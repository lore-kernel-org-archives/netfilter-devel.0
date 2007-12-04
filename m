From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 36/49]: nf_queue: clean up error paths
Date: Tue,  4 Dec 2007 13:02:46 +0100 (MET)
Message-ID: <20071204120246.2442.12893.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62213 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbXLDMCr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:47 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_queue: clean up error paths

Move duplicated error handling to end of function and add a helper function
to release the device and module references from the queue entry.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 486aae228a98e75818b5e7091c3efd62c4b0f6a1
tree 94f8024241180f3eb14edfab5dee4388844d9205
parent 79f4f2de87033501ea05a8d47634a8cffd51418c
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:57 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:31 +0100

 net/netfilter/nf_queue.c |   93 ++++++++++++++++++++--------------------------
 1 files changed, 40 insertions(+), 53 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index f0dc727..7796511 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -80,6 +80,27 @@ void nf_unregister_queue_handlers(const struct nf_queue_handler *qh)
 }
 EXPORT_SYMBOL_GPL(nf_unregister_queue_handlers);
 
+static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
+{
+	/* Release those devices we held, or Alexey will kill me. */
+	if (entry->indev)
+		dev_put(entry->indev);
+	if (entry->outdev)
+		dev_put(entry->outdev);
+#ifdef CONFIG_BRIDGE_NETFILTER
+	if (entry->skb->nf_bridge) {
+		struct nf_bridge_info *nf_bridge = entry->skb->nf_bridge;
+
+		if (nf_bridge->physindev)
+			dev_put(nf_bridge->physindev);
+		if (nf_bridge->physoutdev)
+			dev_put(nf_bridge->physoutdev);
+	}
+#endif
+	/* Drop reference to owner of hook which queued us. */
+	module_put(entry->elem->owner);
+}
+
 /*
  * Any packet that leaves via this function must come back
  * through nf_reinject().
@@ -93,10 +114,10 @@ static int __nf_queue(struct sk_buff *skb,
 		      unsigned int queuenum)
 {
 	int status;
-	struct nf_queue_entry *entry;
+	struct nf_queue_entry *entry = NULL;
 #ifdef CONFIG_BRIDGE_NETFILTER
-	struct net_device *physindev = NULL;
-	struct net_device *physoutdev = NULL;
+	struct net_device *physindev;
+	struct net_device *physoutdev;
 #endif
 	struct nf_afinfo *afinfo;
 	const struct nf_queue_handler *qh;
@@ -105,28 +126,16 @@ static int __nf_queue(struct sk_buff *skb,
 	rcu_read_lock();
 
 	qh = rcu_dereference(queue_handler[pf]);
-	if (!qh) {
-		rcu_read_unlock();
-		kfree_skb(skb);
-		return 1;
-	}
+	if (!qh)
+		goto err_unlock;
 
 	afinfo = nf_get_afinfo(pf);
-	if (!afinfo) {
-		rcu_read_unlock();
-		kfree_skb(skb);
-		return 1;
-	}
+	if (!afinfo)
+		goto err_unlock;
 
 	entry = kmalloc(sizeof(*entry) + afinfo->route_key_size, GFP_ATOMIC);
-	if (!entry) {
-		if (net_ratelimit())
-			printk(KERN_ERR "OOM queueing packet %p\n",
-			       skb);
-		rcu_read_unlock();
-		kfree_skb(skb);
-		return 1;
-	}
+	if (!entry)
+		goto err_unlock;
 
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
@@ -166,25 +175,18 @@ static int __nf_queue(struct sk_buff *skb,
 	rcu_read_unlock();
 
 	if (status < 0) {
-		/* James M doesn't say fuck enough. */
-		if (indev)
-			dev_put(indev);
-		if (outdev)
-			dev_put(outdev);
-#ifdef CONFIG_BRIDGE_NETFILTER
-		if (physindev)
-			dev_put(physindev);
-		if (physoutdev)
-			dev_put(physoutdev);
-#endif
-		module_put(entry->elem->owner);
-		kfree(entry);
-		kfree_skb(skb);
-
-		return 1;
+		nf_queue_entry_release_refs(entry);
+		goto err;
 	}
 
 	return 1;
+
+err_unlock:
+	rcu_read_unlock();
+err:
+	kfree_skb(skb);
+	kfree(entry);
+	return 1;
 }
 
 int nf_queue(struct sk_buff *skb,
@@ -235,22 +237,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 
 	rcu_read_lock();
 
-	/* Release those devices we held, or Alexey will kill me. */
-	if (entry->indev)
-		dev_put(entry->indev);
-	if (entry->outdev)
-		dev_put(entry->outdev);
-#ifdef CONFIG_BRIDGE_NETFILTER
-	if (skb->nf_bridge) {
-		if (skb->nf_bridge->physindev)
-			dev_put(skb->nf_bridge->physindev);
-		if (skb->nf_bridge->physoutdev)
-			dev_put(skb->nf_bridge->physoutdev);
-	}
-#endif
-
-	/* Drop reference to owner of hook which queued us. */
-	module_put(entry->elem->owner);
+	nf_queue_entry_release_refs(entry);
 
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT) {
