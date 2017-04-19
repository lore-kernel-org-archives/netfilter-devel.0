From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] ipvs: convert to use pernet nf_hook api
Date: Wed, 19 Apr 2017 18:25:22 +0200
Message-ID: <20170419162522.20486-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43230 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966124AbdDSQZE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 12:25:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_(un)register_hooks has to maintain an internal hook list to add/remove
those hooks from net namespaces as they are added/deleted.

ipvs already uses pernet_ops, so we can switch to the (more recent)
pernet hook api instead.

Compile tested only.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 It would be nice to (eventually) remove the old api that still provides
 the illusion of global hooks, this is one of the more low-hanging fruits
 towards making that happen.

 net/netfilter/ipvs/ip_vs_core.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index b4a746d0e39b..d2d7bdf1d510 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2200,6 +2200,7 @@ static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
 static int __net_init __ip_vs_init(struct net *net)
 {
 	struct netns_ipvs *ipvs;
+	int ret;
 
 	ipvs = net_generic(net, ip_vs_net_id);
 	if (ipvs == NULL)
@@ -2231,11 +2232,17 @@ static int __net_init __ip_vs_init(struct net *net)
 	if (ip_vs_sync_net_init(ipvs) < 0)
 		goto sync_fail;
 
+	ret = nf_register_net_hooks(net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
+	if (ret < 0)
+		goto hook_fail;
+
 	return 0;
 /*
  * Error handling
  */
 
+hook_fail:
+	ip_vs_sync_net_cleanup(ipvs);
 sync_fail:
 	ip_vs_conn_net_cleanup(ipvs);
 conn_fail:
@@ -2255,6 +2262,7 @@ static void __net_exit __ip_vs_cleanup(struct net *net)
 {
 	struct netns_ipvs *ipvs = net_ipvs(net);
 
+	nf_unregister_net_hooks(net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
 	ip_vs_service_net_cleanup(ipvs);	/* ip_vs_flush() with locks */
 	ip_vs_conn_net_cleanup(ipvs);
 	ip_vs_app_net_cleanup(ipvs);
@@ -2315,24 +2323,16 @@ static int __init ip_vs_init(void)
 	if (ret < 0)
 		goto cleanup_sub;
 
-	ret = nf_register_hooks(ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
-	if (ret < 0) {
-		pr_err("can't register hooks.\n");
-		goto cleanup_dev;
-	}
-
 	ret = ip_vs_register_nl_ioctl();
 	if (ret < 0) {
 		pr_err("can't register netlink/ioctl.\n");
-		goto cleanup_hooks;
+		goto cleanup_dev;
 	}
 
 	pr_info("ipvs loaded.\n");
 
 	return ret;
 
-cleanup_hooks:
-	nf_unregister_hooks(ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
 cleanup_dev:
 	unregister_pernet_device(&ipvs_core_dev_ops);
 cleanup_sub:
@@ -2349,7 +2349,6 @@ static int __init ip_vs_init(void)
 static void __exit ip_vs_cleanup(void)
 {
 	ip_vs_unregister_nl_ioctl();
-	nf_unregister_hooks(ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
 	unregister_pernet_device(&ipvs_core_dev_ops);
 	unregister_pernet_subsys(&ipvs_core_ops);	/* free ip_vs struct */
 	ip_vs_conn_cleanup();
-- 
2.10.2

