From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] xt_condition with 2.6.19+
Date: Mon, 2 Apr 2007 15:40:02 +0200
Message-ID: <200704021540.02609.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yeQEGfvETlFyUao"
Cc: netfilter-devel@lists.netfilter.org
To: max@nucleus.it
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--Boundary-00=_yeQEGfvETlFyUao
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Massimiliano,

attached is a patch to fix xt_condition with kernel 2.6.19+.

Without the patch the destroy() function never gets executed
and so /proc won't be cleaned up. The result is a kernel
WARN_ON() during module unload:

BUG: at fs/proc/generic.c:732 remove_proc_entry()

I've copied your 2.6.17 version and made the needed
modifications in the new 2.6.19 directory.

Cheers,
Thomas

--Boundary-00=_yeQEGfvETlFyUao
Content-Type: text/x-diff; charset="iso-8859-1";
	name="xt_condition-2.6.19.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xt_condition-2.6.19.patch"

diff -u -r -p --new-file old/condition/linux-2.6.19/include/linux/netfilter/xt_condition.h new/condition/linux-2.6.19/include/linux/netfilter/xt_condition.h
--- old/condition/linux-2.6.19/include/linux/netfilter/xt_condition.h	Thu Jan  1 01:00:00 1970
+++ new/condition/linux-2.6.19/include/linux/netfilter/xt_condition.h	Wed Jun 21 02:04:26 2006
@@ -0,0 +1,11 @@
+#ifndef _XT_CONDITION_H
+#define _XT_CONDITION_H
+
+#define CONDITION_NAME_LEN  32
+
+struct condition_info {
+	char name[CONDITION_NAME_LEN];
+	int  invert;
+};
+
+#endif /* _XT_CONDITION_H */
diff -u -r -p --new-file old/condition/linux-2.6.19/net/netfilter/Kconfig.ladd new/condition/linux-2.6.19/net/netfilter/Kconfig.ladd
--- old/condition/linux-2.6.19/net/netfilter/Kconfig.ladd	Thu Jan  1 01:00:00 1970
+++ new/condition/linux-2.6.19/net/netfilter/Kconfig.ladd	Wed Jun 21 02:04:26 2006
@@ -0,0 +1,12 @@
+config NETFILTER_XT_MATCH_CONDITION
+        tristate  '"condition" match support'
+        depends on NETFILTER_XTABLES
+        help
+          This option allows you to match firewall rules against condition
+          variables stored in the /proc/net/nf_condition directory.
+
+          N.B.: older versions used /proc/net/ipt_condition. You can
+          reenable it with "compat_dir_name".
+
+          If you want to compile it as a module, say M here and read
+          Documentation/modules.txt.  If unsure, say `N'.
diff -u -r -p --new-file old/condition/linux-2.6.19/net/netfilter/Makefile.ladd new/condition/linux-2.6.19/net/netfilter/Makefile.ladd
--- old/condition/linux-2.6.19/net/netfilter/Makefile.ladd	Thu Jan  1 01:00:00 1970
+++ new/condition/linux-2.6.19/net/netfilter/Makefile.ladd	Mon Nov  6 11:07:21 2006
@@ -0,0 +1,2 @@
+obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_CONDITION) += xt_condition.o
diff -u -r -p --new-file old/condition/linux-2.6.19/net/netfilter/xt_condition.c new/condition/linux-2.6.19/net/netfilter/xt_condition.c
--- old/condition/linux-2.6.19/net/netfilter/xt_condition.c	Thu Jan  1 01:00:00 1970
+++ new/condition/linux-2.6.19/net/netfilter/xt_condition.c	Mon Apr  2 15:25:18 2007
@@ -0,0 +1,310 @@
+/*-------------------------------------------*\
+|          Netfilter Condition Module         |
+|                                             |
+|  Description: This module allows firewall   |
+|    rules to match using condition variables |
+|    stored in /proc files.                   |
+|                                             |
+|  Author: Stephane Ouellette     2002-10-22  |
+|          <ouellettes@videotron.ca>          |
+|          Massimiliano Hofer     2006-05-15  |
+|          <max@nucleus.it>                   |
+|                                             |
+|  History:                                   |
+|    2003-02-10  Second version with improved |
+|                locking and simplified code. |
+|    2006-05-15  2.6.16 adaptations.          |
+|                Locking overhaul.            |
+|                Various bug fixes.           |
+|                                             |
+|  This software is distributed under the     |
+|  terms of the GNU GPL.                      |
+\*-------------------------------------------*/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/spinlock.h>
+#include <asm/semaphore.h>
+#include <linux/string.h>
+#include <linux/list.h>
+#include <asm/atomic.h>
+#include <asm/uaccess.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_condition.h>
+
+#ifndef CONFIG_PROC_FS
+#error  "Proc file system support is required for this module"
+#endif
+
+/* Defaults, these can be overridden on the module command-line. */
+static unsigned int condition_list_perms = 0644;
+static unsigned int compat_dir_name = 0;
+static unsigned int condition_uid_perms = 0;
+static unsigned int condition_gid_perms = 0;
+
+MODULE_AUTHOR("Stephane Ouellette <ouellettes@videotron.ca> and Massimiliano Hofer <max@nucleus.it>");
+MODULE_DESCRIPTION("Allows rules to match against condition variables");
+MODULE_LICENSE("GPL");
+module_param(condition_list_perms, uint, 0600);
+MODULE_PARM_DESC(condition_list_perms,"permissions on /proc/net/nf_condition/* files");
+module_param(condition_uid_perms, uint, 0600);
+MODULE_PARM_DESC(condition_uid_perms,"user owner of /proc/net/nf_condition/* files");
+module_param(condition_gid_perms, uint, 0600);
+MODULE_PARM_DESC(condition_gid_perms,"group owner of /proc/net/nf_condition/* files");
+module_param(compat_dir_name, bool, 0400);
+MODULE_PARM_DESC(compat_dir_name,"use old style /proc/net/ipt_condition/* files");
+MODULE_ALIAS("ipt_condition");
+MODULE_ALIAS("ip6t_condition");
+
+struct condition_variable {
+	struct list_head list;
+	struct proc_dir_entry *status_proc;
+	unsigned int refcount;
+        int enabled;   /* TRUE == 1, FALSE == 0 */
+};
+
+/* proc_lock is a user context only semaphore used for write access */
+/*           to the conditions' list.                               */
+static DECLARE_MUTEX(proc_lock);
+
+static LIST_HEAD(conditions_list);
+static struct proc_dir_entry *proc_net_condition = NULL;
+static const char *dir_name;
+
+static int
+xt_condition_read_info(char __user *buffer, char **start, off_t offset,
+			int length, int *eof, void *data)
+{
+	struct condition_variable *var =
+	    (struct condition_variable *) data;
+
+	buffer[0] = (var->enabled) ? '1' : '0';
+	buffer[1] = '\n';
+	if (length>=2)
+		*eof = 1;
+
+	return 2;
+}
+
+
+static int
+xt_condition_write_info(struct file *file, const char __user *buffer,
+			 unsigned long length, void *data)
+{
+	struct condition_variable *var =
+	    (struct condition_variable *) data;
+	char newval;
+
+	if (length>0) {
+		if (get_user(newval, buffer))
+			return -EFAULT;
+	        /* Match only on the first character */
+		switch (newval) {
+		case '0':
+			var->enabled = 0;
+			break;
+		case '1':
+			var->enabled = 1;
+			break;
+		}
+	}
+
+	return (int) length;
+}
+
+
+static int
+match(const struct sk_buff *skb, const struct net_device *in,
+      const struct net_device *out, const struct xt_match *match,
+      const void *matchinfo, int offset,
+      unsigned int protoff, int *hotdrop)
+{
+	const struct condition_info *info =
+	    (const struct condition_info *) matchinfo;
+	struct condition_variable *var;
+	int condition_status = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(var, &conditions_list, list) {
+		if (strcmp(info->name, var->status_proc->name) == 0) {
+			condition_status = var->enabled;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return condition_status ^ info->invert;
+}
+
+
+
+static int
+checkentry(const char *tablename, const void *ip,
+	   const struct xt_match *match,
+	   void *matchinfo, unsigned int hook_mask)
+{
+	static const char * const forbidden_names[]={ "", ".", ".." };
+	struct condition_info *info = (struct condition_info *) matchinfo;
+	struct list_head *pos;
+	struct condition_variable *var, *newvar;
+
+	int i;
+
+	/* We don't want a '/' in a proc file name. */
+	for (i=0; i < CONDITION_NAME_LEN && info->name[i] != '\0'; i++)
+		if (info->name[i] == '/')
+			return 0;
+	/* We can't handle file names longer than CONDITION_NAME_LEN and */
+	/* we want a NULL terminated string. */
+	if (i == CONDITION_NAME_LEN)
+		return 0;
+
+	/* We don't want certain reserved names. */
+	for (i=0; i < sizeof(forbidden_names)/sizeof(char *); i++)
+		if(strcmp(info->name, forbidden_names[i])==0)
+			return 0;
+
+	/* Let's acquire the lock, check for the condition and add it */
+	/* or increase the reference counter.                         */
+	if (down_interruptible(&proc_lock))
+	   return -EINTR;
+
+	list_for_each(pos, &conditions_list) {
+		var = list_entry(pos, struct condition_variable, list);
+		if (strcmp(info->name, var->status_proc->name) == 0) {
+			var->refcount++;
+			up(&proc_lock);
+			return 1;
+		}
+	}
+
+	/* At this point, we need to allocate a new condition variable. */
+	newvar = kmalloc(sizeof(struct condition_variable), GFP_KERNEL);
+
+	if (!newvar) {
+		up(&proc_lock);
+		return -ENOMEM;
+	}
+
+	/* Create the condition variable's proc file entry. */
+	newvar->status_proc = create_proc_entry(info->name, condition_list_perms, proc_net_condition);
+
+	if (!newvar->status_proc) {
+		kfree(newvar);
+		up(&proc_lock);
+		return -ENOMEM;
+	}
+
+	newvar->refcount = 1;
+	newvar->enabled = 0;
+	newvar->status_proc->owner = THIS_MODULE;
+	newvar->status_proc->data = newvar;
+	wmb();
+	newvar->status_proc->read_proc = xt_condition_read_info;
+	newvar->status_proc->write_proc = xt_condition_write_info;
+
+	list_add_rcu(&newvar->list, &conditions_list);
+
+	newvar->status_proc->uid = condition_uid_perms;
+	newvar->status_proc->gid = condition_gid_perms;
+
+	up(&proc_lock);
+
+	return 1;
+}
+
+
+static void
+destroy(const struct xt_match *match, void *matchinfo)
+{
+	struct condition_info *info = (struct condition_info *) matchinfo;
+	struct list_head *pos;
+	struct condition_variable *var;
+
+	down(&proc_lock);
+
+	list_for_each(pos, &conditions_list) {
+		var = list_entry(pos, struct condition_variable, list);
+		if (strcmp(info->name, var->status_proc->name) == 0) {
+			if (--var->refcount == 0) {
+				list_del_rcu(pos);
+				remove_proc_entry(var->status_proc->name, proc_net_condition);
+				up(&proc_lock);
+				/* synchronize_rcu() would be goog enough, but synchronize_net() */
+				/* guarantees that no packet will go out with the old rule after */
+				/* succesful removal.                                            */
+				synchronize_net();
+				kfree(var);
+				return;
+			}
+			break;
+		}
+	}
+
+	up(&proc_lock);
+}
+
+
+static struct xt_match condition_match = {
+	.name = "condition",
+	.family = AF_INET,
+	.matchsize = sizeof(struct condition_info),
+	.match = &match,
+	.checkentry = &checkentry,
+	.destroy = &destroy,
+	.me = THIS_MODULE
+};
+
+static struct xt_match condition6_match = {
+	.name = "condition",
+	.family = AF_INET6,
+	.matchsize = sizeof(struct condition_info),
+	.match = &match,
+	.checkentry = &checkentry,
+	.destroy = &destroy,
+	.me = THIS_MODULE
+};
+
+static int __init
+init(void)
+{
+	int errorcode;
+
+	dir_name = compat_dir_name? "ipt_condition": "nf_condition";
+
+	proc_net_condition = proc_mkdir(dir_name, proc_net);
+	if (!proc_net_condition) {
+		remove_proc_entry(dir_name, proc_net);
+		return -EACCES;
+	}
+
+        errorcode = xt_register_match(&condition_match);
+	if (errorcode) {
+		xt_unregister_match(&condition_match);
+		remove_proc_entry(dir_name, proc_net);
+		return errorcode;
+	}
+
+	errorcode = xt_register_match(&condition6_match);
+	if (errorcode) {
+		xt_unregister_match(&condition6_match);
+		xt_unregister_match(&condition_match);
+		remove_proc_entry(dir_name, proc_net);
+		return errorcode;
+	}
+
+	return 0;
+}
+
+
+static void __exit
+fini(void)
+{
+	xt_unregister_match(&condition6_match);
+	xt_unregister_match(&condition_match);
+	remove_proc_entry(dir_name, proc_net);
+}
+
+module_init(init);
+module_exit(fini);

--Boundary-00=_yeQEGfvETlFyUao
Content-Type: text/x-diff; charset="iso-8859-1"; name="xt_condition_diff.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xt_condition_diff.patch"

--- xt_condition.c.old	Wed Jun 21 02:38:04 2006
+++ xt_condition.c	Mon Apr  2 15:25:18 2007
@@ -142,8 +142,7 @@
 static int
 checkentry(const char *tablename, const void *ip,
 	   const struct xt_match *match,
-	   void *matchinfo, unsigned int matchsize,
-	   unsigned int hook_mask)
+	   void *matchinfo, unsigned int hook_mask)
 {
 	static const char * const forbidden_names[]={ "", ".", ".." };
 	struct condition_info *info = (struct condition_info *) matchinfo;
@@ -217,15 +216,11 @@
 
 
 static void
-destroy(const struct xt_match *match, void *matchinfo,
-	unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo)
 {
 	struct condition_info *info = (struct condition_info *) matchinfo;
 	struct list_head *pos;
 	struct condition_variable *var;
-
-	if (matchsize != XT_ALIGN(sizeof(struct condition_info)))
-		return;
 
 	down(&proc_lock);
 

--Boundary-00=_yeQEGfvETlFyUao--
