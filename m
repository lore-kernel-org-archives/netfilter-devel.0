From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 19/37] netfilter: nat: remove l4proto->in_range
Date: Fri, 21 Dec 2018 01:28:23 +0100
Message-ID: <20181221002841.28587-20-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

With exception of icmp, all of the l4 nat protocols set this to
nf_nat_l4proto_in_range.

Get rid of this and just check the l4proto in the caller.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l4proto.h   | 11 ------
 net/ipv4/netfilter/nf_nat_proto_gre.c    |  1 -
 net/ipv4/netfilter/nf_nat_proto_icmp.c   | 11 ------
 net/ipv6/netfilter/nf_nat_proto_icmpv6.c | 11 ------
 net/netfilter/nf_nat_core.c              | 67 ++++++++++++++++++++------------
 net/netfilter/nf_nat_proto_common.c      | 17 --------
 net/netfilter/nf_nat_proto_dccp.c        |  1 -
 net/netfilter/nf_nat_proto_sctp.c        |  1 -
 net/netfilter/nf_nat_proto_tcp.c         |  1 -
 net/netfilter/nf_nat_proto_udp.c         |  2 -
 net/netfilter/nf_nat_proto_unknown.c     |  9 -----
 11 files changed, 43 insertions(+), 89 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index 4a0e4f0623a0..ebf7cbf605cb 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -21,12 +21,6 @@ struct nf_nat_l4proto {
 			  const struct nf_conntrack_tuple *tuple,
 			  enum nf_nat_manip_type maniptype);
 
-	/* Is the manipable part of the tuple between min and max incl? */
-	bool (*in_range)(const struct nf_conntrack_tuple *tuple,
-			 enum nf_nat_manip_type maniptype,
-			 const union nf_conntrack_man_proto *min,
-			 const union nf_conntrack_man_proto *max);
-
 	int (*nlattr_to_range)(struct nlattr *tb[],
 			       struct nf_nat_range2 *range);
 };
@@ -54,11 +48,6 @@ extern const struct nf_nat_l4proto nf_nat_l4proto_sctp;
 extern const struct nf_nat_l4proto nf_nat_l4proto_udplite;
 #endif
 
