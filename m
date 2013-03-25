From: pablo@netfilter.org
Subject: [PATCH 02/12] ipv4: netfilter: use PTR_RET instead of IS_ERR + PTR_ERR
Date: Mon, 25 Mar 2013 13:15:42 +0100
Message-ID: <1364213752-3934-3-git-send-email-pablo@netfilter.org>
References: <1364213752-3934-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46484 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757114Ab3CYMQJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:16:09 -0400
In-Reply-To: <1364213752-3934-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

This uses PTR_RET instead of IS_ERR and PTR_ERR in order to increase
readability.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arptable_filter.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 79ca5e7..eadab1e 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -48,9 +48,7 @@ static int __net_init arptable_filter_net_init(struct net *net)
 	net->ipv4.arptable_filter =
 		arpt_register_table(net, &packet_filter, repl);
 	kfree(repl);
-	if (IS_ERR(net->ipv4.arptable_filter))
-		return PTR_ERR(net->ipv4.arptable_filter);
-	return 0;
+	return PTR_RET(net->ipv4.arptable_filter);
 }
 
 static void __net_exit arptable_filter_net_exit(struct net *net)
-- 
1.7.10.4

