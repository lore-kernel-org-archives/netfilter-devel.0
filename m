From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/49]: merge ipt_owner/ip6t_owner in xt_owner
Date: Tue,  4 Dec 2007 13:02:03 +0100 (MET)
Message-ID: <20071204120203.2442.60635.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62115 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXLDMCF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:05 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: merge ipt_owner/ip6t_owner in xt_owner

xt_owner merges ipt_owner and ip6t_owner, and adds a flag to match
on socket (non-)existence.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 120d4e83e930079caf86168dea4ee6f3eab1fe88
tree f3f5d11d19ef83ccd2284557e8059d961cecef60
parent f4026219449cce39bca209261cfff7ff9a8febfd
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 04 Dec 2007 10:46:=
58 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:46:58 +=
0100

 include/linux/netfilter/Kbuild     |    1=20
 include/linux/netfilter/xt_owner.h |   16 +++
 net/ipv4/netfilter/Kconfig         |    9 --
 net/ipv4/netfilter/Makefile        |    1=20
 net/ipv4/netfilter/ipt_owner.c     |   87 ---------------
 net/ipv6/netfilter/Kconfig         |    9 --
 net/ipv6/netfilter/Makefile        |    1=20
 net/ipv6/netfilter/ip6t_owner.c    |   87 ---------------
 net/netfilter/Kconfig              |    8 +
 net/netfilter/Makefile             |    1=20
 net/netfilter/xt_owner.c           |  211 ++++++++++++++++++++++++++++=
++++++++
 11 files changed, 237 insertions(+), 194 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/K=
build
index b87e83a..1e69002 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -26,6 +26,7 @@ header-y +=3D xt_limit.h
 header-y +=3D xt_mac.h
 header-y +=3D xt_mark.h
 header-y +=3D xt_multiport.h
+header-y +=3D xt_owner.h
 header-y +=3D xt_pkttype.h
 header-y +=3D xt_policy.h
 header-y +=3D xt_realm.h
diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilt=
er/xt_owner.h
new file mode 100644
index 0000000..eacd34e
--- /dev/null
+++ b/include/linux/netfilter/xt_owner.h
@@ -0,0 +1,16 @@
+#ifndef _XT_OWNER_MATCH_H
+#define _XT_OWNER_MATCH_H
+
+enum {
+	XT_OWNER_UID    =3D 1 << 0,
+	XT_OWNER_GID    =3D 1 << 1,
+	XT_OWNER_SOCKET =3D 1 << 2,
+};
+
+struct xt_owner_match_info {
+	u_int32_t uid;
+	u_int32_t gid;
+	u_int8_t match, invert;
+};
+
+#endif /* _XT_OWNER_MATCH_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 9aca9c5..6c563d9 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -111,15 +111,6 @@ config IP_NF_MATCH_TTL
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
-config IP_NF_MATCH_OWNER
-	tristate "Owner match support"
-	depends on IP_NF_IPTABLES
-	help
-	  Packet owner matching allows you to match locally-generated packets
-	  based on who created them: the user, group, process or session.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_ADDRTYPE
 	tristate  'address type match support'
 	depends on IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 7456833..42199e9 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -45,7 +45,6 @@ obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) +=3D ipt_addrtype.=
o
 obj-$(CONFIG_IP_NF_MATCH_AH) +=3D ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) +=3D ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) +=3D ipt_iprange.o
-obj-$(CONFIG_IP_NF_MATCH_OWNER) +=3D ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) +=3D ipt_recent.o
 obj-$(CONFIG_IP_NF_MATCH_TOS) +=3D ipt_tos.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) +=3D ipt_ttl.o
