From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] nfnetlink_queue: use hash table to speed up entry lookup
Date: Tue, 20 Apr 2010 22:31:36 +0800
Message-ID: <1271773896-28246-1-git-send-email-xiaosuo@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Changli Gao <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:42778 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0DTOda (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:33:30 -0400
Received: by fg-out-1718.google.com with SMTP id d23so2565025fga.1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2010 07:33:28 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

use hash table to speed up entry lookup

A hash table is used to speed up entry lookup when the verdicts aren't received
in order. The size of hash table can be specified by NFQA_CFG_QUEUE_HTBLSIZ.
Its default value is 1. Reciprocal division is used to lower the cost of
division, and the entry IDs are generated carefully to get fair entry
distribution in the buckets of the hash table.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 include/linux/netfilter/nfnetlink_queue.h |    1 
 init/Kconfig                              |    1 
 lib/Kconfig                               |    3 
 lib/Makefile                              |    4 
 lib/reciprocal_div.c                      |    2 
 net/netfilter/Kconfig                     |    1 
 net/netfilter/nfnetlink_queue.c           |  252 +++++++++++++++++++++++++-----
 7 files changed, 227 insertions(+), 37 deletions(-)
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
diff --git a/init/Kconfig b/init/Kconfig
index cb6069e..4b4266f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1059,6 +1059,7 @@ choice
 
 config SLAB
 	bool "SLAB"
+	select RECIPROCAL_DIV
 	help
 	  The regular slab allocator that is established and known to work
 	  well in all environments. It organizes cache hot objects in
diff --git a/lib/Kconfig b/lib/Kconfig
index af12831..0c4b5ec 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -231,4 +231,7 @@ config IOQ
 
 	 If unsure, say N
 
+config RECIPROCAL_DIV
+       bool
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 0a6ab6f..c3555bd 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -10,7 +10,7 @@ endif
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
-	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
+	 sha1.o irq_regs.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o flex_array.o
 
@@ -103,6 +103,8 @@ obj-$(CONFIG_GENERIC_CSUM) += checksum.o
 
 obj-$(CONFIG_GENERIC_ATOMIC64) += atomic64.o
 
+obj-$(CONFIG_RECIPROCAL_DIV) += reciprocal_div.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/reciprocal_div.c b/lib/reciprocal_div.c
index 6a3bd48..39f2e5e 100644
--- a/lib/reciprocal_div.c
+++ b/lib/reciprocal_div.c
@@ -1,5 +1,6 @@
 #include <asm/div64.h>
 #include <linux/reciprocal_div.h>
+#include <linux/module.h>
 
 u32 reciprocal_value(u32 k)
 {
@@ -7,3 +8,4 @@ u32 reciprocal_value(u32 k)
 	do_div(val, k);
 	return (u32)val;
 }
+EXPORT_SYMBOL(reciprocal_value);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 18d77b5..40b34d5 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -8,6 +8,7 @@ config NETFILTER_NETLINK_QUEUE
 	tristate "Netfilter NFQUEUE over NFNETLINK interface"
 	depends on NETFILTER_ADVANCED
 	select NETFILTER_NETLINK
+	select RECIPROCAL_DIV
 	help
 	  If this option is enabled, the kernel will include support
 	  for queueing packets via NFNETLINK.
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index e70a6ef..d3d02b7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -28,6 +28,8 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 #include <linux/list.h>
+#include <linux/vmalloc.h>
+#include <linux/reciprocal_div.h>
 #include <net/sock.h>
 #include <net/netfilter/nf_queue.h>
 
@@ -37,11 +39,13 @@
 #include "../bridge/br_private.h"
 #endif
 
-#define NFQNL_QMAX_DEFAULT 1024
+#define NFQNL_QMAX_DEFAULT	1024
+#define NFQNL_QHTBLSIZ_DEFAULT	1
 
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
 	struct rcu_head rcu;
+	struct work_struct work;
 
 	int peer_pid;
 	unsigned int queue_maxlen;
@@ -49,15 +53,21 @@ struct nfqnl_instance {
 	unsigned int queue_total;
 	unsigned int queue_dropped;
 	unsigned int queue_user_dropped;
+	unsigned int queue_htblsiz;
+	u32 reciprocal_value;
 
 	unsigned int id_sequence;		/* 'sequence' of pkt ids */
+	unsigned int id_increment;
+	unsigned int id_offset;
+	unsigned int id_limit;
 
 	u_int16_t queue_num;			/* number of this queue */
 	u_int8_t copy_mode;
 
 	spinlock_t lock;
 
-	struct list_head queue_list;		/* packets in queue */
+	struct list_head *queue_htbl;		/* packets in queue */
+	bool vmalloc;
 };
 
 typedef int (*nfqnl_cmpfn)(struct nf_queue_entry *, unsigned long);
@@ -87,49 +97,87 @@ instance_lookup(u_int16_t queue_num)
 	return NULL;
 }
 
