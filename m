From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] nfnetlink_queue: Use hash to speed up finding entries in
 nfqueue
Date: Fri, 20 Nov 2009 12:56:31 +0800
Message-ID: <4B06217F.6060901@gmail.com>
Reply-To: xiaosuo@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f180.google.com ([209.85.216.180]:38531 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbZKTE4g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Nov 2009 23:56:36 -0500
Received: by pxi10 with SMTP id 10so2170431pxi.33
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2009 20:56:42 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use hash to speed up finding entries in nfqueue.

If user implements QoS in userland, packet verdict won't be received in order. At this moment, a hash table is faster than a double linked list when finding the corresponding entries in nfqueue.

This patch also fixes a potential bug, which will allows more than one entries with the same id are in the same nfqueue in the extreme.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 nfnetlink_queue.c |   86 ++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 61 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7a9dec9..38c7af1 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -37,6 +37,9 @@
 #endif
 
 #define NFQNL_QMAX_DEFAULT 1024
+#define NFQNL_QHT_BITS 8
+#define NFQNL_QHT_SIZE (1 << NFQNL_QHT_BITS)
+#define NFQNL_QHT_MASK (NFQNL_QHT_SIZE - 1)
 
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
@@ -56,7 +59,7 @@ struct nfqnl_instance {
 
 	spinlock_t lock;
 
-	struct list_head queue_list;		/* packets in queue */
+	struct list_head *queue_list;
 };
 
 typedef int (*nfqnl_cmpfn)(struct nf_queue_entry *, unsigned long);
@@ -111,12 +114,19 @@ instance_create(u_int16_t queue_num, int pid)
 	inst->copy_range = 0xfffff;
 	inst->copy_mode = NFQNL_COPY_NONE;
 	spin_lock_init(&inst->lock);
-	INIT_LIST_HEAD(&inst->queue_list);
+	inst->queue_list = kcalloc(NFQNL_QHT_SIZE, sizeof(*inst->queue_list),
+				   GFP_ATOMIC);
+	if (inst->queue_list == NULL) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+	for (h = 0; h < NFQNL_QHT_SIZE; h++)
+		INIT_LIST_HEAD(&inst->queue_list[h]);
 	INIT_RCU_HEAD(&inst->rcu);
 
 	if (!try_module_get(THIS_MODULE)) {
 		err = -EAGAIN;
-		goto out_free;
+		goto out_free_queue;
 	}
 
 	h = instance_hashfn(queue_num);
@@ -126,6 +136,8 @@ instance_create(u_int16_t queue_num, int pid)
 
 	return inst;
 
+out_free_queue:
+	kfree(inst->queue_list);
 out_free:
 	kfree(inst);
 out_unlock:
@@ -143,6 +155,7 @@ instance_destroy_rcu(struct rcu_head *head)
 						   rcu);
 
 	nfqnl_flush(inst, NULL, 0);
+	kfree(inst->queue_list);
 	kfree(inst);
 	module_put(THIS_MODULE);
 }
@@ -162,32 +175,51 @@ instance_destroy(struct nfqnl_instance *inst)
 	spin_unlock(&instances_lock);
 }
 
+static struct nf_queue_entry *
+__find_entry(struct nfqnl_instance *queue, unsigned int id)
+{
+	struct nf_queue_entry *i;
+
+	list_for_each_entry(i, &queue->queue_list[id & NFQNL_QHT_MASK], list) {
+		if (i->id == id)
+			return i;
+	}
+
+	return NULL;
+}
+
 static inline void
 __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
-       list_add_tail(&entry->list, &queue->queue_list);
-       queue->queue_total++;
+	do {
+		entry->id = queue->id_sequence++;
+	} while (__find_entry(queue, entry->id) != NULL);
+	list_add_tail(&entry->list,
+		      &queue->queue_list[entry->id & NFQNL_QHT_MASK]);
+	queue->queue_total++;
 }
 
 static struct nf_queue_entry *
-find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
+__dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 {
-	struct nf_queue_entry *entry = NULL, *i;
-
-	spin_lock_bh(&queue->lock);
-
-	list_for_each_entry(i, &queue->queue_list, list) {
-		if (i->id == id) {
-			entry = i;
-			break;
-		}
-	}
+	struct nf_queue_entry *entry;
 
+	entry = __find_entry(queue, id);
 	if (entry) {
 		list_del(&entry->list);
 		queue->queue_total--;
 	}
 
+	return entry;
+}
+
+static struct nf_queue_entry *
+dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
+{
+	struct nf_queue_entry *entry;
+
+	spin_lock_bh(&queue->lock);
+	entry = __dequeue_entry(queue, id);
 	spin_unlock_bh(&queue->lock);
 
 	return entry;
@@ -197,13 +229,17 @@ static void
 nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 {
 	struct nf_queue_entry *entry, *next;
+	int i;
 
 	spin_lock_bh(&queue->lock);
-	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
-		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
-			queue->queue_total--;
-			nf_reinject(entry, NF_DROP);
+	for (i = 0; i < NFQNL_QHT_SIZE; i++) {
+		list_for_each_entry_safe(entry, next, &queue->queue_list[i],
+					 list) {
+			if (!cmpfn || cmpfn(entry, data)) {
+				list_del(&entry->list);
+				queue->queue_total--;
+				nf_reinject(entry, NF_DROP);
+			}
 		}
 	}
 	spin_unlock_bh(&queue->lock);
@@ -262,7 +298,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 		break;
 	}
 
-	entry->id = queue->id_sequence++;
+	__enqueue_entry(queue, entry);
 
 	spin_unlock_bh(&queue->lock);
 
@@ -379,6 +415,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 
 nlmsg_failure:
 nla_put_failure:
+	dequeue_entry(queue, entry->id);
 	if (skb)
 		kfree_skb(skb);
 	if (net_ratelimit())
@@ -426,14 +463,13 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		goto err_out_unlock;
 	}
 
-	__enqueue_entry(queue, entry);
-
 	spin_unlock_bh(&queue->lock);
 	return 0;
 
 err_out_free_nskb:
 	kfree_skb(nskb);
 err_out_unlock:
+	__dequeue_entry(queue, entry->id);
 	spin_unlock_bh(&queue->lock);
 err_out:
 	return -1;
@@ -645,7 +681,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 		goto err_out_unlock;
 	}
 
-	entry = find_dequeue_entry(queue, ntohl(vhdr->id));
+	entry = dequeue_entry(queue, ntohl(vhdr->id));
 	if (entry == NULL) {
 		err = -ENOENT;
 		goto err_out_unlock;

