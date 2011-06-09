From: pablo@netfilter.org
Subject: [PATCH 4/4] netfilter: nf_conntrack: provide config option to disable ancient procfs parts
Date: Thu,  9 Jun 2011 20:41:02 +0200
Message-ID: <1307644862-3091-5-git-send-email-pablo@netfilter.org>
References: <1307644862-3091-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60829 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab1FISlT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:41:19 -0400
In-Reply-To: <1307644862-3091-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

This option enables for the list of known conntrack entries
to be shown in procfs under net/netfilter/nf_conntrack. This
is considered obsolete in favor of using the conntrack(8)
tool which uses Netlink.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig              |    2 +-
 net/netfilter/Kconfig                   |   10 ++++++++++
 net/netfilter/nf_conntrack_expect.c     |   12 ++++++------
 net/netfilter/nf_conntrack_standalone.c |    4 ++--
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1dfc18a..bf8ff2b 100644
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
index 32bff6d..e4b1076 100644
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
1.7.2.5

