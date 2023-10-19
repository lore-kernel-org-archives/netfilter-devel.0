Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A690ECDB486
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 14:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346049AbjJSOUN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346057AbjJSOUM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 10:20:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1902B0
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 07:20:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,RFC 3/8] netfilter: nf_tables: expose opaque set element as struct nft_elem_priv
Date:   Thu, 19 Oct 2023 16:19:53 +0200
Message-Id: <20231019141958.653727-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231019141958.653727-1-pablo@netfilter.org>
References: <20231019141958.653727-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add placeholder structure and place it at the beginning of each struct
nft_*_elem for each existing set backend, instead of exposing elements
as void type to the frontend which defeats compiler type checks. Use
this pointer to this new type to replace void *.

This patch updates the following set backend API to use this new struct
nft_elem_priv placeholder structure:

- update
- deactivate
- flush
- get

as well as the following helper functions:

- nft_set_elem_ext()
- nft_set_elem_init()
- nft_set_elem_destroy()
- nf_tables_set_elem_destroy()

This patch adds nft_elem_priv_cast() to cast struct nft_elem_priv to
native element representation from the corresponding set backend.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 38 +++++++++------
 net/netfilter/nf_tables_api.c     | 27 ++++++-----
 net/netfilter/nft_dynset.c        | 23 ++++-----
 net/netfilter/nft_set_bitmap.c    | 33 +++++++------
 net/netfilter/nft_set_hash.c      | 78 +++++++++++++++++--------------
 net/netfilter/nft_set_pipapo.c    | 39 ++++++++++------
 net/netfilter/nft_set_pipapo.h    |  4 +-
 net/netfilter/nft_set_rbtree.c    | 44 +++++++++--------
 8 files changed, 165 insertions(+), 121 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f65c083c9ef8..d3f26eba55ed 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -274,6 +274,9 @@ struct nft_userdata {
 	unsigned char		data[];
 };
 
