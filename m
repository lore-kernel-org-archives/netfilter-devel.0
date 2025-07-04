Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88142D94A6
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 12:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751632234; cv=none; b=C+qqY2cE7PQ/u9RVYaNTHR2/wnNJdfLtaqM1QoMiK4KWm95xpG1EPKxTPgjMlh7N716RRLmfTnFEJ7GWSyJAXKI5+2MLhs1qFI9hpOPn9oHRmONWpsiYRoLbmHRdpDoOTVQHkOJ1GXn7lzLUeGqSx0fO34KbPSoFPw2NOKeypBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751632234; c=relaxed/simple;
	bh=JKQNpuO8t8UZn0crhlw0T9t+JzyocFifxQnklcrQrFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRK39pPMquw0qdqF7Hnju2DDk2WowpdZci3QSXrue1M4Iol2oal5jWWk2lbOSNnfn7GNAvXHaLMHai6MM+mQgHSlLFqyDsCozzV9Ix2U48pA6we58vAnDsiQEGAv0+nDO9TecF8wEkHgq4WTQJ6gUnYOCB6ukTvRad42ugTYdQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D8F0761830; Fri,  4 Jul 2025 14:30:29 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Sven Auhagen <Sven.Auhagen@belden.com>
Subject: [nf-next 1/2] netfilter: nf_tables: allow iter callbacks to sleep
Date: Fri,  4 Jul 2025 14:30:17 +0200
Message-ID: <20250704123024.59099-2-fw@strlen.de>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250704123024.59099-1-fw@strlen.de>
References: <20250704123024.59099-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Quoting Sven Auhagen:
  we do see on occasions that we get the following error message, more so on
  x86 systems than on arm64:

  Error: Could not process rule: Cannot allocate memory delete table inet filter

  It is not a consistent error and does not happen all the time.
  We are on Kernel 6.6.80, seems to me like we have something along the lines
  of the nf_tables: allow clone callbacks to sleep problem using GFP_ATOMIC.

As hinted at by Sven, this is because of GFP_ATOMIC allocations during set
flush.

When set is flushed, all elements are deactivated. This triggers a set walk
and each element gets added to the transaction list.

The rbtree and rhashtable sets don't allow the iter callback to sleep:
rbtree walk acquires read side of an rwlock with bh disabled, rhashtable
walk happens with rcu read lock held.

