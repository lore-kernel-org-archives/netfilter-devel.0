From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/37] netfilter: nat: un-export nf_nat_l4proto_unique_tuple
Date: Fri, 21 Dec 2018 01:28:20 +0100
Message-ID: <20181221002841.28587-17-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

almost all l4proto->unique_tuple implementations just call this helper,
so make ->unique_tuple() optional and call its helper directly if the
l4proto doesn't override it.

This is an intermediate step to get rid of ->unique_tuple completely.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l4proto.h |  6 ---
 net/netfilter/nf_nat_core.c            | 76 +++++++++++++++++++++++++++++++++-
 net/netfilter/nf_nat_proto_common.c    | 73 --------------------------------
 net/netfilter/nf_nat_proto_dccp.c      | 11 -----
 net/netfilter/nf_nat_proto_sctp.c      | 11 -----
 net/netfilter/nf_nat_proto_tcp.c       | 11 -----
 net/netfilter/nf_nat_proto_udp.c       | 22 ----------
 7 files changed, 75 insertions(+), 135 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index 7ecac2cd1020..96f0794bb1f8 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -70,12 +70,6 @@ bool nf_nat_l4proto_in_range(const struct nf_conntrack_tuple *tuple,
 			     const union nf_conntrack_man_proto *min,
 			     const union nf_conntrack_man_proto *max);
 
-void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
-				 struct nf_conntrack_tuple *tuple,
-				 const struct nf_nat_range2 *range,
-				 enum nf_nat_manip_type maniptype,
-				 const struct nf_conn *ct);
-
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
 				   struct nf_nat_range2 *range);
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index e2b196054dfc..0c0f012343b1 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -310,6 +310,77 @@ find_best_ips_proto(const struct nf_conntrack_zone *zone,
 	}
 }
 
+static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
+					const struct nf_nat_range2 *range,
+					enum nf_nat_manip_type maniptype,
+					const struct nf_conn *ct)
+{
+	unsigned int range_size, min, max, i, attempts;
+	__be16 *portptr;
+	u16 off;
+	static const unsigned int max_attempts = 128;
+
+	if (maniptype == NF_NAT_MANIP_SRC)
+		portptr = &tuple->src.u.all;
+	else
+		portptr = &tuple->dst.u.all;
+
+	/* If no range specified... */
+	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
+		/* If it's dst rewrite, can't change port */
+		if (maniptype == NF_NAT_MANIP_DST)
+			return;
+
+		if (ntohs(*portptr) < 1024) {
+			/* Loose convention: >> 512 is credential passing */
+			if (ntohs(*portptr) < 512) {
+				min = 1;
+				range_size = 511 - min + 1;
+			} else {
+				min = 600;
+				range_size = 1023 - min + 1;
+			}
+		} else {
+			min = 1024;
+			range_size = 65535 - 1024 + 1;
+		}
+	} else {
+		min = ntohs(range->min_proto.all);
+		max = ntohs(range->max_proto.all);
+		if (unlikely(max < min))
+			swap(max, min);
+		range_size = max - min + 1;
+	}
+
+	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
+		off = (ntohs(*portptr) - ntohs(range->base_proto.all));
+	else
+		off = prandom_u32();
+
+	attempts = range_size;
+	if (attempts > max_attempts)
+		attempts = max_attempts;
+
+	/* We are in softirq; doing a search of the entire range risks
+	 * soft lockup when all tuples are already used.
+	 *
+	 * If we can't find any free port from first offset, pick a new
+	 * one and try again, with ever smaller search window.
+	 */
+another_round:
+	for (i = 0; i < attempts; i++, off++) {
+		*portptr = htons(min + off % range_size);
+		if (!nf_nat_used_tuple(tuple, ct))
+			return;
+	}
+
+	if (attempts >= range_size || attempts < 16)
+		return;
+	attempts /= 2;
+	off = prandom_u32();
+	goto another_round;
+}
+
 /* Manipulate the tuple into the range given. For NF_INET_POST_ROUTING,
  * we change the source to map into the range. For NF_INET_PRE_ROUTING
  * and NF_INET_LOCAL_OUT, we change the destination to map into the
@@ -383,7 +454,10 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	}
 
 	/* Last chance: get protocol to try to obtain unique tuple. */
