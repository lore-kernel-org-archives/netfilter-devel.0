Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0036C001E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jul 2023 11:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbjGYLZj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbjGYLZi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2023 07:25:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A270A187;
        Tue, 25 Jul 2023 04:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3246D61683;
        Tue, 25 Jul 2023 11:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3ABC433C7;
        Tue, 25 Jul 2023 11:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1690284335;
        bh=1MnVIuusv6+jg2IxeOSakk1k769CXW9DWG5EA8ehna8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtYekHh8wCUudU3uWGYLNn4v8Gve6khoirSWfIE9eVSLAy17q1vVLEFVH0zSQhwyw
         KsMC3yKi22T5wXmiSVCdX8s4aVaUQE2eTUBx/z46ibFrLFfIS1RycleFIEHrVRNFeT
         MIJ0d+P78oRQ/wUWCwkzr8ld1+oySGB2vdBht1OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 320/509] netfilter: nf_tables: drop map element references from preparation phase
Date:   Tue, 25 Jul 2023 12:44:19 +0200
Message-ID: <20230725104608.349925015@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 628bd3e49cba1c066228e23d71a852c23e26da73 ]

set .destroy callback releases the references to other objects in maps.
This is very late and it results in spurious EBUSY errors. Drop refcount
from the preparation phase instead, update set backend not to drop
reference counter from set .destroy path.

Exceptions: NFT_TRANS_PREPARE_ERROR does not require to drop the
reference counter because the transaction abort path releases the map
references for each element since the set is unbound. The abort path
also deals with releasing reference counter for new elements added to
unbound sets.

