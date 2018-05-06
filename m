From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/51] netfilter: nf_flow_table: cache mtu in struct flow_offload_tuple
Date: Mon,  7 May 2018 00:46:28 +0200
Message-ID: <20180506224709.29100-11-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Reduces the number of cache lines touched in the offload forwarding
path. This is safe because PMTU limits are bypassed for the forwarding
path (see commit f87c10a8aa1e for more details).

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h   |  2 ++
 net/ipv4/netfilter/nf_flow_table_ipv4.c | 17 +++--------------
 net/ipv6/netfilter/nf_flow_table_ipv6.c | 17 +++--------------
 net/netfilter/nf_flow_table.c           |  8 ++++++--
 4 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 09ba67598991..76ee5c81b752 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -55,6 +55,8 @@ struct flow_offload_tuple {
 
 	int				oifidx;
 
+	u16				mtu;
+
 	struct dst_entry		*dst_cache;
 };
 
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index 0cd46bffa469..461b1815e633 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -178,7 +178,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 }
 
 /* Based on ip_exceeds_mtu(). */
-static bool __nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
+static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 {
 	if (skb->len <= mtu)
 		return false;
@@ -192,17 +192,6 @@ static bool __nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
-static bool nf_flow_exceeds_mtu(struct sk_buff *skb, const struct rtable *rt)
-{
-	u32 mtu;
-
-	mtu = ip_dst_mtu_maybe_forward(&rt->dst, true);
-	if (__nf_flow_exceeds_mtu(skb, mtu))
-		return true;
-
-	return false;
-}
-
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -233,9 +222,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-
 	rt = (const struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
-	if (unlikely(nf_flow_exceeds_mtu(skb, rt)))
+
+	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
 	if (skb_try_make_writable(skb, sizeof(*iph)))
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index 207cb35569b1..0e6328490142 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -173,7 +173,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 }
 
 /* Based on ip_exceeds_mtu(). */
-static bool __nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
+static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 {
 	if (skb->len <= mtu)
 		return false;
@@ -184,17 +184,6 @@ static bool __nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
-static bool nf_flow_exceeds_mtu(struct sk_buff *skb, const struct rt6_info *rt)
-{
-	u32 mtu;
-
-	mtu = ip6_dst_mtu_forward(&rt->dst);
-	if (__nf_flow_exceeds_mtu(skb, mtu))
-		return true;
-
-	return false;
-}
-
 unsigned int
 nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			  const struct nf_hook_state *state)
@@ -225,9 +214,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-
 	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst_cache;
-	if (unlikely(nf_flow_exceeds_mtu(skb, rt)))
+
+	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
 	if (skb_try_make_writable(skb, sizeof(*ip6h)))
diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table.c
index db0673a40b97..7403a0dfddf7 100644
--- a/net/netfilter/nf_flow_table.c
+++ b/net/netfilter/nf_flow_table.c
@@ -4,6 +4,8 @@
 #include <linux/netfilter.h>
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
+#include <net/ip.h>
+#include <net/ip6_route.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_conntrack.h>
@@ -23,6 +25,7 @@ flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
 {
 	struct flow_offload_tuple *ft = &flow->tuplehash[dir].tuple;
 	struct nf_conntrack_tuple *ctt = &ct->tuplehash[dir].tuple;
+	struct dst_entry *dst = route->tuple[dir].dst;
 
 	ft->dir = dir;
 
@@ -30,10 +33,12 @@ flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
 	case NFPROTO_IPV4:
 		ft->src_v4 = ctt->src.u3.in;
 		ft->dst_v4 = ctt->dst.u3.in;
+		ft->mtu = ip_dst_mtu_maybe_forward(dst, true);
 		break;
 	case NFPROTO_IPV6:
 		ft->src_v6 = ctt->src.u3.in6;
 		ft->dst_v6 = ctt->dst.u3.in6;
+		ft->mtu = ip6_dst_mtu_forward(dst);
 		break;
 	}
 
@@ -44,8 +49,7 @@ flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
 
 	ft->iifidx = route->tuple[dir].ifindex;
 	ft->oifidx = route->tuple[!dir].ifindex;
-
-	ft->dst_cache = route->tuple[dir].dst;
+	ft->dst_cache = dst;
 }
 
 struct flow_offload *
-- 
2.11.0
