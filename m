From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: x_tables: ensure e->next_offset consistency with table size
Date: Fri, 18 Mar 2016 22:58:45 +0100
Message-ID: <1458338325-1456-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de, mkubecek@suse.cz, hawkes@google.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48689 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbcCRV7F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 17:59:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5B2CA4B0F5
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 22:59:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 24065DA380
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 22:59:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2B444DA380
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 22:58:58 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces the generic __xt_entry_foreach() that includes a
new parameter to account for remaining entry bytes in the table that we
didn't walk so far. If the amount of remaining bytes is zero, then we
keep validating this table, otherwise for < 0 we just reject this.

Reported-by: Ben Hawkes <hawkes@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Slightly tested here, will be spinning on this again with more testing
tomorrow morning. I'll appreciate any extra hand on testing this
further.

 include/linux/netfilter/x_tables.h | 10 ++++++++++
 net/ipv4/netfilter/arp_tables.c    | 17 +++++++++++++++--
 net/ipv4/netfilter/ip_tables.c     | 16 ++++++++++++++--
 net/ipv6/netfilter/ip6_tables.c    | 16 ++++++++++++++--
 4 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index c557741..1206830 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -411,6 +411,16 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
 void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
 
+/* Similar to xt_entry_foreach, but this tell us how many bytes are remaining
+ * after the iteration. If remain is < 0 then this table we're iterating over
+ * is wrong.
+ */
+#define __xt_entry_foreach(pos, ehead, esize, remain)			\
+	for ((pos) = (typeof(pos))(ehead), (remain) = (esize);		\
+	     (pos) < (typeof(pos))((char *)(ehead) + (esize));		\
+	     (remain) -= (pos)->next_offset,				\
+	     (pos) = (typeof(pos))((char *)(pos) + (pos)->next_offset))
+
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index b488cac..9081cda 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -637,6 +637,7 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	struct arpt_entry *iter;
 	unsigned int i;
 	int ret = 0;
+	s64 remain;
 
 	newinfo->size = repl->size;
 	newinfo->number = repl->num_entries;
@@ -651,7 +652,7 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	i = 0;
 
 	/* Walk through entries, checking offsets. */
-	xt_entry_foreach(iter, entry0, newinfo->size) {
+	__xt_entry_foreach(iter, entry0, newinfo->size, remain) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
 						 entry0 + repl->size,
 						 repl->hook_entry,
@@ -664,6 +665,12 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 		    XT_ERROR_TARGET) == 0)
 			++newinfo->stacksize;
 	}
+
+	if (remain < 0) {
+		pr_debug("translate_table: cannot check %lld bytes\n", remain);
+		return -EINVAL;
+	}
+
 	duprintf("translate_table: ARPT_ENTRY_ITERATE gives %d\n", ret);
 	if (ret != 0)
 		return ret;
