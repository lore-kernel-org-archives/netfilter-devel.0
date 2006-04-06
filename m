From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/12]: Fix section mismatch warnings
Date: Thu,  6 Apr 2006 12:04:56 +0200 (MEST)
Message-ID: <20060406100456.17409.89515.sendpatchset@localhost.localdomain>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix section mismatch warnings

Fix section mismatch warnings caused by netfilter's init_or_cleanup
functions used in many places by splitting the init from the cleanup
parts.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7e7dcfedeec88f2da01af1261c4ecc5a27a9686f
tree 19c9844dce001903774a04a943c61c967a4a9a5f
parent 2f8e62d3a554aee067771c5146a1e29feecd2758
author Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:35:58 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:35:58 +0200

 net/ipv4/netfilter/ip_conntrack_standalone.c   |   90 +++++++++----------
 net/ipv4/netfilter/ip_nat_standalone.c         |   18 +---
 net/ipv4/netfilter/ip_queue.c                  |   31 +++---
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |   40 +++-----
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   38 ++++----
 net/ipv6/netfilter/ip6_queue.c                 |   31 +++---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   38 ++++----
 net/netfilter/nf_conntrack_standalone.c        |  115 ++++++++++++------------
 net/netfilter/nfnetlink_log.c                  |   25 ++---
 net/netfilter/nfnetlink_queue.c                |   27 ++----
 10 files changed, 204 insertions(+), 249 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index adc1a0f..f785529 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -776,18 +776,46 @@ static ctl_table ip_ct_net_table[] = {
 EXPORT_SYMBOL(ip_ct_log_invalid);
 #endif /* CONFIG_SYSCTL */
 
-static int init_or_cleanup(int init)
+/* FIXME: Allow NULL functions and sub in pointers to generic for
+   them. --RR */
+int ip_conntrack_protocol_register(struct ip_conntrack_protocol *proto)
+{
+	int ret = 0;
+
+	write_lock_bh(&ip_conntrack_lock);
+	if (ip_ct_protos[proto->proto] != &ip_conntrack_generic_protocol) {
+		ret = -EBUSY;
+		goto out;
+	}
+	ip_ct_protos[proto->proto] = proto;
+ out:
+	write_unlock_bh(&ip_conntrack_lock);
+	return ret;
+}
+
+void ip_conntrack_protocol_unregister(struct ip_conntrack_protocol *proto)
+{
+	write_lock_bh(&ip_conntrack_lock);
+	ip_ct_protos[proto->proto] = &ip_conntrack_generic_protocol;
+	write_unlock_bh(&ip_conntrack_lock);
+	
+	/* Somebody could be still looking at the proto in bh. */
+	synchronize_net();
+
+	/* Remove all contrack entries for this protocol */
+	ip_ct_iterate_cleanup(kill_proto, &proto->proto);
+}
+
+static int __init ip_conntrack_standalone_init(void)
 {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
 #endif
 	int ret = 0;
 
-	if (!init) goto cleanup;
-
 	ret = ip_conntrack_init();
 	if (ret < 0)
-		goto cleanup_nothing;
+		return ret;
 
 #ifdef CONFIG_PROC_FS
 	ret = -ENOMEM;
@@ -819,16 +847,12 @@ static int init_or_cleanup(int init)
 		goto cleanup_hooks;
 	}
 #endif
-
 	return ret;
 
- cleanup:
-	synchronize_net();
 #ifdef CONFIG_SYSCTL
- 	unregister_sysctl_table(ip_ct_sysctl_header);
  cleanup_hooks:
-#endif
 	nf_unregister_hooks(ip_conntrack_ops, ARRAY_SIZE(ip_conntrack_ops));
+#endif
  cleanup_proc_stat:
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("ip_conntrack", proc_net_stat);
@@ -839,48 +863,22 @@ static int init_or_cleanup(int init)
  cleanup_init:
 #endif /* CONFIG_PROC_FS */
 	ip_conntrack_cleanup();
- cleanup_nothing:
-	return ret;
-}
-
-/* FIXME: Allow NULL functions and sub in pointers to generic for
-   them. --RR */
-int ip_conntrack_protocol_register(struct ip_conntrack_protocol *proto)
-{
-	int ret = 0;
-
-	write_lock_bh(&ip_conntrack_lock);
-	if (ip_ct_protos[proto->proto] != &ip_conntrack_generic_protocol) {
-		ret = -EBUSY;
-		goto out;
-	}
-	ip_ct_protos[proto->proto] = proto;
- out:
-	write_unlock_bh(&ip_conntrack_lock);
 	return ret;
 }
 
