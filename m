From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 46/47] Revert "netfilter: x_tables: ensure last rule in base chain matches underflow/policy"
Date: Fri, 30 Mar 2018 13:46:18 +0200
Message-ID: <20180330114619.18797-7-pablo@netfilter.org>
References: <20180330114619.18797-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114619.18797-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This reverts commit 0d7df906a0e78079a02108b06d32c3ef2238ad25.

Valdis Kletnieks reported that xtables is broken in linux-next since
0d7df906a0e78  ("netfilter: x_tables: ensure last rule in base chain
matches underflow/policy"), as kernel rejects the (well-formed) ruleset:

[   64.402790] ip6_tables: last base chain position 1136 doesn't match underflow 1344 (hook 1)

mark_source_chains is not the correct place for such a check, as it
terminates evaluation of a chain once it sees an unconditional verdict
(following rules are known to be unreachable). It seems preferrable to
fix libiptc instead, so remove this check again.

Fixes: 0d7df906a0e78 ("netfilter: x_tables: ensure last rule in base chain matches underflow/policy")
Reported-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arp_tables.c | 17 +----------------
 net/ipv4/netfilter/ip_tables.c  | 17 +----------------
 net/ipv6/netfilter/ip6_tables.c | 17 +----------------
 3 files changed, 3 insertions(+), 48 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f366ff1cfc19..aaafdbd15ad3 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -309,13 +309,10 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 	for (hook = 0; hook < NF_ARP_NUMHOOKS; hook++) {
 		unsigned int pos = newinfo->hook_entry[hook];
 		struct arpt_entry *e = entry0 + pos;
-		unsigned int last_pos, depth;
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
 
-		depth = 0;
-		last_pos = pos;
 		/* Set initial back pointer. */
 		e->counters.pcnt = pos;
 
@@ -346,8 +343,6 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 					pos = e->counters.pcnt;
 					e->counters.pcnt = 0;
 
-					if (depth)
-						--depth;
 					/* We're at the start. */
 					if (pos == oldpos)
 						goto next;
@@ -372,9 +367,6 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
 						return 0;
-
-					if (entry0 + newpos != arpt_next_entry(e))
-						++depth;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -385,15 +377,8 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos = newpos;
 			}
-			if (depth == 0)
-				last_pos = pos;
-		}
-next:
-		if (last_pos != newinfo->underflow[hook]) {
-			pr_err_ratelimited("last base chain position %u doesn't match underflow %u (hook %u)\n",
-					   last_pos, newinfo->underflow[hook], hook);
-			return 0;
 		}
+next:		;
 	}
 	return 1;
 }
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2362ca2c9e0c..f9063513f9d1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -378,13 +378,10 @@ mark_source_chains(const struct xt_table_info *newinfo,
 	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
 		unsigned int pos = newinfo->hook_entry[hook];
 		struct ipt_entry *e = entry0 + pos;
-		unsigned int last_pos, depth;
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
 
-		depth = 0;
-		last_pos = pos;
 		/* Set initial back pointer. */
 		e->counters.pcnt = pos;
 
@@ -413,8 +410,6 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					pos = e->counters.pcnt;
 					e->counters.pcnt = 0;
 
-					if (depth)
-						--depth;
 					/* We're at the start. */
 					if (pos == oldpos)
 						goto next;
@@ -439,9 +434,6 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
 						return 0;
-
-					if (entry0 + newpos != ipt_next_entry(e))
-						++depth;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -452,15 +444,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos = newpos;
 			}
-			if (depth == 0)
-				last_pos = pos;
-		}
-next:
-		if (last_pos != newinfo->underflow[hook]) {
-			pr_err_ratelimited("last base chain position %u doesn't match underflow %u (hook %u)\n",
-					   last_pos, newinfo->underflow[hook], hook);
-			return 0;
 		}
+next:		;
 	}
 	return 1;
 }
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 004508753abc..3c36a4c77f29 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -396,13 +396,10 @@ mark_source_chains(const struct xt_table_info *newinfo,
 	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
 		unsigned int pos = newinfo->hook_entry[hook];
 		struct ip6t_entry *e = entry0 + pos;
-		unsigned int last_pos, depth;
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
 
-		depth = 0;
-		last_pos = pos;
 		/* Set initial back pointer. */
 		e->counters.pcnt = pos;
 
@@ -431,8 +428,6 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					pos = e->counters.pcnt;
 					e->counters.pcnt = 0;
 
-					if (depth)
-						--depth;
 					/* We're at the start. */
 					if (pos == oldpos)
 						goto next;
@@ -457,9 +452,6 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
 						return 0;
-
-					if (entry0 + newpos != ip6t_next_entry(e))
-						++depth;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -470,15 +462,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos = newpos;
 			}
-			if (depth == 0)
-				last_pos = pos;
-		}
-next:
-		if (last_pos != newinfo->underflow[hook]) {
-			pr_err_ratelimited("last base chain position %u doesn't match underflow %u (hook %u)\n",
-					   last_pos, newinfo->underflow[hook], hook);
-			return 0;
 		}
+next:		;
 	}
 	return 1;
 }
-- 
2.11.0
