From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 13/13] netfilter: nft_flow_offload: make sure route is not stale
Date: Thu, 14 Jun 2018 16:19:47 +0200
Message-ID: <20180614141947.3580-14-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Use dst_check() to validate that route is still valid, otherwise,
tear down the flow entry and pass up packet to the standard forwarding
path so we have a chance to cache the fresh route again.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/netfilter/nf_flow_table_ip.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 0828e49bd95e..2bdf740debac 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -244,6 +244,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
 
+	if (dst_check(&rt->dst, 0)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)) &&
 	    (ip_hdr(skb)->frag_off & htons(IP_DF)) != 0)
 		return NF_ACCEPT;
@@ -462,6 +467,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst_cache;
 
+	if (dst_check(&rt->dst, 0)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
-- 
2.11.0
