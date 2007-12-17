From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 32/64]: arp_tables: add compat support
Date: Tue, 18 Dec 2007 00:46:56 +0100 (MET)
Message-ID: <20071217234656.23601.94041.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38975 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969AbXLQXq6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:58 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: arp_tables: add compat support

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0e08f9705361e4b662dad414c2c4a20c30f92d31
tree 411ce7f0128fff3d0f96a69ced434a4277e490fc
parent 283dfad814dcb078afba8a6048feb4701d78bdfc
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:16 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:56 +0100

 include/linux/netfilter_arp/arp_tables.h |   31 +
 net/ipv4/netfilter/arp_tables.c          |  748 ++++++++++++++++++++++++++++--
 2 files changed, 721 insertions(+), 58 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 7ade26b..53dd4df 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -281,5 +281,36 @@ extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  struct arpt_table *table);
 
 #define ARPT_ALIGN(s) XT_ALIGN(s)
+
+#ifdef CONFIG_COMPAT
+#include <net/compat.h>
+
+struct compat_arpt_entry
+{
+	struct arpt_arp arp;
+	u_int16_t target_offset;
+	u_int16_t next_offset;
+	compat_uint_t comefrom;
+	struct compat_xt_counters counters;
+	unsigned char elems[0];
+};
+
+static inline struct arpt_entry_target *
+compat_arpt_get_target(struct compat_arpt_entry *e)
+{
+	return (void *)e + e->target_offset;
+}
+
+#define COMPAT_ARPT_ALIGN(s)	COMPAT_XT_ALIGN(s)
+
+/* fn returns 0 to continue iteration */
+#define COMPAT_ARPT_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct compat_arpt_entry, entries, size, fn, ## args)
+
+#define COMPAT_ARPT_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
+	XT_ENTRY_ITERATE_CONTINUE(struct compat_arpt_entry, entries, size, n, \
+				  fn, ## args)
+
+#endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _ARPTABLES_H */
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 029df76..ad2da6d 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -19,9 +19,10 @@
 #include <linux/proc_fs.h>
 #include <linux/module.h>
 #include <linux/init.h>
-
-#include <asm/uaccess.h>
 #include <linux/mutex.h>
+#include <linux/err.h>
+#include <net/compat.h>
+#include <asm/uaccess.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_arp/arp_tables.h>
@@ -782,7 +783,73 @@ static int copy_entries_to_user(unsigned int total_size,
 	return ret;
 }
 
-static int get_info(void __user *user, int *len)
+#ifdef CONFIG_COMPAT
+static void compat_standard_from_user(void *dst, void *src)
+{
+	int v = *(compat_int_t *)src;
+
+	if (v > 0)
+		v += xt_compat_calc_jump(NF_ARP, v);
+	memcpy(dst, &v, sizeof(v));
+}
+
+static int compat_standard_to_user(void __user *dst, void *src)
+{
+	compat_int_t cv = *(int *)src;
+
+	if (cv > 0)
+		cv -= xt_compat_calc_jump(NF_ARP, cv);
+	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
+}
+
+static int compat_calc_entry(struct arpt_entry *e,
+			     const struct xt_table_info *info,
+			     void *base, struct xt_table_info *newinfo)
+{
+	struct arpt_entry_target *t;
+	unsigned int entry_offset;
+	int off, i, ret;
+
+	off = sizeof(struct arpt_entry) - sizeof(struct compat_arpt_entry);
+	entry_offset = (void *)e - base;
+
+	t = arpt_get_target(e);
+	off += xt_compat_target_offset(t->u.kernel.target);
+	newinfo->size -= off;
+	ret = xt_compat_add_offset(NF_ARP, entry_offset, off);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
+		if (info->hook_entry[i] &&
+		    (e < (struct arpt_entry *)(base + info->hook_entry[i])))
+			newinfo->hook_entry[i] -= off;
+		if (info->underflow[i] &&
+		    (e < (struct arpt_entry *)(base + info->underflow[i])))
+			newinfo->underflow[i] -= off;
+	}
+	return 0;
+}
+
+static int compat_table_info(const struct xt_table_info *info,
+			     struct xt_table_info *newinfo)
+{
+	void *loc_cpu_entry;
+
+	if (!newinfo || !info)
+		return -EINVAL;
+
+	/* we dont care about newinfo->entries[] */
+	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
+	newinfo->initial_entries = 0;
+	loc_cpu_entry = info->entries[raw_smp_processor_id()];
+	return ARPT_ENTRY_ITERATE(loc_cpu_entry, info->size,
+				  compat_calc_entry, info, loc_cpu_entry,
+				  newinfo);
+}
+#endif
+
+static int get_info(void __user *user, int *len, int compat)
 {
 	char name[ARPT_TABLE_MAXNAMELEN];
 	struct arpt_table *t;
@@ -798,13 +865,24 @@ static int get_info(void __user *user, int *len)
 		return -EFAULT;
 
 	name[ARPT_TABLE_MAXNAMELEN-1] = '\0';
-
+#ifdef CONFIG_COMPAT
+	if (compat)
+		xt_compat_lock(NF_ARP);
+#endif
 	t = try_then_request_module(xt_find_table_lock(NF_ARP, name),
 				    "arptable_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct arpt_getinfo info;
 		struct xt_table_info *private = t->private;
 
+#ifdef CONFIG_COMPAT
+		if (compat) {
+			struct xt_table_info tmp;
+			ret = compat_table_info(private, &tmp);
+			xt_compat_flush_offsets(NF_ARP);
+			private = &tmp;
+		}
+#endif
 		info.valid_hooks = t->valid_hooks;
 		memcpy(info.hook_entry, private->hook_entry,
 		       sizeof(info.hook_entry));
@@ -822,6 +900,10 @@ static int get_info(void __user *user, int *len)
 		module_put(t->me);
 	} else
 		ret = t ? PTR_ERR(t) : -ENOENT;
+#ifdef CONFIG_COMPAT
+	if (compat)
+		xt_compat_unlock(NF_ARP);
+#endif
 	return ret;
 }
 
