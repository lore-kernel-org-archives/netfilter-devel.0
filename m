Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDE4C28D13
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Aug 2022 21:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237746AbiHVV3n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 17:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbiHVV3l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 17:29:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3105E51438
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2022 14:29:39 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     paulb@nvidia.com, roid@nvidia.com, ozsh@nvidia.com,
        saeedm@nvidia.com
Subject: [PATCH nf 1/2] netfilter: flowtable: add function to invoke garbage collection immediately
Date:   Mon, 22 Aug 2022 23:29:22 +0200
Message-Id: <20220822212923.13677-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Expose nf_flow_table_gc_run() to force a garbage collector run from the
offload infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d5326c44b453..476cc4423a90 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -270,6 +270,7 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
+void nf_flow_table_gc_run(struct nf_flowtable *flow_table);
 void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
 			      struct net_device *dev);
 void nf_flow_table_cleanup(struct net_device *dev);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 765ac779bfc8..60fc1e1b7182 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -437,12 +437,17 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 	}
 }
 
+void nf_flow_table_gc_run(struct nf_flowtable *flow_table)
+{
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+}
+
 static void nf_flow_offload_work_gc(struct work_struct *work)
 {
 	struct nf_flowtable *flow_table;
 
 	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+	nf_flow_table_gc_run(flow_table);
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
@@ -601,10 +606,11 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+	nf_flow_table_gc_run(flow_table);
 	nf_flow_table_offload_flush(flow_table);
 	if (nf_flowtable_hw_offload(flow_table))
-		nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+		nf_flow_table_gc_run(flow_table);
+
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
-- 
2.30.2

