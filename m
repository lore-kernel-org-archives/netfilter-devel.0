From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 036/103] netfilter: xtables: optimize call flow around xt_ematch_foreach
Date: Tue,  4 Aug 2009 09:25:20 +0200
Message-ID: <1249370787-17583-37-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50630 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbZHDH1M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:12 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_tables.c  |   94 +++++++++++++-------------------------
 net/ipv6/netfilter/ip6_tables.c |   94 +++++++++++++-------------------------
 2 files changed, 64 insertions(+), 124 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 8271680..5e92076 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -565,21 +565,16 @@ mark_source_chains(const struct xt_table_info *newinfo,
 	return 1;
 }
 
-static int
-cleanup_match(struct ipt_entry_match *m, unsigned int *i)
+static void cleanup_match(struct ipt_entry_match *m)
 {
 	struct xt_mtdtor_param par;
 
-	if (i && (*i)-- == 0)
-		return 1;
-
 	par.match     = m->u.kernel.match;
 	par.matchinfo = m->data;
 	par.family    = NFPROTO_IPV4;
 	if (par.match->destroy != NULL)
 		par.match->destroy(&par);
 	module_put(par.match->me);
-	return 0;
 }
 
 static int
@@ -604,8 +599,7 @@ check_entry(const struct ipt_entry *e, const char *name)
 }
 
 static int
-check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par,
-	    unsigned int *i)
+check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par)
 {
 	const struct ipt_ip *ip = par->entryinfo;
 	int ret;
@@ -620,13 +614,11 @@ check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par,
 			 par.match->name);
 		return ret;
 	}
-	++*i;
 	return 0;
 }
 
 static int
-find_check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par,
-		 unsigned int *i)
+find_check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par)
 {
 	struct xt_match *match;
 	int ret;
@@ -640,7 +632,7 @@ find_check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par,
 	}
 	m->u.kernel.match = match;
 
-	ret = check_match(m, par, i);
+	ret = check_match(m, par);
 	if (ret)
 		goto err;
 
@@ -693,12 +685,11 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size)
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV4;
 	xt_ematch_foreach(ematch, e) {
-		ret = find_check_match(ematch, &mtpar, &j);
+		ret = find_check_match(ematch, &mtpar);
 		if (ret != 0)
-			break;
+			goto cleanup_matches;
+		++j;
 	}
-	if (ret != 0)
-		goto cleanup_matches;
 
 	t = ipt_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET,
@@ -719,9 +710,11 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size)
  err:
 	module_put(t->u.kernel.target->me);
  cleanup_matches:
-	xt_ematch_foreach(ematch, e)
-		if (cleanup_match(ematch, &j) != 0)
+	xt_ematch_foreach(ematch, e) {
+		if (j-- == 0)
 			break;
+		cleanup_match(ematch);
+	}
 	return ret;
 }
 
@@ -796,8 +789,7 @@ cleanup_entry(struct ipt_entry *e)
 
 	/* Cleanup all matches */
 	xt_ematch_foreach(ematch, e)
-		if (cleanup_match(ematch, NULL) != 0)
-			break;
+		cleanup_match(ematch);
 	t = ipt_get_target(e);
 
 	par.target   = t->u.kernel.target;
@@ -1051,13 +1043,6 @@ static int compat_standard_to_user(void __user *dst, const void *src)
 	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
 }
 
-static inline int
-compat_calc_match(const struct ipt_entry_match *m, int *size)
-{
-	*size += xt_compat_match_offset(m->u.kernel.match);
-	return 0;
-}
-
 static int compat_calc_entry(const struct ipt_entry *e,
 			     const struct xt_table_info *info,
 			     const void *base, struct xt_table_info *newinfo)
