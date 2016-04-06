From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC nf-next 1/3] netfilter: nf_tables: add stateful named expressions
Date: Wed,  6 Apr 2016 18:51:31 +0200
Message-ID: <1459961493-7494-2-git-send-email-pablo@netfilter.org>
References: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42807 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbcDFQvr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2016 12:51:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C0F46C9EDF
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9DEA4DA385
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 91E80DA385
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:40 +0200 (CEST)
In-Reply-To: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Users can define named counters in iptables through the nfacct
infrastructure. This extended accounting infrastructure provides a
netlink interface to create counters, that are uniquely identified by a
name, to fetch them from userspace; and to (atomically) fetch and reset
them.

In nf_tables, the use of the existing nfacct infrastructure would not
integrate nicely with its netlink interface and its 2-phase commit
protocol. For that reason, the use of nfacct is out of question.

This patch extends the nf_tables netlink interface to allow the
creation, deletion and dump of these stateful named expression from
userspace.

This patch introduces a generic infrastructure for stateful named
expressions, that allows userspace to set a name for the stateful
expression for several reason: 1) to provide a unique identifier to
fetch and reset it internal state, 2) to update of their parameters
and internal state, 3) to fetch and reset its internal state, and
4) to refer to the same stateful expression from one or more rules.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  25 ++
 include/uapi/linux/netfilter/nf_tables.h |  25 ++
 net/netfilter/nf_tables_api.c            | 393 +++++++++++++++++++++++++++++++
 3 files changed, 443 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f6b1daf..0ba91ac 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -653,6 +653,22 @@ struct nft_expr {
 	unsigned char			data[];
 };
 
+/**
+ *	struct nft_nexpr - nf_tables named expression
+ *
+ *	@list: table named expression list node
+ *	@name: name of this expression
+ *	@use: number of references to this named expression
+ *	@expr: pointer to expression object
+ */
+struct nft_nexpr {
+	struct list_head		list;
+	char				name[NFT_NEXPR_MAXNAMELEN];
+	u32				flags;
+	u32				use;
+	struct nft_expr			*expr;
+};
+
 static inline void *nft_expr_priv(const struct nft_expr *expr)
 {
 	return (void *)expr->data;
@@ -835,6 +851,7 @@ unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
  *	@list: used internally
  *	@chains: chains in the table
  *	@sets: sets in the table
+ *	@nexprs: named expression in the table
  *	@hgenerator: handle generator state
  *	@use: number of chain references to this table
  *	@flags: table flag (see enum nft_table_flags)
@@ -844,6 +861,7 @@ struct nft_table {
 	struct list_head		list;
 	struct list_head		chains;
 	struct list_head		sets;
+	struct list_head		nexprs;
 	u64				hgenerator;
 	u32				use;
 	u16				flags;
@@ -1088,4 +1106,11 @@ struct nft_trans_elem {
 #define nft_trans_elem(trans)	\
 	(((struct nft_trans_elem *)trans->data)->elem)
 
+struct nft_trans_nexpr {
+	struct nft_nexpr		*nexpr;
+};
+
+#define nft_trans_nexpr(trans)	\
+	(((struct nft_trans_nexpr *)trans->data)->nexpr)
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index be41ffc..c1e19c3 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -3,6 +3,7 @@
 
 #define NFT_TABLE_MAXNAMELEN	32
 #define NFT_CHAIN_MAXNAMELEN	32
+#define NFT_NEXPR_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
 
 /**
@@ -84,6 +85,9 @@ enum nft_verdicts {
  * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
  * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
  * @NFT_MSG_TRACE: trace event (enum nft_trace_attributes)
+ * @NFT_MSG_NEWNEXPR: create a new named expression (enum nft_nexpr_attributes)
+ * @NFT_MSG_GETNEXPR: get a named expression (enum nft_nexpr_attributes)
+ * @NFT_MSG_DELNEXPR: delete a named expression (enum nft_nexpr_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -104,6 +108,9 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWGEN,
 	NFT_MSG_GETGEN,
 	NFT_MSG_TRACE,
+	NFT_MSG_NEWNEXPR,
+	NFT_MSG_GETNEXPR,
+	NFT_MSG_DELNEXPR,
 	NFT_MSG_MAX,
 };
 
@@ -416,6 +423,24 @@ enum nft_verdict_attributes {
 #define NFTA_VERDICT_MAX	(__NFTA_VERDICT_MAX - 1)
 
 /**
+ * enum nft_nexpr_attributes - nf_tables named expression netlink attributes
+ *
+ * @NFTA_NEXPR_TABLE: name of the table containing the expression (NLA_STRING)
+ * @NFTA_NEXPR_NAME: name of this expression type (NLA_STRING)
+ * @NFTA_NEXPR_EXPR: expression data (NLA_NESTED: nft_expr_attributes)
+ * @NFTA_NEXPR_USE: number of references to this expression (NLA_U32)
+ */
+enum nft_nexpr_attributes {
+	NFTA_NEXPR_UNSPEC,
+	NFTA_NEXPR_TABLE,
+	NFTA_NEXPR_NAME,
+	NFTA_NEXPR_EXPR,
+	NFTA_NEXPR_USE,
+	__NFTA_NEXPR_MAX
+};
+#define NFTA_NEXPR_MAX		(__NFTA_NEXPR_MAX - 1)
+
+/**
  * enum nft_expr_attributes - nf_tables expression netlink attributes
  *
  * @NFTA_EXPR_NAME: name of the expression type (NLA_STRING)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2011977..b542d20 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -359,6 +359,39 @@ static int nft_delset(struct nft_ctx *ctx, struct nft_set *set)
 	return err;
 }
 
+/* Internal set flag */
+#define NFT_NEXPR_INACTIVE	(1 << 7)
+
+static int nft_trans_nexpr_add(struct nft_ctx *ctx, int msg_type,
+			       struct nft_nexpr *nexpr)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_nexpr));
+	if (trans == NULL)
+		return -ENOMEM;
+
+	nexpr->flags |= NFT_NEXPR_INACTIVE;
+	nft_trans_nexpr(trans) = nexpr;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+
+	return 0;
+}
+
+static int nft_delnexpr(struct nft_ctx *ctx, struct nft_nexpr *nexpr)
+{
+	int err;
+
+	err = nft_trans_nexpr_add(ctx, NFT_MSG_DELNEXPR, nexpr);
+	if (err < 0)
+		return err;
+
+	list_del_rcu(&nexpr->list);
+	ctx->table->use--;
+
+	return err;
+}
+
 /*
  * Tables
  */
