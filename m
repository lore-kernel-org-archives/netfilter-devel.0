Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DE1337113
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Nov 2025 11:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763464646; cv=none; b=QJZVKq11Tw3t/caJoB4uqoXVYXlmC3iMnpRcckhAZhF20t8g5OVHuL98h/SDIR5PfOxTbNK+e4vpRYNE5F1xORlw2lf23RBkMsWdIzoORfUlxt/9Xlbu+DH5hMhgWafKczLn/W4d+l2Jnfc95+jZCo1F/FgxPhT0Km4Tqx1Lo2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763464646; c=relaxed/simple;
	bh=qqSQvPepFSLoMrHcHqUd7/CLu7Hcgxu23qPNeHdZE68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPEpDctv3wbIWhSBBOU+4oF2lqqa5zt3qflZdyC2vbMimioUNHVk41cuO4JJHcseVwo4jxRVShXMMG4Rj/fvZ2NVC4NZCjb7YmGRBmCFJ7/jbSO4pY7QpOIvNNnBcFvuEM/DOGmyLMdZ7rFcNt9qyl09fif2J/uLiRax+sYFnkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 71163604C0; Tue, 18 Nov 2025 12:17:14 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: nft_set_rbtree: prepare for two rbtrees
Date: Tue, 18 Nov 2025 12:16:48 +0100
Message-ID: <20251118111657.12003-2-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251118111657.12003-1-fw@strlen.de>
References: <20251118111657.12003-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Preparation patch that has no intended side effects.

1. add a second rb_root to the set
2. allow elements to be part of two trees

One tree will be the live copy used for matching from packet path.
Other tree will be used for deletions and insertions from control plane.

As-is, new elements are exposed to the packetpath.

Once the commit phase increments the gencursor (but before it erased old
elements from the tree), there is a short time period where such now
inactive-and-about-to-be-erased elements shadow new, valid entries.

This situation only exists for a very short time window, but it is
unwanted.

If the tree stores ranges a-b (being removed) and a-c (getting added),
then a lookup for a key that resides in the a-b or a-c interval must find
the former or the latter range.

To resolve this, followup patches will do all modifications in a hidden
tree, not exposed to packet path:

