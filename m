From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: rpfilter: fix incorrect loopback packet judgment
Date: Sat,  7 Jan 2017 20:49:18 +0800
Message-ID: <1483793358-30619-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:60257 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932130AbdAGMuf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Jan 2017 07:50:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Currently, we check the existing rtable in PREROUTING hook, if RTCF_LOCAL
is set, we assume that the packet is loopback.

But this assumption is incorrect, for example, a packet encapsulated
in ipsec transport mode was received and routed to local, after
decapsulation, it would be delivered to local again, and the rtable
was not dropped, so RTCF_LOCAL check would trigger. But actually, the
packet was not loopback.

So for these normal loopback packets, we can check whether the in device
is IFF_LOOPBACK or not. For these locally generated broadcast/multicast,
we can check whether the skb->pkt_type is PACKET_LOOPBACK or not.

Finally, there's a subtle difference between nft fib expr and xtables
rpfilter extension, user can add the following nft rule to do strict
rpfilter check:
  # nft add rule x y meta iif eth0 fib saddr . iif oif != eth0 drop

So when the packet is loopback, it's better to store the in device
instead of the LOOPBACK_IFINDEX, otherwise, after adding the above
nft rule, locally generated broad/multicast packets will be dropped
incorrectly.

Fixes: f83a7ea2075c ("netfilter: xt_rpfilter: skip locally generated broadcast/multicast, too")
Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/net/netfilter/nft_fib.h    |  6 ++++++
 net/ipv4/netfilter/ipt_rpfilter.c  |  8 ++++----
 net/ipv4/netfilter/nft_fib_ipv4.c  | 15 +++++----------
 net/ipv6/netfilter/ip6t_rpfilter.c |  8 ++++----
 net/ipv6/netfilter/nft_fib_ipv6.c  | 13 ++++---------
 5 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index cbedda0..5ceb220 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -9,6 +9,12 @@ struct nft_fib {
 
 extern const struct nla_policy nft_fib_policy[];
 
+static inline bool
+nft_fib_is_loopback(const struct sk_buff *skb, const struct net_device *in)
+{
+	return skb->pkt_type == PACKET_LOOPBACK || in->flags & IFF_LOOPBACK;
+}
+
 int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr);
 int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		 const struct nlattr * const tb[]);
diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index f273098..37fb955 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -63,10 +63,10 @@ static bool rpfilter_lookup_reverse(struct net *net, struct flowi4 *fl4,
 	return dev_match || flags & XT_RPFILTER_LOOSE;
 }
 
-static bool rpfilter_is_local(const struct sk_buff *skb)
+static bool
+rpfilter_is_loopback(const struct sk_buff *skb, const struct net_device *in)
 {
-	const struct rtable *rt = skb_rtable(skb);
-	return rt && (rt->rt_flags & RTCF_LOCAL);
+	return skb->pkt_type == PACKET_LOOPBACK || in->flags & IFF_LOOPBACK;
 }
 
 static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -79,7 +79,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	info = par->matchinfo;
 	invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (rpfilter_is_local(skb))
+	if (rpfilter_is_loopback(skb, xt_in(par)))
 		return true ^ invert;
 
 	iph = ip_hdr(skb);
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 965b1a1..29812919 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -26,13 +26,6 @@ static __be32 get_saddr(__be32 addr)
 	return addr;
 }
 
-static bool fib4_is_local(const struct sk_buff *skb)
-{
-	const struct rtable *rt = skb_rtable(skb);
-
-	return rt && (rt->rt_flags & RTCF_LOCAL);
-}
-
 #define DSCP_BITS     0xfc
 
 void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
@@ -95,8 +88,10 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		oif = NULL;
 
-	if (nft_hook(pkt) == NF_INET_PRE_ROUTING && fib4_is_local(pkt->skb)) {
-		nft_fib_store_result(dest, priv->result, pkt, LOOPBACK_IFINDEX);
+	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
+	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
+		nft_fib_store_result(dest, priv->result, pkt,
+				     nft_in(pkt)->ifindex);
 		return;
 	}
 
@@ -131,7 +126,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	switch (res.type) {
 	case RTN_UNICAST:
 		break;
-	case RTN_LOCAL:	/* should not appear here, see fib4_is_local() above */
+	case RTN_LOCAL: /* Should not see RTN_LOCAL here */
 		return;
 	default:
 		break;
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index d5263dc..b12e61b 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -72,10 +72,10 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	return ret;
 }
 
-static bool rpfilter_is_local(const struct sk_buff *skb)
+static bool
+rpfilter_is_loopback(const struct sk_buff *skb, const struct net_device *in)
 {
-	const struct rt6_info *rt = (const void *) skb_dst(skb);
-	return rt && (rt->rt6i_flags & RTF_LOCAL);
+	return skb->pkt_type == PACKET_LOOPBACK || in->flags & IFF_LOOPBACK;
 }
 
 static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -85,7 +85,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	struct ipv6hdr *iph;
 	bool invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (rpfilter_is_local(skb))
+	if (rpfilter_is_loopback(skb, xt_in(par)))
 		return true ^ invert;
 
 	iph = ipv6_hdr(skb);
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index c947aad..765facf 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -18,13 +18,6 @@
 #include <net/ip6_fib.h>
 #include <net/ip6_route.h>
 
-static bool fib6_is_local(const struct sk_buff *skb)
-{
-	const struct rt6_info *rt = (const void *)skb_dst(skb);
-
-	return rt && (rt->rt6i_flags & RTF_LOCAL);
-}
-
 static int get_ifindex(const struct net_device *dev)
 {
 	return dev ? dev->ifindex : 0;
@@ -164,8 +157,10 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, oif);
 
-	if (nft_hook(pkt) == NF_INET_PRE_ROUTING && fib6_is_local(pkt->skb)) {
-		nft_fib_store_result(dest, priv->result, pkt, LOOPBACK_IFINDEX);
+	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
+	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
+		nft_fib_store_result(dest, priv->result, pkt,
+				     nft_in(pkt)->ifindex);
 		return;
 	}
 
-- 
2.5.5


