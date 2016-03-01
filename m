From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 02/10] netlink: split generic part of netlink_gen_payload_mask into helper
Date: Tue,  1 Mar 2016 16:37:42 +0100
Message-ID: <1456846670-28179-3-git-send-email-fw@strlen.de>
References: <1456846670-28179-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49298 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539AbcCAPhj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:37:39 -0500
In-Reply-To: <1456846670-28179-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netlink_gen_payload_mask assumes expr is a payload expression,
but most of this function would work fine with exthdr too.

So split the gernic part into a helper, followup patch will
add netlink_gen_exthdr_mask.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_linearize.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 86b49c6..7715a28 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -103,12 +103,13 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 	}
 }
 
-static unsigned int payload_shift_calc(const struct expr *expr)
+static unsigned int payload_shift_calc(const struct expr *expr,
+				       unsigned int offset)
 {
-	unsigned int offset, len;
+	unsigned int len;
 	int shift;
 
-	offset = expr->payload.offset % BITS_PER_BYTE;
+	offset %= BITS_PER_BYTE;
 	len = round_up(expr->len, BITS_PER_BYTE);
 	shift = len - (offset + expr->len);
 	assert(shift >= 0);
@@ -116,19 +117,16 @@ static unsigned int payload_shift_calc(const struct expr *expr)
 	return shift;
 }
 
-static void netlink_gen_payload_mask(struct netlink_linearize_ctx *ctx,
-				     const struct expr *expr,
-				     enum nft_registers dreg)
+static void netlink_gen_mask(struct netlink_linearize_ctx *ctx,
+			     const struct expr *expr,
+			     unsigned int shift,
+			     enum nft_registers dreg)
 {
 	struct nft_data_linearize nld, zero = {};
-	unsigned int shift, len, masklen;
+	unsigned int len, masklen;
 	struct nftnl_expr *nle;
 	mpz_t mask;
 
-	shift = payload_shift_calc(expr);
-	if (!shift && expr->payload.offset % BITS_PER_BYTE == 0)
-		return;
-
 	masklen = expr->len + shift;
 	assert(masklen <= NFT_REG_SIZE * BITS_PER_BYTE);
 	mpz_init2(mask, masklen);
@@ -151,6 +149,18 @@ static void netlink_gen_payload_mask(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_payload_mask(struct netlink_linearize_ctx *ctx,
+				     const struct expr *expr,
+				     enum nft_registers dreg)
+{
+	unsigned int shift, offset;
+
+	offset = expr->payload.offset % BITS_PER_BYTE;
+	shift = payload_shift_calc(expr, offset);
+	if (shift || offset)
+		netlink_gen_mask(ctx, expr, shift, dreg);
+}
+
 static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 				const struct expr *expr,
 				enum nft_registers dreg)
@@ -300,7 +310,8 @@ static void payload_shift_value(const struct expr *left, struct expr *right)
 	    left->ops->type != EXPR_PAYLOAD)
 		return;
 
-	mpz_lshift_ui(right->value, payload_shift_calc(left));
+	mpz_lshift_ui(right->value,
+			payload_shift_calc(left, left->payload.offset));
 }
 
 static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
-- 
2.4.10