+static void instance_destroy_work(struct work_struct *work)
+{
+	struct nfqnl_instance *inst;
+
+	inst = container_of(work, struct nfqnl_instance, work);
+	if (inst->vmalloc)
+		vfree(inst->queue_htbl);
+	else
+		kfree(inst->queue_htbl);
+	kfree(inst);
+	module_put(THIS_MODULE);
+}
+
 static struct nfqnl_instance *
 instance_create(u_int16_t queue_num, int pid)
 {
 	struct nfqnl_instance *inst;
-	unsigned int h;
+	unsigned int h, i;
 	int err;
 
-	spin_lock(&instances_lock);
-	if (instance_lookup(queue_num)) {
-		err = -EEXIST;
-		goto out_unlock;
-	}
-
+	rcu_read_unlock();
 	inst = kzalloc(sizeof(*inst), GFP_ATOMIC);
 	if (!inst) {
 		err = -ENOMEM;
-		goto out_unlock;
+		goto out_lock;
 	}
 
+	INIT_WORK(&inst->work, instance_destroy_work);
 	inst->queue_num = queue_num;
 	inst->peer_pid = pid;
 	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
 	inst->copy_range = 0xfffff;
 	inst->copy_mode = NFQNL_COPY_NONE;
 	spin_lock_init(&inst->lock);
-	INIT_LIST_HEAD(&inst->queue_list);
+	inst->queue_htblsiz = NFQNL_QHTBLSIZ_DEFAULT;
+	inst->id_increment = INT_MAX / inst->queue_htblsiz;
+	inst->id_limit = inst->id_increment * inst->queue_htblsiz;
+	inst->reciprocal_value = reciprocal_value(inst->id_increment);
+	inst->queue_htbl = kmalloc(sizeof(struct list_head) *
+				   inst->queue_htblsiz, GFP_KERNEL);
+	if (inst->queue_htbl == NULL) {
+		inst->queue_htbl = vmalloc(sizeof(struct list_head) *
+					   inst->queue_htblsiz);
+		if (inst->queue_htbl == NULL) {
+			err = -ENOMEM;
+			goto out_free;
+		}
+		inst->vmalloc = true;
+	}
+	for (i = 0; i < inst->queue_htblsiz; i++)
+		INIT_LIST_HEAD(&inst->queue_htbl[i]);
 
 	if (!try_module_get(THIS_MODULE)) {
 		err = -EAGAIN;
 		goto out_free;
 	}
+	rcu_read_lock();
 
+	spin_lock(&instances_lock);
+	if (instance_lookup(queue_num)) {
+		err = -EEXIST;
+		spin_unlock(&instances_lock);
+		rcu_read_unlock();
+		goto out_free;
+	}
 	h = instance_hashfn(queue_num);
 	hlist_add_head_rcu(&inst->hlist, &instance_table[h]);
-
 	spin_unlock(&instances_lock);
 
 	return inst;
 
 out_free:
+	if (inst->queue_htbl) {
+		if (inst->vmalloc)
+			vfree(inst->queue_htbl);
+		else
+			kfree(inst->queue_htbl);
+	}
 	kfree(inst);
-out_unlock:
-	spin_unlock(&instances_lock);
+out_lock:
+	rcu_read_lock();
 	return ERR_PTR(err);
 }
 
@@ -143,8 +191,7 @@ instance_destroy_rcu(struct rcu_head *head)
 						   rcu);
 
 	nfqnl_flush(inst, NULL, 0);
-	kfree(inst);
-	module_put(THIS_MODULE);
+	schedule_work(&inst->work);
 }
 
 static void
@@ -162,32 +209,67 @@ instance_destroy(struct nfqnl_instance *inst)
 	spin_unlock(&instances_lock);
 }
 
+static inline struct list_head *nfqnl_head_get(struct nfqnl_instance *queue,
+					       unsigned int id)
+{
+	return &queue->queue_htbl[reciprocal_divide(id,
+						    queue->reciprocal_value)];
+}
+
+static struct nf_queue_entry *__find_entry(struct nfqnl_instance *queue,
+					   u32 id)
+{
+	struct nf_queue_entry *entry;
+	struct list_head *head;
+
+	head = nfqnl_head_get(queue, id);
+	list_for_each_entry(entry, head, list) {
+		if (entry->id == id)
+			return entry;
+	}
+
+	return NULL;
+}
+
+static u32 __get_uniq_id(struct nfqnl_instance *queue)
+{
+	u32 i;
+
+	for (i = 0; i < INT_MAX; i++) {
+		queue->id_sequence += queue->id_increment;
+		if (queue->id_sequence >= queue->id_limit) {
+			if (++queue->id_offset >= queue->id_increment)
+				queue->id_offset = 0;
+			queue->id_sequence = queue->id_offset;
+		}
+		if (__find_entry(queue, queue->id_sequence) == NULL)
+			return queue->id_sequence;
+	}
+
+	return INT_MAX;
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
-	struct nf_queue_entry *entry = NULL, *i;
+	struct nf_queue_entry *entry;
 
 	spin_lock_bh(&queue->lock);
-
-	list_for_each_entry(i, &queue->queue_list, list) {
-		if (i->id == id) {
-			entry = i;
-			break;
-		}
-	}
-
+	entry = __find_entry(queue, id);
 	if (entry) {
 		list_del(&entry->list);
 		queue->queue_total--;
 	}
-
 	spin_unlock_bh(&queue->lock);
 
 	return entry;
@@ -197,13 +279,22 @@ static void
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
+		head = &queue->queue_htbl[i];
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
@@ -262,7 +353,12 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 		break;
 	}
 
