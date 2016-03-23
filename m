From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nfnetlink_queue: honor NFQA_CFG_F_FAIL_OPEN when netlink unicast fails
Date: Wed, 23 Mar 2016 12:58:01 +0100
Message-ID: <1458734281-19075-1-git-send-email-pablo@netfilter.org>
Cc: yreiss@cisco.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48262 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbcCWL6M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2016 07:58:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 64CB91525C5
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 12:58:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0B151DA38F
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 12:58:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 269D9DA8FA
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 12:58:05 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When netlink unicast fails to deliver the message to userspace, we
should also check if the NFQA_CFG_F_FAIL_OPEN flag is set so we reinject
the packet back to the stack.

I think the user expects no packet drops when this flag is set due to
queueing to userspace errors, no matter if related to the internal queue
or when sending the netlink message to userspace.

The userspace application will still get the ENOBUFS error via recvmsg()
so the user still knows that, with the current configuration that is in
place, the userspace application is not consuming the messages at the
pace that the kernel needs.

Reported-by: "Yigal Reiss (yreiss)" <yreiss@cisco.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Tested-by: "Yigal Reiss (yreiss)" <yreiss@cisco.com>
---
 net/netfilter/nfnetlink_queue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 1d39365..c19efde6 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -584,7 +584,12 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	/* nfnetlink_unicast will either free the nskb or add it to a socket */
 	err = nfnetlink_unicast(nskb, net, queue->peer_portid, MSG_DONTWAIT);
 	if (err < 0) {
-		queue->queue_user_dropped++;
+		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
+			failopen = 1;
+			err = 0;
+		} else {
+			queue->queue_user_dropped++;
+		}
 		goto err_out_unlock;
 	}
 
-- 
2.1.4

