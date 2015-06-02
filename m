From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/6 nft] netlink_delinearize: keep pointer to current statement from rule_pp_ctx
Date: Tue,  2 Jun 2015 19:03:03 +0200
Message-ID: <1433264587-29705-3-git-send-email-pablo@netfilter.org>
References: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49735 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759603AbbFBQ6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 12:58:01 -0400
In-Reply-To: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is required by the range postprocess routine that comes in follow up
patches.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c |   71 +++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 26a8c85..71c32c5 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -780,6 +780,7 @@ struct rule_pp_ctx {
 	struct proto_ctx	pctx;
 	enum proto_bases	pbase;
 	struct stmt		*pdep;
+	struct stmt		*stmt;
 };
 
 /*
@@ -829,7 +830,7 @@ static void integer_type_postprocess(struct expr *expr)
 }
 
 static void payload_match_postprocess(struct rule_pp_ctx *ctx,
-				      struct stmt *stmt, struct expr *expr)
+				      struct expr *expr)
 {
 	struct expr *left = expr->left, *right = expr->right, *tmp;
 	struct list_head list = LIST_HEAD_INIT(list);
@@ -851,8 +852,8 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 			if (expr->op == OP_EQ)
 				left->ops->pctx_update(&ctx->pctx, nexpr);
 
-			nstmt = expr_stmt_alloc(&stmt->location, nexpr);
-			list_add_tail(&nstmt->list, &stmt->list);
+			nstmt = expr_stmt_alloc(&ctx->stmt->location, nexpr);
+			list_add_tail(&nstmt->list, &ctx->stmt->list);
 
 			/* Remember the first payload protocol expression to
 			 * kill it later on if made redundant by a higher layer
@@ -865,8 +866,9 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 			else
 				payload_dependency_kill(ctx, nexpr->left);
 		}
-		list_del(&stmt->list);
-		stmt_free(stmt);
+		list_del(&ctx->stmt->list);
+		stmt_free(ctx->stmt);
+		ctx->stmt = NULL;
 		break;
 	default:
 		payload_expr_complete(left, &ctx->pctx);
@@ -878,7 +880,6 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 }
 
 static void meta_match_postprocess(struct rule_pp_ctx *ctx,
-				   struct stmt *stmt,
 				   const struct expr *expr)
 {
 	struct expr *left = expr->left;
@@ -889,7 +890,8 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 
 		if (ctx->pbase == PROTO_BASE_INVALID &&
 		    left->flags & EXPR_F_PROTOCOL)
-			payload_dependency_store(ctx, stmt, left->meta.base);
+			payload_dependency_store(ctx, ctx->stmt,
+						 left->meta.base);
 		break;
 	case OP_LOOKUP:
 		expr_set_type(expr->right, expr->left->dtype,
@@ -973,8 +975,7 @@ static void relational_binop_postprocess(struct expr *expr)
 	}
 }
 
-static void expr_postprocess(struct rule_pp_ctx *ctx,
-			     struct stmt *stmt, struct expr **exprp)
+static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp, *i;
 
@@ -982,29 +983,29 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 
 	switch (expr->ops->type) {
 	case EXPR_MAP:
-		expr_postprocess(ctx, stmt, &expr->map);
-		expr_postprocess(ctx, stmt, &expr->mappings);
+		expr_postprocess(ctx, &expr->map);
+		expr_postprocess(ctx, &expr->mappings);
 		break;
 	case EXPR_MAPPING:
-		expr_postprocess(ctx, stmt, &expr->left);
-		expr_postprocess(ctx, stmt, &expr->right);
+		expr_postprocess(ctx, &expr->left);
+		expr_postprocess(ctx, &expr->right);
 		break;
 	case EXPR_SET:
 		list_for_each_entry(i, &expr->expressions, list)
-			expr_postprocess(ctx, stmt, &i);
+			expr_postprocess(ctx, &i);
 		break;
 	case EXPR_UNARY:
-		expr_postprocess(ctx, stmt, &expr->arg);
+		expr_postprocess(ctx, &expr->arg);
 		expr_set_type(expr->arg, expr->arg->dtype, !expr->arg->byteorder);
 
 		*exprp = expr_get(expr->arg);
 		expr_free(expr);
 		break;
 	case EXPR_BINOP:
-		expr_postprocess(ctx, stmt, &expr->left);
+		expr_postprocess(ctx, &expr->left);
 		expr_set_type(expr->right, expr->left->dtype,
 			      expr->left->byteorder);
-		expr_postprocess(ctx, stmt, &expr->right);
+		expr_postprocess(ctx, &expr->right);
 
 		expr_set_type(expr, expr->left->dtype,
 			      expr->left->byteorder);
@@ -1012,19 +1013,19 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 	case EXPR_RELATIONAL:
 		switch (expr->left->ops->type) {
 		case EXPR_PAYLOAD:
-			payload_match_postprocess(ctx, stmt, expr);
+			payload_match_postprocess(ctx, expr);
 			return;
 		default:
-			expr_postprocess(ctx, stmt, &expr->left);
+			expr_postprocess(ctx, &expr->left);
 			break;
 		}
 
 		expr_set_type(expr->right, expr->left->dtype, expr->left->byteorder);
-		expr_postprocess(ctx, stmt, &expr->right);
+		expr_postprocess(ctx, &expr->right);
 
 		switch (expr->left->ops->type) {
 		case EXPR_META:
-			meta_match_postprocess(ctx, stmt, expr);
+			meta_match_postprocess(ctx, expr);
 			break;
 		case EXPR_BINOP:
 			relational_binop_postprocess(expr);
@@ -1065,11 +1066,11 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 
 		break;
 	case EXPR_RANGE:
-		expr_postprocess(ctx, stmt, &expr->left);
-		expr_postprocess(ctx, stmt, &expr->right);
+		expr_postprocess(ctx, &expr->left);
+		expr_postprocess(ctx, &expr->right);
 		break;
 	case EXPR_SET_ELEM:
-		expr_postprocess(ctx, stmt, &expr->key);
+		expr_postprocess(ctx, &expr->key);
 		break;
 	case EXPR_SET_REF:
 	case EXPR_EXTHDR:
@@ -1082,9 +1083,10 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 	}
 }
 
-static void stmt_reject_postprocess(struct rule_pp_ctx *rctx, struct stmt *stmt)
+static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 {
 	const struct proto_desc *desc, *base;
+	struct stmt *stmt = rctx->stmt;
 	int protocol;
 
 	switch (rctx->pctx.family) {
@@ -1149,34 +1151,35 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 	proto_ctx_init(&rctx.pctx, rule->handle.family);
 
 	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
+		rctx.stmt = stmt;
+
 		switch (stmt->ops->type) {
 		case STMT_EXPRESSION:
-			expr_postprocess(&rctx, stmt, &stmt->expr);
+			expr_postprocess(&rctx, &stmt->expr);
 			break;
 		case STMT_META:
 			if (stmt->meta.expr != NULL)
-				expr_postprocess(&rctx, stmt, &stmt->meta.expr);
+				expr_postprocess(&rctx, &stmt->meta.expr);
 			break;
 		case STMT_CT:
 			if (stmt->ct.expr != NULL)
-				expr_postprocess(&rctx, stmt, &stmt->ct.expr);
+				expr_postprocess(&rctx, &stmt->ct.expr);
 			break;
 		case STMT_NAT:
 			if (stmt->nat.addr != NULL)
-				expr_postprocess(&rctx, stmt, &stmt->nat.addr);
+				expr_postprocess(&rctx, &stmt->nat.addr);
 			if (stmt->nat.proto != NULL)
-				expr_postprocess(&rctx, stmt, &stmt->nat.proto);
+				expr_postprocess(&rctx, &stmt->nat.proto);
 			break;
 		case STMT_REDIR:
 			if (stmt->redir.proto != NULL)
-				expr_postprocess(&rctx, stmt,
-						 &stmt->redir.proto);
+				expr_postprocess(&rctx, &stmt->redir.proto);
 			break;
 		case STMT_REJECT:
-			stmt_reject_postprocess(&rctx, stmt);
+			stmt_reject_postprocess(&rctx);
 			break;
 		case STMT_SET:
-			expr_postprocess(&rctx, stmt, &stmt->set.key);
+			expr_postprocess(&rctx, &stmt->set.key);
 			break;
 		default:
 			break;
-- 
1.7.10.4

