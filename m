Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAFD38B7BF;
	Thu,  5 Feb 2026 11:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770289761; cv=none; b=FcNeDeiu1cudzfyJDjXdHImhH44c4neZZDJiIkfuEsP0NNTRhXCiYu4zVR/+gpHaASN/tT1EvCFyaxGlKnYJMOLZ5wuOy6aciZsXv02azxa9QnOONM0Jw13cmoK9W74e/vrLMzsUGDFwGn0zUcr+Uv0jXNjlPwoznNyrgBX+KfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770289761; c=relaxed/simple;
	bh=rRyaeW7BqrZciGDbY4cyzeP9p04bcgK9rQS56g1PanQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fb+CZ8FPBPQNGm5Fo0tBkm6nM6o5jSgvOcC+An0iSnDHQoWCIynmlBhDLeN4yCUO+CoypMMg+KV8wG1Fe9h1q9/Ee22Droc3ZEvJeJSVH2JVMSIwGyxQ4DLXgKyYNlYpMe3XqAXbLr8wEjhAS6cHArrHU4z2gqex7sYQ+VTf0jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3070660807; Thu, 05 Feb 2026 12:09:19 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 01/11] netfilter: nft_set_rbtree: don't gc elements on insert
Date: Thu,  5 Feb 2026 12:08:55 +0100
Message-ID: <20260205110905.26629-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260205110905.26629-1-fw@strlen.de>
References: <20260205110905.26629-1-fw@strlen.de>
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
Closes: https://syzkaller.appspot.com/bug?extid=d417922a3e7935517ef6
Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 136 ++++++++++++++++-----------------
 1 file changed, 68 insertions(+), 68 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 7598c368c4e5..0efaa8c3f31b 100644
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
@@ -675,29 +659,13 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 	}
 }
 
-static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
-				 struct nft_rbtree *priv,
-				 struct nft_rbtree_elem *rbe)
-{
-	nft_setelem_data_deactivate(net, set, &rbe->priv);
-	nft_rbtree_erase(priv, rbe);
-}
-
-static void nft_rbtree_gc(struct nft_set *set)
+static void nft_rbtree_gc_scan(struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe, *rbe_end = NULL;
 	struct net *net = read_pnet(&set->net);
 	u64 tstamp = nft_net_tstamp(net);
 	struct rb_node *node, *next;
-	struct nft_trans_gc *gc;
-
-	set  = nft_set_container_of(priv);
-	net  = read_pnet(&set->net);
-
-	gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
-	if (!gc)
-		return;
 
 	for (node = rb_first(&priv->root); node ; node = next) {
 		next = rb_next(node);
@@ -715,34 +683,46 @@ static void nft_rbtree_gc(struct nft_set *set)
 		if (!__nft_set_elem_expired(&rbe->ext, tstamp))
 			continue;
 
-		gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
-		if (!gc)
-			goto try_later;
-
 		/* end element needs to be removed first, it has
 		 * no timeout extension.
 		 */
+		write_lock_bh(&priv->lock);
 		if (rbe_end) {
-			nft_rbtree_gc_remove(net, set, priv, rbe_end);
-			nft_trans_gc_elem_add(gc, rbe_end);
+			nft_rbtree_gc_elem_move(net, set, priv, rbe_end);
 			rbe_end = NULL;
 		}
 
-		gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
-		if (!gc)
-			goto try_later;
-
-		nft_rbtree_gc_remove(net, set, priv, rbe);
-		nft_trans_gc_elem_add(gc, rbe);
+		nft_rbtree_gc_elem_move(net, set, priv, rbe);
+		write_unlock_bh(&priv->lock);
 	}
 
-try_later:
+	priv->last_gc = jiffies;
+}
+
+static void nft_rbtree_gc_queue(struct nft_set *set)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_rbtree_elem *rbe, *rbe_end;
+	struct nft_trans_gc *gc;
+
+	if (list_empty(&priv->expired))
+		return;
 
-	if (gc) {
-		gc = nft_trans_gc_catchall_sync(gc);
-		nft_trans_gc_queue_sync_done(gc);
-		priv->last_gc = jiffies;
+	gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
+	if (!gc)
+		return;
+
+	list_for_each_entry_safe(rbe, rbe_end, &priv->expired, list) {
+		list_del(&rbe->list);
+		nft_trans_gc_elem_add(gc, rbe);
+
+		gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
+		if (!gc)
+			return;
 	}
+
+	gc = nft_trans_gc_catchall_sync(gc);
+	nft_trans_gc_queue_sync_done(gc);
 }
 
 static u64 nft_rbtree_privsize(const struct nlattr * const nla[],
@@ -761,6 +741,7 @@ static int nft_rbtree_init(const struct nft_set *set,
 
 	rwlock_init(&priv->lock);
 	priv->root = RB_ROOT;
+	INIT_LIST_HEAD(&priv->expired);
 
 	priv->array = NULL;
 	priv->array_next = NULL;
@@ -778,10 +759,15 @@ static void nft_rbtree_destroy(const struct nft_ctx *ctx,
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
@@ -828,13 +814,21 @@ static void nft_rbtree_commit(struct nft_set *set)
 	u32 num_intervals = 0;
 	struct rb_node *node;
 
-	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
-		nft_rbtree_gc(set);
-
 	/* No changes, skip, eg. elements updates only. */
 	if (!priv->array_next)
 		return;
 
+	/* GC can be performed if the binary search blob is going
+	 * to be rebuilt.  It has to be done in two phases: first
+	 * scan tree and move all expired elements to the expired
+	 * list.
+	 *
+	 * Then, after blob has been re-built and published to other
+	 * CPUs, queue collected entries for freeing.
+	 */
+	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
+		nft_rbtree_gc_scan(set);
+
 	/* Reverse walk to create an array from smaller to largest interval. */
 	node = rb_last(&priv->root);
 	if (node)
@@ -881,10 +875,16 @@ static void nft_rbtree_commit(struct nft_set *set)
 		num_intervals++;
 err_out:
 	priv->array_next->num_intervals = num_intervals;
-	old = rcu_replace_pointer(priv->array, priv->array_next, true);
+	old = rcu_replace_pointer(priv->array, priv->array_next,
+				  lockdep_is_held(&nft_pernet(read_pnet(&set->net))->commit_mutex));
 	priv->array_next = NULL;
 	if (old)
 		call_rcu(&old->rcu_head, nft_array_free_rcu);
+
+	/* New blob is public, queue collected entries for freeing.
+	 * call_rcu ensures elements stay around until readers are done.
+	 */
+	nft_rbtree_gc_queue(set);
 }
 
 static void nft_rbtree_abort(const struct nft_set *set)
-- 
2.52.0

