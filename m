Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D058EC61D94
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbjKUM2m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjKUM2l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:28:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A81D92;
        Tue, 21 Nov 2023 04:28:38 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r5Prp-0005C6-62; Tue, 21 Nov 2023 13:28:37 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     lorenzo@kernel.org, <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/8] netfilter: nf_flowtable: delay flowtable release a second time
Date:   Tue, 21 Nov 2023 13:27:47 +0100
Message-ID: <20231121122800.13521-5-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231121122800.13521-1-fw@strlen.de>
References: <20231121122800.13521-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At this time the frontends (tc, nftables) ensure that the nf_flowtable
is removed after the frontend hooks are gone (tc action, netfilter hooks).

In both cases the nf_flowtable can be safely free'd as no packets will
be traversing these hooks anymore.

However, the upcoming nf_flowtable kfunc for XDP will still have a
pointer to the nf_flowtable in its own net_device -> nf_flowtable
mapping.

This mapping is removed via the flow_block UNBIND callback.

This callback however comes after an rcu grace period, not before.

Therefore defer the real freeing via call_rcu so that no kfunc can
possibly be using the nf_flowtable (or flow entries within) anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_flow_table.h |  2 ++
 net/netfilter/nf_flow_table_core.c    | 18 ++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d365eabd4a3c..6598ac455d17 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -83,6 +83,8 @@ struct nf_flowtable {
 	struct flow_block		flow_block;
 	struct rw_semaphore		flow_block_lock; /* Guards flow_block */
 	possible_net_t			net;
+
+	struct rcu_work			rwork;
 };
 
 static inline bool nf_flowtable_hw_offload(struct nf_flowtable *flowtable)
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 70cc4e0d5ac9..cae27f8f0f68 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -599,11 +599,11 @@ void nf_flow_table_cleanup(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
-void nf_flow_table_free(struct nf_flowtable *flow_table)
+static void nf_flow_table_free_rwork(struct work_struct *work)
 {
-	mutex_lock(&flowtable_lock);
-	list_del(&flow_table->list);
-	mutex_unlock(&flowtable_lock);
+	struct nf_flowtable *flow_table;
+
+	flow_table = container_of(to_rcu_work(work), struct nf_flowtable, rwork);
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_offload_flush(flow_table);
@@ -615,6 +615,16 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	module_put(flow_table->type->owner);
 	kfree(flow_table);
 }
+
+void nf_flow_table_free(struct nf_flowtable *flow_table)
+{
+	mutex_lock(&flowtable_lock);
+	list_del(&flow_table->list);
+	mutex_unlock(&flowtable_lock);
+
+	INIT_RCU_WORK(&flow_table->rwork, nf_flow_table_free_rwork);
+	queue_rcu_work(system_power_efficient_wq, &flow_table->rwork);
+}
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
 static int nf_flow_table_init_net(struct net *net)
-- 
2.41.0

