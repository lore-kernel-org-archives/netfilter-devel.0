From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/38] netfilter: conntrack: avoid calls to l4proto invert_tuple
Date: Fri, 20 Jul 2018 15:08:40 +0200
Message-ID: <20180720130906.27687-13-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Handle the common cases (tcp, udp, etc). in the core and only
do the indirect call for the protocols that need it (GRE for instance).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h |  2 +-
 net/netfilter/nf_conntrack_core.c            |  8 +++++++-
 net/netfilter/nf_conntrack_proto_dccp.c      | 10 ----------
 net/netfilter/nf_conntrack_proto_generic.c   | 10 ----------
 net/netfilter/nf_conntrack_proto_gre.c       | 10 ----------
 net/netfilter/nf_conntrack_proto_sctp.c      | 10 ----------
 net/netfilter/nf_conntrack_proto_tcp.c       | 10 ----------
 net/netfilter/nf_conntrack_proto_udp.c       | 12 ------------
 8 files changed, 8 insertions(+), 64 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index a7220eef9aee..6a55e337a161 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -36,7 +36,7 @@ struct nf_conntrack_l4proto {
 			     struct net *net, struct nf_conntrack_tuple *tuple);
 
 	/* Invert the per-proto part of the tuple: ie. turn xmit into reply.
-	 * Some packets can't be inverted: return 0 in that case.
+	 * Only used by icmp, most protocols use a generic version.
 	 */
 	bool (*invert_tuple)(struct nf_conntrack_tuple *inverse,
 			     const struct nf_conntrack_tuple *orig);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0674c6e5bfed..92efce69b690 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -400,7 +400,13 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 	inverse->dst.dir = !orig->dst.dir;
 
 	inverse->dst.protonum = orig->dst.protonum;
-	return l4proto->invert_tuple(inverse, orig);
+
+	if (unlikely(l4proto->invert_tuple))
+		return l4proto->invert_tuple(inverse, orig);
+
+	inverse->src.u.all = orig->dst.u.all;
+	inverse->dst.u.all = orig->src.u.all;
+	return true;
 }
 EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
 
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index abe647d5b8c6..05620c03f138 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -403,14 +403,6 @@ static bool dccp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 	return true;
 }
 
