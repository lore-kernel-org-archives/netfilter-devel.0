From: Massimiliano Hofer <max@nucleus.it>
Subject: condition for 2.6.16
Date: Thu, 20 Apr 2006 19:19:12 +0200
Message-ID: <200604201919.19246.max@nucleus.it>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_XK8RERK05tO+7fW"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--Boundary-00=_XK8RERK05tO+7fW
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
I wrote here some time ago about condition and Krzysztof told me it wasn't 
supposed to work.
I tested it and it seemed to work, but reading the code I agree that it 
shouldn't have. :)

I find this extension very useful, so I did a complete porting to 2.6.16 
complete with XT. I fixed various things (mostly fossils of the 2.4 era) in 
the process and it works in my test environment.
I am about to test it in a few high load machines, but I'd appreciate if 
someone else could have a look at it.

What are the next steps in order to have it included in the core extension and 
finally merged in the kernel?

-- 
Saluti,
   Massimiliano Hofer
        Nucleus

--Boundary-00=_XK8RERK05tO+7fW
Content-Type: text/x-diff;
  charset="us-ascii";
  name="condition.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="condition.patch"

diff -Nru patch-o-matic-ng-20060419/patchlets/condition/help patch-o-matic-ng-20060419.new/patchlets/condition/help
--- patch-o-matic-ng-20060419/patchlets/condition/help	2003-12-20 17:19:17.000000000 +0100
+++ patch-o-matic-ng-20060419.new/patchlets/condition/help	2006-04-20 18:36:22.000000000 +0200
@@ -7,8 +7,10 @@
 iptables -A INPUT -p tcp -m condition --condition web_ok --dport 80 -j ACCEPT
 
 To allow this rule to match:
-echo 1 > /proc/net/ipt_condition/web_ok
+echo 1 > /proc/net/nf_condition/web_ok
 
 To disable this rule: 
-echo 0 > /proc/net/ipt_condition/web_ok
+echo 0 > /proc/net/nf_condition/web_ok
+
+NB: it was /proc/net/ipt_condition on 2.4.
 
diff -Nru patch-o-matic-ng-20060419/patchlets/condition/info patch-o-matic-ng-20060419.new/patchlets/condition/info
--- patch-o-matic-ng-20060419/patchlets/condition/info	2004-02-20 00:25:33.000000000 +0100
+++ patch-o-matic-ng-20060419.new/patchlets/condition/info	2006-04-20 18:52:56.000000000 +0200
@@ -1,4 +1,4 @@
-Author: Stephane Ouellette <ouellettes@videotron.ca>
+Author: Stephane Ouellette <ouellettes@videotron.ca> and Massimiliano Hofer <max@nucleus.it>
 Status: ItWorksForMe(tm)
+Requires: linux == 2.4 || linux >= 2.6.16
 Repository: extra
