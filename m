From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 05/15] netfilter: ipt_CLUSTERIP: adapt it to support pernet hooks
Date: Mon, 15 Jun 2015 17:46:47 +0200
Message-ID: <1434383217-13732-6-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36841 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbbFOPls (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:48 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This target is deprecated, but let's adapt this so it doesn't break existing
users.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index cf23858..0baa7f9 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -69,6 +69,8 @@ struct clusterip_net {
 	/* lock protects the configs list */
 	spinlock_t lock;
 
+	struct nf_hook_ops *ops;
+
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *procdir;
 #endif
@@ -724,6 +726,7 @@ static const struct file_operations clusterip_proc_fops = {
 static int clusterip_net_init(struct net *net)
 {
 	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
+	int err;
 
 	INIT_LIST_HEAD(&cn->configs);
 
@@ -737,13 +740,32 @@ static int clusterip_net_init(struct net *net)
 	}
 #endif /* CONFIG_PROC_FS */
 
+	err = -ENOMEM;
+	cn->ops = kmemdup(&cip_arp_ops, sizeof(cip_arp_ops), GFP_KERNEL);
+	if (cn->ops == NULL)
+		goto err1;
+
+	err = nf_register_hook(net, cn->ops);
+	if (err < 0)
+		goto err2;
+
 	return 0;
+err2:
+	kfree(cn->ops);
+err1:
+	proc_remove(cn->procdir);
+
+	return err;
 }
 
 static void clusterip_net_exit(struct net *net)
 {
-#ifdef CONFIG_PROC_FS
 	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
+
+	nf_unregister_hook(cn->ops);
+	kfree(cn->ops);
+
+#ifdef CONFIG_PROC_FS
 	proc_remove(cn->procdir);
 #endif
 }
@@ -767,17 +789,11 @@ static int __init clusterip_tg_init(void)
 	if (ret < 0)
 		goto cleanup_subsys;
 
-	ret = nf_register_hook(&init_net, &cip_arp_ops);
-	if (ret < 0)
-		goto cleanup_target;
-
 	pr_info("ClusterIP Version %s loaded successfully\n",
 		CLUSTERIP_VERSION);
 
 	return 0;
 
-cleanup_target:
-	xt_unregister_target(&clusterip_tg_reg);
 cleanup_subsys:
 	unregister_pernet_subsys(&clusterip_net_ops);
 	return ret;
@@ -787,7 +803,6 @@ static void __exit clusterip_tg_exit(void)
 {
 	pr_info("ClusterIP Version %s unloading\n", CLUSTERIP_VERSION);
 
-	nf_unregister_hook(&cip_arp_ops);
 	xt_unregister_target(&clusterip_tg_reg);
 	unregister_pernet_subsys(&clusterip_net_ops);
 
-- 
1.7.10.4

