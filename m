From: Bernie Harris <bernie.harris@alliedtelesis.co.nz>
Subject: [PATCH] ebtables: Add filter for matching on a string
Date: Thu, 21 Dec 2017 13:01:35 +1300
Message-ID: <20171221000135.5755-1-bernie.harris@alliedtelesis.co.nz>
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        Bernie Harris <bernie.harris@alliedtelesis.co.nz>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:37046 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756493AbdLUAMx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 19:12:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is part of a proposal to add a new filter type to
ebtables that matches on an arbitrary string within the
encapsulated network-layer packet.

The match starts from the beginning of the network-layer packet.

Signed-off-by: Bernie Harris <bernie.harris@alliedtelesis.co.nz>
---
 include/uapi/linux/netfilter_bridge/ebt_string.h | 16 ++++++
 net/bridge/netfilter/Kconfig                     |  8 +++
 net/bridge/netfilter/Makefile                    |  1 +
 net/bridge/netfilter/ebt_string.c                | 65 ++++++++++++++++++++++++
 4 files changed, 90 insertions(+)
 create mode 100644 include/uapi/linux/netfilter_bridge/ebt_string.h
 create mode 100644 net/bridge/netfilter/ebt_string.c

diff --git a/include/uapi/linux/netfilter_bridge/ebt_string.h b/include/uapi/linux/netfilter_bridge/ebt_string.h
new file mode 100644
index 000000000000..87d04e9efebd
--- /dev/null
+++ b/include/uapi/linux/netfilter_bridge/ebt_string.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __LINUX_BRIDGE_EBT_STRING_H
+#define __LINUX_BRIDGE_EBT_STRING_H
+
+#include <linux/types.h>
+
+#define EBT_STRING_MATCH "string"
+#define MAX_STRING_OCTETS 64
+
+struct ebt_string_info {
+	__u16 offset;
+	__u16 length;
+	unsigned char string[MAX_STRING_OCTETS + 1];
+};
+
+#endif
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index e7ef1a1ef3a6..ec1287b3678c 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -154,6 +154,14 @@ config BRIDGE_EBT_VLAN
 	  This option adds the 802.1Q vlan match, which allows the filtering of
 	  802.1Q vlan fields.
 
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+config BRIDGE_EBT_STRING
+	tristate "ebt: string filter support"
+	help
+	  This option adds the string match, which allows filtering based on
+	  an arbitrary sequence of octets starting from a given offset.
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 #
 # targets
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 2f28e16de6c7..450a84ada5e4 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_BRIDGE_EBT_MARK) += ebt_mark_m.o
 obj-$(CONFIG_BRIDGE_EBT_PKTTYPE) += ebt_pkttype.o
 obj-$(CONFIG_BRIDGE_EBT_STP) += ebt_stp.o
 obj-$(CONFIG_BRIDGE_EBT_VLAN) += ebt_vlan.o
+obj-$(CONFIG_BRIDGE_EBT_STRING) += ebt_string.o
 
 # targets
 obj-$(CONFIG_BRIDGE_EBT_ARPREPLY) += ebt_arpreply.o
diff --git a/net/bridge/netfilter/ebt_string.c b/net/bridge/netfilter/ebt_string.c
new file mode 100644
index 000000000000..66770506d3a3
--- /dev/null
+++ b/net/bridge/netfilter/ebt_string.c
@@ -0,0 +1,65 @@
+/*
+ * string
+ *
+ * Author:
+ * Bernie Harris bernie.harris@alliedtelesis.co.nz
+ *
+ * October 2017
+ *
+ */
+#include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_string.h>
+
+static bool
+ebt_string_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct ebt_string_info *info = par->matchinfo;
+	unsigned char buf[MAX_STRING_OCTETS + 1];
+	unsigned char *match_start;
+	int i;
+	int offset = skb_network_offset(skb) + info->offset;
+
+	if (offset + info->length >= skb->len)
+		return false;
+
+	match_start = skb_header_pointer(skb, offset, info->length, buf);
+
+	for (i = 0; i < info->length; i++) {
+		if (*(match_start + i) != info->string[i])
+			return false;
+	}
+
+	return true;
+}
+
+static int ebt_string_mt_check(const struct xt_mtchk_param *par)
+{
+	return 0;
+}
+
+static struct xt_match ebt_string_mt_reg __read_mostly = {
+	.name		= "string",
+	.revision	= 0,
+	.family		= NFPROTO_BRIDGE,
+	.match		= ebt_string_mt,
+	.checkentry	= ebt_string_mt_check,
+	.matchsize	= sizeof(struct ebt_string_info),
+	.me		= THIS_MODULE,
+};
+
+static int __init ebt_string_init(void)
+{
+	return xt_register_match(&ebt_string_mt_reg);
+}
+
+static void __exit ebt_string_fini(void)
+{
+	xt_unregister_match(&ebt_string_mt_reg);
+}
+
+module_init(ebt_string_init);
+module_exit(ebt_string_fini);
+MODULE_DESCRIPTION("Ebtables: String match");
+MODULE_LICENSE("GPL");
-- 
2.15.1

