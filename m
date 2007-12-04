From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/49]: x_tables: add TCPOPTSTRIP target
Date: Tue,  4 Dec 2007 13:01:56 +0100 (MET)
Message-ID: <20071204120156.2442.53101.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62092 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXLDMB5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:01:57 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: x_tables: add TCPOPTSTRIP target

Signed-off-by: Sven Schnelle <svens@bitebene.org>
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b3e4042d568acf92a0e4b5334c8a9ca499bb3a4a
tree bbcd2fdf9fc37af122af3bb8f63caed8bf83b68c
parent f2d0e339181e7973299401191dd22031494114ae
author Sven Schnelle <svens@bitebene.org> Tue, 04 Dec 2007 10:46:50 +01=
00
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:46:50 +=
0100

 include/linux/netfilter/xt_TCPOPTSTRIP.h |   13 +++
 net/netfilter/Kconfig                    |    8 ++
 net/netfilter/Makefile                   |    1=20
 net/netfilter/xt_TCPOPTSTRIP.c           |  147 ++++++++++++++++++++++=
++++++++
 4 files changed, 169 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/xt_TCPOPTSTRIP.h b/include/linux/n=
etfilter/xt_TCPOPTSTRIP.h
new file mode 100644
index 0000000..2db5432
--- /dev/null
+++ b/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1,13 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+#define tcpoptstrip_set_bit(bmap, idx) \
+	(bmap[(idx) >> 5] |=3D 1U << (idx & 31))
+#define tcpoptstrip_test_bit(bmap, idx) \
+	(((1U << (idx & 31)) & bmap[(idx) >> 5]) !=3D 0)
+
+struct xt_tcpoptstrip_target_info {
+	u_int32_t strip_bmap[8];
+};
+
+#endif /* _XT_TCPOPTSTRIP_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 21a9fcc..693f861 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -411,6 +411,14 @@ config NETFILTER_XT_TARGET_TCPMSS
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_TARGET_TCPOPTSTRIP
+	tristate '"TCPOPTSTRIP" target support (EXPERIMENTAL)'
+	depends on EXPERIMENTAL && NETFILTER_XTABLES
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	help
+	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
+	  TCP options from TCP packets.
+
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index ad0e36e..7763dea 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) +=3D xt_NFQ=
UEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) +=3D xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) +=3D xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) +=3D xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) +=3D xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) +=3D xt_TRACE.o
=20
 # matches
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTST=
RIP.c
new file mode 100644
index 0000000..43d6ac2
--- /dev/null
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -0,0 +1,147 @@
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
+			  const struct xt_tcpoptstrip_target_info *info,
+			  unsigned int tcphoff, unsigned int minlen)
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
+			inet_proto_csum_replace2(&tcph->check, skb, htons(o),
+						 htons(n), 0);
+		}
+		memset(opt + i, TCPOPT_NOP, optl);
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+tcpoptstrip_tg4(struct sk_buff *skb, const struct net_device *in,
+		const struct net_device *out, unsigned int hooknum,
+		const struct xt_target *target, const void *targinfo)
+{
+	return tcpoptstrip_mangle_packet(skb, targinfo, ip_hdrlen(skb),
+	       sizeof(struct iphdr) + sizeof(struct tcphdr));
+}
+
+#if defined(CONFIG_IP6_NF_MANGLE) || defined(CONFIG_IP6_NF_MANGLE_MODU=
LE)
+static unsigned int
+tcpoptstrip_tg6(struct sk_buff *skb, const struct net_device *in,
+		const struct net_device *out, unsigned int hooknum,
+		const struct xt_target *target, const void *targinfo)
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
+#endif
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
+#if defined(CONFIG_IP6_NF_MANGLE) || defined(CONFIG_IP6_NF_MANGLE_MODU=
LE)
+	{
+		.name       =3D "TCPOPTSTRIP",
+		.family     =3D AF_INET6,
+		.table      =3D "mangle",
+		.proto      =3D IPPROTO_TCP,
+		.target     =3D tcpoptstrip_tg6,
+		.targetsize =3D sizeof(struct xt_tcpoptstrip_target_info),
+		.me         =3D THIS_MODULE,
+	},
+#endif
+};
+
+static int __init tcpoptstrip_tg_init(void)
+{
+	return xt_register_targets(tcpoptstrip_tg_reg,
+				   ARRAY_SIZE(tcpoptstrip_tg_reg));
+}
+
+static void __exit tcpoptstrip_tg_exit(void)
+{
+	xt_unregister_targets(tcpoptstrip_tg_reg,
+			      ARRAY_SIZE(tcpoptstrip_tg_reg));
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
