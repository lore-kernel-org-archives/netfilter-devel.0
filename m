From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 1/2] netfilter: nf_queue: cleanup copy_range usage
Date: Wed,  5 Jun 2013 10:22:15 +0200
Message-ID: <1370420536-9626-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39370 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405Ab3FEIVy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:21:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For every packet queued, we check if configured copy_range
is 0, and treat that as 'copy entire packet'.

We can move this check to the queue configuration, and can
set copy_range appropriately.

Also, convert repetitive '0xffff - NLA_HDRLEN' to a macro.

[ queue initialization still used 0xffff, although its harmless
  since the initial setting is overwritten on queue config ]

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since v1:
 - split CAP_LEN change into separate patch
 - also move comment

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index cff4449..3c42181 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -41,6 +41,14 @@
 
 #define NFQNL_QMAX_DEFAULT 1024
 
+/* We're using struct nlattr which has 16bit nla_len. Note that nla_len
+ * includes the header length. Thus, the maximum packet length that we
+ * support is 65531 bytes. We send truncated packets if the specified length
+ * is larger than that.  Userspace can check for presence of NFQA_CAP_LEN
+ * attribute to detect truncation.
+ */
+#define NFQNL_MAX_COPY_RANGE (0xffff - NLA_HDRLEN)
+
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
 	struct rcu_head rcu;
@@ -122,7 +130,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num,
 	inst->queue_num = queue_num;
 	inst->peer_portid = portid;
 	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
-	inst->copy_range = 0xffff;
+	inst->copy_range = NFQNL_MAX_COPY_RANGE;
 	inst->copy_mode = NFQNL_COPY_NONE;
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
@@ -333,10 +341,9 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 			return NULL;
 
 		data_len = ACCESS_ONCE(queue->copy_range);
-		if (data_len == 0 || data_len > entskb->len)
+		if (data_len > entskb->len)
 			data_len = entskb->len;
 
-
 		if (!entskb->head_frag ||
 		    skb_headlen(entskb) < L1_CACHE_BYTES ||
 		    skb_shinfo(entskb)->nr_frags >= MAX_SKB_FRAGS)
@@ -727,13 +734,8 @@ nfqnl_set_mode(struct nfqnl_instance *queue,
 
 	case NFQNL_COPY_PACKET:
 		queue->copy_mode = mode;
-		/* We're using struct nlattr which has 16bit nla_len. Note that
-		 * nla_len includes the header length. Thus, the maximum packet
-		 * length that we support is 65531 bytes. We send truncated
-		 * packets if the specified length is larger than that.
-		 */
-		if (range > 0xffff - NLA_HDRLEN)
-			queue->copy_range = 0xffff - NLA_HDRLEN;
+		if (range == 0 || range > NFQNL_MAX_COPY_RANGE)
+			queue->copy_range = NFQNL_MAX_COPY_RANGE;
 		else
 			queue->copy_range = range;
 		break;
-- 
1.7.8.6

