From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 05/11: ip6_tables: add ip6tables security table
Date: Fri,  6 Jun 2008 17:17:52 +0200 (MEST)
Message-ID: <20080606151750.25286.59330.sendpatchset@localhost.localdomain>
References: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48143 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174AbYFFPRy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:17:54 -0400
In-Reply-To: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ip6_tables: add ip6tables security table

This is a port of the IPv4 security table for IPv6.

Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 90faf09757063e4e45aba7124977ef5b82cd5223
tree a7e7a39d81e48803d3fdd4007cd9bafbd425e770
parent 9ca9e6f29c9a45b477de6f6ec63bc39331c384a2
author James Morris <jmorris@namei.org> Fri, 06 Jun 2008 17:11:00 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 17:11:00 +0200

 include/linux/netfilter_ipv6.h         |    1 
 include/net/netns/ipv6.h               |    1 
 net/ipv6/netfilter/Kconfig             |   12 ++
 net/ipv6/netfilter/Makefile            |    1 
 net/ipv6/netfilter/ip6table_security.c |  172 ++++++++++++++++++++++++++++++++
 5 files changed, 187 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 3475a65..fd50988 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -64,6 +64,7 @@ enum nf_ip6_hook_priorities {
 	NF_IP6_PRI_MANGLE = -150,
 	NF_IP6_PRI_NAT_DST = -100,
 	NF_IP6_PRI_FILTER = 0,
+	NF_IP6_PRI_SECURITY = 50,
 	NF_IP6_PRI_NAT_SRC = 100,
 	NF_IP6_PRI_SELINUX_LAST = 225,
 	NF_IP6_PRI_LAST = INT_MAX,
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index ac053be..5bacd83 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -35,6 +35,7 @@ struct netns_ipv6 {
 	struct xt_table		*ip6table_filter;
 	struct xt_table		*ip6table_mangle;
 	struct xt_table		*ip6table_raw;
+	struct xt_table		*ip6table_security;
 #endif
 	struct rt6_info         *ip6_null_entry;
 	struct rt6_statistics   *rt6_stats;
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 6cae547..30e54f6 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -208,5 +208,17 @@ config IP6_NF_RAW
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+# security table for MAC policy
+config IP6_NF_SECURITY
+       tristate "Security table"
+       depends on IP6_NF_IPTABLES
+       depends on SECURITY
+       default m if NETFILTER_ADVANCED=n
+       help
+         This option adds a `security' table to iptables, for use
+         with Mandatory Access Control (MAC) policy.
+        
+         If unsure, say N.
+
 endmenu
 
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index fbf2c14..3f17c94 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o
 obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
 obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
 obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
+obj-$(CONFIG_IP6_NF_SECURITY) += ip6table_security.o
 
 # objects for l3 independent conntrack
 nf_conntrack_ipv6-objs  :=  nf_conntrack_l3proto_ipv6.o nf_conntrack_proto_icmpv6.o nf_conntrack_reasm.o
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
new file mode 100644
index 0000000..4ce0148
--- /dev/null
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -0,0 +1,172 @@
+/*
+ * "security" table for IPv6
+ *
+ * This is for use by Mandatory Access Control (MAC) security models,
+ * which need to be able to manage security policy in separate context
+ * to DAC.
+ *
+ * Based on iptable_mangle.c
+ *
+ * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
+ * Copyright (C) 2000-2004 Netfilter Core Team <coreteam <at> netfilter.org>
+ * Copyright (C) 2008 Red Hat, Inc., James Morris <jmorris <at> redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("James Morris <jmorris <at> redhat.com>");
+MODULE_DESCRIPTION("ip6tables security table, for MAC rules");
+
+#define SECURITY_VALID_HOOKS	(1 << NF_INET_LOCAL_IN) | \
+				(1 << NF_INET_FORWARD) | \
+				(1 << NF_INET_LOCAL_OUT)
+
+static struct
+{
+	struct ip6t_replace repl;
+	struct ip6t_standard entries[3];
+	struct ip6t_error term;
+} initial_table __initdata = {
+	.repl = {
+		.name = "security",
+		.valid_hooks = SECURITY_VALID_HOOKS,
+		.num_entries = 4,
+		.size = sizeof(struct ip6t_standard) * 3 + sizeof(struct ip6t_error),
+		.hook_entry = {
+			[NF_INET_LOCAL_IN] 	= 0,
+			[NF_INET_FORWARD] 	= sizeof(struct ip6t_standard),
+			[NF_INET_LOCAL_OUT] 	= sizeof(struct ip6t_standard) * 2,
+		},
+		.underflow = {
+			[NF_INET_LOCAL_IN] 	= 0,
+			[NF_INET_FORWARD] 	= sizeof(struct ip6t_standard),
+			[NF_INET_LOCAL_OUT] 	= sizeof(struct ip6t_standard) * 2,
+		},
+	},
+	.entries = {
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
+	},
+	.term = IP6T_ERROR_INIT,		/* ERROR */
+};
+
+static struct xt_table security_table = {
+	.name		= "security",
+	.valid_hooks	= SECURITY_VALID_HOOKS,
+	.lock		= __RW_LOCK_UNLOCKED(security_table.lock),
+	.me		= THIS_MODULE,
+	.af		= AF_INET6,
+};
+
+static unsigned int
+ip6t_local_in_hook(unsigned int hook,
+		   struct sk_buff *skb,
+		   const struct net_device *in,
+		   const struct net_device *out,
+		   int (*okfn)(struct sk_buff *))
+{
+	return ip6t_do_table(skb, hook, in, out,
+			     init_net.ipv6.ip6table_security);
+}
+
+static unsigned int
+ip6t_forward_hook(unsigned int hook,
+		  struct sk_buff *skb,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  int (*okfn)(struct sk_buff *))
+{
+	return ip6t_do_table(skb, hook, in, out,
+		 	     init_net.ipv6.ip6table_security);
+}
+
+static unsigned int
+ip6t_local_out_hook(unsigned int hook,
+		    struct sk_buff *skb,
+		    const struct net_device *in,
+		    const struct net_device *out,
+		    int (*okfn)(struct sk_buff *))
+{
+	/* TBD: handle short packets via raw socket */
+	return ip6t_do_table(skb, hook, in, out,
+			     init_net.ipv6.ip6table_security);
+}
+
+static struct nf_hook_ops ip6t_ops[] __read_mostly = {
+	{
+		.hook		= ip6t_local_in_hook,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET6,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP6_PRI_SECURITY,
+	},
+	{
+		.hook		= ip6t_forward_hook,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET6,
+		.hooknum	= NF_INET_FORWARD,
+		.priority	= NF_IP6_PRI_SECURITY,
+	},
+	{
+		.hook		= ip6t_local_out_hook,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET6,
+		.hooknum	= NF_INET_LOCAL_OUT,
+		.priority	= NF_IP6_PRI_SECURITY,
+	},
+};
+
+static int __net_init ip6table_security_net_init(struct net *net)
+{
+	net->ipv6.ip6table_security =
+		ip6t_register_table(net, &security_table, &initial_table.repl);
+
+	if (IS_ERR(net->ipv6.ip6table_security))
+		return PTR_ERR(net->ipv6.ip6table_security);
+
+	return 0;
+}
+
+static void __net_exit ip6table_security_net_exit(struct net *net)
+{
+	ip6t_unregister_table(net->ipv6.ip6table_security);
+}
+
+static struct pernet_operations ip6table_security_net_ops = {
+	.init = ip6table_security_net_init,
+	.exit = ip6table_security_net_exit,
+};
+
+static int __init ip6table_security_init(void)
+{
+	int ret;
+
+	ret = register_pernet_subsys(&ip6table_security_net_ops);
+	if (ret < 0)
+		return ret;
+
+	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
+	if (ret < 0)
+		goto cleanup_table;
+
+	return ret;
+
+cleanup_table:
+	unregister_pernet_subsys(&ip6table_security_net_ops);
+	return ret;
+}
+
+static void __exit ip6table_security_fini(void)
+{
+	nf_unregister_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
+	unregister_pernet_subsys(&ip6table_security_net_ops);
+}
+
+module_init(ip6table_security_init);
+module_exit(ip6table_security_fini);
