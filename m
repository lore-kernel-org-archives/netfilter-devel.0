From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 46/49]: nfnetlink_queue: remove useless enqueue status codes
Date: Tue,  4 Dec 2007 13:03:00 +0100 (MET)
Message-ID: <20071204120300.2442.82558.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62245 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbXLDMDB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:03:01 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: remove useless enqueue status codes

The queueing core doesn't care about the exact return value from
the queue handler, so there's no need to go through the trouble
of returning a meaningful value as long as we indicate an error.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6601c07684fee94541f63c45456d2410f2e522a6
tree 77b2a3a8887d8571fee11645b167bfaea9a47128
parent 9e5fe442940e535b1839192dfde9ef67ae1a3042
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:48:25 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:35 +0100

 net/netfilter/nfnetlink_queue.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index abd5ff9..6148a41 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -203,7 +203,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 
 static struct sk_buff *
 nfqnl_build_packet_message(struct nfqnl_instance *queue,
-			   struct nf_queue_entry *entry, int *errp)
+			   struct nf_queue_entry *entry)
 {
 	sk_buff_data_t old_tail;
 	size_t size;
@@ -241,7 +241,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	case NFQNL_COPY_PACKET:
 		if ((entskb->ip_summed == CHECKSUM_PARTIAL ||
 		     entskb->ip_summed == CHECKSUM_COMPLETE) &&
-		    (*errp = skb_checksum_help(entskb))) {
+		    skb_checksum_help(entskb)) {
 			spin_unlock_bh(&queue->lock);
 			return NULL;
 		}
@@ -374,7 +374,6 @@ nlmsg_failure:
 nla_put_failure:
 	if (skb)
 		kfree_skb(skb);
-	*errp = -EINVAL;
 	if (net_ratelimit())
 		printk(KERN_ERR "nf_queue: error creating packet message\n");
 	return NULL;
@@ -383,21 +382,21 @@ nla_put_failure:
 static int
 nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
-	int status = -EINVAL;
 	struct sk_buff *nskb;
 	struct nfqnl_instance *queue;
+	int err;
 
 	/* rcu_read_lock()ed by nf_hook_slow() */
 	queue = instance_lookup(queuenum);
 	if (!queue)
-		return -EINVAL;
+		goto err_out;
 
 	if (queue->copy_mode == NFQNL_COPY_NONE)
-		return -EAGAIN;
+		goto err_out;
 
-	nskb = nfqnl_build_packet_message(queue, entry, &status);
+	nskb = nfqnl_build_packet_message(queue, entry);
 	if (nskb == NULL)
-		return status;
+		goto err_out;
 
 	spin_lock_bh(&queue->lock);
 
@@ -406,7 +405,6 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 
 	if (queue->queue_total >= queue->queue_maxlen) {
 		queue->queue_dropped++;
-		status = -ENOSPC;
 		if (net_ratelimit())
 			  printk(KERN_WARNING "nf_queue: full at %d entries, "
 				 "dropping packets(s). Dropped: %d\n",
@@ -415,8 +413,8 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	}
 
 	/* nfnetlink_unicast will either free the nskb or add it to a socket */
-	status = nfnetlink_unicast(nskb, queue->peer_pid, MSG_DONTWAIT);
-	if (status < 0) {
+	err = nfnetlink_unicast(nskb, queue->peer_pid, MSG_DONTWAIT);
+	if (err < 0) {
 		queue->queue_user_dropped++;
 		goto err_out_unlock;
 	}
@@ -424,14 +422,14 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	__enqueue_entry(queue, entry);
 
 	spin_unlock_bh(&queue->lock);
-	return status;
+	return 0;
 
 err_out_free_nskb:
 	kfree_skb(nskb);
-
 err_out_unlock:
 	spin_unlock_bh(&queue->lock);
-	return status;
+err_out:
+	return -1;
 }
 
 static int
