From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/5] netfilter: move skb_gso_segment into nfnetlink_queue module
Date: Tue, 16 Apr 2013 17:32:06 +0200
Message-ID: <1366126328-25874-4-git-send-email-fw@strlen.de>
References: <1366126328-25874-1-git-send-email-fw@strlen.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41723 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757381Ab3DPPaH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:30:07 -0400
In-Reply-To: <1366126328-25874-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is nothing wrong with the current code.

However, skb_gso_segment is expensive, so it would be nice
if we could avoid it in the future.

Since userspace must be prepared to receive larger-than-mtu-packets
(which will also have incorrect l3/l4 checksums), we cannot simply
remove it.

The plan is to add a per-queue feature flag that userspace can
set when binding the queue.

The problem is that in nf_queue, we only have a queue number,
not the queue context/configuration settings.

This patch should have no impact other than the skb_gso_segment
call now being in a function that has access to the queue config data.

The size new size attribute in nf_queue_entry is needed so
nfnetlink_queue can duplicate the entry of the gso skb
when segmenting the skb while also copying the route key.

Next step: avoid skb_gso_segment when queue config says so.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_queue.h     |    6 ++
 net/netfilter/nf_queue.c             |   96 ++--------------------
 net/netfilter/nfnetlink_queue_core.c |  143 ++++++++++++++++++++++++++++++----
 3 files changed, 141 insertions(+), 104 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index fb1c0be..aaba4bb 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -9,10 +9,13 @@ struct nf_queue_entry {
 
 	struct nf_hook_ops	*elem;
 	u_int8_t		pf;
+	u16			size; /* sizeof(entry) + saved route keys */
 	unsigned int		hook;
 	struct net_device	*indev;
 	struct net_device	*outdev;
 	int			(*okfn)(struct sk_buff *);
+
+	/* extra space to store route keys */
 };
 
 #define nf_queue_entry_reroute(x) ((void *)x + sizeof(struct nf_queue_entry))
@@ -27,4 +30,7 @@ void nf_register_queue_handler(const struct nf_queue_handler *qh);
 void nf_unregister_queue_handler(void);
 extern void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
 
+bool nf_queue_entry_get_refs(struct nf_queue_entry *entry);
+void nf_queue_entry_release_refs(struct nf_queue_entry *entry);
+
 #endif /* _NF_QUEUE_H */
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 40a5001..36dfc45 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -40,7 +40,7 @@ void nf_unregister_queue_handler(void)
 }
 EXPORT_SYMBOL(nf_unregister_queue_handler);
 
-static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
+void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 {
 	/* Release those devices we held, or Alexey will kill me. */
 	if (entry->indev)
@@ -60,9 +60,10 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	/* Drop reference to owner of hook which queued us. */
 	module_put(entry->elem->owner);
 }
+EXPORT_SYMBOL_GPL(nf_queue_entry_release_refs);
 
 /* Bump dev refs so they don't vanish while packet is out */
