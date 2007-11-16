From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 2/3] xt_TOS target
Date: Fri, 16 Nov 2007 14:00:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711161400170.3340@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59025 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbXKPNAf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 08:00:35 -0500
In-Reply-To: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Posted for review and checkup.

=3D=3D=3DPatch begins=3D=3D=3D

Convert ipt_TOS to xt_TOS, with the following extras:

	* IPv6 support (will use the priority field)

	* can set network precedence

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/Kbuild      |    1=20
 include/linux/netfilter/xt_TOS.h    |   13 ++
 include/linux/netfilter_ipv4/Kbuild |    1=20
 net/ipv4/netfilter/Kconfig          |   10 --
 net/ipv4/netfilter/Makefile         |    1=20
 net/ipv4/netfilter/ipt_TOS.c        |   82 ------------------
 net/netfilter/Kconfig               |    8 +
 net/netfilter/Makefile              |    1=20
 net/netfilter/xt_TOS.c              |  160 +++++++++++++++++++++++++++=
+++++++++
 9 files changed, 183 insertions(+), 94 deletions(-)

Index: net-2.6.25/include/linux/netfilter/Kbuild
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/include/linux/netfilter/Kbuild
+++ net-2.6.25/include/linux/netfilter/Kbuild
@@ -12,6 +12,7 @@ header-y +=3D xt_NFLOG.h
 header-y +=3D xt_NFQUEUE.h
 header-y +=3D xt_SECMARK.h
 header-y +=3D xt_TCPMSS.h
+header-y +=3D xt_TOS.h
 header-y +=3D xt_comment.h
 header-y +=3D xt_connbytes.h
 header-y +=3D xt_connmark.h
Index: net-2.6.25/include/linux/netfilter/xt_TOS.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ net-2.6.25/include/linux/netfilter/xt_TOS.h
@@ -0,0 +1,13 @@
+#ifndef _XT_TOS_TARGET_H
+#define _XT_TOS_TARGET_H
+
+#ifndef IPTOS_NORMALSVC
+#	define IPTOS_NORMALSVC 0
+#endif
+
+struct xt_tos_target_info {
+	u_int8_t tos_value;
+	u_int8_t tos_mask;
+};
+
+#endif /* _XT_TOS_TARGET_H */
Index: net-2.6.25/include/linux/netfilter_ipv4/Kbuild
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/include/linux/netfilter_ipv4/Kbuild
+++ net-2.6.25/include/linux/netfilter_ipv4/Kbuild
@@ -9,7 +9,6 @@ header-y +=3D ipt_NFQUEUE.h
 header-y +=3D ipt_REJECT.h
 header-y +=3D ipt_SAME.h
 header-y +=3D ipt_TCPMSS.h
-header-y +=3D ipt_TOS.h
 header-y +=3D ipt_TTL.h
 header-y +=3D ipt_ULOG.h
 header-y +=3D ipt_addrtype.h
Index: net-2.6.25/net/ipv4/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/net/ipv4/netfilter/Kconfig
+++ net-2.6.25/net/ipv4/netfilter/Kconfig
@@ -302,16 +302,6 @@ config IP_NF_MANGLE
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
-config IP_NF_TARGET_TOS
-	tristate "TOS target support"
-	depends on IP_NF_MANGLE
-	help
-	  This option adds a `TOS' target, which allows you to create rules i=
n
-	  the `mangle' table which alter the Type Of Service field of an IP
-	  packet prior to routing.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_TARGET_ECN
 	tristate "ECN target support"
 	depends on IP_NF_MANGLE
Index: net-2.6.25/net/ipv4/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/net/ipv4/netfilter/Makefile
+++ net-2.6.25/net/ipv4/netfilter/Makefile
@@ -58,7 +58,6 @@ obj-$(CONFIG_IP_NF_TARGET_NETMAP) +=3D ipt
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) +=3D ipt_REDIRECT.o
 obj-$(CONFIG_IP_NF_TARGET_REJECT) +=3D ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_SAME) +=3D ipt_SAME.o
