From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 6/8] evaluate: validate maximum hash and numgen value
Date: Mon, 29 Aug 2016 20:21:17 +0200
Message-ID: <1472494879-16442-6-git-send-email-pablo@netfilter.org>
References: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48878 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754476AbcH2SVe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2016 14:21:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B8741324E3
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18B27100A65
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB35B100A65
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:30 +0200 (CEST)
In-Reply-To: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can validate that values don't get over the maximum datatype
length, this is expressed in number of bits, so the maximum value
is always power of 2.

However, since we got the hash and numgen expressions, the user should
not set a value higher that what the specified modulus option, which
may not be power of 2. This patch extends the expression context with
a new optional field to store the maximum value.

After this patch, nft bails out if the user specifies non-sense rules
like those below:

 # nft add rule x y jhash ip saddr mod 10 seed 0xa 10
 <cmdline>:1:45-46: Error: Value 10 exceeds valid range 0-9
 add rule x y jhash ip saddr mod 10 seed 0xa 10
                                             ^^

The modulus sets a valid value range of [0, n), so n is out of the valid
value range.

 # nft add rule x y numgen inc mod 10 eq 12
 <cmdline>:1:35-36: Error: Value 12 exceeds valid range 0-9
 add rule x y numgen inc mod 10 eq 12
                                   ^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  8 ++++++--
 src/evaluate.c       | 28 ++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 6a509b3..13ca315 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -104,21 +104,24 @@ enum symbol_types {
  * @dtype:	expected datatype
  * @byteorder:	expected byteorder
  * @len:	expected len
+ * @maxval:	expected maximum value
  */
 struct expr_ctx {
 	const struct datatype	*dtype;
 	enum byteorder		byteorder;
 	unsigned int		len;
+	unsigned int		maxval;
 };
 
 static inline void __expr_set_context(struct expr_ctx *ctx,
 				      const struct datatype *dtype,
 				      enum byteorder byteorder,
-				      unsigned int len)
+				      unsigned int len, unsigned int maxval)
 {
 	ctx->dtype	= dtype;
 	ctx->byteorder	= byteorder;
 	ctx->len	= len;
+	ctx->maxval	= maxval;
 }
 
 static inline void expr_set_context(struct expr_ctx *ctx,
@@ -126,7 +129,8 @@ static inline void expr_set_context(struct expr_ctx *ctx,
 				    unsigned int len)
 {
 	__expr_set_context(ctx, dtype,
-			   dtype ? dtype->byteorder : BYTEORDER_INVALID, len);
+			   dtype ? dtype->byteorder : BYTEORDER_INVALID,
+			   len, 0);
 }
 
 /**
diff --git a/src/evaluate.c b/src/evaluate.c
index 39573e9..7eb28f2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -266,12 +266,23 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp;
+	char *valstr, *rangestr;
 	mpz_t mask;
 
+	if (ctx->ectx.maxval > 0 &&
+	    mpz_cmp_ui(expr->value, ctx->ectx.maxval) > 0) {
+		valstr = mpz_get_str(NULL, 10, expr->value);
+		expr_error(ctx->msgs, expr,
+			   "Value %s exceeds valid range 0-%u",
+			   valstr, ctx->ectx.maxval);
+		free(valstr);
+		return -1;
+	}
+
 	mpz_init_bitmask(mask, ctx->ectx.len);
 	if (mpz_cmp(expr->value, mask) > 0) {
-		char *valstr = mpz_get_str(NULL, 10, expr->value);
-		char *rangestr = mpz_get_str(NULL, 10, mask);
+		valstr = mpz_get_str(NULL, 10, expr->value);
+		rangestr = mpz_get_str(NULL, 10, mask);
 		expr_error(ctx->msgs, expr,
 			   "Value %s exceeds valid range 0-%s",
 			   valstr, rangestr);
@@ -309,7 +320,7 @@ static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
 static int expr_evaluate_primary(struct eval_ctx *ctx, struct expr **expr)
 {
 	__expr_set_context(&ctx->ectx, (*expr)->dtype, (*expr)->byteorder,
-			   (*expr)->len);
+			   (*expr)->len, 0);
 	return 0;
 }
 
@@ -1186,9 +1197,13 @@ static void expr_dtype_integer_compatible(struct eval_ctx *ctx,
 
 static int expr_evaluate_numgen(struct eval_ctx *ctx, struct expr **exprp)
 {
-	expr_dtype_integer_compatible(ctx, *exprp);
+	struct expr *expr = *exprp;
+
+	expr_dtype_integer_compatible(ctx, expr);
 
-	return expr_evaluate_primary(ctx, exprp);
+	__expr_set_context(&ctx->ectx, expr->dtype, expr->byteorder, expr->len,
+			   expr->numgen.mod - 1);
+	return 0;
 }
 
 static int expr_evaluate_hash(struct eval_ctx *ctx, struct expr **exprp)
@@ -1205,7 +1220,8 @@ static int expr_evaluate_hash(struct eval_ctx *ctx, struct expr **exprp)
          * expression to be hashed. Since this input is transformed to a 4 bytes
 	 * integer, restore context to the datatype that results from hashing.
 	 */
-	expr_set_context(&ctx->ectx, expr->dtype, expr->len);
+	__expr_set_context(&ctx->ectx, expr->dtype, expr->byteorder, expr->len,
+			   expr->hash.mod - 1);
 
 	return 0;
 }
-- 
2.1.4

