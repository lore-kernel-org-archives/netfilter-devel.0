From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/10] netfilter: nf_tables: use new transaction infrastructure to handle chain
Date: Fri,  4 Apr 2014 15:48:10 +0200
Message-ID: <1396619294-26212-7-git-send-email-pablo@netfilter.org>
References: <1396619294-26212-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48520 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbaDDNsc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:48:32 -0400
In-Reply-To: <1396619294-26212-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch speeds up rule-set updates and it also introduces a way to
revert chain updates if the batch is aborted. The idea is to store the
changes in the transaction to apply that in the commit step.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   17 +++
 net/netfilter/nf_tables_api.c     |  233 +++++++++++++++++++++++++++----------
 2 files changed, 189 insertions(+), 61 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0f472d6..7b2361c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -420,6 +420,22 @@ struct nft_trans_set {
 #define nft_trans_set_id(trans)	\
 	(((struct nft_trans_set *)trans->data)->set_id)
 
+struct nft_trans_chain {
+	bool		update;
+	char		name[NFT_CHAIN_MAXNAMELEN];
+	struct nft_stats __percpu *stats;
+	u8		policy;
+};
+
+#define nft_trans_chain_update(trans)	\
+	(((struct nft_trans_chain *)trans->data)->update)
+#define nft_trans_chain_name(trans)	\
+	(((struct nft_trans_chain *)trans->data)->name)
+#define nft_trans_chain_stats(trans)	\
+	(((struct nft_trans_chain *)trans->data)->stats)
+#define nft_trans_chain_policy(trans)	\
+	(((struct nft_trans_chain *)trans->data)->policy)
+
 static inline struct nft_expr *nft_expr_first(const struct nft_rule *rule)
 {
 	return (struct nft_expr *)&rule->data[0];
@@ -452,6 +468,7 @@ static inline void *nft_userdata(const struct nft_rule *rule)
 
 enum nft_chain_flags {
 	NFT_BASE_CHAIN			= 0x1,
+	NFT_CHAIN_INACTIVE		= 0x2,
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d3a26d2..2345259 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -782,6 +782,8 @@ static int nf_tables_getchain(struct sock *nlsk, struct sk_buff *skb,
 	chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME]);
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
+	if (chain->flags & NFT_CHAIN_INACTIVE)
+		return -ENOENT;
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb2)
@@ -805,8 +807,8 @@ static const struct nla_policy nft_counter_policy[NFTA_COUNTER_MAX + 1] = {
 	[NFTA_COUNTER_BYTES]	= { .type = NLA_U64 },
 };
 
-static int
-nf_tables_counters(struct nft_base_chain *chain, const struct nlattr *attr)
+static struct nft_stats *nf_tables_stats_alloc(struct nft_base_chain *chain,
+					       const struct nlattr *attr)
 {
 	struct nlattr *tb[NFTA_COUNTER_MAX+1];
 	struct nft_stats __percpu *newstats;
@@ -815,14 +817,14 @@ nf_tables_counters(struct nft_base_chain *chain, const struct nlattr *attr)
 
 	err = nla_parse_nested(tb, NFTA_COUNTER_MAX, attr, nft_counter_policy);
 	if (err < 0)
-		return err;
+		return ERR_PTR(err);
 
 	if (!tb[NFTA_COUNTER_BYTES] || !tb[NFTA_COUNTER_PACKETS])
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	newstats = alloc_percpu(struct nft_stats);
 	if (newstats == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	/* Restore old counters on this cpu, no problem. Per-cpu statistics
 	 * are not exposed to userspace.
@@ -831,19 +833,47 @@ nf_tables_counters(struct nft_base_chain *chain, const struct nlattr *attr)
 	stats->bytes = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
 	stats->pkts = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
 
-	if (chain->stats) {
-		struct nft_stats __percpu *oldstats =
-				nft_dereference(chain->stats);
+	return newstats;
+}
 
-		rcu_assign_pointer(chain->stats, newstats);
-		synchronize_rcu();
-		free_percpu(oldstats);
-	} else
-		rcu_assign_pointer(chain->stats, newstats);
+static int nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
+{
+	struct nft_trans *trans;
 
+	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_chain));
+	if (trans == NULL)
+		return -ENOMEM;
+
+	if (msg_type == NFT_MSG_NEWCHAIN)
+		ctx->chain->flags |= NFT_CHAIN_INACTIVE;
+
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
 }
 
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
@@ -862,6 +892,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	unsigned int i;
 	int err;
 	bool create;
+	struct nft_ctx ctx;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
@@ -907,6 +938,11 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	if (chain != NULL) {
+		struct nft_stats *stats = NULL;
+		struct nft_trans *trans;
+
+		if (chain->flags & NFT_CHAIN_INACTIVE)
+			return -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
@@ -920,19 +956,30 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			if (!(chain->flags & NFT_BASE_CHAIN))
 				return -EOPNOTSUPP;
 
-			err = nf_tables_counters(nft_base_chain(chain),
-						 nla[NFTA_CHAIN_COUNTERS]);
-			if (err < 0)
-				return err;
+			stats = nf_tables_stats_alloc(nft_base_chain(chain),
+						      nla[NFTA_CHAIN_COUNTERS]);
+			if (IS_ERR(stats))
+				return PTR_ERR(stats);
 		}
 
+		nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
+		trans = nft_trans_alloc(&ctx, NFT_MSG_NEWCHAIN);
+		if (trans == NULL)
+			return -ENOMEM;
+
+		nft_trans_chain_stats(trans) = stats;
+		nft_trans_chain_update(trans) = true;
+
 		if (nla[NFTA_CHAIN_POLICY])
-			nft_base_chain(chain)->policy = policy;
+			nft_trans_chain_policy(trans) = policy;
+		else
+			nft_trans_chain_policy(trans) = -1;
 
 		if (nla[NFTA_CHAIN_HANDLE] && name)
-			nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
+			nla_strlcpy(nft_trans_chain_name(trans), name, NFT_CHAIN_MAXNAMELEN);
 
-		goto notify;
+		list_add_tail(&trans->list, &net->nft.commit_list);
+		return 0;
 	}
 
 	if (table->use == UINT_MAX)
@@ -977,9 +1024,9 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			return -ENOMEM;
 
 		if (nla[NFTA_CHAIN_COUNTERS]) {
-			err = nf_tables_counters(basechain,
-						 nla[NFTA_CHAIN_COUNTERS]);
-			if (err < 0) {
+			basechain->stats = nf_tables_stats_alloc(basechain,
+						   nla[NFTA_CHAIN_COUNTERS]);
+			if (IS_ERR(basechain->stats)) {
 				module_put(type->owner);
 				kfree(basechain);
 				return err;
@@ -1030,31 +1077,26 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
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
-	return 0;
-}
 
-static void nf_tables_chain_destroy(struct nft_chain *chain)
-{
-	BUG_ON(chain->use > 0);
+	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
+	err = nft_trans_chain_add(&ctx, NFT_MSG_NEWCHAIN);
+	if (err < 0)
+		goto err2;
 
-	if (chain->flags & NFT_BASE_CHAIN) {
-		module_put(nft_base_chain(chain)->type->owner);
-		free_percpu(nft_base_chain(chain)->stats);
-		kfree(nft_base_chain(chain));
-	} else
-		kfree(chain);
+	list_add_tail(&chain->list, &table->chains);
+	return 0;
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
 
 static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
@@ -1067,6 +1109,8 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_chain *chain;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
+	struct nft_ctx ctx;
+	int err;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
@@ -1079,24 +1123,17 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 	chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME]);
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
-
+	if (chain->flags & NFT_CHAIN_INACTIVE)
+		return -ENOENT;
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
+	err = nft_trans_chain_add(&ctx, NFT_MSG_DELCHAIN);
+	if (err < 0)
+		return err;
 
-	nf_tables_chain_destroy(chain);
+	list_del(&chain->list);
 	return 0;
 }
 
@@ -1536,6 +1573,8 @@ static int nf_tables_getrule(struct sock *nlsk, struct sk_buff *skb,
 	chain = nf_tables_chain_lookup(table, nla[NFTA_RULE_CHAIN]);
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
+	if (chain->flags & NFT_CHAIN_INACTIVE)
+		return -ENOENT;
 
 	rule = nf_tables_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
 	if (IS_ERR(rule))
@@ -3098,7 +3137,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_table_policy,
 	},
 	[NFT_MSG_NEWCHAIN] = {
-		.call		= nf_tables_newchain,
+		.call_batch	= nf_tables_newchain,
 		.attr_count	= NFTA_CHAIN_MAX,
 		.policy		= nft_chain_policy,
 	},
@@ -3108,7 +3147,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_chain_policy,
 	},
 	[NFT_MSG_DELCHAIN] = {
-		.call		= nf_tables_delchain,
+		.call_batch	= nf_tables_delchain,
 		.attr_count	= NFTA_CHAIN_MAX,
 		.policy		= nft_chain_policy,
 	},
@@ -3159,6 +3198,36 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	},
 };
 
+static void nft_chain_commit_update(struct nft_trans *trans)
+{
+	struct nft_base_chain *basechain;
+	struct nft_stats __percpu *oldstats;
+
+	if (nft_trans_chain_name(trans)[0])
+		strcpy(trans->ctx.chain->name, nft_trans_chain_name(trans));
+
+	if (!(trans->ctx.chain->flags & NFT_BASE_CHAIN))
+		return;
+
+	basechain = nft_base_chain(trans->ctx.chain);
+
+	if (basechain->stats) {
+		oldstats = nft_dereference(basechain->stats);
+		rcu_assign_pointer(basechain->stats, nft_trans_chain_stats(trans));
+		synchronize_rcu();
+		free_percpu(oldstats);
+	} else {
+		rcu_assign_pointer(basechain->stats, nft_trans_chain_stats(trans));
+	}
+
+	switch (nft_trans_chain_policy(trans)) {
+	case NF_DROP:
+	case NF_ACCEPT:
+		basechain->policy = nft_trans_chain_policy(trans);
+		break;
+	}
+}
+
 static int nf_tables_commit(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
@@ -3177,6 +3246,28 @@ static int nf_tables_commit(struct sk_buff *skb)
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
+		case NFT_MSG_NEWCHAIN:
+			if (nft_trans_chain_update(trans))
+				nft_chain_commit_update(trans);
+			else {
+				trans->ctx.chain->flags &= ~NFT_CHAIN_INACTIVE;
+				trans->ctx.table->use++;
+			}
+			nf_tables_chain_notify(trans->ctx.skb, trans->ctx.nlh,
+					       trans->ctx.table,
+					       trans->ctx.chain,
+					       NFT_MSG_NEWCHAIN,
+					       trans->ctx.afi->family);
+			nft_trans_destroy(trans);
+			break;
+		case NFT_MSG_DELCHAIN:
+			trans->ctx.table->use--;
+			nf_tables_chain_notify(trans->ctx.skb, trans->ctx.nlh,
+					       trans->ctx.table,
+					       trans->ctx.chain,
+					       NFT_MSG_DELCHAIN,
+					       trans->ctx.afi->family);
+			break;
 		case NFT_MSG_NEWRULE:
 			nft_rule_clear(trans->ctx.net, nft_trans_rule(trans));
 			nf_tables_rule_notify(trans->ctx.skb, trans->ctx.nlh,
@@ -3214,6 +3305,9 @@ static int nf_tables_commit(struct sk_buff *skb)
 	/* Now we can safely release unused old rules */
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
+		case NFT_MSG_DELCHAIN:
+			nf_tables_chain_destroy(&trans->ctx);
+			break;
 		case NFT_MSG_DELRULE:
 			nf_tables_rule_destroy(&trans->ctx,
 					       nft_trans_rule(trans));
@@ -3235,6 +3329,20 @@ static int nf_tables_abort(struct sk_buff *skb)
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
+		case NFT_MSG_NEWCHAIN:
+			if (nft_trans_chain_update(trans)) {
+				if (nft_trans_chain_stats(trans))
+					free_percpu(nft_trans_chain_stats(trans));
+
+				nft_trans_destroy(trans);
+			} else
+				list_del(&trans->ctx.chain->list);
+			break;
+		case NFT_MSG_DELCHAIN:
+			list_add_tail(&trans->ctx.chain->list,
+				      &trans->ctx.table->chains);
+			nft_trans_destroy(trans);
+			break;
 		case NFT_MSG_NEWRULE:
 			list_del_rcu(&nft_trans_rule(trans)->list);
 			break;
@@ -3258,6 +3366,9 @@ static int nf_tables_abort(struct sk_buff *skb)
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
+		case NFT_MSG_NEWCHAIN:
+			nf_tables_chain_destroy(&trans->ctx);
+			break;
 		case NFT_MSG_NEWRULE:
 			nf_tables_rule_destroy(&trans->ctx,
 					       nft_trans_rule(trans));
-- 
1.7.10.4

