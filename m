From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/49]: Merge ipt_TOS into xt_DSCP
Date: Tue,  4 Dec 2007 13:02:12 +0100 (MET)
Message-ID: <20071204120212.2442.19832.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62136 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbXLDMCN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:13 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Merge ipt_TOS into xt_DSCP

Merge ipt_TOS into xt_DSCP.

Merge ipt_TOS (tos v0 target) into xt_DSCP. They both modify the same
field in the IPv4 header, so it seems reasonable to keep them in one
piece. This is part two of the implicit 4-patch series to move tos to
xtables and extend it by IPv6.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8566a393780f1db8d84bd066f2d1734ffa90d709
tree c5ee3283f8762b0d5825f7130aae3ae2c1caf188
parent d986d0ecb03d4a040893bf1061fa0f0928c3bbc5
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 04 Dec 2007 10:47:04 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:23:27 +0100

 net/ipv4/netfilter/Kconfig  |   10 --------
 net/ipv4/netfilter/Makefile |    1 -
 net/netfilter/Kconfig       |    6 ++++-
 net/netfilter/xt_DSCP.c     |   51 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 232817c..b11231d 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -293,16 +293,6 @@ config IP_NF_MANGLE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_TARGET_TOS
-	tristate "TOS target support"
-	depends on IP_NF_MANGLE
-	help
-	  This option adds a `TOS' target, which allows you to create rules in
-	  the `mangle' table which alter the Type Of Service field of an IP
-	  packet prior to routing.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_TARGET_ECN
 	tristate "ECN target support"
 	depends on IP_NF_MANGLE
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 00c19c7..2fc0561 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -57,7 +57,6 @@ obj-$(CONFIG_IP_NF_TARGET_NETMAP) += ipt_NETMAP.o
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT.o
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_SAME) += ipt_SAME.o
-obj-$(CONFIG_IP_NF_TARGET_TOS) += ipt_TOS.o
 obj-$(CONFIG_IP_NF_TARGET_TTL) += ipt_TTL.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1804916..9c82d4c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -293,7 +293,7 @@ config NETFILTER_XT_TARGET_CONNMARK
 	  ipt_CONNMARK.ko.  If unsure, say `N'.
 
 config NETFILTER_XT_TARGET_DSCP
-	tristate '"DSCP" target support'
+	tristate '"DSCP" and "TOS" target support'
 	depends on NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
 	help
@@ -302,6 +302,10 @@ config NETFILTER_XT_TARGET_DSCP
 
 	  The DSCP field can have any value between 0x0 and 0x3f inclusive.
 
+	  It also adds the "TOS" target, which allows you to create rules in
+	  the "mangle" table which alter the Type Of Service field of an IPv4
+	  packet prior to routing.
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_MARK
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 1882355..40a4f1d 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -18,12 +18,14 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_DSCP.h>
+#include <linux/netfilter_ipv4/ipt_TOS.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("x_tables DSCP modification module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_DSCP");
 MODULE_ALIAS("ip6t_DSCP");
+MODULE_ALIAS("ipt_TOS");
 
 static unsigned int
 dscp_tg(struct sk_buff *skb, const struct net_device *in,
@@ -76,6 +78,45 @@ dscp_tg_check(const char *tablename, const void *e_void,
 	return true;
 }
 
+static unsigned int
+tos_tg_v0(struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, unsigned int hooknum,
+          const struct xt_target *target, const void *targinfo)
+{
+	const struct ipt_tos_target_info *info = targinfo;
+	struct iphdr *iph = ip_hdr(skb);
+	u_int8_t oldtos;
+
+	if ((iph->tos & IPTOS_TOS_MASK) != info->tos) {
+		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+
+		iph      = ip_hdr(skb);
+		oldtos   = iph->tos;
+		iph->tos = (iph->tos & IPTOS_PREC_MASK) | info->tos;
+		csum_replace2(&iph->check, htons(oldtos), htons(iph->tos));
+	}
+
+	return XT_CONTINUE;
+}
+
+static bool
+tos_tg_check_v0(const char *tablename, const void *e_void,
+                const struct xt_target *target, void *targinfo,
+                unsigned int hook_mask)
+{
+	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
+
+	if (tos != IPTOS_LOWDELAY && tos != IPTOS_THROUGHPUT &&
+	    tos != IPTOS_RELIABILITY && tos != IPTOS_MINCOST &&
+	    tos != IPTOS_NORMALSVC) {
+		printk(KERN_WARNING "TOS: bad tos value %#x\n", tos);
+		return false;
+	}
+
+	return true;
+}
+
 static struct xt_target dscp_tg_reg[] __read_mostly = {
 	{
 		.name		= "DSCP",
@@ -95,6 +136,16 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
 		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
+	{
+		.name		= "TOS",
+		.revision	= 0,
+		.family		= AF_INET,
+		.table		= "mangle",
+		.target		= tos_tg_v0,
+		.targetsize	= sizeof(struct ipt_tos_target_info),
+		.checkentry	= tos_tg_check_v0,
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init dscp_tg_init(void)
