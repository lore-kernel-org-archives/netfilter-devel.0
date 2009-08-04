From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 033/103] netfilter: xtables: replace XT_ENTRY_ITERATE macro
Date: Tue,  4 Aug 2009 09:25:17 +0200
Message-ID: <1249370787-17583-34-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50630 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559AbZHDH1K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:10 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The macro is replaced by a list.h-like foreach loop. This makes
the code much more inspectable.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h        |    9 ++
 include/linux/netfilter_arp/arp_tables.h  |   10 +--
 include/linux/netfilter_ipv4/ip_tables.h  |   11 +--
 include/linux/netfilter_ipv6/ip6_tables.h |   10 +--
 net/ipv4/netfilter/arp_tables.c           |  151 ++++++++++++++++++----------
 net/ipv4/netfilter/ip_tables.c            |  160 +++++++++++++++++++----------
 net/ipv6/netfilter/ip6_tables.c           |  160 +++++++++++++++++++----------
 7 files changed, 321 insertions(+), 190 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 5e434a1..6e051c0 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -147,6 +147,7 @@ struct xt_counters_info
 	__ret;							\
 })
 
+#ifndef __KERNEL__
 /* fn returns 0 to continue iteration */
 #define XT_ENTRY_ITERATE_CONTINUE(type, entries, size, n, fn, args...) \
 ({								\
@@ -171,6 +172,14 @@ struct xt_counters_info
 #define XT_ENTRY_ITERATE(type, entries, size, fn, args...) \
 	XT_ENTRY_ITERATE_CONTINUE(type, entries, size, 0, fn, args)
 
+#endif /* !__KERNEL__ */
+
+/* pos is normally a struct ipt_entry/ip6t_entry/etc. */
+#define xt_entry_foreach(pos, ehead, esize) \
+	for ((pos) = (typeof(pos))(ehead); \
+	     (pos) < (typeof(pos))((char *)(ehead) + (esize)); \
+	     (pos) = (typeof(pos))((char *)(pos) + (pos)->next_offset))
+
 #ifdef __KERNEL__
 
 #include <linux/netdevice.h>
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 6fe3e6a..16313df 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -214,9 +214,11 @@ static __inline__ struct arpt_entry_target *arpt_get_target(struct arpt_entry *e
 	return (void *)e + e->target_offset;
 }
 
+#ifndef __KERNEL__
 /* fn returns 0 to continue iteration */
 #define ARPT_ENTRY_ITERATE(entries, size, fn, args...) \
 	XT_ENTRY_ITERATE(struct arpt_entry, entries, size, fn, ## args)
+#endif
 
 /*
  *	Main firewall chains definitions and global var's definitions.
@@ -297,14 +299,6 @@ compat_arpt_get_target(struct compat_arpt_entry *e)
 
 #define COMPAT_ARPT_ALIGN(s)	COMPAT_XT_ALIGN(s)
 
-/* fn returns 0 to continue iteration */
-#define COMPAT_ARPT_ENTRY_ITERATE(entries, size, fn, args...) \
-	XT_ENTRY_ITERATE(struct compat_arpt_entry, entries, size, fn, ## args)
-
-#define COMPAT_ARPT_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
-	XT_ENTRY_ITERATE_CONTINUE(struct compat_arpt_entry, entries, size, n, \
-				  fn, ## args)
-
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _ARPTABLES_H */
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 61fafc8..362b1f1 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -232,9 +232,11 @@ ipt_get_target(struct ipt_entry *e)
 #define IPT_MATCH_ITERATE(e, fn, args...) \
 	XT_MATCH_ITERATE(struct ipt_entry, e, fn, ## args)
 
+#ifndef __KERNEL__
 /* fn returns 0 to continue iteration */
 #define IPT_ENTRY_ITERATE(entries, size, fn, args...) \
 	XT_ENTRY_ITERATE(struct ipt_entry, entries, size, fn, ## args)
+#endif
 
 /*
  *	Main firewall chains definitions and global var's definitions.
@@ -325,15 +327,6 @@ compat_ipt_get_target(struct compat_ipt_entry *e)
 #define COMPAT_IPT_MATCH_ITERATE(e, fn, args...) \
 	XT_MATCH_ITERATE(struct compat_ipt_entry, e, fn, ## args)
 
-/* fn returns 0 to continue iteration */
-#define COMPAT_IPT_ENTRY_ITERATE(entries, size, fn, args...) \
-	XT_ENTRY_ITERATE(struct compat_ipt_entry, entries, size, fn, ## args)
-
-/* fn returns 0 to continue iteration */
-#define COMPAT_IPT_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
-	XT_ENTRY_ITERATE_CONTINUE(struct compat_ipt_entry, entries, size, n, \
-				  fn, ## args)
-
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IPTABLES_H */
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index a64e145..43db986 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -292,9 +292,11 @@ ip6t_get_target(struct ip6t_entry *e)
 #define IP6T_MATCH_ITERATE(e, fn, args...) \
 	XT_MATCH_ITERATE(struct ip6t_entry, e, fn, ## args)
 
+#ifndef __KERNEL__
 /* fn returns 0 to continue iteration */
 #define IP6T_ENTRY_ITERATE(entries, size, fn, args...) \
 	XT_ENTRY_ITERATE(struct ip6t_entry, entries, size, fn, ## args)
+#endif
 
 /*
  *	Main firewall chains definitions and global var's definitions.
@@ -353,14 +355,6 @@ compat_ip6t_get_target(struct compat_ip6t_entry *e)
 #define COMPAT_IP6T_MATCH_ITERATE(e, fn, args...) \
 	XT_MATCH_ITERATE(struct compat_ip6t_entry, e, fn, ## args)
 
-/* fn returns 0 to continue iteration */
-#define COMPAT_IP6T_ENTRY_ITERATE(entries, size, fn, args...) \
-	XT_ENTRY_ITERATE(struct compat_ip6t_entry, entries, size, fn, ## args)
-
-#define COMPAT_IP6T_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
-	XT_ENTRY_ITERATE_CONTINUE(struct compat_ip6t_entry, entries, size, n, \
-				  fn, ## args)
-
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IP6_TABLES_H */
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 214dfd0..95695e7 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -634,8 +634,9 @@ static int translate_table(const char *name,
 			   const unsigned int *hook_entries,
 			   const unsigned int *underflows)
 {
+	struct arpt_entry *iter;
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	newinfo->size = size;
 	newinfo->number = number;
@@ -650,12 +651,13 @@ static int translate_table(const char *name,
 	i = 0;
 
 	/* Walk through entries, checking offsets. */
-	ret = ARPT_ENTRY_ITERATE(entry0, newinfo->size,
-				 check_entry_size_and_hooks,
-				 newinfo,
-				 entry0,
-				 entry0 + size,
-				 hook_entries, underflows, valid_hooks, &i);
+	xt_entry_foreach(iter, entry0, newinfo->size) {
+		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
+		      entry0 + size, hook_entries, underflows,
+		      valid_hooks, &i);
+		if (ret != 0)
+			break;
+	}
 	duprintf("translate_table: ARPT_ENTRY_ITERATE gives %d\n", ret);
 	if (ret != 0)
 		return ret;
@@ -690,12 +692,16 @@ static int translate_table(const char *name,
 
 	/* Finally, each sanity check must pass */
 	i = 0;
-	ret = ARPT_ENTRY_ITERATE(entry0, newinfo->size,
-				 find_check_entry, name, size, &i);
+	xt_entry_foreach(iter, entry0, newinfo->size) {
+		ret = find_check_entry(iter, name, size, &i);
+		if (ret != 0)
+			break;
+	}
 
 	if (ret != 0) {
-		ARPT_ENTRY_ITERATE(entry0, newinfo->size,
-				cleanup_entry, &i);
+		xt_entry_foreach(iter, entry0, newinfo->size)
+			if (cleanup_entry(iter, &i) != 0)
+				break;
 		return ret;
 	}
 
@@ -732,6 +738,7 @@ static inline int set_entry_to_counter(const struct arpt_entry *e,
 static void get_counters(const struct xt_table_info *t,
 			 struct xt_counters counters[])
 {
+	struct arpt_entry *iter;
 	unsigned int cpu;
 	unsigned int i;
 	unsigned int curcpu;
@@ -747,22 +754,18 @@ static void get_counters(const struct xt_table_info *t,
 	curcpu = smp_processor_id();
 
 	i = 0;
-	ARPT_ENTRY_ITERATE(t->entries[curcpu],
-			   t->size,
-			   set_entry_to_counter,
-			   counters,
-			   &i);
+	xt_entry_foreach(iter, t->entries[curcpu], t->size)
+		if (set_entry_to_counter(iter, counters, &i) != 0)
+			break;
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 		i = 0;
 		xt_info_wrlock(cpu);
-		ARPT_ENTRY_ITERATE(t->entries[cpu],
-				   t->size,
-				   add_entry_to_counter,
-				   counters,
-				   &i);
+		xt_entry_foreach(iter, t->entries[cpu], t->size)
+			if (add_entry_to_counter(iter, counters, &i) != 0)
+				break;
 		xt_info_wrunlock(cpu);
 	}
 	local_bh_enable();
@@ -892,7 +895,9 @@ static int compat_calc_entry(const struct arpt_entry *e,
 static int compat_table_info(const struct xt_table_info *info,
 			     struct xt_table_info *newinfo)
 {
+	struct arpt_entry *iter;
 	void *loc_cpu_entry;
+	int ret = 0;
 
 	if (!newinfo || !info)
 		return -EINVAL;
@@ -901,9 +906,12 @@ static int compat_table_info(const struct xt_table_info *info,
 	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
 	newinfo->initial_entries = 0;
 	loc_cpu_entry = info->entries[raw_smp_processor_id()];
-	return ARPT_ENTRY_ITERATE(loc_cpu_entry, info->size,
-				  compat_calc_entry, info, loc_cpu_entry,
-				  newinfo);
+	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
+		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
+		if (ret != 0)
+			break;
+	}
+	return ret;
 }
 #endif
 
@@ -1018,6 +1026,7 @@ static int __do_replace(struct net *net, const char *name,
 	struct xt_table_info *oldinfo;
 	struct xt_counters *counters;
 	void *loc_cpu_old_entry;
+	struct arpt_entry *iter;
 
 	ret = 0;
 	counters = vmalloc_node(num_counters * sizeof(struct xt_counters),
@@ -1061,8 +1070,9 @@ static int __do_replace(struct net *net, const char *name,
 
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
-	ARPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,
-			   NULL);
+	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
 
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
@@ -1088,6 +1098,7 @@ static int do_replace(struct net *net, const void __user *user,
 	struct arpt_replace tmp;
 	struct xt_table_info *newinfo;
 	void *loc_cpu_entry;
+	struct arpt_entry *iter;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
@@ -1123,7 +1134,9 @@ static int do_replace(struct net *net, const void __user *user,
 	return 0;
 
  free_newinfo_untrans:
-	ARPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1156,6 +1169,7 @@ static int do_add_counters(struct net *net, const void __user *user,
 	const struct xt_table_info *private;
 	int ret = 0;
 	void *loc_cpu_entry;
+	struct arpt_entry *iter;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
 
@@ -1213,11 +1227,9 @@ static int do_add_counters(struct net *net, const void __user *user,
 	curcpu = smp_processor_id();
 	loc_cpu_entry = private->entries[curcpu];
 	xt_info_wrlock(curcpu);
-	ARPT_ENTRY_ITERATE(loc_cpu_entry,
-			   private->size,
-			   add_counter_to_entry,
-			   paddc,
-			   &i);
+	xt_entry_foreach(iter, loc_cpu_entry, private->size)
+		if (add_counter_to_entry(iter, paddc, &i) != 0)
+			break;
 	xt_info_wrunlock(curcpu);
  unlock_up_free:
 	local_bh_enable();
@@ -1381,8 +1393,10 @@ static int translate_compat_table(const char *name,
 	unsigned int i, j;
 	struct xt_table_info *newinfo, *info;
 	void *pos, *entry0, *entry1;
+	struct compat_arpt_entry *iter0;
+	struct arpt_entry *iter1;
 	unsigned int size;
-	int ret;
+	int ret = 0;
 
 	info = *pinfo;
 	entry0 = *pentry0;
@@ -1399,11 +1413,13 @@ static int translate_compat_table(const char *name,
 	j = 0;
 	xt_compat_lock(NFPROTO_ARP);
 	/* Walk through entries, checking offsets. */
-	ret = COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size,
-					check_compat_entry_size_and_hooks,
-					info, &size, entry0,
-					entry0 + total_size,
-					hook_entries, underflows, &j, name);
+	xt_entry_foreach(iter0, entry0, total_size) {
+		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
+		      entry0, entry0 + total_size, hook_entries, underflows,
+		      &j, name);
+		if (ret != 0)
+			break;
+	}
 	if (ret != 0)
 		goto out_unlock;
 
@@ -1444,9 +1460,12 @@ static int translate_compat_table(const char *name,
 	entry1 = newinfo->entries[raw_smp_processor_id()];
 	pos = entry1;
 	size = total_size;
-	ret = COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size,
-					compat_copy_entry_from_user,
-					&pos, &size, name, newinfo, entry1);
+	xt_entry_foreach(iter0, entry0, total_size) {
+		ret = compat_copy_entry_from_user(iter0, &pos,
+		      &size, name, newinfo, entry1);
+		if (ret != 0)
+			break;
+	}
 	xt_compat_flush_offsets(NFPROTO_ARP);
 	xt_compat_unlock(NFPROTO_ARP);
 	if (ret)
@@ -1457,13 +1476,28 @@ static int translate_compat_table(const char *name,
 		goto free_newinfo;
 
 	i = 0;
-	ret = ARPT_ENTRY_ITERATE(entry1, newinfo->size, compat_check_entry,
-				 name, &i);
+	xt_entry_foreach(iter1, entry1, newinfo->size) {
+		ret = compat_check_entry(iter1, name, &i);
+		if (ret != 0)
+			break;
+	}
 	if (ret) {
+		/*
+		 * The first i matches need cleanup_entry (calls ->destroy)
+		 * because they had called ->check already. The other j-i
+		 * entries need only release.
+		 */
+		int skip = i;
 		j -= i;
-		COMPAT_ARPT_ENTRY_ITERATE_CONTINUE(entry0, newinfo->size, i,
-						   compat_release_entry, &j);
-		ARPT_ENTRY_ITERATE(entry1, newinfo->size, cleanup_entry, &i);
+		xt_entry_foreach(iter0, entry0, newinfo->size) {
+			if (skip-- > 0)
+				continue;
+			if (compat_release_entry(iter0, &j) != 0)
+				break;
+		}
+		xt_entry_foreach(iter1, entry1, newinfo->size)
+			if (cleanup_entry(iter1, &i) != 0)
+				break;
 		xt_free_table_info(newinfo);
 		return ret;
 	}
@@ -1481,7 +1515,9 @@ static int translate_compat_table(const char *name,
 free_newinfo:
 	xt_free_table_info(newinfo);
 out:
-	COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
+	xt_entry_foreach(iter0, entry0, total_size)
+		if (compat_release_entry(iter0, &j) != 0)
+			break;
 	return ret;
 out_unlock:
 	xt_compat_flush_offsets(NFPROTO_ARP);
@@ -1508,6 +1544,7 @@ static int compat_do_replace(struct net *net, void __user *user,
 	struct compat_arpt_replace tmp;
 	struct xt_table_info *newinfo;
 	void *loc_cpu_entry;
+	struct arpt_entry *iter;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
@@ -1545,7 +1582,9 @@ static int compat_do_replace(struct net *net, void __user *user,
 	return 0;
 
  free_newinfo_untrans:
-	ARPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1629,6 +1668,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 	int ret = 0;
 	void *loc_cpu_entry;
 	unsigned int i = 0;
+	struct arpt_entry *iter;
 
 	counters = alloc_counters(table);
 	if (IS_ERR(counters))
@@ -1638,9 +1678,12 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	pos = userptr;
 	size = total_size;
-	ret = ARPT_ENTRY_ITERATE(loc_cpu_entry, total_size,
-				 compat_copy_entry_to_user,
-				 &pos, &size, counters, &i);
+	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
+		ret = compat_copy_entry_to_user(iter, &pos,
+		      &size, counters, &i);
+		if (ret != 0)
+			break;
+	}
 	vfree(counters);
 	return ret;
 }
@@ -1836,13 +1879,15 @@ void arpt_unregister_table(struct xt_table *table)
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
 	struct module *table_owner = table->me;
+	struct arpt_entry *iter;
 
 	private = xt_unregister_table(table);
 
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
-	ARPT_ENTRY_ITERATE(loc_cpu_entry, private->size,
-			   cleanup_entry, NULL);
+	xt_entry_foreach(iter, loc_cpu_entry, private->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2c34413..b902779 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -281,6 +281,7 @@ static void trace_packet(const struct sk_buff *skb,
 	const void *table_base;
 	const struct ipt_entry *root;
 	const char *hookname, *chainname, *comment;
+	const struct ipt_entry *iter;
 	unsigned int rulenum = 0;
 
 	table_base = private->entries[smp_processor_id()];
@@ -289,10 +290,10 @@ static void trace_packet(const struct sk_buff *skb,
 	hookname = chainname = hooknames[hook];
 	comment = comments[NF_IP_TRACE_COMMENT_RULE];
 
-	IPT_ENTRY_ITERATE(root,
-			  private->size - private->hook_entry[hook],
-			  get_chainname_rulenum,
-			  e, hookname, &chainname, &comment, &rulenum);
+	xt_entry_foreach(iter, root, private->size - private->hook_entry[hook])
+		if (get_chainname_rulenum(iter, e, hookname,
+		    &chainname, &comment, &rulenum) != 0)
+			break;
 
 	nf_log_packet(AF_INET, hook, skb, in, out, &trace_loginfo,
 		      "TRACE: %s:%s:%s:%u ",
@@ -814,8 +815,9 @@ translate_table(const char *name,
 		const unsigned int *hook_entries,
 		const unsigned int *underflows)
 {
+	struct ipt_entry *iter;
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	newinfo->size = size;
 	newinfo->number = number;
@@ -829,12 +831,13 @@ translate_table(const char *name,
 	duprintf("translate_table: size %u\n", newinfo->size);
 	i = 0;
 	/* Walk through entries, checking offsets. */
-	ret = IPT_ENTRY_ITERATE(entry0, newinfo->size,
-				check_entry_size_and_hooks,
-				newinfo,
-				entry0,
-				entry0 + size,
-				hook_entries, underflows, valid_hooks, &i);
+	xt_entry_foreach(iter, entry0, newinfo->size) {
+		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
+		      entry0 + size, hook_entries, underflows,
+		      valid_hooks, &i);
+		if (ret != 0)
+			break;
+	}
 	if (ret != 0)
 		return ret;
 
@@ -866,12 +869,16 @@ translate_table(const char *name,
 
 	/* Finally, each sanity check must pass */
 	i = 0;
-	ret = IPT_ENTRY_ITERATE(entry0, newinfo->size,
-				find_check_entry, name, size, &i);
+	xt_entry_foreach(iter, entry0, newinfo->size) {
+		ret = find_check_entry(iter, name, size, &i);
+		if (ret != 0)
+			break;
+	}
 
 	if (ret != 0) {
-		IPT_ENTRY_ITERATE(entry0, newinfo->size,
-				cleanup_entry, &i);
+		xt_entry_foreach(iter, entry0, newinfo->size)
+			if (cleanup_entry(iter, &i) != 0)
+				break;
 		return ret;
 	}
 
@@ -911,6 +918,7 @@ static void
 get_counters(const struct xt_table_info *t,
 	     struct xt_counters counters[])
 {
+	struct ipt_entry *iter;
 	unsigned int cpu;
 	unsigned int i;
 	unsigned int curcpu;
@@ -926,22 +934,18 @@ get_counters(const struct xt_table_info *t,
 	curcpu = smp_processor_id();
 
 	i = 0;
-	IPT_ENTRY_ITERATE(t->entries[curcpu],
-			  t->size,
-			  set_entry_to_counter,
-			  counters,
-			  &i);
+	xt_entry_foreach(iter, t->entries[curcpu], t->size)
+		if (set_entry_to_counter(iter, counters, &i) != 0)
+			break;
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 		i = 0;
 		xt_info_wrlock(cpu);
-		IPT_ENTRY_ITERATE(t->entries[cpu],
-				  t->size,
-				  add_entry_to_counter,
-				  counters,
-				  &i);
+		xt_entry_foreach(iter, t->entries[cpu], t->size)
+			if (add_entry_to_counter(iter, counters, &i) != 0)
+				break;
 		xt_info_wrunlock(cpu);
 	}
 	local_bh_enable();
@@ -1099,7 +1103,9 @@ static int compat_calc_entry(const struct ipt_entry *e,
 static int compat_table_info(const struct xt_table_info *info,
 			     struct xt_table_info *newinfo)
 {
+	struct ipt_entry *iter;
 	void *loc_cpu_entry;
+	int ret = 0;
 
 	if (!newinfo || !info)
 		return -EINVAL;
@@ -1108,9 +1114,12 @@ static int compat_table_info(const struct xt_table_info *info,
 	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
 	newinfo->initial_entries = 0;
 	loc_cpu_entry = info->entries[raw_smp_processor_id()];
-	return IPT_ENTRY_ITERATE(loc_cpu_entry, info->size,
-				 compat_calc_entry, info, loc_cpu_entry,
-				 newinfo);
+	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
+		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
+		if (ret != 0)
+			break;
+	}
+	return ret;
 }
 #endif
 
@@ -1224,6 +1233,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct xt_table_info *oldinfo;
 	struct xt_counters *counters;
 	void *loc_cpu_old_entry;
+	struct ipt_entry *iter;
 
 	ret = 0;
 	counters = vmalloc(num_counters * sizeof(struct xt_counters));
@@ -1266,8 +1276,10 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
-	IPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,
-			  NULL);
+	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
+
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
 			 sizeof(struct xt_counters) * num_counters) != 0)
@@ -1292,6 +1304,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 	struct ipt_replace tmp;
 	struct xt_table_info *newinfo;
 	void *loc_cpu_entry;
+	struct ipt_entry *iter;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
@@ -1327,7 +1340,9 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 	return 0;
 
  free_newinfo_untrans:
-	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1361,6 +1376,7 @@ do_add_counters(struct net *net, const void __user *user,
 	const struct xt_table_info *private;
 	int ret = 0;
 	void *loc_cpu_entry;
+	struct ipt_entry *iter;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
 
@@ -1418,11 +1434,9 @@ do_add_counters(struct net *net, const void __user *user,
 	curcpu = smp_processor_id();
 	loc_cpu_entry = private->entries[curcpu];
 	xt_info_wrlock(curcpu);
-	IPT_ENTRY_ITERATE(loc_cpu_entry,
-			  private->size,
-			  add_counter_to_entry,
-			  paddc,
-			  &i);
+	xt_entry_foreach(iter, loc_cpu_entry, private->size)
+		if (add_counter_to_entry(iter, paddc, &i) != 0)
+			break;
 	xt_info_wrunlock(curcpu);
  unlock_up_free:
 	local_bh_enable();
@@ -1706,8 +1720,10 @@ translate_compat_table(const char *name,
 	unsigned int i, j;
 	struct xt_table_info *newinfo, *info;
 	void *pos, *entry0, *entry1;
+	struct compat_ipt_entry *iter0;
+	struct ipt_entry *iter1;
 	unsigned int size;
-	int ret;
+	int ret = 0;
 
 	info = *pinfo;
 	entry0 = *pentry0;
@@ -1724,11 +1740,13 @@ translate_compat_table(const char *name,
 	j = 0;
 	xt_compat_lock(AF_INET);
 	/* Walk through entries, checking offsets. */
-	ret = COMPAT_IPT_ENTRY_ITERATE(entry0, total_size,
-				       check_compat_entry_size_and_hooks,
-				       info, &size, entry0,
-				       entry0 + total_size,
-				       hook_entries, underflows, &j, name);
+	xt_entry_foreach(iter0, entry0, total_size) {
+		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
+		      entry0, entry0 + total_size, hook_entries, underflows,
+		      &j, name);
+		if (ret != 0)
+			break;
+	}
 	if (ret != 0)
 		goto out_unlock;
 
@@ -1769,9 +1787,12 @@ translate_compat_table(const char *name,
 	entry1 = newinfo->entries[raw_smp_processor_id()];
 	pos = entry1;
 	size = total_size;
-	ret = COMPAT_IPT_ENTRY_ITERATE(entry0, total_size,
-				       compat_copy_entry_from_user,
-				       &pos, &size, name, newinfo, entry1);
+	xt_entry_foreach(iter0, entry0, total_size) {
+		ret = compat_copy_entry_from_user(iter0, &pos,
+		      &size, name, newinfo, entry1);
+		if (ret != 0)
+			break;
+	}
 	xt_compat_flush_offsets(AF_INET);
 	xt_compat_unlock(AF_INET);
 	if (ret)
@@ -1782,13 +1803,28 @@ translate_compat_table(const char *name,
 		goto free_newinfo;
 
 	i = 0;
-	ret = IPT_ENTRY_ITERATE(entry1, newinfo->size, compat_check_entry,
-				name, &i);
+	xt_entry_foreach(iter1, entry1, newinfo->size) {
+		ret = compat_check_entry(iter1, name, &i);
+		if (ret != 0)
+			break;
+	}
 	if (ret) {
+		/*
+		 * The first i matches need cleanup_entry (calls ->destroy)
+		 * because they had called ->check already. The other j-i
+		 * entries need only release.
+		 */
+		int skip = i;
 		j -= i;
-		COMPAT_IPT_ENTRY_ITERATE_CONTINUE(entry0, newinfo->size, i,
-						  compat_release_entry, &j);
-		IPT_ENTRY_ITERATE(entry1, newinfo->size, cleanup_entry, &i);
+		xt_entry_foreach(iter0, entry0, newinfo->size) {
+			if (skip-- > 0)
+				continue;
+			if (compat_release_entry(iter0, &i) != 0)
+				break;
+		}
+		xt_entry_foreach(iter1, entry1, newinfo->size)
+			if (cleanup_entry(iter1, &i) != 0)
+				break;
 		xt_free_table_info(newinfo);
 		return ret;
 	}
@@ -1806,7 +1842,9 @@ translate_compat_table(const char *name,
 free_newinfo:
 	xt_free_table_info(newinfo);
 out:
-	COMPAT_IPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
+	xt_entry_foreach(iter0, entry0, total_size)
+		if (compat_release_entry(iter0, &j) != 0)
+			break;
 	return ret;
 out_unlock:
 	xt_compat_flush_offsets(AF_INET);
@@ -1821,6 +1859,7 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 	struct compat_ipt_replace tmp;
 	struct xt_table_info *newinfo;
 	void *loc_cpu_entry;
+	struct ipt_entry *iter;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
@@ -1859,7 +1898,9 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 	return 0;
 
  free_newinfo_untrans:
-	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1908,6 +1949,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 	int ret = 0;
 	const void *loc_cpu_entry;
 	unsigned int i = 0;
+	struct ipt_entry *iter;
 
 	counters = alloc_counters(table);
 	if (IS_ERR(counters))
@@ -1920,9 +1962,12 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	pos = userptr;
 	size = total_size;
-	ret = IPT_ENTRY_ITERATE(loc_cpu_entry, total_size,
-				compat_copy_entry_to_user,
-				&pos, &size, counters, &i);
+	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
+		ret = compat_copy_entry_to_user(iter, &pos,
+		      &size, counters, &i);
+		if (ret != 0)
+			break;
+	}
 
 	vfree(counters);
 	return ret;
@@ -2123,12 +2168,15 @@ void ipt_unregister_table(struct xt_table *table)
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
 	struct module *table_owner = table->me;
+	struct ipt_entry *iter;
 
 	private = xt_unregister_table(table);
 
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
-	IPT_ENTRY_ITERATE(loc_cpu_entry, private->size, cleanup_entry, NULL);
+	xt_entry_foreach(iter, loc_cpu_entry, private->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 654cdc7..23d7519 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -311,6 +311,7 @@ static void trace_packet(const struct sk_buff *skb,
 	const void *table_base;
 	const struct ip6t_entry *root;
 	const char *hookname, *chainname, *comment;
+	const struct ip6t_entry *iter;
 	unsigned int rulenum = 0;
 
 	table_base = private->entries[smp_processor_id()];
@@ -319,10 +320,10 @@ static void trace_packet(const struct sk_buff *skb,
 	hookname = chainname = hooknames[hook];
 	comment = comments[NF_IP6_TRACE_COMMENT_RULE];
 
-	IP6T_ENTRY_ITERATE(root,
-			   private->size - private->hook_entry[hook],
-			   get_chainname_rulenum,
-			   e, hookname, &chainname, &comment, &rulenum);
+	xt_entry_foreach(iter, root, private->size - private->hook_entry[hook])
+		if (get_chainname_rulenum(iter, e, hookname,
+		    &chainname, &comment, &rulenum) != 0)
+			break;
 
 	nf_log_packet(AF_INET6, hook, skb, in, out, &trace_loginfo,
 		      "TRACE: %s:%s:%s:%u ",
@@ -845,8 +846,9 @@ translate_table(const char *name,
 		const unsigned int *hook_entries,
 		const unsigned int *underflows)
 {
+	struct ip6t_entry *iter;
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	newinfo->size = size;
 	newinfo->number = number;
@@ -860,12 +862,13 @@ translate_table(const char *name,
 	duprintf("translate_table: size %u\n", newinfo->size);
 	i = 0;
 	/* Walk through entries, checking offsets. */
-	ret = IP6T_ENTRY_ITERATE(entry0, newinfo->size,
-				check_entry_size_and_hooks,
-				newinfo,
-				entry0,
-				entry0 + size,
-				hook_entries, underflows, valid_hooks, &i);
+	xt_entry_foreach(iter, entry0, newinfo->size) {
+		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
+		      entry0 + size, hook_entries, underflows,
+		      valid_hooks, &i);
+		if (ret != 0)
+			break;
+	}
 	if (ret != 0)
 		return ret;
 
@@ -897,12 +900,16 @@ translate_table(const char *name,
 
 	/* Finally, each sanity check must pass */
 	i = 0;
-	ret = IP6T_ENTRY_ITERATE(entry0, newinfo->size,
-				find_check_entry, name, size, &i);
+	xt_entry_foreach(iter, entry0, newinfo->size) {
+		ret = find_check_entry(iter, name, size, &i);
+		if (ret != 0)
+			break;
+	}
 
 	if (ret != 0) {
-		IP6T_ENTRY_ITERATE(entry0, newinfo->size,
-				   cleanup_entry, &i);
+		xt_entry_foreach(iter, entry0, newinfo->size)
+			if (cleanup_entry(iter, &i) != 0)
+				break;
 		return ret;
 	}
 
@@ -942,6 +949,7 @@ static void
 get_counters(const struct xt_table_info *t,
 	     struct xt_counters counters[])
 {
+	struct ip6t_entry *iter;
 	unsigned int cpu;
 	unsigned int i;
 	unsigned int curcpu;
@@ -957,22 +965,18 @@ get_counters(const struct xt_table_info *t,
 	curcpu = smp_processor_id();
 
 	i = 0;
-	IP6T_ENTRY_ITERATE(t->entries[curcpu],
-			   t->size,
-			   set_entry_to_counter,
-			   counters,
-			   &i);
+	xt_entry_foreach(iter, t->entries[curcpu], t->size)
+		if (set_entry_to_counter(iter, counters, &i) != 0)
+			break;
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 		i = 0;
 		xt_info_wrlock(cpu);
-		IP6T_ENTRY_ITERATE(t->entries[cpu],
-				  t->size,
-				  add_entry_to_counter,
-				  counters,
-				  &i);
+		xt_entry_foreach(iter, t->entries[cpu], t->size)
+			if (add_entry_to_counter(iter, counters, &i) != 0)
+				break;
 		xt_info_wrunlock(cpu);
 	}
 	local_bh_enable();
@@ -1130,7 +1134,9 @@ static int compat_calc_entry(const struct ip6t_entry *e,
 static int compat_table_info(const struct xt_table_info *info,
 			     struct xt_table_info *newinfo)
 {
+	struct ip6t_entry *iter;
 	void *loc_cpu_entry;
+	int ret = 0;
 
 	if (!newinfo || !info)
 		return -EINVAL;
@@ -1139,9 +1145,12 @@ static int compat_table_info(const struct xt_table_info *info,
 	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
 	newinfo->initial_entries = 0;
 	loc_cpu_entry = info->entries[raw_smp_processor_id()];
-	return IP6T_ENTRY_ITERATE(loc_cpu_entry, info->size,
-				  compat_calc_entry, info, loc_cpu_entry,
-				  newinfo);
+	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
+		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
+		if (ret != 0)
+			break;
+	}
+	return ret;
 }
 #endif
 
@@ -1255,6 +1264,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct xt_table_info *oldinfo;
 	struct xt_counters *counters;
 	const void *loc_cpu_old_entry;
+	struct ip6t_entry *iter;
 
 	ret = 0;
 	counters = vmalloc_node(num_counters * sizeof(struct xt_counters),
@@ -1298,8 +1308,10 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
-	IP6T_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,
-			   NULL);
+	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
+
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
 			 sizeof(struct xt_counters) * num_counters) != 0)
@@ -1324,6 +1336,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 	struct ip6t_replace tmp;
 	struct xt_table_info *newinfo;
 	void *loc_cpu_entry;
+	struct ip6t_entry *iter;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
@@ -1359,7 +1372,9 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 	return 0;
 
  free_newinfo_untrans:
-	IP6T_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1393,6 +1408,7 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	const struct xt_table_info *private;
 	int ret = 0;
 	const void *loc_cpu_entry;
+	struct ip6t_entry *iter;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
 
@@ -1451,11 +1467,9 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	curcpu = smp_processor_id();
 	xt_info_wrlock(curcpu);
 	loc_cpu_entry = private->entries[curcpu];
-	IP6T_ENTRY_ITERATE(loc_cpu_entry,
-			  private->size,
-			  add_counter_to_entry,
-			  paddc,
-			  &i);
+	xt_entry_foreach(iter, loc_cpu_entry, private->size)
+		if (add_counter_to_entry(iter, paddc, &i) != 0)
+			break;
 	xt_info_wrunlock(curcpu);
 
  unlock_up_free:
@@ -1739,8 +1753,10 @@ translate_compat_table(const char *name,
 	unsigned int i, j;
 	struct xt_table_info *newinfo, *info;
 	void *pos, *entry0, *entry1;
+	struct compat_ip6t_entry *iter0;
+	struct ip6t_entry *iter1;
 	unsigned int size;
-	int ret;
+	int ret = 0;
 
 	info = *pinfo;
 	entry0 = *pentry0;
@@ -1757,11 +1773,13 @@ translate_compat_table(const char *name,
 	j = 0;
 	xt_compat_lock(AF_INET6);
 	/* Walk through entries, checking offsets. */
-	ret = COMPAT_IP6T_ENTRY_ITERATE(entry0, total_size,
-					check_compat_entry_size_and_hooks,
-					info, &size, entry0,
-					entry0 + total_size,
-					hook_entries, underflows, &j, name);
+	xt_entry_foreach(iter0, entry0, total_size) {
+		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
+		      entry0, entry0 + total_size, hook_entries, underflows,
+		      &j, name);
+		if (ret != 0)
+			break;
+	}
 	if (ret != 0)
 		goto out_unlock;
 
@@ -1802,9 +1820,12 @@ translate_compat_table(const char *name,
 	entry1 = newinfo->entries[raw_smp_processor_id()];
 	pos = entry1;
 	size = total_size;
-	ret = COMPAT_IP6T_ENTRY_ITERATE(entry0, total_size,
-					compat_copy_entry_from_user,
-					&pos, &size, name, newinfo, entry1);
+	xt_entry_foreach(iter0, entry0, total_size) {
+		ret = compat_copy_entry_from_user(iter0, &pos,
+		      &size, name, newinfo, entry1);
+		if (ret != 0)
+			break;
+	}
 	xt_compat_flush_offsets(AF_INET6);
 	xt_compat_unlock(AF_INET6);
 	if (ret)
@@ -1815,13 +1836,28 @@ translate_compat_table(const char *name,
 		goto free_newinfo;
 
 	i = 0;
-	ret = IP6T_ENTRY_ITERATE(entry1, newinfo->size, compat_check_entry,
-				 name, &i);
+	xt_entry_foreach(iter1, entry1, newinfo->size) {
+		ret = compat_check_entry(iter1, name, &i);
+		if (ret != 0)
+			break;
+	}
 	if (ret) {
+		/*
+		 * The first i matches need cleanup_entry (calls ->destroy)
+		 * because they had called ->check already. The other j-i
+		 * entries need only release.
+		 */
+		int skip = i;
 		j -= i;
-		COMPAT_IP6T_ENTRY_ITERATE_CONTINUE(entry0, newinfo->size, i,
-						   compat_release_entry, &j);
-		IP6T_ENTRY_ITERATE(entry1, newinfo->size, cleanup_entry, &i);
+		xt_entry_foreach(iter0, entry0, newinfo->size) {
+			if (skip-- > 0)
+				continue;
+			if (compat_release_entry(iter0, &j) != 0)
+				break;
+		}
+		xt_entry_foreach(iter1, entry1, newinfo->size)
+			if (cleanup_entry(iter1, &i) != 0)
+				break;
 		xt_free_table_info(newinfo);
 		return ret;
 	}
@@ -1839,7 +1875,9 @@ translate_compat_table(const char *name,
 free_newinfo:
 	xt_free_table_info(newinfo);
 out:
-	COMPAT_IP6T_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
+	xt_entry_foreach(iter0, entry0, total_size)
+		if (compat_release_entry(iter0, &j) != 0)
+			break;
 	return ret;
 out_unlock:
 	xt_compat_flush_offsets(AF_INET6);
@@ -1854,6 +1892,7 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 	struct compat_ip6t_replace tmp;
 	struct xt_table_info *newinfo;
 	void *loc_cpu_entry;
+	struct ip6t_entry *iter;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
@@ -1892,7 +1931,9 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 	return 0;
 
  free_newinfo_untrans:
-	IP6T_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1941,6 +1982,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 	int ret = 0;
 	const void *loc_cpu_entry;
 	unsigned int i = 0;
+	struct ip6t_entry *iter;
 
 	counters = alloc_counters(table);
 	if (IS_ERR(counters))
@@ -1953,9 +1995,12 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	pos = userptr;
 	size = total_size;
-	ret = IP6T_ENTRY_ITERATE(loc_cpu_entry, total_size,
-				 compat_copy_entry_to_user,
-				 &pos, &size, counters, &i);
+	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
+		ret = compat_copy_entry_to_user(iter, &pos,
+		      &size, counters, &i);
+		if (ret != 0)
+			break;
+	}
 
 	vfree(counters);
 	return ret;
@@ -2155,12 +2200,15 @@ void ip6t_unregister_table(struct xt_table *table)
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
 	struct module *table_owner = table->me;
+	struct ip6t_entry *iter;
 
 	private = xt_unregister_table(table);
 
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
-	IP6T_ENTRY_ITERATE(loc_cpu_entry, private->size, cleanup_entry, NULL);
+	xt_entry_foreach(iter, loc_cpu_entry, private->size)
+		if (cleanup_entry(iter, NULL) != 0)
+			break;
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
-- 
1.6.3.3

