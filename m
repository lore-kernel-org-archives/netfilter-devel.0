From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/6] netlink_linearize: use u64 conversion for 64bit quantities
Date: Fri,  8 Jan 2016 10:42:49 +0100
Message-ID: <1452246171-13943-5-git-send-email-fw@strlen.de>
References: <1452246171-13943-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47939 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272AbcAHJun (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 04:50:43 -0500
In-Reply-To: <1452246171-13943-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft generated two 4-byte swaps for conntrack byte/packet counters,
which are 64bit host-endian values:

byteorder reg 1 = hton(reg 1, 4, 8) ]

This makes the kernel perform two htonl() calls, but we need
a cpu_to_be64 conversion instead (reg 1, 8, 8).

Without this a rule like 'ct original packets > 10'
matched when counter was between 1 and 10.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_linearize.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 48f5f02..c77c462 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -592,6 +592,14 @@ static void netlink_gen_unary(struct netlink_linearize_ctx *ctx,
 			      enum nft_registers dreg)
 {
 	struct nftnl_expr *nle;
+	int byte_size;
+
+	if ((expr->arg->len % 64) == 0)
+		byte_size = 8;
+	else if ((expr->arg->len % 32) == 0)
+		byte_size = 4;
+	else
+		byte_size = 2;
 
 	netlink_gen_expr(ctx, expr->arg, dreg);
 
@@ -601,7 +609,7 @@ static void netlink_gen_unary(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_LEN,
 			   expr->len / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_SIZE,
-			   expr->arg->len % 32 ? 2 : 4);
+			   byte_size);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_OP,
 			   netlink_gen_unary_op(expr->op));
 	nftnl_rule_add_expr(ctx->nlr, nle);
-- 
2.4.10

