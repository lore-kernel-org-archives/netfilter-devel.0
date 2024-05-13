Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A17C1514D6
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 13:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605773; cv=none; b=UA4F1zZAxXTaTy9MCl2MBkXhlWlcFjcvZBaE0YQn0H3upPqLoyb6j4s0dKdT6fsDBab9l1FRogC1ZOAgy/7sv0AuZFv+Uz2pXOLn155wWRCum5Yv7XDh21JfR5L6xuVe98btzRSZBzD5CCk3xeNXb6TCf6MZh4o8CJNm/o+tnGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605773; c=relaxed/simple;
	bh=s5qErG1Pe67SSFhbv7p4QmREoW2DcA0KEqurk1Z5VqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxFGN+lFE7LvANv4jmNFPJbFSeeLdjBsPSwfxf/Jnn5ePsO0uMVmWel0/vBtTXJD89SlGpBuD6zHvhONZHpPD5c26P/U/9YhWTOoG35o52FhqL6MvQAflUtRGFecdFxdRW3/qcg4WvFwWL4rgxErSQAQc7EzgFXrbu9tZkcgHtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6VQn-0001Om-KU; Mon, 13 May 2024 15:09:29 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 01/11] netfilter: nf_tables: make struct nft_trans first member of derived subtypes
Date: Mon, 13 May 2024 15:00:41 +0200
Message-ID: <20240513130057.11014-2-fw@strlen.de>
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

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 88 +++++++++++++++++--------------
 net/netfilter/nf_tables_api.c     | 10 ++--
 2 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2796153b03da..af0ef21f3780 100644
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
@@ -1623,10 +1625,10 @@ struct nft_trans {
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
@@ -1634,15 +1636,16 @@ struct nft_trans_rule {
 };
 
 #define nft_trans_rule(trans)	\
-	(((struct nft_trans_rule *)trans->data)->rule)
+	container_of(trans, struct nft_trans_rule, nft_trans)->rule
 #define nft_trans_flow_rule(trans)	\
-	(((struct nft_trans_rule *)trans->data)->flow)
+	container_of(trans, struct nft_trans_rule, nft_trans)->flow
 #define nft_trans_rule_id(trans)	\
-	(((struct nft_trans_rule *)trans->data)->rule_id)
+	container_of(trans, struct nft_trans_rule, nft_trans)->rule_id
 #define nft_trans_rule_bound(trans)	\
-	(((struct nft_trans_rule *)trans->data)->bound)
+	container_of(trans, struct nft_trans_rule, nft_trans)->bound
 
 struct nft_trans_set {
+	struct nft_trans		nft_trans;
 	struct nft_set			*set;
 	u32				set_id;
 	u32				gc_int;
@@ -1653,21 +1656,22 @@ struct nft_trans_set {
 };
 
 #define nft_trans_set(trans)	\
-	(((struct nft_trans_set *)trans->data)->set)
+	container_of(trans, struct nft_trans_set, nft_trans)->set
 #define nft_trans_set_id(trans)	\
-	(((struct nft_trans_set *)trans->data)->set_id)
+	container_of(trans, struct nft_trans_set, nft_trans)->set_id
 #define nft_trans_set_bound(trans)	\
-	(((struct nft_trans_set *)trans->data)->bound)
+	container_of(trans, struct nft_trans_set, nft_trans)->bound
 #define nft_trans_set_update(trans)	\
-	(((struct nft_trans_set *)trans->data)->update)
+	container_of(trans, struct nft_trans_set, nft_trans)->update
 #define nft_trans_set_timeout(trans)	\
-	(((struct nft_trans_set *)trans->data)->timeout)
+	container_of(trans, struct nft_trans_set, nft_trans)->timeout
 #define nft_trans_set_gc_int(trans)	\
-	(((struct nft_trans_set *)trans->data)->gc_int)
+	container_of(trans, struct nft_trans_set, nft_trans)->gc_int
 #define nft_trans_set_size(trans)	\
-	(((struct nft_trans_set *)trans->data)->size)
+	container_of(trans, struct nft_trans_set, nft_trans)->size
 
 struct nft_trans_chain {
+	struct nft_trans		nft_trans;
 	struct nft_chain		*chain;
 	bool				update;
 	char				*name;
@@ -1680,58 +1684,64 @@ struct nft_trans_chain {
 };
 
 #define nft_trans_chain(trans)	\
-	(((struct nft_trans_chain *)trans->data)->chain)
+	container_of(trans, struct nft_trans_chain, nft_trans)->chain
 #define nft_trans_chain_update(trans)	\
-	(((struct nft_trans_chain *)trans->data)->update)
+	container_of(trans, struct nft_trans_chain, nft_trans)->update
 #define nft_trans_chain_name(trans)	\
-	(((struct nft_trans_chain *)trans->data)->name)
+	container_of(trans, struct nft_trans_chain, nft_trans)->name
 #define nft_trans_chain_stats(trans)	\
-	(((struct nft_trans_chain *)trans->data)->stats)
+	container_of(trans, struct nft_trans_chain, nft_trans)->stats
 #define nft_trans_chain_policy(trans)	\
-	(((struct nft_trans_chain *)trans->data)->policy)
+	container_of(trans, struct nft_trans_chain, nft_trans)->policy
 #define nft_trans_chain_bound(trans)	\
-	(((struct nft_trans_chain *)trans->data)->bound)
+	container_of(trans, struct nft_trans_chain, nft_trans)->bound
 #define nft_trans_chain_id(trans)	\
-	(((struct nft_trans_chain *)trans->data)->chain_id)
+	container_of(trans, struct nft_trans_chain, nft_trans)->chain_id
 #define nft_trans_basechain(trans)	\
-	(((struct nft_trans_chain *)trans->data)->basechain)
+	container_of(trans, struct nft_trans_chain, nft_trans)->basechain
 #define nft_trans_chain_hooks(trans)	\
-	(((struct nft_trans_chain *)trans->data)->hook_list)
+	container_of(trans, struct nft_trans_chain, nft_trans)->hook_list
 
 struct nft_trans_table {
+	struct nft_trans		nft_trans;
 	bool				update;
 };
 
 #define nft_trans_table_update(trans)	\
-	(((struct nft_trans_table *)trans->data)->update)
+	container_of(trans, struct nft_trans_table, nft_trans)->update
 
 struct nft_trans_elem {
+	struct nft_trans		nft_trans;
 	struct nft_set			*set;
 	struct nft_elem_priv		*elem_priv;
 	bool				bound;
 };
 
+#define nft_trans_container_elem(t)	\
+	container_of(t, struct nft_trans_elem, nft_trans)
 #define nft_trans_elem_set(trans)	\
-	(((struct nft_trans_elem *)trans->data)->set)
+	container_of(trans, struct nft_trans_elem, nft_trans)->set
 #define nft_trans_elem_priv(trans)	\
-	(((struct nft_trans_elem *)trans->data)->elem_priv)
+	container_of(trans, struct nft_trans_elem, nft_trans)->elem_priv
 #define nft_trans_elem_set_bound(trans)	\
-	(((struct nft_trans_elem *)trans->data)->bound)
+	container_of(trans, struct nft_trans_elem, nft_trans)->bound
 
 struct nft_trans_obj {
+	struct nft_trans		nft_trans;
 	struct nft_object		*obj;
 	struct nft_object		*newobj;
 	bool				update;
 };
 
 #define nft_trans_obj(trans)	\
-	(((struct nft_trans_obj *)trans->data)->obj)
+	container_of(trans, struct nft_trans_obj, nft_trans)->obj
 #define nft_trans_obj_newobj(trans) \
-	(((struct nft_trans_obj *)trans->data)->newobj)
+	container_of(trans, struct nft_trans_obj, nft_trans)->newobj
 #define nft_trans_obj_update(trans)	\
-	(((struct nft_trans_obj *)trans->data)->update)
+	container_of(trans, struct nft_trans_obj, nft_trans)->update
 
 struct nft_trans_flowtable {
+	struct nft_trans		nft_trans;
 	struct nft_flowtable		*flowtable;
 	bool				update;
 	struct list_head		hook_list;
@@ -1739,13 +1749,13 @@ struct nft_trans_flowtable {
 };
 
 #define nft_trans_flowtable(trans)	\
-	(((struct nft_trans_flowtable *)trans->data)->flowtable)
+	container_of(trans, struct nft_trans_flowtable, nft_trans)->flowtable
 #define nft_trans_flowtable_update(trans)	\
-	(((struct nft_trans_flowtable *)trans->data)->update)
+	container_of(trans, struct nft_trans_flowtable, nft_trans)->update
 #define nft_trans_flowtable_hooks(trans)	\
-	(((struct nft_trans_flowtable *)trans->data)->hook_list)
+	container_of(trans, struct nft_trans_flowtable, nft_trans)->hook_list
 #define nft_trans_flowtable_flags(trans)	\
-	(((struct nft_trans_flowtable *)trans->data)->flags)
+	container_of(trans, struct nft_trans_flowtable, nft_trans)->flags
 
 #define NFT_TRANS_GC_BATCHCOUNT	256
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index be3b4c90d2ed..cd355f63b1d2 100644
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
-- 
2.43.2