Lookups either observe still-valid a-b in the old tree or the already-valid
a-c range in the replaced tree.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 105 +++++++++++++++++++++------------
 1 file changed, 66 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index ca594161b840..3d4db2b93d6a 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -16,7 +16,7 @@
 #include <net/netfilter/nf_tables_core.h>
 
 struct nft_rbtree {
-	struct rb_root		root;
+	struct rb_root		root[2];
 	rwlock_t		lock;
 	seqcount_rwlock_t	count;
 	unsigned long		last_gc;
@@ -24,7 +24,7 @@ struct nft_rbtree {
 
 struct nft_rbtree_elem {
 	struct nft_elem_priv	priv;
-	struct rb_node		node;
+	struct rb_node		node[2];
 	struct nft_set_ext	ext;
 };
 
@@ -60,14 +60,15 @@ __nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
 	const struct nft_rbtree_elem *rbe, *interval = NULL;
 	u8 genmask = nft_genmask_cur(net);
 	const struct rb_node *parent;
+	u8 genbit = 0;
 	int d;
 
-	parent = rcu_dereference_raw(priv->root.rb_node);
+	parent = rcu_dereference_raw(priv->root[genbit].rb_node);
 	while (parent != NULL) {
 		if (read_seqcount_retry(&priv->count, seq))
 			return NULL;
 
-		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node[genbit]);
 
 		d = memcmp(nft_set_ext_key(&rbe->ext), key, set->klen);
 		if (d < 0) {
@@ -139,14 +140,15 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	struct nft_rbtree *priv = nft_set_priv(set);
 	const struct rb_node *parent;
 	const void *this;
+	u8 genbit = 0;
 	int d;
 
-	parent = rcu_dereference_raw(priv->root.rb_node);
+	parent = rcu_dereference_raw(priv->root[genbit].rb_node);
 	while (parent != NULL) {
 		if (read_seqcount_retry(&priv->count, seq))
 			return false;
 
-		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node[genbit]);
 
 		this = nft_set_ext_key(&rbe->ext);
 		d = memcmp(this, key, set->klen);
@@ -223,11 +225,12 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 static void nft_rbtree_gc_elem_remove(struct net *net, struct nft_set *set,
 				      struct nft_rbtree *priv,
-				      struct nft_rbtree_elem *rbe)
+				      struct nft_rbtree_elem *rbe,
+				      u8 genbit)
 {
 	lockdep_assert_held_write(&priv->lock);
 	nft_setelem_data_deactivate(net, set, &rbe->priv);
-	rb_erase(&rbe->node, &priv->root);
+	rb_erase(&rbe->node[genbit], &priv->root[genbit]);
 }
 
 static const struct nft_rbtree_elem *
@@ -235,10 +238,13 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 		   struct nft_rbtree_elem *rbe)
 {
 	struct nft_set *set = (struct nft_set *)__set;
-	struct rb_node *prev = rb_prev(&rbe->node);
 	struct net *net = read_pnet(&set->net);
 	struct nft_rbtree_elem *rbe_prev;
 	struct nft_trans_gc *gc;
+	struct rb_node *prev;
+	u8 genbit = 0;
+
+	prev = rb_prev(&rbe->node[genbit]);
 
 	gc = nft_trans_gc_alloc(set, 0, GFP_ATOMIC);
 	if (!gc)
@@ -249,7 +255,7 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 	 * are coupled with the interval start element.
 	 */
 	while (prev) {
-		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
+		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node[genbit]);
 		if (nft_rbtree_interval_end(rbe_prev) &&
 		    nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
 			break;
@@ -259,8 +265,8 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 
 	rbe_prev = NULL;
 	if (prev) {
-		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		nft_rbtree_gc_elem_remove(net, set, priv, rbe_prev);
+		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node[genbit]);
+		nft_rbtree_gc_elem_remove(net, set, priv, rbe_prev, genbit);
 
 		/* There is always room in this trans gc for this element,
 		 * memory allocation never actually happens, hence, the warning
@@ -274,7 +280,7 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 		nft_trans_gc_elem_add(gc, rbe_prev);
 	}
 
-	nft_rbtree_gc_elem_remove(net, set, priv, rbe);
+	nft_rbtree_gc_elem_remove(net, set, priv, rbe, genbit);
 	gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
 	if (WARN_ON_ONCE(!gc))
 		return ERR_PTR(-ENOMEM);
@@ -291,8 +297,9 @@ static bool nft_rbtree_update_first(const struct nft_set *set,
 				    struct rb_node *first)
 {
 	struct nft_rbtree_elem *first_elem;
+	u8 genbit = 0;
 
-	first_elem = rb_entry(first, struct nft_rbtree_elem, node);
+	first_elem = rb_entry(first, struct nft_rbtree_elem, node[genbit]);
 	/* this element is closest to where the new element is to be inserted:
 	 * update the first element for the node list path.
 	 */
@@ -312,6 +319,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
 	u64 tstamp = nft_net_tstamp(net);
+	u8 genbit = 0;
 	int d;
 
 	/* Descend the tree to search for an existing element greater than the
@@ -319,10 +327,10 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 * first element to walk the ordered elements to find possible overlap.
 	 */
 	parent = NULL;
-	p = &priv->root.rb_node;
+	p = &priv->root[genbit].rb_node;
 	while (*p != NULL) {
 		parent = *p;
-		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node[genbit]);
 		d = nft_rbtree_cmp(set, rbe, new);
 
 		if (d < 0) {
@@ -330,7 +338,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		} else if (d > 0) {
 			if (!first ||
 			    nft_rbtree_update_first(set, rbe, first))
-				first = &rbe->node;
+				first = &rbe->node[genbit];
 
 			p = &parent->rb_right;
 		} else {
@@ -342,7 +350,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	}
 
 	if (!first)
-		first = rb_first(&priv->root);
+		first = rb_first(&priv->root[genbit]);
 
 	/* Detect overlap by going through the list of valid tree nodes.
 	 * Values stored in the tree are in reversed order, starting from
@@ -351,7 +359,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	for (node = first; node != NULL; node = next) {
 		next = rb_next(node);
 
-		rbe = rb_entry(node, struct nft_rbtree_elem, node);
+		rbe = rb_entry(node, struct nft_rbtree_elem, node[genbit]);
 
 		if (!nft_set_elem_active(&rbe->ext, genmask))
 			continue;
@@ -460,10 +468,10 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 	/* Accepted element: pick insertion point depending on key value */
 	parent = NULL;
-	p = &priv->root.rb_node;
+	p = &priv->root[genbit].rb_node;
 	while (*p != NULL) {
 		parent = *p;
-		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node[genbit]);
 		d = nft_rbtree_cmp(set, rbe, new);
 
 		if (d < 0)
@@ -476,11 +484,15 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			p = &parent->rb_right;
 	}
 
-	rb_link_node_rcu(&new->node, parent, p);
-	rb_insert_color(&new->node, &priv->root);
+	rb_link_node_rcu(&new->node[genbit], parent, p);
+	rb_insert_color(&new->node[genbit], &priv->root[genbit]);
 	return 0;
 }
 
+static void nft_rbtree_maybe_clone(const struct net *net, const struct nft_set *set)
+{
+}
+
 static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			     const struct nft_set_elem *elem,
 			     struct nft_elem_priv **elem_priv)
@@ -489,6 +501,8 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	struct nft_rbtree *priv = nft_set_priv(set);
 	int err;
 
