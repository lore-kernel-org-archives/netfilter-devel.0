From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH] nfnetlink: add a new subsystem to advertise tables update
Date: Mon, 24 Sep 2012 17:39:42 +0200
Message-ID: <1348501182-12470-1-git-send-email-nicolas.dichtel@6wind.com>
Cc: pablo@netfilter.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:57297 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab2IXPhB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:37:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For now, there is no way to be informed, when a netfilter table is updated.

With this patch a netlink message is sent when a table is updated, with the
name of the table and the family.
For this purpose, a new subsystem (with a new group) has been added.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/linux/netfilter/nfnetlink.h        |  5 ++-
 include/linux/netfilter/nfnetlink_compat.h |  1 +
 include/linux/netfilter/nfnetlink_tables.h | 24 +++++++++++
 include/linux/netfilter/x_tables.h         |  3 +-
 include/net/netfilter/nfnetlink_tables.h   |  6 +++
 net/ipv4/netfilter/arp_tables.c            |  2 +-
 net/ipv4/netfilter/ip_tables.c             |  2 +-
 net/ipv6/netfilter/ip6_tables.c            |  2 +-
 net/netfilter/Kconfig                      |  9 +++++
 net/netfilter/Makefile                     |  1 +
 net/netfilter/nfnetlink_tables.c           | 65 ++++++++++++++++++++++++++++++
 net/netfilter/x_tables.c                   | 11 ++++-
 12 files changed, 124 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_tables.h
 create mode 100644 include/net/netfilter/nfnetlink_tables.h
 create mode 100644 net/netfilter/nfnetlink_tables.c

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 18341cd..2470a1c 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -18,6 +18,8 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_UPDATE	NFNLGRP_CONNTRACK_EXP_UPDATE
 	NFNLGRP_CONNTRACK_EXP_DESTROY,
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
+	NFNLGRP_TABLES,
+#define NFNLGRP_TABLES			NFNLGRP_TABLES
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
@@ -51,7 +53,8 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_ACCT		7
 #define NFNL_SUBSYS_CTNETLINK_TIMEOUT	8
 #define NFNL_SUBSYS_CTHELPER		9
-#define NFNL_SUBSYS_COUNT		10
+#define NFNL_SUBSYS_TABLES		10
+#define NFNL_SUBSYS_COUNT		11
 
 #ifdef __KERNEL__
 
diff --git a/include/linux/netfilter/nfnetlink_compat.h b/include/linux/netfilter/nfnetlink_compat.h
index ffb9503..a4cab85 100644
--- a/include/linux/netfilter/nfnetlink_compat.h
+++ b/include/linux/netfilter/nfnetlink_compat.h
@@ -13,6 +13,7 @@
 #define NF_NETLINK_CONNTRACK_EXP_NEW		0x00000008
 #define NF_NETLINK_CONNTRACK_EXP_UPDATE		0x00000010
 #define NF_NETLINK_CONNTRACK_EXP_DESTROY	0x00000020
+#define NF_NETLINK_TABLES			0x00000040
 
 /* Generic structure for encapsulation optional netfilter information.
  * It is reminiscent of sockaddr, but with sa_family replaced
diff --git a/include/linux/netfilter/nfnetlink_tables.h b/include/linux/netfilter/nfnetlink_tables.h
new file mode 100644
index 0000000..630dc9b
--- /dev/null
+++ b/include/linux/netfilter/nfnetlink_tables.h
@@ -0,0 +1,24 @@
+#ifndef _NFNETLINK_TABLES_H
+#define _NFNETLINK_TABLES_H
+
+/* This file describes the netlink messages (i.e. 'protocol packets'),
+ * and not any kind of function definitions.  It is shared between kernel and
+ * userspace.  Don't put kernel specific stuff in here */
+
+#include <linux/types.h>
+#include <linux/netfilter/nfnetlink.h>
+
+enum nftbl_types {
+	NFTBL_UPDATE,
+
+	NFTBL_MSG_MAX
+};
+
+enum nfnl_tables_attr_type {
+        NFTBLA_UNSPEC,
+        NFTBLA_TABLENAME,
+        __NFTBLA_MAX
+};
+#define NFTBLA_MAX (__NFTBLA_MAX - 1)
+
+#endif /* _NFNETLINK_TABLES_H */
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 8d674a7..280612d 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -432,7 +432,8 @@ extern struct xt_table *xt_register_table(struct net *net,
 					  struct xt_table_info *newinfo);
 extern void *xt_unregister_table(struct xt_table *table);
 
-extern struct xt_table_info *xt_replace_table(struct xt_table *table,
+extern struct xt_table_info *xt_replace_table(struct net *net,
+					      struct xt_table *table,
 					      unsigned int num_counters,
 					      struct xt_table_info *newinfo,
 					      int *error);
diff --git a/include/net/netfilter/nfnetlink_tables.h b/include/net/netfilter/nfnetlink_tables.h
new file mode 100644
index 0000000..0d87b69
--- /dev/null
+++ b/include/net/netfilter/nfnetlink_tables.h
@@ -0,0 +1,6 @@
+#ifndef _KER_NFNETLINK_TABLES_H
+#define _KER_NFNETLINK_TABLES_H
+
+int nfnl_msgtables_send_update(struct net *net, const struct xt_table *table);
+
+#endif /* _KER_NFNETLINK_TABLES_H */
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 97e61ea..6fd6002 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1014,7 +1014,7 @@ static int __do_replace(struct net *net, const char *name,
 		goto put_module;
 	}
 
-	oldinfo = xt_replace_table(t, num_counters, newinfo, &ret);
+	oldinfo = xt_replace_table(net, t, num_counters, newinfo, &ret);
 	if (!oldinfo)
 		goto put_module;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 170b1fd..04dfa7f 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1202,7 +1202,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		goto put_module;
 	}
 
