From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] netfilter: nf_tables: Add bridge interface physical index and name
Date: Fri,  5 Sep 2014 12:44:48 +0200
Message-ID: <1409913888-5145-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61106 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbaIEKmZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:42:25 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so11483508wgh.27
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Sep 2014 03:42:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This  allows us to match the packets that enter or leave through a
bridge physical interface by name or index.

This reuses the NFT_META_IIFNAME, NFT_META_OIFNAME, NFT_META_IIF and
NFT_META_OIF labels. In the bridge context, these labels have a special
meaning. The kernel chooses the behaviour depending on the family.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 net/bridge/netfilter/nft_meta_bridge.c |   36 +++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 4f02109..247c0ef 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -26,21 +26,51 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 	const struct net_device *in = pkt->in, *out = pkt->out;
 	struct nft_data *dest = &data[priv->dreg];
 	const struct net_bridge_port *p;
+	struct nf_bridge_info *nf_bridge;
 
 	switch (priv->key) {
 	case NFT_META_BRI_IIFNAME:
 		if (in == NULL || (p = br_port_get_rcu(in)) == NULL)
 			goto err;
+		strncpy((char *)dest->data, p->br->dev->name,
+			sizeof(dest->data));
 		break;
 	case NFT_META_BRI_OIFNAME:
 		if (out == NULL || (p = br_port_get_rcu(out)) == NULL)
 			goto err;
+		strncpy((char *)dest->data, p->br->dev->name,
+			sizeof(dest->data));
+		break;
+	case NFT_META_IIF:
+		nf_bridge = pkt->skb->nf_bridge;
+		if (nf_bridge == NULL || nf_bridge->physindev == NULL)
+			goto err;
+		dest->data[0] = nf_bridge->physindev->ifindex;
+		break;
+	case NFT_META_OIF:
+		nf_bridge = pkt->skb->nf_bridge;
+		if (nf_bridge == NULL || nf_bridge->physoutdev == NULL)
+			goto err;
+		dest->data[0] = nf_bridge->physoutdev->ifindex;
+		break;
+	case NFT_META_IIFNAME:
+		nf_bridge = pkt->skb->nf_bridge;
+		if (nf_bridge == NULL || nf_bridge->physindev == NULL)
+			goto err;
+		strncpy((char *)dest->data, nf_bridge->physindev->name,
+			sizeof(dest->data));
+		break;
+	case NFT_META_OIFNAME:
+		nf_bridge = pkt->skb->nf_bridge;
+		if (nf_bridge == NULL || nf_bridge->physoutdev == NULL)
+			goto err;
+		strncpy((char *)dest->data, nf_bridge->physoutdev->name,
+			sizeof(dest->data));
 		break;
 	default:
 		goto out;
 	}
 
-	strncpy((char *)dest->data, p->br->dev->name, sizeof(dest->data));
 	return;
 out:
 	return nft_meta_get_eval(expr, data, pkt);
@@ -59,6 +89,10 @@ static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
 	switch (priv->key) {
 	case NFT_META_BRI_IIFNAME:
 	case NFT_META_BRI_OIFNAME:
+	case NFT_META_IIF:
+	case NFT_META_OIF:
+	case NFT_META_IIFNAME:
+	case NFT_META_OIFNAME:
 		break;
 	default:
 		return nft_meta_get_init(ctx, expr, tb);
-- 
1.7.10.4