+	nft_rbtree_maybe_clone(net, set);
+
 	do {
 		if (fatal_signal_pending(current))
 			return -EINTR;
@@ -507,9 +521,11 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 static void nft_rbtree_erase(struct nft_rbtree *priv, struct nft_rbtree_elem *rbe)
 {
+	u8 genbit = 0;
+
 	write_lock_bh(&priv->lock);
 	write_seqcount_begin(&priv->count);
-	rb_erase(&rbe->node, &priv->root);
+	rb_erase(&rbe->node[genbit], &priv->root[genbit]);
 	write_seqcount_end(&priv->count);
 	write_unlock_bh(&priv->lock);
 }
@@ -548,13 +564,16 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 {
 	struct nft_rbtree_elem *rbe, *this = nft_elem_priv_cast(elem->priv);
 	const struct nft_rbtree *priv = nft_set_priv(set);
-	const struct rb_node *parent = priv->root.rb_node;
 	u8 genmask = nft_genmask_next(net);
 	u64 tstamp = nft_net_tstamp(net);
+	const struct rb_node *parent;
 	int d;
 
+	nft_rbtree_maybe_clone(net, set);
+
+	parent = priv->root[0].rb_node;
 	while (parent != NULL) {
-		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node[0]);
 
 		d = memcmp(nft_set_ext_key(&rbe->ext), &elem->key.val,
 					   set->klen);
@@ -586,14 +605,15 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 
 static void nft_rbtree_do_walk(const struct nft_ctx *ctx,
 			       struct nft_set *set,
-			       struct nft_set_iter *iter)
+			       struct nft_set_iter *iter,
+			       u8 genbit)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *node;
 
-	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
-		rbe = rb_entry(node, struct nft_rbtree_elem, node);
+	for (node = rb_first(&priv->root[genbit]); node; node = rb_next(node)) {
+		rbe = rb_entry(node, struct nft_rbtree_elem, node[genbit]);
 
 		if (iter->count < iter->skip)
 			goto cont;
@@ -611,15 +631,18 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 			    struct nft_set_iter *iter)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
+	struct net *net = read_pnet(&set->net);
 
 	switch (iter->type) {
 	case NFT_ITER_UPDATE:
 		lockdep_assert_held(&nft_pernet(ctx->net)->commit_mutex);
-		nft_rbtree_do_walk(ctx, set, iter);
+
+		nft_rbtree_maybe_clone(net, set);
+		nft_rbtree_do_walk(ctx, set, iter, 0);
 		break;
 	case NFT_ITER_READ:
 		read_lock_bh(&priv->lock);
-		nft_rbtree_do_walk(ctx, set, iter);
+		nft_rbtree_do_walk(ctx, set, iter, 0);
 		read_unlock_bh(&priv->lock);
 		break;
 	default:
@@ -645,6 +668,7 @@ static void nft_rbtree_gc(struct nft_set *set)
 	u64 tstamp = nft_net_tstamp(net);
 	struct rb_node *node, *next;
 	struct nft_trans_gc *gc;
+	u8 genbit = 0;
 
 	set  = nft_set_container_of(priv);
 	net  = read_pnet(&set->net);
@@ -653,10 +677,10 @@ static void nft_rbtree_gc(struct nft_set *set)
 	if (!gc)
 		return;
 
-	for (node = rb_first(&priv->root); node ; node = next) {
+	for (node = rb_first(&priv->root[genbit]); node ; node = next) {
 		next = rb_next(node);
 
-		rbe = rb_entry(node, struct nft_rbtree_elem, node);
+		rbe = rb_entry(node, struct nft_rbtree_elem, node[genbit]);
 
 		/* elements are reversed in the rbtree for historical reasons,
 		 * from highest to lowest value, that is why end element is
@@ -715,7 +739,8 @@ static int nft_rbtree_init(const struct nft_set *set,
 
 	rwlock_init(&priv->lock);
 	seqcount_rwlock_init(&priv->count, &priv->lock);
-	priv->root = RB_ROOT;
+	priv->root[0] = RB_ROOT;
+	priv->root[1] = RB_ROOT;
 
 	return 0;
 }
@@ -726,10 +751,11 @@ static void nft_rbtree_destroy(const struct nft_ctx *ctx,
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *node;
+	u8 genbit = 0;
 
-	while ((node = priv->root.rb_node) != NULL) {
-		rb_erase(node, &priv->root);
-		rbe = rb_entry(node, struct nft_rbtree_elem, node);
+	while ((node = priv->root[genbit].rb_node) != NULL) {
+		rb_erase(node, &priv->root[genbit]);
+		rbe = rb_entry(node, struct nft_rbtree_elem, node[genbit]);
 		nf_tables_set_elem_destroy(ctx, set, &rbe->priv);
 	}
 }
@@ -790,12 +816,13 @@ static u32 nft_rbtree_adjust_maxsize(const struct nft_set *set)
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *node;
 	const void *key;
+	u8 genbit = 0;
 
-	node = rb_last(&priv->root);
+	node = rb_last(&priv->root[genbit]);
 	if (!node)
 		return 0;
 
-	rbe = rb_entry(node, struct nft_rbtree_elem, node);
+	rbe = rb_entry(node, struct nft_rbtree_elem, node[genbit]);
 	if (!nft_rbtree_interval_end(rbe))
 		return 0;
 
-- 
2.51.0

