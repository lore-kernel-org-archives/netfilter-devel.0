From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] list register ip6tables targets/matches in /proc/net
Date: Tue, 08 Apr 2003 17:59:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E92F1D2.4070902@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030408090105030605060102"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------030408090105030605060102
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch lists registered ip6tables matches/targets in /proc/net,
the equivalent patch to iptables is already included in pom. I sent
this patch multiple times before, hopefully this time it won't be
overseen.

Bye
Patrick

--------------030408090105030605060102
Content-Type: text/plain;
 name="ip6tables-proc-pom.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip6tables-proc-pom.diff"

diff -urN a/extra/ip6_tables-proc.patch.ipv6 b/extra/ip6_tables-proc.patch.ipv6
--- a/extra/ip6_tables-proc.patch.ipv6	1970-01-01 01:00:00.000000000 +0100
+++ b/extra/ip6_tables-proc.patch.ipv6	2003-04-07 23:54:02.000000000 +0200
@@ -0,0 +1,116 @@
+===== net/ipv6/netfilter/ip6_tables.c 1.12 vs edited =====
+--- 1.12/net/ipv6/netfilter/ip6_tables.c	Sun Sep 22 08:22:57 2002
++++ edited/net/ipv6/netfilter/ip6_tables.c	Mon Apr  7 23:49:45 2003
+@@ -1767,14 +1767,15 @@
+ = { { NULL, NULL }, "icmp6", &icmp6_match, &icmp6_checkentry, NULL };
+ 
+ #ifdef CONFIG_PROC_FS
+-static inline int print_name(const struct ip6t_table *t,
++static inline int print_name(const char *i,
+ 			     off_t start_offset, char *buffer, int length,
+ 			     off_t *pos, unsigned int *count)
+ {
+ 	if ((*count)++ >= start_offset) {
+ 		unsigned int namelen;
+ 
+-		namelen = sprintf(buffer + *pos, "%s\n", t->name);
++		namelen = sprintf(buffer + *pos, "%s\n",
++				  i + sizeof(struct list_head));
+ 		if (*pos + namelen > length) {
+ 			/* Stop iterating */
+ 			return 1;
+@@ -1792,7 +1793,7 @@
+ 	if (down_interruptible(&ip6t_mutex) != 0)
+ 		return 0;
+ 
+-	LIST_FIND(&ip6t_tables, print_name, struct ip6t_table *,
++	LIST_FIND(&ip6t_tables, print_name, char *,
+ 		  offset, buffer, length, &pos, &count);
+ 
+ 	up(&ip6t_mutex);
+@@ -1801,6 +1802,46 @@
+ 	*start=(char *)((unsigned long)count-offset);
+ 	return pos;
+ }
++
++static int ip6t_get_targets(char *buffer, char **start, off_t offset, int length)
++{
++	off_t pos = 0;
++	unsigned int count = 0;
++
++	if (down_interruptible(&ip6t_mutex) != 0)
++		return 0;
++
++	LIST_FIND(&ip6t_target, print_name, char *,
++		  offset, buffer, length, &pos, &count);
++
++	up(&ip6t_mutex);
++
++	*start = (char *)((unsigned long)count - offset);
++	return pos;
++}
++
++static int ip6t_get_matches(char *buffer, char **start, off_t offset, int length)
++{
++	off_t pos = 0;
++	unsigned int count = 0;
++
++	if (down_interruptible(&ip6t_mutex) != 0)
++		return 0;
++
++	LIST_FIND(&ip6t_match, print_name, char *,
++		  offset, buffer, length, &pos, &count);
++
++	up(&ip6t_mutex);
++
++	*start = (char *)((unsigned long)count - offset);
++	return pos;
++}
++
++static struct { char *name; get_info_t *get_info; } ip6t_proc_entry[] =
++{ { "ip6_tables_names", ip6t_get_tables },
++  { "ip6_tables_targets", ip6t_get_targets },
++  { "ip6_tables_matches", ip6t_get_matches },
++  { NULL, NULL} };
+ #endif /*CONFIG_PROC_FS*/
+ 
+ static int __init init(void)
+@@ -1826,13 +1867,19 @@
+ #ifdef CONFIG_PROC_FS
+ 	{
+ 		struct proc_dir_entry *proc;
+-		proc = proc_net_create("ip6_tables_names", 0,
+-					ip6t_get_tables);
+-		if (!proc) {
+-			nf_unregister_sockopt(&ip6t_sockopts);
+-			return -ENOMEM;
++		int i;
++
++		for (i = 0; ip6t_proc_entry[i].name; i++) {
++			proc = proc_net_create(ip6t_proc_entry[i].name, 0,
++					       ip6t_proc_entry[i].get_info);
++			if (!proc) {
++				while (--i >= 0)
++				       proc_net_remove(ip6t_proc_entry[i].name);
++				nf_unregister_sockopt(&ip6t_sockopts);
++				return -ENOMEM;
++			}
++			proc->owner = THIS_MODULE;
+ 		}
+-		proc->owner = THIS_MODULE;
+ 	}
+ #endif
+ 
+@@ -1844,7 +1891,11 @@
+ {
+ 	nf_unregister_sockopt(&ip6t_sockopts);
+ #ifdef CONFIG_PROC_FS
+-	proc_net_remove("ip6_tables_names");
++	{
++		int i;
++		for (i = 0; ip6t_proc_entry[i].name; i++)
++			proc_net_remove(ip6t_proc_entry[i].name);
++	}
+ #endif
+ }
+ 
diff -urN a/extra/ip6_tables-proc.patch.ipv6.help b/extra/ip6_tables-proc.patch.ipv6.help
--- a/extra/ip6_tables-proc.patch.ipv6.help	1970-01-01 01:00:00.000000000 +0100
+++ b/extra/ip6_tables-proc.patch.ipv6.help	2003-04-07 23:48:33.000000000 +0200
@@ -0,0 +1,6 @@
+Author: Patrick McHardy
+Status: Working
+
+This patch creates two new files in /proc/net, "ip6_tables_matches" and 
+"ip6tables_targets" which contain the names of all loaded matches/targets
+like the file ip6_tables_names already does with loaded tables.

--------------030408090105030605060102--
