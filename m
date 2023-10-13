Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C85CDB47E
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Oct 2023 16:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbjJMQNX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Oct 2023 12:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbjJMQNS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Oct 2023 12:13:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A269459EA
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Oct 2023 09:12:09 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,RFC] netfilter: nf_tables: shrink memory consumption of set elements
Date:   Fri, 13 Oct 2023 18:09:24 +0200
Message-Id: <20231013160924.119273-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of copying struct nft_set_elem into struct nft_trans_elem, store
the pointer to the opaque set element object in the transaction. Adapt
set backend API (and set backend implementations) to take the pointer to
opaque set element representation whenever required.

This patch deconstifies .remove() and .activate() set backend API since these
modify the set element opaque object. And it also constify nft_set_elem_ext()
since this provides access to the nft_set_ext struct without updating the
object.

According to pahole on x86_64, this patch shrinks struct nft_trans_elem
size from 216 to 24 bytes.

This patch also reduces stack memory consumption by removing the
template struct nft_set_elem object which consumes 200 bytes of stack
memory according to pahole. Use the opaque set element object instead
from the set iterator API, catchall elements and the get element
command paths to benefit from this memory consumption reduction.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I tagged this as RFC because it based on nf.git, but targeted at
nf-next.git, because of missing dependencies, I have kept in here for a
while in my local pile waiting for the dependencies to land, but I
prefer to post it now for review. So it cannot be considered for
integration into the nf-next.git tree yet because of these details.

