From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/64]: ip_tables: reformat compat code
Date: Tue, 18 Dec 2007 00:46:15 +0100 (MET)
Message-ID: <20071217234614.23601.84210.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38885 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbXLQXqQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:16 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip_tables: reformat compat code

The compat code has some very odd formating, clean it up before porting
it to ip6_tables.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4cf89c9646b142291b7623c94daa8e61ab1b4766
tree c8e3889a2dd35b2fddd4329b0da90fdc5913d666
parent 6a19ffcd0ec70582290ae8277c9f1ef8acdb3c0e
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:34 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:34 +0100

 net/ipv4/netfilter/ip_tables.c |  181 ++++++++++++++++++++--------------------
 1 files changed, 92 insertions(+), 89 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index a8f1a2a..7d24262 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -600,8 +600,8 @@ check_entry(struct ipt_entry *e, const char *name)
 }
 
 static inline int check_match(struct ipt_entry_match *m, const char *name,
-				const struct ipt_ip *ip, unsigned int hookmask,
-				unsigned int *i)
+			      const struct ipt_ip *ip,
+			      unsigned int hookmask, unsigned int *i)
 {
 	struct xt_match *match;
 	int ret;
@@ -624,10 +624,10 @@ static inline int check_match(struct ipt_entry_match *m, const char *name,
 
 static inline int
 find_check_match(struct ipt_entry_match *m,
-	    const char *name,
-	    const struct ipt_ip *ip,
-	    unsigned int hookmask,
-	    unsigned int *i)
+		 const char *name,
+		 const struct ipt_ip *ip,
+		 unsigned int hookmask,
+		 unsigned int *i)
 {
 	struct xt_match *match;
 	int ret;
@@ -663,8 +663,8 @@ static inline int check_target(struct ipt_entry *e, const char *name)
 			      name, e->comefrom, e->ip.proto,
 			      e->ip.invflags & IPT_INV_PROTO);
 	if (!ret && t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, target,
-						      t->data, e->comefrom)) {
+	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
+					       e->comefrom)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
@@ -674,7 +674,7 @@ static inline int check_target(struct ipt_entry *e, const char *name)
 
 static inline int
 find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
-	    unsigned int *i)
+		 unsigned int *i)
 {
 	struct ipt_entry_target *t;
 	struct xt_target *target;
@@ -687,14 +687,14 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
 
 	j = 0;
 	ret = IPT_MATCH_ITERATE(e, find_check_match, name, &e->ip,
-							e->comefrom, &j);
+				e->comefrom, &j);
 	if (ret != 0)
 		goto cleanup_matches;
 
 	t = ipt_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET,
-						     t->u.user.name,
-						     t->u.user.revision),
+							t->u.user.name,
+							t->u.user.revision),
 					 "ipt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
 		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
@@ -1020,7 +1020,7 @@ struct compat_delta {
 	short delta;
 };
 
