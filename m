From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables_netdev: fix error path in module initialization
Date: Mon, 18 Jan 2016 13:56:05 +0100
Message-ID: <1453121765-3590-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39966 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbcARM4V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2016 07:56:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6619D131CA0
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jan 2016 13:56:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 56571DA85D
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jan 2016 13:56:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 289A1DA811
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jan 2016 13:56:17 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Unregister the chain type and return error, otherwise this leaks the
subscription to the netdevice notifier call chain.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_netdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index b6605e0..5eefe4a 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -224,12 +224,12 @@ static int __init nf_tables_netdev_init(void)
 
 	nft_register_chain_type(&nft_filter_chain_netdev);
 	ret = register_pernet_subsys(&nf_tables_netdev_net_ops);
-	if (ret < 0)
+	if (ret < 0) {
 		nft_unregister_chain_type(&nft_filter_chain_netdev);
-
+		return ret;
+	}
 	register_netdevice_notifier(&nf_tables_netdev_notifier);
-
-	return ret;
+	return 0;
 }
 
 static void __exit nf_tables_netdev_exit(void)
-- 
2.1.4