Fixes: 591054469b3e ("netfilter: nf_tables: revisit chain/object refcounting from elements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    5 +-
 net/netfilter/nf_tables_api.c     |   89 ++++++++++++++++++++++++++++++++++----
 net/netfilter/nft_set_bitmap.c    |    5 +-
 net/netfilter/nft_set_hash.c      |   23 +++++++--
 net/netfilter/nft_set_pipapo.c    |   14 +++--
 net/netfilter/nft_set_rbtree.c    |    5 +-
 6 files changed, 117 insertions(+), 24 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -382,7 +382,8 @@ struct nft_set_ops {
 	int				(*init)(const struct nft_set *set,
 						const struct nft_set_desc *desc,
 						const struct nlattr * const nla[]);
-	void				(*destroy)(const struct nft_set *set);
+	void				(*destroy)(const struct nft_ctx *ctx,
+						   const struct nft_set *set);
 	void				(*gc_init)(const struct nft_set *set);
 
 	unsigned int			elemsize;
@@ -686,6 +687,8 @@ void *nft_set_elem_init(const struct nft
 			u64 timeout, u64 expiration, gfp_t gfp);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr);
+void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
+				const struct nft_set *set, void *elem);
 
 /**
  *	struct nft_set_gc_batch_head - nf_tables set garbage collection batch
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -557,6 +557,31 @@ static int nft_trans_set_add(const struc
 	return 0;
 }
 
+static void nft_setelem_data_deactivate(const struct net *net,
+					const struct nft_set *set,
+					struct nft_set_elem *elem);
+
+static int nft_mapelem_deactivate(const struct nft_ctx *ctx,
+				  struct nft_set *set,
+				  const struct nft_set_iter *iter,
+				  struct nft_set_elem *elem)
+{
+	nft_setelem_data_deactivate(ctx->net, set, elem);
+
+	return 0;
+}
+
+static void nft_map_deactivate(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	struct nft_set_iter iter = {
+		.genmask	= nft_genmask_next(ctx->net),
+		.fn		= nft_mapelem_deactivate,
+	};
+
+	set->ops->walk(ctx, set, &iter);
+	WARN_ON_ONCE(iter.err);
+}
+
 static int nft_delset(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	int err;
@@ -565,6 +590,9 @@ static int nft_delset(const struct nft_c
 	if (err < 0)
 		return err;
 
+	if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+		nft_map_deactivate(ctx, set);
+
 	nft_deactivate_next(ctx->net, set);
 	ctx->table->use--;
 
@@ -4474,7 +4502,7 @@ err_set_expr_alloc:
 	if (set->expr)
 		nft_expr_destroy(&ctx, set->expr);
 
-	ops->destroy(set);
+	ops->destroy(&ctx, set);
 err_set_init:
 	kfree(set->name);
 err_set_name:
@@ -4490,7 +4518,7 @@ static void nft_set_destroy(const struct
 	if (set->expr)
 		nft_expr_destroy(ctx, set->expr);
 
-	set->ops->destroy(set);
+	set->ops->destroy(ctx, set);
 	kfree(set->name);
 	kvfree(set);
 }
@@ -4614,10 +4642,39 @@ static void nf_tables_unbind_set(const s
 	}
 }
 
+static void nft_setelem_data_activate(const struct net *net,
+				      const struct nft_set *set,
+				      struct nft_set_elem *elem);
+
+static int nft_mapelem_activate(const struct nft_ctx *ctx,
+				struct nft_set *set,
+				const struct nft_set_iter *iter,
+				struct nft_set_elem *elem)
+{
+	nft_setelem_data_activate(ctx->net, set, elem);
+
+	return 0;
+}
+
+static void nft_map_activate(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	struct nft_set_iter iter = {
+		.genmask	= nft_genmask_next(ctx->net),
+		.fn		= nft_mapelem_activate,
+	};
+
+	set->ops->walk(ctx, set, &iter);
+	WARN_ON_ONCE(iter.err);
+}
+
 void nf_tables_activate_set(const struct nft_ctx *ctx, struct nft_set *set)
 {
-	if (nft_set_is_anonymous(set))
+	if (nft_set_is_anonymous(set)) {
+		if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+			nft_map_activate(ctx, set);
+
 		nft_clear(ctx->net, set);
+	}
 
 	set->use++;
 }
@@ -4636,13 +4693,20 @@ void nf_tables_deactivate_set(const stru
 		set->use--;
 		break;
 	case NFT_TRANS_PREPARE:
-		if (nft_set_is_anonymous(set))
-			nft_deactivate_next(ctx->net, set);
+		if (nft_set_is_anonymous(set)) {
+			if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+				nft_map_deactivate(ctx, set);
 
+			nft_deactivate_next(ctx->net, set);
+		}
 		set->use--;
 		return;
 	case NFT_TRANS_ABORT:
 	case NFT_TRANS_RELEASE:
+		if (nft_set_is_anonymous(set) &&
+		    set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+			nft_map_deactivate(ctx, set);
+
 		set->use--;
 		fallthrough;
 	default:
@@ -5249,6 +5313,7 @@ static void nft_set_elem_expr_destroy(co
 	}
 }
 
+/* Drop references and destroy. Called from gc, dynset and abort path. */
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr)
 {
@@ -5270,11 +5335,11 @@ void nft_set_elem_destroy(const struct n
 }
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 
-/* Only called from commit path, nft_setelem_data_deactivate() already deals
- * with the refcounting from the preparation phase.
+/* Destroy element. References have been already dropped in the preparation
+ * path via nft_setelem_data_deactivate().
  */
-static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
-				       const struct nft_set *set, void *elem)
+void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
+				const struct nft_set *set, void *elem)
 {
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
 
@@ -8399,6 +8464,9 @@ static int __nf_tables_abort(struct net
 		case NFT_MSG_DELSET:
 			trans->ctx.table->use++;
 			nft_clear(trans->ctx.net, nft_trans_set(trans));
+			if (nft_trans_set(trans)->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+				nft_map_activate(&trans->ctx, nft_trans_set(trans));
+
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
@@ -9128,6 +9196,9 @@ static void __nft_release_table(struct n
 	list_for_each_entry_safe(set, ns, &table->sets, list) {
 		list_del(&set->list);
 		table->use--;
+		if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+			nft_map_deactivate(&ctx, set);
+
 		nft_set_destroy(&ctx, set);
 	}
 	list_for_each_entry_safe(obj, ne, &table->objects, list) {
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -270,13 +270,14 @@ static int nft_bitmap_init(const struct
 	return 0;
 }
 
-static void nft_bitmap_destroy(const struct nft_set *set)
+static void nft_bitmap_destroy(const struct nft_ctx *ctx,
+			       const struct nft_set *set)
 {
 	struct nft_bitmap *priv = nft_set_priv(set);
 	struct nft_bitmap_elem *be, *n;
 
 	list_for_each_entry_safe(be, n, &priv->list, head)
-		nft_set_elem_destroy(set, be, true);
+		nf_tables_set_elem_destroy(ctx, set, be);
 }
 
 static bool nft_bitmap_estimate(const struct nft_set_desc *desc, u32 features,
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -380,19 +380,31 @@ static int nft_rhash_init(const struct n
 	return 0;
 }
 
+struct nft_rhash_ctx {
+	const struct nft_ctx	ctx;
+	const struct nft_set	*set;
+};
+
 static void nft_rhash_elem_destroy(void *ptr, void *arg)
 {
-	nft_set_elem_destroy(arg, ptr, true);
+	struct nft_rhash_ctx *rhash_ctx = arg;
+
+	nf_tables_set_elem_destroy(&rhash_ctx->ctx, rhash_ctx->set, ptr);
 }
 
-static void nft_rhash_destroy(const struct nft_set *set)
+static void nft_rhash_destroy(const struct nft_ctx *ctx,
+			      const struct nft_set *set)
 {
 	struct nft_rhash *priv = nft_set_priv(set);
+	struct nft_rhash_ctx rhash_ctx = {
+		.ctx	= *ctx,
+		.set	= set,
+	};
 
 	cancel_delayed_work_sync(&priv->gc_work);
 	rcu_barrier();
 	rhashtable_free_and_destroy(&priv->ht, nft_rhash_elem_destroy,
-				    (void *)set);
+				    (void *)&rhash_ctx);
 }
 
 /* Number of buckets is stored in u32, so cap our result to 1U<<31 */
@@ -621,7 +633,8 @@ static int nft_hash_init(const struct nf
 	return 0;
 }
 
-static void nft_hash_destroy(const struct nft_set *set)
+static void nft_hash_destroy(const struct nft_ctx *ctx,
+			     const struct nft_set *set)
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	struct nft_hash_elem *he;
@@ -631,7 +644,7 @@ static void nft_hash_destroy(const struc
 	for (i = 0; i < priv->buckets; i++) {
 		hlist_for_each_entry_safe(he, next, &priv->table[i], node) {
 			hlist_del_rcu(&he->node);
-			nft_set_elem_destroy(set, he, true);
+			nf_tables_set_elem_destroy(ctx, set, he);
 		}
 	}
 }
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2127,10 +2127,12 @@ out_scratch:
 
 /**
  * nft_set_pipapo_match_destroy() - Destroy elements from key mapping array
+ * @ctx:	context
  * @set:	nftables API set representation
  * @m:		matching data pointing to key mapping array
  */
-static void nft_set_pipapo_match_destroy(const struct nft_set *set,
+static void nft_set_pipapo_match_destroy(const struct nft_ctx *ctx,
+					 const struct nft_set *set,
 					 struct nft_pipapo_match *m)
 {
 	struct nft_pipapo_field *f;
@@ -2147,15 +2149,17 @@ static void nft_set_pipapo_match_destroy
 
 		e = f->mt[r].e;
 
-		nft_set_elem_destroy(set, e, true);
+		nf_tables_set_elem_destroy(ctx, set, e);
 	}
 }
 
 /**
  * nft_pipapo_destroy() - Free private data for set and all committed elements
+ * @ctx:	context
  * @set:	nftables API set representation
  */
-static void nft_pipapo_destroy(const struct nft_set *set)
+static void nft_pipapo_destroy(const struct nft_ctx *ctx,
+			       const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m;
@@ -2165,7 +2169,7 @@ static void nft_pipapo_destroy(const str
 	if (m) {
 		rcu_barrier();
 
-		nft_set_pipapo_match_destroy(set, m);
+		nft_set_pipapo_match_destroy(ctx, set, m);
 
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(m->scratch_aligned);
@@ -2182,7 +2186,7 @@ static void nft_pipapo_destroy(const str
 		m = priv->clone;
 
 		if (priv->dirty)
-			nft_set_pipapo_match_destroy(set, m);
+			nft_set_pipapo_match_destroy(ctx, set, m);
 
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(priv->clone->scratch_aligned);
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -657,7 +657,8 @@ static int nft_rbtree_init(const struct
 	return 0;
 }
 
-static void nft_rbtree_destroy(const struct nft_set *set)
+static void nft_rbtree_destroy(const struct nft_ctx *ctx,
+			       const struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe;
@@ -668,7 +669,7 @@ static void nft_rbtree_destroy(const str
 	while ((node = priv->root.rb_node) != NULL) {
 		rb_erase(node, &priv->root);
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
-		nft_set_elem_destroy(set, rbe, true);
+		nf_tables_set_elem_destroy(ctx, set, rbe);
 	}
 }
 


