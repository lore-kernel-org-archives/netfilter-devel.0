From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/7] netfilter: nf_tables: move table handling to the transaction infrastructure
Date: Thu, 27 Mar 2014 22:53:17 +0100
Message-ID: <1395957197-4899-8-git-send-email-pablo@netfilter.org>
References: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49520 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406AbaC0Vxg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:53:36 -0400
In-Reply-To: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch speeds up rule-set updates and it helps to leave the
table configuration in consistent state when processing a batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    1 +
 net/netfilter/nf_tables_api.c     |  189 ++++++++++++++++++++++++++++++-------
 2 files changed, 156 insertions(+), 34 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c489ead..39d5cc2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -343,6 +343,7 @@ struct nft_rule {
 };
 
 enum nft_trans_type {
+	NFT_TRANS_TABLE = 0,
 	NFT_TRANS_CHAIN,
 	NFT_TRANS_RULE,
 	NFT_TRANS_SET,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 11b9d91..917ba15 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -151,6 +151,26 @@ static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
 	return ERR_PTR(-ENOENT);
 }
 
+static struct nft_table *
+nf_tables_table_lookup_trans(struct net *net, const struct nft_af_info *afi,
+			     const struct nlattr *nla)
+{
+	struct nft_trans *trans;
+
+	if (nla == NULL)
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(trans, &net->nft.commit_list, list) {
+		if (trans->type != NFT_TRANS_TABLE)
+			continue;
+
+		if (!nla_strcmp(nla, trans->ctx.table->name))
+			return trans->ctx.table;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+
 static inline u64 nf_tables_alloc_handle(struct nft_table *table)
 {
 	return ++table->hgenerator;
@@ -389,41 +409,66 @@ static int nf_tables_table_disable(const struct nft_af_info *afi,
 	return 0;
 }
 
-static int nf_tables_updtable(struct sock *nlsk, struct sk_buff *skb,
-			      const struct nlmsghdr *nlh,
-			      const struct nlattr * const nla[],
-			      struct nft_af_info *afi, struct nft_table *table)
+static int nf_tables_updtable(struct nft_ctx *ctx)
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	int family = nfmsg->nfgen_family, ret = 0;
+	struct nft_trans *trans;
+	int ret = 0;
 
-	if (nla[NFTA_TABLE_FLAGS]) {
+	if (ctx->nla[NFTA_TABLE_FLAGS]) {
 		u32 flags;
 
-		flags = ntohl(nla_get_be32(nla[NFTA_TABLE_FLAGS]));
+		flags = ntohl(nla_get_be32(ctx->nla[NFTA_TABLE_FLAGS]));
 		if (flags & ~NFT_TABLE_F_DORMANT)
 			return -EINVAL;
 
 		if ((flags & NFT_TABLE_F_DORMANT) &&
-		    !(table->flags & NFT_TABLE_F_DORMANT)) {
-			ret = nf_tables_table_disable(afi, table);
+		    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
+			ret = nf_tables_table_disable(ctx->afi, ctx->table);
 			if (ret >= 0)
-				table->flags |= NFT_TABLE_F_DORMANT;
+				ctx->table->flags |= NFT_TABLE_F_DORMANT;
 		} else if (!(flags & NFT_TABLE_F_DORMANT) &&
-			   table->flags & NFT_TABLE_F_DORMANT) {
-			ret = nf_tables_table_enable(afi, table);
+			   ctx->table->flags & NFT_TABLE_F_DORMANT) {
+			ret = nf_tables_table_enable(ctx->afi, ctx->table);
 			if (ret >= 0)
-				table->flags &= ~NFT_TABLE_F_DORMANT;
+				ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
 		}
 		if (ret < 0)
 			goto err;
 	}
 
-	nf_tables_table_notify(skb, nlh, table, NFT_MSG_NEWTABLE, family);
+	trans = nft_trans_alloc(ctx, NFT_TRANS_TABLE);
+	if (trans == NULL)
+		return -ENOMEM;
+
+	trans->update = true;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 err:
 	return ret;
 }
 
+/* Internal table flags */
+#define __NFT_TABLE_DYING	(1 << 15)
+
+static int nft_table_trans_add(struct nft_ctx *ctx, int msg_type)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, NFT_TRANS_TABLE);
+	if (trans == NULL)
+		return -ENOMEM;
+
+	if (msg_type == NFT_MSG_DELTABLE) {
+		/* You cannot delete the same table twice */
+		if (ctx->table->flags & __NFT_TABLE_DYING)
+			return -ENOENT;
+
+		ctx->table->flags |= __NFT_TABLE_DYING;
+	}
+
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	return 0;
+}
+
 static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -435,6 +480,8 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	u32 flags = 0;
+	struct nft_ctx ctx;
+	int err;
 
 	afi = nf_tables_afinfo_lookup(net, family, true);
 	if (IS_ERR(afi))
@@ -453,7 +500,9 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
-		return nf_tables_updtable(nlsk, skb, nlh, nla, afi, table);
+
+		nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
+		return nf_tables_updtable(&ctx);
 	}
 
 	if (nla[NFTA_TABLE_FLAGS]) {
@@ -476,11 +525,23 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	INIT_LIST_HEAD(&table->sets);
 	table->flags = flags;
 
-	list_add_tail(&table->list, &afi->tables);
-	nf_tables_table_notify(skb, nlh, table, NFT_MSG_NEWTABLE, family);
+	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
+	err = nft_table_trans_add(&ctx, NFT_MSG_NEWTABLE);
+	if (err < 0) {
+		kfree(table);
+		module_put(afi->owner);
+		return err;
+	}
 	return 0;
 }
 
