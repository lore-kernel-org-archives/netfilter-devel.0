Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7E6382363
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2026 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564550; cv=none; b=KxkE7qbmHLqCOH3ZYmEfPTcbTfMHayCg0EGa35I6Oa2CrtrISAVkBP+gtn32CnTkbUMt4U2kQ5VMwSPpLYVrjMGpWciTw1z7U+JzNQNJjXXyBSQ2CJu0csNGz6t0j3OlPABmwXQfk2OIPV1F5AYruRdDMqq9C/0Uxiw/TAwIuDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564550; c=relaxed/simple;
	bh=i9iTgcfu/w0cMqPb0XsKZyPrcpdYNDsV1DaSaPMIAEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JofMbnWS6yvb4j5gS8qkf6DBIE4OQIV6z1x11RMMeNzZV1F70mDk9+BUmTo776SF7bhM9UK/dyymkv9QMH8NUz9XiDt6LrwWLxcUfJNN7Wx3C2ui4SLk9jUtl/TGnQoDW8b+Ro4GRi3jzuOZW60+4XUbsvc6Vd+cdqXHXJ5tUGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E0F1B60D25; Tue, 03 Mar 2026 20:02:27 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>,
	Yiming Qian <yimingqian591@gmail.com>
Subject: [PATCH nf 1/2] netfilter: nft_set_pipapo: split gc in unlink and reclaim phase
Date: Tue,  3 Mar 2026 20:02:07 +0100
Message-ID: <20260303190218.19781-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260303190218.19781-1-fw@strlen.de>
References: <20260303190218.19781-1-fw@strlen.de>
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
 net/netfilter/nft_set_pipapo.c | 65 +++++++++++++++++++++++++---------
 net/netfilter/nft_set_pipapo.h |  4 +++
 2 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index c091898df710..d850166b8e45 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1680,22 +1680,17 @@ static void nft_pipapo_gc_deactivate(struct net *net, struct nft_set *set,
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
 	unsigned int rules_f0, first_rule = 0;
 	u64 tstamp = nft_net_tstamp(net);
 	struct nft_pipapo_elem *e;
-	struct nft_trans_gc *gc;
-
-	gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
-	if (!gc)
-		return;
 
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
 		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
@@ -1724,13 +1719,11 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 		 * NFT_SET_ELEM_DEAD_BIT.
 		 */
 		if (__nft_set_elem_expired(&e->ext, tstamp)) {
-			gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
-			if (!gc)
-				return;
-
 			nft_pipapo_gc_deactivate(net, set, e);
 			pipapo_drop(m, rulemap);
-			nft_trans_gc_elem_add(gc, e);
+
+			e->to_free = priv->to_free;
+			priv->to_free = e;
 
 			/* And check again current first rule, which is now the
 			 * first we haven't checked.
@@ -1740,11 +1733,39 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 		}
 	}
 
-	gc = nft_trans_gc_catchall_sync(gc);
-	if (gc) {
-		nft_trans_gc_queue_sync_done(gc);
-		priv->last_gc = jiffies;
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
+	struct nft_pipapo_elem *e = priv->to_free;
+	struct nft_trans_gc *gc;
+
+	if (!e)
+		return;
+
+	gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
+	if (!gc)
+		return;
+
+	while (e) {
+		struct nft_pipapo_elem *next = e->to_free;
+
+		nft_trans_gc_elem_add(gc, e);
+		priv->to_free = next;
+		e = next;
+		gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
+		if (!gc)
+			return;
 	}
+
+	gc = nft_trans_gc_catchall_sync(gc);
+	nft_trans_gc_queue_sync_done(gc);
 }
 
 /**
@@ -1807,7 +1828,7 @@ static void nft_pipapo_commit(struct nft_set *set)
 		return;
 
 	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
-		pipapo_gc(set, priv->clone);
+		pipapo_gc_scan(set, priv->clone);
 
 	old = rcu_replace_pointer(priv->match, priv->clone,
 				  nft_pipapo_transaction_mutex_held(set));
@@ -1815,6 +1836,8 @@ static void nft_pipapo_commit(struct nft_set *set)
 
 	if (old)
 		call_rcu(&old->rcu, pipapo_reclaim_match);
+
+	pipapo_gc_queue(set);
 }
 
 static void nft_pipapo_abort(const struct nft_set *set)
@@ -2279,6 +2302,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 		f->mt = NULL;
 	}
 
+	priv->to_free = NULL;
 	rcu_assign_pointer(priv->match, m);
 
 	return 0;
@@ -2328,6 +2352,13 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m;
 
+	while (priv->to_free) {
+		struct nft_pipapo_elem *e = priv->to_free;
+
+		priv->to_free = e->to_free;
+		nf_tables_set_elem_destroy(ctx, set, &e->priv);
+	}
+
 	m = rcu_dereference_protected(priv->match, true);
 
 	if (priv->clone) {
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index eaab422aa56a..4a5baebabaa5 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -156,12 +156,14 @@ struct nft_pipapo_match {
  * @clone:	Copy where pending insertions and deletions are kept
  * @width:	Total bytes to be matched for one packet, including padding
  * @last_gc:	Timestamp of last garbage collection run, jiffies
+ * @to_free:	single-linked list of elements to queue up for memory reclaim
  */
 struct nft_pipapo {
 	struct nft_pipapo_match __rcu *match;
 	struct nft_pipapo_match *clone;
 	int width;
 	unsigned long last_gc;
+	struct nft_pipapo_elem *to_free;
 };
 
 struct nft_pipapo_elem;
@@ -169,10 +171,12 @@ struct nft_pipapo_elem;
 /**
  * struct nft_pipapo_elem - API-facing representation of single set element
  * @priv:	element placeholder
+ * @to_free:	list of elements waiting for mem reclaim
  * @ext:	nftables API extensions
  */
 struct nft_pipapo_elem {
 	struct nft_elem_priv	priv;
+	struct nft_pipapo_elem  *to_free;
 	struct nft_set_ext	ext;
 };
 
-- 
2.52.0

