From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [RFC] [PATCH 3/4] netfilter: Add support for failopen in nf_queue()
Date: Mon, 07 May 2012 11:34:11 +0530
Message-ID: <20120507060411.19528.45006.sendpatchset@localhost.localdomain>
References: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
Cc: svajipay@in.ibm.com, vivk@us.ibm.com,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54903 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2EGGES (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 02:04:18 -0400
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Mon, 7 May 2012 11:34:16 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4764DId59244586
	for <netfilter-devel@vger.kernel.org>; Mon, 7 May 2012 11:34:13 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q47BYo0H023063
	for <netfilter-devel@vger.kernel.org>; Mon, 7 May 2012 21:34:50 +1000
In-Reply-To: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pass FAILOPEN flags, add support for fail-open, add support for
GSO skb. If __nf_queue() returns >0 to indicate fail-open, we
call okfn() immediately and return 0 to caller.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 net/netfilter/core.c         |    4 ++
 net/netfilter/nf_internals.h |    3 +-
 net/netfilter/nf_queue.c     |   47 ++++++++++++++++++++++++---------
 3 files changed, 40 insertions(+), 14 deletions(-)

diff -ruNp org/net/netfilter/core.c new/net/netfilter/core.c
--- org/net/netfilter/core.c	2012-05-07 09:20:53.828751916 +0530
+++ new/net/netfilter/core.c	2012-05-07 09:20:53.868813999 +0530
@@ -192,7 +192,9 @@ next_hook:
 			ret = -EPERM;
 	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
 		int err = nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
-						verdict >> NF_VERDICT_QBITS);
+				   verdict >> NF_VERDICT_QBITS,
+				   verdict & NF_VERDICT_FLAG_FAIL_OPEN);
+
 		if (err < 0) {
 			if (err == -ECANCELED)
 				goto next_hook;
diff -ruNp org/net/netfilter/nf_internals.h new/net/netfilter/nf_internals.h
--- org/net/netfilter/nf_internals.h	2012-05-07 09:20:53.827751461 +0530
+++ new/net/netfilter/nf_internals.h	2012-05-07 09:20:53.867814083 +0530
@@ -29,7 +29,8 @@ extern int nf_queue(struct sk_buff *skb,
 		    struct net_device *indev,
 		    struct net_device *outdev,
 		    int (*okfn)(struct sk_buff *),
-		    unsigned int queuenum);
+		    unsigned int queuenum,
+		    int flags);
 extern int __init netfilter_queue_init(void);
 
 /* nf_log.c */
diff -ruNp org/net/netfilter/nf_queue.c new/net/netfilter/nf_queue.c
--- org/net/netfilter/nf_queue.c	2012-05-07 10:15:51.882590018 +0530
+++ new/net/netfilter/nf_queue.c	2012-05-07 09:20:53.866762950 +0530
@@ -123,7 +123,8 @@ static int __nf_queue(struct sk_buff *sk
 		      struct net_device *indev,
 		      struct net_device *outdev,
 		      int (*okfn)(struct sk_buff *),
-		      unsigned int queuenum)
+		      unsigned int queuenum,
+		      int flags)
 {
 	int status = -ENOENT;
 	struct nf_queue_entry *entry = NULL;
@@ -185,11 +186,11 @@ static int __nf_queue(struct sk_buff *sk
 #endif
 	skb_dst_force(skb);
 	afinfo->saveroute(skb, entry);
-	status = qh->outfn(entry, queuenum, 0);
+	status = qh->outfn(entry, queuenum, flags);
 
 	rcu_read_unlock();
 
-	if (status < 0) {
+	if (status) {
 		nf_queue_entry_release_refs(entry);
 		goto err;
 	}
@@ -230,15 +231,25 @@ int nf_queue(struct sk_buff *skb,
 	     struct net_device *indev,
 	     struct net_device *outdev,
 	     int (*okfn)(struct sk_buff *),
-	     unsigned int queuenum)
+	     unsigned int queuenum,
+	     int flags)
 {
 	struct sk_buff *segs;
 	int err = -EINVAL;
 	unsigned int queued;
 
-	if (!skb_is_gso(skb))
-		return __nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
-				  queuenum);
+	if (!skb_is_gso(skb)) {
+		err = __nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
+				  queuenum, flags);
+		if (err > 0) {
+			/* Queue failed due to queue-full and handler
+			 * returned >0 indicating fail-open - temporarily
+			 * accept packets.
+			 */
+			err = okfn(skb);
+		}
+		return err;
+	}
 
 	switch (pf) {
 	case NFPROTO_IPV4:
@@ -266,16 +277,28 @@ int nf_queue(struct sk_buff *skb,
 		if (err == 0) {
 			nf_bridge_adjust_segmented_data(segs);
 			err = __nf_queue(segs, elem, pf, hook, indev,
-					   outdev, okfn, queuenum);
+					 outdev, okfn, queuenum, flags);
 		}
-		if (err == 0)
+
+		if (err == 0) {
 			queued++;
-		else
+		} else if (err > 0) {
+			/* Queue failed due to queue-full and handler
+			 * returned >0 indicating fail-open - accept
+			 * this and remaining segments.
+			 */
+			okfn(segs);
+		} else {
+			/* Queue failed due to queue-full and handler
+			 * returned <0 - free this and remaining skb
+			 * segments.
+			 */
 			kfree_skb(segs);
+		}
 		segs = nskb;
 	} while (segs);
 
-	if (queued) {
+	if (queued || err > 0) {
 		kfree_skb(skb);
 		return 0;
 	}
@@ -325,7 +348,7 @@ void nf_reinject(struct nf_queue_entry *
 	case NF_QUEUE:
 		err = __nf_queue(skb, elem, entry->pf, entry->hook,
 				 entry->indev, entry->outdev, entry->okfn,
-				 verdict >> NF_VERDICT_QBITS);
+				 verdict >> NF_VERDICT_QBITS, 0);
 		if (err < 0) {
 			if (err == -ECANCELED)
 				goto next_hook;

