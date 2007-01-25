From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [patch 3/3] some xtables changes (xt_table)
Date: Thu, 25 Jan 2007 23:15:15 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701252314580.17844@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0701252210090.15753@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0701252210090.15753@yvahk01.tjqt.qr>
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


[PATCH 3/3] XT: xt_table

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>, 2007-01-17

Index: linux-2.6.20-rc6/include/linux/netfilter_ipv4/ip_tables.h
===================================================================
--- linux-2.6.20-rc6.orig/include/linux/netfilter_ipv4/ip_tables.h
+++ linux-2.6.20-rc6/include/linux/netfilter_ipv4/ip_tables.h
@@ -29,7 +29,6 @@
 
 #define IPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
 #define IPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
-#define ipt_table xt_table
 #define ipt_get_revision xt_get_revision
 
 /* Yes, Virginia, you have to zero the padding. */
@@ -273,9 +272,9 @@ extern void ipt_init(void) __init;
 //#define ipt_register_table(tbl, repl) xt_register_table(AF_INET, tbl, repl)
 //#define ipt_unregister_table(tbl) xt_unregister_table(AF_INET, tbl)
 
-extern int ipt_register_table(struct ipt_table *table,
+extern int ipt_register_table(struct xt_table *table,
 			      const struct ipt_replace *repl);
-extern void ipt_unregister_table(struct ipt_table *table);
+extern void ipt_unregister_table(struct xt_table *table);
 
 /* net/sched/ipt.c: Gimme access to your targets!  Gets target->me. */
 extern struct xt_target *ipt_find_target(const char *name, u8 revision);
@@ -303,7 +302,7 @@ extern unsigned int ipt_do_table(struct 
 				 unsigned int hook,
 				 const struct net_device *in,
 				 const struct net_device *out,
-				 struct ipt_table *table);
+				 struct xt_table *table);
 
 #define IPT_ALIGN(s) XT_ALIGN(s)
 
Index: linux-2.6.20-rc6/include/linux/netfilter_ipv6/ip6_tables.h
===================================================================
--- linux-2.6.20-rc6.orig/include/linux/netfilter_ipv6/ip6_tables.h
+++ linux-2.6.20-rc6/include/linux/netfilter_ipv6/ip6_tables.h
@@ -29,7 +29,6 @@
 
 #define IP6T_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
 #define IP6T_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
-#define ip6t_table xt_table
 #define ip6t_get_revision xt_get_revision
 
 /* Yes, Virginia, you have to zero the padding. */
@@ -283,14 +282,14 @@ ip6t_get_target(struct ip6t_entry *e)
 #include <linux/init.h>
 extern void ip6t_init(void) __init;
 
-extern int ip6t_register_table(struct ip6t_table *table,
+extern int ip6t_register_table(struct xt_table *table,
 			       const struct ip6t_replace *repl);
-extern void ip6t_unregister_table(struct ip6t_table *table);
+extern void ip6t_unregister_table(struct xt_table *table);
 extern unsigned int ip6t_do_table(struct sk_buff **pskb,
 				  unsigned int hook,
 				  const struct net_device *in,
 				  const struct net_device *out,
-				  struct ip6t_table *table);
+				  struct xt_table *table);
 
 /* Check for an extension */
 extern int ip6t_ext_hdr(u8 nexthdr);
Index: linux-2.6.20-rc6/net/ipv4/netfilter/ip_nat_rule.c
===================================================================
--- linux-2.6.20-rc6.orig/net/ipv4/netfilter/ip_nat_rule.c
+++ linux-2.6.20-rc6/net/ipv4/netfilter/ip_nat_rule.c
@@ -86,7 +86,7 @@ static struct
     }
 };
 
-static struct ipt_table nat_table = {
+static struct xt_table nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
Index: linux-2.6.20-rc6/net/ipv4/netfilter/ip_tables.c
===================================================================
--- linux-2.6.20-rc6.orig/net/ipv4/netfilter/ip_tables.c
+++ linux-2.6.20-rc6/net/ipv4/netfilter/ip_tables.c
@@ -216,7 +216,7 @@ ipt_do_table(struct sk_buff **pskb,
 	     unsigned int hook,
 	     const struct net_device *in,
 	     const struct net_device *out,
-	     struct ipt_table *table)
+	     struct xt_table *table)
 {
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	u_int16_t offset;
@@ -818,7 +818,7 @@ get_counters(const struct xt_table_info 
 	}
 }
 
