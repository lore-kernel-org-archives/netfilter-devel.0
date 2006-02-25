From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/6]: nf_queue: don't copy registered rerouter data
Date: Sat, 25 Feb 2006 14:17:41 +0100 (MET)
Message-ID: <20060225131559.7400.41473.sendpatchset@localhost.localdomain>
References: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_queue: don't copy registered rerouter data

Use the registered data structure instead of copying it.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 139a39bf3a1cc347d77582bea8cdabe7d3a25021
tree fa64e102124cf15c9df8672ac15342464882cea2
parent 5c1ca65c93503b2c94359ba39640f9687bd192a3
author Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:43:04 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 25 Feb 2006 13:43:04 +0100

 net/netfilter/nf_queue.c |   28 +++++++++-------------------
 1 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index d3a4f30..24ad41e 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -16,7 +16,7 @@
  * for queueing and must reinject all packets it receives, no matter what.
  */
 static struct nf_queue_handler *queue_handler[NPROTO];
-static struct nf_queue_rerouter *queue_rerouter;
+static struct nf_queue_rerouter *queue_rerouter[NPROTO];
 
 static DEFINE_RWLOCK(queue_handler_lock);
 
@@ -64,7 +64,7 @@ int nf_register_queue_rerouter(int pf, s
 		return -EINVAL;
 
 	write_lock_bh(&queue_handler_lock);
-	memcpy(&queue_rerouter[pf], rer, sizeof(queue_rerouter[pf]));
+	queue_rerouter[pf] = rer;
 	write_unlock_bh(&queue_handler_lock);
 
 	return 0;
@@ -77,7 +77,7 @@ int nf_unregister_queue_rerouter(int pf)
 		return -EINVAL;
 
 	write_lock_bh(&queue_handler_lock);
-	memset(&queue_rerouter[pf], 0, sizeof(queue_rerouter[pf]));
+	queue_rerouter[pf] = NULL;
 	write_unlock_bh(&queue_handler_lock);
 	return 0;
 }
@@ -123,7 +123,7 @@ int nf_queue(struct sk_buff **skb, 
 		return 1;
 	}
 
-	info = kmalloc(sizeof(*info)+queue_rerouter[pf].rer_size, GFP_ATOMIC);
+	info = kmalloc(sizeof(*info)+queue_rerouter[pf]->rer_size, GFP_ATOMIC);
 	if (!info) {
 		if (net_ratelimit())
 			printk(KERN_ERR "OOM queueing packet %p\n",
@@ -155,14 +155,14 @@ int nf_queue(struct sk_buff **skb, 
 		if (physoutdev) dev_hold(physoutdev);
 	}
 #endif
-	if (queue_rerouter[pf].save)
-		queue_rerouter[pf].save(*skb, info);
+	if (queue_rerouter[pf]->save)
+		queue_rerouter[pf]->save(*skb, info);
 
 	status = queue_handler[pf]->outfn(*skb, info, queuenum,
 					  queue_handler[pf]->data);
 
-	if (status >= 0 && queue_rerouter[pf].reroute)
-		status = queue_rerouter[pf].reroute(skb, info);
+	if (status >= 0 && queue_rerouter[pf]->reroute)
+		status = queue_rerouter[pf]->reroute(skb, info);
 
 	read_unlock(&queue_handler_lock);
 
@@ -322,22 +322,12 @@ int __init netfilter_queue_init(void)
 {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *pde;
-#endif
-	queue_rerouter = kmalloc(NPROTO * sizeof(struct nf_queue_rerouter),
-				 GFP_KERNEL);
-	if (!queue_rerouter)
-		return -ENOMEM;
 
-#ifdef CONFIG_PROC_FS
 	pde = create_proc_entry("nf_queue", S_IRUGO, proc_net_netfilter);
-	if (!pde) {
-		kfree(queue_rerouter);
+	if (!pde)
 		return -1;
-	}
 	pde->proc_fops = &nfqueue_file_ops;
 #endif
-	memset(queue_rerouter, 0, NPROTO * sizeof(struct nf_queue_rerouter));
-
 	return 0;
 }
 
