From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 6/6 RFC] netfilter: add audit netns ID
Date: Thu, 18 May 2017 13:21:52 -0400
Message-ID: <c19c5f9a2b5bf8d43ced7a0a10d2da80934f242a.1495124188.git.rgb@redhat.com>
References: <cover.1495124188.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Richard Guy Briggs <rgb@redhat.com>, Florian Westphal <fw@strlen.de>,
	Thomas Woerner <twoerner@redhat.com>, Thomas Graf <tgraf@infradead.org>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
	linux-audit@redhat.com
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <cover.1495124188.git.rgb@redhat.com>
In-Reply-To: <cover.1495124188.git.rgb@redhat.com>
References: <cover.1495124188.git.rgb@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

Seemingly duplicate NETFILTER_CFG records are not actually exact duplicates
that are caused by netfilter table initialization in different network
namespaces from the same syscall.  To differentiate the NETFILTER_CFG records,
the network namespace ID (proc inode) was added to the record to make this
source evident.

Here is a sample event with accompanied records:
  time->Sun May 14 22:40:26 2017
  type=PROCTITLE msg=audit(1494816026.072:248): proctitle=2F7362696E2F6D6F6470726F6265002D71002D2D0065627461626C655F6E6174
  type=KERN_MODULE msg=audit(1494816026.072:248): name="ebtable_nat"
  type=SYSCALL msg=audit(1494816026.072:248): arch=c000003e syscall=313 success=yes exit=0 a0=0 a1=55c4648d4106 a2=0 a3=0 items=0 ppid=84 pid=431 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="modprobe" exe="/usr/bin/kmod" subj=system_u:system_r:insmod_t:s0 key="mod-load"
  type=NETFILTER_CFG msg=audit(1494816026.072:248): op=register net=324 family=7 table=nat entries=0
  type=NETFILTER_CFG msg=audit(1494816026.072:248): op=register net=121 family=7 table=nat entries=0

and unaccompanied cases:
  type=UNKNOWN[1331] msg=audit(1494815998.178:167): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:iptables_t:s0 pid=598 comm="ip6tables-resto" exe="/usr/sbin/xtables-multi" op=replace net=121 family=10 table=filter entries=4

