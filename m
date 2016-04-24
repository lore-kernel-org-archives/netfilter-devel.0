From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 3/6] payload: move payload depedency tracking to payload.c
Date: Sun, 24 Apr 2016 22:30:37 +0100
Message-ID: <1461533440-10605-4-git-send-email-kaber@trash.net>
References: <1461533440-10605-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52077 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbcDXVjU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 17:39:20 -0400
In-Reply-To: <1461533440-10605-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/payload.h         | 21 ++++++++++++++
 src/netlink_delinearize.c | 70 ++++++++++++++---------------------------------
 src/payload.c             | 44 +++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 50 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index fae3c67..eb9ff17 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -17,6 +17,27 @@ extern int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 extern int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  struct stmt **res);
 
+/**
+ * struct payload_dep_ctx - payload protocol dependency tracking
+ *
+ * @pbase: protocol base of last dependency match
+ * @pdep: last dependency match
+ * @prev: previous statement
+ */
+struct payload_dep_ctx {
+	enum proto_bases	pbase;
+	struct stmt		*pdep;
+	struct stmt		*prev;
+};
+
+extern void payload_dependency_store(struct payload_dep_ctx *ctx,
+				     struct stmt *stmt,
+				     enum proto_bases base);
+extern void __payload_dependency_kill(struct payload_dep_ctx *ctx,
+				      enum proto_bases base);
+extern void payload_dependency_kill(struct payload_dep_ctx *ctx,
+				    struct expr *expr);
+
 extern bool payload_can_merge(const struct expr *e1, const struct expr *e2);
 extern struct expr *payload_expr_join(const struct expr *e1,
 				      const struct expr *e2);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ee4cf12..59e5f3e 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -999,41 +999,11 @@ static int netlink_parse_expr(struct nftnl_expr *nle, void *arg)
 
 struct rule_pp_ctx {
 	struct proto_ctx	pctx;
-	enum proto_bases	pbase;
-	struct stmt		*pdep;
+	struct payload_dep_ctx	pdctx;
 	struct stmt		*stmt;
-	struct stmt		*prev;
 };
 
-/*
- * Kill a redundant payload dependecy that is implied by a higher layer payload expression.
- */
-static void __payload_dependency_kill(struct rule_pp_ctx *ctx, enum proto_bases base)
-{
-	if (ctx->pbase != PROTO_BASE_INVALID &&
-	    ctx->pbase == base &&
-	    ctx->pdep != NULL) {
-		list_del(&ctx->pdep->list);
-		stmt_free(ctx->pdep);
-		ctx->pbase = PROTO_BASE_INVALID;
-		if (ctx->pdep == ctx->prev)
-			ctx->prev = NULL;
-		ctx->pdep = NULL;
-	}
-}
-
-static void payload_dependency_kill(struct rule_pp_ctx *ctx, const struct expr *expr)
-{
-	__payload_dependency_kill(ctx, expr->payload.base);
-}
-
-static void payload_dependency_store(struct rule_pp_ctx *ctx,
-				     struct stmt *stmt,
-				     enum proto_bases base)
-{
-	ctx->pbase = base + 1;
-	ctx->pdep  = stmt;
-}
+static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp);
 
 static void integer_type_postprocess(struct expr *expr)
 {
@@ -1078,9 +1048,9 @@ static void payload_dependency_save(struct rule_pp_ctx *ctx, unsigned int base,
 	}
 
 	if (stacked_header)
-		payload_dependency_store(ctx, nstmt, base - 1);
+		payload_dependency_store(&ctx->pdctx, nstmt, base - 1);
 	else
-		payload_dependency_store(ctx, nstmt, base);
+		payload_dependency_store(&ctx->pdctx, nstmt, base);
 }
 
 static void payload_match_expand(struct rule_pp_ctx *ctx,
@@ -1118,12 +1088,12 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		 * kill it later on if made redundant by a higher layer
 		 * payload expression.
 		 */
-		if (ctx->pbase == PROTO_BASE_INVALID &&
+		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
 		    expr->op == OP_EQ &&
 		    left->flags & EXPR_F_PROTOCOL) {
 			payload_dependency_save(ctx, base, nstmt, tmp);
 		} else {
-			payload_dependency_kill(ctx, nexpr->left);
+			payload_dependency_kill(&ctx->pdctx, nexpr->left);
 			if (left->flags & EXPR_F_PROTOCOL)
 				payload_dependency_save(ctx, base, nstmt, tmp);
 		}
@@ -1154,7 +1124,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		payload_expr_complete(payload, &ctx->pctx);
 		expr_set_type(expr->right, payload->dtype,
 			      payload->byteorder);
-		payload_dependency_kill(ctx, payload);
+		payload_dependency_kill(&ctx->pdctx, payload);
 		break;
 	}
 }
@@ -1171,9 +1141,9 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 
 		expr->left->ops->pctx_update(&ctx->pctx, expr);
 
