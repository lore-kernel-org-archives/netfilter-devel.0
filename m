Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7D3C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Oct 2022 22:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJNWVG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Oct 2022 18:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJNWVF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2022 18:21:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74348474D6
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2022 15:21:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ojT32-00049h-Dg; Sat, 15 Oct 2022 00:20:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: reduce nft_pktinfo by 8 bytes
Date:   Sat, 15 Oct 2022 00:20:50 +0200
Message-Id: <20221014222050.26304-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

structure is reduced from 32 to 24 bytes.  While at it, also check
that iphdrlen is sane, this is guaranteed for NFPROTO_IPV4 but not
for ingress or bridge, so add checks for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h      | 4 ++--
 include/net/netfilter/nf_tables_ipv4.h | 4 ++++
 include/net/netfilter/nf_tables_ipv6.h | 6 +++---
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cdb7db9b0e25..f6db510689a8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -32,8 +32,8 @@ struct nft_pktinfo {
 	u8				flags;
 	u8				tprot;
 	u16				fragoff;
-	unsigned int			thoff;
-	unsigned int			inneroff;
+	u16				thoff;
+	u16				inneroff;
 };
 
 static inline struct sock *nft_sk(const struct nft_pktinfo *pkt)
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index c4a6147b0ef8..112708f7a6b4 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -35,6 +35,8 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 		return -1;
 	else if (len < thoff)
 		return -1;
+	else if (thoff < sizeof(*iph))
+		return -1;
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
@@ -69,6 +71,8 @@ static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 		return -1;
 	} else if (len < thoff) {
 		goto inhdr_error;
+	} else if (thoff < sizeof(*iph)) {
+		return -1;
 	}
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index ec7eaeaf4f04..467d59b9e533 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -13,7 +13,7 @@ static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt)
 	unsigned short frag_off;
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
-	if (protohdr < 0) {
+	if (protohdr < 0 || thoff > U16_MAX) {
 		nft_set_pktinfo_unspec(pkt);
 		return;
 	}
@@ -47,7 +47,7 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 		return -1;
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
-	if (protohdr < 0)
+	if (protohdr < 0 || thoff > U16_MAX)
 		return -1;
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
@@ -93,7 +93,7 @@ static inline int nft_set_pktinfo_ipv6_ingress(struct nft_pktinfo *pkt)
 	}
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
-	if (protohdr < 0)
+	if (protohdr < 0 || thoff > U16_MAX)
 		goto inhdr_error;
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
-- 
2.37.3

