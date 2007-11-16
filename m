From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/3] xt_tos match
Date: Fri, 16 Nov 2007 14:00:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59023 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXKPNAO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 08:00:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Posted for review and checkup.

=3D=3D=3DPatch begins=3D=3D=3D

Convert ipt_tos to xt_tos, with a few extras:

	* IPv6 support (will use the priority field)

	* allow to match on the full TOS value
	  (i.e. with Network Precedence, if desired)

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/Kbuild      |    1=20
 include/linux/netfilter/xt_tos.h    |   14 ++++
 include/linux/netfilter_ipv4/Kbuild |    1=20
 net/ipv4/netfilter/Kconfig          |    9 ---
 net/ipv4/netfilter/Makefile         |    1=20
 net/ipv4/netfilter/ipt_tos.c        |   50 ----------------
 net/netfilter/Kconfig               |   10 +++
 net/netfilter/Makefile              |    1=20
 net/netfilter/xt_tos.c              |  106 +++++++++++++++++++++++++++=
+++++++++
 9 files changed, 132 insertions(+), 61 deletions(-)

Index: net-2.6.25/include/linux/netfilter/Kbuild
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/include/linux/netfilter/Kbuild
+++ net-2.6.25/include/linux/netfilter/Kbuild
@@ -35,6 +35,7 @@ header-y +=3D xt_statistic.h
 header-y +=3D xt_string.h
 header-y +=3D xt_tcpmss.h
 header-y +=3D xt_tcpudp.h
+header-y +=3D xt_tos.h
=20
 unifdef-y +=3D nf_conntrack_common.h
 unifdef-y +=3D nf_conntrack_ftp.h
Index: net-2.6.25/include/linux/netfilter/xt_tos.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ net-2.6.25/include/linux/netfilter/xt_tos.h
@@ -0,0 +1,14 @@
+#ifndef _XT_TOS_MATCH_H
+#define _XT_TOS_MATCH_H
+
+struct xt_tos_match_info {
+	u_int8_t tos_value;
+	u_int8_t tos_mask;
+	u_int8_t invert;
+};
+
+#ifndef IPTOS_NORMALSVC
+#	define IPTOS_NORMALSVC 0
+#endif
+
+#endif /* _XT_TOS_MATCH_H */
Index: net-2.6.25/include/linux/netfilter_ipv4/Kbuild
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/include/linux/netfilter_ipv4/Kbuild
+++ net-2.6.25/include/linux/netfilter_ipv4/Kbuild
@@ -40,7 +40,6 @@ header-y +=3D ipt_sctp.h
 header-y +=3D ipt_state.h
 header-y +=3D ipt_string.h
 header-y +=3D ipt_tcpmss.h
-header-y +=3D ipt_tos.h
 header-y +=3D ipt_ttl.h
=20
 unifdef-y +=3D ip_queue.h
Index: net-2.6.25/net/ipv4/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/net/ipv4/netfilter/Kconfig
+++ net-2.6.25/net/ipv4/netfilter/Kconfig
@@ -63,15 +63,6 @@ config IP_NF_MATCH_IPRANGE
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
-config IP_NF_MATCH_TOS
-	tristate "TOS match support"
-	depends on IP_NF_IPTABLES
-	help
-	  TOS matching allows you to match packets based on the Type Of
-	  Service fields of the IP packet.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_RECENT
 	tristate "recent match support"
 	depends on IP_NF_IPTABLES
Index: net-2.6.25/net/ipv4/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/net/ipv4/netfilter/Makefile
+++ net-2.6.25/net/ipv4/netfilter/Makefile
@@ -47,7 +47,6 @@ obj-$(CONFIG_IP_NF_MATCH_ECN) +=3D ipt_ecn
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) +=3D ipt_iprange.o
 obj-$(CONFIG_IP_NF_MATCH_OWNER) +=3D ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) +=3D ipt_recent.o
-obj-$(CONFIG_IP_NF_MATCH_TOS) +=3D ipt_tos.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) +=3D ipt_ttl.o
=20
 # targets
