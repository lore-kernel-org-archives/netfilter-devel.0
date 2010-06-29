From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 15/56] netfilter: xtables: add xt_quota revision 3
Date: Tue, 29 Jun 2010 10:42:55 +0200
Message-ID: <1277801017-30600-16-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44264 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab0F2In4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:43:56 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The quota match has been extended in Xtables-addons for a while, whereby
it gained packet counting, upcounting support, named counters and
procfs-based read/write support. Its anonymous counters will be used for
traditional per-rule counters.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/xt_quota.h |   19 +++-
 net/netfilter/xt_quota.c           |  243 ++++++++++++++++++++++++++++++++++--
 2 files changed, 248 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
index 8dc89df..f14e36d 100644
--- a/include/linux/netfilter/xt_quota.h
+++ b/include/linux/netfilter/xt_quota.h
@@ -2,9 +2,11 @@
 #define _XT_QUOTA_H
 
 enum xt_quota_flags {
-	XT_QUOTA_INVERT		= 0x1,
+	XT_QUOTA_INVERT = 1 << 0,
+	XT_QUOTA_GROW   = 1 << 1,
+	XT_QUOTA_PACKET = 1 << 2,
+	XT_QUOTA_MASK   = 0x7,
 };
-#define XT_QUOTA_MASK		0x1
 
 struct xt_quota_priv;
 
@@ -17,4 +19,17 @@ struct xt_quota_info {
 	struct xt_quota_priv	*master;
 };
 
+struct xt_quota_counter;
+
+struct xt_quota_mtinfo3 {
+	char name[15];
+	u_int8_t flags;
+
+	/* Comparison-invariant */
+	aligned_u64 quota;
+
+	/* Used internally by the kernel */
+	struct xt_quota_counter *master __attribute__((aligned(8)));
+};
+
 #endif /* _XT_QUOTA_H */
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index b4f7dfe..d62b35d 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -3,9 +3,12 @@
  *
  * Sam Johnston <samj@samj.net>
  */
+#include <linux/list.h>
+#include <linux/proc_fs.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <asm/atomic.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_quota.h>
@@ -14,14 +17,207 @@ struct xt_quota_priv {
 	uint64_t quota;
 };
 
+struct xt_quota_counter {
+	u_int64_t quota;
+	spinlock_t lock;
+	struct list_head list;
+	atomic_t ref;
+	char name[sizeof(((struct xt_quota_mtinfo3 *)NULL)->name)];
+	struct proc_dir_entry *procfs_entry;
+};
+
 MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
 MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
-MODULE_DESCRIPTION("Xtables: countdown quota match");
+MODULE_DESCRIPTION("Xtables: counter match");
 MODULE_ALIAS("ipt_quota");
 MODULE_ALIAS("ip6t_quota");
 
 static DEFINE_SPINLOCK(quota_lock);
 
