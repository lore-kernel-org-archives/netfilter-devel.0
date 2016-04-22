From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/23] netfilter: x_tables: validate targets of jumps
Date: Fri, 22 Apr 2016 15:39:33 +0200
Message-ID: <1461332394-3994-3-git-send-email-pablo@netfilter.org>
References: <1461332394-3994-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1461332394-3994-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When we see a jump also check that the offset gets us to beginning of
a rule (an ipt_entry).

The extra overhead is negible, even with absurd cases.

300k custom rules, 300k jumps to 'next' user chain:
[ plus one jump from INPUT to first userchain ]:

Before:
real    0m24.874s
user    0m7.532s
sys     0m16.076s

After:
real    0m27.464s
user    0m7.436s
sys     0m18.840s

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arp_tables.c | 16 ++++++++++++++++
 net/ipv4/netfilter/ip_tables.c  | 16 ++++++++++++++++
 net/ipv6/netfilter/ip6_tables.c | 16 ++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 82a434b..ec37f7c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -367,6 +367,18 @@ static inline bool unconditional(const struct arpt_entry *e)
 	       memcmp(&e->arp, &uncond, sizeof(uncond)) == 0;
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
@@ -460,6 +472,10 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
+					e = (struct arpt_entry *)
+						(entry0 + newpos);
+					if (!find_jump_target(newinfo, e))
+						return 0;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index e301a3d..503038e 100644
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
@@ -540,6 +552,10 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
+					e = (struct ipt_entry *)
+						(entry0 + newpos);
+					if (!find_jump_target(newinfo, e))
+						return 0;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 7b3335b..126f2a0 100644
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
@@ -552,6 +564,10 @@ mark_source_chains(const struct xt_table_info *newinfo,
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
+					e = (struct ip6t_entry *)
+						(entry0 + newpos);
+					if (!find_jump_target(newinfo, e))
+						return 0;
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
-- 
2.1.4
