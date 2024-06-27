Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5881494B3;
	Thu, 27 Jun 2024 11:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487642; cv=none; b=Y/E7aHBpQH//rrPbXLDsPIaPR8s/pdpzWjnFNsrzJ4y2QfTbUO4sr7aO7PJu9RKPkWcnhlwB2QVLH/+coZhfYUdr6X6koYK//mQX2CdwEqZeAY6Y1W/eB3haYm0YNEMB21dmP3zgb7LZ2DRrZriaVL4nrOsO3jowdMt5+ARMwGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487642; c=relaxed/simple;
	bh=TJFSqhV8GMQ+5YEmAOhH2DKEAOAgOG0JM4fuB4ZqiY0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RvQEg9GCysFPOyRQAlF8O1rQYIc9mN1jb2iddf7A0f7/72eD+u6gLox8UxNtr8R4D4A7PYw4ikZNT7YzAYEUxRHBDyTWU/OTh8resazgdNQHNJuzgU9MiecTRaDyr5+v1v8qWzKI6djOUfzIcDzV0MeoTDYZXUa+axXbW158aDQ=
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
Subject: [PATCH nf-next 01/19] netfilter: nf_tables: make struct nft_trans first member of derived subtypes
Date: Thu, 27 Jun 2024 13:26:55 +0200
Message-Id: <20240627112713.4846-2-pablo@netfilter.org>
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

There is 'struct nft_trans', the basic structure for all transactional
objects, and the the various different transactional objects, such as
nft_trans_table, chain, set, set_elem and so on.

Right now 'struct nft_trans' uses a flexible member at the tail
(data[]), and casting is needed to access the actual type-specific
members.

Change this to make the hierarchy visible in source code, i.e. make
struct nft_trans the first member of all derived subtypes.

This has several advantages:
1. pahole output reflects the real size needed by the particular subtype
2. allows to use container_of() to convert the base type to the actual
   object type instead of casting ->data to the overlay structure.
3. It makes it easy to add intermediate types.

'struct nft_trans' contains a 'binding_list' that is only needed
by two subtypes, so it should be part of the two subtypes, not in
the base structure.

But that makes it hard to interate over the binding_list, because
there is no common base structure.

A follow patch moves the bind list to a new struct:

 struct nft_trans_binding {
   struct nft_trans nft_trans;
   struct list_head binding_list;
 };

... and makes that structure the new 'first member' for both
nft_trans_chain and nft_trans_set.

No functional change intended in this patch.

