From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 11/17] src: unifiy meta and ct postprocessing
Date: Wed, 28 Jun 2017 12:14:04 +0200
Message-ID: <20170628101410.29134-1-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33440 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751855AbdF1KNx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:13:53 -0400
In-Reply-To: <20170628100659.26976-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>From postprocess point of view meta and ct are logically the same,
except that their storage area overlaps (union type), so if we
extract the relevant fields we can move all of it into a single
helper and support dependency store/kill for both expressions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 50 +++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index c523c8ed4862..d24af46c89a8 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1367,12 +1367,29 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 	}
 }
 
-static void ct_meta_common_postprocess(const struct expr *expr)
+static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
+				       const struct expr *expr,
+				       enum proto_bases base)
 {
 	const struct expr *left = expr->left;
 	struct expr *right = expr->right;
 
 	switch (expr->op) {
+	case OP_EQ:
+		if (expr->right->ops->type == EXPR_RANGE)
+			break;
+
+		expr->left->ops->pctx_update(&ctx->pctx, expr);
+
+		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
+		    left->flags & EXPR_F_PROTOCOL) {
+			payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
+		} else if (ctx->pdctx.pbase < PROTO_BASE_TRANSPORT_HDR) {
+			__payload_dependency_kill(&ctx->pdctx, base);
+			if (left->flags & EXPR_F_PROTOCOL)
+				payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
+		}
+		break;
 	case OP_NEQ:
 		if (right->ops->type != EXPR_SET && right->ops->type != EXPR_SET_REF)
 			break;
@@ -1388,40 +1405,17 @@ static void ct_meta_common_postprocess(const struct expr *expr)
 static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 				   const struct expr *expr)
 {
-	struct expr *left = expr->left;
-
-	switch (expr->op) {
-	case OP_EQ:
-		if (expr->right->ops->type == EXPR_RANGE)
-			break;
-
-		expr->left->ops->pctx_update(&ctx->pctx, expr);
+	const struct expr *left = expr->left;
 
-		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
-		    left->flags & EXPR_F_PROTOCOL)
-			payload_dependency_store(&ctx->pdctx, ctx->stmt,
-						 left->meta.base);
-		break;
-	default:
-		ct_meta_common_postprocess(expr);
-		break;
-	}
+	ct_meta_common_postprocess(ctx, expr, left->meta.base);
 }
 
 static void ct_match_postprocess(struct rule_pp_ctx *ctx,
 				 const struct expr *expr)
 {
-	switch (expr->op) {
-	case OP_EQ:
-		if (expr->right->ops->type == EXPR_RANGE)
-			break;
+	const struct expr *left = expr->left;
 
-		expr->left->ops->pctx_update(&ctx->pctx, expr);
-		break;
-	default:
-		ct_meta_common_postprocess(expr);
-		break;
-	}
+	ct_meta_common_postprocess(ctx, expr, left->ct.base);
 }
 
 /* Convert a bitmask to a prefix length */
-- 
2.13.0

