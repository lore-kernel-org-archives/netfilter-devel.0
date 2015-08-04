From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/3] netfilter: nf_tables: add generation mask to chain objects
Date: Tue,  4 Aug 2015 11:05:27 +0200
Message-ID: <1438679128-4146-2-git-send-email-pablo@netfilter.org>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42679 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674AbbHDI7i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 04:59:38 -0400
In-Reply-To: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the generation mask approach to obtain a consistent list of chain objects
from netlink dump commands.

Get rid of the internal NFT_CHAIN_INACTIVE flag.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    5 +-
 net/netfilter/nf_tables_api.c     |   96 +++++++++++++++++++++++++++----------
 2 files changed, 75 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1b94bf2..04ae9f2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -717,7 +717,6 @@ static inline struct nft_userdata *nft_userdata(const struct nft_rule *rule)
 
 enum nft_chain_flags {
 	NFT_BASE_CHAIN			= 0x1,
-	NFT_CHAIN_INACTIVE		= 0x2,
 };
 
 /**
@@ -730,6 +729,7 @@ enum nft_chain_flags {
  *	@use: number of jump references to this chain
  *	@level: length of longest path to this chain
  *	@flags: bitmask of enum nft_chain_flags
+ *	@genmask: generation mask
  *	@name: name of the chain
  */
 struct nft_chain {
@@ -739,7 +739,8 @@ struct nft_chain {
 	u64				handle;
 	u32				use;
 	u16				level;
-	u8				flags;
+	u8				flags:6,
+					genmask:2;
 	char				name[NFT_CHAIN_MAXNAMELEN];
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cee7326..62293a34 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -230,6 +230,36 @@ static int nft_deltable(struct nft_ctx *ctx)
 	return err;
 }
 
+static inline bool
+nft_chain_is_active(struct net *net, const struct nft_chain *chain)
+{
+	return (chain->genmask & nft_genmask_cur(net)) == 0;
+}
+
+static inline int
+nft_chain_is_active_next(struct net *net, const struct nft_chain *chain)
+{
+	return (chain->genmask & nft_genmask_next(net)) == 0;
+}
+
+static inline void
+nft_chain_activate_next(struct net *net, struct nft_chain *chain)
+{
+	/* Now inactive, will be active in the future */
+	chain->genmask = nft_genmask_cur(net);
+}
+
+static inline void
+nft_chain_deactivate_next(struct net *net, struct nft_chain *chain)
+{
+	chain->genmask = nft_genmask_next(net);
+}
+
+static inline void nft_chain_clear(struct net *net, struct nft_chain *chain)
+{
+	chain->genmask &= ~nft_genmask_next(net);
+}
+
 static int nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
 {
 	struct nft_trans *trans;
@@ -239,7 +269,7 @@ static int nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
 		return -ENOMEM;
 
 	if (msg_type == NFT_MSG_NEWCHAIN)
-		ctx->chain->flags |= NFT_CHAIN_INACTIVE;
+		nft_chain_activate_next(ctx->net, ctx->chain);
 
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
@@ -254,7 +284,7 @@ static int nft_delchain(struct nft_ctx *ctx)
 		return err;
 
 	ctx->table->use--;
-	list_del_rcu(&ctx->chain->list);
+	nft_chain_deactivate_next(ctx->net, ctx->chain);
 
 	return err;
 }
@@ -921,20 +951,33 @@ nf_tables_chain_lookup_byhandle(const struct nft_table *table, u64 handle)
 	return ERR_PTR(-ENOENT);
 }
 
-static struct nft_chain *nf_tables_chain_lookup(const struct nft_table *table,
-						const struct nlattr *nla)
+static struct nft_chain *nft_chain_lookup(const struct nft_table *table,
+					  const struct nlattr *nla)
 {
 	struct nft_chain *chain;
 
-	if (nla == NULL)
-		return ERR_PTR(-EINVAL);
-
 	list_for_each_entry(chain, &table->chains, list) {
 		if (!nla_strcmp(nla, chain->name))
 			return chain;
 	}
+	return NULL;
+}
 
-	return ERR_PTR(-ENOENT);
+static struct nft_chain *nf_tables_chain_lookup(struct net *net,
+						const struct nft_table *table,
+						const struct nlattr *nla,
+						bool trans)
+{
+	struct nft_chain *chain;
+
+	if (nla == NULL)
+		return ERR_PTR(-EINVAL);
+
+	chain = nft_chain_lookup(table, nla);
+	if (chain == NULL || (trans && !nft_chain_is_active_next(net, chain)))
+		return ERR_PTR(-ENOENT);
+
+	return chain;
 }
 
 static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
@@ -1110,6 +1153,8 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 				if (idx > s_idx)
 					memset(&cb->args[1], 0,
 					       sizeof(cb->args) - sizeof(cb->args[0]));
