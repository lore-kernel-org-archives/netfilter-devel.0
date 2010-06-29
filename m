From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 33/56] netfilter: xtables2: switch ip6's tables to the xt2 table format
Date: Tue, 29 Jun 2010 10:43:13 +0200
Message-ID: <1277801017-30600-34-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44309 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab0F2IoR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:17 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/net/netns/x_tables.h           |    3 +-
 net/ipv6/netfilter/Makefile            |    2 +-
 net/ipv6/netfilter/ip6table_filter.c   |   24 +++++--
 net/ipv6/netfilter/ip6table_filter2.c  |  122 --------------------------------
 net/ipv6/netfilter/ip6table_mangle.c   |   37 ++++++----
 net/ipv6/netfilter/ip6table_raw.c      |   23 ++++--
 net/ipv6/netfilter/ip6table_security.c |   24 ++++--
 7 files changed, 76 insertions(+), 159 deletions(-)
 delete mode 100644 net/ipv6/netfilter/ip6table_filter2.c

diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
index 9365569..580f27b 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -19,7 +19,8 @@ struct netns_xt {
 struct netns_xt2 {
 	struct mutex table_lock;
 	struct list_head table_list[NFPROTO_NUMPROTO];
-	struct xt2_table_link *ipv6_filter;
+	struct xt2_table_link
+		*ipv6_filter, *ipv6_mangle, *ipv6_raw, *ipv6_security;
 };
 
 #endif
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 35fa80f..aafbba3 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -4,7 +4,7 @@
 
 # Link order matters here.
 obj-$(CONFIG_IP6_NF_IPTABLES) += ip6_tables.o
-obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o ip6table_filter2.o
+obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o
 obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
 obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
 obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index c9e37c8..99d0340 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -11,6 +11,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/rcupdate.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/slab.h>
 
@@ -37,8 +38,14 @@ ip6table_filter_hook(unsigned int hook, struct sk_buff *skb,
 		     int (*okfn)(struct sk_buff *))
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
-
-	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_filter);
+	const struct xt2_table_link *link;
+	unsigned int verdict;
+
+	rcu_read_lock();
+	link    = rcu_dereference(net->xt2.ipv6_filter);
+	verdict = xt2_do_table(skb, hook, in, out, link->table);
+	rcu_read_unlock();
+	return verdict;
 }
 
 static struct nf_hook_ops *filter_ops __read_mostly;
@@ -50,6 +57,7 @@ module_param(forward, bool, 0000);
 static int __net_init ip6table_filter_net_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	struct xt2_table *table;
 
 	repl = ip6t_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
@@ -58,17 +66,19 @@ static int __net_init ip6table_filter_net_init(struct net *net)
 	((struct ip6t_standard *)repl->entries)[1].target.verdict =
 		-forward - 1;
 
