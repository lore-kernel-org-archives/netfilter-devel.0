From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 16/56] netfilter: xtables2: make a copy of the ipv6_filter table
Date: Tue, 29 Jun 2010 10:42:56 +0200
Message-ID: <1277801017-30600-17-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44266 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab0F2In5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:43:57 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A "filter2" table is temporarily added for testing and patching, so
as to not break bisection operations where ip6table_filter needs to
remain fully functional. It is compiled unconditionally alongside
"filter" for simplicity, only developers see it anyhow while it lives.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/net/netns/x_tables.h          |    1 +
 net/ipv6/netfilter/Makefile           |    2 +-
 net/ipv6/netfilter/ip6table_filter2.c |  113 +++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+), 1 deletions(-)
 create mode 100644 net/ipv6/netfilter/ip6table_filter2.c

diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
index 8a2d497..1e96a54 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -19,6 +19,7 @@ struct netns_xt {
 struct netns_xt2 {
 	struct mutex table_lock;
 	struct list_head table_list[NFPROTO_NUMPROTO];
+	struct xt_table *ipv6_filter;
 };
 
 #endif
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index aafbba3..35fa80f 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -4,7 +4,7 @@
 
 # Link order matters here.
 obj-$(CONFIG_IP6_NF_IPTABLES) += ip6_tables.o
-obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o
+obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o ip6table_filter2.o
 obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
 obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
 obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
diff --git a/net/ipv6/netfilter/ip6table_filter2.c b/net/ipv6/netfilter/ip6table_filter2.c
new file mode 100644
index 0000000..55750e4
--- /dev/null
+++ b/net/ipv6/netfilter/ip6table_filter2.c
@@ -0,0 +1,113 @@
+/*
+ * This is the 1999 rewrite of IP Firewalling, aiming for kernel 2.3.x.
+ *
+ * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
+ * Copyright (C) 2000-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/slab.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("ip6tables filter table");
+
+#define FILTER_VALID_HOOKS ((1 << NF_INET_LOCAL_IN) | \
+			    (1 << NF_INET_FORWARD) | \
+			    (1 << NF_INET_LOCAL_OUT))
+
+static const struct xt_table packet_filter = {
+	.name		= "filter2",
+	.valid_hooks	= FILTER_VALID_HOOKS,
+	.me		= THIS_MODULE,
+	.af		= NFPROTO_IPV6,
+	.priority	= NF_IP6_PRI_FILTER,
+};
+
+/* The work comes in here from netfilter.c. */
+static unsigned int
+ip6table_filter_hook(unsigned int hook, struct sk_buff *skb,
+		     const struct net_device *in, const struct net_device *out,
+		     int (*okfn)(struct sk_buff *))
+{
+	const struct net *net = dev_net((in != NULL) ? in : out);
+
+	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_filter);
+}
+
+static struct nf_hook_ops *filter_ops __read_mostly;
+
+/* Default to forward because I got too much mail already. */
+static int forward = NF_ACCEPT;
+module_param(forward, bool, 0000);
+
+static int __net_init ip6table_filter_net_init(struct net *net)
+{
+	struct ip6t_replace *repl;
+
+	repl = ip6t_alloc_initial_table(&packet_filter);
+	if (repl == NULL)
+		return -ENOMEM;
+	/* Entry 1 is the FORWARD hook */
+	((struct ip6t_standard *)repl->entries)[1].target.verdict =
+		-forward - 1;
+
+	net->xt2.ipv6_filter =
+		ip6t_register_table(net, &packet_filter, repl);
+	kfree(repl);
+	if (IS_ERR(net->xt2.ipv6_filter))
+		return PTR_ERR(net->xt2.ipv6_filter);
+	return 0;
+}
+
+static void __net_exit ip6table_filter_net_exit(struct net *net)
+{
+	ip6t_unregister_table(net, net->xt2.ipv6_filter);
+}
+
+static struct pernet_operations ip6table_filter_net_ops = {
+	.init = ip6table_filter_net_init,
+	.exit = ip6table_filter_net_exit,
+};
+
+static int __init ip6table_filter_init(void)
+{
+	int ret;
+
+	if (forward < 0 || forward > NF_MAX_VERDICT) {
+		pr_err("iptables forward must be 0 or 1\n");
+		return -EINVAL;
+	}
+
+	ret = register_pernet_subsys(&ip6table_filter_net_ops);
+	if (ret < 0)
+		return ret;
+
+	/* Register hooks */
+	filter_ops = xt_hook_link(&packet_filter, ip6table_filter_hook);
+	if (IS_ERR(filter_ops)) {
+		ret = PTR_ERR(filter_ops);
+		goto cleanup_table;
+	}
+
+	return ret;
+
+ cleanup_table:
+	unregister_pernet_subsys(&ip6table_filter_net_ops);
+	return ret;
+}
+
+static void __exit ip6table_filter_fini(void)
+{
+	xt_hook_unlink(&packet_filter, filter_ops);
+	unregister_pernet_subsys(&ip6table_filter_net_ops);
+}
+
+module_init(ip6table_filter_init);
+module_exit(ip6table_filter_fini);
-- 
1.7.1

