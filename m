From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/11] netfilter: ipv6: avoid indirect calls for IPV6=y case
Date: Mon, 18 Feb 2019 00:23:50 +0100
Message-ID: <20190217232357.29858-5-pablo@netfilter.org>
References: <20190217232357.29858-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217232357.29858-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

indirect calls are only needed if ipv6 is a module.
Add helpers to abstract the v6ops indirections and use them instead.

fragment, reroute and route_input are kept as indirect calls.
The first two are not not used in hot path and route_input is only
used by bridge netfilter.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6.h    | 64 +++++++++++++++++++++++++++++++--------
 net/ipv6/netfilter.c              | 15 ++++-----
 net/ipv6/netfilter/nft_fib_ipv6.c |  9 ++----
 net/netfilter/utils.c             |  6 ++--
 net/netfilter/xt_addrtype.c       | 16 +++-------
 5 files changed, 68 insertions(+), 42 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index ad4223c10488..471e9467105b 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -25,29 +25,24 @@ struct nf_queue_entry;
  * if IPv6 is a module.
  */
 struct nf_ipv6_ops {
+#if IS_MODULE(CONFIG_IPV6)
 	int (*chk_addr)(struct net *net, const struct in6_addr *addr,
 			const struct net_device *dev, int strict);
-	void (*route_input)(struct sk_buff *skb);
-	int (*fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
-			int (*output)(struct net *, struct sock *, struct sk_buff *));
-	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
-		     bool strict);
-	int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
-#if IS_MODULE(CONFIG_IPV6)
 	int (*route_me_harder)(struct net *net, struct sk_buff *skb);
 	int (*dev_get_saddr)(struct net *net, const struct net_device *dev,
 		       const struct in6_addr *daddr, unsigned int srcprefs,
 		       struct in6_addr *saddr);
+	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
+		     bool strict);
 #endif
+	void (*route_input)(struct sk_buff *skb);
+	int (*fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
+			int (*output)(struct net *, struct sock *, struct sk_buff *));
+	int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
 };
 
 #ifdef CONFIG_NETFILTER
-int ip6_route_me_harder(struct net *net, struct sk_buff *skb);
-__sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
-			unsigned int dataoff, u_int8_t protocol);
-
-int ipv6_netfilter_init(void);
-void ipv6_netfilter_fini(void);
+#include <net/addrconf.h>
 
 extern const struct nf_ipv6_ops __rcu *nf_ipv6_ops;
 static inline const struct nf_ipv6_ops *nf_get_ipv6_ops(void)
@@ -55,6 +50,49 @@ static inline const struct nf_ipv6_ops *nf_get_ipv6_ops(void)
 	return rcu_dereference(nf_ipv6_ops);
 }
 
+static inline int nf_ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
+				   const struct net_device *dev, int strict)
+{
+#if IS_MODULE(CONFIG_IPV6)
+	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
+
+	if (!v6_ops)
+		return 1;
+
+	return v6_ops->chk_addr(net, addr, dev, strict);
+#else
+	return ipv6_chk_addr(net, addr, dev, strict);
+#endif
+}
+
+int __nf_ip6_route(struct net *net, struct dst_entry **dst,
+			       struct flowi *fl, bool strict);
+
+static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
+			       struct flowi *fl, bool strict)
+{
+#if IS_MODULE(CONFIG_IPV6)
+	const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
+
+	if (v6ops)
+		return v6ops->route(net, dst, fl, strict);
+
+	return -EHOSTUNREACH;
+#endif
+#if IS_BUILTIN(CONFIG_IPV6)
+	return __nf_ip6_route(net, dst, fl, strict);
+#else
+	return -EHOSTUNREACH;
+#endif
+}
+
+int ip6_route_me_harder(struct net *net, struct sk_buff *skb);
+__sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
+			unsigned int dataoff, u_int8_t protocol);
+
+int ipv6_netfilter_init(void);
+void ipv6_netfilter_fini(void);
+
 #else /* CONFIG_NETFILTER */
 static inline int ipv6_netfilter_init(void) { return 0; }
 static inline void ipv6_netfilter_fini(void) { return; }
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 0a5caf263889..a8263031f3a6 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -84,8 +84,8 @@ static int nf_ip6_reroute(struct sk_buff *skb,
 	return 0;
 }
 
