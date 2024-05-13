Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FA315098B
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 13:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605777; cv=none; b=jwm4o7jBlUPd6BLZ1UuMM5FEUrd/nda8jgnqioZwN+LVg60hBaTc8uO+x9R3hZIbNROt8WuTxtL6ztaHLz7hSGOV1Dn++2WyFkQucDNhIhlu27HrIYpLtIFE1DD+7BSfYEXU63mxxXjyuDOdGEG9ohqCtEBhAZNJsxgPYL+LQfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605777; c=relaxed/simple;
	bh=kFDGlXuY8BtHVcMYWnqyhTQBOvAji9rUopqNtJwZ58o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kR8sOFdY1ufMPVFXznOLoTZDSd95wRX8K4Y73etrr+I56VZOW9YqKTAvHJVQrZ+HgpGbELjUz3dnSGi1iiNYO11a6NTcxSTU9ZQQ23ZFioEaa3FB1ZnHm9vFWC6X3tQh72Tbw1C4tlDAd0Wc+cD4Dd4YcHtBZ7NUW/xB57LxmNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6VQr-0001Ow-Mp; Mon, 13 May 2024 15:09:33 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 02/11] netfilter: nf_tables: move bind list_head into relevant subtypes
Date: Mon, 13 May 2024 15:00:42 +0200
Message-ID: <20240513130057.11014-3-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240513130057.11014-1-fw@strlen.de>
References: <20240513130057.11014-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only nft_trans_chain and nft_trans_set subtypes use the
trans->binding_list member.

Add a new common binding subtype and move the member there.

This reduces size of all other subtypes by 16 bytes on 64bit platforms.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 54 +++++++++++++++----------
 net/netfilter/nf_tables_api.c     | 66 +++++++++++++++++++++++++------
 2 files changed, 88 insertions(+), 32 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index af0ef21f3780..f914cace0241 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1611,7 +1611,6 @@ static inline int nft_set_elem_is_dead(const struct nft_set_ext *ext)
  * struct nft_trans - nf_tables object update in transaction
  *
  * @list: used internally
- * @binding_list: list of objects with possible bindings
  * @msg_type: message type
  * @put_net: ctx->net needs to be put
  * @ctx: transaction context
@@ -1621,12 +1620,23 @@ static inline int nft_set_elem_is_dead(const struct nft_set_ext *ext)
  */
 struct nft_trans {
 	struct list_head		list;
-	struct list_head		binding_list;
 	int				msg_type;
 	bool				put_net;
 	struct nft_ctx			ctx;
 };
 
