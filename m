Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729DF3B4C81;
	Thu, 22 Jan 2026 16:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769099399; cv=none; b=nI8p9M3J6sKtWbYejEY7V5QZjVS7w3kdr0kBFW7TeWfuft8fBeNHVtLtI2pc1SIJBEsYP0nmHXJlLG+fQW1qAR4C1mG0e1xlt6a5O/LtXzoxrLcDvFN0F+6Ep7S+ajrX7y3HDFn3pBUU5vUYhnHn+J4vyrF1gali1SdpD3IwBOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769099399; c=relaxed/simple;
	bh=VZEZeOOi9vcqsfls6wRdCbkZR0V1zp7WRNdhoxWRMrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFxbwVJPGmgVz4SU0grCTxgbBamoQme8tJWG88vlGnXeyS3NQDsgHsQebURWE3rpKbqPBSnNdnzvtlH29QR+xt8Be5jE5wEhkE2nTEAjwXCcI2ODY/0NI6NMscoK2B5i7YhDXxKXwEjw4pnXmHLMOCKtJ8V+ekmk9dSJYrL1HNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 04E3D607DA; Thu, 22 Jan 2026 17:29:46 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 2/4] netfilter: nft_set_rbtree: translate rbtree to array for binary search
Date: Thu, 22 Jan 2026 17:29:33 +0100
Message-ID: <20260122162935.8581-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122162935.8581-1-fw@strlen.de>
References: <20260122162935.8581-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

The rbtree can temporarily store overlapping inactive elements during
the transaction processing, leading to false negative lookups.

To address this issue, this patch adds a .commit function that walks the
the rbtree to build a array of intervals of ordered elements. This
conversion compacts the two singleton elements that represent the start
and the end of the interval into a single interval object for space
efficient.

Binary search is O(log n), similar to rbtree lookup time, therefore,
performance number should be similar, and there is an implementation
available under lib/bsearch.c and include/linux/bsearch.h that is used
for this purpose.

This slightly increases memory consumption for this new array that
stores pointers to the start and the end of the interval.

With this patch:

 # time nft -f 100k-intervals-set.nft

 real    0m4.218s
 user    0m3.544s
 sys     0m0.400s

Without this patch:

 # time nft -f 100k-intervals-set.nft

 real    0m3.920s
 user    0m3.547s
 sys     0m0.276s

With this patch, with IPv4 intervals:

  baseline rbtree (match on first field only):   15254954pps

Without this patch:

  baseline rbtree (match on first field only):   10256119pps

This provides a ~50% improvement in matching intervals from packet path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 341 +++++++++++++++++++++++++--------
 1 file changed, 257 insertions(+), 84 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index ca594161b840..821808e8da06 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -10,14 +10,29 @@
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <linux/bsearch.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 
+struct nft_array_interval {
+	struct nft_set_ext	*from;
+	struct nft_set_ext	*to;
+};
+
+struct nft_array {
+	u32			max_intervals;
+	u32			num_intervals;
+	struct nft_array_interval *intervals;
+	struct rcu_head		rcu_head;
+};
+
 struct nft_rbtree {
 	struct rb_root		root;
 	rwlock_t		lock;
+	struct nft_array __rcu	*array;
+	struct nft_array	*array_next;
 	seqcount_rwlock_t	count;
 	unsigned long		last_gc;
 };
@@ -47,90 +62,6 @@ static int nft_rbtree_cmp(const struct nft_set *set,
 		      set->klen);
 }
 