+/* placeholder structure for opaque set element backend representation. */
+struct nft_elem_priv { };
+
 /**
  *	struct nft_set_elem - generic representation of set elements
  *
@@ -294,9 +297,14 @@ struct nft_set_elem {
 		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
 		struct nft_data val;
 	} data;
-	void			*priv;
+	struct nft_elem_priv	*priv;
 };
 
+static inline void *nft_elem_priv_cast(const struct nft_elem_priv *priv)
+{
+	return (void *)priv;
+}
+
 struct nft_set;
 struct nft_set_iter {
 	u8		genmask;
@@ -430,7 +438,8 @@ struct nft_set_ops {
 						  const struct nft_set_ext **ext);
 	bool				(*update)(struct nft_set *set,
 						  const u32 *key,
-						  void *(*new)(struct nft_set *,
+						  struct nft_elem_priv *
+							(*new)(struct nft_set *,
 							       const struct nft_expr *,
 							       struct nft_regs *),
 						  const struct nft_expr *expr,
@@ -446,19 +455,19 @@ struct nft_set_ops {
 	void				(*activate)(const struct net *net,
 						    const struct nft_set *set,
 						    const struct nft_set_elem *elem);
-	void *				(*deactivate)(const struct net *net,
+	struct nft_elem_priv *		(*deactivate)(const struct net *net,
 						      const struct nft_set *set,
 						      const struct nft_set_elem *elem);
 	void				(*flush)(const struct net *net,
 						 const struct nft_set *set,
-						 void *priv);
+						 struct nft_elem_priv *priv);
 	void				(*remove)(const struct net *net,
 						  const struct nft_set *set,
 						  const struct nft_set_elem *elem);
 	void				(*walk)(const struct nft_ctx *ctx,
 						struct nft_set *set,
 						struct nft_set_iter *iter);
-	void *				(*get)(const struct net *net,
+	struct nft_elem_priv *		(*get)(const struct net *net,
 					       const struct nft_set *set,
 					       const struct nft_set_elem *elem,
 					       unsigned int flags);
@@ -796,9 +805,9 @@ static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
 }
 
 static inline struct nft_set_ext *nft_set_elem_ext(const struct nft_set *set,
-						   void *elem)
+						   const struct nft_elem_priv *elem_priv)
 {
-	return elem + set->ops->elemsize;
+	return (void *)elem_priv + set->ops->elemsize;
 }
 
 static inline struct nft_object **nft_set_ext_obj(const struct nft_set_ext *ext)
@@ -810,16 +819,19 @@ struct nft_expr *nft_set_elem_expr_alloc(const struct nft_ctx *ctx,
 					 const struct nft_set *set,
 					 const struct nlattr *attr);
 
-void *nft_set_elem_init(const struct nft_set *set,
-			const struct nft_set_ext_tmpl *tmpl,
-			const u32 *key, const u32 *key_end, const u32 *data,
-			u64 timeout, u64 expiration, gfp_t gfp);
+struct nft_elem_priv *nft_set_elem_init(const struct nft_set *set,
+					const struct nft_set_ext_tmpl *tmpl,
+					const u32 *key, const u32 *key_end,
+					const u32 *data,
+					u64 timeout, u64 expiration, gfp_t gfp);
 int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_expr *expr_array[]);
-void nft_set_elem_destroy(const struct nft_set *set, void *elem,
+void nft_set_elem_destroy(const struct nft_set *set,
+			  const struct nft_elem_priv *elem_priv,
 			  bool destroy_expr);
 void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
-				const struct nft_set *set, void *elem);
+				const struct nft_set *set,
+				const struct nft_elem_priv *elem_priv);
 
 struct nft_expr_ops;
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4239d3665446..3b47a328c4a7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -601,7 +601,7 @@ static int nft_mapelem_deactivate(const struct nft_ctx *ctx,
 struct nft_set_elem_catchall {
 	struct list_head	list;
 	struct rcu_head		rcu;
-	void			*elem;
+	struct nft_elem_priv	*elem;
 };
 
 static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
@@ -6158,10 +6158,11 @@ static int nft_set_ext_memcpy(const struct nft_set_ext_tmpl *tmpl, u8 id,
 	return 0;
 }
 
-void *nft_set_elem_init(const struct nft_set *set,
-			const struct nft_set_ext_tmpl *tmpl,
-			const u32 *key, const u32 *key_end,
-			const u32 *data, u64 timeout, u64 expiration, gfp_t gfp)
+struct nft_elem_priv *nft_set_elem_init(const struct nft_set *set,
+					const struct nft_set_ext_tmpl *tmpl,
+					const u32 *key, const u32 *key_end,
+					const u32 *data,
+					u64 timeout, u64 expiration, gfp_t gfp)
 {
 	struct nft_set_ext *ext;
 	void *elem;
@@ -6226,10 +6227,11 @@ static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 }
 
 /* Drop references and destroy. Called from gc, dynset and abort path. */
-void nft_set_elem_destroy(const struct nft_set *set, void *elem,
+void nft_set_elem_destroy(const struct nft_set *set,
+			  const struct nft_elem_priv *elem_priv,
 			  bool destroy_expr)
 {
-	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 	struct nft_ctx ctx = {
 		.net	= read_pnet(&set->net),
 		.family	= set->table->family,
@@ -6240,10 +6242,10 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 		nft_data_release(nft_set_ext_data(ext), set->dtype);
 	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS))
 		nft_set_elem_expr_destroy(&ctx, nft_set_ext_expr(ext));
-
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
 		nft_use_dec(&(*nft_set_ext_obj(ext))->use);
-	kfree(elem);
+
+	kfree(elem_priv);
 }
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 
@@ -6251,14 +6253,15 @@ EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
  * path via nft_setelem_data_deactivate().
  */
 void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
-				const struct nft_set *set, void *elem)
+				const struct nft_set *set,
+				const struct nft_elem_priv *elem_priv)
 {
-	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS))
 		nft_set_elem_expr_destroy(ctx, nft_set_ext_expr(ext));
 
-	kfree(elem);
+	kfree(elem_priv);
 }
 
 int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 5c5cc01c73c5..b18a79039125 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -44,33 +44,34 @@ static int nft_dynset_expr_setup(const struct nft_dynset *priv,
 	return 0;
 }
 
