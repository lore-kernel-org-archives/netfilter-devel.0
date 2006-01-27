From: Eric Dumazet <dada1@cosmosbay.com>
Subject: [PATCH] x_tables : Use SMP friendly (percpu) rwlock_t to protect
 x_tables
Date: Fri, 27 Jan 2006 16:16:15 +0100
Message-ID: <43DA393F.6010801@cosmosbay.com>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
	<43C247CF.2000608@cosmosbay.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090105040603070102090509"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <43C247CF.2000608@cosmosbay.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090105040603070102090509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch helps scalability of x_tables on SMP, especially NUMA machines.

Instead of using a single rwlock_t to protect x_tables, use an array of 
rwlock_t, one for each possible cpu in the machine.

1) No more cache line ping pongs between cpus. read_lock_bh(&table->lock) / 
read_unlock_bh(&table->lock) were still expensive because of the very hot 
central rwlock.

2) get_counters() is more latency friendly than before (we lock each sub table 
one at a time instead of the full x_tables)

3) When a replace of table must be done, the 'writer' have to write_lock_bh() 
all the locks of the array. This is 'expensive' but seldom done (underlying 
vmalloc/copy_from_user costs are more expensive anyway)

This patch was tested on a 4 way Opteron machine, two gigabit links, with 
rather complex iptables rules (around 200 rules) and gives excellent results 
so far.


Thank you
Eric Dumazet

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--------------090105040603070102090509
Content-Type: text/plain;
 name="x_tables.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x_tables.patch"

--- linux-2.6.16-rc1/include/linux/netfilter/x_tables.h	2006-01-27 16:38:08.000000000 +0100
+++ linux-2.6.16-rc1-edinclude/linux/netfilter/x_tables.h	2006-01-27 16:39:07.000000000 +0100
@@ -170,7 +170,13 @@
 	unsigned int valid_hooks;
 
 	/* Lock for the curtain */
+#ifdef CONFIG_SMP
+	rwlock_t *lockp;
+# define xt_table_lockaddr(X,cpu) per_cpu_ptr((X)->lockp, cpu)
+#else
 	rwlock_t lock;
+# define xt_table_lockaddr(X,cpu) (&(X)->lock)
+#endif
 
 	/* Man behind the curtain... */
 	//struct ip6t_table_info *private;
@@ -207,6 +213,7 @@
 extern int xt_register_match(int af, struct xt_match *target);
 extern void xt_unregister_match(int af, struct xt_match *target);
 
+extern int xt_table_global_init(struct xt_table *table);
 extern int xt_register_table(struct xt_table *table,
 			     struct xt_table_info *bootstrap,
 			     struct xt_table_info *newinfo);
--- linux-2.6.16-rc1/net/ipv4/netfilter/ip_tables.c	2006-01-27 15:11:58.000000000 +0100
+++ linux-2.6.16-rc1-ednet/ipv4/netfilter/ip_tables.c	2006-01-27 16:39:28.000000000 +0100
@@ -230,6 +230,8 @@
 	void *table_base;
 	struct ipt_entry *e, *back;
 	struct xt_table_info *private = table->private;
+	int curcpu;
+	rwlock_t *lockp;
 
 	/* Initialization */
 	ip = (*pskb)->nh.iph;
@@ -244,9 +246,11 @@
 	 * match it. */
 	offset = ntohs(ip->frag_off) & IP_OFFSET;
 
-	read_lock_bh(&table->lock);
+	curcpu = get_cpu();
+	lockp = xt_table_lockaddr(table, curcpu);
+	read_lock_bh(lockp);
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
-	table_base = (void *)private->entries[smp_processor_id()];
+	table_base = (void *)private->entries[curcpu];
 	e = get_entry(table_base, private->hook_entry[hook]);
 
 	/* For return from builtin chain */
@@ -336,7 +340,8 @@
 		}
 	} while (!hotdrop);
 
-	read_unlock_bh(&table->lock);
+	read_unlock_bh(lockp);
+	put_cpu();
 
 #ifdef DEBUG_ALLOW_ALL
 	return NF_ACCEPT;
