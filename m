From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -stable 3.12.y] netfilter: x_tables: speed up jump target validation
Date: Mon,  1 Aug 2016 20:38:20 +0200
Message-ID: <1470076704-13325-2-git-send-email-fw@strlen.de>
References: <1470076704-13325-1-git-send-email-fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, stable@kernel.org,
	alexander.levin@verizon.com, Florian Westphal <fw@strlen.de>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46540 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741AbcHATTM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 15:19:12 -0400
In-Reply-To: <1470076704-13325-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[ Upstream commit f4dc77713f8016d2e8a3295e1c9c53a21f296def ]

The dummy ruleset I used to test the original validation change was broken,
most rules were unreachable and were not tested by mark_source_chains().

In some cases rulesets that used to load in a few seconds now require
several minutes.

sample ruleset that shows the behaviour:

echo "*filter"
for i in $(seq 0 100000);do
        printf ":chain_%06x - [0:0]\n" $i
done
for i in $(seq 0 100000);do
   printf -- "-A INPUT -j chain_%06x\n" $i
   printf -- "-A INPUT -j chain_%06x\n" $i
   printf -- "-A INPUT -j chain_%06x\n" $i
done
echo COMMIT

[ pipe result into iptables-restore ]

This ruleset will be about 74mbyte in size, with ~500k searches
though all 500k[1] rule entries. iptables-restore will take forever
(gave up after 10 minutes)

Instead of always searching the entire blob for a match, fill an
array with the start offsets of every single ipt_entry struct,
then do a binary search to check if the jump target is present or not.

After this change ruleset restore times get again close to what one
gets when reverting 36472341017529e (~3 seconds on my workstation).

[1] every user-defined rule gets an implicit RETURN, so we get
300k jumps + 100k userchains + 100k returns -> 500k rule entries

Fixes: 36472341017529e ("netfilter: x_tables: validate targets of jumps")
Reported-by: Jeff Wu <wujiafu@gmail.com>
Tested-by: Jeff Wu <wujiafu@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h |  4 +++
 net/ipv4/netfilter/arp_tables.c    | 39 ++++++++++++++++++++++-------
 net/ipv4/netfilter/ip_tables.c     | 34 ++++++++++++++++++++------
 net/ipv6/netfilter/ip6_tables.c    | 33 +++++++++++++++++++------
 net/netfilter/x_tables.c           | 50 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 137 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 1d24aa7..07d6b44 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -243,6 +243,10 @@ int xt_check_entry_offsets(const void *base, const char *elems,
 			   unsigned int target_offset,
 			   unsigned int next_offset);
 
+unsigned int *xt_alloc_entry_offsets(unsigned int size);
+bool xt_find_jump_offset(const unsigned int *offsets,
+			 unsigned int target, unsigned int size);
+
 extern int xt_check_match(struct xt_mtchk_param *,
 			  unsigned int size, u_int8_t proto, bool inv_proto);
 extern int xt_check_target(struct xt_tgchk_param *,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 95a5f26..83e276a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -362,7 +362,8 @@ static inline bool unconditional(const struct arpt_entry *e)
  * there are loops.  Puts hook bitmask in comefrom.
  */
 static int mark_source_chains(const struct xt_table_info *newinfo,
-			      unsigned int valid_hooks, void *entry0)
+			      unsigned int valid_hooks, void *entry0,
+			      unsigned int *offsets)
 {
 	unsigned int hook;
 
@@ -451,6 +452,11 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
+					if (!xt_find_jump_offset(offsets, newpos,
+								 newinfo->number))
+						return 0;
+					e = (struct arpt_entry *)
+						(entry0 + newpos);
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -610,6 +616,7 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
                            const struct arpt_replace *repl)
 {
 	struct arpt_entry *iter;
+	unsigned int *offsets;
 	unsigned int i;
 	int ret = 0;
 
@@ -623,8 +630,12 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	}
 
 	duprintf("translate_table: size %u\n", newinfo->size);
-	i = 0;
 
+	offsets = xt_alloc_entry_offsets(newinfo->number);
+	if (!offsets)
+		return -ENOMEM;
+
+	i = 0;
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
@@ -633,7 +644,9 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 						 repl->underflow,
 						 repl->valid_hooks);
 		if (ret != 0)
-			break;
+			goto out_free;
+		if (i < repl->num_entries)
+			offsets[i] = (void *)iter - entry0;
 		++i;
 		if (strcmp(arpt_get_target(iter)->u.user.name,
 		    XT_ERROR_TARGET) == 0)
