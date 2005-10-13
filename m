From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Fri, 14 Oct 2005 00:01:13 +0200
Message-ID: <434ED929.4030207@cosmosbay.com>
References: <Pine.LNX.4.61.0510111550170.2575@filer.marasystems.com>	<434BC86F.3090506@cosmosbay.com>	<20051011174556.GA13415@rama.de.gnumonks.org>
	<20051011.155733.05623834.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040702010003080704030506"
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	hno@marasystems.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20051011.155733.05623834.davem@davemloft.net>
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
--------------040702010003080704030506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

David S. Miller a =E9crit :
> From: Harald Welte <laforge@netfilter.org>
> Date: Tue, 11 Oct 2005 19:45:56 +0200
>=20
>=20
>>Eric, I still have your patches on hold and hope that vmalloc_node will
>>eventually appear.  I don't really like the idea of adding code to
>>iptables that has to go knee-deep into the vm code....  So once
>>vmalloc_node() is there, I'm open to merging your changes.
>=20
>=20
> After thinking about this a bit, what I'm trying to do now is
> champion getting the vmalloc_node() patch into 2.6.14 so we
> can use Eric's approach to fix this bug cleanly.
>=20
> Attached is the current version of the vmalloc_node() patch.
> Eric, can you send me an updated copy of your patch, such
> that it uses this vmalloc_node() instead of the mempolicy
> hacks it had previously?
>=20
> If this fails, I'm afraid we might need to go with the NR_CPUS
> option for now as much as I'd really really hate to do that.
>=20
> Thanks.

Hi David, sorry for being late, I was traveling these last two days.

Here is the patch, depending on the fact that a vmalloc_node() already ex=
ists.
(If not, just replace vmalloc_node() call by vmalloc())

[PATCH] iptables : SMP/NUMA allocation, and elimination of a problem with=
=20
discontiguous processor ids.


Part of the performance problem we have with netfilter is memory allocati=
on
is not NUMA aware, but 'only' SMP aware (ie each CPU normally touch
separate cache lines)

Even with small iptables rules, the cost of this misplacement can be high
  on common workloads.

Instead of using one vmalloc() area (located in the node of the iptables
process), we now allocate an area for each possible CPU, using vmalloc_no=
de()=20
so that memory should be allocated in the CPU's node if possible.

If the size of ipt_table is small enough (less than one page), we use
kmalloc_node() instead of vmalloc_node(), to use less memory and less TLB=
=20
entries) for small setups.

Please note that this patch doesnt increase the number of allocated bytes=
,=20
only the location of allocated zones. For machines where processors id ma=
y be=20
discontiguous, only needed memory is allocated.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--------------040702010003080704030506
Content-Type: text/plain;
 name="patch_iptables.4"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch_iptables.4"

--- linux-2.6.14-rc4/net/ipv4/netfilter/ip_tables.c	2005-10-11 03:19:19.000000000 +0200
+++ linux-2.6.14-rc4-ed/net/ipv4/netfilter/ip_tables.c	2005-10-14 01:52:14.000000000 +0200
@@ -82,11 +82,6 @@
    context stops packets coming through and allows user context to read
    the counters or update the rules.
 
-   To be cache friendly on SMP, we arrange them like so:
-   [ n-entries ]
-   ... cache-align padding ...
-   [ n-entries ]
-
    Hence the start of any table is given by get_table() below.  */
 
 /* The table itself */
@@ -104,20 +99,15 @@
 	unsigned int underflow[NF_IP_NUMHOOKS];
 
 	/* ipt_entry tables: one per CPU */
-	char entries[0] ____cacheline_aligned;
+	void *entries[NR_CPUS];
 };
 
 static LIST_HEAD(ipt_target);
 static LIST_HEAD(ipt_match);
 static LIST_HEAD(ipt_tables);
+#define SET_COUNTER(c,b,p) do { (c).bcnt = (b); (c).pcnt = (p); } while(0)
 #define ADD_COUNTER(c,b,p) do { (c).bcnt += (b); (c).pcnt += (p); } while(0)
 
-#ifdef CONFIG_SMP
-#define TABLE_OFFSET(t,p) (SMP_ALIGN((t)->size)*(p))
-#else
-#define TABLE_OFFSET(t,p) 0
-#endif
-
 #if 0
 #define down(x) do { printk("DOWN:%u:" #x "\n", __LINE__); down(x); } while(0)
 #define down_interruptible(x) ({ int __r; printk("DOWNi:%u:" #x "\n", __LINE__); __r = down_interruptible(x); if (__r != 0) printk("ABORT-DOWNi:%u\n", __LINE__); __r; })
