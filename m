From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/7] netfilter: nf_tables: move chain handling to the transaction infrastructure
Date: Thu, 27 Mar 2014 22:53:16 +0100
Message-ID: <1395957197-4899-7-git-send-email-pablo@netfilter.org>
References: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49519 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405AbaC0Vxg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:53:36 -0400
In-Reply-To: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch speeds up rule-set updates and it helps to leave chains
in consistent state when processing a batch. Note this patch does
not introduce a way to revert chain updates, eg. counter or default
policy changes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    2 +
 net/netfilter/nf_tables_api.c     |  199 ++++++++++++++++++++++++++++++-------
 2 files changed, 164 insertions(+), 37 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 02e990d..c489ead 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -343,6 +343,7 @@ struct nft_rule {
 };
 
 enum nft_trans_type {
+	NFT_TRANS_CHAIN,
 	NFT_TRANS_RULE,
 	NFT_TRANS_SET,
 };
@@ -364,6 +365,7 @@ struct nft_trans {
 			struct nft_set	*set;
 			u32		set_id;
 		};
+		bool			update;
 	};
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0b2fb07..11b9d91 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -566,6 +566,27 @@ static struct nft_chain *nf_tables_chain_lookup(const struct nft_table *table,
 	return ERR_PTR(-ENOENT);
 }
 
+static struct nft_chain *
+nf_tables_chain_lookup_trans(struct net *net,
+			     const struct nft_table *table,
+			     const struct nlattr *nla)
+{
+	struct nft_trans *trans;
+
+	if (nla == NULL)
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(trans, &net->nft.commit_list, list) {
+		if (trans->type != NFT_TRANS_CHAIN)
+			continue;
+
+		if (!nla_strcmp(nla, trans->ctx.chain->name))
+			return trans->ctx.chain;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+
 static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 	[NFTA_CHAIN_TABLE]	= { .type = NLA_STRING },
 	[NFTA_CHAIN_HANDLE]	= { .type = NLA_U64 },
@@ -838,6 +859,53 @@ nf_tables_counters(struct nft_base_chain *chain, const struct nlattr *attr)
 	return 0;
 }
 
+/* Internal chain flags */
+#define __NFT_CHAIN_DYING	(1 << 7)
+
+static int nft_chain_trans_add(struct nft_ctx *ctx, int msg_type)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, NFT_TRANS_CHAIN);
+	if (trans == NULL)
+		return -ENOMEM;
+
+	if (msg_type == NFT_MSG_DELCHAIN) {
+		/* You cannot delete the same chain twice */
+		if (ctx->chain->flags & __NFT_CHAIN_DYING) {
+			kfree(trans);
+			return -ENOENT;
+		}
+		ctx->chain->flags |= __NFT_CHAIN_DYING;
+	}
+
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	return 0;
+}
+
+static void nft_chain_destroy(struct nft_chain *chain)
+{
+	if (chain->flags & NFT_BASE_CHAIN) {
+		module_put(nft_base_chain(chain)->type->owner);
+		free_percpu(nft_base_chain(chain)->stats);
+		kfree(nft_base_chain(chain));
+	} else {
+		kfree(chain);
+	}
+}
+
+static void nf_tables_chain_destroy(struct nft_ctx *ctx)
+{
+	BUG_ON(ctx->chain->use > 0);
+
+	if (!(ctx->table->flags & NFT_TABLE_F_DORMANT) &&
+	    ctx->chain->flags & NFT_BASE_CHAIN) {
+		nf_unregister_hooks(nft_base_chain(ctx->chain)->ops,
+				    ctx->afi->nops);
+	}
+	nft_chain_destroy(ctx->chain);
+}
+
 static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -856,6 +924,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	unsigned int i;
 	int err;
 	bool create;
+	struct nft_ctx ctx;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
@@ -901,6 +970,8 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	if (chain != NULL) {
+		struct nft_trans *trans;
+
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
@@ -910,14 +981,23 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		    !IS_ERR(nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME])))
 			return -EEXIST;
 
