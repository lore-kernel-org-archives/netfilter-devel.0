From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 19/56] netfilter: xtables2: xt2->xt1 translation - GET_ENTRIES support
Date: Tue, 29 Jun 2010 10:42:59 +0200
Message-ID: <1277801017-30600-20-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44277 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab0F2IoB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:01 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With this, `ip6tables -L` can display xt2 tables (if they are
representable in the old format, otherwise returns -EIO).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   38 +++++++++-
 include/linux/netfilter/xt_quota.h |   11 +++
 net/ipv6/netfilter/ip6_tables.c    |   13 +++-
 net/netfilter/x_tables.c           |    1 +
 net/netfilter/xt1_support.c        |  106 +++++++++++++++++++++++---
 net/netfilter/xt1_translat.c       |  146 ++++++++++++++++++++++++++++++++++++
 net/netfilter/xt_quota.c           |    9 --
 7 files changed, 301 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 9e9876f..3d33a06 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -548,6 +548,7 @@ enum {
  * @underflow:		base chain policy (rule)
  * @net:		encompassing netns. To be set by xt2_table_new caller.
  * @owner:		encompassing module
+ * @xt1_lock:		lock for updating chains' xt1_offset
  */
 struct xt2_table {
 	struct list_head chain_list;
@@ -563,6 +564,8 @@ struct xt2_table {
 	const struct xt2_rule *underflow[NF_INET_NUMHOOKS];
 	struct net *net;
 	struct module *owner;
+
+	struct mutex xt1_lock;
 };
 
 /**
@@ -719,10 +722,19 @@ extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
 
 extern struct xt2_chain *xts_lookup_chain(const struct xt2_table *,
 					  unsigned int);
-extern unsigned int xts_blob_prep_table(const struct xt2_table *,
+extern const struct xt2_entry_match *
+xts_rule_quota_ptr(const struct xt2_rule *);
+extern void xts_rule_get_quota(const struct xt2_entry_match *,
+			       uint64_t *, uint64_t *);
+extern unsigned int xts_blob_prep_table(struct xt2_table *,
 					const struct xt1_xlat_info *,
 					unsigned int *, unsigned int *,
 					unsigned int *);
+extern int xts_starget_to_xt1(void __user **, int *, unsigned int *,
+			      const struct xt2_entry_target *,
+			      const struct xt1_xlat_info *);
+extern int xts_target_to_xt1(void __user **, int *, unsigned int *,
+			     const struct xt2_entry_target *);
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
 extern int xt2_rule_add_match(struct xt2_rule *, const char *, uint8_t,
@@ -746,6 +758,30 @@ extern unsigned int xt2_do_table(struct sk_buff *, unsigned int,
 				 const struct net_device *,
 				 const struct xt2_table *);
 
+/**
+ * @pptr:	user pointer
+ * @rem:	remaining bytes in user area
+ * @data:	source data
+ * @dsize:	size of @data
+ * @z:		bytes written so far
+ *
+ * Copy @data to userspace, advance pointer and offset,
+ * reduce remaining counter.
+ */
+static inline int
+xts_copy_to_user(void __user **pptr, int *rem, const void *data,
+		 unsigned int dsize, unsigned int *z)
+{
+	if (*rem < dsize)
+		return -ENOSPC;
+	if (copy_to_user(*pptr, data, dsize) != 0)
+		return -EFAULT;
+	*pptr += dsize;
+	*z    += dsize;
+	*rem  -= dsize;
+	return 0;
+}
+
 static inline bool xt2_builtin_chain(const struct xt2_chain *c)
 {
 	return *c->name == '\0';
diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
index f14e36d..7538cd2 100644
--- a/include/linux/netfilter/xt_quota.h
+++ b/include/linux/netfilter/xt_quota.h
@@ -32,4 +32,15 @@ struct xt_quota_mtinfo3 {
 	struct xt_quota_counter *master __attribute__((aligned(8)));
 };
 
+#ifdef __KERNEL__
+struct xt_quota_counter {
+	u_int64_t quota;
+	spinlock_t lock;
+	struct list_head list;
+	atomic_t ref;
+	char name[sizeof(((struct xt_quota_mtinfo3 *)NULL)->name)];
+	struct proc_dir_entry *procfs_entry;
+};
+#endif
+
 #endif /* _XT_QUOTA_H */
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d2d34b0..ddc0313 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1199,7 +1199,7 @@ static const struct xt1_xlat_info ip6t_xlat_info = {
 };
 
 static int ip6t2_get_info(void __user *uptr, int len,
-			  const struct xt2_table *table)
+			  struct xt2_table *table)
 {
 	struct ip6t_getinfo info = {
 		.valid_hooks = table->valid_hooks,
@@ -1291,6 +1291,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 {
 	int ret;
 	struct ip6t_get_entries get;
+	struct xt2_table *xt2_table;
 	struct xt_table *t;
 
 	if (*len < sizeof(get)) {
@@ -1305,6 +1306,16 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 		return -EINVAL;
 	}
 
+	xt2_table = xt2_table_lookup(net, get.name, NFPROTO_IPV6,
+				     XT2_KEEP_RCULOCK);
+	if (xt2_table != NULL) {
+		ret = ip6t2_table_to_xt1(uptr->entrytable, get.size,
+					 xt2_table, &ip6t_xlat_info);
+		rcu_read_unlock();
+		return ret;
+	}
+	rcu_read_unlock();
+
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (t && !IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index fcfa04e..f4794db 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1583,6 +1583,7 @@ struct xt2_table *xt2_table_new(void)
 		return NULL;
 
 	INIT_LIST_HEAD(&table->chain_list);
+	mutex_init(&table->xt1_lock);
 	return table;
 }
 EXPORT_SYMBOL_GPL(xt2_table_new);
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index 4b13f2f..af58cff 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/rcupdate.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_quota.h>
 
 /**
  * @table:	table to search in
@@ -42,7 +43,7 @@ EXPORT_SYMBOL_GPL(xts_lookup_chain);
  * Also used for the xt2->xt1 converter. Generalized matches run until the two
  * last quota matches.
  */
-static const struct xt2_entry_match *
+const struct xt2_entry_match *
 xts_rule_quota_ptr(const struct xt2_rule *rule)
 {
 	const struct xt2_entry_match *ematch;
@@ -63,6 +64,29 @@ xts_rule_quota_ptr(const struct xt2_rule *rule)
 		return NULL;
 	return ematch;
 }
+EXPORT_SYMBOL_GPL(xts_rule_quota_ptr);
+
+/**
+ * @ematch:	pointer to appropriate quota ematch (obtained from
+ * 		xt1_rule_quota_ptr)
+ */
+void xts_rule_get_quota(const struct xt2_entry_match *ematch,
+			uint64_t *bytes, uint64_t *pkts)
+{
+	const struct xt_quota_mtinfo3 *q;
+
+	/* Bytes */
+	q = ematch->data;
+	spin_lock_bh(&q->master->lock);
+	*bytes = q->master->quota;
+	spin_unlock_bh(&q->master->lock);
+	/* Packets */
+	q = list_entry(ematch->anchor.next, typeof(*ematch), anchor)->data;
+	spin_lock_bh(&q->master->lock);
+	*pkts = q->master->quota;
+	spin_unlock_bh(&q->master->lock);
+}
+EXPORT_SYMBOL_GPL(xts_rule_get_quota);
 
 static int
 xts_blob_prep_rule(const struct xt2_rule *rule, const struct xt1_xlat_info *io,
@@ -89,9 +113,10 @@ xts_blob_prep_rule(const struct xt2_rule *rule, const struct xt1_xlat_info *io,
 		return -EIO;
 
 	/* Do underflow assign first before @z is increased. */
-	for (h = 0; h < ARRAY_SIZE(table->underflow); ++h)
-		if (rule == table->underflow[h])
-			underflow[h] = z;
+	if (underflow != NULL)
+		for (h = 0; h < ARRAY_SIZE(table->underflow); ++h)
+			if (rule == table->underflow[h])
+				underflow[h] = z;
 
 	/* Subtracting, because it will already be added in the loop. */
 	z += io->entry_hdr_size - io->ematch_size - io->pmatch_size;
@@ -121,22 +146,25 @@ xts_blob_prep_rule(const struct xt2_rule *rule, const struct xt1_xlat_info *io,
  * loss of information.
  */
 unsigned int
-xts_blob_prep_table(const struct xt2_table *table,
-		    const struct xt1_xlat_info *io,
+xts_blob_prep_table(struct xt2_table *table, const struct xt1_xlat_info *io,
 		    unsigned int *hook_entry, unsigned int *underflow,
 		    unsigned int *entries_ptr)
 {
-	const struct xt2_chain *chain;
+	struct xt2_chain *chain;
 	const struct xt2_rule *rule;
 	unsigned int hook, entries = 0;
 	int z = 0;
 
 	rcu_read_lock();
 	list_for_each_entry(chain, &table->chain_list, anchor) {
-		for (hook = 0; hook < ARRAY_SIZE(table->entrypoint); ++hook)
-			if (table->entrypoint[hook] == chain)
-				hook_entry[hook] = z;
-
+		if (hook_entry != NULL)
+			for (hook = 0; hook < ARRAY_SIZE(table->entrypoint);
+			     ++hook)
+				if (table->entrypoint[hook] == chain)
+					hook_entry[hook] = z;
+
+		/* Caller needs to take xt1_lock if xt1_offset is needed. */
+		chain->xt1_offset = z;
 		if (!xt2_builtin_chain(chain)) {
 			z += io->entry_hdr_size + io->marker_size;
 			++entries;
@@ -153,9 +181,63 @@ xts_blob_prep_table(const struct xt2_table *table,
 
 	/* Table terminator */
 	z += io->entry_hdr_size + io->marker_size;
-	*entries_ptr = ++entries;
+	if (entries_ptr != NULL)
+		*entries_ptr = ++entries;
 	return z;
 }
 EXPORT_SYMBOL_GPL(xts_blob_prep_table);
 
+int xts_starget_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
+		       const struct xt2_entry_target *etarget,
+		       const struct xt1_xlat_info *io)
+{
+	struct xt_standard_target blob = {
+		.target.u.user = {
+			.target_size = io->standard_tgsize,
+			.revision    = 0,
+		},
+	};
+
+	strncpy(blob.target.u.user.name, XT_STANDARD_TARGET,
+		sizeof(blob.target.u.user.name));
+	if (etarget->ext == XT2_FINAL_VERDICT) {
+		if (etarget->verdict == XT_CONTINUE)
+			blob.verdict = *z + io->standard_tgsize;
+		else if (etarget->verdict == XT_RETURN)
+			blob.verdict = XT_RETURN;
+		else
+			blob.verdict = -etarget->verdict - 1;
+	} else if (etarget->ext == XT2_ACTION_GOTO) {
+		blob.verdict = etarget->r_goto->xt1_offset;
+	} else if (etarget->ext == XT2_ACTION_JUMP) {
+		blob.verdict = etarget->r_jump->xt1_offset;
+	} else {
+		return -EIO;
+	}
+	return xts_copy_to_user(user_ptr, len, &blob, io->standard_tgsize, z);
+}
+EXPORT_SYMBOL_GPL(xts_starget_to_xt1);
+
+int xts_target_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
+		      const struct xt2_entry_target *etarget)
+{
+	int ret;
+	struct xt_entry_target blob = {
+		.u.user = {
+			.target_size = sizeof(blob) +
+			               XT_ALIGN(etarget->ext->targetsize),
+			.revision    = etarget->ext->revision,
+		},
+	};
+
+	strncpy(blob.u.user.name, etarget->ext->name,
+		sizeof(blob.u.user.name));
+	ret = xts_copy_to_user(user_ptr, len, &blob, sizeof(blob), z);
+	if (ret < 0)
+		return ret;
+	return xts_copy_to_user(user_ptr, len, etarget->data,
+				XT_ALIGN(etarget->ext->targetsize), z);
+}
+EXPORT_SYMBOL_GPL(xts_target_to_xt1);
+
 MODULE_LICENSE("GPL");
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index 3d6892a..bff55fc 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -288,3 +288,149 @@ static int XTSUB2(table_to_xt2)(struct xt2_table *table, void *entry0,
 
 	return 0;
 }
+
+static int
+XTSUB2(marker_to_xt1)(void __user **user_pptr, int *len,
+		      const struct xt2_chain *chain, unsigned int *z)
+{
+	/*
+	 * Must write structs separately, or otherwise there is padding between
+	 * (compat_)xtsub_entry and xtsub_error_target.
+	 */
+	struct xtsub_error_target target = {
+		.target.u.user = {
+			.target_size = sizeof(target),
+			.name        = "ERROR",
+			.revision    = 0,
+		},
+	};
+	struct xtsub_entry entry = {
+		.target_offset = sizeof(entry),
+		.next_offset   = sizeof(entry) + sizeof(target),
+	};
+	int ret;
+
+	strncpy(target.errorname, chain->name,
+		min(sizeof(target.errorname), sizeof(chain->name)));
+	ret = xts_copy_to_user(user_pptr, len, &entry, sizeof(entry), z);
+	if (ret < 0)
+		return ret;
+	return xts_copy_to_user(user_pptr, len, &target, sizeof(target), z);
+}
+
+static int
+XTSUB2(rule_to_xt1)(void __user **user_ptr, int *len, unsigned int *z,
+		    const struct xt2_rule *rule,
+		    const struct xt1_xlat_info *io)
+{
+	const struct xt2_entry_match *ematch, *quota_ematch;
+	const struct xt2_entry_target *etarget;
+	struct xtsub_entry entry;
+	void __user *entry_uptr;
+	unsigned int z_start;
+	int ret;
+
+	quota_ematch = xts_rule_quota_ptr(rule);
+	if (quota_ematch == NULL)
+		return -EIO;
+
+	/* Must have exactly one target */
+	if (list_empty(&rule->target_list) ||
+	    rule->target_list.next->next != &rule->target_list)
+		return -EIO;
+
+	/* Entry master */
+	z_start = *z;
+	ematch = list_first_entry(&rule->match_list, typeof(*ematch), anchor);
+#ifdef XTSUB_NFPROTO_IPV6
+	if (strcmp(ematch->ext->name, "ipv6") != 0)
+		return -EIO;
+	memcpy(&entry.ipv6, ematch->data, sizeof(entry.ipv6));
+#endif
+	entry.comefrom = rule->chain->comefrom;
+	entry.nfcache  = 0;
+	xts_rule_get_quota(quota_ematch, &entry.counters.bcnt,
+			   &entry.counters.pcnt);
+
+	/* Remember offset for entry header for later update of offsets. */
+	entry_uptr = *user_ptr;
+	ret = xts_copy_to_user(user_ptr, len, &entry, sizeof(entry), z);
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry_continue(ematch, &rule->match_list, anchor) {
+		struct xt_entry_match blob;
+
+		if (ematch == quota_ematch)
+			break;
+
+		blob.u.match_size    = sizeof(blob) + ematch->dsize;
+		blob.u.user.revision = ematch->ext->revision;
+		strncpy(blob.u.user.name, ematch->ext->name,
+			sizeof(blob.u.user.name));
+		ret = xts_copy_to_user(user_ptr, len, &blob, sizeof(blob), z);
+		if (ret < 0)
+			return ret;
+		ret = xts_copy_to_user(user_ptr, len, ematch->data,
+				       ematch->dsize, z);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* target and next offsets are relative to the start of the entry. */
+	entry.target_offset = *z - z_start;
+
+	list_for_each_entry(etarget, &rule->target_list, anchor) {
+		ret = xt2_special_target(etarget->ext) ?
+		      xts_starget_to_xt1(user_ptr, len, z, etarget, io) :
+		      xts_target_to_xt1(user_ptr, len, z, etarget);
+		if (ret < 0)
+			return ret;
+	}
+
+	entry.next_offset = *z - z_start;
+	return copy_to_user(entry_uptr, &entry, sizeof(entry));
+}
+
+static int
+XTSUB2(table_to_xt1)(void __user *user_ptr, int len, struct xt2_table *table,
+		     const struct xt1_xlat_info *io)
+{
+	static const struct xt2_chain terminator = {.name = "ERROR"};
+	static const uint32_t filler = ~0U;
+	const struct xt2_rule *rule;
+	struct xt2_chain *chain;
+	unsigned int z = 0;
+	int i, ret;
+
+	for (i = 0; i <= len - sizeof(filler); i += sizeof(filler))
+		if (copy_to_user(user_ptr + i, &filler, sizeof(filler)))
+			return -EFAULT;
+
+	ret = mutex_lock_interruptible(&table->xt1_lock);
+	if (ret < 0)
+		return ret;
+
+	/* Calculate chain offsets. */
+	xts_blob_prep_table(table, io, NULL, NULL, NULL);
+
+	list_for_each_entry(chain, &table->chain_list, anchor) {
+		if (!xt2_builtin_chain(chain)) {
+			ret = XTSUB2(marker_to_xt1)(&user_ptr,
+						    &len, chain, &z);
+			if (ret < 0)
+				goto out;
+		}
+		list_for_each_entry(rule, &chain->rule_list, anchor) {
+			ret = XTSUB2(rule_to_xt1)(&user_ptr, &len, &z,
+						  rule, io);
+			if (ret < 0)
+				goto out;
+		}
+	}
+
+	ret = XTSUB2(marker_to_xt1)(&user_ptr, &len, &terminator, &z);
+ out:
+	mutex_unlock(&table->xt1_lock);
+	return ret;
+}
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index d62b35d..d82e287 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -17,15 +17,6 @@ struct xt_quota_priv {
 	uint64_t quota;
 };
 
-struct xt_quota_counter {
-	u_int64_t quota;
-	spinlock_t lock;
-	struct list_head list;
-	atomic_t ref;
-	char name[sizeof(((struct xt_quota_mtinfo3 *)NULL)->name)];
-	struct proc_dir_entry *procfs_entry;
-};
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
 MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
-- 
1.7.1

