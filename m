From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]  ip6tables support for the CONDITION MATCH
Date: Sat, 16 Nov 2002 16:36:34 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DD6BA62.2040707@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_pgXJzJW57HMRFYeYrvEsFw)"
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

--Boundary_(ID_pgXJzJW57HMRFYeYrvEsFw)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

   here is a patch to the condition match to support ip6tables.  IPv6 
support will be compiled only if selected in the kernel configuration.

   There is also a patch for userspace/extensions/Makefile.

Regards,

Stephane Ouellette


--Boundary_(ID_pgXJzJW57HMRFYeYrvEsFw)
Content-type: text/plain; name=condition.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch

--- linux-orig/include/linux/netfilter_ipv4/ipt_condition.h	1969-12-31 19:00:00.000000000 -0500
+++ linux/include/linux/netfilter_ipv4/ipt_condition.h	2002-11-10 00:11:49.000000000 -0500
@@ -0,0 +1,11 @@
+#ifndef __IPT_CONDITION_MATCH__
+#define __IPT_CONDITION_MATCH__
+
+#define VARIABLE_NAME_LEN  32
+
+struct condition_info {
+  char	name[VARIABLE_NAME_LEN];
+  int   invert;
+};
+
+#endif
--- linux-orig/net/ipv4/netfilter/ipt_condition.c	1969-12-31 19:00:00.000000000 -0500
+++ linux/net/ipv4/netfilter/ipt_condition.c	2002-11-10 00:19:59.000000000 -0500
@@ -0,0 +1,275 @@
+/*-------------------------------------------*\
+|          Netfilter Condition Module         |
+|                                             |
+|  Description: This module allows firewall   |
+|    rules to match using condition variables |
+|    stored in /proc files.  It allows IPv4   |
+|    and IPv6 firewall rules to share their   |
+|    condition variables.                     |
+|                                             |
+|  Author: Stephane Ouellette     2002-10-22  |
+|          <ouellettes@videotron.ca>          |
+\*-------------------------------------------*/
+
+#include<linux/module.h>
+#include<linux/proc_fs.h>
+#include<linux/spinlock.h>
+#include<linux/interrupt.h>
+#include<asm/uaccess.h>
+#include<linux/ctype.h>
+#include<linux/vmalloc.h>
+
+#include<linux/netfilter_ipv4/ip_tables.h>
+#include<linux/netfilter_ipv4/ipt_condition.h>
+
+#ifdef CONFIG_IPV6
+#include<linux/netfilter_ipv6/ip6_tables.h>
+#endif
+
+MODULE_AUTHOR("Stephane Ouellette <ouellettes@videotron.ca>");
+MODULE_DESCRIPTION("Allows rules to match against condition variables");
+MODULE_LICENSE("GPL");
+
+
+struct condition_variable {
+  char         name[VARIABLE_NAME_LEN];
+			   // Variable Name (NULL-terminated string)
+  u_int32_t    refcount;   // Number of references to this variable
+  u_int32_t    boolean;    // TRUE == 1, FALSE == 0
+  spinlock_t   variable_lock;
+  struct proc_dir_entry *status_proc;
+  struct condition_variable *next;
+};
+
+
+static spinlock_t list_lock = SPIN_LOCK_UNLOCKED;
+static struct condition_variable *head = NULL;
+static struct proc_dir_entry *proc_net_condition = NULL;
+
+
+static int ipt_condition_read_info(char *buffer, char **start, off_t offset,
+int length, int *eof, void *data)
+{
+  if(offset == 0)
+  {
+    *start = buffer;
+    buffer[0] = '0' + (char)((struct condition_variable*)data)->boolean;
+    buffer[1] = '\n';
+    return 2;
+  }
+ 
+  *eof = 1;
+  return 0;
+}
+
+
+static int ipt_condition_write_info(struct file *file, const char *buffer,
+unsigned long length, void *data)
+{
+  if(length)
+  {
+    // Match only on the first character
+    if(buffer[0] == '0')
+      ((struct condition_variable*)data)->boolean = 0;
+    else if(buffer[0] == '1') 
+      ((struct condition_variable*)data)->boolean = 1;
+  }
+
+  return length;
+}
+
+
+static int match(const struct sk_buff *skb, const struct net_device *in,
+const struct net_device *out, const void *matchinfo, int offset,
+const void *hdr, u_int16_t datalen, int *hotdrop)
+{
+  const struct condition_info *info = (const struct condition_info*)matchinfo;
+  struct condition_variable *var = head;
+  
+  while(var && strncmp(info->name, var->name, VARIABLE_NAME_LEN))
+    var = var->next;
+
+  return((var) ? var->boolean ^ info->invert : 0);
+}
+
+
+static int checkentry_common(struct condition_info *info)
+{
+  struct condition_variable *var = head, *previous = NULL;
+
+  spin_lock_bh(&list_lock);
+
+  // Search for the condition variable in the list
+  while(var && (strncmp(info->name, var->name, VARIABLE_NAME_LEN))) 
+  {
+    previous = var;
+    var = var->next;
+  }
+
+  if(var)
+  {
+    // The variable already exists, increment the reference count
+    spin_lock_bh(&var->variable_lock);
+    var->refcount++;    
+    spin_unlock_bh(&var->variable_lock);
+  }
+  else
+  {
+    // Create a new variable 
+    if((var = vmalloc(sizeof(struct condition_variable))) == NULL)
+    {
+      spin_unlock_bh(&list_lock);
+      return -ENOMEM;
+    }
+
+    strncpy(var->name, info->name, VARIABLE_NAME_LEN - 1);
+    var->name[VARIABLE_NAME_LEN - 1] = 0;
+    var->refcount = 1;
+    var->boolean = 0;
+    var->variable_lock = SPIN_LOCK_UNLOCKED;
+    var->next = NULL;
+    var->status_proc = create_proc_entry(var->name, 0644, proc_net_condition);
+
+    if(!var->status_proc)
+    {
+      vfree(var);
+      spin_unlock_bh(&list_lock);
+      return -ENOMEM;
+    }
+
+    var->status_proc->owner = THIS_MODULE;
+    var->status_proc->read_proc = ipt_condition_read_info;
+    var->status_proc->write_proc = ipt_condition_write_info;
+    var->status_proc->data = var;
+
+    if(previous)
+      previous->next = var;
+    else
+      head = var;
+  }
+
+  spin_unlock_bh(&list_lock);
+  return 1;
+}
+
+
+static int checkentry4(const char *tablename, const struct ipt_ip *ip,
+void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
+{
+  if(matchsize != IPT_ALIGN(sizeof(struct condition_info)))
+    return 0;
+
+  return checkentry_common((struct condition_info*)matchinfo);
+}
+
+
+#ifdef CONFIG_IPV6
+static int checkentry6(const char *tablename, const struct ip6t_ip6 *ip,
+void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
+{
+  if(matchsize != IP6T_ALIGN(sizeof(struct condition_info)))
+    return 0;
+
+  return checkentry_common((struct condition_info*)matchinfo);
+}
+#endif
+
+
+static void destroy_common(struct condition_info *info)
+{
+  struct condition_variable *var = head, *previous = NULL;
+  
+  spin_lock_bh(&list_lock);
+
+  while(var && strncmp(info->name, var->name, VARIABLE_NAME_LEN))
+  {
+    previous = var;
+    var = var->next;
+  }
+
+  if(var)
+  {
+    spin_lock_bh(&var->variable_lock);
+
+    if(--var->refcount == 0)
+    {
+      if(previous)
+        previous->next = var->next;
+      else
+        head = var->next;
+
+      remove_proc_entry(var->name, proc_net_condition);
+      spin_unlock_bh(&var->variable_lock);
+      vfree(var);
+    }
+    else spin_unlock_bh(&var->variable_lock);
+  }
+
+  spin_unlock_bh(&list_lock);
+}
+
+
+static void destroy4(void *matchinfo, unsigned int matchsize)
+{
+  if(matchsize == IPT_ALIGN(sizeof(struct condition_info)))
+    destroy_common((struct condition_info*)matchinfo);
+}
+
+
+#ifdef CONFIG_IPV6
+static void destroy6(void *matchinfo, unsigned int matchsize)
+{
+  if(matchsize == IP6T_ALIGN(sizeof(struct condition_info)))
+    destroy_common((struct condition_info*)matchinfo);
+}
+#endif
+
+
+static struct ipt_match condition_match4 =
+{ { NULL, NULL }, "condition", &match, &checkentry4, &destroy4, THIS_MODULE };
+
+
+#ifdef CONFIG_IPV6
+static struct ip6t_match condition_match6 =
+{ { NULL, NULL }, "condition", &match, &checkentry6, &destroy6, THIS_MODULE };
+#endif
+
+
+static int __init init(void)
+{
+  int  errorcode;
+  proc_net_condition = proc_mkdir("ipt_condition", proc_net);
+
+  if(proc_net_condition)
+  {
+    errorcode = ipt_register_match(&condition_match4);
+
+#ifdef CONFIG_IPV6
+    if(errorcode == 0)
+    {
+      if((errorcode = ip6t_register_match(&condition_match6)) != 0)
+        ipt_unregister_match(&condition_match4);
+    }
+#endif
+
+    if(errorcode != 0)
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
+#ifdef CONFIG_IPV6
+  ip6t_unregister_match(&condition_match6);
+#endif
+  ipt_unregister_match(&condition_match4);
+  remove_proc_entry("ipt_condition", proc_net);
+}
+
+module_init(init);
+module_exit(fini);
+

--Boundary_(ID_pgXJzJW57HMRFYeYrvEsFw)
Content-type: text/plain; name=libip6t_condition.c; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_condition.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <ip6tables.h>

#include<linux/netfilter_ipv6/ip6_tables.h>
#include<linux/netfilter_ipv4/ipt_condition.h>


static void help(void)
{
  printf("condition match v%s options:\n"
  "--condition [!] filename       Match on boolean value stored in /proc file"
  "\n", IPTABLES_VERSION);
}

static struct option opts[] = { { "condition", 1, 0, 'X' }, { 0 } };

static void init(struct ip6t_entry_match *m, unsigned int *nfcache)
{
  *nfcache |= NFC_UNKNOWN;
}

static int parse(int c, char **argv, int invert, unsigned int *flags,
		const struct ip6t_entry *entry, unsigned int *nfcache,
		struct ip6t_entry_match **match)
{
  struct condition_info *info = (struct condition_info*)(*match)->data;

  check_inverse(optarg, &invert, &optind, 0);

  if(*flags)
    exit_error(PARAMETER_PROBLEM, "Can't specify multiple conditions");

  if(c == 'X')
  {
    if(strlen(argv[optind-1]) < VARIABLE_NAME_LEN)
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


static void print(const struct ip6t_ip6 *ip,
		const struct ip6t_entry_match *match, int numeric)
{
  const struct condition_info *info = (const struct condition_info*)match->data;

  printf("condition %s%s ", (info->invert) ? "!" : "", info->name);
}


static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
{
  const struct condition_info *info = (const struct condition_info*)match->data;

  printf("--condition %s%s ", (info->invert) ? "! " : "", info->name);
}


static struct ip6tables_match condition = {
  NULL,
  "condition",
  IPTABLES_VERSION,
  IP6T_ALIGN(sizeof(struct condition_info)),
  IP6T_ALIGN(sizeof(struct condition_info)),
  &help,
  &init,
  &parse,
  &final_check,
  &print,
  &save,
  opts
};


void _init(void)
{
  register_match6(&condition);
}


--Boundary_(ID_pgXJzJW57HMRFYeYrvEsFw)
Content-type: text/plain; name=condition.patch.configure.help; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch.configure.help

CONFIG_IP_NF_MATCH_TOS
condition match support
CONFIG_IP_NF_MATCH_CONDITION
  This option allows you to match firewall rules against condition
  variables stored in the /proc/net/ipt_condition directory.

  This module also supports IPv6. Condition variables can be shared
  by IPv4 and IPv6 firewall rules.

  If you want to compile it as a module, say M here and read
  Documentation/modules.txt.  If unsure, say `N'.

--Boundary_(ID_pgXJzJW57HMRFYeYrvEsFw)
Content-type: text/plain; name=condition.patch.help; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch.help

Author: Stephane Ouellette <ouellettes@videotron.ca>
Status: ItWorksForMe(tm)

This patch adds CONFIG_IP_NF_MATCH_CONDITION which allows you to
match firewall rules against condition variables stored in the
/proc/net/ipt_condition directory.

This module now supports IPv6.  Condition variables can be shared
by IPv4 and IPv6 firewall rules.

--Boundary_(ID_pgXJzJW57HMRFYeYrvEsFw)
Content-type: text/plain; name=Makefile.diff; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=Makefile.diff

--- Makefile.old	2002-11-16 16:32:34.000000000 -0500
+++ Makefile	2002-11-16 16:33:15.000000000 -0500
@@ -4,6 +4,7 @@
 PF6_EXT_SLIB:=eui64 icmpv6 length limit mac mark multiport owner standard tcp udp LOG MARK
 
 # The following may not be present, but compile them anyway.
+PF6_EXT_SLIB+=condition
 PF_EXT_SLIB+=TTL iplimit
 
 # Optionals

--Boundary_(ID_pgXJzJW57HMRFYeYrvEsFw)--