-static struct compat_delta *compat_offsets = NULL;
+static struct compat_delta *compat_offsets;
 
 static int compat_add_offset(unsigned int offset, short delta)
 {
@@ -1046,7 +1046,7 @@ static void compat_flush_offsets(void)
 	struct compat_delta *tmp, *next;
 
 	if (compat_offsets) {
-		for(tmp = compat_offsets; tmp; tmp = next) {
+		for (tmp = compat_offsets; tmp; tmp = next) {
 			next = tmp->next;
 			kfree(tmp);
 		}
@@ -1059,7 +1059,7 @@ static short compat_calc_jump(unsigned int offset)
 	struct compat_delta *tmp;
 	short delta;
 
-	for(tmp = compat_offsets, delta = 0; tmp; tmp = tmp->next)
+	for (tmp = compat_offsets, delta = 0; tmp; tmp = tmp->next)
 		if (tmp->offset < offset)
 			delta += tmp->delta;
 	return delta;
@@ -1084,15 +1084,15 @@ static int compat_standard_to_user(void __user *dst, void *src)
 }
 
 static inline int
-compat_calc_match(struct ipt_entry_match *m, int * size)
+compat_calc_match(struct ipt_entry_match *m, int *size)
 {
 	*size += xt_compat_match_offset(m->u.kernel.match);
 	return 0;
 }
 
 static int compat_calc_entry(struct ipt_entry *e,
-		const struct xt_table_info *info,
-		void *base, struct xt_table_info *newinfo)
+			     const struct xt_table_info *info,
+			     void *base, struct xt_table_info *newinfo)
 {
 	struct ipt_entry_target *t;
 	unsigned int entry_offset;
@@ -1109,18 +1109,18 @@ static int compat_calc_entry(struct ipt_entry *e,
 		return ret;
 
 	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
-		if (info->hook_entry[i] && (e < (struct ipt_entry *)
-				(base + info->hook_entry[i])))
+		if (info->hook_entry[i] &&
+		    (e < (struct ipt_entry *)(base + info->hook_entry[i])))
 			newinfo->hook_entry[i] -= off;
-		if (info->underflow[i] && (e < (struct ipt_entry *)
-				(base + info->underflow[i])))
+		if (info->underflow[i] &&
+		    (e < (struct ipt_entry *)(base + info->underflow[i])))
 			newinfo->underflow[i] -= off;
 	}
 	return 0;
 }
 
 static int compat_table_info(const struct xt_table_info *info,
-		struct xt_table_info *newinfo)
+			     struct xt_table_info *newinfo)
 {
 	void *loc_cpu_entry;
 
@@ -1132,7 +1132,8 @@ static int compat_table_info(const struct xt_table_info *info,
 	newinfo->initial_entries = 0;
 	loc_cpu_entry = info->entries[raw_smp_processor_id()];
 	return IPT_ENTRY_ITERATE(loc_cpu_entry, info->size,
-			compat_calc_entry, info, loc_cpu_entry, newinfo);
+				 compat_calc_entry, info, loc_cpu_entry,
+				 newinfo);
 }
 #endif
 
@@ -1157,7 +1158,7 @@ static int get_info(void __user *user, int *len, int compat)
 		xt_compat_lock(AF_INET);
 #endif
 	t = try_then_request_module(xt_find_table_lock(AF_INET, name),
-			"iptable_%s", name);
+				    "iptable_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct ipt_getinfo info;
 		struct xt_table_info *private = t->private;
@@ -1167,14 +1168,14 @@ static int get_info(void __user *user, int *len, int compat)
 			struct xt_table_info tmp;
 			ret = compat_table_info(private, &tmp);
 			compat_flush_offsets();
-			private =  &tmp;
+			private = &tmp;
 		}
 #endif
 		info.valid_hooks = t->valid_hooks;
 		memcpy(info.hook_entry, private->hook_entry,
-				sizeof(info.hook_entry));
+		       sizeof(info.hook_entry));
 		memcpy(info.underflow, private->underflow,
-				sizeof(info.underflow));
+		       sizeof(info.underflow));
 		info.num_entries = private->number;
 		info.size = private->size;
 		strcpy(info.name, name);
@@ -1240,8 +1241,8 @@ get_entries(struct ipt_get_entries __user *uptr, int *len)
 
 static int
 __do_replace(const char *name, unsigned int valid_hooks,
-		struct xt_table_info *newinfo, unsigned int num_counters,
-		void __user *counters_ptr)
+	     struct xt_table_info *newinfo, unsigned int num_counters,
+	     void __user *counters_ptr)
 {
 	int ret;
 	struct xt_table *t;
@@ -1289,7 +1290,8 @@ __do_replace(const char *name, unsigned int valid_hooks,
 	get_counters(oldinfo, counters);
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
-	IPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,NULL);
+	IPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,
+			  NULL);
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
 			 sizeof(struct xt_counters) * num_counters) != 0)
@@ -1346,9 +1348,8 @@ do_replace(void __user *user, unsigned int len)
 
 	duprintf("ip_tables: Translated table\n");
 
-	ret = __do_replace(tmp.name, tmp.valid_hooks,
-			      newinfo, tmp.num_counters,
-			      tmp.counters);
+	ret = __do_replace(tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, tmp.counters);
 	if (ret)
 		goto free_newinfo_untrans;
 	return 0;
@@ -1523,19 +1524,19 @@ out:
 
 static inline int
 compat_find_calc_match(struct ipt_entry_match *m,
-	    const char *name,
-	    const struct ipt_ip *ip,
-	    unsigned int hookmask,
-	    int *size, int *i)
+		       const char *name,
+		       const struct ipt_ip *ip,
+		       unsigned int hookmask,
+		       int *size, int *i)
 {
 	struct xt_match *match;
 
 	match = try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
-						   m->u.user.revision),
+						      m->u.user.revision),
 					"ipt_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
 		duprintf("compat_check_calc_match: `%s' not found\n",
-				m->u.user.name);
+			 m->u.user.name);
 		return match ? PTR_ERR(match) : -ENOENT;
 	}
 	m->u.kernel.match = match;
