From: Massimiliano Hofer <max@nucleus.it>
Subject: [PATCH 4/4][data-condition]: condition match
Date: Tue, 5 Dec 2006 23:18:15 +0100
Message-ID: <200612052318.16324.max@nucleus.it>
References: <200612052312.28824.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200612052312.28824.max@nucleus.it>
Content-Disposition: inline
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

On Tuesday 5 December 2006 11:12 pm, Massimiliano Hofer wrote:
=46rom 51ca538c78b5748a3521a6868cd4239231984bf0 Mon Sep 17 00:00:00 2001
=46rom: Massimiliano Hofer <max@nucleus.it>
Date: Tue, 5 Dec 2006 23:02:29 +0100
Subject: [PATCH] [NETFILTER]: condition match

This patch adds the first match that makes use of the new instance specific=
 data in netfilter.

This module allows you to match firewall rules against condition
variables stored in the /proc/net/nf_condition directory.

Signed-off-by: Massimiliano Hofer <max@nucleus.it>
=2D--
 include/linux/netfilter/xt_condition.h |   11 ++
 net/netfilter/Kconfig                  |   10 +
 net/netfilter/Makefile                 |    1 +
 net/netfilter/xt_condition.c           |  292 ++++++++++++++++++++++++++++=
++++
 4 files changed, 314 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/xt_condition.h b/include/linux/netfilt=
