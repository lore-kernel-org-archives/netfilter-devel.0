From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: option to disable /proc/net/nf_conntrack procfs [was Re: netfilter
 patches for 3.0.0-rc1]
Date: Fri, 3 Jun 2011 16:06:12 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106031605160.15918@frira.zrqbmnf.qr>
References: <4DE79466.6080400@netfilter.org> <alpine.LNX.2.01.1106031052210.32042@frira.zrqbmnf.qr> <4DE8AE7D.8060609@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:45526 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab1FCOGO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:06:14 -0400
In-Reply-To: <4DE8AE7D.8060609@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-06-03 11:50, Pablo Neira Ayuso wrote:

>On 03/06/11 10:53, Jan Engelhardt wrote:
>> netfilter: provide config option to disable ancient procfs parts
>> 
>> +config NF_CONNTRACK_PROCFS
>> +	bool "Supply CT list in procfs (OBSOLETE)"
>> +	default y
>> +	depends on PROC_FS
>> +	---help---
>> +	This option enables for the list of known conntrack entries
>> +	to be shown in procfs under net/netfilter/nf_conntrack. This
>> +	is considered obsolete in favor of using the conntrack(8)
>> +	tool which uses Netlink.
>> +
>
>This still misses /proc/net/ip_conntrack which would be available. See
>nf_conntrack_l3proto_ipv4_compat.c

Hm indeed. New try:

parent 6b914d11bc76286fd6d39833d046a3ce32a9b3cb (v3.0-rc1-100-g6b914d1)
commit 80a72a00f509c26f9fa50434e0a3df6274f01484
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
# Created with git-export-patch
