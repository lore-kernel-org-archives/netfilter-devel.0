From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [NEW EXTENSION] Condition Match
Date: Tue, 29 Oct 2002 13:54:06 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DBED94E.1030107@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_BhfeGma8P15A1+Ful0DG0A)"
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

--Boundary_(ID_BhfeGma8P15A1+Ful0DG0A)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Folks,

   I developped last week a new extension to Netfilter in order to 
enable or disable a set of rules using /proc files.

   As an example, I like to play Quake III Aerna with a few friends of 
mine but I don't want to keep the firewall rules that make them able to 
connect to my computer active at all times.  Adding and removing these 
specific rules is annoying...

    So my solution is illustrated by the following rules:

iptables -t nat -A PREROUTING -p udp -m condition -i $INTERNET --dport 
27960 --condition quake -j DNAT --to-destination $MYCOMPUTER
iptables -t filter -A FORWARD -p udp -m condition -i $INTERNET -o $LAN 
--dport 27960 --condition quake -j ACCEPT
iptables -t filter -A FORWARD -p udp -m condition -i $LAN -o $INTERNET 
--dport 27960 --condition quake -j ACCEPT


To enable the rules, issue:        echo 1 > /proc/net/ipt_condition/quake
To disable the rules, issue:       echo 0> /proc/net/ipt_condition/quake


The /proc files are created automagically when a new condition is 
defined and destroyed when no rule points to them anymore.

As of this writing, the condition match module supports only one 
condition per rule.  I think I will add in a near future the possibility 
to match on many conditions at the same time, using the syntax:     
--condition file1,file2,file3. . .

- It was tested under kernel 2.4.20-pre10-ac2
- So far so good, the condition match module seems stable !

Any comments, bug reports or suggestions would be greatly appreciated.

Enjoy !

Stephane.


--Boundary_(ID_BhfeGma8P15A1+Ful0DG0A)
Content-type: text/plain; name=condition.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch

diff -aruN linux-2.4.20-pre10-ac1-machiavel/include/linux/netfilter_ipv4/ipt_condition.h linux-2.4.20-pre10-ac1-machiavel-new/include/linux/netfilter_ipv4/ipt_condition.h
--- linux-2.4.20-pre10-ac1-machiavel/include/linux/netfilter_ipv4/ipt_condition.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.4.20-pre10-ac1-machiavel-new/include/linux/netfilter_ipv4/ipt_condition.h	2002-10-25 21:26:09.000000000 -0400
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
diff -aruN linux-2.4.20-pre10-ac1-machiavel/net/ipv4/netfilter/ipt_condition.c linux-2.4.20-pre10-ac1-machiavel-new/net/ipv4/netfilter/ipt_condition.c
--- linux-2.4.20-pre10-ac1-machiavel/net/ipv4/netfilter/ipt_condition.c	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.4.20-pre10-ac1-machiavel-new/net/ipv4/netfilter/ipt_condition.c	2002-10-25 23:30:15.000000000 -0400
@@ -0,0 +1,227 @@
+/*-------------------------------------------*\
+|          Netfilter Condition Module         |
+|                                             |
+|  Description: This module allows firewall   |
+|    rules to match using condition variables |
+|    stored in /proc files.                   |
+|                                             |
+|  Author: Stephane Ouellette     2002-10-22  |
+|          (ouellettes@videotron.ca)          |
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
+static int checkentry(const char *tablename, const struct ipt_ip *ip,
+void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
+{
+  struct condition_info *info = (struct condition_info*)matchinfo;
+  struct condition_variable *var, *previous;
+
+  if(matchsize != IPT_ALIGN(sizeof(struct condition_info)))
+    return 0;
+
+  var = head;
+  previous = NULL;
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
+static void destroy(void *matchinfo, unsigned int matchsize)
+{
+  struct condition_info *info = (struct condition_info*)matchinfo;
+  struct condition_variable *var, *previous;
+
+  if(matchsize != IPT_ALIGN(sizeof(struct condition_info)))
+    return;
+
+  var = head;
+  previous = NULL;
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
+static struct ipt_match condition_match =
+{ { NULL, NULL }, "condition", &match, &checkentry, &destroy, THIS_MODULE };
+
+
+static int __init init(void)
+{
+  int  errorcode;
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
+

--Boundary_(ID_BhfeGma8P15A1+Ful0DG0A)
Content-type: text/plain; name=condition.patch.config.in
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch.config.in

  dep_tristate '  TOS match support' CONFIG_IP_NF_MATCH_TOS $CONFIG_IP_NF_IPTABLES
  dep_tristate '  condition match support' CONFIG_IP_NF_MATCH_CONDITION $CONFIG_IP_NF_IPTABLES

--Boundary_(ID_BhfeGma8P15A1+Ful0DG0A)
Content-type: text/plain; name=condition.patch.configure.help
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch.configure.help

CONFIG_IP_NF_MATCH_TOS
condition match support
CONFIG_IP_NF_MATCH_CONDITION
  This option allows you to match firewall rules against condition
  variables stored in /proc files.

  If you want to compile it as a module, say M here and read
  Documentation/modules.txt.  If unsure, say `N'.

--Boundary_(ID_BhfeGma8P15A1+Ful0DG0A)
Content-type: text/plain; name=condition.patch.help
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch.help

Author: Stephane Ouellette <ouellettes@videotron.ca>
Status: ItWorksForMe(tm)

This patch adds CONFIG_IP_NF_MATCH_CONDITION which allows you to
match firewall rules against condition variables stored in /proc files.


--Boundary_(ID_BhfeGma8P15A1+Ful0DG0A)
Content-type: text/plain; name=condition.patch.makefile
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=condition.patch.makefile

obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o

obj-$(CONFIG_IP_NF_MATCH_CONDITION) += ipt_condition.o


--Boundary_(ID_BhfeGma8P15A1+Ful0DG0A)
Content-type: text/plain; name=libipt_condition.c
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

static struct option opts[] = { { "condition", 1, 0, 'X' }, { 0 } };

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
  NULL,
  "condition",
  IPTABLES_VERSION,
  IPT_ALIGN(sizeof(struct condition_info)),
  IPT_ALIGN(sizeof(struct condition_info)),
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
  register_match(&condition);
}


--Boundary_(ID_BhfeGma8P15A1+Ful0DG0A)--
