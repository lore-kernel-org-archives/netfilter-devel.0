Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D360C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43D19610F8
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhJ1MSH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:18:07 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50558 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhJ1MSG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:18:06 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 325D863ED7
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Oct 2021 14:13:49 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1] netfilter: nft_payload: support for inner header matching / mangling
Date:   Thu, 28 Oct 2021 14:15:33 +0200
Message-Id: <20211028121533.146010-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow to match and mangle on inner headers from the transport payload
offset. There is a new field in the pktinfo structure that stores this
offset which is calculated only when requested.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  4 +-
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/netfilter/nft_payload.c              | 48 +++++++++++++++++++++++-
 3 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a16171c5fd9e..6eae61a026f8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -24,10 +24,12 @@ struct module;
 struct nft_pktinfo {
 	struct sk_buff			*skb;
 	const struct nf_hook_state	*state;
-	bool				tprot_set;
+	u8				tprot_set:1,
+					inner_set:1;
 	u8				tprot;
 	u16				fragoff;
 	unsigned int			thoff;
+	unsigned int			inneroff;
 };
 
 static inline struct sock *nft_sk(const struct nft_pktinfo *pkt)
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 08db4ee06ab6..466fd3f4447c 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -753,11 +753,13 @@ enum nft_dynset_attributes {
  * @NFT_PAYLOAD_LL_HEADER: link layer header
  * @NFT_PAYLOAD_NETWORK_HEADER: network header
  * @NFT_PAYLOAD_TRANSPORT_HEADER: transport header
+ * @NFT_PAYLOAD_INNER_HEADER: inner header / payload
  */
 enum nft_payload_bases {
 	NFT_PAYLOAD_LL_HEADER,
 	NFT_PAYLOAD_NETWORK_HEADER,
 	NFT_PAYLOAD_TRANSPORT_HEADER,
+	NFT_PAYLOAD_INNER_HEADER,
 };
 
 /**
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a44b14f6c0dc..cb038b71bc03 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -22,6 +22,7 @@
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/ip.h>
 #include <net/sctp/checksum.h>
 
 static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
@@ -79,6 +80,32 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 	return skb_copy_bits(skb, offset + mac_off, dst_u8, len) == 0;
 }
 
+static int nft_payload_inner_offset(struct nft_pktinfo *pkt)
+{
+	switch (pkt->tprot) {
+	case IPPROTO_UDP:
+		pkt->inneroff = pkt->thoff + sizeof(struct udphdr);
+		break;
+	case IPPROTO_TCP: {
+		struct tcphdr *th, _tcph;
+
+		th = skb_header_pointer(pkt->skb, pkt->thoff, sizeof(_tcph),
+					&_tcph);
+		if (!th)
+			return -1;
+
+		pkt->inneroff = pkt->thoff + (th->doff * 4);
+		break;
+	}
+	default:
+		return -1;
+	}
+
+	pkt->inner_set = 1;
+
+	return 0;
+}
+
 void nft_payload_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs,
 		      const struct nft_pktinfo *pkt)
@@ -112,6 +139,16 @@ void nft_payload_eval(const struct nft_expr *expr,
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
+	case NFT_PAYLOAD_INNER_HEADER:
+		if (!pkt->tprot_set)
+			goto err;
+
+		if (!pkt->inner_set &&
+		    nft_payload_inner_offset((struct nft_pktinfo *)pkt) < 0)
+			goto err;
+
+		offset = pkt->inneroff;
+		break;
 	default:
 		BUG();
 	}
@@ -614,6 +651,13 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
+	case NFT_PAYLOAD_INNER_HEADER:
+		if (!pkt->inner_set &&
+		    nft_payload_inner_offset((struct nft_pktinfo *)pkt) < 0)
+			goto err;
+
+		offset = pkt->inneroff;
+		break;
 	default:
 		BUG();
 	}
@@ -622,7 +666,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	offset += priv->offset;
 
 	if ((priv->csum_type == NFT_PAYLOAD_CSUM_INET || priv->csum_flags) &&
-	    (priv->base != NFT_PAYLOAD_TRANSPORT_HEADER ||
+	    ((priv->base != NFT_PAYLOAD_TRANSPORT_HEADER &&
+	      priv->base != NFT_PAYLOAD_INNER_HEADER) ||
 	     skb->ip_summed != CHECKSUM_PARTIAL)) {
 		fsum = skb_checksum(skb, offset, priv->len, 0);
 		tsum = csum_partial(src, priv->len, 0);
@@ -741,6 +786,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	case NFT_PAYLOAD_LL_HEADER:
 	case NFT_PAYLOAD_NETWORK_HEADER:
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
+	case NFT_PAYLOAD_INNER_HEADER:
 		break;
 	default:
 		return ERR_PTR(-EOPNOTSUPP);
-- 
2.30.2

