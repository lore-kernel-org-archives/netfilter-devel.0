From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [RELEASE]  Condition variable match module
Date: Tue, 11 Feb 2003 17:56:31 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E497F9F.5000608@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Folks,

    here's the second version of the condition variable match module. 
 There are two separate sets of patches in order to support ip6tables.

Regards,

Stephane Ouellette.


--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=condition.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch

diff -aruN linux-2.4.21-pre4-ac3-orig/include/linux/netfilter_ipv4/ipt_condition.h linux-2.4.21-pre4-ac3/include/linux/netfilter_ipv4/ipt_condition.h
--- linux-2.4.21-pre4-ac3-orig/include/linux/netfilter_ipv4/ipt_condition.h	Wed Dec 31 19:00:00 1969
+++ linux-2.4.21-pre4-ac3/include/linux/netfilter_ipv4/ipt_condition.h	Mon Feb 10 22:39:19 2003
@@ -0,0 +1,11 @@
+#ifndef __IPT_CONDITION_MATCH__
+#define __IPT_CONDITION_MATCH__
+
+#define CONDITION_NAME_LEN  32
+
+struct condition_info {
+  char	name[CONDITION_NAME_LEN];
+  int   invert;
+};
+
+#endif
diff -aruN linux-2.4.21-pre4-ac3-orig/net/ipv4/netfilter/ipt_condition.c linux-2.4.21-pre4-ac3/net/ipv4/netfilter/ipt_condition.c
--- linux-2.4.21-pre4-ac3-orig/net/ipv4/netfilter/ipt_condition.c	Wed Dec 31 19:00:00 1969
+++ linux-2.4.21-pre4-ac3/net/ipv4/netfilter/ipt_condition.c	Mon Feb 10 22:39:35 2003
@@ -0,0 +1,247 @@
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
+  int       enabled;      // TRUE == 1, FALSE == 0
+  atomic_t  refcount; 
+  struct condition_variable *next;
+  struct proc_dir_entry *status_proc;
+};
+
+
+static rwlock_t list_lock;
+static struct condition_variable *head = NULL;
+static struct proc_dir_entry *proc_net_condition = NULL;
+
+
+static int ipt_condition_read_info(char *buffer, char **start, off_t offset,
+int length, int *eof, void *data)
+{
+  struct condition_variable *var = (struct condition_variable*)data;
+
+  if(offset == 0)
+  {
+    *start = buffer;
+    buffer[0] = (var->enabled) ? '1' : '0';
+    buffer[1] = '\n';
+    return(2);
+  }
+
+  *eof = 1;
+  return(0);
+}
+
+
+static int ipt_condition_write_info(struct file *file, const char *buffer,
+unsigned long length, void *data)
+{
+  struct condition_variable *var = (struct condition_variable*)data;
+
+  if(length)
+  {
+    // Match only on the first character
+    switch(buffer[0])
+    {
+    case '0': var->enabled = 0; break;
+    case '1': var->enabled = 1;
+    }
+  }
+
+  return((int)length);
+}
+
+
+static int match(const struct sk_buff *skb, const struct net_device *in,
+const struct net_device *out, const void *matchinfo, int offset,
+const void *hdr, u_int16_t datalen, int *hotdrop)
+{
+  const struct condition_info *info = (const struct condition_info*)matchinfo;
+  struct condition_variable *var;
+  int    condition_status = 0;
+
+  read_lock(&list_lock);
+
+  for(var = head; var; var = var->next)
+  {
+    if(strcmp(info->name, var->status_proc->name) == 0)
+    {
+      condition_status = var->enabled;
+      break;
+    }
+  }
+
+  read_unlock(&list_lock);
+
+  return(condition_status ^ info->invert);
+}
+
+
+
+static int checkentry(const char *tablename, const struct ipt_ip *ip,
+void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
+{
+  struct condition_info *info = (struct condition_info*)matchinfo;
+  struct condition_variable *var, *newvar;
+
+  if(matchsize != IPT_ALIGN(sizeof(struct condition_info)))
+    return(0);
+
+  // The first step is to check if the condition variable already exists.
+  read_lock(&list_lock);   // Here, a read lock is sufficient because we won't change the list
+
+  for(var = head; var; var = var->next)
+  {
+    if(strcmp(info->name, var->status_proc->name) == 0)
+    {
+      // The condition variable already exists, increment the reference count and exit
+      atomic_inc(&var->refcount);
+      read_unlock(&list_lock);
+      return(1);
+    }
+  }
+
+  read_unlock(&list_lock);
+
+  // At this point, we need to allocate a new condition variable
+  if((newvar = kmalloc(sizeof(struct condition_variable), GFP_KERNEL)) == NULL)
+    return(-ENOMEM);
+
+  // Create the condition variable's proc file entry
+  if((newvar->status_proc = create_proc_entry(info->name, 0644, proc_net_condition)) == NULL)
+  {
+    // There are two possibilities:
+    // 1- Another process has just created a condition variable with the same name, which is valid.
+    // 2- There was a memory allocation error.
+    kfree(newvar);
+    read_lock(&list_lock);   // Here, a read lock is sufficient because we won't change the list
+
+    for(var = head; var; var = var->next)
+    {
+      if(strcmp(info->name, var->status_proc->name) == 0)
+      {
+	// The condition variable already exists, increment the reference count and exit
+	atomic_inc(&var->refcount);
+	read_unlock(&list_lock);
+	return(1);
+      }
+    }
+
+    read_unlock(&list_lock);
+    return(-ENOMEM);
+  }
+
+  atomic_set(&newvar->refcount, 1);
+  newvar->enabled = 0;
+  newvar->status_proc->owner = THIS_MODULE;
+  newvar->status_proc->data = newvar;
+  wmb();
+  newvar->status_proc->read_proc = ipt_condition_read_info;
+  newvar->status_proc->write_proc = ipt_condition_write_info;
+
+  // It's time to insert the new element at the beginning of the list
+  write_lock(&list_lock);
+
+  newvar->next = head;
+  head = newvar;
+
+  write_unlock(&list_lock);
+
+  return(1);
+}
+
+
+static void destroy(void *matchinfo, unsigned int matchsize)
+{
+  struct condition_info *info = (struct condition_info*)matchinfo;
+  struct condition_variable *var, *prev = NULL;
+
+  if(matchsize != IPT_ALIGN(sizeof(struct condition_info)))
+    return;
+
+  write_lock(&list_lock);
+
+  for(var = head; var && strcmp(info->name, var->status_proc->name); prev = var, var = var->next);
+
+  if(var && atomic_dec_and_test(&var->refcount))
+  {
+    if(prev)
+      prev->next = var->next;
+    else
+      head = var->next;
+
+    write_unlock(&list_lock);
+    remove_proc_entry(var->status_proc->name, proc_net_condition);
+    kfree(var);
+  }
+  else
+    write_unlock(&list_lock);
+}
+
+
+static struct ipt_match condition_match = {
+  .list = { .next = NULL, .prev = NULL },
+  .name = "condition",
+  .match = &match,
+  .checkentry = &checkentry,
+  .destroy = &destroy,
+  .me = THIS_MODULE
+};
+
+
+static int __init init(void)
+{
+  int  errorcode;
+
+  rwlock_init(&list_lock);
+  proc_net_condition = proc_mkdir("ipt_condition", proc_net);
+
+  if(proc_net_condition)
+  {
+    if((errorcode = ipt_register_match(&condition_match)) != 0)
+      remove_proc_entry("ipt_condition", proc_net);
+  }
+  else errorcode = -EACCES;
+
+  return(errorcode);
+}
+
+
+static void __exit fini(void)
+{
+  ipt_unregister_match(&condition_match);
+  remove_proc_entry("ipt_condition", proc_net);
+}
+
+module_init(init);
+module_exit(fini);

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=condition.patch.config.in; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch.config.in

  dep_tristate '  TOS match support' CONFIG_IP_NF_MATCH_TOS $CONFIG_IP_NF_IPTABLES
  dep_tristate '  condition match support' CONFIG_IP_NF_MATCH_CONDITION $CONFIG_IP_NF_IPTABLES

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=condition.patch.configure.help; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch.configure.help

CONFIG_IP_NF_MATCH_TOS
Condition variable match support
CONFIG_IP_NF_MATCH_CONDITION
  This option allows you to match firewall rules against condition
  variables stored in the /proc/net/ipt_condition directory.

  If you want to compile it as a module, say M here and read
  Documentation/modules.txt.  If unsure, say `N'.

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=condition.patch.help; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch.help

Author: Stephane Ouellette <ouellettes@videotron.ca>
Status: ItWorksForMe(tm)

This patch adds CONFIG_IP_NF_MATCH_CONDITION which allows you to
match firewall rules against condition variables stored in the
/proc/net/ipt_condition directory. Multiple rules can match on a single
condition variable.

Example:
iptables -A INPUT -p tcp -m condition --condition web_ok --dport 80 -j ACCEPT

To allow this rule to match:
echo 1 > /proc/net/ipt_condition/web_ok

To disable this rule: 
echo 0 > /proc/net/ipt_condition/web_ok


--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=condition.patch.makefile; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch.makefile

obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
obj-$(CONFIG_IP_NF_MATCH_CONDITION) += ipt_condition.o

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=condition6.patch.ipv6; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition6.patch.ipv6

diff -aruN linux-2.4.21-pre4-ac3-orig/include/linux/netfilter_ipv6/ip6t_condition.h linux-2.4.21-pre4-ac3/include/linux/netfilter_ipv6/ip6t_condition.h
--- linux-2.4.21-pre4-ac3-orig/include/linux/netfilter_ipv6/ip6t_condition.h	Wed Dec 31 19:00:00 1969
+++ linux-2.4.21-pre4-ac3/include/linux/netfilter_ipv6/ip6t_condition.h	Mon Feb 10 22:43:22 2003
@@ -0,0 +1,11 @@
+#ifndef __IP6T_CONDITION_MATCH__
+#define __IP6T_CONDITION_MATCH__
+
+#define CONDITION6_NAME_LEN  32
+
+struct condition6_info {
+  char	name[CONDITION6_NAME_LEN];
+  int   invert;
+};
+
+#endif
diff -aruN linux-2.4.21-pre4-ac3-orig/net/ipv6/netfilter/ip6t_condition.c linux-2.4.21-pre4-ac3/net/ipv6/netfilter/ip6t_condition.c
--- linux-2.4.21-pre4-ac3-orig/net/ipv6/netfilter/ip6t_condition.c	Wed Dec 31 19:00:00 1969
+++ linux-2.4.21-pre4-ac3/net/ipv6/netfilter/ip6t_condition.c	Mon Feb 10 22:43:46 2003
@@ -0,0 +1,243 @@
+/*-------------------------------------------*\
+|    Netfilter Condition Module for IPv6      |
+|                                             |
+|  Description: This module allows firewall   |
+|    rules to match using condition variables |
+|    stored in /proc files.                   |
+|                                             |
+|  Author: Stephane Ouellette     2003-02-10  |
+|          <ouellettes@videotron.ca>          |
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
+  int       enabled;      // TRUE == 1, FALSE == 0
+  atomic_t  refcount; 
+  struct condition_variable *next;
+  struct proc_dir_entry *status_proc;
+};
+
+
+static rwlock_t list_lock;
+static struct condition_variable *head = NULL;
+static struct proc_dir_entry *proc_net_condition = NULL;
+
+
+static int ipt_condition_read_info(char *buffer, char **start, off_t offset,
+int length, int *eof, void *data)
+{
+  struct condition_variable *var = (struct condition_variable*)data;
+
+  if(offset == 0)
+  {
+    *start = buffer;
+    buffer[0] = (var->enabled) ? '1' : '0';
+    buffer[1] = '\n';
+    return(2);
+  }
+
+  *eof = 1;
+  return(0);
+}
+
+
+static int ipt_condition_write_info(struct file *file, const char *buffer,
+unsigned long length, void *data)
+{
+  struct condition_variable *var = (struct condition_variable*)data;
+
+  if(length)
+  {
+    // Match only on the first character
+    switch(buffer[0])
+    {
+    case '0': var->enabled = 0; break;
+    case '1': var->enabled = 1;
+    }
+  }
+
+  return((int)length);
+}
+
+
+static int match(const struct sk_buff *skb, const struct net_device *in,
+const struct net_device *out, const void *matchinfo, int offset,
+const void *hdr, u_int16_t datalen, int *hotdrop)
+{
+  const struct condition6_info *info = (const struct condition6_info*)matchinfo;
+  struct condition_variable *var;
+  int    condition_status = 0;
+
+  read_lock(&list_lock);
+
+  for(var = head; var; var = var->next)
+  {
+    if(strcmp(info->name, var->status_proc->name) == 0)
+    {
+      condition_status = var->enabled;
+      break;
+    }
+  }
+
+  read_unlock(&list_lock);
+
+  return(condition_status ^ info->invert);
+}
+
+
+
+static int checkentry(const char *tablename, const struct ip6t_ip6 *ip,
+void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
+{
+  struct condition6_info *info = (struct condition6_info*)matchinfo;
+  struct condition_variable *var, *newvar;
+
+  if(matchsize != IP6T_ALIGN(sizeof(struct condition6_info)))
+    return(0);
+
+  // The first step is to check if the condition variable already exists.
+  read_lock(&list_lock);   // Here, a read lock is sufficient because we won't change the list
+
+  for(var = head; var; var = var->next)
+  {
+    if(strcmp(info->name, var->status_proc->name) == 0)
+    {
+      // The condition variable already exists, increment the reference count and exit
+      atomic_inc(&var->refcount);
+      read_unlock(&list_lock);
+      return(1);
+    }
+  }
+
+  read_unlock(&list_lock);
+
+  // At this point, we need to allocate a new condition variable
+  if((newvar = kmalloc(sizeof(struct condition_variable), GFP_KERNEL)) == NULL)
+    return(-ENOMEM);
+
+  // Create the condition variable's proc file entry
+  if((newvar->status_proc = create_proc_entry(info->name, 0644, proc_net_condition)) == NULL)
+  {
+    // There are two possibilities:
+    // 1- Another process has just created a condition variable with the same name, which is valid.
+    // 2- There was a memory allocation error.
+    kfree(newvar);
+    read_lock(&list_lock);   // Here, a read lock is sufficient because we won't change the list
+
+    for(var = head; var; var = var->next)
+    {
+      if(strcmp(info->name, var->status_proc->name) == 0)
+      {
+	// The condition variable already exists, increment the reference count and exit
+	atomic_inc(&var->refcount);
+	read_unlock(&list_lock);
+	return(1);
+      }
+    }
+
+    read_unlock(&list_lock);
+    return(-ENOMEM);
+  }
+
+  atomic_set(&newvar->refcount, 1);
+  newvar->enabled = 0;
+  newvar->status_proc->owner = THIS_MODULE;
+  newvar->status_proc->data = newvar;
+  wmb();
+  newvar->status_proc->read_proc = ipt_condition_read_info;
+  newvar->status_proc->write_proc = ipt_condition_write_info;
+
+  // It's time to insert the new element at the beginning of the list
+  write_lock(&list_lock);
+
+  newvar->next = head;
+  head = newvar;
+
+  write_unlock(&list_lock);
+
+  return(1);
+}
+
+
+static void destroy(void *matchinfo, unsigned int matchsize)
+{
+  struct condition6_info *info = (struct condition6_info*)matchinfo;
+  struct condition_variable *var, *prev = NULL;
+
+  if(matchsize != IP6T_ALIGN(sizeof(struct condition6_info)))
+    return;
+
+  write_lock(&list_lock);
+
+  for(var = head; var && strcmp(info->name, var->status_proc->name); prev = var, var = var->next);
+
+  if(var && atomic_dec_and_test(&var->refcount))
+  {
+    if(prev)
+      prev->next = var->next;
+    else
+      head = var->next;
+
+    write_unlock(&list_lock);
+    remove_proc_entry(var->status_proc->name, proc_net_condition);
+    kfree(var);
+  }
+  else
+    write_unlock(&list_lock);
+}
+
+
+static struct ip6t_match condition_match = {
+  .list = { .next = NULL, .prev = NULL },
+  .name = "condition",
+  .match = &match,
+  .checkentry = &checkentry,
+  .destroy = &destroy,
+  .me = THIS_MODULE
+};
+
+
+static int __init init(void)
+{
+  int  errorcode;
+
+  rwlock_init(&list_lock);
+  proc_net_condition = proc_mkdir("ip6t_condition", proc_net);
+
+  if(proc_net_condition)
+  {
+    if((errorcode = ipt_register_match(&condition_match)) != 0)
+      remove_proc_entry("ip6t_condition", proc_net);
+  }
+  else errorcode = -EACCES;
+
+  return(errorcode);
+}
+
+
+static void __exit fini(void)
+{
+  ipt_unregister_match(&condition_match);
+  remove_proc_entry("ip6t_condition", proc_net);
+}
+
+module_init(init);
+module_exit(fini);

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=condition6.patch.ipv6.config.in; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition6.patch.ipv6.config.in

  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
  dep_tristate '  Condition variable match support' CONFIG_IP6_NF_MATCH_CONDITION $CONFIG_IP6_NF_IPTABLES

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=condition6.patch.ipv6.configure.help;
 CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition6.patch.ipv6.configure.help

CONFIG_IP6_NF_MATCH_MARK
Condition variable match support
CONFIG_IP6_NF_MATCH_CONDITION
  This option allows you to match firewall rules against condition
  variables stored in the /proc/net/ipt_condition directory.

  If you want to compile it as a module, say M here and read
  Documentation/modules.txt.  If unsure, say `N'.

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=condition6.patch.ipv6.help; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition6.patch.ipv6.help

Author: Stephane Ouellette <ouellettes@videotron.ca>
Status: ItWorksForMe(tm)

This patch adds CONFIG_IP6_NF_MATCH_CONDITION which allows you to
match firewall rules against condition variables stored in the
/proc/net/ip6t_condition directory. Multiple rules can match on a single
condition variable.

Example:
ip6tables -A INPUT -p tcp -m condition --condition web_ok --dport 80 -j ACCEPT

To allow this rule to match:
echo 1 > /proc/net/ip6t_condition/web_ok

To disable this rule: 
echo 0 > /proc/net/ip6t_condition/web_ok


--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=condition6.patch.ipv6.makefile; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition6.patch.ipv6.makefile

obj-$(CONFIG_IP6_NF_MATCH_MARK) += ip6t_mark.o
obj-$(CONFIG_IP6_NF_MATCH_CONDITION) += ip6t_condition.o

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=libip6t_condition.c; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_condition.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <ip6tables.h>

#include<linux/netfilter_ipv6/ip6_tables.h>
#include<linux/netfilter_ipv6/ip6t_condition.h>


static void help(void)
{
  printf("condition match v%s options:\n"
  "--condition [!] filename       Match on boolean value stored in /proc file"
  "\n", IPTABLES_VERSION);
}


static struct option opts[] = {
  { .name = "condition", .has_arg = 1, .flag = 0, .val = 'X' },
  { .name = 0 }
};


static void init(struct ip6t_entry_match *m, unsigned int *nfcache)
{
  *nfcache |= NFC_UNKNOWN;
}


static int parse(int c, char **argv, int invert, unsigned int *flags,
		const struct ip6t_entry *entry, unsigned int *nfcache,
		struct ip6t_entry_match **match)
{
  struct condition6_info *info = (struct condition6_info*)(*match)->data;

  check_inverse(optarg, &invert, &optind, 0);

  if(*flags)
    exit_error(PARAMETER_PROBLEM, "Can't specify multiple conditions");

  if(c == 'X')
  {
    if(strlen(argv[optind-1]) < CONDITION6_NAME_LEN)
      strcpy(info->name, argv[optind-1]);
    else
      exit_error(PARAMETER_PROBLEM, "File name too long");

    info->invert = invert;
    *flags = 1;
    return 1;
  }

  return 0;
}


static void final_check(unsigned int flags)
{
  if(!flags)
    exit_error(PARAMETER_PROBLEM, "Condition match: must specify --condition");
}


static void print(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match, int numeric)
{
  const struct condition6_info *info = (const struct condition6_info*)match->data;

  printf("condition %s%s ", (info->invert) ? "!" : "", info->name);
}


static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
{
  const struct condition6_info *info = (const struct condition6_info*)match->data;

  printf("--condition %s%s ", (info->invert) ? "! " : "", info->name);
}


static struct ip6tables_match condition = {
  .next          = NULL,
  .name          = "condition",
  .version       = IPTABLES_VERSION,
  .size          = IP6T_ALIGN(sizeof(struct condition6_info)),
  .userspacesize = IP6T_ALIGN(sizeof(struct condition6_info)),
  .help          = &help,
  .init          = &init,
  .parse         = &parse,
  .final_check   = &final_check,
  .print         = &print,
  .save          = &save,
  .extra_opts    = opts
};


void _init(void)
{
  register_match6(&condition);
}


--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=libipt_condition.c; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libipt_condition.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <iptables.h>

#include<linux/netfilter_ipv4/ip_tables.h>
#include<linux/netfilter_ipv4/ipt_condition.h>


static void help(void)
{
  printf("condition match v%s options:\n"
  "--condition [!] filename       Match on boolean value stored in /proc file"
  "\n", IPTABLES_VERSION);
}


static struct option opts[] = {
  { .name = "condition", .has_arg = 1, .flag = 0, .val = 'X' },
  { .name = 0 }
};


static void init(struct ipt_entry_match *m, unsigned int *nfcache)
{
  *nfcache |= NFC_UNKNOWN;
}


static int parse(int c, char **argv, int invert, unsigned int *flags,
		const struct ipt_entry *entry, unsigned int *nfcache,
		struct ipt_entry_match **match)
{
  struct condition_info *info = (struct condition_info*)(*match)->data;

  check_inverse(optarg, &invert, &optind, 0);

  if(*flags)
    exit_error(PARAMETER_PROBLEM, "Can't specify multiple conditions");

  if(c == 'X')
  {
    if(strlen(argv[optind-1]) < CONDITION_NAME_LEN)
      strcpy(info->name, argv[optind-1]);
    else
      exit_error(PARAMETER_PROBLEM, "File name too long");

    info->invert = invert;
    *flags = 1;
    return 1;
  }

  return 0;
}


static void final_check(unsigned int flags)
{
  if(!flags)
    exit_error(PARAMETER_PROBLEM, "Condition match: must specify --condition");
}


static void print(const struct ipt_ip *ip,
		const struct ipt_entry_match *match, int numeric)
{
  const struct condition_info *info = (const struct condition_info*)match->data;

  printf("condition %s%s ", (info->invert) ? "!" : "", info->name);
}


static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
{
  const struct condition_info *info = (const struct condition_info*)match->data;

  printf("--condition %s%s ", (info->invert) ? "! " : "", info->name);
}


static struct iptables_match condition = {
  .next          = NULL,
  .name          = "condition",
  .version       = IPTABLES_VERSION,
  .size          = IPT_ALIGN(sizeof(struct condition_info)),
  .userspacesize = IPT_ALIGN(sizeof(struct condition_info)),
  .help          = &help,
  .init          = &init,
  .parse         = &parse,
  .final_check   = &final_check,
  .print         = &print,
  .save          = &save,
  .extra_opts    = opts
};


void _init(void)
{
  register_match(&condition);
}

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=.condition-test; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=.condition-test

#!/bin/sh
# True if condition is applied.
[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h ] && echo condition

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)
Content-type: text/plain; name=.condition-test6; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=.condition-test6

#!/bin/sh
# True if condition6 is applied.
[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_condition.h ] && echo condition

--Boundary_(ID_AQSf8+2keoIpNy5V87+z6g)--
