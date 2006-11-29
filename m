From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH] netfilter: remove broken macro
Date: Thu, 30 Nov 2006 00:37:41 +0100
Message-ID: <200611300037.41404.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S967683AbWK2Xii@vger.kernel.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

	This patch removes broken and unused macro.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 net/ipv4/netfilter/ip_nat_standalone.c |    6 ------
 1 file changed, 6 deletions(-)

--- linux-2.6.19-rc6-mm2-a/net/ipv4/netfilter/ip_nat_standalone.c	2006-11-16 05:03:40.000000000 +0100
+++ linux-2.6.19-rc6-mm2-b/net/ipv4/netfilter/ip_nat_standalone.c	2006-11-29 15:31:37.000000000 +0100
@@ -44,12 +44,6 @@
 #define DEBUGP(format, args...)
 #endif
 
-#define HOOKNAME(hooknum) ((hooknum) == NF_IP_POST_ROUTING ? "POST_ROUTING"  \
-			   : ((hooknum) == NF_IP_PRE_ROUTING ? "PRE_ROUTING" \
-			      : ((hooknum) == NF_IP_LOCAL_OUT ? "LOCAL_OUT"  \
-			         : ((hooknum) == NF_IP_LOCAL_IN ? "LOCAL_IN"  \
-				    : "*ERROR*")))
-
 #ifdef CONFIG_XFRM
 static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 {


-- 
Regards,

	Mariusz Kozlowski
