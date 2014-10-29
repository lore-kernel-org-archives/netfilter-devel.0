From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH v4 2/3] Do error handling if __build_packet_message fails
Date: Wed, 29 Oct 2014 10:51:14 -0200
Message-ID: <8dcee609af0015c15d2a99ab6d076a65d6ec01a8.1414586968.git.mleitner@redhat.com>
References: <7be00bf663b212d4984414346da216cf17d3443d.1414586968.git.mleitner@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788AbaJ2Mvc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:51:32 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9TCpVBE031180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2014 08:51:32 -0400
Received: from localhost.localdomain.com (vpn1-7-3.gru2.redhat.com [10.97.7.3])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9TCpTjY016877
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2014 08:51:30 -0400
In-Reply-To: <7be00bf663b212d4984414346da216cf17d3443d.1414586968.git.mleitner@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, we don't check if __build_packet_message fails or not and
that leaves it prone to sending incomplete messages to userspace.

This commit fixes it by canceling the new message if there was any issue
while building it and makes sure the skb is freed if it was the only
message in it.

Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
---
 net/netfilter/nfnetlink_log.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b1e3a05794169283ed50d1c0fb4f44d9e7753eeb..045c5956611f61a3f5dad3e15ca7cf19365e5afa 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -568,10 +568,8 @@ __build_packet_message(struct nfnl_log_net *log,
 		struct nlattr *nla;
 		int size = nla_attr_size(data_len);
 
-		if (skb_tailroom(inst->skb) < nla_total_size(data_len)) {
-			printk(KERN_WARNING "nfnetlink_log: no tailroom!\n");
-			return -1;
-		}
+		if (skb_tailroom(inst->skb) < nla_total_size(data_len))
+			goto nla_put_failure;
 
 		nla = (struct nlattr *)skb_put(inst->skb, nla_total_size(data_len));
 		nla->nla_type = NFULA_PAYLOAD;
@@ -586,6 +584,7 @@ __build_packet_message(struct nfnl_log_net *log,
 
 nla_put_failure:
 	PRINTR(KERN_ERR "nfnetlink_log: error creating log nlmsg\n");
+	nlmsg_cancel(skb, nlh);
 	return -1;
 }
 
@@ -708,8 +707,9 @@ nfulnl_log_packet(struct net *net,
 
 	inst->qlen++;
 
-	__build_packet_message(log, inst, skb, data_len, pf,
-				hooknum, in, out, prefix, plen);
+	if (__build_packet_message(log, inst, skb, data_len, pf,
+				   hooknum, in, out, prefix, plen))
+		goto build_failure;
 
 	if (inst->qlen >= qthreshold)
 		__nfulnl_flush(inst);
@@ -726,6 +726,15 @@ unlock_and_release:
 	instance_put(inst);
 	return;
 
+build_failure:
+	/* If no other messages in it, we're good to free it. */
+	if (!inst->skb->len) {
+		kfree_skb(inst->skb);
+		inst->skb = NULL;
+	}
+
+	inst->qlen--;
+
 alloc_failure:
 	/* FIXME: statistics */
 	goto unlock_and_release;
-- 
1.9.3

