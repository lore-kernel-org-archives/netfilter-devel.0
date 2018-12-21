From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/37] netfilter: nat: remove l4proto->unique_tuple
Date: Fri, 21 Dec 2018 01:28:21 +0100
Message-ID: <20181221002841.28587-18-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

fold remaining users (icmp, icmpv6, gre) into nf_nat_l4proto_unique_tuple.
The static-save of old incarnation of resolved key in gre and icmp is
removed as well, just use the prandom based offset like the others.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l4proto.h   | 11 -----
 net/ipv4/netfilter/nf_nat_proto_gre.c    | 44 --------------------
 net/ipv4/netfilter/nf_nat_proto_icmp.c   | 27 -------------
 net/ipv6/netfilter/nf_nat_proto_icmpv6.c | 26 ------------
 net/netfilter/nf_nat_core.c              | 69 ++++++++++++++++++++++++++------
 net/netfilter/nf_nat_proto_unknown.c     | 13 ------
 6 files changed, 56 insertions(+), 134 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index 96f0794bb1f8..4a0e4f0623a0 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -27,17 +27,6 @@ struct nf_nat_l4proto {
 			 const union nf_conntrack_man_proto *min,
 			 const union nf_conntrack_man_proto *max);
 
-	/* Alter the per-proto part of the tuple (depending on
-	 * maniptype), to give a unique tuple in the given range if
-	 * possible.  Per-protocol part of tuple is initialized to the
-	 * incoming packet.
-	 */
-	void (*unique_tuple)(const struct nf_nat_l3proto *l3proto,
-			     struct nf_conntrack_tuple *tuple,
-			     const struct nf_nat_range2 *range,
-			     enum nf_nat_manip_type maniptype,
-			     const struct nf_conn *ct);
-
 	int (*nlattr_to_range)(struct nlattr *tb[],
 			       struct nf_nat_range2 *range);
 };
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index 00fda6331ce5..a04ff7665e4c 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -37,49 +37,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter NAT protocol helper module for GRE");
 