This patch depends on ("netfilter: nf_tables: do not remove elements if
set backend implements .abort") which will take time to propagate to
nf-next. This also slightly clashes with a other existing pending
patches for nf-next floating in the mailing list, but that should be
easy to fix with a rebase.

I started with an initial patch to make the const updates, but it is
triggering more churning than expected (since follow up patch will again
update the same line when changing from struct nft_set_elem to void).
I believe this patch should be relatively easy to review, but maybe
that is just my bias.

Main issue is (and it was still before patch) is that this opaque
object from the nf_tables frontend is void *, which makes it harder for
the compiler to catch stupid mistakes such as passing elem instead of
elem.priv or even &trans->elem, that is, type checking is defeated so
careful inspection is needed. Instrumention and existing tests also help
catch issues of course.

 include/net/netfilter/nf_tables.h |  28 +++--
 net/netfilter/nf_tables_api.c     | 188 +++++++++++++-----------------
 net/netfilter/nft_set_bitmap.c    |  17 +--
 net/netfilter/nft_set_hash.c      |  28 ++---
 net/netfilter/nft_set_pipapo.c    |  20 +---
 net/netfilter/nft_set_rbtree.c    |  21 ++--
 6 files changed, 125 insertions(+), 177 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 7c816359d5a9..ced9d2d18f8f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -306,7 +306,7 @@ struct nft_set_iter {
 	int		(*fn)(const struct nft_ctx *ctx,
 			      struct nft_set *set,
 			      const struct nft_set_iter *iter,
-			      struct nft_set_elem *elem);
+			      void *elem_priv);
 };
 
 /**
@@ -445,16 +445,16 @@ struct nft_set_ops {
 						  struct nft_set_ext **ext);
 	void				(*activate)(const struct net *net,
 						    const struct nft_set *set,
-						    const struct nft_set_elem *elem);
+						    void *elem_priv);
 	void *				(*deactivate)(const struct net *net,
 						      const struct nft_set *set,
 						      const struct nft_set_elem *elem);
 	bool				(*flush)(const struct net *net,
 						 const struct nft_set *set,
-						 void *priv);
+						 void *elem_priv);
 	void				(*remove)(const struct net *net,
 						  const struct nft_set *set,
-						  const struct nft_set_elem *elem);
+						  void *elem_priv);
 	void				(*walk)(const struct nft_ctx *ctx,
 						struct nft_set *set,
 						struct nft_set_iter *iter);
@@ -796,9 +796,9 @@ static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
 }
 
 static inline struct nft_set_ext *nft_set_elem_ext(const struct nft_set *set,
-						   void *elem)
+						   const void *elem)
 {
-	return elem + set->ops->elemsize;
+	return (struct nft_set_ext *)(elem + set->ops->elemsize);
 }
 
 static inline struct nft_object **nft_set_ext_obj(const struct nft_set_ext *ext)
@@ -816,10 +816,10 @@ void *nft_set_elem_init(const struct nft_set *set,
 			u64 timeout, u64 expiration, gfp_t gfp);
 int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_expr *expr_array[]);
-void nft_set_elem_destroy(const struct nft_set *set, void *elem,
+void nft_set_elem_destroy(const struct nft_set *set, const void *elem_priv,
 			  bool destroy_expr);
 void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
-				const struct nft_set *set, void *elem);
+				const struct nft_set *set, const void *elem);
 
 struct nft_expr_ops;
 /**
@@ -1060,8 +1060,7 @@ struct nft_chain {
 
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
-			 const struct nft_set_iter *iter,
-			 struct nft_set_elem *elem);
+			 const struct nft_set_iter *iter, void *elem_priv);
 int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
@@ -1635,14 +1634,14 @@ struct nft_trans_table {
 
 struct nft_trans_elem {
 	struct nft_set			*set;
-	struct nft_set_elem		elem;
+	void				*elem_priv;
 	bool				bound;
 };
 
 #define nft_trans_elem_set(trans)	\
 	(((struct nft_trans_elem *)trans->data)->set)
-#define nft_trans_elem(trans)	\
-	(((struct nft_trans_elem *)trans->data)->elem)
+#define nft_trans_elem_priv(trans)	\
+	(((struct nft_trans_elem *)trans->data)->elem_priv)
 #define nft_trans_elem_set_bound(trans)	\
 	(((struct nft_trans_elem *)trans->data)->bound)
 
@@ -1705,8 +1704,7 @@ struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
 struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc);
 
 void nft_setelem_data_deactivate(const struct net *net,
-				 const struct nft_set *set,
-				 struct nft_set_elem *elem);
+				 const struct nft_set *set, void *elem_priv);
 
 int __init nft_chain_filter_init(void);
 void nft_chain_filter_fini(void);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a623d31b6518..1e7ebfb42751 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -591,9 +591,9 @@ static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 static int nft_mapelem_deactivate(const struct nft_ctx *ctx,
 				  struct nft_set *set,
 				  const struct nft_set_iter *iter,
-				  struct nft_set_elem *elem)
+				  void *elem_priv)
 {
-	nft_setelem_data_deactivate(ctx->net, set, elem);
+	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 
 	return 0;
 }
@@ -609,7 +609,6 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 {
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set_elem_catchall *catchall;
-	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
@@ -617,8 +616,7 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
 
-		elem.priv = catchall->elem;
-		nft_setelem_data_deactivate(ctx->net, set, &elem);
+		nft_setelem_data_deactivate(ctx->net, set, catchall->elem);
 		break;
 	}
 }
@@ -3750,10 +3748,9 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 }
 
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
-			 const struct nft_set_iter *iter,
-			 struct nft_set_elem *elem)
+			 const struct nft_set_iter *iter, void *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
 	const struct nft_data *data;
 	int err;
@@ -3783,7 +3780,6 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set_elem_catchall *catchall;
-	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 	int ret = 0;
 
@@ -3792,8 +3788,7 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
 
-		elem.priv = catchall->elem;
-		ret = nft_setelem_validate(ctx, set, NULL, &elem);
+		ret = nft_setelem_validate(ctx, set, NULL, catchall->elem);
 		if (ret < 0)
 			return ret;
 	}
@@ -5242,10 +5237,9 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 				       unsigned int len);
 
 static int nft_setelem_data_validate(const struct nft_ctx *ctx,
-				     struct nft_set *set,
-				     struct nft_set_elem *elem)
+				     struct nft_set *set, void *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 	enum nft_registers dreg;
 
 	dreg = nft_type_to_reg(set->dtype);
@@ -5258,9 +5252,9 @@ static int nft_setelem_data_validate(const struct nft_ctx *ctx,
 static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
 					struct nft_set *set,
 					const struct nft_set_iter *iter,
-					struct nft_set_elem *elem)
+					void *elem_priv)
 {
-	return nft_setelem_data_validate(ctx, set, elem);
+	return nft_setelem_data_validate(ctx, set, elem_priv);
 }
 
 static int nft_set_catchall_bind_check(const struct nft_ctx *ctx,
@@ -5268,7 +5262,6 @@ static int nft_set_catchall_bind_check(const struct nft_ctx *ctx,
 {
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set_elem_catchall *catchall;
-	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 	int ret = 0;
 
@@ -5277,8 +5270,7 @@ static int nft_set_catchall_bind_check(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
 
-		elem.priv = catchall->elem;
-		ret = nft_setelem_data_validate(ctx, set, &elem);
+		ret = nft_setelem_data_validate(ctx, set, catchall->elem);
 		if (ret < 0)
 			break;
 	}
@@ -5345,14 +5337,14 @@ static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 
 static void nft_setelem_data_activate(const struct net *net,
 				      const struct nft_set *set,
-				      struct nft_set_elem *elem);
+				      void *elem_priv);
 
 static int nft_mapelem_activate(const struct nft_ctx *ctx,
 				struct nft_set *set,
 				const struct nft_set_iter *iter,
-				struct nft_set_elem *elem)
+				void *elem_priv)
 {
-	nft_setelem_data_activate(ctx->net, set, elem);
+	nft_setelem_data_activate(ctx->net, set, elem_priv);
 
 	return 0;
 }
@@ -5362,7 +5354,6 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 {
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set_elem_catchall *catchall;
-	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
@@ -5370,8 +5361,7 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
 
-		elem.priv = catchall->elem;
-		nft_setelem_data_activate(ctx->net, set, &elem);
+		nft_setelem_data_activate(ctx->net, set, catchall->elem);
 		break;
 	}
 }
@@ -5550,10 +5540,9 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
 static int nf_tables_fill_setelem(struct sk_buff *skb,
 				  const struct nft_set *set,
-				  const struct nft_set_elem *elem,
-				  bool reset)
+				  const void *elem_priv, bool reset)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
 
@@ -5639,16 +5628,16 @@ struct nft_set_dump_args {
 static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 				  struct nft_set *set,
 				  const struct nft_set_iter *iter,
-				  struct nft_set_elem *elem)
+				  void *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 	struct nft_set_dump_args *args;
 
 	if (nft_set_elem_expired(ext))
 		return 0;
 
 	args = container_of(iter, struct nft_set_dump_args, iter);
-	return nf_tables_fill_setelem(args->skb, set, elem, args->reset);
+	return nf_tables_fill_setelem(args->skb, set, elem_priv, args->reset);
 }
 
 static void audit_log_nft_set_reset(const struct nft_table *table,
@@ -5673,7 +5662,6 @@ static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_cur(net);
-	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 	int ret = 0;
 
@@ -5683,8 +5671,7 @@ static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
 		    nft_set_elem_expired(ext))
 			continue;
 
-		elem.priv = catchall->elem;
-		ret = nf_tables_fill_setelem(skb, set, &elem, reset);
+		ret = nf_tables_fill_setelem(skb, set, catchall->elem, reset);
 		if (reset && !ret)
 			audit_log_nft_set_reset(set->table, base_seq, 1);
 		break;
@@ -5809,7 +5796,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 				       const struct nft_ctx *ctx, u32 seq,
 				       u32 portid, int event, u16 flags,
 				       const struct nft_set *set,
-				       const struct nft_set_elem *elem,
+				       const void *elem_priv,
 				       bool reset)
 {
 	struct nlmsghdr *nlh;
@@ -5831,7 +5818,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	err = nf_tables_fill_setelem(skb, set, elem, reset);
+	err = nf_tables_fill_setelem(skb, set, elem_priv, reset);
 	if (err < 0)
 		goto nla_put_failure;
 
@@ -5981,7 +5968,7 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		return err;
 
 	err = nf_tables_fill_setelem_info(skb, ctx, ctx->seq, ctx->portid,
-					  NFT_MSG_NEWSETELEM, 0, set, &elem,
+					  NFT_MSG_NEWSETELEM, 0, set, elem.priv,
 					  reset);
 	if (err < 0)
 		goto err_fill_setelem;
@@ -6062,7 +6049,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 
 static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 				     const struct nft_set *set,
-				     const struct nft_set_elem *elem,
+				     const void *elem_priv,
 				     int event)
 {
 	struct nftables_pernet *nft_net;
@@ -6083,7 +6070,7 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 		flags |= ctx->flags & (NLM_F_CREATE | NLM_F_EXCL);
 
 	err = nf_tables_fill_setelem_info(skb, ctx, 0, portid, event, flags,
-					  set, elem, false);
+					  set, elem_priv, false);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -6226,10 +6213,10 @@ static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 }
 
 /* Drop references and destroy. Called from gc, dynset and abort path. */
