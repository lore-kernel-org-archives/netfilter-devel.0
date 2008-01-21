From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/2] [NETFILTER]: xt_socket: rename from xt_owner
Date: Tue, 22 Jan 2008 00:23:19 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801220022580.25080@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47914 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762426AbYAUXXV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:23:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 7ed2d25d54b696074c8e787a03a1513d245e8caa
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Jan 21 13:34:48 2008 +0100

    [NETFILTER]: xt_socket: rename from xt_owner
   =20
    xt_owner matches against the ownership of a socket. Currently this
    only work in the output path when skb->sk is set. I recalled tproxy=
's
    xt_socket, which does an explicit socket for the input path and
    thought that this could be useful for xt_owner. Both modules would
    then do a lookup, so let's just combine the code into one module.
   =20
    This patch renames xt_owner to xt_socket; the tproxy bits and input
    path socket lookup will be added when tproxy gets merged.
   =20
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilt=
er/xt_owner.h
deleted file mode 100644
index eacd34e..0000000
--- a/include/linux/netfilter/xt_owner.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _XT_OWNER_MATCH_H
-#define _XT_OWNER_MATCH_H
-
-enum {
-	XT_OWNER_UID    =3D 1 << 0,
-	XT_OWNER_GID    =3D 1 << 1,
-	XT_OWNER_SOCKET =3D 1 << 2,
-};
-
-struct xt_owner_match_info {
-	u_int32_t uid;
-	u_int32_t gid;
-	u_int8_t match, invert;
-};
-
-#endif /* _XT_OWNER_MATCH_H */
diff --git a/include/linux/netfilter/xt_socket.h b/include/linux/netfil=
ter/xt_socket.h
new file mode 100644
index 0000000..5d7abb0
--- /dev/null
+++ b/include/linux/netfilter/xt_socket.h
@@ -0,0 +1,16 @@
+#ifndef _LINUX_NETFILTER_XT_SOCKET_H
+#define _LINUX_NETFILTER_XT_SOCKET_H 1
+
+enum {
+	XT_SOCKET_UID    =3D 1 << 0,
+	XT_SOCKET_GID    =3D 1 << 1,
+	XT_SOCKET_EXISTS =3D 1 << 2,
+};
+
+struct xt_socket_mtinfo {
+	u_int32_t uid;
+	u_int32_t gid;
+	u_int8_t match, invert;
+};
+
+#endif /* _LINUX_NETFILTER_XT_SOCKET_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index daf5b88..06e98d1 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -620,15 +620,6 @@ config NETFILTER_XT_MATCH_MARK
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
-config NETFILTER_XT_MATCH_OWNER
-	tristate '"owner" match support'
-	depends on NETFILTER_XTABLES
-	depends on NETFILTER_ADVANCED
-	---help---
-	Socket owner matching allows you to match locally-generated packets
-	based on who created the socket: the user or group. It is also
-	possible to check whether a socket actually exists.
-
 config NETFILTER_XT_MATCH_POLICY
 	tristate 'IPsec "policy" match support'
 	depends on NETFILTER_XTABLES && XFRM
@@ -723,6 +714,15 @@ config NETFILTER_XT_MATCH_SCTP
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
=20
+config NETFILTER_XT_MATCH_SOCKET
+	tristate '"socket" and "owner" match support'
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	---help---
+	Socket matching allows you to match locally-generated packets
+	based on who created the socket: the user or group. It is also
+	possible to check whether a socket actually exists.
+
 config NETFILTER_XT_MATCH_STATE
 	tristate '"state" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index ea75083..551c1e9 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -68,7 +68,6 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) +=3D xt_limit.=
