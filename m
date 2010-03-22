From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/9] netfilter: xtables: make use of xt_request_find_target
Date: Mon, 22 Mar 2010 20:17:59 +0100
Message-ID: <1269285486-22653-4-git-send-email-jengelh@medozas.de>
References: <1269285486-22653-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42169 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab0CVTSN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:13 -0400
In-Reply-To: <1269285486-22653-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebtables.c |   13 ++-----------
 net/ipv4/netfilter/arp_tables.c |   20 ++++++++------------
 net/ipv4/netfilter/ip_tables.c  |   20 ++++++++------------
 net/ipv6/netfilter/ip6_tables.c |   20 ++++++++------------
 net/netfilter/x_tables.c        |    4 +---
 net/sched/act_ipt.c             |    4 ++--
 6 files changed, 29 insertions(+), 52 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 989d72c..6d3b256 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -395,13 +395,9 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
 	   left - sizeof(struct ebt_entry_watcher) < w->watcher_size)
 		return -EINVAL;
 
-	watcher = try_then_request_module(
-		  xt_find_target(NFPROTO_BRIDGE, w->u.name, 0),
-		  "ebt_%s", w->u.name);
+	watcher = xt_request_find_target(NFPROTO_BRIDGE, w->u.name, 0);
 	if (IS_ERR(watcher))
 		return PTR_ERR(watcher);
-	if (watcher == NULL)
-		return -ENOENT;
 	w->u.watcher = watcher;
 
 	par->target   = watcher;
@@ -714,15 +710,10 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
 	gap = e->next_offset - e->target_offset;
 
-	target = try_then_request_module(
-		 xt_find_target(NFPROTO_BRIDGE, t->u.name, 0),
-		 "ebt_%s", t->u.name);
+	target = xt_request_find_target(NFPROTO_BRIDGE, t->u.name, 0);
 	if (IS_ERR(target)) {
 		ret = PTR_ERR(target);
 		goto cleanup_watchers;
-	} else if (target == NULL) {
-		ret = -ENOENT;
-		goto cleanup_watchers;
 	}
 
 	t->u.target = target;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f07d77f..0665e1b 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -523,13 +523,11 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
 		return ret;
 
 	t = arpt_get_target(e);
-	target = try_then_request_module(xt_find_target(NFPROTO_ARP,
-							t->u.user.name,
-							t->u.user.revision),
-					 "arpt_%s", t->u.user.name);
-	if (IS_ERR(target) || !target) {
+	target = xt_request_find_target(NFPROTO_ARP, t->u.user.name,
+	         t->u.user.revision);
+	if (IS_ERR(target)) {
 		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
+		ret = PTR_ERR(target);
 		goto out;
 	}
 	t->u.kernel.target = target;
@@ -1252,14 +1250,12 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 	entry_offset = (void *)e - (void *)base;
 
 	t = compat_arpt_get_target(e);
-	target = try_then_request_module(xt_find_target(NFPROTO_ARP,
-							t->u.user.name,
-							t->u.user.revision),
-					 "arpt_%s", t->u.user.name);
-	if (IS_ERR(target) || !target) {
+	target = xt_request_find_target(NFPROTO_ARP, t->u.user.name,
+	         t->u.user.revision);
+	if (IS_ERR(target)) {
 		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
 			 t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
+		ret = PTR_ERR(target);
 		goto out;
 	}
 	t->u.kernel.target = target;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 73fdf20..a8b0036 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -701,13 +701,11 @@ find_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 	}
 
 	t = ipt_get_target(e);
-	target = try_then_request_module(xt_find_target(AF_INET,
-							t->u.user.name,
-							t->u.user.revision),
-					 "ipt_%s", t->u.user.name);
-	if (IS_ERR(target) || !target) {
+	target = xt_request_find_target(NFPROTO_IPV4, t->u.user.name,
+	         t->u.user.revision);
+	if (IS_ERR(target)) {
 		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
+		ret = PTR_ERR(target);
 		goto cleanup_matches;
 	}
 	t->u.kernel.target = target;
@@ -1547,14 +1545,12 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	}
 
 	t = compat_ipt_get_target(e);
-	target = try_then_request_module(xt_find_target(AF_INET,
-							t->u.user.name,
-							t->u.user.revision),
-					 "ipt_%s", t->u.user.name);
-	if (IS_ERR(target) || !target) {
+	target = xt_request_find_target(NFPROTO_IPV4, t->u.user.name,
+	         t->u.user.revision);
+	if (IS_ERR(target)) {
 		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
 			 t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
+		ret = PTR_ERR(target);
 		goto release_matches;
 	}
 	t->u.kernel.target = target;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 1b2414e..6399f82 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -733,13 +733,11 @@ find_check_entry(struct ip6t_entry *e, struct net *net, const char *name,
 	}
 
 	t = ip6t_get_target(e);
-	target = try_then_request_module(xt_find_target(AF_INET6,
-							t->u.user.name,
-							t->u.user.revision),
-					 "ip6t_%s", t->u.user.name);
-	if (IS_ERR(target) || !target) {
+	target = xt_request_find_target(NFPROTO_IPV6, t->u.user.name,
+	         t->u.user.revision);
+	if (IS_ERR(target)) {
 		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
+		ret = PTR_ERR(target);
 		goto cleanup_matches;
 	}
 	t->u.kernel.target = target;
@@ -1581,14 +1579,12 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 	}
 
 	t = compat_ip6t_get_target(e);
-	target = try_then_request_module(xt_find_target(AF_INET6,
-							t->u.user.name,
-							t->u.user.revision),
-					 "ip6t_%s", t->u.user.name);
-	if (IS_ERR(target) || !target) {
+	target = xt_request_find_target(NFPROTO_IPV6, t->u.user.name,
+	         t->u.user.revision);
+	if (IS_ERR(target)) {
 		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
 			 t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
+		ret = PTR_ERR(target);
 		goto release_matches;
 	}
 	t->u.kernel.target = target;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 9a248d4..bf2806a 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -250,9 +250,7 @@ struct xt_target *xt_request_find_target(u8 af, const char *name, u8 revision)
 
 	target = try_then_request_module(xt_find_target(af, name, revision),
 					 "%st_%s", xt_prefix[af], name);
-	if (IS_ERR(target) || !target)
-		return NULL;
-	return target;
+	return (target != NULL) ? target : ERR_PTR(-ENOENT);
 }
 EXPORT_SYMBOL_GPL(xt_request_find_target);
 
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 082c520..b9f79c2 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -46,8 +46,8 @@ static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int
 
 	target = xt_request_find_target(AF_INET, t->u.user.name,
 					t->u.user.revision);
-	if (!target)
-		return -ENOENT;
+	if (IS_ERR(target))
+		return PTR_ERR(target);
 
 	t->u.kernel.target = target;
 	par.table     = table;
-- 
1.7.0.2

