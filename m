From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/8] netfilter: nf_tables: move table handling to the transaction infrastructure
Date: Sun, 30 Mar 2014 14:04:54 +0200
Message-ID: <1396181094-8140-9-git-send-email-pablo@netfilter.org>
References: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45416 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbaC3MFU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 08:05:20 -0400
In-Reply-To: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch speeds up rule-set updates and it also provides a way
to revert updates and leave things in consistent state in case that
the batch needs to be aborted.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    4 ++
 net/netfilter/nf_tables_api.c     |  143 ++++++++++++++++++++++++++++++++-----
 2 files changed, 128 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index b6f9724..3aeb64f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -365,6 +365,10 @@ struct nft_trans {
 			struct nft_stats __percpu *stats;
 			u8		policy;
 		};
+		struct {
+			bool		update_table;
+			bool		enable;
+		};
 	};
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bce2385..d96c00c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -306,6 +306,9 @@ done:
 	return skb->len;
 }
 
+/* Internal table flags */
+#define NFT_TABLE_INACTIVE	(1 << 15)
+
 static int nf_tables_gettable(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -332,6 +335,8 @@ static int nf_tables_gettable(struct sock *nlsk, struct sk_buff *skb,
 	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME]);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
+	if (table->flags & NFT_TABLE_INACTIVE)
+		return -ENOENT;
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb2)
@@ -394,9 +399,9 @@ static void nf_tables_table_disable(const struct nft_af_info *afi,
 
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(ctx->nlh);
-	int family = nfmsg->nfgen_family, ret = 0;
+	struct nft_trans *trans;
 	u32 flags;
+	int ret = 0;
 
 	if (!ctx->nla[NFTA_TABLE_FLAGS])
 		return 0;
@@ -405,25 +410,46 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if (flags & ~NFT_TABLE_F_DORMANT)
 		return -EINVAL;
 
+	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE);
+	if (trans == NULL)
+		return -ENOMEM;
+
 	if ((flags & NFT_TABLE_F_DORMANT) &&
 	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
-		nf_tables_table_disable(ctx->afi, ctx->table);
-		ctx->table->flags |= NFT_TABLE_F_DORMANT;
+		trans->enable = false;
 	} else if (!(flags & NFT_TABLE_F_DORMANT) &&
 		   ctx->table->flags & NFT_TABLE_F_DORMANT) {
 		ret = nf_tables_table_enable(ctx->afi, ctx->table);
-		if (ret >= 0)
+		if (ret >= 0) {
 			ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
+			trans->enable = true;
+		}
 	}
 	if (ret < 0)
 		goto err;
 
-	nf_tables_table_notify(ctx->skb, ctx->nlh, ctx->table,
-			       NFT_MSG_NEWTABLE, family);
+	trans->update = true;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 err:
+	nft_trans_destroy(trans);
 	return ret;
 }
 
+static int nft_table_trans_add(struct nft_ctx *ctx, int msg_type)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, msg_type);
+	if (trans == NULL)
+		return -ENOMEM;
+
+	if (msg_type == NFT_MSG_NEWTABLE)
+		ctx->table->flags |= NFT_TABLE_INACTIVE;
+
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	return 0;
+}
+
 static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -436,6 +462,7 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	int family = nfmsg->nfgen_family;
 	u32 flags = 0;
 	struct nft_ctx ctx;
+	int err;
 
 	afi = nf_tables_afinfo_lookup(net, family, true);
 	if (IS_ERR(afi))
@@ -452,6 +479,8 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	if (table != NULL) {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
+		if (table->flags & NFT_TABLE_INACTIVE)
+			return -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
@@ -479,8 +508,14 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	INIT_LIST_HEAD(&table->sets);
 	table->flags = flags;
 
+	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
+	err = nft_table_trans_add(&ctx, NFT_MSG_NEWTABLE);
+	if (err < 0) {
+		kfree(table);
+		module_put(afi->owner);
+		return err;
+	}
 	list_add_tail(&table->list, &afi->tables);
-	nf_tables_table_notify(skb, nlh, table, NFT_MSG_NEWTABLE, family);
 	return 0;
 }
 
