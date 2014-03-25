From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 1/2] netfilter: nf_tables: move set netlink messages into the batch
Date: Tue, 25 Mar 2014 21:39:41 +0100
Message-ID: <1395779982-3459-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50398 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbaCYUjx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:39:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch reworks the nf_tables API so set updates are moved into
the same batch that contains rule updates. This speeds up rule-set
updates we skip a dialog of four messages between kernel and
user-space (two on each direction).

 1) create the set and send netlink message to the kernel
 2) process the response from the kernel that contains the allocated name.
 3) add the set elements and send netlink message to the kernel.
 4) process the response from the kernel (to check for errors).

To:

 1) add the set to the batch.
 2) add the set elements to the batch.
 3) add the rule that points to the set.
 4) send batch to the kernel.

The idea is to allocate an internal set ID to the batch that can be
used when adding set elements and rules that refer to the set in the
batch.

Backward compatibility has been only retained in userspace, this
means that new nft versions can talk to the kernel both in the new
and the old fashion.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I'm considering preparing a follow up patch to add tables and chains
to the big batch message as well.

 include/net/netfilter/nf_tables.h        |    2 +
 include/net/netns/nftables.h             |    2 +
 include/uapi/linux/netfilter/nf_tables.h |    6 ++
 net/netfilter/nf_tables_api.c            |  124 ++++++++++++++++++++++++++----
 net/netfilter/nft_lookup.c               |   14 +++-
 5 files changed, 130 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e6bc14d..b749e4d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -222,6 +222,8 @@ static inline void *nft_set_priv(const struct nft_set *set)
 
 struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
 				     const struct nlattr *nla);
+struct nft_set *nf_tables_set_lookup2(const struct net *net,
+				      const struct nlattr *nla);
 
 /**
  *	struct nft_set_binding - nf_tables set binding
diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 26a394c..742fe57 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -8,6 +8,8 @@ struct nft_af_info;
 struct netns_nftables {
 	struct list_head	af_info;
 	struct list_head	commit_list;
+	struct list_head	newset_list;
+	struct list_head	delset_list;
 	struct nft_af_info	*ipv4;
 	struct nft_af_info	*ipv6;
 	struct nft_af_info	*inet;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c88ccbf..3776beb 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -221,6 +221,7 @@ enum nft_set_flags {
  * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
  * @NFTA_SET_DATA_TYPE: mapping data type (NLA_U32)
  * @NFTA_SET_DATA_LEN: mapping data length (NLA_U32)
+ * @NFTA_SET_ID: set ID (NLA_U64)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -231,6 +232,7 @@ enum nft_set_attributes {
 	NFTA_SET_KEY_LEN,
 	NFTA_SET_DATA_TYPE,
 	NFTA_SET_DATA_LEN,
+	NFTA_SET_ID,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
@@ -266,12 +268,14 @@ enum nft_set_elem_attributes {
  * @NFTA_SET_ELEM_LIST_TABLE: table of the set to be changed (NLA_STRING)
  * @NFTA_SET_ELEM_LIST_SET: name of the set to be changed (NLA_STRING)
  * @NFTA_SET_ELEM_LIST_ELEMENTS: list of set elements (NLA_NESTED: nft_set_elem_attributes)
+ * @NFTA_SET_ELEM_LIST_SET_ID: set ID (NLA_U64)
  */
 enum nft_set_elem_list_attributes {
 	NFTA_SET_ELEM_LIST_UNSPEC,
 	NFTA_SET_ELEM_LIST_TABLE,
 	NFTA_SET_ELEM_LIST_SET,
 	NFTA_SET_ELEM_LIST_ELEMENTS,
+	NFTA_SET_ELEM_LIST_SET_ID,
 	__NFTA_SET_ELEM_LIST_MAX
 };
 #define NFTA_SET_ELEM_LIST_MAX	(__NFTA_SET_ELEM_LIST_MAX - 1)
@@ -457,12 +461,14 @@ enum nft_cmp_attributes {
  * @NFTA_LOOKUP_SET: name of the set where to look for (NLA_STRING)
  * @NFTA_LOOKUP_SREG: source register of the data to look for (NLA_U32: nft_registers)
  * @NFTA_LOOKUP_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_LOOKUP_SET_ID: set ID (NLA_U64)
  */
 enum nft_lookup_attributes {
 	NFTA_LOOKUP_UNSPEC,
 	NFTA_LOOKUP_SET,
 	NFTA_LOOKUP_SREG,
 	NFTA_LOOKUP_DREG,
+	NFTA_LOOKUP_SET_ID,
 	__NFTA_LOOKUP_MAX
 };
 #define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 43ae487..ae05c24 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1807,10 +1807,37 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	return err;
 }
 
