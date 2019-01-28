From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/33] netfilter: conntrack: handle icmp pkt_to_tuple helper via direct calls
Date: Tue, 29 Jan 2019 00:57:25 +0100
Message-ID: <20190128235750.18412-9-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

rather than handling them via indirect call, use a direct one instead.
This leaves GRE as the last user of this indirect call facility.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 10 ++++++++++
 net/netfilter/nf_conntrack_core.c            |  6 ++++++
 net/netfilter/nf_conntrack_proto_icmp.c      |  5 ++---
 net/netfilter/nf_conntrack_proto_icmpv6.c    |  9 ++++-----
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 6ca4355ae3dc..46d554806eb3 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -90,6 +90,16 @@ struct nf_conntrack_l4proto {
 	struct module *me;
 };
 
+bool icmp_pkt_to_tuple(const struct sk_buff *skb,
+		       unsigned int dataoff,
+		       struct net *net,
+		       struct nf_conntrack_tuple *tuple);
+
+bool icmpv6_pkt_to_tuple(const struct sk_buff *skb,
+			 unsigned int dataoff,
+			 struct net *net,
+			 struct nf_conntrack_tuple *tuple);
+
 int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 			      struct sk_buff *skb,
 			      unsigned int dataoff,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5dfd95ae510d..b3840d36c3a6 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -274,6 +274,12 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 	tuple->dst.protonum = protonum;
 	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
 
+	switch (protonum) {
+	case IPPROTO_ICMPV6:
+		return icmpv6_pkt_to_tuple(skb, dataoff, net, tuple);
+	case IPPROTO_ICMP:
+		return icmp_pkt_to_tuple(skb, dataoff, net, tuple);
+	}
 	if (unlikely(l4proto->pkt_to_tuple))
 		return l4proto->pkt_to_tuple(skb, dataoff, net, tuple);
 
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 381a7f3ea68a..805c1fe5b837 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -25,8 +25,8 @@
 
 static const unsigned int nf_ct_icmp_timeout = 30*HZ;
 
-static bool icmp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
-			      struct net *net, struct nf_conntrack_tuple *tuple)
+bool icmp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+		       struct net *net, struct nf_conntrack_tuple *tuple)
 {
 	const struct icmphdr *hp;
 	struct icmphdr _hdr;
@@ -347,7 +347,6 @@ static struct nf_proto_net *icmp_get_net_proto(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 {
 	.l4proto		= IPPROTO_ICMP,
-	.pkt_to_tuple		= icmp_pkt_to_tuple,
 	.invert_tuple		= icmp_invert_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= icmp_tuple_to_nlattr,
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 93f27d0bcb75..20cd55e55e41 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -30,10 +30,10 @@
 
 static const unsigned int nf_ct_icmpv6_timeout = 30*HZ;
 
-static bool icmpv6_pkt_to_tuple(const struct sk_buff *skb,
-				unsigned int dataoff,
-				struct net *net,
-				struct nf_conntrack_tuple *tuple)
+bool icmpv6_pkt_to_tuple(const struct sk_buff *skb,
+			 unsigned int dataoff,
+			 struct net *net,
+			 struct nf_conntrack_tuple *tuple)
 {
 	const struct icmp6hdr *hp;
 	struct icmp6hdr _hdr;
@@ -358,7 +358,6 @@ static struct nf_proto_net *icmpv6_get_net_proto(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 {
 	.l4proto		= IPPROTO_ICMPV6,
-	.pkt_to_tuple		= icmpv6_pkt_to_tuple,
 	.invert_tuple		= icmpv6_invert_tuple,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= icmpv6_tuple_to_nlattr,
-- 
2.11.0
