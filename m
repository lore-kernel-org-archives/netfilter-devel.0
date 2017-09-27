From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 04/10] src: unifiy meta and ct postprocessing
Date: Wed, 27 Sep 2017 20:16:48 +0200
Message-ID: <20170927181654.3129-5-fw@strlen.de>
References: <20170927181654.3129-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37758 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751555AbdI0SQt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 14:16:49 -0400
In-Reply-To: <20170927181654.3129-1-fw@strlen.de>
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
index 7c61cd0c5bbc..44328879ebb8 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1385,12 +1385,29 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
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
@@ -1406,40 +1423,17 @@ static void ct_meta_common_postprocess(const struct expr *expr)
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
2.13.5

