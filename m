From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/3] netfilter: NFQUEUE: queue balancing support
Date: Fri, 5 Jun 2009 15:23:28 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906051522470.7950@fbirervta.pbzchgretzou.qr>
References: <1244164542-10739-1-git-send-email-fw@strlen.de> <1244164542-10739-3-git-send-email-fw@strlen.de> <alpine.LSU.2.00.0906051503470.17010@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Holger Eitzenberger <heitzenberger@astaro.com>,
	Florian Westphal <fwestphal@astaro.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34356 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbZFENX1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:23:27 -0400
In-Reply-To: <alpine.LSU.2.00.0906051503470.17010@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-06-05 15:07, Jan Engelhardt wrote:
>On Friday 2009-06-05 03:15, Florian Westphal wrote:
>> 
>>+static u32 hash_v4(const struct sk_buff *skb)
>>+{
>>+	const struct iphdr *iph = ip_hdr(skb);
>>+	u32 ipaddr;
>>+
>>+	/* packets in either direction go into same queue */
>>+	ipaddr = iph->saddr ^ iph->daddr;
>>+
>>+	return jhash_2words(ipaddr, iph->protocol, jhash_initval);
>>+}
>
>I'd say this could be done with much less code:[...]

Oh well, here's the patch because that's faster.
Compile tested only.


parent 17f2f52be0edb6d1ff5a3675f2bc545aea2dbf76 (v2.6.30-rc6-921-g17f2f52)
commit 6adde1879038923d6d34973af5504d381b4ce6d8
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Jun 5 15:22:15 2009 +0200

netfilter: xt_NFQUEUE: consolidate v4/v6 targets into one

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_NFQUEUE.c |   40 ++++++++++-------------------------
 1 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 498b451..53c98db 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -48,17 +48,6 @@ static u32 hash_v4(const struct sk_buff *skb)
 	return jhash_2words(ipaddr, iph->protocol, jhash_initval);
 }
 
-static unsigned int
-nfqueue_tg4_v1(struct sk_buff *skb, const struct xt_target_param *par)
-{
-	const struct xt_NFQ_info_v1 *info = par->targinfo;
-	u32 queue = info->queuenum;
-
-	if (info->queues_total > 1)
-		queue = hash_v4(skb) % info->queues_total + queue;
-	return NF_QUEUE_NR(queue);
-}
-
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 static u32 hash_v6(const struct sk_buff *skb)
 {
@@ -72,18 +61,24 @@ static u32 hash_v6(const struct sk_buff *skb)
 
 	return jhash2(addr, ARRAY_SIZE(addr), jhash_initval);
 }
+#endif
 
 static unsigned int
-nfqueue_tg6_v1(struct sk_buff *skb, const struct xt_target_param *par)
+nfqueue_tg_v1(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	const struct xt_NFQ_info_v1 *info = par->targinfo;
 	u32 queue = info->queuenum;
 
-	if (info->queues_total > 1)
-		queue = hash_v6(skb) % info->queues_total + queue;
+	if (info->queues_total > 1) {
+		if (par->target->family == NFPROTO_IPV4)
+			queue = hash_v4(skb) % info->queues_total + queue;
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+		else if (par->target->family == NFPROTO_IPV6)
+			queue = hash_v6(skb) % info->queues_total + queue;
+#endif
+	}
 	return NF_QUEUE_NR(queue);
 }
-#endif
 
 static bool nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
 {
@@ -114,23 +109,12 @@ static struct xt_target nfqueue_tg_reg[] __read_mostly = {
 	{
 		.name		= "NFQUEUE",
 		.revision	= 1,
-		.family		= NFPROTO_IPV4,
-		.checkentry	= nfqueue_tg_v1_check,
-		.target		= nfqueue_tg4_v1,
-		.targetsize	= sizeof(struct xt_NFQ_info_v1),
-		.me		= THIS_MODULE,
-	},
-#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-	{
-		.name		= "NFQUEUE",
-		.revision	= 1,
-		.family		= NFPROTO_IPV6,
+		.family		= NFPROTO_UNSPEC,
 		.checkentry	= nfqueue_tg_v1_check,
-		.target		= nfqueue_tg6_v1,
+		.target		= nfqueue_tg_v1,
 		.targetsize	= sizeof(struct xt_NFQ_info_v1),
 		.me		= THIS_MODULE,
 	},
-#endif
 };
 
 static int __init nfqueue_tg_init(void)
-- 
# Created with git-export-patch
