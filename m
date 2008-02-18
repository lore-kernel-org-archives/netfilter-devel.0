From: Pavel Emelyanov <xemul@openvz.org>
Subject: [PATCH][NETFILTER]: Drop the actually unused variable from u32_match_it.
Date: Mon, 18 Feb 2008 18:29:50 +0300
Message-ID: <47B9A46E.5090608@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sacred.ru ([62.205.161.221]:55310 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYBRP3w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:29:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The int ret variable is used only to trigger the BUG_ON() after 
the skb_copy_bits() call, so check the call failure directly 
and drop the variable.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

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
