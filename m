From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 6/6]: re-introduce __initdata to {arp,ip,ip6}_tables
Date: Tue, 11 Jan 2005 13:49:58 +0100
Message-ID: <41E3CB76.2080905@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070105030000080406010005"
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
--------------070105030000080406010005
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------070105030000080406010005
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/01/11 03:46:01+01:00 laforge@netfilter.org 
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6table_raw.c
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +1 -2
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6table_mangle.c
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +1 -2
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6table_filter.c
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +1 -2
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_tables.c
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +8 -7
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/iptable_raw.c
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +1 -2
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/iptable_mangle.c
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +1 -2
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/iptable_filter.c
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +3 -4
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_tables.c
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +7 -7
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_rule.c
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +3 -4
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/arptable_filter.c
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +1 -2
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/arp_tables.c
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +8 -7
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv6/ip6_tables.h
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +2 -4
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_tables.h
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +2 -4
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_arp/arp_tables.h
#   2005/01/11 03:45:54+01:00 laforge@netfilter.org +2 -4
#   [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables
#   
#   Instead of just removing the (correct) __initdata as introduced by 
#   http://linux.bkbits.net:8080/linux-2.5/cset@1.2055.4.50                         
#   we rework the code in order to not trigger some misinterpretation by
#   static code checkers.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
--- a/include/linux/netfilter_arp/arp_tables.h	2005-01-11 13:40:03 +01:00
+++ b/include/linux/netfilter_arp/arp_tables.h	2005-01-11 13:40:03 +01:00
@@ -312,9 +312,6 @@
 	/* A unique name... */
 	char name[ARPT_TABLE_MAXNAMELEN];
 
-	/* Seed table: copied in register_table */
-	struct arpt_replace *table;
-
 	/* What hooks you will enter on */
 	unsigned int valid_hooks;
 
@@ -328,7 +325,8 @@
 	struct module *me;
 };
 
-extern int arpt_register_table(struct arpt_table *table);
+extern int arpt_register_table(struct arpt_table *table,
+			       const struct arpt_replace *repl);
 extern void arpt_unregister_table(struct arpt_table *table);
 extern unsigned int arpt_do_table(struct sk_buff **pskb,
 				  unsigned int hook,
diff -Nru a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
--- a/include/linux/netfilter_ipv4/ip_tables.h	2005-01-11 13:40:03 +01:00
+++ b/include/linux/netfilter_ipv4/ip_tables.h	2005-01-11 13:40:03 +01:00
@@ -440,9 +440,6 @@
 	/* A unique name... */
 	char name[IPT_TABLE_MAXNAMELEN];
 
-	/* Seed table: copied in register_table */
-	struct ipt_replace *table;
-
 	/* What hooks you will enter on */
 	unsigned int valid_hooks;
 
@@ -478,7 +475,8 @@
 	struct ipt_error_target target;
 };
 
-extern int ipt_register_table(struct ipt_table *table);
+extern int ipt_register_table(struct ipt_table *table,
+			      const struct ipt_replace *repl);
 extern void ipt_unregister_table(struct ipt_table *table);
 extern unsigned int ipt_do_table(struct sk_buff **pskb,
 				 unsigned int hook,
diff -Nru a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
--- a/include/linux/netfilter_ipv6/ip6_tables.h	2005-01-11 13:40:03 +01:00
+++ b/include/linux/netfilter_ipv6/ip6_tables.h	2005-01-11 13:40:03 +01:00
@@ -429,9 +429,6 @@
 	/* A unique name... */
 	char name[IP6T_TABLE_MAXNAMELEN];
 
-	/* Seed table: copied in register_table */
-	struct ip6t_replace *table;
-
 	/* What hooks you will enter on */
 	unsigned int valid_hooks;
 
@@ -445,7 +442,8 @@
 	struct module *me;
 };
 
