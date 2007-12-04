From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 40/49]: nfnetlink: use RCU for queue instances hash
Date: Tue,  4 Dec 2007 13:02:52 +0100 (MET)
Message-ID: <20071204120251.2442.57070.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62225 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbXLDMCx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:53 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink: use RCU for queue instances hash

Use RCU for queue instances hash. Avoids multiple atomic operations
for each packet.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1fb555e556b810fbcde356b7865f54f6dcb939d9
tree e4df54fec7ccfae4d0de189ec18dc8b8dc5484f6
parent f7f606b9d4ede9a47a3fd61e40b6b688f845f8d7
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:48:09 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:33 +0100

 net/netfilter/nfnetlink_queue.c |  205 ++++++++++++++++++---------------------
 1 files changed, 92 insertions(+), 113 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 4abf62a..449b880 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -47,7 +47,7 @@
 
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
-	atomic_t use;
+	struct rcu_head rcu;
 
 	int peer_pid;
 	unsigned int queue_maxlen;
@@ -68,7 +68,7 @@ struct nfqnl_instance {
 
 typedef int (*nfqnl_cmpfn)(struct nf_queue_entry *, unsigned long);
 
-static DEFINE_RWLOCK(instances_lock);
+static DEFINE_SPINLOCK(instances_lock);
 
 #define INSTANCE_BUCKETS	16
 static struct hlist_head instance_table[INSTANCE_BUCKETS];
@@ -79,14 +79,14 @@ static inline u_int8_t instance_hashfn(u_int16_t queue_num)
 }
 
 static struct nfqnl_instance *