@@ -641,12 +654,13 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	}
 	duprintf("translate_table: ARPT_ENTRY_ITERATE gives %d\n", ret);
 	if (ret != 0)
-		return ret;
+		goto out_free;
 
+	ret = -EINVAL;
 	if (i != repl->num_entries) {
 		duprintf("translate_table: %u not %u entries\n",
 			 i, repl->num_entries);
-		return -EINVAL;
+		goto out_free;
 	}
 
 	/* Check hooks all assigned */
@@ -654,20 +668,24 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 		/* Only hooks which are valid */
 		if (!(repl->valid_hooks & (1 << i)))
 			continue;
+
 		if (newinfo->hook_entry[i] == 0xFFFFFFFF) {
 			duprintf("Invalid hook entry %u %u\n",
 				 i, repl->hook_entry[i]);
-			return -EINVAL;
+			goto out_free;
 		}
 		if (newinfo->underflow[i] == 0xFFFFFFFF) {
 			duprintf("Invalid underflow %u %u\n",
 				 i, repl->underflow[i]);
-			return -EINVAL;
+			goto out_free;
 		}
 	}
 
-	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0))
-		return -ELOOP;
+	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0, offsets)) {
+		ret = -ELOOP;
+		goto out_free;
+	}
+	kvfree(offsets);
 
 	/* Finally, each sanity check must pass */
 	i = 0;
@@ -694,6 +712,9 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	}
 
 	return ret;
+ out_free:
+	kvfree(offsets);
+	return ret;
 }
 
 static void get_counters(const struct xt_table_info *t,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 92c8f27..1657cc1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -438,7 +438,8 @@ ipt_do_table(struct sk_buff *skb,
    there are loops.  Puts hook bitmask in comefrom. */
 static int
 mark_source_chains(const struct xt_table_info *newinfo,
-		   unsigned int valid_hooks, void *entry0)
+		   unsigned int valid_hooks, void *entry0,
+		   unsigned int *offsets)
 {
 	unsigned int hook;
 
@@ -531,6 +532,11 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
+					if (!xt_find_jump_offset(offsets, newpos,
+								 newinfo->number))
+						return 0;
+					e = (struct ipt_entry *)
+						(entry0 + newpos);
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -777,6 +783,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
                 const struct ipt_replace *repl)
 {
 	struct ipt_entry *iter;
+	unsigned int *offsets;
 	unsigned int i;
 	int ret = 0;
 
@@ -790,6 +797,10 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	}
 
 	duprintf("translate_table: size %u\n", newinfo->size);
+
+	offsets = xt_alloc_entry_offsets(newinfo->number);
+	if (!offsets)
+		return -ENOMEM;
 	i = 0;
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
@@ -799,17 +810,20 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 						 repl->underflow,
 						 repl->valid_hooks);
 		if (ret != 0)
-			return ret;
+			goto out_free;
+		if (i < repl->num_entries)
+			offsets[i] = (void *)iter - entry0;
 		++i;
 		if (strcmp(ipt_get_target(iter)->u.user.name,
 		    XT_ERROR_TARGET) == 0)
 			++newinfo->stacksize;
 	}
 
+	ret = -EINVAL;
 	if (i != repl->num_entries) {
 		duprintf("translate_table: %u not %u entries\n",
 			 i, repl->num_entries);
-		return -EINVAL;
+		goto out_free;
 	}
 
 	/* Check hooks all assigned */
@@ -820,17 +834,20 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 		if (newinfo->hook_entry[i] == 0xFFFFFFFF) {
 			duprintf("Invalid hook entry %u %u\n",
 				 i, repl->hook_entry[i]);
-			return -EINVAL;
+			goto out_free;
 		}
 		if (newinfo->underflow[i] == 0xFFFFFFFF) {
 			duprintf("Invalid underflow %u %u\n",
 				 i, repl->underflow[i]);
-			return -EINVAL;
+			goto out_free;
 		}
 	}
 
-	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0))
-		return -ELOOP;
+	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0, offsets)) {
+		ret = -ELOOP;
+		goto out_free;
+	}
+	kvfree(offsets);
 
 	/* Finally, each sanity check must pass */
 	i = 0;
@@ -857,6 +874,9 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	}
 
 	return ret;
