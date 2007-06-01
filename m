From: Amin Azez <azez@ufomechanic.net>
Subject: [PATCH] iptables gateway match
Date: Fri, 01 Jun 2007 17:47:07 +0100
Message-ID: <46604D8B.7030507@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060209070908070804010906"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060209070908070804010906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This adds a gateway match to iptables that lets you match against the
routed ipv4 gateway, it's very useful for SNAT if you want to avoid
replicating your routing in your SNAT table.

e.g.

iptables -t nat -A POSTROUTING -m gateway --nexthop 172.16.1.1 -j SNAT
--to-address 172.16.1.5
iptables -t nat -A POSTROUTING -m gateway --nexthop 192.168.1.1 -j SNAT
--to-address 192.168.1.25

to help you choose the right SNAT address.

It works by comparing the to-be-matched gateway IP with the key in the
neighbor table of the next-hop (the key is the layer 3 address).

--gateway 1.2.3.4

only matches if the packet is destined to 1.2.3.4 as a ROUTE, i.e.
1.2.3.4 is not also the target address.

--nexthop 1.2.3.4

matches if the next hop is specified as 1.2.3.4 either as a gateway or
as a final destination.

It can't do magic, and match on non-routed aliases of routers, it only
matches the targeted IP address from which the layer 2 address has been
(or will be) actually derived.

The .gateway-test doesn't work for me because I don't build into my
kernel source dir, but I tried to do it right for a public release.

Signed-of by: Sam Liddicott <azez@ufomechanic.net>

--------------060209070908070804010906
Content-Type: text/x-patch;
 name="gateway.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gateway.patch"

--- /dev/null	2003-01-30 10:24:37.000000000 +0000
+++ extensions/libipt_gateway.c	2007-04-18 09:20:25.000000000 +0100
@@ -0,0 +1,155 @@
+/* Shared library add-on to iptables to add gateway IP address matching support. 
+   Based on iprange
+   (C) UFO Mechanic <azez@ufomechanic.net> */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_gateway.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"gateway match v%s options:\n"
+"[!] --gateway ip        Match IP address of routed gateway\n"
+"\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "gateway", 1, 0, '1' },
+	{ "nexthop", 1, 0, '2' },
+	{0}
+};
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_gateway_info *info = (struct ipt_gateway_info *)(*match)->data;
+	struct in_addr *ip;
+
+	switch (c) {
+	case '1':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				"gateway match: You can't specify `--gateway' and `--nexthop'");
+
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert) {
+			info->flags |= IPT_GATEWAY_INV;
+		}
+
+		ip = dotted_to_addr(optarg);
+		if (!ip)
+			exit_error(PARAMETER_PROBLEM, "gateway match: Bad IP address `%s'\n", 
+					optarg);
+		info->gateway = ip->s_addr;
+		info->flags |= IPT_GATEWAY_ROUTE;
+
+		*flags=1;
+
+		break;
+
+	case '2':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+				"gateway match: You can't specify `--gateway' and `--nexthop'");
+
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert) {
+			info->flags |= IPT_GATEWAY_INV;
+		}
+
+		ip = dotted_to_addr(optarg);
+		if (!ip)
+			exit_error(PARAMETER_PROBLEM, "gateway match: Bad IP address `%s'\n", 
+					optarg);
+		info->gateway = ip->s_addr;
+		info->flags ^= info->flags & IPT_GATEWAY_ROUTE;
+
+		*flags=1;
+
+		break;
+
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+/* Final check; must have specified --gateway */
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			"gateway match: You must specify `--gateway' or `--nexthop'");
+}
+
+/* Prints out the info. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	struct ipt_gateway_info *info = (struct ipt_gateway_info *)match->data;
+	struct in_addr a;
+
+	a.s_addr = info->gateway;
+
+	if (info->flags & IPT_GATEWAY_ROUTE) {
+		printf("gateway ");
+	} else {
+		printf("nexthop ");
+	}
+	if (info->flags & IPT_GATEWAY_INV) printf("! ");
+	printf("%s", addr_to_dotted(&a));
+}
+
+/* Saves the union ipt_info in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	struct ipt_gateway_info *info = (struct ipt_gateway_info *)match->data;
+	struct in_addr a;
+
+	a.s_addr = info->gateway;
+
+	if (info->flags & IPT_GATEWAY_INV)
+		printf("! ");
+	if (info->flags & IPT_GATEWAY_ROUTE) {
+		printf("--gateway ");
+	} else {
+		printf("--nexthop ");
+	}
+	printf("%s ", addr_to_dotted(&a));
+}
+
+static struct iptables_match gateway = { 
+	.next		= NULL,
+	.name		= "gateway",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_gateway_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_gateway_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_match(&gateway);
+}
--- /dev/null	2003-01-30 10:24:37.000000000 +0000
+++ extensions/.gateway-test	2007-06-01 17:24:53.000000000 +0100
@@ -0,0 +1,3 @@
+#!/bin/sh
+# True if gateway match patch is applied.
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_gateway.h ] && echo gateway
--- /dev/null	2003-01-30 10:24:37.000000000 +0000
+++ ./extensions/libipt_gateway.man	2007-06-01 17:27:43.000000000 +0100
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

--------------060209070908070804010906
Content-Type: text/x-patch;
 name="gateway-kernel.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gateway-kernel.patch"

Index: linux-2.6.17.1/include/linux/netfilter_ipv4/ipt_gateway.h
===================================================================
--- /dev/null
+++ linux-2.6.17.1/include/linux/netfilter_ipv4/ipt_gateway.h
@@ -0,0 +1,13 @@
+#ifndef _IPT_GATEWAY_H
+#define _IPT_GATEWAY_H
+
+#define IPT_GATEWAY_INV		0x1	/* Negate the condition */
+#define IPT_GATEWAY_ROUTE	0x2	/* ...and the gateway is not the final hop */
+
+struct ipt_gateway_info {
+	/* Inclusive: network order. */
+	u_int32_t gateway;
+	u_int8_t flags;
+};
+
+#endif /* _IPT_GATEWAY_H */
Index: linux-2.6.17.1/net/ipv4/netfilter/Kconfig
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/Kconfig
+++ linux-2.6.17.1/net/ipv4/netfilter/Kconfig
@@ -361,6 +361,15 @@ config IP_NF_MATCH_IPRANGE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_MATCH_GATEWAY
+	tristate "IP gateway match support"
+	depends on IP_NF_IPTABLES
+	help
+	  This option makes possible to match the IP address of the
+	  routed gateway for routed packets.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_MATCH_TOS
 	tristate "TOS match support"
 	depends on IP_NF_IPTABLES
