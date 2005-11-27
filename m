From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: zap get_cpu()/put_cpu() calls from ip_tables
Date: Sun, 27 Nov 2005 01:15:30 +0100
Message-ID: <4388FAA2.5010708@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070806010700050804000300"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------070806010700050804000300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes the problems with the iptables NUMA optimization.
It applies to the net-2.6.16 tree.

--------------070806010700050804000300
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: zap get_cpu()/put_cpu() calls from ip_tables

The problem is that get_cpu() disables preemption and the thread is not
allowed to sleep.

As the intent was only to give a hint, relax the enforcement and switch to
a hint: If the current thread is preempted and migrated to another cpu,
this is not a problem. Most of the time, thread wont be migrated anyway.

This patch removes get_cpu()/put_cpu() pairs and uses
raw_smp_processor_id() where appropriate.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 34166a04163effbc5403dc4017ec00429a320013
tree 114a6a1b8689cb0470ed5352e53343ba12f45908
parent d32dd2a3a88f4577033e06cc83319ccb484800e7
author Eric Dumazet <dada1@cosmosbay.com> Sun, 27 Nov 2005 01:14:08 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 27 Nov 2005 01:14:08 +0100

 net/ipv4/netfilter/arp_tables.c |   24 +++++++++++-------------
 net/ipv4/netfilter/ip_tables.c  |   38 ++++++++++++++++++++------------------
 net/ipv6/netfilter/ip6_tables.c |   23 ++++++++++-------------
 3 files changed, 41 insertions(+), 44 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f8be250..54cdb18 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -814,11 +814,14 @@ static void get_counters(const struct ar
 {
 	unsigned int cpu;
 	unsigned int i;
-	unsigned int curcpu = get_cpu();
+	unsigned int curcpu;
 
 	/* Instead of clearing (by a previous call to memset())
 	 * the counters and using adds, we set the counters
-	 * with data used by current CPU */
+	 * with data used by 'current' CPU
+	 * We dont care about preemption here.
+	 */
+	curcpu = raw_smp_processor_id();
 
 	i = 0;
 	ARPT_ENTRY_ITERATE(t->entries[curcpu],
@@ -837,7 +840,6 @@ static void get_counters(const struct ar
 				   counters,
 				   &i);
 	}
-	put_cpu();
 }
 
 static int copy_entries_to_user(unsigned int total_size,
@@ -865,7 +867,7 @@ static int copy_entries_to_user(unsigned
 	get_counters(table->private, counters);
 	write_unlock_bh(&table->lock);
 
-	loc_cpu_entry = table->private->entries[get_cpu()];
+	loc_cpu_entry = table->private->entries[raw_smp_processor_id()];
 	/* ... then copy entire thing ... */
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
 		ret = -EFAULT;
@@ -898,7 +900,6 @@ static int copy_entries_to_user(unsigned
 	}
 
  free_counters:
-	put_cpu();
 	vfree(counters);
 	return ret;
 }
@@ -996,7 +997,7 @@ static int do_replace(void __user *user,
 		return -ENOMEM;
 
 	/* choose the copy that is on our node/cpu */
-	loc_cpu_entry = newinfo->entries[get_cpu()];
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
 		ret = -EFAULT;
@@ -1049,9 +1050,9 @@ static int do_replace(void __user *user,
 	/* Get the old counters. */
 	get_counters(oldinfo, counters);
 	/* Decrease module usage counts and free resource */
-	loc_cpu_old_entry = oldinfo->entries[smp_processor_id()];
+	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
 	ARPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,NULL);
-	put_cpu();
+
 	free_table_info(oldinfo);
 	if (copy_to_user(tmp.counters, counters,
 			 sizeof(struct arpt_counters) * tmp.num_counters) != 0)
@@ -1068,7 +1069,6 @@ static int do_replace(void __user *user,
  free_newinfo_counters:
 	vfree(counters);
  free_newinfo:
-	put_cpu();
 	free_table_info(newinfo);
 	return ret;
 }
@@ -1295,7 +1295,7 @@ int arpt_register_table(struct arpt_tabl
 	}
 
 	/* choose the copy on our node/cpu */
-	loc_cpu_entry = newinfo->entries[get_cpu()];
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
 	ret = translate_table(table->name, table->valid_hooks,
@@ -1303,7 +1303,6 @@ int arpt_register_table(struct arpt_tabl
 			      repl->num_entries,
 			      repl->hook_entry,
 			      repl->underflow);
-	put_cpu();
 	duprintf("arpt_register_table: translate table gives %d\n", ret);
 	if (ret != 0) {
 		free_table_info(newinfo);
@@ -1354,10 +1353,9 @@ void arpt_unregister_table(struct arpt_t
 	up(&arpt_mutex);
 
 	/* Decrease module usage counts and free resources */
-	loc_cpu_entry = table->private->entries[get_cpu()];
+	loc_cpu_entry = table->private->entries[raw_smp_processor_id()];
 	ARPT_ENTRY_ITERATE(loc_cpu_entry, table->private->size,
 			   cleanup_entry, NULL);
-	put_cpu();
 	free_table_info(table->private);
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 091bc1c..5dfae80 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -988,11 +988,14 @@ get_counters(const struct ipt_table_info
 {
 	unsigned int cpu;
 	unsigned int i;
-	unsigned int curcpu = get_cpu();
+	unsigned int curcpu;
 
 	/* Instead of clearing (by a previous call to memset())
 	 * the counters and using adds, we set the counters
-	 * with data used by current CPU */
+	 * with data used by 'current' CPU
+	 * We dont care about preemption here.
+	 */
+	curcpu = raw_smp_processor_id();
 
 	i = 0;
 	IPT_ENTRY_ITERATE(t->entries[curcpu],
@@ -1011,7 +1014,6 @@ get_counters(const struct ipt_table_info
 				  counters,
 				  &i);
 	}
-	put_cpu();
 }
 
 static int
@@ -1029,7 +1031,7 @@ copy_entries_to_user(unsigned int total_
 	   (other than comefrom, which userspace doesn't care
 	   about). */
 	countersize = sizeof(struct ipt_counters) * table->private->number;
-	counters = vmalloc(countersize);
+	counters = vmalloc_node(countersize, numa_node_id());
 
 	if (counters == NULL)
 		return -ENOMEM;
@@ -1039,8 +1041,11 @@ copy_entries_to_user(unsigned int total_
 	get_counters(table->private, counters);
 	write_unlock_bh(&table->lock);
 
-	/* choose the copy that is on our node/cpu, ... */
-	loc_cpu_entry = table->private->entries[get_cpu()];
+	/* choose the copy that is on our node/cpu, ...
+	 * This choice is lazy (because current thread is
+	 * allowed to migrate to another cpu)
+	 */
+	loc_cpu_entry = table->private->entries[raw_smp_processor_id()];
 	/* ... then copy entire thing ... */
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
 		ret = -EFAULT;
@@ -1091,7 +1096,6 @@ copy_entries_to_user(unsigned int total_
 	}
 
  free_counters:
-	put_cpu();
 	vfree(counters);
 	return ret;
 }
@@ -1189,7 +1193,7 @@ do_replace(void __user *user, unsigned i
 		return -ENOMEM;
 
 	/* choose the copy that is our node/cpu */
-	loc_cpu_entry = newinfo->entries[get_cpu()];
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
 		ret = -EFAULT;
@@ -1242,9 +1246,8 @@ do_replace(void __user *user, unsigned i
 	/* Get the old counters. */
 	get_counters(oldinfo, counters);
 	/* Decrease module usage counts and free resource */
-	loc_cpu_old_entry = oldinfo->entries[smp_processor_id()];
+	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
 	IPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,NULL);
-	put_cpu();
 	free_table_info(oldinfo);
 	if (copy_to_user(tmp.counters, counters,
 			 sizeof(struct ipt_counters) * tmp.num_counters) != 0)
@@ -1261,7 +1264,6 @@ do_replace(void __user *user, unsigned i
  free_newinfo_counters:
 	vfree(counters);
  free_newinfo:
-	put_cpu();
 	free_table_info(newinfo);
 	return ret;
 }
@@ -1303,7 +1305,7 @@ do_add_counters(void __user *user, unsig
 	if (len != sizeof(tmp) + tmp.num_counters*sizeof(struct ipt_counters))
 		return -EINVAL;
 
-	paddc = vmalloc(len);
+	paddc = vmalloc_node(len, numa_node_id());
 	if (!paddc)
 		return -ENOMEM;
 
@@ -1326,7 +1328,7 @@ do_add_counters(void __user *user, unsig
 
 	i = 0;
 	/* Choose the copy that is on our node */
-	loc_cpu_entry = t->private->entries[smp_processor_id()];
+	loc_cpu_entry = t->private->entries[raw_smp_processor_id()];
 	IPT_ENTRY_ITERATE(loc_cpu_entry,
 			  t->private->size,
 			  add_counter_to_entry,
@@ -1525,8 +1527,10 @@ int ipt_register_table(struct ipt_table 
 	if (!newinfo)
 		return -ENOMEM;
 
-	/* choose the copy on our node/cpu */
-	loc_cpu_entry = newinfo->entries[get_cpu()];
+	/* choose the copy on our node/cpu
+	 * but dont care of preemption
+	 */
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
 	ret = translate_table(table->name, table->valid_hooks,
@@ -1534,7 +1538,6 @@ int ipt_register_table(struct ipt_table 
 			      repl->num_entries,
 			      repl->hook_entry,
 			      repl->underflow);
-	put_cpu();
 	if (ret != 0) {
 		free_table_info(newinfo);
 		return ret;
@@ -1584,10 +1587,9 @@ void ipt_unregister_table(struct ipt_tab
 	up(&ipt_mutex);
 
 	/* Decrease module usage counts and free resources */
-	loc_cpu_entry = table->private->entries[get_cpu()];
+	loc_cpu_entry = table->private->entries[raw_smp_processor_id()];
 	IPT_ENTRY_ITERATE(loc_cpu_entry, table->private->size,
 			  cleanup_entry, NULL);
-	put_cpu();
 	free_table_info(table->private);
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 0a216e0..ac1e112 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1074,11 +1074,14 @@ get_counters(const struct ip6t_table_inf
 {
 	unsigned int cpu;
 	unsigned int i;
-	unsigned int curcpu = get_cpu();
+	unsigned int curcpu;
 
 	/* Instead of clearing (by a previous call to memset())
 	 * the counters and using adds, we set the counters
-	 * with data used by current CPU */
+	 * with data used by 'current' CPU
+	 * We dont care about preemption here.
+	 */
+	curcpu = raw_smp_processor_id();
 
 	i = 0;
 	IP6T_ENTRY_ITERATE(t->entries[curcpu],
@@ -1097,7 +1100,6 @@ get_counters(const struct ip6t_table_inf
 				  counters,
 				  &i);
 	}
-	put_cpu();
 }
 
 static int
@@ -1126,7 +1128,7 @@ copy_entries_to_user(unsigned int total_
 	write_unlock_bh(&table->lock);
 
 	/* choose the copy that is on ourc node/cpu */
-	loc_cpu_entry = table->private->entries[get_cpu()];
+	loc_cpu_entry = table->private->entries[raw_smp_processor_id()];
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
 		ret = -EFAULT;
 		goto free_counters;
@@ -1176,7 +1178,6 @@ copy_entries_to_user(unsigned int total_
 	}
 
  free_counters:
-	put_cpu();
 	vfree(counters);
 	return ret;
 }
@@ -1271,7 +1272,7 @@ do_replace(void __user *user, unsigned i
 		return -ENOMEM;
 
 	/* choose the copy that is on our node/cpu */
-	loc_cpu_entry = newinfo->entries[get_cpu()];
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
 		ret = -EFAULT;
@@ -1324,9 +1325,8 @@ do_replace(void __user *user, unsigned i
 	/* Get the old counters. */
 	get_counters(oldinfo, counters);
 	/* Decrease module usage counts and free resource */
-	loc_cpu_old_entry = oldinfo->entries[smp_processor_id()];
+	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
 	IP6T_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,NULL);
-	put_cpu();
 	free_table_info(oldinfo);
 	if (copy_to_user(tmp.counters, counters,
 			 sizeof(struct ip6t_counters) * tmp.num_counters) != 0)
@@ -1343,7 +1343,6 @@ do_replace(void __user *user, unsigned i
  free_newinfo_counters:
 	vfree(counters);
  free_newinfo:
-	put_cpu();
 	free_table_info(newinfo);
 	return ret;
 }
@@ -1609,7 +1608,7 @@ int ip6t_register_table(struct ip6t_tabl
 		return -ENOMEM;
 
 	/* choose the copy on our node/cpu */
-	loc_cpu_entry = newinfo->entries[get_cpu()];
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
 	ret = translate_table(table->name, table->valid_hooks,
@@ -1617,7 +1616,6 @@ int ip6t_register_table(struct ip6t_tabl
 			      repl->num_entries,
 			      repl->hook_entry,
 			      repl->underflow);
-	put_cpu();
 	if (ret != 0) {
 		free_table_info(newinfo);
 		return ret;
@@ -1667,10 +1665,9 @@ void ip6t_unregister_table(struct ip6t_t
 	up(&ip6t_mutex);
 
 	/* Decrease module usage counts and free resources */
-	loc_cpu_entry = table->private->entries[get_cpu()];
+	loc_cpu_entry = table->private->entries[raw_smp_processor_id()];
 	IP6T_ENTRY_ITERATE(loc_cpu_entry, table->private->size,
 			  cleanup_entry, NULL);
-	put_cpu();
 	free_table_info(table->private);
 }
 

--------------070806010700050804000300--
