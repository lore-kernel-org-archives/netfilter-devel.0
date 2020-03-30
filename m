Return-Path: <SRS0=CFkq=5P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9659DC2D0E7
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 773A8206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgC3Ahv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 20:37:51 -0400
Received: from correo.us.es ([193.147.175.20]:57168 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbgC3AhY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1597BEF42D
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04B4C100A44
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EDCCB100A4C; Mon, 30 Mar 2020 02:37:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 008DE100A4B;
        Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CDCB042EF42A;
        Mon, 30 Mar 2020 02:37:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/26] netfilter: flowtable: Use rw sem as flow block lock
Date:   Mon, 30 Mar 2020 02:36:57 +0200
Message-Id: <20200330003708.54017-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Currently flow offload threads are synchronized by the flow block mutex.
Use rw lock instead to increase flow insertion (read) concurrency.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  2 +-
 net/netfilter/nf_flow_table_core.c    | 11 +++++------
 net/netfilter/nf_flow_table_offload.c |  4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 4a2ec6fd9ad2..6bf69652f57d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -74,7 +74,7 @@ struct nf_flowtable {
 	struct delayed_work		gc_work;
 	unsigned int			flags;
 	struct flow_block		flow_block;
-	struct mutex			flow_block_lock; /* Guards flow_block */
+	struct rw_semaphore		flow_block_lock; /* Guards flow_block */
 	possible_net_t			net;
 };
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9a477bd563b7..9399bb2df295 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -392,7 +392,7 @@ int nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
 	struct flow_block_cb *block_cb;
 	int err = 0;
 
-	mutex_lock(&flow_table->flow_block_lock);
+	down_write(&flow_table->flow_block_lock);
 	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
 	if (block_cb) {
 		err = -EEXIST;
@@ -408,7 +408,7 @@ int nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
 	list_add_tail(&block_cb->list, &block->cb_list);
 
 unlock:
-	mutex_unlock(&flow_table->flow_block_lock);
+	up_write(&flow_table->flow_block_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_add_cb);
@@ -419,13 +419,13 @@ void nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
 	struct flow_block *block = &flow_table->flow_block;
 	struct flow_block_cb *block_cb;
 
-	mutex_lock(&flow_table->flow_block_lock);
+	down_write(&flow_table->flow_block_lock);
 	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
 	if (block_cb)
 		list_del(&block_cb->list);
 	else
 		WARN_ON(true);
-	mutex_unlock(&flow_table->flow_block_lock);
+	up_write(&flow_table->flow_block_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_del_cb);
 
@@ -551,7 +551,7 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 
 	INIT_DEFERRABLE_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
 	flow_block_init(&flowtable->flow_block);
-	mutex_init(&flowtable->flow_block_lock);
+	init_rwsem(&flowtable->flow_block_lock);
 
 	err = rhashtable_init(&flowtable->rhashtable,
 			      &nf_flow_offload_rhash_params);
@@ -614,7 +614,6 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
 	nf_flow_table_offload_flush(flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
-	mutex_destroy(&flow_table->flow_block_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 0c6437fab4fe..b96db831b4ca 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -691,7 +691,7 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 	if (cmd == FLOW_CLS_REPLACE)
 		cls_flow.rule = flow_rule->rule;
 
-	mutex_lock(&flowtable->flow_block_lock);
+	down_read(&flowtable->flow_block_lock);
 	list_for_each_entry(block_cb, block_cb_list, list) {
 		err = block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow,
 				   block_cb->cb_priv);
@@ -700,7 +700,7 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 
 		i++;
 	}
-	mutex_unlock(&flowtable->flow_block_lock);
+	up_read(&flowtable->flow_block_lock);
 
 	if (cmd == FLOW_CLS_STATS)
 		memcpy(stats, &cls_flow.stats, sizeof(*stats));
-- 
2.11.0

