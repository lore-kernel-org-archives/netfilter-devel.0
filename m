From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next, resend] netfilter: nfnetlink_queue: avoid peer_portid test
Date: Sat, 25 May 2013 13:46:10 +0200
Message-ID: <1369482370-9145-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34501 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754244Ab3EYLrW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 May 2013 07:47:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The portid is set to NETLINK_CB(skb).portid at create time.
The run-time check will always be false.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo,
 This is a re-send of a similar patch:
 ( http://patchwork.ozlabs.org/patch/238013/ )

 Change since last version:
 - Remove check altogether instead of moving it to
   instance_create().

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 2e0e835..cff4449 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -509,10 +509,6 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	}
 	spin_lock_bh(&queue->lock);
 
-	if (!queue->peer_portid) {
-		err = -EINVAL;
-		goto err_out_free_nskb;
-	}
 	if (queue->queue_total >= queue->queue_maxlen) {
 		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
 			failopen = 1;
-- 
1.8.1.5

