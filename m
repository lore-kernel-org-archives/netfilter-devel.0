From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: clusterip: switch to nf_register_net_hook
Date: Wed, 17 May 2017 11:25:31 +0200
Message-ID: <20170517092531.3219-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46750 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753373AbdEQJZM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 May 2017 05:25:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

one of the last remaining users of the old api, hopefully followup commit
can remove it soon.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 All users are gone except selinux and SMACK.

 I sent patches for those 2 weeks ago (to linux-security-module list) but
 have no idea what their status is.

 I'll try to find out what happened there so we can get rid of this
 api during this -next cycle.

 net/ipv4/netfilter/ipt_CLUSTERIP.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)


diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 038f293c2376..f30bee8e407b 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -743,14 +743,20 @@ static const struct file_operations clusterip_proc_fops = {
 static int clusterip_net_init(struct net *net)
 {
 	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
+	int ret;
 
 	INIT_LIST_HEAD(&cn->configs);
 
 	spin_lock_init(&cn->lock);
 
+	ret = nf_register_net_hook(net, &cip_arp_ops);
+	if (ret < 0)
+		return ret;
+
 #ifdef CONFIG_PROC_FS
 	cn->procdir = proc_mkdir("ipt_CLUSTERIP", net->proc_net);
 	if (!cn->procdir) {
+		nf_unregister_net_hook(net, &cip_arp_ops);
 		pr_err("Unable to proc dir entry\n");
 		return -ENOMEM;
 	}
@@ -765,6 +771,7 @@ static void clusterip_net_exit(struct net *net)
 	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
 	proc_remove(cn->procdir);
 #endif
+	nf_unregister_net_hook(net, &cip_arp_ops);
 }
 
 static struct pernet_operations clusterip_net_ops = {
@@ -786,17 +793,11 @@ static int __init clusterip_tg_init(void)
 	if (ret < 0)
 		goto cleanup_subsys;
 
-	ret = nf_register_hook(&cip_arp_ops);
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
@@ -806,7 +807,6 @@ static void __exit clusterip_tg_exit(void)
 {
 	pr_info("ClusterIP Version %s unloading\n", CLUSTERIP_VERSION);
 
-	nf_unregister_hook(&cip_arp_ops);
 	xt_unregister_target(&clusterip_tg_reg);
 	unregister_pernet_subsys(&clusterip_net_ops);
 
-- 
2.13.0

