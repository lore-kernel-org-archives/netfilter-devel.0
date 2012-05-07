From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [RFC] [PATCH 2/4] netfilter: Add new argument to enqueue handlers
Date: Mon, 07 May 2012 11:34:00 +0530
Message-ID: <20120507060400.19528.30381.sendpatchset@localhost.localdomain>
References: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
Cc: svajipay@in.ibm.com, vivk@us.ibm.com,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:38655 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2EGGEJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 02:04:09 -0400
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Mon, 7 May 2012 11:34:05 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q47641k361341782
	for <netfilter-devel@vger.kernel.org>; Mon, 7 May 2012 11:34:01 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q47BXGRh012523
	for <netfilter-devel@vger.kernel.org>; Mon, 7 May 2012 21:33:17 +1000
In-Reply-To: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a new argument to enqueue handlers. Change handlers to return
>0 value to signify "failopen".  This value is not passed up the
stack but intercepted by nf_queue() which calls okfn() and returns
0 to upper layers. This also means ipqueue should return 0 and not
skb->len on success.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 include/net/netfilter/nf_queue.h |    3 ++-
 net/ipv4/netfilter/ip_queue.c    |    5 +++--
 net/ipv6/netfilter/ip6_queue.c   |    5 +++--
 net/netfilter/nf_queue.c         |    2 +-
 net/netfilter/nfnetlink_queue.c  |   18 ++++++++++++------
 5 files changed, 21 insertions(+), 12 deletions(-)

diff -ruNp org/include/net/netfilter/nf_queue.h new/include/net/netfilter/nf_queue.h
--- org/include/net/netfilter/nf_queue.h	2012-05-07 09:20:53.740752995 +0530
+++ new/include/net/netfilter/nf_queue.h	2012-05-07 09:20:53.818751053 +0530
@@ -20,7 +20,8 @@ struct nf_queue_entry {
 /* Packet queuing */
 struct nf_queue_handler {
 	int			(*outfn)(struct nf_queue_entry *entry,
-					 unsigned int queuenum);
+					 unsigned int queuenum,
+					 int failopen);
 	char			*name;
 };
 
diff -ruNp org/net/ipv4/netfilter/ip_queue.c new/net/ipv4/netfilter/ip_queue.c
--- org/net/ipv4/netfilter/ip_queue.c	2012-05-07 09:20:53.750813313 +0530
+++ new/net/ipv4/netfilter/ip_queue.c	2012-05-07 09:20:53.821751520 +0530
@@ -225,7 +225,8 @@ nlmsg_failure:
 }
 
 static int
-ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
+ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum,
+		   int failopen)
 {
 	int status = -EINVAL;
 	struct sk_buff *nskb;
@@ -262,7 +263,7 @@ ipq_enqueue_packet(struct nf_queue_entry
 	__ipq_enqueue_entry(entry);
 
 	spin_unlock_bh(&queue_lock);
-	return status;
+	return 0;
 
 err_out_free_nskb:
 	kfree_skb(nskb);
diff -ruNp org/net/ipv6/netfilter/ip6_queue.c new/net/ipv6/netfilter/ip6_queue.c
--- org/net/ipv6/netfilter/ip6_queue.c	2012-05-07 09:20:53.749814751 +0530
+++ new/net/ipv6/netfilter/ip6_queue.c	2012-05-07 09:20:53.819751460 +0530
@@ -225,7 +225,8 @@ nlmsg_failure:
 }
 
 static int
-ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
+ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum,
+		   int failopen)
 {
 	int status = -EINVAL;
 	struct sk_buff *nskb;
@@ -262,7 +263,7 @@ ipq_enqueue_packet(struct nf_queue_entry
 	__ipq_enqueue_entry(entry);
 
 	spin_unlock_bh(&queue_lock);
-	return status;
+	return 0;
 
 err_out_free_nskb:
 	kfree_skb(nskb);
diff -ruNp org/net/netfilter/nfnetlink_queue.c new/net/netfilter/nfnetlink_queue.c
--- org/net/netfilter/nfnetlink_queue.c	2012-05-07 09:20:53.757813707 +0530
+++ new/net/netfilter/nfnetlink_queue.c	2012-05-07 09:20:53.830751555 +0530
@@ -401,7 +401,8 @@ nla_put_failure:
 }
 
 static int
-nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
+nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum,
+		     int failopen)
 {
 	struct sk_buff *nskb;
 	struct nfqnl_instance *queue;
@@ -432,11 +433,16 @@ nfqnl_enqueue_packet(struct nf_queue_ent
 		goto err_out_free_nskb;
 	}
 	if (queue->queue_total >= queue->queue_maxlen) {
-		queue->queue_dropped++;
-		if (net_ratelimit())
-			  printk(KERN_WARNING "nf_queue: full at %d entries, "
-				 "dropping packets(s).\n",
-				 queue->queue_total);
+		if (failopen) {
+			/* Accept the packet temporarily skipping rules */
+			err = 1;
+		} else {
+			queue->queue_dropped++;
+			if (net_ratelimit())
+				  printk(KERN_WARNING "nf_queue: full at %d "
+					 "entries, dropping packets(s).\n",
+					 queue->queue_total);
+		}
 		goto err_out_free_nskb;
 	}
 	entry->id = ++queue->id_sequence;
diff -ruNp org/net/netfilter/nf_queue.c new/net/netfilter/nf_queue.c
--- org/net/netfilter/nf_queue.c	2012-05-07 09:20:53.754813853 +0530
+++ new/net/netfilter/nf_queue.c	2012-05-07 10:15:51.882590018 +0530
@@ -185,7 +185,7 @@ static int __nf_queue(struct sk_buff *sk
 #endif
 	skb_dst_force(skb);
 	afinfo->saveroute(skb, entry);
-	status = qh->outfn(entry, queuenum);
+	status = qh->outfn(entry, queuenum, 0);
 
 	rcu_read_unlock();
 