-		if (ctx->pbase == PROTO_BASE_INVALID &&
+		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
 		    left->flags & EXPR_F_PROTOCOL)
-			payload_dependency_store(ctx, ctx->stmt,
+			payload_dependency_store(&ctx->pdctx, ctx->stmt,
 						 left->meta.base);
 		break;
 	case OP_LOOKUP:
@@ -1514,7 +1484,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		break;
 	case EXPR_PAYLOAD:
 		payload_expr_complete(expr, &ctx->pctx);
-		payload_dependency_kill(ctx, expr);
+		payload_dependency_kill(&ctx->pdctx, expr);
 		break;
 	case EXPR_VALUE:
 		// FIXME
@@ -1537,7 +1507,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		expr_postprocess(ctx, &expr->key);
 		break;
 	case EXPR_EXTHDR:
-		__payload_dependency_kill(ctx, PROTO_BASE_NETWORK_HDR);
+		__payload_dependency_kill(&ctx->pdctx, PROTO_BASE_NETWORK_HDR);
 		break;
 	case EXPR_SET_REF:
 	case EXPR_META:
@@ -1649,20 +1619,20 @@ static void expr_postprocess_range(struct rule_pp_ctx *ctx, enum ops op)
 	struct stmt *nstmt, *stmt = ctx->stmt;
 	struct expr *nexpr, *rel;
 
-	nexpr = range_expr_alloc(&ctx->prev->location,
-				 expr_clone(ctx->prev->expr->right),
+	nexpr = range_expr_alloc(&ctx->pdctx.prev->location,
+				 expr_clone(ctx->pdctx.prev->expr->right),
 				 expr_clone(stmt->expr->right));
 	expr_set_type(nexpr, stmt->expr->right->dtype,
 		      stmt->expr->right->byteorder);
 
-	rel = relational_expr_alloc(&ctx->prev->location, op,
+	rel = relational_expr_alloc(&ctx->pdctx.prev->location, op,
 				    expr_clone(stmt->expr->left), nexpr);
 
 	nstmt = expr_stmt_alloc(&stmt->location, rel);
 	list_add_tail(&nstmt->list, &stmt->list);
 
-	list_del(&ctx->prev->list);
-	stmt_free(ctx->prev);
+	list_del(&ctx->pdctx.prev->list);
+	stmt_free(ctx->pdctx.prev);
 
 	list_del(&stmt->list);
 	stmt_free(stmt);
@@ -1675,9 +1645,9 @@ static void stmt_expr_postprocess(struct rule_pp_ctx *ctx)
 
 	expr_postprocess(ctx, &ctx->stmt->expr);
 
-	if (ctx->prev && ctx->stmt &&
-	    ctx->stmt->ops->type == ctx->prev->ops->type &&
-	    expr_may_merge_range(ctx->stmt->expr, ctx->prev->expr, &op))
+	if (ctx->pdctx.prev && ctx->stmt &&
+	    ctx->stmt->ops->type == ctx->pdctx.prev->ops->type &&
+	    expr_may_merge_range(ctx->stmt->expr, ctx->pdctx.prev->expr, &op))
 		expr_postprocess_range(ctx, op);
 }
 
@@ -1740,7 +1710,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		default:
 			break;
 		}
-		rctx.prev = rctx.stmt;
+		rctx.pdctx.prev = rctx.stmt;
 	}
 }
 
diff --git a/src/payload.c b/src/payload.c
index 45a2ba2..9dca56b 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -322,6 +322,50 @@ int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 }
 
 /**
+ * payload_dependency_store - store a possibly redundant protocol match
+ *
+ * @ctx: payload dependency context
+ * @stmt: payload match
+ * @base: base of payload match
+ */
+void payload_dependency_store(struct payload_dep_ctx *ctx,
+			      struct stmt *stmt, enum proto_bases base)
+{
+	ctx->pbase = base + 1;
+	ctx->pdep  = stmt;
+}
+
+/**
+ * __payload_dependency_kill - kill a redundant payload depedency
+ *
+ * @ctx: payload dependency context
+ * @expr: higher layer payload expression
+ *
+ * Kill a redundant payload expression if a higher layer payload expression
+ * implies its existance.
+ */
+void __payload_dependency_kill(struct payload_dep_ctx *ctx,
+			       enum proto_bases base)
+{
+	if (ctx->pbase != PROTO_BASE_INVALID &&
+	    ctx->pbase == base &&
+	    ctx->pdep != NULL) {
+		list_del(&ctx->pdep->list);
+		stmt_free(ctx->pdep);
+
+		ctx->pbase = PROTO_BASE_INVALID;
+		if (ctx->pdep == ctx->prev)
+			ctx->prev = NULL;
+		ctx->pdep  = NULL;
+	}
+}
+
+void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr)
+{
+	__payload_dependency_kill(ctx, expr->payload.base);
+}
+
+/**
  * payload_expr_complete - fill in type information of a raw payload expr
  *
  * @expr:	the payload expression
-- 
2.5.5

