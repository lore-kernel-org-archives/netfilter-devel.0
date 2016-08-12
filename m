From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/4] evaluate: Fix datalen checks in expr_evaluate_string()
Date: Fri, 12 Aug 2016 18:00:07 +0200
Message-ID: <1471017610-3473-2-git-send-email-phil@nwl.cc>
References: <1471017610-3473-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:56269 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbcHLQAm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 12:00:42 -0400
In-Reply-To: <1471017610-3473-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This part of the code is pretty weird due to suboptimal variable name
choice: 'data', 'len', 'datalen', 'data_len'.

But even without understanding all of it, the code checking 'datalen - 1
>= 0' assumes 'datalen - 1' may actually become negative, which is not
true since it is unsigned. So make 'datalen' a signed integer instead.

Another issue is the check for "data[datalen] != '*'" which will access
unallocated memory if 'strlen(data) == 0'. So make sure 'datalen >= 0'
before using it as array index.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 87f5a6d77d485..523eedabe84ac 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -211,8 +211,9 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp;
-	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE), datalen;
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	struct expr *value, *prefix;
+	int datalen;
 	int data_len = ctx->ectx.len > 0 ? ctx->ectx.len : len + 1;
 	char data[data_len];
 
@@ -228,7 +229,8 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
 
 	datalen = strlen(data) - 1;
-	if (data[datalen] != '*') {
+	if (datalen >= 0 &&
+	    data[datalen] != '*') {
 		/* We need to reallocate the constant expression with the right
 		 * expression length to avoid problems on big endian.
 		 */
-- 
2.8.2