-static bool nft_rbtree_elem_expired(const struct nft_rbtree_elem *rbe)
-{
-	return nft_set_elem_expired(&rbe->ext);
-}
-
-static const struct nft_set_ext *
-__nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
-		    const u32 *key, unsigned int seq)
-{
-	struct nft_rbtree *priv = nft_set_priv(set);
-	const struct nft_rbtree_elem *rbe, *interval = NULL;
-	u8 genmask = nft_genmask_cur(net);
-	const struct rb_node *parent;
-	int d;
-
-	parent = rcu_dereference_raw(priv->root.rb_node);
-	while (parent != NULL) {
-		if (read_seqcount_retry(&priv->count, seq))
-			return NULL;
-
-		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
-
-		d = memcmp(nft_set_ext_key(&rbe->ext), key, set->klen);
-		if (d < 0) {
-			parent = rcu_dereference_raw(parent->rb_left);
-			if (interval &&
-			    !nft_rbtree_cmp(set, rbe, interval) &&
-			    nft_rbtree_interval_end(rbe) &&
-			    nft_rbtree_interval_start(interval))
-				continue;
-			if (nft_set_elem_active(&rbe->ext, genmask) &&
-			    !nft_rbtree_elem_expired(rbe))
-				interval = rbe;
-		} else if (d > 0)
-			parent = rcu_dereference_raw(parent->rb_right);
-		else {
-			if (!nft_set_elem_active(&rbe->ext, genmask)) {
-				parent = rcu_dereference_raw(parent->rb_left);
-				continue;
-			}
-
-			if (nft_rbtree_elem_expired(rbe))
-				return NULL;
-
-			if (nft_rbtree_interval_end(rbe)) {
-				if (nft_set_is_anonymous(set))
-					return NULL;
-				parent = rcu_dereference_raw(parent->rb_left);
-				interval = NULL;
-				continue;
-			}
-
-			return &rbe->ext;
-		}
-	}
-
-	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
-	    nft_rbtree_interval_start(interval))
-		return &interval->ext;
-
-	return NULL;
-}
-
-INDIRECT_CALLABLE_SCOPE
-const struct nft_set_ext *
-nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
-		  const u32 *key)
-{
-	struct nft_rbtree *priv = nft_set_priv(set);
-	unsigned int seq = read_seqcount_begin(&priv->count);
-	const struct nft_set_ext *ext;
-
-	ext = __nft_rbtree_lookup(net, set, key, seq);
-	if (ext || !read_seqcount_retry(&priv->count, seq))
-		return ext;
-
-	read_lock_bh(&priv->lock);
-	seq = read_seqcount_begin(&priv->count);
-	ext = __nft_rbtree_lookup(net, set, key, seq);
-	read_unlock_bh(&priv->lock);
-
-	return ext;
-}
-
 static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 			     const u32 *key, struct nft_rbtree_elem **elem,
 			     unsigned int seq, unsigned int flags, u8 genmask)
@@ -221,6 +152,60 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	return &rbe->priv;
 }
 
+struct nft_array_lookup_ctx {
+	const u32	*key;
+	u32		klen;
+};
+
+static int nft_array_lookup_cmp(const void *pkey, const void *entry)
+{
+	const struct nft_array_interval *interval = entry;
+	const struct nft_array_lookup_ctx *ctx = pkey;
+	int a, b;
+
+	if (!interval->from)
+		return 1;
+
+	a = memcmp(ctx->key, nft_set_ext_key(interval->from), ctx->klen);
+	if (!interval->to)
+		b = -1;
+	else
+		b = memcmp(ctx->key, nft_set_ext_key(interval->to), ctx->klen);
+
+	if (a >= 0 && b < 0)
+		return 0;
+
+	if (a < 0)
+		return -1;
+
+	return 1;
+}
+
+INDIRECT_CALLABLE_SCOPE
+const struct nft_set_ext *
+nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
+		  const u32 *key)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_array *array = rcu_dereference(priv->array);
+	const struct nft_array_interval *interval;
+	struct nft_array_lookup_ctx ctx = {
+		.key	= key,
+		.klen	= set->klen,
+	};
+
+	if (!array)
+		return NULL;
+
+	interval = bsearch(&ctx, array->intervals, array->num_intervals,
+			   sizeof(struct nft_array_interval),
+			   nft_array_lookup_cmp);
+	if (!interval || nft_set_elem_expired(interval->from))
+		return NULL;
+
+	return interval->from;
+}
+
 static void nft_rbtree_gc_elem_remove(struct net *net, struct nft_set *set,
 				      struct nft_rbtree *priv,
 				      struct nft_rbtree_elem *rbe)