+				if (!nft_chain_is_active(net, chain))
+					continue;
 				if (nf_tables_fill_chain_info(skb, net,
 							      NETLINK_CB(cb->skb).portid,
 							      cb->nlh->nlmsg_seq,
@@ -1160,10 +1205,10 @@ static int nf_tables_getchain(struct sock *nlsk, struct sk_buff *skb,
 	if (!nft_table_is_active(net, table))
 		return -ENOENT;
 
-	chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME]);
+	chain = nf_tables_chain_lookup(net, table, nla[NFTA_CHAIN_NAME], false);
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
-	if (chain->flags & NFT_CHAIN_INACTIVE)
+	if (!nft_chain_is_active(net, chain))
 		return -ENOENT;
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
@@ -1293,7 +1338,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		if (IS_ERR(chain))
 			return PTR_ERR(chain);
 	} else {
-		chain = nf_tables_chain_lookup(table, name);
+		chain = nf_tables_chain_lookup(net, table, name, true);
 		if (IS_ERR(chain)) {
 			if (PTR_ERR(chain) != -ENOENT)
 				return PTR_ERR(chain);
@@ -1324,7 +1369,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		struct nft_stats *stats = NULL;
 		struct nft_trans *trans;
 
-		if (chain->flags & NFT_CHAIN_INACTIVE)
+		if (!nft_chain_is_active(net, chain))
 			return -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
@@ -1332,7 +1377,9 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			return -EOPNOTSUPP;
 
 		if (nla[NFTA_CHAIN_HANDLE] && name &&
-		    !IS_ERR(nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME])))
+		    !IS_ERR(nf_tables_chain_lookup(net, table,
+						   nla[NFTA_CHAIN_NAME],
+						   false)))
 			return -EEXIST;
 
 		if (nla[NFTA_CHAIN_COUNTERS]) {
@@ -1530,10 +1577,10 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 	if (!nft_table_is_active(net, table))
 		return -ENOENT;
 
-	chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME]);
+	chain = nf_tables_chain_lookup(net, table, nla[NFTA_CHAIN_NAME], true);
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
-	if (chain->flags & NFT_CHAIN_INACTIVE)
+	if (!nft_chain_is_active(net, chain))
 		return -ENOENT;
 	if (chain->use > 0)
 		return -EBUSY;
@@ -1994,10 +2041,10 @@ static int nf_tables_getrule(struct sock *nlsk, struct sk_buff *skb,
 	if (!nft_table_is_active(net, table))
 		return -ENOENT;
 
-	chain = nf_tables_chain_lookup(table, nla[NFTA_RULE_CHAIN]);
+	chain = nf_tables_chain_lookup(net, table, nla[NFTA_RULE_CHAIN], false);
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
-	if (chain->flags & NFT_CHAIN_INACTIVE)
+	if (!nft_chain_is_active(net, chain))
 		return -ENOENT;
 
 	rule = nf_tables_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
@@ -2072,7 +2119,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	chain = nf_tables_chain_lookup(table, nla[NFTA_RULE_CHAIN]);
+	chain = nf_tables_chain_lookup(net, table, nla[NFTA_RULE_CHAIN], true);
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
 
@@ -2232,7 +2279,8 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 		return -ENOENT;
 
 	if (nla[NFTA_RULE_CHAIN]) {
-		chain = nf_tables_chain_lookup(table, nla[NFTA_RULE_CHAIN]);
+		chain = nf_tables_chain_lookup(net, table,
+					       nla[NFTA_RULE_CHAIN], true);
 		if (IS_ERR(chain))
 			return PTR_ERR(chain);
 	}
@@ -3960,12 +4008,13 @@ static int nf_tables_commit(struct sk_buff *skb)
 			if (nft_trans_chain_update(trans))
 				nft_chain_commit_update(trans);
 			else
-				trans->ctx.chain->flags &= ~NFT_CHAIN_INACTIVE;
+				nft_chain_clear(net, trans->ctx.chain);
 
 			nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELCHAIN:
+			list_del_rcu(&trans->ctx.chain->list);
 			nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN);
 			nf_tables_unregister_hooks(trans->ctx.table,
 						   trans->ctx.chain,
@@ -4097,8 +4146,7 @@ static int nf_tables_abort(struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELCHAIN:
 			trans->ctx.table->use++;
-			list_add_tail_rcu(&trans->ctx.chain->list,
-					  &trans->ctx.table->chains);
+			nft_chain_clear(trans->ctx.net, trans->ctx.chain);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWRULE:
@@ -4452,8 +4500,8 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	case NFT_GOTO:
 		if (!tb[NFTA_VERDICT_CHAIN])
 			return -EINVAL;
-		chain = nf_tables_chain_lookup(ctx->table,
-					       tb[NFTA_VERDICT_CHAIN]);
+		chain = nf_tables_chain_lookup(ctx->net, ctx->table,
+					       tb[NFTA_VERDICT_CHAIN], true);
 		if (IS_ERR(chain))
 			return PTR_ERR(chain);
 		if (chain->flags & NFT_BASE_CHAIN)
-- 
1.7.10.4

