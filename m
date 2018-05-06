From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 28/51] netfilter: nf_tables: Simplify set backend selection
Date: Mon,  7 May 2018 00:46:46 +0200
Message-ID: <20180506224709.29100-29-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Drop nft_set_type's ability to act as a container of multiple backend
implementations it chooses from. Instead consolidate the whole selection
logic in nft_select_set_ops() and the actual backend provided estimate()
callback.

This turns nf_tables_set_types into a list containing all available
backends which is traversed when selecting one matching userspace
requested criteria.

Also, this change allows to embed nft_set_ops structure into
nft_set_type and pull flags field into the latter as it's only used
during selection phase.

A crucial part of this change is to make sure the new layout respects
hash backend constraints formerly enforced by nft_hash_select_ops()
function: This is achieved by introduction of a specific estimate()
callback for nft_hash_fast_ops which returns false for key lengths != 4.
In turn, nft_hash_estimate() is changed to return false for key lengths
== 4 so it won't be chosen by accident. Also, both callbacks must return
false for unbounded sets as their size estimate depends on a known
maximum element count.

Note that this patch partially reverts commit 4f2921ca21b71 ("netfilter:
nf_tables: meter: pick a set backend that supports updates") by making
nft_set_ops_candidate() not explicitly look for an update callback but
make NFT_SET_EVAL a regular backend feature flag which is checked along
with the others. This way all feature requirements are checked in one
go.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  34 ++++-----
 net/netfilter/nf_tables_api.c     |  25 +++----
 net/netfilter/nft_set_bitmap.c    |  34 ++++-----
 net/netfilter/nft_set_hash.c      | 153 +++++++++++++++++++++-----------------
 net/netfilter/nft_set_rbtree.c    |  36 ++++-----
 5 files changed, 139 insertions(+), 143 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 123e82a2f8bb..de77d36e36b3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -275,23 +275,6 @@ struct nft_set_estimate {
 	enum nft_set_class	space;
 };
 
-/**
- *      struct nft_set_type - nf_tables set type
- *
- *      @select_ops: function to select nft_set_ops
- *      @ops: default ops, used when no select_ops functions is present
- *      @list: used internally
- *      @owner: module reference
- */
-struct nft_set_type {
-	const struct nft_set_ops	*(*select_ops)(const struct nft_ctx *,
-						       const struct nft_set_desc *desc,
-						       u32 flags);
-	const struct nft_set_ops	*ops;
-	struct list_head		list;
-	struct module			*owner;
-};
-
 struct nft_set_ext;
 struct nft_expr;
 
@@ -310,7 +293,6 @@ struct nft_expr;
  *	@init: initialize private data of new set instance
  *	@destroy: destroy private data of set instance
  *	@elemsize: element private size
- *	@features: features supported by the implementation
  */
 struct nft_set_ops {
 	bool				(*lookup)(const struct net *net,
@@ -361,9 +343,23 @@ struct nft_set_ops {
 	void				(*destroy)(const struct nft_set *set);
 
 	unsigned int			elemsize;
+};
+
+/**
+ *      struct nft_set_type - nf_tables set type
+ *
+ *      @ops: set ops for this type
+ *      @list: used internally
+ *      @owner: module reference
+ *      @features: features supported by the implementation
+ */
+struct nft_set_type {
+	const struct nft_set_ops	ops;
+	struct list_head		list;
+	struct module			*owner;
 	u32				features;
-	const struct nft_set_type	*type;
 };
+#define to_set_type(o) container_of(o, struct nft_set_type, ops)
 
 int nft_register_set(struct nft_set_type *type);
 void nft_unregister_set(struct nft_set_type *type);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2f14cadd9922..9ce35acf491d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2523,14 +2523,12 @@ void nft_unregister_set(struct nft_set_type *type)
 EXPORT_SYMBOL_GPL(nft_unregister_set);
 
 #define NFT_SET_FEATURES	(NFT_SET_INTERVAL | NFT_SET_MAP | \
-				 NFT_SET_TIMEOUT | NFT_SET_OBJECT)
+				 NFT_SET_TIMEOUT | NFT_SET_OBJECT | \
+				 NFT_SET_EVAL)
 
-static bool nft_set_ops_candidate(const struct nft_set_ops *ops, u32 flags)
+static bool nft_set_ops_candidate(const struct nft_set_type *type, u32 flags)
 {
-	if ((flags & NFT_SET_EVAL) && !ops->update)
-		return false;
-
-	return (flags & ops->features) == (flags & NFT_SET_FEATURES);
+	return (flags & type->features) == (flags & NFT_SET_FEATURES);
 }
 
 /*
@@ -2567,14 +2565,9 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 	best.space  = ~0;
 
 	list_for_each_entry(type, &nf_tables_set_types, list) {
-		if (!type->select_ops)
-			ops = type->ops;
-		else
-			ops = type->select_ops(ctx, desc, flags);
-		if (!ops)
-			continue;
+		ops = &type->ops;
 
-		if (!nft_set_ops_candidate(ops, flags))
+		if (!nft_set_ops_candidate(type, flags))
 			continue;
 		if (!ops->estimate(desc, flags, &est))
 			continue;
@@ -2605,7 +2598,7 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 		if (!try_module_get(type->owner))
 			continue;
 		if (bops != NULL)
-			module_put(bops->type->owner);
+			module_put(to_set_type(bops)->owner);
 
 		bops = ops;
 		best = est;
@@ -3247,14 +3240,14 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 err2:
 	kvfree(set);
 err1:
-	module_put(ops->type->owner);
+	module_put(to_set_type(ops)->owner);
 	return err;
 }
 
 static void nft_set_destroy(struct nft_set *set)
 {
 	set->ops->destroy(set);
-	module_put(set->ops->type->owner);
+	module_put(to_set_type(set->ops)->owner);
 	kfree(set->name);
 	kvfree(set);
 }
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 45fb2752fb63..d6626e01c7ee 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -296,27 +296,23 @@ static bool nft_bitmap_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
-static struct nft_set_type nft_bitmap_type;
-static struct nft_set_ops nft_bitmap_ops __read_mostly = {
-	.type		= &nft_bitmap_type,
-	.privsize	= nft_bitmap_privsize,
-	.elemsize	= offsetof(struct nft_bitmap_elem, ext),
-	.estimate	= nft_bitmap_estimate,
-	.init		= nft_bitmap_init,
-	.destroy	= nft_bitmap_destroy,
-	.insert		= nft_bitmap_insert,
-	.remove		= nft_bitmap_remove,
-	.deactivate	= nft_bitmap_deactivate,
-	.flush		= nft_bitmap_flush,
-	.activate	= nft_bitmap_activate,
-	.lookup		= nft_bitmap_lookup,
-	.walk		= nft_bitmap_walk,
-	.get		= nft_bitmap_get,
-};
-
 static struct nft_set_type nft_bitmap_type __read_mostly = {
-	.ops		= &nft_bitmap_ops,
 	.owner		= THIS_MODULE,
+	.ops		= {
+		.privsize	= nft_bitmap_privsize,
+		.elemsize	= offsetof(struct nft_bitmap_elem, ext),
+		.estimate	= nft_bitmap_estimate,
+		.init		= nft_bitmap_init,
+		.destroy	= nft_bitmap_destroy,
+		.insert		= nft_bitmap_insert,
+		.remove		= nft_bitmap_remove,
+		.deactivate	= nft_bitmap_deactivate,
+		.flush		= nft_bitmap_flush,
+		.activate	= nft_bitmap_activate,
+		.lookup		= nft_bitmap_lookup,
+		.walk		= nft_bitmap_walk,
+		.get		= nft_bitmap_get,
+	},
 };
 
 static int __init nft_bitmap_module_init(void)
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index fc9c6d5d64cd..dbf1f4ad077c 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -605,6 +605,12 @@ static void nft_hash_destroy(const struct nft_set *set)
 static bool nft_hash_estimate(const struct nft_set_desc *desc, u32 features,
 			      struct nft_set_estimate *est)
 {
+	if (!desc->size)
+		return false;
+
+	if (desc->klen == 4)
+		return false;
+
 	est->size   = sizeof(struct nft_hash) +
 		      nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
 		      desc->size * sizeof(struct nft_hash_elem);
@@ -614,91 +620,100 @@ static bool nft_hash_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
-static struct nft_set_type nft_hash_type;
-static struct nft_set_ops nft_rhash_ops __read_mostly = {
-	.type		= &nft_hash_type,
-	.privsize       = nft_rhash_privsize,
-	.elemsize	= offsetof(struct nft_rhash_elem, ext),
-	.estimate	= nft_rhash_estimate,
-	.init		= nft_rhash_init,
-	.destroy	= nft_rhash_destroy,
-	.insert		= nft_rhash_insert,
-	.activate	= nft_rhash_activate,
-	.deactivate	= nft_rhash_deactivate,
-	.flush		= nft_rhash_flush,
-	.remove		= nft_rhash_remove,
-	.lookup		= nft_rhash_lookup,
-	.update		= nft_rhash_update,
-	.walk		= nft_rhash_walk,
-	.get		= nft_rhash_get,
-	.features	= NFT_SET_MAP | NFT_SET_OBJECT | NFT_SET_TIMEOUT,
-};
+static bool nft_hash_fast_estimate(const struct nft_set_desc *desc, u32 features,
+			      struct nft_set_estimate *est)
+{
+	if (!desc->size)
+		return false;
 
-static struct nft_set_ops nft_hash_ops __read_mostly = {
-	.type		= &nft_hash_type,
-	.privsize       = nft_hash_privsize,
-	.elemsize	= offsetof(struct nft_hash_elem, ext),
-	.estimate	= nft_hash_estimate,
-	.init		= nft_hash_init,
-	.destroy	= nft_hash_destroy,
-	.insert		= nft_hash_insert,
-	.activate	= nft_hash_activate,
-	.deactivate	= nft_hash_deactivate,
-	.flush		= nft_hash_flush,
-	.remove		= nft_hash_remove,
-	.lookup		= nft_hash_lookup,
-	.walk		= nft_hash_walk,
-	.get		= nft_hash_get,
-	.features	= NFT_SET_MAP | NFT_SET_OBJECT,
-};
+	if (desc->klen != 4)
+		return false;
 
-static struct nft_set_ops nft_hash_fast_ops __read_mostly = {
-	.type		= &nft_hash_type,
-	.privsize       = nft_hash_privsize,
-	.elemsize	= offsetof(struct nft_hash_elem, ext),
-	.estimate	= nft_hash_estimate,
-	.init		= nft_hash_init,
-	.destroy	= nft_hash_destroy,
-	.insert		= nft_hash_insert,
-	.activate	= nft_hash_activate,
-	.deactivate	= nft_hash_deactivate,
-	.flush		= nft_hash_flush,
-	.remove		= nft_hash_remove,
-	.lookup		= nft_hash_lookup_fast,
-	.walk		= nft_hash_walk,
-	.get		= nft_hash_get,
-	.features	= NFT_SET_MAP | NFT_SET_OBJECT,
-};
-
-static const struct nft_set_ops *
-nft_hash_select_ops(const struct nft_ctx *ctx, const struct nft_set_desc *desc,
-		    u32 flags)
-{
-	if (desc->size && !(flags & (NFT_SET_EVAL | NFT_SET_TIMEOUT))) {
-		switch (desc->klen) {
-		case 4:
-			return &nft_hash_fast_ops;
-		default:
-			return &nft_hash_ops;
-		}
-	}
+	est->size   = sizeof(struct nft_hash) +
+		      nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
+		      desc->size * sizeof(struct nft_hash_elem);
+	est->lookup = NFT_SET_CLASS_O_1;
+	est->space  = NFT_SET_CLASS_O_N;
 
-	return &nft_rhash_ops;
+	return true;
 }
 
+static struct nft_set_type nft_rhash_type __read_mostly = {
+	.owner		= THIS_MODULE,
+	.features	= NFT_SET_MAP | NFT_SET_OBJECT |
+			  NFT_SET_TIMEOUT | NFT_SET_EVAL,
+	.ops		= {
+		.privsize       = nft_rhash_privsize,
+		.elemsize	= offsetof(struct nft_rhash_elem, ext),
+		.estimate	= nft_rhash_estimate,
+		.init		= nft_rhash_init,
+		.destroy	= nft_rhash_destroy,
+		.insert		= nft_rhash_insert,
+		.activate	= nft_rhash_activate,
+		.deactivate	= nft_rhash_deactivate,
+		.flush		= nft_rhash_flush,
+		.remove		= nft_rhash_remove,
+		.lookup		= nft_rhash_lookup,
+		.update		= nft_rhash_update,
+		.walk		= nft_rhash_walk,
+		.get		= nft_rhash_get,
+	},
+};
+
 static struct nft_set_type nft_hash_type __read_mostly = {
-	.select_ops	= nft_hash_select_ops,
 	.owner		= THIS_MODULE,
+	.features	= NFT_SET_MAP | NFT_SET_OBJECT,
+	.ops		= {
+		.privsize       = nft_hash_privsize,
+		.elemsize	= offsetof(struct nft_hash_elem, ext),
+		.estimate	= nft_hash_estimate,
+		.init		= nft_hash_init,
+		.destroy	= nft_hash_destroy,
+		.insert		= nft_hash_insert,
+		.activate	= nft_hash_activate,
+		.deactivate	= nft_hash_deactivate,
+		.flush		= nft_hash_flush,
+		.remove		= nft_hash_remove,
+		.lookup		= nft_hash_lookup,
+		.walk		= nft_hash_walk,
+		.get		= nft_hash_get,
+	},
+};
+
+static struct nft_set_type nft_hash_fast_type __read_mostly = {
+	.owner		= THIS_MODULE,
+	.features	= NFT_SET_MAP | NFT_SET_OBJECT,
+	.ops		= {
+		.privsize       = nft_hash_privsize,
+		.elemsize	= offsetof(struct nft_hash_elem, ext),
+		.estimate	= nft_hash_fast_estimate,
+		.init		= nft_hash_init,
+		.destroy	= nft_hash_destroy,
+		.insert		= nft_hash_insert,
+		.activate	= nft_hash_activate,
+		.deactivate	= nft_hash_deactivate,
+		.flush		= nft_hash_flush,
+		.remove		= nft_hash_remove,
+		.lookup		= nft_hash_lookup_fast,
+		.walk		= nft_hash_walk,
+		.get		= nft_hash_get,
+	},
 };
 
 static int __init nft_hash_module_init(void)
 {
-	return nft_register_set(&nft_hash_type);
+	if (nft_register_set(&nft_hash_fast_type) ||
+	    nft_register_set(&nft_hash_type) ||
+	    nft_register_set(&nft_rhash_type))
+		return 1;
+	return 0;
 }
 
 static void __exit nft_hash_module_exit(void)
 {
+	nft_unregister_set(&nft_rhash_type);
 	nft_unregister_set(&nft_hash_type);
+	nft_unregister_set(&nft_hash_fast_type);
 }
 
 module_init(nft_hash_module_init);
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index e6f08bc5f359..22c57d7612c4 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -393,28 +393,24 @@ static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
-static struct nft_set_type nft_rbtree_type;
-static struct nft_set_ops nft_rbtree_ops __read_mostly = {
-	.type		= &nft_rbtree_type,
-	.privsize	= nft_rbtree_privsize,
-	.elemsize	= offsetof(struct nft_rbtree_elem, ext),
-	.estimate	= nft_rbtree_estimate,
-	.init		= nft_rbtree_init,
-	.destroy	= nft_rbtree_destroy,
-	.insert		= nft_rbtree_insert,
-	.remove		= nft_rbtree_remove,
-	.deactivate	= nft_rbtree_deactivate,
-	.flush		= nft_rbtree_flush,
-	.activate	= nft_rbtree_activate,
-	.lookup		= nft_rbtree_lookup,
-	.walk		= nft_rbtree_walk,
-	.get		= nft_rbtree_get,
-	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT,
-};
-
 static struct nft_set_type nft_rbtree_type __read_mostly = {
-	.ops		= &nft_rbtree_ops,
 	.owner		= THIS_MODULE,
+	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT,
+	.ops		= {
+		.privsize	= nft_rbtree_privsize,
+		.elemsize	= offsetof(struct nft_rbtree_elem, ext),
+		.estimate	= nft_rbtree_estimate,
+		.init		= nft_rbtree_init,
+		.destroy	= nft_rbtree_destroy,
+		.insert		= nft_rbtree_insert,
+		.remove		= nft_rbtree_remove,
+		.deactivate	= nft_rbtree_deactivate,
+		.flush		= nft_rbtree_flush,
+		.activate	= nft_rbtree_activate,
+		.lookup		= nft_rbtree_lookup,
+		.walk		= nft_rbtree_walk,
+		.get		= nft_rbtree_get,
+	},
 };
 
 static int __init nft_rbtree_module_init(void)
-- 
2.11.0
