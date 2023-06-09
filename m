Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F914C7EE2E
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Jun 2023 12:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjFIMBs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Jun 2023 08:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjFIMBq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Jun 2023 08:01:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15A9C1A2
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Jun 2023 05:01:43 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/3] netfilter: nf_tables: fix chain binding transaction logic
Date:   Fri,  9 Jun 2023 14:01:35 +0200
Message-Id: <20230609120137.66297-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In case of error from the preparation phase, the deactivate function
marks this chain as inactive in the next generation, so it is not
reachable anymore from the transaction list. In this case, immediate
destroy skips releasing the chain object because the transaction deals
with this. From the commit phase, deactivate detaches the chain from the
rule, then the immediate destroy function releases now this (unbound)
chain.

While at it, set chain->bound flag for NFT_CHAIN_BINDING only by
checking for the new nft_chain_binding() helper function.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  5 +++
 net/netfilter/nft_immediate.c     | 52 ++++++++++++++++++++++++++++---
 2 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 83db182decc8..66e5c7a8ec21 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1140,6 +1140,11 @@ int nft_chain_validate_dependency(const struct nft_chain *chain,
 int nft_chain_validate_hooks(const struct nft_chain *chain,
                              unsigned int hook_flags);
 
+static inline bool nft_chain_binding(const struct nft_chain *chain)
+{
+	return chain->flags & NFT_CHAIN_BINDING;
+}
+
 static inline bool nft_chain_is_bound(struct nft_chain *chain)
 {
 	return (chain->flags & NFT_CHAIN_BINDING) && chain->bound;
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index c9d2f7c29f53..054243b9b89e 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -76,11 +76,13 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
 		switch (priv->data.verdict.code) {
 		case NFT_JUMP:
 		case NFT_GOTO:
-			if (nft_chain_is_bound(chain)) {
-				err = -EBUSY;
-				goto err1;
+			if (nft_chain_binding(chain)) {
+				if (chain->bound) {
+					err = -EBUSY;
+					goto err1;
+				}
+				chain->bound = true;
 			}
-			chain->bound = true;
 			break;
 		default:
 			break;
@@ -98,6 +100,23 @@ static void nft_immediate_activate(const struct nft_ctx *ctx,
 				   const struct nft_expr *expr)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+	const struct nft_data *data = &priv->data;
+	struct nft_chain *chain;
+
+	if (priv->dreg == NFT_REG_VERDICT) {
+		switch (data->verdict.code) {
+		case NFT_JUMP:
+		case NFT_GOTO:
+			chain = data->verdict.chain;
+			if (!nft_chain_binding(chain))
+				break;
+
+			nft_clear(ctx->net, chain);
+			break;
+		default:
+			break;
+	        }
+	}
 
 	return nft_data_hold(&priv->data, nft_dreg_to_type(priv->dreg));
 }
@@ -107,10 +126,30 @@ static void nft_immediate_deactivate(const struct nft_ctx *ctx,
 				     enum nft_trans_phase phase)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+	const struct nft_data *data = &priv->data;
+	struct nft_chain *chain;
 
 	if (phase == NFT_TRANS_COMMIT)
 		return;
 
+	if (priv->dreg == NFT_REG_VERDICT) {
+		switch (data->verdict.code) {
+		case NFT_JUMP:
+		case NFT_GOTO:
+			chain = data->verdict.chain;
+			if (!nft_chain_binding(chain))
+				break;
+
+			if (phase == NFT_TRANS_PREPARE)
+				nft_deactivate_next(ctx->net, chain);
+			else
+				chain->bound = false;
+			break;
+		default:
+			break;
+	        }
+	}
+
 	return nft_data_release(&priv->data, nft_dreg_to_type(priv->dreg));
 }
 
@@ -131,7 +170,10 @@ static void nft_immediate_destroy(const struct nft_ctx *ctx,
 	case NFT_GOTO:
 		chain = data->verdict.chain;
 
-		if (!nft_chain_is_bound(chain))
+		if (!nft_chain_binding(chain))
+			break;
+
+		if (chain->bound)
 			break;
 
 		chain_ctx = *ctx;
-- 
2.30.2