-obj-$(CONFIG_IP_NF_TARGET_TOS) +=3D ipt_TOS.o
 obj-$(CONFIG_IP_NF_TARGET_TTL) +=3D ipt_TTL.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) +=3D ipt_ULOG.o
=20
Index: net-2.6.25/net/ipv4/netfilter/ipt_TOS.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/net/ipv4/netfilter/ipt_TOS.c
+++ /dev/null
@@ -1,82 +0,0 @@
-/* This is a module which is used for setting the TOS field of a packe=
t. */
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
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <net/checksum.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_TOS.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("iptables TOS mangling module");
-
-static unsigned int
-tos_tg(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
-{
-	const struct ipt_tos_target_info *tosinfo =3D targinfo;
-	struct iphdr *iph =3D ip_hdr(skb);
-
-	if ((iph->tos & IPTOS_TOS_MASK) !=3D tosinfo->tos) {
-		__u8 oldtos;
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-		iph =3D ip_hdr(skb);
-		oldtos =3D iph->tos;
-		iph->tos =3D (iph->tos & IPTOS_PREC_MASK) | tosinfo->tos;
-		nf_csum_replace2(&iph->check, htons(oldtos), htons(iph->tos));
-	}
-	return XT_CONTINUE;
-}
-
-static bool
-tos_tg_check(const char *tablename, const void *e_void,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
-{
-	const u_int8_t tos =3D ((struct ipt_tos_target_info *)targinfo)->tos;
-
-	if (tos !=3D IPTOS_LOWDELAY
-	    && tos !=3D IPTOS_THROUGHPUT
-	    && tos !=3D IPTOS_RELIABILITY
-	    && tos !=3D IPTOS_MINCOST
-	    && tos !=3D IPTOS_NORMALSVC) {
-		printk(KERN_WARNING "TOS: bad tos value %#x\n", tos);
-		return false;
-	}
-	return true;
-}
-
-static struct xt_target tos_tg_reg __read_mostly =3D {
-	.name		=3D "TOS",
-	.family		=3D AF_INET,
-	.target		=3D tos_tg,
-	.targetsize	=3D sizeof(struct ipt_tos_target_info),
-	.table		=3D "mangle",
-	.checkentry	=3D tos_tg_check,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init tos_tg_init(void)
-{
-	return xt_register_target(&tos_tg_reg);
-}
-
-static void __exit tos_tg_exit(void)
-{
-	xt_unregister_target(&tos_tg_reg);
-}
-
-module_init(tos_tg_init);
-module_exit(tos_tg_exit);
Index: net-2.6.25/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/net/netfilter/Kconfig
+++ net-2.6.25/net/netfilter/Kconfig
@@ -411,6 +411,14 @@ config NETFILTER_XT_TARGET_TCPMSS
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_TARGET_TOS
+	tristate '"TOS" target support'
+	depends on NETFILTER_XTABLES
+	---help---
+	This option adds a "TOS" target, which allows you to create rules in
+	the "mangle" table to alter the Type Of Service field of an IPv4
+	packet or the Traffic Class field of an IPv6 packet prior to routing.
+
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
Index: net-2.6.25/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- net-2.6.25.orig/net/netfilter/Makefile
+++ net-2.6.25/net/netfilter/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) +=3D xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) +=3D xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) +=3D xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TOS) +=3D xt_TOS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) +=3D xt_TRACE.o
=20
 # matches
