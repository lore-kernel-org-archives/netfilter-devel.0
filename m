From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 14/15] security: adapt it to pernet hooks
Date: Mon, 15 Jun 2015 17:46:56 +0200
Message-ID: <1434383217-13732-15-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36926 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbbFOPl7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:59 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since pernet hooks, we need to register the hook for each netnamespace space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/netfilter.h |    3 +++
 security/selinux/hooks.c      |   43 +++++++++++++++++++++++++++++++++++------
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index f2b513d..89925e3 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -21,5 +21,8 @@ struct netns_nf {
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	struct nf_hook_ops *ipv6_defrag_ops;
 #endif
+#ifdef CONFIG_SECURITY
+	struct nf_hook_ops *selinux_ops;
+#endif
 };
 #endif
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7246654..c10a5b1 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6147,6 +6147,40 @@ static struct nf_hook_ops selinux_nf_ops[] = {
 #endif	/* IPV6 */
 };
 
+static int selinux_net_init(struct net *net)
+{
+	int err;
+
+	net->nf.selinux_ops =
+		kmemdup(selinux_nf_ops, sizeof(selinux_nf_ops), GFP_KERNEL);
+	if (net->nf.selinux_ops == NULL) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	err = nf_register_hooks(net, net->nf.selinux_ops,
+				ARRAY_SIZE(selinux_nf_ops));
+	if (err < 0)
+		goto err2;
+
+	return 0;
+err2:
+	kfree(net->nf.selinux_ops);
+err1:
+	return err;
+}
+
+static void selinux_net_exit(struct net *net)
+{
+	nf_unregister_hooks(net->nf.selinux_ops, ARRAY_SIZE(selinux_nf_ops));
+	kfree(net->nf.selinux_ops);
+}
+
+static struct pernet_operations selinux_net_ops = {
+	.init = selinux_net_init,
+	.exit = selinux_net_exit,
+};
+
 static int __init selinux_nf_ip_init(void)
 {
 	int err;
@@ -6156,9 +6190,8 @@ static int __init selinux_nf_ip_init(void)
 
 	printk(KERN_DEBUG "SELinux:  Registering netfilter hooks\n");
 
-	err = nf_register_hooks(&init_net, selinux_nf_ops,
-				ARRAY_SIZE(selinux_nf_ops));
-	if (err)
+	err = register_pernet_subsys(&selinux_net_ops);
+	if (err < 0)
 		panic("SELinux: nf_register_hooks: error %d\n", err);
 
 	return 0;
@@ -6170,9 +6203,7 @@ __initcall(selinux_nf_ip_init);
 static void selinux_nf_ip_exit(void)
 {
 	printk(KERN_DEBUG "SELinux:  Unregistering netfilter hooks\n");
-
-	nf_unregister_hooks(&init_net, selinux_nf_ops,
-			    ARRAY_SIZE(selinux_nf_ops));
+	unregister_pernet_subsys(&selinux_net_ops);
 }
 #endif
 
-- 
1.7.10.4

