From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 42/49]: nfnetlink_queue: remove useless debugging
Date: Tue,  4 Dec 2007 13:02:54 +0100 (MET)
Message-ID: <20071204120254.2442.75401.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62233 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbXLDMCz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:55 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: remove useless debugging

Originally I wanted to just remove the QDEBUG macro and use pr_debug, but
none of the messages seems worth keeping.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit adf817a9cb4ba64618227e93a4d4f84fedc72ef1
tree 7395a15bcbda516aa4cc40f3ffde5ab8d813cf2f
parent 264c2cc068091460172646e0611e96611684355a
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:48:14 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:34 +0100

 net/netfilter/nfnetlink_queue.c |   35 ++++-------------------------------
 1 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 37b7655..c3aba1e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -37,14 +37,6 @@
 
 #define NFQNL_QMAX_DEFAULT 1024
 
-#if 0
-#define QDEBUG(x, args ...)	printk(KERN_DEBUG "%s(%d):%s():	" x, 	   \
-					__FILE__, __LINE__, __FUNCTION__,  \
-					## args)
-#else
-#define QDEBUG(x, ...)
-#endif
-
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
 	struct rcu_head rcu;
@@ -96,17 +88,12 @@ instance_lookup(u_int16_t queue_num)
 static struct nfqnl_instance *
 instance_create(u_int16_t queue_num, int pid)
 {
-	struct nfqnl_instance *inst;
+	struct nfqnl_instance *inst = NULL;
 	unsigned int h;
 
-	QDEBUG("entering for queue_num=%u, pid=%d\n", queue_num, pid);
-
 	spin_lock(&instances_lock);
-	if (instance_lookup(queue_num)) {
-		inst = NULL;
-		QDEBUG("aborting, instance already exists\n");
+	if (instance_lookup(queue_num))
 		goto out_unlock;
-	}
 
 	inst = kzalloc(sizeof(*inst), GFP_ATOMIC);
 	if (!inst)
@@ -129,8 +116,6 @@ instance_create(u_int16_t queue_num, int pid)
 
 	spin_unlock(&instances_lock);
 
-	QDEBUG("successfully created new instance\n");
-
 	return inst;
 
 out_free:
@@ -232,8 +217,6 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	struct net_device *outdev;
 	__be32 tmp_uint;
 
-	QDEBUG("entered\n");
-
 	size =    NLMSG_ALIGN(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
@@ -422,19 +405,13 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	struct sk_buff *nskb;
 	struct nfqnl_instance *queue;
 
-	QDEBUG("entered\n");
-
 	/* rcu_read_lock()ed by nf_hook_slow() */
 	queue = instance_lookup(queuenum);
-	if (!queue) {
-		QDEBUG("no queue instance matching\n");
+	if (!queue)
 		return -EINVAL;
-	}
 
-	if (queue->copy_mode == NFQNL_COPY_NONE) {
-		QDEBUG("mode COPY_NONE, aborting\n");
+	if (queue->copy_mode == NFQNL_COPY_NONE)
 		return -EAGAIN;
-	}
 
 	nskb = nfqnl_build_packet_message(queue, entry, &status);
 	if (nskb == NULL)
@@ -568,8 +545,6 @@ nfqnl_dev_drop(int ifindex)
 {
 	int i;
 
-	QDEBUG("entering for ifindex %u\n", ifindex);
-
 	rcu_read_lock();
 
 	for (i = 0; i < INSTANCE_BUCKETS; i++) {
@@ -733,8 +708,6 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	struct nfqnl_msg_config_cmd *cmd = NULL;
 	int ret = 0;
 
-	QDEBUG("entering for msg %u\n", NFNL_MSG_TYPE(nlh->nlmsg_type));
-
 	if (nfqa[NFQA_CFG_CMD]) {
 		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
 
