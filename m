From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/17] netfilter: nfnetlink_queue: don't handle options after unbind
Date: Fri,  8 Jan 2016 15:02:11 +0100
Message-ID: <1452261737-7475-12-git-send-email-pablo@netfilter.org>
References: <1452261737-7475-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54144 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbcAHODW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 09:03:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7A30FDA88C
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 15:03:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6A646EBAF0
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 15:03:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 70A93EBAE8
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 15:03:18 +0100 (CET)
In-Reply-To: <1452261737-7475-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>

This patch stops processing after destroying a queue instance.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index fe360f7..57951ce 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1176,7 +1176,7 @@ static int nfqnl_recv_config(struct net *net, struct sock *ctnl,
 				goto err_out_unlock;
 			}
 			instance_destroy(q, queue);
-			break;
+			goto err_out_unlock;
 		case NFQNL_CFG_CMD_PF_BIND:
 		case NFQNL_CFG_CMD_PF_UNBIND:
 			break;
-- 
2.1.4