-extern int ip6t_register_table(struct ip6t_table *table);
+extern int ip6t_register_table(struct ip6t_table *table,
+			       const struct ip6t_replace *repl);
 extern void ip6t_unregister_table(struct ip6t_table *table);
 extern unsigned int ip6t_do_table(struct sk_buff **pskb,
 				  unsigned int hook,
diff -Nru a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
--- a/net/ipv4/netfilter/arp_tables.c	2005-01-11 13:40:03 +01:00
+++ b/net/ipv4/netfilter/arp_tables.c	2005-01-11 13:40:03 +01:00
@@ -1150,7 +1150,8 @@
 	up(&arpt_mutex);
 }
 
-int arpt_register_table(struct arpt_table *table)
+int arpt_register_table(struct arpt_table *table,
+			const struct arpt_replace *repl)
 {
 	int ret;
 	struct arpt_table_info *newinfo;
@@ -1158,18 +1159,18 @@
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
 	newinfo = vmalloc(sizeof(struct arpt_table_info)
-			  + SMP_ALIGN(table->table->size) * NR_CPUS);
+			  + SMP_ALIGN(repl->size) * NR_CPUS);
 	if (!newinfo) {
 		ret = -ENOMEM;
 		return ret;
 	}
-	memcpy(newinfo->entries, table->table->entries, table->table->size);
+	memcpy(newinfo->entries, repl->entries, repl->size);
 
 	ret = translate_table(table->name, table->valid_hooks,
-			      newinfo, table->table->size,
-			      table->table->num_entries,
-			      table->table->hook_entry,
-			      table->table->underflow);
+			      newinfo, repl->size,
+			      repl->num_entries,
+			      repl->hook_entry,
+			      repl->underflow);
 	duprintf("arpt_register_table: translate table gives %d\n", ret);
 	if (ret != 0) {
 		vfree(newinfo);
diff -Nru a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
--- a/net/ipv4/netfilter/arptable_filter.c	2005-01-11 13:40:03 +01:00
+++ b/net/ipv4/netfilter/arptable_filter.c	2005-01-11 13:40:03 +01:00
@@ -141,7 +141,6 @@
 
 static struct arpt_table packet_filter = {
 	.name		= "filter",
-	.table		= &initial_table.repl,
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
 	.private	= NULL,
@@ -184,7 +183,7 @@
 	int ret, i;
 
 	/* Register table */
-	ret = arpt_register_table(&packet_filter);
+	ret = arpt_register_table(&packet_filter, &initial_table.repl);
 	if (ret < 0)
 		return ret;
 
diff -Nru a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
--- a/net/ipv4/netfilter/ip_nat_rule.c	2005-01-11 13:40:03 +01:00
+++ b/net/ipv4/netfilter/ip_nat_rule.c	2005-01-11 13:40:03 +01:00
@@ -40,8 +40,8 @@
 	struct ipt_replace repl;
 	struct ipt_standard entries[3];
 	struct ipt_error term;
-} nat_initial_table = {
-    { "nat", NAT_VALID_HOOKS, 4,
+} nat_initial_table __initdata
+= { { "nat", NAT_VALID_HOOKS, 4,
       sizeof(struct ipt_standard) * 3 + sizeof(struct ipt_error),
       { [NF_IP_PRE_ROUTING] = 0,
 	[NF_IP_POST_ROUTING] = sizeof(struct ipt_standard),
@@ -91,7 +91,6 @@
 
 static struct ipt_table nat_table = {
 	.name		= "nat",
-	.table		= &nat_initial_table.repl,
 	.valid_hooks	= NAT_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
 	.me		= THIS_MODULE,
@@ -266,7 +265,7 @@
 {
 	int ret;
 
-	ret = ipt_register_table(&nat_table);
+	ret = ipt_register_table(&nat_table, &nat_initial_table.repl);
 	if (ret != 0)
 		return ret;
 	ret = ipt_register_target(&ipt_snat_reg);
diff -Nru a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
--- a/net/ipv4/netfilter/ip_tables.c	2005-01-11 13:40:03 +01:00
+++ b/net/ipv4/netfilter/ip_tables.c	2005-01-11 13:40:03 +01:00
@@ -1452,7 +1452,7 @@
 	up(&ipt_mutex);
 }
 
-int ipt_register_table(struct ipt_table *table)
+int ipt_register_table(struct ipt_table *table, const struct ipt_replace *repl)
 {
 	int ret;
 	struct ipt_table_info *newinfo;
@@ -1460,17 +1460,17 @@
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
 	newinfo = vmalloc(sizeof(struct ipt_table_info)
-			  + SMP_ALIGN(table->table->size) * NR_CPUS);
+			  + SMP_ALIGN(repl->size) * NR_CPUS);
 	if (!newinfo)
 		return -ENOMEM;
 
-	memcpy(newinfo->entries, table->table->entries, table->table->size);
+	memcpy(newinfo->entries, repl->entries, repl->size);
 
 	ret = translate_table(table->name, table->valid_hooks,
-			      newinfo, table->table->size,
-			      table->table->num_entries,
-			      table->table->hook_entry,
-			      table->table->underflow);
+			      newinfo, repl->size,
+			      repl->num_entries,
+			      repl->hook_entry,
+			      repl->underflow);
 	if (ret != 0) {
 		vfree(newinfo);
 		return ret;
diff -Nru a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
--- a/net/ipv4/netfilter/iptable_filter.c	2005-01-11 13:40:03 +01:00
+++ b/net/ipv4/netfilter/iptable_filter.c	2005-01-11 13:40:03 +01:00
@@ -25,8 +25,8 @@
 	struct ipt_replace repl;
 	struct ipt_standard entries[3];
 	struct ipt_error term;
-} initial_table = {
-    { "filter", FILTER_VALID_HOOKS, 4,
+} initial_table __initdata 
+= { { "filter", FILTER_VALID_HOOKS, 4,
       sizeof(struct ipt_standard) * 3 + sizeof(struct ipt_error),
       { [NF_IP_LOCAL_IN] = 0,
 	[NF_IP_FORWARD] = sizeof(struct ipt_standard),
@@ -76,7 +76,6 @@
 
 static struct ipt_table packet_filter = {
 	.name		= "filter",
-	.table		= &initial_table.repl,
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
 	.me		= THIS_MODULE
@@ -152,7 +151,7 @@
 	initial_table.entries[1].target.verdict = -forward - 1;
 
 	/* Register table */
-	ret = ipt_register_table(&packet_filter);
+	ret = ipt_register_table(&packet_filter, &initial_table.repl);
 	if (ret < 0)
 		return ret;
 
diff -Nru a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
--- a/net/ipv4/netfilter/iptable_mangle.c	2005-01-11 13:40:03 +01:00
+++ b/net/ipv4/netfilter/iptable_mangle.c	2005-01-11 13:40:03 +01:00
@@ -106,7 +106,6 @@
 
 static struct ipt_table packet_mangler = {
 	.name		= "mangle",
-	.table		= &initial_table.repl,
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
 	.me		= THIS_MODULE,
@@ -206,7 +205,7 @@
 	int ret;
 
 	/* Register table */
-	ret = ipt_register_table(&packet_mangler);
+	ret = ipt_register_table(&packet_mangler, &initial_table.repl);
 	if (ret < 0)
 		return ret;
 
diff -Nru a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
--- a/net/ipv4/netfilter/iptable_raw.c	2005-01-11 13:40:03 +01:00
+++ b/net/ipv4/netfilter/iptable_raw.c	2005-01-11 13:40:03 +01:00
@@ -81,7 +81,6 @@
 
 static struct ipt_table packet_raw = { 
 	.name = "raw", 
-	.table = &initial_table.repl,
 	.valid_hooks =  RAW_VALID_HOOKS, 
 	.lock = RW_LOCK_UNLOCKED, 
 	.me = THIS_MODULE
@@ -119,7 +118,7 @@
 	int ret;
 
 	/* Register table */
-	ret = ipt_register_table(&packet_raw);
+	ret = ipt_register_table(&packet_raw, &initial_table.repl);
 	if (ret < 0)
 		return ret;
 
diff -Nru a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c	2005-01-11 13:40:03 +01:00
+++ b/net/ipv6/netfilter/ip6_tables.c	2005-01-11 13:40:03 +01:00
@@ -1460,7 +1460,8 @@
 	up(&ip6t_mutex);
 }
 
-int ip6t_register_table(struct ip6t_table *table)
+int ip6t_register_table(struct ip6t_table *table,
+			const struct ip6t_replace *repl)
 {
 	int ret;
 	struct ip6t_table_info *newinfo;
@@ -1468,17 +1469,17 @@
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
 	newinfo = vmalloc(sizeof(struct ip6t_table_info)
-			  + SMP_ALIGN(table->table->size) * NR_CPUS);
+			  + SMP_ALIGN(repl->size) * NR_CPUS);
 	if (!newinfo)
 		return -ENOMEM;
 
-	memcpy(newinfo->entries, table->table->entries, table->table->size);
+	memcpy(newinfo->entries, repl->entries, repl->size);
 
 	ret = translate_table(table->name, table->valid_hooks,
-			      newinfo, table->table->size,
-			      table->table->num_entries,
-			      table->table->hook_entry,
-			      table->table->underflow);
+			      newinfo, repl->size,
+			      repl->num_entries,
+			      repl->hook_entry,
+			      repl->underflow);
 	if (ret != 0) {
 		vfree(newinfo);
 		return ret;
diff -Nru a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
--- a/net/ipv6/netfilter/ip6table_filter.c	2005-01-11 13:40:03 +01:00
+++ b/net/ipv6/netfilter/ip6table_filter.c	2005-01-11 13:40:03 +01:00
@@ -94,7 +94,6 @@
 
 static struct ip6t_table packet_filter = {
 	.name		= "filter",
-	.table		= &initial_table.repl,
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
 	.me		= THIS_MODULE,
@@ -172,7 +171,7 @@
 	initial_table.entries[1].target.verdict = -forward - 1;
 
 	/* Register table */
-	ret = ip6t_register_table(&packet_filter);
+	ret = ip6t_register_table(&packet_filter, &initial_table.repl);
 	if (ret < 0)
 		return ret;
 
diff -Nru a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
--- a/net/ipv6/netfilter/ip6table_mangle.c	2005-01-11 13:40:03 +01:00
+++ b/net/ipv6/netfilter/ip6table_mangle.c	2005-01-11 13:40:03 +01:00
@@ -124,7 +124,6 @@
 
 static struct ip6t_table packet_mangler = {
 	.name		= "mangle",
-	.table		= &initial_table.repl,
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
 	.me		= THIS_MODULE,
@@ -233,7 +232,7 @@
 	int ret;
 
 	/* Register table */
-	ret = ip6t_register_table(&packet_mangler);
+	ret = ip6t_register_table(&packet_mangler, &initial_table.repl);
 	if (ret < 0)
 		return ret;
 
diff -Nru a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
--- a/net/ipv6/netfilter/ip6table_raw.c	2005-01-11 13:40:03 +01:00
+++ b/net/ipv6/netfilter/ip6table_raw.c	2005-01-11 13:40:03 +01:00
@@ -108,7 +108,6 @@
 
 static struct ip6t_table packet_raw = { 
 	.name = "raw", 
-	.table = &initial_table.repl,
 	.valid_hooks = RAW_VALID_HOOKS, 
 	.lock = RW_LOCK_UNLOCKED, 
 	.me = THIS_MODULE
@@ -145,7 +144,7 @@
 	int ret;
 
 	/* Register table */
-	ret = ip6t_register_table(&packet_raw);
+	ret = ip6t_register_table(&packet_raw, &initial_table.repl);
 	if (ret < 0)
 		return ret;
 

--------------070105030000080406010005--
