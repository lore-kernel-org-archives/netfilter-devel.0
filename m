From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/07]: xt_u32: drop the actually unused variable from u32_match_it
Date: Tue, 19 Feb 2008 17:25:47 +0100 (MET)
Message-ID: <20080219162534.13631.58525.sendpatchset@localhost.localdomain>
References: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50465 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYBSQZs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:25:48 -0500
In-Reply-To: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_u32: drop the actually unused variable from u32_match_it

The int ret variable is used only to trigger the BUG_ON() after
the skb_copy_bits() call, so check the call failure directly
and drop the variable.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 30c709c51fa0f400859890d534cfa02eb8d06cc7
tree 6df1f3fd873cae02ae066e2a76bafd1ef32e055a
parent 2292fd9623ce0391217dfe8cec57f70fd90da538
author Pavel Emelyanov <xemul@openvz.org> Tue, 19 Feb 2008 17:15:26 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 19 Feb 2008 17:15:26 +0100

 net/netfilter/xt_u32.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 9b8ed39..627e0f3 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -26,7 +26,6 @@ static bool u32_match_it(const struct xt_u32 *data,
 	u_int32_t pos;
 	u_int32_t val;
 	u_int32_t at;
-	int ret;
 
 	/*
 	 * Small example: "0 >> 28 == 4 && 8 & 0xFF0000 >> 16 = 6, 17"
@@ -40,8 +39,8 @@ static bool u32_match_it(const struct xt_u32 *data,
 		if (skb->len < 4 || pos > skb->len - 4)
 			return false;
 
-		ret   = skb_copy_bits(skb, pos, &n, sizeof(n));
-		BUG_ON(ret < 0);
+		if (skb_copy_bits(skb, pos, &n, sizeof(n)) < 0)
+			BUG();
 		val   = ntohl(n);
 		nnums = ct->nnums;
 
@@ -67,9 +66,9 @@ static bool u32_match_it(const struct xt_u32 *data,
 				    pos > skb->len - at - 4)
 					return false;
 
-				ret = skb_copy_bits(skb, at + pos, &n,
-						    sizeof(n));
-				BUG_ON(ret < 0);
+				if (skb_copy_bits(skb, at + pos, &n,
+						    sizeof(n)) < 0)
+					BUG();
 				val = ntohl(n);
 				break;
 			}