o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) +=3D xt_mac.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MARK) +=3D xt_mark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MULTIPORT) +=3D xt_multiport.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_OWNER) +=3D xt_owner.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) +=3D xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) +=3D xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) +=3D xt_policy.o
@@ -76,6 +75,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) +=3D xt_quota.=
o
 obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) +=3D xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) +=3D xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) +=3D xt_sctp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_SOCKET) +=3D xt_socket.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) +=3D xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) +=3D xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) +=3D xt_string.o
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
deleted file mode 100644
index d382f9c..0000000
--- a/net/netfilter/xt_owner.c
+++ /dev/null
@@ -1,211 +0,0 @@
-/*
- * Kernel module to match various things tied to sockets associated wi=
th
- * locally generated outgoing packets.
- *
- * (C) 2000 Marc Boucher <marc@mbsi.ca>
- *
- * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
- * Contact: <jengelh@computergmbh.de>
- *
- * This program is free software; you can redistribute it and/or modif=
y
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/file.h>
-#include <net/sock.h>
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_owner.h>
-#include <linux/netfilter_ipv4/ipt_owner.h>
-#include <linux/netfilter_ipv6/ip6t_owner.h>
-
-static bool
-owner_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, const struct xt_match *match=
,
-            const void *matchinfo, int offset, unsigned int protoff,
-            bool *hotdrop)
-{
-	const struct ipt_owner_info *info =3D matchinfo;
-	const struct file *filp;
-
-	if (skb->sk =3D=3D NULL || skb->sk->sk_socket =3D=3D NULL)
-		return false;
-
-	filp =3D skb->sk->sk_socket->file;
-	if (filp =3D=3D NULL)
-		return false;
-
-	if (info->match & IPT_OWNER_UID)
-		if ((filp->f_uid !=3D info->uid) ^
-		    !!(info->invert & IPT_OWNER_UID))
-			return false;
-
-	if (info->match & IPT_OWNER_GID)
-		if ((filp->f_gid !=3D info->gid) ^
-		    !!(info->invert & IPT_OWNER_GID))
-			return false;
-
-	return true;
-}
-
-static bool
-owner_mt6_v0(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *matc=
h,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
-{
-	const struct ip6t_owner_info *info =3D matchinfo;
-	const struct file *filp;
-
-	if (skb->sk =3D=3D NULL || skb->sk->sk_socket =3D=3D NULL)
-		return false;
-
-	filp =3D skb->sk->sk_socket->file;
-	if (filp =3D=3D NULL)
-		return false;
-
-	if (info->match & IP6T_OWNER_UID)
-		if ((filp->f_uid !=3D info->uid) ^
-		    !!(info->invert & IP6T_OWNER_UID))
-			return false;
-
-	if (info->match & IP6T_OWNER_GID)
-		if ((filp->f_gid !=3D info->gid) ^
-		    !!(info->invert & IP6T_OWNER_GID))
-			return false;
-
-	return true;
-}
-
-static bool
-owner_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
-{
-	const struct xt_owner_match_info *info =3D matchinfo;
-	const struct file *filp;
-
-	if (skb->sk =3D=3D NULL || skb->sk->sk_socket =3D=3D NULL)
-		return (info->match ^ info->invert) =3D=3D 0;
-	else if (info->match & info->invert & XT_OWNER_SOCKET)
-		/*
-		 * Socket exists but user wanted ! --socket-exists.
-		 * (Single ampersands intended.)
-		 */
-		return false;
-
-	filp =3D skb->sk->sk_socket->file;
-	if (filp =3D=3D NULL)
-		return ((info->match ^ info->invert) &
-		       (XT_OWNER_UID | XT_OWNER_GID)) =3D=3D 0;
-
-	if (info->match & XT_OWNER_UID)
-		if ((filp->f_uid !=3D info->uid) ^
-		    !!(info->invert & XT_OWNER_UID))
-			return false;
-
-	if (info->match & XT_OWNER_GID)
-		if ((filp->f_gid !=3D info->gid) ^
-		    !!(info->invert & XT_OWNER_GID))
-			return false;
-
-	return true;
-}
-
-static bool
-owner_mt_check_v0(const char *tablename, const void *ip,
-                  const struct xt_match *match, void *matchinfo,
-                  unsigned int hook_mask)
-{
-	const struct ipt_owner_info *info =3D matchinfo;
-
-	if (info->match & (IPT_OWNER_PID | IPT_OWNER_SID | IPT_OWNER_COMM)) {
-		printk(KERN_WARNING KBUILD_MODNAME
-		       ": PID, SID and command matching is not "
-		       "supported anymore\n");
-		return false;
-	}
-
-	return true;
-}
-
-static bool
-owner_mt6_check_v0(const char *tablename, const void *ip,
-                   const struct xt_match *match, void *matchinfo,
-                   unsigned int hook_mask)
-{
-	const struct ip6t_owner_info *info =3D matchinfo;
-
-	if (info->match & (IP6T_OWNER_PID | IP6T_OWNER_SID)) {
-		printk(KERN_WARNING KBUILD_MODNAME
-		       ": PID and SID matching is not supported anymore\n");
-		return false;
-	}
-
-	return true;
-}
-
-static struct xt_match owner_mt_reg[] __read_mostly =3D {
-	{
-		.name       =3D "owner",
-		.revision   =3D 0,
-		.family     =3D AF_INET,
-		.match      =3D owner_mt_v0,
-		.matchsize  =3D sizeof(struct ipt_owner_info),
-		.checkentry =3D owner_mt_check_v0,
-		.hooks      =3D (1 << NF_INET_LOCAL_OUT) |
-		              (1 << NF_INET_POST_ROUTING),
-		.me         =3D THIS_MODULE,
-	},
-	{
-		.name       =3D "owner",
-		.revision   =3D 0,
-		.family     =3D AF_INET6,
-		.match      =3D owner_mt6_v0,
-		.matchsize  =3D sizeof(struct ip6t_owner_info),
-		.checkentry =3D owner_mt6_check_v0,
-		.hooks      =3D (1 << NF_INET_LOCAL_OUT) |
-		              (1 << NF_INET_POST_ROUTING),
-		.me         =3D THIS_MODULE,
-	},
-	{
-		.name       =3D "owner",
-		.revision   =3D 1,
-		.family     =3D AF_INET,
-		.match      =3D owner_mt,
-		.matchsize  =3D sizeof(struct xt_owner_match_info),
-		.hooks      =3D (1 << NF_INET_LOCAL_OUT) |
-		              (1 << NF_INET_POST_ROUTING),
-		.me         =3D THIS_MODULE,
-	},
-	{
-		.name       =3D "owner",
-		.revision   =3D 1,
-		.family     =3D AF_INET6,
-		.match      =3D owner_mt,
-		.matchsize  =3D sizeof(struct xt_owner_match_info),
-		.hooks      =3D (1 << NF_INET_LOCAL_OUT) |
-		              (1 << NF_INET_POST_ROUTING),
-		.me         =3D THIS_MODULE,
-	},
-};
-
-static int __init owner_mt_init(void)
-{
-	return xt_register_matches(owner_mt_reg, ARRAY_SIZE(owner_mt_reg));
-}
-
-static void __exit owner_mt_exit(void)
-{
-	xt_unregister_matches(owner_mt_reg, ARRAY_SIZE(owner_mt_reg));
-}
-
-module_init(owner_mt_init);
-module_exit(owner_mt_exit);
-MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
-MODULE_DESCRIPTION("Xtables: socket owner matching");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("ipt_owner");
-MODULE_ALIAS("ip6t_owner");
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
new file mode 100644
index 0000000..de5116f
--- /dev/null
+++ b/net/netfilter/xt_socket.c
@@ -0,0 +1,213 @@
+/*
+ *	xt_socket - socket property match
+ *
+ *	(C) 2000 Marc Boucher <marc@mbsi.ca>
+ *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
+ *	<jengelh@computergmbh.de>
+ *
+ *	This program is free software; you can redistribute it and/or modif=
y
+ *	it under the terms of the GNU General Public License version 2 as
+ *	published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/file.h>
+#include <net/sock.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_socket.h>
+#include <linux/netfilter_ipv4/ipt_owner.h>
+#include <linux/netfilter_ipv6/ip6t_owner.h>
+
+static bool
+owner_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, const struct xt_match *match=
,
+            const void *matchinfo, int offset, unsigned int protoff,
+            bool *hotdrop)
+{
+	const struct ipt_owner_info *info =3D matchinfo;
+	const struct file *filp;
+
+	if (skb->sk =3D=3D NULL || skb->sk->sk_socket =3D=3D NULL)
+		return false;
+
+	filp =3D skb->sk->sk_socket->file;
+	if (filp =3D=3D NULL)
+		return false;
+
+	if (info->match & IPT_OWNER_UID)
+		if ((filp->f_uid !=3D info->uid) ^
+		    !!(info->invert & IPT_OWNER_UID))
+			return false;
+
+	if (info->match & IPT_OWNER_GID)
+		if ((filp->f_gid !=3D info->gid) ^
+		    !!(info->invert & IPT_OWNER_GID))
+			return false;
+
+	return true;
+}
+
+static bool
+owner_mt6_v0(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *matc=
h,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
+{
+	const struct ip6t_owner_info *info =3D matchinfo;
+	const struct file *filp;
+
+	if (skb->sk =3D=3D NULL || skb->sk->sk_socket =3D=3D NULL)
+		return false;
+
+	filp =3D skb->sk->sk_socket->file;
+	if (filp =3D=3D NULL)
+		return false;
+
+	if (info->match & IP6T_OWNER_UID)
+		if ((filp->f_uid !=3D info->uid) ^
+		    !!(info->invert & IP6T_OWNER_UID))
+			return false;
+
+	if (info->match & IP6T_OWNER_GID)
+		if ((filp->f_gid !=3D info->gid) ^
+		    !!(info->invert & IP6T_OWNER_GID))
+			return false;
+
+	return true;
+}
+
+static bool
+socket_mt(const struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, const struct xt_match *match,
+          const void *matchinfo, int offset, unsigned int protoff,
+          bool *hotdrop)
+{
+	const struct xt_socket_mtinfo *info =3D matchinfo;
+	const struct file *filp;
+	const struct sock *sk;
+
+	sk =3D skb->sk;
+	if (sk =3D=3D NULL || sk->sk_socket =3D=3D NULL)
+		return (info->match ^ info->invert) =3D=3D 0;
+	else if (info->match & info->invert & XT_SOCKET_EXISTS)
+		/*
+		 * Socket exists but user wanted ! --socket-exists.
+		 * (Single ampersands intended.)
+		 */
+		return false;
+
+	filp =3D sk->sk_socket->file;
+	if (filp =3D=3D NULL)
+		return ((info->match ^ info->invert) &
+		       (XT_SOCKET_UID | XT_SOCKET_GID)) =3D=3D 0;
+
+	if (info->match & XT_SOCKET_UID)
+		if ((filp->f_uid !=3D info->uid) ^
+		    !!(info->invert & XT_SOCKET_UID))
+			return false;
+
+	if (info->match & XT_SOCKET_GID)
+		if ((filp->f_gid !=3D info->gid) ^
+		    !!(info->invert & XT_SOCKET_GID))
+			return false;
+
+	return true;
+}
+
+static bool
+owner_mt_check_v0(const char *tablename, const void *ip,
+                  const struct xt_match *match, void *matchinfo,
+                  unsigned int hook_mask)
+{
+	const struct ipt_owner_info *info =3D matchinfo;
+
+	if (info->match & (IPT_OWNER_PID | IPT_OWNER_SID | IPT_OWNER_COMM)) {
+		printk(KERN_WARNING KBUILD_MODNAME
+		       ": PID, SID and command matching is not "
+		       "supported anymore\n");
+		return false;
+	}
+
+	return true;
+}
+
+static bool
+owner_mt6_check_v0(const char *tablename, const void *ip,
+                   const struct xt_match *match, void *matchinfo,
+                   unsigned int hook_mask)
+{
+	const struct ip6t_owner_info *info =3D matchinfo;
+
+	if (info->match & (IP6T_OWNER_PID | IP6T_OWNER_SID)) {
+		printk(KERN_WARNING KBUILD_MODNAME
+		       ": PID and SID matching is not supported anymore\n");
+		return false;
+	}
+
+	return true;
+}
+
+static struct xt_match socket_mt_reg[] __read_mostly =3D {
+	{
+		.name       =3D "owner",
+		.revision   =3D 0,
+		.family     =3D AF_INET,
+		.match      =3D owner_mt_v0,
+		.matchsize  =3D sizeof(struct ipt_owner_info),
+		.checkentry =3D owner_mt_check_v0,
+		.hooks      =3D (1 << NF_INET_LOCAL_OUT) |
+		              (1 << NF_INET_POST_ROUTING),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "owner",
+		.revision   =3D 0,
+		.family     =3D AF_INET6,
+		.match      =3D owner_mt6_v0,
+		.matchsize  =3D sizeof(struct ip6t_owner_info),
+		.checkentry =3D owner_mt6_check_v0,
+		.hooks      =3D (1 << NF_INET_LOCAL_OUT) |
+		              (1 << NF_INET_POST_ROUTING),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "socket",
+		.revision   =3D 0,
+		.family     =3D AF_INET,
+		.match      =3D socket_mt,
+		.matchsize  =3D sizeof(struct xt_socket_mtinfo),
+		.hooks      =3D (1 << NF_INET_LOCAL_OUT) |
+		              (1 << NF_INET_POST_ROUTING),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "socket",
+		.revision   =3D 0,
+		.family     =3D AF_INET6,
+		.match      =3D socket_mt,
+		.matchsize  =3D sizeof(struct xt_socket_mtinfo),
+		.hooks      =3D (1 << NF_INET_LOCAL_OUT) |
+		              (1 << NF_INET_POST_ROUTING),
+		.me         =3D THIS_MODULE,
+	},
+};
+
+static int __init socket_mt_init(void)
+{
+	return xt_register_matches(socket_mt_reg, ARRAY_SIZE(socket_mt_reg));
+}
+
+static void __exit socket_mt_exit(void)
+{
+	xt_unregister_matches(socket_mt_reg, ARRAY_SIZE(socket_mt_reg));
+}
+
+module_init(socket_mt_init);
+module_exit(socket_mt_exit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
+MODULE_DESCRIPTION("Xtables: Socket owner matching");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_owner");
+MODULE_ALIAS("ip6t_owner");
+MODULE_ALIAS("ipt_socket");
+MODULE_ALIAS("ip6t_socket");

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