@@ -728,6 +761,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	nla_strlcpy(table->name, name, NFT_TABLE_MAXNAMELEN);
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
+	INIT_LIST_HEAD(&table->nexprs);
 	table->flags = flags;
 
 	nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
@@ -749,6 +783,7 @@ static int nft_flush_table(struct nft_ctx *ctx)
 {
 	int err;
 	struct nft_chain *chain, *nc;
+	struct nft_nexpr *nexpr, *ne;
 	struct nft_set *set, *ns;
 
 	list_for_each_entry(chain, &ctx->table->chains, list) {
@@ -769,6 +804,12 @@ static int nft_flush_table(struct nft_ctx *ctx)
 			goto out;
 	}
 
+	list_for_each_entry_safe(nexpr, ne, &ctx->table->nexprs, list) {
+		err = nft_delnexpr(ctx, nexpr);
+		if (err < 0)
+			goto out;
+	}
+
 	list_for_each_entry_safe(chain, nc, &ctx->table->chains, list) {
 		ctx->chain = chain;
 
@@ -3759,6 +3800,315 @@ err:
 	return err;
 }
 
+static struct nft_nexpr *nf_tables_nexpr_lookup(const struct nft_table *table,
+						const struct nlattr * const nla[])
+{
+	struct nlattr *tb[NFTA_EXPR_MAX + 1];
+	struct nft_nexpr *nexpr;
+	int err;
+
+	if (!nla[NFTA_NEXPR_NAME] ||
+	    !nla[NFTA_NEXPR_EXPR])
+		return ERR_PTR(-EINVAL);
+
+	err = nla_parse_nested(tb, NFTA_EXPR_MAX, nla[NFTA_NEXPR_EXPR],
+			       nft_expr_policy);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	if (!tb[NFTA_EXPR_NAME])
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(nexpr, &table->nexprs, list) {
+		if (!nla_strcmp(nla[NFTA_NEXPR_NAME], nexpr->name) &&
+		    !nla_strcmp(tb[NFTA_EXPR_NAME], nexpr->expr->ops->type->name))
+			return nexpr;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
+static const struct nla_policy nft_nexpr_policy[NFTA_NEXPR_MAX + 1] = {
+	[NFTA_NEXPR_TABLE]	= { .type = NLA_STRING },
+	[NFTA_NEXPR_NAME]	= { .type = NLA_STRING },
+	[NFTA_NEXPR_EXPR]	= { .type = NLA_NESTED },
+};
+
+static int nf_tables_newnexpr(struct net *net, struct sock *nlsk,
+			      struct sk_buff *skb, const struct nlmsghdr *nlh,
+			      const struct nlattr * const nla[])
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	int family = nfmsg->nfgen_family;
+	struct nft_nexpr *nexpr;
+	struct nft_af_info *afi;
+	struct nft_table *table;
+	struct nft_expr *expr;
+	struct nft_ctx ctx;
+	int err;
+
+	if (!nla[NFTA_NEXPR_EXPR])
+		return -EINVAL;
+
+	afi = nf_tables_afinfo_lookup(net, family, true);
+	if (IS_ERR(afi))
+		return PTR_ERR(afi);
+
+	table = nf_tables_table_lookup(afi, nla[NFTA_NEXPR_TABLE]);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+
+	nexpr = nf_tables_nexpr_lookup(table, nla);
+	if (IS_ERR(nexpr)) {
+		err = PTR_ERR(nexpr);
+		if (err != -ENOENT)
+			return err;
+
+		nexpr = NULL;
+	}
+
+	if (nexpr != NULL) {
+		if (nlh->nlmsg_flags & NLM_F_EXCL)
+			return -EEXIST;
+		else
+			return -EBUSY;
+	}
+
+	nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
+
+	expr = nft_expr_init(&ctx, nla[NFTA_NEXPR_EXPR]);
+	if (IS_ERR(expr)) {
+		err = PTR_ERR(expr);
+		goto err1;
+	}
+
+	if (!(expr->ops->type->flags & NFT_EXPR_STATEFUL)) {
+		err = -EOPNOTSUPP;
+		goto err2;
+	}
+
+	nexpr = kzalloc(sizeof(struct nft_nexpr), GFP_KERNEL);
+	if (nexpr == NULL) {
+		err = -ENOMEM;
+		goto err2;
+	}
+
+	nla_strlcpy(nexpr->name, nla[NFTA_NEXPR_NAME], NFT_NEXPR_MAXNAMELEN);
+	nexpr->expr = expr;
+
+	err = nft_trans_nexpr_add(&ctx, NFT_MSG_NEWNEXPR, nexpr);
+	if (err < 0)
+		goto err3;
+
+	list_add_tail_rcu(&nexpr->list, &table->nexprs);
+	table->use++;
+	return 0;
+err3:
+	kfree(nexpr);
+err2:
+	nft_expr_destroy(&ctx, expr);
+err1:
+	kfree(nexpr);
+	return err;
+}
+
+static int nf_tables_fill_nexpr_info(struct sk_buff *skb, struct net *net,
+				     u32 portid, u32 seq, int event, u32 flags,
+				     int family, const struct nft_table *table,
+				     const struct nft_nexpr *nexpr)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfmsg;
+
+	event |= NFNL_SUBSYS_NFTABLES << 8;
+	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), flags);
+	if (nlh == NULL)
+		goto nla_put_failure;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family	= family;
+	nfmsg->version		= NFNETLINK_V0;
+	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+
+	if (nla_put_string(skb, NFTA_NEXPR_TABLE, table->name) ||
+	    nla_put_string(skb, NFTA_NEXPR_NAME, nexpr->name) ||
+	    nla_put_be32(skb, NFTA_NEXPR_USE, htonl(nexpr->use)) ||
+	    nft_expr_dump(skb, NFTA_NEXPR_EXPR, nexpr->expr))
+		goto nla_put_failure;
+
+	nlmsg_end(skb, nlh);
+	return 0;
+
+nla_put_failure:
+	nlmsg_trim(skb, nlh);
+	return -1;
+}
+
+static int nf_tables_dump_nexpr(struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	const struct nft_af_info *afi;
+	const struct nft_table *table;
+	const struct nft_nexpr *nexpr;
+	unsigned int idx = 0, s_idx = cb->args[0];
+	struct net *net = sock_net(skb->sk);
+	int family = nfmsg->nfgen_family;
+
+	rcu_read_lock();
+	cb->seq = net->nft.base_seq;
+
+	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
+		if (family != NFPROTO_UNSPEC && family != afi->family)
+			continue;
+
+		list_for_each_entry_rcu(table, &afi->tables, list) {
+			list_for_each_entry_rcu(nexpr, &table->nexprs, list) {
+				if (idx < s_idx)
+					goto cont;
+				if (idx > s_idx)
+					memset(&cb->args[1], 0,
+					       sizeof(cb->args) - sizeof(cb->args[0]));
+				if (nf_tables_fill_nexpr_info(skb, net, NETLINK_CB(cb->skb).portid,
+							      cb->nlh->nlmsg_seq,
+							      NFT_MSG_NEWNEXPR,
+							      NLM_F_MULTI | NLM_F_APPEND,
+							      afi->family, table, nexpr) < 0)
+					goto done;
+
+				nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+cont:
+				idx++;
+			}
+		}
+	}
+done:
+	rcu_read_unlock();
+
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+static int nf_tables_getnexpr(struct net *net, struct sock *nlsk,
+			      struct sk_buff *skb, const struct nlmsghdr *nlh,
+			      const struct nlattr * const nla[])
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	int family = nfmsg->nfgen_family;
+	const struct nft_af_info *afi;
+	const struct nft_table *table;
+	struct nft_nexpr *nexpr;
+	struct sk_buff *skb2;
+	int err;
+
+	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.dump = nf_tables_dump_nexpr,
+		};
+		return netlink_dump_start(nlsk, skb, nlh, &c);
+	}
+
+	afi = nf_tables_afinfo_lookup(net, family, false);
+	if (IS_ERR(afi))
+		return PTR_ERR(afi);
+
+	table = nf_tables_table_lookup(afi, nla[NFTA_NEXPR_TABLE]);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+	if (table->flags & NFT_TABLE_INACTIVE)
+		return -ENOENT;
+
+	nexpr = nf_tables_nexpr_lookup(table, nla);
+	if (IS_ERR(nexpr))
+		return PTR_ERR(nexpr);
+
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb2)
+		return -ENOMEM;
+
+	err = nf_tables_fill_nexpr_info(skb2, net, NETLINK_CB(skb).portid,
+					nlh->nlmsg_seq, NFT_MSG_NEWNEXPR, 0,
+					family, table, nexpr);
+	if (err < 0)
+		goto err;
+
+	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+
+err:
+	kfree_skb(skb2);
+	return err;
+
+	return 0;
+}
+
+static void nft_nexpr_destroy(struct nft_ctx *ctx, struct nft_nexpr *nexpr)
+{
+	nft_expr_destroy(ctx, nexpr->expr);
+	kfree(nexpr);
+}
+
+static int nf_tables_delnexpr(struct net *net, struct sock *nlsk,
+			      struct sk_buff *skb, const struct nlmsghdr *nlh,
+			      const struct nlattr * const nla[])
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	int family = nfmsg->nfgen_family;
+	struct nft_nexpr *nexpr;
+	struct nft_af_info *afi;
+	struct nft_table *table;
+	struct nft_ctx ctx;
+
+	afi = nf_tables_afinfo_lookup(net, family, true);
+	if (IS_ERR(afi))
+		return PTR_ERR(afi);
+
+	table = nf_tables_table_lookup(afi, nla[NFTA_NEXPR_TABLE]);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+
+	nexpr = nf_tables_nexpr_lookup(table, nla);
+	if (IS_ERR(nexpr))
+		return PTR_ERR(nexpr);
+	if (nexpr->use > 0)
+		return -EBUSY;
+
+	nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
+
+	return nft_delnexpr(&ctx, nexpr);
+}
+
+static int nf_tables_nexpr_notify(const struct nft_ctx *ctx,
+				  struct nft_nexpr *nexpr, int event)
+{
+	struct sk_buff *skb;
+	int err;
+
+	if (!ctx->report &&
+	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
+		return 0;
+
+	err = -ENOBUFS;
+	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (skb == NULL)
+		goto err;
+
+	err = nf_tables_fill_nexpr_info(skb, ctx->net, ctx->portid, ctx->seq,
+					event, 0, ctx->afi->family, ctx->table,
+					nexpr);
+	if (err < 0) {
+		kfree_skb(skb);
+		goto err;
+	}
+
+	err = nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
+			     ctx->report, GFP_KERNEL);
+err:
+	if (err < 0) {
+		nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
+				  err);
+	}
+	return err;
+}
+
 static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	[NFT_MSG_NEWTABLE] = {
 		.call_batch	= nf_tables_newtable,
@@ -3838,6 +4188,21 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	[NFT_MSG_GETGEN] = {
 		.call		= nf_tables_getgen,
 	},
+	[NFT_MSG_NEWNEXPR] = {
+		.call_batch	= nf_tables_newnexpr,
+		.attr_count	= NFTA_NEXPR_MAX,
+		.policy		= nft_nexpr_policy,
+	},
+	[NFT_MSG_GETNEXPR] = {
+		.call		= nf_tables_getnexpr,
+		.attr_count	= NFTA_NEXPR_MAX,
+		.policy		= nft_nexpr_policy,
+	},
+	[NFT_MSG_DELNEXPR] = {
+		.call_batch	= nf_tables_delnexpr,
+		.attr_count	= NFTA_NEXPR_MAX,
+		.policy		= nft_nexpr_policy,
+	},
 };
 
 static void nft_chain_commit_update(struct nft_trans *trans)
