From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 5/5] netfilter: nfqueue: avoid expensive gso segmentation and checksum fixup
Date: Tue, 16 Apr 2013 17:32:08 +0200
Message-ID: <1366126328-25874-6-git-send-email-fw@strlen.de>
References: <1366126328-25874-1-git-send-email-fw@strlen.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41728 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757564Ab3DPPaJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:30:09 -0400
In-Reply-To: <1366126328-25874-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Userspace can now indicate that it can cope with larger-than-mtu sized
packets and packets that have invalid ipv4/tcp checksums.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nfnetlink_queue.h |    3 ++-
 net/netfilter/nfnetlink_queue_core.c           |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index 0069da3..a2308ae 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -97,7 +97,8 @@ enum nfqnl_attr_config {
 /* Flags for NFQA_CFG_FLAGS */
 #define NFQA_CFG_F_FAIL_OPEN			(1 << 0)
 #define NFQA_CFG_F_CONNTRACK			(1 << 1)
-#define NFQA_CFG_F_MAX				(1 << 2)
+#define NFQA_CFG_F_GSO				(1 << 2)
+#define NFQA_CFG_F_MAX				(1 << 3)
 
 /* flags for NFQA_SKB_INFO */
 /* packet appears to have wrong checksums, but they are ok */
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 839c65b..07ed239 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -330,7 +330,8 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 		break;
 
 	case NFQNL_COPY_PACKET:
-		if (entskb->ip_summed == CHECKSUM_PARTIAL &&
+		if (!(queue->flags & NFQA_CFG_F_GSO) &&
+		    entskb->ip_summed == CHECKSUM_PARTIAL &&
 		    skb_checksum_help(entskb))
 			return NULL;
 
@@ -623,7 +624,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	if (queue->copy_mode == NFQNL_COPY_NONE)
 		return -EINVAL;
 
-	if (!skb_is_gso(entry->skb))
+	if ((queue->flags & NFQA_CFG_F_GSO) || !skb_is_gso(entry->skb))
 		return __nfqnl_enqueue_packet(net, queue, entry);
 
 	skb = entry->skb;
-- 
1.7.8.6