Some numbers:
 struct nft_trans { /* size: 88, cachelines: 2, members: 5 */
 struct nft_trans_chain { /* size: 152, cachelines: 3, members: 10 */
 struct nft_trans_elem { /* size: 112, cachelines: 2, members: 4 */
 struct nft_trans_flowtable { /* size: 128, cachelines: 2, members: 5 */
 struct nft_trans_obj { /* size: 112, cachelines: 2, members: 4 */
 struct nft_trans_rule { /* size: 112, cachelines: 2, members: 5 */
 struct nft_trans_set { /* size: 120, cachelines: 2, members: 8 */
 struct nft_trans_table { /* size: 96, cachelines: 2, members: 2 */

Of particular interest is nft_trans_elem, which needs to be allocated
once for each pending (to be added or removed) set element.

Add BUILD_BUG_ON to check struct nft_trans is placed at the top of
the container structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 162 +++++++++++++++++-------------
 net/netfilter/nf_tables_api.c     |  18 +++-
 2 files changed, 105 insertions(+), 75 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2796153b03da..b25df037fceb 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1608,14 +1608,16 @@ static inline int nft_set_elem_is_dead(const struct nft_set_ext *ext)
 }
 
 /**
- *	struct nft_trans - nf_tables object update in transaction
+ * struct nft_trans - nf_tables object update in transaction
  *
- *	@list: used internally
- *	@binding_list: list of objects with possible bindings
- *	@msg_type: message type
- *	@put_net: ctx->net needs to be put
- *	@ctx: transaction context
- *	@data: internal information related to the transaction
+ * @list: used internally
+ * @binding_list: list of objects with possible bindings
+ * @msg_type: message type
+ * @put_net: ctx->net needs to be put
+ * @ctx: transaction context
+ *
+ * This is the information common to all objects in the transaction,
+ * this must always be the first member of derived sub-types.
  */
 struct nft_trans {
 	struct list_head		list;
@@ -1623,26 +1625,29 @@ struct nft_trans {
 	int				msg_type;
 	bool				put_net;
 	struct nft_ctx			ctx;
-	char				data[];
 };
 
 struct nft_trans_rule {
+	struct nft_trans		nft_trans;
 	struct nft_rule			*rule;
 	struct nft_flow_rule		*flow;
 	u32				rule_id;
 	bool				bound;
 };
 
-#define nft_trans_rule(trans)	\
-	(((struct nft_trans_rule *)trans->data)->rule)
-#define nft_trans_flow_rule(trans)	\
-	(((struct nft_trans_rule *)trans->data)->flow)
-#define nft_trans_rule_id(trans)	\
-	(((struct nft_trans_rule *)trans->data)->rule_id)
-#define nft_trans_rule_bound(trans)	\
-	(((struct nft_trans_rule *)trans->data)->bound)
+#define nft_trans_container_rule(trans)			\
+	container_of(trans, struct nft_trans_rule, nft_trans)
+#define nft_trans_rule(trans)				\
+	nft_trans_container_rule(trans)->rule
+#define nft_trans_flow_rule(trans)			\
+	nft_trans_container_rule(trans)->flow
+#define nft_trans_rule_id(trans)			\
+	nft_trans_container_rule(trans)->rule_id
+#define nft_trans_rule_bound(trans)			\
+	nft_trans_container_rule(trans)->bound
 
 struct nft_trans_set {
+	struct nft_trans		nft_trans;
 	struct nft_set			*set;
 	u32				set_id;
 	u32				gc_int;
@@ -1652,22 +1657,25 @@ struct nft_trans_set {
 	u32				size;
 };
 
-#define nft_trans_set(trans)	\
-	(((struct nft_trans_set *)trans->data)->set)
-#define nft_trans_set_id(trans)	\
-	(((struct nft_trans_set *)trans->data)->set_id)
-#define nft_trans_set_bound(trans)	\
-	(((struct nft_trans_set *)trans->data)->bound)
-#define nft_trans_set_update(trans)	\
-	(((struct nft_trans_set *)trans->data)->update)
-#define nft_trans_set_timeout(trans)	\
-	(((struct nft_trans_set *)trans->data)->timeout)
-#define nft_trans_set_gc_int(trans)	\
-	(((struct nft_trans_set *)trans->data)->gc_int)
-#define nft_trans_set_size(trans)	\
-	(((struct nft_trans_set *)trans->data)->size)
+#define nft_trans_container_set(trans)			\
+	container_of(trans, struct nft_trans_set, nft_trans)
+#define nft_trans_set(trans)				\
+	nft_trans_container_set(trans)->set
+#define nft_trans_set_id(trans)				\
+	nft_trans_container_set(trans)->set_id
+#define nft_trans_set_bound(trans)			\
+	nft_trans_container_set(trans)->bound
+#define nft_trans_set_update(trans)			\
+	nft_trans_container_set(trans)->update
+#define nft_trans_set_timeout(trans)			\
+	nft_trans_container_set(trans)->timeout
+#define nft_trans_set_gc_int(trans)			\
+	nft_trans_container_set(trans)->gc_int
+#define nft_trans_set_size(trans)			\
+	nft_trans_container_set(trans)->size
 
 struct nft_trans_chain {
+	struct nft_trans		nft_trans;
 	struct nft_chain		*chain;
 	bool				update;
 	char				*name;
@@ -1679,73 +1687,87 @@ struct nft_trans_chain {
 	struct list_head		hook_list;
 };
 
-#define nft_trans_chain(trans)	\
-	(((struct nft_trans_chain *)trans->data)->chain)
-#define nft_trans_chain_update(trans)	\
-	(((struct nft_trans_chain *)trans->data)->update)
-#define nft_trans_chain_name(trans)	\
-	(((struct nft_trans_chain *)trans->data)->name)
-#define nft_trans_chain_stats(trans)	\
-	(((struct nft_trans_chain *)trans->data)->stats)
-#define nft_trans_chain_policy(trans)	\
-	(((struct nft_trans_chain *)trans->data)->policy)
-#define nft_trans_chain_bound(trans)	\
-	(((struct nft_trans_chain *)trans->data)->bound)
-#define nft_trans_chain_id(trans)	\
-	(((struct nft_trans_chain *)trans->data)->chain_id)
-#define nft_trans_basechain(trans)	\
-	(((struct nft_trans_chain *)trans->data)->basechain)
-#define nft_trans_chain_hooks(trans)	\
-	(((struct nft_trans_chain *)trans->data)->hook_list)
+#define nft_trans_container_chain(trans)		\
+	container_of(trans, struct nft_trans_chain, nft_trans)
+#define nft_trans_chain(trans)				\
+	nft_trans_container_chain(trans)->chain
+#define nft_trans_chain_update(trans)			\
+	nft_trans_container_chain(trans)->update
+#define nft_trans_chain_name(trans)			\
+	nft_trans_container_chain(trans)->name
+#define nft_trans_chain_stats(trans)			\
+	nft_trans_container_chain(trans)->stats
+#define nft_trans_chain_policy(trans)			\
+	nft_trans_container_chain(trans)->policy
+#define nft_trans_chain_bound(trans)			\
+	nft_trans_container_chain(trans)->bound
+#define nft_trans_chain_id(trans)			\
+	nft_trans_container_chain(trans)->chain_id
+#define nft_trans_basechain(trans)			\
+	nft_trans_container_chain(trans)->basechain
+#define nft_trans_chain_hooks(trans)			\
+	nft_trans_container_chain(trans)->hook_list
 
 struct nft_trans_table {
+	struct nft_trans		nft_trans;
 	bool				update;
 };
 
-#define nft_trans_table_update(trans)	\
-	(((struct nft_trans_table *)trans->data)->update)
+#define nft_trans_container_table(trans)		\
+	container_of(trans, struct nft_trans_table, nft_trans)
+#define nft_trans_table_update(trans)			\
+	nft_trans_container_table(trans)->update
 
 struct nft_trans_elem {
+	struct nft_trans		nft_trans;
 	struct nft_set			*set;
 	struct nft_elem_priv		*elem_priv;
 	bool				bound;
 };
 
-#define nft_trans_elem_set(trans)	\
-	(((struct nft_trans_elem *)trans->data)->set)
-#define nft_trans_elem_priv(trans)	\
-	(((struct nft_trans_elem *)trans->data)->elem_priv)
-#define nft_trans_elem_set_bound(trans)	\
-	(((struct nft_trans_elem *)trans->data)->bound)
+#define nft_trans_container_elem(t)			\
+	container_of(t, struct nft_trans_elem, nft_trans)
+#define nft_trans_elem_set(trans)			\
+	nft_trans_container_elem(trans)->set
+#define nft_trans_elem_priv(trans)			\
+	nft_trans_container_elem(trans)->elem_priv
+#define nft_trans_elem_set_bound(trans)			\
+	nft_trans_container_elem(trans)->bound
 
 struct nft_trans_obj {
+	struct nft_trans		nft_trans;
 	struct nft_object		*obj;
 	struct nft_object		*newobj;
 	bool				update;
 };
 
-#define nft_trans_obj(trans)	\
-	(((struct nft_trans_obj *)trans->data)->obj)
-#define nft_trans_obj_newobj(trans) \
-	(((struct nft_trans_obj *)trans->data)->newobj)
-#define nft_trans_obj_update(trans)	\
-	(((struct nft_trans_obj *)trans->data)->update)
+#define nft_trans_container_obj(t)			\
+	container_of(t, struct nft_trans_obj, nft_trans)
+#define nft_trans_obj(trans)				\
+	nft_trans_container_obj(trans)->obj
+#define nft_trans_obj_newobj(trans)			\
+	nft_trans_container_obj(trans)->newobj
+#define nft_trans_obj_update(trans)			\
+	nft_trans_container_obj(trans)->update
 
 struct nft_trans_flowtable {
+	struct nft_trans		nft_trans;
 	struct nft_flowtable		*flowtable;
 	bool				update;
 	struct list_head		hook_list;
 	u32				flags;
 };
 
-#define nft_trans_flowtable(trans)	\
-	(((struct nft_trans_flowtable *)trans->data)->flowtable)
-#define nft_trans_flowtable_update(trans)	\
-	(((struct nft_trans_flowtable *)trans->data)->update)
-#define nft_trans_flowtable_hooks(trans)	\
-	(((struct nft_trans_flowtable *)trans->data)->hook_list)
-#define nft_trans_flowtable_flags(trans)	\
-	(((struct nft_trans_flowtable *)trans->data)->flags)
+#define nft_trans_container_flowtable(t)		\
+	container_of(t, struct nft_trans_flowtable, nft_trans)
+#define nft_trans_flowtable(trans)			\
+	nft_trans_container_flowtable(trans)->flowtable
+#define nft_trans_flowtable_update(trans)		\
+	nft_trans_container_flowtable(trans)->update
+#define nft_trans_flowtable_hooks(trans)		\
+	nft_trans_container_flowtable(trans)->hook_list
+#define nft_trans_flowtable_flags(trans)		\
+	nft_trans_container_flowtable(trans)->flags
 
 #define NFT_TRANS_GC_BATCHCOUNT	256
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index be3b4c90d2ed..19edd1bcecef 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -153,7 +153,7 @@ static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
 {
 	struct nft_trans *trans;
 
-	trans = kzalloc(sizeof(struct nft_trans) + size, gfp);
+	trans = kzalloc(size, gfp);
 	if (trans == NULL)
 		return NULL;
 
@@ -10348,7 +10348,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 					     trans->msg_type, GFP_KERNEL);
 			break;
 		case NFT_MSG_NEWSETELEM:
-			te = (struct nft_trans_elem *)trans->data;
+			te = nft_trans_container_elem(trans);
 
 			nft_setelem_activate(net, te->set, te->elem_priv);
 			nf_tables_setelem_notify(&trans->ctx, te->set,
@@ -10363,7 +10363,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELSETELEM:
 		case NFT_MSG_DESTROYSETELEM:
-			te = (struct nft_trans_elem *)trans->data;
+			te = nft_trans_container_elem(trans);
 
 			nf_tables_setelem_notify(&trans->ctx, te->set,
 						 te->elem_priv,
@@ -10643,7 +10643,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 				break;
 			}
-			te = (struct nft_trans_elem *)trans->data;
+			te = nft_trans_container_elem(trans);
 			nft_setelem_remove(net, te->set, te->elem_priv);
 			if (!nft_setelem_is_catchall(te->set, te->elem_priv))
 				atomic_dec(&te->set->nelems);
@@ -10656,7 +10656,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_DELSETELEM:
 		case NFT_MSG_DESTROYSETELEM:
-			te = (struct nft_trans_elem *)trans->data;
+			te = nft_trans_container_elem(trans);
 
 			if (!nft_setelem_active_next(net, te->set, te->elem_priv)) {
 				nft_setelem_data_activate(net, te->set, te->elem_priv);
@@ -11588,6 +11588,14 @@ static int __init nf_tables_module_init(void)
 {
 	int err;
 
+	BUILD_BUG_ON(offsetof(struct nft_trans_table, nft_trans) != 0);
+	BUILD_BUG_ON(offsetof(struct nft_trans_chain, nft_trans) != 0);
+	BUILD_BUG_ON(offsetof(struct nft_trans_rule, nft_trans) != 0);
+	BUILD_BUG_ON(offsetof(struct nft_trans_set, nft_trans) != 0);
+	BUILD_BUG_ON(offsetof(struct nft_trans_elem, nft_trans) != 0);
+	BUILD_BUG_ON(offsetof(struct nft_trans_obj, nft_trans) != 0);
+	BUILD_BUG_ON(offsetof(struct nft_trans_flowtable, nft_trans) != 0);
+
 	err = register_pernet_subsys(&nf_tables_net_ops);
 	if (err < 0)
 		return err;
-- 
2.30.2

