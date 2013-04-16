From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/5] netfilter: nfnetlink_queue: avoid peer_portid test
Date: Tue, 16 Apr 2013 17:32:05 +0200
Message-ID: <1366126328-25874-3-git-send-email-fw@strlen.de>
References: <1366126328-25874-1-git-send-email-fw@strlen.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41720 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757381Ab3DPPaG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:30:06 -0400
In-Reply-To: <1366126328-25874-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The portid is the netlink port id of the skb that created the queue.

Add test to ensure the portid cannot be 0 at create time, and
the check at enqueue time will always be false.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue_core.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 5e280b3..94e2e4f 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -107,6 +107,9 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num,
 	unsigned int h;
 	int err;
 
+	if (portid == 0)
+		return ERR_PTR(-EINVAL);
+
 	spin_lock(&q->instances_lock);
 	if (instance_lookup(q, queue_num)) {
 		err = -EEXIST;
@@ -506,10 +509,6 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
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
1.7.8.6

