From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/1] netfilter: add devgroup match
Date: Mon, 31 Jan 2011 20:09:46 +0100
Message-ID: <4D4708FA.6020001@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010603070006080302090200"
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58963 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1AaTJs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:09:48 -0500
Received: from x100e.localnet (localhost [127.0.0.1])
	by stinky.trash.net (Postfix) with ESMTP id 9C54CB2C46
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2011 20:09:46 +0100 (MET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010603070006080302090200
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

This patch adds a 'devgroup' match, which can be used to match on
the device group a network device is assigned to.


--------------010603070006080302090200
Content-Type: text/plain;
 name="xt_devgroup.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xt_devgroup.diff"

commit 92f2850a01bf0689e7ee5797e08afaf2f71e24b7
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jan 27 11:16:11 2011 +0100

    netfilter: add devgroup match
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 89c0d1e..451e163 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -35,6 +35,7 @@ header-y += xt_connmark.h
 header-y += xt_conntrack.h
 header-y += xt_cpu.h
 header-y += xt_dccp.h
+header-y += xt_devgroup.h
 header-y += xt_dscp.h
 header-y += xt_esp.h
 header-y += xt_hashlimit.h
diff --git a/include/linux/netfilter/xt_devgroup.h b/include/linux/netfilter/xt_devgroup.h
new file mode 100644
index 0000000..1babde0
--- /dev/null
+++ b/include/linux/netfilter/xt_devgroup.h
@@ -0,0 +1,21 @@
+#ifndef _XT_DEVGROUP_H
+#define _XT_DEVGROUP_H
+
+#include <linux/types.h>
+
+enum xt_devgroup_flags {
+	XT_DEVGROUP_MATCH_SRC	= 0x1,
+	XT_DEVGROUP_INVERT_SRC	= 0x2,
+	XT_DEVGROUP_MATCH_DST	= 0x4,
+	XT_DEVGROUP_INVERT_DST	= 0x8,
+};
+
+struct xt_devgroup_info {
+	__u32	flags;
+	__u32	src_group;
+	__u32	src_mask;
+	__u32	dst_group;
+	__u32	dst_mask;
+};
+
+#endif /* _XT_DEVGROUP_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index faf7412..cd73aa2 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -726,6 +726,15 @@ config NETFILTER_XT_MATCH_DCCP
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_DEVGROUP
+	tristate '"devgroup" match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This options adds a `devgroup' match, which allows to match on the
+	  device group a network device is assigned to.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_DSCP
 	tristate '"dscp" and "tos" match support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 9ae6878..0ad8871 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_CONNLIMIT) += xt_connlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) += xt_conntrack.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CPU) += xt_cpu.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_DEVGROUP) += xt_devgroup.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
diff --git a/net/netfilter/xt_devgroup.c b/net/netfilter/xt_devgroup.c
new file mode 100644
index 0000000..d9202cd
--- /dev/null
+++ b/net/netfilter/xt_devgroup.c
@@ -0,0 +1,82 @@
+/*
+ * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+
+#include <linux/netfilter/xt_devgroup.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Xtables: Device group match");
+MODULE_ALIAS("ipt_devgroup");
+MODULE_ALIAS("ip6t_devgroup");
+
+static bool devgroup_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_devgroup_info *info = par->matchinfo;
+
+	if (info->flags & XT_DEVGROUP_MATCH_SRC &&
+	    (((info->src_group ^ par->in->group) & info->src_mask ? 1 : 0) ^
+	     ((info->flags & XT_DEVGROUP_INVERT_SRC) ? 1 : 0)))
+		return false;
+
+	if (info->flags & XT_DEVGROUP_MATCH_DST &&
+	    (((info->dst_group ^ par->out->group) & info->dst_mask ? 1 : 0) ^
+	     ((info->flags & XT_DEVGROUP_INVERT_DST) ? 1 : 0)))
+		return false;
+
+	return true;
+}
+
+static int devgroup_mt_checkentry(const struct xt_mtchk_param *par)
+{
+	const struct xt_devgroup_info *info = par->matchinfo;
+
+	if (info->flags & ~(XT_DEVGROUP_MATCH_SRC | XT_DEVGROUP_INVERT_SRC |
+			    XT_DEVGROUP_MATCH_DST | XT_DEVGROUP_INVERT_DST))
+		return -EINVAL;
+
+	if (info->flags & XT_DEVGROUP_MATCH_SRC &&
+	    par->hook_mask & ~((1 << NF_INET_PRE_ROUTING) |
+			       (1 << NF_INET_LOCAL_IN) |
+			       (1 << NF_INET_FORWARD)))
+		return -EINVAL;
+
+	if (info->flags & XT_DEVGROUP_MATCH_DST &&
+	    par->hook_mask & ~((1 << NF_INET_FORWARD) |
+			       (1 << NF_INET_LOCAL_OUT) |
+			       (1 << NF_INET_POST_ROUTING)))
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct xt_match devgroup_mt_reg __read_mostly = {
+	.name		= "devgroup",
+	.match		= devgroup_mt,
+	.checkentry	= devgroup_mt_checkentry,
+	.matchsize	= sizeof(struct xt_devgroup_info),
+	.family		= NFPROTO_UNSPEC,
+	.me		= THIS_MODULE
+};
+
+static int __init devgroup_mt_init(void)
+{
+	return xt_register_match(&devgroup_mt_reg);
+}
+
+static void __exit devgroup_mt_exit(void)
+{
+	xt_unregister_match(&devgroup_mt_reg);
+}
+
+module_init(devgroup_mt_init);
+module_exit(devgroup_mt_exit);

--------------010603070006080302090200--
