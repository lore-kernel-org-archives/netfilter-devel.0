Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17C72BE02C
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Dec 2025 09:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764752775; cv=none; b=m4CSjNQykWledzzxR8Q/TomHp0n2tVJKiCfrekIaKk4uwnG5num3/ep/rwMyLJS/xEzz8GIjate6SVunBWBY4xbUMncBT5xMHCw7ehR7/3SOr1jJJInboIVmWEIkp4Wk1cEV/lxj96Rdv/1uHRQxoz/PP+NUcaE0xbkblndweNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764752775; c=relaxed/simple;
	bh=/ylIZkbTLVVmeCvtLd+xNoS0MfBKPM4BqlhcPvpZVq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZiZQ83xuCs2onQfXI0lNQ/vs6iwgO1YqP41jjHpLZXtjnjYDiTWIugctA7H2lViNKUbFMHki/JLUXE010HWjMX3K26T2ob93nfuG2RTrRrUUz8zSm6eUAGRtyUs+fdZ8HHI/aLVumxNSif34jhgTXfcF52QxFK3twxx7v16BX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1E45460308; Wed, 03 Dec 2025 10:06:12 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v2 3/3] netfilter: nft_set_rbtree: do not modifiy live tree
Date: Wed,  3 Dec 2025 10:03:15 +0100
Message-ID: <20251203090320.26905-4-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251203090320.26905-1-fw@strlen.de>
References: <20251203090320.26905-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The earlier attempt to resolve the false negative lookups is not
sufficient for the rbtree set.  Given existing tree with a matching range
interval a-b, following race exists:

1. control plane marks a-b for removal.
2. control plane adds a-c as new range.
3. control plane enters commit phase and increments the gencursor.
4. packet path starts a lookup for key that matches range a-b and a-c
5. control plane erases a-b (and other to-be-freed elements).

If step 4 has picked up the new gencursor, it may find a-b but ignores
it as its now flagged as inactive. Range a-c might not be found until
after step 5 in case its hidden in the wrong subtree.

Avoid this by using two trees, one for matching and one for control plane
updates.

Above sequence changes as follows:

In the new step 6 (post removal), tree genbits are swapped so the updated
(removed-and-about-to-be-freed elements are not reachable) tree becomes the
new live tree.

In step 4, packet path can now elide generation check for elements, because
newly-added-but-not-yet-valid entries are not reachable from the live tree,
so it will either find range a-b (if it picked up the old tree) or a-c (if
it picked up the new one).

In case it picked up the old tree and the a-b range was already removed by
the ongoing transaction, no match is found.  But in that case the lookup
also observes seqcount mismatch and relookup is done in new tree.

GC happens during insertion and right before commit.  In both cases we
operate on the copied tree.  However, we must also erase the entry from the
live version since the element will be freed after next grace period, which
might happen before the live/copy swap happens.

Note that we could rework GC after this change:

GC could be done during clone step: This avoids need for expire check at
insert time which in turn gets rid of the -EAGAIN retry loop in
nft_rbtree_insert.

