From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: provide config option to disable ancient procfs parts
Date: Thu, 21 Apr 2011 18:52:42 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104211852180.24347@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50525 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab1DUQwo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:52:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 91eb7c08c6cb3b8eeba1c61f5753c56dcb77f018 (v2.6.39-rc1-161-g91eb7c0)
commit 9de3fa3a3ca6a3e56e478d3c3cef48e427d1a298
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Apr 21 09:32:45 2011 +0200

netfilter: provide config option to disable ancient procfs parts

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/Kconfig                   |   10 ++++++++++
 net/netfilter/nf_conntrack_expect.c     |   12 ++++++------
 net/netfilter/nf_conntrack_standalone.c |    4 ++--
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c3f988a..e96a969 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -75,6 +75,16 @@ config NF_CONNTRACK_ZONES
 
 	  If unsure, say `N'.
 
+config NF_CONNTRACK_PROCFS
+	bool "Supply CT list in procfs (OBSOLETE)"
+	default y
+	depends on PROC_FS
+	---help---
+	This option enables for the list of known conntrack entries
+	to be shown in procfs under net/netfilter/nf_conntrack. This
+	is considered obsolete in favor of using the conntrack(8)
+	tool which uses Netlink.
+
 config NF_CONNTRACK_EVENTS
 	bool "Connection tracking events"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index cd1e8e0..b76787e 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -474,7 +474,7 @@ void nf_ct_remove_userspace_expectations(void)
 }
 EXPORT_SYMBOL_GPL(nf_ct_remove_userspace_expectations);
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_NF_CONNTRACK_PROCFS
 struct ct_expect_iter_state {
 	struct seq_net_private p;
 	unsigned int bucket;
@@ -602,25 +602,25 @@ static const struct file_operations exp_file_ops = {
 	.llseek  = seq_lseek,
 	.release = seq_release_net,
 };
-#endif /* CONFIG_PROC_FS */
+#endif /* CONFIG_NF_CONNTRACK_PROCFS */
 
 static int exp_proc_init(struct net *net)
 {
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_NF_CONNTRACK_PROCFS
 	struct proc_dir_entry *proc;
 
 	proc = proc_net_fops_create(net, "nf_conntrack_expect", 0440, &exp_file_ops);
 	if (!proc)
 		return -ENOMEM;
-#endif /* CONFIG_PROC_FS */
+#endif /* CONFIG_NF_CONNTRACK_PROCFS */
 	return 0;
 }
 
 static void exp_proc_remove(struct net *net)
 {
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_NF_CONNTRACK_PROCFS
 	proc_net_remove(net, "nf_conntrack_expect");
-#endif /* CONFIG_PROC_FS */
+#endif /* CONFIG_NF_CONNTRACK_PROCFS */
 }
 
 module_param_named(expect_hashsize, nf_ct_expect_hsize, uint, 0400);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0ae1428..9a65197 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -34,7 +34,7 @@
 
 MODULE_LICENSE("GPL");
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_NF_CONNTRACK_PROCFS
 int
 print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
             const struct nf_conntrack_l3proto *l3proto,
@@ -396,7 +396,7 @@ static int nf_conntrack_standalone_init_proc(struct net *net)
 static void nf_conntrack_standalone_fini_proc(struct net *net)
 {
 }
-#endif /* CONFIG_PROC_FS */
+#endif /* CONFIG_NF_CONNTRACK_PROCFS */
 
 /* Sysctl support */
 
-- 
# Created with git-export-patch