-void nft_set_elem_destroy(const struct nft_set *set, void *elem,
+void nft_set_elem_destroy(const struct nft_set *set, const void *elem_priv,
 			  bool destroy_expr)
 {
-	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 	struct nft_ctx ctx = {
 		.net	= read_pnet(&set->net),
 		.family	= set->table->family,
@@ -6240,10 +6227,10 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
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
 
@@ -6251,14 +6238,15 @@ EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
  * path via nft_setelem_data_deactivate().
  */
 void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
-				const struct nft_set *set, void *elem)
+				const struct nft_set *set,
+				const void *elem_priv)
 {
-	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS))
 		nft_set_elem_expr_destroy(ctx, nft_set_ext_expr(ext));
 
-	kfree(elem);
+	kfree(elem_priv);
 }
 
 int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
@@ -6393,9 +6381,9 @@ static int nft_setelem_insert(const struct net *net,
 }
 
 static bool nft_setelem_is_catchall(const struct nft_set *set,
-				    const struct nft_set_elem *elem)
+				    const void *elem_priv)
 {
-	struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
 	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_CATCHALL)
@@ -6405,14 +6393,14 @@ static bool nft_setelem_is_catchall(const struct nft_set *set,
 }
 
 static void nft_setelem_activate(struct net *net, struct nft_set *set,
-				 struct nft_set_elem *elem)
+				 void *elem_priv)
 {
-	struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 
-	if (nft_setelem_is_catchall(set, elem)) {
+	if (nft_setelem_is_catchall(set, elem_priv)) {
 		nft_set_elem_change_active(net, set, ext);
 	} else {
-		set->ops->activate(net, set, elem);
+		set->ops->activate(net, set, elem_priv);
 	}
 }
 
@@ -6470,12 +6458,12 @@ static int nft_setelem_deactivate(const struct net *net,
 
 static void nft_setelem_catchall_remove(const struct net *net,
 					const struct nft_set *set,
-					const struct nft_set_elem *elem)
+					void *elem_priv)
 {
 	struct nft_set_elem_catchall *catchall, *next;
 
 	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
-		if (catchall->elem == elem->priv) {
+		if (catchall->elem == elem_priv) {
 			list_del_rcu(&catchall->list);
 			kfree_rcu(catchall, rcu);
 			break;
@@ -6484,13 +6472,12 @@ static void nft_setelem_catchall_remove(const struct net *net,
 }
 
 static void nft_setelem_remove(const struct net *net,
-			       const struct nft_set *set,
-			       const struct nft_set_elem *elem)
+			       const struct nft_set *set, void *elem_priv)
 {
-	if (nft_setelem_is_catchall(set, elem))
-		nft_setelem_catchall_remove(net, set, elem);
+	if (nft_setelem_is_catchall(set, elem_priv))
+		nft_setelem_catchall_remove(net, set, elem_priv);
 	else
-		set->ops->remove(net, set, elem);
+		set->ops->remove(net, set, elem_priv);
 }
 
 static bool nft_setelem_valid_key_end(const struct nft_set *set,
@@ -6858,12 +6845,12 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		}
 	}
 
-	nft_trans_elem(trans) = elem;
+	nft_trans_elem_priv(trans) = elem.priv;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 	return 0;
 
 err_set_full:
-	nft_setelem_remove(ctx->net, set, &elem);
+	nft_setelem_remove(ctx->net, set, elem.priv);
 err_element_clash:
 	kfree(trans);
 err_elem_free:
@@ -6962,9 +6949,9 @@ void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
 
 static void nft_setelem_data_activate(const struct net *net,
 				      const struct nft_set *set,
-				      struct nft_set_elem *elem)
+				      void *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_hold(nft_set_ext_data(ext), set->dtype);
@@ -6973,10 +6960,9 @@ static void nft_setelem_data_activate(const struct net *net,
 }
 
 void nft_setelem_data_deactivate(const struct net *net,
-				 const struct nft_set *set,
-				 struct nft_set_elem *elem)
+				 const struct nft_set *set, void *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_release(nft_set_ext_data(ext), set->dtype);
@@ -7061,9 +7047,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto fail_ops;
 
-	nft_setelem_data_deactivate(ctx->net, set, &elem);
+	nft_setelem_data_deactivate(ctx->net, set, elem.priv);
 
-	nft_trans_elem(trans) = elem;
+	nft_trans_elem_priv(trans) = elem.priv;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 	return 0;
 
@@ -7080,8 +7066,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 
 static int nft_setelem_flush(const struct nft_ctx *ctx,
 			     struct nft_set *set,
-			     const struct nft_set_iter *iter,
-			     struct nft_set_elem *elem)
+			     const struct nft_set_iter *iter, void *elem_priv)
 {
 	struct nft_trans *trans;
 	int err;
@@ -7091,15 +7076,15 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	if (!trans)
 		return -ENOMEM;
 
-	if (!set->ops->flush(ctx->net, set, elem->priv)) {
+	if (!set->ops->flush(ctx->net, set, elem_priv)) {
 		err = -ENOENT;
 		goto err1;
 	}
 	set->ndeact++;
 
-	nft_setelem_data_deactivate(ctx->net, set, elem);
+	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_set(trans) = set;
-	nft_trans_elem(trans) = *elem;
+	nft_trans_elem_priv(trans) = elem_priv;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
@@ -7109,8 +7094,7 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 }
 
 static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
-				    struct nft_set *set,
-				    struct nft_set_elem *elem)
+				    struct nft_set *set, void *elem_priv)
 {
 	struct nft_trans *trans;
 
@@ -7119,9 +7103,9 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 	if (!trans)
 		return -ENOMEM;
 
-	nft_setelem_data_deactivate(ctx->net, set, elem);
+	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_set(trans) = set;
-	nft_trans_elem(trans) = *elem;
+	nft_trans_elem_priv(trans) = elem_priv;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
@@ -7132,7 +7116,6 @@ static int nft_set_catchall_flush(const struct nft_ctx *ctx,
 {
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set_elem_catchall *catchall;
-	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 	int ret = 0;
 
@@ -7141,8 +7124,7 @@ static int nft_set_catchall_flush(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
 
-		elem.priv = catchall->elem;
-		ret = __nft_set_catchall_flush(ctx, set, &elem);
+		ret = __nft_set_catchall_flush(ctx, set, catchall->elem);
 		if (ret < 0)
 			break;
 		nft_set_elem_change_active(ctx->net, set, ext);
@@ -9221,7 +9203,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DESTROYSETELEM:
 		nf_tables_set_elem_destroy(&trans->ctx,
 					   nft_trans_elem_set(trans),
-					   nft_trans_elem(trans).priv);
+					   nft_trans_elem_priv(trans));
 		break;
 	case NFT_MSG_DELOBJ:
 	case NFT_MSG_DESTROYOBJ:
@@ -9454,12 +9436,8 @@ static void nft_trans_gc_setelem_remove(struct nft_ctx *ctx,
 	unsigned int i;
 
 	for (i = 0; i < trans->count; i++) {
-		struct nft_set_elem elem = {
-			.priv = priv[i],
-		};
-
-		nft_setelem_data_deactivate(ctx->net, trans->set, &elem);
-		nft_setelem_remove(ctx->net, trans->set, &elem);
+		nft_setelem_data_deactivate(ctx->net, trans->set, priv[i]);
+		nft_setelem_remove(ctx->net, trans->set, priv[i]);
 	}
 }
 
@@ -9472,20 +9450,20 @@ void nft_trans_gc_destroy(struct nft_trans_gc *trans)
 
 static void nft_trans_gc_trans_free(struct rcu_head *rcu)
 {
-	struct nft_set_elem elem = {};
 	struct nft_trans_gc *trans;
 	struct nft_ctx ctx = {};
+	void *elem_priv;
 	unsigned int i;
 
 	trans = container_of(rcu, struct nft_trans_gc, rcu);
 	ctx.net	= read_pnet(&trans->set->net);
 
 	for (i = 0; i < trans->count; i++) {
-		elem.priv = trans->priv[i];
-		if (!nft_setelem_is_catchall(trans->set, &elem))
+		elem_priv = trans->priv[i];
+		if (!nft_setelem_is_catchall(trans->set, elem_priv))
 			atomic_dec(&trans->set->nelems);
 
-		nf_tables_set_elem_destroy(&ctx, trans->set, elem.priv);
+		nf_tables_set_elem_destroy(&ctx, trans->set, elem_priv);
 	}
 
 	nft_trans_gc_destroy(trans);
@@ -10053,9 +10031,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			nft_setelem_activate(net, te->set, &te->elem);
+			nft_setelem_activate(net, te->set, te->elem_priv);
 			nf_tables_setelem_notify(&trans->ctx, te->set,
-						 &te->elem,
+						 te->elem_priv,
 						 NFT_MSG_NEWSETELEM);
 			if (te->set->ops->commit &&
 			    list_empty(&te->set->pending_update)) {
@@ -10069,10 +10047,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			te = (struct nft_trans_elem *)trans->data;
 
 			nf_tables_setelem_notify(&trans->ctx, te->set,
-						 &te->elem,
+						 te->elem_priv,
 						 trans->msg_type);
-			nft_setelem_remove(net, te->set, &te->elem);
-			if (!nft_setelem_is_catchall(te->set, &te->elem)) {
+			nft_setelem_remove(net, te->set, te->elem_priv);
+			if (!nft_setelem_is_catchall(te->set, te->elem_priv)) {
 				atomic_dec(&te->set->nelems);
 				te->set->ndeact--;
 			}
@@ -10192,7 +10170,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
-				     nft_trans_elem(trans).priv, true);
+				     nft_trans_elem_priv(trans), true);
 		break;
 	case NFT_MSG_NEWOBJ:
 		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans));
@@ -10340,10 +10318,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			}
 			te = (struct nft_trans_elem *)trans->data;
 			if (!te->set->ops->abort ||
-			    nft_setelem_is_catchall(te->set, &te->elem))
-				nft_setelem_remove(net, te->set, &te->elem);
+			    nft_setelem_is_catchall(te->set, te->elem_priv))
+				nft_setelem_remove(net, te->set, te->elem_priv);
 
