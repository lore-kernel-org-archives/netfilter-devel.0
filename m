From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/37] netfilter: nat: remove l4 protocol port rovers
Date: Fri, 21 Dec 2018 01:28:13 +0100
Message-ID: <20181221002841.28587-10-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This is a leftover from days where single-cpu systems were common:
Store last port used to resolve a clash to use it as a starting point when
the next conflict needs to be resolved.

When we have parallel attempt to connect to same address:port pair,
its likely that both cores end up computing the same "available" port,
as both use same starting port, and newly used ports won't become
visible to other cores until the conntrack gets confirmed later.

One of the cores then has to drop the packet at insertion time because
the chosen new tuple turns out to be in use after all.

Lets simplify this: remove port rover and use a pseudo-random starting
point.

Note that this doesn't make netfilter default to 'fully random' mode;
the 'rover' was only used if NAT could not reuse source port as-is.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l4proto.h |  2 +-
 net/netfilter/nf_nat_proto_common.c    |  8 ++------
 net/netfilter/nf_nat_proto_dccp.c      |  5 +----
 net/netfilter/nf_nat_proto_sctp.c      |  5 +----
 net/netfilter/nf_nat_proto_tcp.c       |  5 +----
 net/netfilter/nf_nat_proto_udp.c       | 10 ++--------
 6 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index b4d6b29bca62..7ecac2cd1020 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -74,7 +74,7 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 struct nf_conntrack_tuple *tuple,
 				 const struct nf_nat_range2 *range,
 				 enum nf_nat_manip_type maniptype,
-				 const struct nf_conn *ct, u16 *rover);
+				 const struct nf_conn *ct);
 
 int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
 				   struct nf_nat_range2 *range);
diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index 5d849d835561..a7de939fa5a9 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -38,8 +38,7 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 struct nf_conntrack_tuple *tuple,
 				 const struct nf_nat_range2 *range,
 				 enum nf_nat_manip_type maniptype,
-				 const struct nf_conn *ct,
-				 u16 *rover)
+				 const struct nf_conn *ct)
 {
 	unsigned int range_size, min, max, i;
 	__be16 *portptr;
@@ -86,16 +85,13 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 	} else if (range->flags & NF_NAT_RANGE_PROTO_OFFSET) {
 		off = (ntohs(*portptr) - ntohs(range->base_proto.all));
 	} else {
-		off = *rover;
+		off = prandom_u32();
 	}
 
 	for (i = 0; ; ++off) {
 		*portptr = htons(min + off % range_size);
 		if (++i != range_size && nf_nat_used_tuple(tuple, ct))
 			continue;
-		if (!(range->flags & (NF_NAT_RANGE_PROTO_RANDOM_ALL|
-					NF_NAT_RANGE_PROTO_OFFSET)))
-			*rover = off;
 		return;
 	}
 }
diff --git a/net/netfilter/nf_nat_proto_dccp.c b/net/netfilter/nf_nat_proto_dccp.c
index 67ea0d83aa5a..7d4d2c124990 100644
--- a/net/netfilter/nf_nat_proto_dccp.c
+++ b/net/netfilter/nf_nat_proto_dccp.c
@@ -18,8 +18,6 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static u_int16_t dccp_port_rover;
-
 static void
 dccp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  struct nf_conntrack_tuple *tuple,
@@ -27,8 +25,7 @@ dccp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  enum nf_nat_manip_type maniptype,
 		  const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &dccp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index 1c5d9b65fbba..f05ad8fa7b20 100644
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -12,8 +12,6 @@
 
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static u_int16_t nf_sctp_port_rover;
-
 static void
 sctp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  struct nf_conntrack_tuple *tuple,
@@ -21,8 +19,7 @@ sctp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		  enum nf_nat_manip_type maniptype,
 		  const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &nf_sctp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
diff --git a/net/netfilter/nf_nat_proto_tcp.c b/net/netfilter/nf_nat_proto_tcp.c
index f15fcd475f98..c312e6b3e2ea 100644
--- a/net/netfilter/nf_nat_proto_tcp.c
+++ b/net/netfilter/nf_nat_proto_tcp.c
@@ -18,8 +18,6 @@
 #include <net/netfilter/nf_nat_l4proto.h>
 #include <net/netfilter/nf_nat_core.h>
 
-static u16 tcp_port_rover;
-
 static void
 tcp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 struct nf_conntrack_tuple *tuple,
@@ -27,8 +25,7 @@ tcp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &tcp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static bool
diff --git a/net/netfilter/nf_nat_proto_udp.c b/net/netfilter/nf_nat_proto_udp.c
index 5790f70a83b2..208c14316359 100644
--- a/net/netfilter/nf_nat_proto_udp.c
+++ b/net/netfilter/nf_nat_proto_udp.c
@@ -17,8 +17,6 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
-static u16 udp_port_rover;
-
 static void
 udp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 struct nf_conntrack_tuple *tuple,
@@ -26,8 +24,7 @@ udp_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &udp_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 static void
@@ -79,8 +76,6 @@ static bool udp_manip_pkt(struct sk_buff *skb,
 }
 
 #ifdef CONFIG_NF_NAT_PROTO_UDPLITE
-static u16 udplite_port_rover;
-
 static bool udplite_manip_pkt(struct sk_buff *skb,
 			      const struct nf_nat_l3proto *l3proto,
 			      unsigned int iphdroff, unsigned int hdroff,
@@ -104,8 +99,7 @@ udplite_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		     enum nf_nat_manip_type maniptype,
 		     const struct nf_conn *ct)
 {
-	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct,
-				    &udplite_port_rover);
+	nf_nat_l4proto_unique_tuple(l3proto, tuple, range, maniptype, ct);
 }
 
 const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
-- 
2.11.0