-static inline struct xt_counters * alloc_counters(struct ipt_table *table)
+static inline struct xt_counters * alloc_counters(struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
@@ -843,7 +843,7 @@ static inline struct xt_counters * alloc
 
 static int
 copy_entries_to_user(unsigned int total_size,
-		     struct ipt_table *table,
+		     struct xt_table *table,
 		     void __user *userptr)
 {
 	unsigned int off, num;
@@ -1046,7 +1046,7 @@ static int compat_table_info(struct xt_t
 static int get_info(void __user *user, int *len, int compat)
 {
 	char name[IPT_TABLE_MAXNAMELEN];
-	struct ipt_table *t;
+	struct xt_table *t;
 	int ret;
 
 	if (*len != sizeof(struct ipt_getinfo)) {
@@ -1107,7 +1107,7 @@ get_entries(struct ipt_get_entries __use
 {
 	int ret;
 	struct ipt_get_entries get;
-	struct ipt_table *t;
+	struct xt_table *t;
 
 	if (*len < sizeof(get)) {
 		duprintf("get_entries: %u < %d\n", *len,
@@ -1151,7 +1151,7 @@ __do_replace(const char *name, unsigned 
 		void __user *counters_ptr)
 {
 	int ret;
-	struct ipt_table *t;
+	struct xt_table *t;
 	struct xt_table_info *oldinfo;
 	struct xt_counters *counters;
 	void *loc_cpu_old_entry;
@@ -1302,7 +1302,7 @@ do_add_counters(void __user *user, unsig
 	char *name;
 	int size;
 	void *ptmp;
-	struct ipt_table *t;
+	struct xt_table *t;
 	struct xt_table_info *private;
 	int ret = 0;
 	void *loc_cpu_entry;
@@ -1795,7 +1795,7 @@ struct compat_ipt_get_entries
 };
 
 static int compat_copy_entries_to_user(unsigned int total_size,
-		     struct ipt_table *table, void __user *userptr)
+		     struct xt_table *table, void __user *userptr)
 {
 	unsigned int off, num;
 	struct compat_ipt_entry e;
@@ -1869,7 +1869,7 @@ compat_get_entries(struct compat_ipt_get
 {
 	int ret;
 	struct compat_ipt_get_entries get;
-	struct ipt_table *t;
+	struct xt_table *t;
 
 
 	if (*len < sizeof(get)) {
@@ -2052,7 +2052,7 @@ int ipt_register_table(struct xt_table *
 	return 0;
 }
 
-void ipt_unregister_table(struct ipt_table *table)
+void ipt_unregister_table(struct xt_table *table)
 {
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
Index: linux-2.6.20-rc6/net/ipv4/netfilter/iptable_filter.c
===================================================================
--- linux-2.6.20-rc6.orig/net/ipv4/netfilter/iptable_filter.c
+++ linux-2.6.20-rc6/net/ipv4/netfilter/iptable_filter.c
@@ -74,7 +74,7 @@ static struct
     }
 };
 
-static struct ipt_table packet_filter = {
+static struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
Index: linux-2.6.20-rc6/net/ipv4/netfilter/iptable_mangle.c
===================================================================
--- linux-2.6.20-rc6.orig/net/ipv4/netfilter/iptable_mangle.c
+++ linux-2.6.20-rc6/net/ipv4/netfilter/iptable_mangle.c
@@ -103,7 +103,7 @@ static struct
     }
 };
 
-static struct ipt_table packet_mangler = {
+static struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
Index: linux-2.6.20-rc6/net/ipv4/netfilter/iptable_raw.c
===================================================================
--- linux-2.6.20-rc6.orig/net/ipv4/netfilter/iptable_raw.c
+++ linux-2.6.20-rc6/net/ipv4/netfilter/iptable_raw.c
@@ -79,7 +79,7 @@ static struct
 	}
 };
 
-static struct ipt_table packet_raw = { 
+static struct xt_table packet_raw = {
 	.name = "raw", 
 	.valid_hooks =  RAW_VALID_HOOKS, 
 	.lock = RW_LOCK_UNLOCKED, 
Index: linux-2.6.20-rc6/net/ipv4/netfilter/nf_nat_rule.c
===================================================================
--- linux-2.6.20-rc6.orig/net/ipv4/netfilter/nf_nat_rule.c
+++ linux-2.6.20-rc6/net/ipv4/netfilter/nf_nat_rule.c
@@ -119,7 +119,7 @@ static struct
 	}
 };
 
-static struct ipt_table nat_table = {
+static struct xt_table nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
Index: linux-2.6.20-rc6/net/ipv6/netfilter/ip6table_filter.c
===================================================================
--- linux-2.6.20-rc6.orig/net/ipv6/netfilter/ip6table_filter.c
+++ linux-2.6.20-rc6/net/ipv6/netfilter/ip6table_filter.c
@@ -92,7 +92,7 @@ static struct
     }
 };
 
-static struct ip6t_table packet_filter = {
+static struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
Index: linux-2.6.20-rc6/net/ipv6/netfilter/ip6table_mangle.c
===================================================================
--- linux-2.6.20-rc6.orig/net/ipv6/netfilter/ip6table_mangle.c
+++ linux-2.6.20-rc6/net/ipv6/netfilter/ip6table_mangle.c
@@ -122,7 +122,7 @@ static struct
     }
 };
 
-static struct ip6t_table packet_mangler = {
+static struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
Index: linux-2.6.20-rc6/net/sched/act_ipt.c
===================================================================
--- linux-2.6.20-rc6.orig/net/sched/act_ipt.c
+++ linux-2.6.20-rc6/net/sched/act_ipt.c
@@ -52,7 +52,7 @@ static struct tcf_hashinfo ipt_hash_info
 
 static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int hook)
 {
-	struct ipt_target *target;
+	struct xt_target *target;
 	int ret = 0;
 
 	target = xt_find_target(AF_INET, t->u.user.name, t->u.user.revision);
