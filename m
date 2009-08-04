From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 035/103] netfilter: xtables: replace XT_MATCH_ITERATE macro
Date: Tue,  4 Aug 2009 09:25:19 +0200
Message-ID: <1249370787-17583-36-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50629 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553AbZHDH1L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:11 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The macro is replaced by a list.h-like foreach loop. This makes
the code more inspectable.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h        |   10 +++-
 include/linux/netfilter_ipv4/ip_tables.h  |    6 +--
 include/linux/netfilter_ipv6/ip6_tables.h |    6 +--
 net/ipv4/netfilter/ip_tables.c            |   78 ++++++++++++++++++++++------
 net/ipv6/netfilter/ip6_tables.c           |   78 ++++++++++++++++++++++------
 net/netfilter/xt_TCPMSS.c                 |   12 +++--
 6 files changed, 141 insertions(+), 49 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 6e051c0..b4499d9 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -128,6 +128,7 @@ struct xt_counters_info
 
 #define XT_INV_PROTO		0x40	/* Invert the sense of PROTO. */
 
+#ifndef __KERNEL__
 /* fn returns 0 to continue iteration */
 #define XT_MATCH_ITERATE(type, e, fn, args...)			\
 ({								\
@@ -147,7 +148,6 @@ struct xt_counters_info
 	__ret;							\
 })
 
-#ifndef __KERNEL__
 /* fn returns 0 to continue iteration */
 #define XT_ENTRY_ITERATE_CONTINUE(type, entries, size, n, fn, args...) \
 ({								\
@@ -180,6 +180,14 @@ struct xt_counters_info
 	     (pos) < (typeof(pos))((char *)(ehead) + (esize)); \
 	     (pos) = (typeof(pos))((char *)(pos) + (pos)->next_offset))
 
+/* can only be xt_entry_match, so no use of typeof here */
+#define xt_ematch_foreach(pos, entry) \
+	for ((pos) = (struct xt_entry_match *)entry->elems; \
+	     (pos) < (struct xt_entry_match *)((char *)(entry) + \
+	             (entry)->target_offset); \
+	     (pos) = (struct xt_entry_match *)((char *)(pos) + \
+	             (pos)->u.match_size))
+
 #ifdef __KERNEL__
 
 #include <linux/netdevice.h>
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 362b1f1..f50c06f 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -228,11 +228,11 @@ ipt_get_target(struct ipt_entry *e)
 	return (void *)e + e->target_offset;
 }
 