rbtree is simple:
When the walk context is ITER_READ, no change is needed (the iter
callback must not deactivate elements; we're not in a transaction).

When the iter type is ITER_UPDATE, the rwlock isn't needed because the
caller holds the transaction mutex, this prevents any and all changes to
the ruleset, including add/remove of set elements.
Unlike rhashtable rbtree doesn't support insertions/removals from datapath
and timeout is handled only from control plane.

rhashtable is more complex.  Just like rbtree no change is needed for
ITER_READ.

For ITER_UPDATE, we hold transaction mutex which prevents elements from
getting free'd, even outside of rcu read lock section.

Build a temporary list of all elements while doing the rcu iteration
and then call the iterator in a second pass.

The disadvantage is the need to iterate twice, but it allows the iter
callback to use GFP_KERNEL allocations in a followup patch.

The new list based logic makes it necessary to catch recursive calls to
the same set earlier.

Such walk -> iter -> walk recursion for the same set can happen during
ruleset validation in case userspace gave us a bogus (cyclic) ruleset
where verdict map m jumps to chain that sooner or later also calls
"vmap @m".

Before the new ->in_update_walk test, the ruleset is rejected because the
infinite recursion makes ctx->level hit the allowed maximum.

But with the new logic added here, elements would get skipped as
nft_rhash_walk_update sees elements that are on the walk_list of
earlier, nested call.

Use a per-set "in_update_walk" flag and jut return -EMINK immediately
to avoid this.

Next patch converts the problematic GFP_ATOMIC allocations.

Reported-by: Sven Auhagen <Sven.Auhagen@belden.com>
Closes: https://lore.kernel.org/netfilter-devel/aGO89KaXVNuToRJg@strlen.de/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |   2 +
 net/netfilter/nft_set_hash.c      | 102 +++++++++++++++++++++++++++++-
 net/netfilter/nft_set_rbtree.c    |  35 +++++++---
 3 files changed, 128 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e4d8e451e935..0cdaac6cc006 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -562,6 +562,7 @@ struct nft_set_elem_expr {
  * 	@size: maximum set size
  *	@field_len: length of each field in concatenation, bytes
  *	@field_count: number of concatenated fields in element
+ *	@in_update_walk: true during ->walk() in transaction phase
  *	@use: number of rules references to this set
  * 	@nelems: number of elements
  * 	@ndeact: number of deactivated elements queued for removal
@@ -596,6 +597,7 @@ struct nft_set {
 	u32				size;
 	u8				field_len[NFT_REG32_COUNT];
 	u8				field_count;
+	bool				in_update_walk;
 	u32				use;
 	atomic_t			nelems;
 	u32				ndeact;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index abb0c8ec6371..3d235f4e4f60 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -30,6 +30,7 @@ struct nft_rhash {
 struct nft_rhash_elem {
 	struct nft_elem_priv		priv;
 	struct rhash_head		node;
+	struct llist_node		walk_node;
 	u32				wq_gc_seq;
 	struct nft_set_ext		ext;
 };
@@ -148,6 +149,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 		goto err1;
 
 	he = nft_elem_priv_cast(elem_priv);
+	init_llist_node(&he->walk_node);
 	prev = rhashtable_lookup_get_insert_key(&priv->ht, &arg, &he->node,
 						nft_rhash_params);
 	if (IS_ERR(prev))
@@ -185,6 +187,7 @@ static int nft_rhash_insert(const struct net *net, const struct nft_set *set,
 	};
 	struct nft_rhash_elem *prev;
 
+	init_llist_node(&he->walk_node);
 	prev = rhashtable_lookup_get_insert_key(&priv->ht, &arg, &he->node,
 						nft_rhash_params);
 	if (IS_ERR(prev))
@@ -266,12 +269,12 @@ static bool nft_rhash_delete(const struct nft_set *set,
 	return true;
 }
 
-static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
-			   struct nft_set_iter *iter)
+static void nft_rhash_walk_ro(const struct nft_ctx *ctx, struct nft_set *set,
+			      struct nft_set_iter *iter)
 {
 	struct nft_rhash *priv = nft_set_priv(set);
-	struct nft_rhash_elem *he;
 	struct rhashtable_iter hti;
+	struct nft_rhash_elem *he;
 
 	rhashtable_walk_enter(&priv->ht, &hti);
 	rhashtable_walk_start(&hti);
@@ -300,6 +303,99 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	rhashtable_walk_exit(&hti);
 }
 
+static void nft_rhash_walk_update(const struct nft_ctx *ctx, struct nft_set *set,
+				  struct nft_set_iter *iter)
+{
+	struct nft_rhash *priv = nft_set_priv(set);
+	struct nft_rhash_elem *he, *tmp;
+	struct llist_node *first_node;
+	struct rhashtable_iter hti;
+	LLIST_HEAD(walk_list);
+
+	lockdep_assert_held(&nft_pernet(read_pnet(&set->net))->commit_mutex);
+
+	if (set->in_update_walk) {
+		/* This can happen with bogus rulesets during ruleset validation
+		 * when a verdict map causes a jump back to the same verdict map.
+		 *
+		 * Without this extra check the walk_next loop below will see
+		 * elems on the calling functions walk_list and skip (not validate)
+		 * them.
+		 */
+		iter->err = -EMLINK;
+		return;
+	}
+
+	/* walk happens under RCU.
+	 *
+	 * We create a snapshot list so ->iter callback can sleep.
+	 * commit_mutex is held, elements can ...
+	 * .. be added in parallel from dataplane (dynset)
+	 * .. be marked as dead in parallel from dataplane (dynset).
+	 * .. be queued for removal in parallel (gc timeout).
+	 * .. not be freed: transaction mutex is held.
+	 */
+	rhashtable_walk_enter(&priv->ht, &hti);
+	rhashtable_walk_start(&hti);
+
+	while ((he = rhashtable_walk_next(&hti))) {
+		if (IS_ERR(he)) {
+			if (PTR_ERR(he) != -EAGAIN) {
+				iter->err = PTR_ERR(he);
+				break;
+			}
+
+			continue;
+		}
+
+		/* rhashtable resized during walk, skip */
+		if (llist_on_list(&he->walk_node))
+			continue;
+
+		if (iter->count < iter->skip) {
+			iter->count++;
+			continue;
+		}
+
+		llist_add(&he->walk_node, &walk_list);
+	}
+	rhashtable_walk_stop(&hti);
+	rhashtable_walk_exit(&hti);
+
+	first_node = __llist_del_all(&walk_list);
+	set->in_update_walk = true;
+	llist_for_each_entry_safe(he, tmp, first_node, walk_node) {
+		if (iter->err == 0) {
+			iter->err = iter->fn(ctx, set, iter, &he->priv);
+			if (iter->err == 0)
+				iter->count++;
+		}
+
+		/* all entries must be cleared again, else next ->walk iteration
+		 * will skip entries.
+		 */
+		init_llist_node(&he->walk_node);
+	}
+	set->in_update_walk = false;
+}
+
+static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
+			   struct nft_set_iter *iter)
+{
+	switch (iter->type) {
+	case NFT_ITER_UPDATE:
+		nft_rhash_walk_update(ctx, set, iter);
+		break;
+	case NFT_ITER_READ:
+		nft_rhash_walk_ro(ctx, set, iter);
+		break;
+	default:
+		iter->err = -EINVAL;
+		WARN_ON_ONCE(1);
+		break;
+	}
+}
+
 static bool nft_rhash_expr_needs_gc_run(const struct nft_set *set,
 					struct nft_set_ext *ext)
 {
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 2e8ef16ff191..5c55840d4ebd 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -586,15 +586,14 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 	return NULL;
 }
 
-static void nft_rbtree_walk(const struct nft_ctx *ctx,
-			    struct nft_set *set,
-			    struct nft_set_iter *iter)
+static void nft_rbtree_do_walk(const struct nft_ctx *ctx,
+			       struct nft_set *set,
+			       struct nft_set_iter *iter)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *node;
 
-	read_lock_bh(&priv->lock);
 	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 
@@ -602,14 +601,34 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 			goto cont;
 
 		iter->err = iter->fn(ctx, set, iter, &rbe->priv);
-		if (iter->err < 0) {
-			read_unlock_bh(&priv->lock);
+		if (iter->err < 0)
 			return;
-		}
 cont:
 		iter->count++;
 	}
-	read_unlock_bh(&priv->lock);
+}
+
+static void nft_rbtree_walk(const struct nft_ctx *ctx,
+			    struct nft_set *set,
+			    struct nft_set_iter *iter)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+
+	switch (iter->type) {
+	case NFT_ITER_UPDATE:
+		lockdep_assert_held(&nft_pernet(read_pnet(&set->net))->commit_mutex);
+		nft_rbtree_do_walk(ctx, set, iter);
+		break;
+	case NFT_ITER_READ:
+		read_lock_bh(&priv->lock);
+		nft_rbtree_do_walk(ctx, set, iter);
+		read_unlock_bh(&priv->lock);
+		break;
+	default:
+		iter->err = -EINVAL;
+		WARN_ON_ONCE(1);
+		break;
+	}
 }
 
 static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
-- 
2.50.0