-			if (!nft_setelem_is_catchall(te->set, &te->elem))
+			if (!nft_setelem_is_catchall(te->set, te->elem_priv))
 				atomic_dec(&te->set->nelems);
 
 			if (te->set->ops->abort &&
@@ -10356,9 +10334,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DESTROYSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			nft_setelem_data_activate(net, te->set, &te->elem);
-			nft_setelem_activate(net, te->set, &te->elem);
-			if (!nft_setelem_is_catchall(te->set, &te->elem))
+			nft_setelem_data_activate(net, te->set, te->elem_priv);
+			nft_setelem_activate(net, te->set, te->elem_priv);
+			if (!nft_setelem_is_catchall(te->set, te->elem_priv))
 				te->set->ndeact--;
 
 			if (te->set->ops->abort &&
@@ -10534,9 +10512,9 @@ static int nft_check_loops(const struct nft_ctx *ctx,
 static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
 					struct nft_set *set,
 					const struct nft_set_iter *iter,
-					struct nft_set_elem *elem)
+					void *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
 	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 1e5e7a181e0b..5cf0f44b45e8 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -144,12 +144,11 @@ static int nft_bitmap_insert(const struct net *net, const struct nft_set *set,
 	return 0;
 }
 
-static void nft_bitmap_remove(const struct net *net,
-			      const struct nft_set *set,
-			      const struct nft_set_elem *elem)
+static void nft_bitmap_remove(const struct net *net, const struct nft_set *set,
+			      void *elem_priv)
 {
 	struct nft_bitmap *priv = nft_set_priv(set);
-	struct nft_bitmap_elem *be = elem->priv;
+	struct nft_bitmap_elem *be = elem_priv;
 	u8 genmask = nft_genmask_next(net);
 	u32 idx, off;
 
@@ -160,11 +159,10 @@ static void nft_bitmap_remove(const struct net *net,
 }
 
 static void nft_bitmap_activate(const struct net *net,
-				const struct nft_set *set,
-				const struct nft_set_elem *elem)
+				const struct nft_set *set, void *elem_priv)
 {
 	struct nft_bitmap *priv = nft_set_priv(set);
-	struct nft_bitmap_elem *be = elem->priv;
+	struct nft_bitmap_elem *be = elem_priv;
 	u8 genmask = nft_genmask_next(net);
 	u32 idx, off;
 
@@ -218,7 +216,6 @@ static void nft_bitmap_walk(const struct nft_ctx *ctx,
 {
 	const struct nft_bitmap *priv = nft_set_priv(set);
 	struct nft_bitmap_elem *be;
-	struct nft_set_elem elem;
 
 	list_for_each_entry_rcu(be, &priv->list, head) {
 		if (iter->count < iter->skip)
@@ -226,9 +223,7 @@ static void nft_bitmap_walk(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(&be->ext, iter->genmask))
 			goto cont;
 
-		elem.priv = be;
-
-		iter->err = iter->fn(ctx, set, iter, &elem);
+		iter->err = iter->fn(ctx, set, iter, be);
 
 		if (iter->err < 0)
 			return;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 2013de934cef..2f9f436ad42e 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -185,9 +185,9 @@ static int nft_rhash_insert(const struct net *net, const struct nft_set *set,
 }
 
 static void nft_rhash_activate(const struct net *net, const struct nft_set *set,
-			       const struct nft_set_elem *elem)
+			       void *elem_priv)
 {
-	struct nft_rhash_elem *he = elem->priv;
+	struct nft_rhash_elem *he = elem_priv;
 
 	nft_set_elem_change_active(net, set, &he->ext);
 }
@@ -225,11 +225,10 @@ static void *nft_rhash_deactivate(const struct net *net,
 }
 
 static void nft_rhash_remove(const struct net *net,
-			     const struct nft_set *set,
-			     const struct nft_set_elem *elem)
+			     const struct nft_set *set, void *elem_priv)
 {
 	struct nft_rhash *priv = nft_set_priv(set);
-	struct nft_rhash_elem *he = elem->priv;
+	struct nft_rhash_elem *he = elem_priv;
 
 	rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params);
 }
@@ -260,7 +259,6 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_rhash *priv = nft_set_priv(set);
 	struct nft_rhash_elem *he;
 	struct rhashtable_iter hti;
-	struct nft_set_elem elem;
 
 	rhashtable_walk_enter(&priv->ht, &hti);
 	rhashtable_walk_start(&hti);
@@ -280,9 +278,7 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 		if (!nft_set_elem_active(&he->ext, iter->genmask))
 			goto cont;
 
-		elem.priv = he;
-
-		iter->err = iter->fn(ctx, set, iter, &elem);
+		iter->err = iter->fn(ctx, set, iter, he);
 		if (iter->err < 0)
 			break;
 
@@ -583,9 +579,9 @@ static int nft_hash_insert(const struct net *net, const struct nft_set *set,
 }
 
 static void nft_hash_activate(const struct net *net, const struct nft_set *set,
-			      const struct nft_set_elem *elem)
+			      void *elem_priv)
 {
-	struct nft_hash_elem *he = elem->priv;
+	struct nft_hash_elem *he = elem_priv;
 
 	nft_set_elem_change_active(net, set, &he->ext);
 }
@@ -621,10 +617,9 @@ static void *nft_hash_deactivate(const struct net *net,
 }
 
 static void nft_hash_remove(const struct net *net,
-			    const struct nft_set *set,
-			    const struct nft_set_elem *elem)
+			    const struct nft_set *set, void *elem_priv)
 {
-	struct nft_hash_elem *he = elem->priv;
+	struct nft_hash_elem *he = elem_priv;
 
 	hlist_del_rcu(&he->node);
 }
@@ -634,7 +629,6 @@ static void nft_hash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	struct nft_hash_elem *he;
-	struct nft_set_elem elem;
 	int i;
 
 	for (i = 0; i < priv->buckets; i++) {
@@ -644,9 +638,7 @@ static void nft_hash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 			if (!nft_set_elem_active(&he->ext, iter->genmask))
 				goto cont;
 
-			elem.priv = he;
-
-			iter->err = iter->fn(ctx, set, iter, &elem);
+			iter->err = iter->fn(ctx, set, iter, he);
 			if (iter->err < 0)
 				return;
 cont:
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index c0dcc40de358..edc2386914d2 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1540,11 +1540,7 @@ static void nft_pipapo_gc_deactivate(struct net *net, struct nft_set *set,
 				     struct nft_pipapo_elem *e)
 
 {
-	struct nft_set_elem elem = {
-		.priv	= e,
-	};
-
-	nft_setelem_data_deactivate(net, set, &elem);
+	nft_setelem_data_deactivate(net, set, e);
 }
 
 /**
@@ -1740,10 +1736,9 @@ static void nft_pipapo_abort(const struct nft_set *set)
  * element, hence we can't purpose either one as a real commit operation.
  */
 static void nft_pipapo_activate(const struct net *net,
-				const struct nft_set *set,
-				const struct nft_set_elem *elem)
+				const struct nft_set *set, void *elem_priv)
 {
-	struct nft_pipapo_elem *e = elem->priv;
+	struct nft_pipapo_elem *e = elem_priv;
 
 	nft_set_elem_change_active(net, set, &e->ext);
 }
@@ -1947,11 +1942,11 @@ static bool pipapo_match_field(struct nft_pipapo_field *f,
  * the matched element here, if any, and commit the updated matching data.
  */
 static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
-			      const struct nft_set_elem *elem)
+			      void *elem_priv)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m = priv->clone;
-	struct nft_pipapo_elem *e = elem->priv;
+	struct nft_pipapo_elem *e = elem_priv;
 	int rules_f0, first_rule = 0;
 	const u8 *data;
 
