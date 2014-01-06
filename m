From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 09/12] netlink_delinearize: remove implied meta expressions
Date: Mon,  6 Jan 2014 17:27:24 +0000
Message-ID: <1389029247-27697-10-git-send-email-kaber@trash.net>
References: <1389029247-27697-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55579 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886AbaAFR1l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:27:41 -0500
In-Reply-To: <1389029247-27697-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h      |  1 +
 src/netlink_delinearize.c | 29 +++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 59b27c0..a9aa328 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -242,6 +242,7 @@ struct expr {
 		struct {
 			/* EXPR_META */
 			enum nft_meta_keys	key;
+			enum proto_bases	base;
 		} meta;
 		struct {
 			/* EXPR_CT */
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e9b0514..e010452 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -546,10 +546,19 @@ static void payload_dependency_kill(struct rule_pp_ctx *ctx, struct expr *expr)
 	    ctx->pdep != NULL) {
 		list_del(&ctx->pdep->list);
 		stmt_free(ctx->pdep);
+		ctx->pbase = PROTO_BASE_INVALID;
 		ctx->pdep = NULL;
 	}
 }
 
+static void payload_dependency_store(struct rule_pp_ctx *ctx,
+				     struct stmt *stmt,
+				     enum proto_bases base)
+{
+	ctx->pbase = base;
+	ctx->pdep  = stmt;
+}
+
 static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 				      struct stmt *stmt, struct expr *expr)
 {
@@ -580,10 +589,10 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 			 * payload expression.
 			 */
 			if (ctx->pbase == PROTO_BASE_INVALID &&
-			    left->flags & EXPR_F_PROTOCOL) {
-				ctx->pbase = left->payload.base;
-				ctx->pdep  = nstmt;
-			} else
+			    left->flags & EXPR_F_PROTOCOL)
+				payload_dependency_store(ctx, nstmt,
+							 left->payload.base);
+			else
 				payload_dependency_kill(ctx, nexpr->left);
 		}
 		list_del(&stmt->list);
@@ -593,16 +602,24 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		payload_expr_complete(left, &ctx->pctx);
 		expr_set_type(expr->right, expr->left->dtype,
 			      expr->left->byteorder);
+		payload_dependency_kill(ctx, expr->left);
 		break;
 	}
 }
 
-static void meta_match_postprocess(struct proto_ctx *ctx,
+static void meta_match_postprocess(struct rule_pp_ctx *ctx,
+				   struct stmt *stmt,
 				   const struct expr *expr)
 {
+	struct expr *left = expr->left;
+
 	switch (expr->op) {
 	case OP_EQ:
 		expr->left->ops->pctx_update(ctx, expr);
+
+		if (ctx->pbase == PROTO_BASE_INVALID &&
+		    left->flags & EXPR_F_PROTOCOL)
+			payload_dependency_store(ctx, stmt, left->meta.base);
 		break;
 	default:
 		break;
@@ -723,7 +740,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 
 		switch (expr->left->ops->type) {
 		case EXPR_META:
-			meta_match_postprocess(&ctx->pctx, expr);
+			meta_match_postprocess(ctx, stmt, expr);
 			break;
 		case EXPR_BINOP:
 			relational_binop_postprocess(expr);
-- 
1.8.4.2

