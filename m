From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 4/7] netfilter: remove route indirection in struct nf_afinfo
Date: Tue, 19 Dec 2017 00:46:55 +0100
Message-ID: <20171218234658.5004-4-pablo@netfilter.org>
References: <20171218234658.5004-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48462 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933814AbdLRXrJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 18:47:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CD60CFB444
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9D6234D5
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57DEF34D5
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:05 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3F9774265A30
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:05 +0100 (CET)
In-Reply-To: <20171218234658.5004-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is not needed, we call the afinfo->route indirection for cases
where we just checked for family a few lines before. This patch also
adapts existing clients of this to use the direct call invocation.
Update clients of this indirection to use nf_ip_route() and
nf_ip6_route() where needed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: remove .route from nf_tables_bridge. Reported by kbuild robot.

 include/linux/netfilter.h               |  2 --
 include/linux/netfilter_ipv4.h          |  2 ++
 include/linux/netfilter_ipv6.h          |  7 +++++++
 net/bridge/netfilter/nf_tables_bridge.c |  7 -------
 net/ipv4/netfilter.c                    |  6 +++---
 net/ipv6/netfilter.c                    |  6 +++---
 net/ipv6/netfilter/nft_fib_ipv6.c       |  9 ++-------
 net/netfilter/nf_conntrack_h323_main.c  | 23 +++++++++--------------
 net/netfilter/nft_rt.c                  | 17 +++++++----------
 net/netfilter/xt_TCPMSS.c               |  6 ++----
 net/netfilter/xt_addrtype.c             | 22 +++++++---------------
 11 files changed, 42 insertions(+), 65 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index b3a46a374a89..e703b26025ec 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -311,8 +311,6 @@ struct nf_queue_entry;
 
 struct nf_afinfo {
 	unsigned short	family;
-	int		(*route)(struct net *net, struct dst_entry **dst,
-				 struct flowi *fl, bool strict);
 	int		(*reroute)(struct net *net, struct sk_buff *skb,
 				   const struct nf_queue_entry *entry);
 	int		route_key_size;
diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index f47e657f32ef..97e8131f92d6 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -14,5 +14,7 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			       unsigned int dataoff, unsigned int len,
 			       u_int8_t protocol);
+int nf_ip_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
+		bool strict);
 void nf_ip_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry);
 #endif /*__LINUX_IP_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index d359ee1f3e37..e681738c8591 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -29,6 +29,8 @@ __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
 				unsigned int dataoff, unsigned int len,
 				u_int8_t protocol);
+int nf_ip6_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
+                 bool strict);
 void nf_ip6_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry);
 #else
 static inline __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
@@ -44,6 +46,11 @@ static inline__sum16 nf_ip6_checksum_partial(struct sk_buff *skb,
 {
 	return 0;
 }
+static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
+			       struct flowi *fl, bool strict)
+{
+	return -EOPNOTSUPP;
+}
 static inline void nf_ip6_saveroute(const struct sk_buff *skb,
 				    struct nf_queue_entry *entry) {}
 #endif
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index f38350c6bc29..014b6571f2ac 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -101,15 +101,8 @@ static int nf_br_reroute(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
-static int nf_br_route(struct net *net, struct dst_entry **dst,
-		       struct flowi *fl, bool strict __always_unused)
-{
-	return 0;
-}
-
 static const struct nf_afinfo nf_br_afinfo = {
 	.family                 = AF_BRIDGE,
-	.route                  = nf_br_route,
 	.reroute                = nf_br_reroute,
 	.route_key_size         = 0,
 };
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index dc2021aaf885..c6ba5770af0a 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -175,8 +175,8 @@ __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
 	return csum;
 }
 
