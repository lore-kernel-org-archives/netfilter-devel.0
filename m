From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 50/64]: nfnetlink_log: remove excessive debugging
Date: Tue, 18 Dec 2007 00:47:21 +0100 (MET)
Message-ID: <20071217234721.23601.52879.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39036 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760240AbXLQXrW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:22 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_log: remove excessive debugging

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8c9dba4e0c12b9f605bc3856eba21b605ec1284c
tree 666d63e93a9b2603e18fabffde0e77243bdc76d9
parent 338250942a8a7810a9274028a9d96b8a6d3eecaa
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:41 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:59 +0100

 net/netfilter/nfnetlink_log.c |   45 -----------------------------------------
 1 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 325e93a..c12e1d1 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -45,14 +45,6 @@
 #define PRINTR(x, args...)	do { if (net_ratelimit()) \
 				     printk(x, ## args); } while (0);
 
-#if 0
-#define UDEBUG(x, args ...)	printk(KERN_DEBUG "%s(%d):%s():	" x, 	   \
-					__FILE__, __LINE__, __FUNCTION__,  \
-					## args)
-#else
-#define UDEBUG(x, ...)
-#endif
-
 struct nfulnl_instance {
 	struct hlist_node hlist;	/* global list of instances */
 	spinlock_t lock;
@@ -93,8 +85,6 @@ __instance_lookup(u_int16_t group_num)
 	struct hlist_node *pos;
 	struct nfulnl_instance *inst;
 
-	UDEBUG("entering (group_num=%u)\n", group_num);
-
 	head = &instance_table[instance_hashfn(group_num)];
 	hlist_for_each_entry(inst, pos, head, hlist) {
 		if (inst->group_num == group_num)
@@ -127,7 +117,6 @@ static void
 instance_put(struct nfulnl_instance *inst)
 {
 	if (inst && atomic_dec_and_test(&inst->use)) {
-		UDEBUG("kfree(inst=%p)\n", inst);
 		kfree(inst);
 		module_put(THIS_MODULE);
 	}
@@ -140,13 +129,9 @@ instance_create(u_int16_t group_num, int pid)
 {
 	struct nfulnl_instance *inst;
 
-	UDEBUG("entering (group_num=%u, pid=%d)\n", group_num,
-		pid);
-
 	write_lock_bh(&instances_lock);
 	if (__instance_lookup(group_num)) {
 		inst = NULL;
-		UDEBUG("aborting, instance already exists\n");
 		goto out_unlock;
 	}
 
@@ -178,9 +163,6 @@ instance_create(u_int16_t group_num, int pid)
 	hlist_add_head(&inst->hlist,
 		       &instance_table[instance_hashfn(group_num)]);
 
-	UDEBUG("newly added node: %p, next=%p\n", &inst->hlist,
-		inst->hlist.next);
-
 	write_unlock_bh(&instances_lock);
 
 	return inst;
@@ -196,9 +178,6 @@ static void
 __instance_destroy(struct nfulnl_instance *inst)
 {
 	/* first pull it out of the global list */
-	UDEBUG("removing instance %p (queuenum=%u) from hash\n",
-		inst, inst->group_num);
-
 	hlist_del(&inst->hlist);
 
 	/* then flush all pending packets from skb */
@@ -306,8 +285,6 @@ nfulnl_alloc_skb(unsigned int inst_size, unsigned int pkt_size)
 	struct sk_buff *skb;
 	unsigned int n;
 
-	UDEBUG("entered (%u, %u)\n", inst_size, pkt_size);
-
 	/* alloc skb which should be big enough for a whole multipart
 	 * message.  WARNING: has to be <= 128k due to slab restrictions */
 
@@ -342,10 +319,6 @@ __nfulnl_send(struct nfulnl_instance *inst)
 			  sizeof(struct nfgenmsg));
 
 	status = nfnetlink_unicast(inst->skb, inst->peer_pid, MSG_DONTWAIT);
-	if (status < 0) {
-		UDEBUG("netlink_unicast() failed\n");
-		/* FIXME: statistics */
-	}
 
 	inst->qlen = 0;
 	inst->skb = NULL;
@@ -369,8 +342,6 @@ nfulnl_timer(unsigned long data)
 {
 	struct nfulnl_instance *inst = (struct nfulnl_instance *)data;
 
-	UDEBUG("timer function called, flushing buffer\n");
-
 	spin_lock_bh(&inst->lock);
 	if (inst->skb)
 		__nfulnl_send(inst);
@@ -397,8 +368,6 @@ __build_packet_message(struct nfulnl_instance *inst,
 	__be32 tmp_uint;
 	sk_buff_data_t old_tail = inst->skb->tail;
 
-	UDEBUG("entered\n");
-
 	nlh = NLMSG_PUT(inst->skb, 0, 0,
 			NFNL_SUBSYS_ULOG << 8 | NFULNL_MSG_PACKET,
 			sizeof(struct nfgenmsg));
@@ -544,7 +513,6 @@ __build_packet_message(struct nfulnl_instance *inst,
 	return 0;
 
 nlmsg_failure:
-	UDEBUG("nlmsg_failure\n");
 nla_put_failure:
 	PRINTR(KERN_ERR "nfnetlink_log: error creating log nlmsg\n");
 	return -1;
@@ -609,8 +577,6 @@ nfulnl_log_packet(unsigned int pf,
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp));
 
-	UDEBUG("initial size=%u\n", size);
-
 	spin_lock_bh(&inst->lock);
 
 	if (inst->flags & NFULNL_CFG_F_SEQ)
@@ -637,7 +603,6 @@ nfulnl_log_packet(unsigned int pf,
 			data_len = inst->copy_range;
 
 		size += nla_total_size(data_len);
-		UDEBUG("copy_packet, therefore size now %u\n", size);
 		break;
 
 	default:
@@ -648,8 +613,6 @@ nfulnl_log_packet(unsigned int pf,
 	    size > skb_tailroom(inst->skb) - sizeof(struct nfgenmsg)) {
 		/* either the queue len is too high or we don't have
 		 * enough room in the skb left. flush to userspace. */
-		UDEBUG("flushing old skb\n");
-
 		__nfulnl_flush(inst);
 	}
 
@@ -659,7 +622,6 @@ nfulnl_log_packet(unsigned int pf,
 			goto alloc_failure;
 	}
 
-	UDEBUG("qlen %d, qthreshold %d\n", inst->qlen, qthreshold);
 	inst->qlen++;
 
 	__build_packet_message(inst, skb, data_len, pf,
@@ -681,7 +643,6 @@ unlock_and_release:
 	return;
 
 alloc_failure:
-	UDEBUG("error allocating skb\n");
 	/* FIXME: statistics */
 	goto unlock_and_release;
 }
@@ -704,7 +665,6 @@ nfulnl_rcv_nl_event(struct notifier_block *this,
 			struct hlist_head *head = &instance_table[i];
 
 			hlist_for_each_entry_safe(inst, tmp, t2, head, hlist) {
-				UDEBUG("node = %p\n", inst);
 				if ((n->net == &init_net) &&
 				    (n->pid == inst->peer_pid))
 					__instance_destroy(inst);
@@ -750,8 +710,6 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	struct nfulnl_instance *inst;
 	int ret = 0;
 
-	UDEBUG("entering for msg %u\n", NFNL_MSG_TYPE(nlh->nlmsg_type));
-
 	inst = instance_lookup_get(group_num);
 	if (inst && inst->peer_pid != NETLINK_CB(skb).pid) {
 		ret = -EPERM;
@@ -763,7 +721,6 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		struct nfulnl_msg_config_cmd *cmd;
 
 		cmd = nla_data(nfula[NFULA_CFG_CMD]);
-		UDEBUG("found CFG_CMD for\n");
 
 		switch (cmd->command) {
 		case NFULNL_CFG_CMD_BIND:
@@ -788,11 +745,9 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			instance_destroy(inst);
 			goto out;
 		case NFULNL_CFG_CMD_PF_BIND:
-			UDEBUG("registering log handler for pf=%u\n", pf);
 			ret = nf_log_register(pf, &nfulnl_logger);
 			break;
 		case NFULNL_CFG_CMD_PF_UNBIND:
-			UDEBUG("unregistering log handler for pf=%u\n", pf);
 			/* This is a bug and a feature.  We cannot unregister
 			 * other handlers, like nfnetlink_inst can */
 			nf_log_unregister_pf(pf);
