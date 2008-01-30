From: Patrick McHardy <kaber@trash.net>
Subject: Re: [build bug] ip_queue.c:(.init.text+0x322c): undefined reference
 to	`net_ipv4_ctl_path'
Date: Wed, 30 Jan 2008 18:58:13 +0100
Message-ID: <47A0BAB5.3080207@trash.net>
References: <20080130164554.GA2800@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040704010203000406050702"
Cc: linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57306 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbYA3R6s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:58:48 -0500
In-Reply-To: <20080130164554.GA2800@elte.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040704010203000406050702
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> randconfig testing found the following build failure on latest -git:
>
>  net/built-in.o: In function `ip_queue_init':
>  ip_queue.c:(.init.text+0x322c): undefined reference to `net_ipv4_ctl_path'
>
> config attached.

Thanks, the reason is CONFIG_SYSCTL=n. I've queued this patch
(might not apply to Linus' tree due to local changes) to fix
the build error and a runtime error with CONFIG_PROC_FS=n.





--------------040704010203000406050702
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 5109839..6bda110 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -512,6 +512,7 @@ static struct notifier_block ipq_nl_notifier = {
 	.notifier_call	= ipq_rcv_nl_event,
 };
 
+#ifdef CONFIG_SYSCTL
 static struct ctl_table_header *ipq_sysctl_header;
 
 static ctl_table ipq_table[] = {
@@ -525,7 +526,9 @@ static ctl_table ipq_table[] = {
 	},
 	{ .ctl_name = 0 }
 };
+#endif
 
+#ifdef CONFIG_PROC_FS
 static int ip_queue_show(struct seq_file *m, void *v)
 {
 	read_lock_bh(&queue_lock);
@@ -562,6 +565,7 @@ static const struct file_operations ip_queue_proc_fops = {
 	.release	= single_release,
 	.owner		= THIS_MODULE,
 };
+#endif
 
 static const struct nf_queue_handler nfqh = {
 	.name	= "ip_queue",
@@ -571,7 +575,7 @@ static const struct nf_queue_handler nfqh = {
 static int __init ip_queue_init(void)
 {
 	int status = -ENOMEM;
-	struct proc_dir_entry *proc;
+	struct proc_dir_entry *proc __maybe_unused;
 
 	netlink_register_notifier(&ipq_nl_notifier);
 	ipqnl = netlink_kernel_create(&init_net, NETLINK_FIREWALL, 0,
@@ -581,6 +585,7 @@ static int __init ip_queue_init(void)
 		goto cleanup_netlink_notifier;
 	}
 
+#ifdef CONFIG_PROC_FS
 	proc = create_proc_entry(IPQ_PROC_FS_NAME, 0, init_net.proc_net);
 	if (proc) {
 		proc->owner = THIS_MODULE;
@@ -589,10 +594,11 @@ static int __init ip_queue_init(void)
 		printk(KERN_ERR "ip_queue: failed to create proc entry\n");
 		goto cleanup_ipqnl;
 	}
-
+#endif
 	register_netdevice_notifier(&ipq_dev_notifier);
+#ifdef CONFIG_SYSCTL
 	ipq_sysctl_header = register_sysctl_paths(net_ipv4_ctl_path, ipq_table);
-
+#endif
 	status = nf_register_queue_handler(PF_INET, &nfqh);
 	if (status < 0) {
 		printk(KERN_ERR "ip_queue: failed to register queue handler\n");
@@ -601,10 +607,12 @@ static int __init ip_queue_init(void)
 	return status;
 
 cleanup_sysctl:
+#ifdef CONFIG_SYSCTL
 	unregister_sysctl_table(ipq_sysctl_header);
+#endif
 	unregister_netdevice_notifier(&ipq_dev_notifier);
 	proc_net_remove(&init_net, IPQ_PROC_FS_NAME);
-cleanup_ipqnl:
+cleanup_ipqnl: __maybe_unused
 	netlink_kernel_release(ipqnl);
 	mutex_lock(&ipqnl_mutex);
 	mutex_unlock(&ipqnl_mutex);
@@ -620,7 +628,9 @@ static void __exit ip_queue_fini(void)
 	synchronize_net();
 	ipq_flush(NULL, 0);
 
+#ifdef CONFIG_SYSCTL
 	unregister_sysctl_table(ipq_sysctl_header);
+#endif
 	unregister_netdevice_notifier(&ipq_dev_notifier);
 	proc_net_remove(&init_net, IPQ_PROC_FS_NAME);
 
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 56b4ea6..e869916 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -515,6 +515,7 @@ static struct notifier_block ipq_nl_notifier = {
 	.notifier_call	= ipq_rcv_nl_event,
 };
 
+#ifdef CONFIG_SYSCTL
 static struct ctl_table_header *ipq_sysctl_header;
 
 static ctl_table ipq_table[] = {
@@ -528,7 +529,9 @@ static ctl_table ipq_table[] = {
 	},
 	{ .ctl_name = 0 }
 };
+#endif
 
+#ifdef CONFIG_PROC_FS
 static int ip6_queue_show(struct seq_file *m, void *v)
 {
 	read_lock_bh(&queue_lock);
@@ -565,6 +568,7 @@ static const struct file_operations ip6_queue_proc_fops = {
 	.release	= single_release,
 	.owner		= THIS_MODULE,
 };
+#endif
 
 static const struct nf_queue_handler nfqh = {
 	.name	= "ip6_queue",
@@ -574,7 +578,7 @@ static const struct nf_queue_handler nfqh = {
 static int __init ip6_queue_init(void)
 {
 	int status = -ENOMEM;
-	struct proc_dir_entry *proc;
+	struct proc_dir_entry *proc __maybe_unused;
 
 	netlink_register_notifier(&ipq_nl_notifier);
 	ipqnl = netlink_kernel_create(&init_net, NETLINK_IP6_FW, 0,
@@ -584,6 +588,7 @@ static int __init ip6_queue_init(void)
 		goto cleanup_netlink_notifier;
 	}
 
+#ifdef CONFIG_PROC_FS
 	proc = create_proc_entry(IPQ_PROC_FS_NAME, 0, init_net.proc_net);
 	if (proc) {
 		proc->owner = THIS_MODULE;
@@ -592,10 +597,11 @@ static int __init ip6_queue_init(void)
 		printk(KERN_ERR "ip6_queue: failed to create proc entry\n");
 		goto cleanup_ipqnl;
 	}
-
+#endif
 	register_netdevice_notifier(&ipq_dev_notifier);
+#ifdef CONFIG_SYSCTL
 	ipq_sysctl_header = register_sysctl_paths(net_ipv6_ctl_path, ipq_table);
-
+#endif
 	status = nf_register_queue_handler(PF_INET6, &nfqh);
 	if (status < 0) {
 		printk(KERN_ERR "ip6_queue: failed to register queue handler\n");
@@ -604,11 +610,13 @@ static int __init ip6_queue_init(void)
 	return status;
 
 cleanup_sysctl:
+#ifdef CONFIG_SYSCTL
 	unregister_sysctl_table(ipq_sysctl_header);
+#endif
 	unregister_netdevice_notifier(&ipq_dev_notifier);
 	proc_net_remove(&init_net, IPQ_PROC_FS_NAME);
 
-cleanup_ipqnl:
+cleanup_ipqnl: __maybe_unused
 	netlink_kernel_release(ipqnl);
 	mutex_lock(&ipqnl_mutex);
 	mutex_unlock(&ipqnl_mutex);
@@ -624,7 +632,9 @@ static void __exit ip6_queue_fini(void)
 	synchronize_net();
 	ipq_flush(NULL, 0);
 
+#ifdef CONFIG_SYSCTL
 	unregister_sysctl_table(ipq_sysctl_header);
+#endif
 	unregister_netdevice_notifier(&ipq_dev_notifier);
 	proc_net_remove(&init_net, IPQ_PROC_FS_NAME);
 

--------------040704010203000406050702--
