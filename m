From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v2] netfilter: x_tables: don't rely on well-behaving userspace
Date: Thu, 10 Mar 2016 17:26:39 +0100
Message-ID: <1457627199-14766-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44366 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308AbcCJQ02 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 11:26:28 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ben Hawkes says:

 In the mark_source_chains function (net/ipv4/netfilter/ip_tables.c) it
 is possible for a user-supplied ipt_entry structure to have a large
 next_offset field. This field is not bounds checked prior to writing a
 counter value at the supplied offset.

Problem is that xt_entry_foreach() macro stops iterating once e->next_offset
is out of bounds, assuming this is the last entry.

With malformed data thats not necessarily the case so we can
write outside of allocated area later as we might not have walked the
entire blob.

Fix this by simplifying mark_source_chains -- it already has to check
if nextoff is in range to catch invalid jumps, so just do the check
when we move to a next entry as well.

Also, check that the offset meets the xtables_entry alignment.

Reported-by: Ben Hawkes <hawkes@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 25 +++++++++++++++++--------
 net/ipv4/netfilter/ip_tables.c  | 24 +++++++++++++++++-------
 net/ipv6/netfilter/ip6_tables.c | 24 +++++++++++++++++-------
 3 files changed, 51 insertions(+), 22 deletions(-)

Change since v1: also verify that target of jump is aligned to xt_entry struct.

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index b488cac..76533d4 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -366,6 +366,17 @@ static inline bool unconditional(const struct arpt_arp *arp)
 	return memcmp(arp, &uncond, sizeof(uncond)) == 0;
 }
 
+static bool next_offset_ok(const struct xt_table_info *t, unsigned int newpos)
+{
+	if (newpos > t->size - sizeof(struct arpt_entry))
+		return false;
+
+	if (newpos % __alignof__(struct arpt_entry) != 0)
+		return false;
+
+	return true;
+}
+
 /* Figures out from what hook each rule can be called: returns 0 if
  * there are loops.  Puts hook bitmask in comefrom.
  */
@@ -437,6 +448,8 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 
 				/* Move along one */
 				size = e->next_offset;
+				if (!next_offset_ok(newinfo, pos + size))
+					return 0;
 				e = (struct arpt_entry *)
 					(entry0 + pos + size);
 				e->counters.pcnt = pos;
@@ -447,14 +460,6 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
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
@@ -462,6 +467,10 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
 				}
+
+				if (!next_offset_ok(newinfo, newpos))
+					return 0;
+
 				e = (struct arpt_entry *)
 					(entry0 + newpos);
 				e->counters.pcnt = pos;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index b99affa..71a09a8 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -443,6 +443,17 @@ ipt_do_table(struct sk_buff *skb,
 #endif
 }
 
+static bool next_offset_ok(const struct xt_table_info *t, unsigned int newpos)
+{
+	if (newpos > t->size - sizeof(struct ipt_entry))
+		return false;
+
+	if (newpos % __alignof__(struct ipt_entry) != 0)
+		return false;
+
+	return true;
+}
+
 /* Figures out from what hook each rule can be called: returns 0 if
    there are loops.  Puts hook bitmask in comefrom. */
 static int
@@ -519,6 +530,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 
 				/* Move along one */
 				size = e->next_offset;
+				if (!next_offset_ok(newinfo, pos + size))
+					return 0;
 				e = (struct ipt_entry *)
 					(entry0 + pos + size);
 				e->counters.pcnt = pos;
@@ -529,13 +542,6 @@ mark_source_chains(const struct xt_table_info *newinfo,
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
@@ -543,6 +549,10 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
 				}
+
+				if (!next_offset_ok(newinfo, newpos))
+					return 0;
+
 				e = (struct ipt_entry *)
 					(entry0 + newpos);
 				e->counters.pcnt = pos;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 99425cf..80edfe6 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -455,6 +455,17 @@ ip6t_do_table(struct sk_buff *skb,
 #endif
 }
 
+static bool next_offset_ok(const struct xt_table_info *t, unsigned int newpos)
+{
+	if (newpos > t->size - sizeof(struct ip6t_entry))
+		return false;
+
+	if (newpos % __alignof__(struct ip6t_entry) != 0)
+		return false;
+
+	return true;
+}
+
 /* Figures out from what hook each rule can be called: returns 0 if
    there are loops.  Puts hook bitmask in comefrom. */
 static int
@@ -531,6 +542,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 
 				/* Move along one */
 				size = e->next_offset;
+				if (!next_offset_ok(newinfo, pos + size))
+					return 0;
 				e = (struct ip6t_entry *)
 					(entry0 + pos + size);
 				e->counters.pcnt = pos;
@@ -541,13 +554,6 @@ mark_source_chains(const struct xt_table_info *newinfo,
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
@@ -555,6 +561,10 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
 				}
+
+				if (!next_offset_ok(newinfo, newpos))
+					return 0;
+
 				e = (struct ip6t_entry *)
 					(entry0 + newpos);
 				e->counters.pcnt = pos;
-- 
2.4.10