@@ -864,65 +946,41 @@ static int get_entries(struct arpt_get_entries __user *uptr, int *len)
 	return ret;
 }
 
-static int do_replace(void __user *user, unsigned int len)
+static int __do_replace(const char *name, unsigned int valid_hooks,
+			struct xt_table_info *newinfo,
+			unsigned int num_counters,
+			void __user *counters_ptr)
 {
 	int ret;
-	struct arpt_replace tmp;
 	struct arpt_table *t;
-	struct xt_table_info *newinfo, *oldinfo;
+	struct xt_table_info *oldinfo;
 	struct xt_counters *counters;
-	void *loc_cpu_entry, *loc_cpu_old_entry;
-
-	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
-		return -EFAULT;
-
-	/* overflow check */
-	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
-		return -ENOMEM;
-
-	newinfo = xt_alloc_table_info(tmp.size);
-	if (!newinfo)
-		return -ENOMEM;
+	void *loc_cpu_old_entry;
 
-	/* choose the copy that is on our node/cpu */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
-	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
-			   tmp.size) != 0) {
-		ret = -EFAULT;
-		goto free_newinfo;
-	}
-
-	counters = vmalloc_node(tmp.num_counters * sizeof(struct xt_counters),
+	ret = 0;
+	counters = vmalloc_node(num_counters * sizeof(struct xt_counters),
 				numa_node_id());
 	if (!counters) {
 		ret = -ENOMEM;
-		goto free_newinfo;
+		goto out;
 	}
 
-	ret = translate_table(tmp.name, tmp.valid_hooks,
-			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
-			      tmp.hook_entry, tmp.underflow);
-	if (ret != 0)
-		goto free_newinfo_counters;
-
-	duprintf("arp_tables: Translated table\n");
-
-	t = try_then_request_module(xt_find_table_lock(NF_ARP, tmp.name),
-				    "arptable_%s", tmp.name);
+	t = try_then_request_module(xt_find_table_lock(NF_ARP, name),
+				    "arptable_%s", name);
 	if (!t || IS_ERR(t)) {
 		ret = t ? PTR_ERR(t) : -ENOENT;
 		goto free_newinfo_counters_untrans;
 	}
 
 	/* You lied! */
-	if (tmp.valid_hooks != t->valid_hooks) {
+	if (valid_hooks != t->valid_hooks) {
 		duprintf("Valid hook crap: %08X vs %08X\n",
-			 tmp.valid_hooks, t->valid_hooks);
+			 valid_hooks, t->valid_hooks);
 		ret = -EINVAL;
 		goto put_module;
 	}
 
-	oldinfo = xt_replace_table(t, tmp.num_counters, newinfo, &ret);
+	oldinfo = xt_replace_table(t, num_counters, newinfo, &ret);
 	if (!oldinfo)
 		goto put_module;
 
@@ -940,11 +998,12 @@ static int do_replace(void __user *user, unsigned int len)
 	get_counters(oldinfo, counters);
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
-	ARPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,NULL);
+	ARPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,
+			   NULL);
 
 	xt_free_table_info(oldinfo);