-	net->ipv6.ip6table_filter =
-		ip6t_register_table(net, &packet_filter, repl);
+	table = ip6t2_register_table(net, &packet_filter, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv6.ip6table_filter))
-		return PTR_ERR(net->ipv6.ip6table_filter);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	net->xt2.ipv6_filter = xt2_tlink_lookup(net, table->name,
+						table->nfproto,
+						XT2_STD_RCULOCK);
 	return 0;
 }
 
 static void __net_exit ip6table_filter_net_exit(struct net *net)
 {
-	ip6t_unregister_table(net, net->ipv6.ip6table_filter);
+	xt2_table_destroy(net, net->xt2.ipv6_filter->table);
 }
 
 static struct pernet_operations ip6table_filter_net_ops = {
diff --git a/net/ipv6/netfilter/ip6table_filter2.c b/net/ipv6/netfilter/ip6table_filter2.c
deleted file mode 100644
index f81f98b..0000000
--- a/net/ipv6/netfilter/ip6table_filter2.c
+++ /dev/null
@@ -1,122 +0,0 @@
-/*
- * This is the 1999 rewrite of IP Firewalling, aiming for kernel 2.3.x.
- *
- * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
- * Copyright (C) 2000-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/slab.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("ip6tables filter table");
-
-#define FILTER_VALID_HOOKS ((1 << NF_INET_LOCAL_IN) | \
-			    (1 << NF_INET_FORWARD) | \
-			    (1 << NF_INET_LOCAL_OUT))
-
-static const struct xt_table packet_filter = {
-	.name		= "filter2",
-	.valid_hooks	= FILTER_VALID_HOOKS,
-	.me		= THIS_MODULE,
-	.af		= NFPROTO_IPV6,
-	.priority	= NF_IP6_PRI_FILTER,
-};
-
-/* The work comes in here from netfilter.c. */
-static unsigned int
-ip6table_filter_hook(unsigned int hook, struct sk_buff *skb,
-		     const struct net_device *in, const struct net_device *out,
-		     int (*okfn)(struct sk_buff *))
-{
-	const struct net *net = dev_net((in != NULL) ? in : out);
-	const struct xt2_table_link *link;
-	unsigned int verdict;
-
-	rcu_read_lock();
-	link = rcu_dereference(net->xt2.ipv6_filter);
-	verdict = xt2_do_table(skb, hook, in, out, link->table);
-	rcu_read_unlock();
-	return verdict;
-}
-
-static struct nf_hook_ops *filter_ops __read_mostly;
-
-/* Default to forward because I got too much mail already. */
-static int forward = NF_ACCEPT;
-module_param(forward, bool, 0000);
-
-static int __net_init ip6table_filter_net_init(struct net *net)
-{
-	struct ip6t_replace *repl;
-	struct xt2_table *table;
-
-	repl = ip6t_alloc_initial_table(&packet_filter);
-	if (repl == NULL)
-		return -ENOMEM;
-	/* Entry 1 is the FORWARD hook */
-	((struct ip6t_standard *)repl->entries)[1].target.verdict =
-		-forward - 1;
-
-	table = ip6t2_register_table(net, &packet_filter, repl);
-	kfree(repl);
-	if (IS_ERR(table))
-		return PTR_ERR(table);
-	net->xt2.ipv6_filter = xt2_tlink_lookup(net, table->name,
-						table->nfproto,
-						XT2_STD_RCULOCK);
-	return 0;
-}
-
-static void __net_exit ip6table_filter_net_exit(struct net *net)
-{
-	xt2_table_destroy(net, net->xt2.ipv6_filter->table);
-}
-
-static struct pernet_operations ip6table_filter_net_ops = {
-	.init = ip6table_filter_net_init,
-	.exit = ip6table_filter_net_exit,
-};
-
-static int __init ip6table_filter_init(void)
-{
-	int ret;
-
-	if (forward < 0 || forward > NF_MAX_VERDICT) {
-		pr_err("iptables forward must be 0 or 1\n");
-		return -EINVAL;
-	}
-
-	ret = register_pernet_subsys(&ip6table_filter_net_ops);
-	if (ret < 0)
-		return ret;
-
-	/* Register hooks */
-	filter_ops = xt_hook_link(&packet_filter, ip6table_filter_hook);
-	if (IS_ERR(filter_ops)) {
-		ret = PTR_ERR(filter_ops);
-		goto cleanup_table;
-	}
-
-	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&ip6table_filter_net_ops);
-	return ret;
-}
-
-static void __exit ip6table_filter_fini(void)
-{
-	xt_hook_unlink(&packet_filter, filter_ops);
-	unregister_pernet_subsys(&ip6table_filter_net_ops);
-}
-
-module_init(ip6table_filter_init);
-module_exit(ip6table_filter_fini);
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 679a0a3..f348782 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/module.h>
+#include <linux/rcupdate.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/slab.h>
 
