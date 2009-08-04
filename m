From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 042/103] netfilter: xtables: make use of xt_request_find_target
Date: Tue,  4 Aug 2009 09:25:26 +0200
Message-ID: <1249370787-17583-43-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50630 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbZHDH1S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:18 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
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
index 281a531..9f081db 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -374,13 +374,9 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
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
@@ -686,15 +682,10 @@ ebt_check_entry(struct ebt_entry *e, const struct ebt_table_info *newinfo,
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
index b88c069..db24dac 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -516,13 +516,11 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
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
@@ -1247,14 +1245,12 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
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
index 3add32b..fdeb978 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -681,13 +681,11 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size)
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
@@ -1528,14 +1526,12 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
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
index 709d509..e107aa0 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -696,13 +696,11 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size)
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
@@ -1545,14 +1543,12 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
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
index 1f6b078..a1be7df 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -261,9 +261,7 @@ struct xt_target *xt_request_find_target(u8 af, const char *name, u8 revision)
 
 	target = try_then_request_module(xt_find_target(af, name, revision),
 					 "%st_%s", xt_prefix[af], name);
-	if (IS_ERR(target) || !target)
-		return NULL;
-	return target;
+	return (target != NULL) ? target : ERR_PTR(-ENOENT);
 }
 EXPORT_SYMBOL_GPL(xt_request_find_target);
 
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 1e70540..e4b4224 100644
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
1.6.3.3