+		nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
+		trans = nft_trans_alloc(&ctx, NFT_TRANS_CHAIN);
+		if (trans == NULL)
+			return -ENOMEM;
+
+		trans->update = true;
+
 		if (nla[NFTA_CHAIN_COUNTERS]) {
 			if (!(chain->flags & NFT_BASE_CHAIN))
 				return -EOPNOTSUPP;
 
 			err = nf_tables_counters(nft_base_chain(chain),
 						 nla[NFTA_CHAIN_COUNTERS]);
-			if (err < 0)
+			if (err < 0) {
+				kfree(trans);
 				return err;
+			}
 		}
 
 		if (nla[NFTA_CHAIN_POLICY])
@@ -926,7 +1006,8 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		if (nla[NFTA_CHAIN_HANDLE] && name)
 			nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
 
-		goto notify;
+		list_add_tail(&trans->list, &net->nft.commit_list);
+		return 0;
 	}
 
 	if (table->use == UINT_MAX)
@@ -1024,31 +1105,43 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
 	    chain->flags & NFT_BASE_CHAIN) {
 		err = nf_register_hooks(nft_base_chain(chain)->ops, afi->nops);
-		if (err < 0) {
-			module_put(basechain->type->owner);
-			free_percpu(basechain->stats);
-			kfree(basechain);
-			return err;
-		}
+		if (err < 0)
+			goto err1;
 	}
-	list_add_tail(&chain->list, &table->chains);
-	table->use++;
-notify:
-	nf_tables_chain_notify(skb, nlh, table, chain, NFT_MSG_NEWCHAIN,
-			       family);
+
+	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
+	err = nft_chain_trans_add(&ctx, NFT_MSG_NEWCHAIN);
+	if (err < 0)
+		goto err2;
+
 	return 0;
+err2:
+	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
+	    chain->flags & NFT_BASE_CHAIN) {
+		nf_unregister_hooks(nft_base_chain(chain)->ops,
+				    afi->nops);
+	}
+err1:
+	nft_chain_destroy(chain);
+	return err;
 }
 
-static void nf_tables_chain_destroy(struct nft_chain *chain)
+static void nft_chain_add(struct nft_trans *trans)
 {
-	BUG_ON(chain->use > 0);
+	list_add_tail(&trans->ctx.chain->list, &trans->ctx.table->chains);
+	trans->ctx.table->use++;
+	nf_tables_chain_notify(trans->ctx.skb, trans->ctx.nlh,
+			       trans->ctx.table, trans->ctx.chain,
+			       NFT_MSG_NEWCHAIN,
+			       trans->ctx.afi->family);
+}
 
-	if (chain->flags & NFT_BASE_CHAIN) {
-		module_put(nft_base_chain(chain)->type->owner);
-		free_percpu(nft_base_chain(chain)->stats);
-		kfree(nft_base_chain(chain));
-	} else
-		kfree(chain);
+static void nft_chain_del(struct nft_ctx *ctx)
+{
+	list_del(&ctx->chain->list);
+	ctx->table->use--;
+	nf_tables_chain_notify(ctx->skb, ctx->nlh, ctx->table, ctx->chain,
+			       NFT_MSG_DELCHAIN, ctx->afi->family);
 }
 
 static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
@@ -1061,6 +1154,8 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_chain *chain;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
+	struct nft_ctx ctx;
+	int err;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
@@ -1077,20 +1172,11 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 	if (!list_empty(&chain->rules) || chain->use > 0)
 		return -EBUSY;
 
-	list_del(&chain->list);
-	table->use--;
-
-	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
-	    chain->flags & NFT_BASE_CHAIN)
-		nf_unregister_hooks(nft_base_chain(chain)->ops, afi->nops);
-
-	nf_tables_chain_notify(skb, nlh, table, chain, NFT_MSG_DELCHAIN,
-			       family);
-
-	/* Make sure all rule references are gone before this is released */
-	synchronize_rcu();
+	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
+	err = nft_chain_trans_add(&ctx, NFT_MSG_DELCHAIN);
+	if (err < 0)
+		return err;
 
