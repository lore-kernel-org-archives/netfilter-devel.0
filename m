From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 01/17] netfilter: x_tables: don't move to non-existent next rule
Date: Fri,  1 Apr 2016 14:17:21 +0200
Message-ID: <1459513057-30652-2-git-send-email-fw@strlen.de>
References: <1459513057-30652-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46457 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808AbcDAMRX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2016 08:17:23 -0400
In-Reply-To: <1459513057-30652-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ben Hawkes says:

 In the mark_source_chains function (net/ipv4/netfilter/ip_tables.c) it
 is possible for a user-supplied ipt_entry structure to have a large
 next_offset field. This field is not bounds checked prior to writing a
 counter value at the supplied offset.

Base chains enforce absolute verdict.

User defined chains are supposed to end with an unconditional return,
xtables userspace adds them automatically.

But if such return is missing we will move to non-existent next rule.

Reported-by: Ben Hawkes <hawkes@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 8 +++++---
 net/ipv4/netfilter/ip_tables.c  | 4 ++++
 net/ipv6/netfilter/ip6_tables.c | 4 ++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 4133b0f..82a434b 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -439,6 +439,8 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 				size = e->next_offset;
 				e = (struct arpt_entry *)
 					(entry0 + pos + size);
+				if (pos + size >= newinfo->size)
+					return 0;
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
@@ -461,6 +463,8 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
+					if (newpos >= newinfo->size)
+						return 0;
 				}
 				e = (struct arpt_entry *)
 					(entry0 + newpos);
@@ -691,10 +695,8 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 		}
 	}
 
-	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0)) {
-		duprintf("Looping hook\n");
+	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0))
 		return -ELOOP;
-	}
 
 	/* Finally, each sanity check must pass */
 	i = 0;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 631c100..e301a3d 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -520,6 +520,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				size = e->next_offset;
 				e = (struct ipt_entry *)
 					(entry0 + pos + size);
+				if (pos + size >= newinfo->size)
+					return 0;
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
@@ -541,6 +543,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
+					if (newpos >= newinfo->size)
+						return 0;
 				}
 				e = (struct ipt_entry *)
 					(entry0 + newpos);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 86b67b7..7b3335b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -532,6 +532,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				size = e->next_offset;
 				e = (struct ip6t_entry *)
 					(entry0 + pos + size);
+				if (pos + size >= newinfo->size)
+					return 0;
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
@@ -553,6 +555,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
+					if (newpos >= newinfo->size)
+						return 0;
 				}
 				e = (struct ip6t_entry *)
 					(entry0 + newpos);
-- 
2.7.3