+/**
+ * struct nft_trans_binding - nf_tables object with binding support in transaction
+ * @nft_trans:    base structure, MUST be first member
+ * @binding_list: list of objects with possible bindings
+ *
+ * This is the base type used by objects that can be bound to a chain.
+ */
+struct nft_trans_binding {
+	struct nft_trans nft_trans;
+	struct list_head binding_list;
+};
+
 struct nft_trans_rule {
 	struct nft_trans		nft_trans;
 	struct nft_rule			*rule;
@@ -1645,7 +1655,7 @@ struct nft_trans_rule {
 	container_of(trans, struct nft_trans_rule, nft_trans)->bound
 
 struct nft_trans_set {
-	struct nft_trans		nft_trans;
+	struct nft_trans_binding	nft_trans_binding;
 	struct nft_set			*set;
 	u32				set_id;
 	u32				gc_int;
@@ -1655,23 +1665,25 @@ struct nft_trans_set {
 	u32				size;
 };
 
+#define nft_trans_container_set(t)	\
+	container_of(t, struct nft_trans_set, nft_trans_binding.nft_trans)
 #define nft_trans_set(trans)	\
-	container_of(trans, struct nft_trans_set, nft_trans)->set
+	nft_trans_container_set(trans)->set
 #define nft_trans_set_id(trans)	\
-	container_of(trans, struct nft_trans_set, nft_trans)->set_id
+	nft_trans_container_set(trans)->set_id
 #define nft_trans_set_bound(trans)	\
-	container_of(trans, struct nft_trans_set, nft_trans)->bound
+	nft_trans_container_set(trans)->bound
 #define nft_trans_set_update(trans)	\
-	container_of(trans, struct nft_trans_set, nft_trans)->update
+	nft_trans_container_set(trans)->update
 #define nft_trans_set_timeout(trans)	\
-	container_of(trans, struct nft_trans_set, nft_trans)->timeout
+	nft_trans_container_set(trans)->timeout
 #define nft_trans_set_gc_int(trans)	\
-	container_of(trans, struct nft_trans_set, nft_trans)->gc_int
+	nft_trans_container_set(trans)->gc_int
 #define nft_trans_set_size(trans)	\
-	container_of(trans, struct nft_trans_set, nft_trans)->size
+	nft_trans_container_set(trans)->size
 
 struct nft_trans_chain {
-	struct nft_trans		nft_trans;
+	struct nft_trans_binding	nft_trans_binding;
 	struct nft_chain		*chain;
 	bool				update;
 	char				*name;
@@ -1683,24 +1695,26 @@ struct nft_trans_chain {
 	struct list_head		hook_list;
 };
 
+#define nft_trans_container_chain(t)	\
+	container_of(t, struct nft_trans_chain, nft_trans_binding.nft_trans)
 #define nft_trans_chain(trans)	\
-	container_of(trans, struct nft_trans_chain, nft_trans)->chain
+	nft_trans_container_chain(trans)->chain
 #define nft_trans_chain_update(trans)	\
-	container_of(trans, struct nft_trans_chain, nft_trans)->update
+	nft_trans_container_chain(trans)->update
 #define nft_trans_chain_name(trans)	\
-	container_of(trans, struct nft_trans_chain, nft_trans)->name
+	nft_trans_container_chain(trans)->name
 #define nft_trans_chain_stats(trans)	\
-	container_of(trans, struct nft_trans_chain, nft_trans)->stats
+	nft_trans_container_chain(trans)->stats
 #define nft_trans_chain_policy(trans)	\
-	container_of(trans, struct nft_trans_chain, nft_trans)->policy
+	nft_trans_container_chain(trans)->policy
 #define nft_trans_chain_bound(trans)	\
-	container_of(trans, struct nft_trans_chain, nft_trans)->bound
+	nft_trans_container_chain(trans)->bound
 #define nft_trans_chain_id(trans)	\
-	container_of(trans, struct nft_trans_chain, nft_trans)->chain_id
+	nft_trans_container_chain(trans)->chain_id
 #define nft_trans_basechain(trans)	\
-	container_of(trans, struct nft_trans_chain, nft_trans)->basechain
+	nft_trans_container_chain(trans)->basechain
 #define nft_trans_chain_hooks(trans)	\
-	container_of(trans, struct nft_trans_chain, nft_trans)->hook_list
+	nft_trans_container_chain(trans)->hook_list
 
 struct nft_trans_table {
 	struct nft_trans		nft_trans;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cd355f63b1d2..b82b592059ea 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -158,7 +158,6 @@ static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
 		return NULL;
 
 	INIT_LIST_HEAD(&trans->list);
-	INIT_LIST_HEAD(&trans->binding_list);
 	trans->msg_type = msg_type;
 	trans->ctx	= *ctx;
 
@@ -171,10 +170,26 @@ static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
 	return nft_trans_alloc_gfp(ctx, msg_type, size, GFP_KERNEL);
 }
 
+static struct nft_trans_binding *nft_trans_get_binding(struct nft_trans *trans)
+{
+	switch (trans->msg_type) {
+	case NFT_MSG_NEWCHAIN:
+	case NFT_MSG_NEWSET:
+		return container_of(trans, struct nft_trans_binding, nft_trans);
+	}
+
+	return NULL;
+}
+
 static void nft_trans_list_del(struct nft_trans *trans)
 {
+	struct nft_trans_binding *trans_binding;
+
 	list_del(&trans->list);
-	list_del(&trans->binding_list);
+
+	trans_binding = nft_trans_get_binding(trans);
+	if (trans_binding)
+		list_del(&trans_binding->binding_list);
 }
 
 static void nft_trans_destroy(struct nft_trans *trans)
@@ -372,21 +387,26 @@ static void nf_tables_unregister_hook(struct net *net,
 static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *trans)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_trans_binding *binding;
+
+	list_add_tail(&trans->list, &nft_net->commit_list);
+
+	binding = nft_trans_get_binding(trans);
+	if (!binding)
+		return;
 
 	switch (trans->msg_type) {
 	case NFT_MSG_NEWSET:
 		if (!nft_trans_set_update(trans) &&
 		    nft_set_is_anonymous(nft_trans_set(trans)))
-			list_add_tail(&trans->binding_list, &nft_net->binding_list);
+			list_add_tail(&binding->binding_list, &nft_net->binding_list);
 		break;
 	case NFT_MSG_NEWCHAIN:
 		if (!nft_trans_chain_update(trans) &&
 		    nft_chain_binding(nft_trans_chain(trans)))
-			list_add_tail(&trans->binding_list, &nft_net->binding_list);
+			list_add_tail(&binding->binding_list, &nft_net->binding_list);
 		break;
 	}
-
-	list_add_tail(&trans->list, &nft_net->commit_list);
 }
 
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
@@ -416,11 +436,26 @@ static int nft_deltable(struct nft_ctx *ctx)
 	return err;
 }
 
-static struct nft_trans *nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
+static struct nft_trans *
+nft_trans_alloc_chain(const struct nft_ctx *ctx, int msg_type)
 {
 	struct nft_trans *trans;
 
 	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_chain));
+	if (trans) {
+		struct nft_trans_chain *chain = nft_trans_container_chain(trans);
+
+		INIT_LIST_HEAD(&chain->nft_trans_binding.binding_list);
+	}
+
+	return trans;
+}
+
+static struct nft_trans *nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc_chain(ctx, msg_type);
 	if (trans == NULL)
 		return ERR_PTR(-ENOMEM);
 