@@ -492,7 +527,8 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct net *net = sock_net(skb->sk);
-	int family = nfmsg->nfgen_family;
+	int family = nfmsg->nfgen_family, err;
+	struct nft_ctx ctx;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
@@ -501,17 +537,27 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME]);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
+	if (table->flags & NFT_TABLE_INACTIVE)
+		return -ENOENT;
 
 	if (!list_empty(&table->chains) || !list_empty(&table->sets))
 		return -EBUSY;
 
+	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
+	err = nft_table_trans_add(&ctx, NFT_MSG_DELTABLE);
+	if (err < 0)
+		return err;
+
 	list_del(&table->list);
-	nf_tables_table_notify(skb, nlh, table, NFT_MSG_DELTABLE, family);
-	kfree(table);
-	module_put(afi->owner);
 	return 0;
 }
 
+static void nf_tables_table_destroy(struct nft_ctx *ctx)
+{
+	kfree(ctx->table);
+	module_put(ctx->afi->owner);
+}
+
 int nft_register_chain_type(const struct nf_chain_type *ctype)
 {
 	int err = 0;
@@ -775,6 +821,8 @@ static int nf_tables_getchain(struct sock *nlsk, struct sk_buff *skb,
 	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE]);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
+	if (table->flags & NFT_TABLE_INACTIVE)
+		return -ENOENT;
 
 	chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME]);
 	if (IS_ERR(chain))
@@ -1116,6 +1164,8 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE]);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
+	if (table->flags & NFT_TABLE_INACTIVE)
+		return -ENOENT;
 
 	chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME]);
 	if (IS_ERR(chain))
@@ -1566,6 +1616,8 @@ static int nf_tables_getrule(struct sock *nlsk, struct sk_buff *skb,
 	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE]);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
+	if (table->flags & NFT_TABLE_INACTIVE)
+		return -ENOENT;
 
 	chain = nf_tables_chain_lookup(table, nla[NFTA_RULE_CHAIN]);
 	if (IS_ERR(chain))
@@ -1831,6 +1883,8 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE]);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
+	if (table->flags & NFT_TABLE_INACTIVE)
+		return -ENOENT;
 
 	if (nla[NFTA_RULE_CHAIN]) {
 		chain = nf_tables_chain_lookup(table, nla[NFTA_RULE_CHAIN]);
@@ -1952,6 +2006,8 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
 		table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE]);
 		if (IS_ERR(table))
 			return PTR_ERR(table);
+		if (table->flags & NFT_TABLE_INACTIVE)
+			return -ENOENT;
 	}
 
 	nft_ctx_init(ctx, skb, nlh, afi, table, NULL, nla);
@@ -2586,7 +2642,8 @@ static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX +
 static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx,
 				      const struct sk_buff *skb,
 				      const struct nlmsghdr *nlh,
-				      const struct nlattr * const nla[])
+				      const struct nlattr * const nla[],
+				      bool trans)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	struct nft_af_info *afi;
@@ -2600,6 +2657,8 @@ static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx,
 	table = nf_tables_table_lookup(afi, nla[NFTA_SET_ELEM_LIST_TABLE]);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
+	if (!trans && (table->flags & NFT_TABLE_INACTIVE))
+		return -ENOENT;
 
 	nft_ctx_init(ctx, skb, nlh, afi, table, NULL, nla);
 	return 0;
@@ -2673,7 +2732,8 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err < 0)
 		return err;
 
-	err = nft_ctx_init_from_elemattr(&ctx, cb->skb, cb->nlh, (void *)nla);
+	err = nft_ctx_init_from_elemattr(&ctx, cb->skb, cb->nlh, (void *)nla,
+					 false);
 	if (err < 0)
 		return err;
 