-	l4proto->unique_tuple(l3proto, tuple, range, maniptype, ct);
+	if (l4proto->unique_tuple)
+		l4proto->unique_tuple(l3proto, tuple, range, maniptype, ct);
+	else
+		nf_nat_l4proto_unique_tuple(tuple, range, maniptype, ct);
 out:
 	rcu_read_unlock();
 }
diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index dabfe9a2c041..ef14d86f0f5b 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -34,79 +34,6 @@ bool nf_nat_l4proto_in_range(const struct nf_conntrack_tuple *tuple,
 }
 EXPORT_SYMBOL_GPL(nf_nat_l4proto_in_range);
 
-void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
-				 struct nf_conntrack_tuple *tuple,
-				 const struct nf_nat_range2 *range,
-				 enum nf_nat_manip_type maniptype,
-				 const struct nf_conn *ct)
-{
-	unsigned int range_size, min, max, i, attempts;
-	__be16 *portptr;
-	u16 off;
-	static const unsigned int max_attempts = 128;
-
-	if (maniptype == NF_NAT_MANIP_SRC)
-		portptr = &tuple->src.u.all;
-	else
-		portptr = &tuple->dst.u.all;
-
-	/* If no range specified... */
-	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
-		/* If it's dst rewrite, can't change port */
-		if (maniptype == NF_NAT_MANIP_DST)
-			return;
-
-		if (ntohs(*portptr) < 1024) {
-			/* Loose convention: >> 512 is credential passing */
-			if (ntohs(*portptr) < 512) {
-				min = 1;
-				range_size = 511 - min + 1;
-			} else {
-				min = 600;
-				range_size = 1023 - min + 1;
-			}
-		} else {
-			min = 1024;
-			range_size = 65535 - 1024 + 1;
-		}
-	} else {
-		min = ntohs(range->min_proto.all);
-		max = ntohs(range->max_proto.all);
-		if (unlikely(max < min))
-			swap(max, min);
-		range_size = max - min + 1;
-	}
-
-	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
-		off = (ntohs(*portptr) - ntohs(range->base_proto.all));
-	else
-		off = prandom_u32();
-
-	attempts = range_size;
-	if (attempts > max_attempts)
-		attempts = max_attempts;
-
-	/* We are in softirq; doing a search of the entire range risks
-	 * soft lockup when all tuples are already used.
-	 *
-	 * If we can't find any free port from first offset, pick a new
-	 * one and try again, with ever smaller search window.
-	 */
-another_round:
-	for (i = 0; i < attempts; i++, off++) {
-		*portptr = htons(min + off % range_size);
-		if (!nf_nat_used_tuple(tuple, ct))
-			return;
-	}
-
-	if (attempts >= range_size || attempts < 16)
-		return;
-	attempts /= 2;
-	off = prandom_u32();
-	goto another_round;
-}
-EXPORT_SYMBOL_GPL(nf_nat_l4proto_unique_tuple);
-
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
 				   struct nf_nat_range2 *range)
