From: holger@eitzenberger.org
Subject: [PATCH RFC 2/3] NFQUEUE: coalesce IPv4 and IPv6 hashing
Date: Tue, 19 Mar 2013 15:14:44 +0100
Message-ID: <20130319141605.728912499@eitzenberger.org>
References: <20130319141442.150005875@eitzenberger.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50531 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3CSOQI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:16:08 -0400
Received: from holger by kruemel.eitzenberger.org with local (Exim 4.76)
	(envelope-from <holger@eitzenberger.org>)
	id 1UHxKg-0006Rd-3T
	for netfilter-devel@vger.kernel.org; Tue, 19 Mar 2013 15:16:06 +0100
Content-Disposition: inline; filename=net-next/NFQUEUE-coalesce.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Because rev1 and rev3 of the target share the same hashing
generalize it by introduing nfqueue_hash().

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

---
 net/netfilter/xt_NFQUEUE.c |   49 +++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index cf9c6a1..90684a1 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -76,22 +76,37 @@ static u32 hash_v6(const struct sk_buff *skb)
 }
 #endif
 
-static unsigned int
-nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+static u32
+nfqueue_hash(const struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_NFQ_info_v1 *info = par->targinfo;
-	u32 queue = info->queuenum;
+	u32 queue;
 
-	if (info->queues_total > 1) {
-		if (par->family == NFPROTO_IPV4)
-			queue = (((u64) hash_v4(skb) * info->queues_total) >>
-				 32) + queue;
+	if (par->family == NFPROTO_IPV4)
+		queue = (((u64) hash_v4(skb) * info->queues_total) >>
+			 32) + queue;
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-		else if (par->family == NFPROTO_IPV6)
-			queue = (((u64) hash_v6(skb) * info->queues_total) >>
-				 32) + queue;
+	else if (par->family == NFPROTO_IPV6)
+		queue = (((u64) hash_v6(skb) * info->queues_total) >>
+			 32) + queue;
 #endif
-	}
+	else
+		queue = info->queuenum;
+
+	return queue;
+}
+
+static unsigned int
+nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_NFQ_info_v1 *info = par->targinfo;
+	u32 queue;
+
+	if (info->queues_total > 1)
+		queue = nfqueue_hash(skb, par);
+	else
+		queue = info->queuenum;
+
 	return NF_QUEUE_NR(queue);
 }
 
@@ -144,16 +159,8 @@ nfqueue_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
 			int cpu = smp_processor_id();
 
 			queue = info->queuenum + cpu % info->queues_total;
-		} else {
-			if (par->family == NFPROTO_IPV4)
-				queue = (((u64) hash_v4(skb) * info->queues_total) >>
-						 32) + queue;
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-			else if (par->family == NFPROTO_IPV6)
-				queue = (((u64) hash_v6(skb) * info->queues_total) >>
-						 32) + queue;
-#endif
-		}
+		} else
+			queue = nfqueue_hash(skb, par);
 	}
 	return NF_QUEUE_NR(queue);
 }

