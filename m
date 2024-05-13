Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980C91509B5
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 13:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605785; cv=none; b=IfMsY863Dmw78w2WGwYozJPwyggFux4+yTyDr4qgqLOM283HyWEr7xe4+cKqskdKyLv1Tt7FebT4dvjY6YAOMu6P1+zHC7oOBxW3WUI1FYO5I2KxkbeT/5jY65O6CBWC8y+xjK0/K+XoPmqtTPtfFW7BbHkZZj7jWe8/ElpyJVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605785; c=relaxed/simple;
	bh=rQanv0SeIYxFssaeKi9EUdPYYUrtf+Q0sYILgAjQVUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhdIxNxrkhK1xiCD37buTG8dlEQIDeDOd8orNREkvvFH8j6OPQ2vHusbQcMe377Z/bt0mQuKiZC9vtRis1UMsoCCU1aJ5potz9q1DOeuSa0gZjoziIzn9rPk+68ZmChtnspKkWyKnUAWj0RR+s0VeT2YTCjGrtOGOGqEteEeqBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6VQz-0001PK-Qs; Mon, 13 May 2024 15:09:41 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 04/11] netfilter: nf_tables: reduce trans->ctx.table references
Date: Mon, 13 May 2024 15:00:44 +0200
Message-ID: <20240513130057.11014-5-fw@strlen.de>
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

nft_ctx is huge, it should not be stored in nft_trans at all,
most information is not needed.

Preparation patch to remove trans->ctx, no change in behaviour intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 79 ++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b82b592059ea..bd6e93d2f590 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9471,14 +9471,15 @@ static void nft_chain_commit_drop_policy(struct nft_trans *trans)
 
 static void nft_chain_commit_update(struct nft_trans *trans)
 {
+	struct nft_table *table = trans->ctx.table;
 	struct nft_base_chain *basechain;
 
 	if (nft_trans_chain_name(trans)) {
-		rhltable_remove(&trans->ctx.table->chains_ht,
+		rhltable_remove(&table->chains_ht,
 				&trans->ctx.chain->rhlhead,
 				nft_chain_ht_params);
 		swap(trans->ctx.chain->name, nft_trans_chain_name(trans));
-		rhltable_insert_key(&trans->ctx.table->chains_ht,
+		rhltable_insert_key(&table->chains_ht,
 				    trans->ctx.chain->name,
 				    &trans->ctx.chain->rhlhead,
 				    nft_chain_ht_params);
@@ -10236,9 +10237,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
+		struct nft_table *table = trans->ctx.table;
 		int ret;
 
-		ret = nf_tables_commit_audit_alloc(&adl, trans->ctx.table);
+		ret = nf_tables_commit_audit_alloc(&adl, table);
 		if (ret) {
 			nf_tables_commit_chain_prepare_cancel(net);
 			nf_tables_commit_audit_free(&adl);
@@ -10279,28 +10281,29 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	net->nft.gencursor = nft_gencursor_next(net);
 
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
-		nf_tables_commit_audit_collect(&adl, trans->ctx.table,
-					       trans->msg_type);
+		struct nft_table *table = trans->ctx.table;
+
+		nf_tables_commit_audit_collect(&adl, table, trans->msg_type);
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
-				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
+				if (!(table->flags & __NFT_TABLE_F_UPDATE)) {
 					nft_trans_destroy(trans);
 					break;
 				}
-				if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
-					nf_tables_table_disable(net, trans->ctx.table);
+				if (table->flags & NFT_TABLE_F_DORMANT)
+					nf_tables_table_disable(net, table);
 
-				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
+				table->flags &= ~__NFT_TABLE_F_UPDATE;
 			} else {
-				nft_clear(net, trans->ctx.table);
+				nft_clear(net, table);
 			}
 			nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELTABLE:
 		case NFT_MSG_DESTROYTABLE:
-			list_del_rcu(&trans->ctx.table->list);
+			list_del_rcu(&table->list);
 			nf_tables_table_notify(&trans->ctx, trans->msg_type);
 			break;
 		case NFT_MSG_NEWCHAIN:
@@ -10323,7 +10326,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			if (nft_trans_chain_update(trans)) {
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
 						       &nft_trans_chain_hooks(trans));
-				if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT)) {
+				if (!(table->flags & NFT_TABLE_F_DORMANT)) {
 					nft_netdev_unregister_hooks(net,
 								    &nft_trans_chain_hooks(trans),
 								    true);
@@ -10332,8 +10335,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_chain_del(trans->ctx.chain);
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
 						       NULL);
-				nf_tables_unregister_hook(trans->ctx.net,
-							  trans->ctx.table,
+				nf_tables_unregister_hook(trans->ctx.net, table,
 							  trans->ctx.chain);
 			}
 			break;
@@ -10376,7 +10378,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				 */
 				if (nft_set_is_anonymous(nft_trans_set(trans)) &&
 				    !list_empty(&nft_trans_set(trans)->bindings))
-					nft_use_dec(&trans->ctx.table->use);
+					nft_use_dec(&table->use);
 			}
 			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
 					     NFT_MSG_NEWSET, GFP_KERNEL);
@@ -10574,37 +10576,39 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
 					 list) {
+		struct nft_table *table = trans->ctx.table;
+
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
-				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
+				if (!(table->flags & __NFT_TABLE_F_UPDATE)) {
 					nft_trans_destroy(trans);
 					break;
 				}
-				if (trans->ctx.table->flags & __NFT_TABLE_F_WAS_DORMANT) {
-					nf_tables_table_disable(net, trans->ctx.table);
-					trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
-				} else if (trans->ctx.table->flags & __NFT_TABLE_F_WAS_AWAKEN) {
-					trans->ctx.table->flags &= ~NFT_TABLE_F_DORMANT;
+				if (table->flags & __NFT_TABLE_F_WAS_DORMANT) {
+					nf_tables_table_disable(net, table);
+					table->flags |= NFT_TABLE_F_DORMANT;
+				} else if (table->flags & __NFT_TABLE_F_WAS_AWAKEN) {
+					table->flags &= ~NFT_TABLE_F_DORMANT;
 				}
-				if (trans->ctx.table->flags & __NFT_TABLE_F_WAS_ORPHAN) {
-					trans->ctx.table->flags &= ~NFT_TABLE_F_OWNER;
-					trans->ctx.table->nlpid = 0;
+				if (table->flags & __NFT_TABLE_F_WAS_ORPHAN) {
+					table->flags &= ~NFT_TABLE_F_OWNER;
+					table->nlpid = 0;
 				}
-				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
+				table->flags &= ~__NFT_TABLE_F_UPDATE;
 				nft_trans_destroy(trans);
 			} else {
-				list_del_rcu(&trans->ctx.table->list);
+				list_del_rcu(&table->list);
 			}
 			break;
 		case NFT_MSG_DELTABLE:
 		case NFT_MSG_DESTROYTABLE:
-			nft_clear(trans->ctx.net, trans->ctx.table);
+			nft_clear(trans->ctx.net, table);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT)) {
+				if (!(table->flags & NFT_TABLE_F_DORMANT)) {
 					nft_netdev_unregister_hooks(net,
 								    &nft_trans_chain_hooks(trans),
 								    true);
@@ -10617,10 +10621,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 					nft_trans_destroy(trans);
 					break;
 				}
-				nft_use_dec_restore(&trans->ctx.table->use);
+				nft_use_dec_restore(&table->use);
 				nft_chain_del(trans->ctx.chain);
-				nf_tables_unregister_hook(trans->ctx.net,
-							  trans->ctx.table,
+				nf_tables_unregister_hook(trans->ctx.net, table,
 							  trans->ctx.chain);
 			}
 			break;
@@ -10630,7 +10633,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				list_splice(&nft_trans_chain_hooks(trans),
 					    &nft_trans_basechain(trans)->hook_list);
 			} else {
-				nft_use_inc_restore(&trans->ctx.table->use);
+				nft_use_inc_restore(&table->use);
 				nft_clear(trans->ctx.net, trans->ctx.chain);
 			}
 			nft_trans_destroy(trans);