-Requires: linux < 2.6.0
diff -Nru patch-o-matic-ng-20060419/patchlets/condition/linux-2.6.16/Documentation/Configure.help.ladd patch-o-matic-ng-20060419.new/patchlets/condition/linux-2.6.16/Documentation/Configure.help.ladd
--- patch-o-matic-ng-20060419/patchlets/condition/linux-2.6.16/Documentation/Configure.help.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060419.new/patchlets/condition/linux-2.6.16/Documentation/Configure.help.ladd	2006-04-20 17:24:15.000000000 +0200
@@ -0,0 +1,6 @@
+NETFILTER_XT_MATCH_CONDITION
+  This option allows you to match firewall rules against condition
+  variables stored in the /proc/net/nf_condition directory.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
diff -Nru patch-o-matic-ng-20060419/patchlets/condition/linux-2.6.16/include/linux/netfilter/xt_condition.h patch-o-matic-ng-20060419.new/patchlets/condition/linux-2.6.16/include/linux/netfilter/xt_condition.h
--- patch-o-matic-ng-20060419/patchlets/condition/linux-2.6.16/include/linux/netfilter/xt_condition.h	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060419.new/patchlets/condition/linux-2.6.16/include/linux/netfilter/xt_condition.h	2006-04-20 17:18:11.000000000 +0200
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
diff -Nru patch-o-matic-ng-20060419/patchlets/condition/linux-2.6.16/net/netfilter/Kconfig.ladd patch-o-matic-ng-20060419.new/patchlets/condition/linux-2.6.16/net/netfilter/Kconfig.ladd
--- patch-o-matic-ng-20060419/patchlets/condition/linux-2.6.16/net/netfilter/Kconfig.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060419.new/patchlets/condition/linux-2.6.16/net/netfilter/Kconfig.ladd	2006-04-20 17:22:13.000000000 +0200
@@ -0,0 +1,9 @@
+config NETFILTER_XT_MATCH_CONDITION
+        tristate  '"condition" match support'
+        depends on NETFILTER_XTABLES
+        help
+          This option allows you to match firewall rules against condition
+          variables stored in the /proc/net/ipt_condition directory.
+
+          If you want to compile it as a module, say M here and read
+          Documentation/modules.txt.  If unsure, say `N'.
diff -Nru patch-o-matic-ng-20060419/patchlets/condition/linux-2.6.16/net/netfilter/Makefile.ladd patch-o-matic-ng-20060419.new/patchlets/condition/linux-2.6.16/net/netfilter/Makefile.ladd
--- patch-o-matic-ng-20060419/patchlets/condition/linux-2.6.16/net/netfilter/Makefile.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060419.new/patchlets/condition/linux-2.6.16/net/netfilter/Makefile.ladd	2006-04-20 18:34:08.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) += xt_condition.o
diff -Nru patch-o-matic-ng-20060419/patchlets/condition/linux-2.6.16/net/netfilter/xt_condition.c patch-o-matic-ng-20060419.new/patchlets/condition/linux-2.6.16/net/netfilter/xt_condition.c
--- patch-o-matic-ng-20060419/patchlets/condition/linux-2.6.16/net/netfilter/xt_condition.c	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060419.new/patchlets/condition/linux-2.6.16/net/netfilter/xt_condition.c	2006-04-20 17:21:07.000000000 +0200
@@ -0,0 +1,318 @@
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
+
+MODULE_AUTHOR("Stephane Ouellette <ouellettes@videotron.ca> and Massimiliano Hofer <max@nucleus.it>");
+MODULE_DESCRIPTION("Allows rules to match against condition variables");
+MODULE_LICENSE("GPL");
+module_param(condition_list_perms, uint, 0400);
+MODULE_PARM_DESC(condition_list_perms,"permissions on /proc/net/nf_condition/* files");
+MODULE_ALIAS("ipt_condition");
+MODULE_ALIAS("ip6t_condition");
+
+struct condition_variable {
+	struct condition_variable *next;
+	struct proc_dir_entry *status_proc;
+	atomic_t refcount;
+        int enabled;   /* TRUE == 1, FALSE == 0 */
+};
+
+/* list_lock is a spin lock used to synchronize user and bottom half contexts.  */
+/*    It is used only for short period requiring reads from BH or               */
+/*    read/write from user.                                                     */
+/* proc_lock is a user context only semaphor used for more extensive operations */
+/*    during insertion and deletion of rules. It must never be acquired by      */
+/*    by someone already having a list_lock, but you can obtain a list_lock     */
+/*    while having a proc_lock.                                                 */
+static DEFINE_SPINLOCK(list_lock);
+static DECLARE_MUTEX(proc_lock);
+
+static struct condition_variable *head = NULL;
+static struct proc_dir_entry *proc_net_condition = NULL;
+
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
+      const struct net_device *out, const void *matchinfo, int offset,
+      unsigned int protoff, int *hotdrop)
+{
+	const struct condition_info *info =
+	    (const struct condition_info *) matchinfo;
+	struct condition_variable *var;
+	int condition_status = 0;
+
+	spin_lock_bh(&list_lock);
+
+	for (var = head; var != NULL; var = var->next) {
+		if (strcmp(info->name, var->status_proc->name) == 0) {
+			condition_status = var->enabled;
+			break;
+		}
+	}
+
+	spin_unlock_bh(&list_lock);
+
+	return condition_status ^ info->invert;
+}
+
+
+
+static int
+checkentry(const char *tablename, const void *ip,
+	   void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
+{
+	static const char * const forbidden_names[]={ "", ".", ".." };
+	struct condition_info *info = (struct condition_info *) matchinfo;
+	struct condition_variable *var, *newvar;
+
+	int i;
+
+	if (matchsize != XT_ALIGN(sizeof(struct condition_info)))
+		return 0;
+
+	/* We don't want a '/' in a proc file name. */
+	for(i=0; i < CONDITION_NAME_LEN && info->name[i] != '\0'; i++)
+		if(info->name[i] == '/')
+			return 0;
+	/* We can't handle file names longer than CONDITION_NAME_LEN and */
+	/* we want a NULL terminated string. */
+	if(i == CONDITION_NAME_LEN)
+		return 0;
+
+	/* We don't want certain reserved names. */
+	for(i=0; i < sizeof(forbidden_names)/sizeof(char *); i++)
+		if(strcmp(info->name, forbidden_names[i])==0)
+			return 0;
+
+	/* The first step is to check if the condition variable already exists.  */
+	/* This lock is to prevent other processes performing the same check and */
+	/* modify code and from altering proc entries.                           */
+	down(&proc_lock);
+
+	for (var = head; var; var = var->next) {
+		if (strcmp(info->name, var->status_proc->name) == 0) {
+			atomic_inc(&var->refcount);
+			up(&proc_lock);
+			return 1;
+		}
+	}
+
+	/* At this point, we need to allocate a new condition variable */
+	newvar = kmalloc(sizeof(struct condition_variable), GFP_KERNEL);
+
+	if (!newvar) {
+		up(&proc_lock);
+		return -ENOMEM;
+	}
+
+	/* Create the condition variable's proc file entry */
+	newvar->status_proc = create_proc_entry(info->name, condition_list_perms, proc_net_condition);
+
+	if (!newvar->status_proc) {
+	  /*
+	   * There are two possibilities:
+	   *  1- Another condition variable with the same name has been created, which is valid.
+	   *  2- There was a memory allocation error.
+	   */
+		kfree(newvar);
+
+		for (var = head; var; var = var->next) {
+			if (strcmp(info->name, var->status_proc->name) == 0) {
+				atomic_inc(&var->refcount);
+				up(&proc_lock);
+				return 1;
+			}
+		}
+
+		up(&proc_lock);
+		return -ENOMEM;
+	}
+
+	atomic_set(&newvar->refcount, 1);
+	newvar->enabled = 0;
+	newvar->status_proc->owner = THIS_MODULE;
+	newvar->status_proc->data = newvar;
+	wmb();
+	newvar->status_proc->read_proc = xt_condition_read_info;
+	newvar->status_proc->write_proc = xt_condition_write_info;
+
+	/* There used to be a lock here, but a memory barrier should be good enough. */
+	newvar->next = head;
+	wmb();
+	head = newvar;
+
+	up(&proc_lock);
+
+	return 1;
+}
+
+
+static void
+destroy(void *matchinfo, unsigned int matchsize)
+{
+	struct condition_info *info = (struct condition_info *) matchinfo;
+	struct condition_variable *var, *prev;
+
+	if (matchsize != XT_ALIGN(sizeof(struct condition_info)))
+		return;
+
+	down(&proc_lock);
+
+	for (prev = NULL, var = head; var && strcmp(info->name, var->status_proc->name);
+	     prev = var, var = var->next);
+
+	if (var && atomic_dec_and_test(&var->refcount)) {
+		/* This lock is to prevent clashing with netfilter matching. */
+		spin_lock_bh(&list_lock);
+		if (prev)
+			prev->next = var->next;
+		else
+			head = var->next;
+		spin_unlock_bh(&list_lock);
+
+		remove_proc_entry(var->status_proc->name, proc_net_condition);
+		kfree(var);
+	}
+
+	up(&proc_lock);
+}
+
+
+static struct xt_match condition_match = {
+	.name = "condition",
+	.match = &match,
+	.checkentry = &checkentry,
+	.destroy = &destroy,
+	.me = THIS_MODULE
+};
+
+static struct xt_match condition6_match = {
+	.name = "condition",
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
+	spin_lock_init(&list_lock);
+
+	proc_net_condition = proc_mkdir("nf_condition", proc_net);
+	if (!proc_net_condition) {
+		errorcode = -EACCES;
+		goto remove_proc;
+	}
+
+        errorcode = xt_register_match(AF_INET, &condition_match);
+	if (errorcode)
+		goto remove_inet;
+
+	errorcode = xt_register_match(AF_INET6, &condition6_match);
+	if (errorcode)
+		goto remove_inet6;
+	return 0;
+
+remove_inet6:
+		xt_unregister_match(AF_INET6, &condition6_match);
+remove_inet:
+		xt_unregister_match(AF_INET, &condition_match);
+remove_proc:
+		remove_proc_entry("nf_condition", proc_net);
+
+	return errorcode;
+}
+
+
+static void __exit
+fini(void)
+{
+	xt_unregister_match(AF_INET6, &condition6_match);
+	xt_unregister_match(AF_INET, &condition_match);
+	remove_proc_entry("nf_condition", proc_net);
+}
+
+module_init(init);
+module_exit(fini);

--Boundary-00=_XK8RERK05tO+7fW--
