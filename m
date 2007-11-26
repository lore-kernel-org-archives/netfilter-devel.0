From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: NF [PATCH 3/6] (re) Merge ipt_tos into xt_dscp
Date: Tue, 27 Nov 2007 00:54:39 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711270054130.22369@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711270042410.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51475 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbXKZXyk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:54:40 -0500
In-Reply-To: <Pine.LNX.4.64.0711270042410.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Merge ipt_tos into xt_dscp.

Merge ipt_tos (tos v0 match) into xt_dscp. They both modify the same
field in the IPv4 header, so it seems reasonable to keep them in one
piece. This is part one of the implicit 4-patch series to move tos to
xtables and extend it by IPv6.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/ipv4/netfilter/Kconfig   |    9 -------
 net/ipv4/netfilter/Makefile  |    1 
 net/ipv4/netfilter/ipt_tos.c |   50 -------------------------------------------
 net/netfilter/Kconfig        |    6 ++++-
 net/netfilter/xt_dscp.c      |   24 ++++++++++++++++++--
 5 files changed, 27 insertions(+), 63 deletions(-)

Index: linux-2.6/net/ipv4/netfilter/Kconfig
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/Kconfig
+++ linux-2.6/net/ipv4/netfilter/Kconfig
@@ -63,15 +63,6 @@ config IP_NF_MATCH_IPRANGE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_MATCH_TOS
-	tristate "TOS match support"
-	depends on IP_NF_IPTABLES
-	help
-	  TOS matching allows you to match packets based on the Type Of
-	  Service fields of the IP packet.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_RECENT
 	tristate '"recent" match support'
 	depends on IP_NF_IPTABLES
Index: linux-2.6/net/ipv4/netfilter/Makefile
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/Makefile
+++ linux-2.6/net/ipv4/netfilter/Makefile
@@ -46,7 +46,6 @@ obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
-obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 
 # targets
Index: linux-2.6/net/ipv4/netfilter/ipt_tos.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ipt_tos.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/* Kernel module to match TOS values. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/ip.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-
-#include <linux/netfilter_ipv4/ipt_tos.h>
-#include <linux/netfilter/x_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("iptables TOS match module");
-
-static bool
-tos_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
-{
-	const struct ipt_tos_info *info = matchinfo;
-
-	return (ip_hdr(skb)->tos == info->tos) ^ info->invert;
-}
-
-static struct xt_match tos_mt_reg __read_mostly = {
-	.name		= "tos",
-	.family		= AF_INET,
-	.match		= tos_mt,
-	.matchsize	= sizeof(struct ipt_tos_info),
-	.me		= THIS_MODULE,
-};
-
-static int __init tos_mt_init(void)
-{
-	return xt_register_match(&tos_mt_reg);
-}
-
-static void __exit tos_mt_exit(void)
-{
-	xt_unregister_match(&tos_mt_reg);
-}
-
-module_init(tos_mt_init);
-module_exit(tos_mt_exit);
Index: linux-2.6/net/netfilter/Kconfig
===================================================================
--- linux-2.6.orig/net/netfilter/Kconfig
+++ linux-2.6/net/netfilter/Kconfig
@@ -479,7 +479,7 @@ config NETFILTER_XT_MATCH_DCCP
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_DSCP
-	tristate '"dscp" match support'
+	tristate '"dscp" and "tos" match support'
 	depends on NETFILTER_XTABLES
 	help
 	  This option adds a `DSCP' match, which allows you to match against
@@ -487,6 +487,10 @@ config NETFILTER_XT_MATCH_DSCP
 
 	  The DSCP field can have any value between 0x0 and 0x3f inclusive.
 
+	  It will also add a "tos" match, which allows you to match packets
+	  based on the Type Of Service fields of the IPv4 packet (which share
+	  the same bits as DSCP).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_ESP
Index: linux-2.6/net/netfilter/xt_dscp.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_dscp.c
+++ linux-2.6/net/netfilter/xt_dscp.c
@@ -13,14 +13,16 @@
 #include <linux/ipv6.h>
 #include <net/dsfield.h>
 
-#include <linux/netfilter/xt_dscp.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_dscp.h>
+#include <linux/netfilter_ipv4/ipt_tos.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("x_tables DSCP matching module");
+MODULE_DESCRIPTION("x_tables DSCP/tos matching module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_dscp");
 MODULE_ALIAS("ip6t_dscp");
+MODULE_ALIAS("ipt_tos");
 
 static bool
 dscp_mt(const struct sk_buff *skb, const struct net_device *in,
@@ -60,6 +62,16 @@ dscp_mt_check(const char *tablename, con
 	return true;
 }
 
+static bool tos_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+                      const struct net_device *out,
+                      const struct xt_match *match, const void *matchinfo,
+                      int offset, unsigned int protoff, bool *hotdrop)
+{
+	const struct ipt_tos_info *info = matchinfo;
+
+	return (ip_hdr(skb)->tos == info->tos) ^ info->invert;
+}
+
 static struct xt_match dscp_mt_reg[] __read_mostly = {
 	{
 		.name		= "dscp",
@@ -77,6 +89,14 @@ static struct xt_match dscp_mt_reg[] __r
 		.matchsize	= sizeof(struct xt_dscp_info),
 		.me		= THIS_MODULE,
 	},
+	{
+		.name      = "tos",
+		.revision  = 0,
+		.family    = AF_INET,
+		.match     = tos_mt_v0,
+		.matchsize = sizeof(struct ipt_tos_info),
+		.me        = THIS_MODULE,
+	},
 };
 
 static int __init dscp_mt_init(void)