-static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
-			    struct nft_regs *regs)
+static struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
+					    const struct nft_expr *expr,
+					    struct nft_regs *regs)
 {
 	const struct nft_dynset *priv = nft_expr_priv(expr);
 	struct nft_set_ext *ext;
+	void *elem_priv;
 	u64 timeout;
-	void *elem;
 
 	if (!atomic_add_unless(&set->nelems, 1, set->size))
 		return NULL;
 
 	timeout = priv->timeout ? : set->timeout;
-	elem = nft_set_elem_init(set, &priv->tmpl,
-				 &regs->data[priv->sreg_key], NULL,
-				 &regs->data[priv->sreg_data],
-				 timeout, 0, GFP_ATOMIC);
-	if (IS_ERR(elem))
+	elem_priv = nft_set_elem_init(set, &priv->tmpl,
+				      &regs->data[priv->sreg_key], NULL,
+				      &regs->data[priv->sreg_data],
+				      timeout, 0, GFP_ATOMIC);
+	if (IS_ERR(elem_priv))
 		goto err1;
 
-	ext = nft_set_elem_ext(set, elem);
+	ext = nft_set_elem_ext(set, elem_priv);
 	if (priv->num_exprs && nft_dynset_expr_setup(priv, ext) < 0)
 		goto err2;
 
-	return elem;
+	return elem_priv;
 
 err2:
-	nft_set_elem_destroy(set, elem, false);
+	nft_set_elem_destroy(set, elem_priv, false);
 err1:
 	if (set->size)
 		atomic_dec(&set->nelems);
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 2ee6e3672b41..f54fb42918f2 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -13,6 +13,7 @@
 #include <net/netfilter/nf_tables_core.h>
 
 struct nft_bitmap_elem {
+	struct nft_elem_priv	priv;
 	struct list_head	head;
 	struct nft_set_ext	ext;
 };
@@ -104,8 +105,9 @@ nft_bitmap_elem_find(const struct nft_set *set, struct nft_bitmap_elem *this,
 	return NULL;
 }
 
-static void *nft_bitmap_get(const struct net *net, const struct nft_set *set,
-			    const struct nft_set_elem *elem, unsigned int flags)
+static struct nft_elem_priv *
+nft_bitmap_get(const struct net *net, const struct nft_set *set,
+	       const struct nft_set_elem *elem, unsigned int flags)
 {
 	const struct nft_bitmap *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_cur(net);
@@ -116,7 +118,7 @@ static void *nft_bitmap_get(const struct net *net, const struct nft_set *set,
 		    !nft_set_elem_active(&be->ext, genmask))
 			continue;
 
-		return be;
+		return &be->priv;
 	}
 	return ERR_PTR(-ENOENT);
 }
