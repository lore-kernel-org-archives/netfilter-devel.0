From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 7/7] src: move payload sub-byte matching to the evaluation step
Date: Sat,  5 Dec 2015 20:04:26 +0100
Message-ID: <1449342266-2756-7-git-send-email-pablo@netfilter.org>
References: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51096 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbbLETEm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 14:04:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B701CDA8E1
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A9344DA801
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AEFD9DA7FF
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:39 +0100 (CET)
In-Reply-To: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Generating the bitwise logic to match sub-byte payload fields from the
linearize step has several problems.

1) When the bits are split between two bytes and the payload field is
   smaller than one byte, we need to extend the expression length on
   both sides (payload and constant) of the relational expression.

2) Explicit bitmask operations on sub-byte payload fields need to be
   merge to the implicit bitmask operation, otherwise we generate two
   bitwise instructions.

Moreover, with this approach, we can benefit from the binary operation
transfer for shifts to provide a generic way to adjust the constant side
of the expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c          | 71 ++++++++++++++++++++++++++++++++++++++++++++++---
 src/netlink_linearize.c | 60 -----------------------------------------
 2 files changed, 68 insertions(+), 63 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index eb191ed..4ee82ef 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -457,12 +457,74 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 	return 0;
 }
 
-static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
+static unsigned int expr_payload_shift_calc(const struct expr *expr)
 {
-	if (__expr_evaluate_payload(ctx, *expr) < 0)
+	unsigned int offset, len;
+	int shift;
+
+	offset = expr->payload.offset % BITS_PER_BYTE;
+	len = round_up(expr->len, BITS_PER_BYTE);
+	shift = len - (offset + expr->len);
+	assert(shift >= 0);
+
+	return shift;
+}
+
+static void expr_evaluate_payload_bits(struct eval_ctx *ctx,
+				       struct expr **exprp)
+{
+	struct expr *expr = *exprp, *and, *mask, *lshift, *off;
+	unsigned int shift, masklen;
+	mpz_t bitmask;
+
+	shift = expr_payload_shift_calc(expr);
+	masklen = expr->len + shift;
+	assert(masklen <= NFT_REG_SIZE * BITS_PER_BYTE);
+
+	mpz_init2(bitmask, masklen);
+	mpz_bitmask(bitmask, expr->len);
+	mpz_lshift_ui(bitmask, shift);
+
+	mask = constant_expr_alloc(&expr->location, expr_basetype(expr),
+				   BYTEORDER_HOST_ENDIAN, masklen, NULL);
+	mpz_set(mask->value, bitmask);
+
+	and = binop_expr_alloc(&expr->location, OP_AND, expr, mask);
+	and->dtype	= expr->dtype;
+	and->byteorder	= expr->byteorder;
+	and->len	= masklen;
+
+	if (shift) {
+		off = constant_expr_alloc(&expr->location,
+					  expr_basetype(expr),
+					  BYTEORDER_BIG_ENDIAN,
+					  masklen, &shift);
+
+		lshift = binop_expr_alloc(&expr->location, OP_RSHIFT, and, off);
+		lshift->dtype		= expr->dtype;
+		lshift->byteorder	= expr->byteorder;
+		lshift->len		= masklen;
+
+		*exprp = lshift;
+	} else
+		*exprp = and;
+}
+
+static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *expr = *exprp;
+
+	if (__expr_evaluate_payload(ctx, expr) < 0)
 		return -1;
 
-	return expr_evaluate_primary(ctx, expr);
+	if (expr_evaluate_primary(ctx, exprp) < 0)
+		return -1;
+
+	if (expr->payload.offset % BITS_PER_BYTE != 0 ||
+	    expr->len % BITS_PER_BYTE != 0)
+		expr_evaluate_payload_bits(ctx, exprp);
+
+	return 0;
 }
 
 /*
@@ -1042,6 +1104,9 @@ static int binop_transfer_one(struct eval_ctx *ctx,
 					    *right, expr_get(left->right));
 		break;
 	case OP_RSHIFT:
+		if (mpz_get_uint32(left->right->value) >= ctx->ectx.len)
+			ctx->ectx.len += mpz_get_uint32(left->right->value);
+
 		(*right) = binop_expr_alloc(&(*right)->location, OP_LSHIFT,
 					    *right, expr_get(left->right));
 		break;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 131c3f9..e9dfdf9 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -103,54 +103,6 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 	}
 }
 
-static unsigned int payload_shift_calc(const struct expr *expr)
-{
-	unsigned int offset, len;
-	int shift;
-
-	offset = expr->payload.offset % BITS_PER_BYTE;
-	len = round_up(expr->len, BITS_PER_BYTE);
-	shift = len - (offset + expr->len);
-	assert(shift >= 0);
-
-	return shift;
-}
-
-static void netlink_gen_payload_mask(struct netlink_linearize_ctx *ctx,
-				     const struct expr *expr,
-				     enum nft_registers dreg)
-{
-	struct nft_data_linearize nld, zero = {};
-	unsigned int shift, len, masklen;
-	struct nftnl_expr *nle;
-	mpz_t mask;
-
-	shift = payload_shift_calc(expr);
-	if (!shift && expr->payload.offset % BITS_PER_BYTE == 0)
-		return;
-
-	masklen = expr->len + shift;
-	assert(masklen <= NFT_REG_SIZE * BITS_PER_BYTE);
-	mpz_init2(mask, masklen);
-	mpz_bitmask(mask, expr->len);
-	mpz_lshift_ui(mask, shift);
-
-	nle = alloc_nft_expr("bitwise");
-
-	len = div_round_up(expr->len, BITS_PER_BYTE);
-
-	nftnl_expr_set_u32(nle, NFT_EXPR_BITWISE_SREG, dreg);
-	nftnl_expr_set_u32(nle, NFT_EXPR_BITWISE_DREG, dreg);
-	nftnl_expr_set_u32(nle, NFT_EXPR_BITWISE_LEN, len);
-
-	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
-	nftnl_expr_set(nle, NFT_EXPR_BITWISE_MASK, nld.value, nld.len);
-	nftnl_expr_set(nle, NFT_EXPR_BITWISE_XOR, &zero.value, nld.len);
-
-	mpz_clear(mask);
-	nftnl_rule_add_expr(ctx->nlr, nle);
-}
-
 static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 				const struct expr *expr,
 				enum nft_registers dreg)
@@ -167,8 +119,6 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
-
-	netlink_gen_payload_mask(ctx, expr, dreg);
 }
 
 static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
@@ -290,15 +240,6 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg);
 
-static void payload_shift_value(const struct expr *left, struct expr *right)
-{
-	if (right->ops->type != EXPR_VALUE ||
-	    left->ops->type != EXPR_PAYLOAD)
-		return;
-
-	mpz_lshift_ui(right->value, payload_shift_calc(left));
-}
-
 static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
 				       const struct expr *expr,
 				       enum nft_registers sreg)
@@ -367,7 +308,6 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 	netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
 			   netlink_gen_cmp_op(expr->op));
-	payload_shift_value(expr->left, right);
 	netlink_gen_data(right, &nld);
 	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, len);
 	release_register(ctx, expr->left);
-- 
2.1.4

