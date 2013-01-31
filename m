From: pablo@netfilter.org
Subject: [nftables 8/9] netfilter: nf_tables: add missing code in route chain type
Date: Thu, 31 Jan 2013 01:04:04 +0100
Message-ID: <1359590645-4703-8-git-send-email-pablo@netfilter.org>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:37386 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3AaAEf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:04:35 -0500
In-Reply-To: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Add missing code for the route chain type based on the mangle
table code from x_tables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nft_chain_route_ipv4.c |   24 +++++++++++++++++++++---
 net/ipv6/netfilter/nft_chain_route_ipv6.c |   24 +++++++++++++++++++-----
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/nft_chain_route_ipv4.c b/net/ipv4/netfilter/nft_chain_route_ipv4.c
index f991eb0..4b4fd08 100644
--- a/net/ipv4/netfilter/nft_chain_route_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_route_ipv4.c
@@ -29,15 +29,33 @@ static unsigned int nf_route_table_hook(const struct nf_hook_ops *ops,
 	unsigned int ret;
 	struct nft_pktinfo pkt;
 	u32 mark;
+	__be32 saddr, daddr;
+	u_int8_t tos;
+	const struct iphdr *iph;
 
 	nft_set_pktinfo_ipv4(&pkt, ops, skb, in, out);
 
-	// FIXME: length validation
+	/* root is playing with raw sockets. */
+	if (skb->len < sizeof(struct iphdr) ||
+	    ip_hdrlen(skb) < sizeof(struct iphdr))
+		return NF_ACCEPT;
+
 	mark = skb->mark;
+	iph = ip_hdr(skb);
+	saddr = iph->saddr;
+	daddr = iph->daddr;
+	tos = iph->tos;
+
 	ret = nft_do_chain_pktinfo(&pkt, ops);
 	if (ret != NF_DROP && ret != NF_QUEUE) {
-		if (skb->mark != mark && ip_route_me_harder(skb, RTN_UNSPEC))
-			ret = NF_DROP;
+		iph = ip_hdr(skb);
+
+		if (iph->saddr != saddr ||
+		    iph->daddr != daddr ||
+		    skb->mark != mark ||
+		    iph->tos != tos)
+			if (ip_route_me_harder(skb, RTN_UNSPEC))
+				ret = NF_DROP;
 	}
 	return ret;
 }
diff --git a/net/ipv6/netfilter/nft_chain_route_ipv6.c b/net/ipv6/netfilter/nft_chain_route_ipv6.c
index 341b3a8..c70d2de 100644
--- a/net/ipv6/netfilter/nft_chain_route_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_route_ipv6.c
@@ -30,17 +30,31 @@ static unsigned int nf_route_table_hook(const struct nf_hook_ops *ops,
 {
 	unsigned int ret;
 	struct nft_pktinfo pkt;
-	u32 mark;
+	struct in6_addr saddr, daddr;
+	u_int8_t hop_limit;
+	u32 mark, flowlabel;
 
 	if (nft_set_pktinfo_ipv6(&pkt, ops, skb, in, out) < 0)
 		return NF_DROP;
 
+	/* save source/dest address, mark, hoplimit, flowlabel, priority */
+	memcpy(&saddr, &ipv6_hdr(skb)->saddr, sizeof(saddr));
+	memcpy(&daddr, &ipv6_hdr(skb)->daddr, sizeof(daddr));
 	mark = skb->mark;
+	hop_limit = ipv6_hdr(skb)->hop_limit;
+
+	/* flowlabel and prio (includes version, which shouldn't change either */
+	flowlabel = *((u32 *)ipv6_hdr(skb));
+
 	ret = nft_do_chain_pktinfo(&pkt, ops);
-	if (ret != NF_DROP && ret != NF_QUEUE) {
-		if (skb->mark != mark && ip6_route_me_harder(skb))
-			ret = NF_DROP;
-	}
+	if (ret != NF_DROP && ret != NF_QUEUE &&
+	    (memcmp(&ipv6_hdr(skb)->saddr, &saddr, sizeof(saddr)) ||
+	     memcmp(&ipv6_hdr(skb)->daddr, &daddr, sizeof(daddr)) ||
+	     skb->mark != mark ||
+	     ipv6_hdr(skb)->hop_limit != hop_limit ||
+	     flowlabel != *((u_int32_t *)ipv6_hdr(skb))))
+		return ip6_route_me_harder(skb) == 0 ? ret : NF_DROP;
+
 	return ret;
 }
 
-- 
1.7.10.4