@@ -2031,7 +2026,6 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 	for (r = 0; r < f->rules; r++) {
 		struct nft_pipapo_elem *e;
-		struct nft_set_elem elem;
 
 		if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
 			continue;
@@ -2041,9 +2035,7 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 		e = f->mt[r].e;
 
-		elem.priv = e;
-
-		iter->err = iter->fn(ctx, set, iter, &elem);
+		iter->err = iter->fn(ctx, set, iter, e);
 		if (iter->err < 0)
 			goto out;
 
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 2660ceab3759..71d1cd235716 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -225,11 +225,9 @@ static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
 				 struct nft_rbtree *priv,
 				 struct nft_rbtree_elem *rbe)
 {
-	struct nft_set_elem elem = {
-		.priv	= rbe,
-	};
+	void *elem_priv = (void *)rbe;
 
-	nft_setelem_data_deactivate(net, set, &elem);
+	nft_setelem_data_deactivate(net, set, elem_priv);
 	rb_erase(&rbe->node, &priv->root);
 }
 
@@ -508,11 +506,10 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 }
 
 static void nft_rbtree_remove(const struct net *net,
-			      const struct nft_set *set,
-			      const struct nft_set_elem *elem)
+			      const struct nft_set *set, void *elem_priv)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
-	struct nft_rbtree_elem *rbe = elem->priv;
+	struct nft_rbtree_elem *rbe = elem_priv;
 
 	write_lock_bh(&priv->lock);
 	write_seqcount_begin(&priv->count);
@@ -522,10 +519,9 @@ static void nft_rbtree_remove(const struct net *net,
 }
 
 static void nft_rbtree_activate(const struct net *net,
-				const struct nft_set *set,
-				const struct nft_set_elem *elem)
+				const struct nft_set *set, void *elem_priv)
 {
-	struct nft_rbtree_elem *rbe = elem->priv;
+	struct nft_rbtree_elem *rbe = elem_priv;
 
 	nft_set_elem_change_active(net, set, &rbe->ext);
 }
@@ -585,7 +581,6 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe;
-	struct nft_set_elem elem;
 	struct rb_node *node;
 
 	read_lock_bh(&priv->lock);
@@ -597,9 +592,7 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 
-		elem.priv = rbe;
-
-		iter->err = iter->fn(ctx, set, iter, &elem);
+		iter->err = iter->fn(ctx, set, iter, rbe);
 		if (iter->err < 0) {
 			read_unlock_bh(&priv->lock);
 			return;
-- 
2.30.2

