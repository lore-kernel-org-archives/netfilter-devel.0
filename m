From: Pierre Chifflier <chifflier@edenwall.com>
Subject: [PATCH 3/3] bridge: add new target NFQUEUE for ebtables
Date: Thu,  3 Feb 2011 15:32:20 +0100
Message-ID: <1296743540-8148-4-git-send-email-chifflier@edenwall.com>
References: <4D49E1E0.50304@trash.net>
Cc: Pierre Chifflier <chifflier@edenwall.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:44573 "EHLO
	sd-6807.edenwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756209Ab1BCPMF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:12:05 -0500
Received: from [88.171.131.12] (helo=fydelkass.edenwall.com)
	by sd-6807.edenwall.com with esmtp (Exim 4.69)
	(envelope-from <chifflier@edenwall.com>)
	id 1Pl0ER-0007Tb-AW
	for netfilter-devel@vger.kernel.org; Thu, 03 Feb 2011 15:32:23 +0100
In-Reply-To: <4D49E1E0.50304@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds support for sending bridge packets to userspace using
the NFQUEUE target with ebtables.

Signed-off-by: Pierre Chifflier <chifflier@edenwall.com>
---
 include/linux/netfilter_bridge/Kbuild        |    1 +
 include/linux/netfilter_bridge/ebt_nfqueue.h |   21 ++++++++
 net/bridge/netfilter/Kconfig                 |   12 ++++
 net/bridge/netfilter/Makefile                |    1 +
 net/bridge/netfilter/ebt_nfqueue.c           |   70 ++++++++++++++++++++++++++
 5 files changed, 105 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter_bridge/ebt_nfqueue.h
 create mode 100644 net/bridge/netfilter/ebt_nfqueue.c

diff --git a/include/linux/netfilter_bridge/Kbuild b/include/linux/netfilter_bridge/Kbuild
index e48f1a3..fa3a2e1 100644
--- a/include/linux/netfilter_bridge/Kbuild
+++ b/include/linux/netfilter_bridge/Kbuild
@@ -10,6 +10,7 @@ header-y += ebt_mark_m.h
 header-y += ebt_mark_t.h
 header-y += ebt_nat.h
 header-y += ebt_nflog.h
+header-y += ebt_nfqueue.h
 header-y += ebt_pkttype.h
 header-y += ebt_redirect.h
 header-y += ebt_stp.h
diff --git a/include/linux/netfilter_bridge/ebt_nfqueue.h b/include/linux/netfilter_bridge/ebt_nfqueue.h
new file mode 100644
index 0000000..56ff699
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_nfqueue.h
@@ -0,0 +1,21 @@
+#ifndef __LINUX_BRIDGE_EBT_NFQUEUE_H
+#define __LINUX_BRIDGE_EBT_NFQUEUE_H
+
+#define EBT_NFQUEUE_MASK 0x0
+
+#define EBT_NFQUEUE_PREFIX_SIZE 64
+#define EBT_NFQUEUE_WATCHER "nfqueue"
+
+#define EBT_NFQUEUE_DEFAULT_GROUP		0x1
+#define EBT_NFQUEUE_DEFAULT_THRESHOLD	1
+
+struct ebt_nfqueue_info {
+	u_int32_t len;
+	u_int16_t group;
+	u_int16_t threshold;
+	u_int16_t flags;
+	u_int16_t pad;
+	char prefix[EBT_NFQUEUE_PREFIX_SIZE];
+};
+
+#endif				/* __LINUX_BRIDGE_EBT_NFQUEUE_H */
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index ba6f73e..9945b09 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -218,4 +218,16 @@ config BRIDGE_EBT_NFLOG
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config BRIDGE_EBT_NFQUEUE
+	tristate "ebt: NFQUEUE support"
+	select NETFILTER_NETLINK
+	help
+	  If this option is enabled, the kernel will include support
+	  for queueing packets via NFNETLINK.
+
+	  This option adds the nfqueue watcher, that you can use in any rule
+	  in any ebtables table.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 endif # BRIDGE_NF_EBTABLES
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 0718699..b05a1a4 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_BRIDGE_EBT_MARK_T) += ebt_mark.o
 obj-$(CONFIG_BRIDGE_EBT_DNAT) += ebt_dnat.o
 obj-$(CONFIG_BRIDGE_EBT_REDIRECT) += ebt_redirect.o
 obj-$(CONFIG_BRIDGE_EBT_SNAT) += ebt_snat.o
+obj-$(CONFIG_BRIDGE_EBT_NFQUEUE) += ebt_nfqueue.o
 
 # watchers
 obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_log.o
diff --git a/net/bridge/netfilter/ebt_nfqueue.c b/net/bridge/netfilter/ebt_nfqueue.c
new file mode 100644
index 0000000..505d871
--- /dev/null
+++ b/net/bridge/netfilter/ebt_nfqueue.c
@@ -0,0 +1,70 @@
+/*
+ * ebt_nfqueue
+ *
+ *	Author:
+ *	Pierre Chifflier <chifflier@edenwall.com>
+ *
+ *  January, 2010
+ *
+ * Based on:
+ *  xt_NFLOG.c, (C) 2006 by Patrick McHardy <kaber@trash.net>
+ *  ebt_ulog.c, (C) 2004 by Bart De Schuymer <bdschuym@pandora.be>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_nflog.h>
+#include <linux/netfilter_bridge/ebt_nfqueue.h>
+#include <net/netfilter/nf_log.h>
+#include <net/netfilter/nf_queue.h>
+
+static unsigned int
+ebt_nfqueue_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct ebt_nfqueue_info *info = par->targinfo;
+	struct nf_loginfo li;
+	unsigned int verdict = NF_ACCEPT;
+
+	printk(KERN_NOTICE "ebt_NFQUEUE: returning EBT_QUEUE\n");
+	return EBT_QUEUE;
+}
+
+static int ebt_nfqueue_tg_check(const struct xt_tgchk_param *par)
+{
+	struct ebt_nfqueue_info *info = par->targinfo;
+
+	if (info->flags & ~EBT_NFQUEUE_MASK)
+		return -EINVAL;
+	info->prefix[EBT_NFQUEUE_PREFIX_SIZE - 1] = '\0';
+	return 0;
+}
+
+static struct xt_target ebt_nfqueue_tg_reg __read_mostly = {
+	.name       = "nfqueue",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.target     = ebt_nfqueue_tg,
+	.checkentry = ebt_nfqueue_tg_check,
+	.targetsize = sizeof(struct ebt_nfqueue_info),
+	.me         = THIS_MODULE,
+};
+
+static int __init ebt_nfqueue_init(void)
+{
+	printk(KERN_NOTICE "ebt_NFQUEUE: init\n");
+	return xt_register_target(&ebt_nfqueue_tg_reg);
+}
+
+static void __exit ebt_nfqueue_fini(void)
+{
+	xt_unregister_target(&ebt_nfqueue_tg_reg);
+}
+
+module_init(ebt_nfqueue_init);
+module_exit(ebt_nfqueue_fini);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pierre Chifflier <chifflier@edenwall.com>");
+MODULE_DESCRIPTION("ebtables NFQUEUE netfilter filter module");
-- 
1.7.2.3

