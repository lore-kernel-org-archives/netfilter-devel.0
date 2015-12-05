From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/7] evaluate: transfer right shifts to constant side
Date: Sat,  5 Dec 2015 20:04:23 +0100
Message-ID: <1449342266-2756-4-git-send-email-pablo@netfilter.org>
References: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51088 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbbLETEk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 14:04:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9AF63DA876
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8BF5CDA85F
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A29DCDA808
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:37 +0100 (CET)
In-Reply-To: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
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
index 7aab6aa..d62870a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -646,6 +646,7 @@ static int constant_binop_simplify(struct eval_ctx *ctx, struct expr **expr)
 		break;
 	case OP_LSHIFT:
 		assert(left->byteorder == BYTEORDER_HOST_ENDIAN);
+		mpz_set(val, left->value);
 		mpz_lshift_ui(val, mpz_get_uint32(right->value));
 		mpz_and(val, val, mask);
 		break;
@@ -1021,6 +1022,8 @@ static int binop_can_transfer(struct eval_ctx *ctx,
 			return expr_binary_error(ctx->msgs, right, left,
 						 "Comparison is always false");
 		return 1;
+	case OP_RSHIFT:
+		return 1;
 	case OP_XOR:
 		return 1;
 	default:
@@ -1038,6 +1041,10 @@ static int binop_transfer_one(struct eval_ctx *ctx,
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
@@ -1052,6 +1059,7 @@ static int binop_transfer_one(struct eval_ctx *ctx,
 static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *left = (*expr)->left, *i, *next;
+	unsigned int shift;
 	int err;
 
 	if (left->ops->type != EXPR_BINOP)
@@ -1083,10 +1091,24 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
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

