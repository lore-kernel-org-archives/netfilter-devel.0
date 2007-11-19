From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCHv4 2/2] Addrtype match: limit addrtype check to an interface. Moved to xtables
Date: Mon, 19 Nov 2007 16:55:47 +0100
Message-ID: <11954877481145-git-send-email-panther@balabit.hu>
References: <11954877483732-git-send-email-panther@balabit.hu>
 <11954877481813-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:52363 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbXKSPzz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:55:55 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 1FDE0C160C
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Nov 2007 16:55:54 +0100 (CET)
In-Reply-To: <11954877481813-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Addrtype match has a new revision (1), which lets address type checking
limited to the interface the current packet belongs to. Either incoming
or outgoing interface can be used depending on the current hook. In the
FORWARD hook two maches should be used if both interfaces have to be checked.
This revision uses xt_addrtype.h and it is xt_addrtype.c

Revision 0 lets older userspace programs use the match as earlier. The old
header, ipt_addrtype.h is used.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 include/linux/netfilter/xt_addrtype.h |   18 ++++
 net/ipv4/netfilter/Kconfig            |   10 --
 net/ipv4/netfilter/Makefile           |    1 -
 net/ipv4/netfilter/ipt_addrtype.c     |   66 ---------------
 net/netfilter/Kconfig                 |   12 +++-
 net/netfilter/Makefile                |    1 +
 net/netfilter/xt_addrtype.c           |  149 +++++++++++++++++++++++++++++++++
 7 files changed, 179 insertions(+), 78 deletions(-)

diff --git a/include/linux/netfilter/xt_addrtype.h b/include/linux/netfilter/xt_addrtype.h
new file mode 100644
index 0000000..e3f0fd5
--- /dev/null
+++ b/include/linux/netfilter/xt_addrtype.h
@@ -0,0 +1,18 @@
+#ifndef _XT_ADDRTYPE_H
+#define _XT_ADDRTYPE_H
+
+enum
+{
+	XT_ADDRTYPE_INVERT_SOURCE	= 0x0001,
+	XT_ADDRTYPE_INVERT_DEST		= 0x0002,
+	XT_ADDRTYPE_LIMIT_IFACE_IN	= 0x0004,
+	XT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
+};
+
+struct xt_addrtype_info {
+	u_int16_t	source;		/* source-type mask */
+	u_int16_t	dest;		/* dest-type mask */
+	u_int32_t	flags;
+};
+
+#endif
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 9aca9c5..4086ab2 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -120,16 +120,6 @@ config IP_NF_MATCH_OWNER
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_MATCH_ADDRTYPE
-	tristate  'address type match support'
-	depends on IP_NF_IPTABLES
-	help
-	  This option allows you to match what routing thinks of an address,
-	  eg. UNICAST, LOCAL, BROADCAST, ...
-	
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
-
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 7456833..f107ade 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -41,7 +41,6 @@ obj-$(CONFIG_NF_NAT) += iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 
 # matches
-obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
deleted file mode 100644
index 59f01f7..0000000
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ /dev/null
@@ -1,66 +0,0 @@
-/*
- *  iptables module to match inet_addr_type() of an ip.
- *
- *  Copyright (c) 2004 Patrick McHardy <kaber@trash.net>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <linux/ip.h>
-#include <net/route.h>
-
-#include <linux/netfilter_ipv4/ipt_addrtype.h>
-#include <linux/netfilter/x_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("iptables addrtype match");
-
-static inline bool match_type(__be32 addr, u_int16_t mask)
-{
-	return !!(mask & (1 << inet_addr_type(addr)));
-}
-
-static bool match(const struct sk_buff *skb,
-		  const struct net_device *in, const struct net_device *out,
-		  const struct xt_match *match, const void *matchinfo,
-		  int offset, unsigned int protoff, bool *hotdrop)
-{
-	const struct ipt_addrtype_info *info = matchinfo;
-	const struct iphdr *iph = ip_hdr(skb);
-	bool ret = true;
-
-	if (info->source)
-		ret &= match_type(iph->saddr, info->source)^info->invert_source;
-	if (info->dest)
-		ret &= match_type(iph->daddr, info->dest)^info->invert_dest;
-
-	return ret;
-}
-
-static struct xt_match addrtype_match __read_mostly = {
-	.name		= "addrtype",
-	.family		= AF_INET,
-	.match		= match,
-	.matchsize	= sizeof(struct ipt_addrtype_info),
-	.me		= THIS_MODULE
-};
-
-static int __init ipt_addrtype_init(void)
-{
-	return xt_register_match(&addrtype_match);
-}
-
-static void __exit ipt_addrtype_fini(void)
-{
-	xt_unregister_match(&addrtype_match);
-}
-
-module_init(ipt_addrtype_init);
-module_exit(ipt_addrtype_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 21a9fcc..acff1db 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -363,7 +363,7 @@ config NETFILTER_XT_TARGET_TRACE
 	  the tables, chains, rules.
 
 	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_SECMARK
 	tristate '"SECMARK" target support'
@@ -411,6 +411,16 @@ config NETFILTER_XT_TARGET_TCPMSS
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_ADDRTYPE
+	tristate  'address type match support'
+	depends on NETFILTER_XTABLES
+	help
+	  This option allows you to match what routing thinks of an address,
+	  eg. UNICAST, LOCAL, BROADCAST, ...
+	
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index ad0e36e..22dac5c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 
 # matches
+obj-$(CONFIG_NETFILTER_XT_MATCH_ADDRTYPE)+= xt_addrtype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTES) += xt_connbytes.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNLIMIT) += xt_connlimit.o
diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
new file mode 100644
index 0000000..f463c34
--- /dev/null
+++ b/net/netfilter/xt_addrtype.c
@@ -0,0 +1,149 @@
+/*
+ *  iptables module to match inet_addr_type() of an ip.
+ *
+ *  Copyright (c) 2004 Patrick McHardy <kaber@trash.net>
+ *  (C) 2007 Laszlo Attila Toth <panther@balabit.hu>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/ip.h>
+#include <net/route.h>
+
+#include <linux/netfilter_ipv4/ipt_addrtype.h>
+#include <linux/netfilter/xt_addrtype.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("iptables addrtype match");
+MODULE_ALIAS("ipt_addrtype");
+
+static inline bool match_type(__be32 addr,
+			      const struct net_device *in,
+			      u_int16_t mask)
+{
+	return !!(mask & (1 << inet_dev_addr_type(addr, in)));
+}
+
+static bool addrtype_match_v0(const struct sk_buff *skb,
+			      const struct net_device *in,
+			      const struct net_device *out,
+			      const struct xt_match *match,
+			      const void *matchinfo,
+			      int offset,
+			      unsigned int protoff,
+			      bool *hotdrop)
+{
+	const struct ipt_addrtype_info *info = matchinfo;
+	const struct iphdr *iph = ip_hdr(skb);
+	bool ret = true;
+
+	if (info->source)
+		ret &= match_type(iph->saddr, NULL, info->source)^info->invert_source;
+	if (ret && info->dest)
+		ret &= match_type(iph->daddr, NULL, info->dest)^info->invert_dest;
+
+	return ret;
+}
+
+static bool addrtype_match(const struct sk_buff *skb,
+			   const struct net_device *in,
+			   const struct net_device *out,
+			   const struct xt_match *match,
+			   const void *matchinfo,
+			   int offset,
+			   unsigned int protoff,
+			   bool *hotdrop)
+{
+	const struct xt_addrtype_info *info = matchinfo;
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct net_device *limit_dev = NULL;
+	bool ret = true;
+
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN)
+		limit_dev = in;
+	else if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT)
+		limit_dev = out;
+
+
+	if (info->source)
+		ret &= match_type(iph->saddr, limit_dev, info->source) ^
+			(info->flags & XT_ADDRTYPE_INVERT_SOURCE);
+	if (ret && info->dest)
+		ret &= match_type(iph->daddr, limit_dev, info->dest) ^
+			(info->flags & XT_ADDRTYPE_INVERT_DEST);
+
+	return ret;
+}
+
+static bool addrtype_checkentry(const char *tablename,
+				const void *ip_void,
+				const struct xt_match *match,
+				void *matchinfo,
+				unsigned int hook_mask)
+{
+	struct xt_addrtype_info *info = matchinfo;
+
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN &&
+	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printk(KERN_ERR "ipt_addrtype: both incoming and outgoing interface"
+				"limitation cannot be selected\n");
+		return false;
+	}
+
+	if (hook_mask & (1 << NF_INET_PRE_ROUTING | 1 << NF_INET_LOCAL_IN) &&
+	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) {
+		printk(KERN_ERR "ipt_addrtype: output interface limitation "
+				"not valid in PRE_ROUTING and INPUT\n");
+		return false;
+	}
+	if (hook_mask & (1 << NF_INET_POST_ROUTING | 1 << NF_INET_LOCAL_OUT) &&
+	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN) {
+		printk(KERN_ERR "ipt_addrtype: input interface limitation "
+				"not valid in POST_ROUTING and OUTPUT\n");
+		return false;
+	}
+	return true;
+}
+
+static struct xt_match xt_addrtype_match[] __read_mostly = {
+	{
+		.name		= "addrtype",
+		.family		= AF_INET,
+		.revision	= 0,
+		.match		= addrtype_match_v0,
+		.matchsize	= sizeof(struct ipt_addrtype_info),
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "addrtype",
+		.family		= AF_INET,
+		.revision	= 1,
+		.match		= addrtype_match,
+		.checkentry	= addrtype_checkentry,
+		.matchsize	= sizeof(struct xt_addrtype_info),
+		.me		= THIS_MODULE
+	}
+};
+
+static int __init xt_addrtype_init(void)
+{
+	return xt_register_matches(xt_addrtype_match,
+			ARRAY_SIZE(xt_addrtype_match));
+}
+
+static void __exit xt_addrtype_fini(void)
+{
+	xt_unregister_matches(xt_addrtype_match,
+			ARRAY_SIZE(xt_addrtype_match));
+}
+
+module_init(xt_addrtype_init);
+module_exit(xt_addrtype_fini);
-- 
1.5.2.5

