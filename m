From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 1/2] netfilter: iptables: separate counters from iptables rules
Date: Wed, 27 May 2015 02:35:18 +0200
Message-ID: <1432686919-8827-1-git-send-email-fw@strlen.de>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44557 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbbE0Afe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2015 20:35:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The binary arp/ip/ip6tables ruleset is stored per cpu.

The only reason left as to why we need percpu duplication are the rule
counters embedded into ipt_entry et al -- since each cpu has its own copy
of the rules, all counters can be lockless.

The downside is that the more cpus are supported, the more memory is
required.  Rules are not just duplicated per online cpu but for each
possible cpu, i.e. if maxcpu is 144, then rule is duplicated 144 times,
not for the e.g. 64 cores present.

To save some memory and also allow cpus with shared caches to make
better use of available cache size, it would be preferable to only
store a copy of the rule blob for each numa node.

So we first need to separate counters and the rule blob.

We create array of struct xt_counters for each possible cpu and
index them from the main blob via the (unused after validation)
->comefrom member.

Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/x_tables.h |  6 ++++++
 net/ipv4/netfilter/arp_tables.c    | 31 ++++++++++++++--------------
 net/ipv4/netfilter/ip_tables.c     | 31 ++++++++++++++--------------
 net/ipv6/netfilter/ip6_tables.c    | 32 ++++++++++++++---------------
 net/netfilter/x_tables.c           | 42 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 93 insertions(+), 49 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 09f3820..e50ba76 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -224,6 +224,12 @@ struct xt_table_info {
 	unsigned int stacksize;
 	unsigned int __percpu *stackptr;
 	void ***jumpstack;
+
+	/* pointer to array of counters, one per CPU
+	 * each rule maps 1:1 to an entry in the percpu counter array.
+	 */
+	struct xt_counters **counters;
+
 	/* ipt_entry tables: one per CPU */
 	/* Note : this field MUST be the last one, see XT_TABLE_INFO_SZ */
 	void *entries[1];
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 13bfe84..62cd230 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -259,7 +259,8 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	void *table_base;
 	const struct xt_table_info *private;
 	struct xt_action_param acpar;
-	unsigned int addend;
+	struct xt_counters *counters;
+	unsigned int addend, cpu;
 
 	if (!pskb_may_pull(skb, arp_hdr_len(skb->dev)))
 		return NF_DROP;
@@ -270,12 +271,14 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
 	private = table->private;
+	cpu = smp_processor_id();
 	/*
 	 * Ensure we load private-> members after we've fetched the base
 	 * pointer.
 	 */
 	smp_read_barrier_depends();
 	table_base = private->entries[smp_processor_id()];
+	counters   = private->counters[cpu];
 
 	e = get_entry(table_base, private->hook_entry[hook]);
 	back = get_entry(table_base, private->underflow[hook]);
@@ -295,7 +298,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 			continue;
 		}
 
-		ADD_COUNTER(e->counters, arp_hdr_len(skb->dev), 1);
+		ADD_COUNTER(counters[e->comefrom], skb->len, 1);
 
 		t = arpt_get_target_c(e);
 
@@ -690,6 +693,7 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 		ret = find_check_entry(iter, repl->name, repl->size);
 		if (ret != 0)
 			break;
+		iter->comefrom = i;
 		++i;
 	}
 
