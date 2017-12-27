From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v4 5/7] netfilter: move reroute indirection to struct nf_ipv6_ops
Date: Wed, 27 Dec 2017 18:15:45 +0100
Message-ID: <20171227171547.4354-6-pablo@netfilter.org>
References: <20171227171547.4354-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48990 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752082AbdL0RP7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Dec 2017 12:15:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B9961B4978
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7C1F5C1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C220DA3A3
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:55 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 392164265A32
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 18:15:55 +0100 (CET)
In-Reply-To: <20171227171547.4354-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We cannot make a direct call to nf_ip6_reroute() because that would result
in autoloading the 'ipv6' module because of symbol dependencies.
Therefore, define reroute indirection in nf_ipv6_ops where this really
belongs to.

For IPv4, we can indeed make a direct function call, which is faster,
given IPv4 is built-in in the networking code by default. Still,
CONFIG_INET=n and CONFIG_NETFILTER=y is possible, so define empty inline
stub for IPv4 in such case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h               |  3 +--
 include/linux/netfilter_ipv4.h          |  6 ++++++
 include/linux/netfilter_ipv6.h          |  1 +
 net/bridge/netfilter/nf_tables_bridge.c |  7 -------
 net/ipv4/netfilter.c                    |  8 ++++----
 net/ipv6/netfilter.c                    |  6 +++---
 net/netfilter/nf_queue.c                |  4 +---
 net/netfilter/utils.c                   | 19 +++++++++++++++++++
 8 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 02c35eabd348..8358e717eabd 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -311,8 +311,6 @@ struct nf_queue_entry;
 
 struct nf_afinfo {
 	unsigned short	family;
-	int		(*reroute)(struct net *net, struct sk_buff *skb,
-				   const struct nf_queue_entry *entry);
 	int		route_key_size;
 };
 
@@ -331,6 +329,7 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			    u_int8_t protocol, unsigned short family);
 int nf_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 	     bool strict, unsigned short family);
+int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry);
 
 int nf_register_afinfo(const struct nf_afinfo *afinfo);
 void nf_unregister_afinfo(const struct nf_afinfo *afinfo);
diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 2a4e2c415647..0259bcde6d2e 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -26,6 +26,7 @@ __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			       u_int8_t protocol);
 int nf_ip_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		bool strict);
+int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
 #else
 static inline __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 				     unsigned int dataoff, u_int8_t protocol)
@@ -45,6 +46,11 @@ static inline int nf_ip_route(struct net *net, struct dst_entry **dst,
 {
 	return -EOPNOTSUPP;
 }
+static inline int nf_ip_reroute(struct sk_buff *skb,
+				const struct nf_queue_entry *entry)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_INET */
 
 #endif /*__LINUX_IP_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index e5700bb314a1..e4cdcfdce0f9 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -35,6 +35,7 @@ struct nf_ipv6_ops {
 				    u_int8_t protocol);
 	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		     bool strict);
+	int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
 };
 
 #ifdef CONFIG_NETFILTER
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 014b6571f2ac..e7348b49bc0d 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -95,15 +95,8 @@ static const struct nf_chain_type filter_bridge = {
 	},
 };
 
-static int nf_br_reroute(struct net *net, struct sk_buff *skb,
-			 const struct nf_queue_entry *entry)
-{
-	return 0;
-}
-
 static const struct nf_afinfo nf_br_afinfo = {
 	.family                 = AF_BRIDGE,
-	.reroute                = nf_br_reroute,
 	.route_key_size         = 0,
 };
 
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index e9d47e4ec182..ec73be3b2f14 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -80,8 +80,7 @@ int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned int addr_t
 }
 EXPORT_SYMBOL(ip_route_me_harder);
 
-static int nf_ip_reroute(struct net *net, struct sk_buff *skb,
-			 const struct nf_queue_entry *entry)
+int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry)
 {
 	const struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
 
@@ -92,10 +91,12 @@ static int nf_ip_reroute(struct net *net, struct sk_buff *skb,
 		      skb->mark == rt_info->mark &&
 		      iph->daddr == rt_info->daddr &&
 		      iph->saddr == rt_info->saddr))
-			return ip_route_me_harder(net, skb, RTN_UNSPEC);
+			return ip_route_me_harder(entry->state.net, skb,
+						  RTN_UNSPEC);
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nf_ip_reroute);
 
 __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 			    unsigned int dataoff, u_int8_t protocol)
@@ -163,7 +164,6 @@ EXPORT_SYMBOL_GPL(nf_ip_route);
 
 static const struct nf_afinfo nf_ip_afinfo = {
 	.family			= AF_INET,
-	.reroute		= nf_ip_reroute,
 	.route_key_size		= sizeof(struct ip_rt_info),
 };
 
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index f03bb043e4e4..d633b78be06f 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -68,7 +68,7 @@ int ip6_route_me_harder(struct net *net, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ip6_route_me_harder);
 
-static int nf_ip6_reroute(struct net *net, struct sk_buff *skb,
+static int nf_ip6_reroute(struct sk_buff *skb,
 			  const struct nf_queue_entry *entry)
 {
 	struct ip6_rt_info *rt_info = nf_queue_entry_reroute(entry);
@@ -78,7 +78,7 @@ static int nf_ip6_reroute(struct net *net, struct sk_buff *skb,
 		if (!ipv6_addr_equal(&iph->daddr, &rt_info->daddr) ||
 		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr) ||
 		    skb->mark != rt_info->mark)
-			return ip6_route_me_harder(net, skb);
+			return ip6_route_me_harder(entry->state.net, skb);
 	}
 	return 0;
 }
@@ -171,11 +171,11 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.checksum		= nf_ip6_checksum,
 	.checksum_partial	= nf_ip6_checksum_partial,
 	.route			= nf_ip6_route,
+	.reroute		= nf_ip6_reroute,
 };
 
 static const struct nf_afinfo nf_ip6_afinfo = {
 	.family			= AF_INET6,
-	.reroute		= nf_ip6_reroute,
 	.route_key_size		= sizeof(struct ip6_rt_info),
 };
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index dfa35bd292c8..15382ff83e7a 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -266,7 +266,6 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	const struct nf_hook_entry *hook_entry;
 	const struct nf_hook_entries *hooks;
 	struct sk_buff *skb = entry->skb;
-	const struct nf_afinfo *afinfo;
 	const struct net *net;
 	unsigned int i;
 	int err;
@@ -293,8 +292,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		verdict = nf_hook_entry_hookfn(hook_entry, skb, &entry->state);
 
 	if (verdict == NF_ACCEPT) {
-		afinfo = nf_get_afinfo(entry->state.pf);
-		if (!afinfo || afinfo->reroute(entry->state.net, skb, entry) < 0)
+		if (nf_reroute(skb, entry) < 0)
 			verdict = NF_DROP;
 	}
 
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 45c22418c955..0b660c568156 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -2,6 +2,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
+#include <net/netfilter/nf_queue.h>
 
 __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		    unsigned int dataoff, u_int8_t protocol,
@@ -69,3 +70,21 @@ int nf_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_route);
+
+int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
+{
+	const struct nf_ipv6_ops *v6ops;
+	int ret = 0;
+
+	switch (entry->state.pf) {
+	case AF_INET:
+		ret = nf_ip_reroute(skb, entry);
+		break;
+	case AF_INET6:
+		v6ops = rcu_dereference(nf_ipv6_ops);
+		if (v6ops)
+			ret = v6ops->reroute(skb, entry);
+		break;
+	}
+	return ret;
+}
-- 
2.11.0

