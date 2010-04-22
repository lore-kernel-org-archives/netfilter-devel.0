From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: inclusion of xt_condition
Date: Thu, 22 Apr 2010 02:05:48 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004220100530.6257@obet.zrqbmnf.qr>
References: <1271856792-20872-1-git-send-email-jengelh@medozas.de> <1271856792-20872-2-git-send-email-jengelh@medozas.de> <4BCF001D.4090304@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46474 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab0DVAFv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 20:05:51 -0400
In-Reply-To: <4BCF001D.4090304@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-04-21 15:39, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> xt_condition can be used by userspace to influence decisions in rules
>> by means of togglable variables without having to reload the entire
>> ruleset.
>
>> +
>> +	var->refcount = 1;
>> +	var->enabled  = false;
>> +	var->status_proc->data = var;
>> +	wmb();
>
>Jan, while I'm pretty patient, I don't appreciate having to repeat
>the same thing multiple times:
>
>>> Please always comment the use of memory barriers.

I am sorry I missed that; it seemed clear within the first 10 lines
of your mail (which just quoted the patch) that I sent out the
rcu-bugged variant and skipped the rest.

My share on the topic of patience - let me express that merges seemed
to be processed faster in the rc1 week once a good-looking series was
posted. As for maintenance, I think there should also be less
turnarounds/resends. No doubt that tires out maintainers and
bystanders alike looking at the same patch again and again. Adding
routing-by-oif could have easily be added as a patch on top, given it
was a feature not a bugfix. We do not have to meticulously get every
feature in on the very first commit and hold up the merge. You also
see no-one putting up a new filesystem/whatever in a single large
commit, instead they split it and start with small, but functional
base.

(N.B.: Where did iptables.git/extensions/libxt_TEE.c go? You asked for
it, but it did not show up yet either.)

>> +static int __net_init condnet_mt_init(struct net *net)
>> +{
>> +	int ret;
>> +
>> +	proc_net_condition = proc_mkdir(dir_name, net->proc_net);
>> +	if (proc_net_condition == NULL)
>> +		return -EACCES;
>> +
>> +	ret = xt_register_match(&condition_mt_reg);
>
>This is really starting to annoy me. Please read what I wrote,
>take your time, test the patch and then resend it.


The following changes since commit d97a9e47ba148cfc41e354c5cd241f472273207c:
  Jan Engelhardt (1):
        netfilter: x_tables: move sleeping allocation outside BH-disabled region

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (1):
      netfilter: xtables: inclusion of xt_condition

 include/linux/netfilter/Kbuild         |    1 +
 include/linux/netfilter/xt_condition.h |   14 ++
 net/netfilter/Kconfig                  |    8 +
 net/netfilter/Makefile                 |    1 +
 net/netfilter/xt_condition.c           |  230 ++++++++++++++++++++++++++++++++
 5 files changed, 254 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_condition.h
 create mode 100644 net/netfilter/xt_condition.c

parent d97a9e47ba148cfc41e354c5cd241f472273207c (v2.6.34-rc3-1336-gd97a9e4)
commit 7e4f990c6abf3902cec92f673c40ca79c04d0128
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Mar 16 23:38:46 2010 +0100

netfilter: xtables: inclusion of xt_condition

xt_condition can be used by userspace to influence decisions in rules
by means of togglable variables without having to reload the entire
ruleset.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/Kbuild         |    1 +
 include/linux/netfilter/xt_condition.h |   14 ++
 net/netfilter/Kconfig                  |    8 +
 net/netfilter/Makefile                 |    1 +
 net/netfilter/xt_condition.c           |  230 ++++++++++++++++++++++++
 5 files changed, 254 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_condition.h
 create mode 100644 net/netfilter/xt_condition.c

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 48767cd..6b67603 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -19,6 +19,7 @@ header-y += xt_TCPOPTSTRIP.h
 header-y += xt_TEE.h
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
index 673a6c8..217d52b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -612,6 +612,14 @@ config NETFILTER_XT_MATCH_COMMENT
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
index 14e3a8f..139dbe7 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_CLUSTER) += xt_cluster.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_CONDITION) += xt_condition.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTES) += xt_connbytes.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNLIMIT) += xt_connlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) += xt_conntrack.o
diff --git a/net/netfilter/xt_condition.c b/net/netfilter/xt_condition.c
new file mode 100644
index 0000000..5032156
--- /dev/null
+++ b/net/netfilter/xt_condition.c
@@ -0,0 +1,230 @@
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
+static DEFINE_MUTEX(proc_lock);
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
+
+	return var->enabled ^ info->invert;
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
+	mutex_lock(&proc_lock);
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
+	var->status_proc->data       = var;
+	var->status_proc->read_proc  = condition_proc_read;
+	var->status_proc->write_proc = condition_proc_write;
+	var->status_proc->uid        = condition_uid_perms;
+	var->status_proc->gid        = condition_gid_perms;
+	list_add(&var->list, &conditions_list);
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
+		list_del(&var->list);
+		remove_proc_entry(var->status_proc->name, proc_net_condition);
+		mutex_unlock(&proc_lock);
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
+	proc_net_condition = proc_mkdir(dir_name, net->proc_net);
+
+	return (proc_net_condition == NULL) ? -EACCES : 0;
+}
+
+static void __net_exit condnet_mt_exit(struct net *net)
+{
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
+	int ret;
+
+	mutex_init(&proc_lock);
+	ret = xt_register_match(&condition_mt_reg);
+	if (ret < 0)
+		return ret;
+
+	ret = register_pernet_subsys(&condition_mt_netops);
+	if (ret < 0) {
+		xt_unregister_match(&condition_mt_reg);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit condition_mt_exit(void)
+{
+	unregister_pernet_subsys(&condition_mt_netops);
+	xt_unregister_match(&condition_mt_reg);
+}
+
+module_init(condition_mt_init);
+module_exit(condition_mt_exit);
--
# Created with git-export-patch