er/xt_condition.h
new file mode 100644
index 0000000..f0706d0
=2D-- /dev/null
+++ b/include/linux/netfilter/xt_condition.h
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
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3a66878..fb4f07b 100644
=2D-- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -393,6 +393,16 @@ config NETFILTER_XT_MATCH_COMMENT
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
+config NETFILTER_XT_MATCH_CONDITION
+        tristate  '"condition" match support'
+        depends on NETFILTER_XTABLES && PROC_FS
+        help
+          This option allows you to match firewall rules against condition
+          variables stored in the /proc/net/nf_condition directory.
+
+          If you want to compile it as a module, say M here and read
+          Documentation/modules.txt.  If unsure, say `N'.
+
 config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5dc5574..36840e0 100644
=2D-- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -71,3 +71,4 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STRING)
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) +=3D xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) +=3D xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) +=3D xt_hashlimit.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) +=3D xt_condition.o
diff --git a/net/netfilter/xt_condition.c b/net/netfilter/xt_condition.c
new file mode 100644
index 0000000..91ec4d5
=2D-- /dev/null
+++ b/net/netfilter/xt_condition.c
@@ -0,0 +1,292 @@
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
+/* Defaults, these can be overridden on the module command-line. */
+static unsigned int condition_list_perms =3D 0600;
+static unsigned int condition_uid_perms =3D 0;
+static unsigned int condition_gid_perms =3D 0;
+
+MODULE_AUTHOR("Stephane Ouellette <ouellettes@videotron.ca> and Massimilia=
no Hofer <max@nucleus.it>");
+MODULE_DESCRIPTION("Allows rules to match against condition variables");
+MODULE_LICENSE("GPL");
+module_param(condition_list_perms, uint, 0600);
+MODULE_PARM_DESC(condition_list_perms,"permissions on /proc/net/nf_conditi=
on/* files");
+module_param(condition_uid_perms, uint, 0600);
+MODULE_PARM_DESC(condition_uid_perms,"user owner of /proc/net/nf_condition=
/* files");
+module_param(condition_gid_perms, uint, 0600);
+MODULE_PARM_DESC(condition_gid_perms,"group owner of /proc/net/nf_conditio=
n/* files");
+MODULE_ALIAS("ipt_condition");
+MODULE_ALIAS("ip6t_condition");
+
+static const char dir_name[]=3D"nf_condition";
+
+struct condition_variable {
+	struct list_head list;
+	struct proc_dir_entry *status_proc;
+	unsigned int refcount;
+        int enabled;   /* TRUE =3D=3D 1, FALSE =3D=3D 0 */
+};
+
+/* proc_lock is a user context only semaphore used for write access */
+/*           to the conditions' list.                               */
+static DECLARE_MUTEX(proc_lock);
+
+static LIST_HEAD(conditions_list);
+static struct proc_dir_entry *proc_net_condition =3D NULL;
+
+static int
+xt_condition_read_info(char __user *buffer, char **start, off_t offset,
+			int length, int *eof, void *data)
+{
+	struct condition_variable *var =3D
+	    (struct condition_variable *) data;
+
+	buffer[0] =3D (var->enabled) ? '1' : '0';
+	buffer[1] =3D '\n';
+	if (length>=3D2)
+		*eof =3D 1;
+
+	return 2;
+}
+
+
+static int
+xt_condition_write_info(struct file *file, const char __user *buffer,
+			unsigned long length, void *data)
+{
+	struct condition_variable *var =3D
+	    (struct condition_variable *) data;
+	char newval;
+
+	if (length>0) {
+		if (get_user(newval, buffer))
+			return -EFAULT;
+	        /* Match only on the first character */
+		switch (newval) {
+		case '0':
+			var->enabled =3D 0;
+			break;
+		case '1':
+			var->enabled =3D 1;
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
+      const void *matchinfo, void *data, int offset,
+      unsigned int protoff, int *hotdrop)
+{
+	const struct condition_info *info =3D
+		(const struct condition_info *)matchinfo;
+	struct condition_variable *var=3D
+		*(struct condition_variable **)data;
+
+	return var->enabled ^ info->invert;
+}
+
+
+static int
+init(const char *tablename, const void *ip,
+     const struct xt_match *match,
+     void *matchinfo, void *data,
+     unsigned int hook_mask)
+{
+	static const char * const forbidden_names[]=3D{ "", ".", ".." };
+	struct condition_info *info =3D (struct condition_info *) matchinfo;
+	struct list_head *pos;
+	struct condition_variable *var, *newvar;
+
+	int i;
+
+	/* We don't want a '/' in a proc file name. */
+	for (i=3D0; i < CONDITION_NAME_LEN && info->name[i] !=3D '\0'; i++)
+		if (info->name[i] =3D=3D '/')
+			return 0;
+	/* We can't handle file names longer than CONDITION_NAME_LEN and */
+	/* we want a NULL terminated string. */
+	if (i =3D=3D CONDITION_NAME_LEN)
+		return 0;
+
+	/* We don't want certain reserved names. */
+	for (i=3D0; i < sizeof(forbidden_names)/sizeof(char *); i++)
+		if(strcmp(info->name, forbidden_names[i])=3D=3D0)
+			return 0;
+
+	/* Let's acquire the lock, check for the condition and add it */
+	/* or increase the reference counter.                         */
+	if (down_interruptible(&proc_lock))
+	   return -EINTR;
+
+	list_for_each(pos, &conditions_list) {
+		var =3D list_entry(pos, struct condition_variable, list);
+		if (strcmp(info->name, var->status_proc->name) =3D=3D 0) {
+			var->refcount++;
+			up(&proc_lock);
+			*(struct condition_variable **)data=3Dvar;
+			return 1;
+		}
+	}
+
+	/* At this point, we need to allocate a new condition variable. */
+	newvar =3D kmalloc(sizeof(struct condition_variable), GFP_KERNEL);
+
+	if (!newvar) {
+		up(&proc_lock);
+		return -ENOMEM;
+	}
+
+	/* Create the condition variable's proc file entry. */
+	newvar->status_proc =3D create_proc_entry(info->name, condition_list_perm=
s, proc_net_condition);
+
+	if (!newvar->status_proc) {
+		kfree(newvar);
+		up(&proc_lock);
+		return -ENOMEM;
+	}
+
+	newvar->refcount =3D 1;
+	newvar->enabled =3D 0;
+	newvar->status_proc->owner =3D THIS_MODULE;
+	newvar->status_proc->data =3D newvar;
+	wmb();
+	newvar->status_proc->read_proc =3D xt_condition_read_info;
+	newvar->status_proc->write_proc =3D xt_condition_write_info;
+
+	list_add_rcu(&newvar->list, &conditions_list);
+
+	newvar->status_proc->uid =3D condition_uid_perms;
+	newvar->status_proc->gid =3D condition_gid_perms;
+
+	up(&proc_lock);
+
+	*(struct condition_variable **)data=3Dnewvar;
+
+	return 1;
+}
+
+
+static void
+destroy(const struct xt_match *match, void *matchinfo, void *data)
+{
+	struct condition_variable *var=3D
+		*(struct condition_variable **)data;
+
+	BUG_ON(data=3D=3DNULL);
+	BUG_ON(var=3D=3DNULL);
+
+	down(&proc_lock);
+
+	if (--var->refcount =3D=3D 0) {
+		list_del_rcu(&var->list);
+		remove_proc_entry(var->status_proc->name, proc_net_condition);
+		up(&proc_lock);
+		/* synchronize_rcu() would be goog enough, but         */
+		/* synchronize_net() guarantees that no packet will go */
+		/* out with the old rule after succesful removal.      */
+		synchronize_net();
+		kfree(var);
+		return;
+	}
+
+	up(&proc_lock);
+}
+
+
+static struct xt_match condition_match =3D {
+	.name		=3D "condition",
+	.family		=3D AF_INET,
+	.matchsize	=3D sizeof(struct condition_info),
+	.datasize	=3D sizeof(struct condition_variable *),
+	.match		=3D match,
+	.init		=3D init,
+	.destroy	=3D destroy,
+	.me		=3D THIS_MODULE
+};
+
+static struct xt_match condition6_match =3D {
+	.name		=3D "condition",
+	.family		=3D AF_INET6,
+	.matchsize	=3D sizeof(struct condition_info),
+	.datasize	=3D sizeof(struct condition_variable *),
+	.match		=3D match,
+	.init		=3D init,
+	.destroy	=3D destroy,
+	.me		=3D THIS_MODULE
+};
+
+static int __init xt_condition_init(void)
+{
+	int errorcode;
+
+	proc_net_condition =3D proc_mkdir(dir_name, proc_net);
+	if (!proc_net_condition) {
+		remove_proc_entry(dir_name, proc_net);
+		return -EACCES;
+	}
+
+        errorcode =3D xt_register_match(&condition_match);
+	if (errorcode) {
+		xt_unregister_match(&condition_match);
+		remove_proc_entry(dir_name, proc_net);
+		return errorcode;
+	}
+
+	errorcode =3D xt_register_match(&condition6_match);
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
+static void __exit xt_condition_fini(void)
+{
+	xt_unregister_match(&condition6_match);
+	xt_unregister_match(&condition_match);
+	remove_proc_entry(dir_name, proc_net);
+}
+
+module_init(xt_condition_init);
+module_exit(xt_condition_fini);
=2D-=20
1.4.3.3
