From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 4/8]: Use num_possible_cpus instead of NR_CPUS in {ip6_,
	arp_, eb}tables
Date: Fri, 04 Mar 2005 13:00:39 +0100
Message-ID: <42284DE7.80705@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="04.diff"
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
#   2005/03/03 23:16:38+01:00 kaber@coreworks.de 
#   [NETFILTER]: Use num_possible_cpus instead of NR_CPUS in {ip6_,arp_,eb}tables
#   
#   Similar to Andi Kleen's patch "Reduce netfilter memory use on MP systems".
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_tables.c
#   2005/03/03 23:16:30+01:00 kaber@coreworks.de +5 -5
#   [NETFILTER]: Use num_possible_cpus instead of NR_CPUS in {ip6_,arp_,eb}tables
#   
#   Similar to Andi Kleen's patch "Reduce netfilter memory use on MP systems".
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/arp_tables.c
#   2005/03/03 23:16:30+01:00 kaber@coreworks.de +4 -4
#   [NETFILTER]: Use num_possible_cpus instead of NR_CPUS in {ip6_,arp_,eb}tables
#   
#   Similar to Andi Kleen's patch "Reduce netfilter memory use on MP systems".
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/bridge/netfilter/ebtables.c
#   2005/03/03 23:16:30+01:00 kaber@coreworks.de +9 -9
#   [NETFILTER]: Use num_possible_cpus instead of NR_CPUS in {ip6_,arp_,eb}tables
#   
#   Similar to Andi Kleen's patch "Reduce netfilter memory use on MP systems".
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
--- a/net/bridge/netfilter/ebtables.c	2005-03-03 23:35:48 +01:00
+++ b/net/bridge/netfilter/ebtables.c	2005-03-03 23:35:48 +01:00
@@ -822,10 +822,10 @@
 		/* this will get free'd in do_replace()/ebt_register_table()
 		   if an error occurs */
 		newinfo->chainstack = (struct ebt_chainstack **)
-		   vmalloc(NR_CPUS * sizeof(struct ebt_chainstack));
+		   vmalloc(num_possible_cpus() * sizeof(struct ebt_chainstack));
 		if (!newinfo->chainstack)
 			return -ENOMEM;
