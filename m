From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/3] netfilter: nf_tables: add generation mask to table objects
Date: Tue,  4 Aug 2015 11:05:26 +0200
Message-ID: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42673 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331AbbHDI7g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 04:59:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The dumping of table objects can be inconsistent when interfering with the
preparation phase of our 2-phase commit protocol because:

1) We remove objects from the lists during the preparation phase, that can be
   added re-added from the abort step. Thus, we may miss objects that are still
   active.

2) We add new objects to the lists during the preparation phase, so we may get
   objects that are not yet active with an internal flag set.

We can resolve this problem with generation masks, as we already do for rules
when we expose them to the packet path.

After this change, we always obtain a consistent list as long as we stay in the
same generation. The userspace side can detect interferences through the
generation counter. If so, it needs to restart.

As a result, we can get rid of the internal NFT_TABLE_INACTIVE flag.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    4 +-
 net/netfilter/nf_tables_api.c     |  104 ++++++++++++++++++++++++-------------
 2 files changed, 71 insertions(+), 37 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2a24668..1b94bf2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -827,6 +827,7 @@ unsigned int nft_do_chain(struct nft_pktinfo *pkt,
  *	@hgenerator: handle generator state
  *	@use: number of chain references to this table
  *	@flags: table flag (see enum nft_table_flags)
+ *	@genmask: generation mask
  *	@name: name of the table
  */
 struct nft_table {
@@ -835,7 +836,8 @@ struct nft_table {
 	struct list_head		sets;
 	u64				hgenerator;
 	u32				use;
-	u16				flags;
+	u16				flags:14,
+					genmask:2;
 	char				name[NFT_TABLE_MAXNAMELEN];
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4a41eb9..cee7326 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -173,8 +173,35 @@ static void nf_tables_unregister_hooks(const struct nft_table *table,
 	nft_unregister_basechain(nft_base_chain(chain), hook_nops);
 }
 
-/* Internal table flags */
-#define NFT_TABLE_INACTIVE	(1 << 15)
+static inline bool
+nft_table_is_active(struct net *net, const struct nft_table *table)
+{
+	return (table->genmask & nft_genmask_cur(net)) == 0;
+}
+
+static inline int
+nft_table_is_active_next(struct net *net, const struct nft_table *table)
+{
+	return (table->genmask & nft_genmask_next(net)) == 0;
+}
+
+static inline void
+nft_table_activate_next(struct net *net, struct nft_table *table)
+{
+	/* Now inactive, will be active in the future */
+	table->genmask = nft_genmask_cur(net);
+}
+
+static inline void
+nft_table_deactivate_next(struct net *net, struct nft_table *table)
+{
+	table->genmask = nft_genmask_next(net);
+}
+
+static inline void nft_table_clear(struct net *net, struct nft_table *table)
+{
+	table->genmask &= ~nft_genmask_next(net);
+}
 
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
 {
@@ -185,7 +212,7 @@ static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
 		return -ENOMEM;
 
 	if (msg_type == NFT_MSG_NEWTABLE)
-		ctx->table->flags |= NFT_TABLE_INACTIVE;
+		nft_table_activate_next(ctx->net, ctx->table);
 
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
@@ -199,7 +226,7 @@ static int nft_deltable(struct nft_ctx *ctx)
 	if (err < 0)
 		return err;
 
-	list_del_rcu(&ctx->table->list);
+	nft_table_deactivate_next(ctx->net, ctx->table);
 	return err;
 }
 
@@ -373,8 +400,10 @@ static struct nft_table *nft_table_lookup(const struct nft_af_info *afi,
 	return NULL;
 }
 
-static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
-						const struct nlattr *nla)
+static struct nft_table *nf_tables_table_lookup(struct net *net,
+						const struct nft_af_info *afi,
+						const struct nlattr *nla,
+						bool trans)
 {
 	struct nft_table *table;
 
@@ -382,10 +411,10 @@ static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
 		return ERR_PTR(-EINVAL);
 
 	table = nft_table_lookup(afi, nla);
-	if (table != NULL)
-		return table;
+	if (table == NULL || (trans && !nft_table_is_active_next(net, table)))
+		return ERR_PTR(-ENOENT);
 
-	return ERR_PTR(-ENOENT);
+	return table;
 }
 
 static inline u64 nf_tables_alloc_handle(struct nft_table *table)
@@ -522,6 +551,8 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 			if (idx > s_idx)
 				memset(&cb->args[1], 0,
 				       sizeof(cb->args) - sizeof(cb->args[0]));
+			if (!nft_table_is_active(net, table))
+				continue;
 			if (nf_tables_fill_table_info(skb, net,
 						      NETLINK_CB(cb->skb).portid,
 						      cb->nlh->nlmsg_seq,
@@ -564,10 +595,10 @@ static int nf_tables_gettable(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME]);
+	table = nf_tables_table_lookup(net, afi, nla[NFTA_TABLE_NAME], false);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
-	if (table->flags & NFT_TABLE_INACTIVE)
+	if (!nft_table_is_active(net, table))
 		return -ENOENT;
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
@@ -691,7 +722,7 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 		return PTR_ERR(afi);
 
 	name = nla[NFTA_TABLE_NAME];
-	table = nf_tables_table_lookup(afi, name);
+	table = nf_tables_table_lookup(net, afi, name, true);
 	if (IS_ERR(table)) {
 		if (PTR_ERR(table) != -ENOENT)
 			return PTR_ERR(table);
@@ -699,7 +730,7 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	if (table != NULL) {
-		if (table->flags & NFT_TABLE_INACTIVE)
+		if (!nft_table_is_active(net, table))
 			return -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
@@ -829,10 +860,10 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME]);
+	table = nf_tables_table_lookup(net, afi, nla[NFTA_TABLE_NAME], true);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
-	if (table->flags & NFT_TABLE_INACTIVE)
+	if (!nft_table_is_active(net, table))
 		return -ENOENT;
 
 	ctx.afi = afi;
@@ -1123,10 +1154,10 @@ static int nf_tables_getchain(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE]);
+	table = nf_tables_table_lookup(net, afi, nla[NFTA_CHAIN_TABLE], false);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
-	if (table->flags & NFT_TABLE_INACTIVE)
+	if (!nft_table_is_active(net, table))
 		return -ENOENT;
 
 	chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME]);