-void ip_conntrack_protocol_unregister(struct ip_conntrack_protocol *proto)
-{
-	write_lock_bh(&ip_conntrack_lock);
-	ip_ct_protos[proto->proto] = &ip_conntrack_generic_protocol;
-	write_unlock_bh(&ip_conntrack_lock);
-	
-	/* Somebody could be still looking at the proto in bh. */
-	synchronize_net();
-
-	/* Remove all contrack entries for this protocol */
-	ip_ct_iterate_cleanup(kill_proto, &proto->proto);
-}
-
-static int __init ip_conntrack_standalone_init(void)
-{
-	return init_or_cleanup(1);
-}
-
 static void __exit ip_conntrack_standalone_fini(void)
 {
-	init_or_cleanup(0);
+	synchronize_net();
+#ifdef CONFIG_SYSCTL
+	unregister_sysctl_table(ip_ct_sysctl_header);
+#endif
+	nf_unregister_hooks(ip_conntrack_ops, ARRAY_SIZE(ip_conntrack_ops));
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("ip_conntrack", proc_net_stat);
+	proc_net_remove("ip_conntrack_expect");
+	proc_net_remove("ip_conntrack");
+#endif /* CONFIG_PROC_FS */
+	ip_conntrack_cleanup();
 }
 
 module_init(ip_conntrack_standalone_init);
diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index 5f02f43..8f760b2 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -350,14 +350,12 @@ static struct nf_hook_ops ip_nat_ops[] =
 	},
 };
 
-static int init_or_cleanup(int init)
+static int __init ip_nat_standalone_init(void)
 {
 	int ret = 0;
 
 	need_conntrack();
 
-	if (!init) goto cleanup;
-
 #ifdef CONFIG_XFRM
 	BUG_ON(ip_nat_decode_session != NULL);
 	ip_nat_decode_session = nat_decode_session;
@@ -374,8 +372,6 @@ static int init_or_cleanup(int init)
 	}
 	return ret;
 
- cleanup:
-	nf_unregister_hooks(ip_nat_ops, ARRAY_SIZE(ip_nat_ops));
  cleanup_rule_init:
 	ip_nat_rule_cleanup();
  cleanup_decode_session:
@@ -386,14 +382,14 @@ static int init_or_cleanup(int init)
 	return ret;
 }
 
-static int __init ip_nat_standalone_init(void)
-{
-	return init_or_cleanup(1);
-}
-
 static void __exit ip_nat_standalone_fini(void)
 {
-	init_or_cleanup(0);
+	nf_unregister_hooks(ip_nat_ops, ARRAY_SIZE(ip_nat_ops));
+	ip_nat_rule_cleanup();
+#ifdef CONFIG_XFRM
+	ip_nat_decode_session = NULL;
+	synchronize_net();
+#endif
 }
 
 module_init(ip_nat_standalone_init);
diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 896a244..4bcc842 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -662,15 +662,11 @@ static struct nf_queue_handler nfqh = {
 	.outfn	= &ipq_enqueue_packet,
 };
 
-static int
-init_or_cleanup(int init)
+static int __init ip_queue_init(void)
 {
 	int status = -ENOMEM;
 	struct proc_dir_entry *proc;
 	
-	if (!init)
-		goto cleanup;
-
 	netlink_register_notifier(&ipq_nl_notifier);
 	ipqnl = netlink_kernel_create(NETLINK_FIREWALL, 0, ipq_rcv_sk,
 				      THIS_MODULE);
@@ -697,11 +693,6 @@ init_or_cleanup(int init)
 	}
 	return status;
 
-cleanup:
-	nf_unregister_queue_handlers(&nfqh);
-	synchronize_net();
-	ipq_flush(NF_DROP);
-	
 cleanup_sysctl:
 	unregister_sysctl_table(ipq_sysctl_header);
 	unregister_netdevice_notifier(&ipq_dev_notifier);
@@ -717,15 +708,21 @@ cleanup_netlink_notifier:
 	return status;
 }
 