@@ -289,8 +279,7 @@
 
 	read_lock_bh(&table->lock);
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
-	table_base = (void *)table->private->entries
-		+ TABLE_OFFSET(table->private, smp_processor_id());
+	table_base = (void *)table->private->entries[smp_processor_id()];
 	e = get_entry(table_base, table->private->hook_entry[hook]);
 
 #ifdef CONFIG_NETFILTER_DEBUG
@@ -562,7 +551,8 @@
 /* Figures out from what hook each rule can be called: returns 0 if
    there are loops.  Puts hook bitmask in comefrom. */
 static int
-mark_source_chains(struct ipt_table_info *newinfo, unsigned int valid_hooks)
+mark_source_chains(struct ipt_table_info *newinfo,
+	unsigned int valid_hooks, void *entry0)
 {
 	unsigned int hook;
 
@@ -571,7 +561,7 @@
 	for (hook = 0; hook < NF_IP_NUMHOOKS; hook++) {
 		unsigned int pos = newinfo->hook_entry[hook];
 		struct ipt_entry *e
-			= (struct ipt_entry *)(newinfo->entries + pos);
+			= (struct ipt_entry *)(entry0 + pos);
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
@@ -621,13 +611,13 @@
 						goto next;
 
 					e = (struct ipt_entry *)
-						(newinfo->entries + pos);
+						(entry0 + pos);
 				} while (oldpos == pos + e->next_offset);
 
 				/* Move along one */
 				size = e->next_offset;
 				e = (struct ipt_entry *)
-					(newinfo->entries + pos + size);
+					(entry0 + pos + size);
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
@@ -644,7 +634,7 @@
 					newpos = pos + e->next_offset;
 				}
 				e = (struct ipt_entry *)
-					(newinfo->entries + newpos);
+					(entry0 + newpos);
 				e->counters.pcnt = pos;
 				pos = newpos;
 			}
@@ -854,6 +844,7 @@
 translate_table(const char *name,
 		unsigned int valid_hooks,
 		struct ipt_table_info *newinfo,
+		void *entry0,
 		unsigned int size,
 		unsigned int number,
 		const unsigned int *hook_entries,
@@ -874,11 +865,11 @@
 	duprintf("translate_table: size %u\n", newinfo->size);
 	i = 0;
 	/* Walk through entries, checking offsets. */
-	ret = IPT_ENTRY_ITERATE(newinfo->entries, newinfo->size,
+	ret = IPT_ENTRY_ITERATE(entry0, newinfo->size,
 				check_entry_size_and_hooks,
 				newinfo,
-				newinfo->entries,
-				newinfo->entries + size,
+				entry0,
+				entry0 + size,
 				hook_entries, underflows, &i);
 	if (ret != 0)
 		return ret;
@@ -906,25 +897,24 @@
 		}
 	}
 
-	if (!mark_source_chains(newinfo, valid_hooks))
+	if (!mark_source_chains(newinfo, valid_hooks, entry0))
 		return -ELOOP;
 
 	/* Finally, each sanity check must pass */
 	i = 0;
