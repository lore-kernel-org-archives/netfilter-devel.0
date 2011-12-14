From: pablo@netfilter.org
Subject: [PATCH 2/2] netfilter: xtables: add NFACCT target to support extended accounting
Date: Wed, 14 Dec 2011 12:00:43 +0100
Message-ID: <1323860443-7129-3-git-send-email-pablo@netfilter.org>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
Cc: kadlec@blackhole.kfki.hu, kaber@trash.net, jengelh@medozas.de,
	thomas.jarosch@intra2net.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56427 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab1LNLBY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:01:24 -0500
In-Reply-To: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds the target that allows to perform extended
accounting. It requires the new nfnetlink_acct infrastructure.

 # iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name http-traffic
 # iptables -I OUTPUT -p tcp --dport 80 -j NFACCT --nfacct-name http-traffic

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/Kbuild      |    1 +
 include/linux/netfilter/xt_NFACCT.h |   17 ++++++++
 net/netfilter/Kconfig               |   10 ++++
 net/netfilter/Makefile              |    1 +
 net/netfilter/xt_NFACCT.c           |   78 +++++++++++++++++++++++++++++++++++
 5 files changed, 107 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_NFACCT.h
 create mode 100644 net/netfilter/xt_NFACCT.c

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 8995867..16473ff 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -22,6 +22,7 @@ header-y += xt_DSCP.h
 header-y += xt_IDLETIMER.h
 header-y += xt_LED.h
 header-y += xt_MARK.h
+header-y += xt_NFACCT.h
 header-y += xt_NFLOG.h
 header-y += xt_NFQUEUE.h
 header-y += xt_RATEEST.h
diff --git a/include/linux/netfilter/xt_NFACCT.h b/include/linux/netfilter/xt_NFACCT.h
new file mode 100644
index 0000000..63a2d55
--- /dev/null
+++ b/include/linux/netfilter/xt_NFACCT.h
@@ -0,0 +1,17 @@
+#ifndef _XT_NFACCT_TARGET_H
+#define _XT_NFACCT_TARGET_H
+
+#include <linux/types.h>
+
+#ifndef NFACCT_NAME_MAX
+#define NFACCT_NAME_MAX 64
+#endif
+
+struct nf_acct;
+
+struct xt_nfacct_target_info {
+	char		name[NFACCT_NAME_MAX];
+	struct nf_acct	*nfacct;
+};
+
+#endif /* _XT_NFACCT_TARGET_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 77326ac..8dfb5ac 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -523,6 +523,16 @@ config NETFILTER_XT_TARGET_MARK
 	(e.g. when running oldconfig). It selects
 	CONFIG_NETFILTER_XT_MARK (combined mark/MARK module).
 
+config NETFILTER_XT_TARGET_NFACCT
+	tristate '"NFACCT" target support'
+	default m if NETFILTER_ADVANCED=n
+	select NETFILTER_NETLINK_ACCT
+	help
+	  This option enables the NFACCT target, which allows extended
+	  accounting through nfnetlink_acct.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_NFLOG
 	tristate '"NFLOG" target support'
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 4da1c87..af11b81 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CT) += xt_CT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_HL) += xt_HL.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LED) += xt_LED.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_NFACCT) += xt_NFACCT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
diff --git a/net/netfilter/xt_NFACCT.c b/net/netfilter/xt_NFACCT.c
new file mode 100644
index 0000000..7d26c5f
--- /dev/null
+++ b/net/netfilter/xt_NFACCT.c
@@ -0,0 +1,78 @@
+/*
+ * (C) 2011 Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2011 Intra2net AG <http://www.intra2net.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later at your option) as published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/nfnetlink_acct.h>
+#include <linux/netfilter/xt_NFACCT.h>
+
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("Xtables: area-based accouting target");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_NFACCT");
+MODULE_ALIAS("ip6t_NFACCT");
+
+static unsigned int
+nfacct_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_nfacct_target_info *info = par->targinfo;
+
+	/* This update function internally uses one spin lock. */
+	nfnl_acct_update(skb, info->nfacct);
+
+	return XT_CONTINUE;
+}
+
+static int
+nfacct_tg_checkentry(const struct xt_tgchk_param *par)
+{
+	struct xt_nfacct_target_info *info = par->targinfo;
+	struct nf_acct *nfacct;
+
+	nfacct = nfnl_acct_find_get(info->name);
+	if (nfacct == NULL) {
+		pr_info("accounting area with name `%s' does not exists\n",
+			info->name);
+		return -ENOENT;
+	}
+	info->nfacct = nfacct;
+	return 0;
+}
+
+static void
+nfacct_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	const struct xt_nfacct_target_info *info = par->targinfo;
+
+	nfnl_acct_put(info->nfacct);
+}
+
+static struct xt_target nfacct_tg_reg __read_mostly = {
+	.name       = "NFACCT",
+	.family     = NFPROTO_UNSPEC,
+	.checkentry = nfacct_tg_checkentry,
+	.target     = nfacct_tg,
+	.destroy    = nfacct_tg_destroy,
+	.targetsize = sizeof(struct xt_nfacct_target_info),
+	.me         = THIS_MODULE,
+};
+
+static int __init nfacct_tg_init(void)
+{
+	return xt_register_target(&nfacct_tg_reg);
+}
+
+static void __exit nfacct_tg_exit(void)
+{
+	xt_unregister_target(&nfacct_tg_reg);
+}
+
+module_init(nfacct_tg_init);
+module_exit(nfacct_tg_exit);
-- 
1.7.2.5

