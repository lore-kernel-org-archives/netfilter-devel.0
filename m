From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/38] netfilter: nf_conncount: Switch to plain list
Date: Fri, 20 Jul 2018 15:08:46 +0200
Message-ID: <20180720130906.27687-19-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>

Original patch is from Florian Westphal.

This patch switches from hlist to plain list to store the list of
connections with the same filtering key in nf_conncount. With the
plain list, we can insert new connections at the tail, so over time
the beginning of list holds long-running connections and those are
expired, while the newly creates ones are at the end.

Later on, we could probably move checked ones to the end of the list,
so the next run has higher chance to reclaim stale entries in the front.

Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_count.h | 15 ++++--
 net/netfilter/nf_conncount.c               | 83 ++++++++++++++++++------------
 net/netfilter/nft_connlimit.c              | 24 ++++-----
 3 files changed, 75 insertions(+), 47 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 3a188a0923a3..e4884e0e4f69 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -1,8 +1,15 @@
 #ifndef _NF_CONNTRACK_COUNT_H
 #define _NF_CONNTRACK_COUNT_H
 
+#include <linux/list.h>
+
 struct nf_conncount_data;
 
+struct nf_conncount_list {
+	struct list_head head;	/* connections with the same filtering key */
+	unsigned int count;	/* length of list */
+};
+
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family,
 					    unsigned int keylen);
 void nf_conncount_destroy(struct net *net, unsigned int family,
@@ -14,15 +21,17 @@ unsigned int nf_conncount_count(struct net *net,
 				const struct nf_conntrack_tuple *tuple,
 				const struct nf_conntrack_zone *zone);
 
-unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
+unsigned int nf_conncount_lookup(struct net *net, struct nf_conncount_list *list,
 				 const struct nf_conntrack_tuple *tuple,
 				 const struct nf_conntrack_zone *zone,
 				 bool *addit);
 
-bool nf_conncount_add(struct hlist_head *head,
+void nf_conncount_list_init(struct nf_conncount_list *list);
+
+bool nf_conncount_add(struct nf_conncount_list *list,
 		      const struct nf_conntrack_tuple *tuple,
 		      const struct nf_conntrack_zone *zone);
 
-void nf_conncount_cache_free(struct hlist_head *hhead);
+void nf_conncount_cache_free(struct nf_conncount_list *list);
 
 #endif
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 81c02185b2e8..81b060adefef 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -44,7 +44,7 @@
 
 /* we will save the tuples of all connections we care about */
 struct nf_conncount_tuple {
-	struct hlist_node		node;
+	struct list_head		node;
 	struct nf_conntrack_tuple	tuple;
 	struct nf_conntrack_zone	zone;
 	int				cpu;
@@ -53,7 +53,7 @@ struct nf_conncount_tuple {
 
 struct nf_conncount_rb {
 	struct rb_node node;
-	struct hlist_head hhead; /* connections/hosts in same subnet */
+	struct nf_conncount_list list;
 	u32 key[MAX_KEYLEN];
 };
 
@@ -82,12 +82,15 @@ static int key_diff(const u32 *a, const u32 *b, unsigned int klen)
 	return memcmp(a, b, klen * sizeof(u32));
 }
 
-bool nf_conncount_add(struct hlist_head *head,
+bool nf_conncount_add(struct nf_conncount_list *list,
 		      const struct nf_conntrack_tuple *tuple,
 		      const struct nf_conntrack_zone *zone)
 {
 	struct nf_conncount_tuple *conn;
 
+	if (WARN_ON_ONCE(list->count > INT_MAX))
+		return false;
+
 	conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
 	if (conn == NULL)
 		return false;
@@ -95,13 +98,26 @@ bool nf_conncount_add(struct hlist_head *head,
 	conn->zone = *zone;
 	conn->cpu = raw_smp_processor_id();
 	conn->jiffies32 = (u32)jiffies;
-	hlist_add_head(&conn->node, head);
+	list_add_tail(&conn->node, &list->head);
+	list->count++;
 	return true;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_add);
 
+static void conn_free(struct nf_conncount_list *list,
+		      struct nf_conncount_tuple *conn)
+{
+	if (WARN_ON_ONCE(list->count == 0))
+		return;
+
+	list->count--;
+	list_del(&conn->node);
+	kmem_cache_free(conncount_conn_cachep, conn);
+}
+
 static const struct nf_conntrack_tuple_hash *
-find_or_evict(struct net *net, struct nf_conncount_tuple *conn)
+find_or_evict(struct net *net, struct nf_conncount_list *list,
+	      struct nf_conncount_tuple *conn)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	unsigned long a, b;
@@ -121,30 +137,29 @@ find_or_evict(struct net *net, struct nf_conncount_tuple *conn)
 	 */
 	age = a - b;
 	if (conn->cpu == cpu || age >= 2) {
-		hlist_del(&conn->node);
-		kmem_cache_free(conncount_conn_cachep, conn);
+		conn_free(list, conn);
 		return ERR_PTR(-ENOENT);
 	}
 
 	return ERR_PTR(-EAGAIN);
 }
 
-unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
+unsigned int nf_conncount_lookup(struct net *net,
+				 struct nf_conncount_list *list,
 				 const struct nf_conntrack_tuple *tuple,
 				 const struct nf_conntrack_zone *zone,
 				 bool *addit)
 {
 	const struct nf_conntrack_tuple_hash *found;
-	struct nf_conncount_tuple *conn;
+	struct nf_conncount_tuple *conn, *conn_n;
 	struct nf_conn *found_ct;
-	struct hlist_node *n;
 	unsigned int length = 0;
 
 	*addit = tuple ? true : false;
 
 	/* check the saved connections */
-	hlist_for_each_entry_safe(conn, n, head, node) {
-		found = find_or_evict(net, conn);
+	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
+		found = find_or_evict(net, list, conn);
 		if (IS_ERR(found)) {
 			/* Not found, but might be about to be confirmed */
 			if (PTR_ERR(found) == -EAGAIN) {
@@ -157,6 +172,7 @@ unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
 				    nf_ct_zone_id(zone, zone->dir))
 					*addit = false;
 			}
+
 			continue;
 		}
 
@@ -176,8 +192,7 @@ unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
 			 * closed already -> ditch it
 			 */
 			nf_ct_put(found_ct);
-			hlist_del(&conn->node);
-			kmem_cache_free(conncount_conn_cachep, conn);
+			conn_free(list, conn);
 			continue;
 		}
 
@@ -189,17 +204,23 @@ unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
 }
 EXPORT_SYMBOL_GPL(nf_conncount_lookup);
 
+void nf_conncount_list_init(struct nf_conncount_list *list)
+{
+	INIT_LIST_HEAD(&list->head);
+	list->count = 1;
+}
+EXPORT_SYMBOL_GPL(nf_conncount_list_init);
+
 static void nf_conncount_gc_list(struct net *net,
-				 struct nf_conncount_rb *rbconn)
+				 struct nf_conncount_list *list)
 {
 	const struct nf_conntrack_tuple_hash *found;
-	struct nf_conncount_tuple *conn;
-	struct hlist_node *n;
+	struct nf_conncount_tuple *conn, *conn_n;
 	struct nf_conn *found_ct;
 	unsigned int collected = 0;
 
-	hlist_for_each_entry_safe(conn, n, &rbconn->hhead, node) {
-		found = find_or_evict(net, conn);
+	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
+		found = find_or_evict(net, list, conn);
 		if (IS_ERR(found)) {
 			if (PTR_ERR(found) == -ENOENT)
 				collected++;
@@ -213,8 +234,7 @@ static void nf_conncount_gc_list(struct net *net,
 			 * closed already -> ditch it
 			 */
 			nf_ct_put(found_ct);
-			hlist_del(&conn->node);
-			kmem_cache_free(conncount_conn_cachep, conn);
+			conn_free(list, conn);
 			collected++;
 			continue;
 		}
@@ -271,14 +291,14 @@ count_tree(struct net *net, struct rb_root *root,
 			/* same source network -> be counted! */
 			unsigned int count;
 
-			count = nf_conncount_lookup(net, &rbconn->hhead, tuple,
+			count = nf_conncount_lookup(net, &rbconn->list, tuple,
 						    zone, &addit);
 
 			tree_nodes_free(root, gc_nodes, gc_count);
 			if (!addit)
 				return count;
 
-			if (!nf_conncount_add(&rbconn->hhead, tuple, zone))
+			if (!nf_conncount_add(&rbconn->list, tuple, zone))
 				return 0; /* hotdrop */
 
 			return count + 1;
@@ -287,8 +307,8 @@ count_tree(struct net *net, struct rb_root *root,
 		if (no_gc || gc_count >= ARRAY_SIZE(gc_nodes))
 			continue;
 
-		nf_conncount_gc_list(net, rbconn);
-		if (hlist_empty(&rbconn->hhead))
+		nf_conncount_gc_list(net, &rbconn->list);
+		if (list_empty(&rbconn->list.head))
 			gc_nodes[gc_count++] = rbconn;
 	}
 
@@ -322,8 +342,8 @@ count_tree(struct net *net, struct rb_root *root,
 	conn->zone = *zone;
 	memcpy(rbconn->key, key, sizeof(u32) * keylen);
 
-	INIT_HLIST_HEAD(&rbconn->hhead);
-	hlist_add_head(&conn->node, &rbconn->hhead);
+	nf_conncount_list_init(&rbconn->list);
+	list_add(&conn->node, &rbconn->list.head);
 
 	rb_link_node(&rbconn->node, parent, rbnode);
 	rb_insert_color(&rbconn->node, root);
@@ -388,12 +408,11 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family
 }
 EXPORT_SYMBOL_GPL(nf_conncount_init);
 
-void nf_conncount_cache_free(struct hlist_head *hhead)
+void nf_conncount_cache_free(struct nf_conncount_list *list)
 {
-	struct nf_conncount_tuple *conn;
-	struct hlist_node *n;
+	struct nf_conncount_tuple *conn, *conn_n;
 
-	hlist_for_each_entry_safe(conn, n, hhead, node)
+	list_for_each_entry_safe(conn, conn_n, &list->head, node)
 		kmem_cache_free(conncount_conn_cachep, conn);
 }
 EXPORT_SYMBOL_GPL(nf_conncount_cache_free);
@@ -408,7 +427,7 @@ static void destroy_tree(struct rb_root *r)
 
 		rb_erase(node, r);
 
-		nf_conncount_cache_free(&rbconn->hhead);
+		nf_conncount_cache_free(&rbconn->list);
 
 		kmem_cache_free(conncount_rb_cachep, rbconn);
 	}
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index a832c59f0a9c..4f0491a36a1d 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -14,10 +14,10 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 
 struct nft_connlimit {
-	spinlock_t		lock;
-	struct hlist_head	hhead;
-	u32			limit;
-	bool			invert;
+	spinlock_t			lock;
+	struct nf_conncount_list	list;
+	u32				limit;
+	bool				invert;
 };
 
 static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
@@ -46,13 +46,13 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 	}
 
 	spin_lock_bh(&priv->lock);
-	count = nf_conncount_lookup(nft_net(pkt), &priv->hhead, tuple_ptr, zone,
+	count = nf_conncount_lookup(nft_net(pkt), &priv->list, tuple_ptr, zone,
 				    &addit);
 
 	if (!addit)
 		goto out;
 
-	if (!nf_conncount_add(&priv->hhead, tuple_ptr, zone)) {
+	if (!nf_conncount_add(&priv->list, tuple_ptr, zone)) {
 		regs->verdict.code = NF_DROP;
 		spin_unlock_bh(&priv->lock);
 		return;
@@ -88,7 +88,7 @@ static int nft_connlimit_do_init(const struct nft_ctx *ctx,
 	}
 
 	spin_lock_init(&priv->lock);
-	INIT_HLIST_HEAD(&priv->hhead);
+	nf_conncount_list_init(&priv->list);
 	priv->limit	= limit;
 	priv->invert	= invert;
 
@@ -99,7 +99,7 @@ static void nft_connlimit_do_destroy(const struct nft_ctx *ctx,
 				     struct nft_connlimit *priv)
 {
 	nf_ct_netns_put(ctx->net, ctx->family);
-	nf_conncount_cache_free(&priv->hhead);
+	nf_conncount_cache_free(&priv->list);
 }
 
 static int nft_connlimit_do_dump(struct sk_buff *skb,
@@ -213,7 +213,7 @@ static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_connlimit *priv_src = nft_expr_priv(src);
 
 	spin_lock_init(&priv_dst->lock);
-	INIT_HLIST_HEAD(&priv_dst->hhead);
+	nf_conncount_list_init(&priv_dst->list);
 	priv_dst->limit	 = priv_src->limit;
 	priv_dst->invert = priv_src->invert;
 
@@ -225,7 +225,7 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
 
-	nf_conncount_cache_free(&priv->hhead);
+	nf_conncount_cache_free(&priv->list);
 }
 
 static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
@@ -234,9 +234,9 @@ static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
 	bool addit, ret;
 
 	spin_lock_bh(&priv->lock);
-	nf_conncount_lookup(net, &priv->hhead, NULL, &nf_ct_zone_dflt, &addit);
+	nf_conncount_lookup(net, &priv->list, NULL, &nf_ct_zone_dflt, &addit);
 
-	ret = hlist_empty(&priv->hhead);
+	ret = list_empty(&priv->list.head);
 	spin_unlock_bh(&priv->lock);
 
 	return ret;
-- 
2.11.0
