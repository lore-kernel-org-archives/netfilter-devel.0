From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 5/5] netfilter: x_tables: don't move to non-existant next rule
Date: Tue, 22 Mar 2016 18:02:53 +0100
Message-ID: <1458666173-24318-6-git-send-email-fw@strlen.de>
References: <1458666173-24318-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38142 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874AbcCVRCx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 13:02:53 -0400
In-Reply-To: <1458666173-24318-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ben Hawkes reported an out-of-bounds write in mark_source_chains().
This was caused by improper underflow check -- we should have bailed
earlier.

The underflow check has been fixed in the preceeding change
("netfilter: x_tables: fix unconditional helper").

Just to be safe also add checks to mark_source_chains() in case we have other
bugs that would cause such a condition.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 8 +++++---
 net/ipv4/netfilter/ip_tables.c  | 4 ++++
 net/ipv6/netfilter/ip6_tables.c | 4 ++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index a2002ff..13266f4 100644
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
@@ -682,10 +686,8 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
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
index 45b1d97..c4836f0 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -520,6 +520,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				size = e->next_offset;
 				e = (struct ipt_entry *)
 					(entry0 + pos + size);
+				if (WARN_ON(pos + size >= newinfo->size))
+					return 0;
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
@@ -541,6 +543,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
+					if (WARN_ON(newpos >= newinfo->size))
+						return 0;
 				}
 				e = (struct ipt_entry *)
 					(entry0 + newpos);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 85c0942..ab7cdbf 100644
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
2.4.10

