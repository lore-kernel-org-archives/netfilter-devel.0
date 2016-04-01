From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 16/17] netfilter: x_tables: remove obsolete check
Date: Fri,  1 Apr 2016 14:17:36 +0200
Message-ID: <1459513057-30652-17-git-send-email-fw@strlen.de>
References: <1459513057-30652-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46488 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464AbcDAMSN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2016 08:18:13 -0400
In-Reply-To: <1459513057-30652-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since 'netfilter: x_tables: validate targets of jumps' change we
validate that the target aligns exactly with beginning of a rule,
so offset test is now redundant.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 8 --------
 net/ipv4/netfilter/ip_tables.c  | 7 -------
 net/ipv6/netfilter/ip6_tables.c | 7 -------
 3 files changed, 22 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 668c5dc..8cefb7a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -461,14 +461,6 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
 				    newpos >= 0) {
-					if (newpos > newinfo->size -
-						sizeof(struct arpt_entry)) {
-						duprintf("mark_source_chains: "
-							"bad verdict (%i)\n",
-								newpos);
-						return 0;
-					}
-
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4585aa7..9340ce0 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -542,13 +542,6 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
 				    newpos >= 0) {
-					if (newpos > newinfo->size -
-						sizeof(struct ipt_entry)) {
-						duprintf("mark_source_chains: "
-							"bad verdict (%i)\n",
-								newpos);
-						return 0;
-					}
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index fd06251..aa01085 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -554,13 +554,6 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
 				    newpos >= 0) {
-					if (newpos > newinfo->size -
-						sizeof(struct ip6t_entry)) {
-						duprintf("mark_source_chains: "
-							"bad verdict (%i)\n",
-								newpos);
-						return 0;
-					}
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
-- 
2.7.3

