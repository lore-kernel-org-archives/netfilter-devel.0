From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: Fix the condition extension for 2.6.16 kernels
Date: Fri, 31 Mar 2006 15:11:27 +0200
Message-ID: <200603311511.32983.max@nucleus.it>
References: <200603302351.27713.max@nucleus.it>
	<Pine.LNX.4.64.0603310401430.23448@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1260288.hsplJAEtRh";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.64.0603310401430.23448@bizon.gios.gov.pl>
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

--nextPart1260288.hsplJAEtRh
Content-Type: multipart/mixed;
  boundary="Boundary-01=_AqSLEg3L38frWCl"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_AqSLEg3L38frWCl
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 31 March 2006 4:09 am, Krzysztof Oledzki wrote:

> I think you should create a linux-2.6 directory as this modification
> prevents this extension from being usable in 2.4 kernels.

Here you go.

> > Anyway I did a really simple fix for the condition extension for 2.6.16
> > kernels.
>
> BTW: Does it work or only compiles? ;) I remember some mails about porting
> condition to 2.6 raporting kernel crashes when accessing the proc
> interface.

I tested it with IPv4 on x86 and x86_64. Everything works as expected, but =
the=20
more testing the better, so you are welcome to do some more. :)

I don't have an IPv6 environment on hand and did no testing with it. I'll t=
ry=20
to setup an IPv6 network in the coming days, but I think I should aim for a=
=20
full merge of ipt and ip6t.

=2D-=20
Saluti,
   Massimiliano Hofer
        Nucleus

--Boundary-01=_AqSLEg3L38frWCl
Content-Type: text/x-diff;
  charset="utf-8";
  name="condition.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="condition.patch"

diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/D=
ocumentation/Configure.help.ladd patch-o-matic-ng-20060329/patchlets/condit=
ion/linux-2.6.16/Documentation/Configure.help.ladd
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/Docum=
entation/Configure.help.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/Documentatio=
n/Configure.help.ladd	2004-03-05 10:30:25.000000000 +0100
@@ -0,0 +1,8 @@
+CONFIG_IP_NF_MATCH_TOS
+Condition variable match support
+CONFIG_IP_NF_MATCH_CONDITION
+  This option allows you to match firewall rules against condition
+  variables stored in the /proc/net/ipt_condition directory.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/D=
ocumentation/Configure.help.ladd_2 patch-o-matic-ng-20060329/patchlets/cond=
ition/linux-2.6.16/Documentation/Configure.help.ladd_2
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/Docum=
entation/Configure.help.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/Documentatio=
n/Configure.help.ladd_2	2004-03-05 10:30:25.000000000 +0100
@@ -0,0 +1,8 @@
+CONFIG_IP6_NF_MATCH_MARK
+Condition variable match support
+CONFIG_IP6_NF_MATCH_CONDITION
+  This option allows you to match firewall rules against condition
+  variables stored in the /proc/net/ipt_condition directory.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/i=
nclude/linux/netfilter_ipv4/ipt_condition.h patch-o-matic-ng-20060329/patch=
lets/condition/linux-2.6.16/include/linux/netfilter_ipv4/ipt_condition.h
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/inclu=
de/linux/netfilter_ipv4/ipt_condition.h	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/include/linu=
x/netfilter_ipv4/ipt_condition.h	2003-12-18 19:47:52.000000000 +0100
@@ -0,0 +1,11 @@
+#ifndef __IPT_CONDITION_MATCH__
+#define __IPT_CONDITION_MATCH__
+
+#define CONDITION_NAME_LEN  32
+
+struct condition_info {
+	char name[CONDITION_NAME_LEN];
+	int  invert;
+};
+
+#endif
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/i=
nclude/linux/netfilter_ipv6/ip6t_condition.h patch-o-matic-ng-20060329/patc=
hlets/condition/linux-2.6.16/include/linux/netfilter_ipv6/ip6t_condition.h
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/inclu=
de/linux/netfilter_ipv6/ip6t_condition.h	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/include/linu=
x/netfilter_ipv6/ip6t_condition.h	2003-12-20 17:38:19.000000000 +0100
@@ -0,0 +1,11 @@
+#ifndef __IP6T_CONDITION_MATCH__
+#define __IP6T_CONDITION_MATCH__
+
+#define CONDITION6_NAME_LEN  32
+
+struct condition6_info {
+	char name[CONDITION6_NAME_LEN];
+	int  invert;
+};
+
+#endif
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/n=
et/ipv4/netfilter/Config.in.ladd patch-o-matic-ng-20060329/patchlets/condit=
ion/linux-2.6.16/net/ipv4/netfilter/Config.in.ladd
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/net/i=
pv4/netfilter/Config.in.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/net/ipv4/net=
filter/Config.in.ladd	2003-12-18 19:47:52.000000000 +0100
@@ -0,0 +1,2 @@
+  dep_tristate '  TOS match support' CONFIG_IP_NF_MATCH_TOS $CONFIG_IP_NF_=
IPTABLES
+  dep_tristate '  condition match support' CONFIG_IP_NF_MATCH_CONDITION $C=
ONFIG_IP_NF_IPTABLES
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/n=
et/ipv4/netfilter/ipt_condition.c patch-o-matic-ng-20060329/patchlets/condi=
tion/linux-2.6.16/net/ipv4/netfilter/ipt_condition.c
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/net/i=
pv4/netfilter/ipt_condition.c	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/net/ipv4/net=
filter/ipt_condition.c	2006-03-30 23:41:13.000000000 +0200
@@ -0,0 +1,256 @@
+/*-------------------------------------------*\
+|          Netfilter Condition Module         |
+|                                             |
+|  Description: This module allows firewall   |
+|    rules to match using condition variables |
+|    stored in /proc files.                   |
+|                                             |
+|  Author: Stephane Ouellette     2002-10-22  |
+|          <ouellettes@videotron.ca>          |
+|                                             |
+|  History:                                   |
+|    2003-02-10  Second version with improved |
+|                locking and simplified code. |
+|                                             |
+|  This software is distributed under the     |
+|  terms of the GNU GPL.                      |
+\*-------------------------------------------*/
+
+#include<linux/module.h>
+#include<linux/proc_fs.h>
+#include<linux/spinlock.h>
+#include<linux/string.h>
+#include<asm/atomic.h>
+#include<linux/netfilter_ipv4/ip_tables.h>
+#include<linux/netfilter_ipv4/ipt_condition.h>
+
+
+#ifndef CONFIG_PROC_FS
+#error  "Proc file system support is required for this module"
+#endif
+
+
+MODULE_AUTHOR("Stephane Ouellette <ouellettes@videotron.ca>");
+MODULE_DESCRIPTION("Allows rules to match against condition variables");
+MODULE_LICENSE("GPL");
+
+
+struct condition_variable {
+	struct condition_variable *next;
+	struct proc_dir_entry *status_proc;
+	atomic_t refcount;
+        int enabled;   /* TRUE =3D=3D 1, FALSE =3D=3D 0 */
+};
+
+
+static rwlock_t list_lock;
+static struct condition_variable *head =3D NULL;
+static struct proc_dir_entry *proc_net_condition =3D NULL;
+
+
+static int
+ipt_condition_read_info(char *buffer, char **start, off_t offset,
+			int length, int *eof, void *data)
+{
+	struct condition_variable *var =3D
+	    (struct condition_variable *) data;
+
+	if (offset =3D=3D 0) {
+		*start =3D buffer;
+		buffer[0] =3D (var->enabled) ? '1' : '0';
+		buffer[1] =3D '\n';
+		return 2;
+	}
+
+	*eof =3D 1;
+	return 0;
+}
+
+
+static int
+ipt_condition_write_info(struct file *file, const char *buffer,
+			 unsigned long length, void *data)
+{
+	struct condition_variable *var =3D
+	    (struct condition_variable *) data;
+
+	if (length) {
+	        /* Match only on the first character */
+		switch (buffer[0]) {
+		case '0':
+			var->enabled =3D 0;
+			break;
+		case '1':
+			var->enabled =3D 1;
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
+	const struct condition_info *info =3D
+	    (const struct condition_info *) matchinfo;
+	struct condition_variable *var;
+	int condition_status =3D 0;
+
+	read_lock(&list_lock);
+
+	for (var =3D head; var; var =3D var->next) {
+		if (strcmp(info->name, var->status_proc->name) =3D=3D 0) {
+			condition_status =3D var->enabled;
+			break;
+		}
+	}
+
+	read_unlock(&list_lock);
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
+	struct condition_info *info =3D (struct condition_info *) matchinfo;
+	struct condition_variable *var, *newvar;
+
+	if (matchsize !=3D IPT_ALIGN(sizeof(struct condition_info)))
+		return 0;
+
+	/* The first step is to check if the condition variable already exists. */
+	/* Here, a read lock is sufficient because we won't change the list */
+	read_lock(&list_lock);
+
+	for (var =3D head; var; var =3D var->next) {
+		if (strcmp(info->name, var->status_proc->name) =3D=3D 0) {
+			atomic_inc(&var->refcount);
+			read_unlock(&list_lock);
+			return 1;
+		}
+	}
+
+	read_unlock(&list_lock);
+
+	/* At this point, we need to allocate a new condition variable */
+	newvar =3D kmalloc(sizeof(struct condition_variable), GFP_KERNEL);
+
+	if (!newvar)
+		return -ENOMEM;
+
+	/* Create the condition variable's proc file entry */
+	newvar->status_proc =3D create_proc_entry(info->name, 0644, proc_net_cond=
ition);
+
+	if (!newvar->status_proc) {
+	  /*
+	   * There are two possibilities:
+	   *  1- Another condition variable with the same name has been created, =
which is valid.
+	   *  2- There was a memory allocation error.
+	   */
+		kfree(newvar);
+		read_lock(&list_lock);
+
+		for (var =3D head; var; var =3D var->next) {
+			if (strcmp(info->name, var->status_proc->name) =3D=3D 0) {
+				atomic_inc(&var->refcount);
+				read_unlock(&list_lock);
+				return 1;
+			}
+		}
+
+		read_unlock(&list_lock);
+		return -ENOMEM;
+	}
+
+	atomic_set(&newvar->refcount, 1);
+	newvar->enabled =3D 0;
+	newvar->status_proc->owner =3D THIS_MODULE;
+	newvar->status_proc->data =3D newvar;
+	wmb();
+	newvar->status_proc->read_proc =3D ipt_condition_read_info;
+	newvar->status_proc->write_proc =3D ipt_condition_write_info;
+
+	write_lock(&list_lock);
+
+	newvar->next =3D head;
+	head =3D newvar;
+
+	write_unlock(&list_lock);
+
+	return 1;
+}
+
+
+static void
+destroy(void *matchinfo, unsigned int matchsize)
+{
+	struct condition_info *info =3D (struct condition_info *) matchinfo;
+	struct condition_variable *var, *prev =3D NULL;
+
+	if (matchsize !=3D IPT_ALIGN(sizeof(struct condition_info)))
+		return;
+
+	write_lock(&list_lock);
+
+	for (var =3D head; var && strcmp(info->name, var->status_proc->name);
+	     prev =3D var, var =3D var->next);
+
+	if (var && atomic_dec_and_test(&var->refcount)) {
+		if (prev)
+			prev->next =3D var->next;
+		else
+			head =3D var->next;
+
+		write_unlock(&list_lock);
+		remove_proc_entry(var->status_proc->name, proc_net_condition);
+		kfree(var);
+	} else
+		write_unlock(&list_lock);
+}
+
+
+static struct ipt_match condition_match =3D {
+	.name =3D "condition",
+	.match =3D &match,
+	.checkentry =3D &checkentry,
+	.destroy =3D &destroy,
+	.me =3D THIS_MODULE
+};
+
+
+static int __init
+init(void)
+{
+	int errorcode;
+
+	rwlock_init(&list_lock);
+	proc_net_condition =3D proc_mkdir("ipt_condition", proc_net);
+
+	if (proc_net_condition) {
+	        errorcode =3D ipt_register_match(&condition_match);
+
+		if (errorcode)
+			remove_proc_entry("ipt_condition", proc_net);
+	} else
+		errorcode =3D -EACCES;
+
+	return errorcode;
+}
+
+
+static void __exit
+fini(void)
+{
+	ipt_unregister_match(&condition_match);
+	remove_proc_entry("ipt_condition", proc_net);
+}
+
+module_init(init);
+module_exit(fini);
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/n=
et/ipv4/netfilter/Kconfig.ladd patch-o-matic-ng-20060329/patchlets/conditio=
n/linux-2.6.16/net/ipv4/netfilter/Kconfig.ladd
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/net/i=
pv4/netfilter/Kconfig.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/net/ipv4/net=
filter/Kconfig.ladd	2004-05-06 14:46:50.000000000 +0200
@@ -0,0 +1,9 @@
+config IP_NF_MATCH_CONDITION
+	tristate  'condition match support'
+	depends on IP_NF_IPTABLES
+	help
+	  This option allows you to match firewall rules against condition
+	  variables stored in the /proc/net/ipt_condition directory.
+=09
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/n=
et/ipv4/netfilter/Makefile.ladd patch-o-matic-ng-20060329/patchlets/conditi=
on/linux-2.6.16/net/ipv4/netfilter/Makefile.ladd
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/net/i=
pv4/netfilter/Makefile.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/net/ipv4/net=
filter/Makefile.ladd	2003-12-18 19:47:52.000000000 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MATCH_TOS) +=3D ipt_tos.o
+obj-$(CONFIG_IP_NF_MATCH_CONDITION) +=3D ipt_condition.o
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/n=
et/ipv6/netfilter/Config.in.ladd patch-o-matic-ng-20060329/patchlets/condit=
ion/linux-2.6.16/net/ipv6/netfilter/Config.in.ladd
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/net/i=
pv6/netfilter/Config.in.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/net/ipv6/net=
filter/Config.in.ladd	2003-12-23 12:41:10.000000000 +0100
@@ -0,0 +1,2 @@
+  dep_tristate '  limit match support' CONFIG_IP6_NF_MATCH_LIMIT $CONFIG_I=
P6_NF_IPTABLES
+  dep_tristate '  condition match support' CONFIG_IP6_NF_MATCH_CONDITION $=
CONFIG_IP6_NF_IPTABLES
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/n=
et/ipv6/netfilter/ip6t_condition.c patch-o-matic-ng-20060329/patchlets/cond=
ition/linux-2.6.16/net/ipv6/netfilter/ip6t_condition.c
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/net/i=
pv6/netfilter/ip6t_condition.c	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/net/ipv6/net=
filter/ip6t_condition.c	2006-03-30 23:41:01.000000000 +0200
@@ -0,0 +1,254 @@
+/*-------------------------------------------*\
+|    Netfilter Condition Module for IPv6      |
+|                                             |
+|  Description: This module allows firewall   |
+|    rules to match using condition variables |
+|    stored in /proc files.                   |
+|                                             |
+|  Author: Stephane Ouellette     2003-02-10  |
+|          <ouellettes@videotron.ca>          |
+|                                             |
+|  This software is distributed under the     |
+|  terms of the GNU GPL.                      |
+\*-------------------------------------------*/
+
+#include<linux/module.h>
+#include<linux/proc_fs.h>
+#include<linux/spinlock.h>
+#include<linux/string.h>
+#include<asm/atomic.h>
+#include<linux/netfilter_ipv6/ip6_tables.h>
+#include<linux/netfilter_ipv6/ip6t_condition.h>
+
+
+#ifndef CONFIG_PROC_FS
+#error  "Proc file system support is required for this module"
+#endif
+
+
+MODULE_AUTHOR("Stephane Ouellette <ouellettes@videotron.ca>");
+MODULE_DESCRIPTION("Allows rules to match against condition variables");
+MODULE_LICENSE("GPL");
+
+
+struct condition_variable {
+	struct condition_variable *next;
+	struct proc_dir_entry *status_proc;
+	atomic_t refcount;
+        int enabled; /* TRUE =3D=3D 1, FALSE =3D=3D 0 */
+};
+
+
+static rwlock_t list_lock;
+static struct condition_variable *head =3D NULL;
+static struct proc_dir_entry *proc_net_condition =3D NULL;
+
+
+static int
+ipt_condition_read_info(char *buffer, char **start, off_t offset,
+			int length, int *eof, void *data)
+{
+	struct condition_variable *var =3D
+	    (struct condition_variable *) data;
+
+	if (offset =3D=3D 0) {
+		*start =3D buffer;
+		buffer[0] =3D (var->enabled) ? '1' : '0';
+		buffer[1] =3D '\n';
+		return 2;
+	}
+
+	*eof =3D 1;
+	return 0;
+}
+
+
+static int
+ipt_condition_write_info(struct file *file, const char *buffer,
+			 unsigned long length, void *data)
+{
+	struct condition_variable *var =3D
+	    (struct condition_variable *) data;
+
+	if (length) {
+	        /* Match only on the first character */
+		switch (buffer[0]) {
+		case '0':
+			var->enabled =3D 0;
+			break;
+		case '1':
+			var->enabled =3D 1;
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
+	const struct condition6_info *info =3D
+	    (const struct condition6_info *) matchinfo;
+	struct condition_variable *var;
+	int condition_status =3D 0;
+
+	read_lock(&list_lock);
+
+	for (var =3D head; var; var =3D var->next) {
+		if (strcmp(info->name, var->status_proc->name) =3D=3D 0) {
+			condition_status =3D var->enabled;
+			break;
+		}
+	}
+
+	read_unlock(&list_lock);
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
+	struct condition6_info *info =3D
+	    (struct condition6_info *) matchinfo;
+	struct condition_variable *var, *newvar;
+
+	if (matchsize !=3D IP6T_ALIGN(sizeof(struct condition6_info)))
+		return 0;
+
+	/* The first step is to check if the condition variable already exists. */
+	/* Here, a read lock is sufficient because we won't change the list */
+	read_lock(&list_lock);
+
+	for (var =3D head; var; var =3D var->next) {
+		if (strcmp(info->name, var->status_proc->name) =3D=3D 0) {
+			atomic_inc(&var->refcount);
+			read_unlock(&list_lock);
+			return 1;
+		}
+	}
+
+	read_unlock(&list_lock);
+
+	/* At this point, we need to allocate a new condition variable */
+	newvar =3D kmalloc(sizeof(struct condition_variable), GFP_KERNEL);
+
+	if (!newvar)
+		return -ENOMEM;
+
+	/* Create the condition variable's proc file entry */
+	newvar->status_proc =3D create_proc_entry(info->name, 0644, proc_net_cond=
ition);
+
+	if (!newvar->status_proc) {
+	  /*
+	   * There are two possibilities:
+	   *  1- Another condition variable with the same name has been created, =
which is valid.
+	   *  2- There was a memory allocation error.
+	   */
+		kfree(newvar);
+		read_lock(&list_lock);
+
+		for (var =3D head; var; var =3D var->next) {
+			if (strcmp(info->name, var->status_proc->name) =3D=3D 0) {
+				atomic_inc(&var->refcount);
+				read_unlock(&list_lock);
+				return 1;
+			}
+		}
+
+		read_unlock(&list_lock);
+		return -ENOMEM;
+	}
+
+	atomic_set(&newvar->refcount, 1);
+	newvar->enabled =3D 0;
+	newvar->status_proc->owner =3D THIS_MODULE;
+	newvar->status_proc->data =3D newvar;
+	wmb();
+	newvar->status_proc->read_proc =3D ipt_condition_read_info;
+	newvar->status_proc->write_proc =3D ipt_condition_write_info;
+
+	write_lock(&list_lock);
+
+	newvar->next =3D head;
+	head =3D newvar;
+
+	write_unlock(&list_lock);
+
+	return 1;
+}
+
+
+static void
+destroy(void *matchinfo, unsigned int matchsize)
+{
+	struct condition6_info *info =3D
+	    (struct condition6_info *) matchinfo;
+	struct condition_variable *var, *prev =3D NULL;
+
+	if (matchsize !=3D IP6T_ALIGN(sizeof(struct condition6_info)))
+		return;
+
+	write_lock(&list_lock);
+
+	for (var =3D head; var && strcmp(info->name, var->status_proc->name);
+	     prev =3D var, var =3D var->next);
+
+	if (var && atomic_dec_and_test(&var->refcount)) {
+		if (prev)
+			prev->next =3D var->next;
+		else
+			head =3D var->next;
+
+		write_unlock(&list_lock);
+		remove_proc_entry(var->status_proc->name, proc_net_condition);
+		kfree(var);
+	} else
+		write_unlock(&list_lock);
+}
+
+
+static struct ip6t_match condition_match =3D {
+	.name =3D "condition",
+	.match =3D &match,
+	.checkentry =3D &checkentry,
+	.destroy =3D &destroy,
+	.me =3D THIS_MODULE
+};
+
+
+static int __init
+init(void)
+{
+	int errorcode;
+
+	rwlock_init(&list_lock);
+	proc_net_condition =3D proc_mkdir("ip6t_condition", proc_net);
+
+	if (proc_net_condition) {
+	        errorcode =3D ip6t_register_match(&condition_match);
+
+		if (errorcode)
+			remove_proc_entry("ip6t_condition", proc_net);
+	} else
+		errorcode =3D -EACCES;
+
+	return errorcode;
+}
+
+
+static void __exit
+fini(void)
+{
+	ip6t_unregister_match(&condition_match);
+	remove_proc_entry("ip6t_condition", proc_net);
+}
+
+module_init(init);
+module_exit(fini);
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/n=
et/ipv6/netfilter/Kconfig.ladd patch-o-matic-ng-20060329/patchlets/conditio=
n/linux-2.6.16/net/ipv6/netfilter/Kconfig.ladd
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/net/i=
pv6/netfilter/Kconfig.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/net/ipv6/net=
filter/Kconfig.ladd	2004-05-06 14:46:50.000000000 +0200
@@ -0,0 +1,9 @@
+config IP6_NF_MATCH_CONDITION
+	tristate  'condition match support'
+	depends on IP6_NF_IPTABLES
+	help
+	  This option allows you to match firewall rules against condition
+	  variables stored in the /proc/net/ipt_condition directory.
+=09
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
diff -Nur patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/n=
et/ipv6/netfilter/Makefile.ladd patch-o-matic-ng-20060329/patchlets/conditi=
on/linux-2.6.16/net/ipv6/netfilter/Makefile.ladd
=2D-- patch-o-matic-ng-20060329.orig/patchlets/condition/linux-2.6.16/net/i=
pv6/netfilter/Makefile.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060329/patchlets/condition/linux-2.6.16/net/ipv6/net=
filter/Makefile.ladd	2006-03-31 15:04:14.000000000 +0200
@@ -0,0 +1 @@
+obj-$(CONFIG_IP6_NF_MATCH_CONDITION) +=3D ip6t_condition.o

--Boundary-01=_AqSLEg3L38frWCl--

--nextPart1260288.hsplJAEtRh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBELSqEh3gWNw6JlW4RAvwFAJsFix1wOHUXQsXQyvNi9rgA/WH9hACeJ6mf
bb9kFprX0GMeFkXi+B+TFFA=
=Gf6C
-----END PGP SIGNATURE-----

--nextPart1260288.hsplJAEtRh--