-		for (i = 0; i < NR_CPUS; i++) {
+		for (i = 0; i < num_possible_cpus(); i++) {
 			newinfo->chainstack[i] =
 			   vmalloc(udc_cnt * sizeof(struct ebt_chainstack));
 			if (!newinfo->chainstack[i]) {
@@ -898,7 +898,7 @@
 	memcpy(counters, oldcounters,
 	   sizeof(struct ebt_counter) * nentries);
 	/* add other counters to those of cpu 0 */
-	for (cpu = 1; cpu < NR_CPUS; cpu++) {
+	for (cpu = 1; cpu < num_possible_cpus(); cpu++) {
 		counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
 		for (i = 0; i < nentries; i++) {
 			counters[i].pcnt += counter_base[i].pcnt;
@@ -930,7 +930,7 @@
 		BUGPRINT("Entries_size never zero\n");
 		return -EINVAL;
 	}
-	countersize = COUNTER_OFFSET(tmp.nentries) * NR_CPUS;
+	countersize = COUNTER_OFFSET(tmp.nentries) * num_possible_cpus();
 	newinfo = (struct ebt_table_info *)
 	   vmalloc(sizeof(struct ebt_table_info) + countersize);
 	if (!newinfo)
@@ -1023,7 +1023,7 @@
 
 	vfree(table->entries);
 	if (table->chainstack) {
-		for (i = 0; i < NR_CPUS; i++)
+		for (i = 0; i < num_possible_cpus(); i++)
 			vfree(table->chainstack[i]);
 		vfree(table->chainstack);
 	}
@@ -1043,7 +1043,7 @@
 		vfree(counterstmp);
 	/* can be initialized in translate_table() */
 	if (newinfo->chainstack) {
-		for (i = 0; i < NR_CPUS; i++)
+		for (i = 0; i < num_possible_cpus(); i++)
 			vfree(newinfo->chainstack[i]);
 		vfree(newinfo->chainstack);
 	}
@@ -1137,7 +1137,7 @@
 		return -EINVAL;
 	}
 
-	countersize = COUNTER_OFFSET(table->table->nentries) * NR_CPUS;
+	countersize = COUNTER_OFFSET(table->table->nentries) * num_possible_cpus();
 	newinfo = (struct ebt_table_info *)
 	   vmalloc(sizeof(struct ebt_table_info) + countersize);
 	ret = -ENOMEM;
@@ -1191,7 +1191,7 @@
 	up(&ebt_mutex);
 free_chainstack:
 	if (newinfo->chainstack) {
-		for (i = 0; i < NR_CPUS; i++)
+		for (i = 0; i < num_possible_cpus(); i++)
 			vfree(newinfo->chainstack[i]);
 		vfree(newinfo->chainstack);
 	}
@@ -1215,7 +1215,7 @@
 	if (table->private->entries)
 		vfree(table->private->entries);
 	if (table->private->chainstack) {
-		for (i = 0; i < NR_CPUS; i++)
+		for (i = 0; i < num_possible_cpus(); i++)
 			vfree(table->private->chainstack[i]);
 		vfree(table->private->chainstack);
 	}
diff -Nru a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
--- a/net/ipv4/netfilter/arp_tables.c	2005-03-03 23:35:48 +01:00
+++ b/net/ipv4/netfilter/arp_tables.c	2005-03-03 23:35:48 +01:00
@@ -717,7 +717,7 @@
 	}
 
 	/* And one copy for every other CPU */
-	for (i = 1; i < NR_CPUS; i++) {
+	for (i = 1; i < num_possible_cpus(); i++) {
 		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
 		       newinfo->entries,
 		       SMP_ALIGN(newinfo->size));
@@ -768,7 +768,7 @@
 	unsigned int cpu;
 	unsigned int i;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for (cpu = 0; cpu < num_possible_cpus(); cpu++) {
 		i = 0;
 		ARPT_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
 				   t->size,
@@ -886,7 +886,7 @@
 		return -ENOMEM;
 
 	newinfo = vmalloc(sizeof(struct arpt_table_info)
-			  + SMP_ALIGN(tmp.size) * NR_CPUS);
+			  + SMP_ALIGN(tmp.size) * num_possible_cpus());
 	if (!newinfo)
 		return -ENOMEM;
 
@@ -1159,7 +1159,7 @@
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
 	newinfo = vmalloc(sizeof(struct arpt_table_info)
-			  + SMP_ALIGN(repl->size) * NR_CPUS);
+			  + SMP_ALIGN(repl->size) * num_possible_cpus());
 	if (!newinfo) {
 		ret = -ENOMEM;
 		return ret;
diff -Nru a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c	2005-03-03 23:35:48 +01:00
+++ b/net/ipv6/netfilter/ip6_tables.c	2005-03-03 23:35:48 +01:00
@@ -952,7 +952,7 @@
 	}
 
 	/* And one copy for every other CPU */
-	for (i = 1; i < NR_CPUS; i++) {
+	for (i = 1; i < num_possible_cpus(); i++) {
 		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
 		       newinfo->entries,
 		       SMP_ALIGN(newinfo->size));
@@ -974,7 +974,7 @@
 		struct ip6t_entry *table_base;
 		unsigned int i;
 
-		for (i = 0; i < NR_CPUS; i++) {
+		for (i = 0; i < num_possible_cpus(); i++) {
 			table_base =
 				(void *)newinfo->entries
 				+ TABLE_OFFSET(newinfo, i);
@@ -1021,7 +1021,7 @@
 	unsigned int cpu;
 	unsigned int i;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for (cpu = 0; cpu < num_possible_cpus(); cpu++) {
 		i = 0;
 		IP6T_ENTRY_ITERATE(t->entries + TABLE_OFFSET(t, cpu),
 				  t->size,
@@ -1155,7 +1155,7 @@
 		return -ENOMEM;
 
 	newinfo = vmalloc(sizeof(struct ip6t_table_info)
-			  + SMP_ALIGN(tmp.size) * NR_CPUS);
+			  + SMP_ALIGN(tmp.size) * num_possible_cpus());
 	if (!newinfo)
 		return -ENOMEM;
 
@@ -1469,7 +1469,7 @@
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
 	newinfo = vmalloc(sizeof(struct ip6t_table_info)
-			  + SMP_ALIGN(repl->size) * NR_CPUS);
+			  + SMP_ALIGN(repl->size) * num_possible_cpus());
 	if (!newinfo)
 		return -ENOMEM;
 
