Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C566DC2D0CD
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A7221D7D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfLRLFj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 06:05:39 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35976 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726674AbfLRLFi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 06:05:38 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihX96-00077W-Fe; Wed, 18 Dec 2019 12:05:36 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/9] netfilter: nft_meta: move pkttype handling to helper
Date:   Wed, 18 Dec 2019 12:05:14 +0100
Message-Id: <20191218110521.14048-3-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218110521.14048-1-fw@strlen.de>
References: <20191218110521.14048-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When pkttype is loopback, nft_meta performs guesswork to detect
broad/multicast packets. Place this in a helper, this is hardly a hot path.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_meta.c | 90 +++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ba74f3ee7264..fe49b27dfa87 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -76,6 +76,56 @@ nft_meta_get_eval_time(enum nft_meta_keys key,
 	}
 }
 
+static noinline bool
+nft_meta_get_eval_pkttype_lo(const struct nft_pktinfo *pkt,
+			     u32 *dest)
+{
+	const struct sk_buff *skb = pkt->skb;
+
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		if (ipv4_is_multicast(ip_hdr(skb)->daddr))
+			nft_reg_store8(dest, PACKET_MULTICAST);
+		else
+			nft_reg_store8(dest, PACKET_BROADCAST);
+		break;
+	case NFPROTO_IPV6:
+		nft_reg_store8(dest, PACKET_MULTICAST);
+		break;
+	case NFPROTO_NETDEV:
+		switch (skb->protocol) {
+		case htons(ETH_P_IP): {
+			int noff = skb_network_offset(skb);
+			struct iphdr *iph, _iph;
+
+			iph = skb_header_pointer(skb, noff,
+						 sizeof(_iph), &_iph);
+			if (!iph)
+				return false;
+
+			if (ipv4_is_multicast(iph->daddr))
+				nft_reg_store8(dest, PACKET_MULTICAST);
+			else
+				nft_reg_store8(dest, PACKET_BROADCAST);
+
+			break;
+		}
+		case htons(ETH_P_IPV6):
+			nft_reg_store8(dest, PACKET_MULTICAST);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			return false;
+		}
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
+	return true;
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -183,46 +233,8 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			break;
 		}
 
-		switch (nft_pf(pkt)) {
-		case NFPROTO_IPV4:
-			if (ipv4_is_multicast(ip_hdr(skb)->daddr))
-				nft_reg_store8(dest, PACKET_MULTICAST);
-			else
-				nft_reg_store8(dest, PACKET_BROADCAST);
-			break;
-		case NFPROTO_IPV6:
-			nft_reg_store8(dest, PACKET_MULTICAST);
-			break;
-		case NFPROTO_NETDEV:
-			switch (skb->protocol) {
-			case htons(ETH_P_IP): {
-				int noff = skb_network_offset(skb);
-				struct iphdr *iph, _iph;
-
-				iph = skb_header_pointer(skb, noff,
-							 sizeof(_iph), &_iph);
-				if (!iph)
-					goto err;
-
-				if (ipv4_is_multicast(iph->daddr))
-					nft_reg_store8(dest, PACKET_MULTICAST);
-				else
-					nft_reg_store8(dest, PACKET_BROADCAST);
-
-				break;
-			}
-			case htons(ETH_P_IPV6):
-				nft_reg_store8(dest, PACKET_MULTICAST);
-				break;
-			default:
-				WARN_ON_ONCE(1);
-				goto err;
-			}
-			break;
-		default:
-			WARN_ON_ONCE(1);
+		if (!nft_meta_get_eval_pkttype_lo(pkt, dest))
 			goto err;
-		}
 		break;
 	case NFT_META_CPU:
 		*dest = raw_smp_processor_id();
-- 
2.24.1