Index: linux-2.6.17.1/net/ipv4/netfilter/Makefile
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/Makefile
+++ linux-2.6.17.1/net/ipv4/netfilter/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 # matches
 obj-$(CONFIG_IP_NF_MATCH_HASHLIMIT) += ipt_hashlimit.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
+obj-$(CONFIG_IP_NF_MATCH_GATEWAY) += ipt_gateway.o
 obj-$(CONFIG_IP_NF_MATCH_OWNER) += ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
Index: linux-2.6.17.1/net/ipv4/netfilter/ipt_gateway.c
===================================================================
--- /dev/null
+++ linux-2.6.17.1/net/ipv4/netfilter/ipt_gateway.c
@@ -0,0 +1,69 @@
+/*
+ * iptables module to match nexthop router by IP address
+ * (C) 2007 UFO Mechanic <azez@ufomechanic.net>
+ *   to save time and bugs, based on ip_range by
+ *   (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_gateway.h>
+#include <net/dst.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sam Liddicott <azez@ufomechanic.net>");
+MODULE_DESCRIPTION("iptables nexthop gateway IP match module");
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const struct xt_match *match,
+      const void *matchinfo,
+      int offset, unsigned int protoff, int *hotdrop)
+{
+	const struct ipt_gateway_info *info = matchinfo;
+        const struct iphdr *iph = skb->nh.iph;
+
+	return (  !!(info->flags & IPT_GATEWAY_INV) ^
+		( skb && skb->dst && skb->dst->neighbour &&
+		  skb->dst->neighbour->tbl &&
+		  skb->dst->neighbour->tbl->family == AF_INET &&
+		  /* so info->gateway is network bytes order */
+		  memcmp(&info->gateway,
+			&skb->dst->neighbour->primary_key,
+			skb->dst->neighbour->tbl->key_len)==0 &&
+		( (info->flags & IPT_GATEWAY_ROUTE) == 0 || iph->daddr != info->gateway) ) );
+}
+
+static struct ipt_match gateway_match = {
+	.name		= "gateway",
+	.match		= match,
+	.matchsize	= sizeof(struct ipt_gateway_info),
+	.destroy	= NULL,
+	.me		= THIS_MODULE
+};
+
+static int __init ipt_gateway_init(void)
+{
+	return ipt_register_match(&gateway_match);
+}
+
+static void __exit ipt_gateway_fini(void)
+{
+	ipt_unregister_match(&gateway_match);
+}
+
+module_init(ipt_gateway_init);
+module_exit(ipt_gateway_fini);

--------------060209070908070804010906--
