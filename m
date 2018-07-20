From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/38] netfilter: conntrack: avoid l4proto pkt_to_tuple calls
Date: Fri, 20 Jul 2018 15:08:41 +0200
Message-ID: <20180720130906.27687-14-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Handle common protocols (udp, tcp, ..), in the core and only
do the call if needed by the l4proto tracker.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c       | 16 +++++++++++++++-
 net/netfilter/nf_conntrack_proto_dccp.c | 17 -----------------
 net/netfilter/nf_conntrack_proto_sctp.c | 18 ------------------
 net/netfilter/nf_conntrack_proto_tcp.c  | 19 -------------------
 net/netfilter/nf_conntrack_proto_udp.c  | 23 -----------------------
 5 files changed, 15 insertions(+), 78 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 92efce69b690..994591fd9b96 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -235,6 +235,10 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 	unsigned int size;
 	const __be32 *ap;
 	__be32 _addrs[8];
+	struct {
+		__be16 sport;
+		__be16 dport;
+	} _inet_hdr, *inet_hdr;
 
 	memset(tuple, 0, sizeof(*tuple));
 
@@ -270,7 +274,17 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 	tuple->dst.protonum = protonum;
 	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
 
-	return l4proto->pkt_to_tuple(skb, dataoff, net, tuple);
+	if (unlikely(l4proto->pkt_to_tuple))
+		return l4proto->pkt_to_tuple(skb, dataoff, net, tuple);
+
+	/* Actually only need first 4 bytes to get ports. */
+	inet_hdr = skb_header_pointer(skb, dataoff, sizeof(_inet_hdr), &_inet_hdr);
+	if (!inet_hdr)
+		return false;
+
+	tuple->src.u.udp.port = inet_hdr->sport;
+	tuple->dst.u.udp.port = inet_hdr->dport;
+	return true;
 }
 
 static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 05620c03f138..abfdce7baed5 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -388,21 +388,6 @@ static inline struct nf_dccp_net *dccp_pernet(struct net *net)
 	return &net->ct.nf_ct_proto.dccp;
 }
 
-static bool dccp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
-			      struct net *net, struct nf_conntrack_tuple *tuple)
-{
-	struct dccp_hdr _hdr, *dh;
-
-	/* Actually only need first 4 bytes to get ports. */
-	dh = skb_header_pointer(skb, dataoff, 4, &_hdr);
-	if (dh == NULL)
-		return false;
-
-	tuple->src.u.dccp.port = dh->dccph_sport;
-	tuple->dst.u.dccp.port = dh->dccph_dport;
-	return true;
-}
-
 static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		     unsigned int dataoff, unsigned int *timeouts)
 {
@@ -856,7 +841,6 @@ static struct nf_proto_net *dccp_get_net_proto(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 = {
 	.l3proto		= AF_INET,
 	.l4proto		= IPPROTO_DCCP,
-	.pkt_to_tuple		= dccp_pkt_to_tuple,
 	.new			= dccp_new,
 	.packet			= dccp_packet,
 	.get_timeouts		= dccp_get_timeouts,
@@ -891,7 +875,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_dccp4);
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6 = {
 	.l3proto		= AF_INET6,
 	.l4proto		= IPPROTO_DCCP,
-	.pkt_to_tuple		= dccp_pkt_to_tuple,
 	.new			= dccp_new,
 	.packet			= dccp_packet,
 	.get_timeouts		= dccp_get_timeouts,
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 148957a5cf3e..b4126a842bfd 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -150,22 +150,6 @@ static inline struct nf_sctp_net *sctp_pernet(struct net *net)
 	return &net->ct.nf_ct_proto.sctp;
 }
 
-static bool sctp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
-			      struct net *net, struct nf_conntrack_tuple *tuple)
-{
-	const struct sctphdr *hp;
-	struct sctphdr _hdr;
-
-	/* Actually only need first 4 bytes to get ports. */
-	hp = skb_header_pointer(skb, dataoff, 4, &_hdr);
-	if (hp == NULL)
-		return false;
-
-	tuple->src.u.sctp.port = hp->source;
-	tuple->dst.u.sctp.port = hp->dest;
-	return true;
-}
-
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 /* Print out the private part of the conntrack. */
 static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
@@ -772,7 +756,6 @@ static struct nf_proto_net *sctp_get_net_proto(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
 	.l3proto		= PF_INET,
 	.l4proto 		= IPPROTO_SCTP,
-	.pkt_to_tuple 		= sctp_pkt_to_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack	= sctp_print_conntrack,
 #endif
@@ -808,7 +791,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_sctp4);
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
 	.l3proto		= PF_INET6,
 	.l4proto 		= IPPROTO_SCTP,
-	.pkt_to_tuple 		= sctp_pkt_to_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack	= sctp_print_conntrack,
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 03cff1e3066a..13c89fd107b2 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -276,23 +276,6 @@ static inline struct nf_tcp_net *tcp_pernet(struct net *net)
 	return &net->ct.nf_ct_proto.tcp;
 }
 
