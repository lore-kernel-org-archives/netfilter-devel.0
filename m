From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/6 nft] netlink_delinearize: add payload_match_expand()
Date: Tue,  2 Jun 2015 19:03:04 +0200
Message-ID: <1433264587-29705-4-git-send-email-pablo@netfilter.org>
References: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49739 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759614AbbFBQ6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 12:58:01 -0400
In-Reply-To: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function encapsulates the payload expansion logic. This change in required
by the follow up patch to consolidate range printing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c |   69 ++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 32 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 71c32c5..7b4d695 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -829,49 +829,54 @@ static void integer_type_postprocess(struct expr *expr)
 	}
 }
 
-static void payload_match_postprocess(struct rule_pp_ctx *ctx,
-				      struct expr *expr)
+static void payload_match_expand(struct rule_pp_ctx *ctx, struct expr *expr)
 {
 	struct expr *left = expr->left, *right = expr->right, *tmp;
 	struct list_head list = LIST_HEAD_INIT(list);
 	struct stmt *nstmt;
 	struct expr *nexpr;
 
+	payload_expr_expand(&list, left, &ctx->pctx);
+	list_for_each_entry(left, &list, list) {
+		tmp = constant_expr_splice(right, left->len);
+		expr_set_type(tmp, left->dtype, left->byteorder);
+		if (tmp->byteorder == BYTEORDER_HOST_ENDIAN)
+			mpz_switch_byteorder(tmp->value, tmp->len / BITS_PER_BYTE);
+
+		nexpr = relational_expr_alloc(&expr->location, expr->op,
+					      left, tmp);
+		if (expr->op == OP_EQ)
+			left->ops->pctx_update(&ctx->pctx, nexpr);
+
+		nstmt = expr_stmt_alloc(&ctx->stmt->location, nexpr);
+		list_add_tail(&nstmt->list, &ctx->stmt->list);
+
+		/* Remember the first payload protocol expression to
+		 * kill it later on if made redundant by a higher layer
+		 * payload expression.
+		 */
+		if (ctx->pbase == PROTO_BASE_INVALID &&
+		    left->flags & EXPR_F_PROTOCOL)
+			payload_dependency_store(ctx, nstmt,
+						 left->payload.base);
+		else
+			payload_dependency_kill(ctx, nexpr->left);
+	}
+	list_del(&ctx->stmt->list);
+	stmt_free(ctx->stmt);
+	ctx->stmt = NULL;
+}
+
+static void payload_match_postprocess(struct rule_pp_ctx *ctx,
+				      struct expr *expr)
+{
 	switch (expr->op) {
 	case OP_EQ:
 	case OP_NEQ:
-		payload_expr_expand(&list, left, &ctx->pctx);
-		list_for_each_entry(left, &list, list) {
-			tmp = constant_expr_splice(right, left->len);
-			expr_set_type(tmp, left->dtype, left->byteorder);
-			if (tmp->byteorder == BYTEORDER_HOST_ENDIAN)
-				mpz_switch_byteorder(tmp->value, tmp->len / BITS_PER_BYTE);
-
-			nexpr = relational_expr_alloc(&expr->location, expr->op,
-						      left, tmp);
-			if (expr->op == OP_EQ)
-				left->ops->pctx_update(&ctx->pctx, nexpr);
-
-			nstmt = expr_stmt_alloc(&ctx->stmt->location, nexpr);
-			list_add_tail(&nstmt->list, &ctx->stmt->list);
-
-			/* Remember the first payload protocol expression to
-			 * kill it later on if made redundant by a higher layer
-			 * payload expression.
-			 */
-			if (ctx->pbase == PROTO_BASE_INVALID &&
-			    left->flags & EXPR_F_PROTOCOL)
-				payload_dependency_store(ctx, nstmt,
-							 left->payload.base);
-			else
-				payload_dependency_kill(ctx, nexpr->left);
-		}
-		list_del(&ctx->stmt->list);
-		stmt_free(ctx->stmt);
-		ctx->stmt = NULL;
+		payload_match_expand(ctx, expr);
 		break;
 	default:
-		payload_expr_complete(left, &ctx->pctx);
+		payload_expr_complete(expr->left, &ctx->pctx);
 		expr_set_type(expr->right, expr->left->dtype,
 			      expr->left->byteorder);
 		payload_dependency_kill(ctx, expr->left);
-- 
1.7.10.4

