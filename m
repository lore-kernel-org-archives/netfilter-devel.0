From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 071/103] netfilter: ip6tables: move mark_chains to xt1_perproto.c
Date: Tue,  4 Aug 2009 09:25:55 +0200
Message-ID: <1249370787-17583-72-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56950 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594AbZHDH1u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:50 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In xt2, the xt1compat blob is not translated into xt1 anymore, but
directly to xt2. So we need a mark_chains that handles struct
compat_ip6t_entry.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv6/netfilter/ip6_tables.c |  119 +--------------------------------------
 net/netfilter/xt1_translat.c    |  111 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 112 insertions(+), 118 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2f14ef4..464930a 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -67,9 +67,6 @@ do {								\
 #define inline
 #endif
 
-static int mark_source_chains(const struct xt_table_info *,
-	unsigned int, void *);
-
 #define xtsub_entry           ip6t_entry
 #define xtsub_replace         ip6t_replace
 #define xtsub_error_target    ip6t_error_target
@@ -556,118 +553,6 @@ ip6t_do_table(struct sk_buff *skb,
 #endif
 }
 
-/* Figures out from what hook each rule can be called: returns 0 if
-   there are loops.  Puts hook bitmask in comefrom. */
-static int
-mark_source_chains(const struct xt_table_info *newinfo,
-		   unsigned int valid_hooks, void *entry0)
-{
-	unsigned int hook;
-
-	/* No recursion; use packet counter to save back ptrs (reset
-	   to 0 as we leave), and comefrom to save source hook bitmask */
-	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
-		unsigned int pos = newinfo->hook_entry[hook];
-		struct ip6t_entry *e = (struct ip6t_entry *)(entry0 + pos);
-
-		if (!(valid_hooks & (1 << hook)))
-			continue;
-
-		/* Set initial back pointer. */
-		e->counters.pcnt = pos;
-
-		for (;;) {
-			const struct ip6t_standard_target *t
-				= (void *)ip6t_get_target_c(e);
-			int visited = e->comefrom & (1 << hook);
-
-			if (e->comefrom & (1 << NF_INET_NUMHOOKS)) {
-				printk("iptables: loop hook %u pos %u %08X.\n",
-				       hook, pos, e->comefrom);
-				return 0;
-			}
-			e->comefrom |= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
-
-			/* Unconditional return/END. */
-			if ((e->target_offset == sizeof(struct ip6t_entry)
-			    && (strcmp(t->target.u.user.name,
-				       IP6T_STANDARD_TARGET) == 0)
-			    && t->verdict < 0
-			    && unconditional(&e->ipv6)) || visited) {
-				unsigned int oldpos, size;
-
-				if ((strcmp(t->target.u.user.name,
-					    IP6T_STANDARD_TARGET) == 0) &&
-				    t->verdict < -NF_MAX_VERDICT - 1) {
-					duprintf("mark_source_chains: bad "
-						"negative verdict (%i)\n",
-								t->verdict);
-					return 0;
-				}
-
-				/* Return: backtrack through the last
-				   big jump. */
-				do {
-					e->comefrom ^= (1<<NF_INET_NUMHOOKS);
-#ifdef DEBUG_IP_FIREWALL_USER
-					if (e->comefrom
-					    & (1 << NF_INET_NUMHOOKS)) {
-						duprintf("Back unset "
-							 "on hook %u "
-							 "rule %u\n",
-							 hook, pos);
-					}
-#endif
-					oldpos = pos;
-					pos = e->counters.pcnt;
-					e->counters.pcnt = 0;
-
-					/* We're at the start. */
-					if (pos == oldpos)
-						goto next;
-
-					e = (struct ip6t_entry *)
-						(entry0 + pos);
-				} while (oldpos == pos + e->next_offset);
-
-				/* Move along one */
-				size = e->next_offset;
-				e = (struct ip6t_entry *)
-					(entry0 + pos + size);
-				e->counters.pcnt = pos;
-				pos += size;
-			} else {
-				int newpos = t->verdict;
-
-				if (strcmp(t->target.u.user.name,
-					   IP6T_STANDARD_TARGET) == 0
-				    && newpos >= 0) {
-					if (newpos > newinfo->size -
-						sizeof(struct ip6t_entry)) {
-						duprintf("mark_source_chains: "
-							"bad verdict (%i)\n",
-								newpos);
-						return 0;
-					}
-					/* This a jump; chase it. */
-					duprintf("Jump rule %u -> %u\n",
-						 pos, newpos);
-				} else {
-					/* ... this is a fallthru */
-					newpos = pos + e->next_offset;
-				}
-				e = (struct ip6t_entry *)
-					(entry0 + newpos);
-				e->counters.pcnt = pos;
-				pos = newpos;
-			}
-		}
-		next:
-		duprintf("Finished chain %u\n", hook);
-	}
-	return 1;
-}
-
 static void cleanup_match(struct ip6t_entry_match *m)
 {
 	struct xt_mtdtor_param par;
@@ -944,7 +829,7 @@ translate_table(struct xt_table_info *newinfo, void *entry0,
 		}
 	}
 
