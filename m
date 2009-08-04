From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 091/103] netfilter: iptables: switch to xt2 tables
Date: Tue,  4 Aug 2009 09:26:15 +0200
Message-ID: <1249370787-17583-92-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56959 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616AbZHDH2L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:11 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/net/netns/x_tables.h          |    3 +
 net/ipv4/netfilter/ip_tables.c        |  201 ++++++++++++---------------------
 net/ipv4/netfilter/iptable_filter.c   |   21 +++-
 net/ipv4/netfilter/iptable_mangle.c   |   29 ++++--
 net/ipv4/netfilter/iptable_raw.c      |   21 +++-
 net/ipv4/netfilter/iptable_security.c |   22 +++-
 net/ipv4/netfilter/nf_nat_rule.c      |   18 ++-
 7 files changed, 154 insertions(+), 161 deletions(-)

diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
index 5e38fcd..68b0b4f 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -17,6 +17,9 @@ struct netns_xt2 {
 	struct mutex table_lock;
 	struct list_head table_list[NFPROTO_NUMPROTO];
 	struct xt2_table_link
+		*ipv4_filter, *ipv4_mangle, *ipv4_raw, *ipv4_security,
+		*ipv4_nat;
+	struct xt2_table_link
 		*ipv6_filter, *ipv6_mangle, *ipv6_raw, *ipv6_security;
 };
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 7b7f1c3..6a45da8 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1191,11 +1191,51 @@ static int compat_table_info(const struct xt_table_info *info,
 }
 #endif
 