-static bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
+bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 {
 	if (!try_module_get(entry->elem->owner))
 		return false;
@@ -87,12 +88,13 @@ static bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(nf_queue_entry_get_refs);
 
 /*
  * Any packet that leaves via this function must come back
  * through nf_reinject().
  */
-static int __nf_queue(struct sk_buff *skb,
+int nf_queue(struct sk_buff *skb,
 		      struct nf_hook_ops *elem,
 		      u_int8_t pf, unsigned int hook,
 		      struct net_device *indev,
@@ -132,6 +134,7 @@ static int __nf_queue(struct sk_buff *skb,
 		.indev	= indev,
 		.outdev	= outdev,
 		.okfn	= okfn,
+		.size	= sizeof(*entry) + afinfo->route_key_size,
 	};
 
 	if (!nf_queue_entry_get_refs(entry)) {
@@ -158,87 +161,6 @@ err:
 	return status;
 }
 
-#ifdef CONFIG_BRIDGE_NETFILTER
-/* When called from bridge netfilter, skb->data must point to MAC header
- * before calling skb_gso_segment(). Else, original MAC header is lost
- * and segmented skbs will be sent to wrong destination.
- */
-static void nf_bridge_adjust_skb_data(struct sk_buff *skb)
-{
-	if (skb->nf_bridge)
-		__skb_push(skb, skb->network_header - skb->mac_header);
-}
-
-static void nf_bridge_adjust_segmented_data(struct sk_buff *skb)
-{
-	if (skb->nf_bridge)
-		__skb_pull(skb, skb->network_header - skb->mac_header);
-}
-#else
-#define nf_bridge_adjust_skb_data(s) do {} while (0)
-#define nf_bridge_adjust_segmented_data(s) do {} while (0)
-#endif
-
-int nf_queue(struct sk_buff *skb,
-	     struct nf_hook_ops *elem,
-	     u_int8_t pf, unsigned int hook,
-	     struct net_device *indev,
-	     struct net_device *outdev,
-	     int (*okfn)(struct sk_buff *),
-	     unsigned int queuenum)
-{
-	struct sk_buff *segs;
-	int err = -EINVAL;
-	unsigned int queued;
-
-	if (!skb_is_gso(skb))
-		return __nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
-				  queuenum);
-
-	switch (pf) {
-	case NFPROTO_IPV4:
-		skb->protocol = htons(ETH_P_IP);
-		break;
-	case NFPROTO_IPV6:
-		skb->protocol = htons(ETH_P_IPV6);
-		break;
-	}
-
-	nf_bridge_adjust_skb_data(skb);
-	segs = skb_gso_segment(skb, 0);
-	/* Does not use PTR_ERR to limit the number of error codes that can be
-	 * returned by nf_queue.  For instance, callers rely on -ECANCELED to mean
-	 * 'ignore this hook'.
-	 */
-	if (IS_ERR(segs))
-		goto out_err;
-	queued = 0;
-	err = 0;
-	do {
-		struct sk_buff *nskb = segs->next;
-
-		segs->next = NULL;
-		if (err == 0) {
-			nf_bridge_adjust_segmented_data(segs);
-			err = __nf_queue(segs, elem, pf, hook, indev,
-					   outdev, okfn, queuenum);
-		}
-		if (err == 0)
-			queued++;
-		else
-			kfree_skb(segs);
-		segs = nskb;
-	} while (segs);
-
-	if (queued) {
-		kfree_skb(skb);
-		return 0;
-	}
-  out_err:
-	nf_bridge_adjust_segmented_data(skb);
-	return err;
-}
-
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	struct sk_buff *skb = entry->skb;
@@ -278,9 +200,9 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		local_bh_enable();
 		break;
 	case NF_QUEUE:
-		err = __nf_queue(skb, elem, entry->pf, entry->hook,
-				 entry->indev, entry->outdev, entry->okfn,
-				 verdict >> NF_VERDICT_QBITS);
+		err = nf_queue(skb, elem, entry->pf, entry->hook,
+				entry->indev, entry->outdev, entry->okfn,
+				verdict >> NF_VERDICT_QBITS);
 		if (err < 0) {
 			if (err == -ECANCELED)
 				goto next_hook;
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 94e2e4f..8ccaece 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -479,28 +479,13 @@ nla_put_failure:
 }
 
 static int
-nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
+__nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
+			struct nf_queue_entry *entry)
 {
 	struct sk_buff *nskb;
-	struct nfqnl_instance *queue;
 	int err = -ENOBUFS;
 	__be32 *packet_id_ptr;
 	int failopen = 0;
-	struct net *net = dev_net(entry->indev ?
-				  entry->indev : entry->outdev);
-	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
-
-	/* rcu_read_lock()ed by nf_hook_slow() */
-	queue = instance_lookup(q, queuenum);
-	if (!queue) {
-		err = -ESRCH;
-		goto err_out;
-	}
-
-	if (queue->copy_mode == NFQNL_COPY_NONE) {
-		err = -EINVAL;
-		goto err_out;
-	}
 
 	nskb = nfqnl_build_packet_message(queue, entry, &packet_id_ptr);
 	if (nskb == NULL) {
@@ -545,6 +530,130 @@ err_out:
 	return err;
 }
 
+static struct nf_queue_entry *
+nf_queue_entry_dup(struct nf_queue_entry *e)
+{
+	struct nf_queue_entry *entry = kmemdup(e, e->size, GFP_ATOMIC);
+	if (entry) {
+		if (nf_queue_entry_get_refs(entry))
+			return entry;
+		kfree(entry);
+	}
+	return NULL;
+}
+
+#ifdef CONFIG_BRIDGE_NETFILTER
+/* When called from bridge netfilter, skb->data must point to MAC header
+ * before calling skb_gso_segment(). Else, original MAC header is lost
+ * and segmented skbs will be sent to wrong destination.
+ */
+static void nf_bridge_adjust_skb_data(struct sk_buff *skb)
+{
+	if (skb->nf_bridge)
+		__skb_push(skb, skb->network_header - skb->mac_header);
+}
+
+static void nf_bridge_adjust_segmented_data(struct sk_buff *skb)
+{
+	if (skb->nf_bridge)
+		__skb_pull(skb, skb->network_header - skb->mac_header);
+}
+#else
+#define nf_bridge_adjust_skb_data(s) do {} while (0)
+#define nf_bridge_adjust_segmented_data(s) do {} while (0)
+#endif
+
+static int
+__nfqnl_enqueue_packet_gso(struct net *net, struct nfqnl_instance *queue,
+			   struct nf_queue_entry *entry)
+{
+	struct sk_buff *skb = entry->skb;
+	int ret = -ENOMEM;
+
+	nf_bridge_adjust_segmented_data(skb);
+
+	if (skb->next == NULL) /* last packet, no need to copy entry */
+		return __nfqnl_enqueue_packet(net, queue, entry);
+
+	skb->next = NULL;
+
+	entry = nf_queue_entry_dup(entry);
+	if (entry) {
+		ret = __nfqnl_enqueue_packet(net, queue, entry);
+		if (ret) {
+			nf_queue_entry_release_refs(entry);
+			kfree(entry);
+		}
+	}
+	return ret;
+}
+
+static int
+nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
+{
+	unsigned int queued;
+	struct nfqnl_instance *queue;
+	struct sk_buff *skb, *segs;
+	int err = -ENOBUFS;
+	struct net *net = dev_net(entry->indev ?
+				  entry->indev : entry->outdev);
+	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
+
+	/* rcu_read_lock()ed by nf_hook_slow() */
+	queue = instance_lookup(q, queuenum);
+	if (!queue)
+		return -ESRCH;
+
+	if (queue->copy_mode == NFQNL_COPY_NONE)
+		return -EINVAL;
+
+	if (!skb_is_gso(entry->skb))
+		return __nfqnl_enqueue_packet(net, queue, entry);
+
+	skb = entry->skb;
+
+	switch (entry->pf) {
+	case NFPROTO_IPV4:
+		skb->protocol = htons(ETH_P_IP);
+		break;
+	case NFPROTO_IPV6:
+		skb->protocol = htons(ETH_P_IPV6);
+		break;
+	}
+
+	nf_bridge_adjust_skb_data(skb);
+	segs = skb_gso_segment(skb, 0);
+	/* Does not use PTR_ERR to limit the number of error codes that can be
+	 * returned by nf_queue.  For instance, callers rely on -ECANCELED to
+	 * mean 'ignore this hook'.
+	 */
+	if (IS_ERR(segs))
+		goto out_err;
+	queued = 0;
+	err = 0;
+	do {
+		struct sk_buff *nskb = segs->next;
+
+		if (err == 0) {
+			entry->skb = segs;
+			err = __nfqnl_enqueue_packet_gso(net, queue, entry);
+		}
+		if (err == 0)
+			queued++;
+		else
+			kfree_skb(segs);
+		segs = nskb;
+	} while (segs);
+
+	if (queued) {
+		kfree_skb(skb);
+		return 0;
+	}
+ out_err:
+	nf_bridge_adjust_segmented_data(skb);
+	return err;
+}
+
 static int
 nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e, int diff)
 {
-- 
1.7.8.6