+static void nft_table_add(struct nft_ctx *ctx)
+{
+	list_add_tail(&ctx->table->list, &ctx->afi->tables);
+	nf_tables_table_notify(ctx->skb, ctx->nlh, ctx->table,
+			       NFT_MSG_NEWTABLE, ctx->afi->family);
+}
+
 static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -489,7 +550,8 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct net *net = sock_net(skb->sk);
-	int family = nfmsg->nfgen_family;
+	int family = nfmsg->nfgen_family, err;
+	struct nft_ctx ctx;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
@@ -502,13 +564,27 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	if (!list_empty(&table->chains) || !list_empty(&table->sets))
 		return -EBUSY;
 
-	list_del(&table->list);
-	nf_tables_table_notify(skb, nlh, table, NFT_MSG_DELTABLE, family);
-	kfree(table);
-	module_put(afi->owner);
+	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
+	err = nft_table_trans_add(&ctx, NFT_MSG_DELTABLE);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
 
+static void nf_tables_table_destroy(struct nft_ctx *ctx)
+{
+	kfree(ctx->table);
+	module_put(ctx->afi->owner);
+}
+
+static void nft_table_del(struct nft_ctx *ctx)
+{
+	list_del(&ctx->table->list);
+	nf_tables_table_notify(ctx->skb, ctx->nlh, ctx->table,
+			       NFT_MSG_DELTABLE, ctx->afi->family);
+}
+
 int nft_register_chain_type(const struct nf_chain_type *ctype)
 {
 	int err = 0;
@@ -932,7 +1008,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE]);
+	table = nf_tables_table_lookup_trans(net, afi, nla[NFTA_CHAIN_TABLE]);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -1699,7 +1775,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE]);
+	table = nf_tables_table_lookup_trans(net, afi, nla[NFTA_RULE_TABLE]);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -2436,7 +2512,7 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE]);
+	table = nf_tables_table_lookup_trans(net, afi, nla[NFTA_SET_TABLE]);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -2633,7 +2709,8 @@ static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX +
 static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx,
 				      const struct sk_buff *skb,
 				      const struct nlmsghdr *nlh,
-				      const struct nlattr * const nla[])
+				      const struct nlattr * const nla[],
+				      bool trans)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	struct nft_af_info *afi;
@@ -2644,7 +2721,13 @@ static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_SET_ELEM_LIST_TABLE]);
+	if (trans) {
+		table = nf_tables_table_lookup_trans(net, afi,
+					       nla[NFTA_SET_ELEM_LIST_TABLE]);
+	} else {
+		table = nf_tables_table_lookup(afi,
+					       nla[NFTA_SET_ELEM_LIST_TABLE]);
+	}
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -2720,7 +2803,8 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err < 0)
 		return err;
 
-	err = nft_ctx_init_from_elemattr(&ctx, cb->skb, cb->nlh, (void *)nla);
+	err = nft_ctx_init_from_elemattr(&ctx, cb->skb, cb->nlh, (void *)nla,
+					 false);
 	if (err < 0)
 		return err;
 
