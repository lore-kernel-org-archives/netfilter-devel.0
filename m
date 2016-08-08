From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nfnetlink_queue: reject verdict request from different portid
Date: Mon,  8 Aug 2016 22:07:27 +0800
Message-ID: <1470665247-20570-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:43879 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbcHHOIG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 10:08:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Like NFQNL_MSG_VERDICT_BATCH do, we should also reject the verdict
request when the portid is not same with the initial portid(maybe
from another process).

Fixes: 97d32cf9440d ("netfilter: nfnetlink_queue: batch verdict support")
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nfnetlink_queue.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 5d36a09..f49f450 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1145,10 +1145,8 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
 	int err;
 
-	queue = instance_lookup(q, queue_num);
-	if (!queue)
-		queue = verdict_instance_lookup(q, queue_num,
-						NETLINK_CB(skb).portid);
+	queue = verdict_instance_lookup(q, queue_num,
+					NETLINK_CB(skb).portid);
 	if (IS_ERR(queue))
 		return PTR_ERR(queue);
 
-- 
2.5.5


