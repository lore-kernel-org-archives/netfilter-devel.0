Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B75C7618B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Mar 2023 09:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjCQJ6m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Mar 2023 05:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjCQJ6l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2023 05:58:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40F9FE04A
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2023 02:58:40 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/9] evaluate: support shifts larger than the width of the left operand
Date:   Fri, 17 Mar 2023 10:58:27 +0100
Message-Id: <20230317095833.1225401-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230317095833.1225401-1-pablo@netfilter.org>
References: <20230317095833.1225401-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

If we want to left-shift a value of narrower type and assign the result
to a variable of a wider type, we are constrained to only shifting up to
the width of the narrower type.  Thus:

  add rule t c meta mark set ip dscp << 2

works, but:

  add rule t c meta mark set ip dscp << 8

does not, even though the lvalue is large enough to accommodate the
result.

Evaluation of the left-hand operand of a shift overwrites the `len`
field of the evaluation context when `expr_evaluate_primary` is called.
Instead, preserve the `len` value of the evaluation context for shifts,
and support shifts up to that size, even if they are larger than the
length of the left operand.

Update netlink_delinearize.c to handle the case where the length of a
shift expression does not match that of its left-hand operand.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c            | 23 ++++++++++++++---------
 src/netlink_delinearize.c |  4 ++--
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 21d360493ceb..06aa71561619 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1289,14 +1289,18 @@ static int constant_binop_simplify(struct eval_ctx *ctx, struct expr **expr)
 static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *op = *expr, *left = op->left, *right = op->right;
+	unsigned int shift = mpz_get_uint32(right->value);
+	unsigned int op_len = left->len;
 
-	if (mpz_get_uint32(right->value) >= left->len)
-		return expr_binary_error(ctx->msgs, right, left,
-					 "%s shift of %u bits is undefined "
-					 "for type of %u bits width",
-					 op->op == OP_LSHIFT ? "Left" : "Right",
-					 mpz_get_uint32(right->value),
-					 left->len);
+	if (shift >= op_len) {
+		if (shift >= ctx->ectx.len)
+			return expr_binary_error(ctx->msgs, right, left,
+						 "%s shift of %u bits is undefined for type of %u bits width",
+						 op->op == OP_LSHIFT ? "Left" : "Right",
+						 shift,
+						 op_len);
+		op_len = ctx->ectx.len;
+	}
 
 	/* Both sides need to be in host byte order */
 	if (byteorder_conversion(ctx, &op->left, BYTEORDER_HOST_ENDIAN) < 0)
@@ -1306,7 +1310,7 @@ static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 
 	op->byteorder = BYTEORDER_HOST_ENDIAN;
-	op->len       = left->len;
+	op->len	      = op_len;
 
 	if (expr_is_constant(left))
 		return constant_binop_simplify(ctx, expr);
@@ -1339,6 +1343,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *op = *expr, *left, *right;
 	const char *sym = expr_op_symbols[op->op];
+	unsigned int ectx_len = ctx->ectx.len;
 
 	if (expr_evaluate(ctx, &op->left) < 0)
 		return -1;
@@ -1346,7 +1351,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 
 	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT)
 		__expr_set_context(&ctx->ectx, &integer_type,
-				   left->byteorder, ctx->ectx.len, 0);
+				   left->byteorder, ectx_len, 0);
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

