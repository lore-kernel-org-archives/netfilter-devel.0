From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 1/2] netfilter: change NF_ASSERT to WARN_ON
Date: Wed, 12 May 2010 09:29:55 -0700
Message-ID: <20100512163030.036777790@vyatta.com>
References: <20100512162954.316178344@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:59575 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab0ELQsF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 May 2010 12:48:05 -0400
Content-Disposition: inline; filename=netfilter-assert.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Change netfilter asserts to standard WARN_ON. This has the
benefit of backtrace info and also causes netfilter errors
to show up on kerneloops.org.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/net/ipv4/netfilter/ip_tables.c	2010-05-11 21:08:46.929331436 -0700
+++ b/net/ipv4/netfilter/ip_tables.c	2010-05-12 08:27:47.444262585 -0700
@@ -51,12 +51,7 @@ MODULE_DESCRIPTION("IPv4 packet filter")
 #endif
 
 #ifdef CONFIG_NETFILTER_DEBUG
-#define IP_NF_ASSERT(x)						\
-do {								\
-	if (!(x))						\
-		printk("IP_NF_ASSERT: %s:%s:%u\n",		\
-		       __func__, __FILE__, __LINE__);	\
-} while(0)
+#define IP_NF_ASSERT(x)		WARN_ON(!(x))
 #else
 #define IP_NF_ASSERT(x)
 #endif
--- a/net/ipv4/netfilter/arp_tables.c	2010-05-11 21:08:47.259329948 -0700
+++ b/net/ipv4/netfilter/arp_tables.c	2010-05-12 08:27:47.514379906 -0700
@@ -49,12 +49,7 @@ MODULE_DESCRIPTION("arptables core");
 #endif
 
 #ifdef CONFIG_NETFILTER_DEBUG
-#define ARP_NF_ASSERT(x)					\
-do {								\
-	if (!(x))						\
-		printk("ARP_NF_ASSERT: %s:%s:%u\n",		\
-		       __func__, __FILE__, __LINE__);	\
-} while(0)
+#define ARP_NF_ASSERT(x)	WARN_ON(!(x))
 #else
 #define ARP_NF_ASSERT(x)
 #endif
--- a/net/ipv6/netfilter/ip6_tables.c	2010-05-11 21:08:35.787720711 -0700
+++ b/net/ipv6/netfilter/ip6_tables.c	2010-05-12 08:27:47.384369744 -0700
@@ -52,12 +52,7 @@ MODULE_DESCRIPTION("IPv6 packet filter")
 #endif
 
 #ifdef CONFIG_NETFILTER_DEBUG
-#define IP_NF_ASSERT(x)						\
-do {								\
-	if (!(x))						\
-		printk("IP_NF_ASSERT: %s:%s:%u\n",		\
-		       __func__, __FILE__, __LINE__);	\
-} while(0)
+#define IP_NF_ASSERT(x)	WARN_ON(!(x))
 #else
 #define IP_NF_ASSERT(x)
 #endif


