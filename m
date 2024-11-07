Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E3820FA85
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001610; cv=none; b=q11HmBIaEfCdT2d2npEjM50nwYtLQYCawecx/4GtmqXjkYSM4kAObprwraUGiV9sZqmfOiB2tdBsn+Ld32hwQsvrnd8ZnlHRu65fAItEjarmZkBIYYGQgk/q4n9k2CDHvsXFE8xZUuKFEbVb1LWQaTKQrPeLHY1MKAG34a+XJeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001610; c=relaxed/simple;
	bh=1RTH76zNvJfVowZaiGYFGZgTZrUx4oOJCXDQCHC5M28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eecbkNXq3MKtzLD2pYRzIa05r295mKl6qSrMJXls26Mjvd+KjyZY9okmy3prL3GWcjFbifmDtZDoZG26eMiWlVmA/Hm90jR4uwc+vTmoJjY9V4M1RKbzdgx9sgIZY0nVi0ZfdGO47bcK2JPWbgigyn4/8FFPeSy/NqS67JMVSpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t96ai-0007L4-Pw; Thu, 07 Nov 2024 18:46:44 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 2/5] netfilter: nf_tables: prepare for multiple elements in nft_trans_elem structure
Date: Thu,  7 Nov 2024 18:44:06 +0100
Message-ID: <20241107174415.4690-3-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241107174415.4690-1-fw@strlen.de>
References: <20241107174415.4690-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helpers to release the individual elements contained in the
trans_elem container structure.

No functional change intended.

Followup patch will add 'nelems' member and will turn 'priv' into
a flexible array.

These helpers can then loop over all elements.
Care needs to be taken to handle a mix of new elements and existing
elements that are being updated (e.g. timeout refresh).

Before this patch, NEWSETELEM transaction with update is released
early so nft_trans_set_elem_destroy() won't get called, so we need
to skip elements marked as update.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  21 ++-
 net/netfilter/nf_tables_api.c     | 228 +++++++++++++++++++++---------
 2 files changed, 173 insertions(+), 76 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c1513bd14568..14ccf1133a4c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1755,28 +1755,25 @@ enum nft_trans_elem_flags {
 	NFT_TRANS_UPD_EXPIRATION	= (1 << 1),
 };
 
-struct nft_trans_elem {
-	struct nft_trans		nft_trans;
-	struct nft_set			*set;
-	struct nft_elem_priv		*elem_priv;
+struct nft_trans_one_elem {
+	struct nft_elem_priv		*priv;
 	u64				timeout;
 	u64				expiration;
 	u8				update_flags;
+};
+
+struct nft_trans_elem {
+	struct nft_trans		nft_trans;
+	struct nft_set			*set;
 	bool				bound;
+	unsigned int			nelems;
+	struct nft_trans_one_elem	elems[] __counted_by(nelems);
 };
 
 #define nft_trans_container_elem(t)			\
 	container_of(t, struct nft_trans_elem, nft_trans)
 #define nft_trans_elem_set(trans)			\
 	nft_trans_container_elem(trans)->set
-#define nft_trans_elem_priv(trans)			\
-	nft_trans_container_elem(trans)->elem_priv
-#define nft_trans_elem_update_flags(trans)		\
-	nft_trans_container_elem(trans)->update_flags
-#define nft_trans_elem_timeout(trans)			\
-	nft_trans_container_elem(trans)->timeout
-#define nft_trans_elem_expiration(trans)		\
-	nft_trans_container_elem(trans)->expiration
 #define nft_trans_elem_set_bound(trans)			\
 	nft_trans_container_elem(trans)->bound
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e4a54c618760..5eab6f121684 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6445,13 +6445,17 @@ static struct nft_trans *nft_trans_elem_alloc(const struct nft_ctx *ctx,
 					      int msg_type,
 					      struct nft_set *set)
 {
+	struct nft_trans_elem *te;
 	struct nft_trans *trans;
 
-	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_elem));
+	trans = nft_trans_alloc(ctx, msg_type, struct_size(te, elems, 1));
 	if (trans == NULL)
 		return NULL;
 
-	nft_trans_elem_set(trans) = set;
+	te = nft_trans_container_elem(trans);
+	te->nelems = 1;
+	te->set = set;
+
 	return trans;
 }
 
@@ -6573,28 +6577,51 @@ static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 }
 
 /* Drop references and destroy. Called from gc, dynset and abort path. */
