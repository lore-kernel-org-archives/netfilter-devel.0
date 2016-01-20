From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/6] netfilter: nf_tables_netdev: fix error path in module initialization
Date: Wed, 20 Jan 2016 18:04:03 +0100
Message-ID: <1453309444-2297-6-git-send-email-pablo@netfilter.org>
References: <1453309444-2297-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45491 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934929AbcATREZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 12:04:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 15C93A7E35
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 18:04:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 075CDDA807
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 18:04:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2B9D2DA811
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 18:04:21 +0100 (CET)
In-Reply-To: <1453309444-2297-1-git-send-email-pablo@netfilter.org>
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