-	ret = IPT_ENTRY_ITERATE(newinfo->entries, newinfo->size,
+	ret = IPT_ENTRY_ITERATE(entry0, newinfo->size,
 				check_entry, name, size, &i);
 
 	if (ret != 0) {
-		IPT_ENTRY_ITERATE(newinfo->entries, newinfo->size,
+		IPT_ENTRY_ITERATE(entry0, newinfo->size,
 				  cleanup_entry, &i);
 		return ret;
 	}
 
 	/* And one copy for every other CPU */
-	for (i = 1; i < num_possible_cpus(); i++) {
-		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
-		       newinfo->entries,
-		       SMP_ALIGN(newinfo->size));
+	for_each_cpu(i) {
+		if (newinfo->entries[i] && newinfo->entries[i] != entry0)
+			memcpy(newinfo->entries[i], entry0, newinfo->size);
 	}
 
 	return ret;
@@ -940,15 +930,12 @@
 
 #ifdef CONFIG_NETFILTER_DEBUG
 	{
-		struct ipt_entry *table_base;
-		unsigned int i;
+		int cpu;
 
-		for (i = 0; i < num_possible_cpus(); i++) {
-			table_base =
-				(void *)newinfo->entries
-				+ TABLE_OFFSET(newinfo, i);
-
-			table_base->comefrom = 0xdead57ac;
+		for_each_cpu(cpu) {
+			struct ipt_entry *table_base = newinfo->entries[cpu];
+			if (table_base)
+				table_base->comefrom = 0xdead57ac;
 		}
 	}
 #endif
@@ -983,21 +970,51 @@
 	return 0;
 }
 
+static inline int
+set_entry_to_counter(const struct ipt_entry *e,
+		     struct ipt_counters total[],
+		     unsigned int *i)
+{
+	SET_COUNTER(total[*i], e->counters.bcnt, e->counters.pcnt);
+
+	(*i)++;
+	return 0;
+}
+
 static void
 get_counters(const struct ipt_table_info *t,
 	     struct ipt_counters counters[])
 {
 	unsigned int cpu;
 	unsigned int i;
+	unsigned int curcpu = get_cpu();
+
+	/*
+	 * Instead of clearing (by a previous call to memset())
+	 * the counters and using adds, we set the counters
+	 * with data used by our CPU
+	 */
+	i = 0;
+	IPT_ENTRY_ITERATE(t->entries[curcpu],
+			  t->size,
+			  set_entry_to_counter,
+			  counters,
+			  &i);
 
-	for (cpu = 0; cpu < num_possible_cpus(); cpu++) {
+	/*
+	 * Then for every other CPUS, we add their counters
+	 */
+	for_each_cpu(cpu) {
+		if (cpu == curcpu)
+			continue;
 		i = 0;
-		IPT_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
+		IPT_ENTRY_ITERATE(t->entries[cpu],
 				  t->size,
 				  add_entry_to_counter,
 				  counters,
 				  &i);
 	}
+	put_cpu();
 }
 
 static int
@@ -1009,6 +1026,7 @@
 	struct ipt_entry *e;
 	struct ipt_counters *counters;
 	int ret = 0;
+	void *loc_cpu_entry;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -1020,13 +1038,16 @@
 		return -ENOMEM;
 
 	/* First, sum counters... */
-	memset(counters, 0, countersize);
 	write_lock_bh(&table->lock);
 	get_counters(table->private, counters);
 	write_unlock_bh(&table->lock);
 
-	/* ... then copy entire thing from CPU 0... */
-	if (copy_to_user(userptr, table->private->entries, total_size) != 0) {
+	/*
+	 * choose the copy that is on our node/cpu,
+	 */
+	loc_cpu_entry = table->private->entries[get_cpu()];
+	/* ... then copy entire thing ... */
+	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
 		ret = -EFAULT;
 		goto free_counters;
 	}
@@ -1038,7 +1059,7 @@
 		struct ipt_entry_match *m;
 		struct ipt_entry_target *t;
 
-		e = (struct ipt_entry *)(table->private->entries + off);
+		e = (struct ipt_entry *)(loc_cpu_entry + off);
 		if (copy_to_user(userptr + off
 				 + offsetof(struct ipt_entry, counters),
 				 &counters[num],
@@ -1075,6 +1096,7 @@
 	}
 
  free_counters:
+	put_cpu();
 	vfree(counters);
 	return ret;
 }
@@ -1107,6 +1129,42 @@
 	return ret;
 }
 
+static void free_table_info(struct ipt_table_info *info)
+{
+	int cpu;
+	for_each_cpu(cpu) {
+		if (info->size <= PAGE_SIZE)
+			kfree(info->entries[cpu]);
+		else
+			vfree(info->entries[cpu]);
+	}
+	kfree(info);
+}
+
+static struct ipt_table_info *alloc_table_info(unsigned int size)
+{
+struct ipt_table_info *newinfo;
+int cpu;
+	newinfo = kzalloc(sizeof(struct ipt_table_info), GFP_KERNEL);
+	if (!newinfo)
+		return NULL;
+	newinfo->size = size;
+	for_each_cpu(cpu) {
+		if (size <= PAGE_SIZE)
+			newinfo->entries[cpu] = kmalloc_node(size,
+				GFP_KERNEL,
+				cpu_to_node(cpu));
+		else
+			newinfo->entries[cpu] = vmalloc_node(size, cpu_to_node(cpu));
+		if (newinfo->entries[cpu] == 0) {
+			free_table_info(newinfo);
+			return NULL;
+		}
+	}
+	return newinfo;
+}
+
+
 static int
 do_replace(void __user *user, unsigned int len)
 {
@@ -1115,6 +1173,7 @@
 	struct ipt_table *t;
 	struct ipt_table_info *newinfo, *oldinfo;
 	struct ipt_counters *counters;
+	void *loc_cpu_entry, *loc_cpu_old_entry;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
@@ -1127,12 +1186,14 @@
 	if ((SMP_ALIGN(tmp.size) >> PAGE_SHIFT) + 2 > num_physpages)
 		return -ENOMEM;
 
-	newinfo = vmalloc(sizeof(struct ipt_table_info)
-			  + SMP_ALIGN(tmp.size) * num_possible_cpus());
+	newinfo = alloc_table_info(tmp.size);
 	if (!newinfo)
 		return -ENOMEM;
-
-	if (copy_from_user(newinfo->entries, user + sizeof(tmp),
+	/*
+	 * choose the copy that is on our node/cpu
+	 */
+	loc_cpu_entry = newinfo->entries[get_cpu()];
+	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
 		ret = -EFAULT;
 		goto free_newinfo;
@@ -1143,10 +1204,9 @@
 		ret = -ENOMEM;
 		goto free_newinfo;
 	}
-	memset(counters, 0, tmp.num_counters * sizeof(struct ipt_counters));
 
 	ret = translate_table(tmp.name, tmp.valid_hooks,
-			      newinfo, tmp.size, tmp.num_entries,
+			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
 			      tmp.hook_entry, tmp.underflow);
 	if (ret != 0)
 		goto free_newinfo_counters;
@@ -1185,8 +1245,10 @@
 	/* Get the old counters. */
 	get_counters(oldinfo, counters);
 	/* Decrease module usage counts and free resource */
-	IPT_ENTRY_ITERATE(oldinfo->entries, oldinfo->size, cleanup_entry,NULL);
-	vfree(oldinfo);
+	loc_cpu_old_entry = oldinfo->entries[smp_processor_id()];
+	IPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,NULL);
+	put_cpu();
+	free_table_info(oldinfo);
 	if (copy_to_user(tmp.counters, counters,
 			 sizeof(struct ipt_counters) * tmp.num_counters) != 0)
 		ret = -EFAULT;
@@ -1198,11 +1260,12 @@
 	module_put(t->me);
 	up(&ipt_mutex);
  free_newinfo_counters_untrans:
-	IPT_ENTRY_ITERATE(newinfo->entries, newinfo->size, cleanup_entry,NULL);
+	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry,NULL);
  free_newinfo_counters:
 	vfree(counters);
  free_newinfo:
-	vfree(newinfo);
+	put_cpu();
+	free_table_info(newinfo);
 	return ret;
 }
 
@@ -1235,6 +1298,7 @@
 	struct ipt_counters_info tmp, *paddc;
 	struct ipt_table *t;
 	int ret = 0;
+	void *loc_cpu_entry;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
@@ -1264,7 +1328,11 @@
 	}
 
 	i = 0;
