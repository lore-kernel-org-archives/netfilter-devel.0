From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/6 nft] netlink_delinearize: consolidate range printing
Date: Tue,  2 Jun 2015 19:03:05 +0200
Message-ID: <1433264587-29705-5-git-send-email-pablo@netfilter.org>
References: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49741 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759616AbbFBQ6C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 12:58:02 -0400
In-Reply-To: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a routine to the postprocess stage to check if the previous
expression statement and the current actually represent a range, so we can
provide a more compact listing, eg.

 # nft -nn list table test
 table ip test {
        chain test {
                tcp dport 22
                tcp dport 22-23
                tcp dport != 22-23
                ct mark != 0x00000016-0x00000017
                ct mark 0x00000016-0x00000017
                mark 0x00000016-0x00000017
                mark != 0x00000016-0x00000017
        }
 }

To do so, the context state stores a pointer to the current statement. This
pointer needs to be invalidated in case the current statement is replaced.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c |   82 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 4 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7b4d695..b1ce911 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -873,8 +873,11 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 	switch (expr->op) {
 	case OP_EQ:
 	case OP_NEQ:
-		payload_match_expand(ctx, expr);
-		break;
+		if (expr->right->ops->type == EXPR_VALUE) {
+			payload_match_expand(ctx, expr);
+			break;
+		}
+		/* Fall through */
 	default:
 		payload_expr_complete(expr->left, &ctx->pctx);
 		expr_set_type(expr->right, expr->left->dtype,
@@ -1147,10 +1150,80 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 	}
 }
 
+static bool expr_may_merge_range(struct expr *expr, struct expr *prev,
+				 enum ops *op)
+{
+	struct expr *left, *prev_left;
+
+	if (prev->ops->type == EXPR_RELATIONAL &&
+	    expr->ops->type == EXPR_RELATIONAL) {
+		/* ct and meta needs an unary to swap byteorder, in this case
+		 * we have to explore the inner branch in this tree.
+		 */
+		if (expr->left->ops->type == EXPR_UNARY)
+			left = expr->left->arg;
+		else
+			left = expr->left;
+
+		if (prev->left->ops->type == EXPR_UNARY)
+			prev_left = prev->left->arg;
+		else
+			prev_left = prev->left;
+
+		if (left->ops->type == prev_left->ops->type) {
+			if (expr->op == OP_LTE && prev->op == OP_GTE) {
+				*op = OP_EQ;
+				return true;
+			} else if (expr->op == OP_GT && prev->op == OP_LT) {
+				*op = OP_NEQ;
+				return true;
+			}
+		}
+	}
+
+	return false;
+}
+
+static void expr_postprocess_range(struct rule_pp_ctx *ctx, struct stmt *prev,
+				   enum ops op)
+{
+	struct stmt *nstmt, *stmt = ctx->stmt;
+	struct expr *nexpr, *rel;
+
+	nexpr = range_expr_alloc(&prev->location, expr_clone(prev->expr->right),
+				 expr_clone(stmt->expr->right));
+	expr_set_type(nexpr, stmt->expr->right->dtype,
+		      stmt->expr->right->byteorder);
+
+	rel = relational_expr_alloc(&prev->location, op,
+				    expr_clone(stmt->expr->left), nexpr);
+
+	nstmt = expr_stmt_alloc(&stmt->location, rel);
+	list_add_tail(&nstmt->list, &stmt->list);
+
+	list_del(&prev->list);
+	stmt_free(prev);
+
+	list_del(&stmt->list);
+	stmt_free(stmt);
+	ctx->stmt = nstmt;
+}
+
+static void stmt_expr_postprocess(struct rule_pp_ctx *ctx, struct stmt *prev)
+{
+	enum ops op;
+
+	if (prev && ctx->stmt->ops->type == prev->ops->type &&
+	    expr_may_merge_range(ctx->stmt->expr, prev->expr, &op))
+		expr_postprocess_range(ctx, prev, op);
+
+	expr_postprocess(ctx, &ctx->stmt->expr);
+}
+
 static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule)
 {
 	struct rule_pp_ctx rctx;
-	struct stmt *stmt, *next;
+	struct stmt *stmt, *next, *prev = NULL;
 
 	memset(&rctx, 0, sizeof(rctx));
 	proto_ctx_init(&rctx.pctx, rule->handle.family);
@@ -1160,7 +1233,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 
 		switch (stmt->ops->type) {
 		case STMT_EXPRESSION:
-			expr_postprocess(&rctx, &stmt->expr);
+			stmt_expr_postprocess(&rctx, prev);
 			break;
 		case STMT_META:
 			if (stmt->meta.expr != NULL)
@@ -1189,6 +1262,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		default:
 			break;
 		}
+		prev = rctx.stmt;
 	}
 }
 
-- 
1.7.10.4

