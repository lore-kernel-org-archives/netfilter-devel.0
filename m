From: Peter Warasin <peter@endian.com>
Subject: [PATCH 1/2] Adds ebt_nflog watcher to kernel.
Date: Tue, 05 Feb 2008 19:29:21 +0100
Message-ID: <20080205185617.732255000@andrew.endian.com>
References: <20080205185521.051763000@andrew.endian.com>
Cc: ebtables-devel@lists.sourceforge.net,
	Peter Warasin <peter@endian.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:58857 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbYBES4V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:56:21 -0500
Content-Disposition: inline; filename=bridge_netfilter_ebt_nflog.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the ebtables nflog watcher to the
kernel in order to allow ebtables log through the
nfnetlink_log backend.

Signed-off-by: Peter Warasin <peter@endian.com>
---
 include/linux/netfilter_bridge/ebt_nflog.h |   21 ++++++++
 net/bridge/netfilter/Kconfig               |   14 +++++
 net/bridge/netfilter/Makefile              |    1 
 net/bridge/netfilter/ebt_nflog.c           |   73 +++++++++++++++++++++++++++++
 4 files changed, 109 insertions(+)

Index: linux-2.6.22.i586/include/linux/netfilter_bridge/ebt_nflog.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22.i586/include/linux/netfilter_bridge/ebt_nflog.h	2008-02-04 20:53:51.000000000 +0100
@@ -0,0 +1,21 @@
+#ifndef __LINUX_BRIDGE_EBT_NFLOG_H
+#define __LINUX_BRIDGE_EBT_NFLOG_H
+
+#define EBT_NFLOG_MASK 0x0
+
+#define EBT_NFLOG_PREFIX_SIZE 30
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
Index: linux-2.6.22.i586/net/bridge/netfilter/ebt_nflog.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22.i586/net/bridge/netfilter/ebt_nflog.c	2008-02-05 17:17:37.000000000 +0100
@@ -0,0 +1,73 @@
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
+static struct ebt_watcher nflog = {
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
Index: linux-2.6.22.i586/net/bridge/netfilter/Kconfig
===================================================================
--- linux-2.6.22.i586.orig/net/bridge/netfilter/Kconfig	2008-02-04 19:59:07.000000000 +0100
+++ linux-2.6.22.i586/net/bridge/netfilter/Kconfig	2008-02-04 20:04:46.000000000 +0100
@@ -212,4 +212,18 @@
 
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
Index: linux-2.6.22.i586/net/bridge/netfilter/Makefile
===================================================================
--- linux-2.6.22.i586.orig/net/bridge/netfilter/Makefile	2008-02-04 19:59:09.000000000 +0100
+++ linux-2.6.22.i586/net/bridge/netfilter/Makefile	2008-02-04 19:59:26.000000000 +0100
@@ -30,3 +30,4 @@
 # watchers
 obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_log.o
 obj-$(CONFIG_BRIDGE_EBT_ULOG) += ebt_ulog.o
+obj-$(CONFIG_BRIDGE_EBT_NFLOG) += ebt_nflog.o

--