@@ -10663,7 +10666,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 				break;
 			}
-			nft_use_dec_restore(&trans->ctx.table->use);
+			nft_use_dec_restore(&table->use);
 			if (nft_trans_set_bound(trans)) {
 				nft_trans_destroy(trans);
 				break;
@@ -10673,7 +10676,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_DELSET:
 		case NFT_MSG_DESTROYSET:
-			nft_use_inc_restore(&trans->ctx.table->use);
+			nft_use_inc_restore(&table->use);
 			nft_clear(trans->ctx.net, nft_trans_set(trans));
 			if (nft_trans_set(trans)->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
 				nft_map_activate(&trans->ctx, nft_trans_set(trans));
@@ -10719,13 +10722,13 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_obj_destroy(&trans->ctx, nft_trans_obj_newobj(trans));
 				nft_trans_destroy(trans);
 			} else {
-				nft_use_dec_restore(&trans->ctx.table->use);
+				nft_use_dec_restore(&table->use);
 				nft_obj_del(nft_trans_obj(trans));
 			}
 			break;
 		case NFT_MSG_DELOBJ:
 		case NFT_MSG_DESTROYOBJ:
-			nft_use_inc_restore(&trans->ctx.table->use);
+			nft_use_inc_restore(&table->use);
 			nft_clear(trans->ctx.net, nft_trans_obj(trans));
 			nft_trans_destroy(trans);
 			break;
@@ -10734,7 +10737,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_unregister_flowtable_net_hooks(net,
 						&nft_trans_flowtable_hooks(trans));
 			} else {
-				nft_use_dec_restore(&trans->ctx.table->use);
+				nft_use_dec_restore(&table->use);
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
 				nft_unregister_flowtable_net_hooks(net,
 						&nft_trans_flowtable(trans)->hook_list);
@@ -10746,7 +10749,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				list_splice(&nft_trans_flowtable_hooks(trans),
 					    &nft_trans_flowtable(trans)->hook_list);
 			} else {
-				nft_use_inc_restore(&trans->ctx.table->use);
+				nft_use_inc_restore(&table->use);
 				nft_clear(trans->ctx.net, nft_trans_flowtable(trans));
 			}
 			nft_trans_destroy(trans);
-- 
2.43.2