-static bool dccp_invert_tuple(struct nf_conntrack_tuple *inv,
-			      const struct nf_conntrack_tuple *tuple)
-{
-	inv->src.u.dccp.port = tuple->dst.u.dccp.port;
-	inv->dst.u.dccp.port = tuple->src.u.dccp.port;
-	return true;
-}
-
 static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		     unsigned int dataoff, unsigned int *timeouts)
 {
@@ -865,7 +857,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 = {
 	.l3proto		= AF_INET,
 	.l4proto		= IPPROTO_DCCP,
 	.pkt_to_tuple		= dccp_pkt_to_tuple,
-	.invert_tuple		= dccp_invert_tuple,
 	.new			= dccp_new,
 	.packet			= dccp_packet,
 	.get_timeouts		= dccp_get_timeouts,
@@ -901,7 +892,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6 = {
 	.l3proto		= AF_INET6,
 	.l4proto		= IPPROTO_DCCP,
 	.pkt_to_tuple		= dccp_pkt_to_tuple,
-	.invert_tuple		= dccp_invert_tuple,
 	.new			= dccp_new,
 	.packet			= dccp_packet,
 	.get_timeouts		= dccp_get_timeouts,
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 6c6896d21cd7..4dfe40aa9446 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -41,15 +41,6 @@ static bool generic_pkt_to_tuple(const struct sk_buff *skb,
 	return true;
 }
 
-static bool generic_invert_tuple(struct nf_conntrack_tuple *tuple,
-				 const struct nf_conntrack_tuple *orig)
-{
-	tuple->src.u.all = 0;
-	tuple->dst.u.all = 0;
-
-	return true;
-}
-
 static unsigned int *generic_get_timeouts(struct net *net)
 {
 	return &(generic_pernet(net)->timeout);
@@ -168,7 +159,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 	.l3proto		= PF_UNSPEC,
 	.l4proto		= 255,
 	.pkt_to_tuple		= generic_pkt_to_tuple,
-	.invert_tuple		= generic_invert_tuple,
 	.packet			= generic_packet,
 	.get_timeouts		= generic_get_timeouts,
 	.new			= generic_new,
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index d049ea5a3770..0bd40eb06b55 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -179,15 +179,6 @@ EXPORT_SYMBOL_GPL(nf_ct_gre_keymap_destroy);
 
 /* PUBLIC CONNTRACK PROTO HELPER FUNCTIONS */
 
-/* invert gre part of tuple */
-static bool gre_invert_tuple(struct nf_conntrack_tuple *tuple,
-			     const struct nf_conntrack_tuple *orig)
-{
-	tuple->dst.u.gre.key = orig->src.u.gre.key;
-	tuple->src.u.gre.key = orig->dst.u.gre.key;
-	return true;
-}
-
 /* gre hdr info to tuple */
 static bool gre_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 			     struct net *net, struct nf_conntrack_tuple *tuple)
@@ -356,7 +347,6 @@ static const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
 	.l3proto	 = AF_INET,
 	.l4proto	 = IPPROTO_GRE,
 	.pkt_to_tuple	 = gre_pkt_to_tuple,
-	.invert_tuple	 = gre_invert_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack = gre_print_conntrack,
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index fb9a35d16069..148957a5cf3e 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -166,14 +166,6 @@ static bool sctp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 	return true;
 }
 
-static bool sctp_invert_tuple(struct nf_conntrack_tuple *tuple,
-			      const struct nf_conntrack_tuple *orig)
-{
-	tuple->src.u.sctp.port = orig->dst.u.sctp.port;
-	tuple->dst.u.sctp.port = orig->src.u.sctp.port;
-	return true;
-}
-
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 /* Print out the private part of the conntrack. */
 static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
@@ -781,7 +773,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
 	.l3proto		= PF_INET,
 	.l4proto 		= IPPROTO_SCTP,
 	.pkt_to_tuple 		= sctp_pkt_to_tuple,
-	.invert_tuple 		= sctp_invert_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack	= sctp_print_conntrack,
 #endif
@@ -818,7 +809,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
 	.l3proto		= PF_INET6,
 	.l4proto 		= IPPROTO_SCTP,
 	.pkt_to_tuple 		= sctp_pkt_to_tuple,
-	.invert_tuple 		= sctp_invert_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack	= sctp_print_conntrack,
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 8e67910185a0..03cff1e3066a 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -293,14 +293,6 @@ static bool tcp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 	return true;
 }
 
-static bool tcp_invert_tuple(struct nf_conntrack_tuple *tuple,
-			     const struct nf_conntrack_tuple *orig)
-{
-	tuple->src.u.tcp.port = orig->dst.u.tcp.port;
-	tuple->dst.u.tcp.port = orig->src.u.tcp.port;
-	return true;
-}
-
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 /* Print out the private part of the conntrack. */
 static void tcp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
@@ -1560,7 +1552,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
 	.l3proto		= PF_INET,
 	.l4proto 		= IPPROTO_TCP,
 	.pkt_to_tuple 		= tcp_pkt_to_tuple,
-	.invert_tuple 		= tcp_invert_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack 	= tcp_print_conntrack,
 #endif
@@ -1598,7 +1589,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 =
 	.l3proto		= PF_INET6,
 	.l4proto 		= IPPROTO_TCP,
 	.pkt_to_tuple 		= tcp_pkt_to_tuple,
-	.invert_tuple 		= tcp_invert_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack 	= tcp_print_conntrack,
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index fe7243970aa4..6fe2233c323a 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -55,14 +55,6 @@ static bool udp_pkt_to_tuple(const struct sk_buff *skb,
 	return true;
 }
 
-static bool udp_invert_tuple(struct nf_conntrack_tuple *tuple,
-			     const struct nf_conntrack_tuple *orig)
-{
-	tuple->src.u.udp.port = orig->dst.u.udp.port;
-	tuple->dst.u.udp.port = orig->src.u.udp.port;
-	return true;
-}
-
 static unsigned int *udp_get_timeouts(struct net *net)
 {
 	return udp_pernet(net)->timeouts;
@@ -302,7 +294,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
 	.l4proto		= IPPROTO_UDP,
 	.allow_clash		= true,
 	.pkt_to_tuple		= udp_pkt_to_tuple,
-	.invert_tuple		= udp_invert_tuple,
 	.packet			= udp_packet,
 	.get_timeouts		= udp_get_timeouts,
 	.new			= udp_new,
@@ -334,7 +325,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 =
 	.l4proto		= IPPROTO_UDPLITE,
 	.allow_clash		= true,
 	.pkt_to_tuple		= udp_pkt_to_tuple,
-	.invert_tuple		= udp_invert_tuple,
 	.packet			= udp_packet,
 	.get_timeouts		= udp_get_timeouts,
 	.new			= udp_new,
@@ -366,7 +356,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 =
 	.l4proto		= IPPROTO_UDP,
 	.allow_clash		= true,
 	.pkt_to_tuple		= udp_pkt_to_tuple,
-	.invert_tuple		= udp_invert_tuple,
 	.packet			= udp_packet,
 	.get_timeouts		= udp_get_timeouts,
 	.new			= udp_new,
@@ -398,7 +387,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 =
 	.l4proto		= IPPROTO_UDPLITE,
 	.allow_clash		= true,
 	.pkt_to_tuple		= udp_pkt_to_tuple,
-	.invert_tuple		= udp_invert_tuple,
 	.packet			= udp_packet,
 	.get_timeouts		= udp_get_timeouts,
 	.new			= udp_new,
-- 
2.11.0
