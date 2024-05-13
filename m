Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9459B1509BF
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 13:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605813; cv=none; b=FbKA8eiHxZ3vw7wnt3DBx2dY8iNCW/PFuG8dUHDR82DcpVT+5t9I/IB/VDM9erEBtB4MuaqYr+4I33iCUh+HBmMjWJg/zMPImYJK98k3BT9seWCdNmIpGQjuG9XnEWfrC5X772bwuIAuwI0eZpPRxPl3WdmCIidwi6pnL9Lg8lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605813; c=relaxed/simple;
	bh=GEupfRtNO/hKQMkXs0Xf9OfK9AvKiTQ+JO4CTzVGXlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWOjCHE53yIkrsE3K3P6N74bipUSDsQhci7i7K/oY4+5sXXJ/batZzebxdsyxXG2HRez3p4YWsr8I9YColDtv6J/i/rjIu1k0CHvm7rkgo5UT1AVLNyi+J2snNUhHDrTJdGYdoZusQdowb/sGjyNkb5wxuskOCOewTQxamPFv3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6VRS-0001Qu-B0; Mon, 13 May 2024 15:10:10 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 11/11] netfilter: nf_tables: do not store nft_ctx in transaction objects
Date: Mon, 13 May 2024 15:00:51 +0200
Message-ID: <20240513130057.11014-12-fw@strlen.de>
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

nft_ctx is huge and most of the information stored within isn't used
at all.

Remove nft_ctx member from the base transaction structure and store
only what is needed.

After this change, relevant struct sizes are:

struct nft_trans_chain { /* size: 120 (-32), cachelines: 2, members: 10 */
struct nft_trans_elem { /* size: 72 (-40), cachelines: 2, members: 4 */
struct nft_trans_flowtable { /* size: 80 (-48), cachelines: 2, members: 5 */
struct nft_trans_obj { /* size: 72 (-40), cachelines: 2, members: 4 */
struct nft_trans_rule { /* size: 80 (-32), cachelines: 2, members: 6 */
struct nft_trans_set { /* size: 96 (-24), cachelines: 2, members: 8 */
struct nft_trans_table { /* size: 56 (-40), cachelines: 1, members: 2 */

struct nft_trans_elem can now be allocated from kmalloc-96 instead of
kmalloc-128 slab.
A further reduction by 8 bytes would even allow for kmalloc-64.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  43 ++++++++-
 net/netfilter/nf_tables_api.c     | 140 +++++++++++++++++-------------
 net/netfilter/nf_tables_offload.c |   8 +-
 3 files changed, 125 insertions(+), 66 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 11a38fcf4dec..8ca4a027f0e5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1611,18 +1611,26 @@ static inline int nft_set_elem_is_dead(const struct nft_set_ext *ext)
  * struct nft_trans - nf_tables object update in transaction
  *
  * @list: used internally
+ * @net: struct net
+ * @table: struct nft_table the object resides in
  * @msg_type: message type
- * @put_net: ctx->net needs to be put
- * @ctx: transaction context
+ * @seq: netlink sequence number
+ * @flags: modifiers to new request
+ * @report: notify via unicast netlink message
+ * @put_net: net needs to be put
  *
  * This is the information common to all objects in the transaction,
  * this must always be the first member of derived sub-types.
  */
 struct nft_trans {
 	struct list_head		list;
+	struct net			*net;
+	struct nft_table		*table;
 	int				msg_type;
-	bool				put_net;
-	struct nft_ctx			ctx;
+	u32				seq;
+	u16				flags;
+	u8				report:1;
+	u8				put_net:1;
 };
 
