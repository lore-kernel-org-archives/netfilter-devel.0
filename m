From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [13/13] [NETFILTER]: split off next-gen owner match into xt_socket
Date: Fri, 1 Feb 2008 00:24:45 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802010023550.4864@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56877 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYAaXYr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:24:47 -0500
In-Reply-To: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I would not be me if I did not try pushing this. Please consider!

===
commit 2fa078781b60ab577e9b59db38a77f52e35b3518
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Fri Feb 1 00:10:00 2008 +0100

    [NETFILTER]: split off next-gen owner match into xt_socket
    
    The "owner" match seems ripe for moving it to xt_socket, not only
    because ownership is actually a socket feature, but because once
    tproxy gets merged, xt_socket can easily be extended by anticipated
    (it comes up every now and then on IRC) input path processing. The
    reason the rename is done now is that once the module is in a Linus's
    tarball release, it is set in stone, so I would rather start using
    the name xt_socket now, because the ABI already changed, and I want
    to avoid another flag day later.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter/xt_owner.h        |   16 -------
 include/linux/netfilter/xt_socket.h       |   16 +++++++
 net/netfilter/Kconfig                     |   18 ++++----
 net/netfilter/Makefile                    |    2 +-
 net/netfilter/{xt_owner.c => xt_socket.c} |   48 +++++++++++----------
 5 files changed, 51 insertions(+), 49 deletions(-)
 delete mode 100644 include/linux/netfilter/xt_owner.h
 create mode 100644 include/linux/netfilter/xt_socket.h
 rename net/netfilter/{xt_owner.c => xt_socket.c} (82%)

diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilter/xt_owner.h
deleted file mode 100644
index c84e52c..0000000
--- a/include/linux/netfilter/xt_owner.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _XT_OWNER_MATCH_H
-#define _XT_OWNER_MATCH_H
-
-enum {
-	XT_OWNER_UID    = 1 << 0,
-	XT_OWNER_GID    = 1 << 1,
-	XT_OWNER_SOCKET = 1 << 2,
-};
-
-struct xt_owner_match_info {
-	u_int32_t uid_min, uid_max;
-	u_int32_t gid_min, gid_max;
-	u_int8_t match, invert;
-};
-
-#endif /* _XT_OWNER_MATCH_H */
diff --git a/include/linux/netfilter/xt_socket.h b/include/linux/netfilter/xt_socket.h
new file mode 100644
index 0000000..8393a47
--- /dev/null
+++ b/include/linux/netfilter/xt_socket.h
@@ -0,0 +1,16 @@
+#ifndef _XT_SOCKET_MATCH_H
+#define _XT_SOCKET_MATCH_H
+
+enum {
+	XT_SOCKET_UID    = 1 << 0,
+	XT_SOCKET_GID    = 1 << 1,
+	XT_SOCKET_EXISTS = 1 << 2,
+};
+
+struct xt_socket_mtinfo {
+	u_int32_t uid_min, uid_max;
+	u_int32_t gid_min, gid_max;
+	u_int8_t match, invert;
+};
+
+#endif /* _XT_SOCKET_MATCH_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 222aa07..ac4b24e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -620,15 +620,6 @@ config NETFILTER_XT_MATCH_MARK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
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
@@ -734,6 +725,15 @@ config NETFILTER_XT_MATCH_SCTP
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_SOCKET
+	tristate '"socket" match support'
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	---help---
+	Socket owner matching allows you to match locally-generated packets
+	based on who created the socket: the user or group. It is also
+	possible to check whether a socket actually exists.
+
 config NETFILTER_XT_MATCH_STATE
 	tristate '"state" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 9599083..702a5df 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -68,7 +68,6 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) += xt_limit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) += xt_mac.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MARK) += xt_mark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_MULTIPORT) += xt_multiport.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_OWNER) += xt_owner.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
@@ -77,6 +76,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_RECENT) += xt_recent.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_SOCKET) += xt_socket.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_socket.c
similarity index 82%
rename from net/netfilter/xt_owner.c
rename to net/netfilter/xt_socket.c
index 9059c16..9d37d13 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_socket.c
@@ -16,7 +16,7 @@
 #include <linux/file.h>
 #include <net/sock.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_owner.h>
+#include <linux/netfilter/xt_socket.h>
 #include <linux/netfilter_ipv4/ipt_owner.h>
 #include <linux/netfilter_ipv6/ip6t_owner.h>
 
