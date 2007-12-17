From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 51/64]: nfnetlink_{queue,log}: return proper error codes in instance_create
Date: Tue, 18 Dec 2007 00:47:22 +0100 (MET)
Message-ID: <20071217234722.23601.45617.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39040 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088AbXLQXrY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:24 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_{queue,log}: return proper error codes in instance_create

Currently we return EINVAL for "instance exists", "allocation failed" and
"module unloaded below us", which is completely inapproriate.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 686a5513787ed3d89766bb4d8634bbbd43d519dd
tree 907db184c2a29c6a66a71b1ae8897afd8534b5e4
parent 8c9dba4e0c12b9f605bc3856eba21b605ec1284c
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:43 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:59 +0100

 net/netfilter/nfnetlink_log.c   |   14 +++++++++-----
 net/netfilter/nfnetlink_queue.c |   21 ++++++++++++++-------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index c12e1d1..ac58dc9 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -128,19 +128,23 @@ static struct nfulnl_instance *
 instance_create(u_int16_t group_num, int pid)
 {
 	struct nfulnl_instance *inst;
+	int err;
 
 	write_lock_bh(&instances_lock);
 	if (__instance_lookup(group_num)) {
-		inst = NULL;
+		err = -EEXIST;
 		goto out_unlock;
 	}
 
 	inst = kzalloc(sizeof(*inst), GFP_ATOMIC);
-	if (!inst)
+	if (!inst) {
+		err = -ENOMEM;
 		goto out_unlock;
+	}
 
 	if (!try_module_get(THIS_MODULE)) {
 		kfree(inst);
+		err = -EAGAIN;
 		goto out_unlock;
 	}
 
@@ -169,7 +173,7 @@ instance_create(u_int16_t group_num, int pid)
 
 out_unlock:
 	write_unlock_bh(&instances_lock);
-	return NULL;
+	return ERR_PTR(err);
 }
 
 static void __nfulnl_flush(struct nfulnl_instance *inst);
@@ -731,8 +735,8 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 
 			inst = instance_create(group_num,
 					       NETLINK_CB(skb).pid);
-			if (!inst) {
-				ret = -EINVAL;
+			if (IS_ERR(inst)) {
+				ret = PTR_ERR(inst);
 				goto out;
 			}
 			break;
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 370f0af..51476f8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -89,16 +89,21 @@ instance_lookup(u_int16_t queue_num)
 static struct nfqnl_instance *
 instance_create(u_int16_t queue_num, int pid)
 {
-	struct nfqnl_instance *inst = NULL;
+	struct nfqnl_instance *inst;
 	unsigned int h;
+	int err;
 
 	spin_lock(&instances_lock);
-	if (instance_lookup(queue_num))
+	if (instance_lookup(queue_num)) {
+		err = -EEXIST;
 		goto out_unlock;
+	}
 
 	inst = kzalloc(sizeof(*inst), GFP_ATOMIC);
-	if (!inst)
+	if (!inst) {
+		err = -ENOMEM;
 		goto out_unlock;
+	}
 
 	inst->queue_num = queue_num;
 	inst->peer_pid = pid;
@@ -109,8 +114,10 @@ instance_create(u_int16_t queue_num, int pid)
 	INIT_LIST_HEAD(&inst->queue_list);
 	INIT_RCU_HEAD(&inst->rcu);
 
-	if (!try_module_get(THIS_MODULE))
+	if (!try_module_get(THIS_MODULE)) {
+		err = -EAGAIN;
 		goto out_free;
+	}
 
 	h = instance_hashfn(queue_num);
 	hlist_add_head_rcu(&inst->hlist, &instance_table[h]);
@@ -123,7 +130,7 @@ out_free:
 	kfree(inst);
 out_unlock:
 	spin_unlock(&instances_lock);
-	return NULL;
+	return ERR_PTR(err);
 }
 
 static void nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn,
@@ -724,8 +731,8 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 				goto err_out_unlock;
 			}
 			queue = instance_create(queue_num, NETLINK_CB(skb).pid);
-			if (!queue) {
-				ret = -EINVAL;
+			if (IS_ERR(queue)) {
+				ret = PTR_ERR(queue);
 				goto err_out_unlock;
 			}
 			break;