@@ -481,6 +466,87 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	return 0;
 }
 
+static int nft_array_intervals_alloc(struct nft_array *array, u32 max_intervals)
+{
+	struct nft_array_interval *intervals;
+
+	intervals = kvcalloc(max_intervals, sizeof(struct nft_array_interval),
+			     GFP_KERNEL_ACCOUNT);
+	if (!intervals)
+		return -ENOMEM;
+
+	if (array->intervals)
+		kvfree(array->intervals);
+
+	array->intervals = intervals;
+	array->max_intervals = max_intervals;
+
+	return 0;
+}
+
+static struct nft_array *nft_array_alloc(u32 max_intervals)
+{
+	struct nft_array *array;
+
+	array = kzalloc(sizeof(*array), GFP_KERNEL_ACCOUNT);
+	if (!array)
+		return NULL;
+
+	if (nft_array_intervals_alloc(array, max_intervals) < 0) {
+		kfree(array);
+		return NULL;
+	}
+
+	return array;
+}
+
+#define NFT_ARRAY_EXTRA_SIZE	10240
+
+/* Similar to nft_rbtree_{u,k}size to hide details to userspace, but consider
+ * packed representation coming from userspace for anonymous sets too.
+ */
+static u32 nft_array_elems(const struct nft_set *set)
+{
+	u32 nelems = atomic_read(&set->nelems);
+
+	/* Adjacent intervals are represented with a single start element in
+	 * anonymous sets, use the current element counter as is.
+	 */
+	if (nft_set_is_anonymous(set))
+		return nelems;
+
+	/* Add extra room for never matching interval at the beginning and open
+	 * interval at the end which only use a single element to represent it.
+	 * The conversion to array will compact intervals, this allows reduce
+	 * memory consumption.
+	 */
+	return (nelems / 2) + 2;
+}
+
+static int nft_array_may_resize(const struct nft_set *set)
+{
+	u32 nelems = nft_array_elems(set), new_max_intervals;
+	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_array *array;
+
+	if (!priv->array_next) {
+		array = nft_array_alloc(nelems + NFT_ARRAY_EXTRA_SIZE);
+		if (!array)
+			return -ENOMEM;
+
+		priv->array_next = array;
+	}
+
+	if (nelems < priv->array_next->max_intervals)
+		return 0;
+
+	new_max_intervals = priv->array_next->max_intervals + NFT_ARRAY_EXTRA_SIZE;
+	if (nft_array_intervals_alloc(priv->array_next, new_max_intervals) < 0)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			     const struct nft_set_elem *elem,
 			     struct nft_elem_priv **elem_priv)
@@ -489,6 +555,9 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	struct nft_rbtree *priv = nft_set_priv(set);
 	int err;
 