-	nf_tables_chain_destroy(chain);
 	return 0;
 }
 
@@ -1617,7 +1703,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	chain = nf_tables_chain_lookup(table, nla[NFTA_RULE_CHAIN]);
+	chain = nf_tables_chain_lookup_trans(net, table, nla[NFTA_RULE_CHAIN]);
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
 
@@ -2920,7 +3006,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_table_policy,
 	},
 	[NFT_MSG_NEWCHAIN] = {
-		.call		= nf_tables_newchain,
+		.call_batch	= nf_tables_newchain,
 		.attr_count	= NFTA_CHAIN_MAX,
 		.policy		= nft_chain_policy,
 	},
@@ -2930,7 +3016,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_chain_policy,
 	},
 	[NFT_MSG_DELCHAIN] = {
-		.call		= nf_tables_delchain,
+		.call_batch	= nf_tables_delchain,
 		.attr_count	= NFTA_CHAIN_MAX,
 		.policy		= nft_chain_policy,
 	},
@@ -2981,6 +3067,25 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	},
 };
 
+static void nft_chain_commit_update(struct nft_trans *trans)
+{
+	if (trans->ctx.chain->flags & __NFT_CHAIN_DYING) {
+		nft_chain_del(&trans->ctx);
+	} else {
+		list_del(&trans->list);
+		if (trans->update) {
+			nf_tables_chain_notify(trans->ctx.skb, trans->ctx.nlh,
+					       trans->ctx.table,
+					       trans->ctx.chain,
+					       NFT_MSG_NEWCHAIN,
+					       trans->ctx.afi->family);
+		} else {
+			nft_chain_add(trans);
+		}
+		kfree(trans);
+	}
+}
+
 static void nft_rule_commit_update(struct net *net, struct sk_buff *skb,
 				   struct nft_trans *trans)
 {
@@ -3039,6 +3144,9 @@ static int nf_tables_commit(struct sk_buff *skb)
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->type) {
+		case NFT_TRANS_CHAIN:
+			nft_chain_commit_update(trans);
+			break;
 		case NFT_TRANS_RULE:
 			nft_rule_commit_update(net, skb, trans);
 			break;
@@ -3055,6 +3163,10 @@ static int nf_tables_commit(struct sk_buff *skb)
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		list_del(&trans->list);
 		switch (trans->type) {
+		case NFT_TRANS_CHAIN:
+			trans->ctx.chain->flags &= ~__NFT_CHAIN_DYING;
+			nf_tables_chain_destroy(&trans->ctx);
+			break;
 		case NFT_TRANS_RULE:
 			nf_tables_rule_destroy(&trans->ctx, trans->rule);
 			break;
@@ -3088,6 +3200,14 @@ static void nft_rule_abort_undo(struct net *net, struct sk_buff *skb,
 	list_del_rcu(&trans->rule->list);
 }
 
+static void nft_chain_abort(struct nft_trans *trans)
+{
+	if (trans->ctx.chain->flags & __NFT_CHAIN_DYING)
+		trans->ctx.chain->flags &= ~__NFT_CHAIN_DYING;
+	else if (!trans->update)
+		nf_tables_chain_destroy(&trans->ctx);
+}
+
 static void nft_set_abort(struct nft_trans *trans)
 {
 	/* This set was scheduled for removal, clear the dying flags to leave
@@ -3107,6 +3227,8 @@ static int nf_tables_abort(struct sk_buff *skb)
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->type) {
+		case NFT_TRANS_CHAIN:
+			break;
 		case NFT_TRANS_RULE:
 			nft_rule_abort_undo(net, skb, trans);
 			break;
@@ -3121,6 +3243,9 @@ static int nf_tables_abort(struct sk_buff *skb)
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		list_del(&trans->list);
 		switch (trans->type) {
+		case NFT_TRANS_CHAIN:
+			nft_chain_abort(trans);
+			break;
 		case NFT_TRANS_RULE:
 			/* Release new rules, already removed from the list,
 			 * that we couldn't activate.
-- 
1.7.10.4

