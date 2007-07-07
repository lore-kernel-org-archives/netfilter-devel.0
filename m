From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 49/50]: nf_queue: Use RCU and mutex for queue handlers
Date: Sat,  7 Jul 2007 14:24:10 +0200 (MEST)
Message-ID: <20070707122325.1589.49735.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_queue: Use RCU and mutex for queue handlers

Queue handlers are registered/unregistered in only process context.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8e3656db48ab327c2d6648c67c05b6b6dd6d2a23
tree b236a710184f1f99712f6a613a28ead8876bd64a
parent 31358423dfcfd9d0ab6a6b5f168467ef03272562
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 07 Jul 2007 12:16:11 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:16:11 +0200

 net/netfilter/nf_queue.c |   52 ++++++++++++++++++++++++++--------------------
 1 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index f402894..823fbf4 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -17,7 +17,7 @@
  */
 static struct nf_queue_handler *queue_handler[NPROTO];
 
-static DEFINE_RWLOCK(queue_handler_lock);
+static DEFINE_MUTEX(queue_handler_mutex);
 
 /* return EBUSY when somebody else is registered, return EEXIST if the
  * same handler is registered, return 0 in case of success. */
@@ -28,16 +28,16 @@ int nf_register_queue_handler(int pf, struct nf_queue_handler *qh)
 	if (pf >= NPROTO)
 		return -EINVAL;
 
-	write_lock_bh(&queue_handler_lock);
+	mutex_lock(&queue_handler_mutex);
 	if (queue_handler[pf] == qh)
 		ret = -EEXIST;
 	else if (queue_handler[pf])
 		ret = -EBUSY;
 	else {
-		queue_handler[pf] = qh;
+		rcu_assign_pointer(queue_handler[pf], qh);
 		ret = 0;
 	}
-	write_unlock_bh(&queue_handler_lock);
+	mutex_unlock(&queue_handler_mutex);
 
 	return ret;
 }
@@ -49,14 +49,16 @@ int nf_unregister_queue_handler(int pf, struct nf_queue_handler *qh)
 	if (pf >= NPROTO)
 		return -EINVAL;
 
-	write_lock_bh(&queue_handler_lock);
+	mutex_lock(&queue_handler_mutex);
 	if (queue_handler[pf] != qh) {
-		write_unlock_bh(&queue_handler_lock);
+		mutex_unlock(&queue_handler_mutex);
 		return -EINVAL;
 	}
 
-	queue_handler[pf] = NULL;
-	write_unlock_bh(&queue_handler_lock);
+	rcu_assign_pointer(queue_handler[pf], NULL);
+	mutex_unlock(&queue_handler_mutex);
+
+	synchronize_rcu();
 
 	return 0;
 }
@@ -66,12 +68,14 @@ void nf_unregister_queue_handlers(struct nf_queue_handler *qh)
 {
 	int pf;
 
-	write_lock_bh(&queue_handler_lock);
+	mutex_lock(&queue_handler_mutex);
 	for (pf = 0; pf < NPROTO; pf++)  {
 		if (queue_handler[pf] == qh)
-			queue_handler[pf] = NULL;
+			rcu_assign_pointer(queue_handler[pf], NULL);
 	}
-	write_unlock_bh(&queue_handler_lock);
+	mutex_unlock(&queue_handler_mutex);
+
+	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(nf_unregister_queue_handlers);
 
@@ -94,18 +98,21 @@ static int __nf_queue(struct sk_buff *skb,
 	struct net_device *physoutdev = NULL;
 #endif
 	struct nf_afinfo *afinfo;
+	struct nf_queue_handler *qh;
 
 	/* QUEUE == DROP if noone is waiting, to be safe. */
-	read_lock(&queue_handler_lock);
-	if (!queue_handler[pf]) {
-		read_unlock(&queue_handler_lock);
+	rcu_read_lock();
+
+	qh = rcu_dereference(queue_handler[pf]);
+	if (!qh) {
+		rcu_read_unlock();
 		kfree_skb(skb);
 		return 1;
 	}
 
 	afinfo = nf_get_afinfo(pf);
 	if (!afinfo) {
-		read_unlock(&queue_handler_lock);
+		rcu_read_unlock();
 		kfree_skb(skb);
 		return 1;
 	}
@@ -115,7 +122,7 @@ static int __nf_queue(struct sk_buff *skb,
 		if (net_ratelimit())
 			printk(KERN_ERR "OOM queueing packet %p\n",
 			       skb);
-		read_unlock(&queue_handler_lock);
+		rcu_read_unlock();
 		kfree_skb(skb);
 		return 1;
 	}
@@ -125,7 +132,7 @@ static int __nf_queue(struct sk_buff *skb,
 
 	/* If it's going away, ignore hook. */
 	if (!try_module_get(info->elem->owner)) {
-		read_unlock(&queue_handler_lock);
+		rcu_read_unlock();
 		kfree(info);
 		return 0;
 	}
@@ -143,10 +150,9 @@ static int __nf_queue(struct sk_buff *skb,
 	}
 #endif
 	afinfo->saveroute(skb, info);
-	status = queue_handler[pf]->outfn(skb, info, queuenum,
-					  queue_handler[pf]->data);
+	status = qh->outfn(skb, info, queuenum, qh->data);
 
-	read_unlock(&queue_handler_lock);
+	rcu_read_unlock();
 
 	if (status < 0) {
 		/* James M doesn't say fuck enough. */
@@ -313,13 +319,13 @@ static int seq_show(struct seq_file *s, void *v)
 	loff_t *pos = v;
 	struct nf_queue_handler *qh;
 
-	read_lock_bh(&queue_handler_lock);
-	qh = queue_handler[*pos];
+	rcu_read_lock();
+	qh = rcu_dereference(queue_handler[*pos]);
 	if (!qh)
 		ret = seq_printf(s, "%2lld NONE\n", *pos);
 	else
 		ret = seq_printf(s, "%2lld %s\n", *pos, qh->name);
-	read_unlock_bh(&queue_handler_lock);
+	rcu_read_unlock();
 
 	return ret;
 }
