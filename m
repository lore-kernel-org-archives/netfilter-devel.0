From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/47] netfilter: xt_cluster: get rid of xt_cluster_ipv6_is_multicast
Date: Fri, 30 Mar 2018 13:36:45 +0200
Message-ID: <20180330113729.18335-4-pablo@netfilter.org>
References: <20180330113729.18335-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113729.18335-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

If use the ipv6_addr_is_multicast instead of xt_cluster_ipv6_is_multicast,
then we can reduce code size.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_cluster.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 0068688995c8..dfbdbb2fc0ed 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -60,13 +60,6 @@ xt_cluster_hash(const struct nf_conn *ct,
 }
 
 static inline bool
-xt_cluster_ipv6_is_multicast(const struct in6_addr *addr)
-{
-	__be32 st = addr->s6_addr32[0];
-	return ((st & htonl(0xFF000000)) == htonl(0xFF000000));
-}
-
-static inline bool
 xt_cluster_is_multicast_addr(const struct sk_buff *skb, u_int8_t family)
 {
 	bool is_multicast = false;
@@ -76,8 +69,7 @@ xt_cluster_is_multicast_addr(const struct sk_buff *skb, u_int8_t family)
 		is_multicast = ipv4_is_multicast(ip_hdr(skb)->daddr);
 		break;
 	case NFPROTO_IPV6:
-		is_multicast =
-			xt_cluster_ipv6_is_multicast(&ipv6_hdr(skb)->daddr);
+		is_multicast = ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
 		break;
 	default:
 		WARN_ON(1);
-- 
2.11.0
