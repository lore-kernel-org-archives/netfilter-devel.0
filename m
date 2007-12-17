From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/64]: ip6_tables: move counter allocation to seperate function
Date: Tue, 18 Dec 2007 00:46:27 +0100 (MET)
Message-ID: <20071217234627.23601.63581.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38911 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbXLQXq2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:28 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_tables: move counter allocation to seperate function

More resyncing with ip_tables.c as preparation for compat support.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0d3ec012848cbfbdce1903f38af6991c81651ba8
tree 587a1824676535bbb9a698072a932f2d5726b4e3
parent 125dae23b2336fed2aa57e04b0afc4b185610789
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:46 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:19 +0100

 net/ipv6/netfilter/ip6_tables.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d0b5fa6..02be4fc 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -943,17 +943,11 @@ get_counters(const struct xt_table_info *t,
 	}
 }
 
-static int
-copy_entries_to_user(unsigned int total_size,
-		     struct xt_table *table,
-		     void __user *userptr)
+static inline struct xt_counters *alloc_counters(struct xt_table *table)
 {
-	unsigned int off, num, countersize;
-	struct ip6t_entry *e;
+	unsigned int countersize;
 	struct xt_counters *counters;
 	struct xt_table_info *private = table->private;
-	int ret = 0;
-	void *loc_cpu_entry;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -962,13 +956,32 @@ copy_entries_to_user(unsigned int total_size,
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
+static int
+copy_entries_to_user(unsigned int total_size,
+		     struct xt_table *table,
+		     void __user *userptr)
+{
+	unsigned int off, num;
+	struct ip6t_entry *e;
+	struct xt_counters *counters;
+	struct xt_table_info *private = table->private;
+	int ret = 0;
+	void *loc_cpu_entry;
+
+	counters = alloc_counters(table);
+	if (IS_ERR(counters))
+		return PTR_ERR(counters);
+
 	/* choose the copy that is on ourc node/cpu */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
