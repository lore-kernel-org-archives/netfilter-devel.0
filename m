From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry finding.
Date: Fri, 09 Apr 2010 12:13:46 +0800
Message-ID: <4BBEA97A.5020303@gmail.com>
Reply-To: xiaosuo@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:53543 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0DIEN6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:13:58 -0400
Received: by iwn35 with SMTP id 35so1983913iwn.21
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Apr 2010 21:13:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

use hash table to speed up entry finding.

If verdicts aren't received in order, list isn't efficient, and hash
table is better.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
include/linux/netfilter/nfnetlink_queue.h | 1
net/netfilter/nfnetlink_queue.c | 118 ++++++++++++++++++++++++++----
2 files changed, 105 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 2455fe5..77b1566 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -83,6 +83,7 @@ enum nfqnl_attr_config {
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
 	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
+	NFQA_CFG_QUEUE_HTBLSIZ,		/* __u32 */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index e70a6ef..82bec94 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -28,6 +28,7 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 #include <linux/list.h>
+#include <linux/flex_array.h>
 #include <net/sock.h>
 #include <net/netfilter/nf_queue.h>
 
@@ -37,7 +38,8 @@
 #include "../bridge/br_private.h"
 #endif
 
-#define NFQNL_QMAX_DEFAULT 1024
+#define NFQNL_QMAX_DEFAULT	1024
+#define NFQNL_QHTBLSIZ_DEFAULT	1
 
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
@@ -49,6 +51,7 @@ struct nfqnl_instance {
 	unsigned int queue_total;
 	unsigned int queue_dropped;
 	unsigned int queue_user_dropped;
+	unsigned int queue_htblsiz;
 
 	unsigned int id_sequence;		/* 'sequence' of pkt ids */
 
@@ -57,7 +60,7 @@ struct nfqnl_instance {
 
 	spinlock_t lock;
 
-	struct list_head queue_list;		/* packets in queue */
+	struct flex_array *fa;
 };
 
 typedef int (*nfqnl_cmpfn)(struct nf_queue_entry *, unsigned long);
@@ -91,7 +94,7 @@ static struct nfqnl_instance *
 instance_create(u_int16_t queue_num, int pid)
 {
 	struct nfqnl_instance *inst;
-	unsigned int h;
+	unsigned int h, i;
 	int err;
 
 	spin_lock(&instances_lock);
@@ -112,11 +115,24 @@ instance_create(u_int16_t queue_num, int pid)
 	inst->copy_range = 0xfffff;
 	inst->copy_mode = NFQNL_COPY_NONE;
 	spin_lock_init(&inst->lock);
-	INIT_LIST_HEAD(&inst->queue_list);
+	inst->queue_htblsiz = NFQNL_QHTBLSIZ_DEFAULT;
+	inst->fa = flex_array_alloc(sizeof(struct list_head),
+	                            inst->queue_htblsiz,
+				    __GFP_ZERO | GFP_ATOMIC);
+	if (inst->fa == NULL) {
+		err = -ENOMEM;
+		goto out_free_inst;
+	}
+	err = flex_array_prealloc(inst->fa, 0, inst->queue_htblsiz - 1,
+				  __GFP_ZERO | GFP_ATOMIC);
+	if (err != 0)
+		goto out_free_fa;
+	for (i = 0; i < inst->queue_htblsiz; i++)
+		INIT_LIST_HEAD((struct list_head*)flex_array_get(inst->fa, i));
 
 	if (!try_module_get(THIS_MODULE)) {
 		err = -EAGAIN;
-		goto out_free;
+		goto out_free_fa;
 	}
 
 	h = instance_hashfn(queue_num);
@@ -126,7 +142,9 @@ instance_create(u_int16_t queue_num, int pid)
 
 	return inst;
 
-out_free:
+out_free_fa:
+	flex_array_free(inst->fa);
+out_free_inst:
 	kfree(inst);
 out_unlock:
 	spin_unlock(&instances_lock);
@@ -143,6 +161,7 @@ instance_destroy_rcu(struct rcu_head *head)
 						   rcu);
 
 	nfqnl_flush(inst, NULL, 0);
+	flex_array_free(inst->fa);
 	kfree(inst);
 	module_put(THIS_MODULE);
 }
@@ -162,21 +181,32 @@ instance_destroy(struct nfqnl_instance *inst)
 	spin_unlock(&instances_lock);
 }
 