@@ -1070,8 +1055,8 @@ static int compat_calc_entry(const struct ipt_entry *e,
 	off = sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
 	entry_offset = (void *)e - base;
 	xt_ematch_foreach(ematch, e)
-		if (compat_calc_match(ematch, &off) != 0)
-			break;
+		off += xt_compat_match_offset(ematch->u.kernel.match);
+
 	t = ipt_get_target_c(e);
 	off += xt_compat_target_offset(t->u.kernel.target);
 	newinfo->size -= off;
@@ -1462,11 +1447,9 @@ compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 	xt_ematch_foreach(ematch, e) {
 		ret = xt_compat_match_to_user(ematch, dstptr, size);
 		if (ret != 0)
-			break;
+			return ret;
 	}
 	target_offset = e->target_offset - (origsize - *size);
-	if (ret)
-		return ret;
 	t = ipt_get_target(e);
 	ret = xt_compat_target_to_user(t, dstptr, size);
 	if (ret)
@@ -1483,7 +1466,7 @@ compat_find_calc_match(struct ipt_entry_match *m,
 		       const char *name,
 		       const struct ipt_ip *ip,
 		       unsigned int hookmask,
-		       int *size, unsigned int *i)
+		       int *size)
 {
 	struct xt_match *match;
 
@@ -1497,18 +1480,6 @@ compat_find_calc_match(struct ipt_entry_match *m,
 	}
 	m->u.kernel.match = match;
 	*size += xt_compat_match_offset(match);
-
-	(*i)++;
-	return 0;
-}
-
-static int
-compat_release_match(struct ipt_entry_match *m, unsigned int *i)
-{
-	if (i && (*i)-- == 0)
-		return 1;
-
-	module_put(m->u.kernel.match->me);
 	return 0;
 }
 
@@ -1519,8 +1490,7 @@ static void compat_release_entry(struct compat_ipt_entry *e)
 
 	/* Cleanup all matches */
 	xt_ematch_foreach(ematch, e)
-		if (compat_release_match(ematch, NULL) != 0)
-			break;
+		module_put(ematch->u.kernel.match->me);
 	t = compat_ipt_get_target(e);
 	module_put(t->u.kernel.target->me);
 }
@@ -1566,12 +1536,11 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	j = 0;
 	xt_ematch_foreach(ematch, e) {
 		ret = compat_find_calc_match(ematch, name,
-		      &e->ip, e->comefrom, &off, &j);
+		      &e->ip, e->comefrom, &off);
 		if (ret != 0)
-			break;
+			goto release_matches;
+		++j;
 	}
-	if (ret != 0)
-		goto release_matches;
 
 	t = compat_ipt_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET,
@@ -1608,9 +1577,11 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 out:
 	module_put(t->u.kernel.target->me);
 release_matches:
-	xt_ematch_foreach(ematch, e)
-		if (compat_release_match(ematch, &j) != 0)
+	xt_ematch_foreach(ematch, e) {
+		if (j-- == 0)
 			break;
+		module_put(ematch->u.kernel.match->me);
+	}
 	return ret;
 }
 
@@ -1638,10 +1609,8 @@ compat_copy_entry_from_user(struct compat_ipt_entry *e, void **dstptr,
 	xt_ematch_foreach(ematch, e) {
 		ret = xt_compat_match_from_user(ematch, dstptr, size);
 		if (ret != 0)
-			break;
+			return ret;
 	}
-	if (ret)
-		return ret;
 	de->target_offset = e->target_offset - (origsize - *size);
 	t = compat_ipt_get_target(e);
 	target = t->u.kernel.target;
@@ -1671,12 +1640,11 @@ compat_check_entry(struct ipt_entry *e, const char *name)
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV4;
 	xt_ematch_foreach(ematch, e) {
-		ret = check_match(ematch, &mtpar, &j);
+		ret = check_match(ematch, &mtpar);
 		if (ret != 0)
-			break;
+			goto cleanup_matches;
+		++j;
 	}
-	if (ret)
-		goto cleanup_matches;
 
 	ret = check_target(e, name);
 	if (ret)
@@ -1684,9 +1652,11 @@ compat_check_entry(struct ipt_entry *e, const char *name)
 	return 0;
 
  cleanup_matches:
-	xt_ematch_foreach(ematch, e)
-		if (cleanup_match(ematch, &j) != 0)
+	xt_ematch_foreach(ematch, e) {
+		if (j-- == 0)
 			break;
+		cleanup_match(ematch);
+	}
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index c52b9a9..b335ce7 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -596,21 +596,16 @@ mark_source_chains(const struct xt_table_info *newinfo,
 	return 1;
 }
 
-static int
-cleanup_match(struct ip6t_entry_match *m, unsigned int *i)
+static void cleanup_match(struct ip6t_entry_match *m)
 {
 	struct xt_mtdtor_param par;
 
-	if (i && (*i)-- == 0)
-		return 1;
-
 	par.match     = m->u.kernel.match;
 	par.matchinfo = m->data;
 	par.family    = NFPROTO_IPV6;
 	if (par.match->destroy != NULL)
 		par.match->destroy(&par);
 	module_put(par.match->me);
-	return 0;
 }
 
 static int
@@ -634,8 +629,7 @@ check_entry(const struct ip6t_entry *e, const char *name)
 	return 0;
 }
 
