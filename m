From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 10/15] netfilter: defrag: add pernet hook support
Date: Mon, 15 Jun 2015 17:46:52 +0200
Message-ID: <1434383217-13732-11-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36877 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbbFOPlw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:52 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since pernet hooks, we need to register the hook for each netnamespace space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/netfilter.h             |    6 +++++
 net/ipv4/netfilter/nf_defrag_ipv4.c       |   38 +++++++++++++++++++++++---
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |   41 ++++++++++++++++++++++++++---
 3 files changed, 78 insertions(+), 7 deletions(-)

diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index 38aa498..f2b513d 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -15,5 +15,11 @@ struct netns_nf {
 	struct ctl_table_header *nf_log_dir_header;
 #endif
 	struct list_head hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
+	struct nf_hook_ops *ipv4_defrag_ops;
+#endif
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
+	struct nf_hook_ops *ipv6_defrag_ops;
+#endif
 };
 #endif
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index ad74929..084a995 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -108,15 +108,47 @@ static struct nf_hook_ops ipv4_defrag_ops[] = {
 	},
 };
 
+static int ipv4_defrag_net_init(struct net *net)
+{
+	int err;
+
+	net->nf.ipv4_defrag_ops =
+		kmemdup(ipv4_defrag_ops, sizeof(ipv4_defrag_ops), GFP_KERNEL);
+	if (net->nf.ipv4_defrag_ops == NULL)
+		return -ENOMEM;
+
+	err = nf_register_hooks(net, net->nf.ipv4_defrag_ops,
+				ARRAY_SIZE(ipv4_defrag_ops));
+	if (err < 0)
+		goto err1;
+
+	return 0;
+err1:
+	kfree(net->nf.ipv4_defrag_ops);
+
+	return err;
+}
+
+static void ipv4_defrag_net_exit(struct net *net)
+{
+	nf_unregister_hooks(net->nf.ipv4_defrag_ops,
+			    ARRAY_SIZE(ipv4_defrag_ops));
+	kfree(net->nf.ipv4_defrag_ops);
+}
+
+static struct pernet_operations ipv4_defrag_net_ops = {
+	.init = ipv4_defrag_net_init,
+	.exit = ipv4_defrag_net_exit,
+};
+
 static int __init nf_defrag_init(void)
 {
-	return nf_register_hooks(&init_net, ipv4_defrag_ops,
-				 ARRAY_SIZE(ipv4_defrag_ops));
+	return register_pernet_subsys(&ipv4_defrag_net_ops);
 }
 
 static void __exit nf_defrag_fini(void)
 {
-	nf_unregister_hooks(ipv4_defrag_ops, ARRAY_SIZE(ipv4_defrag_ops));
+	unregister_pernet_subsys(&ipv4_defrag_net_ops);
 }
 
 void nf_defrag_ipv4_enable(void)
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index 7bc330f..2745f9c 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -99,6 +99,39 @@ static struct nf_hook_ops ipv6_defrag_ops[] = {
 	},
 };
 
+static int ipv6_defrag_net_init(struct net *net)
+{
+	int err;
+
+	net->nf.ipv6_defrag_ops =
+		kmemdup(ipv6_defrag_ops, sizeof(ipv6_defrag_ops), GFP_KERNEL);
+	if (net->nf.ipv6_defrag_ops == NULL)
+		return -ENOMEM;
+
+	err = nf_register_hooks(net, net->nf.ipv6_defrag_ops,
+				ARRAY_SIZE(ipv6_defrag_ops));
+	if (err < 0)
+		goto err1;
+
+	return 0;
+err1:
+	kfree(net->nf.ipv6_defrag_ops);
+
+	return err;
+}
+
+static void ipv6_defrag_net_exit(struct net *net)
+{
+	nf_unregister_hooks(net->nf.ipv6_defrag_ops,
+			    ARRAY_SIZE(ipv6_defrag_ops));
+	kfree(net->nf.ipv6_defrag_ops);
+}
+
+static struct pernet_operations ipv6_defrag_net_ops = {
+	.init = ipv6_defrag_net_init,
+	.exit = ipv6_defrag_net_exit,
+};
+
 static int __init nf_defrag_init(void)
 {
 	int ret = 0;
@@ -108,10 +141,10 @@ static int __init nf_defrag_init(void)
 		pr_err("nf_defrag_ipv6: can't initialize frag6.\n");
 		return ret;
 	}
-	ret = nf_register_hooks(&init_net, ipv6_defrag_ops,
-				ARRAY_SIZE(ipv6_defrag_ops));
+
+	ret = register_pernet_subsys(&ipv6_defrag_net_ops);
 	if (ret < 0) {
-		pr_err("nf_defrag_ipv6: can't register hooks\n");
+		pr_err("nf_defrag_ipv6: can't register pernet\n");
 		goto cleanup_frag6;
 	}
 	return ret;
@@ -124,7 +157,7 @@ cleanup_frag6:
 
 static void __exit nf_defrag_fini(void)
 {
-	nf_unregister_hooks(ipv6_defrag_ops, ARRAY_SIZE(ipv6_defrag_ops));
+	unregister_pernet_subsys(&ipv6_defrag_net_ops);
 	nf_ct_frag6_cleanup();
 }
 
-- 
1.7.10.4

