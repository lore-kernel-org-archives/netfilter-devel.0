From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_queue: get rid of dependency on IP6_NF_IPTABLES
Date: Sun, 11 Sep 2016 22:05:27 +0800
Message-ID: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:41451 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755780AbcIKOGF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Sep 2016 10:06:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

hash_v6 is used by both nftables and ip6tables, so depend on
IP6_NF_IPTABLES is not properly.

Actually, it only parses ipv6hdr and computes a hash value, so
even if IPV6 is disabled, there's no side effect too, remove it.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 include/net/netfilter/nf_queue.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 0dbce55..cc8a11f 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -54,7 +54,6 @@ static inline u32 hash_v4(const struct sk_buff *skb, u32 jhash_initval)
 			(__force u32)iph->saddr, iph->protocol, jhash_initval);
 }
 
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static inline u32 hash_v6(const struct sk_buff *skb, u32 jhash_initval)
 {
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
@@ -77,7 +76,6 @@ static inline u32 hash_v6(const struct sk_buff *skb, u32 jhash_initval)
 
 	return jhash_3words(a, b, c, jhash_initval);
 }
-#endif
 
 static inline u32
 nfqueue_hash(const struct sk_buff *skb, u16 queue, u16 queues_total, u8 family,
@@ -85,10 +83,8 @@ nfqueue_hash(const struct sk_buff *skb, u16 queue, u16 queues_total, u8 family,
 {
 	if (family == NFPROTO_IPV4)
 		queue += ((u64) hash_v4(skb, jhash_initval) * queues_total) >> 32;
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	else if (family == NFPROTO_IPV6)
 		queue += ((u64) hash_v6(skb, jhash_initval) * queues_total) >> 32;
-#endif
 
 	return queue;
 }
-- 
2.5.5