-/* generate unique tuple ... */
-static void
-gre_unique_tuple(const struct nf_nat_l3proto *l3proto,
-		 struct nf_conntrack_tuple *tuple,
-		 const struct nf_nat_range2 *range,
-		 enum nf_nat_manip_type maniptype,
-		 const struct nf_conn *ct)
-{
-	static u_int16_t key;
-	__be16 *keyptr;
-	unsigned int min, i, range_size;
-
-	/* If there is no master conntrack we are not PPTP,
-	   do not change tuples */
-	if (!ct->master)
-		return;
-
-	if (maniptype == NF_NAT_MANIP_SRC)
-		keyptr = &tuple->src.u.gre.key;
-	else
-		keyptr = &tuple->dst.u.gre.key;
-
-	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
-		pr_debug("%p: NATing GRE PPTP\n", ct);
-		min = 1;
-		range_size = 0xffff;
-	} else {
-		min = ntohs(range->min_proto.gre.key);
-		range_size = ntohs(range->max_proto.gre.key) - min + 1;
-	}
-
-	pr_debug("min = %u, range_size = %u\n", min, range_size);
-
-	for (i = 0; ; ++key) {
-		*keyptr = htons(min + key % range_size);
-		if (++i == range_size || !nf_nat_used_tuple(tuple, ct))
-			return;
-	}
-
-	pr_debug("%p: no NAT mapping\n", ct);
-	return;
-}
-
 /* manipulate a GRE packet according to maniptype */
 static bool
 gre_manip_pkt(struct sk_buff *skb,
@@ -124,7 +81,6 @@ static const struct nf_nat_l4proto gre = {
 	.l4proto		= IPPROTO_GRE,
 	.manip_pkt		= gre_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
-	.unique_tuple		= gre_unique_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index 6d7cf1d79baf..70d7fabdbb01 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -27,32 +27,6 @@ icmp_in_range(const struct nf_conntrack_tuple *tuple,
 	       ntohs(tuple->src.u.icmp.id) <= ntohs(max->icmp.id);
 }
 
-static void
-icmp_unique_tuple(const struct nf_nat_l3proto *l3proto,
-		  struct nf_conntrack_tuple *tuple,
-		  const struct nf_nat_range2 *range,
-		  enum nf_nat_manip_type maniptype,
-		  const struct nf_conn *ct)
-{
-	static u_int16_t id;
-	unsigned int range_size;
-	unsigned int i;
-
-	range_size = ntohs(range->max_proto.icmp.id) -
-		     ntohs(range->min_proto.icmp.id) + 1;
-	/* If no range specified... */
-	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED))
-		range_size = 0xFFFF;
-
-	for (i = 0; ; ++id) {
-		tuple->src.u.icmp.id = htons(ntohs(range->min_proto.icmp.id) +
-					     (id % range_size));
-		if (++i == range_size || !nf_nat_used_tuple(tuple, ct))
-			return;
-	}
-	return;
-}
-
 static bool
 icmp_manip_pkt(struct sk_buff *skb,
 	       const struct nf_nat_l3proto *l3proto,
@@ -76,7 +50,6 @@ const struct nf_nat_l4proto nf_nat_l4proto_icmp = {
 	.l4proto		= IPPROTO_ICMP,
 	.manip_pkt		= icmp_manip_pkt,
 	.in_range		= icmp_in_range,
-	.unique_tuple		= icmp_unique_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
index d9bf42ba44fa..491361b7a721 100644
--- a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
@@ -29,31 +29,6 @@ icmpv6_in_range(const struct nf_conntrack_tuple *tuple,
 	       ntohs(tuple->src.u.icmp.id) <= ntohs(max->icmp.id);
 }
 
-static void
-icmpv6_unique_tuple(const struct nf_nat_l3proto *l3proto,
-		    struct nf_conntrack_tuple *tuple,
-		    const struct nf_nat_range2 *range,
-		    enum nf_nat_manip_type maniptype,
-		    const struct nf_conn *ct)
-{
-	static u16 id;
-	unsigned int range_size;
-	unsigned int i;
-
-	range_size = ntohs(range->max_proto.icmp.id) -
-		     ntohs(range->min_proto.icmp.id) + 1;
-
-	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED))
-		range_size = 0xffff;
-
-	for (i = 0; ; ++id) {
-		tuple->src.u.icmp.id = htons(ntohs(range->min_proto.icmp.id) +
-					     (id % range_size));
-		if (++i == range_size || !nf_nat_used_tuple(tuple, ct))
-			return;
-	}
-}
-
 static bool
 icmpv6_manip_pkt(struct sk_buff *skb,
 		 const struct nf_nat_l3proto *l3proto,
@@ -83,7 +58,6 @@ const struct nf_nat_l4proto nf_nat_l4proto_icmpv6 = {
 	.l4proto		= IPPROTO_ICMPV6,
 	.manip_pkt		= icmpv6_manip_pkt,
 	.in_range		= icmpv6_in_range,
-	.unique_tuple		= icmpv6_unique_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 0c0f012343b1..763a92e82755 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -310,20 +310,65 @@ find_best_ips_proto(const struct nf_conntrack_zone *zone,
 	}
 }
 
+/* Alter the per-proto part of the tuple (depending on maniptype), to
+ * give a unique tuple in the given range if possible.
+ *
+ * Per-protocol part of tuple is initialized to the incoming packet.
+ */
 static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 					const struct nf_nat_range2 *range,
 					enum nf_nat_manip_type maniptype,
 					const struct nf_conn *ct)
 {
 	unsigned int range_size, min, max, i, attempts;
-	__be16 *portptr;
+	__be16 *keyptr;
 	u16 off;
 	static const unsigned int max_attempts = 128;
 
-	if (maniptype == NF_NAT_MANIP_SRC)
-		portptr = &tuple->src.u.all;
-	else
-		portptr = &tuple->dst.u.all;
+	switch (tuple->dst.protonum) {
+	case IPPROTO_ICMP: /* fallthrough */
+	case IPPROTO_ICMPV6:
+		/* id is same for either direction... */
+		keyptr = &tuple->src.u.icmp.id;
+		min = range->min_proto.icmp.id;
+		range_size = ntohs(range->max_proto.icmp.id) -
+			     ntohs(range->min_proto.icmp.id) + 1;
+		goto find_free_id;
+#if IS_ENABLED(CONFIG_NF_CT_PROTO_GRE)
+	case IPPROTO_GRE:
+		/* If there is no master conntrack we are not PPTP,
+		   do not change tuples */
+		if (!ct->master)
+			return;
+
+		if (maniptype == NF_NAT_MANIP_SRC)
+			keyptr = &tuple->src.u.gre.key;
+		else
+			keyptr = &tuple->dst.u.gre.key;
+
+		if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
+			min = 1;
+			range_size = 65535;
+		} else {
+			min = ntohs(range->min_proto.gre.key);
+			range_size = ntohs(range->max_proto.gre.key) - min + 1;
+		}
+		goto find_free_id;
+#endif
+	case IPPROTO_UDP:	/* fallthrough */
+	case IPPROTO_UDPLITE:	/* fallthrough */
+	case IPPROTO_TCP:	/* fallthrough */
+	case IPPROTO_SCTP:	/* fallthrough */
+	case IPPROTO_DCCP:	/* fallthrough */
+		if (maniptype == NF_NAT_MANIP_SRC)
+			keyptr = &tuple->src.u.all;
+		else
+			keyptr = &tuple->dst.u.all;
+
+		break;
+	default:
+		return;
+	}
 
 	/* If no range specified... */
 	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