-	if (copy_to_user(tmp.counters, counters,
-			 sizeof(struct xt_counters) * tmp.num_counters) != 0)
+	if (copy_to_user(counters_ptr, counters,
+			 sizeof(struct xt_counters) * num_counters) != 0)
 		ret = -EFAULT;
 	vfree(counters);
 	xt_table_unlock(t);
@@ -954,9 +1013,53 @@ static int do_replace(void __user *user, unsigned int len)
 	module_put(t->me);
 	xt_table_unlock(t);
  free_newinfo_counters_untrans:
-	ARPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
- free_newinfo_counters:
 	vfree(counters);
+ out:
+	return ret;
+}
+
+static int do_replace(void __user *user, unsigned int len)
+{
+	int ret;
+	struct arpt_replace tmp;
+	struct xt_table_info *newinfo;
+	void *loc_cpu_entry;
+
+	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
+		return -EFAULT;
+
+	/* overflow check */
+	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
+		return -ENOMEM;
+
+	newinfo = xt_alloc_table_info(tmp.size);
+	if (!newinfo)
+		return -ENOMEM;
+
+	/* choose the copy that is on our node/cpu */
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
+			   tmp.size) != 0) {
+		ret = -EFAULT;
+		goto free_newinfo;
+	}
+
+	ret = translate_table(tmp.name, tmp.valid_hooks,
+			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
+			      tmp.hook_entry, tmp.underflow);
+	if (ret != 0)
+		goto free_newinfo;
+
+	duprintf("arp_tables: Translated table\n");
+
+	ret = __do_replace(tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, tmp.counters);
+	if (ret)
+		goto free_newinfo_untrans;
+	return 0;
+
+ free_newinfo_untrans:
+	ARPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -976,31 +1079,59 @@ static inline int add_counter_to_entry(struct arpt_entry *e,
 	return 0;
 }
 
