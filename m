From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 11/79: netns nf_conntrack: add netns boilerplate
Date: Wed,  8 Oct 2008 12:46:36 +0200 (MEST)
Message-ID: <20081008104636.10423.27137.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45882 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYJHKqh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:46:37 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit dfdb8d791877052bbb527d9688d94a064721d8f7
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:02 2008 +0200

    netfilter: netns nf_conntrack: add netns boilerplate
    
    One comment: #ifdefs around #include is necessary to overcome amazing compile
    breakages in NOTRACK-in-netns patch (see below).
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index a8eb43c..708009b 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -16,6 +16,9 @@
 #include <net/netns/ipv6.h>
 #include <net/netns/dccp.h>
 #include <net/netns/x_tables.h>
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+#include <net/netns/conntrack.h>
+#endif
 
 struct proc_dir_entry;
 struct net_device;
@@ -67,6 +70,9 @@ struct net {
 #endif
 #ifdef CONFIG_NETFILTER
 	struct netns_xt		xt;
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	struct netns_ct		ct;
+#endif
 #endif
 	struct net_generic	*gen;
 };
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 05760d6..532aa20 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -24,8 +24,8 @@ extern unsigned int nf_conntrack_in(u_int8_t pf,
 				    unsigned int hooknum,
 				    struct sk_buff *skb);
 
-extern int nf_conntrack_init(void);
-extern void nf_conntrack_cleanup(void);
+extern int nf_conntrack_init(struct net *net);
+extern void nf_conntrack_cleanup(struct net *net);
 
 extern int nf_conntrack_proto_init(void);
 extern void nf_conntrack_proto_fini(void);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
new file mode 100644
index 0000000..82d80b8
--- /dev/null
+++ b/include/net/netns/conntrack.h
@@ -0,0 +1,6 @@
+#ifndef __NETNS_CONNTRACK_H
+#define __NETNS_CONNTRACK_H
+
+struct netns_ct {
+};
+#endif
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 6aaf64b..ee79e93 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1006,7 +1006,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_flush);
 
 /* Mishearing the voices in his head, our hero wonders how he's
    supposed to kill the mall. */
-void nf_conntrack_cleanup(void)
+void nf_conntrack_cleanup(struct net *net)
 {
 	rcu_assign_pointer(ip_ct_attach, NULL);
 
@@ -1120,7 +1120,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_set_hashsize);
 module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
 		  &nf_conntrack_htable_size, 0600);
 
-int __init nf_conntrack_init(void)
+int nf_conntrack_init(struct net *net)
 {
 	int max_factor = 8;
 	int ret;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 990fa12..e6a79f2 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -537,7 +537,7 @@ static const struct file_operations exp_file_ops = {
 };
 #endif /* CONFIG_PROC_FS */
 
-static int __init exp_proc_init(void)
+static int exp_proc_init(void)
 {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *proc;
@@ -558,7 +558,7 @@ static void exp_proc_remove(void)
 
 module_param_named(expect_hashsize, nf_ct_expect_hsize, uint, 0600);
 
-int __init nf_conntrack_expect_init(void)
+int nf_conntrack_expect_init(void)
 {
 	int err = -ENOMEM;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 8509db1..81dec17 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -440,11 +440,26 @@ static void nf_conntrack_standalone_fini_sysctl(void)
 }
 #endif /* CONFIG_SYSCTL */
 
+static int nf_conntrack_net_init(struct net *net)
+{
+	return nf_conntrack_init(net);
+}
+
+static void nf_conntrack_net_exit(struct net *net)
+{
+	nf_conntrack_cleanup(net);
+}
+
+static struct pernet_operations nf_conntrack_net_ops = {
+	.init = nf_conntrack_net_init,
+	.exit = nf_conntrack_net_exit,
+};
+
 static int __init nf_conntrack_standalone_init(void)
 {
 	int ret;
 
-	ret = nf_conntrack_init();
+	ret = register_pernet_subsys(&nf_conntrack_net_ops);
 	if (ret < 0)
 		goto out;
 	ret = nf_conntrack_standalone_init_proc();
@@ -458,7 +473,7 @@ static int __init nf_conntrack_standalone_init(void)
 out_sysctl:
 	nf_conntrack_standalone_fini_proc();
 out_proc:
-	nf_conntrack_cleanup();
+	unregister_pernet_subsys(&nf_conntrack_net_ops);
 out:
 	return ret;
 }
@@ -467,7 +482,7 @@ static void __exit nf_conntrack_standalone_fini(void)
 {
 	nf_conntrack_standalone_fini_sysctl();
 	nf_conntrack_standalone_fini_proc();
-	nf_conntrack_cleanup();
+	unregister_pernet_subsys(&nf_conntrack_net_ops);
 }
 
 module_init(nf_conntrack_standalone_init);