+struct nft_set_trans {
+	struct list_head	list;
+	struct nft_set		*set;
+	struct nft_ctx		ctx;
+	u64			id;
+};
+
+static void nf_tables_set_destroy(const struct nft_ctx *ctx,
+				  struct nft_set *set);
+static int nf_tables_set_notify(const struct nft_ctx *ctx,
+				const struct nft_set *set,
+				int event);
+static void nft_set_destroy(struct nft_set *set);
+
+#define __NFT_SET_INACTIVE	(1 << 15)	/* internal set flag */
+
 static int nf_tables_commit(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct nft_rule_trans *rupd, *tmp;
+	struct nft_set_trans *st, *stmp;
+
+	/* New sets come in first place before you can bind them to rules */
+	list_for_each_entry_safe(st, stmp, &net->nft.newset_list, list) {
+		list_del(&st->list);
+		st->set->flags &= ~__NFT_SET_INACTIVE;
+		list_add_tail(&st->set->list,
+			      (struct list_head *)&st->ctx.table->sets);
+		nf_tables_set_notify(&st->ctx, st->set, NFT_MSG_NEWSET);
+		kfree(st);
+	}
 
 	/* Bump generation counter, invalidate any dump in progress */
 	net->nft.genctr++;
@@ -1857,6 +1884,14 @@ static int nf_tables_commit(struct sk_buff *skb)
 		kfree(rupd);
 	}
 
+	/* We can delete sets that are not bound to any rules anymore */
+	list_for_each_entry_safe(st, stmp, &net->nft.delset_list, list) {
+		list_del(&st->set->list);
+		nf_tables_set_destroy(&st->ctx, st->set);
+		list_del(&st->list);
+		kfree(st);
+	}
+
 	return 0;
 }
 
@@ -1864,6 +1899,7 @@ static int nf_tables_abort(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct nft_rule_trans *rupd, *tmp;
+	struct nft_set_trans *st, *stmp;
 
 	list_for_each_entry_safe(rupd, tmp, &net->nft.commit_list, list) {
 		if (!nft_rule_is_active_next(net, rupd->rule)) {
@@ -1885,6 +1921,17 @@ static int nf_tables_abort(struct sk_buff *skb)
 		list_del(&rupd->list);
 		kfree(rupd);
 	}
+	/* release newly created sets in this batch that are inactive */
+	list_for_each_entry_safe(st, stmp, &net->nft.newset_list, list) {
+		list_del(&st->list);
+		nft_set_destroy(st->set);
+		kfree(st);
+	}
+	/* abort scheduled removal of sets */
+	list_for_each_entry_safe(st, stmp, &net->nft.delset_list, list) {
+		list_del(&st->list);
+		kfree(st);
+	}
 
 	return 0;
 }
@@ -1953,6 +2000,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_KEY_LEN]		= { .type = NLA_U32 },
 	[NFTA_SET_DATA_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_DATA_LEN]		= { .type = NLA_U32 },
+	[NFTA_SET_ID]			= { .type = NLA_U64 },
 };
 
 static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
@@ -1999,6 +2047,19 @@ struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
 	return ERR_PTR(-ENOENT);
 }
 
+struct nft_set *nf_tables_set_lookup2(const struct net *net,
+				      const struct nlattr *nla)
+{
+	struct nft_set_trans *st;
+	u64 id = be64_to_cpu(nla_get_be64(nla));
+
+	list_for_each_entry(st, &net->nft.newset_list, list) {
+		if (id == st->id)
+			return st->set;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
 static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 				    const char *name)
 {
@@ -2305,6 +2366,25 @@ err:
 	return err;
 }
 
+static int nf_tables_set_trans_add(struct list_head *list, struct nft_ctx *ctx,
+				   struct nft_set *set)
+{
+	struct nft_set_trans *strans;
+
+	strans = kmalloc(sizeof(struct nft_set_trans), GFP_ATOMIC);
+	if (strans == NULL)
+		return -ENOMEM;
+
+	strans->set = set;
+	strans->ctx = *ctx;
+	if (ctx->nla[NFTA_SET_ID])
+		strans->id = be64_to_cpu(nla_get_be64(ctx->nla[NFTA_SET_ID]));
+
+	set->flags |= __NFT_SET_INACTIVE;
+	list_add_tail(&strans->list, list);
+	return 0;
+}
+
 static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 			    const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[])
@@ -2429,8 +2509,10 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 	if (err < 0)
 		goto err2;
 
-	list_add_tail(&set->list, &table->sets);
-	nf_tables_set_notify(&ctx, set, NFT_MSG_NEWSET);
+	err = nf_tables_set_trans_add(&net->nft.newset_list, &ctx, set);
+	if (err < 0)
+		goto err2;
+
 	return 0;
 
 err2:
@@ -2440,16 +2522,20 @@ err1:
 	return err;
 }
 
