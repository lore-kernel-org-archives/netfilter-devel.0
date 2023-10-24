Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7C3C00A8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 08:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbjJXIeZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 04:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbjJXIeM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 04:34:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C863120
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 01:34:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 4/5] netfilter: nf_tables: shrink memory consumption of set elements
Date:   Tue, 24 Oct 2023 10:33:58 +0200
Message-Id: <20231024083359.24742-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231024083359.24742-1-pablo@netfilter.org>
References: <20231024083359.24742-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of copying struct nft_set_elem into struct nft_trans_elem, store
the pointer to the opaque set element object in the transaction. Adapt
set backend API (and set backend implementations) to take the pointer to
opaque set element representation whenever required.

This patch deconstifies .remove() and .activate() set backend API since
these modify the set element opaque object. And it also constify
nft_set_elem_ext() this provides access to the nft_set_ext struct
without updating the object.

According to pahole on x86_64, this patch shrinks struct nft_trans_elem
size from 216 to 24 bytes.

This patch also reduces stack memory consumption by removing the
template struct nft_set_elem object, using the opaque set element object
instead such as from the set iterator API, catchall elements and the get
element command.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  18 ++--
 net/netfilter/nf_tables_api.c     | 166 ++++++++++++++----------------
 net/netfilter/nft_set_bitmap.c    |  16 ++-
 net/netfilter/nft_set_hash.c      |  26 ++---
 net/netfilter/nft_set_pipapo.c    |  25 ++---
 net/netfilter/nft_set_rbtree.c    |  19 ++--
 6 files changed, 115 insertions(+), 155 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d287a778be65..b63f35fb2a99 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -314,7 +314,7 @@ struct nft_set_iter {
 	int		(*fn)(const struct nft_ctx *ctx,
 			      struct nft_set *set,
 			      const struct nft_set_iter *iter,
-			      struct nft_set_elem *elem);
+			      struct nft_elem_priv *elem_priv);
 };
 
 /**
@@ -454,7 +454,7 @@ struct nft_set_ops {
 						  struct nft_set_ext **ext);
 	void				(*activate)(const struct net *net,
 						    const struct nft_set *set,
-						    const struct nft_set_elem *elem);
+						    struct nft_elem_priv *elem_priv);
 	struct nft_elem_priv *		(*deactivate)(const struct net *net,
 						      const struct nft_set *set,
 						      const struct nft_set_elem *elem);
@@ -463,7 +463,7 @@ struct nft_set_ops {
 						 struct nft_elem_priv *priv);
 	void				(*remove)(const struct net *net,
 						  const struct nft_set *set,
-						  const struct nft_set_elem *elem);
+						  struct nft_elem_priv *elem_priv);
 	void				(*walk)(const struct nft_ctx *ctx,
 						struct nft_set *set,
 						struct nft_set_iter *iter);
@@ -1073,7 +1073,7 @@ struct nft_chain {
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 			 const struct nft_set_iter *iter,
-			 struct nft_set_elem *elem);
+			 struct nft_elem_priv *elem_priv);
 int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
@@ -1650,14 +1650,14 @@ struct nft_trans_table {
 
 struct nft_trans_elem {
 	struct nft_set			*set;
-	struct nft_set_elem		elem;
+	struct nft_elem_priv		*elem_priv;
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
 
@@ -1698,7 +1698,7 @@ struct nft_trans_gc {
 	struct nft_set		*set;
 	u32			seq;
 	u16			count;
-	void			*priv[NFT_TRANS_GC_BATCHCOUNT];
+	struct nft_elem_priv	*priv[NFT_TRANS_GC_BATCHCOUNT];
 	struct rcu_head		rcu;
 };
 
@@ -1721,7 +1721,7 @@ struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc);
 
 void nft_setelem_data_deactivate(const struct net *net,
 				 const struct nft_set *set,
-				 struct nft_set_elem *elem);
+				 struct nft_elem_priv *elem_priv);
 
 int __init nft_chain_filter_init(void);
 void nft_chain_filter_fini(void);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4ff942eff406..3b47f321e65b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -591,9 +591,9 @@ static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 static int nft_mapelem_deactivate(const struct nft_ctx *ctx,
 				  struct nft_set *set,
 				  const struct nft_set_iter *iter,
-				  struct nft_set_elem *elem)
+				  struct nft_elem_priv *elem_priv)
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
@@ -3733,9 +3731,9 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 			 const struct nft_set_iter *iter,
-			 struct nft_set_elem *elem)
+			 struct nft_elem_priv *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
 	const struct nft_data *data;
 	int err;
@@ -3765,7 +3763,6 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set_elem_catchall *catchall;
-	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 	int ret = 0;
 
@@ -3774,8 +3771,7 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
 
-		elem.priv = catchall->elem;
-		ret = nft_setelem_validate(ctx, set, NULL, &elem);
+		ret = nft_setelem_validate(ctx, set, NULL, catchall->elem);
 		if (ret < 0)
 			return ret;
 	}
@@ -5227,9 +5223,9 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 
 static int nft_setelem_data_validate(const struct nft_ctx *ctx,
 				     struct nft_set *set,
-				     struct nft_set_elem *elem)
+				     struct nft_elem_priv *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 	enum nft_registers dreg;
 
 	dreg = nft_type_to_reg(set->dtype);
@@ -5242,9 +5238,9 @@ static int nft_setelem_data_validate(const struct nft_ctx *ctx,
 static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
 					struct nft_set *set,
 					const struct nft_set_iter *iter,
-					struct nft_set_elem *elem)
+					struct nft_elem_priv *elem_priv)
 {
-	return nft_setelem_data_validate(ctx, set, elem);
+	return nft_setelem_data_validate(ctx, set, elem_priv);
 }
 
 static int nft_set_catchall_bind_check(const struct nft_ctx *ctx,
@@ -5252,7 +5248,6 @@ static int nft_set_catchall_bind_check(const struct nft_ctx *ctx,
 {
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set_elem_catchall *catchall;
-	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 	int ret = 0;
 
@@ -5261,8 +5256,7 @@ static int nft_set_catchall_bind_check(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
 
-		elem.priv = catchall->elem;
-		ret = nft_setelem_data_validate(ctx, set, &elem);
+		ret = nft_setelem_data_validate(ctx, set, catchall->elem);
 		if (ret < 0)
 			break;
 	}
@@ -5329,14 +5323,14 @@ static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 
 static void nft_setelem_data_activate(const struct net *net,
 				      const struct nft_set *set,
-				      struct nft_set_elem *elem);
+				      struct nft_elem_priv *elem_priv);
 
 static int nft_mapelem_activate(const struct nft_ctx *ctx,
 				struct nft_set *set,
 				const struct nft_set_iter *iter,
-				struct nft_set_elem *elem)
+				struct nft_elem_priv *elem_priv)
 {
-	nft_setelem_data_activate(ctx->net, set, elem);
+	nft_setelem_data_activate(ctx->net, set, elem_priv);
 
 	return 0;
 }
@@ -5346,7 +5340,6 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 {
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set_elem_catchall *catchall;
-	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
@@ -5354,8 +5347,7 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
 
-		elem.priv = catchall->elem;
-		nft_setelem_data_activate(ctx->net, set, &elem);
+		nft_setelem_data_activate(ctx->net, set, catchall->elem);
 		break;
 	}
 }
@@ -5534,10 +5526,10 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
 static int nf_tables_fill_setelem(struct sk_buff *skb,
 				  const struct nft_set *set,
-				  const struct nft_set_elem *elem,
+				  const struct nft_elem_priv *elem_priv,
 				  bool reset)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
 
@@ -5623,16 +5615,16 @@ struct nft_set_dump_args {
 static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 				  struct nft_set *set,
 				  const struct nft_set_iter *iter,
-				  struct nft_set_elem *elem)
+				  struct nft_elem_priv *elem_priv)
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
@@ -5657,7 +5649,6 @@ static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_cur(net);
-	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 	int ret = 0;
 
@@ -5667,8 +5658,7 @@ static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
 		    nft_set_elem_expired(ext))
 			continue;
 
-		elem.priv = catchall->elem;
-		ret = nf_tables_fill_setelem(skb, set, &elem, reset);
+		ret = nf_tables_fill_setelem(skb, set, catchall->elem, reset);
 		if (reset && !ret)
 			audit_log_nft_set_reset(set->table, base_seq, 1);
 		break;
@@ -5793,7 +5783,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 				       const struct nft_ctx *ctx, u32 seq,
 				       u32 portid, int event, u16 flags,
 				       const struct nft_set *set,
-				       const struct nft_set_elem *elem,
+				       const struct nft_elem_priv *elem_priv,
 				       bool reset)
 {
 	struct nlmsghdr *nlh;
@@ -5815,7 +5805,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	err = nf_tables_fill_setelem(skb, set, elem, reset);
+	err = nf_tables_fill_setelem(skb, set, elem_priv, reset);
 	if (err < 0)
 		goto nla_put_failure;
 
@@ -5965,7 +5955,7 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		return err;
 
 	err = nf_tables_fill_setelem_info(skb, ctx, ctx->seq, ctx->portid,
-					  NFT_MSG_NEWSETELEM, 0, set, &elem,
+					  NFT_MSG_NEWSETELEM, 0, set, elem.priv,
 					  reset);
 	if (err < 0)
 		goto err_fill_setelem;
@@ -6048,7 +6038,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 
 static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 				     const struct nft_set *set,
-				     const struct nft_set_elem *elem,
+				     const struct nft_elem_priv *elem_priv,
 				     int event)
 {
 	struct nftables_pernet *nft_net;
@@ -6069,7 +6059,7 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 		flags |= ctx->flags & (NLM_F_CREATE | NLM_F_EXCL);
 
 	err = nf_tables_fill_setelem_info(skb, ctx, 0, portid, event, flags,
-					  set, elem, false);
+					  set, elem_priv, false);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -6382,9 +6372,9 @@ static int nft_setelem_insert(const struct net *net,
 }
 
 static bool nft_setelem_is_catchall(const struct nft_set *set,
-				    const struct nft_set_elem *elem)
+				    const struct nft_elem_priv *elem_priv)
 {
-	struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
 	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_CATCHALL)
@@ -6394,14 +6384,14 @@ static bool nft_setelem_is_catchall(const struct nft_set *set,
 }
 
 static void nft_setelem_activate(struct net *net, struct nft_set *set,
-				 struct nft_set_elem *elem)
+				 struct nft_elem_priv *elem_priv)
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
 
@@ -6459,12 +6449,12 @@ static int nft_setelem_deactivate(const struct net *net,
 
 static void nft_setelem_catchall_remove(const struct net *net,
 					const struct nft_set *set,
-					const struct nft_set_elem *elem)
+					struct nft_elem_priv *elem_priv)
 {
 	struct nft_set_elem_catchall *catchall, *next;
 
 	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
-		if (catchall->elem == elem->priv) {
+		if (catchall->elem == elem_priv) {
 			list_del_rcu(&catchall->list);
 			kfree_rcu(catchall, rcu);
 			break;
@@ -6474,12 +6464,12 @@ static void nft_setelem_catchall_remove(const struct net *net,
 
 static void nft_setelem_remove(const struct net *net,
 			       const struct nft_set *set,
-			       const struct nft_set_elem *elem)
+			       struct nft_elem_priv *elem_priv)
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
@@ -6847,12 +6837,12 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -6953,9 +6943,9 @@ void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
 
 static void nft_setelem_data_activate(const struct net *net,
 				      const struct nft_set *set,
-				      struct nft_set_elem *elem)
+				      struct nft_elem_priv *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_hold(nft_set_ext_data(ext), set->dtype);
@@ -6965,9 +6955,9 @@ static void nft_setelem_data_activate(const struct net *net,
 
 void nft_setelem_data_deactivate(const struct net *net,
 				 const struct nft_set *set,
-				 struct nft_set_elem *elem)
+				 struct nft_elem_priv *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_release(nft_set_ext_data(ext), set->dtype);
@@ -7052,9 +7042,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto fail_ops;
 
-	nft_setelem_data_deactivate(ctx->net, set, &elem);
+	nft_setelem_data_deactivate(ctx->net, set, elem.priv);
 
-	nft_trans_elem(trans) = elem;
+	nft_trans_elem_priv(trans) = elem.priv;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 	return 0;
 
@@ -7072,7 +7062,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 static int nft_setelem_flush(const struct nft_ctx *ctx,
 			     struct nft_set *set,
 			     const struct nft_set_iter *iter,
-			     struct nft_set_elem *elem)
+			     struct nft_elem_priv *elem_priv)
 {
 	struct nft_trans *trans;
 
@@ -7081,12 +7071,12 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	if (!trans)
 		return -ENOMEM;
 
-	set->ops->flush(ctx->net, set, elem->priv);
+	set->ops->flush(ctx->net, set, elem_priv);
 	set->ndeact++;
 
-	nft_setelem_data_deactivate(ctx->net, set, elem);
+	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_set(trans) = set;
-	nft_trans_elem(trans) = *elem;
+	nft_trans_elem_priv(trans) = elem_priv;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
@@ -7094,7 +7084,7 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 
 static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 				    struct nft_set *set,
-				    struct nft_set_elem *elem)
+				    struct nft_elem_priv *elem_priv)
 {
 	struct nft_trans *trans;
 
@@ -7103,9 +7093,9 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 	if (!trans)
 		return -ENOMEM;
 
-	nft_setelem_data_deactivate(ctx->net, set, elem);
+	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_set(trans) = set;
-	nft_trans_elem(trans) = *elem;
+	nft_trans_elem_priv(trans) = elem_priv;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
@@ -7116,7 +7106,6 @@ static int nft_set_catchall_flush(const struct nft_ctx *ctx,
 {
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set_elem_catchall *catchall;
-	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 	int ret = 0;
 
@@ -7125,8 +7114,7 @@ static int nft_set_catchall_flush(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
 
-		elem.priv = catchall->elem;
-		ret = __nft_set_catchall_flush(ctx, set, &elem);
+		ret = __nft_set_catchall_flush(ctx, set, catchall->elem);
 		if (ret < 0)
 			break;
 		nft_set_elem_change_active(ctx->net, set, ext);
@@ -9218,7 +9206,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DESTROYSETELEM:
 		nf_tables_set_elem_destroy(&trans->ctx,
 					   nft_trans_elem_set(trans),
-					   nft_trans_elem(trans).priv);
+					   nft_trans_elem_priv(trans));
 		break;
 	case NFT_MSG_DELOBJ:
 	case NFT_MSG_DESTROYOBJ:
@@ -9447,16 +9435,12 @@ void nft_chain_del(struct nft_chain *chain)
 static void nft_trans_gc_setelem_remove(struct nft_ctx *ctx,
 					struct nft_trans_gc *trans)
 {
-	void **priv = trans->priv;
+	struct nft_elem_priv **priv = trans->priv;
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
 
@@ -9469,7 +9453,7 @@ void nft_trans_gc_destroy(struct nft_trans_gc *trans)
 
 static void nft_trans_gc_trans_free(struct rcu_head *rcu)
 {
-	struct nft_set_elem elem = {};
+	struct nft_elem_priv *elem_priv;
 	struct nft_trans_gc *trans;
 	struct nft_ctx ctx = {};
 	unsigned int i;
@@ -9478,11 +9462,11 @@ static void nft_trans_gc_trans_free(struct rcu_head *rcu)
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
@@ -10050,9 +10034,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -10066,10 +10050,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -10189,7 +10173,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
-				     nft_trans_elem(trans).priv, true);
+				     nft_trans_elem_priv(trans), true);
 		break;
 	case NFT_MSG_NEWOBJ:
 		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans));
@@ -10336,8 +10320,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				break;
 			}
 			te = (struct nft_trans_elem *)trans->data;
-			nft_setelem_remove(net, te->set, &te->elem);
-			if (!nft_setelem_is_catchall(te->set, &te->elem))
+			nft_setelem_remove(net, te->set, te->elem_priv);
+			if (!nft_setelem_is_catchall(te->set, te->elem_priv))
 				atomic_dec(&te->set->nelems);
 
 			if (te->set->ops->abort &&
@@ -10350,9 +10334,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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
@@ -10528,9 +10512,9 @@ static int nft_check_loops(const struct nft_ctx *ctx,
 static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
 					struct nft_set *set,
 					const struct nft_set_iter *iter,
-					struct nft_set_elem *elem)
+					struct nft_elem_priv *elem_priv)
 {
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
 	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index a320e7614aaa..963edb514641 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -146,11 +146,10 @@ static int nft_bitmap_insert(const struct net *net, const struct nft_set *set,
 	return 0;
 }
 
-static void nft_bitmap_remove(const struct net *net,
-			      const struct nft_set *set,
-			      const struct nft_set_elem *elem)
+static void nft_bitmap_remove(const struct net *net, const struct nft_set *set,
+			      struct nft_elem_priv *elem_priv)
 {
-	struct nft_bitmap_elem *be = nft_elem_priv_cast(elem->priv);
+	struct nft_bitmap_elem *be = nft_elem_priv_cast(elem_priv);
 	struct nft_bitmap *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	u32 idx, off;
@@ -163,9 +162,9 @@ static void nft_bitmap_remove(const struct net *net,
 
 static void nft_bitmap_activate(const struct net *net,
 				const struct nft_set *set,
-				const struct nft_set_elem *elem)
+				struct nft_elem_priv *elem_priv)
 {
-	struct nft_bitmap_elem *be = nft_elem_priv_cast(elem->priv);
+	struct nft_bitmap_elem *be = nft_elem_priv_cast(elem_priv);
 	struct nft_bitmap *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	u32 idx, off;
@@ -219,7 +218,6 @@ static void nft_bitmap_walk(const struct nft_ctx *ctx,
 {
 	const struct nft_bitmap *priv = nft_set_priv(set);
 	struct nft_bitmap_elem *be;
-	struct nft_set_elem elem;
 
 	list_for_each_entry_rcu(be, &priv->list, head) {
 		if (iter->count < iter->skip)
@@ -227,9 +225,7 @@ static void nft_bitmap_walk(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(&be->ext, iter->genmask))
 			goto cont;
 
-		elem.priv = &be->priv;
-
-		iter->err = iter->fn(ctx, set, iter, &elem);
+		iter->err = iter->fn(ctx, set, iter, &be->priv);
 
 		if (iter->err < 0)
 			return;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 0691565caa81..e6c00891e334 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -190,9 +190,9 @@ static int nft_rhash_insert(const struct net *net, const struct nft_set *set,
 }
 
 static void nft_rhash_activate(const struct net *net, const struct nft_set *set,
-			       const struct nft_set_elem *elem)
+			       struct nft_elem_priv *elem_priv)
 {
-	struct nft_rhash_elem *he = nft_elem_priv_cast(elem->priv);
+	struct nft_rhash_elem *he = nft_elem_priv_cast(elem_priv);
 
 	nft_set_elem_change_active(net, set, &he->ext);
 }
@@ -230,9 +230,9 @@ nft_rhash_deactivate(const struct net *net, const struct nft_set *set,
 
 static void nft_rhash_remove(const struct net *net,
 			     const struct nft_set *set,
-			     const struct nft_set_elem *elem)
+			     struct nft_elem_priv *elem_priv)
 {
-	struct nft_rhash_elem *he = nft_elem_priv_cast(elem->priv);
+	struct nft_rhash_elem *he = nft_elem_priv_cast(elem_priv);
 	struct nft_rhash *priv = nft_set_priv(set);
 
 	rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params);
@@ -264,7 +264,6 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_rhash *priv = nft_set_priv(set);
 	struct nft_rhash_elem *he;
 	struct rhashtable_iter hti;
-	struct nft_set_elem elem;
 
 	rhashtable_walk_enter(&priv->ht, &hti);
 	rhashtable_walk_start(&hti);
@@ -284,9 +283,7 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 		if (!nft_set_elem_active(&he->ext, iter->genmask))
 			goto cont;
 
-		elem.priv = &he->priv;
-
-		iter->err = iter->fn(ctx, set, iter, &elem);
+		iter->err = iter->fn(ctx, set, iter, &he->priv);
 		if (iter->err < 0)
 			break;
 
@@ -592,9 +589,9 @@ static int nft_hash_insert(const struct net *net, const struct nft_set *set,
 }
 
 static void nft_hash_activate(const struct net *net, const struct nft_set *set,
-			      const struct nft_set_elem *elem)
+			      struct nft_elem_priv *elem_priv)
 {
-	struct nft_hash_elem *he = nft_elem_priv_cast(elem->priv);
+	struct nft_hash_elem *he = nft_elem_priv_cast(elem_priv);
 
 	nft_set_elem_change_active(net, set, &he->ext);
 }
@@ -631,9 +628,9 @@ nft_hash_deactivate(const struct net *net, const struct nft_set *set,
 
 static void nft_hash_remove(const struct net *net,
 			    const struct nft_set *set,
-			    const struct nft_set_elem *elem)
+			    struct nft_elem_priv *elem_priv)
 {
-	struct nft_hash_elem *he = nft_elem_priv_cast(elem->priv);
+	struct nft_hash_elem *he = nft_elem_priv_cast(elem_priv);
 
 	hlist_del_rcu(&he->node);
 }
@@ -643,7 +640,6 @@ static void nft_hash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	struct nft_hash_elem *he;
-	struct nft_set_elem elem;
 	int i;
 
 	for (i = 0; i < priv->buckets; i++) {
@@ -653,9 +649,7 @@ static void nft_hash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 			if (!nft_set_elem_active(&he->ext, iter->genmask))
 				goto cont;
 
-			elem.priv = &he->priv;
-
-			iter->err = iter->fn(ctx, set, iter, &elem);
+			iter->err = iter->fn(ctx, set, iter, &he->priv);
 			if (iter->err < 0)
 				return;
 cont:
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 0969d2cb637b..f540c2be0caa 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1548,11 +1548,7 @@ static void nft_pipapo_gc_deactivate(struct net *net, struct nft_set *set,
 				     struct nft_pipapo_elem *e)
 
 {
-	struct nft_set_elem elem = {
-		.priv	= &e->priv,
-	};
-
-	nft_setelem_data_deactivate(net, set, &elem);
+	nft_setelem_data_deactivate(net, set, &e->priv);
 }
 
 /**
@@ -1739,7 +1735,7 @@ static void nft_pipapo_abort(const struct nft_set *set)
  * nft_pipapo_activate() - Mark element reference as active given key, commit
  * @net:	Network namespace
  * @set:	nftables API set representation
- * @elem:	nftables API element representation containing key data
+ * @elem_priv:	nftables API element representation containing key data
  *
  * On insertion, elements are added to a copy of the matching data currently
  * in use for lookups, and not directly inserted into current lookup data. Both
@@ -1748,9 +1744,9 @@ static void nft_pipapo_abort(const struct nft_set *set)
  */
 static void nft_pipapo_activate(const struct net *net,
 				const struct nft_set *set,
-				const struct nft_set_elem *elem)
+				struct nft_elem_priv *elem_priv)
 {
-	struct nft_pipapo_elem *e = nft_elem_priv_cast(elem->priv);
+	struct nft_pipapo_elem *e = nft_elem_priv_cast(elem_priv);
 
 	nft_set_elem_change_active(net, set, &e->ext);
 }
