From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/2] netfilter: nf_tables: remove hooks from family definition
Date: Wed, 22 Nov 2017 15:04:24 +0100
Message-ID: <20171122140424.14914-2-pablo@netfilter.org>
References: <20171122140424.14914-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46500 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751415AbdKVOEd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 09:04:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D01E1D94B4
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:04:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C28FDA793
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:04:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30BA5DA861
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:04:29 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E9AD0403DFA0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:04:28 +0100 (CET)
In-Reply-To: <20171122140424.14914-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

They don't belong to the family definition, move them to the filter
chain type definition instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h       |  2 +-
 net/bridge/netfilter/nf_tables_bridge.c | 14 +++++++-------
 net/ipv4/netfilter/nf_tables_arp.c      |  8 ++++----
 net/ipv4/netfilter/nf_tables_ipv4.c     | 14 +++++++-------
 net/ipv6/netfilter/nf_tables_ipv6.c     | 14 +++++++-------
 net/netfilter/nf_tables_api.c           |  6 +-----
 net/netfilter/nf_tables_inet.c          | 14 +++++++-------
 net/netfilter/nf_tables_netdev.c        |  6 +++---
 8 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4d744c2c45c6..1603a5208af3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -883,7 +883,7 @@ enum nft_chain_type {
  * 	@family: address family
  * 	@owner: module owner
  * 	@hook_mask: mask of valid hooks
- * 	@hooks: hookfn overrides
+ * 	@hooks: array of hook functions
  */
 struct nf_chain_type {
 	const char			*name;
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 2dfe500fa74a..ec42fbd8b104 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -44,13 +44,6 @@ static struct nft_af_info nft_af_bridge __read_mostly = {
 	.family		= NFPROTO_BRIDGE,
 	.nhooks		= NF_BR_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.hooks		= {
-		[NF_BR_PRE_ROUTING]	= nft_do_chain_bridge,
-		[NF_BR_LOCAL_IN]	= nft_do_chain_bridge,
-		[NF_BR_FORWARD]		= nft_do_chain_bridge,
-		[NF_BR_LOCAL_OUT]	= nft_do_chain_bridge,
-		[NF_BR_POST_ROUTING]	= nft_do_chain_bridge,
-	},
 };
 
 static int nf_tables_bridge_init_net(struct net *net)
@@ -91,6 +84,13 @@ static const struct nf_chain_type filter_bridge = {
 			  (1 << NF_BR_FORWARD) |
 			  (1 << NF_BR_LOCAL_OUT) |
 			  (1 << NF_BR_POST_ROUTING),
+	.hooks		= {
+		[NF_BR_PRE_ROUTING]	= nft_do_chain_bridge,
+		[NF_BR_LOCAL_IN]	= nft_do_chain_bridge,
+		[NF_BR_FORWARD]		= nft_do_chain_bridge,
+		[NF_BR_LOCAL_OUT]	= nft_do_chain_bridge,
+		[NF_BR_POST_ROUTING]	= nft_do_chain_bridge,
+	},
 };
 
 static void nf_br_saveroute(const struct sk_buff *skb,
diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 89baee02eed4..ab2ec8669fae 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -30,10 +30,6 @@ static struct nft_af_info nft_af_arp __read_mostly = {
 	.family		= NFPROTO_ARP,
 	.nhooks		= NF_ARP_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.hooks		= {
-		[NF_ARP_IN]		= nft_do_chain_arp,
-		[NF_ARP_OUT]		= nft_do_chain_arp,
-	},
 };
 
 static int nf_tables_arp_init_net(struct net *net)
@@ -71,6 +67,10 @@ static const struct nf_chain_type filter_arp = {
 	.owner		= THIS_MODULE,
 	.hook_mask	= (1 << NF_ARP_IN) |
 			  (1 << NF_ARP_OUT),
+	.hooks		= {
+		[NF_ARP_IN]		= nft_do_chain_arp,
+		[NF_ARP_OUT]		= nft_do_chain_arp,
+	},
 };
 
 static int __init nf_tables_arp_init(void)
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index 69c58318e387..91eae6d34a36 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -48,13 +48,6 @@ static struct nft_af_info nft_af_ipv4 __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.hooks		= {
-		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv4,
-		[NF_INET_LOCAL_OUT]	= nft_ipv4_output,
-		[NF_INET_FORWARD]	= nft_do_chain_ipv4,
-		[NF_INET_PRE_ROUTING]	= nft_do_chain_ipv4,
-		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv4,
-	},
 };
 
 static int nf_tables_ipv4_init_net(struct net *net)
@@ -95,6 +88,13 @@ static const struct nf_chain_type filter_ipv4 = {
 			  (1 << NF_INET_FORWARD) |
 			  (1 << NF_INET_PRE_ROUTING) |
 			  (1 << NF_INET_POST_ROUTING),
+	.hooks		= {
+		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv4,
+		[NF_INET_LOCAL_OUT]	= nft_ipv4_output,
+		[NF_INET_FORWARD]	= nft_do_chain_ipv4,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain_ipv4,
+		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv4,
+	},
 };
 
 static int __init nf_tables_ipv4_init(void)
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index 2948b57dfd04..a13aaff76b43 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -45,13 +45,6 @@ static struct nft_af_info nft_af_ipv6 __read_mostly = {
 	.family		= NFPROTO_IPV6,
 	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.hooks		= {
-		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv6,
-		[NF_INET_LOCAL_OUT]	= nft_ipv6_output,
-		[NF_INET_FORWARD]	= nft_do_chain_ipv6,
-		[NF_INET_PRE_ROUTING]	= nft_do_chain_ipv6,
-		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv6,
-	},
 };
 
 static int nf_tables_ipv6_init_net(struct net *net)
@@ -92,6 +85,13 @@ static const struct nf_chain_type filter_ipv6 = {
 			  (1 << NF_INET_FORWARD) |
 			  (1 << NF_INET_PRE_ROUTING) |
 			  (1 << NF_INET_POST_ROUTING),
+	.hooks		= {
+		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv6,
+		[NF_INET_LOCAL_OUT]	= nft_ipv6_output,
+		[NF_INET_FORWARD]	= nft_do_chain_ipv6,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain_ipv6,
+		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv6,
+	},
 };
 
 static int __init nf_tables_ipv6_init(void)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3e6c201251cd..5d65e315bcf1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1352,7 +1352,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	if (nla[NFTA_CHAIN_HOOK]) {
 		struct nft_chain_hook hook;
 		struct nf_hook_ops *ops;
-		nf_hookfn *hookfn;
 
 		err = nft_chain_parse_hook(net, nla, afi, &hook, create);
 		if (err < 0)
@@ -1378,7 +1377,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			static_branch_inc(&nft_counters_enabled);
 		}
 
-		hookfn = hook.type->hooks[hook.num];
 		basechain->type = hook.type;
 		chain = &basechain->chain;
 
@@ -1387,10 +1385,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		ops->hooknum	= hook.num;
 		ops->priority	= hook.priority;
 		ops->priv	= chain;
-		ops->hook	= afi->hooks[ops->hooknum];
+		ops->hook	= hook.type->hooks[hook.num];
 		ops->dev	= hook.dev;
-		if (hookfn)
-			ops->hook = hookfn;
 
 		chain->flags |= NFT_BASE_CHAIN;
 		basechain->policy = policy;
diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
index 78f0289ea339..cebf94caac2b 100644
--- a/net/netfilter/nf_tables_inet.c
+++ b/net/netfilter/nf_tables_inet.c
@@ -70,13 +70,6 @@ static struct nft_af_info nft_af_inet __read_mostly = {
 	.family		= NFPROTO_INET,
 	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.hooks		= {
-		[NF_INET_LOCAL_IN]	= nft_do_chain_inet,
-		[NF_INET_LOCAL_OUT]	= nft_inet_output,
-		[NF_INET_FORWARD]	= nft_do_chain_inet,
-		[NF_INET_PRE_ROUTING]	= nft_do_chain_inet,
-		[NF_INET_POST_ROUTING]	= nft_do_chain_inet,
-        },
 };
 
 static int __net_init nf_tables_inet_init_net(struct net *net)
@@ -117,6 +110,13 @@ static const struct nf_chain_type filter_inet = {
 			  (1 << NF_INET_FORWARD) |
 			  (1 << NF_INET_PRE_ROUTING) |
 			  (1 << NF_INET_POST_ROUTING),
+	.hooks		= {
+		[NF_INET_LOCAL_IN]	= nft_do_chain_inet,
+		[NF_INET_LOCAL_OUT]	= nft_inet_output,
+		[NF_INET_FORWARD]	= nft_do_chain_inet,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain_inet,
+		[NF_INET_POST_ROUTING]	= nft_do_chain_inet,
+        },
 };
 
 static int __init nf_tables_inet_init(void)
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index aabb00b462de..003b28bfa7a5 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -41,9 +41,6 @@ static struct nft_af_info nft_af_netdev __read_mostly = {
 	.nhooks		= NF_NETDEV_NUMHOOKS,
 	.owner		= THIS_MODULE,
 	.flags		= NFT_AF_NEEDS_DEV,
-	.hooks		= {
-		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
-	},
 };
 
 static int nf_tables_netdev_init_net(struct net *net)
@@ -80,6 +77,9 @@ static const struct nf_chain_type nft_filter_chain_netdev = {
 	.family		= NFPROTO_NETDEV,
 	.owner		= THIS_MODULE,
 	.hook_mask	= (1 << NF_NETDEV_INGRESS),
+	.hooks		= {
+		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
+	},
 };
 
 static void nft_netdev_event(unsigned long event, struct net_device *dev,
-- 
2.11.0

