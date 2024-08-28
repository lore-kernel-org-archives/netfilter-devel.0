Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE641A76AD;
	Wed, 28 Aug 2024 21:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724881643; cv=none; b=XrWDEyNyYJB6QA+sJMBuW6g7A+T5bAAepJoL2d7qPoE3pmBUNRgnDleIxtkBws6fhGkeSamd+D2EFq4ZMkoGW7jYv8/nSHq1Hznzjq5XxmXL3Hhl8Zt7stCt1HUfkz/9b8ei49MYGatS58a8BIQInkAnmNyGedS5DtVjYOyZpww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724881643; c=relaxed/simple;
	bh=bdNuz7ZuoR5hbXBd1PTzWYI8PyfV2TKKLdKN4Zv/8G8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TLHSKgUdBB0ngoA22kNeDW1Xzp7gXVhgRp7J8fwWUUXNMpVis+aClmWBPUBXekm+qcBvxt9AE3VhY43TLnicJnQNT3FJ7f3IhL0BrDfw6D4D1SB5O3i7a+jycf+vVdtCSeEKKZT9vnJUxFEO34m04bFR6GiY0ql/5JnucXOqRvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 1/2] netfilter: nf_tables: restore IP sanity checks for netdev/egress
Date: Wed, 28 Aug 2024 23:47:07 +0200
Message-Id: <20240828214708.619261-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240828214708.619261-1-pablo@netfilter.org>
References: <20240828214708.619261-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Subtract network offset to skb->len before performing IPv4 header sanity
checks, then adjust transport offset from offset from mac header.

Jorge Ortiz says:

When small UDP packets (< 4 bytes payload) are sent from eth0,
`meta l4proto udp` condition is not met because `NFT_PKTINFO_L4PROTO` is
not set. This happens because there is a comparison that checks if the
transport header offset exceeds the total length.  This comparison does
not take into account the fact that the skb network offset might be
non-zero in egress mode (e.g., 14 bytes for Ethernet header).

Fixes: 0ae8e4cca787 ("netfilter: nf_tables: set transport offset from mac header for netdev/egress")
Reported-by: Jorge Ortiz <jorge.ortiz.escribano@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_ipv4.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index 60a7d0ce3080..fcf967286e37 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -19,7 +19,7 @@ static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt)
 static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 {
 	struct iphdr *iph, _iph;
-	u32 len, thoff;
+	u32 len, thoff, skb_len;
 
 	iph = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
 				 sizeof(*iph), &_iph);
@@ -30,8 +30,10 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 		return -1;
 
 	len = iph_totlen(pkt->skb, iph);
-	thoff = skb_network_offset(pkt->skb) + (iph->ihl * 4);
-	if (pkt->skb->len < len)
+	thoff = iph->ihl * 4;
+	skb_len = pkt->skb->len - skb_network_offset(pkt->skb);
+
+	if (skb_len < len)
 		return -1;
 	else if (len < thoff)
 		return -1;
@@ -40,7 +42,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
-	pkt->thoff = thoff;
+	pkt->thoff = skb_network_offset(pkt->skb) + thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
 
 	return 0;
-- 
2.30.2

