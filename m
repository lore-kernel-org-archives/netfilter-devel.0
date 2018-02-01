From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 1/2] netfilter: nft_flow_offload: wait for garbage collector to run after cleanup
Date: Thu,  1 Feb 2018 18:49:00 +0100
Message-ID: <20180201174901.25100-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52966 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751567AbeBARtP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Feb 2018 12:49:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E04F3392E0A
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 18:49:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D087BBAAA8
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 18:49:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B91A0BAAA2
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 18:49:10 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 86CDE4265A2F
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 18:49:10 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If netdevice goes down, then flowtable entries are scheduled to be
removed. Wait for garbage collector to have a chance to run so it can
delete them from the hashtable.

The flush call might sleep, so hold the nfnl mutex from
nft_flow_table_iterate() instead of rcu read side lock. The use of the
nfnl mutex is also implicitly fixing races between updates via nfnetlink
and netdevice event.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c    | 8 ++++----
 net/netfilter/nft_flow_offload.c | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0791813a1e7d..07dd1fac78a8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5006,13 +5006,13 @@ void nft_flow_table_iterate(struct net *net,
 	struct nft_flowtable *flowtable;
 	const struct nft_table *table;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
-		list_for_each_entry_rcu(flowtable, &table->flowtables, list) {
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
+	list_for_each_entry(table, &net->nft.tables, list) {
+		list_for_each_entry(flowtable, &table->flowtables, list) {
 			iter(&flowtable->data, data);
 		}
 	}
-	rcu_read_unlock();
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL_GPL(nft_flow_table_iterate);
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 4503b8dcf9c0..1739ff8ca21f 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -208,6 +208,7 @@ static void nft_flow_offload_iterate_cleanup(struct nf_flowtable *flowtable,
 					     void *data)
 {
 	nf_flow_table_iterate(flowtable, flow_offload_iterate_cleanup, data);
+	flush_delayed_work(&flowtable->gc_work);
 }
 
 static int flow_offload_netdev_event(struct notifier_block *this,
-- 
2.11.0

