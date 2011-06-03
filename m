From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter patches for 3.0.0-rc1
Date: Fri, 3 Jun 2011 10:53:12 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106031052210.32042@frira.zrqbmnf.qr>
References: <4DE79466.6080400@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:37031 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab1FCIxN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jun 2011 04:53:13 -0400
In-Reply-To: <4DE79466.6080400@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-06-02 15:47, Pablo Neira Ayuso wrote:

>Hi!
>
>If you have some netfilter patch for 3.0.0-rc1 which is not here:
>
>http://1984.lsi.us.es/git/?p=net-next-2.6/.git;a=shortlog;h=refs/heads/pablo/nf-next-2.6-updates
>
>Please, resend it asap.
>Thank you.


parent 6b914d11bc76286fd6d39833d046a3ce32a9b3cb (v3.0-rc1-100-g6b914d1)
commit 0dacfcea39b2a655310257f13cc2cd42d53f47f4
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
# Created with git-export-patch