+#ifndef __KERNEL__
 /* fn returns 0 to continue iteration */
 #define IPT_MATCH_ITERATE(e, fn, args...) \
 	XT_MATCH_ITERATE(struct ipt_entry, e, fn, ## args)
 
-#ifndef __KERNEL__
 /* fn returns 0 to continue iteration */
 #define IPT_ENTRY_ITERATE(entries, size, fn, args...) \
 	XT_ENTRY_ITERATE(struct ipt_entry, entries, size, fn, ## args)
@@ -323,10 +323,6 @@ compat_ipt_get_target(struct compat_ipt_entry *e)
 
 #define COMPAT_IPT_ALIGN(s) 	COMPAT_XT_ALIGN(s)
 
-/* fn returns 0 to continue iteration */
-#define COMPAT_IPT_MATCH_ITERATE(e, fn, args...) \
-	XT_MATCH_ITERATE(struct compat_ipt_entry, e, fn, ## args)
-
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IPTABLES_H */
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 43db986..89e0ab1 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -288,11 +288,11 @@ ip6t_get_target(struct ip6t_entry *e)
 	return (void *)e + e->target_offset;
 }
 
+#ifndef __KERNEL__
 /* fn returns 0 to continue iteration */
 #define IP6T_MATCH_ITERATE(e, fn, args...) \
 	XT_MATCH_ITERATE(struct ip6t_entry, e, fn, ## args)
 
-#ifndef __KERNEL__
 /* fn returns 0 to continue iteration */
 #define IP6T_ENTRY_ITERATE(entries, size, fn, args...) \
 	XT_ENTRY_ITERATE(struct ip6t_entry, entries, size, fn, ## args)
@@ -351,10 +351,6 @@ compat_ip6t_get_target(struct compat_ip6t_entry *e)
 
 #define COMPAT_IP6T_ALIGN(s)	COMPAT_XT_ALIGN(s)
 
-/* fn returns 0 to continue iteration */
-#define COMPAT_IP6T_MATCH_ITERATE(e, fn, args...) \
-	XT_MATCH_ITERATE(struct compat_ip6t_entry, e, fn, ## args)
-
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IP6_TABLES_H */
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 17c6ac7..8271680 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -359,16 +359,21 @@ ipt_do_table(struct sk_buff *skb,
 
 	do {
 		const struct ipt_entry_target *t;
+		const struct xt_entry_match *ematch;
 
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
 		if (!ip_packet_match(ip, indev, outdev,
-		    &e->ip, mtpar.fragoff) ||
-		    IPT_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0) {
+		    &e->ip, mtpar.fragoff)) {
+ no_match:
 			e = ipt_next_entry(e);
 			continue;
 		}
 
+		xt_ematch_foreach(ematch, e)
+			if (do_match(ematch, skb, &mtpar) != 0)
+				goto no_match;
+
 		ADD_COUNTER(e->counters, ntohs(ip->tot_len), 1);
 
 		t = ipt_get_target(e);
@@ -676,6 +681,7 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size)
 	int ret;
 	unsigned int j;
 	struct xt_mtchk_param mtpar;
+	struct xt_entry_match *ematch;
 
 	ret = check_entry(e, name);
 	if (ret)
@@ -686,7 +692,11 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size)
 	mtpar.entryinfo = &e->ip;
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV4;
-	ret = IPT_MATCH_ITERATE(e, find_check_match, &mtpar, &j);
+	xt_ematch_foreach(ematch, e) {
+		ret = find_check_match(ematch, &mtpar, &j);
+		if (ret != 0)
+			break;
+	}
 	if (ret != 0)
 		goto cleanup_matches;
 
@@ -709,7 +719,9 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size)
  err:
 	module_put(t->u.kernel.target->me);
  cleanup_matches:
-	IPT_MATCH_ITERATE(e, cleanup_match, &j);
+	xt_ematch_foreach(ematch, e)
+		if (cleanup_match(ematch, &j) != 0)
+			break;
 	return ret;
 }
 
@@ -780,9 +792,12 @@ cleanup_entry(struct ipt_entry *e)
 {
 	struct xt_tgdtor_param par;
 	struct ipt_entry_target *t;
+	struct xt_entry_match *ematch;
 
 	/* Cleanup all matches */
-	IPT_MATCH_ITERATE(e, cleanup_match, NULL);
+	xt_ematch_foreach(ematch, e)
+		if (cleanup_match(ematch, NULL) != 0)
+			break;
 	t = ipt_get_target(e);
 
 	par.target   = t->u.kernel.target;
@@ -1047,13 +1062,16 @@ static int compat_calc_entry(const struct ipt_entry *e,
 			     const struct xt_table_info *info,
 			     const void *base, struct xt_table_info *newinfo)
 {
+	const struct xt_entry_match *ematch;
 	const struct ipt_entry_target *t;
 	unsigned int entry_offset;
 	int off, i, ret;
 
 	off = sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
 	entry_offset = (void *)e - base;
-	IPT_MATCH_ITERATE(e, compat_calc_match, &off);
+	xt_ematch_foreach(ematch, e)
+		if (compat_calc_match(ematch, &off) != 0)
+			break;
 	t = ipt_get_target_c(e);
 	off += xt_compat_target_offset(t->u.kernel.target);
 	newinfo->size -= off;
@@ -1428,7 +1446,8 @@ compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 	struct compat_ipt_entry __user *ce;
 	u_int16_t target_offset, next_offset;
 	compat_uint_t origsize;
-	int ret;
+	const struct xt_entry_match *ematch;
+	int ret = 0;
 
 	origsize = *size;
 	ce = (struct compat_ipt_entry __user *)*dstptr;
@@ -1440,7 +1459,11 @@ compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 	*dstptr += sizeof(struct compat_ipt_entry);
 	*size -= sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
 
-	ret = IPT_MATCH_ITERATE(e, xt_compat_match_to_user, dstptr, size);
+	xt_ematch_foreach(ematch, e) {
+		ret = xt_compat_match_to_user(ematch, dstptr, size);
+		if (ret != 0)
+			break;
+	}
 	target_offset = e->target_offset - (origsize - *size);
 	if (ret)
 		return ret;
@@ -1492,9 +1515,12 @@ compat_release_match(struct ipt_entry_match *m, unsigned int *i)
 static void compat_release_entry(struct compat_ipt_entry *e)
 {
 	struct ipt_entry_target *t;
+	struct xt_entry_match *ematch;
 
 	/* Cleanup all matches */
-	COMPAT_IPT_MATCH_ITERATE(e, compat_release_match, NULL);
+	xt_ematch_foreach(ematch, e)
+		if (compat_release_match(ematch, NULL) != 0)
+			break;
 	t = compat_ipt_get_target(e);
 	module_put(t->u.kernel.target->me);
 }
@@ -1509,6 +1535,7 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 				  const unsigned int *underflows,
 				  const char *name)
 {
+	struct xt_entry_match *ematch;
 	struct ipt_entry_target *t;
 	struct xt_target *target;
 	unsigned int entry_offset;
@@ -1537,8 +1564,12 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	off = sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
 	entry_offset = (void *)e - (void *)base;
 	j = 0;
-	ret = COMPAT_IPT_MATCH_ITERATE(e, compat_find_calc_match, name,
-				       &e->ip, e->comefrom, &off, &j);
+	xt_ematch_foreach(ematch, e) {
+		ret = compat_find_calc_match(ematch, name,
+		      &e->ip, e->comefrom, &off, &j);
+		if (ret != 0)
+			break;
+	}
 	if (ret != 0)
 		goto release_matches;
 
@@ -1577,7 +1608,9 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 out:
 	module_put(t->u.kernel.target->me);
 release_matches:
-	IPT_MATCH_ITERATE(e, compat_release_match, &j);
+	xt_ematch_foreach(ematch, e)
+		if (compat_release_match(ematch, &j) != 0)
+			break;
 	return ret;
 }
 
@@ -1591,6 +1624,7 @@ compat_copy_entry_from_user(struct compat_ipt_entry *e, void **dstptr,
 	struct ipt_entry *de;
 	unsigned int origsize;
 	int ret, h;
+	struct xt_entry_match *ematch;
 
 	ret = 0;
 	origsize = *size;
@@ -1601,8 +1635,11 @@ compat_copy_entry_from_user(struct compat_ipt_entry *e, void **dstptr,
 	*dstptr += sizeof(struct ipt_entry);
 	*size += sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
 
-	ret = COMPAT_IPT_MATCH_ITERATE(e, xt_compat_match_from_user,
-				       dstptr, size);
+	xt_ematch_foreach(ematch, e) {
+		ret = xt_compat_match_from_user(ematch, dstptr, size);
+		if (ret != 0)
+			break;
+	}
 	if (ret)
 		return ret;
 	de->target_offset = e->target_offset - (origsize - *size);
@@ -1623,16 +1660,21 @@ compat_copy_entry_from_user(struct compat_ipt_entry *e, void **dstptr,
 static int
 compat_check_entry(struct ipt_entry *e, const char *name)
 {
+	struct xt_entry_match *ematch;
 	struct xt_mtchk_param mtpar;
 	unsigned int j;
-	int ret;
+	int ret = 0;
 
 	j = 0;
 	mtpar.table     = name;
 	mtpar.entryinfo = &e->ip;
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV4;
-	ret = IPT_MATCH_ITERATE(e, check_match, &mtpar, &j);
+	xt_ematch_foreach(ematch, e) {
+		ret = check_match(ematch, &mtpar, &j);
+		if (ret != 0)
+			break;
+	}
 	if (ret)
 		goto cleanup_matches;
 
@@ -1642,7 +1684,9 @@ compat_check_entry(struct ipt_entry *e, const char *name)
 	return 0;
 
  cleanup_matches:
-	IPT_MATCH_ITERATE(e, cleanup_match, &j);
+	xt_ematch_foreach(ematch, e)
+		if (cleanup_match(ematch, &j) != 0)
+			break;
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 9d666f3..c52b9a9 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -386,16 +386,21 @@ ip6t_do_table(struct sk_buff *skb,
 
 	do {
 		const struct ip6t_entry_target *t;
+		const struct xt_entry_match *ematch;
 
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
 		if (!ip6_packet_match(skb, indev, outdev, &e->ipv6,
-		    &mtpar.thoff, &mtpar.fragoff, &hotdrop) ||
-		    IP6T_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0) {
+		    &mtpar.thoff, &mtpar.fragoff, &hotdrop)) {
+ no_match:
 			e = ip6t_next_entry(e);
 			continue;
 		}
 
+		xt_ematch_foreach(ematch, e)
+			if (do_match(ematch, skb, &mtpar) != 0)
+				goto no_match;
+
 		ADD_COUNTER(e->counters,
 			    ntohs(ipv6_hdr(skb)->payload_len) +
 			    sizeof(struct ipv6hdr), 1);
@@ -707,6 +712,7 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size)
 	int ret;
 	unsigned int j;
 	struct xt_mtchk_param mtpar;
+	struct xt_entry_match *ematch;
 
 	ret = check_entry(e, name);
 	if (ret)
@@ -717,7 +723,11 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size)
 	mtpar.entryinfo = &e->ipv6;
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV6;
-	ret = IP6T_MATCH_ITERATE(e, find_check_match, &mtpar, &j);
+	xt_ematch_foreach(ematch, e) {
+		ret = find_check_match(ematch, &mtpar, &j);
+		if (ret != 0)
+			break;
+	}
 	if (ret != 0)
 		goto cleanup_matches;
 
@@ -740,7 +750,9 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size)
  err:
 	module_put(t->u.kernel.target->me);
  cleanup_matches:
-	IP6T_MATCH_ITERATE(e, cleanup_match, &j);
+	xt_ematch_foreach(ematch, e)
+		if (cleanup_match(ematch, &j) != 0)
+			break;
 	return ret;
 }
 
@@ -810,9 +822,12 @@ static void cleanup_entry(struct ip6t_entry *e)
 {
 	struct xt_tgdtor_param par;
 	struct ip6t_entry_target *t;
+	struct xt_entry_match *ematch;
 
 	/* Cleanup all matches */
-	IP6T_MATCH_ITERATE(e, cleanup_match, NULL);
+	xt_ematch_foreach(ematch, e)
+		if (cleanup_match(ematch, NULL) != 0)
+			break;
 	t = ip6t_get_target(e);
 
 	par.target   = t->u.kernel.target;
@@ -1077,13 +1092,16 @@ static int compat_calc_entry(const struct ip6t_entry *e,
 			     const struct xt_table_info *info,
 			     const void *base, struct xt_table_info *newinfo)
 {
+	const struct xt_entry_match *ematch;
 	const struct ip6t_entry_target *t;
 	unsigned int entry_offset;
 	int off, i, ret;
 
 	off = sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
 	entry_offset = (void *)e - base;
-	IP6T_MATCH_ITERATE(e, compat_calc_match, &off);
+	xt_ematch_foreach(ematch, e)
+		if (compat_calc_match(ematch, &off) != 0)
+			break;
 	t = ip6t_get_target_c(e);
 	off += xt_compat_target_offset(t->u.kernel.target);
 	newinfo->size -= off;
@@ -1461,7 +1479,8 @@ compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
 	struct compat_ip6t_entry __user *ce;
 	u_int16_t target_offset, next_offset;
 	compat_uint_t origsize;
-	int ret;
+	const struct xt_entry_match *ematch;
+	int ret = 0;
 
 	origsize = *size;
 	ce = (struct compat_ip6t_entry __user *)*dstptr;
@@ -1473,7 +1492,11 @@ compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
 	*dstptr += sizeof(struct compat_ip6t_entry);
 	*size -= sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
 
-	ret = IP6T_MATCH_ITERATE(e, xt_compat_match_to_user, dstptr, size);
+	xt_ematch_foreach(ematch, e) {
+		ret = xt_compat_match_to_user(ematch, dstptr, size);
+		if (ret != 0)
+			break;
+	}
 	target_offset = e->target_offset - (origsize - *size);
 	if (ret)
 		return ret;
@@ -1525,9 +1548,12 @@ compat_release_match(struct ip6t_entry_match *m, unsigned int *i)
 static void compat_release_entry(struct compat_ip6t_entry *e)
 {
 	struct ip6t_entry_target *t;
+	struct xt_entry_match *ematch;
 
 	/* Cleanup all matches */
-	COMPAT_IP6T_MATCH_ITERATE(e, compat_release_match, NULL);
+	xt_ematch_foreach(ematch, e)
+		if (compat_release_match(ematch, NULL) != 0)
+			break;
 	t = compat_ip6t_get_target(e);
 	module_put(t->u.kernel.target->me);
 }
@@ -1542,6 +1568,7 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 				  const unsigned int *underflows,
 				  const char *name)
 {
+	struct xt_entry_match *ematch;
 	struct ip6t_entry_target *t;
 	struct xt_target *target;
 	unsigned int entry_offset;
@@ -1570,8 +1597,12 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 	off = sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
 	entry_offset = (void *)e - (void *)base;
 	j = 0;
-	ret = COMPAT_IP6T_MATCH_ITERATE(e, compat_find_calc_match, name,
-					&e->ipv6, e->comefrom, &off, &j);
+	xt_ematch_foreach(ematch, e) {
+		ret = compat_find_calc_match(ematch, name,
+		      &e->ipv6, e->comefrom, &off, &j);
+		if (ret != 0)
+			break;
+	}
 	if (ret != 0)
 		goto release_matches;
 
@@ -1610,7 +1641,9 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 out:
 	module_put(t->u.kernel.target->me);
 release_matches:
-	IP6T_MATCH_ITERATE(e, compat_release_match, &j);
+	xt_ematch_foreach(ematch, e)
+		if (compat_release_match(ematch, &j) != 0)
+			break;
 	return ret;
 }
 
@@ -1624,6 +1657,7 @@ compat_copy_entry_from_user(struct compat_ip6t_entry *e, void **dstptr,
 	struct ip6t_entry *de;
 	unsigned int origsize;
 	int ret, h;
+	struct xt_entry_match *ematch;
 
 	ret = 0;
 	origsize = *size;
@@ -1634,8 +1668,11 @@ compat_copy_entry_from_user(struct compat_ip6t_entry *e, void **dstptr,
 	*dstptr += sizeof(struct ip6t_entry);
 	*size += sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
 
-	ret = COMPAT_IP6T_MATCH_ITERATE(e, xt_compat_match_from_user,
-					dstptr, size);
+	xt_ematch_foreach(ematch, e) {
+		ret = xt_compat_match_from_user(ematch, dstptr, size);
+		if (ret != 0)
+			break;
+	}
 	if (ret)
 		return ret;
 	de->target_offset = e->target_offset - (origsize - *size);
@@ -1656,15 +1693,20 @@ compat_copy_entry_from_user(struct compat_ip6t_entry *e, void **dstptr,
 static int compat_check_entry(struct ip6t_entry *e, const char *name)
 {
 	unsigned int j;
-	int ret;
+	int ret = 0;
 	struct xt_mtchk_param mtpar;
+	struct xt_entry_match *ematch;
 
 	j = 0;
 	mtpar.table     = name;
 	mtpar.entryinfo = &e->ipv6;
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV6;
-	ret = IP6T_MATCH_ITERATE(e, check_match, &mtpar, &j);
+	xt_ematch_foreach(ematch, e) {
+		ret = check_match(ematch, &mtpar, &j);
+		if (ret != 0)
+			break;
+	}
 	if (ret)
 		goto cleanup_matches;
 
@@ -1674,7 +1716,9 @@ static int compat_check_entry(struct ip6t_entry *e, const char *name)
 	return 0;
 
  cleanup_matches:
-	IP6T_MATCH_ITERATE(e, cleanup_match, &j);
+	xt_ematch_foreach(ematch, e)
+		if (cleanup_match(ematch, &j) != 0)
+			break;
 	return ret;
 }
 
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index eda64c1..ea8933e 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -241,6 +241,7 @@ static bool tcpmss_tg4_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
+	const struct xt_entry_match *ematch;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
 	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
@@ -250,8 +251,9 @@ static bool tcpmss_tg4_check(const struct xt_tgchk_param *par)
 		       "FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return false;
 	}
-	if (IPT_MATCH_ITERATE(e, find_syn_match))
-		return true;
+	xt_ematch_foreach(ematch, e)
+		if (find_syn_match(ematch))
+			return true;
 	printk("xt_TCPMSS: Only works on TCP SYN packets\n");
 	return false;
 }
@@ -261,6 +263,7 @@ static bool tcpmss_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
 	const struct ip6t_entry *e = par->entryinfo;
+	const struct xt_entry_match *ematch;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
 	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
@@ -270,8 +273,9 @@ static bool tcpmss_tg6_check(const struct xt_tgchk_param *par)
 		       "FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return false;
 	}
-	if (IP6T_MATCH_ITERATE(e, find_syn_match))
-		return true;
+	xt_ematch_foreach(ematch, e)
+		if (find_syn_match(ematch))
+			return true;
 	printk("xt_TCPMSS: Only works on TCP SYN packets\n");
 	return false;
 }
-- 
1.6.3.3

