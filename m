Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FFF296BC1
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 15:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773242964; cv=none; b=ZPLHsUv/08e/YH7u5lhETvOys0B5T2nw7WcP7rq53I3jvUY2u0VG9D76+q6kgZPv1KGZBTgmHfq/3D5b8hhREnEheApOIz6OlDkbMlDlDIOzLcH3bqQPAoU5+o+1xkofv0ScINlmKKdoawaO22f/lfrVrEnnlwmKB6TuDiqom5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773242964; c=relaxed/simple;
	bh=osvzHmRmwgnxbKmpELoP9BKIvDjUgdgJrzdfKSij9+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MoSHxyKkqanfbnuG22+gPlFgsOj4PGsEjvjUM0bsffAtCtU/KrhH2ZWpJ7+xuJIJ5NmFyuVzNkDkp3IbMjjKJTAYqXG0UF8nE6tzz9dDncOaJLXgzjXfyw67+X1rx6ZLF67ipsVhX8OH0BVsNqTslw9s2df9sBi8pgT6hxILOao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 90893601F4; Wed, 11 Mar 2026 16:29:20 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: revert nft_set_rbtree: validate open interval overlap
Date: Wed, 11 Mar 2026 16:29:12 +0100
Message-ID: <20260311152916.17696-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 648946966a08 ("netfilter: nft_set_rbtree: validate
open interval overlap").

There have been reports of nft failing to laod valid rulesets after this
patch was merged into -stable.

I can reproduce several such problem with recent nft versions, including
nft 1.1.6 which is widely shipped by distributions.

We currently have little choice here.
This commit can be resurrected at some point once the nftables fix that
triggers the false overlap positive has appeared in common distros
(see e83e32c8d1cd ("mnl: restore create element command with large batches" in
 nftables.git).

Fixes: 648946966a08 ("netfilter: nft_set_rbtree: validate open interval overlap")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo, if you prefer a different approach, e.g. just axing
 the relevant check instead of full revert please let me know.

 include/net/netfilter/nf_tables.h |  4 --
 net/netfilter/nf_tables_api.c     | 21 ++-------
 net/netfilter/nft_set_rbtree.c    | 71 +++++--------------------------
 3 files changed, 14 insertions(+), 82 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e2d2bfc1f989..6299af4ef423 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -277,8 +277,6 @@ struct nft_userdata {
 	unsigned char		data[];
 };
 
-#define NFT_SET_ELEM_INTERNAL_LAST	0x1
-
 /* placeholder structure for opaque set element backend representation. */
 struct nft_elem_priv { };
 
@@ -288,7 +286,6 @@ struct nft_elem_priv { };
  *	@key: element key
  *	@key_end: closing element key
  *	@data: element data
- * 	@flags: flags
  *	@priv: element private data and extensions
  */
 struct nft_set_elem {
@@ -304,7 +301,6 @@ struct nft_set_elem {
 		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
 		struct nft_data val;
 	} data;
-	u32			flags;
 	struct nft_elem_priv	*priv;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dacec5f8a11c..4ccdd33cf133 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7156,8 +7156,7 @@ static u32 nft_set_maxsize(const struct nft_set *set)
 }
 
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
-			    const struct nlattr *attr, u32 nlmsg_flags,
-			    bool last)
+			    const struct nlattr *attr, u32 nlmsg_flags)
 {
 	struct nft_expr *expr_array[NFT_SET_EXPR_MAX] = {};
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
@@ -7444,11 +7443,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (flags)
 		*nft_set_ext_flags(ext) = flags;
 
-	if (last)
-		elem.flags = NFT_SET_ELEM_INTERNAL_LAST;
-	else
-		elem.flags = 0;
-
 	if (obj)
 		*nft_set_ext_obj(ext) = obj;
 
@@ -7613,8 +7607,7 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags,
-				       nla_is_last(attr, rem));
+		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			return err;
@@ -7738,7 +7731,7 @@ static void nft_trans_elems_destroy_abort(const struct nft_ctx *ctx,
 }
 
 static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
-			   const struct nlattr *attr, bool last)
+			   const struct nlattr *attr)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	struct nft_set_ext_tmpl tmpl;
@@ -7806,11 +7799,6 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (flags)
 		*nft_set_ext_flags(ext) = flags;
 
-	if (last)
-		elem.flags = NFT_SET_ELEM_INTERNAL_LAST;
-	else
-		elem.flags = 0;
-
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
 	if (trans == NULL)
 		goto fail_trans;
@@ -7961,8 +7949,7 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 		return nft_set_flush(&ctx, set, genmask);
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_del_setelem(&ctx, set, attr,
-				      nla_is_last(attr, rem));
+		err = nft_del_setelem(&ctx, set, attr);
 		if (err == -ENOENT &&
 		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYSETELEM)
 			continue;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index a809b4dbafff..dc1f0e911d20 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -304,19 +304,10 @@ static void nft_rbtree_set_start_cookie(struct nft_rbtree *priv,
 	priv->start_rbe_cookie = (unsigned long)rbe;
 }
 
