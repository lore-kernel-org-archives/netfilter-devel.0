From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/06: add struct net * to target parameters
Date: Tue,  2 Feb 2010 17:52:55 +0100 (MET)
Message-ID: <20100202165255.25160.6709.sendpatchset@x2.localnet>
References: <20100202165253.25160.18314.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33886 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab0BBQw5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:52:57 -0500
In-Reply-To: <20100202165253.25160.18314.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 3865f0e2d43d8a9ec3caf96f5b4435c56f61a612
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Feb 2 17:17:15 2010 +0100

    netfilter: add struct net * to target parameters
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 026eb78..365fabe 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -249,6 +249,7 @@ struct xt_target_param {
  * Other fields see above.
  */
 struct xt_tgchk_param {
+	struct net *net;
 	const char *table;
 	const void *entryinfo;
 	const struct xt_target *target;
@@ -259,6 +260,7 @@ struct xt_tgchk_param {
 
 /* Target destructor parameters */
 struct xt_tgdtor_param {
+	struct net *net;
 	const struct xt_target *target;
 	void *targinfo;
 	u_int8_t family;
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 1aa0e4c..12beb58 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -579,13 +579,14 @@ ebt_cleanup_match(struct ebt_entry_match *m, struct net *net, unsigned int *i)
 }
 
 static inline int
-ebt_cleanup_watcher(struct ebt_entry_watcher *w, unsigned int *i)
+ebt_cleanup_watcher(struct ebt_entry_watcher *w, struct net *net, unsigned int *i)
 {
 	struct xt_tgdtor_param par;
 
 	if (i && (*i)-- == 0)
 		return 1;
 
+	par.net      = net;
 	par.target   = w->u.watcher;
 	par.targinfo = w->data;
 	par.family   = NFPROTO_BRIDGE;
@@ -606,10 +607,11 @@ ebt_cleanup_entry(struct ebt_entry *e, struct net *net, unsigned int *cnt)
 	/* we're done */
 	if (cnt && (*cnt)-- == 0)
 		return 1;
-	EBT_WATCHER_ITERATE(e, ebt_cleanup_watcher, NULL);
+	EBT_WATCHER_ITERATE(e, ebt_cleanup_watcher, net, NULL);
 	EBT_MATCH_ITERATE(e, ebt_cleanup_match, net, NULL);
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
 
+	par.net      = net;
 	par.target   = t->u.target;
 	par.targinfo = t->data;
 	par.family   = NFPROTO_BRIDGE;
@@ -674,7 +676,7 @@ ebt_check_entry(struct ebt_entry *e,
 	}
 	i = 0;
 
-	mtpar.net	= net;
+	mtpar.net	= tgpar.net       = net;
 	mtpar.table     = tgpar.table     = name;
 	mtpar.entryinfo = tgpar.entryinfo = e;
 	mtpar.hook_mask = tgpar.hook_mask = hookmask;
@@ -730,7 +732,7 @@ ebt_check_entry(struct ebt_entry *e,
 	(*cnt)++;
 	return 0;
 cleanup_watchers:
-	EBT_WATCHER_ITERATE(e, ebt_cleanup_watcher, &j);
+	EBT_WATCHER_ITERATE(e, ebt_cleanup_watcher, net, &j);
 cleanup_matches:
 	EBT_MATCH_ITERATE(e, ebt_cleanup_match, net, &i);
 	return ret;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index cfaba0e..7fde8f6 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -638,10 +638,11 @@ err:
 	return ret;
 }
 
-static int check_target(struct ipt_entry *e, const char *name)
+static int check_target(struct ipt_entry *e, struct net *net, const char *name)
 {
 	struct ipt_entry_target *t = ipt_get_target(e);
 	struct xt_tgchk_param par = {
+		.net       = net,
 		.table     = name,
 		.entryinfo = e,
 		.target    = t->u.kernel.target,
@@ -697,7 +698,7 @@ find_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 	}
 	t->u.kernel.target = target;
 
-	ret = check_target(e, name);
+	ret = check_target(e, net, name);
 	if (ret)
 		goto err;
 
@@ -788,6 +789,7 @@ cleanup_entry(struct ipt_entry *e, struct net *net, unsigned int *i)
 	IPT_MATCH_ITERATE(e, cleanup_match, net, NULL);
 	t = ipt_get_target(e);
 
+	par.net      = net;
 	par.target   = t->u.kernel.target;
 	par.targinfo = t->data;
 	par.family   = NFPROTO_IPV4;
@@ -1675,7 +1677,7 @@ compat_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 	if (ret)
 		goto cleanup_matches;
 
-	ret = check_target(e, name);
+	ret = check_target(e, net, name);
 	if (ret)
 		goto cleanup_matches;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 9f1d45f..0376ed6 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -669,10 +669,11 @@ err:
 	return ret;
 }
 
-static int check_target(struct ip6t_entry *e, const char *name)
+static int check_target(struct ip6t_entry *e, struct net *net, const char *name)
 {
 	struct ip6t_entry_target *t = ip6t_get_target(e);
 	struct xt_tgchk_param par = {
+		.net       = net,
 		.table     = name,
 		.entryinfo = e,
 		.target    = t->u.kernel.target,
@@ -729,7 +730,7 @@ find_check_entry(struct ip6t_entry *e, struct net *net, const char *name,
 	}
 	t->u.kernel.target = target;
 
-	ret = check_target(e, name);
+	ret = check_target(e, net, name);
 	if (ret)
 		goto err;
 
@@ -820,6 +821,7 @@ cleanup_entry(struct ip6t_entry *e, struct net *net, unsigned int *i)
 	IP6T_MATCH_ITERATE(e, cleanup_match, net, NULL);
 	t = ip6t_get_target(e);
 
+	par.net      = net;
 	par.target   = t->u.kernel.target;
 	par.targinfo = t->data;
 	par.family   = NFPROTO_IPV6;
@@ -1710,7 +1712,7 @@ static int compat_check_entry(struct ip6t_entry *e, struct net *net,
 	if (ret)
 		goto cleanup_matches;
 
-	ret = check_target(e, name);
+	ret = check_target(e, net, name);
 	if (ret)
 		goto cleanup_matches;
 
