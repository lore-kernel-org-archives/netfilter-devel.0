From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/51] netfilter: nf_flow_table: move ip header check out of nf_flow_exceeds_mtu
Date: Mon,  7 May 2018 00:46:31 +0200
Message-ID: <20180506224709.29100-14-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Allows the function to be shared with the IPv6 hook code

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 034fda963392..103263e0c7c2 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -182,9 +182,6 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	if (skb->len <= mtu)
 		return false;
 
-	if ((ip_hdr(skb)->frag_off & htons(IP_DF)) == 0)
-		return false;
-
 	if (skb_is_gso(skb) && skb_gso_validate_network_len(skb, mtu))
 		return false;
 
@@ -223,7 +220,8 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	rt = (const struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
 
-	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
+	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)) &&
+	    (ip_hdr(skb)->frag_off & htons(IP_DF)) != 0)
 		return NF_ACCEPT;
 
 	if (skb_try_make_writable(skb, sizeof(*iph)))
-- 
2.11.0