@@ -125,8 +127,8 @@ static int nft_bitmap_insert(const struct net *net, const struct nft_set *set,
 			     const struct nft_set_elem *elem,
 			     struct nft_set_ext **ext)
 {
+	struct nft_bitmap_elem *new = nft_elem_priv_cast(elem->priv), *be;
 	struct nft_bitmap *priv = nft_set_priv(set);
-	struct nft_bitmap_elem *new = elem->priv, *be;
 	u8 genmask = nft_genmask_next(net);
 	u32 idx, off;
 
@@ -148,8 +150,8 @@ static void nft_bitmap_remove(const struct net *net,
 			      const struct nft_set *set,
 			      const struct nft_set_elem *elem)
 {
+	struct nft_bitmap_elem *be = nft_elem_priv_cast(elem->priv);
 	struct nft_bitmap *priv = nft_set_priv(set);
-	struct nft_bitmap_elem *be = elem->priv;
 	u8 genmask = nft_genmask_next(net);
 	u32 idx, off;
 
@@ -163,8 +165,8 @@ static void nft_bitmap_activate(const struct net *net,
 				const struct nft_set *set,
 				const struct nft_set_elem *elem)
 {
+	struct nft_bitmap_elem *be = nft_elem_priv_cast(elem->priv);
 	struct nft_bitmap *priv = nft_set_priv(set);
-	struct nft_bitmap_elem *be = elem->priv;
 	u8 genmask = nft_genmask_next(net);
 	u32 idx, off;
 
@@ -175,11 +177,12 @@ static void nft_bitmap_activate(const struct net *net,
 }
 
 static void nft_bitmap_flush(const struct net *net,
-			     const struct nft_set *set, void *_be)
+			     const struct nft_set *set,
+			     struct nft_elem_priv *elem_priv)
 {
+	struct nft_bitmap_elem *be = nft_elem_priv_cast(elem_priv);
 	struct nft_bitmap *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
-	struct nft_bitmap_elem *be = _be;
 	u32 idx, off;
 
 	nft_bitmap_location(set, nft_set_ext_key(&be->ext), &idx, &off);
@@ -188,12 +191,12 @@ static void nft_bitmap_flush(const struct net *net,
 	nft_set_elem_change_active(net, set, &be->ext);
 }
 
-static void *nft_bitmap_deactivate(const struct net *net,
-				   const struct nft_set *set,
-				   const struct nft_set_elem *elem)
+static struct nft_elem_priv *
+nft_bitmap_deactivate(const struct net *net, const struct nft_set *set,
+		      const struct nft_set_elem *elem)
 {
+	struct nft_bitmap_elem *this = nft_elem_priv_cast(elem->priv), *be;
 	struct nft_bitmap *priv = nft_set_priv(set);
-	struct nft_bitmap_elem *this = elem->priv, *be;
 	u8 genmask = nft_genmask_next(net);
 	u32 idx, off;
 
@@ -207,7 +210,7 @@ static void *nft_bitmap_deactivate(const struct net *net,
 	priv->bitmap[idx] &= ~(genmask << off);
 	nft_set_elem_change_active(net, set, &be->ext);
 
-	return be;
+	return &be->priv;
 }
 
 static void nft_bitmap_walk(const struct nft_ctx *ctx,
@@ -224,7 +227,7 @@ static void nft_bitmap_walk(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(&be->ext, iter->genmask))
 			goto cont;
 
-		elem.priv = be;
+		elem.priv = &be->priv;
 
 		iter->err = iter->fn(ctx, set, iter, &elem);
 
@@ -276,7 +279,7 @@ static void nft_bitmap_destroy(const struct nft_ctx *ctx,
 	struct nft_bitmap_elem *be, *n;
 
 	list_for_each_entry_safe(be, n, &priv->list, head)
-		nf_tables_set_elem_destroy(ctx, set, be);
+		nf_tables_set_elem_destroy(ctx, set, &be->priv);
 }
 
 static bool nft_bitmap_estimate(const struct nft_set_desc *desc, u32 features,
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index e758b887ad86..1efe9e7871bf 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -27,6 +27,7 @@ struct nft_rhash {
 };
 
 struct nft_rhash_elem {
+	struct nft_elem_priv		priv;
 	struct rhash_head		node;
 	struct nft_set_ext		ext;
 };
@@ -95,8 +96,9 @@ bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
 	return !!he;
 }
 
-static void *nft_rhash_get(const struct net *net, const struct nft_set *set,
-			   const struct nft_set_elem *elem, unsigned int flags)
+static struct nft_elem_priv *
+nft_rhash_get(const struct net *net, const struct nft_set *set,
+	      const struct nft_set_elem *elem, unsigned int flags)
 {
 	struct nft_rhash *priv = nft_set_priv(set);
 	struct nft_rhash_elem *he;
@@ -108,13 +110,14 @@ static void *nft_rhash_get(const struct net *net, const struct nft_set *set,
 
 	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
 	if (he != NULL)
-		return he;
+		return &he->priv;
 
 	return ERR_PTR(-ENOENT);
 }
 
 static bool nft_rhash_update(struct nft_set *set, const u32 *key,
-			     void *(*new)(struct nft_set *,
+			     struct nft_elem_priv *
+				   (*new)(struct nft_set *,
 					  const struct nft_expr *,
 					  struct nft_regs *regs),
 			     const struct nft_expr *expr,
@@ -123,6 +126,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 {
 	struct nft_rhash *priv = nft_set_priv(set);
 	struct nft_rhash_elem *he, *prev;
+	struct nft_elem_priv *elem_priv;
 	struct nft_rhash_cmp_arg arg = {
 		.genmask = NFT_GENMASK_ANY,
 		.set	 = set,
@@ -133,10 +137,11 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 	if (he != NULL)
 		goto out;
 
-	he = new(set, expr, regs);
-	if (he == NULL)
+	elem_priv = new(set, expr, regs);
+	if (!elem_priv)
 		goto err1;
 
+	he = nft_elem_priv_cast(elem_priv);
 	prev = rhashtable_lookup_get_insert_key(&priv->ht, &arg, &he->node,
 						nft_rhash_params);
 	if (IS_ERR(prev))
@@ -144,7 +149,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 
 	/* Another cpu may race to insert the element with the same key */
 	if (prev) {
-		nft_set_elem_destroy(set, he, true);
+		nft_set_elem_destroy(set, &he->priv, true);
 		atomic_dec(&set->nelems);
 		he = prev;
 	}
@@ -154,7 +159,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 	return true;
 
 err2:
-	nft_set_elem_destroy(set, he, true);
+	nft_set_elem_destroy(set, &he->priv, true);
 	atomic_dec(&set->nelems);
 err1:
 	return false;
@@ -164,8 +169,8 @@ static int nft_rhash_insert(const struct net *net, const struct nft_set *set,
 			    const struct nft_set_elem *elem,
 			    struct nft_set_ext **ext)
 {
+	struct nft_rhash_elem *he = nft_elem_priv_cast(elem->priv);
 	struct nft_rhash *priv = nft_set_priv(set);
-	struct nft_rhash_elem *he = elem->priv;
 	struct nft_rhash_cmp_arg arg = {
 		.genmask = nft_genmask_next(net),
 		.set	 = set,
@@ -187,22 +192,23 @@ static int nft_rhash_insert(const struct net *net, const struct nft_set *set,
 static void nft_rhash_activate(const struct net *net, const struct nft_set *set,
 			       const struct nft_set_elem *elem)
 {
-	struct nft_rhash_elem *he = elem->priv;
+	struct nft_rhash_elem *he = nft_elem_priv_cast(elem->priv);
 
 	nft_set_elem_change_active(net, set, &he->ext);
 }
 
 static void nft_rhash_flush(const struct net *net,
-			    const struct nft_set *set, void *priv)
+			    const struct nft_set *set,
+			    struct nft_elem_priv *elem_priv)
 {
-	struct nft_rhash_elem *he = priv;
+	struct nft_rhash_elem *he = nft_elem_priv_cast(elem_priv);
 
 	nft_set_elem_change_active(net, set, &he->ext);
 }
 
-static void *nft_rhash_deactivate(const struct net *net,
-				  const struct nft_set *set,
-				  const struct nft_set_elem *elem)
+static struct nft_elem_priv *
+nft_rhash_deactivate(const struct net *net, const struct nft_set *set,
+		     const struct nft_set_elem *elem)
 {
 	struct nft_rhash *priv = nft_set_priv(set);
 	struct nft_rhash_elem *he;
@@ -219,15 +225,15 @@ static void *nft_rhash_deactivate(const struct net *net,
 
 	rcu_read_unlock();
 
-	return he;
+	return &he->priv;
 }
 
 static void nft_rhash_remove(const struct net *net,
 			     const struct nft_set *set,
 			     const struct nft_set_elem *elem)
 {
+	struct nft_rhash_elem *he = nft_elem_priv_cast(elem->priv);
 	struct nft_rhash *priv = nft_set_priv(set);
-	struct nft_rhash_elem *he = elem->priv;
 
 	rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params);
 }
@@ -278,7 +284,7 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 		if (!nft_set_elem_active(&he->ext, iter->genmask))
 			goto cont;
 
-		elem.priv = he;
+		elem.priv = &he->priv;
 
 		iter->err = iter->fn(ctx, set, iter, &elem);
 		if (iter->err < 0)
@@ -426,8 +432,9 @@ struct nft_rhash_ctx {
 static void nft_rhash_elem_destroy(void *ptr, void *arg)
 {
 	struct nft_rhash_ctx *rhash_ctx = arg;
+	struct nft_rhash_elem *he = ptr;
 
-	nf_tables_set_elem_destroy(&rhash_ctx->ctx, rhash_ctx->set, ptr);
+	nf_tables_set_elem_destroy(&rhash_ctx->ctx, rhash_ctx->set, &he->priv);
 }
 
 static void nft_rhash_destroy(const struct nft_ctx *ctx,
@@ -474,6 +481,7 @@ struct nft_hash {
 };
 
 struct nft_hash_elem {
+	struct nft_elem_priv		priv;
 	struct hlist_node		node;
 	struct nft_set_ext		ext;
 };
@@ -499,8 +507,9 @@ bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
 	return false;
 }
 
-static void *nft_hash_get(const struct net *net, const struct nft_set *set,
-			  const struct nft_set_elem *elem, unsigned int flags)
+static struct nft_elem_priv *
+nft_hash_get(const struct net *net, const struct nft_set *set,
+	     const struct nft_set_elem *elem, unsigned int flags)
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_cur(net);
@@ -512,7 +521,7 @@ static void *nft_hash_get(const struct net *net, const struct nft_set *set,
 	hlist_for_each_entry_rcu(he, &priv->table[hash], node) {
 		if (!memcmp(nft_set_ext_key(&he->ext), elem->key.val.data, set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask))
-			return he;
+			return &he->priv;
 	}
 	return ERR_PTR(-ENOENT);
 }
@@ -562,7 +571,7 @@ static int nft_hash_insert(const struct net *net, const struct nft_set *set,
 			   const struct nft_set_elem *elem,
 			   struct nft_set_ext **ext)
 {
-	struct nft_hash_elem *this = elem->priv, *he;
+	struct nft_hash_elem *this = nft_elem_priv_cast(elem->priv), *he;
 	struct nft_hash *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	u32 hash;
@@ -583,25 +592,26 @@ static int nft_hash_insert(const struct net *net, const struct nft_set *set,
 static void nft_hash_activate(const struct net *net, const struct nft_set *set,
 			      const struct nft_set_elem *elem)
 {
-	struct nft_hash_elem *he = elem->priv;
+	struct nft_hash_elem *he = nft_elem_priv_cast(elem->priv);
 
 	nft_set_elem_change_active(net, set, &he->ext);
 }
 
 static void nft_hash_flush(const struct net *net,
-			   const struct nft_set *set, void *priv)
+			   const struct nft_set *set,
+			   struct nft_elem_priv *elem_priv)
 {
-	struct nft_hash_elem *he = priv;
+	struct nft_hash_elem *he = nft_elem_priv_cast(elem_priv);
 
 	nft_set_elem_change_active(net, set, &he->ext);
 }
 
-static void *nft_hash_deactivate(const struct net *net,
-				 const struct nft_set *set,
-				 const struct nft_set_elem *elem)
+static struct nft_elem_priv *
+nft_hash_deactivate(const struct net *net, const struct nft_set *set,
+		    const struct nft_set_elem *elem)
 {
+	struct nft_hash_elem *this = nft_elem_priv_cast(elem->priv), *he;
 	struct nft_hash *priv = nft_set_priv(set);
-	struct nft_hash_elem *this = elem->priv, *he;
 	u8 genmask = nft_genmask_next(net);
 	u32 hash;
 
@@ -611,7 +621,7 @@ static void *nft_hash_deactivate(const struct net *net,
 			    set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask)) {
 			nft_set_elem_change_active(net, set, &he->ext);
-			return he;
+			return &he->priv;
 		}
 	}
 	return NULL;
@@ -621,7 +631,7 @@ static void nft_hash_remove(const struct net *net,
 			    const struct nft_set *set,
 			    const struct nft_set_elem *elem)
 {
-	struct nft_hash_elem *he = elem->priv;
+	struct nft_hash_elem *he = nft_elem_priv_cast(elem->priv);
 
 	hlist_del_rcu(&he->node);
 }
@@ -641,7 +651,7 @@ static void nft_hash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 			if (!nft_set_elem_active(&he->ext, iter->genmask))
 				goto cont;
 
-			elem.priv = he;
+			elem.priv = &he->priv;
 
 			iter->err = iter->fn(ctx, set, iter, &elem);
 			if (iter->err < 0)
@@ -682,7 +692,7 @@ static void nft_hash_destroy(const struct nft_ctx *ctx,
 	for (i = 0; i < priv->buckets; i++) {
 		hlist_for_each_entry_safe(he, next, &priv->table[i], node) {
 			hlist_del_rcu(&he->node);
-			nf_tables_set_elem_destroy(ctx, set, he);
+			nf_tables_set_elem_destroy(ctx, set, &he->priv);
 		}
 	}
 }
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index f30d391337d6..7b64f118f8cd 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -599,11 +599,18 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
  * @elem:	nftables API element representation containing key data
  * @flags:	Unused
  */
-static void *nft_pipapo_get(const struct net *net, const struct nft_set *set,
-			    const struct nft_set_elem *elem, unsigned int flags)
+static struct nft_elem_priv *
+nft_pipapo_get(const struct net *net, const struct nft_set *set,
+	       const struct nft_set_elem *elem, unsigned int flags)
 {
-	return pipapo_get(net, set, (const u8 *)elem->key.val.data,
-			 nft_genmask_cur(net));
+	static struct nft_pipapo_elem *e;
+
+	e = pipapo_get(net, set, (const u8 *)elem->key.val.data,
+		       nft_genmask_cur(net));
+	if (IS_ERR(e))
+		return ERR_CAST(e);
+
+	return &e->priv;
 }
 
 /**
@@ -1162,10 +1169,10 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 	const u8 *start = (const u8 *)elem->key.val.data, *end;
-	struct nft_pipapo_elem *e = elem->priv, *dup;
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m = priv->clone;
 	u8 genmask = nft_genmask_next(net);
+	struct nft_pipapo_elem *e, *dup;
 	struct nft_pipapo_field *f;
 	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
@@ -1263,6 +1270,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		put_cpu_ptr(m->scratch);
 	}
 
+	e = nft_elem_priv_cast(elem->priv);
 	*ext2 = &e->ext;
 
 	pipapo_map(m, rulemap, e);
@@ -1541,7 +1549,7 @@ static void nft_pipapo_gc_deactivate(struct net *net, struct nft_set *set,
 
 {
 	struct nft_set_elem elem = {
-		.priv	= e,
+		.priv	= &e->priv,
 	};
 
 	nft_setelem_data_deactivate(net, set, &elem);
@@ -1743,7 +1751,7 @@ static void nft_pipapo_activate(const struct net *net,
 				const struct nft_set *set,
 				const struct nft_set_elem *elem)
 {
-	struct nft_pipapo_elem *e = elem->priv;
+	struct nft_pipapo_elem *e = nft_elem_priv_cast(elem->priv);
 
 	nft_set_elem_change_active(net, set, &e->ext);
 }
@@ -1783,9 +1791,9 @@ static void *pipapo_deactivate(const struct net *net, const struct nft_set *set,
  *
  * Return: deactivated element if found, NULL otherwise.
  */
-static void *nft_pipapo_deactivate(const struct net *net,
-				   const struct nft_set *set,
-				   const struct nft_set_elem *elem)
+static struct nft_elem_priv *
+nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
+		      const struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 
@@ -1811,9 +1819,9 @@ static void *nft_pipapo_deactivate(const struct net *net,
  * Return: true if element was found and deactivated.
  */
 static void nft_pipapo_flush(const struct net *net, const struct nft_set *set,
-			     void *elem)
+			     struct nft_elem_priv *elem_priv)
 {
-	struct nft_pipapo_elem *e = elem;
+	struct nft_pipapo_elem *e = nft_elem_priv_cast(elem_priv);
 
 	nft_set_elem_change_active(net, set, &e->ext);
 }
@@ -1950,10 +1958,11 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m = priv->clone;
-	struct nft_pipapo_elem *e = elem->priv;
 	int rules_f0, first_rule = 0;
+	struct nft_pipapo_elem *e;
 	const u8 *data;
 
+	e = nft_elem_priv_cast(elem->priv);
 	data = (const u8 *)nft_set_ext_key(&e->ext);
 
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
@@ -2040,7 +2049,7 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 		e = f->mt[r].e;
 
-		elem.priv = e;
+		elem.priv = &e->priv;
 
 		iter->err = iter->fn(ctx, set, iter, &elem);
 		if (iter->err < 0)
@@ -2208,7 +2217,7 @@ static void nft_set_pipapo_match_destroy(const struct nft_ctx *ctx,
 
 		e = f->mt[r].e;
 
-		nf_tables_set_elem_destroy(ctx, set, e);
+		nf_tables_set_elem_destroy(ctx, set, &e->priv);
 	}
 }
 
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 2e164a319945..1040223da5fa 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -170,10 +170,12 @@ struct nft_pipapo_elem;
 
 /**
  * struct nft_pipapo_elem - API-facing representation of single set element
+ * @priv:	element placeholder
  * @ext:	nftables API extensions
  */
 struct nft_pipapo_elem {
-	struct nft_set_ext ext;
+	struct nft_elem_priv	priv;
+	struct nft_set_ext	ext;
 };
 
 int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index da7f0102ce75..8453a5c601a1 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -23,6 +23,7 @@ struct nft_rbtree {
 };
 
 struct nft_rbtree_elem {
+	struct nft_elem_priv	priv;
 	struct rb_node		node;
 	struct nft_set_ext	ext;
 };
@@ -197,8 +198,9 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	return false;
 }
 
-static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
-			    const struct nft_set_elem *elem, unsigned int flags)
+static struct nft_elem_priv *
+nft_rbtree_get(const struct net *net, const struct nft_set *set,
+	       const struct nft_set_elem *elem, unsigned int flags)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	unsigned int seq = read_seqcount_begin(&priv->count);
@@ -209,16 +211,17 @@ static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 	ret = __nft_rbtree_get(net, set, key, &rbe, seq, flags, genmask);
 	if (ret || !read_seqcount_retry(&priv->count, seq))
-		return rbe;
+		return &rbe->priv;
 
 	read_lock_bh(&priv->lock);
 	seq = read_seqcount_begin(&priv->count);
 	ret = __nft_rbtree_get(net, set, key, &rbe, seq, flags, genmask);
-	if (!ret)
-		rbe = ERR_PTR(-ENOENT);
 	read_unlock_bh(&priv->lock);
 
-	return rbe;
+	if (!ret)
+		return ERR_PTR(-ENOENT);
+
+	return &rbe->priv;
 }
 
 static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
@@ -226,7 +229,7 @@ static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
 				 struct nft_rbtree_elem *rbe)
 {
 	struct nft_set_elem elem = {
-		.priv	= rbe,
+		.priv	= &rbe->priv,
 	};
 
 	nft_setelem_data_deactivate(net, set, &elem);
@@ -487,8 +490,8 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			     const struct nft_set_elem *elem,
 			     struct nft_set_ext **ext)
 {
+	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
 	struct nft_rbtree *priv = nft_set_priv(set);
-	struct nft_rbtree_elem *rbe = elem->priv;
 	int err;
 
 	do {
@@ -511,8 +514,8 @@ static void nft_rbtree_remove(const struct net *net,
 			      const struct nft_set *set,
 			      const struct nft_set_elem *elem)
 {
+	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
 	struct nft_rbtree *priv = nft_set_priv(set);
-	struct nft_rbtree_elem *rbe = elem->priv;
 
 	write_lock_bh(&priv->lock);
 	write_seqcount_begin(&priv->count);
@@ -525,26 +528,27 @@ static void nft_rbtree_activate(const struct net *net,
 				const struct nft_set *set,
 				const struct nft_set_elem *elem)
 {
-	struct nft_rbtree_elem *rbe = elem->priv;
+	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
 
 	nft_set_elem_change_active(net, set, &rbe->ext);
 }
 
 static void nft_rbtree_flush(const struct net *net,
-			     const struct nft_set *set, void *priv)
+			     const struct nft_set *set,
+			     struct nft_elem_priv *elem_priv)
 {
-	struct nft_rbtree_elem *rbe = priv;
+	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem_priv);
 
 	nft_set_elem_change_active(net, set, &rbe->ext);
 }
 
-static void *nft_rbtree_deactivate(const struct net *net,
-				   const struct nft_set *set,
-				   const struct nft_set_elem *elem)
+static struct nft_elem_priv *
+nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
+		      const struct nft_set_elem *elem)
 {
+	struct nft_rbtree_elem *rbe, *this = nft_elem_priv_cast(elem->priv);
 	const struct nft_rbtree *priv = nft_set_priv(set);
 	const struct rb_node *parent = priv->root.rb_node;
-	struct nft_rbtree_elem *rbe, *this = elem->priv;
 	u8 genmask = nft_genmask_next(net);
 	int d;
 
@@ -572,8 +576,8 @@ static void *nft_rbtree_deactivate(const struct net *net,
 				parent = parent->rb_left;
 				continue;
 			}
-			nft_rbtree_flush(net, set, rbe);
-			return rbe;
+			nft_rbtree_flush(net, set, &rbe->priv);
+			return &rbe->priv;
 		}
 	}
 	return NULL;
@@ -597,7 +601,7 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 
-		elem.priv = rbe;
+		elem.priv = &rbe->priv;
 
 		iter->err = iter->fn(ctx, set, iter, &elem);
 		if (iter->err < 0) {
@@ -729,7 +733,7 @@ static void nft_rbtree_destroy(const struct nft_ctx *ctx,
 	while ((node = priv->root.rb_node) != NULL) {
 		rb_erase(node, &priv->root);
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
-		nf_tables_set_elem_destroy(ctx, set, rbe);
+		nf_tables_set_elem_destroy(ctx, set, &rbe->priv);
 	}
 }
 
-- 
2.30.2

