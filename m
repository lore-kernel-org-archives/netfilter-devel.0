Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D11129B799;
	Thu,  3 Sep 2026 00:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788396134; cv=none; b=n5xgFUGaoRmrw/wzvqlDdNyUAuu/vAKIkWj9aRxyY2gDv+kOjR1+eFv1agXrZl65ZEAcWJOV+HaXUI6nBDQt2MucFwgPkZnjUt5Sl0dsdcqzYnfHWfaBgYPY/LQXVjBJ+EKt48MB50P47almalEGlWhCmqQwVOKL/yy6xKDjxWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788396134; c=relaxed/simple;
	bh=JbpzHt/7NR+byanW8gEovcfBv17PVLxkt8S6dMkHoXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODGwJsagyAyq2lwu4wmHn2Ji7UErFBJQ1ANujSvfX6NKCQ24K+OaGAmtIjL+l8EElTzngEO8hcRIVW+6vv6OmGTAiFBt0p5Z5boG/m7in5wGrsuKzME4evGRxEk5A3DUrtO4FdQcXhoosdsxEzVhmACv7N0fBtaup5otE2wuyhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=P5JQN8c5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="P5JQN8c5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788396128;
	bh=j3E5iJLtUa0XE78sV5DdeJFd+aDZMtFNwgzmo3Cu7Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5JQN8c54GVTUAYdue1Fxw5BN7oFrrLsJASs8d3sHZAv50fiEMI/tlNQlloTLDH5M
	 iPSfpBhXJhf53kD0KgWYmuWiuB/hMhrBqrpxE6U/bvmGQMtS34gLX4veNYuo2SG9HK
	 j4G54+IDAqncWOFaq7IHyCzDFyPCdg1OGWKPtwO73Ex7xYgOgHWzRCk8THHsqnYHkw
	 vIr4R3k+AXX91LOts7ZGML/pvtFRoQjQc6iUgqUAH+pduasIbYMDc0ptNSGlCjwMMt
	 1SH/L0MNWObPf+YrlsPVjZFQTxUgpXPpMTeUkF/ZLXsTebg9sInwkFpl/hT5L9y8Mz
	 hCdjKwQW8OPdA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4E4F5607AB;
	Thu,  3 Sep 2026 02:42:08 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 10/12] netfilter: arp_tables: remove the 32bit compat interface
Date: Thu,  3 Sep 2026 02:41:47 +0200
Message-ID: <20260903004149.1037028-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903004149.1037028-1-pablo@netfilter.org>
References: <20260903004149.1037028-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

This feature is required to use 32bit arptables binary on 64bit kernels.
It's already off in many distributions including Debian and Fedora for
many years.

Zap arptables first, it's the most esoteric of the 4 flavors.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_arp/arp_tables.h |  19 -
 net/ipv4/netfilter/arp_tables.c          | 472 +----------------------
 2 files changed, 3 insertions(+), 488 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 05631a25e622..8b8d472eff34 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -56,23 +56,4 @@ void arpt_unregister_table(struct net *net, const char *name);
 extern unsigned int arpt_do_table(void *priv, struct sk_buff *skb,
 				  const struct nf_hook_state *state);
 
-#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
-#include <net/compat.h>
-
-struct compat_arpt_entry {
-	struct arpt_arp arp;
-	__u16 target_offset;
-	__u16 next_offset;
-	compat_uint_t comefrom;
-	struct compat_xt_counters counters;
-	unsigned char elems[];
-};
-
-static inline struct xt_entry_target *
-compat_arpt_get_target(struct compat_arpt_entry *e)
-{
-	return (void *)e + e->target_offset;
-}
-
-#endif /* CONFIG_COMPAT */
 #endif /* _ARPTABLES_H */
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index a87e07e80d0d..db307fa49f3f 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -23,7 +23,6 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
-#include <net/compat.h>
 #include <net/sock.h>
 #include <linux/uaccess.h>
 
@@ -724,80 +723,6 @@ static int copy_entries_to_user(unsigned int total_size,
 	return ret;
 }
 
