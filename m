Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52D3C2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 933F9206E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfL3LWD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:22:03 -0500
Received: from correo.us.es ([193.147.175.20]:59262 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727448AbfL3LWC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:22:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2C1214DE724
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:22:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DD8BDA71F
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:22:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 13796DA79C; Mon, 30 Dec 2019 12:22:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA8A5DA71F;
        Mon, 30 Dec 2019 12:21:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:21:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 38D6241E4800;
        Mon, 30 Dec 2019 12:21:58 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/17] netfilter: nft_meta: move pkttype handling to helper
Date:   Mon, 30 Dec 2019 12:21:36 +0100
Message-Id: <20191230112143.121708-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When pkttype is loopback, nft_meta performs guesswork to detect
broad/multicast packets. Place this in a helper, this is hardly a hot path.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 90 +++++++++++++++++++++++++++---------------------
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
2.11.0

