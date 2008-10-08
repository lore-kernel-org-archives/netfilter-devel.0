From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 75/79: xtables: move extension arguments into compound structure (6/6)
Date: Wed,  8 Oct 2008 12:48:03 +0200 (MEST)
Message-ID: <20081008104803.10423.60788.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46093 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbYJHKsE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:48:04 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a2df1648ba615dd5908e9a1fa7b2f133fa302487
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:19 2008 +0200

    netfilter: xtables: move extension arguments into compound structure (6/6)
    
    This patch does this for target extensions' destroy functions.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 8daeb49..e3b3b66 100644
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
@@ -311,7 +317,7 @@ struct xt_target
 	bool (*checkentry)(const struct xt_tgchk_param *);
 
 	/* Called when entry of this type deleted. */
-	void (*destroy)(const struct xt_target *target, void *targinfo);
+	void (*destroy)(const struct xt_tgdtor_param *);
 
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, void *src);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index cf823c2..29d8061 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -581,18 +581,23 @@ ebt_cleanup_match(struct ebt_entry_match *m, unsigned int *i)
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
@@ -603,10 +608,12 @@ ebt_cleanup_entry(struct ebt_entry *e, unsigned int *cnt)
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
index b3238d0..3bab783 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -557,15 +557,18 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 
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
index e592c54..50b9a6c 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -768,6 +768,7 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 static int
 cleanup_entry(struct ipt_entry *e, unsigned int *i)
 {
+	struct xt_tgdtor_param par;
 	struct ipt_entry_target *t;
 
 	if (i && (*i)-- == 0)
@@ -776,9 +777,12 @@ cleanup_entry(struct ipt_entry *e, unsigned int *i)
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
index 6c7254e..7ac1677 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -411,9 +411,9 @@ static bool clusterip_tg_check(const struct xt_tgchk_param *par)
 }
 
 /* drop reference count of cluster config when rule is deleted */
-static void clusterip_tg_destroy(const struct xt_target *target, void *targinfo)
+static void clusterip_tg_destroy(const struct xt_tgdtor_param *par)
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
index ca14fb8..d934a69 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -793,6 +793,7 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 static int
 cleanup_entry(struct ip6t_entry *e, unsigned int *i)
 {
+	struct xt_tgdtor_param par;
 	struct ip6t_entry_target *t;
 
 	if (i && (*i)-- == 0)
@@ -801,9 +802,12 @@ cleanup_entry(struct ip6t_entry *e, unsigned int *i)
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
index 8fc9f35..c5a5072 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -146,10 +146,9 @@ static bool connmark_tg_check(const struct xt_tgchk_param *par)
 	return true;
 }
 
-static void
-connmark_tg_destroy(const struct xt_target *target, void *targinfo)
+static void connmark_tg_destroy(const struct xt_tgdtor_param *par)
 {
-	nf_ct_l3proto_module_put(target->family);
+	nf_ct_l3proto_module_put(par->target->family);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 2041a3d..b6e3f3f 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -114,10 +114,9 @@ static bool connsecmark_tg_check(const struct xt_tgchk_param *par)
 	return true;
 }
 
-static void
-connsecmark_tg_destroy(const struct xt_target *target, void *targinfo)
+static void connsecmark_tg_destroy(const struct xt_tgdtor_param *par)
 {
-	nf_ct_l3proto_module_put(target->family);
+	nf_ct_l3proto_module_put(par->target->family);
 }
 
 static struct xt_target connsecmark_tg_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index edf4ab1..43f5676 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -139,10 +139,9 @@ err1:
 	return false;
 }
 
-static void xt_rateest_tg_destroy(const struct xt_target *target,
-				  void *targinfo)
+static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
 {
-	struct xt_rateest_target_info *info = targinfo;
+	struct xt_rateest_target_info *info = par->targinfo;
 
 	xt_rateest_put(info->est);
 }
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index e577722..7a6f9e6 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -113,7 +113,7 @@ static bool secmark_tg_check(const struct xt_tgchk_param *par)
 	return true;
 }
 
-static void secmark_tg_destroy(const struct xt_target *target, void *targinfo)
+static void secmark_tg_destroy(const struct xt_tgdtor_param *par)
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
