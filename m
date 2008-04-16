From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 11/13] [NETFILTER]: Move ARPREPLY to net/netfilter/ and make it usable from arp_tables
Date: Wed, 16 Apr 2008 17:31:03 +0200
Message-ID: <a7d619ec59c4e4bd9f228944967d4017e19a40ff.1208359825.git.jengelh@computergmbh.de>
References: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38092 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763691AbYDPPbJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:31:09 -0400
In-Reply-To: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
References: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter/xt_ARPREPLY.h         |    9 +
 include/linux/netfilter_bridge/ebt_arpreply.h |    7 +-
 net/bridge/netfilter/Kconfig                  |    9 -
 net/bridge/netfilter/ebt_arpreply.c           |  106 -------------
 net/netfilter/Kconfig                         |   10 ++
 net/netfilter/Makefile                        |    1 +
 net/netfilter/xt_ARPREPLY.c                   |  133 +++++++++++++++++
 7 files changed, 155 insertions(+), 120 deletions(-)
 create mode 100644 include/linux/netfilter/xt_ARPREPLY.h
 delete mode 100644 net/bridge/netfilter/ebt_arpreply.c
 create mode 100644 net/netfilter/xt_ARPREPLY.c

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
index 4a04467..117c1be 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -140,15 +140,6 @@ config BRIDGE_EBT_VLAN
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
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
deleted file mode 100644
index 896ec15..0000000
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ /dev/null
@@ -1,106 +0,0 @@
-/*
- *  ebt_arpreply
- *
- *	Authors:
- *	Grzegorz Borowiak <grzes@gnu.univ.gda.pl>
- *	Bart De Schuymer <bdschuym@pandora.be>
- *
- *  August, 2003
- *
- */
-#include <linux/if_arp.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_arpreply.h>
-#include <net/arp.h>
-
-static unsigned int
-ebt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
-		const struct net_device *out, unsigned int hoonum,
-		const struct xt_target *target, const void *data)
-{
-	struct ebt_arpreply_info *info = (void *)data;
-	const __be32 *siptr, *diptr;
-	__be32 _sip, _dip;
-	const struct arphdr *ap;
-	struct arphdr _ah;
-	const unsigned char *shp;
-	unsigned char _sha[ETH_ALEN];
-
-	ap = skb_header_pointer(skb, 0, sizeof(_ah), &_ah);
-	if (ap == NULL)
-		return EBT_DROP;
-
-	if (ap->ar_op != htons(ARPOP_REQUEST) ||
-	    ap->ar_hln != ETH_ALEN ||
-	    ap->ar_pro != htons(ETH_P_IP) ||
-	    ap->ar_pln != 4)
-		return EBT_CONTINUE;
-
-	shp = skb_header_pointer(skb, sizeof(_ah), ETH_ALEN, &_sha);
-	if (shp == NULL)
-		return EBT_DROP;
-
-	siptr = skb_header_pointer(skb, sizeof(_ah) + ETH_ALEN,
-				   sizeof(_sip), &_sip);
-	if (siptr == NULL)
-		return EBT_DROP;
-
-	diptr = skb_header_pointer(skb,
-				   sizeof(_ah) + 2 * ETH_ALEN + sizeof(_sip),
-				   sizeof(_dip), &_dip);
-	if (diptr == NULL)
-		return EBT_DROP;
-
-	arp_send(ARPOP_REPLY, ETH_P_ARP, *siptr, (struct net_device *)in,
-		 *diptr, shp, info->mac, shp);
-
-	return info->target;
-}
-
-static bool
-ebt_arpreply_tg_check(const char *tablename, const void *entry,
-		      const struct xt_target *target, void *data,
-		      unsigned int hookmask)
-{
-	const struct ebt_arpreply_info *info = data;
-	const struct ebt_entry *e = entry;
-
-	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return false;
-	if (e->ethproto != htons(ETH_P_ARP) ||
-	    e->invflags & EBT_IPROTO)
-		return false;
-	CLEAR_BASE_CHAIN_BIT;
-	if (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING))
-		return false;
-	return true;
-}
-
-static struct xt_target ebt_arpreply_tg_reg __read_mostly = {
-	.name       = "ARPREPLY",
-	.revision   = 0,
-	.family     = NFPROTO_BRIDGE,
-	.target     = ebt_arpreply_tg,
-	.targetsize = EBT_ALIGN(sizeof(struct ebt_arpreply_info)),
-	.checkentry = ebt_arpreply_tg_check,
-	.me         = THIS_MODULE,
-};
-
-static int __init ebt_arpreply_init(void)
-{
-	return xt_register_target(&ebt_arpreply_tg_reg);
-}
-
-static void __exit ebt_arpreply_fini(void)
-{
-	xt_unregister_target(&ebt_arpreply_tg_reg);
-}
-
-module_init(ebt_arpreply_init);
-module_exit(ebt_arpreply_fini);
-MODULE_DESCRIPTION("Ebtables: ARP reply target");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("ebt_ARPREPLY");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ccfa95e..5a1f88e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -286,6 +286,16 @@ config NETFILTER_XTABLES
 
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
diff --git a/net/netfilter/xt_ARPREPLY.c b/net/netfilter/xt_ARPREPLY.c
new file mode 100644
index 0000000..27e0d51
--- /dev/null
+++ b/net/netfilter/xt_ARPREPLY.c
@@ -0,0 +1,133 @@
+/*
+ *  ebt_arpreply
+ *
+ *	Authors:
+ *	Grzegorz Borowiak <grzes@gnu.univ.gda.pl>
+ *	Bart De Schuymer <bdschuym@pandora.be>
+ *
+ *  August, 2003
+ *
+ */
+#include <linux/if_arp.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_arpreply.h>
+#include <net/arp.h>
+
+static unsigned int
+ebt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
+		const struct net_device *out, unsigned int hoonum,
+		const struct xt_target *target, const void *data)
+{
+	struct ebt_arpreply_info *info = (void *)data;
+	const __be32 *siptr, *diptr;
+	__be32 _sip, _dip;
+	const struct arphdr *ap;
+	struct arphdr _ah;
+	const unsigned char *shp;
+	unsigned char _sha[ETH_ALEN];
+
+	ap = skb_header_pointer(skb, 0, sizeof(_ah), &_ah);
+	if (ap == NULL)
+		return EBT_DROP;
+
+	if (ap->ar_op != htons(ARPOP_REQUEST) ||
+	    ap->ar_hln != ETH_ALEN ||
+	    ap->ar_pro != htons(ETH_P_IP) ||
+	    ap->ar_pln != 4)
+		return EBT_CONTINUE;
+
+	shp = skb_header_pointer(skb, sizeof(_ah), ETH_ALEN, &_sha);
+	if (shp == NULL)
+		return EBT_DROP;
+
+	siptr = skb_header_pointer(skb, sizeof(_ah) + ETH_ALEN,
+				   sizeof(_sip), &_sip);
+	if (siptr == NULL)
+		return EBT_DROP;
+
+	diptr = skb_header_pointer(skb,
+				   sizeof(_ah) + 2 * ETH_ALEN + sizeof(_sip),
+				   sizeof(_dip), &_dip);
+	if (diptr == NULL)
+		return EBT_DROP;
+
+	arp_send(ARPOP_REPLY, ETH_P_ARP, *siptr, (struct net_device *)in,
+		 *diptr, shp, info->mac, shp);
+
+	return info->target;
+}
+
+static bool
+ebt_arpreply_tg_check(const char *tablename, const void *entry,
+		      const struct xt_target *target, void *data,
+		      unsigned int hookmask)
+{
+	const struct ebt_arpreply_info *info = data;
+	const struct ebt_entry *e = entry;
+
+	if (BASE_CHAIN && info->target == EBT_RETURN)
+		return false;
+	if (e->ethproto != htons(ETH_P_ARP) ||
+	    e->invflags & EBT_IPROTO)
+		return false;
+	CLEAR_BASE_CHAIN_BIT;
+	if (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING))
+		return false;
+	return true;
+}
+
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
+};
+
+static int __init ebt_arpreply_init(void)
+{
+	return xt_register_targets(arpreply_tg_reg,
+	       ARRAY_SIZE(arpreply_tg_reg));
+}
+
+static void __exit ebt_arpreply_fini(void)
+{
+	xt_unregister_targets(arpreply_tg_reg, ARRAY_SIZE(arpreply_tg_reg));
+}
+
+module_init(ebt_arpreply_init);
+module_exit(ebt_arpreply_fini);
+MODULE_DESCRIPTION("Xtables: ARP reply target");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("arpt_ARPREPLY");
+MODULE_ALIAS("ebt_ARPREPLY");
-- 
1.5.5

