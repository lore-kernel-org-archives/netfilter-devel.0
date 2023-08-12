Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B219C04A94
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Aug 2023 22:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjHLWJG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjHLWJF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Aug 2023 18:09:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6C791704;
        Sat, 12 Aug 2023 15:09:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,4.19 1/2] netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush
Date:   Sun, 13 Aug 2023 00:09:02 +0200
Message-Id: <20230812220903.56667-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230812220903.56667-1-pablo@netfilter.org>
References: <20230812220903.56667-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Laura Garcia Liebana <nevola@gmail.com>

commit 9b05b6e11d5e93a3a517cadc12b9836e0470c255 upstream.

The deletion of a flowtable after a flush in the same transaction
results in EBUSY. This patch adds an activation and deactivation of
flowtables in order to update the _use_ counter.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nf_tables_api.c     | 16 ++++++++++++++++
 net/netfilter/nft_flow_offload.c  | 19 +++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cc8541cad5d4..3e314808e0ac 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1161,6 +1161,10 @@ struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
 					   const struct nlattr *nla,
 					   u8 genmask);
 
+void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
+				    struct nft_flowtable *flowtable,
+				    enum nft_trans_phase phase);
+
 void nft_register_flowtable_type(struct nf_flowtable_type *type);
 void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 16405e71a678..8e34bc3001ff 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5519,6 +5519,22 @@ struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
 }
 EXPORT_SYMBOL_GPL(nft_flowtable_lookup);
 
+void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
+				    struct nft_flowtable *flowtable,
+				    enum nft_trans_phase phase)
+{
+	switch (phase) {
+	case NFT_TRANS_PREPARE:
+	case NFT_TRANS_ABORT:
+	case NFT_TRANS_RELEASE:
+		flowtable->use--;
+		/* fall through */
+	default:
+		return;
+	}
+}
+EXPORT_SYMBOL_GPL(nf_tables_deactivate_flowtable);
+
 static struct nft_flowtable *
 nft_flowtable_lookup_byhandle(const struct nft_table *table,
 			      const struct nlattr *nla, u8 genmask)
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 166edea0e452..c78f7bd4c1db 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -175,6 +175,23 @@ static int nft_flow_offload_init(const struct nft_ctx *ctx,
 	return nf_ct_netns_get(ctx->net, ctx->family);
 }
 
+static void nft_flow_offload_deactivate(const struct nft_ctx *ctx,
+					const struct nft_expr *expr,
+					enum nft_trans_phase phase)
+{
+	struct nft_flow_offload *priv = nft_expr_priv(expr);
+
+	nf_tables_deactivate_flowtable(ctx, priv->flowtable, phase);
+}
+
+static void nft_flow_offload_activate(const struct nft_ctx *ctx,
+				      const struct nft_expr *expr)
+{
+	struct nft_flow_offload *priv = nft_expr_priv(expr);
+
+	priv->flowtable->use++;
+}
+
 static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
 				     const struct nft_expr *expr)
 {
@@ -203,6 +220,8 @@ static const struct nft_expr_ops nft_flow_offload_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_flow_offload)),
 	.eval		= nft_flow_offload_eval,
 	.init		= nft_flow_offload_init,
+	.activate	= nft_flow_offload_activate,
+	.deactivate	= nft_flow_offload_deactivate,
 	.destroy	= nft_flow_offload_destroy,
 	.validate	= nft_flow_offload_validate,
 	.dump		= nft_flow_offload_dump,
-- 
2.30.2

