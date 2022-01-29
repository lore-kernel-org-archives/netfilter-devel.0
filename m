Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E54C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Jan 2022 16:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbiA2QNc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Jan 2022 11:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240810AbiA2QNc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jan 2022 11:13:32 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38881C061714
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jan 2022 08:13:32 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nDqLx-0003Qb-Kd; Sat, 29 Jan 2022 17:13:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_payload: don't allow th access for fragments
Date:   Sat, 29 Jan 2022 17:13:23 +0100
Message-Id: <20220129161323.173737-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Loads relative to ->thoff naturally expect that this points to the
transport header, but this is only true if pkt->fragoff == 0.

This has little effect for rulesets with connection tracking/nat because
these enable ip defra. For other rulesets this prevents false matches.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_exthdr.c  | 2 +-
 net/netfilter/nft_payload.c | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index dbe1f2e7dd9e..9e927ab4df15 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -167,7 +167,7 @@ nft_tcp_header_pointer(const struct nft_pktinfo *pkt,
 {
 	struct tcphdr *tcph;
 
-	if (pkt->tprot != IPPROTO_TCP)
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
 		return NULL;
 
 	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(*tcph), buffer);
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 940fed9a760b..5cc06aef4345 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -83,7 +83,7 @@ static int __nft_payload_inner_offset(struct nft_pktinfo *pkt)
 {
 	unsigned int thoff = nft_thoff(pkt);
 
-	if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+	if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 		return -1;
 
 	switch (pkt->tprot) {
@@ -147,7 +147,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
@@ -688,7 +688,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
@@ -728,7 +728,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	if (priv->csum_type == NFT_PAYLOAD_CSUM_SCTP &&
 	    pkt->tprot == IPPROTO_SCTP &&
 	    skb->ip_summed != CHECKSUM_PARTIAL) {
-		if (nft_payload_csum_sctp(skb, nft_thoff(pkt)))
+		if (pkt->fragoff == 0 &&
+		    nft_payload_csum_sctp(skb, nft_thoff(pkt)))
 			goto err;
 	}
 
-- 
2.34.1

