From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 5/6] netfilter: nf_tables: add nfproto support to meta expression
Date: Fri,  3 Jan 2014 12:16:17 +0000
Message-ID: <1388751378-23272-6-git-send-email-kaber@trash.net>
References: <1388751378-23272-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56528 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaACMQ2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 07:16:28 -0500
In-Reply-To: <1388751378-23272-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Needed by multi-family tables to distinguish IPv4 and IPv6 packets.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_meta.c                 | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index fbfd229..7ec92a9 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -529,6 +529,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_NFTRACE: packet nftrace bit
  * @NFT_META_RTCLASSID: realm value of packet's route (skb->dst->tclassid)
  * @NFT_META_SECMARK: packet secmark (skb->secmark)
+ * @NFT_META_NFPROTO: netfilter protocol
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -546,6 +547,7 @@ enum nft_meta_keys {
 	NFT_META_NFTRACE,
 	NFT_META_RTCLASSID,
 	NFT_META_SECMARK,
+	NFT_META_NFPROTO,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8c28220..06a4f30 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -40,6 +40,9 @@ static void nft_meta_eval(const struct nft_expr *expr,
 	case NFT_META_PROTOCOL:
 		*(__be16 *)dest->data = skb->protocol;
 		break;
+	case NFT_META_NFPROTO:
+		dest->data[0] = pkt->ops->pf;
+		break;
 	case NFT_META_PRIORITY:
 		dest->data[0] = skb->priority;
 		break;
@@ -151,6 +154,7 @@ static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	switch (priv->key) {
 	case NFT_META_LEN:
 	case NFT_META_PROTOCOL:
+	case NFT_META_NFPROTO:
 	case NFT_META_PRIORITY:
 	case NFT_META_MARK:
 	case NFT_META_IIF:
-- 
1.8.4.2

