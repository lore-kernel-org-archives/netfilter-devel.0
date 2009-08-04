From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 054/103] netfilter: xtables: alternate size checking in xt_check_target
Date: Tue,  4 Aug 2009 09:25:38 +0200
Message-ID: <1249370787-17583-55-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56942 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbZHDH1c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:32 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    3 ++-
 net/bridge/netfilter/ebtables.c    |    4 ++--
 net/ipv4/netfilter/arp_tables.c    |    3 ++-
 net/ipv4/netfilter/ip_tables.c     |    2 +-
 net/ipv6/netfilter/ip6_tables.c    |    2 +-
 net/netfilter/x_tables.c           |   13 ++++++++-----
 net/sched/act_ipt.c                |    3 ++-
 7 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 956ff8a..8addd6f 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -485,7 +485,8 @@ extern int xt_check_match(struct xt_mtchk_param *,
 			  unsigned int size, u_int8_t proto, bool inv_proto,
 			  bool check_pad);
 extern int xt_check_target(struct xt_tgchk_param *,
-			   unsigned int size, u_int8_t proto, bool inv_proto);
+			   unsigned int size, u_int8_t proto, bool inv_proto,
+			   bool check_pad);
 
 extern struct xt_table *xt_register_table(struct net *net,
 					  const struct xt_table *table,
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 2a13e53..06fd8f1 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -412,7 +412,7 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
 	par->target   = watcher;
 	par->targinfo = w->data;
 	ret = xt_check_target(par, w->watcher_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	      e->ethproto, e->invflags & EBT_IPROTO, true);
 	if (ret < 0) {
 		module_put(watcher->me);
 		return ret;
@@ -734,7 +734,7 @@ ebt_check_entry(struct ebt_entry *e, const struct ebt_table_info *newinfo,
 	tgpar.target   = target;
 	tgpar.targinfo = t->data;
 	ret = xt_check_target(&tgpar, t->target_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	      e->ethproto, e->invflags & EBT_IPROTO, true);
 	if (ret < 0) {
 		module_put(target->me);
 		goto cleanup_watchers;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f38444c..95cddc8 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -550,7 +550,8 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 		.family    = NFPROTO_ARP,
 	};
 
-	ret = xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
+	      0, false, true);
 	if (ret < 0) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 77cef82..043b620 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -748,7 +748,7 @@ static int check_target(struct ipt_entry *e, const char *name)
 	int ret;
 
 	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
-	      e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
+	      e->ip.proto, e->ip.invflags & IPT_INV_PROTO, true);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 63ea701..fa1d289 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -747,7 +747,7 @@ static int check_target(struct ip6t_entry *e, const char *name)
 
 	t = ip6t_get_target(e);
 	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
-	      e->ipv6.proto, e->ipv6.invflags & IP6T_INV_PROTO);
+	      e->ipv6.proto, e->ipv6.invflags & IP6T_INV_PROTO, true);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 1cdc982..3906dfb 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -532,14 +532,17 @@ EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 #endif /* CONFIG_COMPAT */
 
 int xt_check_target(struct xt_tgchk_param *par,
-		    unsigned int size, u_int8_t proto, bool inv_proto)
+		    unsigned int size, u_int8_t proto, bool inv_proto,
+		    bool check_pad)
 {
-	if (XT_ALIGN(par->target->targetsize) != size) {
+	unsigned int required = check_pad ? XT_ALIGN(par->target->targetsize) :
+	                        par->target->targetsize;
+
+	if (required != size) {
 		pr_err("%s_tables: %s.%u target: invalid size "
-		       "(kernel) %zu != (user) %u\n",
+		       "(kernel) %u != (user) %u\n",
 		       xt_prefix[par->family], par->target->name,
-		       par->target->revision,
-		       XT_ALIGN(par->target->targetsize), size);
+		       par->target->revision, required, size);
 		return -EINVAL;
 	}
 	if (par->target->table != NULL &&
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index e4b4224..23d3ea2 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -57,7 +57,8 @@ static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int
 	par.hook_mask = hook;
 	par.family    = NFPROTO_IPV4;
 
-	ret = xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
+	      0, false, true);
 	if (ret < 0) {
 		module_put(t->u.kernel.target->me);
 		return ret;
-- 
1.6.3.3

