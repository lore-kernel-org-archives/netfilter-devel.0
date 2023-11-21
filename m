Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0259FC61D94
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbjKUM2i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjKUM2i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:28:38 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7111B126;
        Tue, 21 Nov 2023 04:28:34 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r5Prl-0005Bo-4H; Tue, 21 Nov 2023 13:28:33 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     lorenzo@kernel.org, <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/8] netfilter: nf_flowtable: make free a real free function
Date:   Tue, 21 Nov 2023 13:27:46 +0100
Message-ID: <20231121122800.13521-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231121122800.13521-1-fw@strlen.de>
References: <20231121122800.13521-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The nf_flowtable 'free' function only frees the internal data
structures, e.g. the rhashtable.

Make it so it releases the entire nf_flowtable.

This wasn't done before because the nf_flowtable structure used to be
embedded into another frontend-representation struct.

This is no longer the case, nf_flowtable gets allocated by ->create(),
and therefore should also be released via ->free().

This also moves the module_put call into the nf_flowtable core.

A followup patch will delay the actual freeing until another
rcu grace period has elapsed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_core.c |  2 ++
 net/netfilter/nf_tables_api.c      | 12 ++++--------
 net/sched/act_ct.c                 |  6 ++----
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 375fc9c24149..70cc4e0d5ac9 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -612,6 +612,8 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	nf_flow_table_gc_run(flow_table);
 	nf_flow_table_offload_flush_cleanup(flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
+	module_put(flow_table->type->owner);
+	kfree(flow_table);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cce82fef4488..e779e275d694 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8402,8 +8402,9 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 
 	flowtable->ft = type->create(net, type);
 	if (!flowtable->ft) {
+		module_put(type->owner);
 		err = -ENOMEM;
-		goto err3;
+		goto err2;
 	}
 
 	if (nla[NFTA_FLOWTABLE_FLAGS]) {
@@ -8411,7 +8412,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 			ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
 		if (flowtable->ft->flags & ~NFT_FLOWTABLE_MASK) {
 			err = -EOPNOTSUPP;
-			goto err3;
+			goto err4;
 		}
 	}
 
@@ -8447,9 +8448,6 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 	}
 err4:
 	flowtable->ft->type->free(flowtable->ft);
-err3:
-	kfree(flowtable->ft);
-	module_put(type->owner);
 err2:
 	kfree(flowtable->name);
 err1:
@@ -8824,7 +8822,6 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
 	struct nft_hook *hook, *next;
 
-	flowtable->ft->type->free(flowtable->ft);
 	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
 		flowtable->ft->type->setup(flowtable->ft, hook->ops.dev,
 					   FLOW_BLOCK_UNBIND);
@@ -8832,8 +8829,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 		kfree(hook);
 	}
 	kfree(flowtable->name);
-	module_put(flowtable->ft->type->owner);
-	kfree(flowtable->ft);
+	flowtable->ft->type->free(flowtable->ft);
 	kfree(flowtable);
 }
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 80869cc52348..dc17b313c175 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -321,6 +321,7 @@ static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 	ct_ft->nf_ft->flags |= NF_FLOWTABLE_HW_OFFLOAD |
 			       NF_FLOWTABLE_COUNTER;
 
+	/* released via nf_flow_table_free() */
 	__module_get(THIS_MODULE);
 out_unlock:
 	params->ct_ft = ct_ft;
@@ -347,7 +348,6 @@ static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
 
 	ct_ft = container_of(to_rcu_work(work), struct tcf_ct_flow_table,
 			     rwork);
-	nf_flow_table_free(ct_ft->nf_ft);
 
 	/* Remove any remaining callbacks before cleanup */
 	block = &ct_ft->nf_ft->flow_block;
@@ -357,10 +357,8 @@ static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
 		flow_block_cb_free(block_cb);
 	}
 	up_write(&ct_ft->nf_ft->flow_block_lock);
-	kfree(ct_ft->nf_ft);
+	nf_flow_table_free(ct_ft->nf_ft);
 	kfree(ct_ft);
-
-	module_put(THIS_MODULE);
 }
 
 static void tcf_ct_flow_table_put(struct tcf_ct_flow_table *ct_ft)
-- 
2.41.0

