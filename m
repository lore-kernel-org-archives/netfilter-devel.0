From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 04/13] [NETFILTER]: xt_recent: make old proc interface configurable
Date: Wed, 16 Apr 2008 17:30:56 +0200
Message-ID: <7d502c6a4287e43b9b2bc58d00bd13c1c57b6031.1208359825.git.jengelh@computergmbh.de>
References: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38083 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586AbYDPPbH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:31:07 -0400
In-Reply-To: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
References: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 net/netfilter/Kconfig     |    7 +++++++
 net/netfilter/xt_recent.c |   18 +++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 292269d..ccfa95e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -732,6 +732,13 @@ config NETFILTER_XT_MATCH_RECENT
 	Short options are available by using 'iptables -m recent -h'
 	Official Website: <http://snowman.net/projects/ipt_recent/>
 
+config NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
+	bool 'Enable obsolete /proc/net/ipt_recent'
+	depends on NETFILTER_XT_MATCH_RECENT && PROC_FS
+	---help---
+	This option enables the old /proc/net/ipt_recent interface,
+	which has been obsoleted by /proc/net/xt_recent.
+
 config NETFILTER_XT_MATCH_SCTP
 	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
 	depends on NETFILTER_XTABLES && EXPERIMENTAL
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 382691d..43d9926 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -31,6 +31,9 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_recent.h>
+#ifdef CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
+#	define OLDPROC 1
+#endif
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
@@ -86,7 +89,10 @@ static DEFINE_SPINLOCK(recent_lock);
 static DEFINE_MUTEX(recent_mutex);
 
 #ifdef CONFIG_PROC_FS
-static struct proc_dir_entry *proc_old_dir, *recent_proc_dir;
+#ifdef OLDPROC
+static struct proc_dir_entry *proc_old_dir;
+#endif
+static struct proc_dir_entry *recent_proc_dir;
 static const struct file_operations recent_old_fops, recent_mt_fops;
 #endif
 
@@ -327,6 +333,7 @@ recent_mt_check(const char *tablename, const void *ip,
 		kfree(t);
 		goto out;
 	}
+#ifdef OLDPROC
 	t->proc_old = proc_create(t->name, ip_list_perms, proc_old_dir,
 		      &recent_old_fops);
 	if (t->proc_old == NULL) {
@@ -337,6 +344,7 @@ recent_mt_check(const char *tablename, const void *ip,
 	t->proc_old->uid   = ip_list_uid;
 	t->proc_old->gid   = ip_list_gid;
 	t->proc_old->data  = t;
+#endif
 	t->proc->uid       = ip_list_uid;
 	t->proc->gid       = ip_list_gid;
 	t->proc->data      = t;
@@ -363,7 +371,9 @@ static void recent_mt_destroy(const struct xt_match *match, void *matchinfo)
 		spin_unlock_bh(&recent_lock);
 		recent_table_flush(t);
 #ifdef CONFIG_PROC_FS
+#ifdef OLDPROC
 		remove_proc_entry(t->name, proc_old_dir);
+#endif
 		remove_proc_entry(t->name, recent_proc_dir);
 #endif
 		kfree(t);
@@ -456,6 +466,7 @@ static int recent_seq_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+#ifdef OLDPROC
 static int recent_old_seq_open(struct inode *inode, struct file *filp)
 {
 	static bool warned_of_old;
@@ -532,6 +543,7 @@ static const struct file_operations recent_old_fops = {
 	.release	= seq_release_private,
 	.owner		= THIS_MODULE,
 };
+#endif
 
 static ssize_t
 recent_mt_proc_write(struct file *file, const char __user *input,
@@ -655,6 +667,7 @@ static int __init recent_mt_init(void)
 		xt_unregister_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg));
 		err = -ENOMEM;
 	}
+#ifdef OLDPROC
 	if (err < 0)
 		return err;
 	proc_old_dir = proc_mkdir("ipt_recent", init_net.proc_net);
@@ -664,6 +677,7 @@ static int __init recent_mt_init(void)
 		err = -ENOMEM;
 	}
 #endif
+#endif
 	return err;
 }
 
@@ -672,7 +686,9 @@ static void __exit recent_mt_exit(void)
 	BUG_ON(!list_empty(&tables));
 	xt_unregister_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg));
 #ifdef CONFIG_PROC_FS
+#ifdef OLDPROC
 	remove_proc_entry("ipt_recent", init_net.proc_net);
+#endif
 	remove_proc_entry("xt_recent", init_net.proc_net);
 #endif
 }
-- 
1.5.5