-static void nft_rbtree_set_start_cookie_open(struct nft_rbtree *priv,
-					     const struct nft_rbtree_elem *rbe,
-					     unsigned long open_interval)
-{
-	priv->start_rbe_cookie = (unsigned long)rbe | open_interval;
-}
-
-#define NFT_RBTREE_OPEN_INTERVAL	1UL
-
 static bool nft_rbtree_cmp_start_cookie(struct nft_rbtree *priv,
 					const struct nft_rbtree_elem *rbe)
 {
-	return (priv->start_rbe_cookie & ~NFT_RBTREE_OPEN_INTERVAL) == (unsigned long)rbe;
+	return priv->start_rbe_cookie == (unsigned long)rbe;
 }
 
 static bool nft_rbtree_insert_same_interval(const struct net *net,
@@ -346,14 +337,13 @@ static bool nft_rbtree_insert_same_interval(const struct net *net,
 
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
-			       struct nft_elem_priv **elem_priv, u64 tstamp, bool last)
+			       struct nft_elem_priv **elem_priv, u64 tstamp)
 {
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL, *rbe_prev;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
-	unsigned long open_interval = 0;
 	int d;
 
 	/* Descend the tree to search for an existing element greater than the
@@ -459,18 +449,10 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		}
 	}
 
-	if (nft_rbtree_interval_null(set, new)) {
+	if (nft_rbtree_interval_null(set, new))
+		priv->start_rbe_cookie = 0;
+	else if (nft_rbtree_interval_start(new) && priv->start_rbe_cookie)
 		priv->start_rbe_cookie = 0;
-	} else if (nft_rbtree_interval_start(new) && priv->start_rbe_cookie) {
-		if (nft_set_is_anonymous(set)) {
-			priv->start_rbe_cookie = 0;
-		} else if (priv->start_rbe_cookie & NFT_RBTREE_OPEN_INTERVAL) {
-			/* Previous element is an open interval that partially
-			 * overlaps with an existing non-open interval.
-			 */
-			return -ENOTEMPTY;
-		}
-	}
 
 	/* - new start element matching existing start element: full overlap
 	 *   reported as -EEXIST, cleared by caller if NLM_F_EXCL is not given.
@@ -478,27 +460,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	if (rbe_ge && !nft_rbtree_cmp(set, new, rbe_ge) &&
 	    nft_rbtree_interval_start(rbe_ge) == nft_rbtree_interval_start(new)) {
 		*elem_priv = &rbe_ge->priv;
-
-		/* - Corner case: new start element of open interval (which
-		 *   comes as last element in the batch) overlaps the start of
-		 *   an existing interval with an end element: partial overlap.
-		 */
-		node = rb_first(&priv->root);
-		rbe = __nft_rbtree_next_active(node, genmask);
-		if (rbe && nft_rbtree_interval_end(rbe)) {
-			rbe = nft_rbtree_next_active(rbe, genmask);
-			if (rbe &&
-			    nft_rbtree_interval_start(rbe) &&
-			    !nft_rbtree_cmp(set, new, rbe)) {
-				if (last)
-					return -ENOTEMPTY;
-
-				/* Maybe open interval? */
-				open_interval = NFT_RBTREE_OPEN_INTERVAL;
-			}
-		}
-		nft_rbtree_set_start_cookie_open(priv, rbe_ge, open_interval);
-
+		nft_rbtree_set_start_cookie(priv, rbe_ge);
 		return -EEXIST;
 	}
 
@@ -553,12 +515,6 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	    nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
 		return -ENOTEMPTY;
 
-	/* - start element overlaps an open interval but end element is new:
-	 *   partial overlap, reported as -ENOEMPTY.
-	 */
-	if (!rbe_ge && priv->start_rbe_cookie && nft_rbtree_interval_end(new))
-		return -ENOTEMPTY;
-
 	/* Accepted element: pick insertion point depending on key value */
 	parent = NULL;
 	p = &priv->root.rb_node;
@@ -673,7 +629,6 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			     struct nft_elem_priv **elem_priv)
 {
 	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
-	bool last = !!(elem->flags & NFT_SET_ELEM_INTERNAL_LAST);
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u64 tstamp = nft_net_tstamp(net);
 	int err;
@@ -690,12 +645,8 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		cond_resched();
 
 		write_lock_bh(&priv->lock);
-		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp, last);
+		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp);
 		write_unlock_bh(&priv->lock);
-
-		if (nft_rbtree_interval_end(rbe))
-			priv->start_rbe_cookie = 0;
-
 	} while (err == -EAGAIN);
 
 	return err;
@@ -783,7 +734,6 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 		      const struct nft_set_elem *elem)
 {
 	struct nft_rbtree_elem *rbe, *this = nft_elem_priv_cast(elem->priv);
-	bool last = !!(elem->flags & NFT_SET_ELEM_INTERNAL_LAST);
 	struct nft_rbtree *priv = nft_set_priv(set);
 	const struct rb_node *parent = priv->root.rb_node;
 	u8 genmask = nft_genmask_next(net);
@@ -824,10 +774,9 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 				continue;
 			}
 
-			if (nft_rbtree_interval_start(rbe)) {
-				if (!last)
-					nft_rbtree_set_start_cookie(priv, rbe);
-			} else if (!nft_rbtree_deactivate_same_interval(net, priv, rbe))
+			if (nft_rbtree_interval_start(rbe))
+				nft_rbtree_set_start_cookie(priv, rbe);
+			else if (!nft_rbtree_deactivate_same_interval(net, priv, rbe))
 				return NULL;
 
 			nft_rbtree_flush(net, set, &rbe->priv);
-- 
2.52.0

