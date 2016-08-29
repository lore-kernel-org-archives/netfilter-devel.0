From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 5/8] evaluate: add expr_evaluate_integer()
Date: Mon, 29 Aug 2016 20:21:16 +0200
Message-ID: <1472494879-16442-5-git-send-email-pablo@netfilter.org>
References: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752993AbcH2SVd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2016 14:21:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1E14F1324E5
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DE1C100A6A
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C3419663F
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:30 +0200 (CEST)
In-Reply-To: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a helper function to wrap the integer evaluation code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8f7824b..39573e9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -263,27 +263,35 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 	return 0;
 }
 
-static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
+static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
 {
+	struct expr *expr = *exprp;
 	mpz_t mask;
 
+	mpz_init_bitmask(mask, ctx->ectx.len);
+	if (mpz_cmp(expr->value, mask) > 0) {
+		char *valstr = mpz_get_str(NULL, 10, expr->value);
+		char *rangestr = mpz_get_str(NULL, 10, mask);
+		expr_error(ctx->msgs, expr,
+			   "Value %s exceeds valid range 0-%s",
+			   valstr, rangestr);
+		free(valstr);
+		free(rangestr);
+		mpz_clear(mask);
+		return -1;
+	}
+	expr->byteorder = ctx->ectx.byteorder;
+	expr->len = ctx->ectx.len;
+	mpz_clear(mask);
+	return 0;
+}
+
+static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
+{
 	switch (expr_basetype(*expr)->type) {
 	case TYPE_INTEGER:
-		mpz_init_bitmask(mask, ctx->ectx.len);
-		if (mpz_cmp((*expr)->value, mask) > 0) {
-			char *valstr = mpz_get_str(NULL, 10, (*expr)->value);
-			char *rangestr = mpz_get_str(NULL, 10, mask);
-			expr_error(ctx->msgs, *expr,
-				   "Value %s exceeds valid range 0-%s",
-				   valstr, rangestr);
-			free(valstr);
-			free(rangestr);
-			mpz_clear(mask);
+		if (expr_evaluate_integer(ctx, expr) < 0)
 			return -1;
-		}
-		(*expr)->byteorder = ctx->ectx.byteorder;
-		(*expr)->len = ctx->ectx.len;
-		mpz_clear(mask);
 		break;
 	case TYPE_STRING:
 		if (expr_evaluate_string(ctx, expr) < 0)
-- 
2.1.4