-	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0))
+	if (!ip6t2_mark_chains(newinfo, repl->valid_hooks, entry0))
 		return -ELOOP;
 
 	/* Finally, each sanity check must pass */
@@ -1903,7 +1788,7 @@ translate_compat_table(const char *name,
 		goto free_newinfo;
 
 	ret = -ELOOP;
-	if (!mark_source_chains(newinfo, valid_hooks, entry1))
+	if (!ip6t2_mark_chains(newinfo, valid_hooks, entry1))
 		goto free_newinfo;
 
 	i = 0;
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index f88a72b..a975a41 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -210,6 +210,115 @@ XTSUB2(rule_to_xt2)(struct xt2_chain *chain, const struct xtsub_entry *entry,
 	return ERR_PTR(ret);
 }
 
+/* Figures out from what hook each rule can be called: returns 0 if
+   there are loops.  Puts hook bitmask in comefrom. */
+static int
+XTSUB2(mark_chains)(const struct xt_table_info *newinfo,
+		    unsigned int valid_hooks, void *entry0)
+{
+	unsigned int hook;
+
+	/* No recursion; use packet counter to save back ptrs (reset
+	   to 0 as we leave), and comefrom to save source hook bitmask */
+	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
+		unsigned int pos = newinfo->hook_entry[hook];
+		struct xtsub_entry *e = (void *)(entry0 + pos);
+
+		if (!(valid_hooks & (1 << hook)))
+			continue;
+
+		/* Set initial back pointer. */
+		e->counters.pcnt = pos;
+
+		for (;;) {
+			const struct xt_standard_target *t
+				= (void *)XTSUB2(get_target)(e);
+			int visited = e->comefrom & (1 << hook);
+
+			if (e->comefrom & (1 << NF_INET_NUMHOOKS)) {
+				printk("iptables: loop hook %u pos %u %08X.\n",
+				       hook, pos, e->comefrom);
+				return false;
+			}
+			e->comefrom |= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
+
+			/* Unconditional return/END. */
+			if ((e->target_offset == sizeof(struct xtsub_entry) &&
+			    strcmp(t->target.u.user.name,
+				       XT_STANDARD_TARGET) == 0 &&
+			    t->verdict < 0 &&
+			    XTSUB2(unconditional)(e)) || visited) {
+				unsigned int oldpos, size;
+
+				if (strcmp(t->target.u.user.name,
+					   XT_STANDARD_TARGET) == 0 &&
+				    t->verdict < -NF_MAX_VERDICT - 1) {
+					pr_devel("mark_chains: bad "
+						"negative verdict (%i)\n",
+								t->verdict);
+					return false;
+				}
+
+				/* Return: backtrack through the last
+				   big jump. */
+				do {
+					e->comefrom ^= (1<<NF_INET_NUMHOOKS);
+#ifdef DEBUG_IP_FIREWALL_USER
+					if (e->comefrom
+					    & (1 << NF_INET_NUMHOOKS)) {
+						pr_devel("Back unset "
+							 "on hook %u "
+							 "rule %u\n",
+							 hook, pos);
+					}
+#endif
+					oldpos = pos;
+					pos = e->counters.pcnt;
+					e->counters.pcnt = 0;
+
+					/* We're at the start. */
+					if (pos == oldpos)
+						goto next;
+
+					e = (void *)(entry0 + pos);
+				} while (oldpos == pos + e->next_offset);
+
+				/* Move along one */
+				size = e->next_offset;
+				e = (void *)(entry0 + pos + size);
+				e->counters.pcnt = pos;
+				pos += size;
+			} else {
+				int newpos = t->verdict;
+
+				if (strcmp(t->target.u.user.name,
+					   XT_STANDARD_TARGET) == 0
+				    && newpos >= 0) {
+					if (newpos > newinfo->size -
+						sizeof(struct xtsub_entry)) {
+						pr_devel("mark_chains: "
+							"bad verdict (%i)\n",
+								newpos);
+						return false;
+					}
+					/* This a jump; chase it. */
+					pr_devel("Jump rule %u -> %u\n",
+						 pos, newpos);
+				} else {
+					/* ... this is a fallthru */
+					newpos = pos + e->next_offset;
+				}
+				e = (void *)(entry0 + newpos);
+				e->counters.pcnt = pos;
+				pos = newpos;
+			}
+		}
+ next:
+		pr_devel("Finished chain %u\n", hook);
+	}
+	return true;
+}
+
 /**
  * @table:	new table
  * @entry0:	blob of <struct ip6t_entry>s
@@ -251,7 +360,7 @@ static int XTSUB2(table_to_xt2)(struct xt2_table *table, void *entry0,
 	memcpy(mark_param.hook_entry, repl->hook_entry,
 	       sizeof(repl->hook_entry));
 	mark_param.size = repl->size;
-	if (!mark_source_chains(&mark_param, repl->valid_hooks, entry0))
+	if (!XTSUB2(mark_chains)(&mark_param, repl->valid_hooks, entry0))
 		return -ELOOP;
 
 	/* Now process rules. */
-- 
1.6.3.3

