Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCC582D67
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 08:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709801226; cv=none; b=bIokOTzIO9zRIvmO+i38DOphOfshWRntMWUWjtBqpy8HGL3RGUPRnji3yHG1Swq51m/bk9oOe0QeMg/OhU2rLD7x+HgV4o/XvMvK/nD3fOdevvSqguoJCyszcJNpK8nV99dBoedKcEdCZkhFibMCB0Q4pVMyhINYXfkGog6etTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709801226; c=relaxed/simple;
	bh=S2vHc8sGdbDB77hxAkhbTsjgX4k4pbFeRWrgimXsmec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t07b/jBvQpBkL2CbKEIJ5SwqjZE4CxUFbSNH+Unl/s0VknlL5dSD5UwYFlCPd4AreyXYzVRSzdXti4oba8qI0gCwNl6S7YQwKfDrFfmoGWnDPnj4vxglHfUu8uhKfBXpCfCnjM4B+vPrlIU7HwvuFUJ0SDJMjXkFiI3UKmXJhnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ri9P4-0005N6-N3; Thu, 07 Mar 2024 09:47:02 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 9/9] netfilter: nf_tables: remove gc sequence counter
Date: Thu,  7 Mar 2024 09:40:13 +0100
Message-ID: <20240307084018.2219-10-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307084018.2219-1-fw@strlen.de>
References: <20240307084018.2219-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove gc sequence counter, rely only on the DEAD lookup.

Concurrent set removal is fine, we still hold a reference to the set
structure.

netns can't go away, the trans_gc structure increments the
netns refcount.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 13 ++------
 net/netfilter/nf_tables_api.c     | 55 +++++--------------------------
 net/netfilter/nft_set_hash.c      | 18 ++--------
 net/netfilter/nft_set_pipapo.c    |  2 +-
 net/netfilter/nft_set_rbtree.c    |  4 +--
 5 files changed, 16 insertions(+), 76 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f0b85944e9eb..c8b8e2066f78 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -605,11 +605,6 @@ static inline void *nft_set_priv(const struct nft_set *set)
 	return (void *)set->data;
 }
 
-static inline bool nft_set_gc_is_pending(const struct nft_set *s)
-{
-	return refcount_read(&s->refs) != 1;
-}
-
 static inline struct nft_set *nft_set_container_of(const void *priv)
 {
 	return (void *)priv - offsetof(struct nft_set, data);
@@ -1744,18 +1739,15 @@ struct nft_trans_gc {
 	struct list_head	list;
 	struct net		*net;
 	struct nft_set		*set;
-	u32			seq;
 	u16			count;
 	struct nft_trans_gc_key keys[NFT_TRANS_GC_BATCHCOUNT];
 	struct rcu_head		rcu;
 };
 
-struct nft_trans_gc *nft_trans_gc_alloc(struct nft_set *set,
-					unsigned int gc_seq, gfp_t gfp);
+struct nft_trans_gc *nft_trans_gc_alloc(struct nft_set *set, gfp_t gfp);
 void nft_trans_gc_destroy(struct nft_trans_gc *trans);
 
-struct nft_trans_gc *nft_trans_gc_queue_async(struct nft_trans_gc *gc,
-					      unsigned int gc_seq, gfp_t gfp);
+struct nft_trans_gc *nft_trans_gc_queue_async(struct nft_trans_gc *gc, gfp_t gfp);
 void nft_trans_gc_queue_async_done(struct nft_trans_gc *gc);
 
 struct nft_trans_gc *nft_trans_gc_queue_sync(struct nft_trans_gc *gc, gfp_t gfp);
@@ -1797,7 +1789,6 @@ struct nftables_pernet {
 	u64			table_handle;
 	u64			tstamp;
 	unsigned int		base_seq;
-	unsigned int		gc_seq;
 	u8			validate_state;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8accb8498479..7a438392977c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9767,7 +9767,7 @@ static void nft_trans_gc_catchall(struct nft_ctx *ctx, struct nft_set *set)
 		if (!nft_set_elem_expired(ext))
 			continue;
 
-		gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
+		gc = nft_trans_gc_alloc(set, GFP_KERNEL);
 		break;
 	}
 
@@ -9803,12 +9803,10 @@ static bool nft_trans_gc_work_done(struct nft_trans_gc *trans)
 
 	mutex_lock(&nft_net->commit_mutex);
 
-	/* Check for race with transaction, otherwise this batch refers to
-	 * stale objects that might not be there anymore. Skip transaction if
-	 * set has been destroyed from control plane transaction in case gc
-	 * worker loses race.
+	/* Check for race with transaction.
+	 * Set could have been destroyed from control plane.
 	 */
-	if (READ_ONCE(nft_net->gc_seq) != trans->seq || trans->set->dead) {
+	if (trans->set->dead) {
 		mutex_unlock(&nft_net->commit_mutex);
 		return false;
 	}
@@ -9842,8 +9840,7 @@ static void nft_trans_gc_work(struct work_struct *work)
 	}
 }
 
