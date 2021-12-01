Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAD1C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349010AbhLAMDw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 07:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbhLAMDc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 07:03:32 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42184C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 04:00:11 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1msOHR-0005Fi-PO; Wed, 01 Dec 2021 13:00:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] netlink_delinearize: rename misleading variable
Date:   Wed,  1 Dec 2021 12:59:55 +0100
Message-Id: <20211201115956.13252-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211201115956.13252-1-fw@strlen.de>
References: <20211201115956.13252-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

relational_binop_postprocess() is called for EXPR_RELATIONAL,
so "expr->right" is safe to use.

But the RHS can be something other than a value.
This has been extended to handle other types, so rename to 'right'.

No code changes intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 66120d659dc3..1446cfdad2e1 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2313,20 +2313,20 @@ static void map_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 					 struct expr **exprp)
 {
-	struct expr *expr = *exprp, *binop = expr->left, *value = expr->right;
+	struct expr *expr = *exprp, *binop = expr->left, *right = expr->right;
 
 	if (binop->op == OP_AND && (expr->op == OP_NEQ || expr->op == OP_EQ) &&
-	    value->dtype->basetype &&
-	    value->dtype->basetype->type == TYPE_BITMASK) {
-		switch (value->etype) {
+	    right->dtype->basetype &&
+	    right->dtype->basetype->type == TYPE_BITMASK) {
+		switch (right->etype) {
 		case EXPR_VALUE:
-			if (!mpz_cmp_ui(value->value, 0)) {
+			if (!mpz_cmp_ui(right->value, 0)) {
 				/* Flag comparison: data & flags != 0
 				 *
 				 * Split the flags into a list of flag values and convert the
 				 * op to OP_EQ.
 				 */
-				expr_free(value);
+				expr_free(right);
 
 				expr->left  = expr_get(binop->left);
 				expr->right = binop_tree_to_list(NULL, binop->right);
@@ -2342,8 +2342,8 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 				}
 				expr_free(binop);
 			} else if (binop->right->etype == EXPR_VALUE &&
-				   value->etype == EXPR_VALUE &&
-				   !mpz_cmp(value->value, binop->right->value)) {
+				   right->etype == EXPR_VALUE &&
+				   !mpz_cmp(right->value, binop->right->value)) {
 				/* Skip flag / flag representation for:
 				 * data & flag == flag
 				 * data & flag != flag
@@ -2353,7 +2353,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 				*exprp = flagcmp_expr_alloc(&expr->location, expr->op,
 							    expr_get(binop->left),
 							    binop_tree_to_list(NULL, binop->right),
-							    expr_get(value));
+							    expr_get(right));
 				expr_free(expr);
 			}
 			break;
@@ -2361,7 +2361,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 			*exprp = flagcmp_expr_alloc(&expr->location, expr->op,
 						    expr_get(binop->left),
 						    binop_tree_to_list(NULL, binop->right),
-						    binop_tree_to_list(NULL, value));
+						    binop_tree_to_list(NULL, right));
 			expr_free(expr);
 			break;
 		default:
@@ -2372,9 +2372,9 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 		   expr_mask_is_prefix(binop->right)) {
 		expr->left = expr_get(binop->left);
 		expr->right = prefix_expr_alloc(&expr->location,
-						expr_get(value),
+						expr_get(right),
 						expr_mask_to_prefix(binop->right));
-		expr_free(value);
+		expr_free(right);
 		expr_free(binop);
 	} else if (binop->op == OP_AND &&
 		   binop->right->etype == EXPR_VALUE) {
-- 
2.32.0

