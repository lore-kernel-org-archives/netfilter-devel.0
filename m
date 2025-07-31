Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6461D19ABAC
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2025 15:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753976644; cv=none; b=QyUojxni4SQNirw508WTKT1m1gVLevB8vVLEnoUe5C4R4081LYYGhzdpeDszHTwEYN90o/ssmbIdmvgkCNnNklUtBo1DX0+IluGJp+jsaRazZ22pPh6F2/73WInMQ1oraSCi4rPPsBR37Znv497l8+p83NxfITfkU5LslFRSunI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753976644; c=relaxed/simple;
	bh=IfSYdLDVXnvp6XEVy0tf+vlumLwgH1nnYPPx2TIifBs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r/PV2n8oI0jiRXE3kgfnDCWD2Xq/HTgqeW82rpzMTGQMiC9EkoGFoNZoMUWkHElSDcBH+cgaBExdWNdKZ9PGek2R3bKmLm3ePs/xvH564iybJPXUn1Lsa2BmhcvOGnHGCjwjnLzcCOxGUdNLLM8h+8WRiJYMZKF7ZL4W6nZJAg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 28E54602B2; Thu, 31 Jul 2025 17:43:59 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next] netfilter: nf_tables: remove element flush allocation
Date: Thu, 31 Jul 2025 17:43:49 +0200
Message-ID: <20250731154352.10098-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
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

As hinted at by Sven, this is because of GFP_ATOMIC allocations during
set flush.

When set is flushed, all elements are deactivated. This triggers a set
walk and each element gets added to the transaction list.

This is needed, because the commit phase will unlink (remove) the
elements from the underlying data structure (hashtable, tree, ...),
but we must delay the freeing until after a synchromize_rcu().

The nft_trans_elem structure holds the addresses of the set elements
so we can free them after removal from the set.

One way to resolve this is to allow sleeping allocations, but Pablo
suggested to avoid the per-element-allocations altogether.

The main drawback vs the initial patch is that in order to support
sleeping allocations, memory cost of each set element grows by one
pointer whereas initial sleeping-allocations only did this for the
rhashtable backend.

Not signed off as I don't see this as more elegant as v1 here:
https://lore.kernel.org/netfilter-devel/20250704123024.59099-1-fw@strlen.de/

One advantage however is that NEWSETELEM could be converted to use
the llist too instead of the dynamically-sized nelems array.

Then, the array could be removed again, it seems dubious to keep it
just for the update case.
That in turn would allow to remove the compaction code again.

Both DEL/NEWSETELEM would be changed to first peek the transaction list
tail to see if a compatible transaction exists and re-use that instead
of allocating a new one.

Pablo, please let me know if you prefer this direction compared to v1.
If so, I would also work on removing the trailing dynamically sized
array from nft_trans_elem structure in a followup patch.

