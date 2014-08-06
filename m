From: Valentina Giusti <valentina.giusti@microon.de>
Subject: [PATCH 1/3] netfilter: nft_meta: add attribute to match cpu handling the packet
Date: Wed,  6 Aug 2014 23:59:50 +0200
Message-ID: <1407362392-24837-2-git-send-email-valentina.giusti@microon.de>
References: <1407362392-24837-1-git-send-email-valentina.giusti@microon.de>
To: coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:54652 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753378AbaHFWGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:06:13 -0400
In-Reply-To: <1407362392-24837-1-git-send-email-valentina.giusti@microon.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_meta.c                 | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 801bdd1..0570284 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -571,6 +571,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_L4PROTO: layer 4 protocol number
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
+ * @NFT_META_CPU: cpu handling the packet
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -592,6 +593,7 @@ enum nft_meta_keys {
 	NFT_META_L4PROTO,
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
+	NFT_META_CPU,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 852b178..b99f714 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -124,6 +124,9 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		dest->data[0] = skb->secmark;
 		break;
 #endif
+	case NFT_META_CPU:
+		dest->data[0] = smp_processor_id();
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -195,6 +198,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
 #endif
+	case NFT_META_CPU:
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.0.0.rc2