+static LIST_HEAD(counter_list);
+static DEFINE_SPINLOCK(counter_list_lock);
+
+#ifdef CONFIG_PROC_FS
+static struct proc_dir_entry *proc_xt_quota;
+static unsigned int quota_list_perms = S_IRUGO | S_IWUSR;
+static unsigned int quota_list_uid;
+static unsigned int quota_list_gid;
+module_param_named(perms, quota_list_perms, uint, S_IRUGO | S_IWUSR);
+module_param_named(uid, quota_list_uid, uint, S_IRUGO | S_IWUSR);
+module_param_named(gid, quota_list_gid, uint, S_IRUGO | S_IWUSR);
+
+static int quota_proc_read(char *page, char **start, off_t offset,
+			   int count, int *eof, void *data)
+{
+	struct xt_quota_counter *e = data;
+	int ret;
+
+	spin_lock_bh(&e->lock);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", e->quota);
+	spin_unlock_bh(&e->lock);
+	return ret;
+}
+
+static int quota_proc_write(struct file *file, const char __user *input,
+			    unsigned long size, void *data)
+{
+	struct xt_quota_counter *e = data;
+	char buf[sizeof("18446744073709551616")];
+
+	if (size > sizeof(buf))
+		size = sizeof(buf);
+	if (copy_from_user(buf, input, size) != 0)
+		return -EFAULT;
+	buf[sizeof(buf)-1] = '\0';
+
+	spin_lock_bh(&e->lock);
+	e->quota = simple_strtoull(buf, NULL, 0);
+	spin_unlock_bh(&e->lock);
+	return size;
+}
+#endif
+
+static struct xt_quota_counter *
+q3_new_counter(const struct xt_quota_mtinfo3 *q, bool anon)
+{
+	struct xt_quota_counter *e;
+	unsigned int size;
+
+	/* Do not need all the procfs things for anonymous counters. */
+	size = anon ? offsetof(typeof(*e), list) : sizeof(*e);
+	e = kmalloc(size, GFP_KERNEL);
+	if (e == NULL)
+		return NULL;
+
+	e->quota = q->quota;
+	spin_lock_init(&e->lock);
+	if (!anon) {
+		INIT_LIST_HEAD(&e->list);
+		atomic_set(&e->ref, 1);
+		strncpy(e->name, q->name, sizeof(e->name));
+	}
+	return e;
+}
+
+/**
+ * q3_get_counter - get ref to counter or create new
+ * @name:	name of counter
+ */
+static struct xt_quota_counter *
+q3_get_counter(const struct xt_quota_mtinfo3 *q)
+{
+	struct proc_dir_entry *p;
+	struct xt_quota_counter *e;
+
+	if (*q->name == '\0')
+		return q3_new_counter(q, true);
+
+#ifdef CONFIG_PROC_FS
+	spin_lock_bh(&counter_list_lock);
+	list_for_each_entry(e, &counter_list, list)
+		if (strcmp(e->name, q->name) == 0) {
+			atomic_inc(&e->ref);
+			spin_unlock_bh(&counter_list_lock);
+			return e;
+		}
+
+	e = q3_new_counter(q, false);
+	if (e == NULL)
+		goto out;
+
+	p = e->procfs_entry = create_proc_entry(e->name, quota_list_perms,
+						proc_xt_quota);
+	if (p == NULL || IS_ERR(p))
+		goto out;
+
+	p->data         = e;
+	p->read_proc    = quota_proc_read;
+	p->write_proc   = quota_proc_write;
+	p->uid          = quota_list_uid;
+	p->gid          = quota_list_gid;
+	list_add_tail(&e->list, &counter_list);
+	spin_unlock_bh(&counter_list_lock);
+	return e;
+
+ out:
+	spin_unlock_bh(&counter_list_lock);
+	kfree(e);
+	return NULL;
+#endif
+}
+
+static int quota_mt3_check(const struct xt_mtchk_param *par)
+{
+	struct xt_quota_mtinfo3 *q = par->matchinfo;
+
+	if (q->flags & ~XT_QUOTA_MASK)
+		return -EINVAL;
+
+	q->name[sizeof(q->name)-1] = '\0';
+	if (*q->name == '.' || strchr(q->name, '/') != NULL) {
+		pr_err("xt_quota.3: illegal name\n");
+		return -EINVAL;
+	}
+
+	q->master = q3_get_counter(q);
+	if (q->master == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void quota_mt3_destroy(const struct xt_mtdtor_param *par)
+{
+	struct xt_quota_mtinfo3 *q = par->matchinfo;
+	struct xt_quota_counter *e = q->master;
+
+	if (*q->name == '\0') {
+		/* anon counter */
+		kfree(e);
+		return;
+	}
+#ifdef CONFIG_PROC_FS
+	spin_lock_bh(&counter_list_lock);
+	if (!atomic_dec_and_test(&e->ref)) {
+		spin_unlock_bh(&counter_list_lock);
+		return;
+	}
+
+	list_del(&e->list);
+	remove_proc_entry(e->name, proc_xt_quota);
+	spin_unlock_bh(&counter_list_lock);
+	kfree(e);
+#endif /* CONFIG_PROC_FS */
+}
+
+static bool
+quota_mt3(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	struct xt_quota_mtinfo3 *q = (void *)par->matchinfo;
+	struct xt_quota_counter *e = q->master;
+	bool ret = q->flags & XT_QUOTA_INVERT;
+
+	spin_lock_bh(&e->lock);
+	if (q->flags & XT_QUOTA_GROW) {
+		e->quota += (q->flags & XT_QUOTA_PACKET) ? 1 : skb->len;
+		q->quota = e->quota;
+		ret = true;
+	} else {
+		if (e->quota >= skb->len) {
+			e->quota -= (q->flags & XT_QUOTA_PACKET) ? 1 : skb->len;
+			ret = !ret;
+		} else {
+			/* we do not allow even small packets from now on */
+			e->quota = 0;
+		}
+		q->quota = e->quota;
+	}
+	spin_unlock_bh(&e->lock);
+	return ret;
+}
+
+
 static bool
 quota_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
@@ -66,25 +262,48 @@ static void quota_mt_destroy(const struct xt_mtdtor_param *par)
 	kfree(q->master);
 }
 
-static struct xt_match quota_mt_reg __read_mostly = {
-	.name       = "quota",
-	.revision   = 0,
-	.family     = NFPROTO_UNSPEC,
-	.match      = quota_mt,
-	.checkentry = quota_mt_check,
-	.destroy    = quota_mt_destroy,
-	.matchsize  = sizeof(struct xt_quota_info),
-	.me         = THIS_MODULE,
+static struct xt_match quota_mt_reg[] __read_mostly = {
+	{
+		.name       = "quota",
+		.revision   = 0,
+		.family     = NFPROTO_UNSPEC,
+		.match      = quota_mt,
+		.checkentry = quota_mt_check,
+		.destroy    = quota_mt_destroy,
+		.matchsize  = sizeof(struct xt_quota_info),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "quota",
+		.revision   = 3,
+		.family     = NFPROTO_UNSPEC,
+		.checkentry = quota_mt3_check,
+		.match      = quota_mt3,
+		.destroy    = quota_mt3_destroy,
+		.matchsize  = sizeof(struct xt_quota_mtinfo3),
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init quota_mt_init(void)
 {
-	return xt_register_match(&quota_mt_reg);
+	int ret;
+
+	/* to be resolved in next patch */
+	proc_xt_quota = proc_mkdir("xt_quota", init_net.proc_net);
+	if (proc_xt_quota == NULL)
+		return -ENOMEM;
+
+	ret = xt_register_matches(quota_mt_reg, ARRAY_SIZE(quota_mt_reg));
+	if (ret < 0)
+		remove_proc_entry("xt_quota", init_net.proc_net);
+	return ret;
 }
 
 static void __exit quota_mt_exit(void)
 {
-	xt_unregister_match(&quota_mt_reg);
+	xt_unregister_matches(quota_mt_reg, ARRAY_SIZE(quota_mt_reg));
+	remove_proc_entry("xt_quota", init_net.proc_net);
 }
 
 module_init(quota_mt_init);
-- 
1.7.1

