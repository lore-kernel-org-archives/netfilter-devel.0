From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: perform sub-byte length matching from the evaluation step
Date: Sat, 28 Nov 2015 13:50:52 +0100
Message-ID: <1448715052-5705-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55805 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbbK1MvF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Nov 2015 07:51:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E7A54B6B9A
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2015 13:51:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D7E63DA801
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2015 13:51:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3CA5ADA801
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2015 13:50:57 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch reworks c3f0501 ("src: netlink_linearize: handle sub-byte lengths")
to perform the required sub-byte transformations from the evaluation step.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Patrick, @Florian: It seems we're falling into subbyte handling
problems from different fronts, I just hit this while further testing of
my dscp patch.

I'm sending this because I think it's sort of ready so we avoid overlap.

I'm working on a follow up patch (almost done here) to cover another
corner case that we don't handle correctly, which is basically this:

    4 bits    6 bits
   +-+-+-+-+-+-+-+-+-+-+
   | vers  |   dscp    |
   +-+-+-+-+-+-+-+-+-+-+
                   ^
                   |
                   byte boundary

To match dscp in IPv6, we have to fetch 2 bytes from offset 0 via
payload expression and the bitmask must be 00ffc000.

I got the code generation correctly, but I'm adjusting the
payload_expr_trim() function now.

So I'm basically working on the netlink code generation part.

I'm not working on the protocol definition problem:
http://marc.info/?l=netfilter-devel&m=144862242521205&w=2, but I also
need this gets fixed. Let me know if you will be looking into this, just
to avoid overlap.

Thanks!

 include/expression.h    |  2 ++
 src/evaluate.c          | 46 +++++++++++++++++++++++++++++++++++++++++---
 src/netlink_linearize.c | 51 -------------------------------------------------
 3 files changed, 45 insertions(+), 54 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 010cb95..bbb92a5 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -100,11 +100,13 @@ enum symbol_types {
  * @dtype:	expected datatype
  * @byteorder:	expected byteorder
  * @len:	expected len
+ * @shift:	required value shift
  */
 struct expr_ctx {
 	const struct datatype	*dtype;
 	enum byteorder		byteorder;
 	unsigned int		len;
+	unsigned int		shift;
 };
 
 static inline void __expr_set_context(struct expr_ctx *ctx,
diff --git a/src/evaluate.c b/src/evaluate.c
index d44cecc..4b8b5ea 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -285,6 +285,8 @@ static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
 		(*expr)->byteorder = ctx->ectx.byteorder;
 		(*expr)->len = ctx->ectx.len;
 		mpz_clear(mask);
+		if (ctx->ectx.shift)
+			mpz_lshift_ui((*expr)->value, ctx->ectx.shift);
 		break;
 	case TYPE_STRING:
 		if (expr_evaluate_string(ctx, expr) < 0)
@@ -457,12 +459,50 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 	return 0;
 }
 
-static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
+static void expr_evaluate_payload_subbyte(struct eval_ctx *ctx,
+					  struct expr **exprp)
 {
-	if (__expr_evaluate_payload(ctx, *expr) < 0)
+	struct expr *expr = *exprp, *and, *mask;
+	unsigned int shift, masklen;
+	mpz_t bitmask;
+
+	shift = expr->payload.offset % BITS_PER_BYTE;
+	masklen = expr->len + shift;
+
+	if (masklen > 128)
+		BUG("expr mask length is %u (len %u, shift %u)\n",
+		    masklen, expr->len, shift);
+
+	mpz_init2(bitmask, masklen);
+	mpz_bitmask(bitmask, expr->len);
+	if (shift)
+		mpz_lshift_ui(bitmask, shift);
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
+	*exprp = and;
+
+	ctx->ectx.shift = shift;
+}
+
+static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *expr = *exprp;
+
+	if (__expr_evaluate_payload(ctx, expr) < 0)
 		return -1;
 
-	return expr_evaluate_primary(ctx, expr);
+	if (expr->len % BITS_PER_BYTE)
+		expr_evaluate_payload_subbyte(ctx, exprp);
+
+	return expr_evaluate_primary(ctx, &expr);
 }
 
 /*
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 432068d..ee072b8 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -103,44 +103,6 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 	}
 }
 
-static void netlink_gen_payload_mask(struct netlink_linearize_ctx *ctx,
-				     const struct expr *expr,
-				     enum nft_registers dreg)
-{
-	struct nft_data_linearize nld, zero = {};
-	struct nftnl_expr *nle;
-	unsigned int offset, len, masklen;
-	mpz_t mask;
-
-	offset = expr->payload.offset % BITS_PER_BYTE;
-	masklen = expr->len + offset;
-
-	if (masklen > 128)
-		BUG("expr mask length is %u (len %u, offset %u)\n",
-				masklen, expr->len, offset);
-
-	mpz_init2(mask, masklen);
-	mpz_bitmask(mask, expr->len);
-
-	if (offset)
-		mpz_lshift_ui(mask, offset);
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
@@ -157,9 +119,6 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
-
-	if (expr->len % BITS_PER_BYTE)
-		netlink_gen_payload_mask(ctx, expr, dreg);
 }
 
 static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
@@ -281,15 +240,6 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg);
 
-static void payload_shift_value(const struct expr *left, struct expr *right)
-{
-	if (right->ops->type != EXPR_VALUE ||
-	    left->ops->type != EXPR_PAYLOAD)
-		return;
-
-	mpz_lshift_ui(right->value, left->payload.offset % BITS_PER_BYTE);
-}
-
 static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
 				       const struct expr *expr,
 				       enum nft_registers sreg)
@@ -358,7 +308,6 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 	netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
 			      netlink_gen_cmp_op(expr->op));
-	payload_shift_value(expr->left, right);
 	netlink_gen_data(right, &nld);
 	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, len);
 	release_register(ctx, expr->left);
-- 
2.1.4

