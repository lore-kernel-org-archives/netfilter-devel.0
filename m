From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/18] netfilter: nft_set_rbtree: add timeout support
Date: Wed, 23 May 2018 20:42:49 +0200
Message-ID: <20180523184254.22599-14-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add garbage collection logic to expire elements stored in the rb-tree
representation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 75 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 22c57d7612c4..d260ce2d6671 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -22,6 +22,7 @@ struct nft_rbtree {
 	struct rb_root		root;
 	rwlock_t		lock;
 	seqcount_t		count;
+	struct delayed_work	gc_work;
 };
 
 struct nft_rbtree_elem {
@@ -265,6 +266,7 @@ static void nft_rbtree_activate(const struct net *net,
 	struct nft_rbtree_elem *rbe = elem->priv;
 
 	nft_set_elem_change_active(net, set, &rbe->ext);
+	nft_set_elem_clear_busy(&rbe->ext);
 }
 
 static bool nft_rbtree_flush(const struct net *net,
@@ -272,8 +274,12 @@ static bool nft_rbtree_flush(const struct net *net,
 {
 	struct nft_rbtree_elem *rbe = priv;
 
-	nft_set_elem_change_active(net, set, &rbe->ext);
-	return true;
+	if (!nft_set_elem_mark_busy(&rbe->ext) ||
+	    !nft_is_active(net, &rbe->ext)) {
+		nft_set_elem_change_active(net, set, &rbe->ext);
+		return true;
+	}
+	return false;
 }
 
 static void *nft_rbtree_deactivate(const struct net *net,
@@ -347,6 +353,62 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 	read_unlock_bh(&priv->lock);
 }
 
+static void nft_rbtree_gc(struct work_struct *work)
+{
+	struct nft_set_gc_batch *gcb = NULL;
+	struct rb_node *node, *prev = NULL;
+	struct nft_rbtree_elem *rbe;
+	struct nft_rbtree *priv;
+	struct nft_set *set;
+	int i;
+
+	priv = container_of(work, struct nft_rbtree, gc_work.work);
+	set  = nft_set_container_of(priv);
+
+	write_lock_bh(&priv->lock);
+	write_seqcount_begin(&priv->count);
+	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
+		rbe = rb_entry(node, struct nft_rbtree_elem, node);
+
+		if (nft_rbtree_interval_end(rbe)) {
+			prev = node;
+			continue;
+		}
+		if (!nft_set_elem_expired(&rbe->ext))
+			continue;
+		if (nft_set_elem_mark_busy(&rbe->ext))
+			continue;
+
+		gcb = nft_set_gc_batch_check(set, gcb, GFP_ATOMIC);
+		if (!gcb)
+			goto out;
+
+		atomic_dec(&set->nelems);
+		nft_set_gc_batch_add(gcb, rbe);
+
+		if (prev) {
+			rbe = rb_entry(prev, struct nft_rbtree_elem, node);
+			atomic_dec(&set->nelems);
+			nft_set_gc_batch_add(gcb, rbe);
+		}
+		node = rb_next(node);
+	}
+out:
+	if (gcb) {
+		for (i = 0; i < gcb->head.cnt; i++) {
+			rbe = gcb->elems[i];
+			rb_erase(&rbe->node, &priv->root);
+		}
+	}
+	write_seqcount_end(&priv->count);
+	write_unlock_bh(&priv->lock);
+
+	nft_set_gc_batch_complete(gcb);
+
+	queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
+			   nft_set_gc_interval(set));
+}
+
 static unsigned int nft_rbtree_privsize(const struct nlattr * const nla[],
 					const struct nft_set_desc *desc)
 {
@@ -362,6 +424,12 @@ static int nft_rbtree_init(const struct nft_set *set,
 	rwlock_init(&priv->lock);
 	seqcount_init(&priv->count);
 	priv->root = RB_ROOT;
+
+	INIT_DEFERRABLE_WORK(&priv->gc_work, nft_rbtree_gc);
+	if (set->flags & NFT_SET_TIMEOUT)
+		queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
+				   nft_set_gc_interval(set));
+
 	return 0;
 }
 
@@ -371,6 +439,7 @@ static void nft_rbtree_destroy(const struct nft_set *set)
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *node;
 
+	cancel_delayed_work_sync(&priv->gc_work);
 	while ((node = priv->root.rb_node) != NULL) {
 		rb_erase(node, &priv->root);
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
@@ -395,7 +464,7 @@ static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
 
 static struct nft_set_type nft_rbtree_type __read_mostly = {
 	.owner		= THIS_MODULE,
-	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT,
+	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT | NFT_SET_TIMEOUT,
 	.ops		= {
 		.privsize	= nft_rbtree_privsize,
 		.elemsize	= offsetof(struct nft_rbtree_elem, ext),
-- 
2.11.0
