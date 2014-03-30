From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/8] netfilter: nf_tables: move set handling to the transaction infrastructure
Date: Sun, 30 Mar 2014 14:04:50 +0200
Message-ID: <1396181094-8140-5-git-send-email-pablo@netfilter.org>
References: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45395 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbaC3MFH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 08:05:07 -0400
In-Reply-To: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
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

Note that this patch doesn't add atomic set element updates, it just
helps to leave the set configuration in consistent state in case
that we fail to load the entire batch for some reason.

Backward compatibility has been only retained in userspace, this
means that new nft versions can talk to the kernel both in the new
and the old fashion.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |    6 ++
 include/uapi/linux/netfilter/nf_tables.h |    6 ++
 net/netfilter/nf_tables_api.c            |  119 ++++++++++++++++++++++++++----
 net/netfilter/nft_lookup.c               |   10 ++-
 4 files changed, 126 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 04d24e6..49e013e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -222,6 +222,8 @@ static inline void *nft_set_priv(const struct nft_set *set)
 
 struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
 				     const struct nlattr *nla);
+struct nft_set *nf_tables_set_lookup_byid(const struct net *net,
+					  const struct nlattr *nla);
 
 /**
  *	struct nft_set_binding - nf_tables set binding
@@ -353,6 +355,10 @@ struct nft_trans {
 	struct nft_ctx			ctx;
 	union {
 		struct nft_rule		*rule;
+		struct {
+			struct nft_set	*set;
+			u32		set_id;
+		};
 	};
 };
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c88ccbf..8427e17 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -221,6 +221,7 @@ enum nft_set_flags {
  * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
  * @NFTA_SET_DATA_TYPE: mapping data type (NLA_U32)
  * @NFTA_SET_DATA_LEN: mapping data length (NLA_U32)
+ * @NFTA_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
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
+ * @NFTA_SET_ELEM_LIST_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
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
+ * @NFTA_LOOKUP_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
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
index 4fce8d9..cef20db 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1889,6 +1889,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_KEY_LEN]		= { .type = NLA_U32 },
 	[NFTA_SET_DATA_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_DATA_LEN]		= { .type = NLA_U32 },
+	[NFTA_SET_ID]			= { .type = NLA_U32 },
 };
 
 static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
@@ -1935,6 +1936,20 @@ struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
 	return ERR_PTR(-ENOENT);
 }
 
+struct nft_set *nf_tables_set_lookup_byid(const struct net *net,
+					  const struct nlattr *nla)
+{
+	struct nft_trans *trans;
+	u32 id = ntohl(nla_get_be32(nla));
+
+	list_for_each_entry(trans, &net->nft.commit_list, list) {
+		if (trans->msg_type == NFT_MSG_NEWSET &&
+		    id == trans->set_id)
+			return trans->set;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
 static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 				    const char *name)
 {
@@ -2196,6 +2211,8 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 	return ret;
 }
 
+#define NFT_SET_INACTIVE	(1 << 15)	/* Internal set flag */
+
 static int nf_tables_getset(struct sock *nlsk, struct sk_buff *skb,
 			    const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[])
@@ -2225,6 +2242,8 @@ static int nf_tables_getset(struct sock *nlsk, struct sk_buff *skb,
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME]);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
+	if (set->flags & NFT_SET_INACTIVE)
+		return -ENOENT;
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (skb2 == NULL)
@@ -2241,6 +2260,28 @@ err:
 	return err;
 }
 
+static int nft_set_trans_add(struct nft_ctx *ctx, int msg_type,
+			     struct nft_set *set)
+{
+	struct nft_trans *trans;
+
+	if (msg_type == NFT_MSG_NEWSET && !ctx->nla[NFTA_SET_ID])
+		return -EINVAL;
+
+	trans = nft_trans_alloc(ctx, msg_type);
+	if (trans == NULL)
+		return -ENOMEM;
+
+	if (msg_type == NFT_MSG_NEWSET) {
+		trans->set_id = ntohl(nla_get_be32(ctx->nla[NFTA_SET_ID]));
+		set->flags |= NFT_SET_INACTIVE;
+	}
+	trans->set = set;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+
+	return 0;
+}
+
 static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 			    const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[])
@@ -2365,8 +2406,11 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 	if (err < 0)
 		goto err2;
 
+	err = nft_set_trans_add(&ctx, NFT_MSG_NEWSET, set);
+	if (err < 0)
+		goto err2;
+
 	list_add_tail(&set->list, &table->sets);
-	nf_tables_set_notify(&ctx, set, NFT_MSG_NEWSET);
 	return 0;
 
 err2:
@@ -2376,16 +2420,20 @@ err1:
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
@@ -2407,10 +2455,16 @@ static int nf_tables_delset(struct sock *nlsk, struct sk_buff *skb,
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME]);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
+	if (set->flags & NFT_SET_INACTIVE)
+		return -ENOENT;
 	if (!list_empty(&set->bindings))
 		return -EBUSY;
 
-	nf_tables_set_destroy(&ctx, set);
+	err = nft_set_trans_add(&ctx, NFT_MSG_DELSET, set);
+	if (err < 0)
+		return err;
+
+	list_del(&set->list);
 	return 0;
 }
 
