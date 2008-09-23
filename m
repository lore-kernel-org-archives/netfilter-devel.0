From: Bryan Duff <bduff@astrocorp.com>
Subject: Kernel netfilter and iptables gateway extension patch
Date: Tue, 23 Sep 2008 08:32:56 -0500
Message-ID: <48D8F008.7040602@astrocorp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090806060103020404020100"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([64.122.215.18]:21593 "EHLO
	mail.astrocorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbYIWNxE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:53:04 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.astrocorp.com (Postfix) with ESMTP id 2D014630FC
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 08:31:36 -0500 (CDT)
Received: from mail.astrocorp.com ([127.0.0.1])
	by localhost (mail.astrocorp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n0iOOJI7zmwX for <netfilter-devel@vger.kernel.org>;
	Tue, 23 Sep 2008 08:31:27 -0500 (CDT)
Received: from Win2003.astrocorp.com (unknown [192.168.1.146])
	by mail.astrocorp.com (Postfix) with ESMTP id C4111630BE
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 08:31:27 -0500 (CDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090806060103020404020100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From the manpage:

+This matches the gateway by IP address on routed packets.
+It does not match packets that are not routed, or which
+are directly addresses to the gateway.

With this patch it doesn't work quite like that.  It now matches packets 
that are "directly addresses to the gateway".  Because frankly, why 
not?  Otherwise those addresses are missed, and it requires more rules.  
It also changes the iptables interface to allow the specifying of a mask 
on the cli.

//e.g. (assume my interface is 192.168.1.100, gateway 192.168.1.1):
iptables -t mangle -A POSTROUTING -o eth0 -m gateway --gateway 
192.168.1.1/24
//end e.g.

Now any packets routed out eth0 to gateway 192.168.1.1 (or anything on 
that subnet - if I send to 192.168.1.2 - then that is the gateway, and 
also matches).  This is most useful for multi-homed ports.  The gateway 
and nexthop options do the same thing.

I'm not sure if this is useful to anyone but me.  I can clean up the 
patches (fix the man page and whatever else).

Thanks.

-Bryan Duff
bduff@astrocorp.com

--------------090806060103020404020100
Content-Type: text/plain;
 name="iptables-1.4.0-gateway.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="iptables-1.4.0-gateway.patch"

---
 extensions/.gateway-test      |    3 
 extensions/libipt_gateway.c   |  157 ++++++++++++++++++++++++++++++++++++++++++
 extensions/libipt_gateway.man |    9 ++
 3 files changed, 169 insertions(+)
Index: iptables/extensions/.gateway-test
===================================================================
--- /dev/null
+++ iptables/extensions/.gateway-test
@@ -0,0 +1,3 @@
+#!/bin/sh
+# True if gateway match patch is applied.
+[ -f "$KERNEL_DIR/include/linux/netfilter/xt_gateway.h" ] && echo gateway
Index: iptables/extensions/libipt_gateway.c
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_gateway.c
@@ -0,0 +1,157 @@
+/*
+ * Shared library add-on to iptables to add gateway IP address matching support.
+ * Based on iprange
+ * (C) UFO Mechanic <azez@ufomechanic.net>
+ * © Jan Engelhardt <jengelh@gmx.de>, 2007
+ */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <linux/netfilter/xt_gateway.h>
+
+/* Function which prints out usage message. */
+static void help(void)
+{
+	printf(
+"gateway match v%s options:\n"
+"[!] --gateway ip        Match IP address of routed gateway\n"
+"[!] --nexthop ip        Match IP address of next hop\n"
+"\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{"gateway", 1, NULL, '1'},
+	{"nexthop", 1, NULL, '2'},
+	{NULL},
+};
+
+/*
+ * Function which parses command options;
+ * returns true if it ate an option.
+ */
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		 const void *entry,
+		 struct xt_entry_match **match)
+{
+	struct xt_gateway_info *info = (void *)(*match)->data;
+	struct in_addr *ip;
+
+	switch (c) {
+	case '1':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM, "gateway match: You "
+				"cannot specify both \"--gateway\" and "
+				"\"--nexthop\"");
+
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->flags |= XT_GATEWAY_INV;
+
+		ip = dotted_to_addr(optarg);
+		if (!ip)
+			exit_error(PARAMETER_PROBLEM, "gateway match: Bad IP "
+				"address \"%s\"\n", optarg);
+
+		info->gateway = ip->s_addr;
+		info->flags  |= XT_GATEWAY_ROUTE;
+		*flags = 1;
+		break;
+
+	case '2':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM, "gateway match: You "
+				"cannot specify both \"--gateway\" and "
+				"\"--nexthop\"");
+
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->flags |= XT_GATEWAY_INV;
+
+		ip = dotted_to_addr(optarg);
+		if (!ip)
+			exit_error(PARAMETER_PROBLEM,
+				"gateway match: Bad IP address `%s'\n", optarg);
+
+		info->gateway = ip->s_addr;
+		info->flags  &= XT_GATEWAY_ROUTE;
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Final check; must have specified --gateway */
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			"gateway match: You must specify `--gateway' "
+			"or `--nexthop'");
+}
+
+/* Prints out the info. */
+static void print(const void *ip, const struct xt_entry_match *match,
+		  int numeric)
+{
+	const struct xt_gateway_info *info = (const void *)match->data;
+	struct in_addr a;
+
+	a.s_addr = info->gateway;
+
+	if (info->flags & XT_GATEWAY_ROUTE)
+		printf("gateway ");
+	else
+		printf("nexthop ");
+
+	if (info->flags & XT_GATEWAY_INV)
+		printf("! ");
+
+	printf("%s", addr_to_dotted(&a));
+}
+
+/* Saves the union ipt_info in parsable form to stdout. */
+static void save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_gateway_info *info = (const void *)match->data;
+	struct in_addr a;
+
+	a.s_addr = info->gateway;
+
+	if (info->flags & XT_GATEWAY_INV)
+		printf("! ");
+
+	if (info->flags & XT_GATEWAY_ROUTE)
+		printf("--gateway ");
+	else
+		printf("--nexthop ");
+
+	printf("%s ", addr_to_dotted(&a));
+}
+
+static struct iptables_match gateway = {
+	.next		= NULL,
+	.name		= "gateway",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct xt_gateway_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct xt_gateway_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static __attribute__((constructor)) void _init(void)
+{
+	register_match(&gateway);
+}
Index: iptables/extensions/libipt_gateway.man
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_gateway.man
@@ -0,0 +1,9 @@
+This matches the gateway by IP address on routed packets.
+It does not mach packets that are not routed, or which
+are directly addresses to the gateway.
+.TP
+.BI "[!]" "--gateway " "ip"
+Check that the packet is routed to a gateway with the specified ip address.
+.BI "[!]" "--nexthop " "ip"
+Check if the packet is being directed to the specified ip address
+either directly or as a route.
-
Index: iptables/extensions/Makefile
===================================================================
--- iptables/extensions/Makefile
+++ iptables/extensions/Makefile
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
+PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG gateway
 PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
 PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
 

--------------090806060103020404020100
Content-Type: text/plain;
 name="kernel-2.6.24-gateway.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="kernel-2.6.24-gateway.patch"

diff -Naur linux-2.6.24-gentoo-r3/include/linux/netfilter/xt_gateway.h linux-2.6.24-gentoo-r3-NEW/include/linux/netfilter/xt_gateway.h
--- linux-2.6.24-gentoo-r3/include/linux/netfilter/xt_gateway.h	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.24-gentoo-r3-NEW/include/linux/netfilter/xt_gateway.h	2008-08-01 17:57:21.000000000 +0000
@@ -0,0 +1,14 @@
+#ifndef _XT_GATEWAY_H
+#define _XT_GATEWAY_H
+
+#define XT_GATEWAY_INV		0x1	/* Negate the condition */
+#define XT_GATEWAY_ROUTE	0x2	/* ...and the gateway is not the final hop */
+
+struct xt_gateway_info {
+	/* Inclusive: network order. */
+	uint32_t gateway;
+	uint32_t mask;
+	uint8_t flags;
+};
+
+#endif /* _XT_GATEWAY_H */
diff -Naur linux-2.6.24-gentoo-r3/net/netfilter/Kconfig linux-2.6.24-gentoo-r3-NEW/net/netfilter/Kconfig
--- linux-2.6.24-gentoo-r3/net/netfilter/Kconfig	2008-08-01 17:46:49.000000000 +0000
+++ linux-2.6.24-gentoo-r3-NEW/net/netfilter/Kconfig	2008-08-01 17:55:18.000000000 +0000
@@ -498,6 +498,15 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_GATEWAY
+	tristate '"gateway" match support'
+	depends on NETFILTER_XTABLES
+	---help---
+	  This option makes possible to match the IP address of the
+	  routed gateway for routed packets.
+
+	  To compile it as a module, choose M here. If unsure, say N.
+
 config NETFILTER_XT_MATCH_HELPER
 	tristate '"helper" match support'
 	depends on NETFILTER_XTABLES
diff -Naur linux-2.6.24-gentoo-r3/net/netfilter/Makefile linux-2.6.24-gentoo-r3-NEW/net/netfilter/Makefile
--- linux-2.6.24-gentoo-r3/net/netfilter/Makefile	2008-08-01 17:46:49.000000000 +0000
+++ linux-2.6.24-gentoo-r3-NEW/net/netfilter/Makefile	2008-08-01 17:56:05.000000000 +0000
@@ -59,6 +59,7 @@
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_GATEWAY) += xt_gateway.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) += xt_length.o
diff -Naur linux-2.6.24-gentoo-r3/net/netfilter/xt_gateway.c linux-2.6.24-gentoo-r3-NEW/net/netfilter/xt_gateway.c
--- linux-2.6.24-gentoo-r3/net/netfilter/xt_gateway.c	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.24-gentoo-r3-NEW/net/netfilter/xt_gateway.c	2008-08-01 17:57:21.000000000 +0000
@@ -0,0 +1,84 @@
+/*
+ * netfilter module to match nexthop router by IP address
+ * (C) 2007 UFO Mechanic <azez@ufomechanic.net>
+ * © Jan Engelhardt <jengelh@gmx.de>, 2007
+ *   to save time and bugs, based on ip_range by
+ *   (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_gateway.h>
+#include <net/dst.h>
+#include <net/neighbour.h>
+
+static int xt_gateway_match1(const struct sk_buff *skb,
+			     const struct xt_gateway_info *info)
+{
+        const struct iphdr *iph;
+	const struct dst_entry *dst;
+	const struct neighbour *neigh;
+	const struct neigh_table *tbl;
+
+	if (skb == NULL) /* necessary? */
+		return false;
+	if ((dst = skb->dst) == NULL)
+		return false;
+	if ((neigh = dst->neighbour) == NULL)
+		return false;
+	if ((tbl = neigh->tbl) == NULL)
+		return false;
+	if (tbl->family != AF_INET)
+		return false;
+	if (memcmp(&info->gateway, &neigh->primary_key, tbl->key_len) == 0) {
+		return true;
+	}
+	iph = ip_hdr(skb);
+	if ((iph->daddr & info->mask) == (info->gateway & info->mask)) {
+		return true;
+	}
+	return false;
+}
+
+static int xt_gateway_match(const struct sk_buff *skb,
+			    const struct net_device *in,
+			    const struct net_device *out,
+			    const struct xt_match *match,
+			    const void *matchinfo, int offset,
+			    unsigned int protoff, int *hotdrop)
+{
+	const struct xt_gateway_info *info = matchinfo;
+	return !!(info->flags & XT_GATEWAY_INV) ^
+	       xt_gateway_match1(skb, info);
+}
+
+static struct xt_match xt_gateway_reg = {
+	.name      = "gateway",
+	.family    = AF_INET,
+	.match     = xt_gateway_match,
+	.matchsize = sizeof(struct xt_gateway_info),
+	.me        = THIS_MODULE
+};
+
+static int __init xt_gateway_init(void)
+{
+	return xt_register_match(&xt_gateway_reg);
+}
+
+static void __exit xt_gateway_exit(void)
+{
+	xt_unregister_match(&xt_gateway_reg);
+	return;
+}
+
+module_init(xt_gateway_init);
+module_exit(xt_gateway_exit);
+MODULE_AUTHOR("Sam Liddicott <azez@ufomechanic.net>");
+MODULE_DESCRIPTION("netfilter nexthop gateway match module");
+MODULE_LICENSE("GPL");

--------------090806060103020404020100--
