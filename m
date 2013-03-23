From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH v2 2/3] NFQUEUE: coalesce IPv4 and IPv6 hashing
Date: Sat, 23 Mar 2013 21:04:04 +0100
Message-ID: <20130323200608.174914056@eitzenberger.org>
References: <20130323200402.209591997@eitzenberger.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:54150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3CWUGL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Mar 2013 16:06:11 -0400
Received: from holger by kruemel.eitzenberger.org with local (Exim 4.76)
	(envelope-from <holger@eitzenberger.org>)
	id 1UJUhc-00049b-GE
	for netfilter-devel@vger.kernel.org; Sat, 23 Mar 2013 21:06:08 +0100
Content-Disposition: inline; filename=net-next/NFQUEUE-coalesce.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Because rev1 and rev3 of the target share the same hashing
generalize it by introduing nfqueue_hash().

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: net-next/net/netfilter/xt_NFQUEUE.c
===================================================================
--- net-next.orig/net/netfilter/xt_NFQUEUE.c	2013-03-23 19:01:11.000000000 +0100
+++ net-next/net/netfilter/xt_NFQUEUE.c	2013-03-23 20:54:54.000000000 +0100
@@ -76,22 +76,31 @@
 }
 #endif
 
-static unsigned int
-nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+static u32
+nfqueue_hash(const struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_NFQ_info_v1 *info = par->targinfo;
 	u32 queue = info->queuenum;
 
-	if (info->queues_total > 1) {
-		if (par->family == NFPROTO_IPV4)
-			queue = (((u64) hash_v4(skb) * info->queues_total) >>
-				 32) + queue;
+	if (par->family == NFPROTO_IPV4)
+		queue += ((u64) hash_v4(skb) * info->queues_total) >> 32;
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-		else if (par->family == NFPROTO_IPV6)
-			queue = (((u64) hash_v6(skb) * info->queues_total) >>
-				 32) + queue;
+	else if (par->family == NFPROTO_IPV6)
+		queue += ((u64) hash_v6(skb) * info->queues_total) >> 32;
 #endif
-	}
+
+	return queue;
+}
+
+static unsigned int
+nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_NFQ_info_v1 *info = par->targinfo;
+	u32 queue = info->queuenum;
+
+	if (info->queues_total > 1)
+		queue = nfqueue_hash(skb, par);
+
 	return NF_QUEUE_NR(queue);
 }
 
@@ -144,17 +153,10 @@
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
+
 	return NF_QUEUE_NR(queue);
 }
 