@@ -2470,7 +2524,8 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 {
 	list_del(&binding->list);
 
-	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
+	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
+	    !(set->flags & NFT_SET_INACTIVE))
 		nf_tables_set_destroy(ctx, set);
 }
 
@@ -2488,6 +2543,7 @@ static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX +
 	[NFTA_SET_ELEM_LIST_TABLE]	= { .type = NLA_STRING },
 	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING },
 	[NFTA_SET_ELEM_LIST_ELEMENTS]	= { .type = NLA_NESTED },
+	[NFTA_SET_ELEM_LIST_SET_ID]	= { .type = NLA_U32 },
 };
 
 static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx,
@@ -2587,6 +2643,8 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
+	if (set->flags & NFT_SET_INACTIVE)
+		return -ENOENT;
 
 	event  = NFT_MSG_NEWSETELEM;
 	event |= NFNL_SUBSYS_NFTABLES << 8;
@@ -2650,6 +2708,8 @@ static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
+	if (set->flags & NFT_SET_INACTIVE)
+		return -ENOENT;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -2751,6 +2811,7 @@ static int nf_tables_newsetelem(struct sock *nlsk, struct sk_buff *skb,
 				const struct nlmsghdr *nlh,
 				const struct nlattr * const nla[])
 {
+	struct net *net = sock_net(skb->sk);
 	const struct nlattr *attr;
 	struct nft_set *set;
 	struct nft_ctx ctx;
@@ -2761,8 +2822,16 @@ static int nf_tables_newsetelem(struct sock *nlsk, struct sk_buff *skb,
 		return err;
 
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET]);
-	if (IS_ERR(set))
-		return PTR_ERR(set);
+	if (IS_ERR(set)) {
+		if (nla[NFTA_SET_ELEM_LIST_SET_ID]) {
+			set = nf_tables_set_lookup_byid(net,
+					nla[NFTA_SET_ELEM_LIST_SET_ID]);
+		}
+		if (IS_ERR(set))
+			return PTR_ERR(set);
+	} else if (set->flags & NFT_SET_INACTIVE)
+		return -ENOENT;
+
 	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
 		return -EBUSY;
 
@@ -2889,7 +2958,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_NEWSET] = {
-		.call		= nf_tables_newset,
+		.call_batch	= nf_tables_newset,
 		.attr_count	= NFTA_SET_MAX,
 		.policy		= nft_set_policy,
 	},
@@ -2899,12 +2968,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -2914,7 +2983,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_DELSETELEM] = {
-		.call		= nf_tables_delsetelem,
+		.call_batch	= nf_tables_delsetelem,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
@@ -2954,6 +3023,16 @@ static int nf_tables_commit(struct sk_buff *skb)
 					      trans->rule, NFT_MSG_DELRULE, 0,
 					      trans->ctx.afi->family);
 			break;
+		case NFT_MSG_NEWSET:
+			trans->set->flags &= ~NFT_SET_INACTIVE;
+			nf_tables_set_notify(&trans->ctx, trans->set,
+					     NFT_MSG_NEWSET);
+			nft_trans_destroy(trans);
+			break;
+		case NFT_MSG_DELSET:
+			nf_tables_set_notify(&trans->ctx, trans->set,
+					     NFT_MSG_DELSET);
+			break;
 		}
 	}
 
@@ -2966,6 +3045,9 @@ static int nf_tables_commit(struct sk_buff *skb)
 		case NFT_MSG_DELRULE:
 			nf_tables_rule_destroy(&trans->ctx, trans->rule);
 			break;
+		case NFT_MSG_DELSET:
+			nft_set_destroy(trans->set);
+			break;
 		}
 		nft_trans_destroy(trans);
 	}
@@ -2987,6 +3069,14 @@ static int nf_tables_abort(struct sk_buff *skb)
 			nft_rule_clear(trans->ctx.net, trans->rule);
 			nft_trans_destroy(trans);
 			break;
+		case NFT_MSG_NEWSET:
+			list_del(&trans->set->list);
+			break;
+		case NFT_MSG_DELSET:
+			list_add_tail(&trans->set->list,
+				      &trans->ctx.table->sets);
+			nft_trans_destroy(trans);
+			break;
 		}
 	}
 
@@ -2998,6 +3088,9 @@ static int nf_tables_abort(struct sk_buff *skb)
 		case NFT_MSG_NEWRULE:
 			nf_tables_rule_destroy(&trans->ctx, trans->rule);
 			break;
+		case NFT_MSG_NEWSET:
+			nft_set_destroy(trans->set);
+			break;
 		}
 		nft_trans_destroy(trans);
 	}
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 7fd2bea..6404a72 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -56,8 +56,14 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 		return -EINVAL;
 
 	set = nf_tables_set_lookup(ctx->table, tb[NFTA_LOOKUP_SET]);
-	if (IS_ERR(set))
-		return PTR_ERR(set);
+	if (IS_ERR(set)) {
+		if (tb[NFTA_LOOKUP_SET_ID]) {
+			set = nf_tables_set_lookup_byid(ctx->net,
+							tb[NFTA_LOOKUP_SET_ID]);
+		}
+		if (IS_ERR(set))
+			return PTR_ERR(set);
+	}
 
 	priv->sreg = ntohl(nla_get_be32(tb[NFTA_LOOKUP_SREG]));
 	err = nft_validate_input_register(priv->sreg);
-- 
1.7.10.4

