From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] netfilter: xtables: inclusion of xt_condition
Date: Fri,  2 Apr 2010 15:23:17 +0200
Message-ID: <1270214599-22734-2-git-send-email-jengelh@medozas.de>
References: <1270214599-22734-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57516 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab0DBNXY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 09:23:24 -0400
In-Reply-To: <1270214599-22734-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_condition can be used by userspace to influence decisions in rules
by means of togglable variables without having to reload the entire
ruleset.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/Kbuild         |    1 +
 include/linux/netfilter/xt_condition.h |   14 ++
 net/netfilter/Kconfig                  |    8 +
 net/netfilter/Makefile                 |    1 +
 net/netfilter/xt_condition.c           |  243 ++++++++++++++++++++++++++++++++
 5 files changed, 267 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_condition.h
 create mode 100644 net/netfilter/xt_condition.c

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index a5a63e4..60bf164 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -18,6 +18,7 @@ header-y += xt_TCPMSS.h
 header-y += xt_TCPOPTSTRIP.h
 header-y += xt_TPROXY.h
 header-y += xt_comment.h
+header-y += xt_condition.h
 header-y += xt_connbytes.h
 header-y += xt_connlimit.h
 header-y += xt_connmark.h
diff --git a/include/linux/netfilter/xt_condition.h b/include/linux/netfilter/xt_condition.h
new file mode 100644
index 0000000..4faf3ca
--- /dev/null
+++ b/include/linux/netfilter/xt_condition.h
@@ -0,0 +1,14 @@
+#ifndef _XT_CONDITION_H
+#define _XT_CONDITION_H
+
+#include <linux/types.h>
+
+struct xt_condition_mtinfo {
+	char name[31];
+	__u8 invert;
+
+	/* Used internally by the kernel */
+	void *condvar __attribute__((aligned(8)));
+};
+
+#endif /* _XT_CONDITION_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 8055786..707d489 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -605,6 +605,14 @@ config NETFILTER_XT_MATCH_COMMENT
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_CONDITION
+	tristate '"condition" match support'
+	depends on NETFILTER_ADVANCED
+	depends on PROC_FS
+	---help---
+	This option allows you to match firewall rules against condition
+	variables stored in the /proc/net/nf_condition directory.
+
 config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
 	depends on NF_CONNTRACK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index cd31afe..bc5bb3f 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_CLUSTER) += xt_cluster.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_CONDITION) += xt_condition.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTES) += xt_connbytes.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNLIMIT) += xt_connlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) += xt_conntrack.o