diff --git a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_ow=
ner.c
deleted file mode 100644
index 4f1aa89..0000000
--- a/net/ipv4/netfilter/ipt_owner.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/* Kernel module to match various things tied to sockets associated wi=
th
-   locally generated outgoing packets. */
-
-/* (C) 2000 Marc Boucher <marc@mbsi.ca>
- *
- * This program is free software; you can redistribute it and/or modif=
y
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/file.h>
-#include <linux/rcupdate.h>
-#include <net/sock.h>
-
-#include <linux/netfilter_ipv4/ipt_owner.h>
-#include <linux/netfilter/x_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("iptables owner match");
-
-static bool
-owner_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
-{
-	const struct ipt_owner_info *info =3D matchinfo;
-
-	if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
-		return false;
-
-	if(info->match & IPT_OWNER_UID) {
-		if ((skb->sk->sk_socket->file->f_uid !=3D info->uid) ^
-		    !!(info->invert & IPT_OWNER_UID))
-			return false;
-	}
-
-	if(info->match & IPT_OWNER_GID) {
-		if ((skb->sk->sk_socket->file->f_gid !=3D info->gid) ^
-		    !!(info->invert & IPT_OWNER_GID))
-			return false;
-	}
-
-	return true;
-}
-
-static bool
-owner_mt_check(const char *tablename, const void *ip,
-               const struct xt_match *match, void *matchinfo,
-               unsigned int hook_mask)
-{
-	const struct ipt_owner_info *info =3D matchinfo;
-
-	if (info->match & (IPT_OWNER_PID|IPT_OWNER_SID|IPT_OWNER_COMM)) {
-		printk("ipt_owner: pid, sid and command matching "
-		       "not supported anymore\n");
-		return false;
-	}
-	return true;
-}
-
-static struct xt_match owner_mt_reg __read_mostly =3D {
-	.name		=3D "owner",
-	.family		=3D AF_INET,
-	.match		=3D owner_mt,
-	.matchsize	=3D sizeof(struct ipt_owner_info),
-	.hooks		=3D (1 << NF_INET_LOCAL_OUT) |
-			  (1 << NF_INET_POST_ROUTING),
-	.checkentry	=3D owner_mt_check,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init owner_mt_init(void)
-{
-	return xt_register_match(&owner_mt_reg);
-}
-
-static void __exit owner_mt_exit(void)
-{
-	xt_unregister_match(&owner_mt_reg);
-}
-
-module_init(owner_mt_init);
-module_exit(owner_mt_exit);
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 838b8dd..30d4852 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -89,15 +89,6 @@ config IP6_NF_MATCH_HL
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
-config IP6_NF_MATCH_OWNER
-	tristate "Owner match support"
-	depends on IP6_NF_IPTABLES
-	help
-	  Packet owner matching allows you to match locally-generated packets
-	  based on who created them: the user, group, process or session.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP6_NF_MATCH_IPV6HEADER
 	tristate "IPv6 Extension Headers Match"
 	depends on IP6_NF_IPTABLES
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index e789ec4..fbf2c14 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -23,7 +23,6 @@ obj-$(CONFIG_IP6_NF_MATCH_HL) +=3D ip6t_hl.o
 obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) +=3D ip6t_ipv6header.o
 obj-$(CONFIG_IP6_NF_MATCH_MH) +=3D ip6t_mh.o
 obj-$(CONFIG_IP6_NF_MATCH_OPTS) +=3D ip6t_hbh.o
-obj-$(CONFIG_IP6_NF_MATCH_OWNER) +=3D ip6t_owner.o
 obj-$(CONFIG_IP6_NF_MATCH_RT) +=3D ip6t_rt.o
=20
 # targets
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_=
owner.c
deleted file mode 100644
index 6a52ed9..0000000
--- a/net/ipv6/netfilter/ip6t_owner.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/* Kernel module to match various things tied to sockets associated wi=
th
-   locally generated outgoing packets. */
-
-/* (C) 2000-2001 Marc Boucher <marc@mbsi.ca>
- *
- * This program is free software; you can redistribute it and/or modif=
y
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/file.h>
-#include <linux/rcupdate.h>
-#include <net/sock.h>
-
-#include <linux/netfilter_ipv6/ip6t_owner.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter/x_tables.h>
-
-MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("IP6 tables owner matching module");
-MODULE_LICENSE("GPL");
-
-
-static bool
-owner_mt6(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
-{
-	const struct ip6t_owner_info *info =3D matchinfo;
-
-	if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
-		return false;
-
-	if (info->match & IP6T_OWNER_UID)
-		if ((skb->sk->sk_socket->file->f_uid !=3D info->uid) ^
-		    !!(info->invert & IP6T_OWNER_UID))
-			return false;
-
-	if (info->match & IP6T_OWNER_GID)
-		if ((skb->sk->sk_socket->file->f_gid !=3D info->gid) ^
-		    !!(info->invert & IP6T_OWNER_GID))
-			return false;
-
-	return true;
-}
-
-static bool
-owner_mt6_check(const char *tablename, const void *ip,
-                const struct xt_match *match, void *matchinfo,
-                unsigned int hook_mask)
-{
-	const struct ip6t_owner_info *info =3D matchinfo;
-
-	if (info->match & (IP6T_OWNER_PID | IP6T_OWNER_SID)) {
-		printk("ipt_owner: pid and sid matching "
-		       "not supported anymore\n");
-		return false;
-	}
-	return true;
-}
-
-static struct xt_match owner_mt6_reg __read_mostly =3D {
-	.name		=3D "owner",
-	.family		=3D AF_INET6,
-	.match		=3D owner_mt6,
-	.matchsize	=3D sizeof(struct ip6t_owner_info),
-	.hooks		=3D (1 << NF_INET_LOCAL_OUT) |
-			  (1 << NF_INET_POST_ROUTING),
-	.checkentry	=3D owner_mt6_check,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init owner_mt6_init(void)
-{
-	return xt_register_match(&owner_mt6_reg);
-}
-
-static void __exit owner_mt6_exit(void)
-{
-	xt_unregister_match(&owner_mt6_reg);
-}
-
-module_init(owner_mt6_init);
-module_exit(owner_mt6_exit);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 693f861..4bc0552 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -554,6 +554,14 @@ config NETFILTER_XT_MATCH_MARK
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_MATCH_OWNER
+	tristate '"owner" match support'
+	depends on NETFILTER_XTABLES
+	---help---
+	Socket owner matching allows you to match locally-generated packets
+	based on who created the socket: the user or group. It is also
+	possible to check whether a socket actually exists.
+
 config NETFILTER_XT_MATCH_POLICY
 	tristate 'IPsec "policy" match support'
 	depends on NETFILTER_XTABLES && XFRM
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 7763dea..28f59a3 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) +=3D xt_limit.=
o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) +=3D xt_mac.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MARK) +=3D xt_mark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MULTIPORT) +=3D xt_multiport.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_OWNER) +=3D xt_owner.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) +=3D xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) +=3D xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) +=3D xt_policy.o
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
new file mode 100644
index 0000000..4222fa2
--- /dev/null
+++ b/net/netfilter/xt_owner.c
@@ -0,0 +1,211 @@
+/*
+ * Kernel module to match various things tied to sockets associated wi=
th
+ * locally generated outgoing packets.
+ *
+ * (C) 2000 Marc Boucher <marc@mbsi.ca>
+ *
+ * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
+ * Contact: <jengelh@computergmbh.de>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/file.h>
+#include <net/sock.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_owner.h>
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
+owner_mt(const struct sk_buff *skb, const struct net_device *in,
+         const struct net_device *out, const struct xt_match *match,
+         const void *matchinfo, int offset, unsigned int protoff,
+         bool *hotdrop)
+{
+	const struct xt_owner_match_info *info =3D matchinfo;
+	const struct file *filp;
+
+	if (skb->sk =3D=3D NULL || skb->sk->sk_socket =3D=3D NULL)
+		return (info->match ^ info->invert) =3D=3D 0;
+	else if (info->match & info->invert & XT_OWNER_SOCKET)
+		/*
+		 * Socket exists but user wanted ! --socket-exists.
+		 * (Single ampersands intended.)
+		 */
+		return false;
+
+	filp =3D skb->sk->sk_socket->file;
+	if (filp =3D=3D NULL)
+		return ((info->match ^ info->invert) &
+		       (XT_OWNER_UID | XT_OWNER_GID)) =3D=3D 0;
+
+	if (info->match & XT_OWNER_UID)
+		if ((filp->f_uid !=3D info->uid) ^
+		    !!(info->invert & XT_OWNER_UID))
+			return false;
+
+	if (info->match & XT_OWNER_GID)
+		if ((filp->f_gid !=3D info->gid) ^
+		    !!(info->invert & XT_OWNER_GID))
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
+static struct xt_match owner_mt_reg[] __read_mostly =3D {
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
+		.name       =3D "owner",
+		.revision   =3D 1,
+		.family     =3D AF_INET,
+		.match      =3D owner_mt,
+		.matchsize  =3D sizeof(struct xt_owner_match_info),
+		.hooks      =3D (1 << NF_INET_LOCAL_OUT) |
+		              (1 << NF_INET_POST_ROUTING),
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "owner",
+		.revision   =3D 1,
+		.family     =3D AF_INET6,
+		.match      =3D owner_mt,
+		.matchsize  =3D sizeof(struct xt_owner_match_info),
+		.hooks      =3D (1 << NF_INET_LOCAL_OUT) |
+		              (1 << NF_INET_POST_ROUTING),
+		.me         =3D THIS_MODULE,
+	},
+};
+
+static int __init owner_mt_init(void)
+{
+	return xt_register_matches(owner_mt_reg, ARRAY_SIZE(owner_mt_reg));
+}
+
+static void __exit owner_mt_exit(void)
+{
+	xt_unregister_matches(owner_mt_reg, ARRAY_SIZE(owner_mt_reg));
+}
+
+module_init(owner_mt_init);
+module_exit(owner_mt_exit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
+MODULE_DESCRIPTION("netfilter \"owner\" match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_owner");
+MODULE_ALIAS("ip6t_owner");
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
