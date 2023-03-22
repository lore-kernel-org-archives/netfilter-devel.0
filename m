Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0373C74A5B
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Mar 2023 21:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCVVxS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Mar 2023 17:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjCVVxR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2023 17:53:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D24334005
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2023 14:53:09 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 2/8] evaluate: support shifts larger than the width of the left operand
Date:   Wed, 22 Mar 2023 22:52:57 +0100
Message-Id: <20230322215303.239763-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230322215303.239763-1-pablo@netfilter.org>
References: <20230322215303.239763-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If we want to left-shift a value of narrower type and assign the result
to a variable of a wider type, we are constrained to only shifting up to
the width of the narrower type.  Thus:

  add rule t c meta mark set ip dscp << 2

works, but:

  add rule t c meta mark set ip dscp << 8

does not, even though the lvalue is large enough to accommodate the
result.

Upgrade the maximum length based on the statement datatype length, which
provided via context, if it is larger than lvalue.

Update netlink_delinearize.c to handle the case where the length of a
shift expression does not match that of its left-hand operand.

Based on patch from Jeremy Sowden.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c            | 27 +++++++++++++++++++--------
 src/netlink_delinearize.c |  4 ++--
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 21d360493ceb..33161f1e2012 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1289,14 +1289,19 @@ static int constant_binop_simplify(struct eval_ctx *ctx, struct expr **expr)
 static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *op = *expr, *left = op->left, *right = op->right;
+	unsigned int shift = mpz_get_uint32(right->value);
+	unsigned int max_shift_len;
 
-	if (mpz_get_uint32(right->value) >= left->len)
+	if (ctx->ectx.len > left->len)
+		max_shift_len = ctx->ectx.len;
+	else
+		max_shift_len = left->len;
+
+	if (shift >= max_shift_len)
 		return expr_binary_error(ctx->msgs, right, left,
-					 "%s shift of %u bits is undefined "
-					 "for type of %u bits width",
+					 "%s shift of %u bits is undefined for type of %u bits width",
 					 op->op == OP_LSHIFT ? "Left" : "Right",
-					 mpz_get_uint32(right->value),
-					 left->len);
+					 shift, max_shift_len);
 
 	/* Both sides need to be in host byte order */
 	if (byteorder_conversion(ctx, &op->left, BYTEORDER_HOST_ENDIAN) < 0)
@@ -1306,7 +1311,7 @@ static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 
 	op->byteorder = BYTEORDER_HOST_ENDIAN;
-	op->len       = left->len;
+	op->len	      = max_shift_len;
 
 	if (expr_is_constant(left))
 		return constant_binop_simplify(ctx, expr);
@@ -1339,14 +1344,20 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *op = *expr, *left, *right;
 	const char *sym = expr_op_symbols[op->op];
+	unsigned int max_shift_len = ctx->ectx.len;
 
 	if (expr_evaluate(ctx, &op->left) < 0)
 		return -1;
 	left = op->left;
 
-	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT)
+	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT) {
+		if (left->len > max_shift_len)
+			max_shift_len = left->len;
+
 		__expr_set_context(&ctx->ectx, &integer_type,
-				   left->byteorder, ctx->ectx.len, 0);
+				   left->byteorder, max_shift_len, 0);
+	}
+
 	if (expr_evaluate(ctx, &op->right) < 0)
 		return -1;
 	right = op->right;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index c1b4c1148d33..4dc28ed8e651 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -489,7 +489,7 @@ static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
 		mpz_ior(m, m, o);
 	}
 
-	if (left->len > 0 && mpz_scan0(m, 0) == left->len) {
+	if (left->len > 0 && mpz_scan0(m, 0) >= left->len) {
 		/* mask encompasses the entire value */
 		expr_free(mask);
 	} else {
@@ -537,7 +537,7 @@ static struct expr *netlink_parse_bitwise_shift(struct netlink_parse_ctx *ctx,
 	right->byteorder = BYTEORDER_HOST_ENDIAN;
 
 	expr = binop_expr_alloc(loc, op, left, right);
-	expr->len = left->len;
+	expr->len = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_LEN) * BITS_PER_BYTE;
 
 	return expr;
 }
-- 
2.30.2

