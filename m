From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/15]: {ip,
	ip6}_tables: use struct xt_table instead of redefined structure
	names
Date: Wed,  7 Feb 2007 09:23:04 +0100 (MET)
Message-ID: <20070207082303.27478.78057.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NETFILTER]: {ip,ip6}_tables: use struct xt_table instead of redefined structure names

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 23ef10d3c0fcfacd86d3e566ba55504ea6de8a74
tree 9c835ce4d97f426523219fe33b801a4cde0cc19b
parent e784feead989b60588e60a2f584e22ae08804cec
author Jan Engelhardt <jengelh@gmx.de> Tue, 06 Feb 2007 07:37:06 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:53:12 +0100

 include/linux/netfilter_ipv4/ip_tables.h  |    9 +++------
 include/linux/netfilter_ipv6/ip6_tables.h |    6 +++---
 net/ipv4/netfilter/ip_nat_rule.c          |    2 +-
 net/ipv4/netfilter/ip_tables.c            |   20 ++++++++++----------
 net/ipv4/netfilter/iptable_filter.c       |    2 +-
 net/ipv4/netfilter/iptable_mangle.c       |    2 +-
 net/ipv4/netfilter/iptable_raw.c          |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c          |    2 +-
 net/ipv6/netfilter/ip6table_filter.c      |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c      |    2 +-
 net/sched/act_ipt.c                       |    2 +-
 11 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index c59bc6f..fccf4b8 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -272,12 +272,9 @@ #ifdef __KERNEL__
 #include <linux/init.h>
 extern void ipt_init(void) __init;
 
-//#define ipt_register_table(tbl, repl) xt_register_table(AF_INET, tbl, repl)
-//#define ipt_unregister_table(tbl) xt_unregister_table(AF_INET, tbl)
-
-extern int ipt_register_table(struct ipt_table *table,
+extern int ipt_register_table(struct xt_table *table,
 			      const struct ipt_replace *repl);
-extern void ipt_unregister_table(struct ipt_table *table);
+extern void ipt_unregister_table(struct xt_table *table);
 
 /* net/sched/ipt.c: Gimme access to your targets!  Gets target->me. */
 extern struct xt_target *ipt_find_target(const char *name, u8 revision);
@@ -305,7 +302,7 @@ extern unsigned int ipt_do_table(struct 
 				 unsigned int hook,
 				 const struct net_device *in,
 				 const struct net_device *out,
-				 struct ipt_table *table);
+				 struct xt_table *table);
 
 #define IPT_ALIGN(s) XT_ALIGN(s)
 
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 2fbabab..e37698c 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -286,14 +286,14 @@ #ifdef __KERNEL__
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
diff --git a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
index 7a8e7bb..e1c8a05 100644
--- a/net/ipv4/netfilter/ip_nat_rule.c
+++ b/net/ipv4/netfilter/ip_nat_rule.c
@@ -86,7 +86,7 @@ static struct
     }
 };
 
-static struct ipt_table nat_table = {
+static struct xt_table nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 3cbe867..a539466 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
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
@@ -1046,7 +1046,7 @@ #endif
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
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index e2e7dd8..51053cb 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -74,7 +74,7 @@ static struct
     }
 };
 
-static struct ipt_table packet_filter = {
+static struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index af29398..a532e4d 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -103,7 +103,7 @@ static struct
     }
 };
 
-static struct ipt_table packet_mangler = {
+static struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index bcbeb4a..5277550 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -79,7 +79,7 @@ static struct
 	}
 };
 
-static struct ipt_table packet_raw = { 
+static struct xt_table packet_raw = {
 	.name = "raw", 
 	.valid_hooks =  RAW_VALID_HOOKS, 
 	.lock = RW_LOCK_UNLOCKED, 
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index de25d63..7f95b4e 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -119,7 +119,7 @@ static struct
 	}
 };
 
-static struct ipt_table nat_table = {
+static struct xt_table nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 2fc07c7..45b8342 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -92,7 +92,7 @@ static struct
     }
 };
 
-static struct ip6t_table packet_filter = {
+static struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 6250e86..6f67ee1 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -122,7 +122,7 @@ static struct
     }
 };
 
-static struct ip6t_table packet_mangler = {
+static struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.lock		= RW_LOCK_UNLOCKED,
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 01e6913..4c68c71 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -52,7 +52,7 @@ static struct tcf_hashinfo ipt_hash_info
 
 static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int hook)
 {
-	struct ipt_target *target;
+	struct xt_target *target;
 	int ret = 0;
 
 	target = xt_request_find_target(AF_INET, t->u.user.name,