@@ -1572,14 +1573,14 @@ compat_release_entry(struct ipt_entry *e, unsigned int *i)
 
 static inline int
 check_compat_entry_size_and_hooks(struct ipt_entry *e,
-			   struct xt_table_info *newinfo,
-			   unsigned int *size,
-			   unsigned char *base,
-			   unsigned char *limit,
-			   unsigned int *hook_entries,
-			   unsigned int *underflows,
-			   unsigned int *i,
-			   const char *name)
+				  struct xt_table_info *newinfo,
+				  unsigned int *size,
+				  unsigned char *base,
+				  unsigned char *limit,
+				  unsigned int *hook_entries,
+				  unsigned int *underflows,
+				  unsigned int *i,
+				  const char *name)
 {
 	struct ipt_entry_target *t;
 	struct xt_target *target;
@@ -1594,7 +1595,7 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 	}
 
 	if (e->next_offset < sizeof(struct compat_ipt_entry) +
-			sizeof(struct compat_xt_entry_target)) {
+			     sizeof(struct compat_xt_entry_target)) {
 		duprintf("checking: element %p size %u\n",
 			 e, e->next_offset);
 		return -EINVAL;
@@ -1608,18 +1609,18 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 	entry_offset = (void *)e - (void *)base;
 	j = 0;
 	ret = IPT_MATCH_ITERATE(e, compat_find_calc_match, name, &e->ip,
-			e->comefrom, &off, &j);
+				e->comefrom, &off, &j);
 	if (ret != 0)
 		goto release_matches;
 
 	t = ipt_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET,
-						     t->u.user.name,
-						     t->u.user.revision),
+							t->u.user.name,
+							t->u.user.revision),
 					 "ipt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
 		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
-							t->u.user.name);
+			 t->u.user.name);
 		ret = target ? PTR_ERR(target) : -ENOENT;
 		goto release_matches;
 	}
@@ -1653,17 +1654,20 @@ release_matches:
 	return ret;
 }
 
-static inline int compat_copy_match_from_user(struct ipt_entry_match *m,
-	void **dstptr, compat_uint_t *size, const char *name,
-	const struct ipt_ip *ip, unsigned int hookmask)
+static inline int
+compat_copy_match_from_user(struct ipt_entry_match *m,
+			    void **dstptr, compat_uint_t *size,
+			    const char *name, const struct ipt_ip *ip,
+			    unsigned int hookmask)
 {
 	xt_compat_match_from_user(m, dstptr, size);
 	return 0;
 }
 
-static int compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
-	unsigned int *size, const char *name,
-	struct xt_table_info *newinfo, unsigned char *base)
+static int
+compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
+			    unsigned int *size, const char *name,
+			    struct xt_table_info *newinfo, unsigned char *base)
 {
 	struct ipt_entry_target *t;
 	struct xt_target *target;
@@ -1678,7 +1682,7 @@ static int compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
 
 	*dstptr += sizeof(struct compat_ipt_entry);
 	ret = IPT_MATCH_ITERATE(e, compat_copy_match_from_user, dstptr, size,
-			name, &de->ip, de->comefrom);
+				name, &de->ip, de->comefrom);
 	if (ret)
 		return ret;
 	de->target_offset = e->target_offset - (origsize - *size);
