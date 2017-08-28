From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: rt: account for tcp header size too
Date: Mon, 28 Aug 2017 17:00:12 +0200
Message-ID: <20170828150012.11287-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51322 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751411AbdH1O7y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 10:59:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This needs to accout for the ipv4/ipv6 header size and the tcp
header without options.

Fixes: 6b5dc98e8fac0 ("netfilter: rt: add support to fetch path mss")
Reported-by: Matteo Croce <technoboy85@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_rt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index e142e65d3176..8a49b5b54ede 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -35,10 +35,11 @@ static u16 get_tcpmss(const struct nft_pktinfo *pkt, const struct dst_entry *skb
 	switch (nft_pf(pkt)) {
 	case NFPROTO_IPV4:
 		fl.u.ip4.daddr = ip_hdr(skb)->saddr;
-		minlen = sizeof(struct iphdr);
+		minlen = sizeof(struct iphdr) + sizeof(struct tcphdr);
 		break;
 	case NFPROTO_IPV6:
 		fl.u.ip6.daddr = ipv6_hdr(skb)->saddr;
+		minlen = sizeof(struct ipv6hdr) + sizeof(struct tcphdr);
 		break;
 	}
 
-- 
2.13.0