+ out_free:
+	kvfree(offsets);
+	return ret;
 }
 
 static void
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e214222..d24ff5d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -448,7 +448,8 @@ ip6t_do_table(struct sk_buff *skb,
    there are loops.  Puts hook bitmask in comefrom. */
 static int
 mark_source_chains(const struct xt_table_info *newinfo,
-		   unsigned int valid_hooks, void *entry0)
+		   unsigned int valid_hooks, void *entry0,
+		   unsigned int *offsets)
 {
 	unsigned int hook;
 
@@ -541,6 +542,11 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
+					if (!xt_find_jump_offset(offsets, newpos,
+								 newinfo->number))
+						return 0;
+					e = (struct ip6t_entry *)
+						(entry0 + newpos);
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -787,6 +793,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
                 const struct ip6t_replace *repl)
 {
 	struct ip6t_entry *iter;
+	unsigned int *offsets;
 	unsigned int i;
 	int ret = 0;
 
@@ -800,6 +807,9 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	}
 
 	duprintf("translate_table: size %u\n", newinfo->size);
+	offsets = xt_alloc_entry_offsets(newinfo->number);
+	if (!offsets)
+		return -ENOMEM;
 	i = 0;
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
@@ -809,17 +819,20 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 						 repl->underflow,
 						 repl->valid_hooks);
 		if (ret != 0)
-			return ret;
+			goto out_free;
+		if (i < repl->num_entries)
+			offsets[i] = (void *)iter - entry0;
 		++i;
 		if (strcmp(ip6t_get_target(iter)->u.user.name,
 		    XT_ERROR_TARGET) == 0)
 			++newinfo->stacksize;
 	}
 
+	ret = -EINVAL;
 	if (i != repl->num_entries) {
 		duprintf("translate_table: %u not %u entries\n",
 			 i, repl->num_entries);
-		return -EINVAL;
+		goto out_free;
 	}
 
 	/* Check hooks all assigned */
@@ -830,17 +843,20 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 		if (newinfo->hook_entry[i] == 0xFFFFFFFF) {
 			duprintf("Invalid hook entry %u %u\n",
 				 i, repl->hook_entry[i]);
-			return -EINVAL;
+			goto out_free;
 		}
 		if (newinfo->underflow[i] == 0xFFFFFFFF) {
 			duprintf("Invalid underflow %u %u\n",
 				 i, repl->underflow[i]);
-			return -EINVAL;
+			goto out_free;
 		}
 	}
 
-	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0))
-		return -ELOOP;
+	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0, offsets)) {
+		ret = -ELOOP;
+		goto out_free;
+	}
+	kvfree(offsets);
 
 	/* Finally, each sanity check must pass */
 	i = 0;
@@ -867,6 +883,9 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	}
 
 	return ret;
+ out_free:
+	kvfree(offsets);
+	return ret;
 }
 
 static void
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 51c141b..94ce5ff 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -721,6 +721,56 @@ int xt_check_entry_offsets(const void *base,
 }
 EXPORT_SYMBOL(xt_check_entry_offsets);
 
+/**
+ * xt_alloc_entry_offsets - allocate array to store rule head offsets
+ *
+ * @size: number of entries
+ *
+ * Return: NULL or kmalloc'd or vmalloc'd array
+ */
+unsigned int *xt_alloc_entry_offsets(unsigned int size)
+{
+	unsigned int *off;
+
+	off = kcalloc(size, sizeof(unsigned int), GFP_KERNEL | __GFP_NOWARN);
+
+	if (off)
+		return off;
+
+	if (size < (SIZE_MAX / sizeof(unsigned int)))
+		off = vmalloc(size * sizeof(unsigned int));
+
+	return off;
+}
+EXPORT_SYMBOL(xt_alloc_entry_offsets);
+
+/**
+ * xt_find_jump_offset - check if target is a valid jump offset
+ *
+ * @offsets: array containing all valid rule start offsets of a rule blob
+ * @target: the jump target to search for
+ * @size: entries in @offset
+ */
+bool xt_find_jump_offset(const unsigned int *offsets,
+			 unsigned int target, unsigned int size)
+{
+	int m, low = 0, hi = size;
+
+	while (hi > low) {
+		m = (low + hi) / 2u;
+
+		if (offsets[m] > target)
+			hi = m;
+		else if (offsets[m] < target)
+			low = m + 1;
+		else
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(xt_find_jump_offset);
+
 int xt_check_target(struct xt_tgchk_param *par,
 		    unsigned int size, u_int8_t proto, bool inv_proto)
 {
-- 
2.7.3