@@ -331,9 +376,9 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 		if (maniptype == NF_NAT_MANIP_DST)
 			return;
 
-		if (ntohs(*portptr) < 1024) {
+		if (ntohs(*keyptr) < 1024) {
 			/* Loose convention: >> 512 is credential passing */
-			if (ntohs(*portptr) < 512) {
+			if (ntohs(*keyptr) < 512) {
 				min = 1;
 				range_size = 511 - min + 1;
 			} else {
@@ -352,8 +397,9 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 		range_size = max - min + 1;
 	}
 
+find_free_id:
 	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
-		off = (ntohs(*portptr) - ntohs(range->base_proto.all));
+		off = (ntohs(*keyptr) - ntohs(range->base_proto.all));
 	else
 		off = prandom_u32();
 
@@ -369,7 +415,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	 */
 another_round:
 	for (i = 0; i < attempts; i++, off++) {
-		*portptr = htons(min + off % range_size);
+		*keyptr = htons(min + off % range_size);
 		if (!nf_nat_used_tuple(tuple, ct))
 			return;
 	}
@@ -454,10 +500,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	}
 
 	/* Last chance: get protocol to try to obtain unique tuple. */
-	if (l4proto->unique_tuple)
-		l4proto->unique_tuple(l3proto, tuple, range, maniptype, ct);
-	else
-		nf_nat_l4proto_unique_tuple(tuple, range, maniptype, ct);
+	nf_nat_l4proto_unique_tuple(tuple, range, maniptype, ct);
 out:
 	rcu_read_unlock();
 }
diff --git a/net/netfilter/nf_nat_proto_unknown.c b/net/netfilter/nf_nat_proto_unknown.c
index c5db3e251232..16b66785ea5b 100644
--- a/net/netfilter/nf_nat_proto_unknown.c
+++ b/net/netfilter/nf_nat_proto_unknown.c
@@ -25,18 +25,6 @@ static bool unknown_in_range(const struct nf_conntrack_tuple *tuple,
 	return true;
 }
 
-static void unknown_unique_tuple(const struct nf_nat_l3proto *l3proto,
-				 struct nf_conntrack_tuple *tuple,
-				 const struct nf_nat_range2 *range,
-				 enum nf_nat_manip_type maniptype,
-				 const struct nf_conn *ct)
-{
-	/* Sorry: we can't help you; if it's not unique, we can't frob
-	 * anything.
-	 */
-	return;
-}
-
 static bool
 unknown_manip_pkt(struct sk_buff *skb,
 		  const struct nf_nat_l3proto *l3proto,
@@ -50,5 +38,4 @@ unknown_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_unknown = {
 	.manip_pkt		= unknown_manip_pkt,
 	.in_range		= unknown_in_range,
-	.unique_tuple		= unknown_unique_tuple,
 };
-- 
2.11.0
