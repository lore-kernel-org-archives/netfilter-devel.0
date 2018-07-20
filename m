From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 22/38] netfilter: nf_conncount: Add list lock and gc worker, and RCU for init tree search
Date: Fri, 20 Jul 2018 15:08:50 +0200
Message-ID: <20180720130906.27687-23-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>

This patch is originally from Florian Westphal.

This patch does the following 3 main tasks.

1) Add list lock to 'struct nf_conncount_list' so that we can
alter the lists containing the individual connections without holding the
main tree lock.  It would be useful when we only need to add/remove to/from
a list without allocate/remove a node in the tree.  With this change, we
update nft_connlimit accordingly since we longer need to maintain
a list lock in nft_connlimit now.

2) Use RCU for the initial tree search to improve tree look up performance.

3) Add a garbage collection worker. This worker is schedule when there
are excessive tree node that needed to be recycled.

Moreover,the rbnode reclaim logic is moved from search tree to insert tree
to avoid race condition.

Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_count.h |  17 +-
 net/netfilter/nf_conncount.c               | 253 +++++++++++++++++++++--------
 net/netfilter/nft_connlimit.c              |  17 +-
 3 files changed, 196 insertions(+), 91 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index dbec17f674b7..4b2b2baf8ab4 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -5,9 +5,17 @@
 
 struct nf_conncount_data;
 
