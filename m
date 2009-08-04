From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 034/103] netfilter: xtables: optimize call flow around xt_entry_foreach
Date: Tue,  4 Aug 2009 09:25:18 +0200
Message-ID: <1249370787-17583-35-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50631 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbZHDH1L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:11 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arp_tables.c |  179 ++++++++++++-------------------------
 net/ipv4/netfilter/ip_tables.c  |  184 +++++++++++++-------------------------
 net/ipv6/netfilter/ip6_tables.c |  181 +++++++++++++-------------------------
 3 files changed, 182 insertions(+), 362 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 95695e7..26b7157 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -505,8 +505,7 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 }
 
 static inline int
-find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
-		 unsigned int *i)
+find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
 {
 	struct arpt_entry_target *t;
 	struct xt_target *target;
@@ -532,7 +531,6 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
 	if (ret)
 		goto err;
 
-	(*i)++;
 	return 0;
 err:
 	module_put(t->u.kernel.target->me);
@@ -561,8 +559,7 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 					     const unsigned char *limit,
 					     const unsigned int *hook_entries,
 					     const unsigned int *underflows,
-					     unsigned int valid_hooks,
-					     unsigned int *i)
+					     unsigned int valid_hooks)
 {
 	unsigned int h;
 
@@ -599,19 +596,14 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 	/* Clear counters and comefrom */
 	e->counters = ((struct xt_counters) { 0, 0 });
 	e->comefrom = 0;
-
-	(*i)++;
 	return 0;
 }
 
