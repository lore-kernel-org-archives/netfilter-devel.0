From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next] netfilter: NFQUEUE: don't xor src/dst ip address
Date: Mon,  4 Jun 2012 14:53:54 +0200
Message-ID: <1338814434-15130-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48142 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806Ab2FDMxF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:53:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

because reply packets need to go to the same nfqueue, src/dst ip
address were xor'd prior to jhash().

However, this causes bad distribution for some workloads, e.g.
flows a.b.1.{1,n} -> a.b.2.{1,n} all share the same hash value.

Avoid this by hashing both. To get same hash for replies,
first argument is the smaller address.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_NFQUEUE.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 95237c8..7babe7d 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -41,26 +41,36 @@ nfqueue_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static u32 hash_v4(const struct sk_buff *skb)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	__be32 ipaddr;
 
 	/* packets in either direction go into same queue */
-	ipaddr = iph->saddr ^ iph->daddr;
+	if (iph->saddr < iph->daddr)
+		return jhash_3words((__force u32)iph->saddr,
+			(__force u32)iph->daddr, iph->protocol, jhash_initval);
 
-	return jhash_2words((__force u32)ipaddr, iph->protocol, jhash_initval);
+	return jhash_3words((__force u32)iph->daddr,
+			(__force u32)iph->saddr, iph->protocol, jhash_initval);
 }
 
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static u32 hash_v6(const struct sk_buff *skb)
 {
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
-	__be32 addr[4];
+	u32 a, b, c;
+
+	if (ip6h->saddr.s6_addr32[3] < ip6h->daddr.s6_addr32[3]) {
+		a = (__force u32) ip6h->saddr.s6_addr32[3];
+		b = (__force u32) ip6h->daddr.s6_addr32[3];
+	} else {
+		b = (__force u32) ip6h->saddr.s6_addr32[3];
+		a = (__force u32) ip6h->daddr.s6_addr32[3];
+	}
 
-	addr[0] = ip6h->saddr.s6_addr32[0] ^ ip6h->daddr.s6_addr32[0];
-	addr[1] = ip6h->saddr.s6_addr32[1] ^ ip6h->daddr.s6_addr32[1];
-	addr[2] = ip6h->saddr.s6_addr32[2] ^ ip6h->daddr.s6_addr32[2];
-	addr[3] = ip6h->saddr.s6_addr32[3] ^ ip6h->daddr.s6_addr32[3];
+	if (ip6h->saddr.s6_addr32[1] < ip6h->daddr.s6_addr32[1])
+		c = (__force u32) ip6h->saddr.s6_addr32[1];
+	else
+		c = (__force u32) ip6h->daddr.s6_addr32[1];
 
-	return jhash2((__force u32 *)addr, ARRAY_SIZE(addr), jhash_initval);
+	return jhash_3words(a, b, c, jhash_initval);
 }
 #endif
 
-- 
1.7.3.4

