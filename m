From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/18]: x_tables: replace IPv4 DSCP target by address
	family independent version
Date: Tue, 22 Aug 2006 00:52:20 +0200 (MEST)
Message-ID: <20060821225220.10288.33754.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: replace IPv4 DSCP target by address family independent version

This replaces IPv4 DSCP target by address family independent version.
This also
	- utilizes dsfield.h to get/mangle DS field in IPv4/IPv6 header
	- fixes Kconfig help text.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit aee6e3b681f66196cf3ec43b53b252b61f870f1a
tree 4c4d9bc72012d42bc9bc0c8442ae644f2d5125e9
parent 8419c86c6871f880cd17a6cc29146d3d2da0477a
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 11 Aug 2006 21:00:58 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 21:00:58 +0200

 include/linux/netfilter/xt_DSCP.h       |   20 +++++
 include/linux/netfilter_ipv4/ipt_DSCP.h |    6 -
 net/ipv4/netfilter/Kconfig              |   11 ---
 net/ipv4/netfilter/Makefile             |    1 
 net/ipv4/netfilter/ipt_DSCP.c           |   96 -----------------------
 net/netfilter/Kconfig                   |   12 +++
 net/netfilter/Makefile                  |    1 
 net/netfilter/xt_DSCP.c                 |  130 +++++++++++++++++++++++++++++++
 8 files changed, 165 insertions(+), 112 deletions(-)

diff --git a/include/linux/netfilter/xt_DSCP.h b/include/linux/netfilter/xt_DSCP.h
new file mode 100644
index 0000000..3c7c963
--- /dev/null
+++ b/include/linux/netfilter/xt_DSCP.h
@@ -0,0 +1,20 @@
+/* x_tables module for setting the IPv4/IPv6 DSCP field
+ *
+ * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
+ * This software is distributed under GNU GPL v2, 1991
+ *
+ * See RFC2474 for a description of the DSCP field within the IP Header.
+ *
+ * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
+*/
+#ifndef _XT_DSCP_TARGET_H
+#define _XT_DSCP_TARGET_H
+#include <linux/netfilter/xt_dscp.h>
+
+/* target info */
+struct xt_DSCP_info {
+	u_int8_t dscp;
+};
+
+#endif /* _XT_DSCP_TARGET_H */
diff --git a/include/linux/netfilter_ipv4/ipt_DSCP.h b/include/linux/netfilter_ipv4/ipt_DSCP.h
index b30f510..3491e52 100644
--- a/include/linux/netfilter_ipv4/ipt_DSCP.h
+++ b/include/linux/netfilter_ipv4/ipt_DSCP.h
@@ -11,10 +11,8 @@
 #ifndef _IPT_DSCP_TARGET_H
 #define _IPT_DSCP_TARGET_H
 #include <linux/netfilter_ipv4/ipt_dscp.h>
+#include <linux/netfilter/xt_DSCP.h>
 
