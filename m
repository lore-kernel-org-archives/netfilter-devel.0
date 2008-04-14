From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/41]: nf_conntrack: less hairy ifdefs around proc and sysctl
Date: Mon, 14 Apr 2008 12:16:19 +0200 (MEST)
Message-ID: <20080414101616.32717.38811.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36233 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYDNKQV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:21 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: less hairy ifdefs around proc and sysctl

Patch splits creation of /proc/net/nf_conntrack, /proc/net/stat/nf_conntrack
and net.netfilter hierarchy into their own functions with dummy ones
if PROC_FS or SYSCTL is not set. Also, remove dead "ret = 0" write
while I'm at it.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8ee4a745f7f5faa662eb8140b60331743b63adf4
tree 2ef2339e4dc1ba03b8119d6bc3b6e70a845e8f63
parent 7477fd2e6b676fcd15861c2a96a7172f71afe0a5
author Alexey Dobriyan <adobriyan@sw.ru> Thu, 20 Mar 2008 15:15:43 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:16 +0200

 net/netfilter/nf_conntrack_standalone.c |  116 ++++++++++++++++++++-----------
 1 files changed, 76 insertions(+), 40 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 9d0b8bb..01d1f7e 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -295,6 +295,41 @@ static const struct file_operations ct_cpu_seq_fops = {
 	.llseek	 = seq_lseek,
 	.release = seq_release,
 };
+
+static int nf_conntrack_standalone_init_proc(void)
+{
+	struct proc_dir_entry *pde;
+
+	pde = proc_net_fops_create(&init_net, "nf_conntrack", 0440, &ct_file_ops);
+	if (!pde)
+		goto out_nf_conntrack;
+	pde = create_proc_entry("nf_conntrack", S_IRUGO, init_net.proc_net_stat);
+	if (!pde)
+		goto out_stat_nf_conntrack;
+	pde->proc_fops = &ct_cpu_seq_fops;
+	pde->owner = THIS_MODULE;
+	return 0;
+
+out_stat_nf_conntrack:
+	proc_net_remove(&init_net, "nf_conntrack");
+out_nf_conntrack:
+	return -ENOMEM;
+}
+
+static void nf_conntrack_standalone_fini_proc(void)
+{
+	remove_proc_entry("nf_conntrack", init_net.proc_net_stat);
+	proc_net_remove(&init_net, "nf_conntrack");
+}
+#else
+static int nf_conntrack_standalone_init_proc(void)
+{
+	return 0;
+}
+
+static void nf_conntrack_standalone_fini_proc(void)
+{
+}
 #endif /* CONFIG_PROC_FS */
 
 /* Sysctl support */
@@ -390,60 +425,61 @@ static struct ctl_path nf_ct_path[] = {
 };
 
 EXPORT_SYMBOL_GPL(nf_ct_log_invalid);
+
+static int nf_conntrack_standalone_init_sysctl(void)
+{
+	nf_ct_sysctl_header =
+		register_sysctl_paths(nf_ct_path, nf_ct_netfilter_table);
+	if (nf_ct_sysctl_header == NULL) {
+		printk("nf_conntrack: can't register to sysctl.\n");
+		return -ENOMEM;
+	}
+	return 0;
+
+}
+
+static void nf_conntrack_standalone_fini_sysctl(void)
+{
+	unregister_sysctl_table(nf_ct_sysctl_header);
+}
+#else
+static int nf_conntrack_standalone_init_sysctl(void)
+{
+	return 0;
+}
+
+static void nf_conntrack_standalone_fini_sysctl(void)
+{
+}
 #endif /* CONFIG_SYSCTL */
 
 static int __init nf_conntrack_standalone_init(void)
 {
-#ifdef CONFIG_PROC_FS
-	struct proc_dir_entry *proc;
-#endif
-	int ret = 0;
+	int ret;
 
 	ret = nf_conntrack_init();
 	if (ret < 0)
-		return ret;
-
-#ifdef CONFIG_PROC_FS
-	proc = proc_net_fops_create(&init_net, "nf_conntrack", 0440, &ct_file_ops);
-	if (!proc) goto cleanup_init;
-
-	if (!proc_create("nf_conntrack", S_IRUGO,
-			 init_net.proc_net_stat, &ct_cpu_seq_fops))
-		goto cleanup_proc;
-#endif
-#ifdef CONFIG_SYSCTL
-	nf_ct_sysctl_header = register_sysctl_paths(nf_ct_path,
-			nf_ct_netfilter_table);
-	if (nf_ct_sysctl_header == NULL) {
-		printk("nf_conntrack: can't register to sysctl.\n");
-		ret = -ENOMEM;
-		goto cleanup_proc_stat;
-	}
-#endif
-	return ret;
+		goto out;
+	ret = nf_conntrack_standalone_init_proc();
+	if (ret < 0)
+		goto out_proc;
+	ret = nf_conntrack_standalone_init_sysctl();
+	if (ret < 0)
+		goto out_sysctl;
+	return 0;
 
-#ifdef CONFIG_SYSCTL
- cleanup_proc_stat:
-#endif
-#ifdef CONFIG_PROC_FS
-	remove_proc_entry("nf_conntrack", init_net. proc_net_stat);
- cleanup_proc:
-	proc_net_remove(&init_net, "nf_conntrack");
- cleanup_init:
-#endif /* CNFIG_PROC_FS */
+out_sysctl:
+	nf_conntrack_standalone_fini_proc();
+out_proc:
 	nf_conntrack_cleanup();
+out:
 	return ret;
 }
 
 static void __exit nf_conntrack_standalone_fini(void)
 {
-#ifdef CONFIG_SYSCTL
-	unregister_sysctl_table(nf_ct_sysctl_header);
-#endif
-#ifdef CONFIG_PROC_FS
-	remove_proc_entry("nf_conntrack", init_net.proc_net_stat);
-	proc_net_remove(&init_net, "nf_conntrack");
-#endif /* CNFIG_PROC_FS */
+	nf_conntrack_standalone_fini_sysctl();
+	nf_conntrack_standalone_fini_proc();
 	nf_conntrack_cleanup();
 }
 
