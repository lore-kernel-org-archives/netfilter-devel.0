From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -stable 4.1.y] netfilter: x_tables: speed up jump target validation
Date: Mon,  1 Aug 2016 20:38:23 +0200
Message-ID: <1470076704-13325-5-git-send-email-fw@strlen.de>
References: <1470076704-13325-1-git-send-email-fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, stable@kernel.org,
	alexander.levin@verizon.com, Florian Westphal <fw@strlen.de>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46506 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863AbcHATPO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 15:15:14 -0400
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
 net/ipv4/netfilter/arp_tables.c    | 47 +++++++++++++++++------------------
 net/ipv4/netfilter/ip_tables.c     | 45 ++++++++++++++++++----------------
 net/ipv6/netfilter/ip6_tables.c    | 45 ++++++++++++++++++----------------
 net/netfilter/x_tables.c           | 50 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 126 insertions(+), 65 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 7741efa..cc615e2 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -243,6 +243,10 @@ int xt_check_entry_offsets(const void *base, const char *elems,
 			   unsigned int target_offset,
 			   unsigned int next_offset);
 
+unsigned int *xt_alloc_entry_offsets(unsigned int size);
+bool xt_find_jump_offset(const unsigned int *offsets,
+			 unsigned int target, unsigned int size);
+
 int xt_check_match(struct xt_mtchk_param *, unsigned int size, u_int8_t proto,
 		   bool inv_proto);
 int xt_check_target(struct xt_tgchk_param *, unsigned int size, u_int8_t proto,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 2953ee9..ebf5821c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -362,23 +362,12 @@ static inline bool unconditional(const struct arpt_entry *e)
 	       memcmp(&e->arp, &uncond, sizeof(uncond)) == 0;
 }
 
-static bool find_jump_target(const struct xt_table_info *t,
-			     const struct arpt_entry *target)
-{
-	struct arpt_entry *iter;
-
-	xt_entry_foreach(iter, t->entries, t->size) {
-		 if (iter == target)
-			return true;
-	}
-	return false;
-}
-
 /* Figures out from what hook each rule can be called: returns 0 if
  * there are loops.  Puts hook bitmask in comefrom.
  */
 static int mark_source_chains(const struct xt_table_info *newinfo,
-			      unsigned int valid_hooks, void *entry0)
+			      unsigned int valid_hooks, void *entry0,
+			      unsigned int *offsets)
 {
 	unsigned int hook;
 
@@ -467,10 +456,11 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
+					if (!xt_find_jump_offset(offsets, newpos,
+								 newinfo->number))
+						return 0;
 					e = (struct arpt_entry *)
 						(entry0 + newpos);
-					if (!find_jump_target(newinfo, e))
-						return 0;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -630,6 +620,7 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
                            const struct arpt_replace *repl)
 {
 	struct arpt_entry *iter;
+	unsigned int *offsets;
 	unsigned int i;
 	int ret = 0;
 
@@ -643,6 +634,9 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	}
 
 	duprintf("translate_table: size %u\n", newinfo->size);
+	offsets = xt_alloc_entry_offsets(newinfo->number);
+	if (!offsets)
+		return -ENOMEM;
 	i = 0;
 
 	/* Walk through entries, checking offsets. */
@@ -653,20 +647,21 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
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
 			++newinfo->stacksize;
 	}
 	duprintf("translate_table: ARPT_ENTRY_ITERATE gives %d\n", ret);
-	if (ret != 0)
-		return ret;
 
+	ret = -EINVAL;
 	if (i != repl->num_entries) {
 		duprintf("translate_table: %u not %u entries\n",
 			 i, repl->num_entries);
-		return -EINVAL;
+		goto out_free;
 	}
 
 	/* Check hooks all assigned */
@@ -677,17 +672,20 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
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
@@ -714,6 +712,9 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	}
 
 	return ret;