Fixes: a60f7bf4a152 ("netfilter: nft_set_rbtree: continue traversal if element is inactive")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes: replace rcu_assign_pointer with WRITE_ONCE() to avoid a sparse
 warning.  This is fine because the new value is NULL.

 net/netfilter/nft_set_rbtree.c | 168 ++++++++++++++++++++++++++-------
 1 file changed, 132 insertions(+), 36 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index d051d8075070..59c968c14e9a 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -17,6 +17,8 @@
 
 struct nft_rbtree {
 	struct rb_root		root[2];
+	u8			genbit;
+	bool			cloned;
 	rwlock_t		lock;
 	seqcount_rwlock_t	count;
 	unsigned long		last_gc;
@@ -28,9 +30,14 @@ struct nft_rbtree_elem {
 	struct nft_set_ext	ext;
 };
 
+static inline u8 nft_rbtree_genbit_live(const struct nft_rbtree *priv)
+{
+	return READ_ONCE(priv->genbit);
+}
+
 static inline u8 nft_rbtree_genbit_copy(const struct nft_rbtree *priv)
 {
-	return 0;
+	return !nft_rbtree_genbit_live(priv);
 }
 
 static bool nft_rbtree_interval_end(const struct nft_rbtree_elem *rbe)
@@ -63,11 +70,11 @@ __nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	const struct nft_rbtree_elem *rbe, *interval = NULL;
-	u8 genmask = nft_genmask_cur(net);
 	const struct rb_node *parent;
-	u8 genbit = 0;
+	u8 genbit;
 	int d;
 
+	genbit = nft_rbtree_genbit_live(priv);
 	parent = rcu_dereference_raw(priv->root[genbit].rb_node);
 	while (parent != NULL) {
 		if (read_seqcount_retry(&priv->count, seq))
@@ -83,17 +90,11 @@ __nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
 			    nft_rbtree_interval_end(rbe) &&
 			    nft_rbtree_interval_start(interval))
 				continue;
-			if (nft_set_elem_active(&rbe->ext, genmask) &&
-			    !nft_rbtree_elem_expired(rbe))
+			if (!nft_rbtree_elem_expired(rbe))
 				interval = rbe;
 		} else if (d > 0)
 			parent = rcu_dereference_raw(parent->rb_right);
 		else {
-			if (!nft_set_elem_active(&rbe->ext, genmask)) {
-				parent = rcu_dereference_raw(parent->rb_left);
-				continue;
-			}
-
 			if (nft_rbtree_elem_expired(rbe))
 				return NULL;
 
@@ -145,9 +146,10 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	struct nft_rbtree *priv = nft_set_priv(set);
 	const struct rb_node *parent;
 	const void *this;
-	u8 genbit = 0;
+	u8 genbit;
 	int d;
 
+	genbit = nft_rbtree_genbit_live(priv);
 	parent = rcu_dereference_raw(priv->root[genbit].rb_node);
 	while (parent != NULL) {
 		if (read_seqcount_retry(&priv->count, seq))
@@ -236,18 +238,18 @@ static void nft_rbtree_gc_elem_remove(struct net *net, struct nft_set *set,
 	lockdep_assert_held_write(&priv->lock);
 	nft_setelem_data_deactivate(net, set, &rbe->priv);
 	rb_erase(&rbe->node[genbit], &priv->root[genbit]);
+	rb_erase(&rbe->node[!genbit], &priv->root[!genbit]);
 }
 
 static const struct nft_rbtree_elem *
 nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
-		   struct nft_rbtree_elem *rbe)
+		   struct nft_rbtree_elem *rbe, u8 genbit)
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct net *net = read_pnet(&set->net);
 	struct nft_rbtree_elem *rbe_prev;
 	struct nft_trans_gc *gc;
 	struct rb_node *prev;
-	u8 genbit = 0;
 
 	prev = rb_prev(&rbe->node[genbit]);
 
@@ -299,10 +301,9 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 
 static bool nft_rbtree_update_first(const struct nft_set *set,
 				    struct nft_rbtree_elem *rbe,
-				    struct rb_node *first)
+				    struct rb_node *first, u8 genbit)
 {
 	struct nft_rbtree_elem *first_elem;
-	u8 genbit = 0;
 
 	first_elem = rb_entry(first, struct nft_rbtree_elem, node[genbit]);
 	/* this element is closest to where the new element is to be inserted:
@@ -353,10 +354,10 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
+	u8 genbit = nft_rbtree_genbit_copy(priv);
 	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
 	u64 tstamp = nft_net_tstamp(net);
-	u8 genbit = 0;
 	int d;
 
 	/* Descend the tree to search for an existing element greater than the
@@ -374,7 +375,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			p = &parent->rb_left;
 		} else if (d > 0) {
 			if (!first ||
-			    nft_rbtree_update_first(set, rbe, first))
+			    nft_rbtree_update_first(set, rbe, first, genbit))
 				first = &rbe->node[genbit];
 
 			p = &parent->rb_right;
@@ -408,7 +409,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
 			const struct nft_rbtree_elem *removed_end;
 
-			removed_end = nft_rbtree_gc_elem(set, priv, rbe);
+			removed_end = nft_rbtree_gc_elem(set, priv, rbe, genbit);
 			if (IS_ERR(removed_end))
 				return PTR_ERR(removed_end);
 
@@ -510,6 +511,26 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 static void nft_rbtree_maybe_clone(const struct net *net, const struct nft_set *set)
 {
+	struct nft_rbtree *priv = nft_set_priv(set);
+	u8 genbit = nft_rbtree_genbit_live(priv);
+	struct nft_rbtree_elem *rbe;
+	struct rb_node *node, *next;
+
+	lockdep_assert_held_once(&nft_pernet(net)->commit_mutex);
+
+	if (priv->cloned)
+		return;
+
+	for (node = rb_first(&priv->root[genbit]); node ; node = next) {
+		next = rb_next(node);
+		rbe = rb_entry(node, struct nft_rbtree_elem, node[genbit]);
+
+		/* No need to acquire a lock, this is the future tree, not
+		 * exposed to packetpath.
+		 */
+		__nft_rbtree_insert_do(set, rbe);
+	}
+	priv->cloned = true;
 }
 
 static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
