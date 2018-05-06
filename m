From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/51] netfilter: nf_flow_table: move init code to nf_flow_table_core.c
Date: Mon,  7 May 2018 00:46:34 +0200
Message-ID: <20180506224709.29100-17-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Reduces duplication of .gc and .params in flowtable type definitions and
makes the API clearer

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h   |   6 +-
 net/ipv4/netfilter/nf_flow_table_ipv4.c |   3 +-
 net/ipv6/netfilter/nf_flow_table_ipv6.c |   3 +-
 net/netfilter/nf_flow_table_core.c      | 102 +++++++++++++++++++-------------
 net/netfilter/nf_flow_table_inet.c      |   3 +-
 net/netfilter/nf_tables_api.c           |  22 +++----
 6 files changed, 74 insertions(+), 65 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 76ee5c81b752..f876e32a60b8 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -14,9 +14,8 @@ struct nf_flowtable;
 struct nf_flowtable_type {
 	struct list_head		list;
 	int				family;
-	void				(*gc)(struct work_struct *work);
+	int				(*init)(struct nf_flowtable *ft);
 	void				(*free)(struct nf_flowtable *ft);
-	const struct rhashtable_params	*params;
 	nf_hookfn			*hook;
 	struct module			*owner;
 };
@@ -100,9 +99,8 @@ int nf_flow_table_iterate(struct nf_flowtable *flow_table,
 
 void nf_flow_table_cleanup(struct net *net, struct net_device *dev);
 
+int nf_flow_table_init(struct nf_flowtable *flow_table);
 void nf_flow_table_free(struct nf_flowtable *flow_table);
-void nf_flow_offload_work_gc(struct work_struct *work);
-extern const struct rhashtable_params nf_flow_offload_rhash_params;
 
 void flow_offload_dead(struct flow_offload *flow);
 
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index b6e43ff0c7b7..e1e56d7123d2 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -7,8 +7,7 @@
 
 static struct nf_flowtable_type flowtable_ipv4 = {
 	.family		= NFPROTO_IPV4,
-	.params		= &nf_flow_offload_rhash_params,
-	.gc		= nf_flow_offload_work_gc,
+	.init		= nf_flow_table_init,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ip_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index f1804ce8d561..c511d206bf9b 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -8,8 +8,7 @@
 
 static struct nf_flowtable_type flowtable_ipv6 = {
 	.family		= NFPROTO_IPV6,
-	.params		= &nf_flow_offload_rhash_params,
-	.gc		= nf_flow_offload_work_gc,
+	.init		= nf_flow_table_init,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_ipv6_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 7403a0dfddf7..09d1be669c39 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -116,16 +116,50 @@ void flow_offload_dead(struct flow_offload *flow)
 }
 EXPORT_SYMBOL_GPL(flow_offload_dead);
 
+static u32 flow_offload_hash(const void *data, u32 len, u32 seed)
+{
+	const struct flow_offload_tuple *tuple = data;
+
+	return jhash(tuple, offsetof(struct flow_offload_tuple, dir), seed);
+}
+
+static u32 flow_offload_hash_obj(const void *data, u32 len, u32 seed)
+{
+	const struct flow_offload_tuple_rhash *tuplehash = data;
+
+	return jhash(&tuplehash->tuple, offsetof(struct flow_offload_tuple, dir), seed);
+}
+
+static int flow_offload_hash_cmp(struct rhashtable_compare_arg *arg,
+					const void *ptr)
+{
+	const struct flow_offload_tuple *tuple = arg->key;
+	const struct flow_offload_tuple_rhash *x = ptr;
+
+	if (memcmp(&x->tuple, tuple, offsetof(struct flow_offload_tuple, dir)))
+		return 1;
+
+	return 0;
+}
+
+static const struct rhashtable_params nf_flow_offload_rhash_params = {
+	.head_offset		= offsetof(struct flow_offload_tuple_rhash, node),
+	.hashfn			= flow_offload_hash,
+	.obj_hashfn		= flow_offload_hash_obj,
+	.obj_cmpfn		= flow_offload_hash_cmp,
+	.automatic_shrinking	= true,
+};
+
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
 	flow->timeout = (u32)jiffies;
 
 	rhashtable_insert_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
-			       *flow_table->type->params);
+			       nf_flow_offload_rhash_params);
 	rhashtable_insert_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
-			       *flow_table->type->params);
+			       nf_flow_offload_rhash_params);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
@@ -135,10 +169,10 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 {
 	rhashtable_remove_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
-			       *flow_table->type->params);
+			       nf_flow_offload_rhash_params);
 	rhashtable_remove_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
-			       *flow_table->type->params);
+			       nf_flow_offload_rhash_params);
 
 	flow_offload_free(flow);
 }
@@ -148,7 +182,7 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 		    struct flow_offload_tuple *tuple)
 {
 	return rhashtable_lookup_fast(&flow_table->rhashtable, tuple,
-				      *flow_table->type->params);
+				      nf_flow_offload_rhash_params);
 }
 EXPORT_SYMBOL_GPL(flow_offload_lookup);
 
@@ -237,7 +271,7 @@ static int nf_flow_offload_gc_step(struct nf_flowtable *flow_table)
 	return 1;
 }
 
