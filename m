From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 23/27] xt_iprange match, revision 1
Date: Wed, 2 Jan 2008 21:31:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022131340.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56951 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbYABUbx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:31:53 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 057131958a0e09403fc47090549fe9d25afd763c
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 18:51:10 2008 +0100

    [NETFILTER]: xt_iprange match, revision 1
   =20
    Adds IPv6 support to xt_iprange, making it possible to match on IPv=
6
    address ranges with ip6tables.
   =20
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 net/netfilter/xt_iprange.c |  123 +++++++++++++++++++++++++++++++++---
 1 files changed, 114 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index ff71868..cd08f17 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -2,6 +2,8 @@
  *	xt_iprange - Netfilter module to match IP address ranges
  *
  *	(C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *	Copyright =C2=A9 CC Computer Consultants GmbH, 2008
+ *	Contact: <jengelh@computergmbh.de>
  *
  *	This program is free software; you can redistribute it and/or modif=
y
  *	it under the terms of the GNU General Public License version 2 as
@@ -10,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_iprange.h>
=20
@@ -51,26 +54,128 @@ iprange_mt_v0(const struct sk_buff *skb, const str=
uct net_device *in,
 	return true;
 }
=20
-static struct xt_match iprange_mt_reg __read_mostly =3D {
-	.name		=3D "iprange",
-	.family		=3D AF_INET,
-	.match		=3D iprange_mt_v0,
-	.matchsize	=3D sizeof(struct ipt_iprange_info),
-	.me		=3D THIS_MODULE
+static bool
+iprange_mt4(const struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, const struct xt_match *match=
,
+            const void *matchinfo, int offset, unsigned int protoff,
+            bool *hotdrop)
+{
+	const struct xt_iprange_mtinfo *info =3D matchinfo;
+	const struct iphdr *iph =3D ip_hdr(skb);
+	bool m;
+
+	if (info->flags & IPRANGE_SRC) {
+		m  =3D ntohl(iph->saddr) < ntohl(info->src_min.ip);
+		m |=3D ntohl(iph->saddr) > ntohl(info->src_max.ip);
+		m ^=3D info->flags & IPRANGE_SRC_INV;
+		if (m) {
+			pr_debug("src IP " NIPQUAD_FMT " NOT in range %s"
+			         NIPQUAD_FMT "-" NIPQUAD_FMT "\n",
+			         NIPQUAD(iph->saddr),
+			         (info->flags & IPRANGE_SRC_INV) ? "(INV) " : "",
+			         NIPQUAD(info->src_max.ip),
+			         NIPQUAD(info->src_max.ip));
+			return false;
+		}
+	}
+	if (info->flags & IPRANGE_DST) {
+		m  =3D ntohl(iph->daddr) < ntohl(info->dst_min.ip);
+		m |=3D ntohl(iph->daddr) > ntohl(info->dst_max.ip);
+		m ^=3D info->flags & IPRANGE_DST_INV;
+		if (m) {
+			pr_debug("dst IP " NIPQUAD_FMT " NOT in range %s"
+			         NIPQUAD_FMT "-" NIPQUAD_FMT "\n",
+			         NIPQUAD(iph->daddr),
+			         (info->flags & IPRANGE_DST_INV) ? "(INV) " : "",
+			         NIPQUAD(info->dst_min.ip),
+			         NIPQUAD(info->dst_max.ip));
+			return false;
+		}
+	}
+	return true;
+}
+
+static inline int
+iprange_ipv6_sub(const struct in6_addr *a, const struct in6_addr *b)
+{
+	unsigned int i;
+	int r;
+
+	for (i =3D 0; i < 4; ++i) {
+		r =3D a->s6_addr32[i] - b->s6_addr32[i];
+		if (r !=3D 0)
+			return r;
+	}
+
+	return 0;
+}
+
+static bool
+iprange_mt6(const struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, const struct xt_match *match=
,
+            const void *matchinfo, int offset, unsigned int protoff,
+            bool *hotdrop)
+{
+	const struct xt_iprange_mtinfo *info =3D matchinfo;
+	const struct ipv6hdr *iph =3D ipv6_hdr(skb);
+	bool m;
+
+	if (info->flags & IPRANGE_SRC) {
+		m  =3D iprange_ipv6_sub(&iph->saddr, &info->src_min.in6) < 0;
+		m |=3D iprange_ipv6_sub(&iph->saddr, &info->src_max.in6) > 0;
+		m ^=3D info->flags & IPRANGE_SRC_INV;
+		if (m)
+			return false;
+	}
+	if (info->flags & IPRANGE_DST) {
+		m  =3D iprange_ipv6_sub(&iph->daddr, &info->dst_min.in6) < 0;
+		m |=3D iprange_ipv6_sub(&iph->daddr, &info->dst_max.in6) > 0;
+		m ^=3D info->flags & IPRANGE_DST_INV;
+		if (m)
+			return false;
+	}
+	return true;
+}
+
+static struct xt_match iprange_mt_reg[] __read_mostly =3D {
+	{
+		.name      =3D "iprange",
+		.revision  =3D 0,
+		.family    =3D AF_INET,
+		.match     =3D iprange_mt_v0,
+		.matchsize =3D sizeof(struct ipt_iprange_info),
+		.me        =3D THIS_MODULE,
+	},
+	{
+		.name      =3D "iprange",
+		.revision  =3D 1,
+		.family    =3D AF_INET6,
+		.match     =3D iprange_mt4,
+		.matchsize =3D sizeof(struct xt_iprange_mtinfo),
+		.me        =3D THIS_MODULE,
+	},
+	{
+		.name      =3D "iprange",
+		.revision  =3D 1,
+		.family    =3D AF_INET6,
+		.match     =3D iprange_mt6,
+		.matchsize =3D sizeof(struct xt_iprange_mtinfo),
+		.me        =3D THIS_MODULE,
+	},
 };
=20
 static int __init iprange_mt_init(void)
 {
-	return xt_register_match(&iprange_mt_reg);
+	return xt_register_matches(iprange_mt_reg, ARRAY_SIZE(iprange_mt_reg)=
);
 }
=20
 static void __exit iprange_mt_exit(void)
 {
-	xt_unregister_match(&iprange_mt_reg);
+	xt_unregister_matches(iprange_mt_reg, ARRAY_SIZE(iprange_mt_reg));
 }
=20
 module_init(iprange_mt_init);
 module_exit(iprange_mt_exit);
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>, Jozsef Kadlec=
sik <kadlec@blackhole.kfki.hu>");
 MODULE_DESCRIPTION("Netfilter: arbitrary IPv4 range matching");
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