@@ -1249,7 +1280,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE]);
+	table = nf_tables_table_lookup(net, afi, nla[NFTA_CHAIN_TABLE], true);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -1493,10 +1524,10 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_CHAIN_TABLE]);
+	table = nf_tables_table_lookup(net, afi, nla[NFTA_CHAIN_TABLE], true);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
-	if (table->flags & NFT_TABLE_INACTIVE)
+	if (!nft_table_is_active(net, table))
 		return -ENOENT;
 
 	chain = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME]);
@@ -1957,10 +1988,10 @@ static int nf_tables_getrule(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE]);
+	table = nf_tables_table_lookup(net, afi, nla[NFTA_RULE_TABLE], true);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
-	if (table->flags & NFT_TABLE_INACTIVE)
+	if (!nft_table_is_active(net, table))
 		return -ENOENT;
 
 	chain = nf_tables_chain_lookup(table, nla[NFTA_RULE_CHAIN]);
@@ -2037,7 +2068,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE]);
+	table = nf_tables_table_lookup(net, afi, nla[NFTA_RULE_TABLE], true);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -2194,10 +2225,10 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_RULE_TABLE]);
+	table = nf_tables_table_lookup(net, afi, nla[NFTA_RULE_TABLE], true);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
-	if (table->flags & NFT_TABLE_INACTIVE)
+	if (!nft_table_is_active(net, table))
 		return -ENOENT;
 
 	if (nla[NFTA_RULE_CHAIN]) {
@@ -2348,7 +2379,8 @@ static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
 static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
 				     const struct sk_buff *skb,
 				     const struct nlmsghdr *nlh,
-				     const struct nlattr * const nla[])
+				     const struct nlattr * const nla[],
+				     bool trans)
 {
 	struct net *net = sock_net(skb->sk);
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
@@ -2365,10 +2397,10 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
 		if (afi == NULL)
 			return -EAFNOSUPPORT;
 
-		table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE]);
+		table = nf_tables_table_lookup(net, afi, nla[NFTA_SET_TABLE], trans);
 		if (IS_ERR(table))
 			return PTR_ERR(table);
-		if (table->flags & NFT_TABLE_INACTIVE)
+		if (!nft_table_is_active(net, table))
 			return -ENOENT;
 	}
 
@@ -2631,7 +2663,7 @@ static int nf_tables_getset(struct sock *nlsk, struct sk_buff *skb,
 	int err;
 
 	/* Verify existence before starting dump */
-	err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla);
+	err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla, false);
 	if (err < 0)
 		return err;
 
@@ -2795,7 +2827,7 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE]);
+	table = nf_tables_table_lookup(net, afi, nla[NFTA_SET_TABLE], true);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
@@ -2897,7 +2929,7 @@ static int nf_tables_delset(struct sock *nlsk, struct sk_buff *skb,
 	if (nla[NFTA_SET_TABLE] == NULL)
 		return -EINVAL;
 
-	err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla);
+	err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla, true);
 	if (err < 0)
 		return err;
 
@@ -3040,10 +3072,10 @@ static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx,
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_SET_ELEM_LIST_TABLE]);
+	table = nf_tables_table_lookup(net, afi, nla[NFTA_SET_ELEM_LIST_TABLE], trans);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
-	if (!trans && (table->flags & NFT_TABLE_INACTIVE))
+	if (!trans && !nft_table_is_active(net, table))
 		return -ENOENT;
 
 	nft_ctx_init(ctx, skb, nlh, afi, table, NULL, nla);
@@ -3915,12 +3947,13 @@ static int nf_tables_commit(struct sk_buff *skb)
 					trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
 				}
 			} else {
-				trans->ctx.table->flags &= ~NFT_TABLE_INACTIVE;
+				nft_table_clear(net, trans->ctx.table);
 			}
 			nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELTABLE:
+			list_del_rcu(&trans->ctx.table->list);
 			nf_tables_table_notify(&trans->ctx, NFT_MSG_DELTABLE);
 			break;
 		case NFT_MSG_NEWCHAIN:
@@ -4046,8 +4079,7 @@ static int nf_tables_abort(struct sk_buff *skb)
 			}
 			break;
 		case NFT_MSG_DELTABLE:
-			list_add_tail_rcu(&trans->ctx.table->list,
-					  &trans->ctx.afi->tables);
+			nft_table_clear(trans->ctx.net, trans->ctx.table);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWCHAIN:
-- 
1.7.10.4

