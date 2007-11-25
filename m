From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: NF [PATCH 4/4] xt_gateway
Date: Sun, 25 Nov 2007 20:07:29 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711252006570.9477@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, azez@ufomechanic.net
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38193 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbXKYTHa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 14:07:30 -0500
In-Reply-To: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Netfilter: Import xt_gateway


Originally from <azez@ufomechanic.net>,
http://lists.netfilter.org/pipermail/netfilter-devel/2007-June/027954.h=
tml

This adds a gateway match to iptables that lets you match against the
routed ipv4 gateway, it is very useful for SNAT if you want to avoid
replicating your routing in your SNAT table.

e.g.

	iptables -t nat -A POSTROUTING -m gateway --nexthop \
		172.16.1.1 -j SNAT --to-address 172.16.1.5
	iptables -t nat -A POSTROUTING -m gateway --nexthop \
		192.168.1.1 -j SNAT --to-address 192.168.1.25

to help you choose the right SNAT address.

It works by comparing the to-be-matched gateway IP address with the
key in the neighbor table of the next-hop (the key is the layer 3
address).

	--gateway 1.2.3.4

only matches if the packet is destined to 1.2.3.4 as a ROUTE, i.e.
1.2.3.4 is not also the target address.

	--nexthop 1.2.3.4

matches if the next hop is specified as 1.2.3.4 either as a gateway or
as a final destination.

It cannot do magic, and match on non-routed aliases of routers, it only
matches the targeted IP address from which the layer 2 address has been
(or will be) actually derived.


Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Cc: <azez@ufomechanic.net>

---
 include/linux/netfilter/xt_gateway.h |   19 ++++++++
 net/netfilter/Kconfig                |    9 +++
 net/netfilter/Makefile               |    1=20
 net/netfilter/xt_gateway.c           |   83 ++++++++++++++++++++++++++=
+++++++++
 4 files changed, 112 insertions(+)

Index: linux-2.6/include/linux/netfilter/xt_gateway.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6/include/linux/netfilter/xt_gateway.h
@@ -0,0 +1,19 @@
+#ifndef _XT_GATEWAY_H
+#define _XT_GATEWAY_H
+
+enum {
+	/* Negate the condition */
+	XT_GATEWAY_INVERT =3D 1 << 0,
+	/* and the gateway is not the final hop */
+	XT_GATEWAY_ROUTE  =3D 1 << 1,
+};
+
+struct xt_gateway_match_info {
+	union {
+		__be32 gateway_v4;
+		__be32 gateway_v6[4];
+	};
+	u_int8_t flags;
+};
+
+#endif /* _XT_GATEWAY_H */
Index: linux-2.6/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/Kconfig
+++ linux-2.6/net/netfilter/Kconfig
@@ -519,6 +519,15 @@ config NETFILTER_XT_MATCH_ESP
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_MATCH_GATEWAY
+	tristate '"gateway" match support'
+	depends on NETFILTER_XTABLES
+	---help---
+	This option makes possible to match the IP address of the
+	routed gateway for routed packets.
+
+	To compile it as a module, choose M here. If unsure, say N.
+
 config NETFILTER_XT_MATCH_HELPER
 	tristate '"helper" match support'
 	depends on NETFILTER_XTABLES
Index: linux-2.6/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/Makefile
+++ linux-2.6/net/netfilter/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRAC
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) +=3D xt_dccp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) +=3D xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) +=3D xt_esp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_GATEWAY) +=3D xt_gateway.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) +=3D xt_hashlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) +=3D xt_helper.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) +=3D xt_length.o
Index: linux-2.6/net/netfilter/xt_gateway.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6/net/netfilter/xt_gateway.c
@@ -0,0 +1,83 @@
+/*
+ * netfilter module to match nexthop router by IP address
+ *
+ * (C) 2007 UFO Mechanic <azez@ufomechanic.net>
+ * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
+ * Contact: Jan Engelhardt <jengelh@computergmbh.de>
+ *
+ *   to save time and bugs, based on ip_range by
+ *   (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
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
+static bool gateway_match_it(const struct sk_buff *skb,
+                             const struct xt_gateway_match_info *info)
+{
+	const struct iphdr *iph;
+	const struct dst_entry *dst;
+	const struct neighbour *neigh;
+	const struct neigh_table *tbl;
+
+	dst =3D skb->dst;
+	if ((neigh =3D dst->neighbour) =3D=3D NULL)
+		return false;
+	tbl =3D neigh->tbl;
+	if (memcmp(&info->gateway_v4, &neigh->primary_key, tbl->key_len) !=3D=
 0)
+		return false;
+	if (!(info->flags & XT_GATEWAY_ROUTE))
+		return true;
+	iph =3D ip_hdr(skb);
+	if (iph->daddr !=3D info->gateway_v4)
+		return true;
+
+	return false;
+}
+
+static bool gateway_mt(const struct sk_buff *skb, const struct net_dev=
ice *in,
+                       const struct net_device *out,
+                       const struct xt_match *match, const void *match=
info,
+                       int offset, unsigned int protoff, bool *hotdrop=
)
+{
+	const struct xt_gateway_match_info *info =3D matchinfo;
+
+	return !!(info->flags & XT_GATEWAY_INVERT) ^
+	       gateway_match_it(skb, info);
+}
+
+static struct xt_match gateway_mt_reg __read_mostly =3D {
+	.name      =3D "gateway",
+	.family    =3D AF_INET,
+	.hooks     =3D (1 << NF_INET_FORWARD) | (1 << NF_INET_LOCAL_OUT) |
+	             (1 << NF_INET_POST_ROUTING),
+	.match     =3D gateway_mt,
+	.matchsize =3D sizeof(struct xt_gateway_match_info),
+	.me        =3D THIS_MODULE,
+};
+
+static int __init gateway_mt_init(void)
+{
+	return xt_register_match(&gateway_mt_reg);
+}
+
+static void __exit gateway_mt_exit(void)
+{
+	xt_unregister_match(&gateway_mt_reg);
+}
+
+module_init(gateway_mt_init);
+module_exit(gateway_mt_exit);
+MODULE_AUTHOR("Sam Liddicott <azez@ufomechanic.net>");
+MODULE_DESCRIPTION("netfilter nexthop/gateway match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_gateway");
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
