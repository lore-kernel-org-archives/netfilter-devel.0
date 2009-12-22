From: akpm@linux-foundation.org
Subject: [patch 1/1] net/netfilter/ipvs/ip_vs_wrr.c: use lib/gcd.c
Date: Mon, 21 Dec 2009 16:37:23 -0800
Message-ID: <200912220037.nBM0bNBZ005989@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, akpm@linux-foundation.org,
	florian@openwrt.org, davem@davemloft.net, horms@verge.net.au,
	juliusv@google.com, sshtylyov@ru.mvista.com, tiwai@suse.de
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbZLVAib (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:38:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Fainelli <florian@openwrt.org>

Remove the private version of the greatest common divider to use
lib/gcd.c, the latter also implementing the a < b case.

[akpm@linux-foundation.org: repair neighboring whitespace because the diff looked odd]
Signed-off-by: Florian Fainelli <florian@openwrt.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Takashi Iwai <tiwai@suse.de>
Acked-by: Simon Horman <horms@verge.net.au>
Cc: Julius Volz <juliusv@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/ipvs/Kconfig     |    3 ++-
 net/netfilter/ipvs/ip_vs_wrr.c |   15 +--------------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff -puN net/netfilter/ipvs/Kconfig~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc net/netfilter/ipvs/Kconfig
--- a/net/netfilter/ipvs/Kconfig~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc
+++ a/net/netfilter/ipvs/Kconfig
@@ -112,7 +112,8 @@ config	IP_VS_RR
 	  module, choose M here. If unsure, say N.
  
 config	IP_VS_WRR
-        tristate "weighted round-robin scheduling" 
+	tristate "weighted round-robin scheduling"
+	select GCD
 	---help---
 	  The weighted robin-robin scheduling algorithm directs network
 	  connections to different real servers based on server weights
diff -puN net/netfilter/ipvs/ip_vs_wrr.c~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc net/netfilter/ipvs/ip_vs_wrr.c
--- a/net/netfilter/ipvs/ip_vs_wrr.c~net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc
+++ a/net/netfilter/ipvs/ip_vs_wrr.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/net.h>
+#include <linux/gcd.h>
 
 #include <net/ip_vs.h>
 
@@ -38,20 +39,6 @@ struct ip_vs_wrr_mark {
 };
 
 
-/*
- *    Get the gcd of server weights
- */
-static int gcd(int a, int b)
-{
-	int c;
-
-	while ((c = a % b)) {
-		a = b;
-		b = c;
-	}
-	return b;
-}
-
 static int ip_vs_wrr_gcd_weight(struct ip_vs_service *svc)
 {
 	struct ip_vs_dest *dest;
_
