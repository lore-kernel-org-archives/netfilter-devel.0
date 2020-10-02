Return-Path: <SRS0=cI96=DJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3655C4363D
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 13:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E4F821D92
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 13:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387491AbgJBNcf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Oct 2020 09:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBNcf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Oct 2020 09:32:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00881C0613D0
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2020 06:32:34 -0700 (PDT)
Received: from localhost ([::1]:50854 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kOLAn-0001VP-Hk; Fri, 02 Oct 2020 15:32:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [net-next PATCH 1/2 v2] net: netfilter: Enable fast nft_cmp for inverted matches
Date:   Fri,  2 Oct 2020 15:50:56 +0200
Message-Id: <20201002135056.17328-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001165744.25466-2-phil@nwl.cc>
References: <20201001165744.25466-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a boolean indicating NFT_CMP_NEQ. To include it into the match
decision, it is sufficient to XOR it with the data comparison's result.

While being at it, store the mask that is calculated during expression
init and free the eval routine from having to recalculate it each time.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Forgot to update nft_cmp_fast_dump.
---
 include/net/netfilter/nf_tables_core.h |  2 ++
 net/netfilter/nf_tables_core.c         |  3 +--
 net/netfilter/nft_cmp.c                | 13 +++++++------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 78516de14d316..df2d91c814cb3 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -25,8 +25,10 @@ void nf_tables_core_module_exit(void);
 
 struct nft_cmp_fast_expr {
 	u32			data;
+	u32			mask;
 	enum nft_registers	sreg:8;
 	u8			len;
+	bool			inv;
 };
 
 struct nft_immediate_expr {
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 587897a2498b8..e92feacaf5516 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -51,9 +51,8 @@ static void nft_cmp_fast_eval(const struct nft_expr *expr,
 			      struct nft_regs *regs)
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
-	u32 mask = nft_cmp_fast_mask(priv->len);
 
-	if ((regs->data[priv->sreg] & mask) == priv->data)
+	if (((regs->data[priv->sreg] & priv->mask) == priv->data) ^ priv->inv)
 		return;
 	regs->verdict.code = NFT_BREAK;
 }
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 16f4d84599ac7..bc079d68a5365 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -167,7 +167,6 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 	struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
 	struct nft_data_desc desc;
 	struct nft_data data;
-	u32 mask;
 	int err;
 
 	err = nft_data_init(NULL, &data, sizeof(data), &desc,
@@ -181,10 +180,11 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 		return err;
 
 	desc.len *= BITS_PER_BYTE;
-	mask = nft_cmp_fast_mask(desc.len);
 
-	priv->data = data.data[0] & mask;
+	priv->mask = nft_cmp_fast_mask(desc.len);
+	priv->data = data.data[0] & priv->mask;
 	priv->len  = desc.len;
+	priv->inv  = ntohl(nla_get_be32(tb[NFTA_CMP_OP])) != NFT_CMP_EQ;
 	return 0;
 }
 
@@ -201,7 +201,7 @@ static int nft_cmp_fast_offload(struct nft_offload_ctx *ctx,
 		},
 		.sreg	= priv->sreg,
 		.len	= priv->len / BITS_PER_BYTE,
-		.op	= NFT_CMP_EQ,
+		.op	= priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ,
 	};
 
 	return __nft_cmp_offload(ctx, flow, &cmp);
@@ -210,11 +210,12 @@ static int nft_cmp_fast_offload(struct nft_offload_ctx *ctx,
 static int nft_cmp_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
+	enum nft_cmp_ops op = priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ;
 	struct nft_data data;
 
 	if (nft_dump_register(skb, NFTA_CMP_SREG, priv->sreg))
 		goto nla_put_failure;
-	if (nla_put_be32(skb, NFTA_CMP_OP, htonl(NFT_CMP_EQ)))
+	if (nla_put_be32(skb, NFTA_CMP_OP, htonl(op)))
 		goto nla_put_failure;
 
 	data.data[0] = priv->data;
@@ -272,7 +273,7 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 		goto err1;
 	}
 
-	if (desc.len <= sizeof(u32) && op == NFT_CMP_EQ)
+	if (desc.len <= sizeof(u32) && (op == NFT_CMP_EQ || op == NFT_CMP_NEQ))
 		return &nft_cmp_fast_ops;
 
 	return &nft_cmp_ops;
-- 
2.28.0

