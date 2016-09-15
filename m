From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_queue: improve queue range support for bridge family
Date: Thu, 15 Sep 2016 20:50:16 +0800
Message-ID: <1473943816-26103-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:34200 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755773AbcIOMu7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Sep 2016 08:50:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

After commit ac2863445686 ("netfilter: bridge: add nf_afinfo to enable
queuing to userspace"), we can queue packets to the user space in bridge
family. But when the user specify the queue range, packets will be only
delivered to the first queue num. Because in nfqueue_hash, we only support
ipv4 and ipv6 family. Now add support for bridge family too.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 include/net/netfilter/nf_queue.h | 56 ++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index cc8a11f..903dca0 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -41,22 +41,19 @@ static inline void init_hashrandom(u32 *jhash_initval)
 		*jhash_initval = prandom_u32();
 }
 
-static inline u32 hash_v4(const struct sk_buff *skb, u32 jhash_initval)
+static inline u32 hash_v4(const struct iphdr *iph, u32 initval)
 {
-	const struct iphdr *iph = ip_hdr(skb);
-
 	/* packets in either direction go into same queue */
 	if ((__force u32)iph->saddr < (__force u32)iph->daddr)
 		return jhash_3words((__force u32)iph->saddr,
-			(__force u32)iph->daddr, iph->protocol, jhash_initval);
+			(__force u32)iph->daddr, iph->protocol, initval);
 
 	return jhash_3words((__force u32)iph->daddr,
-			(__force u32)iph->saddr, iph->protocol, jhash_initval);
+			(__force u32)iph->saddr, iph->protocol, initval);
 }
 
-static inline u32 hash_v6(const struct sk_buff *skb, u32 jhash_initval)
+static inline u32 hash_v6(const struct ipv6hdr *ip6h, u32 initval)
 {
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	u32 a, b, c;
 
 	if ((__force u32)ip6h->saddr.s6_addr32[3] <
@@ -74,17 +71,50 @@ static inline u32 hash_v6(const struct sk_buff *skb, u32 jhash_initval)
 	else
 		c = (__force u32) ip6h->daddr.s6_addr32[1];
 
-	return jhash_3words(a, b, c, jhash_initval);
+	return jhash_3words(a, b, c, initval);
+}
+
+static inline u32 hash_bridge(const struct sk_buff *skb, u32 initval)
+{
+	struct ipv6hdr *ip6h, _ip6h;
+	struct iphdr *iph, _iph;
+
+	switch (eth_hdr(skb)->h_proto) {
+	case htons(ETH_P_IP):
+		iph = skb_header_pointer(skb, skb_network_offset(skb),
+					 sizeof(*iph), &_iph);
+		if (iph)
+			return hash_v4(iph, initval);
+		break;
+	case htons(ETH_P_IPV6):
+		ip6h = skb_header_pointer(skb, skb_network_offset(skb),
+					  sizeof(*ip6h), &_ip6h);
+		if (ip6h)
+			return hash_v6(ip6h, initval);
+		break;
+	}
+
+	return 0;
 }
 
 static inline u32
 nfqueue_hash(const struct sk_buff *skb, u16 queue, u16 queues_total, u8 family,
-	     u32 jhash_initval)
+	     u32 initval)
 {
-	if (family == NFPROTO_IPV4)
-		queue += ((u64) hash_v4(skb, jhash_initval) * queues_total) >> 32;
-	else if (family == NFPROTO_IPV6)
-		queue += ((u64) hash_v6(skb, jhash_initval) * queues_total) >> 32;
+	switch (family) {
+	case NFPROTO_IPV4:
+		queue += reciprocal_scale(hash_v4(ip_hdr(skb), initval),
+					  queues_total);
+		break;
+	case NFPROTO_IPV6:
+		queue += reciprocal_scale(hash_v6(ipv6_hdr(skb), initval),
+					  queues_total);
+		break;
+	case NFPROTO_BRIDGE:
+		queue += reciprocal_scale(hash_bridge(skb, initval),
+					  queues_total);
+		break;
+	}
 
 	return queue;
 }
-- 
2.5.5