+ out_free:
+	kvfree(offsets);
+	return ret;
 }
 
 static void get_counters(const struct xt_table_info *t,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 3bcf28b..8e729cb 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -438,23 +438,12 @@ ipt_do_table(struct sk_buff *skb,
 #endif
 }
 
-static bool find_jump_target(const struct xt_table_info *t,
-			     const struct ipt_entry *target)
-{
-	struct ipt_entry *iter;
-
-	xt_entry_foreach(iter, t->entries, t->size) {
-		 if (iter == target)
-			return true;
-	}
-	return false;
-}
-
 /* Figures out from what hook each rule can be called: returns 0 if
    there are loops.  Puts hook bitmask in comefrom. */
 static int
 mark_source_chains(const struct xt_table_info *newinfo,
-		   unsigned int valid_hooks, void *entry0)
+		   unsigned int valid_hooks, void *entry0,
+		   unsigned int *offsets)
 {
 	unsigned int hook;
 
@@ -547,10 +536,11 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
+					if (!xt_find_jump_offset(offsets, newpos,
+								 newinfo->number))
+						return 0;
 					e = (struct ipt_entry *)
 						(entry0 + newpos);
-					if (!find_jump_target(newinfo, e))
-						return 0;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -797,6 +787,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
                 const struct ipt_replace *repl)
 {
 	struct ipt_entry *iter;
+	unsigned int *offsets;
 	unsigned int i;
 	int ret = 0;
 
@@ -810,6 +801,9 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	}
 
 	duprintf("translate_table: size %u\n", newinfo->size);
+	offsets = xt_alloc_entry_offsets(newinfo->number);
+	if (!offsets)
+		return -ENOMEM;
 	i = 0;
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
@@ -819,17 +813,20 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
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
@@ -840,17 +837,20 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
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
@@ -877,6 +877,9 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	}
 
 	return ret;
+ out_free:
+	kvfree(offsets);
+	return ret;
 }
 
 static void
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 5254d76..98e99fa 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -451,23 +451,12 @@ ip6t_do_table(struct sk_buff *skb,
 #endif
 }
 
-static bool find_jump_target(const struct xt_table_info *t,
-			     const struct ip6t_entry *target)
-{
-	struct ip6t_entry *iter;
-
-	xt_entry_foreach(iter, t->entries, t->size) {
-		 if (iter == target)
-			return true;
-	}
-	return false;
-}
-
 /* Figures out from what hook each rule can be called: returns 0 if
    there are loops.  Puts hook bitmask in comefrom. */
 static int
 mark_source_chains(const struct xt_table_info *newinfo,
-		   unsigned int valid_hooks, void *entry0)
+		   unsigned int valid_hooks, void *entry0,
+		   unsigned int *offsets)
 {
 	unsigned int hook;
 
@@ -560,10 +549,11 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
+					if (!xt_find_jump_offset(offsets, newpos,
+								 newinfo->number))
+						return 0;
 					e = (struct ip6t_entry *)
 						(entry0 + newpos);
-					if (!find_jump_target(newinfo, e))
-						return 0;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -810,6 +800,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
                 const struct ip6t_replace *repl)
 {
 	struct ip6t_entry *iter;
+	unsigned int *offsets;
 	unsigned int i;
 	int ret = 0;
 
@@ -823,6 +814,9 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	}
 
 	duprintf("translate_table: size %u\n", newinfo->size);
+	offsets = xt_alloc_entry_offsets(newinfo->number);
+	if (!offsets)
+		return -ENOMEM;
 	i = 0;
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
@@ -832,17 +826,20 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
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
@@ -853,17 +850,20 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
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
@@ -890,6 +890,9 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	}
 
 	return ret;
+ out_free:
+	kvfree(offsets);
+	return ret;
 }
 
 static void
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 4b850c6..703fc9b 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -704,6 +704,56 @@ int xt_check_entry_offsets(const void *base,
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