-	IPT_ENTRY_ITERATE(t->private->entries,
+	/*
+	 * Choose the copy that is on our node
+	 */
+	loc_cpu_entry = t->private->entries[smp_processor_id()];
+	IPT_ENTRY_ITERATE(loc_cpu_entry,
 			  t->private->size,
 			  add_counter_to_entry,
 			  paddc->counters,
@@ -1456,27 +1524,32 @@
 	struct ipt_table_info *newinfo;
 	static struct ipt_table_info bootstrap
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
+	void *loc_cpu_entry;
 
-	newinfo = vmalloc(sizeof(struct ipt_table_info)
-			  + SMP_ALIGN(repl->size) * num_possible_cpus());
+	newinfo = alloc_table_info(repl->size);
 	if (!newinfo)
 		return -ENOMEM;
 
-	memcpy(newinfo->entries, repl->entries, repl->size);
+	/*
+	 * choose the copy that is on our node/cpu
+	 */
+	loc_cpu_entry = newinfo->entries[get_cpu()];
+	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
 	ret = translate_table(table->name, table->valid_hooks,
-			      newinfo, repl->size,
+			      newinfo, loc_cpu_entry, repl->size,
 			      repl->num_entries,
 			      repl->hook_entry,
 			      repl->underflow);
+	put_cpu();
 	if (ret != 0) {
-		vfree(newinfo);
+		free_table_info(newinfo);
 		return ret;
 	}
 
 	ret = down_interruptible(&ipt_mutex);
 	if (ret != 0) {
-		vfree(newinfo);
+		free_table_info(newinfo);
 		return ret;
 	}
 
@@ -1505,20 +1578,26 @@
 	return ret;
 
  free_unlock:
-	vfree(newinfo);
+	free_table_info(newinfo);
 	goto unlock;
 }
 
 void ipt_unregister_table(struct ipt_table *table)
 {
+	void *loc_cpu_entry;
 	down(&ipt_mutex);
 	LIST_DELETE(&ipt_tables, table);
 	up(&ipt_mutex);
 
-	/* Decrease module usage counts and free resources */
-	IPT_ENTRY_ITERATE(table->private->entries, table->private->size,
+	/*
+	 * Decrease module usage counts and free resources
+	 * Choose the copy that is on our node/cpu
+	 */
+	loc_cpu_entry = table->private->entries[get_cpu()];
+	IPT_ENTRY_ITERATE(loc_cpu_entry, table->private->size,
 			  cleanup_entry, NULL);
-	vfree(table->private);
+	put_cpu();
+	free_table_info(table->private);
 }
 
 /* Returns 1 if the port is matched by the range, 0 otherwise */

--------------040702010003080704030506--