-struct nft_trans_gc *nft_trans_gc_alloc(struct nft_set *set,
-					unsigned int gc_seq, gfp_t gfp)
+struct nft_trans_gc *nft_trans_gc_alloc(struct nft_set *set, gfp_t gfp)
 {
 	struct net *net = read_pnet(&set->net);
 	struct nft_trans_gc *trans;
@@ -9860,7 +9857,6 @@ struct nft_trans_gc *nft_trans_gc_alloc(struct nft_set *set,
 
 	refcount_inc(&set->refs);
 	trans->set = set;
-	trans->seq = gc_seq;
 
 	return trans;
 }
@@ -9896,8 +9892,7 @@ static void nft_trans_gc_queue_work(struct nft_trans_gc *trans)
 	schedule_work(&trans_gc_work);
 }
 
-struct nft_trans_gc *nft_trans_gc_queue_async(struct nft_trans_gc *gc,
-					      unsigned int gc_seq, gfp_t gfp)
+struct nft_trans_gc *nft_trans_gc_queue_async(struct nft_trans_gc *gc, gfp_t gfp)
 {
 	struct nft_set *set;
 
@@ -9907,7 +9902,7 @@ struct nft_trans_gc *nft_trans_gc_queue_async(struct nft_trans_gc *gc,
 	set = gc->set;
 	nft_trans_gc_queue_work(gc);
 
-	return nft_trans_gc_alloc(set, gc_seq, gfp);
+	return nft_trans_gc_alloc(set, gfp);
 }
 
 void nft_trans_gc_queue_async_done(struct nft_trans_gc *trans)
@@ -9933,7 +9928,7 @@ struct nft_trans_gc *nft_trans_gc_queue_sync(struct nft_trans_gc *gc, gfp_t gfp)
 	set = gc->set;
 	call_rcu(&gc->rcu, nft_trans_gc_trans_free);
 
-	return nft_trans_gc_alloc(set, 0, gfp);
+	return nft_trans_gc_alloc(set, gfp);
 }
 
 void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans)
@@ -10116,31 +10111,15 @@ static void nft_set_commit_update(struct list_head *set_update_list)
 	}
 }
 
-static unsigned int nft_gc_seq_begin(struct nftables_pernet *nft_net)
-{
-	unsigned int gc_seq;
-
-	/* Bump gc counter, it becomes odd, this is the busy mark. */
-	gc_seq = READ_ONCE(nft_net->gc_seq);
-	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
-
-	return gc_seq;
-}
-
-static void nft_gc_seq_end(struct nftables_pernet *nft_net, unsigned int gc_seq)
-{
-	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
-}
-
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
-	unsigned int base_seq, gc_seq;
 	LIST_HEAD(set_update_list);
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
+	unsigned int base_seq;
 	LIST_HEAD(adl);
 	int err;
 
@@ -10219,8 +10198,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 	WRITE_ONCE(nft_net->base_seq, base_seq);
 
-	gc_seq = nft_gc_seq_begin(nft_net);
-
 	/* step 3. Start new generation, rules_gen_X now in use. */
 	net->nft.gencursor = nft_gencursor_next(net);
 
@@ -10432,7 +10409,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
 	nf_tables_commit_audit_log(&adl, nft_net->base_seq);
 
-	nft_gc_seq_end(nft_net, gc_seq);
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
 	nf_tables_commit_release(net);
 
@@ -10715,12 +10691,9 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 			   enum nfnl_abort_action action)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
-	unsigned int gc_seq;
 	int ret;
 
-	gc_seq = nft_gc_seq_begin(nft_net);
 	ret = __nf_tables_abort(net, action);
-	nft_gc_seq_end(nft_net, gc_seq);
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
@@ -11443,7 +11416,6 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 	struct net *net = n->net;
 	unsigned int deleted;
 	bool restart = false;
-	unsigned int gc_seq;
 
 	if (event != NETLINK_URELEASE || n->protocol != NETLINK_NETFILTER)
 		return NOTIFY_DONE;