@@ -2738,7 +2798,7 @@ static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_ctx ctx;
 	int err;
 
-	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla);
+	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla, false);
 	if (err < 0)
 		return err;
 
@@ -2854,7 +2914,7 @@ static int nf_tables_newsetelem(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_ctx ctx;
 	int rem, err;
 
-	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla);
+	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla, true);
 	if (err < 0)
 		return err;
 
@@ -2930,7 +2990,7 @@ static int nf_tables_delsetelem(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_ctx ctx;
 	int rem, err;
 
-	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla);
+	err = nft_ctx_init_from_elemattr(&ctx, skb, nlh, nla, false);
 	if (err < 0)
 		return err;
 
@@ -2950,7 +3010,7 @@ static int nf_tables_delsetelem(struct sock *nlsk, struct sk_buff *skb,
 
 static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	[NFT_MSG_NEWTABLE] = {
-		.call		= nf_tables_newtable,
+		.call_batch	= nf_tables_newtable,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_table_policy,
 	},
@@ -2960,7 +3020,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_table_policy,
 	},
 	[NFT_MSG_DELTABLE] = {
-		.call		= nf_tables_deltable,
+		.call_batch	= nf_tables_deltable,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_table_policy,
 	},
@@ -3074,6 +3134,28 @@ static int nf_tables_commit(struct sk_buff *skb)
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
+		case NFT_MSG_NEWTABLE:
+			if (trans->update_table) {
+				if (!trans->enable) {
+					nf_tables_table_disable(trans->ctx.afi,
+								trans->ctx.table);
+					trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
+				}
+			} else {
+				trans->ctx.table->flags &= ~NFT_TABLE_INACTIVE;
+			}
+			nf_tables_table_notify(trans->ctx.skb, trans->ctx.nlh,
+					       trans->ctx.table,
+					       NFT_MSG_NEWTABLE,
+					       trans->ctx.afi->family);
+			nft_trans_destroy(trans);
+			break;
+		case NFT_MSG_DELTABLE:
+			nf_tables_table_notify(trans->ctx.skb, trans->ctx.nlh,
+					       trans->ctx.table,
+					       NFT_MSG_DELTABLE,
+					       trans->ctx.afi->family);
+			break;
 		case NFT_MSG_NEWCHAIN:
 			if (trans->update)
 				nft_chain_commit_update(trans);
@@ -3131,6 +3213,9 @@ static int nf_tables_commit(struct sk_buff *skb)
 	/* Now we can safely release unused old rules */
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
+		case NFT_MSG_DELTABLE:
+			nf_tables_table_destroy(&trans->ctx);
+			break;
 		case NFT_MSG_DELCHAIN:
 			nf_tables_chain_destroy(&trans->ctx);
 			break;
@@ -3154,6 +3239,23 @@ static int nf_tables_abort(struct sk_buff *skb)
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
+		case NFT_MSG_NEWTABLE:
+			if (trans->update_table) {
+				if (trans->enable) {
+					nf_tables_table_disable(trans->ctx.afi,
+								trans->ctx.table);
+					trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
+				}
+				nft_trans_destroy(trans);
+			} else {
+				list_del(&trans->ctx.table->list);
+			}
+			break;
+		case NFT_MSG_DELTABLE:
+			list_add_tail(&trans->ctx.table->list,
+				      &trans->ctx.afi->tables);
+			nft_trans_destroy(trans);
+			break;
 		case NFT_MSG_NEWCHAIN:
 			if (trans->update) {
 				if (trans->stats)
@@ -3191,6 +3293,9 @@ static int nf_tables_abort(struct sk_buff *skb)
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
+		case NFT_MSG_NEWTABLE:
+			nf_tables_table_destroy(&trans->ctx);
+			break;
 		case NFT_MSG_NEWCHAIN:
 			nf_tables_chain_destroy(&trans->ctx);
 			break;
-- 
1.7.10.4

