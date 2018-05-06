From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/51] ipv6: make ip6_dst_mtu_forward inline
Date: Mon,  7 May 2018 00:46:27 +0200
Message-ID: <20180506224709.29100-10-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Just like ip_dst_mtu_maybe_forward(), to avoid a dependency with ipv6.ko.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip6_route.h | 21 +++++++++++++++++++++
 include/net/ipv6.h      |  2 --
 net/ipv6/ip6_output.c   | 22 ----------------------
 3 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index d5fb1e4ae7ac..376928c26d2d 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -279,6 +279,27 @@ static inline bool rt6_duplicate_nexthop(struct fib6_info *a, struct fib6_info *
 	       !lwtunnel_cmp_encap(a->fib6_nh.nh_lwtstate, b->fib6_nh.nh_lwtstate);
 }
 
+static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
+{
+	struct inet6_dev *idev;
+	unsigned int mtu;
+
+	if (dst_metric_locked(dst, RTAX_MTU)) {
+		mtu = dst_metric_raw(dst, RTAX_MTU);
+		if (mtu)
+			return mtu;
+	}
+
+	mtu = IPV6_MIN_MTU;
+	rcu_read_lock();
+	idev = __in6_dev_get(dst->dev);
+	if (idev)
+		mtu = idev->cnf.mtu6;
+	rcu_read_unlock();
+
+	return mtu;
+}
+
 struct neighbour *ip6_neigh_lookup(const struct in6_addr *gw,
 				   struct net_device *dev, struct sk_buff *skb,
 				   const void *daddr);
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 68b167d98879..765441867cfa 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -958,8 +958,6 @@ static inline struct sk_buff *ip6_finish_skb(struct sock *sk)
 			      &inet6_sk(sk)->cork);
 }
 
-unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst);
-
 int ip6_dst_lookup(struct net *net, struct sock *sk, struct dst_entry **dst,
 		   struct flowi6 *fl6);
 struct dst_entry *ip6_dst_lookup_flow(const struct sock *sk, struct flowi6 *fl6,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 3db47986ef38..cec49e137dbb 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -383,28 +383,6 @@ static inline int ip6_forward_finish(struct net *net, struct sock *sk,
 	return dst_output(net, sk, skb);
 }
 
-unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
-{
-	unsigned int mtu;
-	struct inet6_dev *idev;
-
-	if (dst_metric_locked(dst, RTAX_MTU)) {
-		mtu = dst_metric_raw(dst, RTAX_MTU);
-		if (mtu)
-			return mtu;
-	}
-
-	mtu = IPV6_MIN_MTU;
-	rcu_read_lock();
-	idev = __in6_dev_get(dst->dev);
-	if (idev)
-		mtu = idev->cnf.mtu6;
-	rcu_read_unlock();
-
-	return mtu;
-}
-EXPORT_SYMBOL_GPL(ip6_dst_mtu_forward);
-
 static bool ip6_pkt_too_big(const struct sk_buff *skb, unsigned int mtu)
 {
 	if (skb->len <= mtu)
-- 
2.11.0