-void nft_set_elem_destroy(const struct nft_set *set,
-			  const struct nft_elem_priv *elem_priv,
-			  bool destroy_expr)
+static void __nft_set_elem_destroy(const struct nft_ctx *ctx,
+				   const struct nft_set *set,
+				   const struct nft_elem_priv *elem_priv,
+				   bool destroy_expr)
 {
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
-	struct nft_ctx ctx = {
-		.net	= read_pnet(&set->net),
-		.family	= set->table->family,
-	};
 
 	nft_data_release(nft_set_ext_key(ext), NFT_DATA_VALUE);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_release(nft_set_ext_data(ext), set->dtype);
 	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS))
-		nft_set_elem_expr_destroy(&ctx, nft_set_ext_expr(ext));
+		nft_set_elem_expr_destroy(ctx, nft_set_ext_expr(ext));
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
 		nft_use_dec(&(*nft_set_ext_obj(ext))->use);
 
 	kfree(elem_priv);
 }
+
+/* Drop references and destroy. Called from gc and dynset. */
+void nft_set_elem_destroy(const struct nft_set *set,
+			  const struct nft_elem_priv *elem_priv,
+			  bool destroy_expr)
+{
+	struct nft_ctx ctx = {
+		.net	= read_pnet(&set->net),
+		.family	= set->table->family,
+	};
+
+	__nft_set_elem_destroy(&ctx, set, elem_priv, destroy_expr);
+}
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 
+/* Drop references and destroy. Called from abort path. */
+static void nft_trans_set_elem_destroy(const struct nft_ctx *ctx, struct nft_trans_elem *te)
+{
+	int i;
+
+	for (i = 0; i < te->nelems; i++) {
+		if (te->elems[i].update_flags)
+			continue;
+
+		__nft_set_elem_destroy(ctx, te->set, te->elems[i].priv, true);
+	}
+}
+
 /* Destroy element. References have been already dropped in the preparation
  * path via nft_setelem_data_deactivate().
  */
@@ -6610,6 +6637,15 @@ void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 	kfree(elem_priv);
 }
 
+static void nft_trans_elems_destroy(const struct nft_ctx *ctx,
+				    const struct nft_trans_elem *te)
+{
+	int i;
+
+	for (i = 0; i < te->nelems; i++)
+		nf_tables_set_elem_destroy(ctx, te->set, te->elems[i].priv);
+}
+
 int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_expr *expr_array[])
 {
@@ -6766,6 +6802,36 @@ static void nft_setelem_activate(struct net *net, struct nft_set *set,
 	}
 }
 
+static void nft_trans_elem_update(const struct nft_set *set,
+				  const struct nft_trans_one_elem *elem)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+
+	if (elem->update_flags & NFT_TRANS_UPD_TIMEOUT)
+		WRITE_ONCE(nft_set_ext_timeout(ext)->timeout, elem->timeout);
+
+	if (elem->update_flags & NFT_TRANS_UPD_EXPIRATION)
+		WRITE_ONCE(nft_set_ext_timeout(ext)->expiration, get_jiffies_64() + elem->expiration);
+}
+
+static void nft_trans_elems_add(const struct nft_ctx *ctx,
+				struct nft_trans_elem *te)
+{
+	int i;
+
+	for (i = 0; i < te->nelems; i++) {
+		const struct nft_trans_one_elem *elem = &te->elems[i];
+
+		if (elem->update_flags)
+			nft_trans_elem_update(te->set, elem);
+		else
+			nft_setelem_activate(ctx->net, te->set, elem->priv);
+
+		nf_tables_setelem_notify(ctx, te->set, elem->priv,
+					 NFT_MSG_NEWSETELEM);
+	}
+}
+
 static int nft_setelem_catchall_deactivate(const struct net *net,
 					   struct nft_set *set,
 					   struct nft_set_elem *elem)
@@ -6848,6 +6914,24 @@ static void nft_setelem_remove(const struct net *net,
 		set->ops->remove(net, set, elem_priv);
 }
 
