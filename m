From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/49]: Use nf_register_hooks for multiple registrations
Date: Tue,  4 Dec 2007 13:02:26 +0100 (MET)
Message-ID: <20071204120226.2442.93366.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62168 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXLDMC1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:27 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Use nf_register_hooks for multiple registrations

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3d8f7cb0e4708c09a6420a5130dea3852e8617cf
tree e5627c08b5c52d51e1641f98ad4471a901fb66b3
parent 1e1064d63bca1c55c2c5f9b91cc6fb5fb3fb3d71
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:15 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:30:08 +0100

 net/ipv4/ipvs/ip_vs_core.c |  104 +++++++++++++++++---------------------------
 net/sched/sch_ingress.c    |   44 ++++++++-----------
 2 files changed, 57 insertions(+), 91 deletions(-)

diff --git a/net/ipv4/ipvs/ip_vs_core.c b/net/ipv4/ipvs/ip_vs_core.c
index 30e8f75..f5ba606 100644
--- a/net/ipv4/ipvs/ip_vs_core.c
+++ b/net/ipv4/ipvs/ip_vs_core.c
@@ -1025,43 +1025,42 @@ ip_vs_forward_icmp(unsigned int hooknum, struct sk_buff *skb,
 }
 
 
-/* After packet filtering, forward packet through VS/DR, VS/TUN,
-   or VS/NAT(change destination), so that filtering rules can be
-   applied to IPVS. */
-static struct nf_hook_ops ip_vs_in_ops = {
-	.hook		= ip_vs_in,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum        = NF_INET_LOCAL_IN,
-	.priority       = 100,
-};
-
-/* After packet filtering, change source only for VS/NAT */
-static struct nf_hook_ops ip_vs_out_ops = {
-	.hook		= ip_vs_out,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum        = NF_INET_FORWARD,
-	.priority       = 100,
-};
-
-/* After packet filtering (but before ip_vs_out_icmp), catch icmp
-   destined for 0.0.0.0/0, which is for incoming IPVS connections */
-static struct nf_hook_ops ip_vs_forward_icmp_ops = {
-	.hook		= ip_vs_forward_icmp,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum        = NF_INET_FORWARD,
-	.priority       = 99,
-};
-
-/* Before the netfilter connection tracking, exit from POST_ROUTING */
-static struct nf_hook_ops ip_vs_post_routing_ops = {
-	.hook		= ip_vs_post_routing,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum        = NF_INET_POST_ROUTING,
-	.priority       = NF_IP_PRI_NAT_SRC-1,
+static struct nf_hook_ops ip_vs_ops[]  = {
+	/* After packet filtering, forward packet through VS/DR, VS/TUN,
+	 * or VS/NAT(change destination), so that filtering rules can be
+	 * applied to IPVS. */
+	{
+		.hook		= ip_vs_in,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum        = NF_INET_LOCAL_IN,
+		.priority       = 100,
+	},
+	/* After packet filtering, change source only for VS/NAT */
+	{
+		.hook		= ip_vs_out,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum        = NF_INET_FORWARD,
+		.priority       = 100,
+	},
+	/* After packet filtering (but before ip_vs_out_icmp), catch icmp
+	 * destined for 0.0.0.0/0, which is for incoming IPVS connections */
+	{
+		.hook		= ip_vs_forward_icmp,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum        = NF_INET_FORWARD,
+		.priority       = 99,
+	},
+	/* Before the netfilter connection tracking, exit from POST_ROUTING */
+	{
+		.hook		= ip_vs_post_routing,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum        = NF_INET_POST_ROUTING,
+		.priority       = NF_IP_PRI_NAT_SRC-1,
+	},
 };
 
 
@@ -1092,37 +1091,15 @@ static int __init ip_vs_init(void)
 		goto cleanup_app;
 	}
 
