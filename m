From: Stephen Hemminger <shemminger@osdl.org>
Subject: [PTCH 2.5.68] netfilter using Read Copy Update
Date: Thu, 24 Apr 2003 09:04:06 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030424090406.504ada94.shemminger@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is an update to netfilter core that uses the read-copy-update
instead of brlock.  The code is similar to my earlier patch but less
invasive.

There should be no visible change to the semantics, and the performance
should be the same or better.

Ran a basic test with iptables and NAT, but needs some more through
usage. 

Reviewed by Paul McKenney for RCU.
Sent to Dave and Andrew for inclusion in next -mm tree.

diff -urN -X dontdiff linux-2.5.68/include/linux/list.h linux-2.5-nf/include/linux/list.h
--- linux-2.5.68/include/linux/list.h	2003-04-21 09:18:17.000000000 -0700
+++ linux-2.5-nf/include/linux/list.h	2003-04-22 09:24:10.000000000 -0700
@@ -320,6 +320,16 @@
 	for (pos = (head)->next, n = pos->next; pos != (head); \
 		pos = n, ({ smp_read_barrier_depends(); 0;}), n = pos->next)
 
+/**
+ * list_for_each_continue_rcu	-	iterate over an rcu-protected list 
+ *			continuing from existing point.
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @head:	the head for your list.
+ */
+#define list_for_each_continue_rcu(pos, head) \
+	for ((pos) = (pos)->next, prefetch((pos)->next); (pos) != (head); \
+        	(pos) = (pos)->next, ({ smp_read_barrier_depends(); 0;}), prefetch((pos)->next))
+
 /* 
  * Double linked lists with a single pointer list head. 
  * Mostly useful for hash tables where the two pointer list head is 
diff -urN -X dontdiff linux-2.5.68/net/core/netfilter.c linux-2.5-nf/net/core/netfilter.c
--- linux-2.5.68/net/core/netfilter.c	2003-04-22 16:18:25.000000000 -0700
+++ linux-2.5-nf/net/core/netfilter.c	2003-04-22 09:24:12.000000000 -0700
@@ -19,7 +19,6 @@
 #include <linux/interrupt.h>
 #include <linux/if.h>
 #include <linux/netdevice.h>
-#include <linux/brlock.h>
 #include <linux/inetdevice.h>
 #include <net/sock.h>
 #include <net/route.h>
@@ -40,12 +39,13 @@
 #endif
 
 /* Sockopts only registered and called from user context, so
-   BR_NETPROTO_LOCK would be overkill.  Also, [gs]etsockopt calls may
+   net locking would be overkill.  Also, [gs]etsockopt calls may
    sleep. */
 static DECLARE_MUTEX(nf_sockopt_mutex);
 
 struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
 static LIST_HEAD(nf_sockopts);
+static spinlock_t nf_hook_lock = SPIN_LOCK_UNLOCKED;
 
 /* 
  * A queue handler may be registered for each protocol.  Each is protected by
@@ -56,28 +56,31 @@
 	nf_queue_outfn_t outfn;
 	void *data;
 } queue_handler[NPROTO];
+static rwlock_t queue_handler_lock = RW_LOCK_UNLOCKED;
 
 int nf_register_hook(struct nf_hook_ops *reg)
 {
 	struct list_head *i;
 
-	br_write_lock_bh(BR_NETPROTO_LOCK);
-	for (i = nf_hooks[reg->pf][reg->hooknum].next; 
-	     i != &nf_hooks[reg->pf][reg->hooknum]; 
-	     i = i->next) {
+	spin_lock_bh(&nf_hook_lock);
+	list_for_each(i, &nf_hooks[reg->pf][reg->hooknum]) {
 		if (reg->priority < ((struct nf_hook_ops *)i)->priority)
 			break;
 	}
-	list_add(&reg->list, i->prev);
-	br_write_unlock_bh(BR_NETPROTO_LOCK);
+	list_add_rcu(&reg->list, i->prev);
+	spin_unlock_bh(&nf_hook_lock);
+
+	synchronize_net();
 	return 0;
 }
 
 void nf_unregister_hook(struct nf_hook_ops *reg)
 {
-	br_write_lock_bh(BR_NETPROTO_LOCK);
-	list_del(&reg->list);
-	br_write_unlock_bh(BR_NETPROTO_LOCK);
+	spin_lock_bh(&nf_hook_lock);
+	list_del_rcu(&reg->list);
+	spin_unlock_bh(&nf_hook_lock);
+
+	synchronize_net();
 }
 
 /* Do exclusive ranges overlap? */
