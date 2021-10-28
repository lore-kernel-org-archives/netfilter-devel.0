Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C3FC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Oct 2021 20:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B04860FE3
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Oct 2021 20:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhJ1Uvh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 16:51:37 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51534 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbhJ1Uvh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 16:51:37 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AF80263EE1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Oct 2021 22:47:19 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/2,v2] netfilter: nf_tables: convert pktinfo->tprot_set to flags field
Date:   Thu, 28 Oct 2021 22:49:00 +0200
Message-Id: <20211028204901.2183-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Generalize boolean field to store more flags on the pktinfo structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: first time in this series

 include/net/netfilter/nf_tables.h      | 8 ++++++--
 include/net/netfilter/nf_tables_ipv4.h | 8 ++++----
 include/net/netfilter/nf_tables_ipv6.h | 8 ++++----
 net/netfilter/nf_tables_core.c         | 2 +-
 net/netfilter/nf_tables_trace.c        | 4 ++--
 net/netfilter/nft_meta.c               | 2 +-
 net/netfilter/nft_payload.c            | 4 ++--
 7 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a16171c5fd9e..7e3188cf4a7d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -21,10 +21,14 @@ struct module;
 
 #define NFT_JUMP_STACK_SIZE	16
 
+enum {
+	NFT_PKTINFO_L4PROTO	= (1 << 0),
+};
+
 struct nft_pktinfo {
 	struct sk_buff			*skb;
 	const struct nf_hook_state	*state;
-	bool				tprot_set;
+	u8				flags;
 	u8				tprot;
 	u16				fragoff;
 	unsigned int			thoff;
@@ -75,7 +79,7 @@ static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 
 static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt)
 {
-	pkt->tprot_set = false;
+	pkt->flags = 0;
 	pkt->tprot = 0;
 	pkt->thoff = 0;
 	pkt->fragoff = 0;
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index 6e7ec1e6b5e5..6e2933d7e748 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -10,7 +10,7 @@ static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt)
 	struct iphdr *ip;
 
 	ip = ip_hdr(pkt->skb);
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = ip->protocol;
 	pkt->thoff = ip_hdrlen(pkt->skb);
 	pkt->fragoff = ntohs(ip->frag_off) & IP_OFFSET;
@@ -36,7 +36,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 	else if (len < thoff)
 		return -1;
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
 	pkt->thoff = thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
@@ -71,7 +71,7 @@ static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 		goto inhdr_error;
 	}
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
 	pkt->thoff = thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
@@ -104,7 +104,7 @@ static inline int nft_set_pktinfo_ipv4_egress(struct nft_pktinfo *pkt)
 		goto inhdr_error;
 	}
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
 	pkt->thoff = thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index 35a67fee94b2..a15c5df85847 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -18,7 +18,7 @@ static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt)
 		return;
 	}
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
@@ -50,7 +50,7 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 	if (protohdr < 0)
 		return -1;
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
@@ -96,7 +96,7 @@ static inline int nft_set_pktinfo_ipv6_ingress(struct nft_pktinfo *pkt)
 	if (protohdr < 0)
 		goto inhdr_error;
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
@@ -141,7 +141,7 @@ static inline int nft_set_pktinfo_ipv6_egress(struct nft_pktinfo *pkt)
 	if (protohdr < 0)
 		goto inhdr_error;
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 866cfba04d6c..adc348056076 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -79,7 +79,7 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	if (priv->base == NFT_PAYLOAD_NETWORK_HEADER)
 		ptr = skb_network_header(skb);
 	else {
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			return false;
 		ptr = skb_network_header(skb) + nft_thoff(pkt);
 	}
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index e4fe2f0780eb..84a7dea46efa 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -113,13 +113,13 @@ static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
 	int off = skb_network_offset(skb);
 	unsigned int len, nh_end;
 
-	nh_end = pkt->tprot_set ? nft_thoff(pkt) : skb->len;
+	nh_end = pkt->flags & NFT_PKTINFO_L4PROTO ? nft_thoff(pkt) : skb->len;
 	len = min_t(unsigned int, nh_end - skb_network_offset(skb),
 		    NFT_TRACETYPE_NETWORK_HSIZE);
 	if (trace_fill_header(nlskb, NFTA_TRACE_NETWORK_HEADER, skb, off, len))
 		return -1;
 
-	if (pkt->tprot_set) {
+	if (pkt->flags & NFT_PKTINFO_L4PROTO) {
 		len = min_t(unsigned int, skb->len - nft_thoff(pkt),
 			    NFT_TRACETYPE_TRANSPORT_HSIZE);
 		if (trace_fill_header(nlskb, NFTA_TRACE_TRANSPORT_HEADER, skb,
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index f2d7f0ef0773..1df5b7376390 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -333,7 +333,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_reg_store8(dest, nft_pf(pkt));
 		break;
 	case NFT_META_L4PROTO:
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			goto err;
 		nft_reg_store8(dest, pkt->tprot);
 		break;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a44b14f6c0dc..d1cd6583ee00 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -108,7 +108,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
@@ -610,7 +610,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
-- 
2.30.2