-static int __init ip_queue_init(void)
-{
-	
-	return init_or_cleanup(1);
-}
-
 static void __exit ip_queue_fini(void)
 {
-	init_or_cleanup(0);
+	nf_unregister_queue_handlers(&nfqh);
+	synchronize_net();
+	ipq_flush(NF_DROP);
+	
+	unregister_sysctl_table(ipq_sysctl_header);
+	unregister_netdevice_notifier(&ipq_dev_notifier);
+	proc_net_remove(IPQ_PROC_FS_NAME);
+	
+	sock_release(ipqnl->sk_socket);
+	mutex_lock(&ipqnl_mutex);
+	mutex_unlock(&ipqnl_mutex);
+	
+	netlink_unregister_notifier(&ipq_nl_notifier);
 }
 
 MODULE_DESCRIPTION("IPv4 packet queue handler");
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index e4768a3..aad9d28 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -725,22 +725,17 @@ static struct file_operations clusterip_
 
 #endif /* CONFIG_PROC_FS */
 
-static int init_or_cleanup(int fini)
+static int __init ipt_clusterip_init(void)
 {
 	int ret;
 
-	if (fini)
-		goto cleanup;
-
-	if (ipt_register_target(&clusterip_tgt)) {
-		ret = -EINVAL;
-		goto cleanup_none;
-	}
+	ret = ipt_register_target(&clusterip_tgt);
+	if (ret < 0)
+		return ret;
 
-	if (nf_register_hook(&cip_arp_ops) < 0) {
-		ret = -EINVAL;
+	ret = nf_register_hook(&cip_arp_ops);
+	if (ret < 0)
 		goto cleanup_target;
-	}
 
 #ifdef CONFIG_PROC_FS
 	clusterip_procdir = proc_mkdir("ipt_CLUSTERIP", proc_net);
@@ -753,31 +748,24 @@ static int init_or_cleanup(int fini)
 
 	printk(KERN_NOTICE "ClusterIP Version %s loaded successfully\n",
 		CLUSTERIP_VERSION);
-
 	return 0;
 
-cleanup:
-	printk(KERN_NOTICE "ClusterIP Version %s unloading\n",
-		CLUSTERIP_VERSION);
-#ifdef CONFIG_PROC_FS
-	remove_proc_entry(clusterip_procdir->name, clusterip_procdir->parent);
-#endif
 cleanup_hook:
 	nf_unregister_hook(&cip_arp_ops);
 cleanup_target:
 	ipt_unregister_target(&clusterip_tgt);
-cleanup_none:
-	return -EINVAL;
-}
-
-static int __init ipt_clusterip_init(void)
-{
-	return init_or_cleanup(0);
+	return ret;
 }
 
 static void __exit ipt_clusterip_fini(void)
 {
-	init_or_cleanup(1);
+	printk(KERN_NOTICE "ClusterIP Version %s unloading\n",
+		CLUSTERIP_VERSION);
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry(clusterip_procdir->name, clusterip_procdir->parent);
+#endif
+	nf_unregister_hook(&cip_arp_ops);
+	ipt_unregister_target(&clusterip_tgt);
 }
 
 module_init(ipt_clusterip_init);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 3fadacc..15ebdb6 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -432,16 +432,20 @@ struct nf_conntrack_l3proto nf_conntrack
 extern struct nf_conntrack_protocol nf_conntrack_protocol_tcp4;
 extern struct nf_conntrack_protocol nf_conntrack_protocol_udp4;
 extern struct nf_conntrack_protocol nf_conntrack_protocol_icmp;
-static int init_or_cleanup(int init)
+
+MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
+MODULE_LICENSE("GPL");
+
+static int __init nf_conntrack_l3proto_ipv4_init(void)
 {
 	int ret = 0;
-
-	if (!init) goto cleanup;
+	
+	need_conntrack();
 
 	ret = nf_register_sockopt(&so_getorigdst);
 	if (ret < 0) {
 		printk(KERN_ERR "Unable to register netfilter socket option\n");
-		goto cleanup_nothing;
+		return ret;
 	}
 
 	ret = nf_conntrack_protocol_register(&nf_conntrack_protocol_tcp4);
@@ -484,13 +488,10 @@ static int init_or_cleanup(int init)
 #endif
 	return ret;
 
- cleanup:
-	synchronize_net();
 #ifdef CONFIG_SYSCTL
- 	unregister_sysctl_table(nf_ct_ipv4_sysctl_header);
  cleanup_hooks:
-#endif
 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
+#endif
  cleanup_ipv4:
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
  cleanup_icmp:
@@ -501,22 +502,21 @@ static int init_or_cleanup(int init)
 	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_tcp4);
  cleanup_sockopt:
 	nf_unregister_sockopt(&so_getorigdst);
- cleanup_nothing:
 	return ret;
 }
 
-MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
-MODULE_LICENSE("GPL");
-
-static int __init nf_conntrack_l3proto_ipv4_init(void)
-{
-	need_conntrack();
-	return init_or_cleanup(1);
-}
-
 static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 {
-	init_or_cleanup(0);
+	synchronize_net();
+#ifdef CONFIG_SYSCTL
+ 	unregister_sysctl_table(nf_ct_ipv4_sysctl_header);
+#endif
+	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
+	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
+	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_icmp);
+	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_udp4);
+	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_tcp4);
+	nf_unregister_sockopt(&so_getorigdst);
 }
 
 module_init(nf_conntrack_l3proto_ipv4_init);
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index e81c6a9..fa23ffe 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -658,15 +658,11 @@ static struct nf_queue_handler nfqh = {
 	.outfn	= &ipq_enqueue_packet,
 };
 
-static int
-init_or_cleanup(int init)
+static int __init ip6_queue_init(void)
 {
 	int status = -ENOMEM;
 	struct proc_dir_entry *proc;
 	
-	if (!init)
-		goto cleanup;
-
 	netlink_register_notifier(&ipq_nl_notifier);
 	ipqnl = netlink_kernel_create(NETLINK_IP6_FW, 0, ipq_rcv_sk,
 	                              THIS_MODULE);
@@ -693,11 +689,6 @@ init_or_cleanup(int init)
 	}
 	return status;
 
-cleanup:
-	nf_unregister_queue_handlers(&nfqh);
-	synchronize_net();
-	ipq_flush(NF_DROP);
-	
 cleanup_sysctl:
 	unregister_sysctl_table(ipq_sysctl_header);
 	unregister_netdevice_notifier(&ipq_dev_notifier);
@@ -713,15 +704,21 @@ cleanup_netlink_notifier:
 	return status;
 }
 
-static int __init ip6_queue_init(void)
-{
-	
-	return init_or_cleanup(1);
-}
-
 static void __exit ip6_queue_fini(void)
 {
-	init_or_cleanup(0);
+	nf_unregister_queue_handlers(&nfqh);
+	synchronize_net();
+	ipq_flush(NF_DROP);
+	
+	unregister_sysctl_table(ipq_sysctl_header);
+	unregister_netdevice_notifier(&ipq_dev_notifier);
+	proc_net_remove(IPQ_PROC_FS_NAME);
+	
+	sock_release(ipqnl->sk_socket);
+	mutex_lock(&ipqnl_mutex);
+	mutex_unlock(&ipqnl_mutex);
+	
+	netlink_unregister_notifier(&ipq_nl_notifier);
 }
 
 MODULE_DESCRIPTION("IPv6 packet queue handler");
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 0426ed0..93bae36 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -464,16 +464,21 @@ extern struct nf_conntrack_protocol nf_c
 extern struct nf_conntrack_protocol nf_conntrack_protocol_icmpv6;
 extern int nf_ct_frag6_init(void);
 extern void nf_ct_frag6_cleanup(void);
-static int init_or_cleanup(int init)
+
+MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET6));
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Yasuyuki KOZAKAI @USAGI <yasuyuki.kozakai@toshiba.co.jp>");
+
+static int __init nf_conntrack_l3proto_ipv6_init(void)
 {
 	int ret = 0;
 
-	if (!init) goto cleanup;
+	need_conntrack();
 
 	ret = nf_ct_frag6_init();
 	if (ret < 0) {
 		printk("nf_conntrack_ipv6: can't initialize frag6.\n");
-		goto cleanup_nothing;
+		return ret;
 	}
 	ret = nf_conntrack_protocol_register(&nf_conntrack_protocol_tcp6);
 	if (ret < 0) {
@@ -516,13 +521,10 @@ static int init_or_cleanup(int init)
 #endif
 	return ret;
 
- cleanup:
-	synchronize_net();
 #ifdef CONFIG_SYSCTL
- 	unregister_sysctl_table(nf_ct_ipv6_sysctl_header);
  cleanup_hooks:
-#endif
 	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
+#endif
  cleanup_ipv6:
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
  cleanup_icmpv6:
@@ -533,23 +535,21 @@ static int init_or_cleanup(int init)
 	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_tcp6);
  cleanup_frag6:
 	nf_ct_frag6_cleanup();
- cleanup_nothing:
 	return ret;
 }
 
-MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET6));
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Yasuyuki KOZAKAI @USAGI <yasuyuki.kozakai@toshiba.co.jp>");
-
-static int __init nf_conntrack_l3proto_ipv6_init(void)
-{
-	need_conntrack();
-	return init_or_cleanup(1);
-}
-
 static void __exit nf_conntrack_l3proto_ipv6_fini(void)
 {
-	init_or_cleanup(0);
+	synchronize_net();
+#ifdef CONFIG_SYSCTL
+ 	unregister_sysctl_table(nf_ct_ipv6_sysctl_header);
+#endif
+	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
+	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
+	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_icmpv6);
+	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_udp6);
+	nf_conntrack_protocol_unregister(&nf_conntrack_protocol_tcp6);
+	nf_ct_frag6_cleanup();
 }
 
 module_init(nf_conntrack_l3proto_ipv6_init);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index c72aa3c..408960c 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -649,63 +649,6 @@ static ctl_table nf_ct_net_table[] = {
 EXPORT_SYMBOL(nf_ct_log_invalid);
 #endif /* CONFIG_SYSCTL */
 
-static int init_or_cleanup(int init)
-{
-#ifdef CONFIG_PROC_FS
-	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
-#endif
-	int ret = 0;
-
-	if (!init) goto cleanup;
-
-	ret = nf_conntrack_init();
-	if (ret < 0)
-		goto cleanup_nothing;
-
-#ifdef CONFIG_PROC_FS
-	proc = proc_net_fops_create("nf_conntrack", 0440, &ct_file_ops);
-	if (!proc) goto cleanup_init;
-
-	proc_exp = proc_net_fops_create("nf_conntrack_expect", 0440,
-					&exp_file_ops);
-	if (!proc_exp) goto cleanup_proc;
-
-	proc_stat = create_proc_entry("nf_conntrack", S_IRUGO, proc_net_stat);
-	if (!proc_stat)
-		goto cleanup_proc_exp;
-
-	proc_stat->proc_fops = &ct_cpu_seq_fops;
-	proc_stat->owner = THIS_MODULE;
-#endif
-#ifdef CONFIG_SYSCTL
-	nf_ct_sysctl_header = register_sysctl_table(nf_ct_net_table, 0);
-	if (nf_ct_sysctl_header == NULL) {
-		printk("nf_conntrack: can't register to sysctl.\n");
-		ret = -ENOMEM;
-		goto cleanup_proc_stat;
-	}
-#endif
-
-	return ret;
-
- cleanup:
-#ifdef CONFIG_SYSCTL
- 	unregister_sysctl_table(nf_ct_sysctl_header);
- cleanup_proc_stat:
-#endif
-#ifdef CONFIG_PROC_FS
-	remove_proc_entry("nf_conntrack", proc_net_stat);
- cleanup_proc_exp:
-	proc_net_remove("nf_conntrack_expect");
- cleanup_proc:
-	proc_net_remove("nf_conntrack");
- cleanup_init:
-#endif /* CNFIG_PROC_FS */
-	nf_conntrack_cleanup();
- cleanup_nothing:
-	return ret;
-}
-
 int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto)
 {
 	int ret = 0;
@@ -808,12 +751,66 @@ void nf_conntrack_protocol_unregister(st
 
 static int __init nf_conntrack_standalone_init(void)
 {
-	return init_or_cleanup(1);
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
+#endif
+	int ret = 0;
+
+	ret = nf_conntrack_init();
+	if (ret < 0)
+		return ret;
+
+#ifdef CONFIG_PROC_FS
+	proc = proc_net_fops_create("nf_conntrack", 0440, &ct_file_ops);
+	if (!proc) goto cleanup_init;
+
+	proc_exp = proc_net_fops_create("nf_conntrack_expect", 0440,
+					&exp_file_ops);
+	if (!proc_exp) goto cleanup_proc;
+
+	proc_stat = create_proc_entry("nf_conntrack", S_IRUGO, proc_net_stat);
+	if (!proc_stat)
+		goto cleanup_proc_exp;
+
+	proc_stat->proc_fops = &ct_cpu_seq_fops;
+	proc_stat->owner = THIS_MODULE;
+#endif
+#ifdef CONFIG_SYSCTL
+	nf_ct_sysctl_header = register_sysctl_table(nf_ct_net_table, 0);
+	if (nf_ct_sysctl_header == NULL) {
+		printk("nf_conntrack: can't register to sysctl.\n");
+		ret = -ENOMEM;
+		goto cleanup_proc_stat;
+	}
+#endif
+	return ret;
+
+#ifdef CONFIG_SYSCTL
+ cleanup_proc_stat:
+#endif
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("nf_conntrack", proc_net_stat);
+ cleanup_proc_exp:
+	proc_net_remove("nf_conntrack_expect");
+ cleanup_proc:
+	proc_net_remove("nf_conntrack");
+ cleanup_init:
+#endif /* CNFIG_PROC_FS */
+	nf_conntrack_cleanup();
+	return ret;
 }
 
 static void __exit nf_conntrack_standalone_fini(void)
 {
-	init_or_cleanup(0);
+#ifdef CONFIG_SYSCTL
+ 	unregister_sysctl_table(nf_ct_sysctl_header);
+#endif
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("nf_conntrack", proc_net_stat);
+	proc_net_remove("nf_conntrack_expect");
+	proc_net_remove("nf_conntrack");
+#endif /* CNFIG_PROC_FS */
+	nf_conntrack_cleanup();
 }
 
 module_init(nf_conntrack_standalone_init);
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 3e3f544..c60273c 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1033,17 +1033,13 @@ static struct file_operations nful_file_
 
 #endif /* PROC_FS */
 
-static int
-init_or_cleanup(int init)
+static int __init nfnetlink_log_init(void)
 {
 	int i, status = -ENOMEM;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *proc_nful;
 #endif
 	
-	if (!init)
-		goto cleanup;
-
 	for (i = 0; i < INSTANCE_BUCKETS; i++)
 		INIT_HLIST_HEAD(&instance_table[i]);
 	
@@ -1066,30 +1062,25 @@ init_or_cleanup(int init)
 		goto cleanup_subsys;
 	proc_nful->proc_fops = &nful_file_ops;
 #endif
-
 	return status;
 
-cleanup:
-	nf_log_unregister_logger(&nfulnl_logger);
 #ifdef CONFIG_PROC_FS
-	remove_proc_entry("nfnetlink_log", proc_net_netfilter);
 cleanup_subsys:
-#endif
 	nfnetlink_subsys_unregister(&nfulnl_subsys);
+#endif
 cleanup_netlink_notifier:
 	netlink_unregister_notifier(&nfulnl_rtnl_notifier);
 	return status;
 }
 
-static int __init nfnetlink_log_init(void)
-{
-	
-	return init_or_cleanup(1);
-}
-
 static void __exit nfnetlink_log_fini(void)
 {
-	init_or_cleanup(0);
+	nf_log_unregister_logger(&nfulnl_logger);
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("nfnetlink_log", proc_net_netfilter);
+#endif
+	nfnetlink_subsys_unregister(&nfulnl_subsys);
+	netlink_unregister_notifier(&nfulnl_rtnl_notifier);
 }
 
 MODULE_DESCRIPTION("netfilter userspace logging");
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index d0e62f6..b93bcd3 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1071,17 +1071,13 @@ static struct file_operations nfqnl_file
 
 #endif /* PROC_FS */
 
-static int
-init_or_cleanup(int init)
+static int __init nfnetlink_queue_init(void)
 {
 	int i, status = -ENOMEM;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *proc_nfqueue;
 #endif
 	
-	if (!init)
-		goto cleanup;
-
 	for (i = 0; i < INSTANCE_BUCKETS; i++)
 		INIT_HLIST_HEAD(&instance_table[i]);
 
@@ -1101,31 +1097,26 @@ init_or_cleanup(int init)
 #endif
 
 	register_netdevice_notifier(&nfqnl_dev_notifier);
-
 	return status;
 
-cleanup:
-	nf_unregister_queue_handlers(&nfqh);
-	unregister_netdevice_notifier(&nfqnl_dev_notifier);
 #ifdef CONFIG_PROC_FS
-	remove_proc_entry("nfnetlink_queue", proc_net_netfilter);
 cleanup_subsys:
-#endif	
 	nfnetlink_subsys_unregister(&nfqnl_subsys);
+#endif	
 cleanup_netlink_notifier:
 	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
 	return status;
 }
 
-static int __init nfnetlink_queue_init(void)
-{
-	
-	return init_or_cleanup(1);
-}
-
 static void __exit nfnetlink_queue_fini(void)
 {
-	init_or_cleanup(0);
+	nf_unregister_queue_handlers(&nfqh);
+	unregister_netdevice_notifier(&nfqnl_dev_notifier);
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("nfnetlink_queue", proc_net_netfilter);
+#endif	
+	nfnetlink_subsys_unregister(&nfqnl_subsys);
+	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
 }
 
 MODULE_DESCRIPTION("netfilter packet queue handler");
