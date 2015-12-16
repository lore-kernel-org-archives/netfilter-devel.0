From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink_delinearize: add previous statement to rule_pp_ctx
Date: Wed, 16 Dec 2015 23:38:55 +0100
Message-ID: <1450305535-18225-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, pablombg@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34372 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbbLPWj0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Dec 2015 17:39:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A65DDA820D
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Dec 2015 23:39:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 94DF2DA85D
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Dec 2015 23:39:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6BB8DDA7FF
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Dec 2015 23:39:07 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

564b0e7c13f9 ("netlink_delinearize: postprocess expression before range
merge") crashes nft when the previous statement is removed via
payload_dependency_kill() as this pointer is not valid anymore.

Move the pointer to the previous statement to rule_pp_ctx and invalid it
when required.

Reported-by: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8cbabc3..f68fca0 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -944,6 +944,7 @@ struct rule_pp_ctx {
 	enum proto_bases	pbase;
 	struct stmt		*pdep;
 	struct stmt		*stmt;
+	struct stmt		*prev;
 };
 
 /*
@@ -957,6 +958,8 @@ static void payload_dependency_kill(struct rule_pp_ctx *ctx, struct expr *expr)
 		list_del(&ctx->pdep->list);
 		stmt_free(ctx->pdep);
 		ctx->pbase = PROTO_BASE_INVALID;
+		if (ctx->pdep == ctx->prev)
+			ctx->prev = NULL;
 		ctx->pdep = NULL;
 	}
 }
@@ -1529,46 +1532,47 @@ static bool expr_may_merge_range(struct expr *expr, struct expr *prev,
 	return false;
 }
 
-static void expr_postprocess_range(struct rule_pp_ctx *ctx, struct stmt *prev,
-				   enum ops op)
+static void expr_postprocess_range(struct rule_pp_ctx *ctx, enum ops op)
 {
 	struct stmt *nstmt, *stmt = ctx->stmt;
 	struct expr *nexpr, *rel;
 
-	nexpr = range_expr_alloc(&prev->location, expr_clone(prev->expr->right),
+	nexpr = range_expr_alloc(&ctx->prev->location,
+				 expr_clone(ctx->prev->expr->right),
 				 expr_clone(stmt->expr->right));
 	expr_set_type(nexpr, stmt->expr->right->dtype,
 		      stmt->expr->right->byteorder);
 
-	rel = relational_expr_alloc(&prev->location, op,
+	rel = relational_expr_alloc(&ctx->prev->location, op,
 				    expr_clone(stmt->expr->left), nexpr);
 
 	nstmt = expr_stmt_alloc(&stmt->location, rel);
 	list_add_tail(&nstmt->list, &stmt->list);
 
-	list_del(&prev->list);
-	stmt_free(prev);
+	list_del(&ctx->prev->list);
+	stmt_free(ctx->prev);
 
 	list_del(&stmt->list);
 	stmt_free(stmt);
 	ctx->stmt = nstmt;
 }
 
-static void stmt_expr_postprocess(struct rule_pp_ctx *ctx, struct stmt *prev)
+static void stmt_expr_postprocess(struct rule_pp_ctx *ctx)
 {
 	enum ops op;
 
 	expr_postprocess(ctx, &ctx->stmt->expr);
 
-	if (prev && ctx->stmt && ctx->stmt->ops->type == prev->ops->type &&
-	    expr_may_merge_range(ctx->stmt->expr, prev->expr, &op))
-		expr_postprocess_range(ctx, prev, op);
+	if (ctx->prev && ctx->stmt &&
+	    ctx->stmt->ops->type == ctx->prev->ops->type &&
+	    expr_may_merge_range(ctx->stmt->expr, ctx->prev->expr, &op))
+		expr_postprocess_range(ctx, op);
 }
 
 static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule)
 {
 	struct rule_pp_ctx rctx;
-	struct stmt *stmt, *next, *prev = NULL;
+	struct stmt *stmt, *next;
 
 	memset(&rctx, 0, sizeof(rctx));
 	proto_ctx_init(&rctx.pctx, rule->handle.family);
@@ -1578,7 +1582,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 
 		switch (stmt->ops->type) {
 		case STMT_EXPRESSION:
-			stmt_expr_postprocess(&rctx, prev);
+			stmt_expr_postprocess(&rctx);
 			break;
 		case STMT_PAYLOAD:
 			expr_postprocess(&rctx, &stmt->payload.expr);
@@ -1620,7 +1624,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		default:
 			break;
 		}
-		prev = rctx.stmt;
+		rctx.prev = rctx.stmt;
 	}
 }
 
-- 
2.1.4