@@ -758,7 +763,8 @@
 
 static void
 get_counters(const struct xt_table_info *t,
-	     struct xt_counters counters[])
+	     struct xt_counters counters[],
+		struct xt_table *table)
 {
 	unsigned int cpu;
 	unsigned int i;
@@ -767,26 +773,34 @@
 	/* Instead of clearing (by a previous call to memset())
 	 * the counters and using adds, we set the counters
 	 * with data used by 'current' CPU
-	 * We dont care about preemption here.
 	 */
-	curcpu = raw_smp_processor_id();
+	curcpu = get_cpu();
 
+	if (table)
+		write_lock_bh(xt_table_lockaddr(table, curcpu));
 	i = 0;
 	IPT_ENTRY_ITERATE(t->entries[curcpu],
 			  t->size,
 			  set_entry_to_counter,
 			  counters,
 			  &i);
+	if (table)
+		write_unlock_bh(xt_table_lockaddr(table, curcpu));
+	put_cpu();
 
 	for_each_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
+		if (table)
+			write_lock_bh(xt_table_lockaddr(table, cpu));
 		i = 0;
 		IPT_ENTRY_ITERATE(t->entries[cpu],
 				  t->size,
 				  add_entry_to_counter,
 				  counters,
 				  &i);
+		if (table)
+			write_unlock_bh(xt_table_lockaddr(table, cpu));
 	}
 }
 
@@ -812,9 +826,7 @@
 		return -ENOMEM;
 
 	/* First, sum counters... */
-	write_lock_bh(&table->lock);
-	get_counters(private, counters);
-	write_unlock_bh(&table->lock);
+	get_counters(private, counters, table);
 
 	/* choose the copy that is on our node/cpu, ...
 	 * This choice is lazy (because current thread is
@@ -977,7 +989,7 @@
 		module_put(t->me);
 
 	/* Get the old counters. */
-	get_counters(oldinfo, counters);
+	get_counters(oldinfo, counters, NULL);
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
 	IPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,NULL);
@@ -1032,6 +1044,7 @@
 	struct xt_table_info *private;
 	int ret = 0;
 	void *loc_cpu_entry;
+	int cpu;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
@@ -1054,7 +1067,8 @@
 		goto free;
 	}
 
-	write_lock_bh(&t->lock);
+	cpu = get_cpu();
+	write_lock_bh(xt_table_lockaddr(t, cpu));
 	private = t->private;
 	if (private->number != paddc->num_counters) {
 		ret = -EINVAL;
@@ -1063,14 +1077,15 @@
 
 	i = 0;
 	/* Choose the copy that is on our node */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	loc_cpu_entry = private->entries[cpu];
 	IPT_ENTRY_ITERATE(loc_cpu_entry,
 			  private->size,
 			  add_counter_to_entry,
 			  paddc->counters,
 			  &i);
  unlock_up_free:
-	write_unlock_bh(&t->lock);
+	write_unlock_bh(xt_table_lockaddr(t, cpu));
+	put_cpu();
 	xt_table_unlock(t);
 	module_put(t->me);
  free:
@@ -1215,10 +1230,12 @@
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 	void *loc_cpu_entry;
 
+	ret = xt_table_global_init(table);
+	if (ret)
+		return ret;
 	newinfo = xt_alloc_table_info(repl->size);
 	if (!newinfo)
 		return -ENOMEM;
-
 	/* choose the copy on our node/cpu
 	 * but dont care of preemption
 	 */
--- linux-2.6.16-rc1/net/netfilter/x_tables.c	2006-01-27 15:36:26.000000000 +0100
+++ linux-2.6.16-rc1-ed/net/netfilter/x_tables.c	2006-01-27 16:40:56.000000000 +0100
@@ -309,6 +309,44 @@
 }
 EXPORT_SYMBOL_GPL(xt_table_unlock);
 
+/*
+ * Dont use write_lock_bh() in the loop, because NR_CPUS
+ * might be very large and preempt_count could overflow
+ */
+static void xt_table_global_lock(struct xt_table *table)
+{
+	int cpu;
+	local_bh_disable();
+	preempt_disable();
+	for_each_cpu(cpu) {
+		_raw_write_lock(xt_table_lockaddr(table, cpu));
+	}
+}
+
+static void xt_table_global_unlock(struct xt_table *table)
+{
+	int cpu;
+	for_each_cpu(cpu) {
+		_raw_write_unlock(xt_table_lockaddr(table, cpu));
+	}
+	preempt_enable_no_resched();
+	local_bh_enable();
+}
+
+int xt_table_global_init(struct xt_table *table)
+{
+	int cpu;
+#ifdef CONFIG_SMP
+	if (!table->lockp) {
+		table->lockp = alloc_percpu(rwlock_t);
+		if (!table->lockp)
+			return -ENOMEM;
+	}
+#endif
+	for_each_cpu(cpu)
+		rwlock_init(xt_table_lockaddr(table, cpu));
+	return 0;
+}
 
 struct xt_table_info *
 xt_replace_table(struct xt_table *table,
@@ -319,20 +357,20 @@
 	struct xt_table_info *oldinfo, *private;
 
 	/* Do the substitution. */
-	write_lock_bh(&table->lock);
+	xt_table_global_lock(table);
 	private = table->private;
 	/* Check inside lock: is the old number correct? */
 	if (num_counters != private->number) {
 		duprintf("num_counters != table->private->number (%u/%u)\n",
 			 num_counters, private->number);
-		write_unlock_bh(&table->lock);
+		xt_table_global_unlock(table);
 		*error = -EAGAIN;
 		return NULL;
 	}
 	oldinfo = private;
 	table->private = newinfo;
 	newinfo->initial_entries = oldinfo->initial_entries;
-	write_unlock_bh(&table->lock);
+	xt_table_global_unlock(table);
 
 	return oldinfo;
 }
