From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 05/12] src: netlink_linearize: handle sub-byte lengths
Date: Sun, 16 Aug 2015 21:05:48 +0200
Message-ID: <1439751955-31190-6-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34746 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447AbbHPTGL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:11 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently length is expr->len / BITS_PER_BYTE, i.e. expr->len
has to be a multiple of 8.

When core asks for e.g. '9 bits', we truncate this to 8.
Round up to 16 and inject a 9-bit mask to zero out the parts we're not
interested in.

This will also need change to the delinarization step to
remove the extra op when dumping rules from kernel.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_linearize.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index bf1e56b..0467872 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -99,6 +99,44 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 	}
 }
 
+static void netlink_gen_payload_mask(struct netlink_linearize_ctx *ctx,
+				     const struct expr *expr,
+				     enum nft_registers dreg)
+{
+	struct nft_data_linearize nld, zero = {};
+	struct nft_rule_expr *nle;
+	unsigned int offset, len, masklen;
+	mpz_t mask;
+
+	offset = expr->payload.offset % BITS_PER_BYTE;
+	masklen = expr->len + offset;
+
+	if (masklen > 128)
+		BUG("expr mask length is %u (len %u, offset %u)\n",
+				masklen, expr->len, offset);
+
+	mpz_init2(mask, masklen);
+	mpz_bitmask(mask, expr->len);
+
+	if (offset)
+		mpz_lshift_ui(mask, offset);
+
+	nle = alloc_nft_expr("bitwise");
+
+	len = div_round_up(expr->len, BITS_PER_BYTE);
+
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_SREG, dreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_DREG, dreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_LEN, len);
+
+	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
+	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_MASK, nld.value, nld.len);
+	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_XOR, &zero.value, nld.len);
+
+	mpz_clear(mask);
+	nft_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 				const struct expr *expr,
 				enum nft_registers dreg)
@@ -111,9 +149,14 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 			      expr->payload.base - 1);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_PAYLOAD_OFFSET,
 			      expr->payload.offset / BITS_PER_BYTE);
+
 	nft_rule_expr_set_u32(nle, NFT_EXPR_PAYLOAD_LEN,
-			      expr->len / BITS_PER_BYTE);
+			      div_round_up(expr->len, BITS_PER_BYTE));
+
 	nft_rule_add_expr(ctx->nlr, nle);
+
+	if (expr->len % BITS_PER_BYTE)
+		netlink_gen_payload_mask(ctx, expr, dreg);
 }
 
 static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
-- 
2.0.5

