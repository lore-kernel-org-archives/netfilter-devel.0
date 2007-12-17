From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/64]: ip6_tables: add compat support
Date: Tue, 18 Dec 2007 00:46:31 +0100 (MET)
Message-ID: <20071217234631.23601.6719.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38921 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbXLQXqd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:33 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_tables: add compat support

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8a27d7d8dbfa0a27714e8b05d3c51786ebdb42e7
tree ba41312d5c6cfcbb3070c08b9e20885740f83d66
parent 740665f37ee927ca922fc0d978c3b3ba354ee220
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:52 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:53 +0100

 include/linux/netfilter_ipv6/ip6_tables.h |   35 +
 net/compat.c                              |  106 ----
 net/ipv6/netfilter/ip6_tables.c           |  823 +++++++++++++++++++++++++++--
 3 files changed, 802 insertions(+), 162 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 8257b52..c112482 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -326,5 +326,40 @@ extern int ip6_masked_addrcmp(const struct in6_addr *addr1,
 
 #define IP6T_ALIGN(s) (((s) + (__alignof__(struct ip6t_entry)-1)) & ~(__alignof__(struct ip6t_entry)-1))
 
+#ifdef CONFIG_COMPAT
+#include <net/compat.h>
+
+struct compat_ip6t_entry
+{
+	struct ip6t_ip6 ipv6;
+	compat_uint_t nfcache;
+	u_int16_t target_offset;
+	u_int16_t next_offset;
+	compat_uint_t comefrom;
+	struct compat_xt_counters counters;
+	unsigned char elems[0];
+};
+
+static inline struct ip6t_entry_target *
+compat_ip6t_get_target(struct compat_ip6t_entry *e)
+{
+	return (void *)e + e->target_offset;
+}
+
+#define COMPAT_IP6T_ALIGN(s)	COMPAT_XT_ALIGN(s)
+
+/* fn returns 0 to continue iteration */
+#define COMPAT_IP6T_MATCH_ITERATE(e, fn, args...) \
+	XT_MATCH_ITERATE(struct compat_ip6t_entry, e, fn, ## args)
+
+/* fn returns 0 to continue iteration */
+#define COMPAT_IP6T_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct compat_ip6t_entry, entries, size, fn, ## args)
+
+#define COMPAT_IP6T_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
+	XT_ENTRY_ITERATE_CONTINUE(struct compat_ip6t_entry, entries, size, n, \
+				  fn, ## args)
+
+#endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IP6_TABLES_H */
diff --git a/net/compat.c b/net/compat.c
index b599cf1..96ec55e 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -20,7 +20,6 @@
 #include <linux/syscalls.h>
 #include <linux/filter.h>
 #include <linux/compat.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/security.h>
 
 #include <net/scm.h>
@@ -315,107 +314,6 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
 }
 
 /*
- * For now, we assume that the compatibility and native version
- * of struct ipt_entry are the same - sfr.  FIXME
- */
-struct compat_ipt_replace {
-	char			name[IPT_TABLE_MAXNAMELEN];
-	u32			valid_hooks;
-	u32			num_entries;
-	u32			size;
-	u32			hook_entry[NF_INET_NUMHOOKS];
-	u32			underflow[NF_INET_NUMHOOKS];
-	u32			num_counters;
-	compat_uptr_t		counters;	/* struct ipt_counters * */
-	struct ipt_entry	entries[0];
-};
-
-static int do_netfilter_replace(int fd, int level, int optname,
-				char __user *optval, int optlen)
-{
-	struct compat_ipt_replace __user *urepl;
-	struct ipt_replace __user *repl_nat;
-	char name[IPT_TABLE_MAXNAMELEN];
-	u32 origsize, tmp32, num_counters;
-	unsigned int repl_nat_size;
-	int ret;
-	int i;
-	compat_uptr_t ucntrs;
-
-	urepl = (struct compat_ipt_replace __user *)optval;
-	if (get_user(origsize, &urepl->size))
-		return -EFAULT;
-
-	/* Hack: Causes ipchains to give correct error msg --RR */
-	if (optlen != sizeof(*urepl) + origsize)
-		return -ENOPROTOOPT;
-
-	/* XXX Assumes that size of ipt_entry is the same both in
-	 *     native and compat environments.
-	 */
-	repl_nat_size = sizeof(*repl_nat) + origsize;
-	repl_nat = compat_alloc_user_space(repl_nat_size);
-
-	ret = -EFAULT;
-	if (put_user(origsize, &repl_nat->size))
-		goto out;
-
-	if (!access_ok(VERIFY_READ, urepl, optlen) ||
-	    !access_ok(VERIFY_WRITE, repl_nat, optlen))
-		goto out;
-
-	if (__copy_from_user(name, urepl->name, sizeof(urepl->name)) ||
-	    __copy_to_user(repl_nat->name, name, sizeof(repl_nat->name)))
-		goto out;
-
-	if (__get_user(tmp32, &urepl->valid_hooks) ||
-	    __put_user(tmp32, &repl_nat->valid_hooks))
-		goto out;
-
-	if (__get_user(tmp32, &urepl->num_entries) ||
-	    __put_user(tmp32, &repl_nat->num_entries))
-		goto out;
-
-	if (__get_user(num_counters, &urepl->num_counters) ||
-	    __put_user(num_counters, &repl_nat->num_counters))
-		goto out;
-
-	if (__get_user(ucntrs, &urepl->counters) ||
-	    __put_user(compat_ptr(ucntrs), &repl_nat->counters))
-		goto out;
-
-	if (__copy_in_user(&repl_nat->entries[0],
-			   &urepl->entries[0],
-			   origsize))
-		goto out;
-
-	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
-		if (__get_user(tmp32, &urepl->hook_entry[i]) ||
-		    __put_user(tmp32, &repl_nat->hook_entry[i]) ||
-		    __get_user(tmp32, &urepl->underflow[i]) ||
-		    __put_user(tmp32, &repl_nat->underflow[i]))
-			goto out;
-	}
-
-	/*
-	 * Since struct ipt_counters just contains two u_int64_t members
-	 * we can just do the access_ok check here and pass the (converted)
-	 * pointer into the standard syscall.  We hope that the pointer is
-	 * not misaligned ...
-	 */
-	if (!access_ok(VERIFY_WRITE, compat_ptr(ucntrs),
-		       num_counters * sizeof(struct ipt_counters)))
-		goto out;
-
-
-	ret = sys_setsockopt(fd, level, optname,
-			     (char __user *)repl_nat, repl_nat_size);
-
-out:
-	return ret;
-}
-
-/*
  * A struct sock_filter is architecture independent.
  */
 struct compat_sock_fprog {
@@ -483,10 +381,6 @@ asmlinkage long compat_sys_setsockopt(int fd, int level, int optname,
 	int err;
 	struct socket *sock;
 
-	if (level == SOL_IPV6 && optname == IPT_SO_SET_REPLACE)
-		return do_netfilter_replace(fd, level, optname,
-					    optval, optlen);
-
 	if (optlen < 0)
 		return -EINVAL;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 6fcc0d5..db0dc96 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -19,9 +19,11 @@
 #include <linux/poison.h>
 #include <linux/icmpv6.h>
 #include <net/ipv6.h>
+#include <net/compat.h>
 #include <asm/uaccess.h>
 #include <linux/mutex.h>
 #include <linux/proc_fs.h>
+#include <linux/err.h>
 #include <linux/cpumask.h>
 
 #include <linux/netfilter_ipv6/ip6_tables.h>
@@ -1037,7 +1039,80 @@ copy_entries_to_user(unsigned int total_size,
 	return ret;
 }
 
-static int get_info(void __user *user, int *len)
+#ifdef CONFIG_COMPAT
+static void compat_standard_from_user(void *dst, void *src)
+{
+	int v = *(compat_int_t *)src;
+
+	if (v > 0)
+		v += xt_compat_calc_jump(AF_INET6, v);
+	memcpy(dst, &v, sizeof(v));
+}
+
+static int compat_standard_to_user(void __user *dst, void *src)
+{
+	compat_int_t cv = *(int *)src;
+
+	if (cv > 0)
+		cv -= xt_compat_calc_jump(AF_INET6, cv);
+	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
+}
+
+static inline int
+compat_calc_match(struct ip6t_entry_match *m, int *size)
+{
+	*size += xt_compat_match_offset(m->u.kernel.match);
+	return 0;
+}
+
+static int compat_calc_entry(struct ip6t_entry *e,
+			     const struct xt_table_info *info,
+			     void *base, struct xt_table_info *newinfo)
+{
+	struct ip6t_entry_target *t;
+	unsigned int entry_offset;
+	int off, i, ret;
+
+	off = sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
+	entry_offset = (void *)e - base;
+	IP6T_MATCH_ITERATE(e, compat_calc_match, &off);
+	t = ip6t_get_target(e);
+	off += xt_compat_target_offset(t->u.kernel.target);
+	newinfo->size -= off;
+	ret = xt_compat_add_offset(AF_INET6, entry_offset, off);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+		if (info->hook_entry[i] &&
+		    (e < (struct ip6t_entry *)(base + info->hook_entry[i])))
+			newinfo->hook_entry[i] -= off;
+		if (info->underflow[i] &&
+		    (e < (struct ip6t_entry *)(base + info->underflow[i])))
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
+	return IP6T_ENTRY_ITERATE(loc_cpu_entry, info->size,
+				  compat_calc_entry, info, loc_cpu_entry,
+				  newinfo);
+}
+#endif
+
+static int get_info(void __user *user, int *len, int compat)
 {
 	char name[IP6T_TABLE_MAXNAMELEN];
 	struct xt_table *t;
@@ -1053,13 +1128,24 @@ static int get_info(void __user *user, int *len)
 		return -EFAULT;
 
 	name[IP6T_TABLE_MAXNAMELEN-1] = '\0';
-
+#ifdef CONFIG_COMPAT
+	if (compat)
+		xt_compat_lock(AF_INET6);
+#endif
 	t = try_then_request_module(xt_find_table_lock(AF_INET6, name),
 				    "ip6table_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct ip6t_getinfo info;
 		struct xt_table_info *private = t->private;
 
+#ifdef CONFIG_COMPAT
+		if (compat) {
+			struct xt_table_info tmp;
+			ret = compat_table_info(private, &tmp);
+			xt_compat_flush_offsets(AF_INET6);
+			private = &tmp;
+		}
+#endif
 		info.valid_hooks = t->valid_hooks;
 		memcpy(info.hook_entry, private->hook_entry,
 		       sizeof(info.hook_entry));
@@ -1078,6 +1164,10 @@ static int get_info(void __user *user, int *len)
 		module_put(t->me);
 	} else
 		ret = t ? PTR_ERR(t) : -ENOENT;
+#ifdef CONFIG_COMPAT
+	if (compat)
+		xt_compat_unlock(AF_INET6);
+#endif
 	return ret;
 }
 
@@ -1121,65 +1211,40 @@ get_entries(struct ip6t_get_entries __user *uptr, int *len)
 }
 
 static int
-do_replace(void __user *user, unsigned int len)
+__do_replace(const char *name, unsigned int valid_hooks,
+	     struct xt_table_info *newinfo, unsigned int num_counters,
+	     void __user *counters_ptr)
 {
 	int ret;
-	struct ip6t_replace tmp;
 	struct xt_table *t;
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
-
-	/* choose the copy that is on our node/cpu */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
-	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
-			   tmp.size) != 0) {
-		ret = -EFAULT;
-		goto free_newinfo;
-	}
+	void *loc_cpu_old_entry;
 
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
-	duprintf("ip_tables: Translated table\n");
-
-	t = try_then_request_module(xt_find_table_lock(AF_INET6, tmp.name),
-				    "ip6table_%s", tmp.name);
+	t = try_then_request_module(xt_find_table_lock(AF_INET6, name),
+				    "ip6table_%s", name);
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
 
@@ -1197,10 +1262,11 @@ do_replace(void __user *user, unsigned int len)
 	get_counters(oldinfo, counters);
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
-	IP6T_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,NULL);
+	IP6T_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,
+			   NULL);
 	xt_free_table_info(oldinfo);
