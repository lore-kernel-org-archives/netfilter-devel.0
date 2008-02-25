From: Peter Warasin <peter@endian.com>
Subject: Re: [PATCH resend 1/2] Adds ebt_nflog watcher to kernel.
Date: Tue, 26 Feb 2008 00:03:15 +0100
Message-ID: <47C34933.8000301@endian.com>
References: <20080205185521.051763000@andrew.endian.com> <20080205185617.732255000@andrew.endian.com> <47BD86EF.7060809@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080208040704000502050901"
Cc: netfilter-devel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net,
	Bart De Schuymer <bdschuym@pandora.be>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:56325 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbYBYXDb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:03:31 -0500
In-Reply-To: <47BD86EF.7060809@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080208040704000502050901
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi

Patrick McHardy wrote:
> Peter Warasin wrote:
>  > This patch adds the ebtables nflog watcher to the
>  > kernel
> This seems mostly fine to me. A few minor comments:

> If you'll resend the patch based on net-2.6.26 I'll queue it
> if Bart has no objections.

I re-based on net-2.6.26 and changed what you mentioned.
Patch is attached

regards,
peter

--------------080208040704000502050901
Content-Type: text/x-patch;
 name="0001-Adds-ebt_nflog-watcher.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Adds-ebt_nflog-watcher.patch"

>From de032f8a95d42401603c6a69d02016700e71ffea Mon Sep 17 00:00:00 2001
From: Peter Warasin <peter@endian.com>
Date: Thu, 21 Feb 2008 22:28:49 +0100
Subject: [PATCH] Adds ebt_nflog watcher

This patch adds the ebtables nflog watcher to the
kernel in order to allow ebtables log through the
nfnetlink_log backend.

Signed-off-by: Peter Warasin <peter@endian.com>

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
-- 
1.5.2.5


--------------080208040704000502050901--
