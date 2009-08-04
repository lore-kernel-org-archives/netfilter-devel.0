From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 061/103] netfilter: xtables: add xt_quota revision 3
Date: Tue,  4 Aug 2009 09:25:45 +0200
Message-ID: <1249370787-17583-62-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56944 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592AbZHDH1j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:39 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The quota match has been extended in an out-of-tree project, whereby
it gained packet counting, upcounting support and procfs-based
read/write support.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/xt_quota.h |   19 +++-
 net/netfilter/xt_quota.c           |  231 ++++++++++++++++++++++++++++++++++--
 2 files changed, 236 insertions(+), 14 deletions(-)

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
index 0de9fcf..33ce76a 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -3,8 +3,11 @@
  *
  * Sam Johnston <samj@samj.net>
  */
+#include <linux/list.h>
+#include <linux/proc_fs.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
+#include <asm/atomic.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_quota.h>
@@ -13,14 +16,206 @@ struct xt_quota_priv {
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
+static struct proc_dir_entry *proc_xt_quota;
+static unsigned int quota_list_perms = S_IRUGO | S_IWUSR;
+static unsigned int quota_list_uid;
+static unsigned int quota_list_gid;
+module_param_named(perms, quota_list_perms, uint, S_IRUGO | S_IWUSR);
+module_param_named(uid, quota_list_uid, uint, S_IRUGO | S_IWUSR);
+module_param_named(gid, quota_list_gid, uint, S_IRUGO | S_IWUSR);
+
+static int quota_proc_read(char *page, char **start, off_t offset,
+                           int count, int *eof, void *data)
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
+                            unsigned long size, void *data)
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
+	                      proc_xt_quota);
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
+}
+
+static bool quota_mt3_check(const struct xt_mtchk_param *par)
+{
+	struct xt_quota_mtinfo3 *q = par->matchinfo;
+
+	if (q->flags & ~XT_QUOTA_MASK)
+		return false;
+
+	q->name[sizeof(q->name)-1] = '\0';
+	if (*q->name == '.' || strchr(q->name, '/') != NULL) {
+		printk(KERN_ERR "xt_quota<%u>: illegal name\n",
+		       par->match->revision);
+		return false;
+	}
+
+	q->master = q3_get_counter(q);
+	if (q->master == NULL) {
+		printk(KERN_ERR "xt_quota<%u>: memory alloc failure\n",
+		       par->match->revision);
+		return false;
+	}
+
+	return true;
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
+
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
@@ -65,25 +260,37 @@ static void quota_mt_destroy(const struct xt_mtdtor_param *par)
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
+	return xt_register_matches(quota_mt_reg, ARRAY_SIZE(quota_mt_reg));
 }
 
 static void __exit quota_mt_exit(void)
 {
-	xt_unregister_match(&quota_mt_reg);
+	xt_unregister_matches(quota_mt_reg, ARRAY_SIZE(quota_mt_reg));
 }
 
 module_init(quota_mt_init);
-- 
1.6.3.3