-static int do_add_counters(void __user *user, unsigned int len)
+static int do_add_counters(void __user *user, unsigned int len, int compat)
 {
 	unsigned int i;
-	struct xt_counters_info tmp, *paddc;
+	struct xt_counters_info tmp;
+	struct xt_counters *paddc;
+	unsigned int num_counters;
+	char *name;
+	int size;
+	void *ptmp;
 	struct arpt_table *t;
 	struct xt_table_info *private;
 	int ret = 0;
 	void *loc_cpu_entry;
+#ifdef CONFIG_COMPAT
+	struct compat_xt_counters_info compat_tmp;
 
-	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
+	if (compat) {
+		ptmp = &compat_tmp;
+		size = sizeof(struct compat_xt_counters_info);
+	} else
+#endif
+	{
+		ptmp = &tmp;
+		size = sizeof(struct xt_counters_info);
+	}
+
+	if (copy_from_user(ptmp, user, size) != 0)
 		return -EFAULT;
 
-	if (len != sizeof(tmp) + tmp.num_counters*sizeof(struct xt_counters))
+#ifdef CONFIG_COMPAT
+	if (compat) {
+		num_counters = compat_tmp.num_counters;
+		name = compat_tmp.name;
+	} else
+#endif
+	{
+		num_counters = tmp.num_counters;
+		name = tmp.name;
+	}
+
+	if (len != size + num_counters * sizeof(struct xt_counters))
 		return -EINVAL;
 
-	paddc = vmalloc_node(len, numa_node_id());
+	paddc = vmalloc_node(len - size, numa_node_id());
 	if (!paddc)
 		return -ENOMEM;
 
-	if (copy_from_user(paddc, user, len) != 0) {
+	if (copy_from_user(paddc, user + size, len - size) != 0) {
 		ret = -EFAULT;
 		goto free;
 	}
 
-	t = xt_find_table_lock(NF_ARP, tmp.name);
+	t = xt_find_table_lock(NF_ARP, name);
 	if (!t || IS_ERR(t)) {
 		ret = t ? PTR_ERR(t) : -ENOENT;
 		goto free;
@@ -1008,7 +1139,7 @@ static int do_add_counters(void __user *user, unsigned int len)
 
 	write_lock_bh(&t->lock);
 	private = t->private;
-	if (private->number != tmp.num_counters) {
+	if (private->number != num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
 	}
@@ -1019,7 +1150,7 @@ static int do_add_counters(void __user *user, unsigned int len)
 	ARPT_ENTRY_ITERATE(loc_cpu_entry,
 			   private->size,
 			   add_counter_to_entry,
-			   paddc->counters,
+			   paddc,
 			   &i);
  unlock_up_free:
 	write_unlock_bh(&t->lock);
@@ -1031,6 +1162,496 @@ static int do_add_counters(void __user *user, unsigned int len)
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+static inline int
+compat_release_entry(struct compat_arpt_entry *e, unsigned int *i)
+{
+	struct arpt_entry_target *t;
+
+	if (i && (*i)-- == 0)
+		return 1;
+
+	t = compat_arpt_get_target(e);
+	module_put(t->u.kernel.target->me);
+	return 0;
+}
+
+static inline int
+check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
+				  struct xt_table_info *newinfo,
+				  unsigned int *size,
+				  unsigned char *base,
+				  unsigned char *limit,
+				  unsigned int *hook_entries,
+				  unsigned int *underflows,
+				  unsigned int *i,
+				  const char *name)
+{
+	struct arpt_entry_target *t;
+	struct xt_target *target;
+	unsigned int entry_offset;
+	int ret, off, h;
+
+	duprintf("check_compat_entry_size_and_hooks %p\n", e);
+	if ((unsigned long)e % __alignof__(struct compat_arpt_entry) != 0
+	    || (unsigned char *)e + sizeof(struct compat_arpt_entry) >= limit) {
+		duprintf("Bad offset %p, limit = %p\n", e, limit);
+		return -EINVAL;
+	}
+
+	if (e->next_offset < sizeof(struct compat_arpt_entry) +
+			     sizeof(struct compat_xt_entry_target)) {
+		duprintf("checking: element %p size %u\n",
+			 e, e->next_offset);
+		return -EINVAL;
+	}
+
+	/* For purposes of check_entry casting the compat entry is fine */
+	ret = check_entry((struct arpt_entry *)e, name);
+	if (ret)
+		return ret;
+
+	off = sizeof(struct arpt_entry) - sizeof(struct compat_arpt_entry);
+	entry_offset = (void *)e - (void *)base;
+
+	t = compat_arpt_get_target(e);
+	target = try_then_request_module(xt_find_target(NF_ARP,
+							t->u.user.name,
+							t->u.user.revision),
+					 "arpt_%s", t->u.user.name);
+	if (IS_ERR(target) || !target) {
+		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
+			 t->u.user.name);
+		ret = target ? PTR_ERR(target) : -ENOENT;
+		goto out;
+	}
+	t->u.kernel.target = target;
+
+	off += xt_compat_target_offset(target);
+	*size += off;
+	ret = xt_compat_add_offset(NF_ARP, entry_offset, off);
+	if (ret)
+		goto release_target;
+
+	/* Check hooks & underflows */
+	for (h = 0; h < NF_ARP_NUMHOOKS; h++) {
+		if ((unsigned char *)e - base == hook_entries[h])
+			newinfo->hook_entry[h] = hook_entries[h];
+		if ((unsigned char *)e - base == underflows[h])
+			newinfo->underflow[h] = underflows[h];
+	}
+
+	/* Clear counters and comefrom */
+	memset(&e->counters, 0, sizeof(e->counters));
+	e->comefrom = 0;
+
+	(*i)++;
+	return 0;
+
+release_target:
+	module_put(t->u.kernel.target->me);
+out:
+	return ret;
+}
+
+static int
+compat_copy_entry_from_user(struct compat_arpt_entry *e, void **dstptr,
+			    unsigned int *size, const char *name,
+			    struct xt_table_info *newinfo, unsigned char *base)
+{
+	struct arpt_entry_target *t;
+	struct xt_target *target;
+	struct arpt_entry *de;
+	unsigned int origsize;
+	int ret, h;
+
+	ret = 0;
+	origsize = *size;
+	de = (struct arpt_entry *)*dstptr;
+	memcpy(de, e, sizeof(struct arpt_entry));
+	memcpy(&de->counters, &e->counters, sizeof(e->counters));
+
+	*dstptr += sizeof(struct arpt_entry);
+	*size += sizeof(struct arpt_entry) - sizeof(struct compat_arpt_entry);
+
+	de->target_offset = e->target_offset - (origsize - *size);
+	t = compat_arpt_get_target(e);
+	target = t->u.kernel.target;
+	xt_compat_target_from_user(t, dstptr, size);
+
+	de->next_offset = e->next_offset - (origsize - *size);
+	for (h = 0; h < NF_ARP_NUMHOOKS; h++) {
+		if ((unsigned char *)de - base < newinfo->hook_entry[h])
+			newinfo->hook_entry[h] -= origsize - *size;
+		if ((unsigned char *)de - base < newinfo->underflow[h])
+			newinfo->underflow[h] -= origsize - *size;
+	}
+	return ret;
+}
+
+static inline int compat_check_entry(struct arpt_entry *e, const char *name,
+				     unsigned int *i)
+{
+	int ret;
+
+	ret = check_target(e, name);
+	if (ret)
+		return ret;
+
+	(*i)++;
+	return 0;
+}
+
+static int translate_compat_table(const char *name,
+				  unsigned int valid_hooks,
+				  struct xt_table_info **pinfo,
+				  void **pentry0,
+				  unsigned int total_size,
+				  unsigned int number,
+				  unsigned int *hook_entries,
+				  unsigned int *underflows)
+{
+	unsigned int i, j;
+	struct xt_table_info *newinfo, *info;
+	void *pos, *entry0, *entry1;
+	unsigned int size;
+	int ret;
+
+	info = *pinfo;
+	entry0 = *pentry0;
+	size = total_size;
+	info->number = number;
+
+	/* Init all hooks to impossible value. */
+	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
+		info->hook_entry[i] = 0xFFFFFFFF;
+		info->underflow[i] = 0xFFFFFFFF;
+	}
+
+	duprintf("translate_compat_table: size %u\n", info->size);
+	j = 0;
+	xt_compat_lock(NF_ARP);
+	/* Walk through entries, checking offsets. */
+	ret = COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size,
+					check_compat_entry_size_and_hooks,
+					info, &size, entry0,
+					entry0 + total_size,
+					hook_entries, underflows, &j, name);
+	if (ret != 0)
+		goto out_unlock;
+
+	ret = -EINVAL;
+	if (j != number) {
+		duprintf("translate_compat_table: %u not %u entries\n",
+			 j, number);
+		goto out_unlock;
+	}
+
+	/* Check hooks all assigned */
+	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
+		/* Only hooks which are valid */
+		if (!(valid_hooks & (1 << i)))
+			continue;
+		if (info->hook_entry[i] == 0xFFFFFFFF) {
+			duprintf("Invalid hook entry %u %u\n",
+				 i, hook_entries[i]);
+			goto out_unlock;
+		}
+		if (info->underflow[i] == 0xFFFFFFFF) {
+			duprintf("Invalid underflow %u %u\n",
+				 i, underflows[i]);
+			goto out_unlock;
+		}
+	}
+
+	ret = -ENOMEM;
+	newinfo = xt_alloc_table_info(size);
+	if (!newinfo)
+		goto out_unlock;
+
+	newinfo->number = number;
+	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
+		newinfo->hook_entry[i] = info->hook_entry[i];
+		newinfo->underflow[i] = info->underflow[i];
+	}
+	entry1 = newinfo->entries[raw_smp_processor_id()];
+	pos = entry1;
+	size = total_size;
+	ret = COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size,
+					compat_copy_entry_from_user,
+					&pos, &size, name, newinfo, entry1);
+	xt_compat_flush_offsets(NF_ARP);
+	xt_compat_unlock(NF_ARP);
+	if (ret)
+		goto free_newinfo;
+
+	ret = -ELOOP;
+	if (!mark_source_chains(newinfo, valid_hooks, entry1))
+		goto free_newinfo;
+
+	i = 0;
+	ret = ARPT_ENTRY_ITERATE(entry1, newinfo->size, compat_check_entry,
+				 name, &i);
+	if (ret) {
+		j -= i;
+		COMPAT_ARPT_ENTRY_ITERATE_CONTINUE(entry0, newinfo->size, i,
+						   compat_release_entry, &j);
+		ARPT_ENTRY_ITERATE(entry1, newinfo->size, cleanup_entry, &i);
+		xt_free_table_info(newinfo);
+		return ret;
+	}
+
+	/* And one copy for every other CPU */
+	for_each_possible_cpu(i)
+		if (newinfo->entries[i] && newinfo->entries[i] != entry1)
+			memcpy(newinfo->entries[i], entry1, newinfo->size);
+
+	*pinfo = newinfo;
+	*pentry0 = entry1;
+	xt_free_table_info(info);
+	return 0;
+
+free_newinfo:
+	xt_free_table_info(newinfo);
+out:
+	COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
+	return ret;
+out_unlock:
+	xt_compat_flush_offsets(NF_ARP);
+	xt_compat_unlock(NF_ARP);
+	goto out;
+}
+
+struct compat_arpt_replace {
+	char				name[ARPT_TABLE_MAXNAMELEN];
+	u32				valid_hooks;
+	u32				num_entries;
+	u32				size;
+	u32				hook_entry[NF_ARP_NUMHOOKS];
+	u32				underflow[NF_ARP_NUMHOOKS];
+	u32				num_counters;
+	compat_uptr_t			counters;
+	struct compat_arpt_entry	entries[0];
+};
+
+static int compat_do_replace(void __user *user, unsigned int len)
+{
+	int ret;
+	struct compat_arpt_replace tmp;
+	struct xt_table_info *newinfo;
+	void *loc_cpu_entry;
+
+	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
+		return -EFAULT;
+
+	/* overflow check */
+	if (tmp.size >= INT_MAX / num_possible_cpus())
+		return -ENOMEM;
+	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
+		return -ENOMEM;
+
+	newinfo = xt_alloc_table_info(tmp.size);
+	if (!newinfo)
+		return -ENOMEM;
+
+	/* choose the copy that is on our node/cpu */
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp), tmp.size) != 0) {
+		ret = -EFAULT;
+		goto free_newinfo;
+	}
+
+	ret = translate_compat_table(tmp.name, tmp.valid_hooks,
+				     &newinfo, &loc_cpu_entry, tmp.size,
+				     tmp.num_entries, tmp.hook_entry,
+				     tmp.underflow);
+	if (ret != 0)
+		goto free_newinfo;
+
+	duprintf("compat_do_replace: Translated table\n");
+
+	ret = __do_replace(tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, compat_ptr(tmp.counters));
+	if (ret)
+		goto free_newinfo_untrans;
+	return 0;
+
+ free_newinfo_untrans:
+	ARPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+ free_newinfo:
+	xt_free_table_info(newinfo);
+	return ret;
+}
+
+static int compat_do_arpt_set_ctl(struct sock *sk, int cmd, void __user *user,
+				  unsigned int len)
+{
+	int ret;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case ARPT_SO_SET_REPLACE:
+		ret = compat_do_replace(user, len);
+		break;
+
+	case ARPT_SO_SET_ADD_COUNTERS:
+		ret = do_add_counters(user, len, 1);
+		break;
+
+	default:
+		duprintf("do_arpt_set_ctl:  unknown request %i\n", cmd);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int compat_copy_entry_to_user(struct arpt_entry *e, void __user **dstptr,
+				     compat_uint_t *size,
+				     struct xt_counters *counters,
+				     unsigned int *i)
+{
+	struct arpt_entry_target *t;
+	struct compat_arpt_entry __user *ce;
+	u_int16_t target_offset, next_offset;
+	compat_uint_t origsize;
+	int ret;
+
+	ret = -EFAULT;
+	origsize = *size;
+	ce = (struct compat_arpt_entry __user *)*dstptr;
+	if (copy_to_user(ce, e, sizeof(struct arpt_entry)))
+		goto out;
+
+	if (copy_to_user(&ce->counters, &counters[*i], sizeof(counters[*i])))
+		goto out;
+
+	*dstptr += sizeof(struct compat_arpt_entry);
+	*size -= sizeof(struct arpt_entry) - sizeof(struct compat_arpt_entry);
+
+	target_offset = e->target_offset - (origsize - *size);
+
+	t = arpt_get_target(e);
+	ret = xt_compat_target_to_user(t, dstptr, size);
+	if (ret)
+		goto out;
+	ret = -EFAULT;
+	next_offset = e->next_offset - (origsize - *size);
+	if (put_user(target_offset, &ce->target_offset))
+		goto out;
+	if (put_user(next_offset, &ce->next_offset))
+		goto out;
+
+	(*i)++;
+	return 0;
+out:
+	return ret;
+}
+
+static int compat_copy_entries_to_user(unsigned int total_size,
+				       struct arpt_table *table,
+				       void __user *userptr)
+{
+	struct xt_counters *counters;
+	struct xt_table_info *private = table->private;
+	void __user *pos;
+	unsigned int size;
+	int ret = 0;
+	void *loc_cpu_entry;
+	unsigned int i = 0;
+
+	counters = alloc_counters(table);
+	if (IS_ERR(counters))
+		return PTR_ERR(counters);
+
+	/* choose the copy on our node/cpu */
+	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	pos = userptr;
+	size = total_size;
+	ret = ARPT_ENTRY_ITERATE(loc_cpu_entry, total_size,
+				 compat_copy_entry_to_user,
+				 &pos, &size, counters, &i);
+	vfree(counters);
+	return ret;
+}
+
+struct compat_arpt_get_entries {
+	char name[ARPT_TABLE_MAXNAMELEN];
+	compat_uint_t size;
+	struct compat_arpt_entry entrytable[0];
+};
+
+static int compat_get_entries(struct compat_arpt_get_entries __user *uptr,
+			      int *len)
+{
+	int ret;
+	struct compat_arpt_get_entries get;
+	struct arpt_table *t;
+
+	if (*len < sizeof(get)) {
+		duprintf("compat_get_entries: %u < %zu\n", *len, sizeof(get));
+		return -EINVAL;
+	}
+	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
+		return -EFAULT;
+	if (*len != sizeof(struct compat_arpt_get_entries) + get.size) {
+		duprintf("compat_get_entries: %u != %zu\n",
+			 *len, sizeof(get) + get.size);
+		return -EINVAL;
+	}
+
+	xt_compat_lock(NF_ARP);
+	t = xt_find_table_lock(NF_ARP, get.name);
+	if (t && !IS_ERR(t)) {
+		struct xt_table_info *private = t->private;
+		struct xt_table_info info;
+
+		duprintf("t->private->number = %u\n", private->number);
+		ret = compat_table_info(private, &info);
+		if (!ret && get.size == info.size) {
+			ret = compat_copy_entries_to_user(private->size,
+							  t, uptr->entrytable);
+		} else if (!ret) {
+			duprintf("compat_get_entries: I've got %u not %u!\n",
+				 private->size, get.size);
+			ret = -EINVAL;
+		}
+		xt_compat_flush_offsets(NF_ARP);
+		module_put(t->me);
+		xt_table_unlock(t);
+	} else
+		ret = t ? PTR_ERR(t) : -ENOENT;
+
+	xt_compat_unlock(NF_ARP);
+	return ret;
+}
+
+static int do_arpt_get_ctl(struct sock *, int, void __user *, int *);
+
+static int compat_do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user,
+				  int *len)
+{
+	int ret;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case ARPT_SO_GET_INFO:
+		ret = get_info(user, len, 1);
+		break;
+	case ARPT_SO_GET_ENTRIES:
+		ret = compat_get_entries(user, len);
+		break;
+	default:
+		ret = do_arpt_get_ctl(sk, cmd, user, len);
+	}
+	return ret;
+}
+#endif
+
 static int do_arpt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 {
 	int ret;
@@ -1044,7 +1665,7 @@ static int do_arpt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned
 		break;
 
 	case ARPT_SO_SET_ADD_COUNTERS:
-		ret = do_add_counters(user, len);
+		ret = do_add_counters(user, len, 0);
 		break;
 
 	default:
@@ -1064,7 +1685,7 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 
 	switch (cmd) {
 	case ARPT_SO_GET_INFO:
-		ret = get_info(user, len);
+		ret = get_info(user, len, 0);
 		break;
 
 	case ARPT_SO_GET_ENTRIES:
@@ -1156,6 +1777,11 @@ static struct arpt_target arpt_standard_target __read_mostly = {
 	.name		= ARPT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
 	.family		= NF_ARP,
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(compat_int_t),
+	.compat_from_user = compat_standard_from_user,
+	.compat_to_user	= compat_standard_to_user,
+#endif
 };
 
 static struct arpt_target arpt_error_target __read_mostly = {
@@ -1170,9 +1796,15 @@ static struct nf_sockopt_ops arpt_sockopts = {
 	.set_optmin	= ARPT_BASE_CTL,
 	.set_optmax	= ARPT_SO_SET_MAX+1,
 	.set		= do_arpt_set_ctl,
+#ifdef CONFIG_COMPAT
+	.compat_set	= compat_do_arpt_set_ctl,
+#endif
 	.get_optmin	= ARPT_BASE_CTL,
 	.get_optmax	= ARPT_SO_GET_MAX+1,
 	.get		= do_arpt_get_ctl,
+#ifdef CONFIG_COMPAT
+	.compat_get	= compat_do_arpt_get_ctl,
+#endif
 	.owner		= THIS_MODULE,
 };
 
