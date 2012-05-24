From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [v5 PATCH 1/1] netfilter: Add fail-open support
Date: Thu, 24 May 2012 19:26:44 +0530
Message-ID: <20120524135644.24345.694.sendpatchset@localhost.localdomain>
References: <20120524135631.24345.60254.sendpatchset@localhost.localdomain>
Cc: vivk@us.ibm.com, svajipay@in.ibm.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:49354 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2EXOCl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 May 2012 10:02:41 -0400
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Thu, 24 May 2012 19:32:00 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4ODukBg3211678
	for <netfilter-devel@vger.kernel.org>; Thu, 24 May 2012 19:26:46 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q4OJRNbU001972
	for <netfilter-devel@vger.kernel.org>; Fri, 25 May 2012 05:27:24 +1000
In-Reply-To: <20120524135631.24345.60254.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Implement a new "fail-open" mode where packets are not dropped
upon queue-full condition. This mode can be enabled/disabled per
queue using netlink NFQA_CFG_FLAGS & NFQA_CFG_MASK attributes.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
---
 include/linux/netfilter/nfnetlink_queue.h |    5 ++
 net/netfilter/nfnetlink_queue.c           |   40 ++++++++++++++++++--
 2 files changed, 42 insertions(+), 3 deletions(-)

diff -ruNp org/include/linux/netfilter/nfnetlink_queue.h new/include/linux/netfilter/nfnetlink_queue.h
--- org/include/linux/netfilter/nfnetlink_queue.h	2012-05-24 15:47:52.361984483 +0530
+++ new/include/linux/netfilter/nfnetlink_queue.h	2012-05-24 16:06:29.123911109 +0530
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
diff -ruNp org/net/netfilter/nfnetlink_queue.c new/net/netfilter/nfnetlink_queue.c
--- org/net/netfilter/nfnetlink_queue.c	2012-05-24 15:47:52.366985562 +0530
+++ new/net/netfilter/nfnetlink_queue.c	2012-05-24 18:12:04.695509859 +0530
@@ -52,6 +52,7 @@ struct nfqnl_instance {
 
 	u_int16_t queue_num;			/* number of this queue */
 	u_int8_t copy_mode;
+	u_int32_t flags;			/* Set using NFQA_CFG_FLAGS */
 /*
  * Following fields are dirtied for each queued packet,
  * keep them in same cache line if possible.
@@ -406,6 +407,7 @@ nfqnl_enqueue_packet(struct nf_queue_ent
 	struct nfqnl_instance *queue;
 	int err = -ENOBUFS;
 	__be32 *packet_id_ptr;
+	int failopen = 0;
 
 	/* rcu_read_lock()ed by nf_hook_slow() */
 	queue = instance_lookup(queuenum);
@@ -431,9 +433,14 @@ nfqnl_enqueue_packet(struct nf_queue_ent
 		goto err_out_free_nskb;
 	}
 	if (queue->queue_total >= queue->queue_maxlen) {
-		queue->queue_dropped++;
-		net_warn_ratelimited("nf_queue: full at %d entries, dropping packets(s)\n",
-				     queue->queue_total);
+		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
+			failopen = 1;
+			err = 0;
+		} else {
+			queue->queue_dropped++;
+			net_warn_ratelimited("nf_queue: full at %d entries, dropping packets(s)\n",
+					     queue->queue_total);
+		}
 		goto err_out_free_nskb;
 	}
 	entry->id = ++queue->id_sequence;
@@ -455,6 +462,8 @@ err_out_free_nskb:
 	kfree_skb(nskb);
 err_out_unlock:
 	spin_unlock_bh(&queue->lock);
+	if (failopen)
+		nf_reinject(entry, NF_ACCEPT);
 err_out:
 	return err;
 }
@@ -858,6 +867,31 @@ nfqnl_recv_config(struct sock *ctnl, str
 		spin_unlock_bh(&queue->lock);
 	}
 
+	if (nfqa[NFQA_CFG_FLAGS]) {
+		__u32 flags, mask;
+
+		if (!queue) {
+			ret = -ENODEV;
+			goto err_out_unlock;
+		}
+
+		if (!nfqa[NFQA_CFG_MASK]) {
+			/* A mask is needed to specify which flags are being
+			 * changed.
+			 */
+			ret = -EINVAL;
+			goto err_out_unlock;
+		}
+
+		flags = ntohl(nla_get_be32(nfqa[NFQA_CFG_FLAGS]));
+		mask = ntohl(nla_get_be32(nfqa[NFQA_CFG_MASK]));
+
+		spin_lock_bh(&queue->lock);
+		queue->flags &= ~mask;
+		queue->flags |= flags & mask;
+		spin_unlock_bh(&queue->lock);
+	}
+
 err_out_unlock:
 	rcu_read_unlock();
 	return ret;

