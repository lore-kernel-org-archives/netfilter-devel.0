From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 24/47] netfilter: nft_ct: add NFT_CT_{SRC,DST}_{IP,IP6}
Date: Fri, 30 Mar 2018 13:43:11 +0200
Message-ID: <20180330114334.18664-5-pablo@netfilter.org>
References: <20180330114334.18664-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114334.18664-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

All existing keys, except the NFT_CT_SRC and NFT_CT_DST are assumed to
have strict datatypes. This is causing problems with sets and
concatenations given the specific length of these keys is not known.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h | 12 ++++++++--
 net/netfilter/nft_ct.c                   | 38 ++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 66dceee0ae30..6a3d653d5b27 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -909,8 +909,8 @@ enum nft_rt_attributes {
  * @NFT_CT_EXPIRATION: relative conntrack expiration time in ms
  * @NFT_CT_HELPER: connection tracking helper assigned to conntrack
  * @NFT_CT_L3PROTOCOL: conntrack layer 3 protocol
- * @NFT_CT_SRC: conntrack layer 3 protocol source (IPv4/IPv6 address)
- * @NFT_CT_DST: conntrack layer 3 protocol destination (IPv4/IPv6 address)
+ * @NFT_CT_SRC: conntrack layer 3 protocol source (IPv4/IPv6 address, deprecated)
+ * @NFT_CT_DST: conntrack layer 3 protocol destination (IPv4/IPv6 address, deprecated)
  * @NFT_CT_PROTOCOL: conntrack layer 4 protocol
  * @NFT_CT_PROTO_SRC: conntrack layer 4 protocol source
  * @NFT_CT_PROTO_DST: conntrack layer 4 protocol destination
@@ -920,6 +920,10 @@ enum nft_rt_attributes {
  * @NFT_CT_AVGPKT: conntrack average bytes per packet
  * @NFT_CT_ZONE: conntrack zone
  * @NFT_CT_EVENTMASK: ctnetlink events to be generated for this conntrack
+ * @NFT_CT_SRC_IP: conntrack layer 3 protocol source (IPv4 address)
+ * @NFT_CT_DST_IP: conntrack layer 3 protocol destination (IPv4 address)
+ * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
+ * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -941,6 +945,10 @@ enum nft_ct_keys {
 	NFT_CT_AVGPKT,
 	NFT_CT_ZONE,
 	NFT_CT_EVENTMASK,
+	NFT_CT_SRC_IP,
+	NFT_CT_DST_IP,
+	NFT_CT_SRC_IP6,
+	NFT_CT_DST_IP6,
 };
 
 /**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 6ab274b14484..ea737fd789e8 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -196,6 +196,26 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	case NFT_CT_PROTO_DST:
 		nft_reg_store16(dest, (__force u16)tuple->dst.u.all);
 		return;
+	case NFT_CT_SRC_IP:
+		if (nf_ct_l3num(ct) != NFPROTO_IPV4)
+			goto err;
+		*dest = tuple->src.u3.ip;
+		return;
+	case NFT_CT_DST_IP:
+		if (nf_ct_l3num(ct) != NFPROTO_IPV4)
+			goto err;
+		*dest = tuple->dst.u3.ip;
+		return;
+	case NFT_CT_SRC_IP6:
+		if (nf_ct_l3num(ct) != NFPROTO_IPV6)
+			goto err;
+		memcpy(dest, tuple->src.u3.ip6, sizeof(struct in6_addr));
+		return;
+	case NFT_CT_DST_IP6:
+		if (nf_ct_l3num(ct) != NFPROTO_IPV6)
+			goto err;
+		memcpy(dest, tuple->dst.u3.ip6, sizeof(struct in6_addr));
+		return;
 	default:
 		break;
 	}
@@ -419,6 +439,20 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 			return -EAFNOSUPPORT;
 		}
 		break;
+	case NFT_CT_SRC_IP:
+	case NFT_CT_DST_IP:
+		if (tb[NFTA_CT_DIRECTION] == NULL)
+			return -EINVAL;
+
+		len = FIELD_SIZEOF(struct nf_conntrack_tuple, src.u3.ip);
+		break;
+	case NFT_CT_SRC_IP6:
+	case NFT_CT_DST_IP6:
+		if (tb[NFTA_CT_DIRECTION] == NULL)
+			return -EINVAL;
+
+		len = FIELD_SIZEOF(struct nf_conntrack_tuple, src.u3.ip6);
+		break;
 	case NFT_CT_PROTO_SRC:
 	case NFT_CT_PROTO_DST:
 		if (tb[NFTA_CT_DIRECTION] == NULL)
@@ -588,6 +622,10 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	switch (priv->key) {
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
+	case NFT_CT_SRC_IP:
+	case NFT_CT_DST_IP:
+	case NFT_CT_SRC_IP6:
+	case NFT_CT_DST_IP6:
 	case NFT_CT_PROTO_SRC:
 	case NFT_CT_PROTO_DST:
 		if (nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
-- 
2.11.0
