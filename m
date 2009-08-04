From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 103/103] netfilter: xtables1: remove compat-userspace code
Date: Tue,  4 Aug 2009 09:26:27 +0200
Message-ID: <1249370787-17583-104-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56966 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbZHDH2X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:23 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   57 ----------
 net/netfilter/x_tables.c           |  203 ------------------------------------
 2 files changed, 0 insertions(+), 260 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 7befc66..0a33c8f 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -745,44 +745,6 @@ xt2_table_lookup(struct net *net, const char *name, uint8_t nfproto,
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
-struct compat_xt_entry_match
-{
-	union {
-		struct {
-			u_int16_t match_size;
-			char name[XT_FUNCTION_MAXNAMELEN - 1];
-			u_int8_t revision;
-		} user;
-		struct {
-			u_int16_t match_size;
-			compat_uptr_t match;
-		} kernel;
-		u_int16_t match_size;
-	} u;
-	unsigned char data[0];
-};
-
-struct compat_xt_entry_target
-{
-	union {
-		struct {
-			u_int16_t target_size;
-			char name[XT_FUNCTION_MAXNAMELEN - 1];
-			u_int8_t revision;
-		} user;
-		struct {
-			u_int16_t target_size;
-			compat_uptr_t target;
-		} kernel;
-		u_int16_t target_size;
-	} u;
-	unsigned char data[0];
-};
-
-/* FIXME: this works only on 32 bit tasks
- * need to change whole approach in order to calculate align as function of
- * current task alignment */
-
 struct compat_xt_counters
 {
 	compat_u64 bcnt, pcnt;
@@ -798,25 +760,6 @@ struct compat_xt_counters_info
 #define COMPAT_XT_ALIGN(s) (((s) + (__alignof__(struct compat_xt_counters)-1)) \
 		& ~(__alignof__(struct compat_xt_counters)-1))
 
-extern void xt_compat_lock(u_int8_t af);
-extern void xt_compat_unlock(u_int8_t af);
-
-extern int xt_compat_add_offset(u_int8_t af, unsigned int offset, short delta);
-extern void xt_compat_flush_offsets(u_int8_t af);
-extern short xt_compat_calc_jump(u_int8_t af, unsigned int offset);
-
-extern int xt_compat_match_offset(const struct xt_match *match);
-extern int xt_compat_match_from_user(struct xt_entry_match *m,
-				     void **dstptr, unsigned int *size);
-extern int xt_compat_match_to_user(const struct xt_entry_match *m,
-				   void __user **dstptr, unsigned int *size);
-
-extern int xt_compat_target_offset(const struct xt_target *target);
-extern void xt_compat_target_from_user(struct xt_entry_target *t,
-				       void **dstptr, unsigned int *size);
-extern int xt_compat_target_to_user(const struct xt_entry_target *t,
-				    void __user **dstptr, unsigned int *size);
-
 #endif /* CONFIG_COMPAT */
 #endif /* __KERNEL__ */
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 1e43ab3..62297b7 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -38,20 +38,10 @@ MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
 
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
 
-struct compat_delta {
-	struct compat_delta *next;
-	unsigned int offset;
-	short delta;
-};
-
 struct xt_af {
 	struct mutex mutex;
 	struct list_head match;
 	struct list_head target;
-#ifdef CONFIG_COMPAT
-	struct mutex compat_mutex;
-	struct compat_delta *compat_offsets;
-#endif
 };
 
 static struct xt_af *xt;
@@ -432,118 +422,6 @@ int xt_check_match(struct xt_mtchk_param *par,
 }
 EXPORT_SYMBOL_GPL(xt_check_match);
 
-#ifdef CONFIG_COMPAT
-int xt_compat_add_offset(u_int8_t af, unsigned int offset, short delta)
-{
-	struct compat_delta *tmp;
-
-	tmp = kmalloc(sizeof(struct compat_delta), GFP_KERNEL);
-	if (!tmp)
-		return -ENOMEM;
-
-	tmp->offset = offset;
-	tmp->delta = delta;
-
-	if (xt[af].compat_offsets) {
-		tmp->next = xt[af].compat_offsets->next;
-		xt[af].compat_offsets->next = tmp;
-	} else {
-		xt[af].compat_offsets = tmp;
-		tmp->next = NULL;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(xt_compat_add_offset);
-
-void xt_compat_flush_offsets(u_int8_t af)
-{
-	struct compat_delta *tmp, *next;
-
-	if (xt[af].compat_offsets) {
-		for (tmp = xt[af].compat_offsets; tmp; tmp = next) {
-			next = tmp->next;
-			kfree(tmp);
-		}
-		xt[af].compat_offsets = NULL;
-	}
-}
-EXPORT_SYMBOL_GPL(xt_compat_flush_offsets);
-
-short xt_compat_calc_jump(u_int8_t af, unsigned int offset)
-{
-	struct compat_delta *tmp;
-	short delta;
-
-	for (tmp = xt[af].compat_offsets, delta = 0; tmp; tmp = tmp->next)
-		if (tmp->offset < offset)
-			delta += tmp->delta;
-	return delta;
-}
-EXPORT_SYMBOL_GPL(xt_compat_calc_jump);
-
-int xt_compat_match_offset(const struct xt_match *match)
-{
-	u_int16_t csize = match->compatsize ? : match->matchsize;
-	return XT_ALIGN(match->matchsize) - COMPAT_XT_ALIGN(csize);
-}
-EXPORT_SYMBOL_GPL(xt_compat_match_offset);
-
-int xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
-			      unsigned int *size)
-{
-	const struct xt_match *match = m->u.kernel.match;
-	struct compat_xt_entry_match *cm = (struct compat_xt_entry_match *)m;
-	int pad, off = xt_compat_match_offset(match);
-	u_int16_t msize = cm->u.user.match_size;
-
-	m = *dstptr;
-	memcpy(m, cm, sizeof(*cm));
-	if (match->compat_from_user)
-		match->compat_from_user(m->data, cm->data);
-	else
-		memcpy(m->data, cm->data, msize - sizeof(*cm));
-	pad = XT_ALIGN(match->matchsize) - match->matchsize;
-	if (pad > 0)
-		memset(m->data + match->matchsize, 0, pad);
-
-	msize += off;
-	m->u.user.match_size = msize;
-
-	*size += off;
-	*dstptr += msize;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(xt_compat_match_from_user);
-
-int xt_compat_match_to_user(const struct xt_entry_match *m,
-			    void __user **dstptr, unsigned int *size)
-{
-	const struct xt_match *match = m->u.kernel.match;
-	struct compat_xt_entry_match __user *cm = *dstptr;
-	int off = xt_compat_match_offset(match);
-	u_int16_t msize = m->u.user.match_size - off;
-
-	if (copy_to_user(cm, m, sizeof(*cm)) ||
-	    put_user(msize, &cm->u.user.match_size) ||
-	    copy_to_user(cm->u.user.name, m->u.kernel.match->name,
-			 strlen(m->u.kernel.match->name) + 1))
-		return -EFAULT;
-
-	if (match->compat_to_user) {
-		if (match->compat_to_user((void __user *)cm->data, m->data))
-			return -EFAULT;
-	} else {
-		if (copy_to_user(cm->data, m->data, msize - sizeof(*cm)))
-			return -EFAULT;
-	}
-
-	*size -= off;
-	*dstptr += msize;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
-#endif /* CONFIG_COMPAT */
-
 int xt_check_target(struct xt_tgchk_param *par,
 		    unsigned int size, u_int8_t proto, bool inv_proto,
 		    bool check_pad)
@@ -587,83 +465,6 @@ int xt_check_target(struct xt_tgchk_param *par,
 }
 EXPORT_SYMBOL_GPL(xt_check_target);
 
-#ifdef CONFIG_COMPAT
-int xt_compat_target_offset(const struct xt_target *target)
-{
-	u_int16_t csize = target->compatsize ? : target->targetsize;
-	return XT_ALIGN(target->targetsize) - COMPAT_XT_ALIGN(csize);
-}
-EXPORT_SYMBOL_GPL(xt_compat_target_offset);
-
-void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
-				unsigned int *size)
-{
-	const struct xt_target *target = t->u.kernel.target;
-	struct compat_xt_entry_target *ct = (struct compat_xt_entry_target *)t;
-	int pad, off = xt_compat_target_offset(target);
-	u_int16_t tsize = ct->u.user.target_size;
-
-	t = *dstptr;
-	memcpy(t, ct, sizeof(*ct));
-	if (target->compat_from_user)
-		target->compat_from_user(t->data, ct->data);
-	else
-		memcpy(t->data, ct->data, tsize - sizeof(*ct));
-	pad = XT_ALIGN(target->targetsize) - target->targetsize;
-	if (pad > 0)
-		memset(t->data + target->targetsize, 0, pad);
-
-	tsize += off;
-	t->u.user.target_size = tsize;
-
-	*size += off;
-	*dstptr += tsize;
-}
-EXPORT_SYMBOL_GPL(xt_compat_target_from_user);
-
-int xt_compat_target_to_user(const struct xt_entry_target *t,
-			     void __user **dstptr, unsigned int *size)
-{
-	const struct xt_target *target = t->u.kernel.target;
-	struct compat_xt_entry_target __user *ct = *dstptr;
-	int off = xt_compat_target_offset(target);
-	u_int16_t tsize = t->u.user.target_size - off;
-
-	if (copy_to_user(ct, t, sizeof(*ct)) ||
-	    put_user(tsize, &ct->u.user.target_size) ||
-	    copy_to_user(ct->u.user.name, t->u.kernel.target->name,
-			 strlen(t->u.kernel.target->name) + 1))
-		return -EFAULT;
-
-	if (target->compat_to_user) {
-		if (target->compat_to_user((void __user *)ct->data, t->data))
-			return -EFAULT;
-	} else {
-		if (copy_to_user(ct->data, t->data, tsize - sizeof(*ct)))
-			return -EFAULT;
-	}
-
-	*size -= off;
-	*dstptr += tsize;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(xt_compat_target_to_user);
-#endif
-
-#ifdef CONFIG_COMPAT
-void xt_compat_lock(u_int8_t af)
-{
-	mutex_lock(&xt[af].compat_mutex);
-}
-EXPORT_SYMBOL_GPL(xt_compat_lock);
-
-void xt_compat_unlock(u_int8_t af)
-{
-	mutex_unlock(&xt[af].compat_mutex);
-}
-EXPORT_SYMBOL_GPL(xt_compat_unlock);
-#endif
-
 #ifdef CONFIG_PROC_FS
 struct xt_names_priv {
 	struct seq_net_private p;
@@ -1806,10 +1607,6 @@ static int __init xt_init(void)
 
 	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
 		mutex_init(&xt[i].mutex);
-#ifdef CONFIG_COMPAT
-		mutex_init(&xt[i].compat_mutex);
-		xt[i].compat_offsets = NULL;
-#endif
 		INIT_LIST_HEAD(&xt[i].target);
 		INIT_LIST_HEAD(&xt[i].match);
 	}
-- 
1.6.3.3

