From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 30/49]: nfnetlink_queue: deobfuscate entry lookups
Date: Tue,  4 Dec 2007 13:02:37 +0100 (MET)
Message-ID: <20071204120237.2442.82313.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62193 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbXLDMCj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:39 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: deobfuscate entry lookups

A queue entry lookup currently looks like this:

find_dequeue_entry -> __find_dequeue_entry ->
	__find_entry -> cmpfn -> id_cmp

Use simple open-coded list walking and kill the cmpfn for
find_dequeue_entry. Instead add it to nfqnl_flush (after
similar cleanups) and use nfqnl_flush for both complete
flushes and flushing entries related to a device.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 554157a1a42a25819b2e64e59f19515828991435
tree e5c31cab3dbc70261c23bb9f0248e674f4ab19e9
parent 5a6886e29d4d9cd1ac4f91073ae30163446512ef
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:38 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:32:20 +0100

 net/netfilter/nfnetlink_queue.c |  100 ++++++++++++---------------------------
 1 files changed, 31 insertions(+), 69 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 74d5ed9..cb901cf 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -171,7 +171,8 @@ out_unlock:
 	return NULL;
 }
 
-static void nfqnl_flush(struct nfqnl_instance *queue, int verdict);
+static void nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn,
+			unsigned long data);
 
 static void
 _instance_destroy2(struct nfqnl_instance *inst, int lock)
@@ -188,7 +189,7 @@ _instance_destroy2(struct nfqnl_instance *inst, int lock)
 		write_unlock_bh(&instances_lock);
 
 	/* then flush all pending skbs from the queue */
-	nfqnl_flush(inst, NF_DROP);
+	nfqnl_flush(inst, NULL, 0);
 
 	/* and finally put the refcount */
 	instance_put(inst);
@@ -235,54 +236,6 @@ __enqueue_entry(struct nfqnl_instance *queue,
        queue->queue_total++;
 }
 
-/*
- * Find and return a queued entry matched by cmpfn, or return the last
- * entry if cmpfn is NULL.
- */
-static inline struct nfqnl_queue_entry *
-__find_entry(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn,
-		   unsigned long data)
-{
-	struct nfqnl_queue_entry *entry;
-
-	list_for_each_entry(entry, &queue->queue_list, list) {
-		if (!cmpfn || cmpfn(entry, data))
-			return entry;
-	}
-	return NULL;
-}
-
-static inline void
-__dequeue_entry(struct nfqnl_instance *q, struct nfqnl_queue_entry *entry)
-{
-	list_del(&entry->list);
-	q->queue_total--;
-}
-
-static inline struct nfqnl_queue_entry *
-__find_dequeue_entry(struct nfqnl_instance *queue,
-		     nfqnl_cmpfn cmpfn, unsigned long data)
-{
-	struct nfqnl_queue_entry *entry;
-
-	entry = __find_entry(queue, cmpfn, data);
-	if (entry == NULL)
-		return NULL;
-
-	__dequeue_entry(queue, entry);
-	return entry;
-}
-
-
-static inline void
-__nfqnl_flush(struct nfqnl_instance *queue, int verdict)
-{
-	struct nfqnl_queue_entry *entry;
-
-	while ((entry = __find_dequeue_entry(queue, NULL, 0)))
-		issue_verdict(entry, verdict);
-}
-
 static inline int
 __nfqnl_set_mode(struct nfqnl_instance *queue,
 		 unsigned char mode, unsigned int range)
@@ -313,23 +266,42 @@ __nfqnl_set_mode(struct nfqnl_instance *queue,
 }
 
 static struct nfqnl_queue_entry *
-find_dequeue_entry(struct nfqnl_instance *queue,
-			 nfqnl_cmpfn cmpfn, unsigned long data)
+find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 {
-	struct nfqnl_queue_entry *entry;
+	struct nfqnl_queue_entry *entry = NULL, *i;
 
 	spin_lock_bh(&queue->lock);
-	entry = __find_dequeue_entry(queue, cmpfn, data);
+
+	list_for_each_entry(i, &queue->queue_list, list) {
+		if (i->id == id) {
+			entry = i;
+			break;
+		}
+	}
+
+	if (entry) {
+		list_del(&entry->list);
+		queue->queue_total--;
+	}
+
 	spin_unlock_bh(&queue->lock);
 
 	return entry;
 }
 
 static void
-nfqnl_flush(struct nfqnl_instance *queue, int verdict)
+nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 {
+	struct nfqnl_queue_entry *entry, *next;
+
 	spin_lock_bh(&queue->lock);
-	__nfqnl_flush(queue, verdict);
+	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
+		if (!cmpfn || cmpfn(entry, data)) {
+			list_del(&entry->list);
+			queue->queue_total--;
+			issue_verdict(entry, NF_DROP);
+		}
+	}
 	spin_unlock_bh(&queue->lock);
 }
 
@@ -644,12 +616,6 @@ nfqnl_mangle(void *data, int data_len, struct nfqnl_queue_entry *e)
 	return 0;
 }
 
-static inline int
-id_cmp(struct nfqnl_queue_entry *e, unsigned long id)
-{
-	return (id == e->id);
-}
-
 static int
 nfqnl_set_mode(struct nfqnl_instance *queue,
 	       unsigned char mode, unsigned int range)
@@ -706,12 +672,8 @@ nfqnl_dev_drop(int ifindex)
 		struct nfqnl_instance *inst;
 		struct hlist_head *head = &instance_table[i];
 
-		hlist_for_each_entry(inst, tmp, head, hlist) {
-			struct nfqnl_queue_entry *entry;
-			while ((entry = find_dequeue_entry(inst, dev_cmp,
-							   ifindex)) != NULL)
-				issue_verdict(entry, NF_DROP);
-		}
+		hlist_for_each_entry(inst, tmp, head, hlist)
+			nfqnl_flush(inst, dev_cmp, ifindex);
 	}
 
 	read_unlock_bh(&instances_lock);
@@ -811,7 +773,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 		goto err_out_put;
 	}
 
-	entry = find_dequeue_entry(queue, id_cmp, ntohl(vhdr->id));
+	entry = find_dequeue_entry(queue, ntohl(vhdr->id));
 	if (entry == NULL) {
 		err = -ENOENT;
 		goto err_out_put;
