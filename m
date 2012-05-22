From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [v3 PATCH 1/1] netfilter: Add fail-open support.
Date: Tue, 22 May 2012 17:40:48 +0530
Message-ID: <20120522121048.880.22605.sendpatchset@localhost.localdomain>
References: <20120522121037.880.44203.sendpatchset@localhost.localdomain>
Cc: vivk@us.ibm.com, svajipay@in.ibm.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:57059 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab2EVMRt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 May 2012 08:17:49 -0400
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Tue, 22 May 2012 17:47:30 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4MCAoh35964076
	for <netfilter-devel@vger.kernel.org>; Tue, 22 May 2012 17:40:50 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q4MHeRjh003145
	for <netfilter-devel@vger.kernel.org>; Tue, 22 May 2012 23:10:28 +0530
In-Reply-To: <20120522121037.880.44203.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Implement a new "fail-open" mode where packets are not dropped
upon queue-full condition. This mode can be individually enabled
or disabled per queue using netlink NFAQ_CFG_FLAGS & NFAQ_CFG_MASK
attributes.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
---
 include/linux/netfilter/nfnetlink_queue.h |    5 ++
 net/netfilter/core.c                      |   37 +++++++++++++++++++-
 net/netfilter/nf_queue.c                  |   15 ++++++--
 net/netfilter/nfnetlink_queue.c           |   37 ++++++++++++++++++--
 4 files changed, 87 insertions(+), 7 deletions(-)

diff -ruNp org/include/linux/netfilter/nfnetlink_queue.h new/include/linux/netfilter/nfnetlink_queue.h
--- org/include/linux/netfilter/nfnetlink_queue.h	2012-05-22 08:45:32.648606721 +0530
+++ new/include/linux/netfilter/nfnetlink_queue.h	2012-05-22 16:53:05.035405303 +0530
@@ -84,8 +84,13 @@ enum nfqnl_attr_config {
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
 	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
+	NFQA_CFG_MASK,			/* identify which flags to change */
+	NFQA_CFG_FLAGS,			/* value of these flags (__u32) */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
 
+/* Flags for NFQA_CFG_FLAGS */
+#define NFQA_CFG_F_FAIL_OPEN			(1 << 0)
+
 #endif /* _NFNETLINK_QUEUE_H */
diff -ruNp org/net/netfilter/core.c new/net/netfilter/core.c
--- org/net/netfilter/core.c	2012-05-22 08:45:32.651608253 +0530
+++ new/net/netfilter/core.c	2012-05-22 17:35:51.294216873 +0530
@@ -163,6 +163,31 @@ repeat:
 	return NF_ACCEPT;
 }
 
+/*
+ * Handler was not able to enqueue the packet, and returned ENOSPC
+ * since "fail-open" was enabled. We temporarily accept the skb, or
+ * each segment for a segmented skb, and then free up the header.
+ */
+static void handle_fail_open(struct sk_buff *skb,
+			     int (*okfn)(struct sk_buff *))
+{
+	struct sk_buff *segs;
+	bool gso;
+
+	segs = skb->next ? : skb;
+	gso = skb->next != NULL;
+
+	do {
+		struct sk_buff *nskb = segs->next;
+
+		segs->next = NULL;
+		okfn(segs);
+		segs = nskb;
+	} while (segs);
+
+	if (gso)
+		kfree_skb(skb);
+}
 
 /* Returns 1 if okfn() needs to be executed by the caller,
  * -EPERM for NF_DROP, 0 otherwise. */
