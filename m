From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/38] netfilter: conntrack: remove invert_tuple indirection from l3 protocol trackers
Date: Fri, 20 Jul 2018 15:08:38 +0200
Message-ID: <20180720130906.27687-11-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its simpler to just handle it directly in nf_ct_invert_tuple().
Also gets rid of need to pass l3proto pointer to resolve_conntrack().

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_core.h      |  1 -
 include/net/netfilter/nf_conntrack_l3proto.h   |  7 -------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 10 ----------
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |  3 +--
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 10 ----------
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |  3 +--
 net/netfilter/nf_conntrack_core.c              | 26 ++++++++++++++++----------
 net/netfilter/nf_conntrack_l3proto_generic.c   | 10 ----------
 8 files changed, 18 insertions(+), 52 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index d454a53ba646..35461b2d3462 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -42,7 +42,6 @@ void nf_conntrack_cleanup_end(void);
 
 bool nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 			const struct nf_conntrack_tuple *orig,
-			const struct nf_conntrack_l3proto *l3proto,
 			const struct nf_conntrack_l4proto *l4proto);
 
 /* Find a connection corresponding to a tuple. */
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index ece231450f30..164641c743a5 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -25,13 +25,6 @@ struct nf_conntrack_l3proto {
 	u16 nla_size;
 
 	/*
-	 * Invert the per-proto part of the tuple: ie. turn xmit into reply.
-	 * Some packets can't be inverted: return 0 in that case.
-	 */
-	bool (*invert_tuple)(struct nf_conntrack_tuple *inverse,
-			     const struct nf_conntrack_tuple *orig);
-
-	/*
 	 * Called before tracking. 
 	 *	*dataoff: offset of protocol header (TCP, UDP,...) in skb
 	 *	*protonum: protocol number
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 7ed56f61798b..e10e38c443ab 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -38,15 +38,6 @@ struct conntrack4_net {
 	unsigned int users;
 };
 
-static bool ipv4_invert_tuple(struct nf_conntrack_tuple *tuple,
-			      const struct nf_conntrack_tuple *orig)
-{
-	tuple->src.u3.ip = orig->dst.u3.ip;
-	tuple->dst.u3.ip = orig->src.u3.ip;
-
-	return true;
-}
-
 static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 			    unsigned int *dataoff, u_int8_t *protonum)
 {
@@ -306,7 +297,6 @@ static void ipv4_hooks_unregister(struct net *net)
 
 const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 = {
 	.l3proto	 = PF_INET,
-	.invert_tuple	 = ipv4_invert_tuple,
 	.get_l4proto	 = ipv4_get_l4proto,
 	.net_ns_get	 = ipv4_hooks_register,
 	.net_ns_put	 = ipv4_hooks_unregister,
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 5c15beafa711..34095949a003 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -142,8 +142,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 
 	/* Ordinarily, we'd expect the inverted tupleproto, but it's
 	   been preserved inside the ICMP. */
-	if (!nf_ct_invert_tuple(&innertuple, &origtuple,
-				&nf_conntrack_l3proto_ipv4, innerproto)) {
+	if (!nf_ct_invert_tuple(&innertuple, &origtuple, innerproto)) {
 		pr_debug("icmp_error_message: no match\n");
 		return -NF_ACCEPT;
 	}
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index bdb1709bb951..f8051fe20489 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -41,15 +41,6 @@ struct conntrack6_net {
 	unsigned int users;
 };
 
-static bool ipv6_invert_tuple(struct nf_conntrack_tuple *tuple,
-			      const struct nf_conntrack_tuple *orig)
-{
-	memcpy(tuple->src.u3.ip6, orig->dst.u3.ip6, sizeof(tuple->src.u3.ip6));
-	memcpy(tuple->dst.u3.ip6, orig->src.u3.ip6, sizeof(tuple->dst.u3.ip6));
-
-	return true;
-}
-
 static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 			    unsigned int *dataoff, u_int8_t *protonum)
 {
@@ -290,7 +281,6 @@ static void ipv6_hooks_unregister(struct net *net)
 
 const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 = {
 	.l3proto		= PF_INET6,
-	.invert_tuple		= ipv6_invert_tuple,
 	.get_l4proto		= ipv6_get_l4proto,
 	.net_ns_get		= ipv6_hooks_register,
 	.net_ns_put		= ipv6_hooks_unregister,
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 2548e2c8aedd..8bcbc2f15bd5 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -152,8 +152,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 
 	/* Ordinarily, we'd expect the inverted tupleproto, but it's
 	   been preserved inside the ICMP. */
-	if (!nf_ct_invert_tuple(&intuple, &origtuple,
-				&nf_conntrack_l3proto_ipv6, inproto)) {
+	if (!nf_ct_invert_tuple(&intuple, &origtuple, inproto)) {
 		pr_debug("icmpv6_error: Can't invert tuple\n");
 		return -NF_ACCEPT;
 	}
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 66b2ebae2747..14c040805b32 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -305,14 +305,24 @@ EXPORT_SYMBOL_GPL(nf_ct_get_tuplepr);
 bool
 nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 		   const struct nf_conntrack_tuple *orig,
-		   const struct nf_conntrack_l3proto *l3proto,
 		   const struct nf_conntrack_l4proto *l4proto)
 {
 	memset(inverse, 0, sizeof(*inverse));
 
 	inverse->src.l3num = orig->src.l3num;
-	if (l3proto->invert_tuple(inverse, orig) == 0)
-		return false;
+
+	switch (orig->src.l3num) {
+	case NFPROTO_IPV4:
+		inverse->src.u3.ip = orig->dst.u3.ip;
+		inverse->dst.u3.ip = orig->src.u3.ip;
+		break;
+	case NFPROTO_IPV6:
+		inverse->src.u3.in6 = orig->dst.u3.in6;
+		inverse->dst.u3.in6 = orig->src.u3.in6;
+		break;
+	default:
+		break;
+	}
 
 	inverse->dst.dir = !orig->dst.dir;
 
@@ -1222,7 +1232,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_free);
 static noinline struct nf_conntrack_tuple_hash *
 init_conntrack(struct net *net, struct nf_conn *tmpl,
 	       const struct nf_conntrack_tuple *tuple,
-	       const struct nf_conntrack_l3proto *l3proto,
 	       const struct nf_conntrack_l4proto *l4proto,
 	       struct sk_buff *skb,
 	       unsigned int dataoff, u32 hash)
@@ -1237,7 +1246,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	struct nf_conntrack_zone tmp;
 	unsigned int *timeouts;
 
-	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, l4proto)) {
+	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l4proto)) {
 		pr_debug("Can't invert tuple.\n");
 		return NULL;
 	}
