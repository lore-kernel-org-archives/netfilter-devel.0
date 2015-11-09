From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] evaluate: fix string matching on big endian
Date: Mon,  9 Nov 2015 19:47:38 +0100
Message-ID: <1447094858-3215-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35463 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbbKISrs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 13:47:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We need to reallocate the constant expression with the right expression
length when evaluating the string. Otherwise the linearization step
generates a wrong comparison on big endian. We cannot do this any
earlier since we don't know the maximum string length for this datatype
at the parsing stage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I tried with mpz_realloc2(expr->value, expr->len) but this is not working.

 src/evaluate.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e129907..a925e85 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -208,7 +208,8 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 	struct expr *expr = *exprp;
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE), datalen;
 	struct expr *value, *prefix;
-	char data[len + 1];
+	int data_len = ctx->ectx.len > 0 ? ctx->ectx.len : len + 1;
+	char data[data_len];
 
 	if (ctx->ectx.len > 0) {
 		if (expr->len > ctx->ectx.len)
@@ -218,15 +219,25 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 		expr->len = ctx->ectx.len;
 	}
 
+	memset(data + len, 0, data_len - len);
 	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
 
 	datalen = strlen(data) - 1;
-	if (data[datalen] != '*')
+	if (data[datalen] != '*') {
+		/* We need to reallocate the constant expression with the right
+		 * expression length to avoid problems on big endian.
+		 */
+		value = constant_expr_alloc(&expr->location, &string_type,
+					    BYTEORDER_HOST_ENDIAN,
+					    expr->len, data);
+		expr_free(expr);
+		*exprp = value;
 		return 0;
+	}
 
 	if (datalen - 1 >= 0 &&
 	    data[datalen - 1] == '\\') {
-		char unescaped_str[len];
+		char unescaped_str[data_len];
 
 		memset(unescaped_str, 0, sizeof(unescaped_str));
 		xstrunescape(data, unescaped_str);
-- 
2.1.4

