From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 037/103] netfilter: xtables: reduce arguments to translate_table
Date: Tue,  4 Aug 2009 09:25:21 +0200
Message-ID: <1249370787-17583-38-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50631 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539AbZHDH1N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:13 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just pass in the entire repl struct. In case of a new table (e.g.
ip6t_register_table), the repldata has been previously filled with
table->name and table->size already (in xt_repldata_create).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arp_tables.c |   42 +++++++++++++-------------------------
 net/ipv4/netfilter/ip_tables.c  |   41 +++++++++++++------------------------
 net/ipv6/netfilter/ip6_tables.c |   41 +++++++++++++------------------------
 3 files changed, 45 insertions(+), 79 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 26b7157..79ee12f 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -616,21 +616,15 @@ static inline void cleanup_entry(struct arpt_entry *e)
 /* Checks and translates the user-supplied table segment (held in
  * newinfo).
  */
-static int translate_table(const char *name,
-			   unsigned int valid_hooks,
-			   struct xt_table_info *newinfo,
-			   void *entry0,
-			   unsigned int size,
-			   unsigned int number,
-			   const unsigned int *hook_entries,
-			   const unsigned int *underflows)
+static int translate_table(struct xt_table_info *newinfo, void *entry0,
+                           const struct arpt_replace *repl)
 {
 	struct arpt_entry *iter;
 	unsigned int i;
 	int ret = 0;
 
-	newinfo->size = size;
-	newinfo->number = number;
+	newinfo->size = repl->size;
+	newinfo->number = repl->num_entries;
 
 	/* Init all hooks to impossible value. */
 	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
@@ -644,7 +638,8 @@ static int translate_table(const char *name,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
-		      entry0 + size, hook_entries, underflows, valid_hooks);
+		      entry0 + repl->size, repl->hook_entry, repl->underflow,
+		      repl->valid_hooks);
 		if (ret != 0)
 			break;
 		++i;
@@ -653,30 +648,30 @@ static int translate_table(const char *name,
 	if (ret != 0)
 		return ret;
 
-	if (i != number) {
+	if (i != repl->num_entries) {
 		duprintf("translate_table: %u not %u entries\n",
-			 i, number);
+			 i, repl->num_entries);
 		return -EINVAL;
 	}
 
 	/* Check hooks all assigned */
 	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
 		/* Only hooks which are valid */
-		if (!(valid_hooks & (1 << i)))
+		if (!(repl->valid_hooks & (1 << i)))
 			continue;
 		if (newinfo->hook_entry[i] == 0xFFFFFFFF) {
 			duprintf("Invalid hook entry %u %u\n",
-				 i, hook_entries[i]);
+				 i, repl->hook_entry[i]);
 			return -EINVAL;
 		}
 		if (newinfo->underflow[i] == 0xFFFFFFFF) {
 			duprintf("Invalid underflow %u %u\n",
-				 i, underflows[i]);
+				 i, repl->underflow[i]);
 			return -EINVAL;
 		}
 	}
 
-	if (!mark_source_chains(newinfo, valid_hooks, entry0)) {
+	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0)) {
 		duprintf("Looping hook\n");
 		return -ELOOP;
 	}
@@ -684,7 +679,7 @@ static int translate_table(const char *name,
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, name, size);
+		ret = find_check_entry(iter, repl->name, repl->size);
 		if (ret != 0)
 			break;
 		++i;
@@ -1095,9 +1090,7 @@ static int do_replace(struct net *net, const void __user *user,
 		goto free_newinfo;
 	}
 
-	ret = translate_table(tmp.name, tmp.valid_hooks,
-			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
-			      tmp.hook_entry, tmp.underflow);
+	ret = translate_table(newinfo, loc_cpu_entry, &tmp);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -1789,12 +1782,7 @@ struct xt_table *arpt_register_table(struct net *net,
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
-	ret = translate_table(table->name, table->valid_hooks,
-			      newinfo, loc_cpu_entry, repl->size,
-			      repl->num_entries,
-			      repl->hook_entry,
-			      repl->underflow);
-
+	ret = translate_table(newinfo, loc_cpu_entry, repl);
 	duprintf("arpt_register_table: translate table gives %d\n", ret);
 	if (ret != 0)
 		goto out_free;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 5e92076..bde4754 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -803,21 +803,15 @@ cleanup_entry(struct ipt_entry *e)
 /* Checks and translates the user-supplied table segment (held in
    newinfo) */
 static int
-translate_table(const char *name,
-		unsigned int valid_hooks,
-		struct xt_table_info *newinfo,
-		void *entry0,
-		unsigned int size,
-		unsigned int number,
-		const unsigned int *hook_entries,
-		const unsigned int *underflows)
+translate_table(struct xt_table_info *newinfo, void *entry0,
+                const struct ipt_replace *repl)
 {
 	struct ipt_entry *iter;
 	unsigned int i;
 	int ret = 0;
 
-	newinfo->size = size;
-	newinfo->number = number;
+	newinfo->size = repl->size;
+	newinfo->number = repl->num_entries;
 
 	/* Init all hooks to impossible value. */
 	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
@@ -830,42 +824,43 @@ translate_table(const char *name,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
-		      entry0 + size, hook_entries, underflows, valid_hooks);
+		      entry0 + repl->size, repl->hook_entry, repl->underflow,
+		      repl->valid_hooks);
 		if (ret != 0)
 			return ret;
 		++i;
 	}
 
