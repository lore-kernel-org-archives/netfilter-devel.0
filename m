From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/4] netfilter: xtables: validate targets of jumps
Date: Sat, 19 Mar 2016 22:51:33 +0100
Message-ID: <1458424294-8678-3-git-send-email-fw@strlen.de>
References: <1458424294-8678-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35267 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932143AbcCSVvY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Mar 2016 17:51:24 -0400
In-Reply-To: <1458424294-8678-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When we see a jump also check that the offset gets us to a beginning of
a rule (an ipt_entry).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 14 ++++++++++++++
 net/ipv4/netfilter/ip_tables.c  | 14 ++++++++++++++
 net/ipv6/netfilter/ip6_tables.c | 14 ++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 2347a5c..378ea80 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -366,6 +366,18 @@ static inline bool unconditional(const struct arpt_arp *arp)
 	return memcmp(arp, &uncond, sizeof(uncond)) == 0;
 }
 
+static bool find_jump_target(const struct xt_table_info *t,
+			     const struct arpt_entry *target)
+{
+	struct arpt_entry *iter;
+
+	xt_entry_foreach(iter, t->entries, t->size) {
+		 if (iter == target)
+			return true;
+	}
+	return false;
+}
+
 /* Figures out from what hook each rule can be called: returns 0 if
  * there are loops.  Puts hook bitmask in comefrom.
  */
@@ -462,6 +474,8 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 						 pos, newpos);
 					e = (struct arpt_entry *)
 						(entry0 + newpos);
+					if (!find_jump_target(newinfo, e))
+						return 0;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 07ce901..5d66c55 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -443,6 +443,18 @@ ipt_do_table(struct sk_buff *skb,
 #endif
 }
 
+static bool find_jump_target(const struct xt_table_info *t,
+			     const struct ipt_entry *target)
+{
+	struct ipt_entry *iter;
+
+	xt_entry_foreach(iter, t->entries, t->size) {
+		 if (iter == target)
+			return true;
+	}
+	return false;
+}
+
 /* Figures out from what hook each rule can be called: returns 0 if
    there are loops.  Puts hook bitmask in comefrom. */
 static int
@@ -543,6 +555,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 						 pos, newpos);
 					e = (struct ipt_entry *)
 						(entry0 + newpos);
+					if (!find_jump_target(newinfo, e))
+						return 0;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 99068dc..6fc671c 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -455,6 +455,18 @@ ip6t_do_table(struct sk_buff *skb,
 #endif
 }
 
+static bool find_jump_target(const struct xt_table_info *t,
+			     const struct ip6t_entry *target)
+{
+	struct ip6t_entry *iter;
+
+	xt_entry_foreach(iter, t->entries, t->size) {
+		 if (iter == target)
+			return true;
+	}
+	return false;
+}
+
 /* Figures out from what hook each rule can be called: returns 0 if
    there are loops.  Puts hook bitmask in comefrom. */
 static int
@@ -555,6 +567,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
 						 pos, newpos);
 					e = (struct ip6t_entry *)
 						(entry0 + newpos);
+					if (!find_jump_target(newinfo, e))
+						return 0;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
-- 
2.4.10

