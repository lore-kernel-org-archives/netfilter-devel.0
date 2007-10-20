From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] xt_owner
Date: Sat, 20 Oct 2007 13:45:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201345230.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38328 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321AbXJTLpe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:45:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Convert ipt_owner to xt_owner, adding support for IPv6.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_owner.h |   15 ++++++
 net/netfilter/Kconfig              |    7 +++
 net/netfilter/Makefile             |    1=20
 net/netfilter/xt_owner.c           |   82 ++++++++++++++++++++++++++++=
+++++++++
 4 files changed, 105 insertions(+)

Index: gitone/include/linux/netfilter/xt_owner.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ gitone/include/linux/netfilter/xt_owner.h
@@ -0,0 +1,15 @@
+#ifndef _XT_OWNER_MATCH_H
+#define _XT_OWNER_MATCH_H
+
+enum {
+	XT_OWNER_UID =3D 1 << 0,
+	XT_OWNER_GID =3D 1 << 1,
+};
+
+struct xt_owner_info {
+	u_int32_t uid;
+	u_int32_t gid;
+	u_int8_t match, invert;
+};
+
+#endif /* _XT_OWNER_MATCH_H */
Index: gitone/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- gitone.orig/net/netfilter/Kconfig
+++ gitone/net/netfilter/Kconfig
@@ -554,6 +554,13 @@ config NETFILTER_XT_MATCH_MARK
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_MATCH_OWNER
+	tristate '"owner" match support'
+	depends on NETFILTER_XTABLES
+	---help---
+	Socket owner matching allows you to match locally-generated packets
+	based on who created the socket: the user, group, process or session.
+
 config NETFILTER_XT_MATCH_POLICY
 	tristate 'IPsec "policy" match support'
 	depends on NETFILTER_XTABLES && XFRM
Index: gitone/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- gitone.orig/net/netfilter/Makefile
+++ gitone/net/netfilter/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) +
 obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) +=3D xt_mac.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MARK) +=3D xt_mark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MULTIPORT) +=3D xt_multiport.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_OWNER) +=3D xt_owner.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) +=3D xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) +=3D xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) +=3D xt_policy.o
Index: gitone/net/netfilter/xt_owner.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ gitone/net/netfilter/xt_owner.c
@@ -0,0 +1,82 @@
+/* Kernel module to match various things tied to sockets associated wi=
th
+   locally generated outgoing packets. */
+
+/*
+ * (C) 2000 Marc Boucher <marc@mbsi.ca>
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
+#include <linux/file.h>
+#include <net/sock.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_owner.h>
+
+static bool
+xt_owner_match(const struct sk_buff *skb, const struct net_device *in,
+               const struct net_device *out, const struct xt_match *ma=
tch,
+               const void *matchinfo, int offset, unsigned int protoff=
,
+               bool *hotdrop)
+{
+	const struct xt_owner_info *info =3D matchinfo;
+
+	if (skb->sk =3D=3D NULL || skb->sk->sk_socket =3D=3D NULL ||
+	    skb->sk->sk_socket->file =3D=3D NULL)
+		return false;
+
+	if (info->match & XT_OWNER_UID)
+		if ((skb->sk->sk_socket->file->f_uid !=3D info->uid) ^
+		    !!(info->invert & XT_OWNER_UID))
+			return false;
+
+	if (info->match & XT_OWNER_GID)
+		if ((skb->sk->sk_socket->file->f_gid !=3D info->gid) ^
+		    !!(info->invert & XT_OWNER_GID))
+			return false;
+
+	return true;
+}
+
+static struct xt_match xt_owner_reg[] __read_mostly =3D {
+	{
+		.name       =3D "owner",
+		.family     =3D AF_INET,
+		.match      =3D xt_owner_match,
+		.matchsize  =3D sizeof(struct xt_owner_info),
+		.hooks      =3D (1 << NF_IP_LOCAL_OUT) |
+		              (1 << NF_IP_POST_ROUTING),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "owner",
+		.family     =3D AF_INET6,
+		.match      =3D xt_owner_match,
+		.matchsize  =3D sizeof(struct xt_owner_info),
+		.hooks      =3D (1 << NF_IP_LOCAL_OUT) |
+		              (1 << NF_IP_POST_ROUTING),
+		.me         =3D THIS_MODULE,
+	},
+};
+
+static int __init xt_owner_init(void)
+{
+	return xt_register_matches(xt_owner_reg, ARRAY_SIZE(xt_owner_reg));
+}
+
+static void __exit xt_owner_exit(void)
+{
+	xt_unregister_matches(xt_owner_reg, ARRAY_SIZE(xt_owner_reg));
+}
+
+module_init(xt_owner_init);
+module_exit(xt_owner_exit);
+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
+MODULE_DESCRIPTION("iptables owner match");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_owner");
+MODULE_ALIAS("ip6t_owner");

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