@@ -714,26 +718,24 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 static void get_counters(const struct xt_table_info *t,
 			 struct xt_counters counters[])
 {
-	struct arpt_entry *iter;
 	unsigned int cpu;
 	unsigned int i;
 
 	for_each_possible_cpu(cpu) {
+		struct xt_counters *pcpu_counters = t->counters[cpu];
 		seqcount_t *s = &per_cpu(xt_recseq, cpu);
 
-		i = 0;
-		xt_entry_foreach(iter, t->entries[cpu], t->size) {
+		for (i = 0; i < t->number; i++) {
 			u64 bcnt, pcnt;
 			unsigned int start;
 
 			do {
 				start = read_seqcount_begin(s);
-				bcnt = iter->counters.bcnt;
-				pcnt = iter->counters.pcnt;
+				bcnt = pcpu_counters[i].bcnt;
+				pcnt = pcpu_counters[i].pcnt;
 			} while (read_seqcount_retry(s, start));
 
 			ADD_COUNTER(counters[i], bcnt, pcnt);
-			++i;
 		}
 	}
 }
@@ -1114,7 +1116,7 @@ static int do_add_counters(struct net *net, const void __user *user,
 {
 	unsigned int i, curcpu;
 	struct xt_counters_info tmp;
-	struct xt_counters *paddc;
+	struct xt_counters *paddc, *pcpu_counters;
 	unsigned int num_counters;
 	const char *name;
 	int size;
@@ -1122,8 +1124,6 @@ static int do_add_counters(struct net *net, const void __user *user,
 	struct xt_table *t;
 	const struct xt_table_info *private;
 	int ret = 0;
-	void *loc_cpu_entry;
-	struct arpt_entry *iter;
 	unsigned int addend;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
@@ -1180,12 +1180,10 @@ static int do_add_counters(struct net *net, const void __user *user,
 	i = 0;
 	/* Choose the copy that is on our node */
 	curcpu = smp_processor_id();
-	loc_cpu_entry = private->entries[curcpu];
+	pcpu_counters = private->counters[curcpu];
 	addend = xt_write_recseq_begin();
-	xt_entry_foreach(iter, loc_cpu_entry, private->size) {
-		ADD_COUNTER(iter->counters, paddc[i].bcnt, paddc[i].pcnt);
-		++i;
-	}
+	for (i = 0; i < private->number ; i++)
+		ADD_COUNTER(pcpu_counters[i], paddc[i].bcnt, paddc[i].pcnt);
 	xt_write_recseq_end(addend);
  unlock_up_free:
 	local_bh_enable();
@@ -1416,6 +1414,7 @@ static int translate_compat_table(const char *name,
 		ret = check_target(iter1, name);
 		if (ret != 0)
 			break;
+		iter1->comefrom = i;
 		++i;
 		if (strcmp(arpt_get_target(iter1)->u.user.name,
 		    XT_ERROR_TARGET) == 0)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 583779f..a68c377 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -301,6 +301,7 @@ ipt_do_table(struct sk_buff *skb,
 	unsigned int *stackptr, origptr, cpu;
 	const struct xt_table_info *private;
 	struct xt_action_param acpar;
+	struct xt_counters *counters;
 	unsigned int addend;
 
 	/* Initialization */
@@ -335,6 +336,7 @@ ipt_do_table(struct sk_buff *skb,
 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
 	stackptr   = per_cpu_ptr(private->stackptr, cpu);
 	origptr    = *stackptr;
+	counters   = private->counters[cpu];
 
 	e = get_entry(table_base, private->hook_entry[hook]);
 
@@ -361,7 +363,7 @@ ipt_do_table(struct sk_buff *skb,
 				goto no_match;
 		}
 
-		ADD_COUNTER(e->counters, skb->len, 1);
+		ADD_COUNTER(counters[e->comefrom], skb->len, 1);
 
 		t = ipt_get_target(e);
 		IP_NF_ASSERT(t->u.kernel.target);
@@ -854,6 +856,8 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 		ret = find_check_entry(iter, net, repl->name, repl->size);
 		if (ret != 0)
 			break;
+		/* overload comefrom to index into percpu counters array */
+		iter->comefrom = i;
 		++i;
 	}
 
@@ -879,26 +883,24 @@ static void
 get_counters(const struct xt_table_info *t,
 	     struct xt_counters counters[])
 {
-	struct ipt_entry *iter;
 	unsigned int cpu;
 	unsigned int i;
 
 	for_each_possible_cpu(cpu) {
+		struct xt_counters *pcpu_counters = t->counters[cpu];
 		seqcount_t *s = &per_cpu(xt_recseq, cpu);
 
-		i = 0;
-		xt_entry_foreach(iter, t->entries[cpu], t->size) {
+		for (i = 0; i < t->number; i++) {
 			u64 bcnt, pcnt;
 			unsigned int start;
 
 			do {
 				start = read_seqcount_begin(s);
-				bcnt = iter->counters.bcnt;
-				pcnt = iter->counters.pcnt;
+				bcnt = pcpu_counters[i].bcnt;
+				pcnt = pcpu_counters[i].pcnt;
 			} while (read_seqcount_retry(s, start));
 
 			ADD_COUNTER(counters[i], bcnt, pcnt);
-			++i; /* macro does multi eval of i */
 		}
 	}
 }
@@ -1302,7 +1304,7 @@ do_add_counters(struct net *net, const void __user *user,
 {
 	unsigned int i, curcpu;
 	struct xt_counters_info tmp;
-	struct xt_counters *paddc;
+	struct xt_counters *paddc, *pcpu_counters;
 	unsigned int num_counters;
 	const char *name;
 	int size;
@@ -1310,8 +1312,6 @@ do_add_counters(struct net *net, const void __user *user,
 	struct xt_table *t;
 	const struct xt_table_info *private;
 	int ret = 0;
-	void *loc_cpu_entry;
-	struct ipt_entry *iter;
 	unsigned int addend;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
@@ -1365,15 +1365,12 @@ do_add_counters(struct net *net, const void __user *user,
 		goto unlock_up_free;
 	}
 
-	i = 0;
 	/* Choose the copy that is on our node */
 	curcpu = smp_processor_id();
-	loc_cpu_entry = private->entries[curcpu];
+	pcpu_counters = private->counters[curcpu];
 	addend = xt_write_recseq_begin();
-	xt_entry_foreach(iter, loc_cpu_entry, private->size) {
-		ADD_COUNTER(iter->counters, paddc[i].bcnt, paddc[i].pcnt);
-		++i;
-	}
+	for (i = 0; i < private->number ; i++)
+		ADD_COUNTER(pcpu_counters[i], paddc[i].bcnt, paddc[i].pcnt);
 	xt_write_recseq_end(addend);
  unlock_up_free:
 	local_bh_enable();
@@ -1736,6 +1733,8 @@ translate_compat_table(struct net *net,
 		ret = compat_check_entry(iter1, net, name);
 		if (ret != 0)
 			break;
+		/* overload comefrom to index into percpu counters array */
+		iter1->comefrom = i;
 		++i;
 		if (strcmp(ipt_get_target(iter1)->u.user.name,
 		    XT_ERROR_TARGET) == 0)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d54f049..69aec1d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -329,6 +329,7 @@ ip6t_do_table(struct sk_buff *skb,
 	unsigned int *stackptr, origptr, cpu;
 	const struct xt_table_info *private;
 	struct xt_action_param acpar;
+	struct xt_counters *counters;
 	unsigned int addend;
 
 	/* Initialization */
@@ -361,6 +362,7 @@ ip6t_do_table(struct sk_buff *skb,
 	jumpstack  = (struct ip6t_entry **)private->jumpstack[cpu];
 	stackptr   = per_cpu_ptr(private->stackptr, cpu);
 	origptr    = *stackptr;
+	counters   = private->counters[cpu];
 
 	e = get_entry(table_base, private->hook_entry[hook]);
 
@@ -384,7 +386,7 @@ ip6t_do_table(struct sk_buff *skb,
 				goto no_match;
 		}
 
-		ADD_COUNTER(e->counters, skb->len, 1);
+		ADD_COUNTER(counters[e->comefrom], skb->len, 1);
 
 		t = ip6t_get_target_c(e);
 		IP_NF_ASSERT(t->u.kernel.target);
@@ -867,6 +869,8 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 		ret = find_check_entry(iter, net, repl->name, repl->size);
 		if (ret != 0)
 			break;
+		/* overload comefrom to index into percpu counters array */
+		iter->comefrom = i;
 		++i;
 	}
 
@@ -892,26 +896,24 @@ static void
 get_counters(const struct xt_table_info *t,
 	     struct xt_counters counters[])
 {
-	struct ip6t_entry *iter;
 	unsigned int cpu;
 	unsigned int i;
 
 	for_each_possible_cpu(cpu) {
+		struct xt_counters *pcpu_counters = t->counters[cpu];
 		seqcount_t *s = &per_cpu(xt_recseq, cpu);
 
-		i = 0;
-		xt_entry_foreach(iter, t->entries[cpu], t->size) {
+		for (i = 0; i < t->number; i++) {
 			u64 bcnt, pcnt;
 			unsigned int start;
 
 			do {
 				start = read_seqcount_begin(s);
-				bcnt = iter->counters.bcnt;
-				pcnt = iter->counters.pcnt;
+				bcnt = pcpu_counters[i].bcnt;
+				pcnt = pcpu_counters[i].pcnt;
 			} while (read_seqcount_retry(s, start));
 
 			ADD_COUNTER(counters[i], bcnt, pcnt);
-			++i;
 		}
 	}
 }
@@ -1315,7 +1317,7 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 {
 	unsigned int i, curcpu;
 	struct xt_counters_info tmp;
-	struct xt_counters *paddc;
+	struct xt_counters *paddc, *pcpu_counters;
 	unsigned int num_counters;
 	char *name;
 	int size;
@@ -1323,8 +1325,6 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	struct xt_table *t;
 	const struct xt_table_info *private;
 	int ret = 0;
-	const void *loc_cpu_entry;
-	struct ip6t_entry *iter;
 	unsigned int addend;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
@@ -1379,17 +1379,13 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 		goto unlock_up_free;
 	}
 
-	i = 0;
 	/* Choose the copy that is on our node */
 	curcpu = smp_processor_id();
+	pcpu_counters = private->counters[curcpu];
 	addend = xt_write_recseq_begin();
-	loc_cpu_entry = private->entries[curcpu];
-	xt_entry_foreach(iter, loc_cpu_entry, private->size) {
-		ADD_COUNTER(iter->counters, paddc[i].bcnt, paddc[i].pcnt);
-		++i;
-	}
+	for (i = 0; i < private->number ; i++)
+		ADD_COUNTER(pcpu_counters[i], paddc[i].bcnt, paddc[i].pcnt);
 	xt_write_recseq_end(addend);
-
  unlock_up_free:
 	local_bh_enable();
 	xt_table_unlock(t);
@@ -1749,6 +1745,8 @@ translate_compat_table(struct net *net,
 		ret = compat_check_entry(iter1, net, name);
 		if (ret != 0)
 			break;
+		/* overload comefrom to index into percpu counters array */
+		iter1->comefrom = i;
 		++i;
 		if (strcmp(ip6t_get_target(iter1)->u.user.name,
 		    XT_ERROR_TARGET) == 0)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8303246..28e3396 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -697,6 +697,12 @@ void xt_free_table_info(struct xt_table_info *info)
 	for_each_possible_cpu(cpu)
 		kvfree(info->entries[cpu]);
 
+	if (info->counters != NULL) {
+		for_each_possible_cpu(cpu)
+			kvfree(info->counters[cpu]);
+		kvfree(info->counters);
+	}
+
 	if (info->jumpstack != NULL) {
 		for_each_possible_cpu(cpu)
 			kvfree(info->jumpstack[cpu]);
@@ -747,6 +753,36 @@ EXPORT_SYMBOL_GPL(xt_compat_unlock);
 DEFINE_PER_CPU(seqcount_t, xt_recseq);
 EXPORT_PER_CPU_SYMBOL_GPL(xt_recseq);
 
+static int xt_counters_alloc(struct xt_table_info *i)
+{
+	unsigned int size;
+	int cpu;
+
+	size = sizeof(void *) * nr_cpu_ids;
+	if (size > PAGE_SIZE)
+		i->counters = vzalloc(size);
+	else
+		i->counters = kzalloc(size, GFP_KERNEL);
+
+	if (i->counters == NULL)
+		return -ENOMEM;
+
+	size = sizeof(struct xt_counters) * i->number;
+
+	for_each_possible_cpu(cpu) {
+		if (size > PAGE_SIZE)
+			i->counters[cpu] = vzalloc_node(size,
+				cpu_to_node(cpu));
+		else
+			i->counters[cpu] = kzalloc_node(size,
+				GFP_KERNEL, cpu_to_node(cpu));
+		if (i->counters[cpu] == NULL)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static int xt_jumpstack_alloc(struct xt_table_info *i)
 {
 	unsigned int size;
@@ -794,6 +830,12 @@ xt_replace_table(struct xt_table *table,
 	struct xt_table_info *private;
 	int ret;
 
+	ret = xt_counters_alloc(newinfo);
+	if (ret < 0) {
+		*error = ret;
+		return NULL;
+	}
+
 	ret = xt_jumpstack_alloc(newinfo);
 	if (ret < 0) {
 		*error = ret;
-- 
2.0.5

