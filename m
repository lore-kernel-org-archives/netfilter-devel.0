From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: xt_gateway 20070605 (kernel)
Date: Tue, 5 Jun 2007 13:17:57 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706051317440.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706051317150.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706051317150.20829@yvahk01.tjqt.qr>
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


Originally from Amin Azez <azez@ufomechanic.net>,
http://lists.netfilter.org/pipermail/netfilter-devel/2007-June/027954.html

This adds a gateway match to iptables that lets you match against the
routed ipv4 gateway, it's very useful for SNAT if you want to avoid
replicating your routing in your SNAT table.

e.g.

	iptables -t nat -A POSTROUTING -m gateway --nexthop 172.16.1.1 \
		-j SNAT --to-address 172.16.1.5
	iptables -t nat -A POSTROUTING -m gateway --nexthop 192.168.1.1 \
		-j SNAT --to-address 192.168.1.25

to help you choose the right SNAT address.

It works by comparing the to-be-matched gateway IP with the key in the
neighbor table of the next-hop (the key is the layer 3 address).

	--gateway 1.2.3.4

only matches if the packet is destined to 1.2.3.4 as a ROUTE, i.e.
1.2.3.4 is not also the target address.

	--nexthop 1.2.3.4

matches if the next hop is specified as 1.2.3.4 either as a gateway or
as a final destination.

It cannot do magic, and match on non-routed aliases of routers, it only
matches the targeted IP address from which the layer 2 address has been
(or will be) actually derived.


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
[Posted to LKML/NF-DEV on 2007-06-02, 2007-06-05]

---
 include/linux/netfilter/xt_gateway.h |   13 +++++
 net/netfilter/Kconfig                |    9 +++
 net/netfilter/Makefile               |    1 
 net/netfilter/xt_gateway.c           |   86 +++++++++++++++++++++++++++++++++++
 4 files changed, 109 insertions(+)

Index: linux-2.6.22-rc4/include/linux/netfilter/xt_gateway.h
===================================================================
--- /dev/null
+++ linux-2.6.22-rc4/include/linux/netfilter/xt_gateway.h
@@ -0,0 +1,13 @@
+#ifndef _XT_GATEWAY_H
+#define _XT_GATEWAY_H
+
+#define XT_GATEWAY_INV		0x1	/* Negate the condition */
+#define XT_GATEWAY_ROUTE	0x2	/* ...and the gateway is not the final hop */
+
+struct xt_gateway_info {
+	/* Inclusive: network order. */
+	uint32_t gateway;
+	uint8_t flags;
+};
+
+#endif /* _XT_GATEWAY_H */
Index: linux-2.6.22-rc4/net/netfilter/Kconfig
===================================================================
--- linux-2.6.22-rc4.orig/net/netfilter/Kconfig
+++ linux-2.6.22-rc4/net/netfilter/Kconfig
@@ -475,6 +475,15 @@ config NETFILTER_XT_MATCH_ESP
 
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
Index: linux-2.6.22-rc4/net/netfilter/Makefile
===================================================================
--- linux-2.6.22-rc4.orig/net/netfilter/Makefile
+++ linux-2.6.22-rc4/net/netfilter/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRAC
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_GATEWAY) += xt_gateway.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) += xt_length.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) += xt_limit.o
Index: linux-2.6.22-rc4/net/netfilter/xt_gateway.c
===================================================================
--- /dev/null
+++ linux-2.6.22-rc4/net/netfilter/xt_gateway.c
@@ -0,0 +1,86 @@
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
+static bool xt_gateway_match_it(const struct sk_buff *skb,
+				const struct xt_gateway_info *info)
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
+	if (memcmp(&info->gateway, &neigh->primary_key, tbl->key_len) != 0)
+		return false;
+	if (!(info->flags & XT_GATEWAY_ROUTE))
+		return true;
+	iph = ip_hdr(skb);
+	if (iph->daddr != info->gateway)
+		return true;
+
+	return false;
+}
+
+static bool xt_gateway_match(const struct sk_buff *skb,
+			     const struct net_device *in,
+			     const struct net_device *out,
+			     const struct xt_match *match,
+			     const void *matchinfo, int offset,
+			     unsigned int protoff, bool *hotdrop)
+{
+	const struct xt_gateway_info *info = matchinfo;
+	return !!(info->flags & XT_GATEWAY_INV) ^
+	       xt_gateway_match_it(skb, info);
+}
+
+static struct xt_match xt_gateway_reg = {
+	.name      = "gateway",
+	.family    = AF_INET,
+	.match     = xt_gateway_match,
+	.matchsize = sizeof(struct xt_gateway_info),
+	.me        = THIS_MODULE,
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
+MODULE_DESCRIPTION("netfilter nexthop/gateway match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_gateway");