-__instance_lookup(u_int16_t queue_num)
+instance_lookup(u_int16_t queue_num)
 {
 	struct hlist_head *head;
 	struct hlist_node *pos;
 	struct nfqnl_instance *inst;
 
 	head = &instance_table[instance_hashfn(queue_num)];
-	hlist_for_each_entry(inst, pos, head, hlist) {
+	hlist_for_each_entry_rcu(inst, pos, head, hlist) {
 		if (inst->queue_num == queue_num)
 			return inst;
 	}
@@ -94,37 +94,15 @@ __instance_lookup(u_int16_t queue_num)
 }
 
 static struct nfqnl_instance *
-instance_lookup_get(u_int16_t queue_num)
-{
-	struct nfqnl_instance *inst;
-
-	read_lock_bh(&instances_lock);
-	inst = __instance_lookup(queue_num);
-	if (inst)
-		atomic_inc(&inst->use);
-	read_unlock_bh(&instances_lock);
-
-	return inst;
-}
-
-static void
-instance_put(struct nfqnl_instance *inst)
-{
-	if (inst && atomic_dec_and_test(&inst->use)) {
-		QDEBUG("kfree(inst=%p)\n", inst);
-		kfree(inst);
-	}
-}
-
-static struct nfqnl_instance *
 instance_create(u_int16_t queue_num, int pid)
 {
 	struct nfqnl_instance *inst;
+	unsigned int h;
 
 	QDEBUG("entering for queue_num=%u, pid=%d\n", queue_num, pid);
 
-	write_lock_bh(&instances_lock);
-	if (__instance_lookup(queue_num)) {
+	spin_lock(&instances_lock);
+	if (instance_lookup(queue_num)) {
 		inst = NULL;
 		QDEBUG("aborting, instance already exists\n");
 		goto out_unlock;
@@ -139,18 +117,17 @@ instance_create(u_int16_t queue_num, int pid)
 	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
 	inst->copy_range = 0xfffff;
 	inst->copy_mode = NFQNL_COPY_NONE;
-	/* needs to be two, since we _put() after creation */
-	atomic_set(&inst->use, 2);
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
+	INIT_RCU_HEAD(&inst->rcu);
 
 	if (!try_module_get(THIS_MODULE))
 		goto out_free;
 
-	hlist_add_head(&inst->hlist,
-		       &instance_table[instance_hashfn(queue_num)]);
+	h = instance_hashfn(queue_num);
+	hlist_add_head_rcu(&inst->hlist, &instance_table[h]);
 
-	write_unlock_bh(&instances_lock);
+	spin_unlock(&instances_lock);
 
 	QDEBUG("successfully created new instance\n");
 
@@ -159,7 +136,7 @@ instance_create(u_int16_t queue_num, int pid)
 out_free:
 	kfree(inst);
 out_unlock:
-	write_unlock_bh(&instances_lock);
+	spin_unlock(&instances_lock);
 	return NULL;
 }
 
@@ -167,38 +144,29 @@ static void nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn,
 			unsigned long data);
 
 static void
-_instance_destroy2(struct nfqnl_instance *inst, int lock)
+instance_destroy_rcu(struct rcu_head *head)
 {
-	/* first pull it out of the global list */
-	if (lock)
-		write_lock_bh(&instances_lock);
-
-	QDEBUG("removing instance %p (queuenum=%u) from hash\n",
-		inst, inst->queue_num);
-	hlist_del(&inst->hlist);
+	struct nfqnl_instance *inst = container_of(head, struct nfqnl_instance,
+						   rcu);
 
-	if (lock)
-		write_unlock_bh(&instances_lock);
-
-	/* then flush all pending skbs from the queue */
 	nfqnl_flush(inst, NULL, 0);
-
-	/* and finally put the refcount */
-	instance_put(inst);
-
+	kfree(inst);
 	module_put(THIS_MODULE);
 }
 
-static inline void
+static void
 __instance_destroy(struct nfqnl_instance *inst)
 {
-	_instance_destroy2(inst, 0);
+	hlist_del_rcu(&inst->hlist);
+	call_rcu(&inst->rcu, instance_destroy_rcu);
 }
 
-static inline void
+static void
 instance_destroy(struct nfqnl_instance *inst)
 {
-	_instance_destroy2(inst, 1);
+	spin_lock(&instances_lock);
+	__instance_destroy(inst);
+	spin_unlock(&instances_lock);
 }
 
 static inline void
@@ -485,7 +453,8 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 
 	QDEBUG("entered\n");
 
-	queue = instance_lookup_get(queuenum);
+	/* rcu_read_lock()ed by nf_hook_slow() */
+	queue = instance_lookup(queuenum);
 	if (!queue) {
 		QDEBUG("no queue instance matching\n");
 		return -EINVAL;
@@ -493,13 +462,12 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 
 	if (queue->copy_mode == NFQNL_COPY_NONE) {
 		QDEBUG("mode COPY_NONE, aborting\n");
-		status = -EAGAIN;
-		goto err_out_put;
+		return -EAGAIN;
 	}
 
 	nskb = nfqnl_build_packet_message(queue, entry, &status);
 	if (nskb == NULL)
-		goto err_out_put;
+		return status;
 
 	spin_lock_bh(&queue->lock);
 
@@ -526,7 +494,6 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	__enqueue_entry(queue, entry);
 
 	spin_unlock_bh(&queue->lock);
-	instance_put(queue);
 	return status;
 
 err_out_free_nskb:
@@ -534,9 +501,6 @@ err_out_free_nskb:
 
 err_out_unlock:
 	spin_unlock_bh(&queue->lock);
-
-err_out_put:
-	instance_put(queue);
 	return status;
 }
 
@@ -616,21 +580,18 @@ nfqnl_dev_drop(int ifindex)
 
 	QDEBUG("entering for ifindex %u\n", ifindex);
 
-	/* this only looks like we have to hold the readlock for a way too long
-	 * time, issue_verdict(),  nf_reinject(), ... - but we always only
-	 * issue NF_DROP, which is processed directly in nf_reinject() */
-	read_lock_bh(&instances_lock);
+	rcu_read_lock();
 
-	for  (i = 0; i < INSTANCE_BUCKETS; i++) {
+	for (i = 0; i < INSTANCE_BUCKETS; i++) {
 		struct hlist_node *tmp;
 		struct nfqnl_instance *inst;
 		struct hlist_head *head = &instance_table[i];
 
-		hlist_for_each_entry(inst, tmp, head, hlist)
+		hlist_for_each_entry_rcu(inst, tmp, head, hlist)
 			nfqnl_flush(inst, dev_cmp, ifindex);
 	}
 
-	read_unlock_bh(&instances_lock);
+	rcu_read_unlock();
 }
 
 #define RCV_SKB_FAIL(err) do { netlink_ack(skb, nlh, (err)); return; } while (0)
@@ -665,8 +626,8 @@ nfqnl_rcv_nl_event(struct notifier_block *this,
 		int i;
 
 		/* destroy all instances for this pid */
-		write_lock_bh(&instances_lock);
-		for  (i = 0; i < INSTANCE_BUCKETS; i++) {
+		spin_lock(&instances_lock);
+		for (i = 0; i < INSTANCE_BUCKETS; i++) {
 			struct hlist_node *tmp, *t2;
 			struct nfqnl_instance *inst;
 			struct hlist_head *head = &instance_table[i];
@@ -677,7 +638,7 @@ nfqnl_rcv_nl_event(struct notifier_block *this,
 					__instance_destroy(inst);
 			}
 		}
-		write_unlock_bh(&instances_lock);
+		spin_unlock(&instances_lock);
 	}
 	return NOTIFY_DONE;
 }
@@ -705,18 +666,21 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_queue_entry *entry;
 	int err;
 
-	queue = instance_lookup_get(queue_num);
-	if (!queue)
-		return -ENODEV;
+	rcu_read_lock();
+	queue = instance_lookup(queue_num);
+	if (!queue) {
+		err = -ENODEV;
+		goto err_out_unlock;
+	}
 
 	if (queue->peer_pid != NETLINK_CB(skb).pid) {
 		err = -EPERM;
-		goto err_out_put;
+		goto err_out_unlock;
 	}
 
 	if (!nfqa[NFQA_VERDICT_HDR]) {
 		err = -EINVAL;
-		goto err_out_put;
+		goto err_out_unlock;
 	}
 
 	vhdr = nla_data(nfqa[NFQA_VERDICT_HDR]);
@@ -724,14 +688,15 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 
 	if ((verdict & NF_VERDICT_MASK) > NF_MAX_VERDICT) {
 		err = -EINVAL;
-		goto err_out_put;
+		goto err_out_unlock;
 	}
 
 	entry = find_dequeue_entry(queue, ntohl(vhdr->id));
 	if (entry == NULL) {
 		err = -ENOENT;
-		goto err_out_put;
+		goto err_out_unlock;
 	}
+	rcu_read_unlock();
 
 	if (nfqa[NFQA_PAYLOAD]) {
 		if (nfqnl_mangle(nla_data(nfqa[NFQA_PAYLOAD]),
@@ -744,11 +709,10 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 					 nla_data(nfqa[NFQA_MARK]));
 
 	nf_reinject(entry, verdict);
-	instance_put(queue);
 	return 0;
 
-err_out_put:
-	instance_put(queue);
+err_out_unlock:
+	rcu_read_unlock();
 	return err;
 }
 
@@ -776,45 +740,61 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
 	u_int16_t queue_num = ntohs(nfmsg->res_id);
 	struct nfqnl_instance *queue;
+	struct nfqnl_msg_config_cmd *cmd = NULL;
 	int ret = 0;
 
 	QDEBUG("entering for msg %u\n", NFNL_MSG_TYPE(nlh->nlmsg_type));
 
-	queue = instance_lookup_get(queue_num);
+	if (nfqa[NFQA_CFG_CMD]) {
+		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
+
+		/* Commands without queue context - might sleep */
+		switch (cmd->command) {
+		case NFQNL_CFG_CMD_PF_BIND:
+			ret = nf_register_queue_handler(ntohs(cmd->pf),
+							&nfqh);
+			break;
+		case NFQNL_CFG_CMD_PF_UNBIND:
+			ret = nf_unregister_queue_handler(ntohs(cmd->pf),
+							  &nfqh);
+			break;
+		default:
+			break;
+		}
+
+		if (ret < 0)
+			return ret;
+	}
+
+	rcu_read_lock();
+	queue = instance_lookup(queue_num);
 	if (queue && queue->peer_pid != NETLINK_CB(skb).pid) {
 		ret = -EPERM;
-		goto out_put;
+		goto err_out_unlock;
 	}
 
-	if (nfqa[NFQA_CFG_CMD]) {
-		struct nfqnl_msg_config_cmd *cmd;
-
-		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
-		QDEBUG("found CFG_CMD\n");
-
+	if (cmd != NULL) {
 		switch (cmd->command) {
 		case NFQNL_CFG_CMD_BIND:
-			if (queue)
-				return -EBUSY;
-
+			if (queue) {
+				ret = -EBUSY;
+				goto err_out_unlock;
+			}
 			queue = instance_create(queue_num, NETLINK_CB(skb).pid);
-			if (!queue)
-				return -EINVAL;
+			if (!queue) {
+				ret = -EINVAL;
+				goto err_out_unlock;
+			}
 			break;
 		case NFQNL_CFG_CMD_UNBIND:
-			if (!queue)
-				return -ENODEV;
+			if (!queue) {
+				ret = -ENODEV;
+				goto err_out_unlock;
+			}
 			instance_destroy(queue);
 			break;
 		case NFQNL_CFG_CMD_PF_BIND:
-			QDEBUG("registering queue handler for pf=%u\n",
-				ntohs(cmd->pf));
-			ret = nf_register_queue_handler(ntohs(cmd->pf), &nfqh);
-			break;
 		case NFQNL_CFG_CMD_PF_UNBIND:
-			QDEBUG("unregistering queue handler for pf=%u\n",
-				ntohs(cmd->pf));
-			ret = nf_unregister_queue_handler(ntohs(cmd->pf), &nfqh);
 			break;
 		default:
 			ret = -EINVAL;
@@ -827,7 +807,7 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 
 		if (!queue) {
 			ret = -ENODEV;
-			goto out_put;
+			goto err_out_unlock;
 		}
 		params = nla_data(nfqa[NFQA_CFG_PARAMS]);
 		nfqnl_set_mode(queue, params->copy_mode,
@@ -839,7 +819,7 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 
 		if (!queue) {
 			ret = -ENODEV;
-			goto out_put;
+			goto err_out_unlock;
 		}
 		queue_maxlen = nla_data(nfqa[NFQA_CFG_QUEUE_MAXLEN]);
 		spin_lock_bh(&queue->lock);
@@ -847,8 +827,8 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		spin_unlock_bh(&queue->lock);
 	}
 
-out_put:
-	instance_put(queue);
+err_out_unlock:
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -916,7 +896,7 @@ static struct hlist_node *get_idx(struct seq_file *seq, loff_t pos)
 
 static void *seq_start(struct seq_file *seq, loff_t *pos)
 {
-	read_lock_bh(&instances_lock);
+	spin_lock(&instances_lock);
 	return get_idx(seq, *pos);
 }
 
@@ -928,7 +908,7 @@ static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 
 static void seq_stop(struct seq_file *s, void *v)
 {
-	read_unlock_bh(&instances_lock);
+	spin_unlock(&instances_lock);
 }
 
 static int seq_show(struct seq_file *s, void *v)
@@ -940,8 +920,7 @@ static int seq_show(struct seq_file *s, void *v)
 			  inst->peer_pid, inst->queue_total,
 			  inst->copy_mode, inst->copy_range,
 			  inst->queue_dropped, inst->queue_user_dropped,
-			  inst->id_sequence,
-			  atomic_read(&inst->use));
+			  inst->id_sequence, 1);
 }
 
 static const struct seq_operations nfqnl_seq_ops = {
