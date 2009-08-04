From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 084/103] netfilter: ip6tables: remove unused functions (GET_ENTRIES)
Date: Tue,  4 Aug 2009 09:26:08 +0200
Message-ID: <1249370787-17583-85-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56958 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612AbZHDH2E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:04 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv6/netfilter/ip6_tables.c |  224 ---------------------------------------
 1 files changed, 0 insertions(+), 224 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 8535995..deb63f9 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -809,156 +809,6 @@ get_counters(const struct xt_table_info *t,
 	local_bh_enable();
 }
 
-static struct xt_counters *alloc_counters(const struct xt_table *table)
-{
-	unsigned int countersize;
-	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
-
-	/* We need atomic snapshot of counters: rest doesn't change
-	   (other than comefrom, which userspace doesn't care
-	   about). */
-	countersize = sizeof(struct xt_counters) * private->number;
-	counters = vmalloc_node(countersize, numa_node_id());
-
-	if (counters == NULL)
-		return ERR_PTR(-ENOMEM);
-
-	get_counters(private, counters);
-
-	return counters;
-}
-
-static int
-copy_entries_to_user(unsigned int total_size,
-		     const struct xt_table *table,
-		     void __user *userptr)
-{
-	unsigned int off, num;
-	const struct ip6t_entry *e;
-	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
-	int ret = 0;
-	const void *loc_cpu_entry;
-
-	counters = alloc_counters(table);
-	if (IS_ERR(counters))
-		return PTR_ERR(counters);
-
-	/* choose the copy that is on our node/cpu, ...
-	 * This choice is lazy (because current thread is
-	 * allowed to migrate to another cpu)
-	 */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
-	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
-		ret = -EFAULT;
-		goto free_counters;
-	}
-
-	/* FIXME: use iterator macros --RR */
-	/* ... then go back and fix counters and names */
-	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
-		unsigned int i;
-		const struct ip6t_entry_match *m;
-		const struct ip6t_entry_target *t;
-
-		e = (struct ip6t_entry *)(loc_cpu_entry + off);
-		if (copy_to_user(userptr + off
-				 + offsetof(struct ip6t_entry, counters),
-				 &counters[num],
-				 sizeof(counters[num])) != 0) {
-			ret = -EFAULT;
-			goto free_counters;
-		}
-
-		for (i = sizeof(struct ip6t_entry);
-		     i < e->target_offset;
-		     i += m->u.match_size) {
-			m = (void *)e + i;
-
-			if (copy_to_user(userptr + off + i
-					 + offsetof(struct ip6t_entry_match,
-						    u.user.name),
-					 m->u.kernel.match->name,
-					 strlen(m->u.kernel.match->name)+1)
-			    != 0) {
-				ret = -EFAULT;
-				goto free_counters;
-			}
-		}
-
-		t = ip6t_get_target_c(e);
-		if (copy_to_user(userptr + off + e->target_offset
-				 + offsetof(struct ip6t_entry_target,
-					    u.user.name),
-				 t->u.kernel.target->name,
-				 strlen(t->u.kernel.target->name)+1) != 0) {
-			ret = -EFAULT;
-			goto free_counters;
-		}
-	}
-
- free_counters:
-	vfree(counters);
-	return ret;
-}
-
-#ifdef CONFIG_COMPAT
-static int compat_calc_entry(const struct ip6t_entry *e,
-			     const struct xt_table_info *info,
-			     const void *base, struct xt_table_info *newinfo)
-{
-	const struct xt_entry_match *ematch;
-	const struct ip6t_entry_target *t;
-	unsigned int entry_offset;
-	int off, i, ret;
-
-	off = sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
-	entry_offset = (void *)e - base;
-	xt_ematch_foreach(ematch, e)
-		off += xt_compat_match_offset(ematch->u.kernel.match);
-
-	t = ip6t_get_target_c(e);
-	off += xt_compat_target_offset(t->u.kernel.target);
-	newinfo->size -= off;
-	ret = xt_compat_add_offset(AF_INET6, entry_offset, off);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
-		if (info->hook_entry[i] &&
-		    (e < (struct ip6t_entry *)(base + info->hook_entry[i])))
-			newinfo->hook_entry[i] -= off;
-		if (info->underflow[i] &&
-		    (e < (struct ip6t_entry *)(base + info->underflow[i])))
-			newinfo->underflow[i] -= off;
-	}
-	return 0;
-}
-
-static int compat_table_info(const struct xt_table_info *info,
-			     struct xt_table_info *newinfo)
-{
-	struct ip6t_entry *iter;
-	void *loc_cpu_entry;
-	int ret;
-
-	if (!newinfo || !info)
-		return -EINVAL;
-
-	/* we dont care about newinfo->entries[] */
-	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
-	newinfo->initial_entries = 0;
-	loc_cpu_entry = info->entries[raw_smp_processor_id()];
-	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
-		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
-		if (ret != 0)
-			return ret;
-	}
-	return 0;
-}
-#endif
-
 static const struct xt1_xlat_info ip6t_compat_xlat_info = {
 #ifdef CONFIG_COMPAT
 	.marker_size     = COMPAT_XT_ALIGN(sizeof(struct ip6t_error_target)),
@@ -1288,45 +1138,6 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 
 #ifdef CONFIG_COMPAT
 static int
-compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
-			  unsigned int *size, struct xt_counters *counters,
-			  unsigned int i)
-{
-	struct ip6t_entry_target *t;
-	struct compat_ip6t_entry __user *ce;
-	u_int16_t target_offset, next_offset;
-	compat_uint_t origsize;
-	const struct xt_entry_match *ematch;
-	int ret = 0;
-
-	origsize = *size;
-	ce = (struct compat_ip6t_entry __user *)*dstptr;
-	if (copy_to_user(ce, e, sizeof(struct ip6t_entry)) != 0 ||
-	    copy_to_user(&ce->counters, &counters[i],
-	    sizeof(counters[i])) != 0)
-		return -EFAULT;
-
-	*dstptr += sizeof(struct compat_ip6t_entry);
-	*size -= sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
-
-	xt_ematch_foreach(ematch, e) {
-		ret = xt_compat_match_to_user(ematch, dstptr, size);
-		if (ret != 0)
-			return ret;
-	}
-	target_offset = e->target_offset - (origsize - *size);
-	t = ip6t_get_target(e);
-	ret = xt_compat_target_to_user(t, dstptr, size);
-	if (ret)
-		return ret;
-	next_offset = e->next_offset - (origsize - *size);
-	if (put_user(target_offset, &ce->target_offset) != 0 ||
-	    put_user(next_offset, &ce->next_offset) != 0)
-		return -EFAULT;
-	return 0;
-}
-
-static int
 compat_find_calc_match(struct ip6t_entry_match *m,
 		       const char *name,
 		       const struct ip6t_ip6 *ipv6,
@@ -1768,41 +1579,6 @@ struct compat_ip6t_get_entries {
 };
 
 static int
-compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
-			    void __user *userptr)
-{
-	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
-	void __user *pos;
-	unsigned int size;
-	int ret = 0;
-	const void *loc_cpu_entry;
-	unsigned int i = 0;
-	struct ip6t_entry *iter;
-
-	counters = alloc_counters(table);
-	if (IS_ERR(counters))
-		return PTR_ERR(counters);
-
-	/* choose the copy that is on our node/cpu, ...
-	 * This choice is lazy (because current thread is
-	 * allowed to migrate to another cpu)
-	 */
-	loc_cpu_entry = private->entries[raw_smp_processor_id()];
-	pos = userptr;
-	size = total_size;
-	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
-		ret = compat_copy_entry_to_user(iter, &pos,
-		      &size, counters, i++);
-		if (ret != 0)
-			break;
-	}
-
-	vfree(counters);
-	return ret;
-}
-
-static int
 compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 		   int *len)
 {
-- 
1.6.3.3