@@ -174,6 +199,7 @@ int nf_hook_slow(u_int8_t pf, unsigned i
 {
 	struct list_head *elem;
 	unsigned int verdict;
+	int failopen = 0;
 	int ret = 0;
 
 	/* We may already have this, but read-locks nest anyway */
@@ -184,7 +210,8 @@ next_hook:
 	verdict = nf_iterate(&nf_hooks[pf][hook], skb, hook, indev,
 			     outdev, &elem, okfn, hook_thresh);
 	if (verdict == NF_ACCEPT || verdict == NF_STOP) {
-		ret = 1;
+		if (!failopen) /* don't use the default verdict if 'failopen' */
+			ret = 1;
 	} else if ((verdict & NF_VERDICT_MASK) == NF_DROP) {
 		kfree_skb(skb);
 		ret = NF_DROP_GETERR(verdict);
@@ -199,10 +226,18 @@ next_hook:
 			if (err == -ESRCH &&
 			   (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
 				goto next_hook;
+			if (err == -ENOSPC) {
+				failopen = 1;
+				goto next_hook;
+			}
 			kfree_skb(skb);
 		}
 	}
 	rcu_read_unlock();
+
+	if (!ret && failopen)
+		handle_fail_open(skb, okfn);
+
 	return ret;
 }
 EXPORT_SYMBOL(nf_hook_slow);
diff -ruNp org/net/netfilter/nfnetlink_queue.c new/net/netfilter/nfnetlink_queue.c
--- org/net/netfilter/nfnetlink_queue.c	2012-05-22 08:45:32.652606825 +0530
+++ new/net/netfilter/nfnetlink_queue.c	2012-05-22 16:51:21.876842922 +0530
@@ -52,6 +52,7 @@ struct nfqnl_instance {
 
 	u_int16_t queue_num;			/* number of this queue */
 	u_int8_t copy_mode;
+	u_int32_t flags;			/* Set using NFQA_CFG_FLAGS */
 /*
  * Following fields are dirtied for each queued packet,
  * keep them in same cache line if possible.
@@ -431,9 +432,14 @@ nfqnl_enqueue_packet(struct nf_queue_ent
 		goto err_out_free_nskb;
 	}
 	if (queue->queue_total >= queue->queue_maxlen) {
-		queue->queue_dropped++;
-		net_warn_ratelimited("nf_queue: full at %d entries, dropping packets(s)\n",
-				     queue->queue_total);
+		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
+			/* Accept the packet temporarily skipping rules */
+			err = -ENOSPC;
+		} else {
+			queue->queue_dropped++;
+			net_warn_ratelimited("nf_queue: full at %d entries, dropping packets(s)\n",
+					     queue->queue_total);
+		}
 		goto err_out_free_nskb;
 	}
 	entry->id = ++queue->id_sequence;
@@ -858,6 +864,31 @@ nfqnl_recv_config(struct sock *ctnl, str
 		spin_unlock_bh(&queue->lock);
 	}
 
+	if (nfqa[NFQA_CFG_FLAGS]) {
+		u_int32_t *flags, *mask;
+
+		if (!queue) {
+			ret = -ENODEV;
+			goto err_out_unlock;
+		}
+
+		if (!nfqa[NFQA_CFG_MASK]) {
+			/* A mask is needed to tell which flags are being
+			 * changed.
+			 * */
+			ret = -EINVAL;
+			goto err_out_unlock;
+		}
+
+		flags = nla_data(nfqa[NFQA_CFG_FLAGS]);
+		mask = nla_data(nfqa[NFQA_CFG_MASK]);
+
+		spin_lock_bh(&queue->lock);
+		queue->flags &= ~ntohl(*mask);
+		queue->flags |= ntohl(*flags) & ntohl(*mask);
+		spin_unlock_bh(&queue->lock);
+	}
+
 err_out_unlock:
 	rcu_read_unlock();
 	return ret;
diff -ruNp org/net/netfilter/nf_queue.c new/net/netfilter/nf_queue.c
--- org/net/netfilter/nf_queue.c	2012-05-22 08:45:32.649606572 +0530
+++ new/net/netfilter/nf_queue.c	2012-05-22 14:21:19.578299181 +0530
@@ -268,14 +268,23 @@ int nf_queue(struct sk_buff *skb,
 			err = __nf_queue(segs, elem, pf, hook, indev,
 					   outdev, okfn, queuenum);
 		}
-		if (err == 0)
+
+		if (err == 0) {
 			queued++;
-		else
+		} else if (err == -ENOSPC) {
+			/* Queue failed due to queue-full and handler is
+			 * in "fail-open" mode.
+			 */
+			segs->next = nskb;
+			skb->next = segs;
+			break;
+		} else {
 			kfree_skb(segs);
+		}
 		segs = nskb;
 	} while (segs);
 
-	if (queued) {
+	if (queued && err != -ENOSPC) {
 		kfree_skb(skb);
 		return 0;
 	}

