Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C3E1C232D;
	Fri, 28 Jun 2024 16:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719590725; cv=none; b=jDiss9YkTWPjeob8pHhNAl3eZhbwjomBPb5rF2JoggLrpc4dXe4avGXRWeZairHcJZpdpGAxl8NQkYGOZ9EP/oY8gtlDxmSO0l6sMOZvk1aQ7wnoTvOYzlaYf7WJOkeWZ0tNzhLQbQbM2Tp1byyfCpmo3fJGY244Z6LNHQwJs+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719590725; c=relaxed/simple;
	bh=wooU4l5AQp8klnwF36cI8oQCizntwv7uyB+6k1RW7uE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aX+1oJY8eIInHSUox1C2OCE+63E17bPzmAtSqlZVwWIa4aWQ3rS+lgQmyxBK+2d7g4NH8+fy03D4DZu30ppgIjTdtvE1YS/uq2sD8CsXbKMpqYNd/c51rZePbgKxf0cq1cH/OB7TzvP3/Tz42BOxGnkzfCeIb7PXjCZ66nTWSJ0=
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
Subject: [PATCH net-next 04/17] netfilter: nf_tables: reduce trans->ctx.table references
Date: Fri, 28 Jun 2024 18:04:52 +0200
Message-Id: <20240628160505.161283-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240628160505.161283-1-pablo@netfilter.org>
References: <20240628160505.161283-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

nft_ctx is huge, it should not be stored in nft_trans at all,
most information is not needed.

Preparation patch to remove trans->ctx, no change in behaviour intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 79 ++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c950938ef612..60c435774db8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9472,14 +9472,15 @@ static void nft_chain_commit_drop_policy(struct nft_trans *trans)
 
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
@@ -10237,9 +10238,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
+		struct nft_table *table = trans->ctx.table;
 		int ret;
 
-		ret = nf_tables_commit_audit_alloc(&adl, trans->ctx.table);
+		ret = nf_tables_commit_audit_alloc(&adl, table);
 		if (ret) {
 			nf_tables_commit_chain_prepare_cancel(net);
 			nf_tables_commit_audit_free(&adl);
@@ -10280,28 +10282,29 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -10324,7 +10327,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			if (nft_trans_chain_update(trans)) {
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
 						       &nft_trans_chain_hooks(trans));
-				if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT)) {
+				if (!(table->flags & NFT_TABLE_F_DORMANT)) {
 					nft_netdev_unregister_hooks(net,
 								    &nft_trans_chain_hooks(trans),
 								    true);
@@ -10333,8 +10336,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_chain_del(trans->ctx.chain);
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
 						       NULL);
-				nf_tables_unregister_hook(trans->ctx.net,
-							  trans->ctx.table,
+				nf_tables_unregister_hook(trans->ctx.net, table,
 							  trans->ctx.chain);
 			}
 			break;
@@ -10377,7 +10379,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				 */
 				if (nft_set_is_anonymous(nft_trans_set(trans)) &&
 				    !list_empty(&nft_trans_set(trans)->bindings))
-					nft_use_dec(&trans->ctx.table->use);
+					nft_use_dec(&table->use);
 			}
 			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
 					     NFT_MSG_NEWSET, GFP_KERNEL);
@@ -10575,37 +10577,39 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 
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
@@ -10618,10 +10622,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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
@@ -10631,7 +10634,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				list_splice(&nft_trans_chain_hooks(trans),
 					    &nft_trans_basechain(trans)->hook_list);
 			} else {
-				nft_use_inc_restore(&trans->ctx.table->use);
+				nft_use_inc_restore(&table->use);
 				nft_clear(trans->ctx.net, trans->ctx.chain);
 			}
 			nft_trans_destroy(trans);
@@ -10664,7 +10667,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 				break;
 			}
-			nft_use_dec_restore(&trans->ctx.table->use);
+			nft_use_dec_restore(&table->use);
 			if (nft_trans_set_bound(trans)) {
 				nft_trans_destroy(trans);
 				break;
@@ -10674,7 +10677,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_DELSET:
 		case NFT_MSG_DESTROYSET:
-			nft_use_inc_restore(&trans->ctx.table->use);
+			nft_use_inc_restore(&table->use);
 			nft_clear(trans->ctx.net, nft_trans_set(trans));
 			if (nft_trans_set(trans)->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
 				nft_map_activate(&trans->ctx, nft_trans_set(trans));
@@ -10720,13 +10723,13 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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
@@ -10735,7 +10738,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_unregister_flowtable_net_hooks(net,
 						&nft_trans_flowtable_hooks(trans));
 			} else {
-				nft_use_dec_restore(&trans->ctx.table->use);
+				nft_use_dec_restore(&table->use);
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
 				nft_unregister_flowtable_net_hooks(net,
 						&nft_trans_flowtable(trans)->hook_list);
@@ -10747,7 +10750,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				list_splice(&nft_trans_flowtable_hooks(trans),
 					    &nft_trans_flowtable(trans)->hook_list);
 			} else {
-				nft_use_inc_restore(&trans->ctx.table->use);
+				nft_use_inc_restore(&table->use);
 				nft_clear(trans->ctx.net, nft_trans_flowtable(trans));
 			}
 			nft_trans_destroy(trans);
-- 
2.30.2

