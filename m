From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 28/33] netfilter: conntrack: fix bogus port values for other l4 protocols
Date: Tue, 29 Jan 2019 00:57:45 +0100
Message-ID: <20190128235750.18412-29-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We must only extract l4 proto information if we can track the layer 4
protocol.

Before removal of pkt_to_tuple callback, the code to extract port
information was only reached for TCP/UDP/LITE/DCCP/SCTP.

The other protocols were handled by the indirect call, and the
'generic' tracker took care of other protocols that have no notion
of 'ports'.

After removal of the callback we must be more strict here and only
init port numbers for those protocols that have ports.

Fixes: df5e1629087a ("netfilter: conntrack: remove pkt_to_tuple callback")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 46 +++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a3e5232c2088..815956ac5a76 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -222,6 +222,24 @@ static u32 hash_conntrack(const struct net *net,
 	return scale_hash(hash_conntrack_raw(tuple, net));
 }
 
+static bool nf_ct_get_tuple_ports(const struct sk_buff *skb,
+				  unsigned int dataoff,
+				  struct nf_conntrack_tuple *tuple)
+{	struct {
+		__be16 sport;
+		__be16 dport;
+	} _inet_hdr, *inet_hdr;
+
+	/* Actually only need first 4 bytes to get ports. */
+	inet_hdr = skb_header_pointer(skb, dataoff, sizeof(_inet_hdr), &_inet_hdr);
+	if (!inet_hdr)
+		return false;
+
+	tuple->src.u.udp.port = inet_hdr->sport;
+	tuple->dst.u.udp.port = inet_hdr->dport;
+	return true;
+}
+
 static bool
 nf_ct_get_tuple(const struct sk_buff *skb,
 		unsigned int nhoff,
@@ -234,10 +252,6 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 	unsigned int size;
 	const __be32 *ap;
 	__be32 _addrs[8];
-	struct {
-		__be16 sport;
-		__be16 dport;
-	} _inet_hdr, *inet_hdr;
 
 	memset(tuple, 0, sizeof(*tuple));
 
@@ -284,15 +298,25 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 	case IPPROTO_GRE:
 		return gre_pkt_to_tuple(skb, dataoff, net, tuple);
 #endif
+	case IPPROTO_TCP:
+	case IPPROTO_UDP: /* fallthrough */
+		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
+#ifdef CONFIG_NF_CT_PROTO_UDPLITE
+	case IPPROTO_UDPLITE:
+		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+	case IPPROTO_SCTP:
+		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+	case IPPROTO_DCCP:
+		return nf_ct_get_tuple_ports(skb, dataoff, tuple);
+#endif
+	default:
+		break;
 	}
 
-	/* Actually only need first 4 bytes to get ports. */
-	inet_hdr = skb_header_pointer(skb, dataoff, sizeof(_inet_hdr), &_inet_hdr);
-	if (!inet_hdr)
-		return false;
-
-	tuple->src.u.udp.port = inet_hdr->sport;
-	tuple->dst.u.udp.port = inet_hdr->dport;
 	return true;
 }
 
-- 
2.11.0
