From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/9] netfilter: nft_ct: add zone id get support
Date: Fri,  3 Feb 2017 13:35:48 +0100
Message-ID: <20170203123556.17357-2-fw@strlen.de>
References: <20170203123556.17357-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41956 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752700AbdBCMfm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 07:35:42 -0500
In-Reply-To: <20170203123556.17357-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just like with counters the direction attribute is optional.
We set priv->dir to MAX unconditionally to avoid duplicating the assignment
for all keys with optional direction.

For keys where direction is mandatory, existing code already returns
an error.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_ct.c                   | 22 +++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index b00a05d1ee56..b972e72623c2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -864,6 +864,7 @@ enum nft_rt_attributes {
  * @NFT_CT_PKTS: conntrack packets
  * @NFT_CT_BYTES: conntrack bytes
  * @NFT_CT_AVGPKT: conntrack average bytes per packet
+ * @NFT_CT_ZONE: conntrack zone
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -883,6 +884,7 @@ enum nft_ct_keys {
 	NFT_CT_PKTS,
 	NFT_CT_BYTES,
 	NFT_CT_AVGPKT,
+	NFT_CT_ZONE,
 };
 
 /**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 66a2377510e1..5bd4cdfdcda5 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -151,6 +151,18 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	case NFT_CT_PROTOCOL:
 		*dest = nf_ct_protonum(ct);
 		return;
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	case NFT_CT_ZONE: {
+		const struct nf_conntrack_zone *zone = nf_ct_zone(ct);
+
+		if (priv->dir < IP_CT_DIR_MAX)
+			*dest = nf_ct_zone_id(zone, priv->dir);
+		else
+			*dest = zone->id;
+
+		return;
+	}
+#endif
 	default:
 		break;
 	}
@@ -266,6 +278,7 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 	int err;
 
 	priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
+	priv->dir = IP_CT_DIR_MAX;
 	switch (priv->key) {
 	case NFT_CT_DIRECTION:
 		if (tb[NFTA_CT_DIRECTION] != NULL)
@@ -333,11 +346,13 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 	case NFT_CT_BYTES:
 	case NFT_CT_PKTS:
 	case NFT_CT_AVGPKT:
-		/* no direction? return sum of original + reply */
-		if (tb[NFTA_CT_DIRECTION] == NULL)
-			priv->dir = IP_CT_DIR_MAX;
 		len = sizeof(u64);
 		break;
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	case NFT_CT_ZONE:
+		len = sizeof(u16);
+		break;
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -465,6 +480,7 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	case NFT_CT_BYTES:
 	case NFT_CT_PKTS:
 	case NFT_CT_AVGPKT:
+	case NFT_CT_ZONE:
 		if (priv->dir < IP_CT_DIR_MAX &&
 		    nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
 			goto nla_put_failure;
-- 
2.10.2

