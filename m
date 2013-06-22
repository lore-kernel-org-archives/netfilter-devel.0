From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCHv2] nft: netlink: fix network address prefix
Date: Sat, 22 Jun 2013 19:46:38 +0200
Message-ID: <1371923198-11811-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42986 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3FVRqr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Jun 2013 13:46:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

eg. nft add rule filter output ip daddr 192.168.1.0/24 counter

so far, this operation was only possible using sets.

nft add rule filter output ip daddr \{ 192.168.1.0/24 \} counter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: initial version
v2: don't break normal comparisons

 src/netlink.c             |   24 +++++++++++++++++++
 src/netlink_delinearize.c |   57 +++++++++++++++++++++++++++++++++++++++++++++
 src/netlink_linearize.c   |   28 ++++++++++++++++++----
 3 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index d835281..2a7bdb5 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -228,6 +228,28 @@ static void netlink_gen_verdict(const struct expr *expr,
 	}
 }
 
+static void netlink_gen_prefix(const struct expr *expr,
+			       struct nft_data_linearize *data)
+{
+	uint32_t i, cidr, idx;
+	uint32_t mask;
+
+	assert(expr->ops->type == EXPR_PREFIX);
+
+	data->len = div_round_up(expr->prefix->len, BITS_PER_BYTE);
+	cidr = expr->prefix_len;
+
+	for (i = 0; i < data->len; i+= 32) {
+		if (cidr - i >= 32)
+			mask = 0;
+		else
+			mask = (1 << cidr) - 1;
+
+		idx = i / 32;
+		data->value[idx] = mask;
+	}
+}
+
 void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
 {
 	switch (expr->ops->type) {
@@ -237,6 +259,8 @@ void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
 		return netlink_gen_concat_data(expr, data);
 	case EXPR_VERDICT:
 		return netlink_gen_verdict(expr, data);
+	case EXPR_PREFIX:
+		return netlink_gen_prefix(expr, data);
 	default:
 		BUG("invalid data expression type %s\n", expr->ops->name);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index c24e105..ab7c00d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -593,6 +593,54 @@ static void meta_match_postprocess(struct payload_ctx *ctx,
 	}
 }
 
+static int expr_value2cidr(struct expr *expr)
+{
+	int i, j, k = 0;
+	uint32_t data[4], bits;
+	uint32_t len = div_round_up(expr->len, BITS_PER_BYTE) / sizeof(uint32_t);
+
+	assert(expr->ops->type == EXPR_VALUE);
+
+	mpz_export_data(data, expr->value, expr->byteorder, len);
+
+	for (i = len - 1; i >= 0; i--) {
+		j = 32;
+		bits = UINT32_MAX >> 1;
+
+		if (data[i] == UINT32_MAX)
+			goto next;
+
+		while (--j >= 0) {
+			if (data[i] == bits)
+				break;
+
+			bits >>=1;
+		}
+next:
+		k += j;
+	}
+	return k;
+}
+
+static int prefix_postprocess(struct expr *expr)
+{
+	struct expr *binop = expr->left, *value = expr->right;
+
+	if ((binop->left->dtype->type == TYPE_IPADDR ||
+	     binop->left->dtype->type == TYPE_IP6ADDR) &&
+	    binop->op == OP_AND) {
+
+		expr->left = expr_clone(binop->left);
+		expr->right = prefix_expr_alloc(&expr->location,
+						expr_clone(value),
+						expr_value2cidr(binop->right));
+		expr_free(value);
+		expr_free(binop);
+		return 1;
+	}
+	return 0;
+}
+
 static void expr_postprocess(struct rule_pp_ctx *ctx,
 			     struct stmt *stmt, struct expr **exprp)
 {
@@ -635,6 +683,15 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 		case EXPR_PAYLOAD:
 			payload_match_postprocess(ctx, stmt, expr);
 			return;
+		case EXPR_BINOP:
+			expr_postprocess(ctx, stmt, &expr->left);
+			expr_set_type(expr->right, expr->left->dtype,
+				      expr->left->byteorder);
+			expr_postprocess(ctx, stmt, &expr->right);
+
+			/* Network address + prefix case */
+			prefix_postprocess(expr);
+			return;
 		default:
 			expr_postprocess(ctx, stmt, &expr->left);
 			break;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 044815a..059952c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -184,18 +184,38 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 {
 	struct nft_rule_expr *nle;
 	enum nft_registers sreg;
-	struct nft_data_linearize nld;
+	struct nft_data_linearize nld, zero = {};
+	struct expr *right;
+	uint8_t op;
 
 	assert(dreg == NFT_REG_VERDICT);
 
 	sreg = get_register(ctx);
 	netlink_gen_expr(ctx, expr->left, sreg);
 
+	if (expr->right->ops->type == EXPR_PREFIX) {
+		right = expr->right->prefix;
+		op = netlink_gen_cmp_op(expr->op);
+
+		netlink_gen_data(expr->right, &nld);
+		zero.len = nld.len;
+
+		nle = alloc_nft_expr("bitwise");
+		nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_SREG, sreg);
+		nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_DREG, sreg);
+		nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_LEN, nld.len);
+		nft_rule_expr_set(nle, NFT_EXPR_BITWISE_MASK, &nld.value, nld.len);
+		nft_rule_expr_set(nle, NFT_EXPR_BITWISE_XOR, &zero.value, zero.len);
+		nft_rule_add_expr(ctx->nlr, nle);
+	} else {
+		right = expr->right;
+		op = netlink_gen_cmp_op(expr->op);
+	}
+
 	nle = alloc_nft_expr("cmp");
 	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_SREG, sreg);
-	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_OP,
-			      netlink_gen_cmp_op(expr->op));
-	netlink_gen_data(expr->right, &nld);
+	nft_rule_expr_set_u8(nle, NFT_EXPR_CMP_OP, op);
+	netlink_gen_data(right, &nld);
 	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
 	release_register(ctx);
 
-- 
1.7.10.4