+static void nft_trans_elems_remove(const struct nft_ctx *ctx,
+				   const struct nft_trans_elem *te)
+{
+	int i;
+
+	for (i = 0; i < te->nelems; i++) {
+		nf_tables_setelem_notify(ctx, te->set,
+					 te->elems[i].priv,
+					 te->nft_trans.msg_type);
+
+		nft_setelem_remove(ctx->net, te->set, te->elems[i].priv);
+		if (!nft_setelem_is_catchall(te->set, te->elems[i].priv)) {
+			atomic_dec(&te->set->nelems);
+			te->set->ndeact--;
+		}
+	}
+}
+
 static bool nft_setelem_valid_key_end(const struct nft_set *set,
 				      struct nlattr **nla, u32 flags)
 {
@@ -7199,22 +7283,26 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			else if (!(nlmsg_flags & NLM_F_EXCL)) {
 				err = 0;
 				if (nft_set_ext_exists(ext2, NFT_SET_EXT_TIMEOUT)) {
+					struct nft_trans_one_elem *update;
+
+					update = &nft_trans_container_elem(trans)->elems[0];
+
 					update_flags = 0;
 					if (timeout != nft_set_ext_timeout(ext2)->timeout) {
-						nft_trans_elem_timeout(trans) = timeout;
+						update->timeout = timeout;
 						if (expiration == 0)
 							expiration = timeout;
 
 						update_flags |= NFT_TRANS_UPD_TIMEOUT;
 					}
 					if (expiration) {
-						nft_trans_elem_expiration(trans) = expiration;
+						update->expiration = expiration;
 						update_flags |= NFT_TRANS_UPD_EXPIRATION;
 					}
 
 					if (update_flags) {
-						nft_trans_elem_priv(trans) = elem_priv;
-						nft_trans_elem_update_flags(trans) = update_flags;
+						update->priv = elem_priv;
+						update->update_flags = update_flags;
 						nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 						goto err_elem_free;
 					}
@@ -7238,7 +7326,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		}
 	}
 
-	nft_trans_elem_priv(trans) = elem.priv;
+	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
 	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 	return 0;
 
@@ -7376,6 +7464,50 @@ void nft_setelem_data_deactivate(const struct net *net,
 		nft_use_dec(&(*nft_set_ext_obj(ext))->use);
 }
 
+/* similar to nft_trans_elems_remove, but called from abort path to undo newsetelem.
+ * No notifications and no ndeact changes.
+ *
+ * Returns true if set had been added to (i.e., elements need to be removed again).
+ */
+static bool nft_trans_elems_new_abort(const struct nft_ctx *ctx,
+				      const struct nft_trans_elem *te)
+{
+	bool removed = false;
+	int i;
+
+	for (i = 0; i < te->nelems; i++) {
+		if (te->elems[i].update_flags)
+			continue;
+
+		if (!te->set->ops->abort || nft_setelem_is_catchall(te->set, te->elems[i].priv))
+			nft_setelem_remove(ctx->net, te->set, te->elems[i].priv);
+
+		if (!nft_setelem_is_catchall(te->set, te->elems[i].priv))
+			atomic_dec(&te->set->nelems);
+
+		removed = true;
+	}
+
+	return removed;
+}
+
+/* Called from abort path to undo DELSETELEM/DESTROYSETELEM. */
+static void nft_trans_elems_destroy_abort(const struct nft_ctx *ctx,
+					  const struct nft_trans_elem *te)
+{
+	int i;
+
+	for (i = 0; i < te->nelems; i++) {
+		if (!nft_setelem_active_next(ctx->net, te->set, te->elems[i].priv)) {
+			nft_setelem_data_activate(ctx->net, te->set, te->elems[i].priv);
+			nft_setelem_activate(ctx->net, te->set, te->elems[i].priv);
+		}
+
+		if (!nft_setelem_is_catchall(te->set, te->elems[i].priv))
+			te->set->ndeact--;
+	}
+}
+
 static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 			   const struct nlattr *attr)
 {
@@ -7455,7 +7587,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 
 	nft_setelem_data_deactivate(ctx->net, set, elem.priv);
 
-	nft_trans_elem_priv(trans) = elem.priv;
+	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
 	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 	return 0;
 
@@ -7482,7 +7614,8 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 		return 0;
 
 	trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM,
-				    sizeof(struct nft_trans_elem), GFP_ATOMIC);
+				    struct_size_t(struct nft_trans_elem, elems, 1),
+				    GFP_ATOMIC);
 	if (!trans)
 		return -ENOMEM;
 
@@ -7491,7 +7624,8 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_set(trans) = set;
-	nft_trans_elem_priv(trans) = elem_priv;
+	nft_trans_container_elem(trans)->nelems = 1;
+	nft_trans_container_elem(trans)->elems[0].priv = elem_priv;
 	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_ATOMIC);
 
 	return 0;
@@ -7508,7 +7642,7 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 		return -ENOMEM;
 
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
-	nft_trans_elem_priv(trans) = elem_priv;
+	nft_trans_container_elem(trans)->elems[0].priv = elem_priv;
 	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 
 	return 0;
