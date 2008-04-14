From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 40/41]: bridge: add ebt_nflog watcher
Date: Mon, 14 Apr 2008 12:17:13 +0200 (MEST)
Message-ID: <20080414101710.32717.51053.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36366 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbYDNKRO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:17:14 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: bridge: add ebt_nflog watcher

This patch adds the ebtables nflog watcher to the kernel in order to
allow ebtables log through the nfnetlink_log backend.

Signed-off-by: Peter Warasin <peter@endian.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7649b4aade16e08fc9024467d5bfdfc885425961
tree d92aad7aac50c41e0fbcae3cb41d03bd82d9ab40
parent ed85c857b1339f605b1668f7bb185d8e19c172d1
author Peter Warasin <peter@endian.com> Mon, 14 Apr 2008 12:10:57 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:57 +0200

 include/linux/netfilter_bridge/ebt_nflog.h |   21 ++++++++
 net/bridge/netfilter/Kconfig               |   14 +++++
 net/bridge/netfilter/Makefile              |    1 
 net/bridge/netfilter/ebt_nflog.c           |   74 ++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebt_nflog.h b/include/linux/netfilter_bridge/ebt_nflog.h
new file mode 100644
index 0000000..0528178
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebt_nflog.h
@@ -0,0 +1,21 @@
+#ifndef __LINUX_BRIDGE_EBT_NFLOG_H
+#define __LINUX_BRIDGE_EBT_NFLOG_H
+
+#define EBT_NFLOG_MASK 0x0
+
+#define EBT_NFLOG_PREFIX_SIZE 64
+#define EBT_NFLOG_WATCHER "nflog"
+
+#define EBT_NFLOG_DEFAULT_GROUP		0x1
+#define EBT_NFLOG_DEFAULT_THRESHOLD	1
+
+struct ebt_nflog_info {
+	u_int32_t len;
+	u_int16_t group;
+	u_int16_t threshold;
+	u_int16_t flags;
+	u_int16_t pad;
+	char prefix[EBT_NFLOG_PREFIX_SIZE];
+};
+
+#endif				/* __LINUX_BRIDGE_EBT_NFLOG_H */
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 4a3e2bf..7beeefa 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -212,4 +212,18 @@ config BRIDGE_EBT_ULOG
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config BRIDGE_EBT_NFLOG
+	tristate "ebt: nflog support"
+	depends on BRIDGE_NF_EBTABLES
+	help
+	  This option enables the nflog watcher, which allows to LOG
+	  messages through the netfilter logging API, which can use
+	  either the old LOG target, the old ULOG target or nfnetlink_log
+	  as backend.
+
+	  This option adds the ulog watcher, that you can use in any rule
+	  in any ebtables table.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 endmenu
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 905087e..83715d7 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_BRIDGE_EBT_SNAT) += ebt_snat.o
 # watchers
 obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_log.o
 obj-$(CONFIG_BRIDGE_EBT_ULOG) += ebt_ulog.o
+obj-$(CONFIG_BRIDGE_EBT_NFLOG) += ebt_nflog.o
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
new file mode 100644
index 0000000..8e799aa
--- /dev/null
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -0,0 +1,74 @@
+/*
+ * ebt_nflog
+ *
+ *	Author:
+ *	Peter Warasin <peter@endian.com>
+ *
+ *  February, 2008
+ *
+ * Based on:
+ *  xt_NFLOG.c, (C) 2006 by Patrick McHardy <kaber@trash.net>
+ *  ebt_ulog.c, (C) 2004 by Bart De Schuymer <bdschuym@pandora.be>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_nflog.h>
+#include <net/netfilter/nf_log.h>
+
+static void ebt_nflog(const struct sk_buff *skb,
+		      unsigned int hooknr,
+		      const struct net_device *in,
+		      const struct net_device *out,
+		      const void *data, unsigned int datalen)
+{
+	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
+	struct nf_loginfo li;
+
+	li.type = NF_LOG_TYPE_ULOG;
+	li.u.ulog.copy_len = info->len;
+	li.u.ulog.group = info->group;
+	li.u.ulog.qthreshold = info->threshold;
+
+	nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li, "%s", info->prefix);
+}
+
+static int ebt_nflog_check(const char *tablename,
+			   unsigned int hookmask,
+			   const struct ebt_entry *e,
+			   void *data, unsigned int datalen)
+{
+	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
+
+	if (datalen != EBT_ALIGN(sizeof(struct ebt_nflog_info)))
+		return -EINVAL;
+	if (info->flags & ~EBT_NFLOG_MASK)
+		return -EINVAL;
+	info->prefix[EBT_NFLOG_PREFIX_SIZE - 1] = '\0';
+	return 0;
+}
+
+static struct ebt_watcher nflog __read_mostly = {
+	.name = EBT_NFLOG_WATCHER,
+	.watcher = ebt_nflog,
+	.check = ebt_nflog_check,
+	.me = THIS_MODULE,
+};
+
+static int __init ebt_nflog_init(void)
+{
+	return ebt_register_watcher(&nflog);
+}
+
+static void __exit ebt_nflog_fini(void)
+{
+	ebt_unregister_watcher(&nflog);
+}
+
+module_init(ebt_nflog_init);
+module_exit(ebt_nflog_fini);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Peter Warasin <peter@endian.com>");
+MODULE_DESCRIPTION("ebtables NFLOG netfilter logging module");
