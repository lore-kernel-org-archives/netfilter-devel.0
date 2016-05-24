From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink_delinerize: don't use meta_match_postprocess for ct pp
Date: Tue, 24 May 2016 14:02:49 +0200
Message-ID: <1464091369-4230-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58046 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954AbcEXMCc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2016 08:02:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

meta_match_postprocess uses meta.base which is only accessible if
left expression has EXPR_META type, so we can't use it to handle ct postprocessing.

To reduce copy-pastry factor the common part into ct_meta_common_postprocess(),
then call that from both meta and ct postprocessing.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index de5d66c..9e26078 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1161,6 +1161,23 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 	}
 }
 
+static void ct_meta_common_postprocess(const struct expr *expr)
+{
+	const struct expr *left = expr->left;
+	struct expr *right = expr->right;
+
+	switch (expr->op) {
+	case OP_LOOKUP:
+		expr_set_type(right, left->dtype, left->byteorder);
+		if (right->dtype == &integer_type)
+			integer_type_postprocess(right);
+		break;
+
+	default:
+		break;
+	}
+}
+
 static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 				   const struct expr *expr)
 {
@@ -1178,13 +1195,8 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 			payload_dependency_store(&ctx->pdctx, ctx->stmt,
 						 left->meta.base);
 		break;
-	case OP_LOOKUP:
-		expr_set_type(expr->right, expr->left->dtype,
-			      expr->left->byteorder);
-		if (expr->right->dtype == &integer_type)
-			integer_type_postprocess(expr->right);
-		break;
 	default:
+		ct_meta_common_postprocess(expr);
 		break;
 	}
 }
@@ -1192,7 +1204,17 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 static void ct_match_postprocess(struct rule_pp_ctx *ctx,
 				 const struct expr *expr)
 {
-	return meta_match_postprocess(ctx, expr);
+	switch (expr->op) {
+	case OP_EQ:
+		if (expr->right->ops->type == EXPR_RANGE)
+			break;
+
+		expr->left->ops->pctx_update(&ctx->pctx, expr);
+		break;
+	default:
+		ct_meta_common_postprocess(expr);
+		break;
+	}
 }
 
 /* Convert a bitmask to a prefix length */
-- 
2.7.3

