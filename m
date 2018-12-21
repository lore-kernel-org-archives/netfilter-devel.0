From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/37] netfilter: nf_flow_table: simplify nf_flow_offload_gc_step()
Date: Fri, 21 Dec 2018 01:28:10 +0100
Message-ID: <20181221002841.28587-7-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

nf_flow_offload_gc_step() and nf_flow_table_iterate() are very similar.
so that many duplicate code can be removed.
After this patch, nf_flow_offload_gc_step() is simple callback function of
nf_flow_table_iterate() like nf_flow_table_do_cleanup().

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 58bb006cf1b8..fa0844e2a68d 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -286,33 +286,13 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
 }
 
-static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table)
+static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
-	struct flow_offload_tuple_rhash *tuplehash;
-	struct rhashtable_iter hti;
-	struct flow_offload *flow;
-
-	rhashtable_walk_enter(&flow_table->rhashtable, &hti);
-	rhashtable_walk_start(&hti);
+	struct nf_flowtable *flow_table = data;
 
-	while ((tuplehash = rhashtable_walk_next(&hti))) {
-		if (IS_ERR(tuplehash)) {
-			if (PTR_ERR(tuplehash) != -EAGAIN)
-				break;
-			continue;
-		}
-		if (tuplehash->tuple.dir)
-			continue;
-
-		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
-
-		if (nf_flow_has_expired(flow) ||
-		    (flow->flags & (FLOW_OFFLOAD_DYING |
-				    FLOW_OFFLOAD_TEARDOWN)))
-			flow_offload_del(flow_table, flow);
-	}
-	rhashtable_walk_stop(&hti);
-	rhashtable_walk_exit(&hti);
+	if (nf_flow_has_expired(flow) ||
+	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN)))
+		flow_offload_del(flow_table, flow);
 }
 
 static void nf_flow_offload_work_gc(struct work_struct *work)
@@ -320,7 +300,7 @@ static void nf_flow_offload_work_gc(struct work_struct *work)
 	struct nf_flowtable *flow_table;
 
 	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
-	nf_flow_offload_gc_step(flow_table);
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
@@ -504,7 +484,7 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	mutex_unlock(&flowtable_lock);
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	nf_flow_offload_gc_step(flow_table);
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
-- 
2.11.0