+	if (nft_array_may_resize(set) < 0)
+		return -ENOMEM;
+
 	do {
 		if (fatal_signal_pending(current))
 			return -EINTR;
@@ -553,6 +622,9 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 	u64 tstamp = nft_net_tstamp(net);
 	int d;
 
+	if (nft_array_may_resize(set) < 0)
+		return NULL;
+
 	while (parent != NULL) {
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
 
@@ -615,6 +687,11 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 	switch (iter->type) {
 	case NFT_ITER_UPDATE:
 		lockdep_assert_held(&nft_pernet(ctx->net)->commit_mutex);
+
+		if (nft_array_may_resize(set) < 0) {
+			iter->err = -ENOMEM;
+			break;
+		}
 		nft_rbtree_do_walk(ctx, set, iter);
 		break;
 	case NFT_ITER_READ:
@@ -717,14 +794,24 @@ static int nft_rbtree_init(const struct nft_set *set,
 	seqcount_rwlock_init(&priv->count, &priv->lock);
 	priv->root = RB_ROOT;
 
+	priv->array = NULL;
+	priv->array_next = NULL;
+
 	return 0;
 }
 
+static void __nft_array_free(struct nft_array *array)
+{
+	kvfree(array->intervals);
+	kfree(array);
+}
+
 static void nft_rbtree_destroy(const struct nft_ctx *ctx,
 			       const struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe;
+	struct nft_array *array;
 	struct rb_node *node;
 
 	while ((node = priv->root.rb_node) != NULL) {
@@ -732,6 +819,12 @@ static void nft_rbtree_destroy(const struct nft_ctx *ctx,
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 		nf_tables_set_elem_destroy(ctx, set, &rbe->priv);
 	}
+
+	array = rcu_dereference_protected(priv->array, true);
+	if (array)
+		__nft_array_free(array);
+	if (priv->array_next)
+		__nft_array_free(priv->array_next);
 }
 
 static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
@@ -752,12 +845,91 @@ static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
+static void nft_array_free_rcu(struct rcu_head *rcu_head)
+{
+	struct nft_array *array = container_of(rcu_head, struct nft_array, rcu_head);
+
+	__nft_array_free(array);
+}
+
 static void nft_rbtree_commit(struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_rbtree_elem *rbe, *prev_rbe;
+	struct nft_array *old;
+	u32 num_intervals = 0;
+	struct rb_node *node;
 
 	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
 		nft_rbtree_gc(set);
+
+	/* No changes, skip, eg. elements updates only. */
+	if (!priv->array_next)
+		return;
+
+	/* Reverse walk to create an array from smaller to largest interval. */
+	node = rb_last(&priv->root);
+	if (node)
+		prev_rbe = rb_entry(node, struct nft_rbtree_elem, node);
+	else
+		prev_rbe = NULL;
+
+	while (prev_rbe) {
+		rbe = prev_rbe;
+
+		if (nft_rbtree_interval_start(rbe))
+			priv->array_next->intervals[num_intervals].from = &rbe->ext;
+		else if (nft_rbtree_interval_end(rbe))
+			priv->array_next->intervals[num_intervals++].to = &rbe->ext;
+
+		if (num_intervals >= priv->array_next->max_intervals) {
+			pr_warn_once("malformed interval set from userspace?");
+			goto err_out;
+		}
+
+		node = rb_prev(node);
+		if (!node)
+			break;
+
+		prev_rbe = rb_entry(node, struct nft_rbtree_elem, node);
+
+		/* For anonymous sets, when adjacent ranges are found,
+		 * the end element is not added to the set to pack the set
+		 * representation. Use next start element to complete this
+		 * interval.
+		 */
+		if (nft_rbtree_interval_start(rbe) &&
+		    nft_rbtree_interval_start(prev_rbe) &&
+		    priv->array_next->intervals[num_intervals].from)
+			priv->array_next->intervals[num_intervals++].to = &prev_rbe->ext;
+
+		if (num_intervals >= priv->array_next->max_intervals) {
+			pr_warn_once("malformed interval set from userspace?");
+			goto err_out;
+		}
+	}
+
+	if (priv->array_next->intervals[num_intervals].from)
+		num_intervals++;
+err_out:
+	priv->array_next->num_intervals = num_intervals;
+	old = rcu_replace_pointer(priv->array, priv->array_next, true);
+	priv->array_next = NULL;
+	if (old)
+		call_rcu(&old->rcu_head, nft_array_free_rcu);
+}
+
+static void nft_rbtree_abort(const struct nft_set *set)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_array *array_next;
+
+	if (!priv->array_next)
+		return;
+
+	array_next = priv->array_next;
+	priv->array_next = NULL;
+	__nft_array_free(array_next);
 }
 
 static void nft_rbtree_gc_init(const struct nft_set *set)
@@ -821,6 +993,7 @@ const struct nft_set_type nft_set_rbtree_type = {
 		.flush		= nft_rbtree_flush,
 		.activate	= nft_rbtree_activate,
 		.commit		= nft_rbtree_commit,
+		.abort		= nft_rbtree_abort,
 		.gc_init	= nft_rbtree_gc_init,
 		.lookup		= nft_rbtree_lookup,
 		.walk		= nft_rbtree_walk,
-- 
2.52.0

