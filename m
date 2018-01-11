From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink_linearize: exthdr op must be u32
Date: Thu, 11 Jan 2018 16:30:19 +0100
Message-ID: <20180111153024.25198-2-fw@strlen.de>
References: <20180111153024.25198-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57484 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932384AbeAKPmg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 10:42:36 -0500
In-Reply-To: <20180111153024.25198-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libnftnl casts this to u32. Broke exthdr expressions on bigendian.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_linearize.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index cf6ffdb05ebf..99a4dde22adb 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -178,7 +178,7 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET, offset / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
-	nftnl_expr_set_u8(nle, NFTNL_EXPR_EXTHDR_OP, expr->exthdr.op);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OP, expr->exthdr.op);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_FLAGS, expr->exthdr.flags);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
@@ -839,7 +839,7 @@ static void netlink_gen_exthdr_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET, offset / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
-	nftnl_expr_set_u8(nle, NFTNL_EXPR_EXTHDR_OP, expr->exthdr.op);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OP, expr->exthdr.op);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
-- 
2.13.6

