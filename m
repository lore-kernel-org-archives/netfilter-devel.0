From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Thu, 13 Oct 2005 14:14:08 -0700 (PDT)
Message-ID: <20051013.141408.99857789.davem@davemloft.net>
References: <20051012.155419.36023860.davem@davemloft.net>
	<E1EPyj0-0001dx-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	bdschuym@pandora.be, seb@frankengul.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: herbert@gondor.apana.org.au
In-Reply-To: <E1EPyj0-0001dx-00@gondolin.me.apana.org.au>
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

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 13 Oct 2005 18:46:06 +1000

> > +/* Find the highest possible smp_processor_id() */
> > +static inline unsigned int highest_possible_processor_id(void)
> > +{
> > +       unsigned int cpu, highest = 0;
> > +
> > +       for_each_cpu_mask(cpu, cpu_possible_map) {
> > +               if (cpu > highest)
> > +                       highest = cpu;
> > +       }
> > +
> > +       return highest;
> > +}
> 
> In the mean time we can at least kill the (cpu > highest) check since
> cpu is monotonically increasing.

Correct.

> > @@ -893,11 +895,8 @@ static void get_counters(struct ebt_coun
> >        int i, cpu;
> >        struct ebt_counter *counter_base;
> > 
> > -       /* counters of cpu 0 */
> > -       memcpy(counters, oldcounters,
> > -          sizeof(struct ebt_counter) * nentries);
> >        /* add other counters to those of cpu 0 */
> > -       for (cpu = 1; cpu < num_possible_cpus(); cpu++) {
> > +       for_each_cpu(cpu) {
> >                counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
> >                for (i = 0; i < nentries; i++) {
> >                        counters[i].pcnt += counter_base[i].pcnt;
> 
> I'm not sure about this.  Counters hasn't been zeroed yet, has it?

Good catch, I fixed this up to preserve the original memset(),
then do the loop like:

	for_each_cpu(cpu) {
		if (cpu == 0)
			continue;
	...

With these two fixes, the following is what I'm about to push
to Linus.

Thanks everyone.

diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 2c5cae0..957f551 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/cpumask.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 
 #define IPI_SCHEDULE 1
 #define IPI_CALL 2
@@ -28,6 +29,7 @@ spinlock_t cris_atomic_locks[] = { [0 ..
 /* CPU masks */
 cpumask_t cpu_online_map = CPU_MASK_NONE;
 cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
+EXPORT_SYMBOL(phys_cpu_present_map);
 
 /* Variables used during SMP boot */
 volatile int cpu_now_booting = 0;
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 56a39d6..5ecefc0 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -22,6 +22,7 @@
 #include <linux/time.h>
 #include <linux/timex.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 
 #include <asm/atomic.h>
 #include <asm/processor.h>
@@ -39,6 +40,8 @@ struct sh_cpuinfo cpu_data[NR_CPUS];
 extern void per_cpu_trap_init(void);
 
 cpumask_t cpu_possible_map;
+EXPORT_SYMBOL(cpu_possible_map);
+
 cpumask_t cpu_online_map;
 static atomic_t cpus_booted = ATOMIC_INIT(0);
 
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index b15826f..fe97783 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -392,4 +392,16 @@ extern cpumask_t cpu_present_map;
 #define for_each_online_cpu(cpu)  for_each_cpu_mask((cpu), cpu_online_map)
 #define for_each_present_cpu(cpu) for_each_cpu_mask((cpu), cpu_present_map)
 
+/* Find the highest possible smp_processor_id() */
+static inline unsigned int highest_possible_processor_id(void)
+{
+	unsigned int cpu, highest = 0;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		highest = cpu;
+
+	return highest;
+}
+
+
 #endif /* __LINUX_CPUMASK_H */
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index c454014..f8ffbf6 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -26,6 +26,7 @@
 #include <linux/spinlock.h>
 #include <asm/uaccess.h>
 #include <linux/smp.h>
+#include <linux/cpumask.h>
 #include <net/sock.h>
 /* needed for logical [in,out]-dev filtering */
 #include "../br_private.h"
@@ -823,10 +824,11 @@ static int translate_table(struct ebt_re
 		/* this will get free'd in do_replace()/ebt_register_table()
 		   if an error occurs */
 		newinfo->chainstack = (struct ebt_chainstack **)
-		   vmalloc(num_possible_cpus() * sizeof(struct ebt_chainstack));
+		   vmalloc((highest_possible_processor_id()+1) 
+				   		* sizeof(struct ebt_chainstack));
 		if (!newinfo->chainstack)
 			return -ENOMEM;
-		for (i = 0; i < num_possible_cpus(); i++) {
+		for_each_cpu(i) {
 			newinfo->chainstack[i] =
 			   vmalloc(udc_cnt * sizeof(struct ebt_chainstack));
 			if (!newinfo->chainstack[i]) {
@@ -895,9 +897,12 @@ static void get_counters(struct ebt_coun
 
 	/* counters of cpu 0 */
 	memcpy(counters, oldcounters,
-	   sizeof(struct ebt_counter) * nentries);
+	       sizeof(struct ebt_counter) * nentries);
+
 	/* add other counters to those of cpu 0 */
-	for (cpu = 1; cpu < num_possible_cpus(); cpu++) {
+	for_each_cpu(cpu) {
+		if (cpu == 0)
+			continue;
 		counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
 		for (i = 0; i < nentries; i++) {
 			counters[i].pcnt += counter_base[i].pcnt;
@@ -929,7 +934,8 @@ static int do_replace(void __user *user,
 		BUGPRINT("Entries_size never zero\n");
 		return -EINVAL;
 	}
-	countersize = COUNTER_OFFSET(tmp.nentries) * num_possible_cpus();
+	countersize = COUNTER_OFFSET(tmp.nentries) * 
+					(highest_possible_processor_id()+1);
 	newinfo = (struct ebt_table_info *)
 	   vmalloc(sizeof(struct ebt_table_info) + countersize);
 	if (!newinfo)
@@ -1022,7 +1028,7 @@ static int do_replace(void __user *user,
 
 	vfree(table->entries);
 	if (table->chainstack) {
-		for (i = 0; i < num_possible_cpus(); i++)
+		for_each_cpu(i)
 			vfree(table->chainstack[i]);
 		vfree(table->chainstack);
 	}
@@ -1040,7 +1046,7 @@ free_counterstmp:
 	vfree(counterstmp);
 	/* can be initialized in translate_table() */
 	if (newinfo->chainstack) {
-		for (i = 0; i < num_possible_cpus(); i++)
+		for_each_cpu(i)
 			vfree(newinfo->chainstack[i]);
 		vfree(newinfo->chainstack);
 	}
@@ -1132,7 +1138,8 @@ int ebt_register_table(struct ebt_table 
 		return -EINVAL;
 	}
 
-	countersize = COUNTER_OFFSET(table->table->nentries) * num_possible_cpus();
+	countersize = COUNTER_OFFSET(table->table->nentries) *
+					(highest_possible_processor_id()+1);
 	newinfo = (struct ebt_table_info *)
 	   vmalloc(sizeof(struct ebt_table_info) + countersize);
 	ret = -ENOMEM;
@@ -1186,7 +1193,7 @@ free_unlock:
 	up(&ebt_mutex);
 free_chainstack:
 	if (newinfo->chainstack) {
-		for (i = 0; i < num_possible_cpus(); i++)
+		for_each_cpu(i)
 			vfree(newinfo->chainstack[i]);
 		vfree(newinfo->chainstack);
 	}
@@ -1209,7 +1216,7 @@ void ebt_unregister_table(struct ebt_tab
 	up(&ebt_mutex);
 	vfree(table->private->entries);
 	if (table->private->chainstack) {
-		for (i = 0; i < num_possible_cpus(); i++)
+		for_each_cpu(i)
 			vfree(table->private->chainstack[i]);
 		vfree(table->private->chainstack);
 	}
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index fa16342..a796928 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -716,8 +716,10 @@ static int translate_table(const char *n
 	}
 
 	/* And one copy for every other CPU */
-	for (i = 1; i < num_possible_cpus(); i++) {
-		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
+	for_each_cpu(i) {
+		if (i == 0)
+			continue;
+		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size) * i,
 		       newinfo->entries,
 		       SMP_ALIGN(newinfo->size));
 	}
@@ -767,7 +769,7 @@ static void get_counters(const struct ar
 	unsigned int cpu;
 	unsigned int i;
 
-	for (cpu = 0; cpu < num_possible_cpus(); cpu++) {
+	for_each_cpu(cpu) {
 		i = 0;
 		ARPT_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
 				   t->size,
@@ -885,7 +887,8 @@ static int do_replace(void __user *user,
 		return -ENOMEM;
 
 	newinfo = vmalloc(sizeof(struct arpt_table_info)
-			  + SMP_ALIGN(tmp.size) * num_possible_cpus());
+			  + SMP_ALIGN(tmp.size) *
+			  		(highest_possible_processor_id()+1));
 	if (!newinfo)
 		return -ENOMEM;
 
@@ -1158,7 +1161,8 @@ int arpt_register_table(struct arpt_tabl
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
 	newinfo = vmalloc(sizeof(struct arpt_table_info)
-			  + SMP_ALIGN(repl->size) * num_possible_cpus());
+			  + SMP_ALIGN(repl->size) *
+			  		(highest_possible_processor_id()+1));
 	if (!newinfo) {
 		ret = -ENOMEM;
 		return ret;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index eef99a1..75c27e9 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -27,6 +27,7 @@
 #include <asm/semaphore.h>
 #include <linux/proc_fs.h>
 #include <linux/err.h>
+#include <linux/cpumask.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 
@@ -921,8 +922,10 @@ translate_table(const char *name,
 	}
 
 	/* And one copy for every other CPU */
-	for (i = 1; i < num_possible_cpus(); i++) {
-		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
+	for_each_cpu(i) {
+		if (i == 0)
+			continue;
+		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size) * i,
 		       newinfo->entries,
 		       SMP_ALIGN(newinfo->size));
 	}
@@ -943,7 +946,7 @@ replace_table(struct ipt_table *table,
 		struct ipt_entry *table_base;
 		unsigned int i;
 
-		for (i = 0; i < num_possible_cpus(); i++) {
+		for_each_cpu(i) {
 			table_base =
 				(void *)newinfo->entries
 				+ TABLE_OFFSET(newinfo, i);
@@ -990,7 +993,7 @@ get_counters(const struct ipt_table_info
 	unsigned int cpu;
 	unsigned int i;
 
-	for (cpu = 0; cpu < num_possible_cpus(); cpu++) {
+	for_each_cpu(cpu) {
 		i = 0;
 		IPT_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
 				  t->size,
@@ -1128,7 +1131,8 @@ do_replace(void __user *user, unsigned i
 		return -ENOMEM;
 
 	newinfo = vmalloc(sizeof(struct ipt_table_info)
-			  + SMP_ALIGN(tmp.size) * num_possible_cpus());
+			  + SMP_ALIGN(tmp.size) * 
+			  	(highest_possible_processor_id()+1));
 	if (!newinfo)
 		return -ENOMEM;
 
@@ -1458,7 +1462,8 @@ int ipt_register_table(struct ipt_table 
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
 	newinfo = vmalloc(sizeof(struct ipt_table_info)
-			  + SMP_ALIGN(repl->size) * num_possible_cpus());
+			  + SMP_ALIGN(repl->size) * 
+			  		(highest_possible_processor_id()+1));
 	if (!newinfo)
 		return -ENOMEM;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2da514b..b03e906 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -28,6 +28,7 @@
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 #include <linux/proc_fs.h>
+#include <linux/cpumask.h>
 
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
@@ -950,8 +951,10 @@ translate_table(const char *name,
 	}
 
 	/* And one copy for every other CPU */
-	for (i = 1; i < num_possible_cpus(); i++) {
-		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
+	for_each_cpu(i) {
+		if (i == 0)
+			continue;
+		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size) * i,
 		       newinfo->entries,
 		       SMP_ALIGN(newinfo->size));
 	}
@@ -973,6 +976,7 @@ replace_table(struct ip6t_table *table,
 		unsigned int i;
 
 		for (i = 0; i < num_possible_cpus(); i++) {
+		for_each_cpu(i) {
 			table_base =
 				(void *)newinfo->entries
 				+ TABLE_OFFSET(newinfo, i);
@@ -1019,7 +1023,7 @@ get_counters(const struct ip6t_table_inf
 	unsigned int cpu;
 	unsigned int i;
 
-	for (cpu = 0; cpu < num_possible_cpus(); cpu++) {
+	for_each_cpu(cpu) {
 		i = 0;
 		IP6T_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
 				  t->size,
@@ -1153,7 +1157,8 @@ do_replace(void __user *user, unsigned i
 		return -ENOMEM;
 
 	newinfo = vmalloc(sizeof(struct ip6t_table_info)
-			  + SMP_ALIGN(tmp.size) * num_possible_cpus());
+			  + SMP_ALIGN(tmp.size) *
+			  		(highest_possible_processor_id()+1));
 	if (!newinfo)
 		return -ENOMEM;
 
@@ -1467,7 +1472,8 @@ int ip6t_register_table(struct ip6t_tabl
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
 	newinfo = vmalloc(sizeof(struct ip6t_table_info)
-			  + SMP_ALIGN(repl->size) * num_possible_cpus());
+			  + SMP_ALIGN(repl->size) *
+			  		(highest_possible_processor_id()+1));
 	if (!newinfo)
 		return -ENOMEM;
 
