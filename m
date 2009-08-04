From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 008/103] netfilter: xtables: remove obsolete /proc/net/ipt_recent
Date: Tue,  4 Aug 2009 09:24:52 +0200
Message-ID: <1249370787-17583-9-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50617 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525AbZHDH0l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:41 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The directory has been superseded by /proc/net/xt_recent
(v2.6.27-rc8-889-g079aa88).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Documentation/feature-removal-schedule.txt |    3 -
 net/netfilter/Kconfig                      |    7 --
 net/netfilter/xt_recent.c                  |  109 ----------------------------
 3 files changed, 0 insertions(+), 119 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 5556d23..420ea83 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -238,9 +238,6 @@ What (Why):
 	- "forwarding" header files like ipt_mac.h in
 	  include/linux/netfilter_ipv4/ and include/linux/netfilter_ipv6/
 
-	- xt_recent: the old ipt_recent proc dir
-	  (superseded by /proc/net/xt_recent)
-
 When:	January 2009 or Linux 2.7.0, whichever comes first
 Why:	Superseded by newer revisions or modules
 Who:	Jan Engelhardt <jengelh@computergmbh.de>
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 634d14a..773c360 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -811,13 +811,6 @@ config NETFILTER_XT_MATCH_RECENT
 	Short options are available by using 'iptables -m recent -h'
 	Official Website: <http://snowman.net/projects/ipt_recent/>
 
-config NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
-	bool 'Enable obsolete /proc/net/ipt_recent'
-	depends on NETFILTER_XT_MATCH_RECENT && PROC_FS
-	---help---
-	This option enables the old /proc/net/ipt_recent interface,
-	which has been obsoleted by /proc/net/xt_recent.
-
 config NETFILTER_XT_MATCH_SCTP
 	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
 	depends on EXPERIMENTAL
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index eb0ceb8..350bede 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -83,9 +83,6 @@ static DEFINE_SPINLOCK(recent_lock);
 static DEFINE_MUTEX(recent_mutex);
 
 #ifdef CONFIG_PROC_FS
-#ifdef CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
-static struct proc_dir_entry *proc_old_dir;
-#endif
 static struct proc_dir_entry *recent_proc_dir;
 static const struct file_operations recent_old_fops, recent_mt_fops;
 #endif
@@ -326,17 +323,6 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 	}
 	pde->uid = ip_list_uid;
 	pde->gid = ip_list_gid;
-#ifdef CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
-	pde = proc_create_data(t->name, ip_list_perms, proc_old_dir,
-		      &recent_old_fops, t);
-	if (pde == NULL) {
-		remove_proc_entry(t->name, proc_old_dir);
-		kfree(t);
-		goto out;
-	}
-	pde->uid = ip_list_uid;
-	pde->gid = ip_list_gid;
-#endif
 #endif
 	spin_lock_bh(&recent_lock);
 	list_add_tail(&t->list, &tables);
@@ -359,9 +345,6 @@ static void recent_mt_destroy(const struct xt_mtdtor_param *par)
 		list_del(&t->list);
 		spin_unlock_bh(&recent_lock);
 #ifdef CONFIG_PROC_FS
-#ifdef CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
-		remove_proc_entry(t->name, proc_old_dir);
-#endif
 		remove_proc_entry(t->name, recent_proc_dir);
 #endif
 		recent_table_flush(t);
@@ -453,85 +436,6 @@ static int recent_seq_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-#ifdef CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
-static int recent_old_seq_open(struct inode *inode, struct file *filp)
-{
-	static bool warned_of_old;
-
-	if (unlikely(!warned_of_old)) {
-		printk(KERN_INFO KBUILD_MODNAME ": Use of /proc/net/ipt_recent"
-		       " is deprecated; use /proc/net/xt_recent.\n");
-		warned_of_old = true;
-	}
-	return recent_seq_open(inode, filp);
-}
-
-static ssize_t recent_old_proc_write(struct file *file,
-				     const char __user *input,
-				     size_t size, loff_t *loff)
-{
-	const struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
-	struct recent_table *t = pde->data;
-	struct recent_entry *e;
-	char buf[sizeof("+255.255.255.255")], *c = buf;
-	union nf_inet_addr addr = {};
-	int add;
-
-	if (size > sizeof(buf))
-		size = sizeof(buf);
-	if (copy_from_user(buf, input, size))
-		return -EFAULT;
-
-	while (isspace(*c))
-		c++;
-
-	if (size - (c - buf) < 5)
-		return c - buf;
-	if (!strncmp(c, "clear", 5)) {
-		c += 5;
-		spin_lock_bh(&recent_lock);
-		recent_table_flush(t);
-		spin_unlock_bh(&recent_lock);
-		return c - buf;
-	}
-
-	switch (*c) {
-	case '-':
-		add = 0;
-		c++;
-		break;
-	case '+':
-		c++;
-	default:
-		add = 1;
-		break;
-	}
-	addr.ip = in_aton(c);
-
-	spin_lock_bh(&recent_lock);
-	e = recent_entry_lookup(t, &addr, NFPROTO_IPV4, 0);
-	if (e == NULL) {
-		if (add)
-			recent_entry_init(t, &addr, NFPROTO_IPV4, 0);
-	} else {
-		if (add)
-			recent_entry_update(t, e);
-		else
-			recent_entry_remove(t, e);
-	}
-	spin_unlock_bh(&recent_lock);
-	return size;
-}
-
-static const struct file_operations recent_old_fops = {
-	.open		= recent_old_seq_open,
-	.read		= seq_read,
-	.write		= recent_old_proc_write,
-	.release	= seq_release_private,
-	.owner		= THIS_MODULE,
-};
-#endif
-
 static ssize_t
 recent_mt_proc_write(struct file *file, const char __user *input,
 		     size_t size, loff_t *loff)
@@ -654,16 +558,6 @@ static int __init recent_mt_init(void)
 		xt_unregister_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg));
 		err = -ENOMEM;
 	}
-#ifdef CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
-	if (err < 0)
-		return err;
-	proc_old_dir = proc_mkdir("ipt_recent", init_net.proc_net);
-	if (proc_old_dir == NULL) {
-		remove_proc_entry("xt_recent", init_net.proc_net);
-		xt_unregister_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg));
-		err = -ENOMEM;
-	}
-#endif
 #endif
 	return err;
 }
@@ -673,9 +567,6 @@ static void __exit recent_mt_exit(void)
 	BUG_ON(!list_empty(&tables));
 	xt_unregister_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg));
 #ifdef CONFIG_PROC_FS
-#ifdef CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
-	remove_proc_entry("ipt_recent", init_net.proc_net);
-#endif
 	remove_proc_entry("xt_recent", init_net.proc_net);
 #endif
 }
-- 
1.6.3.3

