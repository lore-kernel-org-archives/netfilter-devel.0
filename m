From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 09/10] netlink_delinearize: prepare binop_postprocess for exthdr demux
Date: Tue,  1 Mar 2016 16:37:49 +0100
Message-ID: <1456846670-28179-10-git-send-email-fw@strlen.de>
References: <1456846670-28179-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49314 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192AbcCAPiD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:38:03 -0500
In-Reply-To: <1456846670-28179-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

binop_postprocess takes care of removing masks if we're dealing
with payload expressions that have non-byte divisible sizes
or offsets.

Same can happen when matching some extension header fields, i.e.
this also needs to handle exthdr expression, not just payload.

So rename payload to left and move test for left type to
binop_postprocess.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index eec7d0f..30c5f62 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1213,12 +1213,12 @@ static struct expr *binop_tree_to_list(struct expr *list, struct expr *expr)
 static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 {
 	struct expr *binop = expr->left, *value = expr->right;
-
-	struct expr *payload = binop->left;
+	struct expr *left = binop->left;
 	struct expr *mask = binop->right;
 	unsigned int shift;
 
-	if (payload_expr_trim(payload, mask, &ctx->pctx, &shift)) {
+	if ((left->ops->type == EXPR_PAYLOAD &&
+	    payload_expr_trim(left, mask, &ctx->pctx, &shift))) {
 		/* mask is implicit, binop needs to be removed.
 		 *
 		 * Fix all values of the expression according to the mask
@@ -1231,15 +1231,15 @@ static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 		if (value->ops->type == EXPR_VALUE) {
 			assert(value->len >= expr->left->right->len);
 			mpz_rshift_ui(value->value, shift);
-			value->len = payload->len;
+			value->len = left->len;
 		}
 
 		assert(expr->left->ops->type == EXPR_BINOP);
-		assert(binop->left == payload);
-		expr->left = expr_get(payload);
+		assert(binop->left == left);
+		expr->left = expr_get(left);
 		expr_free(binop);
 
-		payload_match_postprocess(ctx, expr, payload);
+		payload_match_postprocess(ctx, expr, left);
 	}
 }
 
@@ -1285,7 +1285,6 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 		expr_free(value);
 		expr_free(binop);
 	} else if (binop->op == OP_AND &&
-		   binop->left->ops->type == EXPR_PAYLOAD &&
 		   binop->right->ops->type == EXPR_VALUE) {
 		/*
 		 * This *might* be a payload match testing header fields that
-- 
2.4.10

