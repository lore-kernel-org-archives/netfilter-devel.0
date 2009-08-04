From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 097/103] netfilter: arptables: switch to xt2 tables
Date: Tue,  4 Aug 2009 09:26:21 +0200
Message-ID: <1249370787-17583-98-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56963 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627AbZHDH2S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:18 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/net/netns/x_tables.h         |    1 +
 net/ipv4/netfilter/arp_tables.c      |  201 ++++++++++++----------------------
 net/ipv4/netfilter/arptable_filter.c |   22 +++-
 3 files changed, 87 insertions(+), 137 deletions(-)

diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
index 68b0b4f..f472744 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -21,6 +21,7 @@ struct netns_xt2 {
 		*ipv4_nat;
 	struct xt2_table_link
 		*ipv6_filter, *ipv6_mangle, *ipv6_raw, *ipv6_security;
+	struct xt2_table_link *arp_filter;
 };
 
 #endif
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 850b248..8d59b2a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -955,11 +955,51 @@ static int compat_table_info(const struct xt_table_info *info,
 }
 #endif
 
+static const struct xt1_xlat_info arpt_compat_xlat_info = {
+#ifdef CONFIG_COMPAT
+	.marker_size     = XT_ALIGN(sizeof(struct arpt_error_target)),
+	.entry_hdr_size  = sizeof(struct compat_arpt_entry),
+	.pmatch_size     = sizeof(struct arpt_arp),
+	.first_match     = "arp",
+	.ematch_size     = sizeof(struct xt_entry_match),
+	.etarget_size    = sizeof(struct xt_entry_target),
+	.standard_tgsize = COMPAT_XT_ALIGN(sizeof(struct xt_entry_target) +
+	                   sizeof(compat_uint_t)),
+	.compat          = true,
+#endif
+};
+
+static const struct xt1_xlat_info arpt_xlat_info = {
+	.marker_size     = XT_ALIGN(sizeof(struct arpt_error_target)),
+	.entry_hdr_size  = sizeof(struct arpt_entry),
+	.pmatch_size     = sizeof(struct arpt_arp),
+	.first_match     = "arp",
+	.ematch_size     = sizeof(struct xt_entry_match),
+	.etarget_size    = sizeof(struct xt_entry_target),
+	.standard_tgsize = XT_ALIGN(sizeof(struct xt_entry_target) +
+	                   sizeof(int)),
+};
+
+static int arpt2_get_info(void __user *uptr, int len,
+                          struct xt2_table *table, bool compat)
+{
+	struct arpt_getinfo info = {
+		.valid_hooks = table->valid_hooks,
+	};
+
+	strncpy(info.name, table->name,
+	        min(sizeof(info.name), sizeof(table->name)));
+	info.size = xts_blob_prep_table(table,
+	            compat ? &arpt_compat_xlat_info : &arpt_xlat_info,
+	            info.hook_entry, info.underflow, &info.num_entries);
+	return (copy_to_user(uptr, &info, sizeof(info)) != 0) ? -EFAULT : 0;
+}
+
 static int get_info(struct net *net, void __user *user,
                     const int *len, int compat)
 {
 	char name[ARPT_TABLE_MAXNAMELEN];
-	struct xt_table *t;
+	struct xt2_table *table;
 	int ret;
 
 	if (*len != sizeof(struct arpt_getinfo)) {
@@ -972,45 +1012,13 @@ static int get_info(struct net *net, void __user *user,
 		return -EFAULT;
 
 	name[ARPT_TABLE_MAXNAMELEN-1] = '\0';
-#ifdef CONFIG_COMPAT
-	if (compat)
-		xt_compat_lock(NFPROTO_ARP);
-#endif
-	t = try_then_request_module(xt_find_table_lock(net, NFPROTO_ARP, name),
-				    "arptable_%s", name);
-	if (t && !IS_ERR(t)) {
-		struct arpt_getinfo info;
-		const struct xt_table_info *private = t->private;
-
-#ifdef CONFIG_COMPAT
-		if (compat) {
-			struct xt_table_info tmp;
-			ret = compat_table_info(private, &tmp);
-			xt_compat_flush_offsets(NFPROTO_ARP);
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
-		xt_table_unlock(t);
-		module_put(t->me);
-	} else
-		ret = t ? PTR_ERR(t) : -ENOENT;
-#ifdef CONFIG_COMPAT
-	if (compat)
-		xt_compat_unlock(NFPROTO_ARP);
-#endif
+	table = try_then_request_module(
+	        xt2_table_lookup(net, name, NFPROTO_ARP, XT2_TAKE_RCULOCK),
+	        "arptable_%s", name);
+	if (table == NULL)
+		return -ENOENT;
+	ret = arpt2_get_info(user, *len, table, compat);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1019,7 +1027,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 {
 	int ret;
 	struct arpt_get_entries get;
-	struct xt_table *t;
+	struct xt2_table *table;
 
 	if (*len < sizeof(get)) {
 		duprintf("get_entries: %u < %Zu\n", *len, sizeof(get));
@@ -1033,25 +1041,12 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 		return -EINVAL;
 	}
 
-	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
-	if (t && !IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
-
-		duprintf("t->private->number = %u\n",
-			 private->number);
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
+	table = xt2_table_lookup(net, get.name, NFPROTO_ARP, XT2_TAKE_RCULOCK);
+	if (table == NULL)
+		return -ENOENT;
+	ret = arpt2_table_to_xt1(uptr->entrytable, get.size,
+	      table, &arpt_xlat_info);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1181,18 +1176,13 @@ static int do_replace(struct net *net, const void __user *user,
 static int do_add_counters(struct net *net, const void __user *user,
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
-	struct arpt_entry *iter;
+	struct xt2_table *table;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
 
@@ -1223,45 +1213,11 @@ static int do_add_counters(struct net *net, const void __user *user,
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
-	t = xt_find_table_lock(net, NFPROTO_ARP, name);
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
+	table = xt2_table_lookup(net, name, NFPROTO_ARP, XT2_TAKE_RCULOCK);
+	if (table == NULL)
+		return -ENOENT;
+	ret = xts_get_counters(table, user + size, num_counters);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1600,7 +1556,7 @@ static int compat_do_arpt_set_ctl(struct sock *sk, int cmd, void __user *user,
 
 	switch (cmd) {
 	case ARPT_SO_SET_REPLACE:
-		ret = compat_do_replace(sock_net(sk), user, len);
+		ret = arpt2_compat_do_replace(sock_net(sk), user, len);
 		break;
 
 	case ARPT_SO_SET_ADD_COUNTERS:
@@ -1692,7 +1648,7 @@ static int compat_get_entries(struct net *net,
 {
 	int ret;
 	struct compat_arpt_get_entries get;
-	struct xt_table *t;
+	struct xt2_table *table;
 
 	if (*len < sizeof(get)) {
 		duprintf("compat_get_entries: %u < %zu\n", *len, sizeof(get));
@@ -1706,29 +1662,12 @@ static int compat_get_entries(struct net *net,
 		return -EINVAL;
 	}
 
-	xt_compat_lock(NFPROTO_ARP);
-	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
-	if (t && !IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
-		struct xt_table_info info;
-
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
-		xt_compat_flush_offsets(NFPROTO_ARP);
-		module_put(t->me);
-		xt_table_unlock(t);
-	} else
-		ret = t ? PTR_ERR(t) : -ENOENT;
-
-	xt_compat_unlock(NFPROTO_ARP);
+	table = xt2_table_lookup(net, get.name, NFPROTO_ARP, XT2_TAKE_RCULOCK);
+	if (table == NULL)
+		return -ENOENT;
+	ret = arpt2_compat_table_to_xt1(uptr->entrytable, get.size,
+	      table, &arpt_compat_xlat_info);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -1765,7 +1704,7 @@ static int do_arpt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned
 
 	switch (cmd) {
 	case ARPT_SO_SET_REPLACE:
-		ret = do_replace(sock_net(sk), user, len);
+		ret = arpt2_do_replace(sock_net(sk), user, len);
 		break;
 
 	case ARPT_SO_SET_ADD_COUNTERS:
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 1299f08..341c0c8 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/rcupdate.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_arp/arp_tables.h>
 
@@ -32,26 +33,35 @@ static unsigned int arptable_filter_hook(unsigned int hook,
 				 int (*okfn)(struct sk_buff *))
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
-	return arpt_do_table(skb, hook, in, out, net->ipv4.arptable_filter);
+	const struct xt2_table_link *link;
+	unsigned int verdict;
+
+	rcu_read_lock();
+	link    = rcu_dereference(net->xt2.arp_filter);
+	verdict = xt2_do_table(skb, hook, in, out, link->table);
+	rcu_read_unlock();
+	return verdict;
 }
 
 static int __net_init arptable_filter_net_init(struct net *net)
 {
 	struct arpt_replace *repl = xt_repldata_create(&packet_filter);
+	struct xt2_table *table;
 
 	if (repl == NULL)
 		return -ENOMEM;
-	net->ipv4.arptable_filter =
-		arpt_register_table(net, &packet_filter, repl);
+	table = arpt2_register_table(net, &packet_filter, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv4.arptable_filter))
-		return PTR_ERR(net->ipv4.arptable_filter);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	net->xt2.arp_filter = xt2_tlink_lookup(net, table->name,
+		table->nfproto, XT2_NO_RCULOCK);
 	return 0;
 }
 
 static void __net_exit arptable_filter_net_exit(struct net *net)
 {
-	arpt_unregister_table(net->ipv4.arptable_filter);
+	xt2_table_destroy(net, net->xt2.arp_filter->table);
 }
 
 static struct pernet_operations arptable_filter_net_ops = {
-- 
1.6.3.3