-	oldinfo = xt_replace_table(t, num_counters, newinfo, &ret);
+	oldinfo = xt_replace_table(net, t, num_counters, newinfo, &ret);
 	if (!oldinfo)
 		goto put_module;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d7cb045..6741442 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1212,7 +1212,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		goto put_module;
 	}
 
-	oldinfo = xt_replace_table(t, num_counters, newinfo, &ret);
+	oldinfo = xt_replace_table(net, t, num_counters, newinfo, &ret);
 	if (!oldinfo)
 		goto put_module;
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3f4b3b4..3ca9de4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -32,6 +32,15 @@ config NETFILTER_NETLINK_LOG
 	  and is also scheduled to replace the old syslog-based ipt_LOG
 	  and ip6t_LOG modules.
 
+config NETFILTER_NETLINK_TABLES
+	tristate "Netfilter Tables events over NFNETLINK interface"
+	depends on NETFILTER_XTABLES
+	select NETFILTER_NETLINK
+	default m
+	help
+	  If this option is enabled, the kernel will avertise operations
+	  on xt_tables via NFNETLINK.
+
 config NF_CONNTRACK
 	tristate "Netfilter connection tracking support"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0baa3f1..07d5c5e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -13,6 +13,7 @@ nfnetlink_queue-y := nfnetlink_queue_core.o
 nfnetlink_queue-$(CONFIG_NETFILTER_NETLINK_QUEUE_CT) += nfnetlink_queue_ct.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
 obj-$(CONFIG_NETFILTER_NETLINK_LOG) += nfnetlink_log.o
+obj-$(CONFIG_NETFILTER_NETLINK_TABLES) += nfnetlink_tables.o
 
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK) += nf_conntrack.o
diff --git a/net/netfilter/nfnetlink_tables.c b/net/netfilter/nfnetlink_tables.c
new file mode 100644
index 0000000..dce1092
--- /dev/null
+++ b/net/netfilter/nfnetlink_tables.c
@@ -0,0 +1,65 @@
+/*
+ * (C) 2012 by Nicolas Dichtel <nicolas.dichtel@6wind.com>
+ * (C) 2012 by 6WIND <http://www.6wind.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation (or any later at your option).
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/init.h>
+#include <linux/netfilter.h>
+#include <linux/netlink.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_tables.h>
+
+int nfnl_msgtables_send_update(struct net *net, const struct xt_table *table)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfmsg;
+	int size, err;
+
+	size = NLMSG_ALIGN(sizeof(struct nfgenmsg)) +
+	       nla_total_size(sizeof(char[XT_TABLE_MAXNAMELEN]));
+	skb = nlmsg_new(size, GFP_ATOMIC);
+	if (skb == NULL)
+		goto errout;
+
+	nlh = nlmsg_put(skb, 0, 0, NFNL_SUBSYS_TABLES << 8 | NFTBL_UPDATE,
+			sizeof(struct nfgenmsg), 0);
+	if (nlh == NULL)
+		goto nlmsg_failure;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family = table->af;
+	nfmsg->version = NFNETLINK_V0;
+	nfmsg->res_id = 0;
+
+	if (nla_put_string(skb, NFTBLA_TABLENAME, table->name))
+		 goto nla_put_failure;
+
+	nlmsg_end(skb, nlh);
+
+	err = nfnetlink_send(skb, net, 0, NFNLGRP_TABLES, 0, 0);
+	if (err == -ENOBUFS || err == -EAGAIN)
+		return -ENOBUFS;
+
+	return 0;
+
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+nlmsg_failure:
+	kfree_skb(skb);
+errout:
+	if (nfnetlink_set_err(net, 0, NFNLGRP_TABLES, -ENOBUFS) > 0)
+		return -ENOBUFS;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nfnl_msgtables_send_update);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nicolas Dichtel <nicolas.dichtel@6wind.com>");
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8d987c3..8ea4dc3 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -32,6 +32,9 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_arp/arp_tables.h>
+#if IS_ENABLED (CONFIG_NETFILTER_NETLINK_TABLES)
+#include <net/netfilter/nfnetlink_tables.h>
+#endif
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
@@ -805,7 +808,7 @@ static int xt_jumpstack_alloc(struct xt_table_info *i)
 }
 
 struct xt_table_info *
-xt_replace_table(struct xt_table *table,
+xt_replace_table(struct net *net, struct xt_table *table,
 	      unsigned int num_counters,
 	      struct xt_table_info *newinfo,
 	      int *error)
@@ -843,6 +846,10 @@ xt_replace_table(struct xt_table *table,
 	 */
 	local_bh_enable();
 
+#if IS_ENABLED(CONFIG_NETFILTER_NETLINK_TABLES)
+	nfnl_msgtables_send_update(net, table);
+#endif
+
 #ifdef CONFIG_AUDIT
 	if (audit_enabled) {
 		struct audit_buffer *ab;
@@ -893,7 +900,7 @@ struct xt_table *xt_register_table(struct net *net,
 	/* Simplifies replace_table code. */
 	table->private = bootstrap;
 
-	if (!xt_replace_table(table, 0, newinfo, &ret))
+	if (!xt_replace_table(net, table, 0, newinfo, &ret))
 		goto unlock;
 
 	private = table->private;
-- 
1.7.12