@@ -344,7 +347,11 @@
 			       int (*okfn)(struct sk_buff *),
 			       int hook_thresh)
 {
-	for (*i = (*i)->next; *i != head; *i = (*i)->next) {
+	/*
+	 * The caller must not block between calls to this
+	 * function because of risk of continuing from deleted element.
+	 */
+	list_for_each_continue_rcu(*i, head) {
 		struct nf_hook_ops *elem = (struct nf_hook_ops *)*i;
 
 		if (hook_thresh > elem->priority)
@@ -381,7 +388,7 @@
 {      
 	int ret;
 
-	br_write_lock_bh(BR_NETPROTO_LOCK);
+	write_lock_bh(&queue_handler_lock);
 	if (queue_handler[pf].outfn)
 		ret = -EBUSY;
 	else {
@@ -389,7 +396,7 @@
 		queue_handler[pf].data = data;
 		ret = 0;
 	}
-	br_write_unlock_bh(BR_NETPROTO_LOCK);
+	write_unlock_bh(&queue_handler_lock);
 
 	return ret;
 }
@@ -397,10 +404,11 @@
 /* The caller must flush their queue before this */
 int nf_unregister_queue_handler(int pf)
 {
-	br_write_lock_bh(BR_NETPROTO_LOCK);
+	write_lock_bh(&queue_handler_lock);
 	queue_handler[pf].outfn = NULL;
 	queue_handler[pf].data = NULL;
-	br_write_unlock_bh(BR_NETPROTO_LOCK);
+	write_unlock_bh(&queue_handler_lock);
+	
 	return 0;
 }
 
@@ -421,8 +429,9 @@
 	struct net_device *physindev = NULL;
 	struct net_device *physoutdev = NULL;
 #endif
-
+	read_lock(&queue_handler_lock);
 	if (!queue_handler[pf].outfn) {
+		read_unlock(&queue_handler_lock);
 		kfree_skb(skb);
 		return;
 	}
@@ -432,6 +441,7 @@
 		if (net_ratelimit())
 			printk(KERN_ERR "OOM queueing packet %p\n",
 			       skb);
+		read_unlock(&queue_handler_lock);
 		kfree_skb(skb);
 		return;
 	}
@@ -453,6 +463,8 @@
 #endif
 
 	status = queue_handler[pf].outfn(skb, info, queue_handler[pf].data);
+	read_unlock(&queue_handler_lock);
+
 	if (status < 0) {
 		/* James M doesn't say fuck enough. */
 		if (indev) dev_put(indev);
@@ -486,7 +498,7 @@
 	}
 
 	/* We may already have this, but read-locks nest anyway */
-	br_read_lock_bh(BR_NETPROTO_LOCK);
+	rcu_read_lock();
 
 #ifdef CONFIG_NETFILTER_DEBUG
 	if (skb->nf_debug & (1 << hook)) {
@@ -515,7 +527,7 @@
 		break;
 	}
 
-	br_read_unlock_bh(BR_NETPROTO_LOCK);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -525,18 +537,20 @@
 	struct list_head *elem = &info->elem->list;
 	struct list_head *i;
 
-	/* We don't have BR_NETPROTO_LOCK here */
-	br_read_lock_bh(BR_NETPROTO_LOCK);
-	for (i = nf_hooks[info->pf][info->hook].next; i != elem; i = i->next) {
-		if (i == &nf_hooks[info->pf][info->hook]) {
-			/* The module which sent it to userspace is gone. */
-			NFDEBUG("%s: module disappeared, dropping packet.\n",
-			         __FUNCTION__);
-			verdict = NF_DROP;
+	rcu_read_lock();
+	list_for_each_rcu(i, &nf_hooks[info->pf][info->hook]) {
+		if (i == elem) 
 			break;
-		}
 	}
 
+	if (elem == &nf_hooks[info->pf][info->hook]) {
+		/* The module which sent it to userspace is gone. */
+		NFDEBUG("%s: module disappeared, dropping packet.\n",
+			__FUNCTION__);
+		verdict = NF_DROP;
+	}
+
+
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT) {
 		elem = elem->prev;
@@ -564,7 +578,7 @@
 		kfree_skb(skb);
 		break;
 	}
-	br_read_unlock_bh(BR_NETPROTO_LOCK);
+	rcu_read_unlock();
 
 	/* Release those devices we held, or Alexey will kill me. */
 	if (info->indev) dev_put(info->indev);