@@ -1803,7 +1799,7 @@ nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
  * nft_pipapo_flush() - Call pipapo_deactivate() to make element inactive
  * @net:	Network namespace
  * @set:	nftables API set representation
- * @elem:	nftables API element representation containing key data
+ * @elem_priv:	nftables API element representation containing key data
  *
  * This is functionally the same as nft_pipapo_deactivate(), with a slightly
  * different interface, and it's also called once for each element in a set
@@ -1945,7 +1941,7 @@ static bool pipapo_match_field(struct nft_pipapo_field *f,
  * nft_pipapo_remove() - Remove element given key, commit
  * @net:	Network namespace
  * @set:	nftables API set representation
- * @elem:	nftables API element representation containing key data
+ * @elem_priv:	nftables API element representation containing key data
  *
  * Similarly to nft_pipapo_activate(), this is used as commit operation by the
  * API, but it's called once per element in the pending transaction, so we can't
@@ -1953,7 +1949,7 @@ static bool pipapo_match_field(struct nft_pipapo_field *f,
  * the matched element here, if any, and commit the updated matching data.
  */
 static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
-			      const struct nft_set_elem *elem)
+			      struct nft_elem_priv *elem_priv)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m = priv->clone;
@@ -1961,7 +1957,7 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_elem *e;
 	const u8 *data;
 
