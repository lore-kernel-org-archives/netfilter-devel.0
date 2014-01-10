From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink: fix wrong type in attributes
Date: Fri, 10 Jan 2014 13:39:43 +0100
Message-ID: <1389357583-7336-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39604 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbaAJMjz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:39:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix inconsistent attribute types in meta and cmp expressions, use
uint32_t.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c |   12 ++++++------
 src/netlink_linearize.c   |   14 +++++++-------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8f6ee38..ce4f7af 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -103,7 +103,7 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 
 static enum ops netlink_parse_cmp_op(const struct nft_rule_expr *nle)
 {
-	switch (nft_rule_expr_get_u8(nle, NFT_EXPR_CMP_OP)) {
+	switch (nft_rule_expr_get_u32(nle, NFT_EXPR_CMP_OP)) {
 	case NFT_CMP_EQ:
 		return OP_EQ;
 	case NFT_CMP_NEQ:
@@ -132,7 +132,7 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 
 	nld.value = nft_rule_expr_get(nle, NFT_EXPR_CMP_DATA, &nld.len);
 	left = netlink_get_register(ctx, loc,
-			nft_rule_expr_get_u8(nle, NFT_EXPR_CMP_SREG));
+			nft_rule_expr_get_u32(nle, NFT_EXPR_CMP_SREG));
 	if (left == NULL)
 		return netlink_error(ctx, loc,
 				     "Relational expression has no left "
@@ -332,9 +332,9 @@ static void netlink_parse_meta_dreg(struct netlink_parse_ctx *ctx,
 	struct expr *expr;
 
 	expr = meta_expr_alloc(loc,
-			       nft_rule_expr_get_u8(nle, NFT_EXPR_META_KEY));
+			       nft_rule_expr_get_u32(nle, NFT_EXPR_META_KEY));
 	netlink_set_register(ctx,
-			     nft_rule_expr_get_u8(nle, NFT_EXPR_META_DREG),
+			     nft_rule_expr_get_u32(nle, NFT_EXPR_META_DREG),
 			     expr);
 }
 
@@ -346,9 +346,9 @@ static void netlink_parse_meta_sreg(struct netlink_parse_ctx *ctx,
 	struct expr *expr;
 
 	expr = netlink_get_register(ctx, loc,
-			nft_rule_expr_get_u8(nle, NFT_EXPR_META_SREG));
+			nft_rule_expr_get_u32(nle, NFT_EXPR_META_SREG));
 	stmt = meta_stmt_alloc(loc,
-			       nft_rule_expr_get_u8(nle, NFT_EXPR_META_KEY),
+			       nft_rule_expr_get_u32(nle, NFT_EXPR_META_KEY),
 			       expr);
 	expr_set_type(expr, stmt->meta.tmpl->dtype, stmt->meta.tmpl->byteorder);
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 9ae9bb7..332383a 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -210,9 +210,9 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 	}
 
 	nle = alloc_nft_expr("cmp");
-	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_SREG, sreg);
-	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_OP,
-			     netlink_gen_cmp_op(expr->op));
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
+			      netlink_gen_cmp_op(expr->op));
 	netlink_gen_data(right, &nld);
 	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
 	release_register(ctx);
@@ -235,7 +235,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 	netlink_gen_expr(ctx, expr->left, sreg);
 
 	nle = alloc_nft_expr("cmp");
-	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_SREG, sreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
 			      netlink_gen_cmp_op(OP_GTE));
 	netlink_gen_data(range->left, &nld);
@@ -243,7 +243,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 
 	nle = alloc_nft_expr("cmp");
-	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_SREG, sreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
 			      netlink_gen_cmp_op(OP_LTE));
 	netlink_gen_data(range->right, &nld);
@@ -283,8 +283,8 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("cmp");
 	netlink_gen_raw_data(zero, expr->right->byteorder, len, &nld);
-	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_SREG, sreg);
-	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_OP, NFT_CMP_NEQ);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP, NFT_CMP_NEQ);
 	netlink_gen_data(expr->right, &nld);
 	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
 	nft_rule_add_expr(ctx->nlr, nle);
-- 
1.7.10.4

