From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 1/7] Interpret OP_NEQ against a set as OP_LOOKUP
Date: Thu, 24 Nov 2016 15:16:20 +0100
Message-ID: <92cdd42afb329e58b41c0c33f2a68786afd8d7e5.1479994191.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:59214 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756885AbcKXObb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 09:31:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that the support for inverted matching is in the kernel and in libnftnl, add
it to nftables too.

This fixes bug #888

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
This patch is heavily based off those of Yuxuan Shui from 2014
(https://marc.info/?l=netfilter-devel&m=140682484411296)

 src/evaluate.c            | 14 ++++++++++++++
 src/netlink_delinearize.c | 10 ++++++++++
 src/netlink_linearize.c   | 14 +++++++++-----
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8b113c8..bb46615 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1541,6 +1541,20 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 			if (byteorder_conversion(ctx, &rel->right, left->byteorder) < 0)
 				return -1;
 			break;
+		case EXPR_SET:
+			assert(rel->op == OP_NEQ);
+			right = rel->right =
+				implicit_set_declaration(ctx, "__set%d",
+							 left->dtype, left->len,
+							 right);
+			/* fall through */
+		case EXPR_SET_REF:
+			assert(rel->op == OP_NEQ);
+			/* Data for range lookups needs to be in big endian order */
+			if (right->set->flags & SET_F_INTERVAL &&
+			    byteorder_conversion(ctx, &rel->left, BYTEORDER_BIG_ENDIAN) < 0)
+				return -1;
+			break;
 		default:
 			BUG("invalid expression type %s\n", right->ops->name);
 		}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 0ebe368..cb0f6ac 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -292,6 +292,7 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	const char *name;
 	struct expr *expr, *left, *right;
 	struct set *set;
+	uint32_t flag;
 
 	name = nftnl_expr_get_str(nle, NFTNL_EXPR_LOOKUP_SET);
 	set  = set_lookup(ctx->table, name);
@@ -323,6 +324,12 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 		expr = relational_expr_alloc(loc, OP_LOOKUP, left, right);
 	}
 
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOOKUP_FLAGS)) {
+		flag = nftnl_expr_get_u32(nle, NFTNL_EXPR_LOOKUP_FLAGS);
+		if (flag & NFT_LOOKUP_F_INV)
+			expr->op = OP_NEQ;
+	}
+
 	ctx->stmt = expr_stmt_alloc(loc, expr);
 }
 
@@ -1316,6 +1323,9 @@ static void ct_meta_common_postprocess(const struct expr *expr)
 	struct expr *right = expr->right;
 
 	switch (expr->op) {
+	case OP_NEQ:
+		if (right->ops->type != EXPR_SET && right->ops->type != EXPR_SET_REF)
+			break;
 	case OP_LOOKUP:
 		expr_set_type(right, left->dtype, left->byteorder);
 		if (right->dtype == &integer_type)
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 2945392..6bc0bee 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -278,6 +278,8 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 			   expr->right->set->handle.set);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_LOOKUP_SET_ID,
 			   expr->right->set->handle.set_id);
+	if (expr->op == OP_NEQ)
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_LOOKUP_FLAGS, NFT_LOOKUP_F_INV);
 
 	release_register(ctx, expr->left);
 	nftnl_rule_add_expr(ctx->nlr, nle);
@@ -346,13 +348,14 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 
 	assert(dreg == NFT_REG_VERDICT);
 
-	if (expr->right->ops->type == EXPR_RANGE)
-		return netlink_gen_range(ctx, expr, dreg);
-
-	sreg = get_register(ctx, expr->left);
-
 	switch (expr->right->ops->type) {
+	case EXPR_RANGE:
+		return netlink_gen_range(ctx, expr, dreg);
+	case EXPR_SET:
+	case EXPR_SET_REF:
+		return netlink_gen_lookup(ctx, expr, dreg);
 	case EXPR_PREFIX:
+		sreg = get_register(ctx, expr->left);
 		if (expr->left->dtype->type != TYPE_STRING) {
 			len = div_round_up(expr->right->len, BITS_PER_BYTE);
 			netlink_gen_expr(ctx, expr->left, sreg);
@@ -365,6 +368,7 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 		}
 		break;
 	default:
+		sreg = get_register(ctx, expr->left);
 		len = div_round_up(expr->right->len, BITS_PER_BYTE);
 		right = expr->right;
 		netlink_gen_expr(ctx, expr->left, sreg);
-- 
2.11.0.rc2