+static inline struct list_head *nfqnl_head_get(struct nfqnl_instance *queue,
+					       unsigned int id)
+{
+	return flex_array_get(queue->fa, id % queue->queue_htblsiz);
+}
+
 static inline void
 __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
-       list_add_tail(&entry->list, &queue->queue_list);
-       queue->queue_total++;
+	struct list_head *head;
+
+	head = nfqnl_head_get(queue, entry->id);
+	list_add_tail(&entry->list, head);
+	queue->queue_total++;
 }
 
 static struct nf_queue_entry *
 find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 {
 	struct nf_queue_entry *entry = NULL, *i;
+	struct list_head *head;
 
 	spin_lock_bh(&queue->lock);
 
-	list_for_each_entry(i, &queue->queue_list, list) {
+	head = nfqnl_head_get(queue, id);
+	list_for_each_entry(i, head, list) {
 		if (i->id == id) {
 			entry = i;
 			break;
@@ -197,13 +227,22 @@ static void
 nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 {
 	struct nf_queue_entry *entry, *next;
+	unsigned int i, total;
+	struct list_head *head;
 
 	spin_lock_bh(&queue->lock);
-	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
-		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
-			queue->queue_total--;
-			nf_reinject(entry, NF_DROP);
+	total = queue->queue_total;
+	for (i = 0; i < queue->queue_htblsiz; i++) {
+		if (total < 1)
+			break;
+		head = flex_array_get(queue->fa, i);
+		list_for_each_entry_safe(entry, next, head, list) {
+			if (!cmpfn || cmpfn(entry, data)) {
+				list_del(&entry->list);
+				queue->queue_total--;
+				nf_reinject(entry, NF_DROP);
+			}
+			--total;
 		}
 	}
 	spin_unlock_bh(&queue->lock);
@@ -686,6 +725,46 @@ static const struct nf_queue_handler nfqh = {
 	.outfn	= &nfqnl_enqueue_packet,
 };
 
+static int nfqnl_htbl_resize(struct nfqnl_instance *queue, unsigned int size)
+{
+	struct flex_array *fa;
+	unsigned int i, total;
+	struct list_head *h;
+	struct nf_queue_entry *entry, *next;
+
+	if (size < 1)
+		return -EINVAL;
+	
+	fa = flex_array_alloc(sizeof(struct list_head), size,
+			      __GFP_ZERO | GFP_ATOMIC);
+	if (fa == NULL)
+		return -ENOMEM;
+	if (flex_array_prealloc(fa, 0, size - 1, __GFP_ZERO | GFP_ATOMIC)) {
+		flex_array_free(fa);
+		return -ENOMEM;
+	}
+	for (i = 0; i < size; i++)
+		INIT_LIST_HEAD((struct list_head*)flex_array_get(fa, i));
+	spin_lock_bh(&queue->lock);
+	swap(size, queue->queue_htblsiz);
+	swap(fa, queue->fa);
+	total = queue->queue_total;
+	for (i = 0; i < size; i++) {
+		if (total < 1)
+			break;
+		h = flex_array_get(fa, i);
+		list_for_each_entry_safe(entry, next, h, list) {
+			list_move_tail(&entry->list,
+				       nfqnl_head_get(queue, entry->id));
+			--total;
+		}
+	}
+	spin_unlock_bh(&queue->lock);
+	flex_array_free(fa);
+
+	return 0;
+}
+
 static int
 nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		  const struct nlmsghdr *nlh,
@@ -772,6 +851,17 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		spin_unlock_bh(&queue->lock);
 	}
 
+	if (nfqa[NFQA_CFG_QUEUE_HTBLSIZ]) {
+		__be32 *htblsiz;
+
+		if (!queue) {
+			ret = -ENODEV;
+			goto err_out_unlock;
+		}
+		htblsiz = nla_data(nfqa[NFQA_CFG_QUEUE_HTBLSIZ]);
+		ret = nfqnl_htbl_resize(queue, ntohl(*htblsiz));
+	}
+
 err_out_unlock:
 	rcu_read_unlock();
 	return ret;


