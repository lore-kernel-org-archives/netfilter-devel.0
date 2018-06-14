From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 10/13] netfilter: nf_flow_table: add flowtable for early ingress hook
Date: Thu, 14 Jun 2018 16:19:44 +0200
Message-ID: <20180614141947.3580-11-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add the new flowtable type for the early ingress hook, this allows
us to combine the custom GRO chaining with the flowtable abstraction
to define fastpaths.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/netfilter/nf_flow_table.h   |  3 ++
 net/ipv4/netfilter/nf_flow_table_ipv4.c | 11 ++++++
 net/netfilter/nf_flow_table_ip.c        | 62 +++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 4606bad41155..e270269dd1e8 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -126,6 +126,9 @@ unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 				     const struct nf_hook_state *state);
 unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				       const struct nf_hook_state *state);
+unsigned int nf_flow_offload_early_ingress_ip_hook(void *priv,
+						   struct sk_buff *skb,
+						   const struct nf_hook_state *state);
 
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index 681c0d5c47d7..b771000ca894 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -14,15 +14,26 @@ static struct nf_flowtable_type flowtable_ipv4 = {
 	.owner		= THIS_MODULE,
 };
 
+static struct nf_flowtable_type flowtable_ipv4_early = {
+	.family		= NFPROTO_IPV4,
+	.hooknum	= NF_NETDEV_EARLY_INGRESS,
+	.init		= nf_flow_table_init,
+	.free		= nf_flow_table_free,
+	.hook		= nf_flow_offload_early_ingress_ip_hook,
+	.owner		= THIS_MODULE,
+};
+
 static int __init nf_flow_ipv4_module_init(void)
 {
 	nft_register_flowtable_type(&flowtable_ipv4);
+	nft_register_flowtable_type(&flowtable_ipv4_early);
 
 	return 0;
 }
 
 static void __exit nf_flow_ipv4_module_exit(void)
 {
+	nft_unregister_flowtable_type(&flowtable_ipv4_early);
 	nft_unregister_flowtable_type(&flowtable_ipv4);
 }
 
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 15ed91309992..0828e49bd95e 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -11,6 +11,7 @@
 #include <net/ip6_route.h>
 #include <net/neighbour.h>
 #include <net/netfilter/nf_flow_table.h>
+#include <net/xfrm.h>
 /* For layer 4 checksum field offset. */
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -487,3 +488,64 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	return NF_STOLEN;
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
+
+unsigned int
+nf_flow_offload_early_ingress_ip_hook(void *priv, struct sk_buff *skb,
+				      const struct nf_hook_state *state)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table = priv;
+	struct flow_offload_tuple tuple = {};
+	enum flow_offload_tuple_dir dir;
+	struct flow_offload *flow;
+	struct net_device *outdev;
+	const struct rtable *rt;
+	unsigned int thoff;
+	struct iphdr *iph;
+
+	if (skb->protocol != htons(ETH_P_IP))
+		return NF_ACCEPT;
+
+	if (nf_flow_tuple_ip(skb, state->in, &tuple) < 0)
+		return NF_ACCEPT;
+
+	tuplehash = flow_offload_lookup(flow_table, &tuple);
+	if (tuplehash == NULL)
+		return NF_ACCEPT;
+
+	outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.oifidx);
+	if (!outdev)
+		return NF_ACCEPT;
+
+	dir = tuplehash->tuple.dir;
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+	rt = (const struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
+
+	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)) &&
+	    (ip_hdr(skb)->frag_off & htons(IP_DF)) != 0)
+		return NF_ACCEPT;
+
+	if (skb_try_make_writable(skb, sizeof(*iph)))
+		return NF_DROP;
+
+	thoff = ip_hdr(skb)->ihl * 4;
+	if (nf_flow_state_check(flow, ip_hdr(skb)->protocol, skb, thoff))
+		return NF_ACCEPT;
+
+	if (flow->flags & (FLOW_OFFLOAD_SNAT | FLOW_OFFLOAD_DNAT) &&
+	    nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
+		return NF_DROP;
+
+	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
+
+	skb_dst_set_noref(skb, flow->tuplehash[dir].tuple.dst_cache);
+
+	if (skb_dst(skb)->xfrm &&
+	    !xfrm_dev_offload_ok(skb, skb_dst(skb)->xfrm))
+		return NF_ACCEPT;
+
+	NAPI_GRO_CB(skb)->is_ffwd = 1;
+
+	return NF_STOLEN;
+}
+EXPORT_SYMBOL_GPL(nf_flow_offload_early_ingress_ip_hook);
-- 
2.11.0