@@ -1340,6 +1347,7 @@ static int translate_compat_table(const char *name,
 	struct arpt_entry *iter1;
 	unsigned int size;
 	int ret = 0;
+	s64 remain;
 
 	info = *pinfo;
 	entry0 = *pentry0;
@@ -1357,7 +1365,7 @@ static int translate_compat_table(const char *name,
 	xt_compat_lock(NFPROTO_ARP);
 	xt_compat_init_offsets(NFPROTO_ARP, number);
 	/* Walk through entries, checking offsets. */
-	xt_entry_foreach(iter0, entry0, total_size) {
+	__xt_entry_foreach(iter0, entry0, total_size, remain) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
 							entry0,
 							entry0 + total_size,
@@ -1370,6 +1378,11 @@ static int translate_compat_table(const char *name,
 	}
 
 	ret = -EINVAL;
+	if (remain < 0) {
+		pr_debug("translate_compat_table: cannot check %lld bytes\n", remain);
+		goto out_unlock;
+	}
+
 	if (j != number) {
 		duprintf("translate_compat_table: %u not %u entries\n",
 			 j, number);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index b99affa..ff29fe1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -809,6 +809,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	struct ipt_entry *iter;
 	unsigned int i;
 	int ret = 0;
+	s64 remain;
 
 	newinfo->size = repl->size;
 	newinfo->number = repl->num_entries;
@@ -822,7 +823,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	duprintf("translate_table: size %u\n", newinfo->size);
 	i = 0;
 	/* Walk through entries, checking offsets. */
-	xt_entry_foreach(iter, entry0, newinfo->size) {
+	__xt_entry_foreach(iter, entry0, newinfo->size, remain) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
 						 entry0 + repl->size,
 						 repl->hook_entry,
@@ -836,6 +837,11 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 			++newinfo->stacksize;
 	}
 
+	if (remain < 0) {
+		pr_debug("translate_table: cannot check %lld bytes\n", remain);
+		return -EINVAL;
+	}
+
 	if (i != repl->num_entries) {
 		duprintf("translate_table: %u not %u entries\n",
 			 i, repl->num_entries);
@@ -1661,6 +1667,7 @@ translate_compat_table(struct net *net,
 	struct compat_ipt_entry *iter0;
 	struct ipt_entry *iter1;
 	unsigned int size;
+	s64 remain;
 	int ret;
 
 	info = *pinfo;
@@ -1679,7 +1686,7 @@ translate_compat_table(struct net *net,
 	xt_compat_lock(AF_INET);
 	xt_compat_init_offsets(AF_INET, number);
 	/* Walk through entries, checking offsets. */
-	xt_entry_foreach(iter0, entry0, total_size) {
+	__xt_entry_foreach(iter0, entry0, total_size, remain) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
 							entry0,
 							entry0 + total_size,
@@ -1692,6 +1699,11 @@ translate_compat_table(struct net *net,
 	}
 
 	ret = -EINVAL;
+	if (remain < 0) {
+		pr_debug("translate_compat_table: cannot check %lld bytes\n", remain);
+		goto out_unlock;
+	}
+
 	if (j != number) {
 		duprintf("translate_compat_table: %u not %u entries\n",
 			 j, number);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 99425cf..40f1292 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -821,6 +821,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	struct ip6t_entry *iter;
 	unsigned int i;
 	int ret = 0;
+	s64 remain;
 
 	newinfo->size = repl->size;
 	newinfo->number = repl->num_entries;
@@ -834,7 +835,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	duprintf("translate_table: size %u\n", newinfo->size);
 	i = 0;
 	/* Walk through entries, checking offsets. */
-	xt_entry_foreach(iter, entry0, newinfo->size) {
+	__xt_entry_foreach(iter, entry0, newinfo->size, remain) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
 						 entry0 + repl->size,
 						 repl->hook_entry,
@@ -848,6 +849,11 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 			++newinfo->stacksize;
 	}
 
+	if (remain < 0) {
+		pr_debug("translate_table: cannot check %lld bytes\n", remain);
+		return -EINVAL;
+	}
+
 	if (i != repl->num_entries) {
 		duprintf("translate_table: %u not %u entries\n",
 			 i, repl->num_entries);
@@ -1671,6 +1677,7 @@ translate_compat_table(struct net *net,
 	struct ip6t_entry *iter1;
 	unsigned int size;
 	int ret = 0;
+	s64 remain;
 
 	info = *pinfo;
 	entry0 = *pentry0;
@@ -1688,7 +1695,7 @@ translate_compat_table(struct net *net,
 	xt_compat_lock(AF_INET6);
 	xt_compat_init_offsets(AF_INET6, number);
 	/* Walk through entries, checking offsets. */
-	xt_entry_foreach(iter0, entry0, total_size) {
+	__xt_entry_foreach(iter0, entry0, total_size, remain) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
 							entry0,
 							entry0 + total_size,
@@ -1701,6 +1708,11 @@ translate_compat_table(struct net *net,
 	}
 
 	ret = -EINVAL;
+	if (remain < 0) {
+		pr_debug("translate_compat_table: cannot check %lld bytes\n", remain);
+		goto out_unlock;
+	}
+
 	if (j != number) {
 		duprintf("translate_compat_table: %u not %u entries\n",
 			 j, number);
-- 
2.1.4

