From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/09]: nfnetlink_queue: fix EPERM when binding/unbinding and instance 0 exists
Date: Mon, 10 Mar 2008 19:26:24 +0100 (MET)
Message-ID: <20080310182626.20404.45629.sendpatchset@localhost.localdomain>
References: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34278 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYCJS0Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:26:25 -0400
In-Reply-To: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: fix EPERM when binding/unbinding and instance 0 exists

Similar to the nfnetlink_log problem, nfnetlink_queue incorrectly returns -EPERM
when binding or unbinding to an address family and queueing instance 0 exists
and is owned by a different process. Unlike nfnetlink_log it previously completes
the operation, but it is still incorrect.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 68b176bf4421f595f94c8a80fffcf4cc06d7edc4
tree 3bcd124e75e83a8f7fd8df822bd66fb2d305f812
parent 1db33bfdd9496c38b1f3e41b2e6ff72649d99044
author Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 19:11:31 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 19:11:31 +0100

 net/netfilter/nfnetlink_queue.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a573baa..7f9d820 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -703,19 +703,12 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		/* Commands without queue context - might sleep */
 		switch (cmd->command) {
 		case NFQNL_CFG_CMD_PF_BIND:
-			ret = nf_register_queue_handler(ntohs(cmd->pf),
-							&nfqh);
-			break;
+			return nf_register_queue_handler(ntohs(cmd->pf),
+							 &nfqh);
 		case NFQNL_CFG_CMD_PF_UNBIND:
-			ret = nf_unregister_queue_handler(ntohs(cmd->pf),
-							  &nfqh);
-			break;
-		default:
-			break;
+			return nf_unregister_queue_handler(ntohs(cmd->pf),
+							   &nfqh);
 		}
-
-		if (ret < 0)
-			return ret;
 	}
 
 	rcu_read_lock();