-	if (i != number) {
+	if (i != repl->num_entries) {
 		duprintf("translate_table: %u not %u entries\n",
-			 i, number);
+			 i, repl->num_entries);
 		return -EINVAL;
 	}
 
 	/* Check hooks all assigned */
 	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
 		/* Only hooks which are valid */
-		if (!(valid_hooks & (1 << i)))
+		if (!(repl->valid_hooks & (1 << i)))
 			continue;
 		if (newinfo->hook_entry[i] == 0xFFFFFFFF) {
 			duprintf("Invalid hook entry %u %u\n",
-				 i, hook_entries[i]);
+				 i, repl->hook_entry[i]);
 			return -EINVAL;
 		}
 		if (newinfo->underflow[i] == 0xFFFFFFFF) {
 			duprintf("Invalid underflow %u %u\n",
-				 i, underflows[i]);
+				 i, repl->underflow[i]);
 			return -EINVAL;
 		}
 	}
 
-	if (!mark_source_chains(newinfo, valid_hooks, entry0))
+	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0))
 		return -ELOOP;
 
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, name, size);
+		ret = find_check_entry(iter, repl->name, repl->size);
 		if (ret != 0)
 			break;
 		++i;
@@ -1299,9 +1294,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 		goto free_newinfo;
 	}
 
-	ret = translate_table(tmp.name, tmp.valid_hooks,
-			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
-			      tmp.hook_entry, tmp.underflow);
+	ret = translate_table(newinfo, loc_cpu_entry, &tmp);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -2098,11 +2091,7 @@ struct xt_table *ipt_register_table(struct net *net,
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
-	ret = translate_table(table->name, table->valid_hooks,
-			      newinfo, loc_cpu_entry, repl->size,
-			      repl->num_entries,
-			      repl->hook_entry,
-			      repl->underflow);
+	ret = translate_table(newinfo, loc_cpu_entry, repl);
 	if (ret != 0)
 		goto out_free;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index b335ce7..c491249 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -833,21 +833,15 @@ static void cleanup_entry(struct ip6t_entry *e)
 /* Checks and translates the user-supplied table segment (held in
    newinfo) */
 static int
-translate_table(const char *name,
-		unsigned int valid_hooks,
-		struct xt_table_info *newinfo,
-		void *entry0,
-		unsigned int size,
-		unsigned int number,
-		const unsigned int *hook_entries,
-		const unsigned int *underflows)
+translate_table(struct xt_table_info *newinfo, void *entry0,
+                const struct ip6t_replace *repl)
 {
 	struct ip6t_entry *iter;
 	unsigned int i;
 	int ret = 0;
 
-	newinfo->size = size;
-	newinfo->number = number;
+	newinfo->size = repl->size;
+	newinfo->number = repl->num_entries;
 
 	/* Init all hooks to impossible value. */
 	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
@@ -860,42 +854,43 @@ translate_table(const char *name,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
-		      entry0 + size, hook_entries, underflows, valid_hooks);
+		      entry0 + repl->size, repl->hook_entry, repl->underflow,
+		      repl->valid_hooks);
 		if (ret != 0)
 			return ret;
 		++i;
 	}
 
-	if (i != number) {
+	if (i != repl->num_entries) {
 		duprintf("translate_table: %u not %u entries\n",
-			 i, number);
+			 i, repl->num_entries);
 		return -EINVAL;
 	}
 
 	/* Check hooks all assigned */
 	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
 		/* Only hooks which are valid */
-		if (!(valid_hooks & (1 << i)))
+		if (!(repl->valid_hooks & (1 << i)))
 			continue;
 		if (newinfo->hook_entry[i] == 0xFFFFFFFF) {
 			duprintf("Invalid hook entry %u %u\n",
-				 i, hook_entries[i]);
+				 i, repl->hook_entry[i]);
 			return -EINVAL;
 		}
 		if (newinfo->underflow[i] == 0xFFFFFFFF) {
 			duprintf("Invalid underflow %u %u\n",
-				 i, underflows[i]);
+				 i, repl->underflow[i]);
 			return -EINVAL;
 		}
 	}
 
-	if (!mark_source_chains(newinfo, valid_hooks, entry0))
+	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0))
 		return -ELOOP;
 
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, name, size);
+		ret = find_check_entry(iter, repl->name, repl->size);
 		if (ret != 0)
 			break;
 		++i;
@@ -1330,9 +1325,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 		goto free_newinfo;
 	}
 
-	ret = translate_table(tmp.name, tmp.valid_hooks,
-			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
-			      tmp.hook_entry, tmp.underflow);
+	ret = translate_table(newinfo, loc_cpu_entry, &tmp);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -2130,11 +2123,7 @@ struct xt_table *ip6t_register_table(struct net *net,
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
-	ret = translate_table(table->name, table->valid_hooks,
-			      newinfo, loc_cpu_entry, repl->size,
-			      repl->num_entries,
-			      repl->hook_entry,
-			      repl->underflow);
+	ret = translate_table(newinfo, loc_cpu_entry, repl);
 	if (ret != 0)
 		goto out_free;
 
-- 
1.6.3.3

