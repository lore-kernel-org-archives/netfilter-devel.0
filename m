From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/33] netfilter: conntrack: remove invert_tuple callback
Date: Tue, 29 Jan 2019 00:57:30 +0100
Message-ID: <20190128235750.18412-14-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Only used by icmp(v6).  Prefer a direct call and remove this
function from the l4proto struct.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 11 +++++------
 net/netfilter/nf_conntrack_core.c            |  8 ++++++--
 net/netfilter/nf_conntrack_proto_icmp.c      |  5 ++---
 net/netfilter/nf_conntrack_proto_icmpv6.c    |  5 ++---
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 0d4b0398aeb9..6cec8337e684 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -27,12 +27,6 @@ struct nf_conntrack_l4proto {
 	/* protoinfo nlattr size, closes a hole */
 	u16 nlattr_size;
 
-	/* Invert the per-proto part of the tuple: ie. turn xmit into reply.
-	 * Only used by icmp, most protocols use a generic version.
-	 */
-	bool (*invert_tuple)(struct nf_conntrack_tuple *inverse,
-			     const struct nf_conntrack_tuple *orig);
-
 	/* Returns verdict for packet, or -1 for invalid. */
 	int (*packet)(struct nf_conn *ct,
 		      struct sk_buff *skb,
@@ -95,6 +89,11 @@ bool icmpv6_pkt_to_tuple(const struct sk_buff *skb,
 			 struct net *net,
 			 struct nf_conntrack_tuple *tuple);
 
+bool nf_conntrack_invert_icmp_tuple(struct nf_conntrack_tuple *tuple,
+				    const struct nf_conntrack_tuple *orig);
+bool nf_conntrack_invert_icmpv6_tuple(struct nf_conntrack_tuple *tuple,
+				      const struct nf_conntrack_tuple *orig);
+
 int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 			      struct sk_buff *skb,
 			      unsigned int dataoff,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b71e271f2b44..d56cb0fc82b6 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -423,8 +423,12 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 
 	inverse->dst.protonum = orig->dst.protonum;
 
-	if (unlikely(l4proto->invert_tuple))
-		return l4proto->invert_tuple(inverse, orig);
+	switch (orig->dst.protonum) {
+	case IPPROTO_ICMP:
+		return nf_conntrack_invert_icmp_tuple(inverse, orig);
+	case IPPROTO_ICMPV6:
+		return nf_conntrack_invert_icmpv6_tuple(inverse, orig);
+	}
 
 	inverse->src.u.all = orig->dst.u.all;
 	inverse->dst.u.all = orig->src.u.all;
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 805c1fe5b837..d28c1d7633b2 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -54,8 +54,8 @@ static const u_int8_t invmap[] = {
 	[ICMP_ADDRESSREPLY] = ICMP_ADDRESS + 1
 };
 
-static bool icmp_invert_tuple(struct nf_conntrack_tuple *tuple,
-			      const struct nf_conntrack_tuple *orig)
+bool nf_conntrack_invert_icmp_tuple(struct nf_conntrack_tuple *tuple,
+				    const struct nf_conntrack_tuple *orig)
 {
 	if (orig->dst.u.icmp.type >= sizeof(invmap) ||
 	    !invmap[orig->dst.u.icmp.type])
@@ -347,7 +347,6 @@ static struct nf_proto_net *icmp_get_net_proto(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 {
 	.l4proto		= IPPROTO_ICMP,
-	.invert_tuple		= icmp_invert_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= icmp_tuple_to_nlattr,
 	.nlattr_tuple_size	= icmp_nlattr_tuple_size,
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 20cd55e55e41..2910dcdea134 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -67,8 +67,8 @@ static const u_int8_t noct_valid_new[] = {
 	[ICMPV6_MLD2_REPORT - 130] = 1
 };
 
-static bool icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
-				const struct nf_conntrack_tuple *orig)
+bool nf_conntrack_invert_icmpv6_tuple(struct nf_conntrack_tuple *tuple,
+				      const struct nf_conntrack_tuple *orig)
 {
 	int type = orig->dst.u.icmp.type - 128;
 	if (type < 0 || type >= sizeof(invmap) || !invmap[type])
@@ -358,7 +358,6 @@ static struct nf_proto_net *icmpv6_get_net_proto(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 {
 	.l4proto		= IPPROTO_ICMPV6,
-	.invert_tuple		= icmpv6_invert_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= icmpv6_tuple_to_nlattr,
 	.nlattr_tuple_size	= icmpv6_nlattr_tuple_size,
-- 
2.11.0