-	e = nft_elem_priv_cast(elem->priv);
+	e = nft_elem_priv_cast(elem_priv);
 	data = (const u8 *)nft_set_ext_key(&e->ext);
 
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
@@ -2038,7 +2034,6 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 	for (r = 0; r < f->rules; r++) {
 		struct nft_pipapo_elem *e;
-		struct nft_set_elem elem;
 
 		if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
 			continue;
@@ -2048,9 +2043,7 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 		e = f->mt[r].e;
 
-		elem.priv = &e->priv;
-
-		iter->err = iter->fn(ctx, set, iter, &elem);
+		iter->err = iter->fn(ctx, set, iter, &e->priv);
 		if (iter->err < 0)
 			goto out;
 
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 291ce919dcce..cf344440aab4 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -228,11 +228,7 @@ static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
 				 struct nft_rbtree *priv,
 				 struct nft_rbtree_elem *rbe)
 {
-	struct nft_set_elem elem = {
-		.priv	= &rbe->priv,
-	};
-
-	nft_setelem_data_deactivate(net, set, &elem);
+	nft_setelem_data_deactivate(net, set, &rbe->priv);
 	rb_erase(&rbe->node, &priv->root);
 }
 
@@ -512,9 +508,9 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 static void nft_rbtree_remove(const struct net *net,
 			      const struct nft_set *set,
-			      const struct nft_set_elem *elem)
+			      struct nft_elem_priv *elem_priv)
 {
-	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
+	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem_priv);
 	struct nft_rbtree *priv = nft_set_priv(set);
 
 	write_lock_bh(&priv->lock);
@@ -526,9 +522,9 @@ static void nft_rbtree_remove(const struct net *net,
 
 static void nft_rbtree_activate(const struct net *net,
 				const struct nft_set *set,
-				const struct nft_set_elem *elem)
+				struct nft_elem_priv *elem_priv)
 {
-	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
+	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem_priv);
 
 	nft_set_elem_change_active(net, set, &rbe->ext);
 }
@@ -589,7 +585,6 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe;
-	struct nft_set_elem elem;
 	struct rb_node *node;
 
 	read_lock_bh(&priv->lock);
@@ -601,9 +596,7 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 
-		elem.priv = &rbe->priv;
-
-		iter->err = iter->fn(ctx, set, iter, &elem);
+		iter->err = iter->fn(ctx, set, iter, &rbe->priv);
 		if (iter->err < 0) {
 			read_unlock_bh(&priv->lock);
 			return;
-- 
2.30.2

