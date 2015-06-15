From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 11/15] ipvs: adapt it to pernet hooks
Date: Mon, 15 Jun 2015 17:46:53 +0200
Message-ID: <1434383217-13732-12-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36887 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbbFOPlx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:53 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             |    3 +++
 net/netfilter/ipvs/ip_vs_core.c |   42 +++++++++++++++++++++++++++++----------
 2 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 4e3731e..406dbe3 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -850,6 +850,9 @@ struct ipvs_master_sync_state {
 struct netns_ipvs {
 	int			gen;		/* Generation */
 	int			enable;		/* enable like nf_hooks do */
+
+	struct nf_hook_ops	*ip_vs_ops;
+
 	/* Hash table: for real service lookups */
 	#define IP_VS_RTAB_BITS 4
 	#define IP_VS_RTAB_SIZE (1 << IP_VS_RTAB_BITS)
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 2751d5a..65cd930 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2039,9 +2039,39 @@ static void __net_exit __ip_vs_cleanup(struct net *net)
 	net->ipvs = NULL;
 }
 
+static int ip_vs_dev_init(struct net *net)
+{
+	struct netns_ipvs *ipvs_net = net_ipvs(net);
+	int err;
+
+	ipvs_net->ip_vs_ops =
+		kmemdup(ip_vs_ops, sizeof(ip_vs_ops), GFP_KERNEL);
+	if (ipvs_net->ip_vs_ops == NULL) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	err = nf_register_hooks(net, ipvs_net->ip_vs_ops,
+				ARRAY_SIZE(ip_vs_ops));
+	if (err < 0) {
+		pr_err("can't register hooks.\n");
+		goto err2;
+	}
+
+	return 0;
+err2:
+	kfree(ipvs_net->ip_vs_ops);
+err1:
+	return err;
+}
+
 static void __net_exit __ip_vs_dev_cleanup(struct net *net)
 {
+	struct netns_ipvs *ipvs_net = net_ipvs(net);
+
 	EnterFunction(2);
+	nf_unregister_hooks(ipvs_net->ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
+	kfree(ipvs_net->ip_vs_ops);
 	net_ipvs(net)->enable = 0;	/* Disable packet reception */
 	smp_wmb();
 	ip_vs_sync_net_cleanup(net);
@@ -2056,6 +2086,7 @@ static struct pernet_operations ipvs_core_ops = {
 };
 
 static struct pernet_operations ipvs_core_dev_ops = {
+	.init = ip_vs_dev_init,
 	.exit = __ip_vs_dev_cleanup,
 };
 
@@ -2088,24 +2119,16 @@ static int __init ip_vs_init(void)
 	if (ret < 0)
 		goto cleanup_sub;
 
-	ret = nf_register_hooks(&init_net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
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
@@ -2122,7 +2145,6 @@ exit:
 static void __exit ip_vs_cleanup(void)
 {
 	ip_vs_unregister_nl_ioctl();
-	nf_unregister_hooks(ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
 	unregister_pernet_device(&ipvs_core_dev_ops);
 	unregister_pernet_subsys(&ipvs_core_ops);	/* free ip_vs struct */
 	ip_vs_conn_cleanup();
-- 
1.7.10.4

