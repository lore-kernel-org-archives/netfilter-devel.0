From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 01/12] evaluate: transfer right shifts to constant side
Date: Wed, 11 May 2016 23:05:05 +0200
Message-ID: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40448 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbcEKVF0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 17:05:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B2DF41BD5AA
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A15D1CA100
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A0059CA100
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:20 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

This provides a generic way to transfer shifts from the left hand side
to the right hand constant side of a relational expression when
performing transformations from the evaluation step.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7444d09..f862cd0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -698,6 +698,7 @@ static int constant_binop_simplify(struct eval_ctx *ctx, struct expr **expr)
 		break;
 	case OP_LSHIFT:
 		assert(left->byteorder == BYTEORDER_HOST_ENDIAN);
+		mpz_set(val, left->value);
 		mpz_lshift_ui(val, mpz_get_uint32(right->value));
 		mpz_and(val, val, mask);
 		break;
@@ -1094,6 +1095,8 @@ static int binop_can_transfer(struct eval_ctx *ctx,
 			return expr_binary_error(ctx->msgs, right, left,
 						 "Comparison is always false");
 		return 1;
+	case OP_RSHIFT:
+		return 1;
 	case OP_XOR:
 		return 1;
 	default:
@@ -1111,6 +1114,10 @@ static int binop_transfer_one(struct eval_ctx *ctx,
 		(*right) = binop_expr_alloc(&(*right)->location, OP_RSHIFT,
 					    *right, expr_get(left->right));
 		break;
+	case OP_RSHIFT:
+		(*right) = binop_expr_alloc(&(*right)->location, OP_LSHIFT,
+					    *right, expr_get(left->right));
+		break;
 	case OP_XOR:
 		(*right) = binop_expr_alloc(&(*right)->location, OP_XOR,
 					    *right, expr_get(left->right));
@@ -1125,6 +1132,7 @@ static int binop_transfer_one(struct eval_ctx *ctx,
 static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *left = (*expr)->left, *i, *next;
+	unsigned int shift;
 	int err;
 
 	if (left->ops->type != EXPR_BINOP)
@@ -1156,10 +1164,24 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 		return 0;
 	}
 
-	left = expr_get((*expr)->left->left);
-	left->dtype = (*expr)->left->dtype;
-	expr_free((*expr)->left);
-	(*expr)->left = left;
+	switch (left->op) {
+	case OP_RSHIFT:
+		/* Mask out the bits the shift would have masked out */
+		shift = mpz_get_uint8(left->right->value);
+		mpz_bitmask(left->right->value, left->left->len);
+		mpz_lshift_ui(left->right->value, shift);
+		left->op = OP_AND;
+		break;
+	case OP_LSHIFT:
+	case OP_XOR:
+		left = expr_get((*expr)->left->left);
+		left->dtype = (*expr)->left->dtype;
+		expr_free((*expr)->left);
+		(*expr)->left = left;
+		break;
+	default:
+		BUG("invalid binop operation %u", left->op);
+	}
 	return 0;
 }
 
-- 
2.1.4

