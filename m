From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] netlink: move binop postprocess to extra function
Date: Sun, 24 Jan 2016 18:58:25 +0100
Message-ID: <1453658307-7177-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57951 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbcAXSGH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Jan 2016 13:06:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just move the payload trim part to a separate function.
Next patch will add a second call site to deal with map ops
that use a lookup based on a binop result.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 64 ++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 28 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3f01781..6876f02 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1170,6 +1170,41 @@ static struct expr *binop_tree_to_list(struct expr *list, struct expr *expr)
 	return list;
 }
 
+static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
+{
+	struct expr *binop = expr->left, *value = expr->right;
+
+	struct expr *payload = binop->left;
+	struct expr *mask = binop->right;
+	unsigned int shift;
+
+	if (payload_expr_trim(payload, mask, &ctx->pctx, &shift)) {
+		/* mask is implicit, binop needs to be removed.
+		 *
+		 * Fix all values of the expression according to the mask
+		 * and then process the payload instruction using the real
+		 * sizes and offsets we're interested in.
+		 *
+		 * Finally, convert the expression to 1) by replacing
+		 * the binop with the binop payload expr.
+		 */
+		if (value->ops->type == EXPR_VALUE) {
+			assert(value->len >= expr->left->right->len);
+			mpz_rshift_ui(value->value, shift);
+			value->len = payload->len;
+		}
+
+		payload_match_postprocess(ctx, expr, payload);
+
+		assert(expr->left->ops->type == EXPR_BINOP);
+
+		assert(binop->left == payload);
+		expr->left = expr_get(payload);
+		expr_free(binop);
+	}
+}
+
+
 static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 {
 	struct expr *binop = expr->left, *value = expr->right;
@@ -1202,10 +1237,6 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 	} else if (binop->op == OP_AND &&
 		   binop->left->ops->type == EXPR_PAYLOAD &&
 		   binop->right->ops->type == EXPR_VALUE) {
-		struct expr *payload = binop->left;
-		struct expr *mask = binop->right;
-		unsigned int shift;
-
 		/*
 		 * This *might* be a payload match testing header fields that
 		 * have non byte divisible offsets and/or bit lengths.
@@ -1229,30 +1260,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 		 * payload_expr_trim will figure out if the mask is needed to match
 		 * templates.
 		 */
-		if (payload_expr_trim(payload, mask, &ctx->pctx, &shift)) {
-			/* mask is implicit, binop needs to be removed.
-			 *
-			 * Fix all values of the expression according to the mask
-			 * and then process the payload instruction using the real
-			 * sizes and offsets we're interested in.
-			 *
-			 * Finally, convert the expression to 1) by replacing
-			 * the binop with the binop payload expr.
-			 */
-			if (value->ops->type == EXPR_VALUE) {
-				assert(value->len >= expr->left->right->len);
-				mpz_rshift_ui(value->value, shift);
-				value->len = payload->len;
-			}
-
-			payload_match_postprocess(ctx, expr, payload);
-
-			assert(expr->left->ops->type == EXPR_BINOP);
-
-			assert(binop->left == payload);
-			expr->left = expr_get(payload);
-			expr_free(binop);
-		}
+		binop_postprocess(ctx, expr);
 	}
 }
 
-- 
2.4.10

