From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] xt_TOS
Date: Sat, 20 Oct 2007 13:45:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201345090.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38320 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbXJTLpY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:45:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Convert ipt_TOS to xt_TOS, adding support for IPv6.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_TOS.h |   12 +++
 net/netfilter/Kconfig            |    8 ++
 net/netfilter/Makefile           |    1=20
 net/netfilter/xt_TOS.c           |  130 ++++++++++++++++++++++++++++++=
+++++++++
 4 files changed, 151 insertions(+)

Index: gitone/include/linux/netfilter/xt_TOS.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ gitone/include/linux/netfilter/xt_TOS.h
@@ -0,0 +1,12 @@
+#ifndef _XT_TOS_TARGET_H
+#define _XT_TOS_TARGET_H
+
+#ifndef IPTOS_NORMALSVC
+#	define IPTOS_NORMALSVC 0
+#endif
+
+struct xt_TOS_info {
+	u_int8_t tos_value, tos_mask;
+};
+
+#endif /* _XT_TOS_TARGET_H */
Index: gitone/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- gitone.orig/net/netfilter/Kconfig
+++ gitone/net/netfilter/Kconfig
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
Index: gitone/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- gitone.orig/net/netfilter/Makefile
+++ gitone/net/netfilter/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) +=3D xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) +=3D xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) +=3D xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TOS) +=3D xt_TOS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) +=3D xt_TRACE.o
=20
 # matches
Index: gitone/net/netfilter/xt_TOS.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ gitone/net/netfilter/xt_TOS.c
@@ -0,0 +1,130 @@
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
+
+static unsigned int
+xt_TOS_target4(struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, unsigned int hooknum,
+               const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_TOS_info *info =3D targinfo;
+	struct iphdr *iph =3D ip_hdr(skb);
+	u_int8_t old_tos;
+
+	if ((iph->tos & IPTOS_TOS_MASK) =3D=3D info->tos_value)
+		return XT_CONTINUE;
+
+	if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		return NF_DROP;
+
+	iph      =3D ip_hdr(skb);
+	old_tos  =3D iph->tos;
+	iph->tos =3D (iph->tos & IPTOS_PREC_MASK) |
+	           ((iph->tos & info->tos_mask) ^ info->tos_value);
+	nf_csum_replace2(&iph->check, htons(old_tos), htons(iph->tos));
+	return XT_CONTINUE;
+}
+
+static unsigned int
+xt_TOS_target6(struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, unsigned int hooknum,
+               const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_TOS_info *info =3D targinfo;
+	struct ipv6hdr *iph =3D ipv6_hdr(skb);
+
+	if (iph->priority =3D=3D info->tos_value)
+		return XT_CONTINUE;
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
+xt_TOS_check(const char *tablename, const void *e_void,
+             const struct xt_target *target, void *targinfo,
+             unsigned int hook_mask)
+{
+	const struct xt_TOS_info *info =3D targinfo;
+
+	if (target->family =3D=3D AF_INET6 && info->tos_value > 0xF) {
+		printk(KERN_WARNING KBUILD_MODNAME
+		       ": Traffic Class field may only take values 0-15\n");
+		return false;
+	}
+
+	if (target->family =3D=3D AF_INET) {
+		if ((info->tos_value & ~IPTOS_TOS_MASK) !=3D 0) {
+			printk(KERN_WARNING KBUILD_MODNAME
+			       ": Bad TOS value %#x\n", info->tos_value);
+			return false;
+		}
+		if ((info->tos_mask & ~IPTOS_TOS_MASK) !=3D 0) {
+			printk(KERN_WARNING KBUILD_MODNAME
+			       ": Bad mask for TOS operation: %#x\n",
+			       info->tos_mask);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static struct xt_target xt_TOS_reg[] __read_mostly =3D {
+	{
+		.name		=3D "TOS",
+		.family		=3D AF_INET,
+		.target		=3D xt_TOS_target4,
+		.targetsize	=3D sizeof(struct xt_TOS_info),
+		.table		=3D "mangle",
+		.checkentry	=3D xt_TOS_check,
+		.me		=3D THIS_MODULE,
+	},
+	{
+		.name		=3D "TOS",
+		.family		=3D AF_INET6,
+		.target		=3D xt_TOS_target6,
+		.targetsize	=3D sizeof(struct xt_TOS_info),
+		.table		=3D "mangle",
+		.checkentry	=3D xt_TOS_check,
+		.me		=3D THIS_MODULE,
+	},
+};
+
+static int __init xt_TOS_init(void)
+{
+	return xt_register_targets(xt_TOS_reg, ARRAY_SIZE(xt_TOS_reg));
+}
+
+static void __exit xt_TOS_exit(void)
+{
+	xt_unregister_targets(xt_TOS_reg, ARRAY_SIZE(xt_TOS_reg));
+}
+
+module_init(xt_TOS_init);
+module_exit(xt_TOS_exit);
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
