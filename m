From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: NF [PATCH 4/6] Merge ipt_TOS into xt_DSCP
Date: Tue, 27 Nov 2007 00:43:20 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711270043040.22369@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49981 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbXKZXnV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:43:21 -0500
In-Reply-To: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Merge ipt_TOS into xt_DSCP.

Merge ipt_TOS (tos v0 target) into xt_DSCP. They both modify the same
field in the IPv4 header, so it seems reasonable to keep them in one
piece. This is part two of the implicit 4-patch series to move tos to
xtables and extend it by IPv6.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/ipv4/netfilter/Kconfig   |   10 -----
 net/ipv4/netfilter/Makefile  |    1 
 net/ipv4/netfilter/ipt_TOS.c |   82 -------------------------------------------
 net/netfilter/Kconfig        |    6 ++-
 net/netfilter/xt_DSCP.c      |   51 ++++++++++++++++++++++++++
 5 files changed, 56 insertions(+), 94 deletions(-)

Index: linux-2.6/net/ipv4/netfilter/Kconfig
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/Kconfig
+++ linux-2.6/net/ipv4/netfilter/Kconfig
@@ -293,16 +293,6 @@ config IP_NF_MANGLE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_TARGET_TOS
-	tristate "TOS target support"
-	depends on IP_NF_MANGLE
-	help
-	  This option adds a `TOS' target, which allows you to create rules in
-	  the `mangle' table which alter the Type Of Service field of an IP
-	  packet prior to routing.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_TARGET_ECN
 	tristate "ECN target support"
 	depends on IP_NF_MANGLE
Index: linux-2.6/net/ipv4/netfilter/Makefile
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/Makefile
+++ linux-2.6/net/ipv4/netfilter/Makefile
@@ -57,7 +57,6 @@ obj-$(CONFIG_IP_NF_TARGET_NETMAP) += ipt
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT.o
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_SAME) += ipt_SAME.o
-obj-$(CONFIG_IP_NF_TARGET_TOS) += ipt_TOS.o
 obj-$(CONFIG_IP_NF_TARGET_TTL) += ipt_TTL.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 
Index: linux-2.6/net/ipv4/netfilter/ipt_TOS.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ipt_TOS.c
+++ /dev/null
@@ -1,82 +0,0 @@
-/* This is a module which is used for setting the TOS field of a packet. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <net/checksum.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_TOS.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("iptables TOS mangling module");
-
-static unsigned int
-tos_tg(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
-{
-	const struct ipt_tos_target_info *tosinfo = targinfo;
-	struct iphdr *iph = ip_hdr(skb);
-
-	if ((iph->tos & IPTOS_TOS_MASK) != tosinfo->tos) {
-		__u8 oldtos;
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-		iph = ip_hdr(skb);
-		oldtos = iph->tos;
-		iph->tos = (iph->tos & IPTOS_PREC_MASK) | tosinfo->tos;
-		nf_csum_replace2(&iph->check, htons(oldtos), htons(iph->tos));
-	}
-	return XT_CONTINUE;
-}
-
-static bool
-tos_tg_check(const char *tablename, const void *e_void,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
-{
-	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
-
-	if (tos != IPTOS_LOWDELAY
-	    && tos != IPTOS_THROUGHPUT
-	    && tos != IPTOS_RELIABILITY
-	    && tos != IPTOS_MINCOST
-	    && tos != IPTOS_NORMALSVC) {
-		printk(KERN_WARNING "TOS: bad tos value %#x\n", tos);
-		return false;
-	}
-	return true;
-}
-
-static struct xt_target tos_tg_reg __read_mostly = {
-	.name		= "TOS",
-	.family		= AF_INET,
-	.target		= tos_tg,
-	.targetsize	= sizeof(struct ipt_tos_target_info),
-	.table		= "mangle",
-	.checkentry	= tos_tg_check,
-	.me		= THIS_MODULE,
-};
-
-static int __init tos_tg_init(void)
-{
-	return xt_register_target(&tos_tg_reg);
-}
-
-static void __exit tos_tg_exit(void)
-{
-	xt_unregister_target(&tos_tg_reg);
-}
-
-module_init(tos_tg_init);
-module_exit(tos_tg_exit);
Index: linux-2.6/net/netfilter/Kconfig
===================================================================
--- linux-2.6.orig/net/netfilter/Kconfig
+++ linux-2.6/net/netfilter/Kconfig
@@ -293,7 +293,7 @@ config NETFILTER_XT_TARGET_CONNMARK
 	  ipt_CONNMARK.ko.  If unsure, say `N'.
 
 config NETFILTER_XT_TARGET_DSCP
-	tristate '"DSCP" target support'
+	tristate '"DSCP" and "TOS" target support'
 	depends on NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
 	help
@@ -302,6 +302,10 @@ config NETFILTER_XT_TARGET_DSCP
 
 	  The DSCP field can have any value between 0x0 and 0x3f inclusive.
 
+	  It also adds the "TOS" target, which allows you to create rules in
+	  the "mangle" table which alter the Type Of Service field of an IPv4
+	  packet prior to routing.
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_MARK
Index: linux-2.6/net/netfilter/xt_DSCP.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_DSCP.c
+++ linux-2.6/net/netfilter/xt_DSCP.c
@@ -18,12 +18,14 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_DSCP.h>
+#include <linux/netfilter_ipv4/ipt_TOS.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("x_tables DSCP modification module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_DSCP");
 MODULE_ALIAS("ip6t_DSCP");
+MODULE_ALIAS("ipt_TOS");
 
 static unsigned int
 dscp_tg(struct sk_buff *skb, const struct net_device *in,
@@ -76,6 +78,45 @@ dscp_tg_check(const char *tablename, con
 	return true;
 }
 
+static unsigned int
+tos_tg_v0(struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, unsigned int hooknum,
+          const struct xt_target *target, const void *targinfo)
+{
+	const struct ipt_tos_target_info *info = targinfo;
+	struct iphdr *iph = ip_hdr(skb);
+	u_int8_t oldtos;
+
+	if ((iph->tos & IPTOS_TOS_MASK) != info->tos) {
+		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+
+		iph      = ip_hdr(skb);
+		oldtos   = iph->tos;
+		iph->tos = (iph->tos & IPTOS_PREC_MASK) | info->tos;
+		nf_csum_replace2(&iph->check, htons(oldtos), htons(iph->tos));
+	}
+
+	return XT_CONTINUE;
+}
+
+static bool
+tos_tg_check_v0(const char *tablename, const void *e_void,
+                const struct xt_target *target, void *targinfo,
+                unsigned int hook_mask)
+{
+	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
+
+	if (tos != IPTOS_LOWDELAY && tos != IPTOS_THROUGHPUT &&
+	    tos != IPTOS_RELIABILITY && tos != IPTOS_MINCOST &&
+	    tos != IPTOS_NORMALSVC) {
+		printk(KERN_WARNING "TOS: bad tos value %#x\n", tos);
+		return false;
+	}
+
+	return true;
+}
+
 static struct xt_target dscp_tg_reg[] __read_mostly = {
 	{
 		.name		= "DSCP",
@@ -95,6 +136,16 @@ static struct xt_target dscp_tg_reg[] __
 		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
+	{
+		.name       = "TOS",
+		.revision   = 0,
+		.family     = AF_INET,
+		.table      = "mangle",
+		.target     = tos_tg_v0,
+		.targetsize = sizeof(struct ipt_tos_target_info),
+		.checkentry = tos_tg_check_v0,
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init dscp_tg_init(void)