+static const struct xt1_xlat_info ipt_compat_xlat_info = {
+#ifdef CONFIG_COMPAT
+	.marker_size     = XT_ALIGN(sizeof(struct ipt_error_target)),
+	.entry_hdr_size  = sizeof(struct compat_ipt_entry),
+	.pmatch_size     = sizeof(struct ipt_ip),
+	.first_match     = "ipv4",
+	.ematch_size     = sizeof(struct xt_entry_match),
+	.etarget_size    = sizeof(struct xt_entry_target),
+	.standard_tgsize = COMPAT_XT_ALIGN(sizeof(struct xt_entry_target) +
+	                   sizeof(compat_uint_t)),
+	.compat          = true,
+#endif
+};
+
+static const struct xt1_xlat_info ipt_xlat_info = {
+	.marker_size     = XT_ALIGN(sizeof(struct ipt_error_target)),
+	.entry_hdr_size  = sizeof(struct ipt_entry),
+	.pmatch_size     = sizeof(struct ipt_ip),
+	.first_match     = "ipv4",
+	.ematch_size     = sizeof(struct xt_entry_match),
+	.etarget_size    = sizeof(struct xt_entry_target),
+	.standard_tgsize = XT_ALIGN(sizeof(struct xt_entry_target) +
+	                   sizeof(int)),
+};
+
+static int ipt2_get_info(void __user *uptr, int len,
+                         struct xt2_table *table, bool compat)
+{
+	struct ipt_getinfo info = {
+		.valid_hooks = table->valid_hooks,
+	};
+
+	strncpy(info.name, table->name,
+	        min(sizeof(info.name), sizeof(table->name)));
+	info.size = xts_blob_prep_table(table,
+	            compat ? &ipt_compat_xlat_info : &ipt_xlat_info,
+	            info.hook_entry, info.underflow, &info.num_entries);
+	return (copy_to_user(uptr, &info, sizeof(info)) != 0) ? -EFAULT : 0;
+}
+
 static int get_info(struct net *net, void __user *user,
                     const int *len, int compat)
 {
 	char name[IPT_TABLE_MAXNAMELEN];
-	struct xt_table *t;
+	struct xt2_table *table;
 	int ret;
 
 	if (*len != sizeof(struct ipt_getinfo)) {
@@ -1208,46 +1248,13 @@ static int get_info(struct net *net, void __user *user,
 		return -EFAULT;
 
 	name[IPT_TABLE_MAXNAMELEN-1] = '\0';
-#ifdef CONFIG_COMPAT
-	if (compat)
-		xt_compat_lock(AF_INET);
-#endif
-	t = try_then_request_module(xt_find_table_lock(net, AF_INET, name),
-				    "iptable_%s", name);
-	if (t && !IS_ERR(t)) {
-		struct ipt_getinfo info;
-		const struct xt_table_info *private = t->private;
-
-#ifdef CONFIG_COMPAT
-		if (compat) {
-			struct xt_table_info tmp;
-			ret = compat_table_info(private, &tmp);
-			xt_compat_flush_offsets(AF_INET);
-			private = &tmp;
-		}
-#endif
-		info.valid_hooks = t->valid_hooks;
-		memcpy(info.hook_entry, private->hook_entry,
-		       sizeof(info.hook_entry));
-		memcpy(info.underflow, private->underflow,
-		       sizeof(info.underflow));
-		info.num_entries = private->number;
-		info.size = private->size;
-		strcpy(info.name, name);
-
-		if (copy_to_user(user, &info, *len) != 0)
-			ret = -EFAULT;
-		else
-			ret = 0;
-
-		xt_table_unlock(t);
-		module_put(t->me);
-	} else
-		ret = t ? PTR_ERR(t) : -ENOENT;
-#ifdef CONFIG_COMPAT
-	if (compat)
-		xt_compat_unlock(AF_INET);
-#endif
+	table = try_then_request_module(
+	        xt2_table_lookup(net, name, NFPROTO_IPV4, XT2_TAKE_RCULOCK),
+	        "iptable_%s", name);
+	if (table == NULL)
+		return -ENOENT;
+	ret = ipt2_get_info(user, *len, table, compat);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1257,7 +1264,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 {
 	int ret;
 	struct ipt_get_entries get;
-	struct xt_table *t;
+	struct xt2_table *table;
 
 	if (*len < sizeof(get)) {
 		duprintf("get_entries: %u < %zu\n", *len, sizeof(get));
@@ -1271,23 +1278,13 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 		return -EINVAL;
 	}
 
-	t = xt_find_table_lock(net, AF_INET, get.name);
-	if (t && !IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
-		duprintf("t->private->number = %u\n", private->number);
-		if (get.size == private->size)
-			ret = copy_entries_to_user(private->size,
-						   t, uptr->entrytable);
-		else {
-			duprintf("get_entries: I've got %u not %u!\n",
-				 private->size, get.size);
-			ret = -EAGAIN;
-		}
-		module_put(t->me);
-		xt_table_unlock(t);
-	} else
-		ret = t ? PTR_ERR(t) : -ENOENT;
-
+	table = xt2_table_lookup(net, get.name, NFPROTO_IPV4,
+	        XT2_TAKE_RCULOCK);
+	if (table == NULL)
+		return -ENOENT;
+	ret = ipt2_table_to_xt1(uptr->entrytable, get.size,
+	      table, &ipt_xlat_info);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1416,18 +1413,13 @@ static int
 do_add_counters(struct net *net, const void __user *user,
                 unsigned int len, int compat)
 {
-	unsigned int i, curcpu;
 	struct xt_counters_info tmp;
-	struct xt_counters *paddc;
 	unsigned int num_counters;
 	const char *name;
 	int size;
 	void *ptmp;
-	struct xt_table *t;
-	const struct xt_table_info *private;
 	int ret = 0;
-	void *loc_cpu_entry;
-	struct ipt_entry *iter;
+	struct xt2_table *table;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
 
@@ -1458,45 +1450,11 @@ do_add_counters(struct net *net, const void __user *user,
 	if (len != size + num_counters * sizeof(struct xt_counters))
 		return -EINVAL;
 
-	paddc = vmalloc_node(len - size, numa_node_id());
-	if (!paddc)
-		return -ENOMEM;
-
-	if (copy_from_user(paddc, user + size, len - size) != 0) {
-		ret = -EFAULT;
-		goto free;
-	}
-
-	t = xt_find_table_lock(net, AF_INET, name);
-	if (!t || IS_ERR(t)) {
-		ret = t ? PTR_ERR(t) : -ENOENT;
-		goto free;
-	}
-
-	local_bh_disable();
-	private = t->private;
-	if (private->number != num_counters) {
-		ret = -EINVAL;
-		goto unlock_up_free;
-	}
-
-	i = 0;
-	/* Choose the copy that is on our node */
-	curcpu = smp_processor_id();
-	loc_cpu_entry = private->entries[curcpu];
-	xt_info_wrlock(curcpu);
-	xt_entry_foreach(iter, loc_cpu_entry, private->size) {
-		ADD_COUNTER(iter->counters, paddc[i].bcnt, paddc[i].pcnt);
-		++i;
-	}
-	xt_info_wrunlock(curcpu);
- unlock_up_free:
-	local_bh_enable();
-	xt_table_unlock(t);
-	module_put(t->me);
- free:
-	vfree(paddc);
-
+	table = xt2_table_lookup(net, name, NFPROTO_IPV4, XT2_TAKE_RCULOCK);
+	if (table == NULL)
+		return -ENOENT;
+	ret = xts_get_counters(table, user + size, num_counters);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1957,7 +1915,7 @@ compat_do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user,
 
 	switch (cmd) {
 	case IPT_SO_SET_REPLACE:
-		ret = compat_do_replace(sock_net(sk), user, len);
+		ret = ipt2_compat_do_replace(sock_net(sk), user, len);
 		break;
 
 	case IPT_SO_SET_ADD_COUNTERS:
@@ -2019,7 +1977,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 {
 	int ret;
 	struct compat_ipt_get_entries get;
-	struct xt_table *t;
+	struct xt2_table *table;
 
 	if (*len < sizeof(get)) {
 		duprintf("compat_get_entries: %u < %zu\n", *len, sizeof(get));
@@ -2035,28 +1993,13 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 		return -EINVAL;
 	}
 
-	xt_compat_lock(AF_INET);
-	t = xt_find_table_lock(net, AF_INET, get.name);
-	if (t && !IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
-		struct xt_table_info info;
-		duprintf("t->private->number = %u\n", private->number);
-		ret = compat_table_info(private, &info);
-		if (!ret && get.size == info.size) {
-			ret = compat_copy_entries_to_user(private->size,
-							  t, uptr->entrytable);
-		} else if (!ret) {
-			duprintf("compat_get_entries: I've got %u not %u!\n",
-				 private->size, get.size);
-			ret = -EAGAIN;
-		}
-		xt_compat_flush_offsets(AF_INET);
-		module_put(t->me);
-		xt_table_unlock(t);
-	} else
-		ret = t ? PTR_ERR(t) : -ENOENT;
-
-	xt_compat_unlock(AF_INET);
+	table = xt2_table_lookup(net, get.name, NFPROTO_IPV4,
+	        XT2_TAKE_RCULOCK);
+	if (table == NULL)
+		return -ENOENT;
+	ret = ipt2_compat_table_to_xt1(uptr->entrytable, get.size,
+	      table, &ipt_compat_xlat_info);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -2094,7 +2037,7 @@ do_ipt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 
 	switch (cmd) {
 	case IPT_SO_SET_REPLACE:
-		ret = do_replace(sock_net(sk), user, len);
+		ret = ipt2_do_replace(sock_net(sk), user, len);
 		break;
 
 	case IPT_SO_SET_ADD_COUNTERS:
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 962d6f5..d79474d 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/rcupdate.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <net/ip.h>
 
@@ -38,7 +39,9 @@ iptable_filter_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
+	const struct xt2_table_link *link;
 	const struct net *net;
+	unsigned int verdict;
 
 	if (hook == NF_INET_LOCAL_OUT)
 		/* root is playing with raw sockets. */
@@ -47,7 +50,11 @@ iptable_filter_hook(unsigned int hook,
 			return NF_ACCEPT;
 
 	net = dev_net((in != NULL) ? in : out);
-	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_filter);
+	rcu_read_lock();
+	link    = rcu_dereference(net->xt2.ipv4_filter);
+	verdict = xt2_do_table(skb, hook, in, out, link->table);
+	rcu_read_unlock();
+	return verdict;
 }
 
 /* Default to forward because I got too much mail already. */
@@ -57,6 +64,7 @@ module_param(forward, bool, 0000);
 static int __net_init iptable_filter_net_init(struct net *net)
 {
 	struct ipt_replace *repl = xt_repldata_create(&packet_filter);
+	struct xt2_table *table;
 
 	if (repl == NULL)
 		return -ENOMEM;
@@ -64,17 +72,18 @@ static int __net_init iptable_filter_net_init(struct net *net)
 	((struct ipt_standard *)repl->entries)[1].target.verdict =
 		-forward - 1;
 
-	net->ipv4.iptable_filter =
-		ipt_register_table(net, &packet_filter, repl);
+	table = ipt2_register_table(net, &packet_filter, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv4.iptable_filter))
-		return PTR_ERR(net->ipv4.iptable_filter);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	net->xt2.ipv4_filter = xt2_tlink_lookup(net, table->name,
+		table->nfproto, XT2_NO_RCULOCK);
 	return 0;
 }
 
 static void __net_exit iptable_filter_net_exit(struct net *net)
 {
-	ipt_unregister_table(net->ipv4.iptable_filter);
+	xt2_table_destroy(net, net->xt2.ipv4_filter->table);
 }
 
 static struct pernet_operations iptable_filter_net_ops = {
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 8434f57..5a931c9 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netdevice.h>
+#include <linux/rcupdate.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <net/route.h>
@@ -40,6 +41,7 @@ static unsigned int
 iptable_mangle_out_hook(struct sk_buff *skb, const struct net_device *out,
                         const struct net *net)
 {
+	const struct xt2_table_link *link;
 	unsigned int ret;
 	const struct iphdr *iph;
 	u_int8_t tos;
@@ -58,8 +60,11 @@ iptable_mangle_out_hook(struct sk_buff *skb, const struct net_device *out,
 	daddr = iph->daddr;
 	tos = iph->tos;
 
-	ret = ipt_do_table(skb, NF_INET_LOCAL_OUT, NULL, out,
-			   net->ipv4.iptable_mangle);
+	rcu_read_lock();
+	link = rcu_dereference(net->xt2.ipv4_mangle);
+	ret  = xt2_do_table(skb, NF_INET_LOCAL_OUT, NULL, out, link->table);
+	rcu_read_unlock();
+
 	/* Reroute for ANY change. */
 	if (ret != NF_DROP && ret != NF_STOLEN && ret != NF_QUEUE) {
 		iph = ip_hdr(skb);
@@ -82,30 +87,38 @@ iptable_mangle_hook(unsigned int hook, struct sk_buff *skb,
                     int (*okfn)(struct sk_buff *))
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
+	const struct xt2_table_link *link;
+	unsigned int verdict;
 
 	if (hook == NF_INET_LOCAL_OUT)
 		return iptable_mangle_out_hook(skb, out, net);
 
-	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_mangle);
+	rcu_read_lock();
+	link    = rcu_dereference(net->xt2.ipv4_mangle);
+	verdict = xt2_do_table(skb, hook, in, out, link->table);
+	rcu_read_unlock();
+	return verdict;
 }
 
 static int __net_init iptable_mangle_net_init(struct net *net)
 {
 	struct ipt_replace *repl = xt_repldata_create(&packet_mangler);
+	struct xt2_table *table;
 
 	if (repl == NULL)
 		return -ENOMEM;
-	net->ipv4.iptable_mangle =
-		ipt_register_table(net, &packet_mangler, repl);
+	table = ipt2_register_table(net, &packet_mangler, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv4.iptable_mangle))
-		return PTR_ERR(net->ipv4.iptable_mangle);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	net->xt2.ipv4_mangle = xt2_tlink_lookup(net, table->name,
+		table->nfproto, XT2_NO_RCULOCK);
 	return 0;
 }
 
 static void __net_exit iptable_mangle_net_exit(struct net *net)
 {
-	ipt_unregister_table(net->ipv4.iptable_mangle);
+	xt2_table_destroy(net, net->xt2.ipv4_mangle->table);
 }
 
 static struct pernet_operations iptable_mangle_net_ops = {
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 243329c..757da0f 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  */
 #include <linux/module.h>
+#include <linux/rcupdate.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <net/ip.h>
 
@@ -25,7 +26,9 @@ iptable_raw_hook(unsigned int hook,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
+	const struct xt2_table_link *link;
 	const struct net *net;
+	unsigned int verdict;
 
 	if (hook == NF_INET_LOCAL_OUT)
 		/* root is playing with raw sockets. */
@@ -34,26 +37,32 @@ iptable_raw_hook(unsigned int hook,
 			return NF_ACCEPT;
 
 	net = dev_net((in != NULL) ? in : out);
-	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_raw);
+	rcu_read_lock();
+	link    = rcu_dereference(net->xt2.ipv4_raw);
+	verdict = xt2_do_table(skb, hook, in, out, link->table);
+	rcu_read_unlock();
+	return verdict;
 }
 
 static int __net_init iptable_raw_net_init(struct net *net)
 {
 	struct ipt_replace *repl = xt_repldata_create(&packet_raw);
+	struct xt2_table *table;
 
 	if (repl == NULL)
 		return -ENOMEM;
-	net->ipv4.iptable_raw =
-		ipt_register_table(net, &packet_raw, repl);
+	table = ipt2_register_table(net, &packet_raw, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv4.iptable_raw))
-		return PTR_ERR(net->ipv4.iptable_raw);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	net->xt2.ipv4_raw = xt2_tlink_lookup(net, table->name,
+		table->nfproto, XT2_NO_RCULOCK);
 	return 0;
 }
 
 static void __net_exit iptable_raw_net_exit(struct net *net)
 {
-	ipt_unregister_table(net->ipv4.iptable_raw);
+	xt2_table_destroy(net, net->xt2.ipv4_raw->table);
 }
 
 static struct pernet_operations iptable_raw_net_ops = {
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index d2aed39..a999c8a 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -16,6 +16,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/module.h>
+#include <linux/rcupdate.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <net/ip.h>
 
@@ -42,7 +43,9 @@ iptable_security_hook(unsigned int hook,
 		  const struct net_device *out,
 		  int (*okfn)(struct sk_buff *))
 {
+	const struct xt2_table_link *link;
 	const struct net *net;
+	unsigned int verdict;
 
 	if (hook == NF_INET_LOCAL_OUT)
 		/* Somebody is playing with raw sockets. */
@@ -51,27 +54,32 @@ iptable_security_hook(unsigned int hook,
 			return NF_ACCEPT;
 
 	net = dev_net((in != NULL) ? in : out);
-	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_security);
+	rcu_read_lock();
+	link    = rcu_dereference(net->xt2.ipv4_security);
+	verdict = xt2_do_table(skb, hook, in, out, link->table);
+	rcu_read_unlock();
+	return verdict;
 }
 
 static int __net_init iptable_security_net_init(struct net *net)
 {
 	struct ipt_replace *repl = xt_repldata_create(&security_table);
+	struct xt2_table *table;
 
 	if (repl == NULL)
 		return -ENOMEM;
-	net->ipv4.iptable_security =
-		ipt_register_table(net, &security_table, repl);
+	table = ipt2_register_table(net, &security_table, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv4.iptable_security))
-		return PTR_ERR(net->ipv4.iptable_security);
-
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	net->xt2.ipv4_security = xt2_tlink_lookup(net, table->name,
+		table->nfproto, XT2_NO_RCULOCK);
 	return 0;
 }
 
 static void __net_exit iptable_security_net_exit(struct net *net)
 {
-	ipt_unregister_table(net->ipv4.iptable_security);
+	xt2_table_destroy(net, net->xt2.ipv4_security->table);
 }
 
 static struct pernet_operations iptable_security_net_ops = {
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 8b44f1a..db1f1c0 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -13,6 +13,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/module.h>
 #include <linux/kmod.h>
+#include <linux/rcupdate.h>
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
 #include <net/checksum.h>
@@ -121,10 +122,14 @@ int nf_nat_rule_find(struct sk_buff *skb,
 		     const struct net_device *out,
 		     struct nf_conn *ct)
 {
+	const struct xt2_table_link *link;
 	struct net *net = nf_ct_net(ct);
 	int ret;
 
-	ret = ipt_do_table(skb, hooknum, in, out, net->ipv4.nat_table);
+	rcu_read_lock();
+	link = rcu_dereference(net->xt2.ipv4_nat);
+	ret  = xt2_do_table(skb, hooknum, in, out, link->table);
+	rcu_read_unlock();
 
 	if (ret == NF_ACCEPT) {
 		if (!nf_nat_initialized(ct, HOOK2MANIP(hooknum)))
@@ -157,19 +162,22 @@ static struct xt_target ipt_dnat_reg __read_mostly = {
 static int __net_init nf_nat_rule_net_init(struct net *net)
 {
 	struct ipt_replace *repl = xt_repldata_create(&nat_table);
+	struct xt2_table *table;
 
 	if (repl == NULL)
 		return -ENOMEM;
-	net->ipv4.nat_table = ipt_register_table(net, &nat_table, repl);
+	table = ipt2_register_table(net, &nat_table, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv4.nat_table))
-		return PTR_ERR(net->ipv4.nat_table);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	net->xt2.ipv4_nat = xt2_tlink_lookup(net, table->name,
+		table->nfproto, XT2_NO_RCULOCK);
 	return 0;
 }
 
 static void __net_exit nf_nat_rule_net_exit(struct net *net)
 {
-	ipt_unregister_table(net->ipv4.nat_table);
+	xt2_table_destroy(net, net->xt2.ipv4_nat->table);
 }
 
 static struct pernet_operations nf_nat_rule_net_ops = {
-- 
1.6.3.3

