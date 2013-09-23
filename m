From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 1/2] nfnetlink_queue: use proper net to allocate skb
Date: Mon, 23 Sep 2013 19:20:55 +0800
Message-ID: <1379935256-18598-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49862 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab3IWLTw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:19:52 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8NBJkki026201
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2013 19:19:46 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use proper net struct to allocate skb,otherwise
netlink mmap will be of no effect.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/nfnetlink_queue_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index ae2e5c1..678106d 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -298,7 +298,8 @@ nfqnl_put_packet_info(struct sk_buff *nlskb, struct sk_buff *packet,
 }
 
 static struct sk_buff *
-nfqnl_build_packet_message(struct nfqnl_instance *queue,
+nfqnl_build_packet_message(struct net *net,
+			   struct nfqnl_instance *queue,
 			   struct nf_queue_entry *entry,
 			   __be32 **packet_id_ptr)
 {
@@ -372,7 +373,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	if (queue->flags & NFQA_CFG_F_CONNTRACK)
 		ct = nfqnl_ct_get(entskb, &size, &ctinfo);
 
-	skb = nfnetlink_alloc_skb(&init_net, size, queue->peer_portid,
+	skb = nfnetlink_alloc_skb(net, size, queue->peer_portid,
 				  GFP_ATOMIC);
 	if (!skb)
 		return NULL;
@@ -525,7 +526,7 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	__be32 *packet_id_ptr;
 	int failopen = 0;
 
-	nskb = nfqnl_build_packet_message(queue, entry, &packet_id_ptr);
+	nskb = nfqnl_build_packet_message(net, queue, entry, &packet_id_ptr);
 	if (nskb == NULL) {
 		err = -ENOMEM;
 		goto err_out;
-- 
1.8.3.1

