From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 3/8]: Reduce netfilter memory use on MP systems
Date: Fri, 04 Mar 2005 13:00:33 +0100
Message-ID: <42284DE1.8040607@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="03.diff"
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

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/03 23:15:48+01:00 ak@suse.de 
#   [NETFILTER]: Reduce netfilter memory use on MP systems
#   
#   On kernels compiled with a big NR_CPUS netfilter rules would 
#   eat a lot of memory because all counters would be duplicated
#   for all NR_CPUs CPUs.  With NR_CPUS=256 this would add up
#   to many MBs of memory.
#   
#   This patch only allocates enough memory for the possible CPUs,
#   which is usually a much smaller number than NR_CPUS.
#   
#   This allows loading of bigger rule sets on 64bit systems.
#   There is still a limit because someone else broke vmalloc to have a 64MB 
#   limit on 64bit systems for single allocations, 129MB on 32bit.
#   It allocates an array of pages with kmalloc and kmalloc has a 128K limit. 
#   To be fixed with a separate patch.
#   
#   64bit systems were hurt worst because they tend to have big NR_CPUS
#   and the counters need more memory there, and the vmalloc limit is lower.
#   But it will raise the limits even on 32bit. 
#   
#   And in general it saves a lot of memory.
#   
#   Tested only on a small dual CPU box. 
#   
#   Signed-off-by: Andi Kleen <ak@suse.de>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_tables.c
#   2005/03/03 23:15:40+01:00 ak@suse.de +5 -5
#   [NETFILTER]: Reduce netfilter memory use on MP systems
#   
#   On kernels compiled with a big NR_CPUS netfilter rules would 
#   eat a lot of memory because all counters would be duplicated
#   for all NR_CPUs CPUs.  With NR_CPUS=256 this would add up
#   to many MBs of memory.
#   
#   This patch only allocates enough memory for the possible CPUs,
#   which is usually a much smaller number than NR_CPUS.
#   
#   This allows loading of bigger rule sets on 64bit systems.
#   There is still a limit because someone else broke vmalloc to have a 64MB 
#   limit on 64bit systems for single allocations, 129MB on 32bit.
#   It allocates an array of pages with kmalloc and kmalloc has a 128K limit. 
#   To be fixed with a separate patch.
#   
#   64bit systems were hurt worst because they tend to have big NR_CPUS
#   and the counters need more memory there, and the vmalloc limit is lower.
#   But it will raise the limits even on 32bit. 
#   
#   And in general it saves a lot of memory.
#   
#   Tested only on a small dual CPU box. 
#   
#   Signed-off-by: Andi Kleen <ak@suse.de>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
--- a/net/ipv4/netfilter/ip_tables.c	2005-03-03 23:35:42 +01:00
+++ b/net/ipv4/netfilter/ip_tables.c	2005-03-03 23:35:42 +01:00
@@ -923,7 +923,7 @@
 	}
 
 	/* And one copy for every other CPU */
-	for (i = 1; i < NR_CPUS; i++) {
+	for (i = 1; i < num_possible_cpus(); i++) {
 		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
 		       newinfo->entries,
 		       SMP_ALIGN(newinfo->size));
@@ -945,7 +945,7 @@
 		struct ipt_entry *table_base;
 		unsigned int i;
 
-		for (i = 0; i < NR_CPUS; i++) {
+		for (i = 0; i < num_possible_cpus(); i++) {
 			table_base =
 				(void *)newinfo->entries
 				+ TABLE_OFFSET(newinfo, i);
@@ -992,7 +992,7 @@
 	unsigned int cpu;
 	unsigned int i;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for (cpu = 0; cpu < num_possible_cpus(); cpu++) {
 		i = 0;
 		IPT_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
 				  t->size,
@@ -1130,7 +1130,7 @@
 		return -ENOMEM;
 
 	newinfo = vmalloc(sizeof(struct ipt_table_info)
-			  + SMP_ALIGN(tmp.size) * NR_CPUS);
+			  + SMP_ALIGN(tmp.size) * num_possible_cpus());
 	if (!newinfo)
 		return -ENOMEM;
 
@@ -1460,7 +1460,7 @@
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
 	newinfo = vmalloc(sizeof(struct ipt_table_info)
-			  + SMP_ALIGN(repl->size) * NR_CPUS);
+			  + SMP_ALIGN(repl->size) * num_possible_cpus());
 	if (!newinfo)
 		return -ENOMEM;
 
