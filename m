From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] Add xt_tos
Date: Sat, 20 Oct 2007 13:45:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201344220.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38307 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750AbXJTLpK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:45:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Convert ipt_tos to xt_tos, adding support for IPv6.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_tos.h |   13 +++++++
 net/netfilter/Kconfig            |   10 ++++++
 net/netfilter/Makefile           |    1=20
 net/netfilter/xt_tos.c           |   65 ++++++++++++++++++++++++++++++=
+++++++++
 4 files changed, 89 insertions(+)

Index: gitone/include/linux/netfilter/xt_tos.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ gitone/include/linux/netfilter/xt_tos.h
@@ -0,0 +1,13 @@
+#ifndef _XT_TOS_MATCH_H
+#define _XT_TOS_MATCH_H
+
+struct xt_tos_info {
+	u_int8_t tos;
+	u_int8_t invert;
+};
+
+#ifndef IPTOS_NORMALSVC
+#	define IPTOS_NORMALSVC 0
+#endif
+
+#endif /* _XT_TOS_MATCH_H */
Index: gitone/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- gitone.orig/net/netfilter/Kconfig
+++ gitone/net/netfilter/Kconfig
@@ -679,6 +679,16 @@ config NETFILTER_XT_MATCH_TIME
 	  If you want to compile it as a module, say M here.
 	  If unsure, say N.
=20
+config NETFILTER_XT_MATCH_TOS
+	tristate '"tos" match support'
+	depends on NETFILTER_XTABLES
+	---help---
+	TOS matching allows you to match packets based on the Type Of
+	Service field of the IPv4 packet or Traffic Class field of
+	the IPv6 packet.
+
+	To compile it as a module, choose M here. If unsure, say N.
+
 config NETFILTER_XT_MATCH_U32
 	tristate '"u32" match support'
 	depends on NETFILTER_XTABLES
Index: gitone/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- gitone.orig/net/netfilter/Makefile
+++ gitone/net/netfilter/Makefile
@@ -77,4 +77,5 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTI
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) +=3D xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) +=3D xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) +=3D xt_time.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_TOS) +=3D xt_tos.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) +=3D xt_u32.o
Index: gitone/net/netfilter/xt_tos.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ gitone/net/netfilter/xt_tos.c
@@ -0,0 +1,65 @@
+/* Kernel module to match TOS values. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ * =C2=A9 2007 CC Computer Consultants GmbH <jengelh@computergmbh.de>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tos.h>
+
+static bool
+xt_tos_match(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *matc=
h,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
+{
+	const struct xt_tos_info *info =3D matchinfo;
+
+	if (match->family =3D=3D AF_INET)
+		return (ip_hdr(skb)->tos =3D=3D info->tos) ^ info->invert;
+	else
+		return (ipv6_hdr(skb)->priority =3D=3D info->tos) ^ info->invert;
+}
+
+static struct xt_match xt_tos_reg[] __read_mostly =3D {
+	{
+		.name      =3D "tos",
+		.family    =3D AF_INET,
+		.match     =3D xt_tos_match,
+		.matchsize =3D sizeof(struct xt_tos_info),
+		.me        =3D THIS_MODULE,
+	},
+	{
+		.name      =3D "tos",
+		.family    =3D AF_INET6,
+		.match     =3D xt_tos_match,
+		.matchsize =3D sizeof(struct xt_tos_info),
+		.me        =3D THIS_MODULE,
+	},
+};
+
+static int __init xt_tos_init(void)
+{
+	return xt_register_matches(xt_tos_reg, ARRAY_SIZE(xt_tos_reg));
+}
+
+static void __exit xt_tos_exit(void)
+{
+	xt_unregister_matches(xt_tos_reg, ARRAY_SIZE(xt_tos_reg));
+}
+
+module_init(xt_tos_init);
+module_exit(xt_tos_exit);
+MODULE_DESCRIPTION("netfilter \"tos\" match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_tos");
+MODULE_ALIAS("ip6t_tos");

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