@@ -366,7 +404,6 @@
 	/* save number of initial entries */
 	private->initial_entries = private->number;
 
-	rwlock_init(&table->lock);
 	list_prepend(&xt[table->af].tables, table);
 
 	ret = 0;
--- linux-2.6.16-rc1/net/ipv4/netfilter/ip_nat_rule.c	2006-01-27 16:10:50.000000000 +0100
+++ linux-2.6.16-rc1-ed/net/ipv4/netfilter/ip_nat_rule.c	2006-01-27 16:32:11.000000000 +0100
@@ -93,7 +93,6 @@
 static struct ipt_table nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
 	.me		= THIS_MODULE,
 	.af		= AF_INET,
 };
--- linux-2.6.16-rc1/net/ipv4/netfilter/iptable_mangle.c	2006-01-27 16:11:00.000000000 +0100
+++ linux-2.6.16-rc1-ed/net/ipv4/netfilter/iptable_mangle.c	2006-01-27 16:32:11.000000000 +0100
@@ -107,7 +107,6 @@
 static struct ipt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
 	.me		= THIS_MODULE,
 	.af		= AF_INET,
 };
--- linux-2.6.16-rc1/net/ipv4/netfilter/iptable_raw.c	2006-01-27 16:11:37.000000000 +0100
+++ linux-2.6.16-rc1-ed/net/ipv4/netfilter/iptable_raw.c	2006-01-27 16:11:52.000000000 +0100
@@ -82,7 +82,6 @@
 static struct ipt_table packet_raw = { 
 	.name = "raw", 
 	.valid_hooks =  RAW_VALID_HOOKS, 
-	.lock = RW_LOCK_UNLOCKED, 
 	.me = THIS_MODULE,
 	.af = AF_INET,
 };
--- linux-2.6.16-rc1/net/ipv4/netfilter/arptable_filter.c	2006-01-27 16:20:26.000000000 +0100
+++ linux-2.6.16-rc1-ed/net/ipv4/netfilter/arptable_filter.c	2006-01-27 16:22:59.000000000 +0100
@@ -142,7 +142,6 @@
 static struct arpt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
 	.private	= NULL,
 	.me		= THIS_MODULE,
 	.af		= NF_ARP,
--- linux-2.6.16-rc1/net/ipv6/netfilter/ip6_tables.c	2006-01-27 16:21:56.000000000 +0100
+++ linux-2.6.16-rc1-ed/net/ipv6/netfilter/ip6_tables.c	2006-01-27 16:43:42.000000000 +0100
@@ -283,6 +283,8 @@
 	void *table_base;
 	struct ip6t_entry *e, *back;
 	struct xt_table_info *private;
+	int curcpu;
+	rwlock_t *lockp;
 
 	/* Initialization */
 	indev = in ? in->name : nulldevname;
@@ -294,10 +296,12 @@
 	 * rule is also a fragment-specific rule, non-fragments won't
 	 * match it. */
 
-	read_lock_bh(&table->lock);
+	curcpu = get_cpu();
+	lockp = xt_table_lockaddr(table, curcpu);
+	read_lock_bh(lockp);
 	private = table->private;
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
-	table_base = (void *)private->entries[smp_processor_id()];
+	table_base = (void *)private->entries[curcpu];
 	e = get_entry(table_base, private->hook_entry[hook]);
 
 #ifdef CONFIG_NETFILTER_DEBUG
@@ -403,7 +407,8 @@
 #ifdef CONFIG_NETFILTER_DEBUG
 	((struct ip6t_entry *)table_base)->comefrom = 0xdead57ac;
 #endif
