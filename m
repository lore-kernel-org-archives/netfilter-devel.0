From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/17] netfilter: nfnetlink_queue: just returns error for unknown command
Date: Fri,  8 Jan 2016 15:02:12 +0100
Message-ID: <1452261737-7475-13-git-send-email-pablo@netfilter.org>
References: <1452261737-7475-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54131 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbcAHODY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 09:03:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E73C2DA88E
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 15:03:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D97BC4E532
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 15:03:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1EA44DA7FF
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 15:03:20 +0100 (CET)
In-Reply-To: <1452261737-7475-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>

This patch stops processing options for unknown command.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 57951ce..c1f6df4 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1182,7 +1182,7 @@ static int nfqnl_recv_config(struct net *net, struct sock *ctnl,
 			break;
 		default:
 			ret = -ENOTSUPP;
-			break;
+			goto err_out_unlock;
 		}
 	}
 
-- 
2.1.4

