From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/51] netfilter: nf_flow_table: track flow tables in nf_flow_table directly
Date: Mon,  7 May 2018 00:46:36 +0200
Message-ID: <20180506224709.29100-19-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Avoids having nf_flow_table depend on nftables (useful for future
iptables backport work)

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 include/net/netfilter/nf_tables.h     |  3 ---
 net/netfilter/nf_flow_table_core.c    | 21 ++++++++++++++++++---
 net/netfilter/nf_tables_api.c         | 17 -----------------
 4 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f876e32a60b8..ab408adba688 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -21,6 +21,7 @@ struct nf_flowtable_type {
 };
 
 struct nf_flowtable {
+	struct list_head		list;
 	struct rhashtable		rhashtable;
 	const struct nf_flowtable_type	*type;
 	struct delayed_work		gc_work;
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cd368d1b8cb8..2f2062ae1c45 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1109,9 +1109,6 @@ struct nft_flowtable {
 struct nft_flowtable *nf_tables_flowtable_lookup(const struct nft_table *table,
 						 const struct nlattr *nla,
 						 u8 genmask);
-void nft_flow_table_iterate(struct net *net,
-			    void (*iter)(struct nf_flowtable *flowtable, void *data),
-			    void *data);
 
 void nft_register_flowtable_type(struct nf_flowtable_type *type);
 void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 09d1be669c39..e761359b56a9 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -18,6 +18,9 @@ struct flow_offload_entry {
 	struct rcu_head		rcu_head;
 };
 
+static DEFINE_MUTEX(flowtable_lock);
+static LIST_HEAD(flowtables);
+
 static void
 flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
 		      struct nf_flow_route *route,
@@ -410,6 +413,10 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 	queue_delayed_work(system_power_efficient_wq,
 			   &flowtable->gc_work, HZ);
 
+	mutex_lock(&flowtable_lock);
+	list_add(&flowtable->list, &flowtables);
+	mutex_unlock(&flowtable_lock);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_init);
@@ -425,20 +432,28 @@ static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 }
 
 static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
-					  void *data)
+					  struct net_device *dev)
 {
-	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, data);
+	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
 	flush_delayed_work(&flowtable->gc_work);
 }
 
 void nf_flow_table_cleanup(struct net *net, struct net_device *dev)
 {
-	nft_flow_table_iterate(net, nf_flow_table_iterate_cleanup, dev);
+	struct nf_flowtable *flowtable;
+
+	mutex_lock(&flowtable_lock);
+	list_for_each_entry(flowtable, &flowtables, list)
+		nf_flow_table_iterate_cleanup(flowtable, dev);
+	mutex_unlock(&flowtable_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
 void nf_flow_table_free(struct nf_flowtable *flow_table)
 {
+	mutex_lock(&flowtable_lock);
+	list_del(&flow_table->list);
+	mutex_unlock(&flowtable_lock);
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
 	WARN_ON(!nf_flow_offload_gc_step(flow_table));
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 517bb93c00fb..16b67f54b3d2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5060,23 +5060,6 @@ static const struct nf_flowtable_type *nft_flowtable_type_get(u8 family)
 	return ERR_PTR(-ENOENT);
 }
 
-void nft_flow_table_iterate(struct net *net,
-			    void (*iter)(struct nf_flowtable *flowtable, void *data),
-			    void *data)
-{
-	struct nft_flowtable *flowtable;
-	const struct nft_table *table;
-
-	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	list_for_each_entry(table, &net->nft.tables, list) {
-		list_for_each_entry(flowtable, &table->flowtables, list) {
-			iter(&flowtable->data, data);
-		}
-	}
-	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-}
-EXPORT_SYMBOL_GPL(nft_flow_table_iterate);
-
 static void nft_unregister_flowtable_net_hooks(struct net *net,
 					       struct nft_flowtable *flowtable)
 {
-- 
2.11.0