-	read_unlock_bh(&table->lock);
+	read_unlock_bh(lockp);
+	put_cpu();
 
 #ifdef DEBUG_ALLOW_ALL
 	return NF_ACCEPT;
@@ -825,7 +830,8 @@
 
 static void
 get_counters(const struct xt_table_info *t,
-	     struct xt_counters counters[])
+	     struct xt_counters counters[],
+		struct xt_table *table)
 {
 	unsigned int cpu;
 	unsigned int i;
@@ -834,26 +840,34 @@
 	/* Instead of clearing (by a previous call to memset())
 	 * the counters and using adds, we set the counters
 	 * with data used by 'current' CPU
-	 * We dont care about preemption here.
 	 */
-	curcpu = raw_smp_processor_id();
+	curcpu = get_cpu();
 
+	if (table)
+		write_lock_bh(xt_table_lockaddr(table, curcpu));
 	i = 0;
 	IP6T_ENTRY_ITERATE(t->entries[curcpu],
 			   t->size,
 			   set_entry_to_counter,
 			   counters,
 			   &i);
+	if (table)
+		write_unlock_bh(xt_table_lockaddr(table, curcpu));
+	put_cpu();
 
 	for_each_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
+		if (table)
+			write_lock_bh(xt_table_lockaddr(table, cpu));
 		i = 0;
 		IP6T_ENTRY_ITERATE(t->entries[cpu],
 				  t->size,
 				  add_entry_to_counter,
 				  counters,
 				  &i);
+		if (table)
+			write_unlock_bh(xt_table_lockaddr(table, cpu));
 	}
 }
 
@@ -879,9 +893,7 @@
 		return -ENOMEM;
 
 	/* First, sum counters... */
-	write_lock_bh(&table->lock);
-	get_counters(private, counters);
-	write_unlock_bh(&table->lock);
+	get_counters(private, counters, table);
 
 	/* choose the copy that is on ourc node/cpu */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
@@ -1034,7 +1046,7 @@
 		module_put(t->me);
 
 	/* Get the old counters. */
-	get_counters(oldinfo, counters);
+	get_counters(oldinfo, counters, NULL);
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
 	IP6T_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,NULL);
@@ -1089,6 +1101,7 @@
 	struct xt_table *t;
 	int ret = 0;
 	void *loc_cpu_entry;
+	int cpu;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
@@ -1111,7 +1124,8 @@
 		goto free;
 	}
 
-	write_lock_bh(&t->lock);
+	cpu = get_cpu();
+	write_lock_bh(xt_table_lockaddr(t, cpu));
 	private = t->private;
 	if (private->number != paddc->num_counters) {
 		ret = -EINVAL;
@@ -1120,14 +1134,15 @@
 
 	i = 0;
 	/* Choose the copy that is on our node */
-	loc_cpu_entry = private->entries[smp_processor_id()];
+	loc_cpu_entry = private->entries[cpu];
 	IP6T_ENTRY_ITERATE(loc_cpu_entry,
 			  private->size,
 			  add_counter_to_entry,
 			  paddc->counters,
 			  &i);
  unlock_up_free:
-	write_unlock_bh(&t->lock);
+	write_unlock_bh(xt_table_lockaddr(t, cpu));
+	put_cpu();
 	xt_table_unlock(t);
 	module_put(t->me);
  free:
--- linux-2.6.16-rc1/net/ipv6/netfilter/ip6table_filter.c	2006-01-27 16:25:54.000000000 +0100
+++ linux-2.6.16-rc1-ed/net/ipv6/netfilter/ip6table_filter.c	2006-01-27 16:26:05.000000000 +0100
@@ -95,7 +95,6 @@
 static struct ip6t_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
-	.lock		= RW_LOCK_UNLOCKED,
 	.me		= THIS_MODULE,
 	.af		= AF_INET6,
 };
--- linux-2.6.16-rc1/net/ipv6/netfilter/ip6table_raw.c	2006-01-27 16:26:57.000000000 +0100
+++ linux-2.6.16-rc1-ed/net/ipv6/netfilter/ip6table_raw.c	2006-01-27 16:27:12.000000000 +0100
@@ -109,7 +109,6 @@
 static struct xt_table packet_raw = { 
 	.name = "raw", 
 	.valid_hooks = RAW_VALID_HOOKS, 
-	.lock = RW_LOCK_UNLOCKED, 
 	.me = THIS_MODULE,
 	.af = AF_INET6,
 };

--------------090105040603070102090509--
