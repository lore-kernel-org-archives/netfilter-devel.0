From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/49]: x_tables: struct xt_table_info diet
Date: Tue,  4 Dec 2007 13:02:01 +0100 (MET)
Message-ID: <20071204120200.2442.89438.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62104 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbXLDMCC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:02 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: x_tables: struct xt_table_info diet

Instead of using a big array of NR_CPUS entries, we can compute the size
needed at runtime, using nr_cpu_ids

This should save some ram (especially on David's machines where NR_CPUS=4096 :
32 KB can be saved per table, and 64KB for dynamically allocated ones (because
of slab/slub alignements) )

In particular, the 'bootstrap' tables are not any more static (in data
section) but on stack as their size is now very small.

This also should reduce the size used on stack in compat functions
(get_info() declares an automatic variable, that could be bigger than kernel
stack size for big NR_CPUS)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e648b28460f8bcbdb6293ce66b99735efa31a1ee
tree d0e9de24d3746bbcb1b6bdd39a5f21c6cfd5b609
parent 15b20d2de585dd83c73067783150c667d1229259
author Eric Dumazet <dada1@cosmosbay.com> Tue, 04 Dec 2007 10:46:56 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:46:56 +0100

 include/linux/netfilter/x_tables.h |    5 ++++-
 net/ipv4/netfilter/arp_tables.c    |    5 ++---
 net/ipv4/netfilter/ip_tables.c     |   24 +++++++++---------------
 net/ipv6/netfilter/ip6_tables.c    |    5 ++---
 net/netfilter/x_tables.c           |    2 +-
 5 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 9657c4e..e305f2d 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -269,9 +269,12 @@ struct xt_table_info
 	unsigned int underflow[NF_INET_NUMHOOKS];
 
 	/* ipt_entry tables: one per CPU */
-	char *entries[NR_CPUS];
+	/* Note : this field MUST be the last one, see XT_TABLE_INFO_SZ */
+	char *entries[1];
 };
 
+#define XT_TABLE_INFO_SZ (offsetof(struct xt_table_info, entries) \
+			  + nr_cpu_ids * sizeof(char *))
 extern int xt_register_target(struct xt_target *target);
 extern void xt_unregister_target(struct xt_target *target);
 extern int xt_register_targets(struct xt_target *target, unsigned int n);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 2909c92..a21722d 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -811,8 +811,7 @@ static int do_replace(void __user *user, unsigned int len)
 		return -ENOPROTOOPT;
 
 	/* overflow check */
-	if (tmp.size >= (INT_MAX - sizeof(struct xt_table_info)) / NR_CPUS -
-			SMP_CACHE_BYTES)
+	if (tmp.size >= INT_MAX / num_possible_cpus())
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
@@ -1090,7 +1089,7 @@ int arpt_register_table(struct arpt_table *table,
 {
 	int ret;
 	struct xt_table_info *newinfo;
-	static struct xt_table_info bootstrap
+	struct xt_table_info bootstrap
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 	void *loc_cpu_entry;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index a99fe89..4200fde 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1090,7 +1090,8 @@ compat_calc_match(struct ipt_entry_match *m, int * size)
 	return 0;
 }
 
-static int compat_calc_entry(struct ipt_entry *e, struct xt_table_info *info,
+static int compat_calc_entry(struct ipt_entry *e,
+		const struct xt_table_info *info,
 		void *base, struct xt_table_info *newinfo)
 {
 	struct ipt_entry_target *t;
@@ -1118,22 +1119,17 @@ static int compat_calc_entry(struct ipt_entry *e, struct xt_table_info *info,
 	return 0;
 }
 
-static int compat_table_info(struct xt_table_info *info,
+static int compat_table_info(const struct xt_table_info *info,
 		struct xt_table_info *newinfo)
 {
 	void *loc_cpu_entry;
-	int i;
 
 	if (!newinfo || !info)
 		return -EINVAL;
 
-	memset(newinfo, 0, sizeof(struct xt_table_info));
-	newinfo->size = info->size;
-	newinfo->number = info->number;
-	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
-		newinfo->hook_entry[i] = info->hook_entry[i];
-		newinfo->underflow[i] = info->underflow[i];
-	}
+	/* we dont care about newinfo->entries[] */
+	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
+	newinfo->initial_entries = 0;
 	loc_cpu_entry = info->entries[raw_smp_processor_id()];
 	return IPT_ENTRY_ITERATE(loc_cpu_entry, info->size,
 			compat_calc_entry, info, loc_cpu_entry, newinfo);
@@ -1327,8 +1323,7 @@ do_replace(void __user *user, unsigned int len)
 		return -ENOPROTOOPT;
 
 	/* overflow check */
-	if (tmp.size >= (INT_MAX - sizeof(struct xt_table_info)) / NR_CPUS -
-			SMP_CACHE_BYTES)
+	if (tmp.size >= INT_MAX / num_possible_cpus())
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
@@ -1861,8 +1856,7 @@ compat_do_replace(void __user *user, unsigned int len)
 		return -ENOPROTOOPT;
 
 	/* overflow check */
-	if (tmp.size >= (INT_MAX - sizeof(struct xt_table_info)) / NR_CPUS -
-			SMP_CACHE_BYTES)
+	if (tmp.size >= INT_MAX / num_possible_cpus())
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
@@ -2159,7 +2153,7 @@ int ipt_register_table(struct xt_table *table, const struct ipt_replace *repl)
 {
 	int ret;
 	struct xt_table_info *newinfo;
-	static struct xt_table_info bootstrap
+	struct xt_table_info bootstrap
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 	void *loc_cpu_entry;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e1e87ef..e60c1b4 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1042,8 +1042,7 @@ do_replace(void __user *user, unsigned int len)
 		return -EFAULT;
 
 	/* overflow check */
-	if (tmp.size >= (INT_MAX - sizeof(struct xt_table_info)) / NR_CPUS -
-			SMP_CACHE_BYTES)
+	if (tmp.size >= INT_MAX / num_possible_cpus())
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
@@ -1339,7 +1338,7 @@ int ip6t_register_table(struct xt_table *table,
 {
 	int ret;
 	struct xt_table_info *newinfo;
-	static struct xt_table_info bootstrap
+	struct xt_table_info bootstrap
 		= { 0, 0, 0, { 0 }, { 0 }, { } };
 	void *loc_cpu_entry;
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d9a3bde..862b27d 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -495,7 +495,7 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > num_physpages)
 		return NULL;
 
-	newinfo = kzalloc(sizeof(struct xt_table_info), GFP_KERNEL);
+	newinfo = kzalloc(XT_TABLE_INFO_SZ, GFP_KERNEL);
 	if (!newinfo)
 		return NULL;
 