@@ -538,23 +559,15 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	return err;
 }
 
-static void nft_rbtree_erase(struct nft_rbtree *priv, struct nft_rbtree_elem *rbe)
-{
-	write_lock_bh(&priv->lock);
-	write_seqcount_begin(&priv->count);
-	rb_erase(&rbe->node[0], &priv->root[0]);
-	write_seqcount_end(&priv->count);
-	write_unlock_bh(&priv->lock);
-}
-
 static void nft_rbtree_remove(const struct net *net,
 			      const struct nft_set *set,
 			      struct nft_elem_priv *elem_priv)
 {
 	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem_priv);
 	struct nft_rbtree *priv = nft_set_priv(set);
+	u8 genbit = nft_rbtree_genbit_copy(priv);
 
-	nft_rbtree_erase(priv, rbe);
+	rb_erase(&rbe->node[genbit], &priv->root[genbit]);
 }
 
 static void nft_rbtree_activate(const struct net *net,
@@ -581,6 +594,7 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 {
 	struct nft_rbtree_elem *rbe, *this = nft_elem_priv_cast(elem->priv);
 	const struct nft_rbtree *priv = nft_set_priv(set);
+	u8 genbit = nft_rbtree_genbit_copy(priv);
 	u8 genmask = nft_genmask_next(net);
 	u64 tstamp = nft_net_tstamp(net);
 	const struct rb_node *parent;
@@ -588,9 +602,9 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 
 	nft_rbtree_maybe_clone(net, set);
 
-	parent = priv->root[0].rb_node;
+	parent = priv->root[genbit].rb_node;
 	while (parent != NULL) {
-		rbe = rb_entry(parent, struct nft_rbtree_elem, node[0]);
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node[genbit]);
 
 		d = memcmp(nft_set_ext_key(&rbe->ext), &elem->key.val,
 					   set->klen);
@@ -655,11 +669,13 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 		lockdep_assert_held(&nft_pernet(ctx->net)->commit_mutex);
 
 		nft_rbtree_maybe_clone(net, set);
-		nft_rbtree_do_walk(ctx, set, iter, 0);
+		nft_rbtree_do_walk(ctx, set, iter,
+				   nft_rbtree_genbit_copy(priv));
 		break;
 	case NFT_ITER_READ:
 		read_lock_bh(&priv->lock);
-		nft_rbtree_do_walk(ctx, set, iter, 0);
+		nft_rbtree_do_walk(ctx, set, iter,
+				   nft_rbtree_genbit_live(priv));
 		read_unlock_bh(&priv->lock);
 		break;
 	default:
@@ -673,8 +689,21 @@ static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
 				 struct nft_rbtree *priv,
 				 struct nft_rbtree_elem *rbe)
 {
+	u8 genbit = nft_rbtree_genbit_live(priv);
+
 	nft_setelem_data_deactivate(net, set, &rbe->priv);
-	nft_rbtree_erase(priv, rbe);
+
+	/* first remove from live copy */
+	write_lock_bh(&priv->lock);
+	write_seqcount_begin(&priv->count);
+	rb_erase(&rbe->node[genbit], &priv->root[genbit]);
+	write_seqcount_end(&priv->count);
+	write_unlock_bh(&priv->lock);
+
+	genbit = !genbit;
+
+	/* then from private copy */
+	rb_erase(&rbe->node[genbit], &priv->root[genbit]);
 }
 
 static void nft_rbtree_gc(struct nft_set *set)
@@ -685,7 +714,7 @@ static void nft_rbtree_gc(struct nft_set *set)
 	u64 tstamp = nft_net_tstamp(net);
 	struct rb_node *node, *next;
 	struct nft_trans_gc *gc;
-	u8 genbit = 0;
+	u8 genbit;
 
 	set  = nft_set_container_of(priv);
 	net  = read_pnet(&set->net);
@@ -694,6 +723,7 @@ static void nft_rbtree_gc(struct nft_set *set)
 	if (!gc)
 		return;
 
+	genbit = nft_rbtree_genbit_copy(priv);
 	for (node = rb_first(&priv->root[genbit]); node ; node = next) {
 		next = rb_next(node);
 
@@ -758,6 +788,8 @@ static int nft_rbtree_init(const struct nft_set *set,
 	seqcount_rwlock_init(&priv->count, &priv->lock);
 	priv->root[0] = RB_ROOT;
 	priv->root[1] = RB_ROOT;
+	priv->cloned = false;
+	priv->genbit = 0;
 
 	return 0;
 }
@@ -768,7 +800,21 @@ static void nft_rbtree_destroy(const struct nft_ctx *ctx,
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *node;
-	u8 genbit = 0;
+	u8 genbit;
+
+	if (priv->cloned) {
+		genbit = nft_rbtree_genbit_copy(priv);
+		priv->cloned = false;
+
+		/* live version is outdated:
+		 * Still contains elements that have been
+		 * removed already and are queued for freeing.
+		 * Doesn't contain new elements.
+		 */
+	} else {
+		/* no changes?  Tear down live version. */
+		genbit = nft_rbtree_genbit_live(priv);
+	}
 
 	while ((node = priv->root[genbit].rb_node) != NULL) {
 		rb_erase(node, &priv->root[genbit]);
@@ -795,12 +841,56 @@ static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
+static void nft_rbtree_abort(const struct nft_set *set)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+
+	if (priv->cloned) {
+		u8 genbit = nft_rbtree_genbit_copy(priv);
+
+		priv->root[genbit] = RB_ROOT;
+		priv->cloned = false;
+	}
+}
+
 static void nft_rbtree_commit(struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
+	u8 genbit;
 
 	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
 		nft_rbtree_gc(set);
+
+	priv->cloned = false;
+
+	write_lock_bh(&priv->lock);
+	write_seqcount_begin(&priv->count);
+
+	genbit = nft_rbtree_genbit_live(priv);
+	priv->genbit = !genbit;
+
+	/* genbit is now the old generation. priv->cloned as been set to
+	 * false.  Future call to nft_rbtree_maybe_clone() will create a
+	 * new on-demand copy of the live version.
+	 *
+	 * Elements new in the committed transaction and all unchanged
+	 * elements are now visible to other CPUs.
+	 *
+	 * Removed elements are now only reachable via their
+	 * DELSETELEM transaction entry, they will be free'd after
+	 * rcu grace period.
+	 *
+	 * A cpu still doing a lookup in the old (genbit) tree will
+	 * either find a match, or, if it did not find a result, observe
+	 * the altered sequence count.
+	 *
+	 * In the latter case, it will spin on priv->lock and then performs
+	 * a new lookup in the current tree.
+	 */
+	WRITE_ONCE(priv->root[genbit].rb_node, NULL);
+
+	write_seqcount_end(&priv->count);
+	write_unlock_bh(&priv->lock);
 }
 
 static void nft_rbtree_gc_init(const struct nft_set *set)
@@ -833,7 +923,12 @@ static u32 nft_rbtree_adjust_maxsize(const struct nft_set *set)
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *node;
 	const void *key;
-	u8 genbit = 0;
+	u8 genbit;
+
+	if (priv->cloned)
+		genbit = nft_rbtree_genbit_copy(priv);
+	else
+		genbit = nft_rbtree_genbit_live(priv);
 
 	node = rb_last(&priv->root[genbit]);
 	if (!node)
@@ -865,6 +960,7 @@ const struct nft_set_type nft_set_rbtree_type = {
 		.flush		= nft_rbtree_flush,
 		.activate	= nft_rbtree_activate,
 		.commit		= nft_rbtree_commit,
+		.abort		= nft_rbtree_abort,
 		.gc_init	= nft_rbtree_gc_init,
 		.lookup		= nft_rbtree_lookup,
 		.walk		= nft_rbtree_walk,
-- 
2.51.2

