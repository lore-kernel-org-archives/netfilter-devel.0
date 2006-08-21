From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/18]: x_tables: replace IPv4 dscp match by address
	family independent version
Date: Tue, 22 Aug 2006 00:52:19 +0200 (MEST)
Message-ID: <20060821225219.10288.17937.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: replace IPv4 dscp match by address family independent version

This replaces IPv4 dscp match by address family independent version.
This also
	- utilizes dsfield.h to get the DS field in IPv4/IPv6 header, and
	- checks for the DSCP value from user space.
	- fixes Kconfig help text.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8419c86c6871f880cd17a6cc29146d3d2da0477a
tree 3a134391c4d162f7675f4374c144f7f5e0ab3725
parent 99c4451081b0ea2107ba4827f7d518e1c739cf1b
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 11 Aug 2006 20:35:46 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 20:35:46 +0200

 include/linux/netfilter/xt_dscp.h       |   23 ++++++
 include/linux/netfilter_ipv4/ipt_dscp.h |   14 ++--
 net/ipv4/netfilter/Kconfig              |   11 ---
 net/ipv4/netfilter/Makefile             |    1 
 net/ipv4/netfilter/ipt_dscp.c           |   54 ---------------
 net/netfilter/Kconfig                   |   11 +++
 net/netfilter/Makefile                  |    1 
 net/netfilter/xt_dscp.c                 |  113 +++++++++++++++++++++++++++++++
 8 files changed, 154 insertions(+), 74 deletions(-)

diff --git a/include/linux/netfilter/xt_dscp.h b/include/linux/netfilter/xt_dscp.h
new file mode 100644
index 0000000..1da61e6
--- /dev/null
+++ b/include/linux/netfilter/xt_dscp.h
@@ -0,0 +1,23 @@
+/* x_tables module for matching the IPv4/IPv6 DSCP field
+ *
+ * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ * This software is distributed under GNU GPL v2, 1991
+ *
+ * See RFC2474 for a description of the DSCP field within the IP Header.
+ *
+ * xt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
+*/
+#ifndef _XT_DSCP_H
+#define _XT_DSCP_H
+
+#define XT_DSCP_MASK	0xfc	/* 11111100 */
+#define XT_DSCP_SHIFT	2
+#define XT_DSCP_MAX	0x3f	/* 00111111 */
+
+/* match info */
+struct xt_dscp_info {
+	u_int8_t dscp;
+	u_int8_t invert;
+};
+
+#endif /* _XT_DSCP_H */
diff --git a/include/linux/netfilter_ipv4/ipt_dscp.h b/include/linux/netfilter_ipv4/ipt_dscp.h
index 2fa6dfe..4b82ca9 100644
--- a/include/linux/netfilter_ipv4/ipt_dscp.h
+++ b/include/linux/netfilter_ipv4/ipt_dscp.h
@@ -10,14 +10,12 @@
 #ifndef _IPT_DSCP_H
 #define _IPT_DSCP_H
 
-#define IPT_DSCP_MASK	0xfc	/* 11111100 */
-#define IPT_DSCP_SHIFT	2
-#define IPT_DSCP_MAX	0x3f	/* 00111111 */
+#include <linux/netfilter/xt_dscp.h>
 
