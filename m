From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/37] netfilter: nat: fold in_range indirection into caller
Date: Fri, 21 Dec 2018 01:28:22 +0100
Message-ID: <20181221002841.28587-19-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No need for indirections here, we only support ipv4 and ipv6
and the called functions are very small.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l3proto.h   |  3 ---
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c |  8 --------
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c |  8 --------
 net/netfilter/nf_nat_core.c              | 23 ++++++++++++++++-------
 4 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l3proto.h b/include/net/netfilter/nf_nat_l3proto.h
index f8b3fbe7a1bf..1ce0980da638 100644
--- a/include/net/netfilter/nf_nat_l3proto.h
+++ b/include/net/netfilter/nf_nat_l3proto.h
@@ -6,9 +6,6 @@ struct nf_nat_l4proto;
 struct nf_nat_l3proto {
 	u8	l3proto;
 
-	bool	(*in_range)(const struct nf_conntrack_tuple *t,
-			    const struct nf_nat_range2 *range);
-
 	bool	(*manip_pkt)(struct sk_buff *skb,
 			     unsigned int iphdroff,
 			     const struct nf_nat_l4proto *l4proto,
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index 4d755a6f73ad..00904e605e85 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -62,13 +62,6 @@ static void nf_nat_ipv4_decode_session(struct sk_buff *skb,
 }
 #endif /* CONFIG_XFRM */
 
-static bool nf_nat_ipv4_in_range(const struct nf_conntrack_tuple *t,
-				 const struct nf_nat_range2 *range)
-{
-	return ntohl(t->src.u3.ip) >= ntohl(range->min_addr.ip) &&
-	       ntohl(t->src.u3.ip) <= ntohl(range->max_addr.ip);
-}
-
 static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
 				  unsigned int iphdroff,
 				  const struct nf_nat_l4proto *l4proto,
@@ -155,7 +148,6 @@ static int nf_nat_ipv4_nlattr_to_range(struct nlattr *tb[],
 
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv4 = {
 	.l3proto		= NFPROTO_IPV4,
-	.in_range		= nf_nat_ipv4_in_range,
 	.manip_pkt		= nf_nat_ipv4_manip_pkt,
 	.csum_update		= nf_nat_ipv4_csum_update,
 	.csum_recalc		= nf_nat_ipv4_csum_recalc,
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index 290bb0142192..016ab74ac1c6 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -61,13 +61,6 @@ static void nf_nat_ipv6_decode_session(struct sk_buff *skb,
 }
 #endif
 
-static bool nf_nat_ipv6_in_range(const struct nf_conntrack_tuple *t,
-				 const struct nf_nat_range2 *range)
-{
-	return ipv6_addr_cmp(&t->src.u3.in6, &range->min_addr.in6) >= 0 &&
-	       ipv6_addr_cmp(&t->src.u3.in6, &range->max_addr.in6) <= 0;
-}
-
 static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
 				  unsigned int iphdroff,
 				  const struct nf_nat_l4proto *l4proto,
@@ -165,7 +158,6 @@ static int nf_nat_ipv6_nlattr_to_range(struct nlattr *tb[],
 
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
 	.l3proto		= NFPROTO_IPV6,
-	.in_range		= nf_nat_ipv6_in_range,
 	.manip_pkt		= nf_nat_ipv6_manip_pkt,
 	.csum_update		= nf_nat_ipv6_csum_update,
 	.csum_recalc		= nf_nat_ipv6_csum_recalc,
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 763a92e82755..e1d9903a1e40 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -172,11 +172,21 @@ nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 }
 EXPORT_SYMBOL(nf_nat_used_tuple);
 
+static bool nf_nat_inet_in_range(const struct nf_conntrack_tuple *t,
+				 const struct nf_nat_range2 *range)
+{
+	if (t->src.l3num == NFPROTO_IPV4)
+		return ntohl(t->src.u3.ip) >= ntohl(range->min_addr.ip) &&
+		       ntohl(t->src.u3.ip) <= ntohl(range->max_addr.ip);
+
+	return ipv6_addr_cmp(&t->src.u3.in6, &range->min_addr.in6) >= 0 &&
+	       ipv6_addr_cmp(&t->src.u3.in6, &range->max_addr.in6) <= 0;
+}
+
 /* If we source map this tuple so reply looks like reply_tuple, will
  * that meet the constraints of range.
  */
-static int in_range(const struct nf_nat_l3proto *l3proto,
-		    const struct nf_nat_l4proto *l4proto,
+static int in_range(const struct nf_nat_l4proto *l4proto,
 		    const struct nf_conntrack_tuple *tuple,
 		    const struct nf_nat_range2 *range)
 {
@@ -184,7 +194,7 @@ static int in_range(const struct nf_nat_l3proto *l3proto,
 	 * range specified, otherwise let this drag us onto a new src IP.
 	 */
 	if (range->flags & NF_NAT_RANGE_MAP_IPS &&
-	    !l3proto->in_range(tuple, range))
+	    !nf_nat_inet_in_range(tuple, range))
 		return 0;
 
 	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) ||
@@ -211,7 +221,6 @@ same_src(const struct nf_conn *ct,
 static int
 find_appropriate_src(struct net *net,
 		     const struct nf_conntrack_zone *zone,
-		     const struct nf_nat_l3proto *l3proto,
 		     const struct nf_nat_l4proto *l4proto,
 		     const struct nf_conntrack_tuple *tuple,
 		     struct nf_conntrack_tuple *result,
@@ -229,7 +238,7 @@ find_appropriate_src(struct net *net,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 			result->dst = tuple->dst;
 
-			if (in_range(l3proto, l4proto, result, range))
+			if (in_range(l4proto, result, range))
 				return 1;
 		}
 	}
@@ -463,12 +472,12 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	if (maniptype == NF_NAT_MANIP_SRC &&
 	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		/* try the original tuple first */
-		if (in_range(l3proto, l4proto, orig_tuple, range)) {
+		if (in_range(l4proto, orig_tuple, range)) {
 			if (!nf_nat_used_tuple(orig_tuple, ct)) {
 				*tuple = *orig_tuple;
 				goto out;
 			}
-		} else if (find_appropriate_src(net, zone, l3proto, l4proto,
+		} else if (find_appropriate_src(net, zone, l4proto,
 						orig_tuple, tuple, range)) {
 			pr_debug("get_unique_tuple: Found current src map\n");
 			if (!nf_nat_used_tuple(tuple, ct))
-- 
2.11.0
