From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 2/2] netfilter: nft_flow_offload: no need to flush entries on module removal
Date: Thu,  1 Feb 2018 18:49:01 +0100
Message-ID: <20180201174901.25100-2-pablo@netfilter.org>
References: <20180201174901.25100-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52986 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751567AbeBARtS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Feb 2018 12:49:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6BA28392E06
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 18:49:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5AD5CDA727
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 18:49:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1BC65DA727
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 18:49:12 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D5DE74265A2F
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 18:49:11 +0100 (CET)
In-Reply-To: <20180201174901.25100-1-pablo@netfilter.org>
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

