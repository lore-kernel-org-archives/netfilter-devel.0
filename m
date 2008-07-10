From: Jan Engelhardt <jengelh@medozas.de>
Subject: 12/13 [NETFILTER]: Move ARPREPLY to net/netfilter/ and make it usable
 from arp_tables
Date: Thu, 10 Jul 2008 15:28:34 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807101528070.27323@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0807101522400.27323@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42795 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbYGJN2f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:28:35 -0400
In-Reply-To: <alpine.LNX.1.10.0807101522400.27323@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit ffffffffffffffffffffffffffffffffffffffff
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jul 8 00:53:12 2008 +0200

[NETFILTER]: Move ARPREPLY to net/netfilter/ and make it usable from arp_tables

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/Kbuild                     |    1 +
 include/linux/netfilter/xt_ARPREPLY.h              |    9 ++
 include/linux/netfilter_bridge/ebt_arpreply.h      |    7 +-
 net/bridge/netfilter/Kconfig                       |    9 --
 net/netfilter/Kconfig                              |   10 +++
 net/netfilter/Makefile                             |    1 +
 .../ebt_arpreply.c => netfilter/xt_ARPREPLY.c}     |   49 +++++++++---
 7 files changed, 61 insertions(+), 25 deletions(-)
 create mode 100644 include/linux/netfilter/xt_ARPREPLY.h
 rename net/{bridge/netfilter/ebt_arpreply.c => netfilter/xt_ARPREPLY.c} (64%)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 5a8af87..213cb14 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -3,6 +3,7 @@ header-y += nf_conntrack_tuple_common.h
 header-y += nfnetlink_conntrack.h
 header-y += nfnetlink_log.h
 header-y += nfnetlink_queue.h
+header-y += xt_ARPREPLY.h
 header-y += xt_CLASSIFY.h
 header-y += xt_CONNMARK.h
 header-y += xt_CONNSECMARK.h
diff --git a/include/linux/netfilter/xt_ARPREPLY.h b/include/linux/netfilter/xt_ARPREPLY.h
new file mode 100644
index 0000000..b358e79
--- /dev/null
+++ b/include/linux/netfilter/xt_ARPREPLY.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_NETFILTER_XT_ARPREPLY_H
+#define _LINUX_NETFILTER_XT_ARPREPLY_H 1
+
+struct xt_arpreply_tginfo {
+	unsigned char mac[ETH_ALEN];
+	__u32 target;
+};
+
+#endif /* _LINUX_NETFILTER_XT_ARPREPLY_H */
diff --git a/include/linux/netfilter_bridge/ebt_arpreply.h b/include/linux/netfilter_bridge/ebt_arpreply.h
index 96a8339..4cb316a 100644
--- a/include/linux/netfilter_bridge/ebt_arpreply.h
+++ b/include/linux/netfilter_bridge/ebt_arpreply.h
@@ -1,11 +1,8 @@
 #ifndef __LINUX_BRIDGE_EBT_ARPREPLY_H
 #define __LINUX_BRIDGE_EBT_ARPREPLY_H
 
-struct ebt_arpreply_info
-{
-	unsigned char mac[ETH_ALEN];
-	int target;
-};
+#define ebt_arpreply_info xt_arpreply_tginfo
 #define EBT_ARPREPLY_TARGET "arpreply"
+#include <linux/netfilter/xt_ARPREPLY.h>
 
 #endif
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 43b162a..e339421 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -149,15 +149,6 @@ config BRIDGE_EBT_VLAN
 #
 # targets
 #
-config BRIDGE_EBT_ARPREPLY
-	tristate "ebt: arp reply target support"
-	depends on BRIDGE_NF_EBTABLES && INET
-	help
-	  This option adds the arp reply target, which allows
-	  automatically sending arp replies to arp requests.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config BRIDGE_EBT_DNAT
 	tristate "ebt: dnat target support"
 	depends on BRIDGE_NF_EBTABLES
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 61fd6d3..928a85d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -287,6 +287,16 @@ config NETFILTER_XTABLES
 
 # alphabetically ordered list of targets
 
+config NETFILTER_XT_TARGET_ARPREPLY
+	tristate '"ARPREPLY" target'
+	depends on NETFILTER_XTABLES && NETFILTER_ADVANCED
+	---help---
+	This option adds the "ARPREPLY" target which can be used to respond
+	to ARP queries. This is useful to make routing work when sender and
+	router have different views of the network (proxy arp), but may also
+	be used as a security device to block access to the entire network
+	segment on the link level.
+
 config NETFILTER_XT_TARGET_CLASSIFY
 	tristate '"CLASSIFY" target support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index b8ea59f..48e423a 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
 
 # targets
+obj-$(CONFIG_NETFILTER_XT_TARGET_ARPREPLY) += xt_ARPREPLY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNMARK) += xt_CONNMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/netfilter/xt_ARPREPLY.c
similarity index 64%
rename from net/bridge/netfilter/ebt_arpreply.c
rename to net/netfilter/xt_ARPREPLY.c
index 896ec15..27e0d51 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/netfilter/xt_ARPREPLY.c
@@ -79,28 +79,55 @@ ebt_arpreply_tg_check(const char *tablename, const void *entry,
 	return true;
 }
 
-static struct xt_target ebt_arpreply_tg_reg __read_mostly = {
-	.name       = "ARPREPLY",
-	.revision   = 0,
-	.family     = NFPROTO_BRIDGE,
-	.target     = ebt_arpreply_tg,
-	.targetsize = EBT_ALIGN(sizeof(struct ebt_arpreply_info)),
-	.checkentry = ebt_arpreply_tg_check,
-	.me         = THIS_MODULE,
+static unsigned int
+arpt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
+		 const struct net_device *out, unsigned int hooknum,
+		 const struct xt_target *target, const void *data)
+{
+	ebt_arpreply_tg(skb, in, out, hooknum, target, data);
+	/*
+	 * Must return absolute verdict because of reentrancy into arp_tables.
+	 * Reason this is not done in ebt_arpreply_tg is that it is
+	 * run from eb_tables, not arp_tables.
+	 */
+	return NF_DROP;
+}
+
+static struct xt_target arpreply_tg_reg[] __read_mostly = {
+	{
+		.name       = "ARPREPLY",
+		.revision   = 0,
+		.family     = NFPROTO_BRIDGE,
+		.target     = ebt_arpreply_tg,
+		.targetsize = EBT_ALIGN(sizeof(struct ebt_arpreply_info)),
+		.checkentry = ebt_arpreply_tg_check,
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "ARPREPLY",
+		.revision   = 0,
+		.family     = NFPROTO_ARP,
+		.hooks      = (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD),
+		.target     = arpt_arpreply_tg,
+		.targetsize = XT_ALIGN(sizeof(struct ebt_arpreply_info)),
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init ebt_arpreply_init(void)
 {
-	return xt_register_target(&ebt_arpreply_tg_reg);
+	return xt_register_targets(arpreply_tg_reg,
+	       ARRAY_SIZE(arpreply_tg_reg));
 }
 
 static void __exit ebt_arpreply_fini(void)
 {
-	xt_unregister_target(&ebt_arpreply_tg_reg);
+	xt_unregister_targets(arpreply_tg_reg, ARRAY_SIZE(arpreply_tg_reg));
 }
 
 module_init(ebt_arpreply_init);
 module_exit(ebt_arpreply_fini);
-MODULE_DESCRIPTION("Ebtables: ARP reply target");
+MODULE_DESCRIPTION("Xtables: ARP reply target");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("arpt_ARPREPLY");
 MODULE_ALIAS("ebt_ARPREPLY");
