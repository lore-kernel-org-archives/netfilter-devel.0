From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf RFC] netfilter: x_tables: only allow jumps to user-defined chains
Date: Wed,  7 Feb 2018 14:20:41 +0100
Message-ID: <20180207132041.444-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38732 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753675AbeBGNVw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 08:21:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This rejects rulesets where a jump occurs to a non-user defined chain.
This isn't limited in any way in the binary format (you can jump to
any rule you want within the blob structure), but iptables tools
do not offset such a feature.

Sending as RFC as this limits features that might be used by programs
that don't call xtables(-restore) tools.

This change also prevents the syzkaller reported crash as
ruleset gets rejected.

Reported-by: syzbot+e783f671527912cd9403@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 20 ++++++++++++++------
 net/ipv4/netfilter/ip_tables.c  | 21 +++++++++++++++------
 net/ipv6/netfilter/ip6_tables.c | 22 ++++++++++++++++------
 3 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index e3e420f3ba7b..2df708e5cf42 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -368,10 +368,14 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
 				    newpos >= 0) {
-					/* This a jump; chase it. */
-					if (!xt_find_jump_offset(offsets, newpos,
-								 newinfo->number))
+					if (newpos >= newinfo->size)
 						return 0;
+					if (entry0 + newpos != ipt_next_entry(e)) {
+						/* This a jump; chase it. */
+						if (!xt_find_jump_offset(offsets, newpos,
+									 newinfo->stacksize))
+							return 0;
+					}
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -523,6 +527,7 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	struct arpt_entry *iter;
 	unsigned int *offsets;
 	unsigned int i;
+	bool userchain;
 	int ret = 0;
 
 	newinfo->size = repl->size;
@@ -548,12 +553,15 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 						 repl->valid_hooks);
 		if (ret != 0)
 			goto out_free;
-		if (i < repl->num_entries)
-			offsets[i] = (void *)iter - entry0;
 		++i;
+		if (userchain) {
+			offsets[newinfo->stacksize] = (void *)iter - entry0;
+			++newinfo->stacksize;
+			userchain = false;
+		}
 		if (strcmp(arpt_get_target(iter)->u.user.name,
 		    XT_ERROR_TARGET) == 0)
-			++newinfo->stacksize;
+			userchain = true;
 	}
 
 	ret = -EINVAL;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index e38395a8dcf2..c8adab24a883 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -435,10 +435,14 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
 				    newpos >= 0) {
-					/* This a jump; chase it. */
-					if (!xt_find_jump_offset(offsets, newpos,
-								 newinfo->number))
+					if (newpos >= newinfo->size)
 						return 0;
+					if (entry0 + newpos != ipt_next_entry(e)) {
+						/* This a jump; chase it. */
+						if (!xt_find_jump_offset(offsets, newpos,
+									 newinfo->stacksize))
+							return 0;
+					}
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -671,6 +675,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	struct ipt_entry *iter;
 	unsigned int *offsets;
 	unsigned int i;
+	bool userchain;
 	int ret = 0;
 
 	newinfo->size = repl->size;
@@ -686,6 +691,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	if (!offsets)
 		return -ENOMEM;
 	i = 0;
+	userchain = false;
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
@@ -695,12 +701,15 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 						 repl->valid_hooks);
 		if (ret != 0)
 			goto out_free;
-		if (i < repl->num_entries)
-			offsets[i] = (void *)iter - entry0;
 		++i;
+		if (userchain) {
+			offsets[newinfo->stacksize] = (void *)iter - entry0;
+			++newinfo->stacksize;
+			userchain = false;
+		}
 		if (strcmp(ipt_get_target(iter)->u.user.name,
 		    XT_ERROR_TARGET) == 0)
-			++newinfo->stacksize;
+			userchain = true;
 	}
 
 	ret = -EINVAL;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 62358b93bbac..d4932b18ad14 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -453,10 +453,15 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
 				    newpos >= 0) {
-					/* This a jump; chase it. */
-					if (!xt_find_jump_offset(offsets, newpos,
-								 newinfo->number))
+					if (newpos >= newinfo->size)
 						return 0;
+
+					if (entry0 + newpos != ip6t_next_entry(e)) {
+						/* This a jump; chase it. */
+						if (!xt_find_jump_offset(offsets, newpos,
+									 newinfo->stacksize))
+							return 0;
+					}
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;
@@ -689,6 +694,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	struct ip6t_entry *iter;
 	unsigned int *offsets;
 	unsigned int i;
+	bool userchain;
 	int ret = 0;
 
 	newinfo->size = repl->size;
@@ -704,6 +710,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	if (!offsets)
 		return -ENOMEM;
 	i = 0;
+	userchain = false;
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
@@ -713,12 +720,15 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 						 repl->valid_hooks);
 		if (ret != 0)
 			goto out_free;
-		if (i < repl->num_entries)
-			offsets[i] = (void *)iter - entry0;
 		++i;
+		if (userchain) {
+			offsets[newinfo->stacksize] = (void *)iter - entry0;
+			++newinfo->stacksize;
+			userchain = false;
+		}
 		if (strcmp(ip6t_get_target(iter)->u.user.name,
 		    XT_ERROR_TARGET) == 0)
-			++newinfo->stacksize;
+			userchain = true;
 	}
 
 	ret = -EINVAL;
-- 
2.13.6