-	entry->id = queue->id_sequence++;
+	entry->id = __get_uniq_id(queue);
+	if (entry->id == INT_MAX) {
+		spin_unlock_bh(&queue->lock);
+		return NULL;
+	}
+	__enqueue_entry(queue, entry);
 
 	spin_unlock_bh(&queue->lock);
 
@@ -379,6 +475,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 
 nlmsg_failure:
 nla_put_failure:
+	find_dequeue_entry(queue, entry->id);
 	if (skb)
 		kfree_skb(skb);
 	if (net_ratelimit())
@@ -426,14 +523,14 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		goto err_out_unlock;
 	}
 
-	__enqueue_entry(queue, entry);
-
 	spin_unlock_bh(&queue->lock);
 	return 0;
 
 err_out_free_nskb:
 	kfree_skb(nskb);
 err_out_unlock:
+	list_del(&entry->list);
+	queue->queue_total--;
 	spin_unlock_bh(&queue->lock);
 err_out:
 	return -1;
@@ -686,6 +783,77 @@ static const struct nf_queue_handler nfqh = {
 	.outfn	= &nfqnl_enqueue_packet,
 };
 
+static int nfqnl_htbl_resize(u16 queue_num, int pid, unsigned int size)
+{
+	struct nfqnl_instance *queue;
+	unsigned int i, total;
+	struct list_head *h, *htbl;
+	bool is_vmalloc;
+	int err;
+
+	if (size < 1 || size > INT_MAX)
+		return -EINVAL;
+
+	rcu_read_unlock();
+	htbl = kmalloc(sizeof(*h) * size, GFP_KERNEL);
+	if (htbl == NULL) {
+		htbl = vmalloc(sizeof(*h) * size);
+		if (htbl == NULL) {
+			err = -ENOMEM;
+			goto out_lock;
+		}
+		is_vmalloc = true;
+	} else {
+		is_vmalloc = false;
+	}
+	rcu_read_lock();
+
+	queue = instance_lookup(queue_num);
+	if (!queue || queue->peer_pid != pid) {
+		err = -ENODEV;
+		goto out_free;
+	}
+
+	for (i = 0; i < size; i++)
+		INIT_LIST_HEAD(&htbl[i]);
+	spin_lock_bh(&queue->lock);
+	swap(size, queue->queue_htblsiz);
+	queue->id_increment = INT_MAX / queue->queue_htblsiz;
+	queue->id_limit = queue->id_increment * queue->queue_htblsiz;
+	if (queue->id_offset >= queue->id_increment)
+		queue->id_offset = 0;
+	if (queue->id_sequence >= queue->id_limit)
+		queue->id_sequence = queue->id_offset;
+	queue->reciprocal_value = reciprocal_value(queue->id_increment);
+	swap(htbl, queue->queue_htbl);
+	swap(is_vmalloc, queue->vmalloc);
+	total = queue->queue_total;
+	for (i = 0; i < size; i++) {
+		struct nf_queue_entry *entry, *next;
+
+		if (total < 1)
+			break;
+		h = &queue->queue_htbl[i];
+		list_for_each_entry_safe(entry, next, h, list) {
+			list_move_tail(&entry->list,
+				       nfqnl_head_get(queue, entry->id));
+			--total;
+		}
+	}
+	spin_unlock_bh(&queue->lock);
+	err = 0;
+
+out_free:
+	rcu_read_unlock();
+	if (is_vmalloc)
+		vfree(htbl);
+	else
+		kfree(htbl);
+out_lock:
+	rcu_read_lock();
+	return err;
+}
+
 static int
 nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		  const struct nlmsghdr *nlh,
@@ -772,6 +940,18 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
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
+		ret = nfqnl_htbl_resize(queue_num, NETLINK_CB(skb).pid,
+					ntohl(*htblsiz));
+	}
+
 err_out_unlock:
 	rcu_read_unlock();
 	return ret;