-static bool tcp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
-			     struct net *net, struct nf_conntrack_tuple *tuple)
-{
-	const struct tcphdr *hp;
-	struct tcphdr _hdr;
-
-	/* Actually only need first 4 bytes to get ports. */
-	hp = skb_header_pointer(skb, dataoff, 4, &_hdr);
-	if (hp == NULL)
-		return false;
-
-	tuple->src.u.tcp.port = hp->source;
-	tuple->dst.u.tcp.port = hp->dest;
-
-	return true;
-}
-
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 /* Print out the private part of the conntrack. */
 static void tcp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
@@ -1551,7 +1534,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
 {
 	.l3proto		= PF_INET,
 	.l4proto 		= IPPROTO_TCP,
-	.pkt_to_tuple 		= tcp_pkt_to_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack 	= tcp_print_conntrack,
 #endif
@@ -1588,7 +1570,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 =
 {
 	.l3proto		= PF_INET6,
 	.l4proto 		= IPPROTO_TCP,
-	.pkt_to_tuple 		= tcp_pkt_to_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack 	= tcp_print_conntrack,
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 6fe2233c323a..8b435d70ffe3 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -36,25 +36,6 @@ static inline struct nf_udp_net *udp_pernet(struct net *net)
 	return &net->ct.nf_ct_proto.udp;
 }
 
-static bool udp_pkt_to_tuple(const struct sk_buff *skb,
-			     unsigned int dataoff,
-			     struct net *net,
-			     struct nf_conntrack_tuple *tuple)
-{
-	const struct udphdr *hp;
-	struct udphdr _hdr;
-
-	/* Actually only need first 4 bytes to get ports. */
-	hp = skb_header_pointer(skb, dataoff, 4, &_hdr);
-	if (hp == NULL)
-		return false;
-
-	tuple->src.u.udp.port = hp->source;
-	tuple->dst.u.udp.port = hp->dest;
-
-	return true;
-}
-
 static unsigned int *udp_get_timeouts(struct net *net)
 {
 	return udp_pernet(net)->timeouts;
@@ -293,7 +274,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_UDP,
 	.allow_clash		= true,
-	.pkt_to_tuple		= udp_pkt_to_tuple,
 	.packet			= udp_packet,
 	.get_timeouts		= udp_get_timeouts,
 	.new			= udp_new,
@@ -324,7 +304,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 =
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_UDPLITE,
 	.allow_clash		= true,
-	.pkt_to_tuple		= udp_pkt_to_tuple,
 	.packet			= udp_packet,
 	.get_timeouts		= udp_get_timeouts,
 	.new			= udp_new,
@@ -355,7 +334,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 =
 	.l3proto		= PF_INET6,
 	.l4proto		= IPPROTO_UDP,
 	.allow_clash		= true,
-	.pkt_to_tuple		= udp_pkt_to_tuple,
 	.packet			= udp_packet,
 	.get_timeouts		= udp_get_timeouts,
 	.new			= udp_new,
@@ -386,7 +364,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 =
 	.l3proto		= PF_INET6,
 	.l4proto		= IPPROTO_UDPLITE,
 	.allow_clash		= true,
-	.pkt_to_tuple		= udp_pkt_to_tuple,
 	.packet			= udp_packet,
 	.get_timeouts		= udp_get_timeouts,
 	.new			= udp_new,
-- 
2.11.0
