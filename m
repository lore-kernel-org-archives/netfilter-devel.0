From: Sven Schnelle <svens@bitebene.org>
Subject: Re: [PATCH] xt_TCPOPTSTRIP 20071006 (kernel)
Date: Mon, 08 Oct 2007 09:58:59 +0200
Message-ID: <86sl4mghq4.fsf@deprecated.bitebene.org>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
	<Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
	<46FD1798.2020302@trash.net>
	<87tzpd266j.fsf@begreifnix.intranet.astaro.de>
	<87hcl91ubt.fsf@begreifnix.intranet.astaro.de>
	<87abr11tth.fsf@begreifnix.intranet.astaro.de>
	<Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr>
	<874ph4bafm.fsf@apollo.sven.bitebene.org>
	<Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0710061659271.5969@fbirervta.pbzchgretzou.qr>
	<4709B97F.2000106@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@computergmbh.de>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from woomax.duncanthrax.net ([195.2.162.46]:44742 "EHLO
	woomax.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbXJHH7C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 03:59:02 -0400
In-Reply-To: <4709B97F.2000106@trash.net> (Patrick McHardy's message of "Mon,
	08 Oct 2007 07:00:47 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Patrick McHardy <kaber@trash.net> writes:

> Jan Engelhardt wrote:
>> Add xt_TCPOPTSTRIP, a module to replace TCP options by NOPs.
>
> A few minor comments:
> [..]

Added the updated version. This should now be considered as the final
Version. ;-)

Signed-off-by: Sven Schnelle <svens@bitebene.org>
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>=20

=2D--
 include/linux/netfilter/xt_TCPOPTSTRIP.h |   13 +++
 net/netfilter/Kconfig                    |    7 ++
 net/netfilter/Makefile                   |    1 +
 net/netfilter/xt_TCPOPTSTRIP.c           |  144 ++++++++++++++++++++++++++=
++++
 4 files changed, 165 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_TCPOPTSTRIP.h
 create mode 100644 net/netfilter/xt_TCPOPTSTRIP.c

diff --git a/include/linux/netfilter/xt_TCPOPTSTRIP.h b/include/linux/netfi=
lter/xt_TCPOPTSTRIP.h
new file mode 100644
index 0000000..a7edfeb
=2D-- /dev/null
+++ b/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1,13 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+#define tcpoptstrip_set_bit(bmap, idx) \
+	(bmap[(idx) >> 5] |=3D 1 << (idx & 31))
+#define tcpoptstrip_test_bit(bmap, idx) \
+	(((1 << (idx & 31)) & bmap[(idx) >> 5]) !=3D 0)
+
+struct xt_tcpoptstrip_info {
+	u_int32_t strip_bmap[8];
+};
+
+#endif /* _XT_TCPOPTSTRIP_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3599770..9830c34 100644
=2D-- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -411,6 +411,13 @@ config NETFILTER_XT_TARGET_TCPMSS
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_TARGET_TCPOPTSTRIP
+	tristate '"TCPOPTSTRIP" target support'
+	depends on EXPERIMENTAL && NETFILTER_XTABLES
+	---help---
+	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
+	  TCP options from TCP packets.
+
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0c054bf..fe5ac6e 100644
=2D-- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) +=3D xt_TRACE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) +=3D xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) +=3D xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) +=3D xt_CONNSECMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) +=3D xt_TCPOPTSTRIP.o
=20
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) +=3D xt_comment.o
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
new file mode 100644
index 0000000..57005bc
=2D-- /dev/null
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -0,0 +1,144 @@
+/*
+ * A module for stripping a specific TCP option from TCP packets.
+ *
+ * Copyright (c) 2007 Sven Schnelle <svens@bitebene.org>
+ * Copyright (c) 2007 Jan Engelhardt <jengelh@computergmbh.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
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
+static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
+{
+	/* Beware zero-length options: make finite progress */
+	if (opt[offset] <=3D TCPOPT_NOP || opt[offset+1] =3D=3D 0)
+		return 1;
+	else
+		return opt[offset+1];
+}
+
+static unsigned int
+tcpoptstrip_mangle_packet(struct sk_buff **pskb,
+                          const struct xt_tcpoptstrip_info *info,
+                          unsigned int tcphoff, unsigned int minlen)
+{
+	unsigned int optl, i, j;
+	struct tcphdr *tcph;
+	u_int16_t n, o;
+	u_int8_t *opt;
+
+	if (!skb_make_writable(pskb, (*pskb)->len))
+		return NF_DROP;
+
+	tcph =3D (struct tcphdr *)(skb_network_header(*pskb) + tcphoff);
+	opt  =3D (u_int8_t *)tcph;
+
+	/*
+	 * Walk through all TCP options - if we find some option to remove,
+	 * set all octets to %TCPOPT_NOP and adjust checksum.
+	 */
+	for (i =3D sizeof(struct tcphdr); i < tcp_hdrlen(*pskb); i +=3D optl) {
+		optl =3D optlen(opt, i);
+
+		if (i + optl > tcp_hdrlen(*pskb))
+			return NF_DROP;
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
+			nf_proto_csum_replace2(&tcph->check, *pskb, htons(o),
+			                       htons(n), 0);
+		}
+		memset(opt + i, TCPOPT_NOP, optl);
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+xt_tcpoptstrip_target4(struct sk_buff **pskb, const struct net_device *in,
+                       const struct net_device *out, unsigned int hooknum,
+                       const struct xt_target *target, const void *targinf=
o)
+{
+	return tcpoptstrip_mangle_packet(pskb, targinfo, ip_hdrlen(*pskb),
+	       sizeof(struct iphdr) + sizeof(struct tcphdr));
+}
+
+#ifdef CONFIG_IPV6
+static unsigned int
+xt_tcpoptstrip_target6(struct sk_buff **pskb, const struct net_device *in,
+                       const struct net_device *out, unsigned int hooknum,
+                       const struct xt_target *target, const void *targinf=
o)
+{
+	struct ipv6hdr *ipv6h =3D ipv6_hdr(*pskb);
+	unsigned int tcphoff;
+	u_int8_t nexthdr;
+
+	nexthdr =3D ipv6h->nexthdr;
+	tcphoff =3D ipv6_skip_exthdr(*pskb, sizeof(*ipv6h), &nexthdr);
+	if (tcphoff < 0)
+		return NF_DROP;
+
+	return tcpoptstrip_mangle_packet(pskb, targinfo, tcphoff,
+	       sizeof(*ipv6h) + sizeof(struct tcphdr));
+}
+#endif
+
+static struct xt_target tcpoptstrip_reg[] __read_mostly =3D {
+	{
+		.name       =3D "TCPOPTSTRIP",
+		.family     =3D AF_INET,
+		.table      =3D "mangle",
+		.proto      =3D IPPROTO_TCP,
+		.target     =3D xt_tcpoptstrip_target4,
+		.targetsize =3D sizeof(struct xt_tcpoptstrip_info),
+		.me         =3D THIS_MODULE,
+	},
+#ifdef CONFIG_IPV6
+	{
+		.name       =3D "TCPOPTSTRIP",
+		.family     =3D AF_INET6,
+		.table      =3D "mangle",
+		.proto      =3D IPPROTO_TCP,
+		.target     =3D xt_tcpoptstrip_target6,
+		.targetsize =3D sizeof(struct xt_tcpoptstrip_info),
+		.me         =3D THIS_MODULE,
+	},
+#endif
+};
+
+static int __init xt_tcpoptstrip_init(void)
+{
+	return xt_register_targets(tcpoptstrip_reg, ARRAY_SIZE(tcpoptstrip_reg));
+}
+
+static void __exit xt_tcpoptstrip_exit(void)
+{
+	xt_unregister_targets(tcpoptstrip_reg, ARRAY_SIZE(tcpoptstrip_reg));
+}
+
+module_init(xt_tcpoptstrip_init);
+module_exit(xt_tcpoptstrip_exit);
+MODULE_AUTHOR("Sven Schnelle <svens@bitebene.org>");
+MODULE_DESCRIPTION("netfilter TCPOPTSTRIP target module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_TCPOPTSTRIP");
+MODULE_ALIAS("ip6t_TCPOPTSTRIP");
=2D-=20
1.5.3.4


--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHCeND86MdxiXaIbERAh/QAJ4p0MjikmrKSH4Cy/kqGKkiix2QgwCfTKZC
1CxbDG8G2SXE+5iFbv9It+M=
=17tB
-----END PGP SIGNATURE-----
--=-=-=--
