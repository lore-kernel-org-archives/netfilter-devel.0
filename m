From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 3/3] netfilter: nf_tables: add generation mask to set objects
Date: Tue,  4 Aug 2015 11:05:28 +0200
Message-ID: <1438679128-4146-3-git-send-email-pablo@netfilter.org>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42684 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437AbbHDI7k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 04:59:40 -0400
In-Reply-To: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the generation mask approach to obtain a consistent list of set objects
from netlink dump commands.

Get rid of the internal NFT_SET_INACTIVE flag.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    4 ++-
 net/netfilter/nf_tables_api.c     |   54 ++++++++++++++++++++++++++++---------
 2 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 04ae9f2..083aa0b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -295,6 +295,7 @@ void nft_unregister_set(struct nft_set_ops *ops);
  * 	@ops: set ops
  * 	@pnet: network namespace
  * 	@flags: set flags
+ *	@genmask: generation mask
  * 	@klen: key length
  * 	@dlen: data length
  * 	@data: private set data
@@ -314,7 +315,8 @@ struct nft_set {
 	/* runtime data below here */
 	const struct nft_set_ops	*ops ____cacheline_aligned;
 	possible_net_t			pnet;
-	u16				flags;
+	u16				flags:14,
+					genmask:2;
 	u8				klen;
 	u8				dlen;
 	unsigned char			data[]
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 62293a34..23c0f14 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -377,8 +377,35 @@ static int nft_delrule_by_chain(struct nft_ctx *ctx)
 	return 0;
 }
 
-/* Internal set flag */
-#define NFT_SET_INACTIVE	(1 << 15)
+static inline bool
+nft_set_is_active(struct net *net, const struct nft_set *set)
+{
+	return (set->genmask & nft_genmask_cur(net)) == 0;
+}
+
+static inline int
+nft_set_is_active_next(struct net *net, const struct nft_set *set)
+{
+	return (set->genmask & nft_genmask_next(net)) == 0;
+}
+
+static inline void
+nft_set_activate_next(struct net *net, struct nft_set *set)
+{
+	/* Now inactive, will be active in the future */
+	set->genmask = nft_genmask_cur(net);
+}
+
+static inline void
+nft_set_deactivate_next(struct net *net, struct nft_set *set)
+{
+	set->genmask = nft_genmask_next(net);
+}
+
+static inline void nft_set_clear(struct net *net, struct nft_set *set)
+{
+	set->genmask &= ~nft_genmask_next(net);
+}
 
 static int nft_trans_set_add(struct nft_ctx *ctx, int msg_type,
 			     struct nft_set *set)
@@ -392,7 +419,7 @@ static int nft_trans_set_add(struct nft_ctx *ctx, int msg_type,
 	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] != NULL) {
 		nft_trans_set_id(trans) =
 			ntohl(nla_get_be32(ctx->nla[NFTA_SET_ID]));
-		set->flags |= NFT_SET_INACTIVE;
+		nft_set_activate_next(ctx->net, set);
 	}
 	nft_trans_set(trans) = set;
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
@@ -408,7 +435,7 @@ static int nft_delset(struct nft_ctx *ctx, struct nft_set *set)
 	if (err < 0)
 		return err;
 
-	list_del_rcu(&set->list);
+	nft_set_deactivate_next(ctx->net, set);
 	ctx->table->use--;
 
 	return err;
@@ -2668,7 +2695,8 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 			list_for_each_entry_rcu(set, &table->sets, list) {
 				if (idx < s_idx)
 					goto cont;
-
+				if (!nft_set_is_active(net, set))
+					continue;
 				ctx_set = *ctx;
 				ctx_set.table = table;
 				ctx_set.afi = afi;
@@ -2739,7 +2767,7 @@ static int nf_tables_getset(struct sock *nlsk, struct sk_buff *skb,
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME]);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
-	if (set->flags & NFT_SET_INACTIVE)
+	if (!nft_set_is_active(ctx.net, set))
 		return -ENOENT;
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
@@ -2984,7 +3012,7 @@ static int nf_tables_delset(struct sock *nlsk, struct sk_buff *skb,
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME]);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
-	if (set->flags & NFT_SET_INACTIVE)
+	if (!nft_set_is_active(ctx.net, set))
 		return -ENOENT;
 	if (!list_empty(&set->bindings))
 		return -EBUSY;
@@ -3052,7 +3080,7 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	list_del_rcu(&binding->list);
 
 	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
-	    !(set->flags & NFT_SET_INACTIVE))
+	    nft_set_is_active(ctx->net, set))
 		nf_tables_set_destroy(ctx, set);
 }
 
@@ -3239,7 +3267,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
-	if (set->flags & NFT_SET_INACTIVE)
+	if (!nft_set_is_active(ctx.net, set))
 		return -ENOENT;
 
 	event  = NFT_MSG_NEWSETELEM;
@@ -3304,7 +3332,7 @@ static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
-	if (set->flags & NFT_SET_INACTIVE)
+	if (!nft_set_is_active(ctx.net, set))
 		return -ENOENT;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -4034,7 +4062,7 @@ static int nf_tables_commit(struct sk_buff *skb)
 					      NFT_MSG_DELRULE);
 			break;
 		case NFT_MSG_NEWSET:
-			nft_trans_set(trans)->flags &= ~NFT_SET_INACTIVE;
+			nft_set_clear(net, nft_trans_set(trans));
 			/* This avoids hitting -EBUSY when deleting the table
 			 * from the transaction.
 			 */
@@ -4047,6 +4075,7 @@ static int nf_tables_commit(struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELSET:
+			list_del_rcu(&nft_trans_set(trans)->list);
 			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
 					     NFT_MSG_DELSET, GFP_KERNEL);
 			break;
@@ -4164,8 +4193,7 @@ static int nf_tables_abort(struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELSET:
 			trans->ctx.table->use++;
-			list_add_tail_rcu(&nft_trans_set(trans)->list,
-					  &trans->ctx.table->sets);
+			nft_set_clear(trans->ctx.net, nft_trans_set(trans));
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
-- 
1.7.10.4

