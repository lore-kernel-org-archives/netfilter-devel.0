From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Make 2.6.9-rc1-bk9 compile without CONFIG_SYSCTL
Date: Tue, 07 Sep 2004 18:13:20 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1094293407.32317.20.camel@bach>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Jeremy Kerr <jk@ozlabs.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>,
	Harald Welte <laforge@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Discovered this by accident (nfsim doesn't turn on CONFIG_SYSCTL).

Name: Make sure conntrack compiles without CONFIG_SYSCTL (ip_ct_log_invalid)
Status: Untested
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

ip_ct_log_invalid was added without testing that it compiles without
CONFIG_SYSCTL.  Since sysctl is the only way of turning it on, there
should be no references to it if !CONFIG_SYSCTL.  Also, that turns off
CONFIG_PROC_FS, which elicits more warnings.  Squish them too.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .21815-linux-2.6.9-rc1-bk9/include/linux/netfilter_ipv4/ip_conntrack_protocol.h .21815-linux-2.6.9-rc1-bk9.updated/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
--- .21815-linux-2.6.9-rc1-bk9/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2004-08-25 09:54:14.000000000 +1000
+++ .21815-linux-2.6.9-rc1-bk9.updated/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2004-09-04 19:56:07.000000000 +1000
@@ -75,6 +75,7 @@ extern int ip_conntrack_protocol_tcp_ini
 /* Log invalid packets */
 extern unsigned int ip_ct_log_invalid;
 
+#ifdef CONFIG_SYSCTL
 #ifdef DEBUG_INVALID_PACKETS
 #define LOG_INVALID(proto) \
 	(ip_ct_log_invalid == (proto) || ip_ct_log_invalid == IPPROTO_RAW)
@@ -83,5 +84,8 @@ extern unsigned int ip_ct_log_invalid;
 	((ip_ct_log_invalid == (proto) || ip_ct_log_invalid == IPPROTO_RAW) \
 	 && net_ratelimit())
 #endif
+#else
+#define LOG_INVALID(proto) 0
+#endif /* CONFIG_SYSCTL */
 
 #endif /*_IP_CONNTRACK_PROTOCOL_H*/
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .21815-linux-2.6.9-rc1-bk9/net/ipv4/netfilter/ip_conntrack_proto_sctp.c .21815-linux-2.6.9-rc1-bk9.updated/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
--- .21815-linux-2.6.9-rc1-bk9/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-09-03 09:31:10.000000000 +1000
+++ .21815-linux-2.6.9-rc1-bk9.updated/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-09-04 19:53:43.000000000 +1000
@@ -623,8 +623,8 @@ int __init init(void)
 
 	return ret;
 
- cleanup:
 #ifdef CONFIG_SYSCTL
+ cleanup:
 	ip_conntrack_protocol_unregister(&ip_conntrack_protocol_sctp);
 #endif
  out:
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .21815-linux-2.6.9-rc1-bk9/net/ipv4/netfilter/ip_conntrack_standalone.c .21815-linux-2.6.9-rc1-bk9.updated/net/ipv4/netfilter/ip_conntrack_standalone.c
--- .21815-linux-2.6.9-rc1-bk9/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-09-03 09:31:10.000000000 +1000
+++ .21815-linux-2.6.9-rc1-bk9.updated/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-09-04 20:01:37.000000000 +1000
@@ -54,6 +54,7 @@ static int kill_proto(const struct ip_co
 			*((u_int8_t *) data));
 }
 
+#ifdef CONFIG_PROC_FS
 static unsigned int
 print_tuple(char *buffer, const struct ip_conntrack_tuple *tuple,
 	    struct ip_conntrack_protocol *proto)
@@ -367,6 +368,7 @@ static struct file_operations ct_cpu_seq
 	.llseek  = seq_lseek,
 	.release = seq_release_private,
 };
+#endif
 
 static unsigned int ip_confirm(unsigned int hooknum,
 			       struct sk_buff **pskb,
@@ -726,10 +728,15 @@ static ctl_table ip_ct_net_table[] = {
 	},
 	{ .ctl_name = 0 }
 };
-#endif
+
+EXPORT_SYMBOL(ip_ct_log_invalid);
+#endif /* CONFIG_SYSCTL */
+
 static int init_or_cleanup(int init)
 {
+#ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
+#endif
 	int ret = 0;
 
 	if (!init) goto cleanup;
@@ -738,19 +745,20 @@ static int init_or_cleanup(int init)
 	if (ret < 0)
 		goto cleanup_nothing;
 
-	proc = proc_net_create("ip_conntrack", 0440, NULL);
+#ifdef CONFIG_PROC_FS
+	proc = proc_net_fops_create("ip_conntrack", 0440, &ct_file_ops);
 	if (!proc) goto cleanup_init;
-	proc->proc_fops = &ct_file_ops;
 
-	proc_exp = proc_net_create("ip_conntrack_expect", 0440, NULL);
+	proc_exp = proc_net_fops_create("ip_conntrack_expect", 0440,
+					&exp_file_ops);
 	if (!proc_exp) goto cleanup_proc;
-	proc_exp->proc_fops = &exp_file_ops;
 
 	proc_stat = proc_net_fops_create("ip_conntrack_stat", S_IRUGO,
 					 &ct_cpu_seq_fops);
 	if (!proc_stat)
 		goto cleanup_proc_exp;
 	proc_stat->owner = THIS_MODULE;
+#endif
 
 	ret = nf_register_hook(&ip_conntrack_defrag_ops);
 	if (ret < 0) {
@@ -814,12 +822,14 @@ static int init_or_cleanup(int init)
 	local_bh_enable();
 	nf_unregister_hook(&ip_conntrack_defrag_ops);
  cleanup_proc_stat:
+#ifdef CONFIG_PROC_FS
 	proc_net_remove("ip_conntrack_stat");
 cleanup_proc_exp:
 	proc_net_remove("ip_conntrack_exp");
  cleanup_proc:
 	proc_net_remove("ip_conntrack");
  cleanup_init:
+#endif /* CONFIG_PROC_FS */
 	ip_conntrack_cleanup();
  cleanup_nothing:
 	return ret;
@@ -912,4 +922,3 @@ EXPORT_SYMBOL(ip_conntrack_hash);
 EXPORT_SYMBOL(ip_conntrack_untracked);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_put);
-EXPORT_SYMBOL(ip_ct_log_invalid);
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .21815-linux-2.6.9-rc1-bk9/net/ipv4/netfilter/ip_queue.c .21815-linux-2.6.9-rc1-bk9.updated/net/ipv4/netfilter/ip_queue.c
--- .21815-linux-2.6.9-rc1-bk9/net/ipv4/netfilter/ip_queue.c	2004-02-18 23:54:37.000000000 +1100
+++ .21815-linux-2.6.9-rc1-bk9.updated/net/ipv4/netfilter/ip_queue.c	2004-09-04 19:54:04.000000000 +1000
@@ -619,6 +619,7 @@ static ctl_table ipq_root_table[] = {
 	{ .ctl_name = 0 }
 };
 
+#ifdef CONFIG_PROC_FS
 static int
 ipq_get_info(char *buffer, char **start, off_t offset, int length)
 {
@@ -648,6 +649,7 @@ ipq_get_info(char *buffer, char **start,
 		len = 0;
 	return len;
 }
+#endif /* CONFIG_PROC_FS */
 
 static int
 init_or_cleanup(int init)

-- 
Anyone who quotes me in their signature is an idiot -- Rusty Russell