@@ -3880,6 +4245,9 @@ static void nf_tables_commit_release(struct nft_trans *trans)
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
 				     nft_trans_elem(trans).priv);
 		break;
+	case NFT_MSG_NEWNEXPR:
+		nft_nexpr_destroy(&trans->ctx, nft_trans_nexpr(trans));
+		break;
 	}
 	kfree(trans);
 }
@@ -3982,6 +4350,18 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			atomic_dec(&te->set->nelems);
 			te->set->ndeact--;
 			break;
+		case NFT_MSG_NEWNEXPR:
+			nft_trans_nexpr(trans)->flags &= ~NFT_NEXPR_INACTIVE;
+			nf_tables_nexpr_notify(&trans->ctx,
+					       nft_trans_nexpr(trans),
+					       NFT_MSG_NEWNEXPR);
+			nft_trans_destroy(trans);
+			break;
+		case NFT_MSG_DELNEXPR:
+			nf_tables_nexpr_notify(&trans->ctx,
+					       nft_trans_nexpr(trans),
+					       NFT_MSG_DELNEXPR);
+			break;
 		}
 	}
 
@@ -4016,6 +4396,9 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
 				     nft_trans_elem(trans).priv);
 		break;
+	case NFT_MSG_NEWNEXPR:
+		nft_nexpr_destroy(&trans->ctx, nft_trans_nexpr(trans));
+		break;
 	}
 	kfree(trans);
 }
@@ -4097,6 +4480,16 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 
 			nft_trans_destroy(trans);
 			break;
+		case NFT_MSG_NEWNEXPR:
+			trans->ctx.table->use--;
+			list_del_rcu(&nft_trans_nexpr(trans)->list);
+			break;
+		case NFT_MSG_DELNEXPR:
+			trans->ctx.table->use++;
+			list_add_tail_rcu(&nft_trans_nexpr(trans)->list,
+					  &trans->ctx.table->nexprs);
+			nft_trans_destroy(trans);
+			break;
 		}
 	}
 
-- 
2.1.4

