From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nft] netlink_linearize: factor out prefix generation
Date: Mon,  2 Nov 2015 12:55:06 +0100
Message-ID: <1446465306-3364-2-git-send-email-pablo@netfilter.org>
References: <1446465306-3364-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55202 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbbKBLs4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Nov 2015 06:48:56 -0500
In-Reply-To: <1446465306-3364-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a new netlink_gen_prefix() function that encapsulates the prefix
generation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This patch, I should have sent it before the one to add wildcard string.

 src/netlink_linearize.c | 53 +++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index aa44eea..a4cd370 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -290,13 +290,40 @@ static void payload_shift_value(const struct expr *left, struct expr *right)
 	mpz_lshift_ui(right->value, left->payload.offset % BITS_PER_BYTE);
 }
 
+static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
+				       const struct expr *expr,
+				       enum nft_registers sreg)
+{
+	struct nft_data_linearize nld, zero = {};
+	struct nftnl_expr *nle;
+	mpz_t mask;
+
+	mpz_init(mask);
+	mpz_prefixmask(mask, expr->right->len, expr->right->prefix_len);
+	netlink_gen_raw_data(mask, expr->right->byteorder,
+			     expr->right->len / BITS_PER_BYTE, &nld);
+	mpz_clear(mask);
+
+	zero.len = nld.len;
+
+	nle = alloc_nft_expr("bitwise");
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, sreg);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, nld.len);
+	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld.value, nld.len);
+	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &zero.value, zero.len);
+	nftnl_rule_add_expr(ctx->nlr, nle);
+
+	return expr->right->prefix;
+}
+
 static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 			    const struct expr *expr,
 			    enum nft_registers dreg)
 {
+	struct nft_data_linearize nld;
 	struct nftnl_expr *nle;
 	enum nft_registers sreg;
-	struct nft_data_linearize nld, zero = {};
 	struct expr *right;
 
 	assert(dreg == NFT_REG_VERDICT);
@@ -308,30 +335,12 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 	netlink_gen_expr(ctx, expr->left, sreg);
 
 	switch (expr->right->ops->type) {
-	case EXPR_PREFIX: {
-		mpz_t mask;
-
-		mpz_init(mask);
-		mpz_prefixmask(mask, expr->right->len, expr->right->prefix_len);
-		netlink_gen_raw_data(mask, expr->right->byteorder,
-				     expr->right->len / BITS_PER_BYTE, &nld);
-		mpz_clear(mask);
-
-		zero.len = nld.len;
-
-		nle = alloc_nft_expr("bitwise");
-		netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
-		netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, sreg);
-		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, nld.len);
-		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld.value, nld.len);
-		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &zero.value, zero.len);
-		nftnl_rule_add_expr(ctx->nlr, nle);
-
-		right = expr->right->prefix;
+	case EXPR_PREFIX:
+		right = netlink_gen_prefix(ctx, expr, sreg);
 		break;
-		}
 	default:
 		right = expr->right;
+		break;
 	}
 
 	nle = alloc_nft_expr("cmp");
-- 
2.1.4