diff --git a/net/netfilter/xt_condition.c b/net/netfilter/xt_condition.c
new file mode 100644
index 0000000..d3dcaa4
--- /dev/null
+++ b/net/netfilter/xt_condition.c
@@ -0,0 +1,243 @@
+/*
+ *	"condition" match extension for Xtables
+ *
+ *	Description: This module allows firewall rules to match using
+ *	condition variables available through procfs.
+ *
+ *	Authors:
+ *	Stephane Ouellette <ouellettes [at] videotron ca>, 2002-10-22
+ *	Massimiliano Hofer <max [at] nucleus it>, 2006-05-15
+ *
+ *	This program is free software; you can redistribute it and/or modify it
+ *	under the terms of the GNU General Public License; either version 2
+ *	or 3 of the License, as published by the Free Software Foundation.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/version.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_condition.h>
+#include <asm/uaccess.h>
+
+/* Defaults, these can be overridden on the module command-line. */
+static unsigned int condition_list_perms = S_IRUSR | S_IWUSR;
+static unsigned int condition_uid_perms;
+static unsigned int condition_gid_perms;
+
+MODULE_AUTHOR("Stephane Ouellette <ouellettes@videotron.ca>");
+MODULE_AUTHOR("Massimiliano Hofer <max@nucleus.it>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
+MODULE_DESCRIPTION("Allows rules to match against condition variables");
+MODULE_LICENSE("GPL");
+module_param(condition_list_perms, uint, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(condition_list_perms, "default permissions on /proc/net/nf_condition/* files");
+module_param(condition_uid_perms, uint, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(condition_uid_perms, "default user owner of /proc/net/nf_condition/* files");
+module_param(condition_gid_perms, uint, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(condition_gid_perms, "default group owner of /proc/net/nf_condition/* files");
+MODULE_ALIAS("ipt_condition");
+MODULE_ALIAS("ip6t_condition");
+
+struct condition_variable {
+	struct list_head list;
+	struct proc_dir_entry *status_proc;
+	unsigned int refcount;
+	bool enabled;
+};
+
+/* proc_lock is a user context only semaphore used for write access */
+/*           to the conditions' list.                               */
+static struct mutex proc_lock;
+
+static LIST_HEAD(conditions_list);
+static struct proc_dir_entry *proc_net_condition;
+
+static int condition_proc_read(char __user *buffer, char **start, off_t offset,
+			       int length, int *eof, void *data)
+{
+	const struct condition_variable *var = data;
+
+	buffer[0] = var->enabled ? '1' : '0';
+	buffer[1] = '\n';
+	if (length >= 2)
+		*eof = true;
+	return 2;
+}
+
+static int condition_proc_write(struct file *file, const char __user *buffer,
+				unsigned long length, void *data)
+{
+	struct condition_variable *var = data;
+	char newval;
+
+	if (length > 0) {
+		if (get_user(newval, buffer) != 0)
+			return -EFAULT;
+		/* Match only on the first character */
+		switch (newval) {
+		case '0':
+			var->enabled = false;
+			break;
+		case '1':
+			var->enabled = true;
+			break;
+		}
+	}
+	return length;
+}
+
+static bool
+condition_mt(const struct sk_buff *skb, const struct xt_match_param *par)
+{
+	const struct xt_condition_mtinfo *info = par->matchinfo;
+	const struct condition_variable *var   = info->condvar;
+	bool x;
+
+	rcu_read_lock();
+	x = rcu_dereference(var->enabled);
+	rcu_read_unlock();
+
+	return x ^ info->invert;
+}
+
+static int condition_mt_check(const struct xt_mtchk_param *par)
+{
+	struct xt_condition_mtinfo *info = par->matchinfo;
+	struct condition_variable *var;
+
+	/* Forbid certain names */
+	if (*info->name == '\0' || *info->name == '.' ||
+	    info->name[sizeof(info->name)-1] != '\0' ||
+	    memchr(info->name, '/', sizeof(info->name)) != NULL) {
+		pr_info("name not allowed or too long: \"%.*s\"\n",
+			(unsigned int)sizeof(info->name), info->name);
+		return -EINVAL;
+	}
+	/*
+	 * Let's acquire the lock, check for the condition and add it
+	 * or increase the reference counter.
+	 */
+	if (mutex_lock_interruptible(&proc_lock) != 0)
+		return -EINTR;
+
+	list_for_each_entry(var, &conditions_list, list) {
+		if (strcmp(info->name, var->status_proc->name) == 0) {
+			++var->refcount;
+			mutex_unlock(&proc_lock);
+			info->condvar = var;
+			return 0;
+		}
+	}
+
+	/* At this point, we need to allocate a new condition variable. */
+	var = kmalloc(sizeof(struct condition_variable), GFP_KERNEL);
+	if (var == NULL) {
+		mutex_unlock(&proc_lock);
+		return -ENOMEM;
+	}
+
+	/* Create the condition variable's proc file entry. */
+	var->status_proc = create_proc_entry(info->name, condition_list_perms,
+			   proc_net_condition);
+	if (var->status_proc == NULL) {
+		kfree(var);
+		mutex_unlock(&proc_lock);
+		return -ENOMEM;
+	}
+
+	var->refcount = 1;
+	var->enabled  = false;
+	var->status_proc->data = var;
+	wmb();
+	var->status_proc->read_proc  = condition_proc_read;
+	var->status_proc->write_proc = condition_proc_write;
+	list_add_rcu(&var->list, &conditions_list);
+	var->status_proc->uid = condition_uid_perms;
+	var->status_proc->gid = condition_gid_perms;
+	mutex_unlock(&proc_lock);
+	info->condvar = var;
+	return 0;
+}
+
+static void condition_mt_destroy(const struct xt_mtdtor_param *par)
+{
+	const struct xt_condition_mtinfo *info = par->matchinfo;
+	struct condition_variable *var = info->condvar;
+
+	mutex_lock(&proc_lock);
+	if (--var->refcount == 0) {
+		list_del_rcu(&var->list);
+		remove_proc_entry(var->status_proc->name, proc_net_condition);
+		mutex_unlock(&proc_lock);
+		/*
+		 * synchronize_rcu() would be good enough, but
+		 * synchronize_net() guarantees that no packet
+		 * will go out with the old rule after
+		 * succesful removal.
+		 */
+		synchronize_net();
+		kfree(var);
+		return;
+	}
+	mutex_unlock(&proc_lock);
+}
+
+static struct xt_match condition_mt_reg __read_mostly = {
+	.name       = "condition",
+	.revision   = 1,
+	.family     = NFPROTO_UNSPEC,
+	.matchsize  = sizeof(struct xt_condition_mtinfo),
+	.match      = condition_mt,
+	.checkentry = condition_mt_check,
+	.destroy    = condition_mt_destroy,
+	.me         = THIS_MODULE,
+};
+
+static const char *const dir_name = "nf_condition";
+
+static int __net_init condnet_mt_init(struct net *net)
+{
+	int ret;
+
+	proc_net_condition = proc_mkdir(dir_name, net->proc_net);
+	if (proc_net_condition == NULL)
+		return -EACCES;
+
+	ret = xt_register_match(&condition_mt_reg);
+	if (ret < 0) {
+		remove_proc_entry(dir_name, net->proc_net);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __net_exit condnet_mt_exit(struct net *net)
+{
+	xt_unregister_match(&condition_mt_reg);
+	remove_proc_entry(dir_name, net->proc_net);
+}
+
+static struct pernet_operations condition_mt_netops = {
+	.init = condnet_mt_init,
+	.exit = condnet_mt_exit,
+};
+
+static int __init condition_mt_init(void)
+{
+	mutex_init(&proc_lock);
+	return register_pernet_subsys(&condition_mt_netops);
+}
+
+static void __exit condition_mt_exit(void)
+{
+	unregister_pernet_subsys(&condition_mt_netops);
+}
+
+module_init(condition_mt_init);
+module_exit(condition_mt_exit);
-- 
1.7.0.2