-static int check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par,
-		       unsigned int *i)
+static int check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par)
 {
 	const struct ip6t_ip6 *ipv6 = par->entryinfo;
 	int ret;
@@ -650,13 +644,11 @@ static int check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par,
 			 par.match->name);
 		return ret;
 	}
-	++*i;
 	return 0;
 }
 
 static int
-find_check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par,
-		 unsigned int *i)
+find_check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par)
 {
 	struct xt_match *match;
 	int ret;
@@ -670,7 +662,7 @@ find_check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par,
 	}
 	m->u.kernel.match = match;
 
-	ret = check_match(m, par, i);
+	ret = check_match(m, par);
 	if (ret)
 		goto err;
 
@@ -724,12 +716,11 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size)
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV6;
 	xt_ematch_foreach(ematch, e) {
-		ret = find_check_match(ematch, &mtpar, &j);
+		ret = find_check_match(ematch, &mtpar);
 		if (ret != 0)
-			break;
+			goto cleanup_matches;
+		++j;
 	}
-	if (ret != 0)
-		goto cleanup_matches;
 
 	t = ip6t_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET6,
@@ -750,9 +741,11 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size)
  err:
 	module_put(t->u.kernel.target->me);
  cleanup_matches:
-	xt_ematch_foreach(ematch, e)
-		if (cleanup_match(ematch, &j) != 0)
+	xt_ematch_foreach(ematch, e) {
+		if (j-- == 0)
 			break;
+		cleanup_match(ematch);
+	}
 	return ret;
 }
 
@@ -826,8 +819,7 @@ static void cleanup_entry(struct ip6t_entry *e)
 
 	/* Cleanup all matches */
 	xt_ematch_foreach(ematch, e)
-		if (cleanup_match(ematch, NULL) != 0)
-			break;
+		cleanup_match(ematch);
 	t = ip6t_get_target(e);
 
 	par.target   = t->u.kernel.target;
@@ -1081,13 +1073,6 @@ static int compat_standard_to_user(void __user *dst, const void *src)
 	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
 }
 
-static inline int
-compat_calc_match(const struct ip6t_entry_match *m, int *size)
-{
-	*size += xt_compat_match_offset(m->u.kernel.match);
-	return 0;
-}
-
 static int compat_calc_entry(const struct ip6t_entry *e,
 			     const struct xt_table_info *info,
 			     const void *base, struct xt_table_info *newinfo)
