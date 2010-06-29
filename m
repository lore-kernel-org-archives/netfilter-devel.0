From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/56] netfilter: xtables: alternate size checking in xt_check_target
Date: Tue, 29 Jun 2010 10:42:49 +0200
Message-ID: <1277801017-30600-10-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44245 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab0F2Int (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:43:49 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Same as before, but for targets.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    3 ++-
 net/bridge/netfilter/ebtables.c    |    8 ++++----
 net/ipv4/netfilter/arp_tables.c    |    3 ++-
 net/ipv4/netfilter/ip_tables.c     |    4 ++--
 net/ipv6/netfilter/ip6_tables.c    |    3 ++-
 net/netfilter/x_tables.c           |   11 +++++++----
 net/sched/act_ipt.c                |    3 ++-
 7 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 7bdbecb..3fc0d9b 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -486,7 +486,8 @@ extern int xt_check_match(struct xt_mtchk_param *,
 			  unsigned int size, u_int8_t proto, bool inv_proto,
 			  bool check_pad);
 extern int xt_check_target(struct xt_tgchk_param *,
-			   unsigned int size, u_int8_t proto, bool inv_proto);
+			   unsigned int size, u_int8_t proto, bool inv_proto,
+			   bool check_pad);
 
 extern struct xt_table *xt_register_table(struct net *net,
 					  const struct xt_table *table,
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 73c9cec..ab37e1c 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -433,8 +433,8 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
 
 	par->target   = watcher;
 	par->targinfo = w->data;
-	ret = xt_check_target(par, w->watcher_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	ret = xt_check_target(par, w->watcher_size, e->ethproto,
+			      e->invflags & EBT_IPROTO, true);
 	if (ret < 0) {
 		module_put(watcher->me);
 		return ret;
@@ -763,8 +763,8 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 
 	tgpar.target   = target;
 	tgpar.targinfo = t->data;
-	ret = xt_check_target(&tgpar, t->target_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	ret = xt_check_target(&tgpar, t->target_size, e->ethproto,
+			      e->invflags & EBT_IPROTO, true);
 	if (ret < 0) {
 		module_put(target->me);
 		goto cleanup_watchers;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 7f7752a..2fee4a5 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -554,7 +554,8 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 		.family    = NFPROTO_ARP,
 	};
 
-	ret = xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
+			      0, false, true);
 	if (ret < 0) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 43adafa..3809f38 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -749,8 +749,8 @@ static int check_target(struct ipt_entry *e, struct net *net, const char *name)
 	};
 	int ret;
 
-	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
-	      e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t), e->ip.proto,
+			      e->ip.invflags & IPT_INV_PROTO, true);
 	if (ret < 0) {
 		duprintf("check failed for `%s'.\n",
 			 t->u.kernel.target->name);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 0602685..cd8a2f1 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -765,7 +765,8 @@ static int check_target(struct ip6t_entry *e, struct net *net, const char *name)
 
 	t = ip6t_get_target(e);
 	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
-	      e->ipv6.proto, e->ipv6.invflags & IP6T_INV_PROTO);
+			      e->ipv6.proto, e->ipv6.invflags & IP6T_INV_PROTO,
+			      true);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 0eef61a..1f4354f 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -533,16 +533,19 @@ EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 #endif /* CONFIG_COMPAT */
 
 int xt_check_target(struct xt_tgchk_param *par,
-		    unsigned int size, u_int8_t proto, bool inv_proto)
+		    unsigned int size, u_int8_t proto, bool inv_proto,
+		    bool check_pad)
 {
+	unsigned int required;
 	int ret;
 
-	if (XT_ALIGN(par->target->targetsize) != size) {
+	required = check_pad ? XT_ALIGN(par->target->targetsize) :
+		   par->target->targetsize;
+	if (required != size) {
 		pr_err("%s_tables: %s.%u target: invalid size "
 		       "%u (kernel) != (user) %u\n",
 		       xt_prefix[par->family], par->target->name,
-		       par->target->revision,
-		       XT_ALIGN(par->target->targetsize), size);
+		       par->target->revision, required, size);
 		return -EINVAL;
 	}
 	if (par->target->table != NULL &&
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index c7e59e6..79223ec 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -58,7 +58,8 @@ static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int
 	par.hook_mask = hook;
 	par.family    = NFPROTO_IPV4;
 
-	ret = xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
+			      0, false, true);
 	if (ret < 0) {
 		module_put(t->u.kernel.target->me);
 		return ret;
-- 
1.7.1