-static int nf_ip_route(struct net *net, struct dst_entry **dst,
-		       struct flowi *fl, bool strict __always_unused)
+int nf_ip_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
+		bool strict __always_unused)
 {
 	struct rtable *rt = ip_route_output_key(net, &fl->u.ip4);
 	if (IS_ERR(rt))
@@ -184,10 +184,10 @@ static int nf_ip_route(struct net *net, struct dst_entry **dst,
 	*dst = &rt->dst;
 	return 0;
 }
+EXPORT_SYMBOL(nf_ip_route);
 
 static const struct nf_afinfo nf_ip_afinfo = {
 	.family			= AF_INET,
-	.route			= nf_ip_route,
 	.reroute		= nf_ip_reroute,
 	.route_key_size		= sizeof(struct ip_rt_info),
 };
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 4894f030511e..72364f09253a 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -108,8 +108,8 @@ static int nf_ip6_reroute(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
-static int nf_ip6_route(struct net *net, struct dst_entry **dst,
-			struct flowi *fl, bool strict)
+int nf_ip6_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
+		 bool strict)
 {
 	static const struct ipv6_pinfo fake_pinfo;
 	static const struct inet_sock fake_sk = {
@@ -129,6 +129,7 @@ static int nf_ip6_route(struct net *net, struct dst_entry **dst,
 		*dst = result;
 	return err;
 }
+EXPORT_SYMBOL_GPL(nf_ip6_route);
 
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			     unsigned int dataoff, u_int8_t protocol)
@@ -197,7 +198,6 @@ static const struct nf_ipv6_ops ipv6ops = {
 
 static const struct nf_afinfo nf_ip6_afinfo = {
 	.family			= AF_INET6,
-	.route			= nf_ip6_route,
 	.reroute		= nf_ip6_reroute,
 	.route_key_size		= sizeof(struct ip6_rt_info),
 };
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 54b5899543ef..7fb4651957f1 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -60,7 +60,6 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 {
 	const struct net_device *dev = NULL;
 	const struct nf_ipv6_ops *v6ops;
-	const struct nf_afinfo *afinfo;
 	int route_err, addrtype;
 	struct rt6_info *rt;
 	struct flowi6 fl6 = {
@@ -69,10 +68,6 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 	};
 	u32 ret = 0;
 
-	afinfo = nf_get_afinfo(NFPROTO_IPV6);
-	if (!afinfo)
-		return RTN_UNREACHABLE;
-
 	if (priv->flags & NFTA_FIB_F_IIF)
 		dev = nft_in(pkt);
 	else if (priv->flags & NFTA_FIB_F_OIF)
@@ -84,8 +79,8 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 	if (dev && v6ops && v6ops->chk_addr(nft_net(pkt), &fl6.daddr, dev, true))
 		ret = RTN_LOCAL;
 
-	route_err = afinfo->route(nft_net(pkt), (struct dst_entry **)&rt,
-				  flowi6_to_flowi(&fl6), false);
+	route_err = nf_ip6_route(nft_net(pkt), (struct dst_entry **)&rt,
+				 flowi6_to_flowi(&fl6), false);
 	if (route_err)
 		goto err;
 
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 7f0e0f66e488..3009af56e194 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -25,6 +25,7 @@
 #include <net/route.h>
 #include <net/ip6_route.h>
 
+#include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
@@ -721,14 +722,8 @@ static int callforward_do_filter(struct net *net,
 				 const union nf_inet_addr *dst,
 				 u_int8_t family)
 {
-	const struct nf_afinfo *afinfo;
 	int ret = 0;
 
-	/* rcu_read_lock()ed by nf_hook_thresh */
-	afinfo = nf_get_afinfo(family);
-	if (!afinfo)
-		return 0;
-
 	switch (family) {
 	case AF_INET: {
 		struct flowi4 fl1, fl2;
@@ -739,10 +734,10 @@ static int callforward_do_filter(struct net *net,
 
 		memset(&fl2, 0, sizeof(fl2));
 		fl2.daddr = dst->ip;
-		if (!afinfo->route(net, (struct dst_entry **)&rt1,
-				   flowi4_to_flowi(&fl1), false)) {
-			if (!afinfo->route(net, (struct dst_entry **)&rt2,
-					   flowi4_to_flowi(&fl2), false)) {
+		if (!nf_ip_route(net, (struct dst_entry **)&rt1,
+				 flowi4_to_flowi(&fl1), false)) {
+			if (!nf_ip_route(net, (struct dst_entry **)&rt2,
+					 flowi4_to_flowi(&fl2), false)) {
 				if (rt_nexthop(rt1, fl1.daddr) ==
 				    rt_nexthop(rt2, fl2.daddr) &&
 				    rt1->dst.dev  == rt2->dst.dev)
@@ -763,10 +758,10 @@ static int callforward_do_filter(struct net *net,
 
 		memset(&fl2, 0, sizeof(fl2));
 		fl2.daddr = dst->in6;
-		if (!afinfo->route(net, (struct dst_entry **)&rt1,
-				   flowi6_to_flowi(&fl1), false)) {
-			if (!afinfo->route(net, (struct dst_entry **)&rt2,
-					   flowi6_to_flowi(&fl2), false)) {
+		if (!nf_ip6_route(net, (struct dst_entry **)&rt1,
+				  flowi6_to_flowi(&fl1), false)) {
+			if (!nf_ip6_route(net, (struct dst_entry **)&rt2,
+					  flowi6_to_flowi(&fl2), false)) {
 				if (ipv6_addr_equal(rt6_nexthop(rt1, &fl1.daddr),
 						    rt6_nexthop(rt2, &fl2.daddr)) &&
 				    rt1->dst.dev == rt2->dst.dev)
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index a6b7d05aeacf..87ee16be033b 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -12,6 +12,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter_ipv6.h>
 #include <net/dst.h>
 #include <net/ip6_route.h>
 #include <net/route.h>
@@ -27,7 +28,7 @@ static u16 get_tcpmss(const struct nft_pktinfo *pkt, const struct dst_entry *skb
 {
 	u32 minlen = sizeof(struct ipv6hdr), mtu = dst_mtu(skbdst);
 	const struct sk_buff *skb = pkt->skb;
-	const struct nf_afinfo *ai;
+	struct dst_entry *dst = NULL;
 	struct flowi fl;
 
 	memset(&fl, 0, sizeof(fl));
@@ -36,22 +37,18 @@ static u16 get_tcpmss(const struct nft_pktinfo *pkt, const struct dst_entry *skb
 	case NFPROTO_IPV4:
 		fl.u.ip4.daddr = ip_hdr(skb)->saddr;
 		minlen = sizeof(struct iphdr) + sizeof(struct tcphdr);
+		nf_ip_route(nft_net(pkt), &dst, &fl, false);
 		break;
 	case NFPROTO_IPV6:
 		fl.u.ip6.daddr = ipv6_hdr(skb)->saddr;
 		minlen = sizeof(struct ipv6hdr) + sizeof(struct tcphdr);
+		nf_ip6_route(nft_net(pkt), &dst, &fl, false);
 		break;
 	}
 
-	ai = nf_get_afinfo(nft_pf(pkt));
-	if (ai) {
-		struct dst_entry *dst = NULL;
-
-		ai->route(nft_net(pkt), &dst, &fl, false);
-		if (dst) {
-			mtu = min(mtu, dst_mtu(dst));
-			dst_release(dst);
-		}
+	if (dst) {
+		mtu = min(mtu, dst_mtu(dst));
+		dst_release(dst);
 	}
 
 	if (mtu <= minlen || mtu > 0xffff)
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 9dae4d665965..f06b9c2697e9 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -48,7 +48,6 @@ static u_int32_t tcpmss_reverse_mtu(struct net *net,
 				    unsigned int family)
 {
 	struct flowi fl;
-	const struct nf_afinfo *ai;
 	struct rtable *rt = NULL;
 	u_int32_t mtu     = ~0U;
 
@@ -56,15 +55,14 @@ static u_int32_t tcpmss_reverse_mtu(struct net *net,
 		struct flowi4 *fl4 = &fl.u.ip4;
 		memset(fl4, 0, sizeof(*fl4));
 		fl4->daddr = ip_hdr(skb)->saddr;
+		nf_ip_route(net, (struct dst_entry **)&rt, &fl, false);
 	} else {
 		struct flowi6 *fl6 = &fl.u.ip6;
 
 		memset(fl6, 0, sizeof(*fl6));
 		fl6->daddr = ipv6_hdr(skb)->saddr;
+		nf_ip6_route(net, (struct dst_entry **)&rt, &fl, false);
 	}
-	ai = nf_get_afinfo(family);
-	if (ai != NULL)
-		ai->route(net, (struct dst_entry **)&rt, &fl, false);
 
 	if (rt != NULL) {
 		mtu = dst_mtu(&rt->dst);
diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
index 3b2be2ae6987..4b8ecd0d9ae8 100644
--- a/net/netfilter/xt_addrtype.c
+++ b/net/netfilter/xt_addrtype.c
@@ -36,7 +36,7 @@ MODULE_ALIAS("ip6t_addrtype");
 static u32 match_lookup_rt6(struct net *net, const struct net_device *dev,
 			    const struct in6_addr *addr, u16 mask)
 {
-	const struct nf_afinfo *afinfo;
+	const struct nf_ipv6_ops *v6ops;
 	struct flowi6 flow;
 	struct rt6_info *rt;
 	u32 ret = 0;
@@ -47,21 +47,13 @@ static u32 match_lookup_rt6(struct net *net, const struct net_device *dev,
 	if (dev)
 		flow.flowi6_oif = dev->ifindex;
 
-	afinfo = nf_get_afinfo(NFPROTO_IPV6);
-	if (afinfo != NULL) {
-		const struct nf_ipv6_ops *v6ops;
-
-		if (dev && (mask & XT_ADDRTYPE_LOCAL)) {
-			v6ops = nf_get_ipv6_ops();
-			if (v6ops && v6ops->chk_addr(net, addr, dev, true))
-				ret = XT_ADDRTYPE_LOCAL;
-		}
-		route_err = afinfo->route(net, (struct dst_entry **)&rt,
-					  flowi6_to_flowi(&flow), false);
-	} else {
-		route_err = 1;
+	if (dev && (mask & XT_ADDRTYPE_LOCAL)) {
+		v6ops = nf_get_ipv6_ops();
+		if (v6ops && v6ops->chk_addr(net, addr, dev, true))
+			ret = XT_ADDRTYPE_LOCAL;
 	}
-
+	route_err = nf_ip6_route(net, (struct dst_entry **)&rt,
+				 flowi6_to_flowi(&flow), false);
 	if (route_err)
 		return XT_ADDRTYPE_UNREACHABLE;
 
-- 
2.11.0