-	ret = nf_register_hook(&ip_vs_in_ops);
+	ret = nf_register_hooks(ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
 	if (ret < 0) {
-		IP_VS_ERR("can't register in hook.\n");
+		IP_VS_ERR("can't register hooks.\n");
 		goto cleanup_conn;
 	}
 
-	ret = nf_register_hook(&ip_vs_out_ops);
-	if (ret < 0) {
-		IP_VS_ERR("can't register out hook.\n");
-		goto cleanup_inops;
-	}
-	ret = nf_register_hook(&ip_vs_post_routing_ops);
-	if (ret < 0) {
-		IP_VS_ERR("can't register post_routing hook.\n");
-		goto cleanup_outops;
-	}
-	ret = nf_register_hook(&ip_vs_forward_icmp_ops);
-	if (ret < 0) {
-		IP_VS_ERR("can't register forward_icmp hook.\n");
-		goto cleanup_postroutingops;
-	}
-
 	IP_VS_INFO("ipvs loaded.\n");
 	return ret;
 
-  cleanup_postroutingops:
-	nf_unregister_hook(&ip_vs_post_routing_ops);
-  cleanup_outops:
-	nf_unregister_hook(&ip_vs_out_ops);
-  cleanup_inops:
-	nf_unregister_hook(&ip_vs_in_ops);
   cleanup_conn:
 	ip_vs_conn_cleanup();
   cleanup_app:
@@ -1136,10 +1113,7 @@ static int __init ip_vs_init(void)
 
 static void __exit ip_vs_cleanup(void)
 {
-	nf_unregister_hook(&ip_vs_forward_icmp_ops);
-	nf_unregister_hook(&ip_vs_post_routing_ops);
-	nf_unregister_hook(&ip_vs_out_ops);
-	nf_unregister_hook(&ip_vs_in_ops);
+	nf_unregister_hooks(ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
 	ip_vs_conn_cleanup();
 	ip_vs_app_cleanup();
 	ip_vs_protocol_cleanup();
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 902d82e..f4af9b6 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -231,20 +231,21 @@ ing_hook(unsigned int hook, struct sk_buff *skb,
 }
 
 /* after ipt_filter */
-static struct nf_hook_ops ing_ops = {
-	.hook           = ing_hook,
-	.owner		= THIS_MODULE,
-	.pf             = PF_INET,
-	.hooknum        = NF_INET_PRE_ROUTING,
-	.priority       = NF_IP_PRI_FILTER + 1,
-};
-
-static struct nf_hook_ops ing6_ops = {
-	.hook           = ing_hook,
-	.owner		= THIS_MODULE,
-	.pf             = PF_INET6,
-	.hooknum        = NF_INET_PRE_ROUTING,
-	.priority       = NF_IP6_PRI_FILTER + 1,
+static struct nf_hook_ops ing_ops[] = {
+	{
+		.hook           = ing_hook,
+		.owner		= THIS_MODULE,
+		.pf             = PF_INET,
+		.hooknum        = NF_INET_PRE_ROUTING,
+		.priority       = NF_IP_PRI_FILTER + 1,
+	},
+	{
+		.hook           = ing_hook,
+		.owner		= THIS_MODULE,
+		.pf             = PF_INET6,
+		.hooknum        = NF_INET_PRE_ROUTING,
+		.priority       = NF_IP6_PRI_FILTER + 1,
+	},
 };
 
 #endif
@@ -268,17 +269,11 @@ static int ingress_init(struct Qdisc *sch,struct rtattr *opt)
 #ifndef CONFIG_NET_CLS_ACT
 #ifdef CONFIG_NETFILTER
 	if (!nf_registered) {
-		if (nf_register_hook(&ing_ops) < 0) {
+		if (nf_register_hooks(ing_ops, ARRAY_SIZE(ing_ops)) < 0) {
 			printk("ingress qdisc registration error \n");
 			return -EINVAL;
 		}
 		nf_registered++;
-
-		if (nf_register_hook(&ing6_ops) < 0) {
-			printk("IPv6 ingress qdisc registration error, " \
-			    "disabling IPv6 support.\n");
-		} else
-			nf_registered++;
 	}
 #endif
 #endif
@@ -385,11 +380,8 @@ static void __exit ingress_module_exit(void)
 	unregister_qdisc(&ingress_qdisc_ops);
 #ifndef CONFIG_NET_CLS_ACT
 #ifdef CONFIG_NETFILTER
-	if (nf_registered) {
-		nf_unregister_hook(&ing_ops);
-		if (nf_registered > 1)
-			nf_unregister_hook(&ing6_ops);
-	}
+	if (nf_registered)
+		nf_unregister_hooks(ing_ops, ARRAY_SIZE(ing_ops));
 #endif
 #endif
 }
