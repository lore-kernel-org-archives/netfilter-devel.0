Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B67F34DB4F
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 17:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769707741; cv=none; b=r6mfCtfPH65veI53RH9WD/Hajl4IjInYJFplDrPOqM6gtcvjvYQZ2qQVfKZQzkpNbKACPpqrxn1NJA5ccsHU2UTFR2VCHYTQ5IS0YItjfWyr+NWQvun3wVJjUWtdO3ltDDjxCiP2Aq9p1Xa0fSp5JQiDK/BFgvuvApOdGUuvxU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769707741; c=relaxed/simple;
	bh=bnoC0sLTLrN8SyKI2m+zH9U34MqrsCIVXPc4IXQCqRI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SxUfDUR5Xhy+EEoZ5WOTH4sZGxroQuWXvGjs9mG193v20/yiCR4qa9dpGZh7Gk7VeNhp4PBu6tQAEmWXNoQq1CcD5qblmBUGW+5aQnbY9ftqEdplf1KMqYeCV6enucdqz4dp4IMokz0n0ZnYH3q44Dlq3dzA8q3EGRThWe8dhTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0E97860516; Thu, 29 Jan 2026 18:28:56 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	syzbot+d417922a3e7935517ef6@syzkaller.appspotmail.com
Subject: [PATCH nf-next] netfilter: nft_set_rbtree: don't gc elements on insert
Date: Thu, 29 Jan 2026 18:28:39 +0100
Message-ID: <20260129172842.6310-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During insertion we can queue up expired elements for garbage
collection.

In case of later abort, the commit hook will never be called.
Packet path and 'get' requests will find free'd elements in the
binary search blob:

 nft_set_ext_key include/net/netfilter/nf_tables.h:800 [inline]
 nft_array_get_cmp+0x1f6/0x2a0 net/netfilter/nft_set_rbtree.c:133
 __inline_bsearch include/linux/bsearch.h:15 [inline]
 bsearch+0x50/0xc0 lib/bsearch.c:33
 nft_rbtree_get+0x16b/0x400 net/netfilter/nft_set_rbtree.c:169
 nft_setelem_get net/netfilter/nf_tables_api.c:6495 [inline]
 nft_get_set_elem+0x420/0xaa0 net/netfilter/nf_tables_api.c:6543
 nf_tables_getsetelem+0x448/0x5e0 net/netfilter/nf_tables_api.c:6632
 nfnetlink_rcv_msg+0x8ae/0x12c0 net/netfilter/nfnetlink.c:290

Also, when we insert an element that triggers -EEXIST, and that insertion
happens to also zap a timed-out entry, we end up with same issue:
Neither commit nor abort hook is called.

Fix this by removing gc api usage during insertion.

The blamed commit also removes concurrency of the rbtree with the
packet path, so we can now safely rb_erase() the element and move
it to a new expired list that can be reaped in the commit hook
before building the next blob iteration.

This also avoids the need to rebuild the blob in the abort path:
Expired elements seen during insertion attempts are kept around
until a transaction passes.

Reported-by: syzbot+d417922a3e7935517ef6@syzkaller.appspotmail.com
Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 71 ++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 7598c368c4e5..097a0ae4b0d5 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -34,11 +34,15 @@ struct nft_rbtree {
 	struct nft_array __rcu	*array;
 	struct nft_array	*array_next;
 	unsigned long		last_gc;
+	struct list_head	expired;
 };
 
 struct nft_rbtree_elem {
 	struct nft_elem_priv	priv;
-	struct rb_node		node;
+	union {
+		struct rb_node	node;
+		struct list_head list;
+	};
 	struct nft_set_ext	ext;
 };
 
@@ -179,13 +183,16 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	return &rbe->priv;
 }
 
-static void nft_rbtree_gc_elem_remove(struct net *net, struct nft_set *set,
-				      struct nft_rbtree *priv,
-				      struct nft_rbtree_elem *rbe)
+static void nft_rbtree_gc_elem_move(struct net *net, struct nft_set *set,
+				    struct nft_rbtree *priv,
+				    struct nft_rbtree_elem *rbe)
 {
 	lockdep_assert_held_write(&priv->lock);
 	nft_setelem_data_deactivate(net, set, &rbe->priv);
 	rb_erase(&rbe->node, &priv->root);
+
+	/* collected later on in commit callback */
+	list_add(&rbe->list, &priv->expired);
 }
 
 static const struct nft_rbtree_elem *