-/* match info */
-struct ipt_dscp_info {
-	u_int8_t dscp;
-	u_int8_t invert;
-};
+#define IPT_DSCP_MASK	XT_DSCP_MASK
+#define IPT_DSCP_SHIFT	XT_DSCP_SHIFT
+#define IPT_DSCP_MAX	XT_DSCP_MAX
+
+#define ipt_dscp_info	xt_dscp_info
 
 #endif /* _IPT_DSCP_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index ef0b5aa..d88d71d 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -278,17 +278,6 @@ config IP_NF_MATCH_ECN
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_MATCH_DSCP
-	tristate "DSCP match support"
-	depends on IP_NF_IPTABLES
-	help
-	  This option adds a `DSCP' match, which allows you to match against
-	  the IPv4 header DSCP field (DSCP codepoint).
-
-	  The DSCP codepoint can have any value between 0x0 and 0x4f.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_AH
 	tristate "AH match support"
 	depends on IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 3ded4a3..b946b0f 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -59,7 +59,6 @@ obj-$(CONFIG_IP_NF_MATCH_OWNER) += ipt_o
 obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
-obj-$(CONFIG_IP_NF_MATCH_DSCP) += ipt_dscp.o
 obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
diff --git a/net/ipv4/netfilter/ipt_dscp.c b/net/ipv4/netfilter/ipt_dscp.c
deleted file mode 100644
index 4717759..0000000
--- a/net/ipv4/netfilter/ipt_dscp.c
+++ /dev/null
@@ -1,54 +0,0 @@
-/* IP tables module for matching the value of the IPv4 DSCP field
- *
- * ipt_dscp.c,v 1.3 2002/08/05 19:00:21 laforge Exp
- *
- * (C) 2002 by Harald Welte <laforge@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-
-#include <linux/netfilter_ipv4/ipt_dscp.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("iptables DSCP matching module");
-MODULE_LICENSE("GPL");
-
-static int match(const struct sk_buff *skb,
-		 const struct net_device *in, const struct net_device *out,
-		 const struct xt_match *match, const void *matchinfo,
-		 int offset, unsigned int protoff, int *hotdrop)
-{
-	const struct ipt_dscp_info *info = matchinfo;
-	const struct iphdr *iph = skb->nh.iph;
-
-	u_int8_t sh_dscp = ((info->dscp << IPT_DSCP_SHIFT) & IPT_DSCP_MASK);
-
-	return ((iph->tos&IPT_DSCP_MASK) == sh_dscp) ^ info->invert;
-}
-
-static struct ipt_match dscp_match = {
-	.name		= "dscp",
-	.match		= match,
-	.matchsize	= sizeof(struct ipt_dscp_info),
-	.me		= THIS_MODULE,
-};
-
-static int __init ipt_dscp_init(void)
-{
-	return ipt_register_match(&dscp_match);
-}
-
-static void __exit ipt_dscp_fini(void)
-{
-	ipt_unregister_match(&dscp_match);
-
-}
-
-module_init(ipt_dscp_init);
-module_exit(ipt_dscp_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a9894dd..f781405 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -263,6 +263,17 @@ config NETFILTER_XT_MATCH_DCCP
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_DSCP
+	tristate '"DSCP" match support'
+	depends on NETFILTER_XTABLES
+	help
+	  This option adds a `DSCP' match, which allows you to match against
+	  the IPv4/IPv6 header DSCP field (differentiated services codepoint).
+
+	  The DSCP field can have any value between 0x0 and 0x3f inclusive.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_ESP
 	tristate '"ESP" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 6fa4b75..0b8a70c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTE
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNMARK) += xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) += xt_conntrack.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) += xt_length.o
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
new file mode 100644
index 0000000..82e250d
--- /dev/null
+++ b/net/netfilter/xt_dscp.c
@@ -0,0 +1,113 @@
+/* IP tables module for matching the value of the IPv4/IPv6 DSCP field
+ *
+ * xt_dscp.c,v 1.3 2002/08/05 19:00:21 laforge Exp
+ *
+ * (C) 2002 by Harald Welte <laforge@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/dsfield.h>
+
+#include <linux/netfilter/xt_dscp.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("x_tables DSCP matching module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_dscp");
+MODULE_ALIAS("ip6t_dscp");
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
+	const struct xt_dscp_info *info = matchinfo;
+	u_int8_t dscp = ipv4_get_dsfield(skb->nh.iph) >> XT_DSCP_SHIFT;
+
+	return (dscp == info->dscp) ^ !!info->invert;
+}
+
+static int match6(const struct sk_buff *skb,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  const struct xt_match *match,
+		  const void *matchinfo,
+		  int offset,
+		  unsigned int protoff,
+		  int *hotdrop)
+{
+	const struct xt_dscp_info *info = matchinfo;
+	u_int8_t dscp = ipv6_get_dsfield(skb->nh.ipv6h) >> XT_DSCP_SHIFT;
+
+	return (dscp == info->dscp) ^ !!info->invert;
+}
+
+static int checkentry(const char *tablename,
+		      const void *info,
+		      const struct xt_match *match,
+		      void *matchinfo,
+		      unsigned int matchsize,
+		      unsigned int hook_mask)
+{
+	const u_int8_t dscp = ((struct xt_dscp_info *)matchinfo)->dscp;
+
+	if (dscp > XT_DSCP_MAX) {
+		printk(KERN_ERR "xt_dscp: dscp %x out of range\n", dscp);
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct xt_match dscp_match = {
+	.name		= "dscp",
+	.match		= match,
+	.checkentry	= checkentry,
+	.matchsize	= sizeof(struct xt_dscp_info),
+	.family		= AF_INET,
+	.me		= THIS_MODULE,
+};
+
+static struct xt_match dscp6_match = {
+	.name		= "dscp",
+	.match		= match6,
+	.checkentry	= checkentry,
+	.matchsize	= sizeof(struct xt_dscp_info),
+	.family		= AF_INET6,
+	.me		= THIS_MODULE,
+};
+
+static int __init xt_dscp_match_init(void)
+{
+	int ret;
+	ret = xt_register_match(&dscp_match);
+	if (ret)
+		return ret;
+
+	ret = xt_register_match(&dscp6_match);
+	if (ret)
+		xt_unregister_match(&dscp_match);
+
+	return ret;
+}
+
+static void __exit xt_dscp_match_fini(void)
+{
+	xt_unregister_match(&dscp_match);
+	xt_unregister_match(&dscp6_match);
+}
+
+module_init(xt_dscp_match_init);
+module_exit(xt_dscp_match_fini);
