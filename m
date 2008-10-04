From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 13/16] [NETFILTER]: Move extension arguments into compound structure (6/6)
Date: Sat,  4 Oct 2008 15:41:27 -0400
Message-ID: <f78a26befe65f1bb12f293a2d7bed892a4caf454.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34321 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYJDTlf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:41:35 -0400
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch does this for target extensions' destroy functions.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    8 +++++++-
 net/bridge/netfilter/ebtables.c    |   19 +++++++++++++------
 net/ipv4/netfilter/arp_tables.c    |    9 ++++++---
 net/ipv4/netfilter/ip_tables.c     |   10 +++++++---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    6 +++---
 net/ipv6/netfilter/ip6_tables.c    |   10 +++++++---
 net/netfilter/xt_CONNMARK.c        |    5 ++---
 net/netfilter/xt_CONNSECMARK.c     |    5 ++---
 net/netfilter/xt_RATEEST.c         |    5 ++---
 net/netfilter/xt_SECMARK.c         |    2 +-
 net/sched/act_ipt.c                |   10 +++++++---
 11 files changed, 57 insertions(+), 32 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 0dbc673..b7d73b2 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -251,6 +251,12 @@ struct xt_tgchk_param {
 	unsigned int hook_mask;
 };
 
+/* Target destructor parameters */
+struct xt_tgdtor_param {
+	const struct xt_target *target;
+	void *targinfo;
+};
+
 struct xt_match
 {
 	struct list_head list;
@@ -309,7 +315,7 @@ struct xt_target
 	bool (*checkentry)(struct xt_tgchk_param *);
 
 	/* Called when entry of this type deleted. */
-	void (*destroy)(const struct xt_target *target, void *targinfo);
+	void (*destroy)(struct xt_tgdtor_param *);
 
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, void *src);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index a784431..2ba3e57 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -599,18 +599,23 @@ ebt_cleanup_match(struct ebt_entry_match *m, unsigned int *i)
 static inline int
 ebt_cleanup_watcher(struct ebt_entry_watcher *w, unsigned int *i)
 {
+	struct xt_tgdtor_param par;
+
 	if (i && (*i)-- == 0)
 		return 1;
-	if (w->u.watcher->destroy)
-		w->u.watcher->destroy(w->u.watcher, w->data);
-	module_put(w->u.watcher->me);
 
+	par.target   = w->u.watcher;
+	par.targinfo = w->data;
+	if (par.target->destroy != NULL)
+		par.target->destroy(&par);
+	module_put(par.target->me);
 	return 0;
 }
 
 static inline int
 ebt_cleanup_entry(struct ebt_entry *e, unsigned int *cnt)
 {
+	struct xt_tgdtor_param par;
 	struct ebt_entry_target *t;
 
 	if (e->bitmask == 0)
@@ -621,10 +626,12 @@ ebt_cleanup_entry(struct ebt_entry *e, unsigned int *cnt)
 	EBT_WATCHER_ITERATE(e, ebt_cleanup_watcher, NULL);
 	EBT_MATCH_ITERATE(e, ebt_cleanup_match, NULL);
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
-	if (t->u.target->destroy)
-		t->u.target->destroy(t->u.target, t->data);
-	module_put(t->u.target->me);
 
+	par.target   = t->u.target;
+	par.targinfo = t->data;
+	if (par.target->destroy != NULL)
+		par.target->destroy(&par);
+	module_put(par.target->me);
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 917498f..6c293e8 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -556,15 +556,18 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 
 static inline int cleanup_entry(struct arpt_entry *e, unsigned int *i)
 {
+	struct xt_tgdtor_param par;
 	struct arpt_entry_target *t;
 
 	if (i && (*i)-- == 0)
 		return 1;
 
 	t = arpt_get_target(e);
-	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
-	module_put(t->u.kernel.target->me);
+	par.target   = t->u.kernel.target;
+	par.targinfo = t->data;
+	if (par.target->destroy != NULL)
+		par.target->destroy(&par);
+	module_put(par.target->me);
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 0775857..0484df5 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -782,6 +782,7 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 static int
 cleanup_entry(struct ipt_entry *e, unsigned int *i)
 {
+	struct xt_tgdtor_param par;
 	struct ipt_entry_target *t;
 
 	if (i && (*i)-- == 0)
@@ -790,9 +791,12 @@ cleanup_entry(struct ipt_entry *e, unsigned int *i)
 	/* Cleanup all matches */
 	IPT_MATCH_ITERATE(e, cleanup_match, NULL);
 	t = ipt_get_target(e);
-	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
-	module_put(t->u.kernel.target->me);
+
+	par.target   = t->u.kernel.target;
+	par.targinfo = t->data;
+	if (par.target->destroy != NULL)
+		par.target->destroy(&par);
+	module_put(par.target->me);
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index be81a50..e0485b1 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -411,9 +411,9 @@ static bool clusterip_tg_check(struct xt_tgchk_param *par)
 }
 
 /* drop reference count of cluster config when rule is deleted */
-static void clusterip_tg_destroy(const struct xt_target *target, void *targinfo)
+static void clusterip_tg_destroy(struct xt_tgdtor_param *par)
 {
-	const struct ipt_clusterip_tgt_info *cipinfo = targinfo;
+	const struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
 
 	/* if no more entries are referencing the config, remove it
 	 * from the list and destroy the proc entry */
@@ -421,7 +421,7 @@ static void clusterip_tg_destroy(const struct xt_target *target, void *targinfo)
 
 	clusterip_config_put(cipinfo->config);
 
-	nf_ct_l3proto_module_put(target->family);
+	nf_ct_l3proto_module_put(par->target->family);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index bc8cd8f..e727ac9 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -811,6 +811,7 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 static int
 cleanup_entry(struct ip6t_entry *e, unsigned int *i)
 {
+	struct xt_tgdtor_param par;
 	struct ip6t_entry_target *t;
 
 	if (i && (*i)-- == 0)
@@ -819,9 +820,12 @@ cleanup_entry(struct ip6t_entry *e, unsigned int *i)
 	/* Cleanup all matches */
 	IP6T_MATCH_ITERATE(e, cleanup_match, NULL);
 	t = ip6t_get_target(e);
-	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
-	module_put(t->u.kernel.target->me);
+
+	par.target   = t->u.kernel.target;
+	par.targinfo = t->data;
+	if (par.target->destroy != NULL)
+		par.target->destroy(&par);
+	module_put(par.target->me);
 	return 0;
 }
 
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index bf84f6c..e6d3f38 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -146,10 +146,9 @@ static bool connmark_tg_check(struct xt_tgchk_param *par)
 	return true;
 }
 
-static void
-connmark_tg_destroy(const struct xt_target *target, void *targinfo)
+static void connmark_tg_destroy(struct xt_tgdtor_param *par)
 {
-	nf_ct_l3proto_module_put(target->family);
+	nf_ct_l3proto_module_put(par->target->family);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 3506f37..e43b5e5 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -114,10 +114,9 @@ static bool connsecmark_tg_check(struct xt_tgchk_param *par)
 	return true;
 }
 
-static void
-connsecmark_tg_destroy(const struct xt_target *target, void *targinfo)
+static void connsecmark_tg_destroy(struct xt_tgdtor_param *par)
 {
-	nf_ct_l3proto_module_put(target->family);
+	nf_ct_l3proto_module_put(par->target->family);
 }
 
 static struct xt_target connsecmark_tg_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 4465609..0fc45e9 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -139,10 +139,9 @@ err1:
 	return false;
 }
 
-static void xt_rateest_tg_destroy(const struct xt_target *target,
-				  void *targinfo)
+static void xt_rateest_tg_destroy(struct xt_tgdtor_param *par)
 {
-	struct xt_rateest_target_info *info = targinfo;
+	struct xt_rateest_target_info *info = par->targinfo;
 
 	xt_rateest_put(info->est);
 }
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index b8b6818..4807e5d 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -113,7 +113,7 @@ static bool secmark_tg_check(struct xt_tgchk_param *par)
 	return true;
 }
 
-static void secmark_tg_destroy(const struct xt_target *target, void *targinfo)
+static void secmark_tg_destroy(struct xt_tgdtor_param *par)
 {
 	switch (mode) {
 	case SECMARK_MODE_SEL:
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index a54dc3f..b951d42 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -67,9 +67,13 @@ static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int
 
 static void ipt_destroy_target(struct ipt_entry_target *t)
 {
-	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
-	module_put(t->u.kernel.target->me);
+	struct xt_tgdtor_param par = {
+		.target   = t->u.kernel.target,
+		.targinfo = t->data,
+	};
+	if (par.target->destroy != NULL)
+		par.target->destroy(&par);
+	module_put(par.target->me);
 }
 
 static int tcf_ipt_release(struct tcf_ipt *ipt, int bind)
-- 
1.6.0.1

