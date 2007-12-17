From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 29/64]: arp_tables: move counter allocation to seperate function
Date: Tue, 18 Dec 2007 00:46:52 +0100 (MET)
Message-ID: <20071217234652.23601.27443.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38965 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852AbXLQXqx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:53 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: arp_tables: move counter allocation to seperate function

More resyncing with ip_tables.c as preparation for compat support.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f858d36b5f774655b3dd9a08a6502a8e2df1bb63
tree 0cc2b6613b2c3aeff5c1881f2a7729781ba69fd6
parent d0ccbefbca69eff49883e5ad964a5f13172aef0d
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:12 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:55 +0100

 net/ipv4/netfilter/arp_tables.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index b0f4331..eaca06e 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -706,16 +706,11 @@ static void get_counters(const struct xt_table_info *t,
 	}
 }
 
-static int copy_entries_to_user(unsigned int total_size,
-				struct arpt_table *table,
-				void __user *userptr)
+static inline struct xt_counters *alloc_counters(struct arpt_table *table)
 {
-	unsigned int off, num, countersize;
-	struct arpt_entry *e;
+	unsigned int countersize;
 	struct xt_counters *counters;
 	struct xt_table_info *private = table->private;
-	int ret = 0;
-	void *loc_cpu_entry;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	 * (other than comefrom, which userspace doesn't care
@@ -725,13 +720,31 @@ static int copy_entries_to_user(unsigned int total_size,
 	counters = vmalloc_node(countersize, numa_node_id());
 
 	if (counters == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	/* First, sum counters... */
 	write_lock_bh(&table->lock);
 	get_counters(private, counters);
 	write_unlock_bh(&table->lock);
 
+	return counters;
+}
+
+static int copy_entries_to_user(unsigned int total_size,
+				struct arpt_table *table,
+				void __user *userptr)
+{
+	unsigned int off, num;
+	struct arpt_entry *e;
+	struct xt_counters *counters;
+	struct xt_table_info *private = table->private;
+	int ret = 0;
+	void *loc_cpu_entry;
+
+	counters = alloc_counters(table);
+	if (IS_ERR(counters))
+		return PTR_ERR(counters);
+
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	/* ... then copy entire thing ... */
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
