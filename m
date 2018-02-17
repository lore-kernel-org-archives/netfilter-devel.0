From: Felix Fietkau <nbd@nbd.name>
Subject: [RFC 3/9] ipv6: make ip6_dst_mtu_forward inline
Date: Sat, 17 Feb 2018 12:12:00 +0100
Message-ID: <20180217111206.37312-3-nbd@nbd.name>
References: <20180217111206.37312-1-nbd@nbd.name>
Cc: pablo@netfilter.org, nbd@nbd.name
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54284 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbeBQLMK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Feb 2018 06:12:10 -0500
In-Reply-To: <20180217111206.37312-1-nbd@nbd.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Removes a direct dependency on ipv6.ko

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/ip6_route.h | 22 ++++++++++++++++++++++
 include/net/ipv6.h      |  2 --
 net/ipv6/ip6_output.c   | 22 ----------------------
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 27d23a65f3cd..dae0ddfeb4db 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -266,4 +266,26 @@ static inline bool rt6_duplicate_nexthop(struct rt6_info *a, struct rt6_info *b)
 	       ipv6_addr_equal(&a->rt6i_gateway, &b->rt6i_gateway) &&
 	       !lwtunnel_cmp_encap(a->dst.lwtstate, b->dst.lwtstate);
 }
+
+static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
+{
+	unsigned int mtu;
+	struct inet6_dev *idev;
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
 #endif
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 8606c9113d3f..51d559b19d85 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -970,8 +970,6 @@ static inline struct sk_buff *ip6_finish_skb(struct sock *sk)
 			      &inet6_sk(sk)->cork);
 }
 
-unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst);
-
 int ip6_dst_lookup(struct net *net, struct sock *sk, struct dst_entry **dst,
 		   struct flowi6 *fl6);
 struct dst_entry *ip6_dst_lookup_flow(const struct sock *sk, struct flowi6 *fl6,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 997c7f19ad62..c7f3545f75f4 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -378,28 +378,6 @@ static inline int ip6_forward_finish(struct net *net, struct sock *sk,
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
2.14.2

