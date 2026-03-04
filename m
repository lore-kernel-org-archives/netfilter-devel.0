Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43C029408
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2026 05:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772602581; cv=none; b=qOONrLdMnCX6HiqeOrNLLPgyEK7vT7TyvyV9NWsXvKnLF199ykKGwN7PGdujX5fyhZub9WnMiYdRrYW1DhRFoxmBrtELxN2AaeG4+btD0YJwjiBY9uLJ18ShpZ4RW5LywFX9/S4leBI9bhcRe7m29og+N7Jwnu0MjddQ/QGUcmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772602581; c=relaxed/simple;
	bh=6Fz/8kP5PHE7adCCx3vowwtCpSXd1FuvYVC5OuVvBxE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TBmTxyzSqac3EQ2zrk5geiloSOzXUh5jektdKhngpkB3rqndKi22jwx7P+bM3WC8BidsDGlSToxouVd4DMrv9f1VX97fmo8RNFrLbCCj7KgExjwowBn+QrWwWdVL7tnL/+N9T/T6wpsW40O3G2TRMLlNwjlUoYHJqEpuSPdEp4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 632C06011D; Wed, 04 Mar 2026 06:36:18 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>,
	Yiming Qian <yimingqian591@gmail.com>
Subject: [PATCH v2 nf] netfilter: nft_set_pipapo: split gc in unlink and reclaim phase
Date: Wed,  4 Mar 2026 06:36:07 +0100
Message-ID: <20260304053611.15197-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Yiming Qian reports Use-after-free in the pipapo set type:
  Under a large number of expired elements, commit-time GC can run for a very
  long time in a non-preemptible context, triggering soft lockup warnings and
  RCU stall reports (local denial of service).

We must split GC in an unlink and a reclaim phase.

We CANNOT queue elements for reaping by the GC engine until after
pointers have been swapped.  Expired elements are still fully exposed to
both the packet path and userspace dumpers via the live copy of the data
structure.

call_rcu() does NOT protect us: dump operations or element lookups starting
after call_rcu has fired can still observe the free'd element, unless the
commit phase has made enough progress to swap the clone and live pointers.

This a similar approach as done recently for the rbtree backend in commit
35f83a75529a ("netfilter: nft_set_rbtree: don't gc elements on insert").

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: allocate gc containers and stash them in priv->gc_head, then
 pass them to gc engine after pointer swap.  Avoids adding a pointer
 in nft_pipapo_elem structure.

 include/net/netfilter/nf_tables.h |  5 +++
 net/netfilter/nf_tables_api.c     |  5 ---
 net/netfilter/nft_set_pipapo.c    | 51 ++++++++++++++++++++++++++-----
 net/netfilter/nft_set_pipapo.h    |  2 ++
 4 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ea6f29ad7888..e2d2bfc1f989 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1863,6 +1863,11 @@ struct nft_trans_gc {
 	struct rcu_head		rcu;
 };
 
+static inline int nft_trans_gc_space(const struct nft_trans_gc *trans)
+{
+	return NFT_TRANS_GC_BATCHCOUNT - trans->count;
+}
+
 static inline void nft_ctx_update(struct nft_ctx *ctx,
 				  const struct nft_trans *trans)
 {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 058f7004cb2b..1862bd7fe804 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10493,11 +10493,6 @@ static void nft_trans_gc_queue_work(struct nft_trans_gc *trans)
 	schedule_work(&trans_gc_work);
 }
 
