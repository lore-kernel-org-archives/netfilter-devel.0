From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 2/2] netfilter: store rules per NUMA node instead of per cpu
Date: Wed, 27 May 2015 02:35:19 +0200
Message-ID: <1432686919-8827-2-git-send-email-fw@strlen.de>
References: <1432686919-8827-1-git-send-email-fw@strlen.de>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44561 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbbE0Afk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2015 20:35:40 -0400
In-Reply-To: <1432686919-8827-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We store rule blob per (possible) cpu.  Unfortunately this means we can
waste lot of memory on big smp machines. ipt_entry structure ('rule head')
is 112 byte, so e.g. with maxcpu=64 one single rule eats close to 8k RAM.

Since previous patch moved counters to separate percpu blob, it appears
there is nothing left in the rule blob that must be percpu.

Thus only duplicate the rule blob for each NUMA node.

On my test system (144 possible cpus, one numa node, 400k dummy rules) this
change saves close to 9 Gigabyte of RAM.

Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/x_tables.h |  2 +-
 net/ipv4/netfilter/arp_tables.c    | 21 ++++++++++-----------
 net/ipv4/netfilter/ip_tables.c     | 30 +++++++++++++++---------------
 net/ipv6/netfilter/ip6_tables.c    | 30 +++++++++++++++---------------
 net/netfilter/x_tables.c           | 20 +++++++++-----------
 5 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index e50ba76..ff25664 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -230,7 +230,7 @@ struct xt_table_info {
 	 */
 	struct xt_counters **counters;
 
-	/* ipt_entry tables: one per CPU */
+	/* ipt_entry tables: one per NUMA node */
 	/* Note : this field MUST be the last one, see XT_TABLE_INFO_SZ */
 	void *entries[1];
 };
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 62cd230..bee2c5a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -277,7 +277,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	 * pointer.
 	 */
 	smp_read_barrier_depends();
-	table_base = private->entries[smp_processor_id()];
+	table_base = private->entries[cpu_to_node(cpu)];
 	counters   = private->counters[cpu];
 
 	e = get_entry(table_base, private->hook_entry[hook]);
