From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/38] netfilter: conntrack: remove pkt_to_tuple indirection from l3 protocol trackers
Date: Fri, 20 Jul 2018 15:08:37 +0200
Message-ID: <20180720130906.27687-10-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l3proto.h   |  7 -----
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 17 -----------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 18 ------------
 net/netfilter/nf_conntrack_core.c              | 39 ++++++++++++++++++++++----
 net/netfilter/nf_conntrack_l3proto_generic.c   | 10 -------
 5 files changed, 33 insertions(+), 58 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index d07b5216a925..ece231450f30 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -25,13 +25,6 @@ struct nf_conntrack_l3proto {
 	u16 nla_size;
 
 	/*
-	 * Try to fill in the third arg: nhoff is offset of l3 proto
-         * hdr.  Return true if possible.
-	 */
-	bool (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int nhoff,
-			     struct nf_conntrack_tuple *tuple);
-
-	/*
 	 * Invert the per-proto part of the tuple: ie. turn xmit into reply.
 	 * Some packets can't be inverted: return 0 in that case.
 	 */
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 98ed12858c52..7ed56f61798b 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -38,22 +38,6 @@ struct conntrack4_net {
 	unsigned int users;
 };
 
-static bool ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
-			      struct nf_conntrack_tuple *tuple)
-{
-	const __be32 *ap;
-	__be32 _addrs[2];
-	ap = skb_header_pointer(skb, nhoff + offsetof(struct iphdr, saddr),
-				sizeof(u_int32_t) * 2, _addrs);
-	if (ap == NULL)
-		return false;
-
-	tuple->src.u3.ip = ap[0];
-	tuple->dst.u3.ip = ap[1];
-
-	return true;
-}
-
 static bool ipv4_invert_tuple(struct nf_conntrack_tuple *tuple,
 			      const struct nf_conntrack_tuple *orig)
 {
@@ -322,7 +306,6 @@ static void ipv4_hooks_unregister(struct net *net)
 
 const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 = {
 	.l3proto	 = PF_INET,
-	.pkt_to_tuple	 = ipv4_pkt_to_tuple,
 	.invert_tuple	 = ipv4_invert_tuple,
 	.get_l4proto	 = ipv4_get_l4proto,
 	.net_ns_get	 = ipv4_hooks_register,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 13a660ae5799..bdb1709bb951 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -41,23 +41,6 @@ struct conntrack6_net {
 	unsigned int users;
 };
 
-static bool ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
-			      struct nf_conntrack_tuple *tuple)
-{
-	const u_int32_t *ap;
-	u_int32_t _addrs[8];
-
-	ap = skb_header_pointer(skb, nhoff + offsetof(struct ipv6hdr, saddr),
-				sizeof(_addrs), _addrs);
-	if (ap == NULL)
-		return false;
-
-	memcpy(tuple->src.u3.ip6, ap, sizeof(tuple->src.u3.ip6));
-	memcpy(tuple->dst.u3.ip6, ap + 4, sizeof(tuple->dst.u3.ip6));
-
-	return true;
-}
-
 static bool ipv6_invert_tuple(struct nf_conntrack_tuple *tuple,
 			      const struct nf_conntrack_tuple *orig)
 {
@@ -307,7 +290,6 @@ static void ipv6_hooks_unregister(struct net *net)
 
 const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 = {
 	.l3proto		= PF_INET6,
-	.pkt_to_tuple		= ipv6_pkt_to_tuple,
 	.invert_tuple		= ipv6_invert_tuple,
 	.get_l4proto		= ipv6_get_l4proto,
 	.net_ns_get		= ipv6_hooks_register,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index be0ab81e6b2c..66b2ebae2747 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -230,15 +230,43 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 		u_int8_t protonum,
 		struct net *net,
 		struct nf_conntrack_tuple *tuple,
-		const struct nf_conntrack_l3proto *l3proto,
 		const struct nf_conntrack_l4proto *l4proto)
 {
+	unsigned int size;
+	const __be32 *ap;
+	__be32 _addrs[8];
+
 	memset(tuple, 0, sizeof(*tuple));
 
 	tuple->src.l3num = l3num;
-	if (l3proto->pkt_to_tuple(skb, nhoff, tuple) == 0)
+	switch (l3num) {
+	case NFPROTO_IPV4:
+		nhoff += offsetof(struct iphdr, saddr);
+		size = 2 * sizeof(__be32);
+		break;
+	case NFPROTO_IPV6:
+		nhoff += offsetof(struct ipv6hdr, saddr);
+		size = sizeof(_addrs);
+		break;
+	default:
+		return true;
+	}
+
+	ap = skb_header_pointer(skb, nhoff, size, _addrs);
+	if (!ap)
 		return false;
 
+	switch (l3num) {
+	case NFPROTO_IPV4:
+		tuple->src.u3.ip = ap[0];
+		tuple->dst.u3.ip = ap[1];
+		break;
+	case NFPROTO_IPV6:
+		memcpy(tuple->src.u3.ip6, ap, sizeof(tuple->src.u3.ip6));
+		memcpy(tuple->dst.u3.ip6, ap + 4, sizeof(tuple->dst.u3.ip6));
+		break;
+	}
+
 	tuple->dst.protonum = protonum;
 	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
 
@@ -267,7 +295,7 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 	l4proto = __nf_ct_l4proto_find(l3num, protonum);
 
 	ret = nf_ct_get_tuple(skb, nhoff, protoff, l3num, protonum, net, tuple,
-			      l3proto, l4proto);
+			      l4proto);
 
 	rcu_read_unlock();
 	return ret;
@@ -1318,8 +1346,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	u32 hash;
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
-			     dataoff, l3num, protonum, net, &tuple, l3proto,
-			     l4proto)) {
+			     dataoff, l3num, protonum, net, &tuple, l4proto)) {
 		pr_debug("Can't get tuple\n");
 		return 0;
 	}
@@ -1633,7 +1660,7 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 	l4proto = nf_ct_l4proto_find_get(l3num, l4num);
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb), dataoff, l3num,
-			     l4num, net, &tuple, l3proto, l4proto))
+			     l4num, net, &tuple, l4proto))
 		return -1;
 
 	if (ct->status & IPS_SRC_NAT) {
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index 397e6911214f..0b01c9970e99 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -31,15 +31,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 
-static bool generic_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
-				 struct nf_conntrack_tuple *tuple)
-{
-	memset(&tuple->src.u3, 0, sizeof(tuple->src.u3));
-	memset(&tuple->dst.u3, 0, sizeof(tuple->dst.u3));
-
-	return true;
-}
-
 static bool generic_invert_tuple(struct nf_conntrack_tuple *tuple,
 				 const struct nf_conntrack_tuple *orig)
 {
@@ -59,7 +50,6 @@ static int generic_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 
 struct nf_conntrack_l3proto nf_conntrack_l3proto_generic __read_mostly = {
 	.l3proto	 = PF_UNSPEC,
-	.pkt_to_tuple	 = generic_pkt_to_tuple,
 	.invert_tuple	 = generic_invert_tuple,
 	.get_l4proto	 = generic_get_l4proto,
 };
-- 
2.11.0
