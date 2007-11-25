From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: NF [PATCH 3/4] xt_TCPOPTSTRIP
Date: Sun, 25 Nov 2007 20:06:55 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711252006330.9477@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sven Schnelle <svens@bitebene.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37593 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbXKYTG5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 14:06:57 -0500
In-Reply-To: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Netfilter: Import xt_TCPOPTSTRIP


Originally from Sven Schnelle.
xt_TCPOPTSTRIP can strip TCP options from TCP packets, for example,
to disable Selective ACK or Window scaling.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Sven Schnelle <svens@bitebene.org>

---
 include/linux/netfilter/xt_TCPOPTSTRIP.h |   13 ++
 net/netfilter/Kconfig                    |    8 +
 net/netfilter/Makefile                   |    1=20
 net/netfilter/xt_TCPOPTSTRIP.c           |  143 ++++++++++++++++++++++=
+++++++++
 4 files changed, 165 insertions(+)

Index: linux-2.6/include/linux/netfilter/xt_TCPOPTSTRIP.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1,13 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+#define tcpoptstrip_set_bit(bmap, idx) \
+	(bmap[(idx) >> 5] |=3D 1UL << (idx & 31))
+#define tcpoptstrip_test_bit(bmap, idx) \
+	(((1UL << (idx & 31)) & bmap[(idx) >> 5]) !=3D 0)
+
+struct xt_tcpoptstrip_target_info {
+	u_int32_t strip_bmap[8];
+};
+
+#endif /* _XT_TCPOPTSTRIP_H */
Index: linux-2.6/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/Kconfig
+++ linux-2.6/net/netfilter/Kconfig
@@ -424,6 +424,14 @@ config NETFILTER_XT_TARGET_TEE
 	  Documentation/modules.txt. The module will be called xt_TEE.ko.
 	  If unsure, say N.
=20
+config NETFILTER_XT_TARGET_TCPOPTSTRIP
+	tristate '"TCPOPTSTRIP" target support'
+	depends on NETFILTER_XTABLES
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	---help---
+	This option adds a "TCPOPTSTRIP" target, which allows you to strip
+	TCP options from TCP packets.
+
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
Index: linux-2.6/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/Makefile
+++ linux-2.6/net/netfilter/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) +=3D xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) +=3D xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) +=3D xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) +=3D xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) +=3D xt_TEE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) +=3D xt_TRACE.o
=20
Index: linux-2.6/net/netfilter/xt_TCPOPTSTRIP.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6/net/netfilter/xt_TCPOPTSTRIP.c
@@ -0,0 +1,143 @@
+/*
+ * A module for stripping a specific TCP option from TCP packets.
+ *
+ * Copyright (C) 2007 Sven Schnelle <svens@bitebene.org>
+ * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
+ * Contact: Jan Engelhardt <jengelh@computergmbh.de>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <net/ipv6.h>
+#include <net/tcp.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TCPOPTSTRIP.h>
+
+static inline unsigned int optlen(const u_int8_t *opt, unsigned int of=
fset)
+{
+	/* Beware zero-length options: make finite progress */
+	if (opt[offset] <=3D TCPOPT_NOP || opt[offset+1] =3D=3D 0)
+		return 1;
+	else
+		return opt[offset+1];
+}
+
+static unsigned int
+tcpoptstrip_mangle_packet(struct sk_buff *skb,
+                          const struct xt_tcpoptstrip_target_info *inf=
o,
+                          unsigned int tcphoff, unsigned int minlen)
+{
+	unsigned int optl, i, j;
+	struct tcphdr *tcph;
+	u_int16_t n, o;
+	u_int8_t *opt;
+
+	if (!skb_make_writable(skb, skb->len))
+		return NF_DROP;
+
+	tcph =3D (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	opt  =3D (u_int8_t *)tcph;
+
+	/*
+	 * Walk through all TCP options - if we find some option to remove,
+	 * set all octets to %TCPOPT_NOP and adjust checksum.
+	 */
+	for (i =3D sizeof(struct tcphdr); i < tcp_hdrlen(skb); i +=3D optl) {
+		optl =3D optlen(opt, i);
+
+		if (i + optl > tcp_hdrlen(skb))
+			break;
+
+		if (!tcpoptstrip_test_bit(info->strip_bmap, opt[i]))
+			continue;
+
+		for (j =3D 0; j < optl; ++j) {
+			o =3D opt[i+j];
+			n =3D TCPOPT_NOP;
+			if ((i + j) % 2 =3D=3D 0) {
+				o <<=3D 8;
+				n <<=3D 8;
+			}
+			nf_proto_csum_replace2(&tcph->check, skb, htons(o),
+			                       htons(n), 0);
+		}
+		memset(opt + i, TCPOPT_NOP, optl);
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+tcpoptstrip_tg4(struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, unsigned int hooknum,
+                const struct xt_target *target, const void *targinfo)
+{
+	return tcpoptstrip_mangle_packet(skb, targinfo, ip_hdrlen(skb),
+	       sizeof(struct iphdr) + sizeof(struct tcphdr));
+}
+
+static unsigned int
+tcpoptstrip_tg6(struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, unsigned int hooknum,
+                const struct xt_target *target, const void *targinfo)
+{
+	struct ipv6hdr *ipv6h =3D ipv6_hdr(skb);
+	unsigned int tcphoff;
+	u_int8_t nexthdr;
+
+	nexthdr =3D ipv6h->nexthdr;
+	tcphoff =3D ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr);
+	if (tcphoff < 0)
+		return NF_DROP;
+
+	return tcpoptstrip_mangle_packet(skb, targinfo, tcphoff,
+	       sizeof(*ipv6h) + sizeof(struct tcphdr));
+}
+
+static struct xt_target tcpoptstrip_tg_reg[] __read_mostly =3D {
+	{
+		.name       =3D "TCPOPTSTRIP",
+		.family     =3D AF_INET,
+		.table      =3D "mangle",
+		.proto      =3D IPPROTO_TCP,
+		.target     =3D tcpoptstrip_tg4,
+		.targetsize =3D sizeof(struct xt_tcpoptstrip_target_info),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "TCPOPTSTRIP",
+		.family     =3D AF_INET6,
+		.table      =3D "mangle",
+		.proto      =3D IPPROTO_TCP,
+		.target     =3D tcpoptstrip_tg6,
+		.targetsize =3D sizeof(struct xt_tcpoptstrip_target_info),
+		.me         =3D THIS_MODULE,
+	},
+};
+
+static int __init tcpoptstrip_tg_init(void)
+{
+	return xt_register_targets(tcpoptstrip_tg_reg,
+	       ARRAY_SIZE(tcpoptstrip_tg_reg));
+}
+
+static void __exit tcpoptstrip_tg_exit(void)
+{
+	xt_unregister_targets(tcpoptstrip_tg_reg,
+	                      ARRAY_SIZE(tcpoptstrip_tg_reg));
+}
+
+module_init(tcpoptstrip_tg_init);
+module_exit(tcpoptstrip_tg_exit);
+MODULE_AUTHOR("Sven Schnelle <svens@bitebene.org>, Jan Engelhardt <jen=
gelh@computergmbh.de>");
+MODULE_DESCRIPTION("netfilter \"TCPOPTSTRIP\" target module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_TCPOPTSTRIP");
+MODULE_ALIAS("ip6t_TCPOPTSTRIP");
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