@@ -33,6 +34,7 @@ static const struct xt_table packet_mangler = {
 static unsigned int
 ip6t_mangle_out(struct sk_buff *skb, const struct net_device *out)
 {
+	const struct xt2_table_link *link;
 	unsigned int ret;
 	struct in6_addr saddr, daddr;
 	u_int8_t hop_limit;
@@ -57,8 +59,10 @@ ip6t_mangle_out(struct sk_buff *skb, const struct net_device *out)
 	/* flowlabel and prio (includes version, which shouldn't change either */
 	flowlabel = *((u_int32_t *)ipv6_hdr(skb));
 
-	ret = ip6t_do_table(skb, NF_INET_LOCAL_OUT, NULL, out,
-			    dev_net(out)->ipv6.ip6table_mangle);
+	rcu_read_lock();
+	link = rcu_dereference(dev_net(out)->xt2.ipv6_mangle);
+	ret  = xt2_do_table(skb, NF_INET_LOCAL_OUT, NULL, out, link->table);
+	rcu_read_unlock();
 
 	if (ret != NF_DROP && ret != NF_STOLEN &&
 	    (memcmp(&ipv6_hdr(skb)->saddr, &saddr, sizeof(saddr)) ||
@@ -76,35 +80,42 @@ ip6table_mangle_hook(unsigned int hook, struct sk_buff *skb,
 		     const struct net_device *in, const struct net_device *out,
 		     int (*okfn)(struct sk_buff *))
 {
+	const struct net *net = dev_net((in != NULL) ? in : out);
+	const struct xt2_table_link *link;
+	unsigned int verdict;
+
 	if (hook == NF_INET_LOCAL_OUT)
 		return ip6t_mangle_out(skb, out);
-	if (hook == NF_INET_POST_ROUTING)
-		return ip6t_do_table(skb, hook, in, out,
-				     dev_net(out)->ipv6.ip6table_mangle);
-	/* INPUT/FORWARD */
-	return ip6t_do_table(skb, hook, in, out,
-			     dev_net(in)->ipv6.ip6table_mangle);
+
+	rcu_read_lock();
+	link    = rcu_dereference(net->xt2.ipv6_mangle);
+	verdict = xt2_do_table(skb, hook, in, out, link->table);
+	rcu_read_unlock();
+	return verdict;
 }
 
 static struct nf_hook_ops *mangle_ops __read_mostly;
 static int __net_init ip6table_mangle_net_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	struct xt2_table *table;
 
 	repl = ip6t_alloc_initial_table(&packet_mangler);
 	if (repl == NULL)
 		return -ENOMEM;
-	net->ipv6.ip6table_mangle =
-		ip6t_register_table(net, &packet_mangler, repl);
+	table = ip6t2_register_table(net, &packet_mangler, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv6.ip6table_mangle))
-		return PTR_ERR(net->ipv6.ip6table_mangle);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	net->xt2.ipv6_mangle = xt2_tlink_lookup(net, table->name,
+						table->nfproto,
+						XT2_STD_RCULOCK);
 	return 0;
 }
 
 static void __net_exit ip6table_mangle_net_exit(struct net *net)
 {
-	ip6t_unregister_table(net, net->ipv6.ip6table_mangle);
+	xt2_table_destroy(net, net->xt2.ipv6_mangle->table);
 }
 
 static struct pernet_operations ip6table_mangle_net_ops = {
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 5b9926a..a1f1741 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  */
 #include <linux/module.h>
+#include <linux/rcupdate.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/slab.h>
 
@@ -24,8 +25,14 @@ ip6table_raw_hook(unsigned int hook, struct sk_buff *skb,
 		  int (*okfn)(struct sk_buff *))
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
-
-	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_raw);
+	const struct xt2_table_link *link;
+	unsigned int verdict;
+
+	rcu_read_lock();
+	link    = rcu_dereference(net->xt2.ipv6_raw);
+	verdict = xt2_do_table(skb, hook, in, out, link->table);
+	rcu_read_unlock();
+	return verdict;
 }
 
 static struct nf_hook_ops *rawtable_ops __read_mostly;
@@ -33,21 +40,23 @@ static struct nf_hook_ops *rawtable_ops __read_mostly;
 static int __net_init ip6table_raw_net_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	struct xt2_table *table;
 
 	repl = ip6t_alloc_initial_table(&packet_raw);
 	if (repl == NULL)
 		return -ENOMEM;
-	net->ipv6.ip6table_raw =
-		ip6t_register_table(net, &packet_raw, repl);
+	table = ip6t2_register_table(net, &packet_raw, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv6.ip6table_raw))
-		return PTR_ERR(net->ipv6.ip6table_raw);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	net->xt2.ipv6_raw = xt2_tlink_lookup(net, table->name,
+					     table->nfproto, XT2_STD_RCULOCK);
 	return 0;
 }
 
 static void __net_exit ip6table_raw_net_exit(struct net *net)
 {
-	ip6t_unregister_table(net, net->ipv6.ip6table_raw);
+	xt2_table_destroy(net, net->xt2.ipv6_raw->table);
 }
 
 static struct pernet_operations ip6table_raw_net_ops = {
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 91aa2b4..8746620 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -42,8 +42,14 @@ ip6table_security_hook(unsigned int hook, struct sk_buff *skb,
 		       int (*okfn)(struct sk_buff *))
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
-
-	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_security);
+	const struct xt2_table_link *link;
+	unsigned int verdict;
+
+	rcu_read_lock();
+	link    = rcu_dereference(net->xt2.ipv6_security);
+	verdict = xt2_do_table(skb, hook, in, out, link->table);
+	rcu_read_unlock();
+	return verdict;
 }
 
 static struct nf_hook_ops *sectbl_ops __read_mostly;
@@ -51,22 +57,24 @@ static struct nf_hook_ops *sectbl_ops __read_mostly;
 static int __net_init ip6table_security_net_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	struct xt2_table *table;
 
 	repl = ip6t_alloc_initial_table(&security_table);
 	if (repl == NULL)
 		return -ENOMEM;
-	net->ipv6.ip6table_security =
-		ip6t_register_table(net, &security_table, repl);
+	table = ip6t2_register_table(net, &security_table, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv6.ip6table_security))
-		return PTR_ERR(net->ipv6.ip6table_security);
-
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	net->xt2.ipv6_security = xt2_tlink_lookup(net, table->name,
+						  table->nfproto,
+						  XT2_STD_RCULOCK);
 	return 0;
 }
 
 static void __net_exit ip6table_security_net_exit(struct net *net)
 {
-	ip6t_unregister_table(net, net->ipv6.ip6table_security);
+	xt2_table_destroy(net, net->xt2.ipv6_security->table);
 }
 
 static struct pernet_operations ip6table_security_net_ops = {
-- 
1.7.1

