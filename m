From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/6] netfilter: nfnetlink_queue: return error number to caller
Date: Sun, 16 Jan 2011 14:19:03 +0100
Message-ID: <1295183947-12786-3-git-send-email-fw@strlen.de>
References: <1295183947-12786-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42906 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413Ab1APNYd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:24:33 -0500
In-Reply-To: <1295183947-12786-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

instead of returning -1 on error, return an error number to allow the
caller to handle some errors differently.

ECANCELED is used to indicate that the hook is going away and should be
ignored.

A followup patch will introduce more 'ignore this hook' conditions,
(depending on queue settings) and will move kfree_skb responsibility
to the caller.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
Changes since v1:
- keep 'ignore hook on try_module_get failure' via -ECANCELED retval.
- avoid renaming 'int status' in __nf_queue to reduce diff size
- if queue handler does not exist, return ENOENT instead of EINVAL.
- don't unconditionally free skbs in nf_queue() GSO path
[ all pointed out by Pablo ]

 net/netfilter/core.c            |    6 +++-
 net/netfilter/nf_queue.c        |   44 +++++++++++++++++++++++++++-----------
 net/netfilter/nfnetlink_queue.c |   22 ++++++++++++-------
 3 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index e69d537..91d66d2f 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -179,9 +179,11 @@ next_hook:
 		if (ret == 0)
 			ret = -EPERM;
 	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
-		if (!nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
-			      verdict >> NF_VERDICT_BITS))
+		ret = nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
+			       verdict >> NF_VERDICT_BITS);
+		if (ret == -ECANCELED)
 			goto next_hook;
+		ret = 0;
 	}
 	rcu_read_unlock();
 	return ret;
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 1876f74..c361084 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -125,7 +125,7 @@ static int __nf_queue(struct sk_buff *skb,
 		      int (*okfn)(struct sk_buff *),
 		      unsigned int queuenum)
 {
-	int status;
+	int status = -ENOENT;
 	struct nf_queue_entry *entry = NULL;
 #ifdef CONFIG_BRIDGE_NETFILTER
 	struct net_device *physindev;
@@ -146,8 +146,10 @@ static int __nf_queue(struct sk_buff *skb,
 		goto err_unlock;
 
 	entry = kmalloc(sizeof(*entry) + afinfo->route_key_size, GFP_ATOMIC);
-	if (!entry)
+	if (!entry) {
+		status = -ENOMEM;
 		goto err_unlock;
+	}
 
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
@@ -163,9 +165,8 @@ static int __nf_queue(struct sk_buff *skb,
 	if (!try_module_get(entry->elem->owner)) {
 		rcu_read_unlock();
 		kfree(entry);
-		return 0;
+		return -ECANCELED;
 	}
-
 	/* Bump dev refs so they don't vanish while packet is out */
 	if (indev)
 		dev_hold(indev);
@@ -192,14 +193,14 @@ static int __nf_queue(struct sk_buff *skb,
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
+	return status;
 }
 
 int nf_queue(struct sk_buff *skb,
@@ -211,6 +212,8 @@ int nf_queue(struct sk_buff *skb,
 	     unsigned int queuenum)
 {
 	struct sk_buff *segs;
+	int err;
+	unsigned int queued;
 
 	if (!skb_is_gso(skb))
 		return __nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
@@ -227,19 +230,32 @@ int nf_queue(struct sk_buff *skb,
 
 	segs = skb_gso_segment(skb, 0);
 	kfree_skb(skb);
+	/* Does not use PTR_ERR to limit the number of error codes that can be
+	 * returned by nf_queue.  For instance, callers rely on -ECANCELED to mean
+	 * 'ignore this hook'.
+	 */
 	if (IS_ERR(segs))
-		return 1;
+		return -EINVAL;
 
+	queued = 0;
+	err = 0;
 	do {
 		struct sk_buff *nskb = segs->next;
 
 		segs->next = NULL;
-		if (!__nf_queue(segs, elem, pf, hook, indev, outdev, okfn,
-				queuenum))
+		if (err == 0)
+			err = __nf_queue(segs, elem, pf, hook, indev,
+					   outdev, okfn, queuenum);
+		if (err == 0)
+			queued++;
+		else
 			kfree_skb(segs);
 		segs = nskb;
 	} while (segs);
-	return 1;
+
+	if (unlikely(err && queued))
+		err = 0;
+	return err;
 }
 
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
@@ -247,6 +263,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	struct sk_buff *skb = entry->skb;
 	struct list_head *elem = &entry->elem->list;
 	const struct nf_afinfo *afinfo;
+	int err;
 
 	rcu_read_lock();
 
@@ -280,9 +297,10 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		local_bh_enable();
 		break;
 	case NF_QUEUE:
-		if (!__nf_queue(skb, elem, entry->pf, entry->hook,
-				entry->indev, entry->outdev, entry->okfn,
-				verdict >> NF_VERDICT_BITS))
+		err = __nf_queue(skb, elem, entry->pf, entry->hook,
+				 entry->indev, entry->outdev, entry->okfn,
+				 verdict >> NF_VERDICT_BITS);
+		if (err == -ECANCELED)
 			goto next_hook;
 		break;
 	case NF_STOLEN:
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