-/* target info */
-struct ipt_DSCP_info {
-	u_int8_t dscp;
-};
+#define ipt_DSCP_info xt_DSCP_info
 
 #endif /* _IPT_DSCP_TARGET_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index d88d71d..a55b8ff 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -557,17 +557,6 @@ config IP_NF_TARGET_ECN
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_TARGET_DSCP
-	tristate "DSCP target support"
-	depends on IP_NF_MANGLE
-	help
-	  This option adds a `DSCP' match, which allows you to match against
-	  the IPv4 header DSCP field (DSCP codepoint).
-
-	  The DSCP codepoint can have any value between 0x0 and 0x4f.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_TARGET_TTL
 	tristate  'TTL target support'
 	depends on IP_NF_MANGLE
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index b946b0f..09aaed1 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -67,7 +67,6 @@ # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_TOS) += ipt_TOS.o
 obj-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN.o
-obj-$(CONFIG_IP_NF_TARGET_DSCP) += ipt_DSCP.o
 obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) += ipt_MASQUERADE.o
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT.o
 obj-$(CONFIG_IP_NF_TARGET_NETMAP) += ipt_NETMAP.o
diff --git a/net/ipv4/netfilter/ipt_DSCP.c b/net/ipv4/netfilter/ipt_DSCP.c
deleted file mode 100644
index c8e9712..0000000
--- a/net/ipv4/netfilter/ipt_DSCP.c
+++ /dev/null
@@ -1,96 +0,0 @@
-/* iptables module for setting the IPv4 DSCP field, Version 1.8
- *
- * (C) 2002 by Harald Welte <laforge@netfilter.org>
- * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as 
- * published by the Free Software Foundation.
- * 
- * See RFC2474 for a description of the DSCP field within the IP Header.
- *
- * ipt_DSCP.c,v 1.8 2002/08/06 18:41:57 laforge Exp
-*/
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <net/checksum.h>
-
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_DSCP.h>
-
-MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("iptables DSCP modification module");
-MODULE_LICENSE("GPL");
-
-static unsigned int
-target(struct sk_buff **pskb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const struct xt_target *target,
-       const void *targinfo,
-       void *userinfo)
-{
-	const struct ipt_DSCP_info *dinfo = targinfo;
-	u_int8_t sh_dscp = ((dinfo->dscp << IPT_DSCP_SHIFT) & IPT_DSCP_MASK);
-
-
-	if (((*pskb)->nh.iph->tos & IPT_DSCP_MASK) != sh_dscp) {
-		u_int16_t diffs[2];
-
-		if (!skb_make_writable(pskb, sizeof(struct iphdr)))
-			return NF_DROP;
-
-		diffs[0] = htons((*pskb)->nh.iph->tos) ^ 0xFFFF;
-		(*pskb)->nh.iph->tos = ((*pskb)->nh.iph->tos & ~IPT_DSCP_MASK)
-			| sh_dscp;
-		diffs[1] = htons((*pskb)->nh.iph->tos);
-		(*pskb)->nh.iph->check
-			= csum_fold(csum_partial((char *)diffs,
-						 sizeof(diffs),
-						 (*pskb)->nh.iph->check
-						 ^ 0xFFFF));
-	}
-	return IPT_CONTINUE;
-}
-
-static int
-checkentry(const char *tablename,
-	   const void *e_void,
-	   const struct xt_target *target,
-           void *targinfo,
-           unsigned int targinfosize,
-           unsigned int hook_mask)
-{
-	const u_int8_t dscp = ((struct ipt_DSCP_info *)targinfo)->dscp;
-
-	if ((dscp > IPT_DSCP_MAX)) {
-		printk(KERN_WARNING "DSCP: dscp %x out of range\n", dscp);
-		return 0;
-	}
-	return 1;
-}
-
-static struct ipt_target ipt_dscp_reg = {
-	.name		= "DSCP",
-	.target		= target,
-	.targetsize	= sizeof(struct ipt_DSCP_info),
-	.table		= "mangle",
-	.checkentry	= checkentry,
-	.me		= THIS_MODULE,
-};
-
-static int __init ipt_dscp_init(void)
-{
-	return ipt_register_target(&ipt_dscp_reg);
-}
-
-static void __exit ipt_dscp_fini(void)
-{
-	ipt_unregister_target(&ipt_dscp_reg);
-}
-
-module_init(ipt_dscp_init);
-module_exit(ipt_dscp_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f781405..0a28d2c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -148,6 +148,18 @@ config NETFILTER_XT_TARGET_CONNMARK
 	  <file:Documentation/modules.txt>.  The module will be called
 	  ipt_CONNMARK.o.  If unsure, say `N'.
 