@@ -1697,7 +1701,7 @@ static int compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
 }
 
 static inline int compat_check_entry(struct ipt_entry *e, const char *name,
-						unsigned int *i)
+				     unsigned int *i)
 {
 	int j, ret;
 
@@ -1720,13 +1724,13 @@ static inline int compat_check_entry(struct ipt_entry *e, const char *name,
 
 static int
 translate_compat_table(const char *name,
-		unsigned int valid_hooks,
-		struct xt_table_info **pinfo,
-		void **pentry0,
-		unsigned int total_size,
-		unsigned int number,
-		unsigned int *hook_entries,
-		unsigned int *underflows)
+		       unsigned int valid_hooks,
+		       struct xt_table_info **pinfo,
+		       void **pentry0,
+		       unsigned int total_size,
+		       unsigned int number,
+		       unsigned int *hook_entries,
+		       unsigned int *underflows)
 {
 	unsigned int i, j;
 	struct xt_table_info *newinfo, *info;
@@ -1793,10 +1797,10 @@ translate_compat_table(const char *name,
 	}
 	entry1 = newinfo->entries[raw_smp_processor_id()];
 	pos = entry1;
-	size =  total_size;
+	size = total_size;
 	ret = IPT_ENTRY_ITERATE(entry0, total_size,
-			compat_copy_entry_from_user, &pos, &size,
-			name, newinfo, entry1);
+				compat_copy_entry_from_user, &pos, &size,
+				name, newinfo, entry1);
 	compat_flush_offsets();
 	xt_compat_unlock(AF_INET);
 	if (ret)
@@ -1808,11 +1812,11 @@ translate_compat_table(const char *name,
 
 	i = 0;
 	ret = IPT_ENTRY_ITERATE(entry1, newinfo->size, compat_check_entry,
-								name, &i);
+				name, &i);
 	if (ret) {
 		j -= i;
 		IPT_ENTRY_ITERATE_CONTINUE(entry1, newinfo->size, i,
-						compat_release_entry, &j);
+					   compat_release_entry, &j);
 		IPT_ENTRY_ITERATE(entry1, newinfo->size, cleanup_entry, &i);
 		xt_free_table_info(newinfo);
 		return ret;
@@ -1873,22 +1877,22 @@ compat_do_replace(void __user *user, unsigned int len)
 	}
 
 	ret = translate_compat_table(tmp.name, tmp.valid_hooks,
-			      &newinfo, &loc_cpu_entry, tmp.size,
-			      tmp.num_entries, tmp.hook_entry, tmp.underflow);
+				     &newinfo, &loc_cpu_entry, tmp.size,
+				     tmp.num_entries, tmp.hook_entry,
+				     tmp.underflow);
 	if (ret != 0)
 		goto free_newinfo;
 
 	duprintf("compat_do_replace: Translated table\n");
 
-	ret = __do_replace(tmp.name, tmp.valid_hooks,
-			      newinfo, tmp.num_counters,
-			      compat_ptr(tmp.counters));
+	ret = __do_replace(tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, compat_ptr(tmp.counters));
 	if (ret)
 		goto free_newinfo_untrans;
 	return 0;
 
  free_newinfo_untrans:
-	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry,NULL);
+	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1896,7 +1900,7 @@ compat_do_replace(void __user *user, unsigned int len)
 
 static int
 compat_do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user,
-		unsigned int len)
+		      unsigned int len)
 {
 	int ret;
 
@@ -1920,15 +1924,15 @@ compat_do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user,
 	return ret;
 }
 
-struct compat_ipt_get_entries
-{
+struct compat_ipt_get_entries {
 	char name[IPT_TABLE_MAXNAMELEN];
 	compat_uint_t size;
 	struct compat_ipt_entry entrytable[0];
 };
 
-static int compat_copy_entries_to_user(unsigned int total_size,
-		     struct xt_table *table, void __user *userptr)
+static int
+compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
+			    void __user *userptr)
 {
 	struct xt_counters *counters;
 	struct xt_table_info *private = table->private;
@@ -1964,10 +1968,9 @@ compat_get_entries(struct compat_ipt_get_entries __user *uptr, int *len)
 	struct compat_ipt_get_entries get;
 	struct xt_table *t;
 
-
 	if (*len < sizeof(get)) {
 		duprintf("compat_get_entries: %u < %u\n",
-				*len, (unsigned int)sizeof(get));
+			 *len, (unsigned int)sizeof(get));
 		return -EINVAL;
 	}
 
@@ -1976,8 +1979,8 @@ compat_get_entries(struct compat_ipt_get_entries __user *uptr, int *len)
 
 	if (*len != sizeof(struct compat_ipt_get_entries) + get.size) {
 		duprintf("compat_get_entries: %u != %u\n", *len,
-			(unsigned int)(sizeof(struct compat_ipt_get_entries) +
-			get.size));
+			 (unsigned int)(sizeof(struct compat_ipt_get_entries) +
+			 get.size));
 		return -EINVAL;
 	}
 
@@ -1991,7 +1994,7 @@ compat_get_entries(struct compat_ipt_get_entries __user *uptr, int *len)
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size) {
 			ret = compat_copy_entries_to_user(private->size,
-						   t, uptr->entrytable);
+							  t, uptr->entrytable);
 		} else if (!ret) {
 			duprintf("compat_get_entries: I've got %u not %u!\n",
 				 private->size,