@@ -9690,9 +9824,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_DELSETELEM:
 	case NFT_MSG_DESTROYSETELEM:
-		nf_tables_set_elem_destroy(&ctx,
-					   nft_trans_elem_set(trans),
-					   nft_trans_elem_priv(trans));
+		nft_trans_elems_destroy(&ctx, nft_trans_container_elem(trans));
 		break;
 	case NFT_MSG_DELOBJ:
 	case NFT_MSG_DESTROYOBJ:
@@ -10545,25 +10677,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWSETELEM:
 			te = nft_trans_container_elem(trans);
 
-			if (te->update_flags) {
-				const struct nft_set_ext *ext =
-					nft_set_elem_ext(te->set, te->elem_priv);
+			nft_trans_elems_add(&ctx, te);
 
-				if (te->update_flags & NFT_TRANS_UPD_TIMEOUT) {
-					WRITE_ONCE(nft_set_ext_timeout(ext)->timeout,
-						   te->timeout);
-				}
-				if (te->update_flags & NFT_TRANS_UPD_EXPIRATION) {
-					WRITE_ONCE(nft_set_ext_timeout(ext)->expiration,
-						   get_jiffies_64() + te->expiration);
-				}
-			} else {
-				nft_setelem_activate(net, te->set, te->elem_priv);
-			}
-
-			nf_tables_setelem_notify(&ctx, te->set,
-						 te->elem_priv,
-						 NFT_MSG_NEWSETELEM);
 			if (te->set->ops->commit &&
 			    list_empty(&te->set->pending_update)) {
 				list_add_tail(&te->set->pending_update,
@@ -10575,14 +10690,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DESTROYSETELEM:
 			te = nft_trans_container_elem(trans);
 
-			nf_tables_setelem_notify(&ctx, te->set,
-						 te->elem_priv,
-						 trans->msg_type);
-			nft_setelem_remove(net, te->set, te->elem_priv);
-			if (!nft_setelem_is_catchall(te->set, te->elem_priv)) {
-				atomic_dec(&te->set->nelems);
-				te->set->ndeact--;
-			}
+			nft_trans_elems_remove(&ctx, te);
+
 			if (te->set->ops->commit &&
 			    list_empty(&te->set->pending_update)) {
 				list_add_tail(&te->set->pending_update,
@@ -10702,8 +10811,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nft_set_destroy(&ctx, nft_trans_set(trans));
 		break;
 	case NFT_MSG_NEWSETELEM:
-		nft_set_elem_destroy(nft_trans_elem_set(trans),
-				     nft_trans_elem_priv(trans), true);
+		nft_trans_set_elem_destroy(&ctx, nft_trans_container_elem(trans));
 		break;
 	case NFT_MSG_NEWOBJ:
 		nft_obj_destroy(&ctx, nft_trans_obj(trans));
@@ -10860,18 +10968,15 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
-			if (nft_trans_elem_update_flags(trans) ||
-			    nft_trans_elem_set_bound(trans)) {
+			if (nft_trans_elem_set_bound(trans)) {
 				nft_trans_destroy(trans);
 				break;
 			}
 			te = nft_trans_container_elem(trans);
-			if (!te->set->ops->abort ||
-			    nft_setelem_is_catchall(te->set, te->elem_priv))
-				nft_setelem_remove(net, te->set, te->elem_priv);
-
-			if (!nft_setelem_is_catchall(te->set, te->elem_priv))
-				atomic_dec(&te->set->nelems);
+			if (!nft_trans_elems_new_abort(&ctx, te)) {
+				nft_trans_destroy(trans);
+				break;
+			}
 
 			if (te->set->ops->abort &&
 			    list_empty(&te->set->pending_update)) {
@@ -10883,12 +10988,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DESTROYSETELEM:
 			te = nft_trans_container_elem(trans);
 
-			if (!nft_setelem_active_next(net, te->set, te->elem_priv)) {
-				nft_setelem_data_activate(net, te->set, te->elem_priv);
-				nft_setelem_activate(net, te->set, te->elem_priv);
-			}
-			if (!nft_setelem_is_catchall(te->set, te->elem_priv))
-				te->set->ndeact--;
+			nft_trans_elems_destroy_abort(&ctx, te);
 
 			if (te->set->ops->abort &&
 			    list_empty(&te->set->pending_update)) {
-- 
2.45.2