@@ -560,12 +595,16 @@ static int __nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 			       struct nft_set *set,
 			       const struct nft_set_desc *desc)
 {
+	struct nft_trans_set *trans_set;
 	struct nft_trans *trans;
 
 	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_set));
 	if (trans == NULL)
 		return -ENOMEM;
 
+	trans_set = nft_trans_container_set(trans);
+	INIT_LIST_HEAD(&trans_set->nft_trans_binding.binding_list);
+
 	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] && !desc) {
 		nft_trans_set_id(trans) =
 			ntohl(nla_get_be32(ctx->nla[NFTA_SET_ID]));
@@ -2698,8 +2737,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	}
 
 	err = -ENOMEM;
-	trans = nft_trans_alloc(ctx, NFT_MSG_NEWCHAIN,
-				sizeof(struct nft_trans_chain));
+	trans = nft_trans_alloc_chain(ctx, NFT_MSG_NEWCHAIN);
 	if (trans == NULL)
 		goto err_trans;
 
@@ -2915,8 +2953,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 		list_move(&hook->list, &chain_del_list);
 	}
 
-	trans = nft_trans_alloc(ctx, NFT_MSG_DELCHAIN,
-				sizeof(struct nft_trans_chain));
+	trans = nft_trans_alloc_chain(ctx, NFT_MSG_DELCHAIN);
 	if (!trans) {
 		err = -ENOMEM;
 		goto err_chain_del_hook;
@@ -10147,6 +10184,7 @@ static void nft_gc_seq_end(struct nftables_pernet *nft_net, unsigned int gc_seq)
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_trans_binding *trans_binding;
 	struct nft_trans *trans, *next;
 	unsigned int base_seq, gc_seq;
 	LIST_HEAD(set_update_list);
@@ -10161,7 +10199,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		return 0;
 	}
 
-	list_for_each_entry(trans, &nft_net->binding_list, binding_list) {
+	list_for_each_entry(trans_binding, &nft_net->binding_list, binding_list) {
+		trans = &trans_binding->nft_trans;
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWSET:
 			if (!nft_trans_set_update(trans) &&
@@ -10179,6 +10218,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				return -EINVAL;
 			}
 			break;
+		default:
+			WARN_ONCE(1, "Unhandled bind type %d", trans->msg_type);
+			break;
 		}
 	}
 
-- 
2.43.2

