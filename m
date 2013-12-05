From: Eric Leblond <eric@regit.org>
Subject: [PATCHv4 2/3] netfilter: xt_NFQUEUE: separate reusable code
Date: Fri,  6 Dec 2013 00:24:12 +0100
Message-ID: <1386285853-464-3-git-send-email-eric@regit.org>
References: <20131205214133.GA4307@localhost>
 <1386285853-464-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59309 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3LEXYf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:24:35 -0500
In-Reply-To: <1386285853-464-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch prepares the adding of nft_queue module by putting
reusable code into a header file.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/net/netfilter/nf_queue.h | 63 +++++++++++++++++++++++++++++++++
 net/netfilter/xt_NFQUEUE.c       | 75 +++++-----------------------------------
 2 files changed, 71 insertions(+), 67 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index c1d5b3e..0a71ab0 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -1,6 +1,10 @@
 #ifndef _NF_QUEUE_H
 #define _NF_QUEUE_H
 
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/jhash.h>
+
 /* Each queued (to userspace) skbuff has one of these. */
 struct nf_queue_entry {
 	struct list_head	list;
@@ -33,4 +37,63 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
 bool nf_queue_entry_get_refs(struct nf_queue_entry *entry);
 void nf_queue_entry_release_refs(struct nf_queue_entry *entry);
 
+static u32 jhash_initval __read_mostly;
+
+static inline void init_hashrandom(void)
+{
+	while (jhash_initval == 0)
+		jhash_initval = prandom_u32();
+}
+
+static inline u32 hash_v4(const struct sk_buff *skb)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+
+	/* packets in either direction go into same queue */
+	if ((__force u32)iph->saddr < (__force u32)iph->daddr)
+		return jhash_3words((__force u32)iph->saddr,
+			(__force u32)iph->daddr, iph->protocol, jhash_initval);
+
+	return jhash_3words((__force u32)iph->daddr,
+			(__force u32)iph->saddr, iph->protocol, jhash_initval);
+}
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+static inline u32 hash_v6(const struct sk_buff *skb)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	u32 a, b, c;
+
+	if ((__force u32)ip6h->saddr.s6_addr32[3] <
+	    (__force u32)ip6h->daddr.s6_addr32[3]) {
+		a = (__force u32) ip6h->saddr.s6_addr32[3];
+		b = (__force u32) ip6h->daddr.s6_addr32[3];
+	} else {
+		b = (__force u32) ip6h->saddr.s6_addr32[3];
+		a = (__force u32) ip6h->daddr.s6_addr32[3];
+	}
+
+	if ((__force u32)ip6h->saddr.s6_addr32[1] <
+	    (__force u32)ip6h->daddr.s6_addr32[1])
+		c = (__force u32) ip6h->saddr.s6_addr32[1];
+	else
+		c = (__force u32) ip6h->daddr.s6_addr32[1];
+
+	return jhash_3words(a, b, c, jhash_initval);
+}
+#endif
+
+static inline u32
+nfqueue_hash(const struct sk_buff *skb, u16 queue, u16 queues_total, u8 family)
+{
+	if (family == NFPROTO_IPV4)
+		queue += ((u64) hash_v4(skb) * queues_total) >> 32;
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	else if (family == NFPROTO_IPV6)
+		queue += ((u64) hash_v6(skb) * queues_total) >> 32;
+#endif
+
+	return queue;
+}
+
 #endif /* _NF_QUEUE_H */
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index ed00fef..20098f8 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -11,15 +11,13 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <linux/jhash.h>
-
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFQUEUE.h>
 
+#include <net/netfilter/nf_queue.h>
+
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: packet forwarding to netlink");
 MODULE_LICENSE("GPL");
@@ -27,9 +25,6 @@ MODULE_ALIAS("ipt_NFQUEUE");
 MODULE_ALIAS("ip6t_NFQUEUE");
 MODULE_ALIAS("arpt_NFQUEUE");
 
-static u32 jhash_initval __read_mostly;
-static bool rnd_inited __read_mostly;
-
 static unsigned int
 nfqueue_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -38,60 +33,6 @@ nfqueue_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	return NF_QUEUE_NR(tinfo->queuenum);
 }
 
-static u32 hash_v4(const struct sk_buff *skb)
-{
-	const struct iphdr *iph = ip_hdr(skb);
-
-	/* packets in either direction go into same queue */
-	if ((__force u32)iph->saddr < (__force u32)iph->daddr)
-		return jhash_3words((__force u32)iph->saddr,
-			(__force u32)iph->daddr, iph->protocol, jhash_initval);
-
-	return jhash_3words((__force u32)iph->daddr,
-			(__force u32)iph->saddr, iph->protocol, jhash_initval);
-}
-
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-static u32 hash_v6(const struct sk_buff *skb)
-{
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
-	u32 a, b, c;
-
-	if ((__force u32)ip6h->saddr.s6_addr32[3] <
-	    (__force u32)ip6h->daddr.s6_addr32[3]) {
-		a = (__force u32) ip6h->saddr.s6_addr32[3];
-		b = (__force u32) ip6h->daddr.s6_addr32[3];
-	} else {
-		b = (__force u32) ip6h->saddr.s6_addr32[3];
-		a = (__force u32) ip6h->daddr.s6_addr32[3];
-	}
-
-	if ((__force u32)ip6h->saddr.s6_addr32[1] <
-	    (__force u32)ip6h->daddr.s6_addr32[1])
-		c = (__force u32) ip6h->saddr.s6_addr32[1];
-	else
-		c = (__force u32) ip6h->daddr.s6_addr32[1];
-
-	return jhash_3words(a, b, c, jhash_initval);
-}
-#endif
-
-static u32
-nfqueue_hash(const struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_NFQ_info_v1 *info = par->targinfo;
-	u32 queue = info->queuenum;
-
-	if (par->family == NFPROTO_IPV4)
-		queue += ((u64) hash_v4(skb) * info->queues_total) >> 32;
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-	else if (par->family == NFPROTO_IPV6)
-		queue += ((u64) hash_v6(skb) * info->queues_total) >> 32;
-#endif
-
-	return queue;
-}
-
 static unsigned int
 nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -99,7 +40,8 @@ nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	u32 queue = info->queuenum;
 
 	if (info->queues_total > 1)
-		queue = nfqueue_hash(skb, par);
+		queue = nfqueue_hash(skb, queue,
+				     info->queues_total, par->family);
 
 	return NF_QUEUE_NR(queue);
 }
@@ -120,10 +62,8 @@ static int nfqueue_tg_check(const struct xt_tgchk_param *par)
 	const struct xt_NFQ_info_v3 *info = par->targinfo;
 	u32 maxid;
 
-	if (unlikely(!rnd_inited)) {
-		get_random_bytes(&jhash_initval, sizeof(jhash_initval));
-		rnd_inited = true;
-	}
+	init_hashrandom();
+
 	if (info->queues_total == 0) {
 		pr_err("NFQUEUE: number of total queues is 0\n");
 		return -EINVAL;
@@ -155,7 +95,8 @@ nfqueue_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
 
 			queue = info->queuenum + cpu % info->queues_total;
 		} else
-			queue = nfqueue_hash(skb, par);
+			queue = nfqueue_hash(skb, queue,
+					     info->queues_total, par->family);
 	}
 
 	ret = NF_QUEUE_NR(queue);
-- 
1.8.5