See: https://github.com/linux-audit/audit-kernel/issues/25

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/netfilter/x_tables.h |    1 +
 net/bridge/netfilter/ebtables.c    |   13 +++++++++----
 net/ipv4/netfilter/arp_tables.c    |    2 +-
 net/ipv4/netfilter/ip_tables.c     |    2 +-
 net/ipv6/netfilter/ip6_tables.c    |    2 +-
 net/netfilter/x_tables.c           |   10 +++++++---
 6 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index be378cf..6be4a04 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -308,6 +308,7 @@ struct xt_table *xt_register_table(struct net *net,
 struct xt_table_info *xt_replace_table(struct xt_table *table,
 				       unsigned int num_counters,
 				       struct xt_table_info *newinfo,
+				       struct net *net,
 				       int *error);
 
 struct xt_match *xt_find_match(u8 af, const char *name, u8 revision);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 59b63a8..0f77b2a 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -27,6 +27,7 @@
 #include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/audit.h>
+#define PROC_DYNAMIC_FIRST 0xF0000000U
 #include <net/sock.h>
 /* needed for logical [in,out]-dev filtering */
 #include "../br_private.h"
@@ -1075,7 +1076,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 			ab = audit_log_start(current->audit_context, GFP_KERNEL,
 					     AUDIT_NETFILTER_CFG);
 			if (ab) {
-				audit_log_format(ab, "op=replace family=%u table=%s entries=%u",
+				audit_log_format(ab, "op=replace net=%u family=%u table=%s entries=%u",
+						 net->ns.inum - PROC_DYNAMIC_FIRST,
 						 AF_BRIDGE, repl->name,
 						 repl->nentries);
 				audit_log_end(ab);
@@ -1085,7 +1087,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 					     AUDIT_NETFILTER_CFGSOLO);
 			if (ab) {
 				audit_log_task(ab);
-				audit_log_format(ab, " op=replace family=%u table=%s entries=%u",
+				audit_log_format(ab, " op=replace net=%u family=%u table=%s entries=%u",
+						 net->ns.inum - PROC_DYNAMIC_FIRST,
 						 AF_BRIDGE, repl->name,
 						 repl->nentries);
 				audit_log_end(ab);
@@ -1259,7 +1262,8 @@ struct ebt_table * ebt_register_table(struct net *net,
 			ab = audit_log_start(current->audit_context, GFP_KERNEL,
 					     AUDIT_NETFILTER_CFG);
 			if (ab) {
-				audit_log_format(ab, "op=register family=%u table=%s entries=%u",
+				audit_log_format(ab, "op=register net=%u family=%u table=%s entries=%u",
+						 net->ns.inum - PROC_DYNAMIC_FIRST,
 						 AF_BRIDGE, repl->name,
 						 repl->nentries);
 				audit_log_end(ab);
@@ -1269,7 +1273,8 @@ struct ebt_table * ebt_register_table(struct net *net,
 					     AUDIT_NETFILTER_CFGSOLO);
 			if (ab) {
 				audit_log_task(ab);
-				audit_log_format(ab, " op=register family=%u table=%s entries=%u",
+				audit_log_format(ab, " op=register net=%u family=%u table=%s entries=%u",
+						 net->ns.inum - PROC_DYNAMIC_FIRST,
 						 AF_BRIDGE, repl->name,
 						 repl->nentries);
 				audit_log_end(ab);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 6241a81..4933a5a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -904,7 +904,7 @@ static int __do_replace(struct net *net, const char *name,
 		goto put_module;
 	}
 
-	oldinfo = xt_replace_table(t, num_counters, newinfo, &ret);
+	oldinfo = xt_replace_table(t, num_counters, newinfo, net, &ret);
 	if (!oldinfo)
 		goto put_module;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 384b857..c638607 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1066,7 +1066,7 @@ static int get_info(struct net *net, void __user *user,
 		goto put_module;
 	}
 
-	oldinfo = xt_replace_table(t, num_counters, newinfo, &ret);
+	oldinfo = xt_replace_table(t, num_counters, newinfo, net, &ret);
 	if (!oldinfo)
 		goto put_module;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 1e15c54..87ef83b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1096,7 +1096,7 @@ static int get_info(struct net *net, void __user *user,
 		goto put_module;
 	}
 
-	oldinfo = xt_replace_table(t, num_counters, newinfo, &ret);
+	oldinfo = xt_replace_table(t, num_counters, newinfo, net, &ret);
 	if (!oldinfo)
 		goto put_module;
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 395ebd3..35533f1 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -26,6 +26,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/audit.h>
+#define PROC_DYNAMIC_FIRST 0xF0000000U
 #include <linux/user_namespace.h>
 #include <net/net_namespace.h>
 
@@ -1151,6 +1152,7 @@ static int xt_jumpstack_alloc(struct xt_table_info *i)
 struct xt_table_info *xt_replace_table(struct xt_table *table,
 				       unsigned int num_counters,
 				       struct xt_table_info *newinfo,
+				       struct net *net,
 				       int *error)
 {
 	struct xt_table_info *private;
@@ -1199,8 +1201,9 @@ struct xt_table_info *xt_replace_table(struct xt_table *table,
 			ab = audit_log_start(current->audit_context, GFP_KERNEL,
 					     AUDIT_NETFILTER_CFG);
 			if (ab) {
-				audit_log_format(ab, "op=%s family=%u table=%s entries=%u",
+				audit_log_format(ab, "op=%s net=%u family=%u table=%s entries=%u",
 						 private->number ? "replace" : "register",
+						 net->ns.inum - PROC_DYNAMIC_FIRST,
 						 table->af, table->name,
 						 private->number);
 				audit_log_end(ab);
@@ -1210,7 +1213,8 @@ struct xt_table_info *xt_replace_table(struct xt_table *table,
 					     AUDIT_NETFILTER_CFGSOLO);
 			if (ab) {
 				audit_log_task(ab);
-				audit_log_format(ab, " op=replace family=%u table=%s entries=%u",
+				audit_log_format(ab, " op=replace net=%u family=%u table=%s entries=%u",
+						 net->ns.inum - PROC_DYNAMIC_FIRST,
 						 table->af, table->name,
 						 private->number);
 				audit_log_end(ab);
@@ -1251,7 +1255,7 @@ struct xt_table *xt_register_table(struct net *net,
 	/* Simplifies replace_table code. */
 	table->private = bootstrap;
 
-	if (!xt_replace_table(table, 0, newinfo, &ret))
+	if (!xt_replace_table(table, 0, newinfo, net, &ret))
 		goto unlock;
 
 	private = table->private;
-- 
1.7.1
