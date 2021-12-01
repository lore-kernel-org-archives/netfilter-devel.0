Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E001BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhLAMD6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 07:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348219AbhLAMDg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 07:03:36 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533B6C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 04:00:15 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1msOHV-0005Fs-TH; Wed, 01 Dec 2021 13:00:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] netlink_delinearize: binop: make accesses to expr->left/right conditional
Date:   Wed,  1 Dec 2021 12:59:56 +0100
Message-Id: <20211201115956.13252-4-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211201115956.13252-1-fw@strlen.de>
References: <20211201115956.13252-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function can be called for different expression types, including
some (EXPR_MAP) where expr->left/right alias to different member
variables.

This makes accesses to those members conditional by checking the
expression type ahead of the access.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 50 ++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 1446cfdad2e1..87db2e510593 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2223,8 +2223,8 @@ static void binop_adjust_one(const struct expr *binop, struct expr *value,
 	}
 }
 
-static void __binop_adjust(const struct expr *binop, struct expr *right,
-			   unsigned int shift)
+static void binop_adjust(const struct expr *binop, struct expr *right,
+			 unsigned int shift)
 {
 	struct expr *i;
 
@@ -2243,7 +2243,7 @@ static void __binop_adjust(const struct expr *binop, struct expr *right,
 				binop_adjust_one(binop, i->key->right, shift);
 				break;
 			case EXPR_SET_ELEM:
-				__binop_adjust(binop, i->key->key, shift);
+				binop_adjust(binop, i->key->key, shift);
 				break;
 			default:
 				BUG("unknown expression type %s\n", expr_name(i->key));
@@ -2260,22 +2260,22 @@ static void __binop_adjust(const struct expr *binop, struct expr *right,
 	}
 }
 
-static void binop_adjust(struct expr *expr, unsigned int shift)
+static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr,
+			      struct expr **expr_binop)
 {
-	__binop_adjust(expr->left, expr->right, shift);
-}
-
-static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
-{
-	struct expr *binop = expr->left;
+	struct expr *binop = *expr_binop;
 	struct expr *left = binop->left;
 	struct expr *mask = binop->right;
 	unsigned int shift;
 
+	assert(binop->etype == EXPR_BINOP);
+
 	if ((left->etype == EXPR_PAYLOAD &&
 	    payload_expr_trim(left, mask, &ctx->pctx, &shift)) ||
 	    (left->etype == EXPR_EXTHDR &&
 	     exthdr_find_template(left, mask, &shift))) {
+		struct expr *right = NULL;
+
 		/* mask is implicit, binop needs to be removed.
 		 *
 		 * Fix all values of the expression according to the mask
@@ -2285,16 +2285,28 @@ static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 		 * Finally, convert the expression to 1) by replacing
 		 * the binop with the binop payload/exthdr expression.
 		 */
-		binop_adjust(expr, shift);
+		switch (expr->etype) {
+		case EXPR_BINOP:
+		case EXPR_RELATIONAL:
+			right = expr->right;
+			binop_adjust(binop, right, shift);
+			break;
+		case EXPR_MAP:
+			right = expr->mappings;
+			binop_adjust(binop, right, shift);
+			break;
+		default:
+			break;
+		}
 
-		assert(expr->left->etype == EXPR_BINOP);
 		assert(binop->left == left);
-		expr->left = expr_get(left);
+		*expr_binop = expr_get(left);
 		expr_free(binop);
+
 		if (left->etype == EXPR_PAYLOAD)
 			payload_match_postprocess(ctx, expr, left);
-		else if (left->etype == EXPR_EXTHDR)
-			expr_set_type(expr->right, left->dtype, left->byteorder);
+		else if (left->etype == EXPR_EXTHDR && right)
+			expr_set_type(right, left->dtype, left->byteorder);
 	}
 }
 
@@ -2307,7 +2319,7 @@ static void map_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 
 	if (binop->left->etype == EXPR_PAYLOAD &&
 	    binop->right->etype == EXPR_VALUE)
-		binop_postprocess(ctx, expr);
+		binop_postprocess(ctx, expr, &expr->map);
 }
 
 static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
@@ -2401,7 +2413,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 		 * payload_expr_trim will figure out if the mask is needed to match
 		 * templates.
 		 */
-		binop_postprocess(ctx, expr);
+		binop_postprocess(ctx, expr, &expr->left);
 	}
 }
 
@@ -2777,7 +2789,7 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
 
 	assert(payload->etype == EXPR_PAYLOAD);
 	if (payload_expr_trim(payload, mask, &ctx->pctx, &shift)) {
-		__binop_adjust(binop, mask, shift);
+		binop_adjust(binop, mask, shift);
 		payload_expr_complete(payload, &ctx->pctx);
 		expr_set_type(mask, payload->dtype,
 			      payload->byteorder);
@@ -2872,7 +2884,7 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 		mpz_set(mask->value, bitmask);
 		mpz_clear(bitmask);
 
-		binop_postprocess(ctx, expr);
+		binop_postprocess(ctx, expr, &expr->left);
 		if (!payload_is_known(payload)) {
 			mpz_set(mask->value, tmp);
 			mpz_clear(tmp);
-- 
2.32.0

