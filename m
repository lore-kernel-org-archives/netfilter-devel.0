Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8DD13C3C2;
	Thu, 27 Jun 2024 11:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487643; cv=none; b=mrGu1q1ZumoErW1xpRmbKUxEWA28utmvNqMUnc8tO30NQkyT7un3RbTP3SceGvSPgEIHvF7T0aWAqN/bWEcHNYrC8exj/genA/wfKb7m0X+IjRdQnkEoF7/qcClaUX44i/VagPYyyf0fjpq7ng5/cjfioAP0zQ21Qosv2Vq0iWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487643; c=relaxed/simple;
	bh=GxaENIpQzBjabLNsJuYxurAwRF013SWSirVckjurde0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rIbQNh01npMhgT0qWL6ueNFW+aOkx+MZ2dIy8s5QEf+fMTrh1sOXGwQmY6GMeadzURt2yO0FKEoFTbH1DTR/nBIAAqbfZrtI4H2G6IhwjtXEexBRjejEwF6J9lilv8/2wF/RBdBqkurJaOliulqn2xKDDYMAX6jFcux45/Kw8BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH nf-next 02/19] netfilter: nf_tables: move bind list_head into relevant subtypes
Date: Thu, 27 Jun 2024 13:26:56 +0200
Message-Id: <20240627112713.4846-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240627112713.4846-1-pablo@netfilter.org>
References: <20240627112713.4846-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Only nft_trans_chain and nft_trans_set subtypes use the
trans->binding_list member.

Add a new common binding subtype and move the member there.

This reduces size of all other subtypes by 16 bytes on 64bit platforms.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 26 +++++++----
 net/netfilter/nf_tables_api.c     | 71 +++++++++++++++++++++++++------
 2 files changed, 75 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index b25df037fceb..f72448095833 100644
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
@@ -1647,7 +1657,7 @@ struct nft_trans_rule {
 	nft_trans_container_rule(trans)->bound
 
 struct nft_trans_set {
-	struct nft_trans		nft_trans;
+	struct nft_trans_binding	nft_trans_binding;
 	struct nft_set			*set;
 	u32				set_id;
 	u32				gc_int;
@@ -1657,8 +1667,8 @@ struct nft_trans_set {
 	u32				size;
 };
 
-#define nft_trans_container_set(trans)			\
-	container_of(trans, struct nft_trans_set, nft_trans)
+#define nft_trans_container_set(t)	\
+	container_of(t, struct nft_trans_set, nft_trans_binding.nft_trans)
 #define nft_trans_set(trans)				\
 	nft_trans_container_set(trans)->set
 #define nft_trans_set_id(trans)				\
@@ -1675,7 +1685,7 @@ struct nft_trans_set {
 	nft_trans_container_set(trans)->size
 
 struct nft_trans_chain {
-	struct nft_trans		nft_trans;
+	struct nft_trans_binding	nft_trans_binding;
 	struct nft_chain		*chain;
 	bool				update;
 	char				*name;
@@ -1687,8 +1697,8 @@ struct nft_trans_chain {
 	struct list_head		hook_list;
 };
 
-#define nft_trans_container_chain(trans)		\
-	container_of(trans, struct nft_trans_chain, nft_trans)
+#define nft_trans_container_chain(t)	\
+	container_of(t, struct nft_trans_chain, nft_trans_binding.nft_trans)
 #define nft_trans_chain(trans)				\
 	nft_trans_container_chain(trans)->chain
 #define nft_trans_chain_update(trans)			\
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 19edd1bcecef..c950938ef612 100644
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
@@ -416,11 +436,27 @@ static int nft_deltable(struct nft_ctx *ctx)
 	return err;
 }
 
-static struct nft_trans *nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
+static struct nft_trans *
+nft_trans_alloc_chain(const struct nft_ctx *ctx, int msg_type)
 {
+	struct nft_trans_chain *trans_chain;
 	struct nft_trans *trans;
 
 	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_chain));
+	if (!trans)
+		return NULL;
+
+	trans_chain = nft_trans_container_chain(trans);
+	INIT_LIST_HEAD(&trans_chain->nft_trans_binding.binding_list);
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
 
@@ -560,12 +596,16 @@ static int __nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
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
@@ -2698,8 +2738,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	}
 
 	err = -ENOMEM;
-	trans = nft_trans_alloc(ctx, NFT_MSG_NEWCHAIN,
-				sizeof(struct nft_trans_chain));
+	trans = nft_trans_alloc_chain(ctx, NFT_MSG_NEWCHAIN);
 	if (trans == NULL)
 		goto err_trans;
 
@@ -2915,8 +2954,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 		list_move(&hook->list, &chain_del_list);
 	}
 
-	trans = nft_trans_alloc(ctx, NFT_MSG_DELCHAIN,
-				sizeof(struct nft_trans_chain));
+	trans = nft_trans_alloc_chain(ctx, NFT_MSG_DELCHAIN);
 	if (!trans) {
 		err = -ENOMEM;
 		goto err_chain_del_hook;
@@ -10147,6 +10185,7 @@ static void nft_gc_seq_end(struct nftables_pernet *nft_net, unsigned int gc_seq)
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_trans_binding *trans_binding;
 	struct nft_trans *trans, *next;
 	unsigned int base_seq, gc_seq;
 	LIST_HEAD(set_update_list);
@@ -10161,7 +10200,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		return 0;
 	}
 
-	list_for_each_entry(trans, &nft_net->binding_list, binding_list) {
+	list_for_each_entry(trans_binding, &nft_net->binding_list, binding_list) {
+		trans = &trans_binding->nft_trans;
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWSET:
 			if (!nft_trans_set_update(trans) &&
@@ -10179,6 +10219,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				return -EINVAL;
 			}
 			break;
+		default:
+			WARN_ONCE(1, "Unhandled bind type %d", trans->msg_type);
+			break;
 		}
 	}
 
@@ -11589,9 +11632,9 @@ static int __init nf_tables_module_init(void)
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct nft_trans_table, nft_trans) != 0);
-	BUILD_BUG_ON(offsetof(struct nft_trans_chain, nft_trans) != 0);
+	BUILD_BUG_ON(offsetof(struct nft_trans_chain, nft_trans_binding.nft_trans) != 0);
 	BUILD_BUG_ON(offsetof(struct nft_trans_rule, nft_trans) != 0);
-	BUILD_BUG_ON(offsetof(struct nft_trans_set, nft_trans) != 0);
+	BUILD_BUG_ON(offsetof(struct nft_trans_set, nft_trans_binding.nft_trans) != 0);
 	BUILD_BUG_ON(offsetof(struct nft_trans_elem, nft_trans) != 0);
 	BUILD_BUG_ON(offsetof(struct nft_trans_obj, nft_trans) != 0);
 	BUILD_BUG_ON(offsetof(struct nft_trans_flowtable, nft_trans) != 0);
-- 
2.30.2

