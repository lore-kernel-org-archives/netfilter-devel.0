From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/4][IPTABLES] u32 iptables match
Date: Fri, 10 Nov 2006 02:23:13 +0100
Message-ID: <4553D481.6040202@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010202080904010400030700"
Cc: Michael Rash <mbr@cipherdyne.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010202080904010400030700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Introduce a `u32' match which allows to extract quantities of up to 4
bytes from a packet and test whether the result is a certain value.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------010202080904010400030700
Content-Type: text/plain;
 name="05u32.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05u32.patch"

[PATCH] u32 iptables match

Introduce a `u32' match which allows to extract quantities of up to 4 bytes
from a packet and test whether the result is a certain value.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: linux-2.6.git/net/netfilter/xt_u32.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/net/netfilter/xt_u32.c	2006-11-09 23:54:00.000000000 +0100
@@ -0,0 +1,78 @@
+/*
+ * (C) 2006 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter/xt_u32.h>
+#include <linux/netfilter/x_tables.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("iptables u32 match module");
+MODULE_ALIAS("ipt_u32");
+MODULE_ALIAS("ip6t_u32");
+
+static int match(const struct sk_buff *skb,
+		 const struct net_device *in,
+		 const struct net_device *out,
+		 const struct xt_match *match,
+		 const void *matchinfo,
+		 int offset,
+		 unsigned int protoff,
+		 int *hotdrop)
+{
+	u_int32_t _data, *ptr;
+	struct xt_u32_info *conf = (struct xt_u32_info *) matchinfo;
+
+	if (conf->offset + sizeof(u_int32_t) > skb->len) 
+		return 0;
+
+	ptr = skb_header_pointer(skb, conf->offset, sizeof(u_int32_t), &_data);
+	if (ptr == NULL)
+		goto dropit;
+
+	return !((*ptr ^ conf->val) & conf->mask) ^ conf->invert;
+dropit:
+	*hotdrop = 1;
+	return 0;
+}
+
+static struct xt_match xt_u32_match[] = {
+	{
+		.name		= "u32",
+		.family		= AF_INET,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_u32_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "u32",
+		.family		= AF_INET6,
+		.match		= match,
+		.matchsize	= sizeof(struct xt_u32_info),
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init xt_u32_init(void)
+{
+	return xt_register_matches(xt_u32_match, ARRAY_SIZE(xt_u32_match));
+}
+
+static void __exit xt_u32_fini(void)
+{
+	xt_unregister_matches(xt_u32_match, ARRAY_SIZE(xt_u32_match));
+}
+
+module_init(xt_u32_init);
+module_exit(xt_u32_fini);
Index: linux-2.6.git/include/linux/netfilter/xt_u32.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/include/linux/netfilter/xt_u32.h	2006-11-09 01:00:30.000000000 +0100
@@ -0,0 +1,8 @@
+#ifndef _XT_U32_MATCH_H
+#define _XT_U32_MATCH_H
+
+struct xt_u32_info {
+	u_int32_t offset, val, mask, invert;
+};
+
+#endif /*_XT_U32_MATCH_H*/
Index: linux-2.6.git/net/netfilter/Kconfig
===================================================================
--- linux-2.6.git.orig/net/netfilter/Kconfig	2006-11-06 17:35:24.000000000 +0100
+++ linux-2.6.git/net/netfilter/Kconfig	2006-11-09 00:50:39.000000000 +0100
@@ -464,5 +464,15 @@ config NETFILTER_XT_MATCH_TCPMSS
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_U32
+	tristate '"u32" match support'
+	depends on NETFILTER_XTABLES
+	help
+	  This option adds a `u32' match, which allows you to extract
+	  quantities of up to 4 bytes from a packet and test whether the
+	  result is a certain value.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 endmenu
 
Index: linux-2.6.git/net/netfilter/Makefile
===================================================================
--- linux-2.6.git.orig/net/netfilter/Makefile	2006-11-06 17:35:24.000000000 +0100
+++ linux-2.6.git/net/netfilter/Makefile	2006-11-09 00:58:32.000000000 +0100
@@ -56,3 +56,4 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTI
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
Index: linux-2.6.git/include/linux/netfilter_ipv4/ipt_u32.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/include/linux/netfilter_ipv4/ipt_u32.h	2006-11-09 01:03:31.000000000 +0100
@@ -0,0 +1,7 @@
+#ifndef _IPT_U32_H
+#define _IPT_U32_H
+
+#include <linux/netfilter/xt_u32.h>
+#define ipt_u32_info xt_u32_info
+
+#endif /*_IPT_U32_H*/

--------------010202080904010400030700--