@@ -79,17 +79,17 @@ owner_mt6_v0(const struct sk_buff *skb, const struct net_device *in,
 }
 
 static bool
-owner_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+socket_mt(const struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, const struct xt_match *match,
+          const void *matchinfo, int offset, unsigned int protoff,
+          bool *hotdrop)
 {
-	const struct xt_owner_match_info *info = matchinfo;
+	const struct xt_socket_mtinfo *info = matchinfo;
 	const struct file *filp;
 
 	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
 		return (info->match ^ info->invert) == 0;
-	else if (info->match & info->invert & XT_OWNER_SOCKET)
+	else if (info->match & info->invert & XT_SOCKET_EXISTS)
 		/*
 		 * Socket exists but user wanted ! --socket-exists.
 		 * (Single ampersands intended.)
@@ -99,18 +99,18 @@ owner_mt(const struct sk_buff *skb, const struct net_device *in,
 	filp = skb->sk->sk_socket->file;
 	if (filp == NULL)
 		return ((info->match ^ info->invert) &
-		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
+		       (XT_SOCKET_UID | XT_SOCKET_GID)) == 0;
 
-	if (info->match & XT_OWNER_UID)
+	if (info->match & XT_SOCKET_UID)
 		if ((filp->f_uid >= info->uid_min &&
 		    filp->f_uid <= info->uid_max) ^
-		    !(info->invert & XT_OWNER_UID))
+		    !(info->invert & XT_SOCKET_UID))
 			return false;
 
-	if (info->match & XT_OWNER_GID)
+	if (info->match & XT_SOCKET_GID)
 		if ((filp->f_gid >= info->gid_min &&
 		    filp->f_gid <= info->gid_max) ^
-		    !(info->invert & XT_OWNER_GID))
+		    !(info->invert & XT_SOCKET_GID))
 			return false;
 
 	return true;
@@ -149,7 +149,7 @@ owner_mt6_check_v0(const char *tablename, const void *ip,
 	return true;
 }
 
-static struct xt_match owner_mt_reg[] __read_mostly = {
+static struct xt_match socket_mt_reg[] __read_mostly = {
 	{
 		.name       = "owner",
 		.revision   = 0,
@@ -173,21 +173,21 @@ static struct xt_match owner_mt_reg[] __read_mostly = {
 		.me         = THIS_MODULE,
 	},
 	{
-		.name       = "owner",
-		.revision   = 1,
+		.name       = "socket",
+		.revision   = 0,
 		.family     = AF_INET,
-		.match      = owner_mt,
-		.matchsize  = sizeof(struct xt_owner_match_info),
+		.match      = socket_mt,
+		.matchsize  = sizeof(struct xt_socket_mtinfo),
 		.hooks      = (1 << NF_INET_LOCAL_OUT) |
 		              (1 << NF_INET_POST_ROUTING),
 		.me         = THIS_MODULE,
 	},
 	{
-		.name       = "owner",
-		.revision   = 1,
+		.name       = "socket",
+		.revision   = 0,
 		.family     = AF_INET6,
-		.match      = owner_mt,
-		.matchsize  = sizeof(struct xt_owner_match_info),
+		.match      = socket_mt,
+		.matchsize  = sizeof(struct xt_socket_mtinfo),
 		.hooks      = (1 << NF_INET_LOCAL_OUT) |
 		              (1 << NF_INET_POST_ROUTING),
 		.me         = THIS_MODULE,
@@ -196,12 +196,12 @@ static struct xt_match owner_mt_reg[] __read_mostly = {
 
 static int __init owner_mt_init(void)
 {
-	return xt_register_matches(owner_mt_reg, ARRAY_SIZE(owner_mt_reg));
+	return xt_register_matches(socket_mt_reg, ARRAY_SIZE(socket_mt_reg));
 }
 
 static void __exit owner_mt_exit(void)
 {
-	xt_unregister_matches(owner_mt_reg, ARRAY_SIZE(owner_mt_reg));
+	xt_unregister_matches(socket_mt_reg, ARRAY_SIZE(socket_mt_reg));
 }
 
 module_init(owner_mt_init);
@@ -211,3 +211,5 @@ MODULE_DESCRIPTION("Xtables: socket owner matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_owner");
 MODULE_ALIAS("ip6t_owner");
+MODULE_ALIAS("ipt_socket");
+MODULE_ALIAS("ip6t_socket");
