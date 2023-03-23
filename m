Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D463C74A5B
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 16:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjCWQ7K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjCWQ7H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 12:59:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B87A61AE
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Mar 2023 09:59:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     jeremy@azazel.net, fw@strlen.de
Subject: [PATCH nft,v3 02/12] evaluate: support shifts larger than the width of the left operand
Date:   Thu, 23 Mar 2023 17:58:45 +0100
Message-Id: <20230323165855.559837-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230323165855.559837-1-pablo@netfilter.org>
References: <20230323165855.559837-1-pablo@netfilter.org>
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
is provided via context, if it is larger than expression lvalue.

Update netlink_delinearize.c to handle the case where the length of a
shift expression does not match that of its left-hand operand.

Based on patch from Jeremy Sowden.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h            |  1 +
 src/evaluate.c            | 62 +++++++++++++++++++++++++++------------
 src/netlink_delinearize.c |  4 +--
 3 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index e1efbb819163..ef094c90b1c1 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -766,6 +766,7 @@ struct eval_ctx {
 	struct rule		*rule;
 	struct set		*set;
 	struct stmt		*stmt;
+	uint32_t		stmt_len;
 	struct expr_ctx		ectx;
 	struct proto_ctx	_pctx[2];
 	const struct proto_desc	*inner_desc;
diff --git a/src/evaluate.c b/src/evaluate.c
index 21d360493ceb..b0a7fa761624 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1289,14 +1289,19 @@ static int constant_binop_simplify(struct eval_ctx *ctx, struct expr **expr)
 static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *op = *expr, *left = op->left, *right = op->right;
+	unsigned int shift = mpz_get_uint32(right->value);
+	unsigned int max_shift_len;
 
-	if (mpz_get_uint32(right->value) >= left->len)
+	if (ctx->stmt_len > left->len)
+		max_shift_len = ctx->stmt_len;
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
@@ -1865,6 +1876,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	}
 
 	expr_set_context(&ctx->ectx, NULL, 0);
+	ctx->stmt_len = 0;
 	if (expr_evaluate(ctx, &map->map) < 0)
 		return -1;
 	if (expr_is_constant(map->map))
@@ -3000,20 +3012,34 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	return stmt_evaluate_arg(ctx, stmt,
-				 stmt->meta.tmpl->dtype,
-				 stmt->meta.tmpl->len,
-				 stmt->meta.tmpl->byteorder,
-				 &stmt->meta.expr);
+	int ret;
+
+	ctx->stmt_len = stmt->meta.tmpl->len;
+
+	ret = stmt_evaluate_arg(ctx, stmt,
+				stmt->meta.tmpl->dtype,
+				stmt->meta.tmpl->len,
+				stmt->meta.tmpl->byteorder,
+				&stmt->meta.expr);
+	ctx->stmt_len = 0;
+
+	return ret;
 }
 
 static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	if (stmt_evaluate_arg(ctx, stmt,
-			      stmt->ct.tmpl->dtype,
-			      stmt->ct.tmpl->len,
-			      stmt->ct.tmpl->byteorder,
-			      &stmt->ct.expr) < 0)
+	int ret;
+
+	ctx->stmt_len = stmt->ct.tmpl->len;
+
+	ret = stmt_evaluate_arg(ctx, stmt,
+				stmt->ct.tmpl->dtype,
+				stmt->ct.tmpl->len,
+				stmt->ct.tmpl->byteorder,
+				&stmt->ct.expr);
+	ctx->stmt_len = 0;
+
+	if (ret < 0)
 		return -1;
 
 	if (stmt->ct.key == NFT_CT_SECMARK && expr_is_constant(stmt->ct.expr))
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

