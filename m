From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] netfilter: simplify warning message
Date: Fri, 15 Jan 2010 23:05:51 +0100
Message-ID: <1263593151-20651-1-git-send-email-eric@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55785 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab0AOWGB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2010 17:06:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch remove variable part from a debug message to have
message concatenation from syslog.
---
 net/netfilter/nfnetlink_queue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7e3fa41..b5ed1f7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -414,8 +414,8 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		queue->queue_dropped++;
 		if (net_ratelimit())
 			  printk(KERN_WARNING "nf_queue: full at %d entries, "
-				 "dropping packets(s). Dropped: %d\n",
-				 queue->queue_total, queue->queue_dropped);
+				 "dropping packets(s).\n",
+				 queue->queue_total);
 		goto err_out_free_nskb;
 	}
 
-- 
1.6.1