Thanks!
---
 include/net/netfilter/nf_tables.h |   5 +
 net/netfilter/nf_tables_api.c     | 157 +++++++++++++++++++-----------
 2 files changed, 104 insertions(+), 58 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 891e43a01bdc..6668b186e83c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -735,6 +735,7 @@ struct nft_set_ext_tmpl {
  *
  *	@genmask: generation mask, but also flags (see NFT_SET_ELEM_DEAD_BIT)
  *	@offset: offsets of individual extension types
+ *	@trans_list: used during transaction when element is added or removed
  *	@data: beginning of extension data
  *
  *	This structure must be aligned to word size, otherwise atomic bitops
@@ -743,6 +744,7 @@ struct nft_set_ext_tmpl {
 struct nft_set_ext {
 	u8	genmask;
 	u8	offset[NFT_SET_EXT_NUM];
+	struct llist_node trans_list;
 	char	data[];
 } __aligned(BITS_PER_LONG / 8);
 
@@ -775,6 +777,7 @@ static inline void nft_set_ext_init(struct nft_set_ext *ext,
 				    const struct nft_set_ext_tmpl *tmpl)
 {
 	memcpy(ext->offset, tmpl->offset, sizeof(ext->offset));
+	init_llist_node(&ext->trans_list);
 }
 
 static inline bool __nft_set_ext_exists(const struct nft_set_ext *ext, u8 id)
@@ -1777,6 +1780,8 @@ struct nft_trans_one_elem {
 struct nft_trans_elem {
 	struct nft_trans		nft_trans;
 	struct nft_set			*set;
+	struct llist_head		elem_list;
+	unsigned int 			elem_count;
 	bool				bound;
 	unsigned int			nelems;
 	struct nft_trans_one_elem	elems[] __counted_by(nelems);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 13d0ed9d1895..1e34fd3b72b6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -498,7 +498,6 @@ static bool nft_trans_try_collapse(struct nftables_pernet *nft_net,
 
 	switch (trans->msg_type) {
 	case NFT_MSG_NEWSETELEM:
-	case NFT_MSG_DELSETELEM:
 		return nft_trans_collapse_set_elem(nft_net,
 						   nft_trans_container_elem(tail),
 						   nft_trans_container_elem(trans), gfp);
@@ -6653,6 +6652,8 @@ static struct nft_trans *nft_trans_elem_alloc(const struct nft_ctx *ctx,
 		return NULL;
 
 	te = nft_trans_container_elem(trans);
+	init_llist_head(&te->elem_list);
+
 	te->nelems = 1;
 	te->set = set;
 
@@ -6838,13 +6839,33 @@ void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 	kfree(elem_priv);
 }
 
+static struct nft_elem_priv *nft_set_elem_ext_to_priv(const struct nft_set *set,
+						     const struct nft_set_ext *ext)
+{
+	return (void *)ext - set->ops->elemsize;
+}
+
 static void nft_trans_elems_destroy(const struct nft_ctx *ctx,
-				    const struct nft_trans_elem *te)
+				    struct nft_trans_elem *te)
 {
-	int i;
+	struct llist_node *llist = __llist_del_all(&te->elem_list);
+	struct nft_set_ext *ext, *tmp;
+	unsigned int count = 0;
+
+	WARN_ON_ONCE(te->nelems); /* only used for NEW */
 
-	for (i = 0; i < te->nelems; i++)
-		nf_tables_set_elem_destroy(ctx, te->set, te->elems[i].priv);
+	llist_for_each_entry_safe(ext, tmp, llist, trans_list) {
+		struct nft_elem_priv *priv;
+
+		priv = nft_set_elem_ext_to_priv(te->set, ext);
+		nf_tables_set_elem_destroy(ctx, te->set, priv);
+		count++;
+	}
+
+	/* te->elem_count is reported to userspace via nfnetlink,
+	 * it should correspond the the number of removed elements.
+	 */
+	WARN_ON_ONCE(te->elem_count != count);
 }
 
 int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
@@ -7120,17 +7141,22 @@ static void nft_setelem_remove(const struct net *net,
 static void nft_trans_elems_remove(const struct nft_ctx *ctx,
 				   const struct nft_trans_elem *te)
 {
-	int i;
+	struct llist_node *llist = te->elem_list.first;
+	struct nft_set_ext *ext;
 
-	for (i = 0; i < te->nelems; i++) {
-		WARN_ON_ONCE(te->elems[i].update);
+	WARN_ON_ONCE(te->nelems); /* only used for NEW */
+
+	llist_for_each_entry(ext, llist, trans_list) {
+		struct nft_elem_priv *priv;
+
+		priv = nft_set_elem_ext_to_priv(te->set, ext);
 
 		nf_tables_setelem_notify(ctx, te->set,
-					 te->elems[i].priv,
+					 priv,
 					 te->nft_trans.msg_type);
 
-		nft_setelem_remove(ctx->net, te->set, te->elems[i].priv);
-		if (!nft_setelem_is_catchall(te->set, te->elems[i].priv)) {
+		nft_setelem_remove(ctx->net, te->set, priv);
+		if (!nft_setelem_is_catchall(te->set, priv)) {
 			atomic_dec(&te->set->nelems);
 			te->set->ndeact--;
 		}
@@ -7695,6 +7721,20 @@ void nft_setelem_data_deactivate(const struct net *net,
 		nft_use_dec(&(*nft_set_ext_obj(ext))->use);
 }
 
+static void nft_setelem_data_deactivate_trans(const struct nft_ctx *ctx,
+					      struct nft_trans_elem *te,
+					      struct nft_elem_priv *elem_priv)
+{
+	struct nft_set_ext *ext = nft_set_elem_ext(te->set, elem_priv);
+
+	nft_setelem_data_deactivate(ctx->net, te->set, elem_priv);
+
+	__llist_add(&ext->trans_list, &te->elem_list);
+
+	/* for later reporting to userland */
+	te->elem_count++;
+}
+
 /* similar to nft_trans_elems_remove, but called from abort path to undo newsetelem.
  * No notifications and no ndeact changes.
  *
@@ -7729,19 +7769,31 @@ static bool nft_trans_elems_new_abort(const struct nft_ctx *ctx,
 
 /* Called from abort path to undo DELSETELEM/DESTROYSETELEM. */
 static void nft_trans_elems_destroy_abort(const struct nft_ctx *ctx,
-					  const struct nft_trans_elem *te)
+					  struct nft_trans_elem *te)
 {
-	int i;
+	struct llist_node *llist = __llist_del_all(&te->elem_list);
+	struct nft_set_ext *ext, *tmp;
+	unsigned int count = 0;
 
-	for (i = 0; i < te->nelems; i++) {
-		if (!nft_setelem_active_next(ctx->net, te->set, te->elems[i].priv)) {
-			nft_setelem_data_activate(ctx->net, te->set, te->elems[i].priv);
-			nft_setelem_activate(ctx->net, te->set, te->elems[i].priv);
+	WARN_ON_ONCE(te->nelems); /* only used for NEW */
+
+	llist_for_each_entry_safe(ext, tmp, llist, trans_list) {
+		struct nft_elem_priv *priv;
+
+		priv = nft_set_elem_ext_to_priv(te->set, ext);
+
+		if (!nft_setelem_active_next(ctx->net, te->set, priv)) {
+			nft_setelem_data_activate(ctx->net, te->set, priv);
+			nft_setelem_activate(ctx->net, te->set, priv);
 		}
 
-		if (!nft_setelem_is_catchall(te->set, te->elems[i].priv))
+		if (!nft_setelem_is_catchall(te->set, priv))
 			te->set->ndeact--;
+
+		++count;
 	}
+
+	WARN_ON_ONCE(te->elem_count != count);
 }
 
 static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
@@ -7817,13 +7869,16 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (trans == NULL)
 		goto fail_trans;
 
+	nft_trans_container_elem(trans)->nelems = 0;
+
 	err = nft_setelem_deactivate(ctx->net, set, &elem, flags);
 	if (err < 0)
 		goto fail_ops;
 
-	nft_setelem_data_deactivate(ctx->net, set, elem.priv);
+	nft_setelem_data_deactivate_trans(ctx,
+					  nft_trans_container_elem(trans),
+					  elem.priv);
 
-	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
 	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 	return 0;
 
@@ -7843,54 +7898,33 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 			     const struct nft_set_iter *iter,
 			     struct nft_elem_priv *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
+	struct nftables_pernet *nft_net;
 	struct nft_trans *trans;
 
 	if (!nft_set_elem_active(ext, iter->genmask))
 		return 0;
 
-	trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM,
-				    struct_size_t(struct nft_trans_elem, elems, 1),
-				    GFP_ATOMIC);
-	if (!trans)
-		return -ENOMEM;
+	nft_net = nft_pernet(ctx->net);
+	trans = list_last_entry(&nft_net->commit_list, struct nft_trans, list);
 
 	set->ops->flush(ctx->net, set, elem_priv);
 	set->ndeact++;
 
-	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
-	nft_trans_elem_set(trans) = set;
-	nft_trans_container_elem(trans)->nelems = 1;
-	nft_trans_container_elem(trans)->elems[0].priv = elem_priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_ATOMIC);
-
-	return 0;
-}
-
-static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
-				    struct nft_set *set,
-				    struct nft_elem_priv *elem_priv)
-{
-	struct nft_trans *trans;
-
-	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
-	if (!trans)
-		return -ENOMEM;
-
-	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
-	nft_trans_container_elem(trans)->elems[0].priv = elem_priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+	nft_setelem_data_deactivate_trans(ctx,
+					  nft_trans_container_elem(trans),
+					  elem_priv);
 
 	return 0;
 }
 
-static int nft_set_catchall_flush(const struct nft_ctx *ctx,
-				  struct nft_set *set)
+static void nft_set_catchall_flush(const struct nft_ctx *ctx,
+				   struct nft_trans_elem *trans)
 {
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set_elem_catchall *catchall;
+	struct nft_set *set = trans->set;
 	struct nft_set_ext *ext;
-	int ret = 0;
 
 	list_for_each_entry_rcu(catchall, &set->catchall_list, list,
 				lockdep_commit_lock_is_held(ctx->net)) {
@@ -7898,13 +7932,9 @@ static int nft_set_catchall_flush(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
 
-		ret = __nft_set_catchall_flush(ctx, set, catchall->elem);
-		if (ret < 0)
-			break;
+		nft_setelem_data_deactivate_trans(ctx, trans, catchall->elem);
 		nft_set_elem_change_active(ctx->net, set, ext);
 	}
-
-	return ret;
 }
 
 static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
@@ -7914,10 +7944,20 @@ static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
 		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_setelem_flush,
 	};
+	struct nft_trans *trans;
+
+	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
+	if (!trans)
+		return -ENOMEM;
+
+	nft_trans_container_elem(trans)->nelems = 0;
+	nft_trans_container_elem(trans)->elem_count = 0;
+
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 
 	set->ops->walk(ctx, set, &iter);
 	if (!iter.err)
-		iter.err = nft_set_catchall_flush(ctx, set);
+		nft_set_catchall_flush(ctx, nft_trans_container_elem(trans));
 
 	return iter.err;
 }
@@ -10755,8 +10795,9 @@ static unsigned int nf_tables_commit_audit_entrycount(const struct nft_trans *tr
 {
 	switch (trans->msg_type) {
 	case NFT_MSG_NEWSETELEM:
-	case NFT_MSG_DELSETELEM:
 		return nft_trans_container_elem(trans)->nelems;
+	case NFT_MSG_DELSETELEM:
+		return nft_trans_container_elem(trans)->elem_count;
 	}
 
 	return 1;
-- 
2.49.1