Index: net-2.6.25/net/netfilter/xt_TOS.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ net-2.6.25/net/netfilter/xt_TOS.c
@@ -0,0 +1,160 @@
+/* This is a module which is used for setting the TOS field of a packe=
t. */
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
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/checksum.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TOS.h>
+#include <linux/netfilter_ipv4/ipt_TOS.h>
+
+static unsigned int
+tos_tg4_v0(struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, unsigned int hooknum,
+           const struct xt_target *target, const void *targinfo)
+{
+	const struct ipt_tos_target_info *info =3D targinfo;
+	struct iphdr *iph =3D ip_hdr(skb);
+	u_int8_t old_tos;
+
+	if ((iph->tos & IPTOS_TOS_MASK) =3D=3D info->tos)
+		return XT_CONTINUE;
+
+	if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		return NF_DROP;
+
+	iph      =3D ip_hdr(skb);
+	old_tos  =3D iph->tos;
+	iph->tos =3D (iph->tos & IPTOS_PREC_MASK) | info->tos;
+	nf_csum_replace2(&iph->check, htons(old_tos), htons(iph->tos));
+	return XT_CONTINUE;
+}
+
+static unsigned int
+tos_tg4(struct sk_buff *skb, const struct net_device *in,
+        const struct net_device *out, unsigned int hooknum,
+        const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_tos_target_info *info =3D targinfo;
+	struct iphdr *iph =3D ip_hdr(skb);
+	u_int8_t old_tos;
+
+	if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		return NF_DROP;
+
+	iph       =3D ip_hdr(skb);
+	old_tos   =3D iph->tos;
+	iph->tos &=3D info->tos_mask;
+	iph->tos ^=3D info->tos_value;
+	nf_csum_replace2(&iph->check, htons(old_tos), htons(iph->tos));
+	return XT_CONTINUE;
+}
+
+static unsigned int
+tos_tg6(struct sk_buff *skb, const struct net_device *in,
+        const struct net_device *out, unsigned int hooknum,
+        const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_tos_target_info *info =3D targinfo;
+	struct ipv6hdr *iph =3D ipv6_hdr(skb);
+
+	if (!skb_make_writable(skb, sizeof(struct ipv6hdr)))
+		return NF_DROP;
+
+	iph            =3D ipv6_hdr(skb);
+	iph->priority &=3D info->tos_mask;
+	iph->priority ^=3D info->tos_value;
+	return XT_CONTINUE;
+}
+
+static bool
+tos_tg4_check_v0(const char *tablename, const void *e_void,
+                 const struct xt_target *target, void *targinfo,
+                 unsigned int hook_mask)
+{
+	const struct ipt_tos_target_info *info =3D targinfo;
+
+	if ((info->tos & ~IPTOS_TOS_MASK) !=3D 0) {
+		printk(KERN_WARNING KBUILD_MODNAME
+		       ": Bad TOS value %#x\n", info->tos);
+		return false;
+	}
+
+	return true;
+}
+
+static bool
+tos_tg6_check(const char *tablename, const void *e_void,
+              const struct xt_target *target, void *targinfo,
+              unsigned int hook_mask)
+{
+	const struct xt_tos_target_info *info =3D targinfo;
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
+static struct xt_target tos_tg_reg[] __read_mostly =3D {
+	{
+		.name       =3D "TOS",
+		.revision   =3D 0,
+		.family     =3D AF_INET,
+		.target     =3D tos_tg4_v0,
+		.targetsize =3D sizeof(struct ipt_tos_target_info),
+		.table      =3D "mangle",
+		.checkentry =3D tos_tg4_check_v0,
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "TOS",
+		.revision   =3D 1,
+		.family     =3D AF_INET,
+		.target     =3D tos_tg4,
+		.targetsize =3D sizeof(struct xt_tos_target_info),
+		.table      =3D "mangle",
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "TOS",
+		.revision   =3D 1,
+		.family     =3D AF_INET6,
+		.target     =3D tos_tg6,
+		.targetsize =3D sizeof(struct xt_tos_target_info),
+		.checkentry =3D tos_tg6_check,
+		.table      =3D "mangle",
+		.me         =3D THIS_MODULE,
+	},
+};
+
+static int __init tos_tg_init(void)
+{
+	return xt_register_targets(tos_tg_reg, ARRAY_SIZE(tos_tg_reg));
+}
+
+static void __exit tos_tg_exit(void)
+{
+	xt_unregister_targets(tos_tg_reg, ARRAY_SIZE(tos_tg_reg));
+}
+
+module_init(tos_tg_init);
+module_exit(tos_tg_exit);
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("netfilter \"TOS\" target module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_TOS");
+MODULE_ALIAS("ip6t_TOS");
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