@@ -1100,8 +1085,8 @@ static int compat_calc_entry(const struct ip6t_entry *e,
 	off = sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
 	entry_offset = (void *)e - base;
 	xt_ematch_foreach(ematch, e)
-		if (compat_calc_match(ematch, &off) != 0)
-			break;
+		off += xt_compat_match_offset(ematch->u.kernel.match);
+
 	t = ip6t_get_target_c(e);
 	off += xt_compat_target_offset(t->u.kernel.target);
 	newinfo->size -= off;
@@ -1495,11 +1480,9 @@ compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
 	xt_ematch_foreach(ematch, e) {
 		ret = xt_compat_match_to_user(ematch, dstptr, size);
 		if (ret != 0)
-			break;
+			return ret;
 	}
 	target_offset = e->target_offset - (origsize - *size);
-	if (ret)
-		return ret;
 	t = ip6t_get_target(e);
 	ret = xt_compat_target_to_user(t, dstptr, size);
 	if (ret)
@@ -1516,7 +1499,7 @@ compat_find_calc_match(struct ip6t_entry_match *m,
 		       const char *name,
 		       const struct ip6t_ip6 *ipv6,
 		       unsigned int hookmask,
-		       int *size, unsigned int *i)
+		       int *size)
 {
 	struct xt_match *match;
 
@@ -1530,18 +1513,6 @@ compat_find_calc_match(struct ip6t_entry_match *m,
 	}
 	m->u.kernel.match = match;
 	*size += xt_compat_match_offset(match);
-
-	(*i)++;
-	return 0;
-}
-
-static int
-compat_release_match(struct ip6t_entry_match *m, unsigned int *i)
-{
-	if (i && (*i)-- == 0)
-		return 1;
-
-	module_put(m->u.kernel.match->me);
 	return 0;
 }
 
@@ -1552,8 +1523,7 @@ static void compat_release_entry(struct compat_ip6t_entry *e)
 
 	/* Cleanup all matches */
 	xt_ematch_foreach(ematch, e)
-		if (compat_release_match(ematch, NULL) != 0)
-			break;
+		module_put(ematch->u.kernel.match->me);
 	t = compat_ip6t_get_target(e);
 	module_put(t->u.kernel.target->me);
 }
@@ -1599,12 +1569,11 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 	j = 0;
 	xt_ematch_foreach(ematch, e) {
 		ret = compat_find_calc_match(ematch, name,
-		      &e->ipv6, e->comefrom, &off, &j);
+		      &e->ipv6, e->comefrom, &off);
 		if (ret != 0)
-			break;
+			goto release_matches;
+		++j;
 	}
-	if (ret != 0)
-		goto release_matches;
 
 	t = compat_ip6t_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET6,
@@ -1641,9 +1610,11 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 out:
 	module_put(t->u.kernel.target->me);
 release_matches:
-	xt_ematch_foreach(ematch, e)
-		if (compat_release_match(ematch, &j) != 0)
+	xt_ematch_foreach(ematch, e) {
+		if (j-- == 0)
 			break;
+		module_put(ematch->u.kernel.match->me);
+	}
 	return ret;
 }
 
@@ -1671,10 +1642,8 @@ compat_copy_entry_from_user(struct compat_ip6t_entry *e, void **dstptr,
 	xt_ematch_foreach(ematch, e) {
 		ret = xt_compat_match_from_user(ematch, dstptr, size);
 		if (ret != 0)
-			break;
+			return ret;
 	}
-	if (ret)
-		return ret;
 	de->target_offset = e->target_offset - (origsize - *size);
 	t = compat_ip6t_get_target(e);
 	target = t->u.kernel.target;
@@ -1703,12 +1672,11 @@ static int compat_check_entry(struct ip6t_entry *e, const char *name)
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV6;
 	xt_ematch_foreach(ematch, e) {
-		ret = check_match(ematch, &mtpar, &j);
+		ret = check_match(ematch, &mtpar);
 		if (ret != 0)
-			break;
+			goto cleanup_matches;
+		++j;
 	}
-	if (ret)
-		goto cleanup_matches;
 
 	ret = check_target(e, name);
 	if (ret)
@@ -1716,9 +1684,11 @@ static int compat_check_entry(struct ip6t_entry *e, const char *name)
 	return 0;
 
  cleanup_matches:
-	xt_ematch_foreach(ematch, e)
-		if (cleanup_match(ematch, &j) != 0)
+	xt_ematch_foreach(ematch, e) {
+		if (j-- == 0)
 			break;
+		cleanup_match(ematch);
+	}
 	return ret;
 }
 
-- 
1.6.3.3