-#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
-static void compat_standard_from_user(void *dst, const void *src)
-{
-	int v = *(compat_int_t *)src;
-
-	if (v > 0)
-		v += xt_compat_calc_jump(NFPROTO_ARP, v);
-	memcpy(dst, &v, sizeof(v));
-}
-
-static int compat_standard_to_user(void __user *dst, const void *src)
-{
-	compat_int_t cv = *(int *)src;
-
-	if (cv > 0)
-		cv -= xt_compat_calc_jump(NFPROTO_ARP, cv);
-	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
-}
-
-static int compat_calc_entry(const struct arpt_entry *e,
-			     const struct xt_table_info *info,
-			     const void *base, struct xt_table_info *newinfo)
-{
-	const struct xt_entry_target *t;
-	unsigned int entry_offset;
-	int off, i, ret;
-
-	off = sizeof(struct arpt_entry) - sizeof(struct compat_arpt_entry);
-	entry_offset = (void *)e - base;
-
-	t = arpt_get_target_c(e);
-	off += xt_compat_target_offset(t->u.kernel.target);
-	newinfo->size -= off;
-	ret = xt_compat_add_offset(NFPROTO_ARP, entry_offset, off);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
-		if (info->hook_entry[i] &&
-		    (e < (struct arpt_entry *)(base + info->hook_entry[i])))
-			newinfo->hook_entry[i] -= off;
-		if (info->underflow[i] &&
-		    (e < (struct arpt_entry *)(base + info->underflow[i])))
-			newinfo->underflow[i] -= off;
-	}
-	return 0;
-}
-
-static int compat_table_info(const struct xt_table_info *info,
-			     struct xt_table_info *newinfo)
-{
-	struct arpt_entry *iter;
-	const void *loc_cpu_entry;
-	int ret;
-
-	if (!newinfo || !info)
-		return -EINVAL;
-
-	/* we dont care about newinfo->entries */
-	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
-	newinfo->initial_entries = 0;
-	loc_cpu_entry = info->entries;
-	ret = xt_compat_init_offsets(NFPROTO_ARP, info->number);
-	if (ret)
-		return ret;
-	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
-		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
-		if (ret != 0)
-			return ret;
-	}
-	return 0;
-}
-#endif
-
 static int get_info(struct net *net, void __user *user, const int *len)
 {
 	char name[XT_TABLE_MAXNAMELEN];
@@ -811,23 +736,11 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		return -EFAULT;
 
 	name[XT_TABLE_MAXNAMELEN-1] = '\0';
-#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
-	if (in_compat_syscall())
-		xt_compat_lock(NFPROTO_ARP);
-#endif
 	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
 	if (!IS_ERR(t)) {
 		struct arpt_getinfo info;
 		const struct xt_table_info *private = t->private;
-#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
-		struct xt_table_info tmp;
 
-		if (in_compat_syscall()) {
-			ret = compat_table_info(private, &tmp);
-			xt_compat_flush_offsets(NFPROTO_ARP);
-			private = &tmp;
-		}
-#endif
 		memset(&info, 0, sizeof(info));
 		info.valid_hooks = t->valid_hooks;
 		memcpy(info.hook_entry, private->hook_entry,
@@ -846,10 +759,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		module_put(t->me);
 	} else
 		ret = PTR_ERR(t);
-#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
-	if (in_compat_syscall())
-		xt_compat_unlock(NFPROTO_ARP);
-#endif
+
 	return ret;
 }
 
@@ -1059,367 +969,6 @@ static int do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	return ret;
 }
 
