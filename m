From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 72/79: xtables: move extension arguments into compound structure (3/6)
Date: Wed,  8 Oct 2008 12:47:58 +0200 (MEST)
Message-ID: <20081008104758.10423.42973.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46084 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbYJHKsA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:48:00 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 6be3d8598e883fb632edf059ba2f8d1b9f4da138
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:19 2008 +0200

    netfilter: xtables: move extension arguments into compound structure (3/6)
    
    This patch does this for match extensions' destroy functions.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 763a704..c79c883 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -212,6 +212,12 @@ struct xt_mtchk_param {
 	unsigned int hook_mask;
 };
 
+/* Match destructor parameters */
+struct xt_mtdtor_param {
+	const struct xt_match *match;
+	void *matchinfo;
+};
+
 struct xt_match
 {
 	struct list_head list;
@@ -230,7 +236,7 @@ struct xt_match
 	bool (*checkentry)(const struct xt_mtchk_param *);
 
 	/* Called when entry of this type deleted. */
-	void (*destroy)(const struct xt_match *match, void *matchinfo);
+	void (*destroy)(const struct xt_mtdtor_param *);
 
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, void *src);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5ce37b2..0320b52 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -558,12 +558,16 @@ ebt_get_udc_positions(struct ebt_entry *e, struct ebt_table_info *newinfo,
 static inline int
 ebt_cleanup_match(struct ebt_entry_match *m, unsigned int *i)
 {
+	struct xt_mtdtor_param par;
+
 	if (i && (*i)-- == 0)
 		return 1;
-	if (m->u.match->destroy)
-		m->u.match->destroy(m->u.match, m->data);
-	module_put(m->u.match->me);
 
+	par.match     = m->u.match;
+	par.matchinfo = m->data;
+	if (par.match->destroy != NULL)
+		par.match->destroy(&par);
+	module_put(par.match->me);
 	return 0;
 }
 
@@ -609,7 +613,7 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	unsigned int i, j, hook = 0, hookmask = 0;
 	size_t gap;
 	int ret;
-	struct xt_mtchk_param par;
+	struct xt_mtchk_param mtpar;
 
 	/* don't mess with the struct ebt_entries */
 	if (e->bitmask == 0)
@@ -651,10 +655,10 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	}
 	i = 0;
 
-	par.table     = name;
-	par.entryinfo = e;
-	par.hook_mask = hookmask;
-	ret = EBT_MATCH_ITERATE(e, ebt_check_match, &par, &i);
+	mtpar.table     = name;
+	mtpar.entryinfo = e;
+	mtpar.hook_mask = hookmask;
+	ret = EBT_MATCH_ITERATE(e, ebt_check_match, &mtpar, &i);
 	if (ret != 0)
 		goto cleanup_matches;
 	j = 0;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4147298..12ad4d5 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -576,12 +576,16 @@ mark_source_chains(struct xt_table_info *newinfo,
 static int
 cleanup_match(struct ipt_entry_match *m, unsigned int *i)
 {
+	struct xt_mtdtor_param par;
+
 	if (i && (*i)-- == 0)
 		return 1;
 
-	if (m->u.kernel.match->destroy)
-		m->u.kernel.match->destroy(m->u.kernel.match, m->data);
-	module_put(m->u.kernel.match->me);
+	par.match     = m->u.kernel.match;
+	par.matchinfo = m->data;
+	if (par.match->destroy != NULL)
+		par.match->destroy(&par);
+	module_put(par.match->me);
 	return 0;
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 9c843e3..891358e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -599,12 +599,16 @@ mark_source_chains(struct xt_table_info *newinfo,
 static int
 cleanup_match(struct ip6t_entry_match *m, unsigned int *i)
 {
+	struct xt_mtdtor_param par;
+
 	if (i && (*i)-- == 0)
 		return 1;
 
-	if (m->u.kernel.match->destroy)
-		m->u.kernel.match->destroy(m->u.kernel.match, m->data);
-	module_put(m->u.kernel.match->me);
+	par.match     = m->u.kernel.match;
+	par.matchinfo = m->data;
+	if (par.match->destroy != NULL)
+		par.match->destroy(&par);
+	module_put(par.match->me);
 	return 0;
 }
 
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 43a36c7..5bf4aa0 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -115,9 +115,9 @@ static bool connbytes_mt_check(const struct xt_mtchk_param *par)
 	return true;
 }
 
-static void connbytes_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void connbytes_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(match->family);
+	nf_ct_l3proto_module_put(par->match->family);
 }
 
 static struct xt_match connbytes_mt_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 1361e99..bfb3ee6 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -246,16 +246,15 @@ static bool connlimit_mt_check(const struct xt_mtchk_param *par)
 	return true;
 }
 