-bool nf_nat_l4proto_in_range(const struct nf_conntrack_tuple *tuple,
-			     enum nf_nat_manip_type maniptype,
-			     const union nf_conntrack_man_proto *min,
-			     const union nf_conntrack_man_proto *max);
-
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
 				   struct nf_nat_range2 *range);
 
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index a04ff7665e4c..94b735dd570d 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -80,7 +80,6 @@ gre_manip_pkt(struct sk_buff *skb,
 static const struct nf_nat_l4proto gre = {
 	.l4proto		= IPPROTO_GRE,
 	.manip_pkt		= gre_manip_pkt,
-	.in_range		= nf_nat_l4proto_in_range,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index 70d7fabdbb01..f532e2215970 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -18,16 +18,6 @@
 #include <net/netfilter/nf_nat_l4proto.h>
 
 static bool
-icmp_in_range(const struct nf_conntrack_tuple *tuple,
-	      enum nf_nat_manip_type maniptype,
-	      const union nf_conntrack_man_proto *min,
-	      const union nf_conntrack_man_proto *max)
-{
-	return ntohs(tuple->src.u.icmp.id) >= ntohs(min->icmp.id) &&
-	       ntohs(tuple->src.u.icmp.id) <= ntohs(max->icmp.id);
-}
-
-static bool
 icmp_manip_pkt(struct sk_buff *skb,
 	       const struct nf_nat_l3proto *l3proto,
 	       unsigned int iphdroff, unsigned int hdroff,
@@ -49,7 +39,6 @@ icmp_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_icmp = {
 	.l4proto		= IPPROTO_ICMP,
 	.manip_pkt		= icmp_manip_pkt,
-	.in_range		= icmp_in_range,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
index 491361b7a721..ffae55c1fb8d 100644
--- a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
@@ -20,16 +20,6 @@
 #include <net/netfilter/nf_nat_l4proto.h>
 
 static bool
-icmpv6_in_range(const struct nf_conntrack_tuple *tuple,
-		enum nf_nat_manip_type maniptype,
-		const union nf_conntrack_man_proto *min,
-		const union nf_conntrack_man_proto *max)
-{
-	return ntohs(tuple->src.u.icmp.id) >= ntohs(min->icmp.id) &&
-	       ntohs(tuple->src.u.icmp.id) <= ntohs(max->icmp.id);
-}
-
-static bool
 icmpv6_manip_pkt(struct sk_buff *skb,
 		 const struct nf_nat_l3proto *l3proto,
 		 unsigned int iphdroff, unsigned int hdroff,
@@ -57,7 +47,6 @@ icmpv6_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_icmpv6 = {
 	.l4proto		= IPPROTO_ICMPV6,
 	.manip_pkt		= icmpv6_manip_pkt,
-	.in_range		= icmpv6_in_range,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index e1d9903a1e40..d0351e0f21ad 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -183,11 +183,41 @@ static bool nf_nat_inet_in_range(const struct nf_conntrack_tuple *t,
 	       ipv6_addr_cmp(&t->src.u3.in6, &range->max_addr.in6) <= 0;
 }
 
+/* Is the manipable part of the tuple between min and max incl? */
+static bool l4proto_in_range(const struct nf_conntrack_tuple *tuple,
+			     enum nf_nat_manip_type maniptype,
+			     const union nf_conntrack_man_proto *min,
+			     const union nf_conntrack_man_proto *max)
+{
+	__be16 port;
+
+	switch (tuple->dst.protonum) {
+	case IPPROTO_ICMP: /* fallthrough */
+	case IPPROTO_ICMPV6:
+		return ntohs(tuple->src.u.icmp.id) >= ntohs(min->icmp.id) &&
+		       ntohs(tuple->src.u.icmp.id) <= ntohs(max->icmp.id);
+	case IPPROTO_GRE: /* all fall though */
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+	case IPPROTO_DCCP:
+	case IPPROTO_SCTP:
+		if (maniptype == NF_NAT_MANIP_SRC)
+			port = tuple->src.u.all;
+		else
+			port = tuple->dst.u.all;
+
+		return ntohs(port) >= ntohs(min->all) &&
+		       ntohs(port) <= ntohs(max->all);
+	default:
+		return true;
+	}
+}
+
 /* If we source map this tuple so reply looks like reply_tuple, will
  * that meet the constraints of range.
  */
-static int in_range(const struct nf_nat_l4proto *l4proto,
-		    const struct nf_conntrack_tuple *tuple,
+static int in_range(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_nat_range2 *range)
 {
 	/* If we are supposed to map IPs, then we must be in the
@@ -197,12 +227,11 @@ static int in_range(const struct nf_nat_l4proto *l4proto,
 	    !nf_nat_inet_in_range(tuple, range))
 		return 0;
 
-	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) ||
-	    l4proto->in_range(tuple, NF_NAT_MANIP_SRC,
-			      &range->min_proto, &range->max_proto))
+	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED))
 		return 1;
 
-	return 0;
+	return l4proto_in_range(tuple, NF_NAT_MANIP_SRC,
+				&range->min_proto, &range->max_proto);
 }
 
 static inline int
@@ -221,7 +250,6 @@ same_src(const struct nf_conn *ct,
 static int
 find_appropriate_src(struct net *net,
 		     const struct nf_conntrack_zone *zone,
-		     const struct nf_nat_l4proto *l4proto,
 		     const struct nf_conntrack_tuple *tuple,
 		     struct nf_conntrack_tuple *result,
 		     const struct nf_nat_range2 *range)
@@ -238,7 +266,7 @@ find_appropriate_src(struct net *net,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 			result->dst = tuple->dst;
 
-			if (in_range(l4proto, result, range))
+			if (in_range(result, range))
 				return 1;
 		}
 	}
@@ -450,17 +478,10 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 enum nf_nat_manip_type maniptype)
 {
 	const struct nf_conntrack_zone *zone;
-	const struct nf_nat_l3proto *l3proto;
-	const struct nf_nat_l4proto *l4proto;
 	struct net *net = nf_ct_net(ct);
 
 	zone = nf_ct_zone(ct);
 
-	rcu_read_lock();
-	l3proto = __nf_nat_l3proto_find(orig_tuple->src.l3num);
-	l4proto = __nf_nat_l4proto_find(orig_tuple->src.l3num,
-					orig_tuple->dst.protonum);
-
 	/* 1) If this srcip/proto/src-proto-part is currently mapped,
 	 * and that same mapping gives a unique tuple within the given
 	 * range, use that.
@@ -472,16 +493,16 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	if (maniptype == NF_NAT_MANIP_SRC &&
 	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		/* try the original tuple first */
-		if (in_range(l4proto, orig_tuple, range)) {
+		if (in_range(orig_tuple, range)) {
 			if (!nf_nat_used_tuple(orig_tuple, ct)) {
 				*tuple = *orig_tuple;
-				goto out;
+				return;
 			}
-		} else if (find_appropriate_src(net, zone, l4proto,
+		} else if (find_appropriate_src(net, zone,
 						orig_tuple, tuple, range)) {
 			pr_debug("get_unique_tuple: Found current src map\n");
 			if (!nf_nat_used_tuple(tuple, ct))
-				goto out;
+				return;
 		}
 	}
 
@@ -497,21 +518,19 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 			if (!(range->flags & NF_NAT_RANGE_PROTO_OFFSET) &&
-			    l4proto->in_range(tuple, maniptype,
+			    l4proto_in_range(tuple, maniptype,
 			          &range->min_proto,
 			          &range->max_proto) &&
 			    (range->min_proto.all == range->max_proto.all ||
 			     !nf_nat_used_tuple(tuple, ct)))
-				goto out;
+				return;
 		} else if (!nf_nat_used_tuple(tuple, ct)) {
-			goto out;
+			return;
 		}
 	}
 
 	/* Last chance: get protocol to try to obtain unique tuple. */
 	nf_nat_l4proto_unique_tuple(tuple, range, maniptype, ct);
-out:
-	rcu_read_unlock();
 }
 
 struct nf_conn_nat *nf_ct_nat_ext_add(struct nf_conn *ct)
diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index ef14d86f0f5b..a155cfa1cc13 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -17,23 +17,6 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-bool nf_nat_l4proto_in_range(const struct nf_conntrack_tuple *tuple,
-			     enum nf_nat_manip_type maniptype,
-			     const union nf_conntrack_man_proto *min,
-			     const union nf_conntrack_man_proto *max)
-{
-	__be16 port;
-
-	if (maniptype == NF_NAT_MANIP_SRC)
-		port = tuple->src.u.all;
-	else
-		port = tuple->dst.u.all;
-
-	return ntohs(port) >= ntohs(min->all) &&
-	       ntohs(port) <= ntohs(max->all);
-}
-EXPORT_SYMBOL_GPL(nf_nat_l4proto_in_range);
-
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
 				   struct nf_nat_range2 *range)
diff --git a/net/netfilter/nf_nat_proto_dccp.c b/net/netfilter/nf_nat_proto_dccp.c
index 8dbba7b20177..a5ed1e3e4f22 100644
--- a/net/netfilter/nf_nat_proto_dccp.c
+++ b/net/netfilter/nf_nat_proto_dccp.c
@@ -61,7 +61,6 @@ dccp_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_dccp = {
 	.l4proto		= IPPROTO_DCCP,
 	.manip_pkt		= dccp_manip_pkt,
-	.in_range		= nf_nat_l4proto_in_range,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index da86475d0db6..ff5f5bbd2ff1 100644
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -56,7 +56,6 @@ sctp_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_sctp = {
 	.l4proto		= IPPROTO_SCTP,
 	.manip_pkt		= sctp_manip_pkt,
-	.in_range		= nf_nat_l4proto_in_range,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/netfilter/nf_nat_proto_tcp.c b/net/netfilter/nf_nat_proto_tcp.c
index 666a4b3303f7..c938ecf7e0b0 100644
--- a/net/netfilter/nf_nat_proto_tcp.c
+++ b/net/netfilter/nf_nat_proto_tcp.c
@@ -64,7 +64,6 @@ tcp_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_tcp = {
 	.l4proto		= IPPROTO_TCP,
 	.manip_pkt		= tcp_manip_pkt,
-	.in_range		= nf_nat_l4proto_in_range,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/netfilter/nf_nat_proto_udp.c b/net/netfilter/nf_nat_proto_udp.c
index 26f3715a457a..6703eb005c67 100644
--- a/net/netfilter/nf_nat_proto_udp.c
+++ b/net/netfilter/nf_nat_proto_udp.c
@@ -85,7 +85,6 @@ static bool udplite_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
 	.l4proto		= IPPROTO_UDPLITE,
 	.manip_pkt		= udplite_manip_pkt,
-	.in_range		= nf_nat_l4proto_in_range,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
@@ -95,7 +94,6 @@ const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
 const struct nf_nat_l4proto nf_nat_l4proto_udp = {
 	.l4proto		= IPPROTO_UDP,
 	.manip_pkt		= udp_manip_pkt,
-	.in_range		= nf_nat_l4proto_in_range,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/netfilter/nf_nat_proto_unknown.c b/net/netfilter/nf_nat_proto_unknown.c
index 16b66785ea5b..ba178b02fc1a 100644
--- a/net/netfilter/nf_nat_proto_unknown.c
+++ b/net/netfilter/nf_nat_proto_unknown.c
@@ -17,14 +17,6 @@
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static bool unknown_in_range(const struct nf_conntrack_tuple *tuple,
-			     enum nf_nat_manip_type manip_type,
-			     const union nf_conntrack_man_proto *min,
-			     const union nf_conntrack_man_proto *max)
-{
-	return true;
-}
-
 static bool
 unknown_manip_pkt(struct sk_buff *skb,
 		  const struct nf_nat_l3proto *l3proto,
@@ -37,5 +29,4 @@ unknown_manip_pkt(struct sk_buff *skb,
 
 const struct nf_nat_l4proto nf_nat_l4proto_unknown = {
 	.manip_pkt		= unknown_manip_pkt,
-	.in_range		= unknown_in_range,
 };
-- 
2.11.0