-static int nft_trans_gc_space(struct nft_trans_gc *trans)
-{
-	return NFT_TRANS_GC_BATCHCOUNT - trans->count;
-}
-
 struct nft_trans_gc *nft_trans_gc_queue_async(struct nft_trans_gc *gc,
 					      unsigned int gc_seq, gfp_t gfp)
 {
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index c091898df710..a34632ae6048 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1680,11 +1680,11 @@ static void nft_pipapo_gc_deactivate(struct net *net, struct nft_set *set,
 }
 
 /**
- * pipapo_gc() - Drop expired entries from set, destroy start and end elements
+ * pipapo_gc_scan() - Drop expired entries from set and link them to gc list
  * @set:	nftables API set representation
  * @m:		Matching data
  */
-static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
+static void pipapo_gc_scan(struct nft_set *set, struct nft_pipapo_match *m)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct net *net = read_pnet(&set->net);
@@ -1697,6 +1697,8 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 	if (!gc)
 		return;
 
+	list_add(&gc->list, &priv->gc_head);
+
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
 		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 		const struct nft_pipapo_field *f;
@@ -1724,9 +1726,13 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 		 * NFT_SET_ELEM_DEAD_BIT.
 		 */
 		if (__nft_set_elem_expired(&e->ext, tstamp)) {
-			gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
-			if (!gc)
-				return;
+			if (!nft_trans_gc_space(gc)) {
+				gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
+				if (!gc)
+					return;
+
+				list_add(&gc->list, &priv->gc_head);
+			}
 
 			nft_pipapo_gc_deactivate(net, set, e);
 			pipapo_drop(m, rulemap);
@@ -1740,10 +1746,30 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 		}
 	}
 
-	gc = nft_trans_gc_catchall_sync(gc);
+	priv->last_gc = jiffies;
+}
+
+/**
+ * pipapo_gc_queue() - Free expired elements
+ * @set:	nftables API set representation
+ */
+static void pipapo_gc_queue(struct nft_set *set)
+{
+	struct nft_pipapo *priv = nft_set_priv(set);
+	struct nft_trans_gc *gc, *next;
+
+	/* always do a catchall cycle: */
+	gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
 	if (gc) {
+		gc = nft_trans_gc_catchall_sync(gc);
+		if (gc)
+			nft_trans_gc_queue_sync_done(gc);
+	}
+
+	/* always purge queued gc elements. */
+	list_for_each_entry_safe(gc, next, &priv->gc_head, list) {
+		list_del(&gc->list);
 		nft_trans_gc_queue_sync_done(gc);
-		priv->last_gc = jiffies;
 	}
 }
 
@@ -1797,6 +1823,10 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
  *
  * We also need to create a new working copy for subsequent insertions and
  * deletions.
+ *
+ * After the live copy has been replaced by the clone, we can safely queue
+ * expired elements that have been collected by pipapo_gc_scan() for
+ * memory reclaim.
  */
 static void nft_pipapo_commit(struct nft_set *set)
 {
@@ -1807,7 +1837,7 @@ static void nft_pipapo_commit(struct nft_set *set)
 		return;
 
 	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
-		pipapo_gc(set, priv->clone);
+		pipapo_gc_scan(set, priv->clone);
 
 	old = rcu_replace_pointer(priv->match, priv->clone,
 				  nft_pipapo_transaction_mutex_held(set));
@@ -1815,6 +1845,8 @@ static void nft_pipapo_commit(struct nft_set *set)
 
 	if (old)
 		call_rcu(&old->rcu, pipapo_reclaim_match);
+
+	pipapo_gc_queue(set);
 }
 
 static void nft_pipapo_abort(const struct nft_set *set)
@@ -2279,6 +2311,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 		f->mt = NULL;
 	}
 
+	INIT_LIST_HEAD(&priv->gc_head);
 	rcu_assign_pointer(priv->match, m);
 
 	return 0;
@@ -2328,6 +2361,8 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m;
 
+	WARN_ON_ONCE(!list_empty(&priv->gc_head));
+
 	m = rcu_dereference_protected(priv->match, true);
 
 	if (priv->clone) {
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index eaab422aa56a..9aee9a9eaeb7 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -156,12 +156,14 @@ struct nft_pipapo_match {
  * @clone:	Copy where pending insertions and deletions are kept
  * @width:	Total bytes to be matched for one packet, including padding
  * @last_gc:	Timestamp of last garbage collection run, jiffies
+ * @gc_head:	list of nft_trans_gc to queue up for mem reclaim
  */
 struct nft_pipapo {
 	struct nft_pipapo_match __rcu *match;
 	struct nft_pipapo_match *clone;
 	int width;
 	unsigned long last_gc;
+	struct list_head gc_head;
 };
 
 struct nft_pipapo_elem;
-- 
2.52.0

