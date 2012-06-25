From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] netfilter: make net/stat/nf_conntrack procfs available again
Date: Mon, 25 Jun 2012 16:02:05 +0200
Message-ID: <1340632925-4153-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58920 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756873Ab2FYOAM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:00:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

partially reverts commit 54b07dca68557b0952585b5f4834cd0dd86eba35
(netfilter: provide config option to disable ancient procfs parts).

Problem is that this also disabled net/stat/nf_conntrack, which
is useful for diagnosing certain conntrack-related issues; and there
are currently no other means to obtain these statistics from userspace.

(conntrack-tools "conntrack -S" uses the proc interface, too...)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_standalone.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 9b39432..2363cf2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -269,6 +269,27 @@ static const struct file_operations ct_file_ops = {
 	.release = seq_release_net,
 };
 
+static bool nf_conntrack_procfs_create(struct net *net)
+{
+	return !!proc_net_fops_create(net, "nf_conntrack", 0440, &ct_file_ops);
+}
+
+static void nf_conntrack_procfs_remove(struct net *net)
+{
+	proc_net_remove(net, "nf_conntrack");
+}
+#else
+static bool nf_conntrack_procfs_create(struct net *net)
+{
+	return true;
+}
+
+static inline void nf_conntrack_procfs_remove(struct net *net)
+{
+}
+#endif /* CONFIG_NF_CONNTRACK_PROCFS */
+
+#ifdef CONFIG_PROC_FS
 static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct net *net = seq_file_net(seq);
@@ -366,8 +387,7 @@ static int nf_conntrack_standalone_init_proc(struct net *net)
 {
 	struct proc_dir_entry *pde;
 
-	pde = proc_net_fops_create(net, "nf_conntrack", 0440, &ct_file_ops);
-	if (!pde)
+	if (!nf_conntrack_procfs_create(net))
 		goto out_nf_conntrack;
 
 	pde = proc_create("nf_conntrack", S_IRUGO, net->proc_net_stat,
@@ -377,7 +397,7 @@ static int nf_conntrack_standalone_init_proc(struct net *net)
 	return 0;
 
 out_stat_nf_conntrack:
-	proc_net_remove(net, "nf_conntrack");
+	nf_conntrack_procfs_remove(net);
 out_nf_conntrack:
 	return -ENOMEM;
 }
@@ -385,7 +405,7 @@ out_nf_conntrack:
 static void nf_conntrack_standalone_fini_proc(struct net *net)
 {
 	remove_proc_entry("nf_conntrack", net->proc_net_stat);
-	proc_net_remove(net, "nf_conntrack");
+	nf_conntrack_procfs_remove(net);
 }
 #else
 static int nf_conntrack_standalone_init_proc(struct net *net)
@@ -396,7 +416,7 @@ static int nf_conntrack_standalone_init_proc(struct net *net)
 static void nf_conntrack_standalone_fini_proc(struct net *net)
 {
 }
-#endif /* CONFIG_NF_CONNTRACK_PROCFS */
+#endif /* CONFIG_PROC_FS */
 
 /* Sysctl support */
 
-- 
1.7.3.4

