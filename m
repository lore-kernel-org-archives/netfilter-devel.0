From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/37] netfilter: remove NF_NAT_RANGE_PROTO_RANDOM support
Date: Fri, 21 Dec 2018 01:28:19 +0100
Message-ID: <20181221002841.28587-16-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Historically this was net_random() based, and was then converted to
a hash based algorithm (private boot seed + hash of endpoint addresses)
due to concerns of leaking net_random() bits.

RANDOM_FULLY mode was added later to avoid problems with hash
based mode (see commit 34ce324019e76,
"netfilter: nf_nat: add full port randomization support" for details).

Just make prandom_u32() the default search starting point and get rid of
->secure_port() altogether.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l3proto.h   | 2 --
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c | 7 -------
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c | 7 -------
 net/netfilter/nf_nat_proto_common.c      | 9 ++-------
 4 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l3proto.h b/include/net/netfilter/nf_nat_l3proto.h
index d300b8f03972..f8b3fbe7a1bf 100644
--- a/include/net/netfilter/nf_nat_l3proto.h
+++ b/include/net/netfilter/nf_nat_l3proto.h
@@ -9,8 +9,6 @@ struct nf_nat_l3proto {
 	bool	(*in_range)(const struct nf_conntrack_tuple *t,
 			    const struct nf_nat_range2 *range);
 
-	u32 	(*secure_port)(const struct nf_conntrack_tuple *t, __be16);
-
 	bool	(*manip_pkt)(struct sk_buff *skb,
 			     unsigned int iphdroff,
 			     const struct nf_nat_l4proto *l4proto,
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index 78a67f961d86..4d755a6f73ad 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -69,12 +69,6 @@ static bool nf_nat_ipv4_in_range(const struct nf_conntrack_tuple *t,
 	       ntohl(t->src.u3.ip) <= ntohl(range->max_addr.ip);
 }
 
-static u32 nf_nat_ipv4_secure_port(const struct nf_conntrack_tuple *t,
-				   __be16 dport)
-{
-	return secure_ipv4_port_ephemeral(t->src.u3.ip, t->dst.u3.ip, dport);
-}
-
 static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
 				  unsigned int iphdroff,
 				  const struct nf_nat_l4proto *l4proto,
@@ -162,7 +156,6 @@ static int nf_nat_ipv4_nlattr_to_range(struct nlattr *tb[],
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv4 = {
 	.l3proto		= NFPROTO_IPV4,
 	.in_range		= nf_nat_ipv4_in_range,
-	.secure_port		= nf_nat_ipv4_secure_port,
 	.manip_pkt		= nf_nat_ipv4_manip_pkt,
 	.csum_update		= nf_nat_ipv4_csum_update,
 	.csum_recalc		= nf_nat_ipv4_csum_recalc,
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index ca6d38698b1a..290bb0142192 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -68,12 +68,6 @@ static bool nf_nat_ipv6_in_range(const struct nf_conntrack_tuple *t,
 	       ipv6_addr_cmp(&t->src.u3.in6, &range->max_addr.in6) <= 0;
 }
 
-static u32 nf_nat_ipv6_secure_port(const struct nf_conntrack_tuple *t,
-				   __be16 dport)
-{
-	return secure_ipv6_port_ephemeral(t->src.u3.ip6, t->dst.u3.ip6, dport);
-}
-
 static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
 				  unsigned int iphdroff,
 				  const struct nf_nat_l4proto *l4proto,
@@ -171,7 +165,6 @@ static int nf_nat_ipv6_nlattr_to_range(struct nlattr *tb[],
 
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
 	.l3proto		= NFPROTO_IPV6,
-	.secure_port		= nf_nat_ipv6_secure_port,
 	.in_range		= nf_nat_ipv6_in_range,
 	.manip_pkt		= nf_nat_ipv6_manip_pkt,
 	.csum_update		= nf_nat_ipv6_csum_update,
diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index dcb5d11688a1..dabfe9a2c041 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -77,15 +77,10 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		range_size = max - min + 1;
 	}
 
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
-		off = l3proto->secure_port(tuple, maniptype == NF_NAT_MANIP_SRC
-						  ? tuple->dst.u.all
-						  : tuple->src.u.all);
-	} else if (range->flags & NF_NAT_RANGE_PROTO_OFFSET) {
+	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
 		off = (ntohs(*portptr) - ntohs(range->base_proto.all));
-	} else {
+	else
 		off = prandom_u32();
-	}
 
 	attempts = range_size;
 	if (attempts > max_attempts)
-- 
2.11.0
