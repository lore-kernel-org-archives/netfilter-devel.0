From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [v2 PATCH 5/6] netfilter: GSO packet handling
Date: Tue, 08 May 2012 15:14:42 +0530
Message-ID: <20120508094442.19531.56563.sendpatchset@localhost.localdomain>
References: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Cc: vivk@us.ibm.com, svajipay@in.ibm.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43967 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2EHJ4e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 05:56:34 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Tue, 8 May 2012 09:37:59 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q489ilqx15007746
	for <netfilter-devel@vger.kernel.org>; Tue, 8 May 2012 19:44:48 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q489ikgb020484
	for <netfilter-devel@vger.kernel.org>; Tue, 8 May 2012 19:44:47 +1000
In-Reply-To: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Handle >0 return value from outfn in __nf_queue(). This value
is not passed up the stack but intercepted by nf_queue(), which
returns 0 to upper layers.

Also add support for GSO skb. If __nf_queue() returns >0 to
indicate fail-open, we call okfn() immediately.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
---
 net/netfilter/nf_queue.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff -ruNp org/net/netfilter/nf_queue.c new/net/netfilter/nf_queue.c
--- org/net/netfilter/nf_queue.c	2012-05-08 13:02:18.163816400 +0530
+++ new/net/netfilter/nf_queue.c	2012-05-08 15:08:11.028555335 +0530
@@ -189,7 +189,7 @@ static int __nf_queue(struct sk_buff *sk
 
 	rcu_read_unlock();
 
-	if (status < 0) {
+	if (status) {
 		nf_queue_entry_release_refs(entry);
 		goto err;
 	}
@@ -236,9 +236,18 @@ int nf_queue(struct sk_buff *skb,
 	int err = -EINVAL;
 	unsigned int queued;
 
-	if (!skb_is_gso(skb))
-		return __nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
+	if (!skb_is_gso(skb)) {
+		err = __nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
 				  queuenum);
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
@@ -268,14 +277,26 @@ int nf_queue(struct sk_buff *skb,
 			err = __nf_queue(segs, elem, pf, hook, indev,
 					   outdev, okfn, queuenum);
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

