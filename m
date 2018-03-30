From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/47] netfilter: x_tables: ensure last rule in base chain matches underflow/policy
Date: Fri, 30 Mar 2018 13:38:44 +0200
Message-ID: <20180330113914.18431-8-pablo@netfilter.org>
References: <20180330113914.18431-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113914.18431-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Harmless from kernel point of view, but again iptables assumes that
this is true when decoding ruleset coming from kernel.

If a (syzkaller generated) ruleset doesn't have the underflow/policy
stored as the last rule in the base chain, then iptables will abort()
because it doesn't find the chain policy.

libiptc assumes that the policy is the last rule in the basechain, which
is only true for iptables-generated rulesets.

Unfortunately this needs code duplication -- the functions need the
struct layout of the rule head, but that is different for
ip/ip6/arptables.

NB: pr_warn could be pr_debug but in case this break rulesets somehow its
useful to know why blob was rejected.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arp_tables.c | 17 ++++++++++++++++-
 net/ipv4/netfilter/ip_tables.c  | 17 ++++++++++++++++-
 net/ipv6/netfilter/ip6_tables.c | 17 ++++++++++++++++-
 3 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index aaafdbd15ad3..f366ff1cfc19 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -309,10 +309,13 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 	for (hook = 0; hook < NF_ARP_NUMHOOKS; hook++) {
 		unsigned int pos = newinfo->hook_entry[hook];
 		struct arpt_entry *e = entry0 + pos;
+		unsigned int last_pos, depth;
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
 
+		depth = 0;
+		last_pos = pos;
 		/* Set initial back pointer. */
 		e->counters.pcnt = pos;
 
@@ -343,6 +346,8 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 					pos = e->counters.pcnt;
 					e->counters.pcnt = 0;
 
+					if (depth)
+						--depth;
 					/* We're at the start. */
 					if (pos == oldpos)
 						goto next;
@@ -367,6 +372,9 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
 						return 0;
+
+					if (entry0 + newpos != arpt_next_entry(e))
+						++depth;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -377,8 +385,15 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos = newpos;
 			}
+			if (depth == 0)
+				last_pos = pos;
+		}
+next:
+		if (last_pos != newinfo->underflow[hook]) {
+			pr_err_ratelimited("last base chain position %u doesn't match underflow %u (hook %u)\n",
+					   last_pos, newinfo->underflow[hook], hook);
+			return 0;
 		}
-next:		;
 	}
 	return 1;
 }
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f9063513f9d1..2362ca2c9e0c 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -378,10 +378,13 @@ mark_source_chains(const struct xt_table_info *newinfo,
 	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
 		unsigned int pos = newinfo->hook_entry[hook];
 		struct ipt_entry *e = entry0 + pos;
+		unsigned int last_pos, depth;
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
 
+		depth = 0;
+		last_pos = pos;
 		/* Set initial back pointer. */
 		e->counters.pcnt = pos;
 
@@ -410,6 +413,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					pos = e->counters.pcnt;
 					e->counters.pcnt = 0;
 
+					if (depth)
+						--depth;
 					/* We're at the start. */
 					if (pos == oldpos)
 						goto next;
@@ -434,6 +439,9 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
 						return 0;
+
+					if (entry0 + newpos != ipt_next_entry(e))
+						++depth;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -444,8 +452,15 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos = newpos;
 			}
+			if (depth == 0)
+				last_pos = pos;
+		}
+next:
+		if (last_pos != newinfo->underflow[hook]) {
+			pr_err_ratelimited("last base chain position %u doesn't match underflow %u (hook %u)\n",
+					   last_pos, newinfo->underflow[hook], hook);
+			return 0;
 		}
-next:		;
 	}
 	return 1;
 }
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 3c36a4c77f29..004508753abc 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -396,10 +396,13 @@ mark_source_chains(const struct xt_table_info *newinfo,
 	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
 		unsigned int pos = newinfo->hook_entry[hook];
 		struct ip6t_entry *e = entry0 + pos;
+		unsigned int last_pos, depth;
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
 
+		depth = 0;
+		last_pos = pos;
 		/* Set initial back pointer. */
 		e->counters.pcnt = pos;
 
@@ -428,6 +431,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					pos = e->counters.pcnt;
 					e->counters.pcnt = 0;
 
+					if (depth)
+						--depth;
 					/* We're at the start. */
 					if (pos == oldpos)
 						goto next;
@@ -452,6 +457,9 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
 						return 0;
+
+					if (entry0 + newpos != ip6t_next_entry(e))
+						++depth;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -462,8 +470,15 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos = newpos;
 			}
+			if (depth == 0)
+				last_pos = pos;
+		}
+next:
+		if (last_pos != newinfo->underflow[hook]) {
+			pr_err_ratelimited("last base chain position %u doesn't match underflow %u (hook %u)\n",
+					   last_pos, newinfo->underflow[hook], hook);
+			return 0;
 		}
-next:		;
 	}
 	return 1;
 }
-- 
2.11.0
