From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [v2 PATCH 4/6] netfilter: Add fail-open support to handler
Date: Tue, 08 May 2012 15:14:30 +0530
Message-ID: <20120508094430.19531.28008.sendpatchset@localhost.localdomain>
References: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Cc: vivk@us.ibm.com, svajipay@in.ibm.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:45718 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2EHJpL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 05:45:11 -0400
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Tue, 8 May 2012 15:15:06 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q489ifOB38994016
	for <netfilter-devel@vger.kernel.org>; Tue, 8 May 2012 15:14:41 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q48FEEE5020467
	for <netfilter-devel@vger.kernel.org>; Tue, 8 May 2012 20:44:19 +0530
In-Reply-To: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Change NFQUEUE handler to return >0 value on queue full
to signify "fail-open".

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
---
 net/netfilter/nfnetlink_queue.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -ruNp org/net/netfilter/nfnetlink_queue.c new/net/netfilter/nfnetlink_queue.c
--- org/net/netfilter/nfnetlink_queue.c	2012-05-08 12:57:39.225755227 +0530
+++ new/net/netfilter/nfnetlink_queue.c	2012-05-08 12:57:55.515816567 +0530
@@ -433,11 +433,16 @@ nfqnl_enqueue_packet(struct nf_queue_ent
 		goto err_out_free_nskb;
 	}
 	if (queue->queue_total >= queue->queue_maxlen) {
-		queue->queue_dropped++;
-		if (net_ratelimit())
-			  printk(KERN_WARNING "nf_queue: full at %d entries, "
-				 "dropping packets(s).\n",
-				 queue->queue_total);
+		if (queue->fail_open) {
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