-static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
+static void nft_set_destroy(struct nft_set *set)
 {
-	list_del(&set->list);
-	nf_tables_set_notify(ctx, set, NFT_MSG_DELSET);
-
 	set->ops->destroy(set);
 	module_put(set->ops->owner);
 	kfree(set);
 }
 
+static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	list_del(&set->list);
+	nf_tables_set_notify(ctx, set, NFT_MSG_DELSET);
+	nft_set_destroy(set);
+}
+
 static int nf_tables_delset(struct sock *nlsk, struct sk_buff *skb,
 			    const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[])
@@ -2474,8 +2560,7 @@ static int nf_tables_delset(struct sock *nlsk, struct sk_buff *skb,
 	if (!list_empty(&set->bindings))
 		return -EBUSY;
 
-	nf_tables_set_destroy(&ctx, set);
-	return 0;
+	return nf_tables_set_trans_add(&ctx.net->nft.delset_list, &ctx, set);
 }
 
 static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
@@ -2534,7 +2619,8 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 {
 	list_del(&binding->list);
 
-	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
+	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
+	    !(set->flags & __NFT_SET_INACTIVE))
 		nf_tables_set_destroy(ctx, set);
 }
 
@@ -2552,6 +2638,7 @@ static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX +
 	[NFTA_SET_ELEM_LIST_TABLE]	= { .type = NLA_STRING },
 	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING },
 	[NFTA_SET_ELEM_LIST_ELEMENTS]	= { .type = NLA_NESTED },
+	[NFTA_SET_ELEM_LIST_SET_ID]	= { .type = NLA_U64 },
 };
 
 static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx,
@@ -2815,6 +2902,7 @@ static int nf_tables_newsetelem(struct sock *nlsk, struct sk_buff *skb,
 				const struct nlmsghdr *nlh,
 				const struct nlattr * const nla[])
 {
+	struct net *net = sock_net(skb->sk);
 	const struct nlattr *attr;
 	struct nft_set *set;
 	struct nft_ctx ctx;
@@ -2824,7 +2912,13 @@ static int nf_tables_newsetelem(struct sock *nlsk, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
+	if (nla[NFTA_SET_ELEM_LIST_SET_ID]) {
+		set = nf_tables_set_lookup2(net,
+					    nla[NFTA_SET_ELEM_LIST_SET_ID]);
+	} else {
+		set = nf_tables_set_lookup(ctx.table,
+					   nla[NFTA_SET_ELEM_LIST_SET]);
+	}
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
@@ -2953,7 +3047,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_NEWSET] = {
-		.call		= nf_tables_newset,
+		.call_batch	= nf_tables_newset,
 		.attr_count	= NFTA_SET_MAX,
 		.policy		= nft_set_policy,
 	},
@@ -2963,12 +3057,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_policy,
 	},
 	[NFT_MSG_DELSET] = {
-		.call		= nf_tables_delset,
+		.call_batch	= nf_tables_delset,
 		.attr_count	= NFTA_SET_MAX,
 		.policy		= nft_set_policy,
 	},
 	[NFT_MSG_NEWSETELEM] = {
-		.call		= nf_tables_newsetelem,
+		.call_batch	= nf_tables_newsetelem,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
@@ -2978,7 +3072,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_DELSETELEM] = {
-		.call		= nf_tables_delsetelem,
+		.call_batch	= nf_tables_delsetelem,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
@@ -3371,6 +3465,8 @@ static int nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.af_info);
 	INIT_LIST_HEAD(&net->nft.commit_list);
+	INIT_LIST_HEAD(&net->nft.newset_list);
+	INIT_LIST_HEAD(&net->nft.delset_list);
 	return 0;
 }
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 7fd2bea..28d28ea 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -51,13 +51,19 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	struct nft_set *set;
 	int err;
 
-	if (tb[NFTA_LOOKUP_SET] == NULL ||
+	if ((tb[NFTA_LOOKUP_SET] == NULL && tb[NFTA_LOOKUP_SET_ID] == NULL) ||
 	    tb[NFTA_LOOKUP_SREG] == NULL)
 		return -EINVAL;
 
-	set = nf_tables_set_lookup(ctx->table, tb[NFTA_LOOKUP_SET]);
-	if (IS_ERR(set))
-		return PTR_ERR(set);
+	if (tb[NFTA_LOOKUP_SET_ID]) {
+		set = nf_tables_set_lookup2(ctx->net, tb[NFTA_LOOKUP_SET_ID]);
+		if (IS_ERR(set))
+			return PTR_ERR(set);
+	} else {
+		set = nf_tables_set_lookup(ctx->table, tb[NFTA_LOOKUP_SET]);
+		if (IS_ERR(set))
+			return PTR_ERR(set);
+	}
 
 	priv->sreg = ntohl(nla_get_be32(tb[NFTA_LOOKUP_SREG]));
 	err = nft_validate_input_register(priv->sreg);
-- 
1.7.10.4