-static inline int cleanup_entry(struct arpt_entry *e, unsigned int *i)
+static inline void cleanup_entry(struct arpt_entry *e)
 {
 	struct xt_tgdtor_param par;
 	struct arpt_entry_target *t;
 
-	if (i && (*i)-- == 0)
-		return 1;
-
 	t = arpt_get_target(e);
 	par.target   = t->u.kernel.target;
 	par.targinfo = t->data;
@@ -619,7 +611,6 @@ static inline int cleanup_entry(struct arpt_entry *e, unsigned int *i)
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-	return 0;
 }
 
 /* Checks and translates the user-supplied table segment (held in
@@ -653,10 +644,10 @@ static int translate_table(const char *name,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
-		      entry0 + size, hook_entries, underflows,
-		      valid_hooks, &i);
+		      entry0 + size, hook_entries, underflows, valid_hooks);
 		if (ret != 0)
 			break;
+		++i;
 	}
 	duprintf("translate_table: ARPT_ENTRY_ITERATE gives %d\n", ret);
 	if (ret != 0)
@@ -693,15 +684,18 @@ static int translate_table(const char *name,
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, name, size, &i);
+		ret = find_check_entry(iter, name, size);
 		if (ret != 0)
 			break;
+		++i;
 	}
 
 	if (ret != 0) {
-		xt_entry_foreach(iter, entry0, newinfo->size)
-			if (cleanup_entry(iter, &i) != 0)
+		xt_entry_foreach(iter, entry0, newinfo->size) {
+			if (i-- == 0)
 				break;
+			cleanup_entry(iter);
+		}
 		return ret;
 	}
 
@@ -714,27 +708,6 @@ static int translate_table(const char *name,
 	return ret;
 }
 
-/* Gets counters. */
-static inline int add_entry_to_counter(const struct arpt_entry *e,
-				       struct xt_counters total[],
-				       unsigned int *i)
-{
-	ADD_COUNTER(total[*i], e->counters.bcnt, e->counters.pcnt);
-
-	(*i)++;
-	return 0;
-}
-
-static inline int set_entry_to_counter(const struct arpt_entry *e,
-				       struct xt_counters total[],
-				       unsigned int *i)
-{
-	SET_COUNTER(total[*i], e->counters.bcnt, e->counters.pcnt);
-
-	(*i)++;
-	return 0;
-}
-
 static void get_counters(const struct xt_table_info *t,
 			 struct xt_counters counters[])
 {
@@ -754,18 +727,22 @@ static void get_counters(const struct xt_table_info *t,
 	curcpu = smp_processor_id();
 
 	i = 0;
-	xt_entry_foreach(iter, t->entries[curcpu], t->size)
-		if (set_entry_to_counter(iter, counters, &i) != 0)
-			break;
+	xt_entry_foreach(iter, t->entries[curcpu], t->size) {
+		SET_COUNTER(counters[i], iter->counters.bcnt,
+			iter->counters.pcnt);
+		++i;
+	}
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 		i = 0;
 		xt_info_wrlock(cpu);
-		xt_entry_foreach(iter, t->entries[cpu], t->size)
-			if (add_entry_to_counter(iter, counters, &i) != 0)
-				break;
+		xt_entry_foreach(iter, t->entries[cpu], t->size) {
+			ADD_COUNTER(counters[i], iter->counters.bcnt,
+				iter->counters.pcnt);
+			++i;
+		}
 		xt_info_wrunlock(cpu);
 	}
 	local_bh_enable();
@@ -897,7 +874,7 @@ static int compat_table_info(const struct xt_table_info *info,
 {
 	struct arpt_entry *iter;
 	void *loc_cpu_entry;
-	int ret = 0;
+	int ret;
 
 	if (!newinfo || !info)
 		return -EINVAL;
@@ -909,9 +886,9 @@ static int compat_table_info(const struct xt_table_info *info,
 	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
 		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
 		if (ret != 0)
-			break;
+			return ret;
 	}
-	return ret;
+	return 0;
 }
 #endif
 
@@ -1071,8 +1048,7 @@ static int __do_replace(struct net *net, const char *name,
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
 	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
 
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
@@ -1135,26 +1111,12 @@ static int do_replace(struct net *net, const void __user *user,
 
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
 }
 
-/* We're lazy, and add to the first CPU; overflow works its fey magic
- * and everything is OK. */
-static int
-add_counter_to_entry(struct arpt_entry *e,
-		     const struct xt_counters addme[],
-		     unsigned int *i)
-{
-	ADD_COUNTER(e->counters, addme[*i].bcnt, addme[*i].pcnt);
-
-	(*i)++;
-	return 0;
-}
-
 static int do_add_counters(struct net *net, const void __user *user,
 			   unsigned int len, int compat)
 {
@@ -1227,9 +1189,10 @@ static int do_add_counters(struct net *net, const void __user *user,
 	curcpu = smp_processor_id();
 	loc_cpu_entry = private->entries[curcpu];
 	xt_info_wrlock(curcpu);
-	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		if (add_counter_to_entry(iter, paddc, &i) != 0)
-			break;
+	xt_entry_foreach(iter, loc_cpu_entry, private->size) {
+		ADD_COUNTER(iter->counters, paddc[i].bcnt, paddc[i].pcnt);
+		++i;
+	}
 	xt_info_wrunlock(curcpu);
  unlock_up_free:
 	local_bh_enable();
@@ -1242,17 +1205,12 @@ static int do_add_counters(struct net *net, const void __user *user,
 }
 
 #ifdef CONFIG_COMPAT
-static inline int
-compat_release_entry(struct compat_arpt_entry *e, unsigned int *i)
+static inline void compat_release_entry(struct compat_arpt_entry *e)
 {
 	struct arpt_entry_target *t;
 
-	if (i && (*i)-- == 0)
-		return 1;
-
 	t = compat_arpt_get_target(e);
 	module_put(t->u.kernel.target->me);
-	return 0;
 }
 
 static inline int
@@ -1263,7 +1221,6 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 				  const unsigned char *limit,
 				  const unsigned int *hook_entries,
 				  const unsigned int *underflows,
-				  unsigned int *i,
 				  const char *name)
 {
 	struct arpt_entry_target *t;
@@ -1323,8 +1280,6 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 	/* Clear counters and comefrom */
 	memset(&e->counters, 0, sizeof(e->counters));
 	e->comefrom = 0;
-
-	(*i)++;
 	return 0;
 
 release_target:
@@ -1368,19 +1323,6 @@ compat_copy_entry_from_user(struct compat_arpt_entry *e, void **dstptr,
 	return ret;
 }
 
-static inline int compat_check_entry(struct arpt_entry *e, const char *name,
-				     unsigned int *i)
-{
-	int ret;
-
-	ret = check_target(e, name);
-	if (ret)
-		return ret;
-
-	(*i)++;
-	return 0;
-}
-
 static int translate_compat_table(const char *name,
 				  unsigned int valid_hooks,
 				  struct xt_table_info **pinfo,
@@ -1416,12 +1358,11 @@ static int translate_compat_table(const char *name,
 	xt_entry_foreach(iter0, entry0, total_size) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
 		      entry0, entry0 + total_size, hook_entries, underflows,
-		      &j, name);
+		      name);
 		if (ret != 0)
-			break;
+			goto out_unlock;
+		++j;
 	}
-	if (ret != 0)
-		goto out_unlock;
 
 	ret = -EINVAL;
 	if (j != number) {
@@ -1477,9 +1418,10 @@ static int translate_compat_table(const char *name,
 
 	i = 0;
 	xt_entry_foreach(iter1, entry1, newinfo->size) {
-		ret = compat_check_entry(iter1, name, &i);
+		ret = check_target(iter1, name);
 		if (ret != 0)
 			break;
+		++i;
 	}
 	if (ret) {
 		/*
@@ -1492,12 +1434,15 @@ static int translate_compat_table(const char *name,
 		xt_entry_foreach(iter0, entry0, newinfo->size) {
 			if (skip-- > 0)
 				continue;
-			if (compat_release_entry(iter0, &j) != 0)
+			if (j-- == 0)
 				break;
+			compat_release_entry(iter0);
 		}
-		xt_entry_foreach(iter1, entry1, newinfo->size)
-			if (cleanup_entry(iter1, &i) != 0)
+		xt_entry_foreach(iter1, entry1, newinfo->size) {
+			if (i-- == 0)
 				break;
+			cleanup_entry(iter1);
+		}
 		xt_free_table_info(newinfo);
 		return ret;
 	}
@@ -1515,9 +1460,11 @@ static int translate_compat_table(const char *name,
 free_newinfo:
 	xt_free_table_info(newinfo);
 out:
-	xt_entry_foreach(iter0, entry0, total_size)
-		if (compat_release_entry(iter0, &j) != 0)
+	xt_entry_foreach(iter0, entry0, total_size) {
+		if (j-- == 0)
 			break;
+		compat_release_entry(iter0);
+	}
 	return ret;
 out_unlock:
 	xt_compat_flush_offsets(NFPROTO_ARP);
@@ -1583,8 +1530,7 @@ static int compat_do_replace(struct net *net, void __user *user,
 
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1618,7 +1564,7 @@ static int compat_do_arpt_set_ctl(struct sock *sk, int cmd, void __user *user,
 static int compat_copy_entry_to_user(struct arpt_entry *e, void __user **dstptr,
 				     compat_uint_t *size,
 				     struct xt_counters *counters,
-				     unsigned int *i)
+				     unsigned int i)
 {
 	struct arpt_entry_target *t;
 	struct compat_arpt_entry __user *ce;
@@ -1626,14 +1572,12 @@ static int compat_copy_entry_to_user(struct arpt_entry *e, void __user **dstptr,
 	compat_uint_t origsize;
 	int ret;
 
-	ret = -EFAULT;
 	origsize = *size;
 	ce = (struct compat_arpt_entry __user *)*dstptr;
-	if (copy_to_user(ce, e, sizeof(struct arpt_entry)))
-		goto out;
-
-	if (copy_to_user(&ce->counters, &counters[*i], sizeof(counters[*i])))
-		goto out;
+	if (copy_to_user(ce, e, sizeof(struct arpt_entry)) != 0 ||
+	    copy_to_user(&ce->counters, &counters[i],
+	    sizeof(counters[i])) != 0)
+		return -EFAULT;
 
 	*dstptr += sizeof(struct compat_arpt_entry);
 	*size -= sizeof(struct arpt_entry) - sizeof(struct compat_arpt_entry);
@@ -1643,18 +1587,12 @@ static int compat_copy_entry_to_user(struct arpt_entry *e, void __user **dstptr,
 	t = arpt_get_target(e);
 	ret = xt_compat_target_to_user(t, dstptr, size);
 	if (ret)
-		goto out;
-	ret = -EFAULT;
+		return ret;
 	next_offset = e->next_offset - (origsize - *size);
-	if (put_user(target_offset, &ce->target_offset))
-		goto out;
-	if (put_user(next_offset, &ce->next_offset))
-		goto out;
-
-	(*i)++;
+	if (put_user(target_offset, &ce->target_offset) != 0 ||
+	    put_user(next_offset, &ce->next_offset) != 0)
+		return -EFAULT;
 	return 0;
-out:
-	return ret;
 }
 
 static int compat_copy_entries_to_user(unsigned int total_size,
@@ -1680,7 +1618,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 	size = total_size;
 	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
 		ret = compat_copy_entry_to_user(iter, &pos,
-		      &size, counters, &i);
+		      &size, counters, i++);
 		if (ret != 0)
 			break;
 	}
@@ -1886,8 +1824,7 @@ void arpt_unregister_table(struct xt_table *table)
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index b902779..17c6ac7 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -669,8 +669,7 @@ static int check_target(struct ipt_entry *e, const char *name)
 }
 
 static int
-find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
-		 unsigned int *i)
+find_check_entry(struct ipt_entry *e, const char *name, unsigned int size)
 {
 	struct ipt_entry_target *t;
 	struct xt_target *target;
@@ -706,8 +705,6 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
 	ret = check_target(e, name);
 	if (ret)
 		goto err;
-
-	(*i)++;
 	return 0;
  err:
 	module_put(t->u.kernel.target->me);
@@ -738,8 +735,7 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 			   const unsigned char *limit,
 			   const unsigned int *hook_entries,
 			   const unsigned int *underflows,
-			   unsigned int valid_hooks,
-			   unsigned int *i)
+			   unsigned int valid_hooks)
 {
 	unsigned int h;
 
@@ -776,20 +772,15 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 	/* Clear counters and comefrom */
 	e->counters = ((struct xt_counters) { 0, 0 });
 	e->comefrom = 0;
-
-	(*i)++;
 	return 0;
 }
 
-static int
-cleanup_entry(struct ipt_entry *e, unsigned int *i)
+static void
+cleanup_entry(struct ipt_entry *e)
 {
 	struct xt_tgdtor_param par;
 	struct ipt_entry_target *t;
 
-	if (i && (*i)-- == 0)
-		return 1;
-
 	/* Cleanup all matches */
 	IPT_MATCH_ITERATE(e, cleanup_match, NULL);
 	t = ipt_get_target(e);
@@ -800,7 +791,6 @@ cleanup_entry(struct ipt_entry *e, unsigned int *i)
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-	return 0;
 }
 
 /* Checks and translates the user-supplied table segment (held in
@@ -833,13 +823,11 @@ translate_table(const char *name,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
-		      entry0 + size, hook_entries, underflows,
-		      valid_hooks, &i);
+		      entry0 + size, hook_entries, underflows, valid_hooks);
 		if (ret != 0)
-			break;
+			return ret;
+		++i;
 	}
-	if (ret != 0)
-		return ret;
 
 	if (i != number) {
 		duprintf("translate_table: %u not %u entries\n",
@@ -870,15 +858,18 @@ translate_table(const char *name,
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, name, size, &i);
+		ret = find_check_entry(iter, name, size);
 		if (ret != 0)
 			break;
+		++i;
 	}
 
 	if (ret != 0) {
-		xt_entry_foreach(iter, entry0, newinfo->size)
-			if (cleanup_entry(iter, &i) != 0)
+		xt_entry_foreach(iter, entry0, newinfo->size) {
+			if (i-- == 0)
 				break;
+			cleanup_entry(iter);
+		}
 		return ret;
 	}
 
@@ -891,29 +882,6 @@ translate_table(const char *name,
 	return ret;
 }
 
-/* Gets counters. */
-static inline int
-add_entry_to_counter(const struct ipt_entry *e,
-		     struct xt_counters total[],
-		     unsigned int *i)
-{
-	ADD_COUNTER(total[*i], e->counters.bcnt, e->counters.pcnt);
-
-	(*i)++;
-	return 0;
-}
-
-static inline int
-set_entry_to_counter(const struct ipt_entry *e,
-		     struct ipt_counters total[],
-		     unsigned int *i)
-{
-	SET_COUNTER(total[*i], e->counters.bcnt, e->counters.pcnt);
-
-	(*i)++;
-	return 0;
-}
-
 static void
 get_counters(const struct xt_table_info *t,
 	     struct xt_counters counters[])
@@ -934,18 +902,22 @@ get_counters(const struct xt_table_info *t,
 	curcpu = smp_processor_id();
 
 	i = 0;
-	xt_entry_foreach(iter, t->entries[curcpu], t->size)
-		if (set_entry_to_counter(iter, counters, &i) != 0)
-			break;
+	xt_entry_foreach(iter, t->entries[curcpu], t->size) {
+		SET_COUNTER(counters[i], iter->counters.bcnt,
+			iter->counters.pcnt);
+		++i;
+	}
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 		i = 0;
 		xt_info_wrlock(cpu);
-		xt_entry_foreach(iter, t->entries[cpu], t->size)
-			if (add_entry_to_counter(iter, counters, &i) != 0)
-				break;
+		xt_entry_foreach(iter, t->entries[cpu], t->size) {
+			ADD_COUNTER(counters[i], iter->counters.bcnt,
+				iter->counters.pcnt);
+			++i; /* macro does multi eval of i */
+		}
 		xt_info_wrunlock(cpu);
 	}
 	local_bh_enable();
@@ -1105,7 +1077,7 @@ static int compat_table_info(const struct xt_table_info *info,
 {
 	struct ipt_entry *iter;
 	void *loc_cpu_entry;
-	int ret = 0;
+	int ret;
 
 	if (!newinfo || !info)
 		return -EINVAL;
@@ -1117,9 +1089,9 @@ static int compat_table_info(const struct xt_table_info *info,
 	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
 		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
 		if (ret != 0)
-			break;
+			return ret;
 	}
-	return ret;
+	return 0;
 }
 #endif
 
@@ -1277,8 +1249,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
 	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
 
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
@@ -1341,26 +1312,12 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
 }
 
-/* We're lazy, and add to the first CPU; overflow works its fey magic
- * and everything is OK. */
-static int
-add_counter_to_entry(struct ipt_entry *e,
-		     const struct xt_counters addme[],
-		     unsigned int *i)
-{
-	ADD_COUNTER(e->counters, addme[*i].bcnt, addme[*i].pcnt);
-
-	(*i)++;
-	return 0;
-}
-
 static int
 do_add_counters(struct net *net, const void __user *user,
                 unsigned int len, int compat)
@@ -1434,9 +1391,10 @@ do_add_counters(struct net *net, const void __user *user,
 	curcpu = smp_processor_id();
 	loc_cpu_entry = private->entries[curcpu];
 	xt_info_wrlock(curcpu);
-	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		if (add_counter_to_entry(iter, paddc, &i) != 0)
-			break;
+	xt_entry_foreach(iter, loc_cpu_entry, private->size) {
+		ADD_COUNTER(iter->counters, paddc[i].bcnt, paddc[i].pcnt);
+		++i;
+	}
 	xt_info_wrunlock(curcpu);
  unlock_up_free:
 	local_bh_enable();
@@ -1464,7 +1422,7 @@ struct compat_ipt_replace {
 static int
 compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 			  unsigned int *size, struct xt_counters *counters,
-			  unsigned int *i)
+			  unsigned int i)
 {
 	struct ipt_entry_target *t;
 	struct compat_ipt_entry __user *ce;
@@ -1472,14 +1430,12 @@ compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 	compat_uint_t origsize;
 	int ret;
 
-	ret = -EFAULT;
 	origsize = *size;
 	ce = (struct compat_ipt_entry __user *)*dstptr;
-	if (copy_to_user(ce, e, sizeof(struct ipt_entry)))
-		goto out;
-
-	if (copy_to_user(&ce->counters, &counters[*i], sizeof(counters[*i])))
-		goto out;
+	if (copy_to_user(ce, e, sizeof(struct ipt_entry)) != 0 ||
+	    copy_to_user(&ce->counters, &counters[i],
+	    sizeof(counters[i])) != 0)
+		return -EFAULT;
 
 	*dstptr += sizeof(struct compat_ipt_entry);
 	*size -= sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
@@ -1487,22 +1443,16 @@ compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 	ret = IPT_MATCH_ITERATE(e, xt_compat_match_to_user, dstptr, size);
 	target_offset = e->target_offset - (origsize - *size);
 	if (ret)
-		goto out;
+		return ret;
 	t = ipt_get_target(e);
 	ret = xt_compat_target_to_user(t, dstptr, size);
 	if (ret)
-		goto out;
-	ret = -EFAULT;
+		return ret;
 	next_offset = e->next_offset - (origsize - *size);
-	if (put_user(target_offset, &ce->target_offset))
-		goto out;
-	if (put_user(next_offset, &ce->next_offset))
-		goto out;
-
-	(*i)++;
+	if (put_user(target_offset, &ce->target_offset) != 0 ||
+	    put_user(next_offset, &ce->next_offset) != 0)
+		return -EFAULT;
 	return 0;
-out:
-	return ret;
 }
 
 static int
@@ -1539,19 +1489,14 @@ compat_release_match(struct ipt_entry_match *m, unsigned int *i)
 	return 0;
 }
 
-static int
-compat_release_entry(struct compat_ipt_entry *e, unsigned int *i)
+static void compat_release_entry(struct compat_ipt_entry *e)
 {
 	struct ipt_entry_target *t;
 
-	if (i && (*i)-- == 0)
-		return 1;
-
 	/* Cleanup all matches */
 	COMPAT_IPT_MATCH_ITERATE(e, compat_release_match, NULL);
 	t = compat_ipt_get_target(e);
 	module_put(t->u.kernel.target->me);
-	return 0;
 }
 
 static int
@@ -1562,7 +1507,6 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 				  const unsigned char *limit,
 				  const unsigned int *hook_entries,
 				  const unsigned int *underflows,
-				  unsigned int *i,
 				  const char *name)
 {
 	struct ipt_entry_target *t;
@@ -1628,8 +1572,6 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	/* Clear counters and comefrom */
 	memset(&e->counters, 0, sizeof(e->counters));
 	e->comefrom = 0;
-
-	(*i)++;
 	return 0;
 
 out:
@@ -1679,8 +1621,7 @@ compat_copy_entry_from_user(struct compat_ipt_entry *e, void **dstptr,
 }
 
 static int
-compat_check_entry(struct ipt_entry *e, const char *name,
-				     unsigned int *i)
+compat_check_entry(struct ipt_entry *e, const char *name)
 {
 	struct xt_mtchk_param mtpar;
 	unsigned int j;
@@ -1698,8 +1639,6 @@ compat_check_entry(struct ipt_entry *e, const char *name,
 	ret = check_target(e, name);
 	if (ret)
 		goto cleanup_matches;
-
-	(*i)++;
 	return 0;
 
  cleanup_matches:
@@ -1723,7 +1662,7 @@ translate_compat_table(const char *name,
 	struct compat_ipt_entry *iter0;
 	struct ipt_entry *iter1;
 	unsigned int size;
-	int ret = 0;
+	int ret;
 
 	info = *pinfo;
 	entry0 = *pentry0;
@@ -1743,12 +1682,11 @@ translate_compat_table(const char *name,
 	xt_entry_foreach(iter0, entry0, total_size) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
 		      entry0, entry0 + total_size, hook_entries, underflows,
-		      &j, name);
+		      name);
 		if (ret != 0)
-			break;
+			goto out_unlock;
+		++j;
 	}
-	if (ret != 0)
-		goto out_unlock;
 
 	ret = -EINVAL;
 	if (j != number) {
@@ -1804,9 +1742,10 @@ translate_compat_table(const char *name,
 
 	i = 0;
 	xt_entry_foreach(iter1, entry1, newinfo->size) {
-		ret = compat_check_entry(iter1, name, &i);
+		ret = compat_check_entry(iter1, name);
 		if (ret != 0)
 			break;
+		++i;
 	}
 	if (ret) {
 		/*
@@ -1819,12 +1758,15 @@ translate_compat_table(const char *name,
 		xt_entry_foreach(iter0, entry0, newinfo->size) {
 			if (skip-- > 0)
 				continue;
-			if (compat_release_entry(iter0, &i) != 0)
+			if (j-- == 0)
 				break;
+			compat_release_entry(iter0);
 		}
-		xt_entry_foreach(iter1, entry1, newinfo->size)
-			if (cleanup_entry(iter1, &i) != 0)
+		xt_entry_foreach(iter1, entry1, newinfo->size) {
+			if (i-- == 0)
 				break;
+			cleanup_entry(iter1);
+		}
 		xt_free_table_info(newinfo);
 		return ret;
 	}
@@ -1842,9 +1784,11 @@ translate_compat_table(const char *name,
 free_newinfo:
 	xt_free_table_info(newinfo);
 out:
-	xt_entry_foreach(iter0, entry0, total_size)
-		if (compat_release_entry(iter0, &j) != 0)
+	xt_entry_foreach(iter0, entry0, total_size) {
+		if (j-- == 0)
 			break;
+		compat_release_entry(iter0);
+	}
 	return ret;
 out_unlock:
 	xt_compat_flush_offsets(AF_INET);
@@ -1899,8 +1843,7 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1964,7 +1907,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 	size = total_size;
 	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
 		ret = compat_copy_entry_to_user(iter, &pos,
-		      &size, counters, &i);
+		      &size, counters, i++);
 		if (ret != 0)
 			break;
 	}
@@ -2175,8 +2118,7 @@ void ipt_unregister_table(struct xt_table *table)
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 23d7519..9d666f3 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -700,8 +700,7 @@ static int check_target(struct ip6t_entry *e, const char *name)
 }
 
 static int
-find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
-		 unsigned int *i)
+find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size)
 {
 	struct ip6t_entry_target *t;
 	struct xt_target *target;
@@ -737,8 +736,6 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
 	ret = check_target(e, name);
 	if (ret)
 		goto err;
-
-	(*i)++;
 	return 0;
  err:
 	module_put(t->u.kernel.target->me);
@@ -769,8 +766,7 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 			   const unsigned char *limit,
 			   const unsigned int *hook_entries,
 			   const unsigned int *underflows,
-			   unsigned int valid_hooks,
-			   unsigned int *i)
+			   unsigned int valid_hooks)
 {
 	unsigned int h;
 
@@ -807,20 +803,14 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 	/* Clear counters and comefrom */
 	e->counters = ((struct xt_counters) { 0, 0 });
 	e->comefrom = 0;
-
-	(*i)++;
 	return 0;
 }
 
-static int
-cleanup_entry(struct ip6t_entry *e, unsigned int *i)
+static void cleanup_entry(struct ip6t_entry *e)
 {
 	struct xt_tgdtor_param par;
 	struct ip6t_entry_target *t;
 
-	if (i && (*i)-- == 0)
-		return 1;
-
 	/* Cleanup all matches */
 	IP6T_MATCH_ITERATE(e, cleanup_match, NULL);
 	t = ip6t_get_target(e);
@@ -831,7 +821,6 @@ cleanup_entry(struct ip6t_entry *e, unsigned int *i)
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-	return 0;
 }
 
 /* Checks and translates the user-supplied table segment (held in
@@ -864,13 +853,11 @@ translate_table(const char *name,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
-		      entry0 + size, hook_entries, underflows,
-		      valid_hooks, &i);
+		      entry0 + size, hook_entries, underflows, valid_hooks);
 		if (ret != 0)
-			break;
+			return ret;
+		++i;
 	}
-	if (ret != 0)
-		return ret;
 
 	if (i != number) {
 		duprintf("translate_table: %u not %u entries\n",
@@ -901,15 +888,18 @@ translate_table(const char *name,
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, name, size, &i);
+		ret = find_check_entry(iter, name, size);
 		if (ret != 0)
 			break;
+		++i;
 	}
 
 	if (ret != 0) {
-		xt_entry_foreach(iter, entry0, newinfo->size)
-			if (cleanup_entry(iter, &i) != 0)
+		xt_entry_foreach(iter, entry0, newinfo->size) {
+			if (i-- == 0)
 				break;
+			cleanup_entry(iter);
+		}
 		return ret;
 	}
 
@@ -922,29 +912,6 @@ translate_table(const char *name,
 	return ret;
 }
 
-/* Gets counters. */
-static inline int
-add_entry_to_counter(const struct ip6t_entry *e,
-		     struct xt_counters total[],
-		     unsigned int *i)
-{
-	ADD_COUNTER(total[*i], e->counters.bcnt, e->counters.pcnt);
-
-	(*i)++;
-	return 0;
-}
-
-static inline int
-set_entry_to_counter(const struct ip6t_entry *e,
-		     struct ip6t_counters total[],
-		     unsigned int *i)
-{
-	SET_COUNTER(total[*i], e->counters.bcnt, e->counters.pcnt);
-
-	(*i)++;
-	return 0;
-}
-
 static void
 get_counters(const struct xt_table_info *t,
 	     struct xt_counters counters[])
@@ -965,18 +932,22 @@ get_counters(const struct xt_table_info *t,
 	curcpu = smp_processor_id();
 
 	i = 0;
-	xt_entry_foreach(iter, t->entries[curcpu], t->size)
-		if (set_entry_to_counter(iter, counters, &i) != 0)
-			break;
+	xt_entry_foreach(iter, t->entries[curcpu], t->size) {
+		SET_COUNTER(counters[i], iter->counters.bcnt,
+			iter->counters.pcnt);
+		++i;
+	}
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == curcpu)
 			continue;
 		i = 0;
 		xt_info_wrlock(cpu);
-		xt_entry_foreach(iter, t->entries[cpu], t->size)
-			if (add_entry_to_counter(iter, counters, &i) != 0)
-				break;
+		xt_entry_foreach(iter, t->entries[cpu], t->size) {
+			ADD_COUNTER(counters[i], iter->counters.bcnt,
+				iter->counters.pcnt);
+			++i;
+		}
 		xt_info_wrunlock(cpu);
 	}
 	local_bh_enable();
@@ -1136,7 +1107,7 @@ static int compat_table_info(const struct xt_table_info *info,
 {
 	struct ip6t_entry *iter;
 	void *loc_cpu_entry;
-	int ret = 0;
+	int ret;
 
 	if (!newinfo || !info)
 		return -EINVAL;
@@ -1148,9 +1119,9 @@ static int compat_table_info(const struct xt_table_info *info,
 	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
 		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
 		if (ret != 0)
-			break;
+			return ret;
 	}
-	return ret;
+	return 0;
 }
 #endif
 
@@ -1309,8 +1280,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
 	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
 
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
@@ -1373,26 +1343,12 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
 }
 
-/* We're lazy, and add to the first CPU; overflow works its fey magic
- * and everything is OK. */
-static int
-add_counter_to_entry(struct ip6t_entry *e,
-		     const struct xt_counters addme[],
-		     unsigned int *i)
-{
-	ADD_COUNTER(e->counters, addme[*i].bcnt, addme[*i].pcnt);
-
-	(*i)++;
-	return 0;
-}
-
 static int
 do_add_counters(struct net *net, const void __user *user, unsigned int len,
 		int compat)
@@ -1467,9 +1423,10 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	curcpu = smp_processor_id();
 	xt_info_wrlock(curcpu);
 	loc_cpu_entry = private->entries[curcpu];
-	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		if (add_counter_to_entry(iter, paddc, &i) != 0)
-			break;
+	xt_entry_foreach(iter, loc_cpu_entry, private->size) {
+		ADD_COUNTER(iter->counters, paddc[i].bcnt, paddc[i].pcnt);
+		++i;
+	}
 	xt_info_wrunlock(curcpu);
 
  unlock_up_free:
@@ -1498,7 +1455,7 @@ struct compat_ip6t_replace {
 static int
 compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
 			  unsigned int *size, struct xt_counters *counters,
-			  unsigned int *i)
+			  unsigned int i)
 {
 	struct ip6t_entry_target *t;
 	struct compat_ip6t_entry __user *ce;
@@ -1506,14 +1463,12 @@ compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
 	compat_uint_t origsize;
 	int ret;
 
-	ret = -EFAULT;
 	origsize = *size;
 	ce = (struct compat_ip6t_entry __user *)*dstptr;
-	if (copy_to_user(ce, e, sizeof(struct ip6t_entry)))
-		goto out;
-
-	if (copy_to_user(&ce->counters, &counters[*i], sizeof(counters[*i])))
-		goto out;
+	if (copy_to_user(ce, e, sizeof(struct ip6t_entry)) != 0 ||
+	    copy_to_user(&ce->counters, &counters[i],
+	    sizeof(counters[i])) != 0)
+		return -EFAULT;
 
 	*dstptr += sizeof(struct compat_ip6t_entry);
 	*size -= sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
@@ -1521,22 +1476,16 @@ compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
 	ret = IP6T_MATCH_ITERATE(e, xt_compat_match_to_user, dstptr, size);
 	target_offset = e->target_offset - (origsize - *size);
 	if (ret)
-		goto out;
+		return ret;
 	t = ip6t_get_target(e);
 	ret = xt_compat_target_to_user(t, dstptr, size);
 	if (ret)
-		goto out;
-	ret = -EFAULT;
+		return ret;
 	next_offset = e->next_offset - (origsize - *size);
-	if (put_user(target_offset, &ce->target_offset))
-		goto out;
-	if (put_user(next_offset, &ce->next_offset))
-		goto out;
-
-	(*i)++;
+	if (put_user(target_offset, &ce->target_offset) != 0 ||
+	    put_user(next_offset, &ce->next_offset) != 0)
+		return -EFAULT;
 	return 0;
-out:
-	return ret;
 }
 
 static int
@@ -1573,19 +1522,14 @@ compat_release_match(struct ip6t_entry_match *m, unsigned int *i)
 	return 0;
 }
 
-static int
-compat_release_entry(struct compat_ip6t_entry *e, unsigned int *i)
+static void compat_release_entry(struct compat_ip6t_entry *e)
 {
 	struct ip6t_entry_target *t;
 
-	if (i && (*i)-- == 0)
-		return 1;
-
 	/* Cleanup all matches */
 	COMPAT_IP6T_MATCH_ITERATE(e, compat_release_match, NULL);
 	t = compat_ip6t_get_target(e);
 	module_put(t->u.kernel.target->me);
-	return 0;
 }
 
 static int
@@ -1596,7 +1540,6 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 				  const unsigned char *limit,
 				  const unsigned int *hook_entries,
 				  const unsigned int *underflows,
-				  unsigned int *i,
 				  const char *name)
 {
 	struct ip6t_entry_target *t;
@@ -1662,8 +1605,6 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 	/* Clear counters and comefrom */
 	memset(&e->counters, 0, sizeof(e->counters));
 	e->comefrom = 0;
-
-	(*i)++;
 	return 0;
 
 out:
@@ -1712,8 +1653,7 @@ compat_copy_entry_from_user(struct compat_ip6t_entry *e, void **dstptr,
 	return ret;
 }
 
-static int compat_check_entry(struct ip6t_entry *e, const char *name,
-				     unsigned int *i)
+static int compat_check_entry(struct ip6t_entry *e, const char *name)
 {
 	unsigned int j;
 	int ret;
@@ -1731,8 +1671,6 @@ static int compat_check_entry(struct ip6t_entry *e, const char *name,
 	ret = check_target(e, name);
 	if (ret)
 		goto cleanup_matches;
-
-	(*i)++;
 	return 0;
 
  cleanup_matches:
@@ -1776,12 +1714,11 @@ translate_compat_table(const char *name,
 	xt_entry_foreach(iter0, entry0, total_size) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
 		      entry0, entry0 + total_size, hook_entries, underflows,
-		      &j, name);
+		      name);
 		if (ret != 0)
-			break;
+			goto out_unlock;
+		++j;
 	}
-	if (ret != 0)
-		goto out_unlock;
 
 	ret = -EINVAL;
 	if (j != number) {
@@ -1837,9 +1774,10 @@ translate_compat_table(const char *name,
 
 	i = 0;
 	xt_entry_foreach(iter1, entry1, newinfo->size) {
-		ret = compat_check_entry(iter1, name, &i);
+		ret = compat_check_entry(iter1, name);
 		if (ret != 0)
 			break;
+		++i;
 	}
 	if (ret) {
 		/*
@@ -1852,12 +1790,15 @@ translate_compat_table(const char *name,
 		xt_entry_foreach(iter0, entry0, newinfo->size) {
 			if (skip-- > 0)
 				continue;
-			if (compat_release_entry(iter0, &j) != 0)
+			if (j-- == 0)
 				break;
+			compat_release_entry(iter0);
 		}
-		xt_entry_foreach(iter1, entry1, newinfo->size)
-			if (cleanup_entry(iter1, &i) != 0)
+		xt_entry_foreach(iter1, entry1, newinfo->size) {
+			if (i-- == 0)
 				break;
+			cleanup_entry(iter1);
+		}
 		xt_free_table_info(newinfo);
 		return ret;
 	}
@@ -1875,9 +1816,11 @@ translate_compat_table(const char *name,
 free_newinfo:
 	xt_free_table_info(newinfo);
 out:
-	xt_entry_foreach(iter0, entry0, total_size)
-		if (compat_release_entry(iter0, &j) != 0)
+	xt_entry_foreach(iter0, entry0, total_size) {
+		if (j-- == 0)
 			break;
+		compat_release_entry(iter0);
+	}
 	return ret;
 out_unlock:
 	xt_compat_flush_offsets(AF_INET6);
@@ -1932,8 +1875,7 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1997,7 +1939,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 	size = total_size;
 	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
 		ret = compat_copy_entry_to_user(iter, &pos,
-		      &size, counters, &i);
+		      &size, counters, i++);
 		if (ret != 0)
 			break;
 	}
@@ -2207,8 +2149,7 @@ void ip6t_unregister_table(struct xt_table *table)
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		if (cleanup_entry(iter, NULL) != 0)
-			break;
+		cleanup_entry(iter);
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
-- 
1.6.3.3