-#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
-struct compat_arpt_replace {
-	char				name[XT_TABLE_MAXNAMELEN];
-	u32				valid_hooks;
-	u32				num_entries;
-	u32				size;
-	u32				hook_entry[NF_ARP_NUMHOOKS];
-	u32				underflow[NF_ARP_NUMHOOKS];
-	u32				num_counters;
-	compat_uptr_t			counters;
-	struct compat_arpt_entry	entries[];
-};
-
-static inline void compat_release_entry(struct compat_arpt_entry *e)
-{
-	struct xt_entry_target *t;
-
-	t = compat_arpt_get_target(e);
-	module_put(t->u.kernel.target->me);
-}
-
-static int
-check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
-				  struct xt_table_info *newinfo,
-				  unsigned int *size,
-				  const unsigned char *base,
-				  const unsigned char *limit)
-{
-	struct xt_entry_target *t;
-	struct xt_target *target;
-	unsigned int entry_offset;
-	int ret, off;
-
-	if ((unsigned long)e % __alignof__(struct compat_arpt_entry) != 0 ||
-	    (unsigned char *)e + sizeof(struct compat_arpt_entry) >= limit ||
-	    (unsigned char *)e + e->next_offset > limit)
-		return -EINVAL;
-
-	if (e->next_offset < sizeof(struct compat_arpt_entry) +
-			     sizeof(struct compat_xt_entry_target))
-		return -EINVAL;
-
-	if (!arp_checkentry(&e->arp))
-		return -EINVAL;
-
-	ret = xt_compat_check_entry_offsets(e, e->elems, e->target_offset,
-					    e->next_offset);
-	if (ret)
-		return ret;
-
-	off = sizeof(struct arpt_entry) - sizeof(struct compat_arpt_entry);
-	entry_offset = (void *)e - (void *)base;
-
-	t = compat_arpt_get_target(e);
-	target = xt_request_find_target(NFPROTO_ARP, t->u.user.name,
-					t->u.user.revision);
-	if (IS_ERR(target)) {
-		ret = PTR_ERR(target);
-		goto out;
-	}
-	t->u.kernel.target = target;
-
-	off += xt_compat_target_offset(target);
-	*size += off;
-	ret = xt_compat_add_offset(NFPROTO_ARP, entry_offset, off);
-	if (ret)
-		goto release_target;
-
-	return 0;
-
-release_target:
-	module_put(t->u.kernel.target->me);
-out:
-	return ret;
-}
-
-static void
-compat_copy_entry_from_user(struct compat_arpt_entry *e, void **dstptr,
-			    unsigned int *size,
-			    struct xt_table_info *newinfo, unsigned char *base)
-{
-	struct xt_entry_target *t;
-	struct arpt_entry *de;
-	unsigned int origsize;
-	int h;
-
-	origsize = *size;
-	de = *dstptr;
-	memcpy(de, e, sizeof(struct arpt_entry));
-	memcpy(&de->counters, &e->counters, sizeof(e->counters));
-
-	*dstptr += sizeof(struct arpt_entry);
-	*size += sizeof(struct arpt_entry) - sizeof(struct compat_arpt_entry);
-
-	de->target_offset = e->target_offset - (origsize - *size);
-	t = compat_arpt_get_target(e);
-	xt_compat_target_from_user(t, dstptr, size);
-
-	de->next_offset = e->next_offset - (origsize - *size);
-	for (h = 0; h < NF_ARP_NUMHOOKS; h++) {
-		if ((unsigned char *)de - base < newinfo->hook_entry[h])
-			newinfo->hook_entry[h] -= origsize - *size;
-		if ((unsigned char *)de - base < newinfo->underflow[h])
-			newinfo->underflow[h] -= origsize - *size;
-	}
-}
-
-static int translate_compat_table(struct net *net,
-				  struct xt_table_info **pinfo,
-				  void **pentry0,
-				  const struct compat_arpt_replace *compatr)
-{
-	unsigned int i, j;
-	struct xt_table_info *newinfo, *info;
-	void *pos, *entry0, *entry1;
-	struct compat_arpt_entry *iter0;
-	struct arpt_replace repl;
-	unsigned int size;
-	int ret;
-
-	info = *pinfo;
-	entry0 = *pentry0;
-	size = compatr->size;
-	info->number = compatr->num_entries;
-
-	j = 0;
-	xt_compat_lock(NFPROTO_ARP);
-	ret = xt_compat_init_offsets(NFPROTO_ARP, compatr->num_entries);
-	if (ret)
-		goto out_unlock;
-	/* Walk through entries, checking offsets. */
-	xt_entry_foreach(iter0, entry0, compatr->size) {
-		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
-							entry0,
-							entry0 + compatr->size);
-		if (ret != 0)
-			goto out_unlock;
-		++j;
-	}
-
-	ret = -EINVAL;
-	if (j != compatr->num_entries)
-		goto out_unlock;
-
-	ret = -ENOMEM;
-	newinfo = xt_alloc_table_info(size);
-	if (!newinfo)
-		goto out_unlock;
-
-	memset(newinfo->entries, 0, size);
-
-	newinfo->number = compatr->num_entries;
-	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
-		newinfo->hook_entry[i] = compatr->hook_entry[i];
-		newinfo->underflow[i] = compatr->underflow[i];
-	}
-	entry1 = newinfo->entries;
-	pos = entry1;
-	size = compatr->size;
-	xt_entry_foreach(iter0, entry0, compatr->size)
-		compat_copy_entry_from_user(iter0, &pos, &size,
-					    newinfo, entry1);
-
-	/* all module references in entry0 are now gone */
-
-	xt_compat_flush_offsets(NFPROTO_ARP);
-	xt_compat_unlock(NFPROTO_ARP);
-
-	memcpy(&repl, compatr, sizeof(*compatr));
-
-	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
-		repl.hook_entry[i] = newinfo->hook_entry[i];
-		repl.underflow[i] = newinfo->underflow[i];
-	}
-
-	repl.num_counters = 0;
-	repl.counters = NULL;
-	repl.size = newinfo->size;
-	ret = translate_table(net, newinfo, entry1, &repl);
-	if (ret)
-		goto free_newinfo;
-
-	*pinfo = newinfo;
-	*pentry0 = entry1;
-	xt_free_table_info(info);
-	return 0;
-
-free_newinfo:
-	xt_free_table_info(newinfo);
-	return ret;
-out_unlock:
-	xt_compat_flush_offsets(NFPROTO_ARP);
-	xt_compat_unlock(NFPROTO_ARP);
-	xt_entry_foreach(iter0, entry0, compatr->size) {
-		if (j-- == 0)
-			break;
-		compat_release_entry(iter0);
-	}
-	return ret;
-}
-
-static int compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
-{
-	int ret;
-	struct compat_arpt_replace tmp;
-	struct xt_table_info *newinfo;
-	void *loc_cpu_entry;
-	struct arpt_entry *iter;
-
-	if (len < sizeof(tmp))
-		return -EINVAL;
-	if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
-		return -EFAULT;
-
-	/* overflow check */
-	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
-		return -ENOMEM;
-	if (tmp.num_counters == 0)
-		return -EINVAL;
-	if ((u64)len < (u64)tmp.size + sizeof(tmp))
-		return -EINVAL;
-
-	tmp.name[sizeof(tmp.name)-1] = 0;
-
-	newinfo = xt_alloc_table_info(tmp.size);
-	if (!newinfo)
-		return -ENOMEM;
-
-	loc_cpu_entry = newinfo->entries;
-	if (copy_from_sockptr_offset(loc_cpu_entry, arg, sizeof(tmp),
-			tmp.size) != 0) {
-		ret = -EFAULT;
-		goto free_newinfo;
-	}
-
-	ret = translate_compat_table(net, &newinfo, &loc_cpu_entry, &tmp);
-	if (ret != 0)
-		goto free_newinfo;
-
-	ret = __do_replace(net, tmp.name, tmp.valid_hooks, newinfo,
-			   tmp.num_counters, compat_ptr(tmp.counters));
-	if (ret)
-		goto free_newinfo_untrans;
-	return 0;
-
- free_newinfo_untrans:
-	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		cleanup_entry(iter, net);
- free_newinfo:
-	xt_free_table_info(newinfo);
-	return ret;
-}
-
-static int compat_copy_entry_to_user(struct arpt_entry *e, void __user **dstptr,
-				     compat_uint_t *size,
-				     struct xt_counters *counters,
-				     unsigned int i)
-{
-	struct xt_entry_target *t;
-	struct compat_arpt_entry __user *ce;
-	u_int16_t target_offset, next_offset;
-	compat_uint_t origsize;
-	int ret;
-
-	origsize = *size;
-	ce = *dstptr;
-	if (copy_to_user(ce, e, offsetof(struct compat_arpt_entry, counters)) ||
-	    copy_to_user(&ce->counters, &counters[i], sizeof(counters[i])))
-		return -EFAULT;
-
-	*dstptr += sizeof(struct compat_arpt_entry);
-	*size -= sizeof(struct arpt_entry) - sizeof(struct compat_arpt_entry);
-
-	target_offset = e->target_offset - (origsize - *size);
-
-	t = arpt_get_target(e);
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
-static int compat_copy_entries_to_user(unsigned int total_size,
-				       struct xt_table *table,
-				       void __user *userptr)
-{
-	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
-	void __user *pos;
-	unsigned int size;
-	int ret = 0;
-	unsigned int i = 0;
-	struct arpt_entry *iter;
-
-	counters = alloc_counters(table);
-	if (IS_ERR(counters))
-		return PTR_ERR(counters);
-
-	pos = userptr;
-	size = total_size;
-	xt_entry_foreach(iter, private->entries, total_size) {
-		ret = compat_copy_entry_to_user(iter, &pos,
-						&size, counters, i++);
-		if (ret != 0)
-			break;
-	}
-	vfree(counters);
-	return ret;
-}
-
-struct compat_arpt_get_entries {
-	char name[XT_TABLE_MAXNAMELEN];
-	compat_uint_t size;
-	struct compat_arpt_entry entrytable[];
-};
-
-static int compat_get_entries(struct net *net,
-			      struct compat_arpt_get_entries __user *uptr,
-			      int *len)
-{
-	int ret;
-	struct compat_arpt_get_entries get;
-	struct xt_table *t;
-
-	if (*len < sizeof(get))
-		return -EINVAL;
-	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
-		return -EFAULT;
-	if (*len != sizeof(struct compat_arpt_get_entries) + get.size)
-		return -EINVAL;
-
-	get.name[sizeof(get.name) - 1] = '\0';
-
-	xt_compat_lock(NFPROTO_ARP);
-	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
-	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
-		struct xt_table_info info;
-
-		ret = compat_table_info(private, &info);
-		if (!ret && get.size == info.size) {
-			ret = compat_copy_entries_to_user(private->size,
-							  t, uptr->entrytable);
-		} else if (!ret)
-			ret = -EAGAIN;
-
-		xt_compat_flush_offsets(NFPROTO_ARP);
-		module_put(t->me);
-		xt_table_unlock(t);
-	} else
-		ret = PTR_ERR(t);
-
-	xt_compat_unlock(NFPROTO_ARP);
-	return ret;
-}
-#endif
-
 static int do_arpt_set_ctl(struct sock *sk, int cmd, sockptr_t arg,
 		unsigned int len)
 {
@@ -1432,12 +981,7 @@ static int do_arpt_set_ctl(struct sock *sk, int cmd, sockptr_t arg,
 
 	switch (cmd) {
 	case ARPT_SO_SET_REPLACE:
-#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
-		if (in_compat_syscall())
-			ret = compat_do_replace(sock_net(sk), arg, len);
-		else
-#endif
-			ret = do_replace(sock_net(sk), arg, len);
+		ret = do_replace(sock_net(sk), arg, len);
 		break;
 
 	case ARPT_SO_SET_ADD_COUNTERS:
@@ -1466,12 +1010,7 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 		break;
 
 	case ARPT_SO_GET_ENTRIES:
-#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
-		if (in_compat_syscall())
-			ret = compat_get_entries(sock_net(sk), user, len);
-		else
-#endif
-			ret = get_entries(sock_net(sk), user, len);
+		ret = get_entries(sock_net(sk), user, len);
 		break;
 
 	case ARPT_SO_GET_REVISION_TARGET: {
@@ -1568,11 +1107,6 @@ static struct xt_target arpt_builtin_tg[] __read_mostly = {
 		.name             = XT_STANDARD_TARGET,
 		.targetsize       = sizeof(int),
 		.family           = NFPROTO_ARP,
-#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
-		.compatsize       = sizeof(compat_int_t),
-		.compat_from_user = compat_standard_from_user,
-		.compat_to_user   = compat_standard_to_user,
-#endif
 	},
 	{
 		.name             = XT_ERROR_TARGET,
-- 
2.47.3