+enum nf_conncount_list_add {
+	NF_CONNCOUNT_ADDED, 	/* list add was ok */
+	NF_CONNCOUNT_ERR,	/* -ENOMEM, must drop skb */
+	NF_CONNCOUNT_SKIP,	/* list is already reclaimed by gc */
+};
+
 struct nf_conncount_list {
+	spinlock_t list_lock;
 	struct list_head head;	/* connections with the same filtering key */
 	unsigned int count;	/* length of list */
+	bool dead;
 };
 
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family,
@@ -28,11 +36,12 @@ void nf_conncount_lookup(struct net *net, struct nf_conncount_list *list,
 
 void nf_conncount_list_init(struct nf_conncount_list *list);
 
-bool nf_conncount_add(struct nf_conncount_list *list,
-		      const struct nf_conntrack_tuple *tuple,
-		      const struct nf_conntrack_zone *zone);
+enum nf_conncount_list_add
+nf_conncount_add(struct nf_conncount_list *list,
+		 const struct nf_conntrack_tuple *tuple,
+		 const struct nf_conntrack_zone *zone);
 
-void nf_conncount_gc_list(struct net *net,
+bool nf_conncount_gc_list(struct net *net,
 			  struct nf_conncount_list *list);
 
 void nf_conncount_cache_free(struct nf_conncount_list *list);
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 3f14806b7271..02ca7df793f5 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -49,12 +49,14 @@ struct nf_conncount_tuple {
 	struct nf_conntrack_zone	zone;
 	int				cpu;
 	u32				jiffies32;
+	struct rcu_head			rcu_head;
 };
 
 struct nf_conncount_rb {
 	struct rb_node node;
 	struct nf_conncount_list list;
 	u32 key[MAX_KEYLEN];
+	struct rcu_head rcu_head;
 };
 
 static spinlock_t nf_conncount_locks[CONNCOUNT_LOCK_SLOTS] __cacheline_aligned_in_smp;
@@ -62,6 +64,10 @@ static spinlock_t nf_conncount_locks[CONNCOUNT_LOCK_SLOTS] __cacheline_aligned_i
 struct nf_conncount_data {
 	unsigned int keylen;
 	struct rb_root root[CONNCOUNT_SLOTS];
+	struct net *net;
+	struct work_struct gc_work;
+	unsigned long pending_trees[BITS_TO_LONGS(CONNCOUNT_SLOTS)];
+	unsigned int gc_tree;
 };
 
 static u_int32_t conncount_rnd __read_mostly;
@@ -82,42 +88,70 @@ static int key_diff(const u32 *a, const u32 *b, unsigned int klen)
 	return memcmp(a, b, klen * sizeof(u32));
 }
 
-bool nf_conncount_add(struct nf_conncount_list *list,
-		      const struct nf_conntrack_tuple *tuple,
-		      const struct nf_conntrack_zone *zone)
+enum nf_conncount_list_add
+nf_conncount_add(struct nf_conncount_list *list,
+		 const struct nf_conntrack_tuple *tuple,
+		 const struct nf_conntrack_zone *zone)
 {
 	struct nf_conncount_tuple *conn;
 
 	if (WARN_ON_ONCE(list->count > INT_MAX))
-		return false;
+		return NF_CONNCOUNT_ERR;
 
 	conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
 	if (conn == NULL)
-		return false;
+		return NF_CONNCOUNT_ERR;
+
 	conn->tuple = *tuple;
 	conn->zone = *zone;
 	conn->cpu = raw_smp_processor_id();
 	conn->jiffies32 = (u32)jiffies;
+	spin_lock(&list->list_lock);
+	if (list->dead == true) {
+		kmem_cache_free(conncount_conn_cachep, conn);
+		spin_unlock(&list->list_lock);
+		return NF_CONNCOUNT_SKIP;
+	}
 	list_add_tail(&conn->node, &list->head);
 	list->count++;
-	return true;
+	spin_unlock(&list->list_lock);
+	return NF_CONNCOUNT_ADDED;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_add);
 
-static void conn_free(struct nf_conncount_list *list,
+static void __conn_free(struct rcu_head *h)
+{
+	struct nf_conncount_tuple *conn;
+
+	conn = container_of(h, struct nf_conncount_tuple, rcu_head);
+	kmem_cache_free(conncount_conn_cachep, conn);
+}
+
+static bool conn_free(struct nf_conncount_list *list,
 		      struct nf_conncount_tuple *conn)
 {
-	if (WARN_ON_ONCE(list->count == 0))
-		return;
+	bool free_entry = false;
+
+	spin_lock(&list->list_lock);
+
+	if (list->count == 0) {
+		spin_unlock(&list->list_lock);
+                return free_entry;
+	}
 
 	list->count--;
-	list_del(&conn->node);
-	kmem_cache_free(conncount_conn_cachep, conn);
+	list_del_rcu(&conn->node);
+	if (list->count == 0)
+		free_entry = true;
+
+	spin_unlock(&list->list_lock);
+	call_rcu(&conn->rcu_head, __conn_free);
+	return free_entry;
 }
 
 static const struct nf_conntrack_tuple_hash *
 find_or_evict(struct net *net, struct nf_conncount_list *list,
-	      struct nf_conncount_tuple *conn)
+	      struct nf_conncount_tuple *conn, bool *free_entry)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	unsigned long a, b;
@@ -137,7 +171,7 @@ find_or_evict(struct net *net, struct nf_conncount_list *list,
 	 */
 	age = a - b;
 	if (conn->cpu == cpu || age >= 2) {
-		conn_free(list, conn);
+		*free_entry = conn_free(list, conn);
 		return ERR_PTR(-ENOENT);
 	}
 
@@ -154,6 +188,7 @@ void nf_conncount_lookup(struct net *net,
 	struct nf_conncount_tuple *conn, *conn_n;
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
+	bool free_entry = false;
 
 	/* best effort only */
 	*addit = tuple ? true : false;
@@ -163,7 +198,7 @@ void nf_conncount_lookup(struct net *net,
 		if (collect > CONNCOUNT_GC_MAX_NODES)
 			break;
 
-		found = find_or_evict(net, list, conn);
+		found = find_or_evict(net, list, conn, &free_entry);
 		if (IS_ERR(found)) {
 			/* Not found, but might be about to be confirmed */
 			if (PTR_ERR(found) == -EAGAIN) {
@@ -208,24 +243,31 @@ EXPORT_SYMBOL_GPL(nf_conncount_lookup);
 
 void nf_conncount_list_init(struct nf_conncount_list *list)
 {
+	spin_lock_init(&list->list_lock);
 	INIT_LIST_HEAD(&list->head);
 	list->count = 1;
+	list->dead = false;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_list_init);
 
-void nf_conncount_gc_list(struct net *net,
+/* Return true if the list is empty */
+bool nf_conncount_gc_list(struct net *net,
 			  struct nf_conncount_list *list)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct nf_conncount_tuple *conn, *conn_n;
 	struct nf_conn *found_ct;
 	unsigned int collected = 0;
+	bool free_entry = false;
 
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
-		found = find_or_evict(net, list, conn);
+		found = find_or_evict(net, list, conn, &free_entry);
 		if (IS_ERR(found)) {
-			if (PTR_ERR(found) == -ENOENT)
+			if (PTR_ERR(found) == -ENOENT)  {
+				if (free_entry)
+					return true;
 				collected++;
+			}
 			continue;
 		}
 
@@ -236,18 +278,28 @@ void nf_conncount_gc_list(struct net *net,
 			 * closed already -> ditch it
 			 */
 			nf_ct_put(found_ct);
-			conn_free(list, conn);
+			if (conn_free(list, conn))
+				return true;
 			collected++;
 			continue;
 		}
 
 		nf_ct_put(found_ct);
 		if (collected > CONNCOUNT_GC_MAX_NODES)
-			return;
+			return false;
 	}
+	return false;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_gc_list);
 
+static void __tree_nodes_free(struct rcu_head *h)
+{
+	struct nf_conncount_rb *rbconn;
+
+	rbconn = container_of(h, struct nf_conncount_rb, rcu_head);
+	kmem_cache_free(conncount_rb_cachep, rbconn);
+}
+
 static void tree_nodes_free(struct rb_root *root,
 			    struct nf_conncount_rb *gc_nodes[],
 			    unsigned int gc_count)
@@ -256,23 +308,39 @@ static void tree_nodes_free(struct rb_root *root,
 
 	while (gc_count) {
 		rbconn = gc_nodes[--gc_count];
-		rb_erase(&rbconn->node, root);
-		kmem_cache_free(conncount_rb_cachep, rbconn);
+		spin_lock(&rbconn->list.list_lock);
+		if (rbconn->list.count == 0 && rbconn->list.dead == false) {
+			rbconn->list.dead = true;
+			rb_erase(&rbconn->node, root);
+			call_rcu(&rbconn->rcu_head, __tree_nodes_free);
+		}
+		spin_unlock(&rbconn->list.list_lock);
 	}
 }
 
+static void schedule_gc_worker(struct nf_conncount_data *data, int tree)
+{
+	set_bit(tree, data->pending_trees);
+	schedule_work(&data->gc_work);
+}
+
 static unsigned int
-insert_tree(struct rb_root *root,
+insert_tree(struct net *net,
+	    struct nf_conncount_data *data,
+	    struct rb_root *root,
 	    unsigned int hash,
 	    const u32 *key,
 	    u8 keylen,
 	    const struct nf_conntrack_tuple *tuple,
 	    const struct nf_conntrack_zone *zone)
 {
+	enum nf_conncount_list_add ret;
+	struct nf_conncount_rb *gc_nodes[CONNCOUNT_GC_MAX_NODES];
 	struct rb_node **rbnode, *parent;
 	struct nf_conncount_rb *rbconn;
 	struct nf_conncount_tuple *conn;
-	unsigned int count = 0;
+	unsigned int count = 0, gc_count = 0;
+	bool node_found = false;
 
 	spin_lock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
 
@@ -290,16 +358,44 @@ insert_tree(struct rb_root *root,
 			rbnode = &((*rbnode)->rb_right);
 		} else {
 			/* unlikely: other cpu added node already */
-			if (!nf_conncount_add(&rbconn->list, tuple, zone)) {
+			node_found = true;
+			ret = nf_conncount_add(&rbconn->list, tuple, zone);
+			if (ret == NF_CONNCOUNT_ERR) {
 				count = 0; /* hotdrop */
-				goto out_unlock;
+			} else if (ret == NF_CONNCOUNT_ADDED) {
+				count = rbconn->list.count;
+			} else {
+				/* NF_CONNCOUNT_SKIP, rbconn is already
+				 * reclaimed by gc, insert a new tree node
+				 */
+				node_found = false;
 			}
-
-			count = rbconn->list.count;
-			goto out_unlock;
+			break;
 		}
+
+		if (gc_count >= ARRAY_SIZE(gc_nodes))
+			continue;
+
+		if (nf_conncount_gc_list(net, &rbconn->list))
+			gc_nodes[gc_count++] = rbconn;
+	}
+
+	if (gc_count) {
+		tree_nodes_free(root, gc_nodes, gc_count);
+		/* tree_node_free before new allocation permits
+		 * allocator to re-use newly free'd object.
+		 *
+		 * This is a rare event; in most cases we will find
+		 * existing node to re-use. (or gc_count is 0).
+		 */
+
+		if (gc_count >= ARRAY_SIZE(gc_nodes))
+			schedule_gc_worker(data, hash);
 	}
 
+	if (node_found)
+		goto out_unlock;
+
 	/* expected case: match, insert new node */
 	rbconn = kmem_cache_alloc(conncount_rb_cachep, GFP_ATOMIC);
 	if (rbconn == NULL)
@@ -333,87 +429,97 @@ count_tree(struct net *net,
 	   const struct nf_conntrack_tuple *tuple,
 	   const struct nf_conntrack_zone *zone)
 {
-	struct nf_conncount_rb *gc_nodes[CONNCOUNT_GC_MAX_NODES];
+	enum nf_conncount_list_add ret;
 	struct rb_root *root;
-	struct rb_node **rbnode, *parent;
+	struct rb_node *parent;
 	struct nf_conncount_rb *rbconn;
-	unsigned int gc_count, hash;
-	bool no_gc = false;
-	unsigned int count = 0;
+	unsigned int hash;
 	u8 keylen = data->keylen;
 
 	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
 
-	spin_lock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
- restart:
-	gc_count = 0;
-	parent = NULL;
-	rbnode = &(root->rb_node);
-	while (*rbnode) {
+	parent = rcu_dereference_raw(root->rb_node);
+	while (parent) {
 		int diff;
 		bool addit;
 
-		rbconn = rb_entry(*rbnode, struct nf_conncount_rb, node);
+		rbconn = rb_entry(parent, struct nf_conncount_rb, node);
 
-		parent = *rbnode;
 		diff = key_diff(key, rbconn->key, keylen);
 		if (diff < 0) {
-			rbnode = &((*rbnode)->rb_left);
+			parent = rcu_dereference_raw(parent->rb_left);
 		} else if (diff > 0) {
-			rbnode = &((*rbnode)->rb_right);
+			parent = rcu_dereference_raw(parent->rb_right);
 		} else {
 			/* same source network -> be counted! */
 			nf_conncount_lookup(net, &rbconn->list, tuple, zone,
 					    &addit);
-			count = rbconn->list.count;
 
-			tree_nodes_free(root, gc_nodes, gc_count);
 			if (!addit)
-				goto out_unlock;
+				return rbconn->list.count;
+
+			ret = nf_conncount_add(&rbconn->list, tuple, zone);
+			if (ret == NF_CONNCOUNT_ERR) {
+				return 0; /* hotdrop */
+			} else if (ret == NF_CONNCOUNT_ADDED) {
+				return rbconn->list.count;
+			} else {
+				/* NF_CONNCOUNT_SKIP, rbconn is already
+				 * reclaimed by gc, insert a new tree node
+				 */
+				break;
+			}
+		}
+	}
 
-			if (!nf_conncount_add(&rbconn->list, tuple, zone))
-				count = 0; /* hotdrop */
-				goto out_unlock;
+	if (!tuple)
+		return 0;
 
-			count++;
-			goto out_unlock;
-		}
+	return insert_tree(net, data, root, hash, key, keylen, tuple, zone);
+}
 
-		if (no_gc || gc_count >= ARRAY_SIZE(gc_nodes))
-			continue;
+static void tree_gc_worker(struct work_struct *work)
+{
+	struct nf_conncount_data *data = container_of(work, struct nf_conncount_data, gc_work);
+	struct nf_conncount_rb *gc_nodes[CONNCOUNT_GC_MAX_NODES], *rbconn;
+	struct rb_root *root;
+	struct rb_node *node;
+	unsigned int tree, next_tree, gc_count = 0;
+
+	tree = data->gc_tree % CONNCOUNT_LOCK_SLOTS;
+	root = &data->root[tree];
 
-		nf_conncount_gc_list(net, &rbconn->list);
-		if (list_empty(&rbconn->list.head))
+	rcu_read_lock();
+	for (node = rb_first(root); node != NULL; node = rb_next(node)) {
+		rbconn = rb_entry(node, struct nf_conncount_rb, node);
+		if (nf_conncount_gc_list(data->net, &rbconn->list))
 			gc_nodes[gc_count++] = rbconn;
 	}
+	rcu_read_unlock();
+
+	spin_lock_bh(&nf_conncount_locks[tree]);
 
 	if (gc_count) {
-		no_gc = true;
 		tree_nodes_free(root, gc_nodes, gc_count);
-		/* tree_node_free before new allocation permits
-		 * allocator to re-use newly free'd object.
-		 *
-		 * This is a rare event; in most cases we will find
-		 * existing node to re-use. (or gc_count is 0).
-		 */
-		goto restart;
 	}
 
-	count = 0;
-	if (!tuple)
-		goto out_unlock;
+	clear_bit(tree, data->pending_trees);
 
-	spin_unlock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
-	return insert_tree(root, hash, key, keylen, tuple, zone);
+	next_tree = (tree + 1) % CONNCOUNT_SLOTS;
+	next_tree = find_next_bit(data->pending_trees, next_tree, CONNCOUNT_SLOTS);
 
-out_unlock:
-	spin_unlock_bh(&nf_conncount_locks[hash % CONNCOUNT_LOCK_SLOTS]);
-	return count;
+	if (next_tree < CONNCOUNT_SLOTS) {
+		data->gc_tree = next_tree;
+		schedule_work(work);
+	}
+
+	spin_unlock_bh(&nf_conncount_locks[tree]);
 }
 
 /* Count and return number of conntrack entries in 'net' with particular 'key'.
  * If 'tuple' is not null, insert it into the accounting data structure.
+ * Call with RCU read lock.
  */
 unsigned int nf_conncount_count(struct net *net,
 				struct nf_conncount_data *data,
@@ -452,6 +558,8 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family
 		data->root[i] = RB_ROOT;
 
 	data->keylen = keylen / sizeof(u32);
+	data->net = net;
+	INIT_WORK(&data->gc_work, tree_gc_worker);
 
 	return data;
 }
@@ -487,6 +595,7 @@ void nf_conncount_destroy(struct net *net, unsigned int family,
 {
 	unsigned int i;
 
+	cancel_work_sync(&data->gc_work);
 	nf_ct_netns_put(net, family);
 
 	for (i = 0; i < ARRAY_SIZE(data->root); ++i)
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 37c52ae06741..b90d96ba4a12 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -14,7 +14,6 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 
 struct nft_connlimit {
-	spinlock_t			lock;
 	struct nf_conncount_list	list;
 	u32				limit;
 	bool				invert;
@@ -45,7 +44,6 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 		return;
 	}
 
-	spin_lock_bh(&priv->lock);
 	nf_conncount_lookup(nft_net(pkt), &priv->list, tuple_ptr, zone,
 			    &addit);
 	count = priv->list.count;
@@ -53,14 +51,12 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 	if (!addit)
 		goto out;
 
-	if (!nf_conncount_add(&priv->list, tuple_ptr, zone)) {
+	if (nf_conncount_add(&priv->list, tuple_ptr, zone) == NF_CONNCOUNT_ERR) {
 		regs->verdict.code = NF_DROP;
-		spin_unlock_bh(&priv->lock);
 		return;
 	}
 	count++;
 out:
-	spin_unlock_bh(&priv->lock);
 
 	if ((count > priv->limit) ^ priv->invert) {
 		regs->verdict.code = NFT_BREAK;
@@ -88,7 +84,6 @@ static int nft_connlimit_do_init(const struct nft_ctx *ctx,
 			invert = true;
 	}
 
-	spin_lock_init(&priv->lock);
 	nf_conncount_list_init(&priv->list);
 	priv->limit	= limit;
 	priv->invert	= invert;
@@ -213,7 +208,6 @@ static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_connlimit *priv_dst = nft_expr_priv(dst);
 	struct nft_connlimit *priv_src = nft_expr_priv(src);
 
-	spin_lock_init(&priv_dst->lock);
 	nf_conncount_list_init(&priv_dst->list);
 	priv_dst->limit	 = priv_src->limit;
 	priv_dst->invert = priv_src->invert;
@@ -232,15 +226,8 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
 static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
-	bool ret;
 
-	spin_lock_bh(&priv->lock);
-	nf_conncount_gc_list(net, &priv->list);
-
-	ret = list_empty(&priv->list.head);
-	spin_unlock_bh(&priv->lock);
-
-	return ret;
+	return nf_conncount_gc_list(net, &priv->list);
 }
 
 static struct nft_expr_type nft_connlimit_type;
-- 
2.11.0