@@ -1334,7 +1343,6 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 		  unsigned int dataoff,
 		  u_int16_t l3num,
 		  u_int8_t protonum,
-		  const struct nf_conntrack_l3proto *l3proto,
 		  const struct nf_conntrack_l4proto *l4proto)
 {
 	const struct nf_conntrack_zone *zone;
@@ -1356,7 +1364,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	hash = hash_conntrack_raw(&tuple, net);
 	h = __nf_conntrack_find_get(net, zone, &tuple, hash);
 	if (!h) {
-		h = init_conntrack(net, tmpl, &tuple, l3proto, l4proto,
+		h = init_conntrack(net, tmpl, &tuple, l4proto,
 				   skb, dataoff, hash);
 		if (!h)
 			return 0;
@@ -1439,8 +1447,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 			goto out;
 	}
 repeat:
-	ret = resolve_normal_ct(net, tmpl, skb, dataoff, pf, protonum,
-				l3proto, l4proto);
+	ret = resolve_normal_ct(net, tmpl, skb, dataoff, pf, protonum, l4proto);
 	if (ret < 0) {
 		/* Too stressed to deal. */
 		NF_CT_STAT_INC_ATOMIC(net, drop);
@@ -1497,7 +1504,6 @@ bool nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
 
 	rcu_read_lock();
 	ret = nf_ct_invert_tuple(inverse, orig,
-				 __nf_ct_l3proto_find(orig->src.l3num),
 				 __nf_ct_l4proto_find(orig->src.l3num,
 						      orig->dst.protonum));
 	rcu_read_unlock();
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index 0b01c9970e99..d6a8fe591ccc 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -31,15 +31,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 
-static bool generic_invert_tuple(struct nf_conntrack_tuple *tuple,
-				 const struct nf_conntrack_tuple *orig)
-{
-	memset(&tuple->src.u3, 0, sizeof(tuple->src.u3));
-	memset(&tuple->dst.u3, 0, sizeof(tuple->dst.u3));
-
-	return true;
-}
-
 static int generic_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 			       unsigned int *dataoff, u_int8_t *protonum)
 {
@@ -50,7 +41,6 @@ static int generic_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 
 struct nf_conntrack_l3proto nf_conntrack_l3proto_generic __read_mostly = {
 	.l3proto	 = PF_UNSPEC,
-	.invert_tuple	 = generic_invert_tuple,
 	.get_l4proto	 = generic_get_l4proto,
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_generic);
-- 
2.11.0
