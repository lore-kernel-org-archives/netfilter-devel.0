From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 23/31] netfilter: nf_tables: use rhashtable_walk_enter instead of rhashtable_walk_init
Date: Tue,  9 Oct 2018 01:01:17 +0200
Message-ID: <20181008230125.2330-24-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

rhashtable_walk_init() is deprecated and rhashtable_walk_enter() can be
used instead. rhashtable_walk_init() is wrapper function of
rhashtable_walk_enter() so that logic is actually same.
But rhashtable_walk_enter() doesn't return error hence error path
code can be removed.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 35 +++++++++++------------------------
 net/netfilter/nft_set_hash.c       | 30 ++++++++----------------------
 2 files changed, 19 insertions(+), 46 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 0c233cfcc84d..da3044482317 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -254,20 +254,17 @@ int nf_flow_table_iterate(struct nf_flowtable *flow_table,
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct rhashtable_iter hti;
 	struct flow_offload *flow;
-	int err;
-
-	err = rhashtable_walk_init(&flow_table->rhashtable, &hti, GFP_KERNEL);
-	if (err)
-		return err;
+	int err = 0;
 
+	rhashtable_walk_enter(&flow_table->rhashtable, &hti);
 	rhashtable_walk_start(&hti);
 
 	while ((tuplehash = rhashtable_walk_next(&hti))) {
 		if (IS_ERR(tuplehash)) {
-			err = PTR_ERR(tuplehash);
-			if (err != -EAGAIN)
-				goto out;
-
+			if (PTR_ERR(tuplehash) != -EAGAIN) {
+				err = PTR_ERR(tuplehash);
+				break;
+			}
 			continue;
 		}
 		if (tuplehash->tuple.dir)
@@ -277,7 +274,6 @@ int nf_flow_table_iterate(struct nf_flowtable *flow_table,
 
 		iter(flow, data);
 	}
-out:
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
 
@@ -290,25 +286,19 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
 }
 
-static int nf_flow_offload_gc_step(struct nf_flowtable *flow_table)
+static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct rhashtable_iter hti;
 	struct flow_offload *flow;
-	int err;
-
-	err = rhashtable_walk_init(&flow_table->rhashtable, &hti, GFP_KERNEL);
-	if (err)
-		return 0;
 
+	rhashtable_walk_enter(&flow_table->rhashtable, &hti);
 	rhashtable_walk_start(&hti);
 
 	while ((tuplehash = rhashtable_walk_next(&hti))) {
 		if (IS_ERR(tuplehash)) {
-			err = PTR_ERR(tuplehash);
-			if (err != -EAGAIN)
-				goto out;
-
+			if (PTR_ERR(tuplehash) != -EAGAIN)
+				break;
 			continue;
 		}
 		if (tuplehash->tuple.dir)
@@ -321,11 +311,8 @@ static int nf_flow_offload_gc_step(struct nf_flowtable *flow_table)
 				    FLOW_OFFLOAD_TEARDOWN)))
 			flow_offload_del(flow_table, flow);
 	}
-out:
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
-
-	return 1;
 }
 
 static void nf_flow_offload_work_gc(struct work_struct *work)
@@ -514,7 +501,7 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	mutex_unlock(&flowtable_lock);
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	WARN_ON(!nf_flow_offload_gc_step(flow_table));
+	nf_flow_offload_gc_step(flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 015124e649cb..4f9c01715856 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -244,21 +244,15 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_rhash_elem *he;
 	struct rhashtable_iter hti;
 	struct nft_set_elem elem;
-	int err;
-
-	err = rhashtable_walk_init(&priv->ht, &hti, GFP_ATOMIC);
-	iter->err = err;
-	if (err)
-		return;
 
+	rhashtable_walk_enter(&priv->ht, &hti);
 	rhashtable_walk_start(&hti);
 
 	while ((he = rhashtable_walk_next(&hti))) {
 		if (IS_ERR(he)) {
-			err = PTR_ERR(he);
-			if (err != -EAGAIN) {
-				iter->err = err;
-				goto out;
+			if (PTR_ERR(he) != -EAGAIN) {
+				iter->err = PTR_ERR(he);
+				break;
 			}
 
 			continue;
@@ -275,13 +269,11 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 		iter->err = iter->fn(ctx, set, iter, &elem);
 		if (iter->err < 0)
-			goto out;
+			break;
 
 cont:
 		iter->count++;
 	}
-
-out:
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
 }
@@ -293,21 +285,17 @@ static void nft_rhash_gc(struct work_struct *work)
 	struct nft_rhash *priv;
 	struct nft_set_gc_batch *gcb = NULL;
 	struct rhashtable_iter hti;
-	int err;
 
 	priv = container_of(work, struct nft_rhash, gc_work.work);
 	set  = nft_set_container_of(priv);
 
-	err = rhashtable_walk_init(&priv->ht, &hti, GFP_KERNEL);
-	if (err)
-		goto schedule;
-
+	rhashtable_walk_enter(&priv->ht, &hti);
 	rhashtable_walk_start(&hti);
 
 	while ((he = rhashtable_walk_next(&hti))) {
 		if (IS_ERR(he)) {
 			if (PTR_ERR(he) != -EAGAIN)
-				goto out;
+				break;
 			continue;
 		}
 
@@ -326,17 +314,15 @@ static void nft_rhash_gc(struct work_struct *work)
 
 		gcb = nft_set_gc_batch_check(set, gcb, GFP_ATOMIC);
 		if (gcb == NULL)
-			goto out;
+			break;
 		rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params);
 		atomic_dec(&set->nelems);
 		nft_set_gc_batch_add(gcb, he);
 	}
-out:
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
 
 	nft_set_gc_batch_complete(gcb);
-schedule:
 	queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
 			   nft_set_gc_interval(set));
 }
-- 
2.11.0