-	if (copy_to_user(tmp.counters, counters,
-			 sizeof(struct xt_counters) * tmp.num_counters) != 0)
+	if (copy_to_user(counters_ptr, counters,
+			 sizeof(struct xt_counters) * num_counters) != 0)
 		ret = -EFAULT;
 	vfree(counters);
 	xt_table_unlock(t);
@@ -1210,9 +1276,54 @@ do_replace(void __user *user, unsigned int len)
 	module_put(t->me);
 	xt_table_unlock(t);
  free_newinfo_counters_untrans:
-	IP6T_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry,NULL);
- free_newinfo_counters:
 	vfree(counters);
+ out:
+	return ret;
+}
+
+static int
+do_replace(void __user *user, unsigned int len)
+{
+	int ret;
+	struct ip6t_replace tmp;
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
+	duprintf("ip_tables: Translated table\n");
+
+	ret = __do_replace(tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, tmp.counters);
+	if (ret)
+		goto free_newinfo_untrans;
+	return 0;
+
+ free_newinfo_untrans:
+	IP6T_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1241,31 +1352,59 @@ add_counter_to_entry(struct ip6t_entry *e,
 }
 
 static int
-do_add_counters(void __user *user, unsigned int len)
+do_add_counters(void __user *user, unsigned int len, int compat)
 {
 	unsigned int i;
-	struct xt_counters_info tmp, *paddc;
+	struct xt_counters_info tmp;
+	struct xt_counters *paddc;
+	unsigned int num_counters;
+	char *name;
+	int size;
+	void *ptmp;
 	struct xt_table_info *private;
 	struct xt_table *t;
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
 
-	t = xt_find_table_lock(AF_INET6, tmp.name);
+	t = xt_find_table_lock(AF_INET6, name);
 	if (!t || IS_ERR(t)) {
 		ret = t ? PTR_ERR(t) : -ENOENT;
 		goto free;
@@ -1273,7 +1412,7 @@ do_add_counters(void __user *user, unsigned int len)
 
 	write_lock_bh(&t->lock);
 	private = t->private;
-	if (private->number != tmp.num_counters) {
+	if (private->number != num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
 	}
@@ -1284,7 +1423,7 @@ do_add_counters(void __user *user, unsigned int len)
 	IP6T_ENTRY_ITERATE(loc_cpu_entry,
 			  private->size,
 			  add_counter_to_entry,
-			  paddc->counters,
+			  paddc,
 			  &i);
  unlock_up_free:
 	write_unlock_bh(&t->lock);
@@ -1296,6 +1435,567 @@ do_add_counters(void __user *user, unsigned int len)
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_ip6t_replace {
+	char			name[IP6T_TABLE_MAXNAMELEN];
+	u32			valid_hooks;
+	u32			num_entries;
+	u32			size;
+	u32			hook_entry[NF_INET_NUMHOOKS];
+	u32			underflow[NF_INET_NUMHOOKS];
+	u32			num_counters;
+	compat_uptr_t		counters;	/* struct ip6t_counters * */
+	struct compat_ip6t_entry entries[0];
+};
+
+static int
+compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
+			  compat_uint_t *size, struct xt_counters *counters,
+			  unsigned int *i)
+{
+	struct ip6t_entry_target *t;
+	struct compat_ip6t_entry __user *ce;
+	u_int16_t target_offset, next_offset;
+	compat_uint_t origsize;
+	int ret;
+
+	ret = -EFAULT;
+	origsize = *size;
+	ce = (struct compat_ip6t_entry __user *)*dstptr;
+	if (copy_to_user(ce, e, sizeof(struct ip6t_entry)))
+		goto out;
+
+	if (copy_to_user(&ce->counters, &counters[*i], sizeof(counters[*i])))
+		goto out;
+
+	*dstptr += sizeof(struct compat_ip6t_entry);
+	*size -= sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
+
+	ret = IP6T_MATCH_ITERATE(e, xt_compat_match_to_user, dstptr, size);
+	target_offset = e->target_offset - (origsize - *size);
+	if (ret)
+		goto out;
+	t = ip6t_get_target(e);
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
+static inline int
+compat_find_calc_match(struct ip6t_entry_match *m,
+		       const char *name,
+		       const struct ip6t_ip6 *ipv6,
+		       unsigned int hookmask,
+		       int *size, int *i)
+{
+	struct xt_match *match;
+
+	match = try_then_request_module(xt_find_match(AF_INET6, m->u.user.name,
+						      m->u.user.revision),
+					"ip6t_%s", m->u.user.name);
+	if (IS_ERR(match) || !match) {
+		duprintf("compat_check_calc_match: `%s' not found\n",
+			 m->u.user.name);
+		return match ? PTR_ERR(match) : -ENOENT;
+	}
+	m->u.kernel.match = match;
+	*size += xt_compat_match_offset(match);
+
+	(*i)++;
+	return 0;
+}
+
+static inline int
+compat_release_match(struct ip6t_entry_match *m, unsigned int *i)
+{
+	if (i && (*i)-- == 0)
+		return 1;
+
+	module_put(m->u.kernel.match->me);
+	return 0;
+}
+
+static inline int
+compat_release_entry(struct compat_ip6t_entry *e, unsigned int *i)
+{
+	struct ip6t_entry_target *t;
+
+	if (i && (*i)-- == 0)
+		return 1;
+
+	/* Cleanup all matches */
+	COMPAT_IP6T_MATCH_ITERATE(e, compat_release_match, NULL);
+	t = compat_ip6t_get_target(e);
+	module_put(t->u.kernel.target->me);
+	return 0;
+}
+
+static inline int
+check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
+				  struct xt_table_info *newinfo,
+				  unsigned int *size,
+				  unsigned char *base,
+				  unsigned char *limit,
+				  unsigned int *hook_entries,
+				  unsigned int *underflows,
+				  unsigned int *i,
+				  const char *name)
+{
+	struct ip6t_entry_target *t;
+	struct xt_target *target;
+	unsigned int entry_offset;
+	int ret, off, h, j;
+
+	duprintf("check_compat_entry_size_and_hooks %p\n", e);
+	if ((unsigned long)e % __alignof__(struct compat_ip6t_entry) != 0
+	    || (unsigned char *)e + sizeof(struct compat_ip6t_entry) >= limit) {
+		duprintf("Bad offset %p, limit = %p\n", e, limit);
+		return -EINVAL;
+	}
+
+	if (e->next_offset < sizeof(struct compat_ip6t_entry) +
+			     sizeof(struct compat_xt_entry_target)) {
+		duprintf("checking: element %p size %u\n",
+			 e, e->next_offset);
+		return -EINVAL;
+	}
+
+	/* For purposes of check_entry casting the compat entry is fine */
+	ret = check_entry((struct ip6t_entry *)e, name);
+	if (ret)
+		return ret;
+
+	off = sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
+	entry_offset = (void *)e - (void *)base;
+	j = 0;
+	ret = COMPAT_IP6T_MATCH_ITERATE(e, compat_find_calc_match, name,
+					&e->ipv6, e->comefrom, &off, &j);
+	if (ret != 0)
+		goto release_matches;
+
+	t = compat_ip6t_get_target(e);
+	target = try_then_request_module(xt_find_target(AF_INET6,
+							t->u.user.name,
+							t->u.user.revision),
+					 "ip6t_%s", t->u.user.name);
+	if (IS_ERR(target) || !target) {
+		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
+			 t->u.user.name);
+		ret = target ? PTR_ERR(target) : -ENOENT;
+		goto release_matches;
+	}
+	t->u.kernel.target = target;
+
+	off += xt_compat_target_offset(target);
+	*size += off;
+	ret = xt_compat_add_offset(AF_INET6, entry_offset, off);
+	if (ret)
+		goto out;
+
+	/* Check hooks & underflows */
+	for (h = 0; h < NF_INET_NUMHOOKS; h++) {
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
+out:
+	module_put(t->u.kernel.target->me);
+release_matches:
+	IP6T_MATCH_ITERATE(e, compat_release_match, &j);
+	return ret;
+}
+
+static int
+compat_copy_entry_from_user(struct compat_ip6t_entry *e, void **dstptr,
+			    unsigned int *size, const char *name,
+			    struct xt_table_info *newinfo, unsigned char *base)
+{
+	struct ip6t_entry_target *t;
+	struct xt_target *target;
+	struct ip6t_entry *de;
+	unsigned int origsize;
+	int ret, h;
+
+	ret = 0;
+	origsize = *size;
+	de = (struct ip6t_entry *)*dstptr;
+	memcpy(de, e, sizeof(struct ip6t_entry));
+	memcpy(&de->counters, &e->counters, sizeof(e->counters));
+
+	*dstptr += sizeof(struct ip6t_entry);
+	*size += sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
+
+	ret = COMPAT_IP6T_MATCH_ITERATE(e, xt_compat_match_from_user,
+					dstptr, size);
+	if (ret)
+		return ret;
+	de->target_offset = e->target_offset - (origsize - *size);
+	t = compat_ip6t_get_target(e);
+	target = t->u.kernel.target;
+	xt_compat_target_from_user(t, dstptr, size);
+
+	de->next_offset = e->next_offset - (origsize - *size);
+	for (h = 0; h < NF_INET_NUMHOOKS; h++) {
+		if ((unsigned char *)de - base < newinfo->hook_entry[h])
+			newinfo->hook_entry[h] -= origsize - *size;
+		if ((unsigned char *)de - base < newinfo->underflow[h])
+			newinfo->underflow[h] -= origsize - *size;
+	}
+	return ret;
+}
+
+static inline int compat_check_entry(struct ip6t_entry *e, const char *name,
+				     unsigned int *i)
+{
+	int j, ret;
+
+	j = 0;
+	ret = IP6T_MATCH_ITERATE(e, check_match, name, &e->ipv6,
+				 e->comefrom, &j);
+	if (ret)
+		goto cleanup_matches;
+
+	ret = check_target(e, name);
+	if (ret)
+		goto cleanup_matches;
+
+	(*i)++;
+	return 0;
+
+ cleanup_matches:
+	IP6T_MATCH_ITERATE(e, cleanup_match, &j);
+	return ret;
+}
+
+static int
+translate_compat_table(const char *name,
+		       unsigned int valid_hooks,
+		       struct xt_table_info **pinfo,
+		       void **pentry0,
+		       unsigned int total_size,
+		       unsigned int number,
+		       unsigned int *hook_entries,
+		       unsigned int *underflows)
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
+	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+		info->hook_entry[i] = 0xFFFFFFFF;
+		info->underflow[i] = 0xFFFFFFFF;
+	}
+
+	duprintf("translate_compat_table: size %u\n", info->size);
+	j = 0;
+	xt_compat_lock(AF_INET6);
+	/* Walk through entries, checking offsets. */
+	ret = COMPAT_IP6T_ENTRY_ITERATE(entry0, total_size,
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
+	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
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
+	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+		newinfo->hook_entry[i] = info->hook_entry[i];
+		newinfo->underflow[i] = info->underflow[i];
+	}
+	entry1 = newinfo->entries[raw_smp_processor_id()];
+	pos = entry1;
+	size = total_size;
+	ret = COMPAT_IP6T_ENTRY_ITERATE(entry0, total_size,
+					compat_copy_entry_from_user,
+					&pos, &size, name, newinfo, entry1);
+	xt_compat_flush_offsets(AF_INET6);
+	xt_compat_unlock(AF_INET6);
+	if (ret)
+		goto free_newinfo;
+
+	ret = -ELOOP;
+	if (!mark_source_chains(newinfo, valid_hooks, entry1))
+		goto free_newinfo;
+
+	i = 0;
+	ret = IP6T_ENTRY_ITERATE(entry1, newinfo->size, compat_check_entry,
+				 name, &i);
+	if (ret) {
+		j -= i;
+		COMPAT_IP6T_ENTRY_ITERATE_CONTINUE(entry0, newinfo->size, i,
+						   compat_release_entry, &j);
+		IP6T_ENTRY_ITERATE(entry1, newinfo->size, cleanup_entry, &i);
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
+	COMPAT_IP6T_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
+	return ret;
+out_unlock:
+	xt_compat_flush_offsets(AF_INET6);
+	xt_compat_unlock(AF_INET6);
+	goto out;
+}
+
+static int
+compat_do_replace(void __user *user, unsigned int len)
+{
+	int ret;
+	struct compat_ip6t_replace tmp;
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
+	/* choose the copy that is our node/cpu */
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
+			   tmp.size) != 0) {
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
+	IP6T_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+ free_newinfo:
+	xt_free_table_info(newinfo);
+	return ret;
+}
+
+static int
+compat_do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user,
+		       unsigned int len)
+{
+	int ret;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case IP6T_SO_SET_REPLACE:
+		ret = compat_do_replace(user, len);
+		break;
+
+	case IP6T_SO_SET_ADD_COUNTERS:
+		ret = do_add_counters(user, len, 1);
+		break;
+
+	default:
+		duprintf("do_ip6t_set_ctl:  unknown request %i\n", cmd);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+struct compat_ip6t_get_entries {
+	char name[IP6T_TABLE_MAXNAMELEN];
+	compat_uint_t size;
+	struct compat_ip6t_entry entrytable[0];
+};
+
+static int
+compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
+			    void __user *userptr)
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
+	/* choose the copy that is on our node/cpu, ...
+	 * This choice is lazy (because current thread is
+	 * allowed to migrate to another cpu)
+	 */
+	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	pos = userptr;
+	size = total_size;
+	ret = IP6T_ENTRY_ITERATE(loc_cpu_entry, total_size,
+				 compat_copy_entry_to_user,
+				 &pos, &size, counters, &i);
+
+	vfree(counters);
+	return ret;
+}
+
+static int
+compat_get_entries(struct compat_ip6t_get_entries __user *uptr, int *len)
+{
+	int ret;
+	struct compat_ip6t_get_entries get;
+	struct xt_table *t;
+
+	if (*len < sizeof(get)) {
+		duprintf("compat_get_entries: %u < %u\n",
+			 *len, (unsigned int)sizeof(get));
+		return -EINVAL;
+	}
+
+	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
+		return -EFAULT;
+
+	if (*len != sizeof(struct compat_ip6t_get_entries) + get.size) {
+		duprintf("compat_get_entries: %u != %u\n", *len,
+			 (unsigned int)(sizeof(struct compat_ip6t_get_entries) +
+			 get.size));
+		return -EINVAL;
+	}
+
+	xt_compat_lock(AF_INET6);
+	t = xt_find_table_lock(AF_INET6, get.name);
+	if (t && !IS_ERR(t)) {
+		struct xt_table_info *private = t->private;
+		struct xt_table_info info;
+		duprintf("t->private->number = %u\n",
+			 private->number);
+		ret = compat_table_info(private, &info);
+		if (!ret && get.size == info.size) {
+			ret = compat_copy_entries_to_user(private->size,
+							  t, uptr->entrytable);
+		} else if (!ret) {
+			duprintf("compat_get_entries: I've got %u not %u!\n",
+				 private->size,
+				 get.size);
+			ret = -EINVAL;
+		}
+		xt_compat_flush_offsets(AF_INET6);
+		module_put(t->me);
+		xt_table_unlock(t);
+	} else
+		ret = t ? PTR_ERR(t) : -ENOENT;
+
+	xt_compat_unlock(AF_INET6);
+	return ret;
+}
+
+static int do_ip6t_get_ctl(struct sock *, int, void __user *, int *);
+
+static int
+compat_do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
+{
+	int ret;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case IP6T_SO_GET_INFO:
+		ret = get_info(user, len, 1);
+		break;
+	case IP6T_SO_GET_ENTRIES:
+		ret = compat_get_entries(user, len);
+		break;
+	default:
+		ret = do_ip6t_get_ctl(sk, cmd, user, len);
+	}
+	return ret;
+}
+#endif
+
 static int
 do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 {
@@ -1310,7 +2010,7 @@ do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		break;
 
 	case IP6T_SO_SET_ADD_COUNTERS:
-		ret = do_add_counters(user, len);
+		ret = do_add_counters(user, len, 0);
 		break;
 
 	default:
@@ -1331,7 +2031,7 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 
 	switch (cmd) {
 	case IP6T_SO_GET_INFO:
-		ret = get_info(user, len);
+		ret = get_info(user, len, 0);
 		break;
 
 	case IP6T_SO_GET_ENTRIES:
@@ -1483,6 +2183,11 @@ static struct xt_target ip6t_standard_target __read_mostly = {
 	.name		= IP6T_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
 	.family		= AF_INET6,
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(compat_int_t),
+	.compat_from_user = compat_standard_from_user,
+	.compat_to_user	= compat_standard_to_user,
+#endif
 };
 
 static struct xt_target ip6t_error_target __read_mostly = {
@@ -1497,9 +2202,15 @@ static struct nf_sockopt_ops ip6t_sockopts = {
 	.set_optmin	= IP6T_BASE_CTL,
 	.set_optmax	= IP6T_SO_SET_MAX+1,
 	.set		= do_ip6t_set_ctl,
+#ifdef CONFIG_COMPAT
+	.compat_set	= compat_do_ip6t_set_ctl,
+#endif
 	.get_optmin	= IP6T_BASE_CTL,
 	.get_optmax	= IP6T_SO_GET_MAX+1,
 	.get		= do_ip6t_get_ctl,
+#ifdef CONFIG_COMPAT
+	.compat_get	= compat_do_ip6t_get_ctl,
+#endif
 	.owner		= THIS_MODULE,
 };
 
