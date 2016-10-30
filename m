From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next] netfilter: nf_queue: place volatile data in own cacheline
Date: Mon, 31 Oct 2016 00:35:07 +0100
Message-ID: <1477870507-10453-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42266 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752800AbcJ3Xet (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Oct 2016 19:34:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As the comment indicates, the data at the end of nfqnl_instance struct is
written on every queue/dequeue, so it should reside in its own cacheline.

Before this change, 'lock' was in first cacheline so we dirtied both.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index af832c526048..5379f788a372 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -69,7 +69,7 @@ struct nfqnl_instance {
  * Following fields are dirtied for each queued packet,
  * keep them in same cache line if possible.
  */
-	spinlock_t	lock;
+	spinlock_t	lock	____cacheline_aligned_in_smp;
 	unsigned int	queue_total;
 	unsigned int	id_sequence;		/* 'sequence' of pkt ids */
 	struct list_head queue_list;		/* packets in queue */
-- 
2.7.3