@@ -776,7 +776,7 @@ static int copy_entries_to_user(unsigned int total_size,
 	if (IS_ERR(counters))
 		return PTR_ERR(counters);
 
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	loc_cpu_entry = private->entries[numa_node_id()];
 	/* ... then copy entire thing ... */
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
 		ret = -EFAULT;
@@ -874,7 +874,7 @@ static int compat_table_info(const struct xt_table_info *info,
 	/* we dont care about newinfo->entries[] */
 	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
 	newinfo->initial_entries = 0;
-	loc_cpu_entry = info->entries[raw_smp_processor_id()];
+	loc_cpu_entry = info->entries[numa_node_id()];
 	xt_compat_init_offsets(NFPROTO_ARP, info->number);
 	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
 		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
@@ -1039,7 +1039,7 @@ static int __do_replace(struct net *net, const char *name,
 	get_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
-	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
+	loc_cpu_old_entry = oldinfo->entries[numa_node_id()];
 	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
 		cleanup_entry(iter);
 
@@ -1084,7 +1084,7 @@ static int do_replace(struct net *net, const void __user *user,
 		return -ENOMEM;
 
 	/* choose the copy that is on our node/cpu */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	loc_cpu_entry = newinfo->entries[numa_node_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
 		ret = -EFAULT;
@@ -1177,7 +1177,6 @@ static int do_add_counters(struct net *net, const void __user *user,
 		goto unlock_up_free;
 	}
 
-	i = 0;
 	/* Choose the copy that is on our node */
 	curcpu = smp_processor_id();
 	pcpu_counters = private->counters[curcpu];
@@ -1391,7 +1390,7 @@ static int translate_compat_table(const char *name,
 		newinfo->hook_entry[i] = info->hook_entry[i];
 		newinfo->underflow[i] = info->underflow[i];
 	}
-	entry1 = newinfo->entries[raw_smp_processor_id()];
+	entry1 = newinfo->entries[numa_node_id()];
 	pos = entry1;
 	size = total_size;
 	xt_entry_foreach(iter0, entry0, total_size) {
@@ -1505,7 +1504,7 @@ static int compat_do_replace(struct net *net, void __user *user,
 		return -ENOMEM;
 
 	/* choose the copy that is on our node/cpu */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	loc_cpu_entry = newinfo->entries[numa_node_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp), tmp.size) != 0) {
 		ret = -EFAULT;
 		goto free_newinfo;
@@ -1611,7 +1610,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 		return PTR_ERR(counters);
 
 	/* choose the copy on our node/cpu */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	loc_cpu_entry = private->entries[numa_node_id()];
 	pos = userptr;
 	size = total_size;
 	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
@@ -1784,7 +1783,7 @@ struct xt_table *arpt_register_table(struct net *net,
 	}
 
 	/* choose the copy on our node/cpu */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	loc_cpu_entry = newinfo->entries[numa_node_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
 	ret = translate_table(newinfo, loc_cpu_entry, repl);
@@ -1815,7 +1814,7 @@ void arpt_unregister_table(struct xt_table *table)
 	private = xt_unregister_table(table);
 
 	/* Decrease module usage counts and free resources */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	loc_cpu_entry = private->entries[numa_node_id()];
 	xt_entry_foreach(iter, loc_cpu_entry, private->size)
 		cleanup_entry(iter);
 	if (private->number > private->initial_entries)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index a68c377..6fa6213 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -261,7 +261,7 @@ static void trace_packet(const struct sk_buff *skb,
 	unsigned int rulenum = 0;
 	struct net *net = dev_net(in ? in : out);
 
-	table_base = private->entries[smp_processor_id()];
+	table_base = private->entries[numa_node_id()];
 	root = get_entry(table_base, private->hook_entry[hook]);
 
 	hookname = chainname = hooknames[hook];
@@ -332,7 +332,7 @@ ipt_do_table(struct sk_buff *skb,
 	 * pointer.
 	 */
 	smp_read_barrier_depends();
-	table_base = private->entries[cpu];
+	table_base = private->entries[cpu_to_node(cpu)];
 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
 	stackptr   = per_cpu_ptr(private->stackptr, cpu);
 	origptr    = *stackptr;
@@ -870,8 +870,8 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 		return ret;
 	}
 
-	/* And one copy for every other CPU */
-	for_each_possible_cpu(i) {
+	/* And one copy for every other NUMA node */
+	for_each_node(i) {
 		if (newinfo->entries[i] && newinfo->entries[i] != entry0)
 			memcpy(newinfo->entries[i], entry0, newinfo->size);
 	}
@@ -945,7 +945,7 @@ copy_entries_to_user(unsigned int total_size,
 	 * This choice is lazy (because current thread is
 	 * allowed to migrate to another cpu)
 	 */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	loc_cpu_entry = private->entries[numa_node_id()];
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
 		ret = -EFAULT;
 		goto free_counters;
@@ -1062,7 +1062,7 @@ static int compat_table_info(const struct xt_table_info *info,
 	/* we dont care about newinfo->entries[] */
 	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
 	newinfo->initial_entries = 0;
-	loc_cpu_entry = info->entries[raw_smp_processor_id()];
+	loc_cpu_entry = info->entries[numa_node_id()];
 	xt_compat_init_offsets(AF_INET, info->number);
 	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
 		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
@@ -1226,7 +1226,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	get_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
-	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
+	loc_cpu_old_entry = oldinfo->entries[numa_node_id()];
 	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
 		cleanup_entry(iter, net);
 
@@ -1271,7 +1271,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 		return -ENOMEM;
 
 	/* choose the copy that is on our node/cpu */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	loc_cpu_entry = newinfo->entries[numa_node_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
 		ret = -EFAULT;
@@ -1710,7 +1710,7 @@ translate_compat_table(struct net *net,
 		newinfo->hook_entry[i] = info->hook_entry[i];
 		newinfo->underflow[i] = info->underflow[i];
 	}
-	entry1 = newinfo->entries[raw_smp_processor_id()];
+	entry1 = newinfo->entries[numa_node_id()];
 	pos = entry1;
 	size = total_size;
 	xt_entry_foreach(iter0, entry0, total_size) {
@@ -1764,8 +1764,8 @@ translate_compat_table(struct net *net,
 		return ret;
 	}
 
-	/* And one copy for every other CPU */
-	for_each_possible_cpu(i)
+	/* And one copy for every other NUMA node */
+	for_each_node(i)
 		if (newinfo->entries[i] && newinfo->entries[i] != entry1)
 			memcpy(newinfo->entries[i], entry1, newinfo->size);
 
@@ -1813,7 +1813,7 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 		return -ENOMEM;
 
 	/* choose the copy that is on our node/cpu */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	loc_cpu_entry = newinfo->entries[numa_node_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
 		ret = -EFAULT;
@@ -1896,7 +1896,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 	 * This choice is lazy (because current thread is
 	 * allowed to migrate to another cpu)
 	 */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	loc_cpu_entry = private->entries[numa_node_id()];
 	pos = userptr;
 	size = total_size;
 	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
@@ -2075,7 +2075,7 @@ struct xt_table *ipt_register_table(struct net *net,
 	}
 
 	/* choose the copy on our node/cpu, but dont care about preemption */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	loc_cpu_entry = newinfo->entries[numa_node_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
 	ret = translate_table(net, newinfo, loc_cpu_entry, repl);
@@ -2106,7 +2106,7 @@ void ipt_unregister_table(struct net *net, struct xt_table *table)
 	private = xt_unregister_table(table);
 
 	/* Decrease module usage counts and free resources */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	loc_cpu_entry = private->entries[numa_node_id()];
 	xt_entry_foreach(iter, loc_cpu_entry, private->size)
 		cleanup_entry(iter, net);
 	if (private->number > private->initial_entries)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 69aec1d..7491315 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -290,7 +290,7 @@ static void trace_packet(const struct sk_buff *skb,
 	unsigned int rulenum = 0;
 	struct net *net = dev_net(in ? in : out);
 
-	table_base = private->entries[smp_processor_id()];
+	table_base = private->entries[numa_node_id()];
 	root = get_entry(table_base, private->hook_entry[hook]);
 
 	hookname = chainname = hooknames[hook];
@@ -358,7 +358,7 @@ ip6t_do_table(struct sk_buff *skb,
 	 */
 	smp_read_barrier_depends();
 	cpu        = smp_processor_id();
-	table_base = private->entries[cpu];
+	table_base = private->entries[cpu_to_node(cpu)];
 	jumpstack  = (struct ip6t_entry **)private->jumpstack[cpu];
 	stackptr   = per_cpu_ptr(private->stackptr, cpu);
 	origptr    = *stackptr;
@@ -883,8 +883,8 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 		return ret;
 	}
 
-	/* And one copy for every other CPU */
-	for_each_possible_cpu(i) {
+	/* And one copy for every other NUMA node */
+	for_each_node(i) {
 		if (newinfo->entries[i] && newinfo->entries[i] != entry0)
 			memcpy(newinfo->entries[i], entry0, newinfo->size);
 	}
@@ -958,7 +958,7 @@ copy_entries_to_user(unsigned int total_size,
 	 * This choice is lazy (because current thread is
 	 * allowed to migrate to another cpu)
 	 */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	loc_cpu_entry = private->entries[numa_node_id()];
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
 		ret = -EFAULT;
 		goto free_counters;
@@ -1075,7 +1075,7 @@ static int compat_table_info(const struct xt_table_info *info,
 	/* we dont care about newinfo->entries[] */
 	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
 	newinfo->initial_entries = 0;
-	loc_cpu_entry = info->entries[raw_smp_processor_id()];
+	loc_cpu_entry = info->entries[numa_node_id()];
 	xt_compat_init_offsets(AF_INET6, info->number);
 	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
 		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
@@ -1239,7 +1239,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	get_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
-	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
+	loc_cpu_old_entry = oldinfo->entries[numa_node_id()];
 	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
 		cleanup_entry(iter, net);
 
@@ -1284,7 +1284,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 		return -ENOMEM;
 
 	/* choose the copy that is on our node/cpu */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	loc_cpu_entry = newinfo->entries[numa_node_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
 		ret = -EFAULT;
@@ -1722,7 +1722,7 @@ translate_compat_table(struct net *net,
 		newinfo->hook_entry[i] = info->hook_entry[i];
 		newinfo->underflow[i] = info->underflow[i];
 	}
-	entry1 = newinfo->entries[raw_smp_processor_id()];
+	entry1 = newinfo->entries[numa_node_id()];
 	pos = entry1;
 	size = total_size;
 	xt_entry_foreach(iter0, entry0, total_size) {
@@ -1776,8 +1776,8 @@ translate_compat_table(struct net *net,
 		return ret;
 	}
 
-	/* And one copy for every other CPU */
-	for_each_possible_cpu(i)
+	/* And one copy for every other NUMA node */
+	for_each_node(i)
 		if (newinfo->entries[i] && newinfo->entries[i] != entry1)
 			memcpy(newinfo->entries[i], entry1, newinfo->size);
 
@@ -1825,7 +1825,7 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 		return -ENOMEM;
 
 	/* choose the copy that is on our node/cpu */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	loc_cpu_entry = newinfo->entries[numa_node_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
 		ret = -EFAULT;
@@ -1908,7 +1908,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 	 * This choice is lazy (because current thread is
 	 * allowed to migrate to another cpu)
 	 */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	loc_cpu_entry = private->entries[numa_node_id()];
 	pos = userptr;
 	size = total_size;
 	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
@@ -2087,7 +2087,7 @@ struct xt_table *ip6t_register_table(struct net *net,
 	}
 
 	/* choose the copy on our node/cpu, but dont care about preemption */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	loc_cpu_entry = newinfo->entries[numa_node_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
 	ret = translate_table(net, newinfo, loc_cpu_entry, repl);
@@ -2117,7 +2117,7 @@ void ip6t_unregister_table(struct net *net, struct xt_table *table)
 	private = xt_unregister_table(table);
 
 	/* Decrease module usage counts and free resources */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	loc_cpu_entry = private->entries[numa_node_id()];
 	xt_entry_foreach(iter, loc_cpu_entry, private->size)
 		cleanup_entry(iter, net);
 	if (private->number > private->initial_entries)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 28e3396..01549c1 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -659,7 +659,7 @@ EXPORT_SYMBOL_GPL(xt_compat_target_to_user);
 struct xt_table_info *xt_alloc_table_info(unsigned int size)
 {
 	struct xt_table_info *newinfo;
-	int cpu;
+	int node;
 
 	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
 	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
@@ -671,16 +671,14 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 
 	newinfo->size = size;
 
-	for_each_possible_cpu(cpu) {
+	for_each_node(node) {
 		if (size <= PAGE_SIZE)
-			newinfo->entries[cpu] = kmalloc_node(size,
-							GFP_KERNEL,
-							cpu_to_node(cpu));
+			newinfo->entries[node] = kmalloc_node(size,
+							GFP_KERNEL, node);
 		else
-			newinfo->entries[cpu] = vmalloc_node(size,
-							cpu_to_node(cpu));
+			newinfo->entries[node] = vmalloc_node(size, node);
 
-		if (newinfo->entries[cpu] == NULL) {
+		if (newinfo->entries[node] == NULL) {
 			xt_free_table_info(newinfo);
 			return NULL;
 		}
@@ -692,10 +690,10 @@ EXPORT_SYMBOL(xt_alloc_table_info);
 
 void xt_free_table_info(struct xt_table_info *info)
 {
-	int cpu;
+	int cpu, node;
 
-	for_each_possible_cpu(cpu)
-		kvfree(info->entries[cpu]);
+	for_each_node(node)
+		kvfree(info->entries[node]);
 
 	if (info->counters != NULL) {
 		for_each_possible_cpu(cpu)
-- 
2.0.5