-void nf_flow_offload_work_gc(struct work_struct *work)
+static void nf_flow_offload_work_gc(struct work_struct *work)
 {
 	struct nf_flowtable *flow_table;
 
@@ -245,42 +279,6 @@ void nf_flow_offload_work_gc(struct work_struct *work)
 	nf_flow_offload_gc_step(flow_table);
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
-EXPORT_SYMBOL_GPL(nf_flow_offload_work_gc);
-
-static u32 flow_offload_hash(const void *data, u32 len, u32 seed)
-{
-	const struct flow_offload_tuple *tuple = data;
-
-	return jhash(tuple, offsetof(struct flow_offload_tuple, dir), seed);
-}
-
-static u32 flow_offload_hash_obj(const void *data, u32 len, u32 seed)
-{
-	const struct flow_offload_tuple_rhash *tuplehash = data;
-
-	return jhash(&tuplehash->tuple, offsetof(struct flow_offload_tuple, dir), seed);
-}
-
-static int flow_offload_hash_cmp(struct rhashtable_compare_arg *arg,
-					const void *ptr)
-{
-	const struct flow_offload_tuple *tuple = arg->key;
-	const struct flow_offload_tuple_rhash *x = ptr;
-
-	if (memcmp(&x->tuple, tuple, offsetof(struct flow_offload_tuple, dir)))
-		return 1;
-
-	return 0;
-}
-
-const struct rhashtable_params nf_flow_offload_rhash_params = {
-	.head_offset		= offsetof(struct flow_offload_tuple_rhash, node),
-	.hashfn			= flow_offload_hash,
-	.obj_hashfn		= flow_offload_hash_obj,
-	.obj_cmpfn		= flow_offload_hash_cmp,
-	.automatic_shrinking	= true,
-};
-EXPORT_SYMBOL_GPL(nf_flow_offload_rhash_params);
 
 static int nf_flow_nat_port_tcp(struct sk_buff *skb, unsigned int thoff,
 				__be16 port, __be16 new_port)
@@ -398,6 +396,24 @@ int nf_flow_dnat_port(const struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(nf_flow_dnat_port);
 
+int nf_flow_table_init(struct nf_flowtable *flowtable)
+{
+	int err;
+
+	INIT_DEFERRABLE_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
+
+	err = rhashtable_init(&flowtable->rhashtable,
+			      &nf_flow_offload_rhash_params);
+	if (err < 0)
+		return err;
+
+	queue_delayed_work(system_power_efficient_wq,
+			   &flowtable->gc_work, HZ);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_flow_table_init);
+
 static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 {
 	struct net_device *dev = data;
@@ -423,8 +439,10 @@ EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
 void nf_flow_table_free(struct nf_flowtable *flow_table)
 {
+	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
 	WARN_ON(!nf_flow_offload_gc_step(flow_table));
+	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 375a1881d93d..99771aa7e7ea 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -22,8 +22,7 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_flowtable_type flowtable_inet = {
 	.family		= NFPROTO_INET,
-	.params		= &nf_flow_offload_rhash_params,
-	.gc		= nf_flow_offload_work_gc,
+	.init		= nf_flow_table_init,
 	.free		= nf_flow_table_free,
 	.hook		= nf_flow_offload_inet_hook,
 	.owner		= THIS_MODULE,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9134cc429ad4..6cd9955916e5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5150,14 +5150,14 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	}
 
 	flowtable->data.type = type;
-	err = rhashtable_init(&flowtable->data.rhashtable, type->params);
+	err = type->init(&flowtable->data);
 	if (err < 0)
 		goto err3;
 
 	err = nf_tables_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
 					     flowtable);
 	if (err < 0)
-		goto err3;
+		goto err4;
 
 	for (i = 0; i < flowtable->ops_len; i++) {
 		if (!flowtable->ops[i].dev)
@@ -5171,37 +5171,35 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 				if (flowtable->ops[i].dev == ft->ops[k].dev &&
 				    flowtable->ops[i].pf == ft->ops[k].pf) {
 					err = -EBUSY;
-					goto err4;
+					goto err5;
 				}
 			}
 		}
 
 		err = nf_register_net_hook(net, &flowtable->ops[i]);
 		if (err < 0)
-			goto err4;
+			goto err5;
 	}
 
 	err = nft_trans_flowtable_add(&ctx, NFT_MSG_NEWFLOWTABLE, flowtable);
 	if (err < 0)
-		goto err5;
-
-	INIT_DEFERRABLE_WORK(&flowtable->data.gc_work, type->gc);
-	queue_delayed_work(system_power_efficient_wq,
-			   &flowtable->data.gc_work, HZ);
+		goto err6;
 
 	list_add_tail_rcu(&flowtable->list, &table->flowtables);
 	table->use++;
 
 	return 0;
-err5:
+err6:
 	i = flowtable->ops_len;
-err4:
+err5:
 	for (k = i - 1; k >= 0; k--) {
 		kfree(flowtable->dev_name[k]);
 		nf_unregister_net_hook(net, &flowtable->ops[k]);
 	}
 
 	kfree(flowtable->ops);
+err4:
+	flowtable->data.type->free(&flowtable->data);
 err3:
 	module_put(type->owner);
 err2:
@@ -5485,11 +5483,9 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 
 static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
-	cancel_delayed_work_sync(&flowtable->data.gc_work);
 	kfree(flowtable->ops);
 	kfree(flowtable->name);
 	flowtable->data.type->free(&flowtable->data);
-	rhashtable_destroy(&flowtable->data.rhashtable);
 	module_put(flowtable->data.type->owner);
 }
 
-- 
2.11.0