-static void
-connlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void connlimit_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	const struct xt_connlimit_info *info = matchinfo;
+	const struct xt_connlimit_info *info = par->matchinfo;
 	struct xt_connlimit_conn *conn;
 	struct xt_connlimit_conn *tmp;
 	struct list_head *hash = info->data->iphash;
 	unsigned int i;
 
-	nf_ct_l3proto_module_put(match->family);
+	nf_ct_l3proto_module_put(par->match->family);
 
 	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i) {
 		list_for_each_entry_safe(conn, tmp, &hash[i], list) {
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index b935b78..c708577 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -87,10 +87,9 @@ static bool connmark_mt_check(const struct xt_mtchk_param *par)
 	return true;
 }
 
-static void
-connmark_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void connmark_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(match->family);
+	nf_ct_l3proto_module_put(par->match->family);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index f04c46a..5cd58d7 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -288,10 +288,9 @@ static bool conntrack_mt_check(const struct xt_mtchk_param *par)
 	return true;
 }
 
-static void
-conntrack_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void conntrack_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(match->family);
+	nf_ct_l3proto_module_put(par->match->family);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 2f73820..6fc4292 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -748,17 +748,16 @@ static bool hashlimit_mt_check(const struct xt_mtchk_param *par)
 }
 
 static void
-hashlimit_mt_destroy_v0(const struct xt_match *match, void *matchinfo)
+hashlimit_mt_destroy_v0(const struct xt_mtdtor_param *par)
 {
-	const struct xt_hashlimit_info *r = matchinfo;
+	const struct xt_hashlimit_info *r = par->matchinfo;
 
 	htable_put(r->hinfo);
 }
 
-static void
-hashlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void hashlimit_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	const struct xt_hashlimit_mtinfo1 *info = matchinfo;
+	const struct xt_hashlimit_mtinfo1 *info = par->matchinfo;
 
 	htable_put(info->hinfo);
 }
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 86d3c33..280c984 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -67,9 +67,9 @@ static bool helper_mt_check(const struct xt_mtchk_param *par)
 	return true;
 }
 
-static void helper_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void helper_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(match->family);
+	nf_ct_l3proto_module_put(par->match->family);
 }
 
 static struct xt_match helper_mt_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 4b05ce1..220a1d5 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -117,10 +117,9 @@ err1:
 	return false;
 }
 
-static void xt_rateest_mt_destroy(const struct xt_match *match,
-				  void *matchinfo)
+static void xt_rateest_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	struct xt_rateest_match_info *info = matchinfo;
+	struct xt_rateest_match_info *info = par->matchinfo;
 
 	xt_rateest_put(info->est1);
 	if (info->est2)
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index a512b49..4ebd4ca 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -349,9 +349,9 @@ out:
 	return ret;
 }
 
-static void recent_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void recent_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	const struct xt_recent_mtinfo *info = matchinfo;
+	const struct xt_recent_mtinfo *info = par->matchinfo;
 	struct recent_table *t;
 
 	mutex_lock(&recent_mutex);
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 88b1235..4c946cb 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -47,9 +47,9 @@ static bool state_mt_check(const struct xt_mtchk_param *par)
 	return true;
 }
 
-static void state_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void state_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(match->family);
+	nf_ct_l3proto_module_put(par->match->family);
 }
 
 static struct xt_match state_mt_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index c9407aa..b4d7741 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -70,9 +70,9 @@ static bool string_mt_check(const struct xt_mtchk_param *par)
 	return true;
 }
 
-static void string_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void string_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
+	textsearch_destroy(STRING_TEXT_PRIV(par->matchinfo)->config);
 }
 
 static struct xt_match xt_string_mt_reg[] __read_mostly = {
