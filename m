From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/11] netfilter: nat: remove module dependency on ipv6 core
Date: Mon, 18 Feb 2019 00:23:49 +0100
Message-ID: <20190217232357.29858-4-pablo@netfilter.org>
References: <20190217232357.29858-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217232357.29858-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nf_nat_ipv6 calls two ipv6 core functions, so add those to v6ops to avoid
the module dependency.

This is a prerequisite for merging ipv4 and ipv6 nat implementations.

Add wrappers to avoid the indirection if ipv6 is builtin.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6.h              |  6 ++++++
 net/ipv6/netfilter.c                        |  4 ++++
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c    | 17 ++++++++++++++++-
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c | 21 +++++++++++++++++++--
 4 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index c0dc4dd78887..ad4223c10488 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -33,6 +33,12 @@ struct nf_ipv6_ops {
 	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		     bool strict);
 	int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
+#if IS_MODULE(CONFIG_IPV6)
+	int (*route_me_harder)(struct net *net, struct sk_buff *skb);
+	int (*dev_get_saddr)(struct net *net, const struct net_device *dev,
+		       const struct in6_addr *daddr, unsigned int srcprefs,
+		       struct in6_addr *saddr);
+#endif
 };
 
 #ifdef CONFIG_NETFILTER
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 8b075f0bc351..0a5caf263889 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -112,6 +112,10 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.fragment		= ip6_fragment,
 	.route			= nf_ip6_route,
 	.reroute		= nf_ip6_reroute,
+#if IS_MODULE(CONFIG_IPV6)
+	.route_me_harder	= ip6_route_me_harder,
+	.dev_get_saddr		= ipv6_dev_get_saddr,
+#endif
 };
 
 int __init ipv6_netfilter_init(void)
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index 9c914db44bec..b52026adb3e7 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -17,6 +17,7 @@
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
 #include <net/ip6_route.h>
+#include <net/xfrm.h>
 #include <net/ipv6.h>
 
 #include <net/netfilter/nf_conntrack_core.h>
@@ -317,6 +318,20 @@ nf_nat_ipv6_out(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
+static int nat_route_me_harder(struct net *net, struct sk_buff *skb)
+{
+#ifdef CONFIG_IPV6_MODULE
+	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
+
+	if (!v6_ops)
+		return -EHOSTUNREACH;
+
+	return v6_ops->route_me_harder(net, skb);
+#else
+	return ip6_route_me_harder(net, skb);
+#endif
+}
+
 static unsigned int
 nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 		     const struct nf_hook_state *state)
@@ -333,7 +348,7 @@ nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 
 		if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.dst.u3,
 				      &ct->tuplehash[!dir].tuple.src.u3)) {
-			err = ip6_route_me_harder(state->net, skb);
+			err = nat_route_me_harder(state->net, skb);
 			if (err < 0)
 				ret = NF_DROP_ERR(err);
 		}
diff --git a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
index 0ad0da5a2600..fd313b726263 100644
--- a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
@@ -24,6 +24,23 @@
 
 static atomic_t v6_worker_count;
 
+static int
+nat_ipv6_dev_get_saddr(struct net *net, const struct net_device *dev,
+		       const struct in6_addr *daddr, unsigned int srcprefs,
+		       struct in6_addr *saddr)
+{
+#ifdef CONFIG_IPV6_MODULE
+	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
+
+	if (!v6_ops)
+		return -EHOSTUNREACH;
+
+	return v6_ops->dev_get_saddr(net, dev, daddr, srcprefs, saddr);
+#else
+	return ipv6_dev_get_saddr(net, dev, daddr, srcprefs, saddr);
+#endif
+}
+
 unsigned int
 nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		       const struct net_device *out)
@@ -38,8 +55,8 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
 			 ctinfo == IP_CT_RELATED_REPLY)));
 
-	if (ipv6_dev_get_saddr(nf_ct_net(ct), out,
-			       &ipv6_hdr(skb)->daddr, 0, &src) < 0)
+	if (nat_ipv6_dev_get_saddr(nf_ct_net(ct), out,
+				   &ipv6_hdr(skb)->daddr, 0, &src) < 0)
 		return NF_DROP;
 
 	nat = nf_ct_nat_ext_add(ct);
-- 
2.11.0
