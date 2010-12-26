From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/6] netfilter: nfnetlink_queue: return error number to caller
Date: Mon, 27 Dec 2010 00:58:20 +0100
Message-ID: <1293407904-31464-3-git-send-email-fw@strlen.de>
References: <1293407904-31464-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53933 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748Ab0L0ADV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Dec 2010 19:03:21 -0500
In-Reply-To: <1293407904-31464-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

instead of returning -1 on error, return an error number to allow the
caller to handle some errors differently.

To make things simpler try_module_get() failure is no longer special-cased.

The new return values will be used in followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/core.c            |    5 +--
 net/netfilter/nf_queue.c        |   50 ++++++++++++++++++++++----------------
 net/netfilter/nfnetlink_queue.c |   22 +++++++++++------
 3 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 32fcbe2..518a2e3 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -179,9 +179,8 @@ next_hook:
 		if (ret == 0)
 			ret = -EPERM;
 	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
-		if (!nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
-			      verdict >> NF_VERDICT_BITS))
-			goto next_hook;
+		nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
+			       verdict >> NF_VERDICT_BITS);
 	}
 	rcu_read_unlock();
 	return ret;
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 74aebed..a417458 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -115,7 +115,7 @@ static int __nf_queue(struct sk_buff *skb,
 		      int (*okfn)(struct sk_buff *),
 		      unsigned int queuenum)
 {
-	int status;
+	int error = -EINVAL;
 	struct nf_queue_entry *entry = NULL;
 #ifdef CONFIG_BRIDGE_NETFILTER
 	struct net_device *physindev;
@@ -136,8 +136,10 @@ static int __nf_queue(struct sk_buff *skb,
 		goto err_unlock;
 
 	entry = kmalloc(sizeof(*entry) + afinfo->route_key_size, GFP_ATOMIC);
-	if (!entry)
+	if (!entry) {
+		error = -ENOMEM;
 		goto err_unlock;
+	}
 
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
@@ -149,12 +151,8 @@ static int __nf_queue(struct sk_buff *skb,
 		.okfn	= okfn,
 	};
 
-	/* If it's going away, ignore hook. */
-	if (!try_module_get(entry->elem->owner)) {
-		rcu_read_unlock();
-		kfree(entry);
-		return 0;
-	}
+	if (!try_module_get(entry->elem->owner))
+		goto err_unlock;
 
 	/* Bump dev refs so they don't vanish while packet is out */
 	if (indev)
@@ -173,23 +171,23 @@ static int __nf_queue(struct sk_buff *skb,
 #endif
 	skb_dst_force(skb);
 	afinfo->saveroute(skb, entry);
-	status = qh->outfn(entry, queuenum);
+	error = qh->outfn(entry, queuenum);
 
 	rcu_read_unlock();
 
-	if (status < 0) {
+	if (error < 0) {
 		nf_queue_entry_release_refs(entry);
 		goto err;
 	}
 
-	return 1;
+	return 0;
 
 err_unlock:
 	rcu_read_unlock();
 err:
 	kfree_skb(skb);
 	kfree(entry);
-	return 1;
+	return error;
 }
 
 int nf_queue(struct sk_buff *skb,
@@ -201,6 +199,8 @@ int nf_queue(struct sk_buff *skb,
 	     unsigned int queuenum)
 {
 	struct sk_buff *segs;
+	int error = 0;
+	unsigned int queued;
 
 	if (!skb_is_gso(skb))
 		return __nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
@@ -218,18 +218,26 @@ int nf_queue(struct sk_buff *skb,
 	segs = skb_gso_segment(skb, 0);
 	kfree_skb(skb);
 	if (IS_ERR(segs))
-		return 1;
+		return -ENOMEM;
 
+	queued = 0;
 	do {
 		struct sk_buff *nskb = segs->next;
 
 		segs->next = NULL;
-		if (!__nf_queue(segs, elem, pf, hook, indev, outdev, okfn,
-				queuenum))
-			kfree_skb(segs);
+		if (error == 0) {
+			error = __nf_queue(segs, elem, pf, hook, indev,
+					   outdev, okfn, queuenum);
+			if (error == 0)
+				queued++;
+		}
+		kfree_skb(segs);
 		segs = nskb;
 	} while (segs);
-	return 1;
+
+	if (unlikely(error && queued))
+		error = 0;
+	return error;
 }
 
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
@@ -237,6 +245,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	struct sk_buff *skb = entry->skb;
 	struct list_head *elem = &entry->elem->list;
 	const struct nf_afinfo *afinfo;
+	int err;
 
 	rcu_read_lock();
 
@@ -270,10 +279,9 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		local_bh_enable();
 		break;
 	case NF_QUEUE:
-		if (!__nf_queue(skb, elem, entry->pf, entry->hook,
-				entry->indev, entry->outdev, entry->okfn,
-				verdict >> NF_VERDICT_BITS))
-			goto next_hook;
+		__nf_queue(skb, elem, entry->pf, entry->hook,
+				 entry->indev, entry->outdev, entry->okfn,
+				 verdict >> NF_VERDICT_BITS);
 		break;
 	case NF_STOLEN:
 	default:
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 68e67d1..b83123f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -387,25 +387,31 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
 	struct sk_buff *nskb;
 	struct nfqnl_instance *queue;
-	int err;
+	int err = -ENOBUFS;
 
 	/* rcu_read_lock()ed by nf_hook_slow() */
 	queue = instance_lookup(queuenum);
-	if (!queue)
+	if (!queue) {
+		err = -ESRCH;
 		goto err_out;
+	}
 
-	if (queue->copy_mode == NFQNL_COPY_NONE)
+	if (queue->copy_mode == NFQNL_COPY_NONE) {
+		err = -EINVAL;
 		goto err_out;
+	}
 
 	nskb = nfqnl_build_packet_message(queue, entry);
-	if (nskb == NULL)
+	if (nskb == NULL) {
+		err = -ENOMEM;
 		goto err_out;
-
+	}
 	spin_lock_bh(&queue->lock);
 
-	if (!queue->peer_pid)
+	if (!queue->peer_pid) {
+		err = -EINVAL;
 		goto err_out_free_nskb;
-
+	}
 	if (queue->queue_total >= queue->queue_maxlen) {
 		queue->queue_dropped++;
 		if (net_ratelimit())
@@ -432,7 +438,7 @@ err_out_free_nskb:
 err_out_unlock:
 	spin_unlock_bh(&queue->lock);
 err_out:
-	return -1;
+	return err;
 }
 
 static int
-- 
1.7.2.2