Index: net-2.6.25/net/ipv4/netfilter/ipt_tos.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/net/ipv4/netfilter/ipt_tos.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/* Kernel module to match TOS values. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modif=
y
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/ip.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-
-#include <linux/netfilter_ipv4/ipt_tos.h>
-#include <linux/netfilter/x_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("iptables TOS match module");
-
-static bool
-tos_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *=
hotdrop)
-{
-	const struct ipt_tos_info *info =3D matchinfo;
-
-	return (ip_hdr(skb)->tos =3D=3D info->tos) ^ info->invert;
-}
-
-static struct xt_match tos_mt_reg __read_mostly =3D {
-	.name		=3D "tos",
-	.family		=3D AF_INET,
-	.match		=3D tos_mt,
-	.matchsize	=3D sizeof(struct ipt_tos_info),
-	.me		=3D THIS_MODULE,
-};
-
-static int __init tos_mt_init(void)
-{
-	return xt_register_match(&tos_mt_reg);
-}
-
-static void __exit tos_mt_exit(void)
-{
-	xt_unregister_match(&tos_mt_reg);
-}
-
-module_init(tos_mt_init);
-module_exit(tos_mt_exit);
Index: net-2.6.25/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/net/netfilter/Kconfig
+++ net-2.6.25/net/netfilter/Kconfig
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
Index: net-2.6.25/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/net/netfilter/Makefile
+++ net-2.6.25/net/netfilter/Makefile
@@ -77,4 +77,5 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTI
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) +=3D xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) +=3D xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) +=3D xt_time.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_TOS) +=3D xt_tos.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) +=3D xt_u32.o
Index: net-2.6.25/net/netfilter/xt_tos.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ net-2.6.25/net/netfilter/xt_tos.c
@@ -0,0 +1,106 @@
+/* Kernel module to match TOS values. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ * =C2=A9 2007 CC Computer Consultants GmbH
+ * Contact: <jengelh@computergmbh.de>
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
+#include <linux/netfilter_ipv4/ipt_tos.h>
+
+static bool
+tos_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, const struct xt_match *match,
+          const void *matchinfo, int offset, unsigned int protoff,
+          bool *hotdrop)
+{
+	const struct ipt_tos_info *info =3D matchinfo;
+
+	return (ip_hdr(skb)->tos =3D=3D info->tos) ^ info->invert;
+}
+
+static bool
+tos_mt(const struct sk_buff *skb, const struct net_device *in,
+       const struct net_device *out, const struct xt_match *match,
+       const void *matchinfo, int offset, unsigned int protoff, bool *=
hotdrop)
+{
+	const struct xt_tos_match_info *info =3D matchinfo;
+
+	if (match->family =3D=3D AF_INET)
+		return ((ip_hdr(skb)->tos & info->tos_mask) =3D=3D
+		       info->tos_value) ^ info->invert;
+	else
+		return ((ipv6_hdr(skb)->priority & info->tos_mask) =3D=3D
+		       info->tos_value) ^ info->invert;
+}
+
+static bool
+tos_mt6_check(const char *tablename, const void *ip,
+              const struct xt_match *match, void *matchinfo,
+              unsigned int hook_mask)
+{
+	const struct xt_tos_match_info *info =3D matchinfo;
+
+	if (info->tos_mask > 0xF || info->tos_value > 0xF) {
+		printk(KERN_WARNING KBUILD_MODNAME
+		       ": Traffic Class field may only take values 0-15\n");
+		return false;
+	}
+
+	return true;
+}
+
+static struct xt_match tos_mt_reg[] __read_mostly =3D {
+	{
+		.name       =3D "tos",
+		.revision   =3D 0,
+		.family     =3D AF_INET,
+		.match      =3D tos_mt_v0,
+		.matchsize  =3D sizeof(struct ipt_tos_info),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "tos",
+		.revision   =3D 1,
+		.family     =3D AF_INET,
+		.match      =3D tos_mt,
+		.matchsize  =3D sizeof(struct xt_tos_match_info),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "tos",
+		.revision   =3D 1,
+		.family     =3D AF_INET6,
+		.match      =3D tos_mt,
+		.matchsize  =3D sizeof(struct xt_tos_match_info),
+		.checkentry =3D tos_mt6_check,
+		.me         =3D THIS_MODULE,
+	},
+};
+
+static int __init tos_mt_init(void)
+{
+	return xt_register_matches(tos_mt_reg, ARRAY_SIZE(tos_mt_reg));
+}
+
+static void __exit tos_mt_exit(void)
+{
+	xt_unregister_matches(tos_mt_reg, ARRAY_SIZE(tos_mt_reg));
+}
+
+module_init(tos_mt_init);
+module_exit(tos_mt_exit);
+MODULE_DESCRIPTION("netfilter \"tos\" match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_tos");
+MODULE_ALIAS("ip6t_tos");

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