@@ -196,11 +203,6 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 	struct rb_node *prev = rb_prev(&rbe->node);
 	struct net *net = read_pnet(&set->net);
 	struct nft_rbtree_elem *rbe_prev;
-	struct nft_trans_gc *gc;
-
-	gc = nft_trans_gc_alloc(set, 0, GFP_ATOMIC);
-	if (!gc)
-		return ERR_PTR(-ENOMEM);
 
 	/* search for end interval coming before this element.
 	 * end intervals don't carry a timeout extension, they
@@ -218,28 +220,10 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 	rbe_prev = NULL;
 	if (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		nft_rbtree_gc_elem_remove(net, set, priv, rbe_prev);
-
-		/* There is always room in this trans gc for this element,
-		 * memory allocation never actually happens, hence, the warning
-		 * splat in such case. No need to set NFT_SET_ELEM_DEAD_BIT,
-		 * this is synchronous gc which never fails.
-		 */
-		gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
-		if (WARN_ON_ONCE(!gc))
-			return ERR_PTR(-ENOMEM);
-
-		nft_trans_gc_elem_add(gc, rbe_prev);
+		nft_rbtree_gc_elem_move(net, set, priv, rbe_prev);
 	}
 
-	nft_rbtree_gc_elem_remove(net, set, priv, rbe);
-	gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
-	if (WARN_ON_ONCE(!gc))
-		return ERR_PTR(-ENOMEM);
-
-	nft_trans_gc_elem_add(gc, rbe);
-
-	nft_trans_gc_queue_sync_done(gc);
+	nft_rbtree_gc_elem_move(net, set, priv, rbe);
 
 	return rbe_prev;
 }
@@ -699,6 +683,17 @@ static void nft_rbtree_gc(struct nft_set *set)
 	if (!gc)
 		return;
 
+	list_for_each_entry_safe(rbe, rbe_end, &priv->expired, list) {
+		list_del(&rbe->list);
+		nft_trans_gc_elem_add(gc, rbe);
+
+		gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
+		if (!gc)
+			goto try_later;
+	}
+
+	rbe_end = NULL;
+
 	for (node = rb_first(&priv->root); node ; node = next) {
 		next = rb_next(node);
 
@@ -761,6 +756,7 @@ static int nft_rbtree_init(const struct nft_set *set,
 
 	rwlock_init(&priv->lock);
 	priv->root = RB_ROOT;
+	INIT_LIST_HEAD(&priv->expired);
 
 	priv->array = NULL;
 	priv->array_next = NULL;
@@ -778,10 +774,15 @@ static void nft_rbtree_destroy(const struct nft_ctx *ctx,
 			       const struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
-	struct nft_rbtree_elem *rbe;
+	struct nft_rbtree_elem *rbe, *next;
 	struct nft_array *array;
 	struct rb_node *node;
 
+	list_for_each_entry_safe(rbe, next, &priv->expired, list) {
+		list_del(&rbe->list);
+		nf_tables_set_elem_destroy(ctx, set, &rbe->priv);
+	}
+
 	while ((node = priv->root.rb_node) != NULL) {
 		rb_erase(node, &priv->root);
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
@@ -828,13 +829,14 @@ static void nft_rbtree_commit(struct nft_set *set)
 	u32 num_intervals = 0;
 	struct rb_node *node;
 
-	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
-		nft_rbtree_gc(set);
-
 	/* No changes, skip, eg. elements updates only. */
 	if (!priv->array_next)
 		return;
 
+	/* Can GC when we rebuild the binary search blob. */
+	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
+		nft_rbtree_gc(set);
+
 	/* Reverse walk to create an array from smaller to largest interval. */
 	node = rb_last(&priv->root);
 	if (node)
@@ -881,7 +883,8 @@ static void nft_rbtree_commit(struct nft_set *set)
 		num_intervals++;
 err_out:
 	priv->array_next->num_intervals = num_intervals;
-	old = rcu_replace_pointer(priv->array, priv->array_next, true);
+	old = rcu_replace_pointer(priv->array, priv->array_next,
+				  lockdep_is_held(&nft_pernet(read_pnet(&set->net))->commit_mutex));
 	priv->array_next = NULL;
 	if (old)
 		call_rcu(&old->rcu_head, nft_array_free_rcu);
-- 
2.52.0

