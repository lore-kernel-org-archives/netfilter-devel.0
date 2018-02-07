From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/11] netfilter: nft_flow_offload: no need to flush entries on module removal
Date: Wed,  7 Feb 2018 18:42:24 +0100
Message-ID: <20180207174229.4098-7-pablo@netfilter.org>
References: <20180207174229.4098-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47012 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754241AbeBGRmm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 12:42:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4737A3066AB
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37E38DA84A
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:41 +0100 (CET)
In-Reply-To: <20180207174229.4098-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft_flow_offload module removal does not require to flush existing
flowtables, it is valid to remove this module while keeping flowtables
around.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 1739ff8ca21f..e5c45c7ac02a 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -247,14 +247,8 @@ static int __init nft_flow_offload_module_init(void)
 
 static void __exit nft_flow_offload_module_exit(void)
 {
-	struct net *net;
-
 	nft_unregister_expr(&nft_flow_offload_type);
 	unregister_netdevice_notifier(&flow_offload_netdev_notifier);
-	rtnl_lock();
-	for_each_net(net)
-		nft_flow_table_iterate(net, nft_flow_offload_iterate_cleanup, NULL);
-	rtnl_unlock();
 }
 
 module_init(nft_flow_offload_module_init);
-- 
2.11.0

