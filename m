From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 41/49]: nfnetlink_queue: kill useless wrapper
Date: Tue,  4 Dec 2007 13:02:53 +0100 (MET)
Message-ID: <20071204120253.2442.47453.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62229 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbXLDMCy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:54 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: kill useless wrapper

nfqnl_set_mode takes the queue lock and calls __nfqnl_set_mode. Just move
the code from __nfqnl_set_mode to nfqnl_set_mode since there is no other
user.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 264c2cc068091460172646e0611e96611684355a
tree 0b5dc98f227b6bb9a08bc899c655166b0cf9acb8
parent 1fb555e556b810fbcde356b7865f54f6dcb939d9
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:48:12 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:33 +0100

 net/netfilter/nfnetlink_queue.c |   52 ++++++++++++++++-----------------------
 1 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 449b880..37b7655 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -176,35 +176,6 @@ __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
        queue->queue_total++;
 }
 
-static inline int
-__nfqnl_set_mode(struct nfqnl_instance *queue,
-		 unsigned char mode, unsigned int range)
-{
-	int status = 0;
-
-	switch (mode) {
-	case NFQNL_COPY_NONE:
-	case NFQNL_COPY_META:
-		queue->copy_mode = mode;
-		queue->copy_range = 0;
-		break;
-
-	case NFQNL_COPY_PACKET:
-		queue->copy_mode = mode;
-		/* we're using struct nlattr which has 16bit nla_len */
-		if (range > 0xffff)
-			queue->copy_range = 0xffff;
-		else
-			queue->copy_range = range;
-		break;
-
-	default:
-		status = -EINVAL;
-
-	}
-	return status;
-}
-
 static struct nf_queue_entry *
 find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 {
@@ -540,10 +511,29 @@ static int
 nfqnl_set_mode(struct nfqnl_instance *queue,
 	       unsigned char mode, unsigned int range)
 {
-	int status;
+	int status = 0;
 
 	spin_lock_bh(&queue->lock);
-	status = __nfqnl_set_mode(queue, mode, range);
+	switch (mode) {
+	case NFQNL_COPY_NONE:
+	case NFQNL_COPY_META:
+		queue->copy_mode = mode;
+		queue->copy_range = 0;
+		break;
+
+	case NFQNL_COPY_PACKET:
+		queue->copy_mode = mode;
+		/* we're using struct nlattr which has 16bit nla_len */
+		if (range > 0xffff)
+			queue->copy_range = 0xffff;
+		else
+			queue->copy_range = range;
+		break;
+
+	default:
+		status = -EINVAL;
+
+	}
 	spin_unlock_bh(&queue->lock);
 
 	return status;