 /**
@@ -1786,6 +1794,33 @@ struct nft_trans_gc {
 	struct rcu_head		rcu;
 };
 
+static inline void nft_ctx_update(struct nft_ctx *ctx,
+				  const struct nft_trans *trans)
+{
+	switch (trans->msg_type) {
+	case NFT_MSG_NEWRULE:
+	case NFT_MSG_DELRULE:
+	case NFT_MSG_DESTROYRULE:
+		ctx->chain = nft_trans_rule_chain(trans);
+		break;
+	case NFT_MSG_NEWCHAIN:
+	case NFT_MSG_DELCHAIN:
+	case NFT_MSG_DESTROYCHAIN:
+		ctx->chain = nft_trans_chain(trans);
+		break;
+	default:
+		ctx->chain = NULL;
+		break;
+	}
+
+	ctx->net = trans->net;
+	ctx->table = trans->table;
+	ctx->family = trans->table->family;
+	ctx->report = trans->report;
+	ctx->flags = trans->flags;
+	ctx->seq = trans->seq;
+}
+
 struct nft_trans_gc *nft_trans_gc_alloc(struct nft_set *set,
 					unsigned int gc_seq, gfp_t gfp);
 void nft_trans_gc_destroy(struct nft_trans_gc *trans);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 769c5ced7f2e..6e9cbaca6009 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -159,7 +159,12 @@ static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
 
 	INIT_LIST_HEAD(&trans->list);
 	trans->msg_type = msg_type;
-	trans->ctx	= *ctx;
+
+	trans->net = ctx->net;
+	trans->table = ctx->table;
+	trans->seq = ctx->seq;
+	trans->flags = ctx->flags;
+	trans->report = ctx->report;
 
 	return trans;
 }
@@ -1257,7 +1262,7 @@ static bool nft_table_pending_update(const struct nft_ctx *ctx)
 		return true;
 
 	list_for_each_entry(trans, &nft_net->commit_list, list) {
-		if (trans->ctx.table == ctx->table &&
+		if (trans->table == ctx->table &&
 		    ((trans->msg_type == NFT_MSG_NEWCHAIN &&
 		      nft_trans_chain_update(trans)) ||
 		     (trans->msg_type == NFT_MSG_DELCHAIN &&
@@ -2099,7 +2104,7 @@ static void nft_chain_stats_replace(struct nft_trans_chain *trans)
 
 	trans->stats =
 		rcu_replace_pointer(chain->stats, trans->stats,
-				    lockdep_commit_lock_is_held(t->ctx.net));
+				    lockdep_commit_lock_is_held(t->net));
 
 	if (!trans->stats)
 		static_branch_inc(&nft_counters_enabled);
@@ -2765,7 +2770,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		err = -EEXIST;
 		list_for_each_entry(tmp, &nft_net->commit_list, list) {
 			if (tmp->msg_type == NFT_MSG_NEWCHAIN &&
-			    tmp->ctx.table == table &&
+			    tmp->table == table &&
 			    nft_trans_chain_update(tmp) &&
 			    nft_trans_chain_name(tmp) &&
 			    strcmp(name, nft_trans_chain_name(tmp)) == 0) {
@@ -9471,7 +9476,7 @@ static void nft_chain_commit_drop_policy(struct nft_trans_chain *trans)
 
 static void nft_chain_commit_update(struct nft_trans_chain *trans)
 {
-	struct nft_table *table = trans->nft_trans_binding.nft_trans.ctx.table;
+	struct nft_table *table = trans->nft_trans_binding.nft_trans.table;
 	struct nft_base_chain *basechain;
 
 	if (trans->name) {
@@ -9500,7 +9505,8 @@ static void nft_chain_commit_update(struct nft_trans_chain *trans)
 	}
 }
 
-static void nft_obj_commit_update(struct nft_trans *trans)
+static void nft_obj_commit_update(const struct nft_ctx *ctx,
+				  struct nft_trans *trans)
 {
 	struct nft_object *newobj;
 	struct nft_object *obj;
@@ -9512,15 +9518,21 @@ static void nft_obj_commit_update(struct nft_trans *trans)
 		return;
 
 	obj->ops->update(obj, newobj);
-	nft_obj_destroy(&trans->ctx, newobj);
+	nft_obj_destroy(ctx, newobj);
 }
 
 static void nft_commit_release(struct nft_trans *trans)
 {
+	struct nft_ctx ctx = {
+		.net = trans->net,
+	};
+
+	nft_ctx_update(&ctx, trans);
+
 	switch (trans->msg_type) {
 	case NFT_MSG_DELTABLE:
 	case NFT_MSG_DESTROYTABLE:
-		nf_tables_table_destroy(trans->ctx.table);
+		nf_tables_table_destroy(trans->table);
 		break;
 	case NFT_MSG_NEWCHAIN:
 		free_percpu(nft_trans_chain_stats(trans));
@@ -9535,21 +9547,21 @@ static void nft_commit_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_DELRULE:
 	case NFT_MSG_DESTROYRULE:
-		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
+		nf_tables_rule_destroy(&ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_DELSET:
 	case NFT_MSG_DESTROYSET:
-		nft_set_destroy(&trans->ctx, nft_trans_set(trans));
+		nft_set_destroy(&ctx, nft_trans_set(trans));
 		break;
 	case NFT_MSG_DELSETELEM:
 	case NFT_MSG_DESTROYSETELEM:
-		nf_tables_set_elem_destroy(&trans->ctx,
+		nf_tables_set_elem_destroy(&ctx,
 					   nft_trans_elem_set(trans),
 					   nft_trans_elem_priv(trans));
 		break;
 	case NFT_MSG_DELOBJ:
 	case NFT_MSG_DESTROYOBJ:
-		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans));
+		nft_obj_destroy(&ctx, nft_trans_obj(trans));
 		break;
 	case NFT_MSG_DELFLOWTABLE:
 	case NFT_MSG_DESTROYFLOWTABLE:
@@ -9561,7 +9573,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	}
 
 	if (trans->put_net)
-		put_net(trans->ctx.net);
+		put_net(trans->net);
 
 	kfree(trans);
 }
@@ -10041,7 +10053,7 @@ static void nf_tables_commit_release(struct net *net)
 
 	trans = list_last_entry(&nft_net->commit_list,
 				struct nft_trans, list);
-	get_net(trans->ctx.net);
+	get_net(trans->net);
 	WARN_ON_ONCE(trans->put_net);
 
 	trans->put_net = true;
@@ -10185,6 +10197,7 @@ static void nft_gc_seq_end(struct nftables_pernet *nft_net, unsigned int gc_seq)
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
+	const struct nlmsghdr *nlh = nlmsg_hdr(skb);
 	struct nft_trans_binding *trans_binding;
 	struct nft_trans *trans, *next;
 	unsigned int base_seq, gc_seq;
@@ -10192,6 +10205,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
+	struct nft_ctx ctx;
 	LIST_HEAD(adl);
 	int err;
 
@@ -10200,6 +10214,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		return 0;
 	}
 
+	nft_ctx_init(&ctx, net, skb, nlh, NFPROTO_UNSPEC, NULL, NULL, NULL);
+
 	list_for_each_entry(trans_binding, &nft_net->binding_list, binding_list) {
 		trans = &trans_binding->nft_trans;
 		switch (trans->msg_type) {
@@ -10237,7 +10253,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
-		struct nft_table *table = trans->ctx.table;
+		struct nft_table *table = trans->table;
 		int ret;
 
 		ret = nf_tables_commit_audit_alloc(&adl, table);
@@ -10281,7 +10297,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	net->nft.gencursor = nft_gencursor_next(net);
 
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
-		struct nft_table *table = trans->ctx.table;
+		struct nft_table *table = trans->table;
+
+		nft_ctx_update(&ctx, trans);
 
 		nf_tables_commit_audit_collect(&adl, table, trans->msg_type);
 		switch (trans->msg_type) {
@@ -10298,18 +10316,18 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			} else {
 				nft_clear(net, table);
 			}
-			nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
+			nf_tables_table_notify(&ctx, NFT_MSG_NEWTABLE);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELTABLE:
 		case NFT_MSG_DESTROYTABLE:
 			list_del_rcu(&table->list);
-			nf_tables_table_notify(&trans->ctx, trans->msg_type);
+			nf_tables_table_notify(&ctx, trans->msg_type);
 			break;
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
 				nft_chain_commit_update(nft_trans_container_chain(trans));
-				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN,
+				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN,
 						       &nft_trans_chain_hooks(trans));
 				list_splice(&nft_trans_chain_hooks(trans),
 					    &nft_trans_basechain(trans)->hook_list);
@@ -10317,14 +10335,14 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			} else {
 				nft_chain_commit_drop_policy(nft_trans_container_chain(trans));
 				nft_clear(net, nft_trans_chain(trans));
-				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN, NULL);
+				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN, NULL);
 				nft_trans_destroy(trans);
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
 		case NFT_MSG_DESTROYCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
+				nf_tables_chain_notify(&ctx, NFT_MSG_DELCHAIN,
 						       &nft_trans_chain_hooks(trans));
 				if (!(table->flags & NFT_TABLE_F_DORMANT)) {
 					nft_netdev_unregister_hooks(net,
@@ -10333,16 +10351,15 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				}
 			} else {
 				nft_chain_del(nft_trans_chain(trans));
-				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
+				nf_tables_chain_notify(&ctx, NFT_MSG_DELCHAIN,
 						       NULL);
-				nf_tables_unregister_hook(trans->ctx.net, table,
+				nf_tables_unregister_hook(ctx.net, ctx.table,
 							  nft_trans_chain(trans));
 			}
 			break;
 		case NFT_MSG_NEWRULE:
-			nft_clear(trans->ctx.net, nft_trans_rule(trans));
-			nf_tables_rule_notify(&trans->ctx,
-					      nft_trans_rule(trans),
+			nft_clear(net, nft_trans_rule(trans));
+			nf_tables_rule_notify(&ctx, nft_trans_rule(trans),
 					      NFT_MSG_NEWRULE);
 			if (nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
@@ -10352,11 +10369,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DELRULE:
 		case NFT_MSG_DESTROYRULE:
 			list_del_rcu(&nft_trans_rule(trans)->list);
-			nf_tables_rule_notify(&trans->ctx,
-					      nft_trans_rule(trans),
+			nf_tables_rule_notify(&ctx, nft_trans_rule(trans),
 					      trans->msg_type);
-			nft_rule_expr_deactivate(&trans->ctx,
-						 nft_trans_rule(trans),
+			nft_rule_expr_deactivate(&ctx, nft_trans_rule(trans),
 						 NFT_TRANS_COMMIT);
 
 			if (nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD)
@@ -10380,7 +10395,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				    !list_empty(&nft_trans_set(trans)->bindings))
 					nft_use_dec(&table->use);
 			}
-			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
+			nf_tables_set_notify(&ctx, nft_trans_set(trans),
 					     NFT_MSG_NEWSET, GFP_KERNEL);
 			nft_trans_destroy(trans);
 			break;
@@ -10388,14 +10403,14 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DESTROYSET:
 			nft_trans_set(trans)->dead = 1;
 			list_del_rcu(&nft_trans_set(trans)->list);
-			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
+			nf_tables_set_notify(&ctx, nft_trans_set(trans),
 					     trans->msg_type, GFP_KERNEL);
 			break;
 		case NFT_MSG_NEWSETELEM:
 			te = nft_trans_container_elem(trans);
 
 			nft_setelem_activate(net, te->set, te->elem_priv);
-			nf_tables_setelem_notify(&trans->ctx, te->set,
+			nf_tables_setelem_notify(&ctx, te->set,
 						 te->elem_priv,
 						 NFT_MSG_NEWSETELEM);
 			if (te->set->ops->commit &&
@@ -10409,7 +10424,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DESTROYSETELEM:
 			te = nft_trans_container_elem(trans);
 
-			nf_tables_setelem_notify(&trans->ctx, te->set,
+			nf_tables_setelem_notify(&ctx, te->set,
 						 te->elem_priv,
 						 trans->msg_type);
 			nft_setelem_remove(net, te->set, te->elem_priv);
@@ -10425,13 +10440,13 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
-				nft_obj_commit_update(trans);
-				nf_tables_obj_notify(&trans->ctx,
+				nft_obj_commit_update(&ctx, trans);
+				nf_tables_obj_notify(&ctx,
 						     nft_trans_obj(trans),
 						     NFT_MSG_NEWOBJ);
 			} else {
 				nft_clear(net, nft_trans_obj(trans));
-				nf_tables_obj_notify(&trans->ctx,
+				nf_tables_obj_notify(&ctx,
 						     nft_trans_obj(trans),
 						     NFT_MSG_NEWOBJ);
 				nft_trans_destroy(trans);
@@ -10440,14 +10455,14 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DELOBJ:
 		case NFT_MSG_DESTROYOBJ:
 			nft_obj_del(nft_trans_obj(trans));
-			nf_tables_obj_notify(&trans->ctx, nft_trans_obj(trans),
+			nf_tables_obj_notify(&ctx, nft_trans_obj(trans),
 					     trans->msg_type);
 			break;
 		case NFT_MSG_NEWFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
 				nft_trans_flowtable(trans)->data.flags =
 					nft_trans_flowtable_flags(trans);
-				nf_tables_flowtable_notify(&trans->ctx,
+				nf_tables_flowtable_notify(&ctx,
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
 							   NFT_MSG_NEWFLOWTABLE);
@@ -10455,7 +10470,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 					    &nft_trans_flowtable(trans)->hook_list);
 			} else {
 				nft_clear(net, nft_trans_flowtable(trans));
-				nf_tables_flowtable_notify(&trans->ctx,
+				nf_tables_flowtable_notify(&ctx,
 							   nft_trans_flowtable(trans),
 							   NULL,
 							   NFT_MSG_NEWFLOWTABLE);
@@ -10465,7 +10480,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DELFLOWTABLE:
 		case NFT_MSG_DESTROYFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				nf_tables_flowtable_notify(&trans->ctx,
+				nf_tables_flowtable_notify(&ctx,
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
 							   trans->msg_type);
@@ -10473,7 +10488,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 								   &nft_trans_flowtable_hooks(trans));
 			} else {
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
-				nf_tables_flowtable_notify(&trans->ctx,
+				nf_tables_flowtable_notify(&ctx,
 							   nft_trans_flowtable(trans),
 							   NULL,
 							   trans->msg_type);
@@ -10515,9 +10530,13 @@ static void nf_tables_module_autoload(struct net *net)
 
 static void nf_tables_abort_release(struct nft_trans *trans)
 {
+	struct nft_ctx ctx = { };
+
+	nft_ctx_update(&ctx, trans);
+
 	switch (trans->msg_type) {
 	case NFT_MSG_NEWTABLE:
-		nf_tables_table_destroy(trans->ctx.table);
+		nf_tables_table_destroy(trans->table);
 		break;
 	case NFT_MSG_NEWCHAIN:
 		if (nft_trans_chain_update(trans))
@@ -10526,17 +10545,17 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 			nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_NEWRULE:
-		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
+		nf_tables_rule_destroy(&ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_NEWSET:
-		nft_set_destroy(&trans->ctx, nft_trans_set(trans));
+		nft_set_destroy(&ctx, nft_trans_set(trans));
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
 				     nft_trans_elem_priv(trans), true);
 		break;
 	case NFT_MSG_NEWOBJ:
-		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans));
+		nft_obj_destroy(&ctx, nft_trans_obj(trans));
 		break;
 	case NFT_MSG_NEWFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
@@ -10569,6 +10588,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	LIST_HEAD(set_update_list);
 	struct nft_trans_elem *te;
 	int err = 0;
+	struct nft_ctx ctx = {
+		.net = net,
+	};
 
 	if (action == NFNL_ABORT_VALIDATE &&
 	    nf_tables_validate(net) < 0)
@@ -10576,7 +10598,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
 					 list) {
-		struct nft_table *table = trans->ctx.table;
+		struct nft_table *table = trans->table;
+
+		nft_ctx_update(&ctx, trans);
 
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
@@ -10603,7 +10627,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_DELTABLE:
 		case NFT_MSG_DESTROYTABLE:
-			nft_clear(trans->ctx.net, table);
+			nft_clear(trans->net, table);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWCHAIN:
@@ -10623,7 +10647,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				}
 				nft_use_dec_restore(&table->use);
 				nft_chain_del(nft_trans_chain(trans));
-				nf_tables_unregister_hook(trans->ctx.net, table,
+				nf_tables_unregister_hook(trans->net, table,
 							  nft_trans_chain(trans));
 			}
 			break;
@@ -10634,7 +10658,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 					    &nft_trans_basechain(trans)->hook_list);
 			} else {
 				nft_use_inc_restore(&table->use);
-				nft_clear(trans->ctx.net, nft_trans_chain(trans));
+				nft_clear(trans->net, nft_trans_chain(trans));
 			}
 			nft_trans_destroy(trans);
 			break;
@@ -10645,7 +10669,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			}
 			nft_use_dec_restore(&nft_trans_rule_chain(trans)->use);
 			list_del_rcu(&nft_trans_rule(trans)->list);
-			nft_rule_expr_deactivate(&trans->ctx,
+			nft_rule_expr_deactivate(&ctx,
 						 nft_trans_rule(trans),
 						 NFT_TRANS_ABORT);
 			if (nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD)
@@ -10654,8 +10678,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELRULE:
 		case NFT_MSG_DESTROYRULE:
 			nft_use_inc_restore(&nft_trans_rule_chain(trans)->use);
-			nft_clear(trans->ctx.net, nft_trans_rule(trans));
-			nft_rule_expr_activate(&trans->ctx, nft_trans_rule(trans));
+			nft_clear(trans->net, nft_trans_rule(trans));
+			nft_rule_expr_activate(&ctx, nft_trans_rule(trans));
 			if (nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 
@@ -10677,9 +10701,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELSET:
 		case NFT_MSG_DESTROYSET:
 			nft_use_inc_restore(&table->use);
-			nft_clear(trans->ctx.net, nft_trans_set(trans));
+			nft_clear(trans->net, nft_trans_set(trans));
 			if (nft_trans_set(trans)->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
-				nft_map_activate(&trans->ctx, nft_trans_set(trans));
+				nft_map_activate(&ctx, nft_trans_set(trans));
 
 			nft_trans_destroy(trans);
 			break;
@@ -10719,7 +10743,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
-				nft_obj_destroy(&trans->ctx, nft_trans_obj_newobj(trans));
+				nft_obj_destroy(&ctx, nft_trans_obj_newobj(trans));
 				nft_trans_destroy(trans);
 			} else {
 				nft_use_dec_restore(&table->use);
@@ -10729,7 +10753,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELOBJ:
 		case NFT_MSG_DESTROYOBJ:
 			nft_use_inc_restore(&table->use);
-			nft_clear(trans->ctx.net, nft_trans_obj(trans));
+			nft_clear(trans->net, nft_trans_obj(trans));
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWFLOWTABLE:
@@ -10750,7 +10774,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 					    &nft_trans_flowtable(trans)->hook_list);
 			} else {
 				nft_use_inc_restore(&table->use);
-				nft_clear(trans->ctx.net, nft_trans_flowtable(trans));
+				nft_clear(trans->net, nft_trans_flowtable(trans));
 			}
 			nft_trans_destroy(trans);
 			break;
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 0619feb10abb..64675f1c7f29 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -513,7 +513,7 @@ static void nft_flow_rule_offload_abort(struct net *net,
 	int err = 0;
 
 	list_for_each_entry_continue_reverse(trans, &nft_net->commit_list, list) {
-		if (trans->ctx.family != NFPROTO_NETDEV)
+		if (trans->table->family != NFPROTO_NETDEV)
 			continue;
 
 		switch (trans->msg_type) {
@@ -564,7 +564,7 @@ int nft_flow_rule_offload_commit(struct net *net)
 	u8 policy;
 
 	list_for_each_entry(trans, &nft_net->commit_list, list) {
-		if (trans->ctx.family != NFPROTO_NETDEV)
+		if (trans->table->family != NFPROTO_NETDEV)
 			continue;
 
 		switch (trans->msg_type) {
@@ -589,8 +589,8 @@ int nft_flow_rule_offload_commit(struct net *net)
 			if (!(nft_trans_rule_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			if (trans->ctx.flags & NLM_F_REPLACE ||
-			    !(trans->ctx.flags & NLM_F_APPEND)) {
+			if (trans->flags & NLM_F_REPLACE ||
+			    !(trans->flags & NLM_F_APPEND)) {
 				err = -EOPNOTSUPP;
 				break;
 			}
-- 
2.43.2