-static int nf_ip6_route(struct net *net, struct dst_entry **dst,
-			struct flowi *fl, bool strict)
+int __nf_ip6_route(struct net *net, struct dst_entry **dst,
+		   struct flowi *fl, bool strict)
 {
 	static const struct ipv6_pinfo fake_pinfo;
 	static const struct inet_sock fake_sk = {
@@ -105,17 +105,18 @@ static int nf_ip6_route(struct net *net, struct dst_entry **dst,
 		*dst = result;
 	return err;
 }
+EXPORT_SYMBOL_GPL(__nf_ip6_route);
 
 static const struct nf_ipv6_ops ipv6ops = {
-	.chk_addr		= ipv6_chk_addr,
-	.route_input    	= ip6_route_input,
-	.fragment		= ip6_fragment,
-	.route			= nf_ip6_route,
-	.reroute		= nf_ip6_reroute,
 #if IS_MODULE(CONFIG_IPV6)
+	.chk_addr		= ipv6_chk_addr,
 	.route_me_harder	= ip6_route_me_harder,
 	.dev_get_saddr		= ipv6_dev_get_saddr,
+	.route			= __nf_ip6_route,
 #endif
+	.route_input		= ip6_route_input,
+	.fragment		= ip6_fragment,
+	.reroute		= nf_ip6_reroute,
 };
 
 int __init ipv6_netfilter_init(void)
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 36be3cf0adef..73cdc0bc63f7 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -59,7 +59,6 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 				struct ipv6hdr *iph)
 {
 	const struct net_device *dev = NULL;
-	const struct nf_ipv6_ops *v6ops;
 	int route_err, addrtype;
 	struct rt6_info *rt;
 	struct flowi6 fl6 = {
@@ -68,10 +67,6 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 	};
 	u32 ret = 0;
 
-	v6ops = nf_get_ipv6_ops();
-	if (!v6ops)
-		return RTN_UNREACHABLE;
-
 	if (priv->flags & NFTA_FIB_F_IIF)
 		dev = nft_in(pkt);
 	else if (priv->flags & NFTA_FIB_F_OIF)
@@ -79,10 +74,10 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 
 	nft_fib6_flowi_init(&fl6, priv, pkt, dev, iph);
 
-	if (dev && v6ops->chk_addr(nft_net(pkt), &fl6.daddr, dev, true))
+	if (dev && nf_ipv6_chk_addr(nft_net(pkt), &fl6.daddr, dev, true))
 		ret = RTN_LOCAL;
 
-	route_err = v6ops->route(nft_net(pkt), (struct dst_entry **)&rt,
+	route_err = nf_ip6_route(nft_net(pkt), (struct dst_entry **)&rt,
 				 flowi6_to_flowi(&fl6), false);
 	if (route_err)
 		goto err;
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 55af9f247993..06dc55590441 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -162,7 +162,7 @@ EXPORT_SYMBOL_GPL(nf_checksum_partial);
 int nf_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 	     bool strict, unsigned short family)
 {
-	const struct nf_ipv6_ops *v6ops;
+	const struct nf_ipv6_ops *v6ops __maybe_unused;
 	int ret = 0;
 
 	switch (family) {
@@ -170,9 +170,7 @@ int nf_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		ret = nf_ip_route(net, dst, fl, strict);
 		break;
 	case AF_INET6:
-		v6ops = rcu_dereference(nf_ipv6_ops);
-		if (v6ops)
-			ret = v6ops->route(net, dst, fl, strict);
+		ret = nf_ip6_route(net, dst, fl, strict);
 		break;
 	}
 
diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
index 89e281b3bfc2..29987ff03621 100644
--- a/net/netfilter/xt_addrtype.c
+++ b/net/netfilter/xt_addrtype.c
@@ -36,7 +36,6 @@ MODULE_ALIAS("ip6t_addrtype");
 static u32 match_lookup_rt6(struct net *net, const struct net_device *dev,
 			    const struct in6_addr *addr, u16 mask)
 {
-	const struct nf_ipv6_ops *v6ops;
 	struct flowi6 flow;
 	struct rt6_info *rt;
 	u32 ret = 0;
@@ -47,18 +46,13 @@ static u32 match_lookup_rt6(struct net *net, const struct net_device *dev,
 	if (dev)
 		flow.flowi6_oif = dev->ifindex;
 
-	v6ops = nf_get_ipv6_ops();
-	if (v6ops) {
-		if (dev && (mask & XT_ADDRTYPE_LOCAL)) {
-			if (v6ops->chk_addr(net, addr, dev, true))
-				ret = XT_ADDRTYPE_LOCAL;
-		}
-		route_err = v6ops->route(net, (struct dst_entry **)&rt,
-					 flowi6_to_flowi(&flow), false);
-	} else {
-		route_err = 1;
+	if (dev && (mask & XT_ADDRTYPE_LOCAL)) {
+		if (nf_ipv6_chk_addr(net, addr, dev, true))
+			ret = XT_ADDRTYPE_LOCAL;
 	}
 
+	route_err = nf_ip6_route(net, (struct dst_entry **)&rt,
+				 flowi6_to_flowi(&flow), false);
 	if (route_err)
 		return XT_ADDRTYPE_UNREACHABLE;
 
-- 
2.11.0
