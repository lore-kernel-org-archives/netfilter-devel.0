From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 08/12] netlink: cmp: shift rhs constant if lhs offset doesn't start on byte boundary
Date: Sun, 16 Aug 2015 21:05:51 +0200
Message-ID: <1439751955-31190-9-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34749 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbbHPTGN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:13 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

if we have payload(someoffset) == 42, then shift 42 in case someoffset
doesn't start on a byte boundary.

We already insert a mask instruction to only load those bits into
the register that we were interested in, but the cmp will fail without
also adjusting rhs accordingly.

Needs additional patch in reverse direction to undo the shift again
when dumping ruleset.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_linearize.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0467872..044bac8 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -278,6 +278,15 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg);
 
+static void payload_shift_value(const struct expr *left, struct expr *right)
+{
+	if (right->ops->type != EXPR_VALUE ||
+	    left->ops->type != EXPR_PAYLOAD)
+		return;
+
+	mpz_lshift_ui(right->value, left->payload.offset % BITS_PER_BYTE);
+}
+
 static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 			    const struct expr *expr,
 			    enum nft_registers dreg)
@@ -326,6 +335,7 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 	netlink_put_register(nle, NFT_EXPR_CMP_SREG, sreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
 			      netlink_gen_cmp_op(expr->op));
+	payload_shift_value(expr->left, right);
 	netlink_gen_data(right, &nld);
 	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
 	release_register(ctx, expr->left);
-- 
2.0.5

