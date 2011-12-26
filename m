From: Jan Engelhardt <jengelh@medozas.de>
Subject: [patch] netfilter: provide config option to disable ancient procfs
 parts
Date: Mon, 26 Dec 2011 19:10:24 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112261910070.4284@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48610 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab1LZSK1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Dec 2011 13:10:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent c5e1fd8ccae09f574d6f978c90c2b968ee29030c (v3.2-rc6-1783-gc5e1fd8)
commit 5c90b715139cc87ecd6f64a77118807776350144
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Apr 21 09:32:45 2011 +0200

netfilter: provide config option to disable ancient procfs parts

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/Kconfig              |    2 +-
 net/netfilter/Kconfig                   |   10 ++++++++++
 net/netfilter/nf_conntrack_expect.c     |   12 ++++++------
 net/netfilter/nf_conntrack_standalone.c |    4 ++--
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 7e1f5cd..033b1e8 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -27,7 +27,7 @@ config NF_CONNTRACK_IPV4
 
 config NF_CONNTRACK_PROC_COMPAT
 	bool "proc/sysctl compatibility with old connection tracking"
-	depends on NF_CONNTRACK_IPV4
+	depends on NF_CONNTRACK_PROCFS && NF_CONNTRACK_IPV4
 	default y
 	help
 	  This option enables /proc and sysctl compatibility with the old
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index bac93ba..0dfd5a8 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -83,6 +83,16 @@ config NF_CONNTRACK_ZONES
 
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
index bebb167..4147ba3 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -455,7 +455,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_related_report);
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_NF_CONNTRACK_PROCFS
 struct ct_expect_iter_state {
 	struct seq_net_private p;
 	unsigned int bucket;
@@ -583,25 +583,25 @@ static const struct file_operations exp_file_ops = {
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
index 05e9feb..885f5ab 100644
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

