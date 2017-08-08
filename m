From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/4] netfilter: exthdr: factor out tcp option access
Date: Tue,  8 Aug 2017 15:15:27 +0200
Message-ID: <20170808131530.29194-2-fw@strlen.de>
References: <20170808131530.29194-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34482 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751925AbdHHNPP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2017 09:15:15 -0400
In-Reply-To: <20170808131530.29194-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_exthdr.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 1ec49fe5845f..921c95f2c583 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -61,6 +61,26 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static void *
+nft_tcp_header_pointer(const struct nft_pktinfo *pkt,
+		       unsigned int len, void *buffer, unsigned int *tcphdr_len)
+{
+	struct tcphdr *tcph;
+
+	if (!pkt->tprot_set || pkt->tprot != IPPROTO_TCP)
+		return NULL;
+
+	tcph = skb_header_pointer(pkt->skb, pkt->xt.thoff, sizeof(*tcph), buffer);
+	if (!tcph)
+		return NULL;
+
+	*tcphdr_len = __tcp_hdrlen(tcph);
+	if (*tcphdr_len < sizeof(*tcph) || *tcphdr_len > len)
+		return NULL;
+
+	return skb_header_pointer(pkt->skb, pkt->xt.thoff, *tcphdr_len, buffer);
+}
+
 static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
 				struct nft_regs *regs,
 				const struct nft_pktinfo *pkt)
@@ -72,18 +92,7 @@ static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
 	struct tcphdr *tcph;
 	u8 *opt;
 
-	if (!pkt->tprot_set || pkt->tprot != IPPROTO_TCP)
-		goto err;
-
-	tcph = skb_header_pointer(pkt->skb, pkt->xt.thoff, sizeof(*tcph), buff);
-	if (!tcph)
-		goto err;
-
-	tcphdr_len = __tcp_hdrlen(tcph);
-	if (tcphdr_len < sizeof(*tcph))
-		goto err;
-
-	tcph = skb_header_pointer(pkt->skb, pkt->xt.thoff, tcphdr_len, buff);
+	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
 	if (!tcph)
 		goto err;
 
-- 
2.13.0

