From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink_linearize: fix wrong comparison in netlink_gen_flagcmp()
Date: Sun, 16 Feb 2014 23:42:02 +0100
Message-ID: <1392590522-4170-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48712 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaBPWmK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 17:42:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 nft add rule filter input ct state established,related counter drop

is not matching here due to a wrong comparison in the rule:

 ip filter input 20 19
   [ ct load state => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000006 ] <----- this has to be zero
   [ counter pkts 0 bytes 0 ]
   [ immediate reg 0 drop ]

There's a line that generates the value from the right-hand
expression which was not in the original code. This bug was
introduced in aae836a ("src: use libnftables").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_linearize.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 332383a..3e9a078 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -285,7 +285,6 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 	netlink_gen_raw_data(zero, expr->right->byteorder, len, &nld);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP, NFT_CMP_NEQ);
-	netlink_gen_data(expr->right, &nld);
 	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
 	nft_rule_add_expr(ctx->nlr, nle);
 
-- 
1.7.10.4