+config NETFILTER_XT_TARGET_DSCP
+	tristate '"DSCP" target support'
+	depends on NETFILTER_XTABLES
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	help
+	  This option adds a `DSCP' target, which allows you to manipulate
+	  the IPv4/IPv6 header DSCP field (differentiated services codepoint).
+
+	  The DSCP field can have any value between 0x0 and 0x3f inclusive.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_MARK
 	tristate '"MARK" target support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0b8a70c..a74be49 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_NETFILTER_XTABLES) += x_tab
 # targets
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNMARK) += xt_CONNMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) += xt_MARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
new file mode 100644
index 0000000..79df816
--- /dev/null
+++ b/net/netfilter/xt_DSCP.c
@@ -0,0 +1,130 @@
+/* x_tables module for setting the IPv4/IPv6 DSCP field, Version 1.8
+ *
+ * (C) 2002 by Harald Welte <laforge@netfilter.org>
+ * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * See RFC2474 for a description of the DSCP field within the IP Header.
+ *
+ * xt_DSCP.c,v 1.8 2002/08/06 18:41:57 laforge Exp
+*/
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/dsfield.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_DSCP.h>
+
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("x_tables DSCP modification module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_DSCP");
+MODULE_ALIAS("ip6t_DSCP");
+
+static unsigned int target(struct sk_buff **pskb,
+			   const struct net_device *in,
+			   const struct net_device *out,
+			   unsigned int hooknum,
+			   const struct xt_target *target,
+			   const void *targinfo,
+			   void *userinfo)
+{
+	const struct xt_DSCP_info *dinfo = targinfo;
+	u_int8_t dscp = ipv4_get_dsfield((*pskb)->nh.iph) >> XT_DSCP_SHIFT;
+
+	if (dscp != dinfo->dscp) {
+		if (!skb_make_writable(pskb, sizeof(struct iphdr)))
+			return NF_DROP;
+
+		ipv4_change_dsfield((*pskb)->nh.iph, (__u8)(~XT_DSCP_MASK),
+				    dinfo->dscp << XT_DSCP_SHIFT);
+
+	}
+	return XT_CONTINUE;
+}
+
+static unsigned int target6(struct sk_buff **pskb,
+			    const struct net_device *in,
+			    const struct net_device *out,
+			    unsigned int hooknum,
+			    const struct xt_target *target,
+			    const void *targinfo,
+			    void *userinfo)
+{
+	const struct xt_DSCP_info *dinfo = targinfo;
+	u_int8_t dscp = ipv6_get_dsfield((*pskb)->nh.ipv6h) >> XT_DSCP_SHIFT;
+
+	if (dscp != dinfo->dscp) {
+		if (!skb_make_writable(pskb, sizeof(struct ipv6hdr)))
+			return NF_DROP;
+
+		ipv6_change_dsfield((*pskb)->nh.ipv6h, (__u8)(~XT_DSCP_MASK),
+				    dinfo->dscp << XT_DSCP_SHIFT);
+	}
+	return XT_CONTINUE;
+}
+
+static int checkentry(const char *tablename,
+		      const void *e_void,
+		      const struct xt_target *target,
+		      void *targinfo,
+		      unsigned int targinfosize,
+		      unsigned int hook_mask)
+{
+	const u_int8_t dscp = ((struct xt_DSCP_info *)targinfo)->dscp;
+
+	if ((dscp > XT_DSCP_MAX)) {
+		printk(KERN_WARNING "DSCP: dscp %x out of range\n", dscp);
+		return 0;
+	}
+	return 1;
+}
+
+static struct xt_target xt_dscp_reg = {
+	.name		= "DSCP",
+	.target		= target,
+	.targetsize	= sizeof(struct xt_DSCP_info),
+	.table		= "mangle",
+	.checkentry	= checkentry,
+	.family		= AF_INET,
+	.me		= THIS_MODULE,
+};
+
+static struct xt_target xt_dscp6_reg = {
+	.name		= "DSCP",
+	.target		= target6,
+	.targetsize	= sizeof(struct xt_DSCP_info),
+	.table		= "mangle",
+	.checkentry	= checkentry,
+	.family		= AF_INET6,
+	.me		= THIS_MODULE,
+};
+
+static int __init xt_dscp_target_init(void)
+{
+	int ret;
+	ret = xt_register_target(&xt_dscp_reg);
+	if (ret)
+		return ret;
+
+	ret = xt_register_target(&xt_dscp6_reg);
+	if (ret)
+		xt_unregister_target(&xt_dscp_reg);
+
+	return ret;
+}
+
+static void __exit xt_dscp_target_fini(void)
+{
+	xt_unregister_target(&xt_dscp_reg);
+	xt_unregister_target(&xt_dscp6_reg);
+}
+
+module_init(xt_dscp_target_init);
+module_exit(xt_dscp_target_fini);
