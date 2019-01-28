From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/33] netfilter: conntrack: remove pkt_to_tuple callback
Date: Tue, 29 Jan 2019 00:57:29 +0100
Message-ID: <20190128235750.18412-13-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

GRE is now builtin, so we can handle it via direct call and
remove the callback.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_proto_gre.h |  2 ++
 include/net/netfilter/nf_conntrack_l4proto.h     |  5 -----
 net/netfilter/nf_conntrack_core.c                |  6 ++++--
 net/netfilter/nf_conntrack_proto_generic.c       | 11 -----------
 net/netfilter/nf_conntrack_proto_gre.c           |  5 ++---
 5 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index 59714e9ee4ef..25f9a770fb84 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -30,5 +30,7 @@ void nf_ct_gre_keymap_flush(struct net *net);
 /* delete keymap entries */
 void nf_ct_gre_keymap_destroy(struct nf_conn *ct);
 
+bool gre_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+		      struct net *net, struct nf_conntrack_tuple *tuple);
 #endif /* __KERNEL__ */
 #endif /* _CONNTRACK_PROTO_GRE_H */
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 3585f8666fc0..0d4b0398aeb9 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -27,11 +27,6 @@ struct nf_conntrack_l4proto {
 	/* protoinfo nlattr size, closes a hole */
 	u16 nlattr_size;
 
-	/* Try to fill in the third arg: dataoff is offset past network protocol
-           hdr.  Return true if possible. */
-	bool (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int dataoff,
-			     struct net *net, struct nf_conntrack_tuple *tuple);
-
 	/* Invert the per-proto part of the tuple: ie. turn xmit into reply.
 	 * Only used by icmp, most protocols use a generic version.
 	 */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b3840d36c3a6..b71e271f2b44 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -279,9 +279,11 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 		return icmpv6_pkt_to_tuple(skb, dataoff, net, tuple);
 	case IPPROTO_ICMP:
 		return icmp_pkt_to_tuple(skb, dataoff, net, tuple);
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		return gre_pkt_to_tuple(skb, dataoff, net, tuple);
+#endif
 	}
-	if (unlikely(l4proto->pkt_to_tuple))
-		return l4proto->pkt_to_tuple(skb, dataoff, net, tuple);
 
 	/* Actually only need first 4 bytes to get ports. */
 	inet_hdr = skb_header_pointer(skb, dataoff, sizeof(_inet_hdr), &_inet_hdr);
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 5da19d5fbc76..5a5bf7cb6508 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -27,16 +27,6 @@ static bool nf_generic_should_process(u8 proto)
 	}
 }
 
-static bool generic_pkt_to_tuple(const struct sk_buff *skb,
-				 unsigned int dataoff,
-				 struct net *net, struct nf_conntrack_tuple *tuple)
-{
-	tuple->src.u.all = 0;
-	tuple->dst.u.all = 0;
-
-	return true;
-}
-
 /* Returns verdict for packet, or -1 for invalid. */
 static int generic_packet(struct nf_conn *ct,
 			  struct sk_buff *skb,
@@ -149,7 +139,6 @@ static struct nf_proto_net *generic_get_net_proto(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 {
 	.l4proto		= 255,
-	.pkt_to_tuple		= generic_pkt_to_tuple,
 	.packet			= generic_packet,
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 68f9bfb79c4e..04bc982b274d 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -162,8 +162,8 @@ EXPORT_SYMBOL_GPL(nf_ct_gre_keymap_destroy);
 /* PUBLIC CONNTRACK PROTO HELPER FUNCTIONS */
 
 /* gre hdr info to tuple */
-static bool gre_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
-			     struct net *net, struct nf_conntrack_tuple *tuple)
+bool gre_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+		      struct net *net, struct nf_conntrack_tuple *tuple)
 {
 	const struct pptp_gre_header *pgrehdr;
 	struct pptp_gre_header _pgrehdr;
@@ -368,7 +368,6 @@ static int gre_init_net(struct net *net)
 /* protocol helper struct */
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre = {
 	.l4proto	 = IPPROTO_GRE,
-	.pkt_to_tuple	 = gre_pkt_to_tuple,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack = gre_print_conntrack,
 #endif
-- 
2.11.0
