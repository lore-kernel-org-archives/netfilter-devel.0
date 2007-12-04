From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 38/49]: nfnetlink_queue: avoid unnecessary atomic operation
Date: Tue,  4 Dec 2007 13:02:49 +0100 (MET)
Message-ID: <20071204120249.2442.29828.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62219 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbXLDMCu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:50 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: avoid unnecessary atomic operation

The sequence counter doesn't need to be an atomic_t, just move the increment
inside the locked section.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e237561545ccdb708967d2c5ae4030e5ef05bffc
tree c7b6bb2a4c2b025387b569d831ddbc6884b176a7
parent e1b5dfe8599c62320973aa270e94c4d4e8872db9
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:48:03 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:32 +0100

 net/netfilter/nfnetlink_queue.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index d9ce394..bd18de7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -56,7 +56,7 @@ struct nfqnl_instance {
 	unsigned int queue_dropped;
 	unsigned int queue_user_dropped;
 
-	atomic_t id_sequence;			/* 'sequence' of pkt ids */
+	unsigned int id_sequence;		/* 'sequence' of pkt ids */
 
 	u_int16_t queue_num;			/* number of this queue */
 	u_int8_t copy_mode;
@@ -139,7 +139,6 @@ instance_create(u_int16_t queue_num, int pid)
 	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
 	inst->copy_range = 0xfffff;
 	inst->copy_mode = NFQNL_COPY_NONE;
-	atomic_set(&inst->id_sequence, 0);
 	/* needs to be two, since we _put() after creation */
 	atomic_set(&inst->use, 2);
 	spin_lock_init(&inst->lock);
@@ -340,6 +339,8 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 		return NULL;
 	}
 
+	entry->id = queue->id_sequence++;
+
 	spin_unlock_bh(&queue->lock);
 
 	skb = alloc_skb(size, GFP_ATOMIC);
@@ -496,8 +497,6 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		goto err_out_put;
 	}
 
-	entry->id = atomic_inc_return(&queue->id_sequence);
-
 	nskb = nfqnl_build_packet_message(queue, entry, &status);
 	if (nskb == NULL)
 		goto err_out_put;
@@ -948,7 +947,7 @@ static int seq_show(struct seq_file *s, void *v)
 			  inst->peer_pid, inst->queue_total,
 			  inst->copy_mode, inst->copy_range,
 			  inst->queue_dropped, inst->queue_user_dropped,
-			  atomic_read(&inst->id_sequence),
+			  inst->id_sequence,
 			  atomic_read(&inst->use));
 }
 