diff --git a/net/netfilter/nf_nat_proto_dccp.c b/net/netfilter/nf_nat_proto_dccp.c
index 7d4d2c124990..8dbba7b20177 100644
--- a/net/netfilter/nf_nat_proto_dccp.c
+++ b/net/netfilter/nf_nat_proto_dccp.c
@@ -18,16 +18,6 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static void
-dccp_unique_tuple(const struct nf_nat_l3proto *l3proto,
-		  struct nf_conntrack_tuple *tuple,
-		  const struct nf_nat_range2 *range,
-		  enum nf_nat_manip_type maniptype,
-		  const struct nf_conn *ct)
-{
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
-}
-
 static bool
 dccp_manip_pkt(struct sk_buff *skb,
 	       const struct nf_nat_l3proto *l3proto,
@@ -72,7 +62,6 @@ const struct nf_nat_l4proto nf_nat_l4proto_dccp = {
 	.l4proto		= IPPROTO_DCCP,
 	.manip_pkt		= dccp_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
-	.unique_tuple		= dccp_unique_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index f05ad8fa7b20..da86475d0db6 100644
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -12,16 +12,6 @@
 
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static void
-sctp_unique_tuple(const struct nf_nat_l3proto *l3proto,
-		  struct nf_conntrack_tuple *tuple,
-		  const struct nf_nat_range2 *range,
-		  enum nf_nat_manip_type maniptype,
-		  const struct nf_conn *ct)
-{
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
-}
-
 static bool
 sctp_manip_pkt(struct sk_buff *skb,
 	       const struct nf_nat_l3proto *l3proto,
@@ -67,7 +57,6 @@ const struct nf_nat_l4proto nf_nat_l4proto_sctp = {
 	.l4proto		= IPPROTO_SCTP,
 	.manip_pkt		= sctp_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
-	.unique_tuple		= sctp_unique_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/netfilter/nf_nat_proto_tcp.c b/net/netfilter/nf_nat_proto_tcp.c
index c312e6b3e2ea..666a4b3303f7 100644
--- a/net/netfilter/nf_nat_proto_tcp.c
+++ b/net/netfilter/nf_nat_proto_tcp.c
@@ -18,16 +18,6 @@
 #include <net/netfilter/nf_nat_l4proto.h>
 #include <net/netfilter/nf_nat_core.h>
 
-static void
-tcp_unique_tuple(const struct nf_nat_l3proto *l3proto,
-		 struct nf_conntrack_tuple *tuple,
-		 const struct nf_nat_range2 *range,
-		 enum nf_nat_manip_type maniptype,
-		 const struct nf_conn *ct)
-{
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
-}
-
 static bool
 tcp_manip_pkt(struct sk_buff *skb,
 	      const struct nf_nat_l3proto *l3proto,
@@ -75,7 +65,6 @@ const struct nf_nat_l4proto nf_nat_l4proto_tcp = {
 	.l4proto		= IPPROTO_TCP,
 	.manip_pkt		= tcp_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
-	.unique_tuple		= tcp_unique_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
diff --git a/net/netfilter/nf_nat_proto_udp.c b/net/netfilter/nf_nat_proto_udp.c
index 208c14316359..26f3715a457a 100644
--- a/net/netfilter/nf_nat_proto_udp.c
+++ b/net/netfilter/nf_nat_proto_udp.c
@@ -18,16 +18,6 @@
 #include <net/netfilter/nf_nat_l4proto.h>
 
 static void
-udp_unique_tuple(const struct nf_nat_l3proto *l3proto,
-		 struct nf_conntrack_tuple *tuple,
-		 const struct nf_nat_range2 *range,
-		 enum nf_nat_manip_type maniptype,
-		 const struct nf_conn *ct)
-{
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
-}
-
-static void
 __udp_manip_pkt(struct sk_buff *skb,
 	        const struct nf_nat_l3proto *l3proto,
 	        unsigned int iphdroff, struct udphdr *hdr,
@@ -92,21 +82,10 @@ static bool udplite_manip_pkt(struct sk_buff *skb,
 	return true;
 }
 
-static void
-udplite_unique_tuple(const struct nf_nat_l3proto *l3proto,
-		     struct nf_conntrack_tuple *tuple,
-		     const struct nf_nat_range2 *range,
-		     enum nf_nat_manip_type maniptype,
-		     const struct nf_conn *ct)
-{
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
-}
-
 const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
 	.l4proto		= IPPROTO_UDPLITE,
 	.manip_pkt		= udplite_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
-	.unique_tuple		= udplite_unique_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
@@ -117,7 +96,6 @@ const struct nf_nat_l4proto nf_nat_l4proto_udp = {
 	.l4proto		= IPPROTO_UDP,
 	.manip_pkt		= udp_manip_pkt,
 	.in_range		= nf_nat_l4proto_in_range,
-	.unique_tuple		= udp_unique_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
 #endif
-- 
2.11.0
