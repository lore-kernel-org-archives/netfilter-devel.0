From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 03/10] netlink: add and use netlink_gen_exthdr_mask
Date: Tue,  1 Mar 2016 16:37:43 +0100
Message-ID: <1456846670-28179-4-git-send-email-fw@strlen.de>
References: <1456846670-28179-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49299 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539AbcCAPhm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:37:42 -0500
In-Reply-To: <1456846670-28179-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

rule ip6 filter input frag frag-off 33

before patch:
 [ exthdr load 1b @ 44 + 2 => reg 1 ]
 [ cmp eq reg 1 0x00002100 ]

We truncated 13bit field to 1 byte.

after patch:
 [ exthdr load 2b @ 44 + 2 => reg 1 ]
 [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
 [ cmp eq reg 1 0x00000801 ]

- ask for 2 bytes
- mask out the 3 lower bits
- shift the value by 3 so equality test will pass for 33

This causes test failures, will be fixed up in a later patch
(the test suite expects the old, broken input).

It also misses the reverse translation to remove the binop,
find the right template and undo the shift of the value.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_linearize.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 7715a28..7ff3b00 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -181,6 +181,18 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 	netlink_gen_payload_mask(ctx, expr, dreg);
 }
 
+static void netlink_gen_exthdr_mask(struct netlink_linearize_ctx *ctx,
+				    const struct expr *expr,
+				    enum nft_registers dreg)
+{
+	unsigned int shift, offset;
+
+	offset = expr->exthdr.tmpl->offset % BITS_PER_BYTE;
+	shift = payload_shift_calc(expr, offset);
+	if (shift || offset)
+		netlink_gen_mask(ctx, expr, shift, dreg);
+}
+
 static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 			       const struct expr *expr,
 			       enum nft_registers dreg)
@@ -194,8 +206,10 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET,
 			   expr->exthdr.tmpl->offset / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_LEN,
-			   expr->len / BITS_PER_BYTE);
+			   div_round_up(expr->len, BITS_PER_BYTE));
 	nftnl_rule_add_expr(ctx->nlr, nle);
+
+	netlink_gen_exthdr_mask(ctx, expr, dreg);
 }
 
 static void netlink_gen_meta(struct netlink_linearize_ctx *ctx,
@@ -306,10 +320,17 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 
 static void payload_shift_value(const struct expr *left, struct expr *right)
 {
-	if (right->ops->type != EXPR_VALUE ||
-	    left->ops->type != EXPR_PAYLOAD)
+	if (right->ops->type != EXPR_VALUE)
 		return;
 
+	switch (left->ops->type) {
+	case EXPR_PAYLOAD:
+	case EXPR_EXTHDR:
+		break;
+	default:
+		return;
+	}
+
 	mpz_lshift_ui(right->value,
 			payload_shift_calc(left, left->payload.offset));
 }
-- 
2.4.10