@@ -11452,8 +11424,6 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 	deleted = 0;
 	mutex_lock(&nft_net->commit_mutex);
 
-	gc_seq = nft_gc_seq_begin(nft_net);
-
 	if (!list_empty(&nf_tables_destroy_list))
 		nf_tables_trans_destroy_flush_work();
 again:
@@ -11480,7 +11450,6 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 		if (restart)
 			goto again;
 	}
-	nft_gc_seq_end(nft_net, gc_seq);
 
 	mutex_unlock(&nft_net->commit_mutex);
 
@@ -11502,7 +11471,6 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);
 	nft_net->base_seq = 1;
-	nft_net->gc_seq = 0;
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
 
 	return 0;
@@ -11520,20 +11488,15 @@ static void __net_exit nf_tables_pre_exit_net(struct net *net)
 static void __net_exit nf_tables_exit_net(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
-	unsigned int gc_seq;
 
 	mutex_lock(&nft_net->commit_mutex);
 
-	gc_seq = nft_gc_seq_begin(nft_net);
-
 	if (!list_empty(&nft_net->commit_list) ||
 	    !list_empty(&nft_net->module_list))
 		__nf_tables_abort(net, NFNL_ABORT_NONE);
 
 	__nft_release_tables(net);
 
-	nft_gc_seq_end(nft_net, gc_seq);
-
 	mutex_unlock(&nft_net->commit_mutex);
 	WARN_ON_ONCE(!list_empty(&nft_net->tables));
 	WARN_ON_ONCE(!list_empty(&nft_net->module_list));
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 4b3cc2e17784..c8210ed95c50 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -323,25 +323,18 @@ static bool nft_rhash_expr_needs_gc_run(const struct nft_set *set,
 
 static void nft_rhash_gc(struct work_struct *work)
 {
-	struct nftables_pernet *nft_net;
 	struct nft_set *set;
 	struct nft_rhash_elem *he;
 	struct nft_rhash *priv;
 	struct rhashtable_iter hti;
 	struct nft_trans_gc *gc;
 	struct net *net;
-	u32 gc_seq;
 
 	priv = container_of(work, struct nft_rhash, gc_work.work);
 	set  = nft_set_container_of(priv);
 	net  = read_pnet(&set->net);
-	nft_net = nft_pernet(net);
-	gc_seq = READ_ONCE(nft_net->gc_seq);
 
-	if (nft_set_gc_is_pending(set))
-		goto done;
-
-	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
+	gc = nft_trans_gc_alloc(set, GFP_KERNEL);
 	if (!gc)
 		goto done;
 
@@ -355,13 +348,6 @@ static void nft_rhash_gc(struct work_struct *work)
 			goto try_later;
 		}
 
-		/* Ruleset has been updated, try later. */
-		if (READ_ONCE(nft_net->gc_seq) != gc_seq) {
-			nft_trans_gc_destroy(gc);
-			gc = NULL;
-			goto try_later;
-		}
-
 		if (nft_set_elem_is_dead(&he->ext))
 			goto dead_elem;
 
@@ -374,7 +360,7 @@ static void nft_rhash_gc(struct work_struct *work)
 needs_gc_run:
 		nft_set_elem_dead(&he->ext);
 dead_elem:
-		gc = nft_trans_gc_queue_async(gc, gc_seq, GFP_ATOMIC);
+		gc = nft_trans_gc_queue_async(gc, GFP_ATOMIC);
 		if (!gc)
 			goto try_later;
 
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 35308de428c6..0b7022e6a03c 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1667,7 +1667,7 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 	struct nft_pipapo_elem *e;
 	struct nft_trans_gc *gc;
 
-	gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
+	gc = nft_trans_gc_alloc(set, GFP_KERNEL);
 	if (!gc)
 		return;
 
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index fc23fa76683a..ec03a6815790 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -242,7 +242,7 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 	struct nft_rbtree_elem *rbe_prev;
 	struct nft_trans_gc *gc;
 
-	gc = nft_trans_gc_alloc(set, 0, GFP_ATOMIC);
+	gc = nft_trans_gc_alloc(set, GFP_ATOMIC);
 	if (!gc)
 		return ERR_PTR(-ENOMEM);
 
@@ -634,7 +634,7 @@ static void nft_rbtree_gc(struct nft_set *set)
 	set  = nft_set_container_of(priv);
 	net  = read_pnet(&set->net);
 
-	gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
+	gc = nft_trans_gc_alloc(set, GFP_KERNEL);
 	if (!gc)
 		return;
 
-- 
2.43.0

