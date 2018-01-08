From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 26/52] netfilter: core: pass hook number, family and device to nf_find_hook_list()
Date: Mon,  8 Jan 2018 21:19:34 +0100
Message-ID: <20180108202000.12989-27-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Instead of passing struct nf_hook_ops, this is needed by follow up
patches to handle NFPROTO_INET from the core.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 9153b6e03f6b..bcbaa78ec374 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -268,36 +268,38 @@ static void *__nf_hook_entries_try_shrink(struct nf_hook_entries __rcu **pp)
 	return old;
 }
 
-static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const struct nf_hook_ops *reg)
+static struct nf_hook_entries __rcu **
+nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
+		   struct net_device *dev)
 {
-	switch (reg->pf) {
+	switch (pf) {
 	case NFPROTO_NETDEV:
 		break;
 #ifdef CONFIG_NETFILTER_FAMILY_ARP
 	case NFPROTO_ARP:
-		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_arp) <= reg->hooknum))
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_arp) <= hooknum))
 			return NULL;
-		return net->nf.hooks_arp + reg->hooknum;
+		return net->nf.hooks_arp + hooknum;
 #endif
 #ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
 	case NFPROTO_BRIDGE:
-		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_bridge) <= reg->hooknum))
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_bridge) <= hooknum))
 			return NULL;
-		return net->nf.hooks_bridge + reg->hooknum;
+		return net->nf.hooks_bridge + hooknum;
 #endif
 	case NFPROTO_IPV4:
-		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv4) <= reg->hooknum))
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv4) <= hooknum))
 			return NULL;
-		return net->nf.hooks_ipv4 + reg->hooknum;
+		return net->nf.hooks_ipv4 + hooknum;
 	case NFPROTO_IPV6:
-		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv6) <= reg->hooknum))
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv6) <= hooknum))
 			return NULL;
-		return net->nf.hooks_ipv6 + reg->hooknum;
+		return net->nf.hooks_ipv6 + hooknum;
 #if IS_ENABLED(CONFIG_DECNET)
 	case NFPROTO_DECNET:
-		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_decnet) <= reg->hooknum))
+		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_decnet) <= hooknum))
 			return NULL;
-		return net->nf.hooks_decnet + reg->hooknum;
+		return net->nf.hooks_decnet + hooknum;
 #endif
 	default:
 		WARN_ON_ONCE(1);
@@ -305,9 +307,9 @@ static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const
 	}
 
 #ifdef CONFIG_NETFILTER_INGRESS
-	if (reg->hooknum == NF_NETDEV_INGRESS) {
-		if (reg->dev && dev_net(reg->dev) == net)
-			return &reg->dev->nf_hooks_ingress;
+	if (hooknum == NF_NETDEV_INGRESS) {
+		if (dev && dev_net(dev) == net)
+			return &dev->nf_hooks_ingress;
 	}
 #endif
 	WARN_ON_ONCE(1);
@@ -329,7 +331,7 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 			return -EINVAL;
 	}
 
-	pp = nf_hook_entry_head(net, reg);
+	pp = nf_hook_entry_head(net, reg->pf, reg->hooknum, reg->dev);
 	if (!pp)
 		return -EINVAL;
 
@@ -403,7 +405,7 @@ void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	struct nf_hook_entries __rcu **pp;
 	struct nf_hook_entries *p;
 
-	pp = nf_hook_entry_head(net, reg);
+	pp = nf_hook_entry_head(net, reg->pf, reg->hooknum, reg->dev);
 	if (!pp)
 		return;
 
-- 
2.11.0
