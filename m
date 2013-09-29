From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 1/2] fix IPv6 prefix computation.
Date: Sun, 29 Sep 2013 11:53:28 +0200
Message-ID: <1380448409-19583-2-git-send-email-eric@regit.org>
References: <1380448409-19583-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50857 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3I2Jxt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Sep 2013 05:53:49 -0400
In-Reply-To: <1380448409-19583-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The prefix building algorithm in netlink phase was incorrect in
IPv6.

For example, when adding the following rule
 nft add rule ip6 nat postrouting ip6 saddr 2::/64 --debug=all

we had:

 ip6 nat postrouting 0 0
  [ payload load 16b @ network header + 8 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00000000 0x99361540 0x00007f8d 0x2e33a1eb ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
  [ cmp eq reg 1 0x00000200 0x00000000 0x00000000 0x00000000 ]

With the patch the result is as expected:

 ip6 nat postrouting 0 0
  [ payload load 16b @ network header + 8 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0xffffffff 0xffffffff 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
  [ cmp eq reg 1 0x00000200 0x00000000 0x00000000 0x00000000 ]

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/netlink.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index c48e667..b1e44ad 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -234,7 +234,8 @@ static void netlink_gen_verdict(const struct expr *expr,
 static void netlink_gen_prefix(const struct expr *expr,
 			       struct nft_data_linearize *data)
 {
-	uint32_t i, cidr, idx;
+	uint32_t idx;
+	int32_t i, cidr;
 	uint32_t mask;
 
 	assert(expr->ops->type == EXPR_PREFIX);
@@ -242,11 +243,13 @@ static void netlink_gen_prefix(const struct expr *expr,
 	data->len = div_round_up(expr->prefix->len, BITS_PER_BYTE);
 	cidr = expr->prefix_len;
 
-	for (i = 0; i < data->len; i+= 32) {
+	for (i = 0; (uint32_t)i / BITS_PER_BYTE < data->len; i += 32) {
 		if (cidr - i >= 32)
-			mask = 0;
+			mask = 0xffffffff;
+		else if (cidr - i > 0)
+			mask = (1 << (cidr - i)) - 1;
 		else
-			mask = (1 << cidr) - 1;
+			mask = 0;
 
 		idx = i / 32;
 		data->value[idx] = mask;
-- 
1.8.4.rc3