@@ -2783,7 +2867,7 @@ static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_ctx ctx;
 	int err;
 
-	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla);
+	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla, false);
 	if (err < 0)
 		return err;
 
@@ -2897,7 +2981,7 @@ static int nf_tables_newsetelem(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_ctx ctx;
 	int rem, err;
 
-	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla);
+	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla, true);
 	if (err < 0)
 		return err;
 
@@ -2971,7 +3055,7 @@ static int nf_tables_delsetelem(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_ctx ctx;
 	int rem, err;
 
-	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla);
+	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla, false);
 	if (err < 0)
 		return err;
 
@@ -2991,7 +3075,7 @@ static int nf_tables_delsetelem(struct sock *nlsk, struct sk_buff *skb,
 
 static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	[NFT_MSG_NEWTABLE] = {
-		.call		= nf_tables_newtable,
+		.call_batch	= nf_tables_newtable,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_table_policy,
 	},
@@ -3001,7 +3085,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_table_policy,
 	},
 	[NFT_MSG_DELTABLE] = {
-		.call		= nf_tables_deltable,
+		.call_batch	= nf_tables_deltable,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_table_policy,
 	},
@@ -3067,6 +3151,24 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	},
 };
 
+static void nft_table_commit_update(struct nft_trans *trans)
+{
+	if (trans->ctx.table->flags & __NFT_TABLE_DYING) {
+		nft_table_del(&trans->ctx);
+	} else {
+		list_del(&trans->list);
+		if (trans->update) {
+			nf_tables_table_notify(trans->ctx.skb, trans->ctx.nlh,
+					       trans->ctx.table,
+					       NFT_MSG_NEWTABLE,
+					       trans->ctx.afi->family);
+		} else {
+			nft_table_add(&trans->ctx);
+		}
+		kfree(trans);
+	}
+}
+
 static void nft_chain_commit_update(struct nft_trans *trans)
 {
 	if (trans->ctx.chain->flags & __NFT_CHAIN_DYING) {
@@ -3144,6 +3246,9 @@ static int nf_tables_commit(struct sk_buff *skb)
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->type) {
+		case NFT_TRANS_TABLE:
+			nft_table_commit_update(trans);
+			break;
 		case NFT_TRANS_CHAIN:
 			nft_chain_commit_update(trans);
 			break;
@@ -3163,6 +3268,10 @@ static int nf_tables_commit(struct sk_buff *skb)
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		list_del(&trans->list);
 		switch (trans->type) {
+		case NFT_TRANS_TABLE:
+			trans->ctx.table->flags &= ~__NFT_TABLE_DYING;
+			nf_tables_table_destroy(&trans->ctx);
+			break;
 		case NFT_TRANS_CHAIN:
 			trans->ctx.chain->flags &= ~__NFT_CHAIN_DYING;
 			nf_tables_chain_destroy(&trans->ctx);
@@ -3200,6 +3309,14 @@ static void nft_rule_abort_undo(struct net *net, struct sk_buff *skb,
 	list_del_rcu(&trans->rule->list);
 }
 
+static void nft_table_abort(struct nft_trans *trans)
+{
+	if (trans->ctx.table->flags & __NFT_TABLE_DYING)
+		trans->ctx.table->flags &= ~__NFT_TABLE_DYING;
+	else if (!trans->update)
+		nf_tables_table_destroy(&trans->ctx);
+}
+
 static void nft_chain_abort(struct nft_trans *trans)
 {
 	if (trans->ctx.chain->flags & __NFT_CHAIN_DYING)
@@ -3227,6 +3344,7 @@ static int nf_tables_abort(struct sk_buff *skb)
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->type) {
+		case NFT_TRANS_TABLE:
 		case NFT_TRANS_CHAIN:
 			break;
 		case NFT_TRANS_RULE:
@@ -3243,6 +3361,9 @@ static int nf_tables_abort(struct sk_buff *skb)
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		list_del(&trans->list);
 		switch (trans->type) {
+		case NFT_TRANS_TABLE:
+			nft_table_abort(trans);
+			break;
 		case NFT_TRANS_CHAIN:
 			nft_chain_abort(trans);
 			break;
-- 
1.7.10.4

