From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/16] [NETFILTER]: Move extension arguments into compound structure (3/6)
Date: Sat,  4 Oct 2008 15:41:24 -0400
Message-ID: <f240056c3c83528781570a2e5c95e22199c5de39.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34318 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbYJDTlf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:41:35 -0400
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch does this for match extensions' destroy functions.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    8 +++++++-
 net/bridge/netfilter/ebtables.c    |   10 +++++++---
 net/ipv4/netfilter/ip_tables.c     |   10 +++++++---
 net/ipv6/netfilter/ip6_tables.c    |   10 +++++++---
 net/netfilter/xt_connbytes.c       |    4 ++--
 net/netfilter/xt_connlimit.c       |    7 +++----
 net/netfilter/xt_connmark.c        |    5 ++---
 net/netfilter/xt_conntrack.c       |    5 ++---
 net/netfilter/xt_hashlimit.c       |    9 ++++-----
 net/netfilter/xt_helper.c          |    4 ++--
 net/netfilter/xt_rateest.c         |    5 ++---
 net/netfilter/xt_recent.c          |    4 ++--
 net/netfilter/xt_state.c           |    4 ++--
 net/netfilter/xt_string.c          |    4 ++--
 14 files changed, 51 insertions(+), 38 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 7282eaf..99a9840 100644
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
@@ -229,7 +235,7 @@ struct xt_match
 	bool (*checkentry)(struct xt_mtchk_param *);
 
 	/* Called when entry of this type deleted. */
-	void (*destroy)(const struct xt_match *match, void *matchinfo);
+	void (*destroy)(struct xt_mtdtor_param *);
 
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, void *src);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index c4c75db..6a553c3 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -564,12 +564,16 @@ ebt_get_udc_positions(struct ebt_entry *e, struct ebt_table_info *newinfo,
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
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c042144..ad0c8a5 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -584,12 +584,16 @@ mark_source_chains(struct xt_table_info *newinfo,
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
index 36cf8de..e6f6465 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -611,12 +611,16 @@ mark_source_chains(struct xt_table_info *newinfo,
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
index 9fb78d9..59a87f7 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -114,9 +114,9 @@ static bool connbytes_mt_check(struct xt_mtchk_param *par)
 	return true;
 }
 
-static void connbytes_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void connbytes_mt_destroy(struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(match->family);
+	nf_ct_l3proto_module_put(par->match->family);
 }
 
 static struct xt_match connbytes_mt_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 2b40ae1..21492e2 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -245,16 +245,15 @@ static bool connlimit_mt_check(struct xt_mtchk_param *par)
 	return true;
 }
 
-static void
-connlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void connlimit_mt_destroy(struct xt_mtdtor_param *par)
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
index 559d522..830bf06 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -86,10 +86,9 @@ static bool connmark_mt_check(struct xt_mtchk_param *par)
 	return true;
 }
 
-static void
-connmark_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void connmark_mt_destroy(struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(match->family);
+	nf_ct_l3proto_module_put(par->match->family);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 294ace1..cfe0afb 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -287,10 +287,9 @@ static bool conntrack_mt_check(struct xt_mtchk_param *par)
 	return true;
 }
 
-static void
-conntrack_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void conntrack_mt_destroy(struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(match->family);
+	nf_ct_l3proto_module_put(par->match->family);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 5208f9c..6e6bbf6 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -747,17 +747,16 @@ static bool hashlimit_mt_check(struct xt_mtchk_param *par)
 }
 
 static void
-hashlimit_mt_destroy_v0(const struct xt_match *match, void *matchinfo)
+hashlimit_mt_destroy_v0(struct xt_mtdtor_param *par)
 {
-	const struct xt_hashlimit_info *r = matchinfo;
+	const struct xt_hashlimit_info *r = par->matchinfo;
 
 	htable_put(r->hinfo);
 }
 
-static void
-hashlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void hashlimit_mt_destroy(struct xt_mtdtor_param *par)
 {
-	const struct xt_hashlimit_mtinfo1 *info = matchinfo;
+	const struct xt_hashlimit_mtinfo1 *info = par->matchinfo;
 
 	htable_put(info->hinfo);
 }
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 3ce867e..54b74f4 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -66,9 +66,9 @@ static bool helper_mt_check(struct xt_mtchk_param *par)
 	return true;
 }
 
-static void helper_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void helper_mt_destroy(struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(match->family);
+	nf_ct_l3proto_module_put(par->match->family);
 }
 
 static struct xt_match helper_mt_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 8244eb7..fa855b4 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -117,10 +117,9 @@ err1:
 	return false;
 }
 
-static void xt_rateest_mt_destroy(const struct xt_match *match,
-				  void *matchinfo)
+static void xt_rateest_mt_destroy(struct xt_mtdtor_param *par)
 {
-	struct xt_rateest_match_info *info = matchinfo;
+	struct xt_rateest_match_info *info = par->matchinfo;
 
 	xt_rateest_put(info->est1);
 	if (info->est2)
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 1cc5d71..13518ae 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -348,9 +348,9 @@ out:
 	return ret;
 }
 
-static void recent_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void recent_mt_destroy(struct xt_mtdtor_param *par)
 {
-	const struct xt_recent_mtinfo *info = matchinfo;
+	const struct xt_recent_mtinfo *info = par->matchinfo;
 	struct recent_table *t;
 
 	mutex_lock(&recent_mutex);
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index be9cc8d..07df155 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -46,9 +46,9 @@ static bool state_mt_check(struct xt_mtchk_param *par)
 	return true;
 }
 
-static void state_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void state_mt_destroy(struct xt_mtdtor_param *par)
 {
-	nf_ct_l3proto_module_put(match->family);
+	nf_ct_l3proto_module_put(par->match->family);
 }
 
 static struct xt_match state_mt_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index a53001b..44a1ba1 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -69,9 +69,9 @@ static bool string_mt_check(struct xt_mtchk_param *par)
 	return true;
 }
 
-static void string_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void string_mt_destroy(struct xt_mtdtor_param *par)
 {
-	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
+	textsearch_destroy(STRING_TEXT_PRIV(par->matchinfo)->config);
 }
 
 static struct xt_match xt_string_mt_reg[] __read_mostly = {
-- 
1.6.0.1

