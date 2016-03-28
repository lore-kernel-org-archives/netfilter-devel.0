From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/9] netfilter: nfnetlink_queue: honor NFQA_CFG_F_FAIL_OPEN when netlink unicast fails
Date: Mon, 28 Mar 2016 19:58:00 +0200
Message-ID: <1459187882-5357-8-git-send-email-pablo@netfilter.org>
References: <1459187882-5357-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50853 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbcC1R6Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2016 13:58:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0622FE839B
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 19:58:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B150FDA8F7
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 19:58:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B6EE3DA8F8
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 19:58:12 +0200 (CEST)
In-Reply-To: <1459187882-5357-1-git-send-email-pablo@netfilter.org>
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
index 7542999..cb5b630 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -582,7 +582,12 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
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

