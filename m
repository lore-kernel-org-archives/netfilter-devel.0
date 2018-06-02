From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/20] netfilter: nf_tables: fix chain dependency validation
Date: Sat,  2 Jun 2018 02:22:54 +0200
Message-ID: <20180602002259.4024-16-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The following ruleset:

 add table ip filter
 add chain ip filter input { type filter hook input priority 4; }
 add chain ip filter ap
 add rule ip filter input jump ap
 add rule ip filter ap masquerade

results in a panic, because the masquerade extension should be rejected
from the filter chain. The existing validation is missing a chain
dependency check when the rule is added to the non-base chain.

This patch fixes the problem by walking down the rules from the
basechains, searching for either immediate or lookup expressions, then
jumping to non-base chains and again walking down the rules to perform
the expression validation, so we make sure the full ruleset graph is
validated. This is done only once from the commit phase, in case of
problem, we abort the transaction and perform fine grain validation for
error reporting. This patch requires 003087911af2 ("netfilter:
nfnetlink: allow commit to fail") to achieve this behaviour.

This patch also adds a cleanup callback to nfnl batch interface to reset
the validate state from the exit path.

As a result of this patch, nf_tables_check_loops() doesn't use
->validate to check for loops, instead it just checks for immediate
expressions.

Reported-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h    |   1 +
 include/net/netfilter/nf_tables.h      |   2 +
 include/net/netfilter/nf_tables_core.h |   8 ++
 include/net/netns/nftables.h           |   1 +
 net/netfilter/nf_tables_api.c          | 152 ++++++++++++++++++++++++++++-----
 net/netfilter/nfnetlink.c              |   2 +
 net/netfilter/nft_immediate.c          |  27 ++++--
 net/netfilter/nft_lookup.c             |  47 ++++++++++
 8 files changed, 208 insertions(+), 32 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 34551f8aaf9d..3ecc3050be0e 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -31,6 +31,7 @@ struct nfnetlink_subsystem {
 	const struct nfnl_callback *cb;	/* callback for individual types */
 	int (*commit)(struct net *net, struct sk_buff *skb);
 	int (*abort)(struct net *net, struct sk_buff *skb);
+	void (*cleanup)(struct net *net);
 	bool (*valid_genid)(struct net *net, u32 genid);
 };
 
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6b9ddb99f3a8..435c32d8a995 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -874,6 +874,8 @@ struct nft_chain {
 	struct nft_rule			**rules_next;
 };
 
+int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
+
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
 	NFT_CHAIN_T_ROUTE,
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index cd6915b6c054..e0c0c2558ec4 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -2,6 +2,8 @@
 #ifndef _NET_NF_TABLES_CORE_H
 #define _NET_NF_TABLES_CORE_H
 
+#include <net/netfilter/nf_tables.h>
+
 extern struct nft_expr_type nft_imm_type;
 extern struct nft_expr_type nft_cmp_type;
 extern struct nft_expr_type nft_lookup_type;
@@ -23,6 +25,12 @@ struct nft_cmp_fast_expr {
 	u8			len;
 };
 
+struct nft_immediate_expr {
+	struct nft_data		data;
+	enum nft_registers	dreg:8;
+	u8			dlen;
+};
+
 /* Calculate the mask for the nft_cmp_fast expression. On big endian the
  * mask needs to include the *upper* bytes when interpreting that data as
  * something smaller than the full u32, therefore a cpu_to_le32 is done.
diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 29c3851b486a..94767ea3a490 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -9,6 +9,7 @@ struct netns_nftables {
 	struct list_head	commit_list;
 	unsigned int		base_seq;
 	u8			gencursor;
+	u8			validate_state;
 };
 
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3b2ad96a9a05..c785bc5a66f1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -28,6 +28,28 @@ static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
 static u64 table_handle;
 
+enum {
+	NFT_VALIDATE_SKIP	= 0,
+	NFT_VALIDATE_NEED,
+	NFT_VALIDATE_DO,
+};
+
+static void nft_validate_state_update(struct net *net, u8 new_validate_state)
+{
+	switch (net->nft.validate_state) {
+	case NFT_VALIDATE_SKIP:
+		WARN_ON_ONCE(new_validate_state == NFT_VALIDATE_DO);
+		break;
+	case NFT_VALIDATE_NEED:
+		break;
+	case NFT_VALIDATE_DO:
+		if (new_validate_state == NFT_VALIDATE_NEED)
+			return;
+	}
+
+	net->nft.validate_state = new_validate_state;
+}
+
 static void nft_ctx_init(struct nft_ctx *ctx,
 			 struct net *net,
 			 const struct sk_buff *skb,
@@ -1921,19 +1943,7 @@ static int nf_tables_newexpr(const struct nft_ctx *ctx,
 			goto err1;
 	}
 
-	if (ops->validate) {
-		const struct nft_data *data = NULL;
-
-		err = ops->validate(ctx, expr, &data);
-		if (err < 0)
-			goto err2;
-	}
-
 	return 0;
-
-err2:
-	if (ops->destroy)
-		ops->destroy(ctx, expr);
 err1:
 	expr->ops = NULL;
 	return err;
@@ -2299,6 +2309,53 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx,
 	nf_tables_rule_destroy(ctx, rule);
 }
 
+int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
+{
+	struct nft_expr *expr, *last;
+	const struct nft_data *data;
+	struct nft_rule *rule;
+	int err;
+
+	list_for_each_entry(rule, &chain->rules, list) {
+		if (!nft_is_active_next(ctx->net, rule))
+			continue;
+
+		nft_rule_for_each_expr(expr, last, rule) {
+			if (!expr->ops->validate)
+				continue;
+
+			err = expr->ops->validate(ctx, expr, &data);
+			if (err < 0)
+				return err;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_chain_validate);
+
+static int nft_table_validate(struct net *net, const struct nft_table *table)
+{
+	struct nft_chain *chain;
+	struct nft_ctx ctx = {
+		.net	= net,
+		.family	= table->family,
+	};
+	int err;
+
+	list_for_each_entry(chain, &table->chains, list) {
+		if (!nft_is_base_chain(chain))
+			continue;
+
+		ctx.chain = chain;
+		err = nft_chain_validate(&ctx, chain);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 #define NFT_RULE_MAXEXPRS	128
 
 static struct nft_expr_info *info;
@@ -2426,6 +2483,10 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		err = nf_tables_newexpr(&ctx, &info[i], expr);
 		if (err < 0)
 			goto err2;
+
+		if (info[i].ops->validate)
+			nft_validate_state_update(net, NFT_VALIDATE_NEED);
+
 		info[i].ops = NULL;
 		expr = nft_expr_next(expr);
 	}
@@ -2469,8 +2530,11 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		}
 	}
 	chain->use++;
-	return 0;
 
+	if (net->nft.validate_state == NFT_VALIDATE_DO)
+		return nft_table_validate(net, table);
+
+	return 0;
 err2:
 	nf_tables_rule_release(&ctx, rule);
 err1:
@@ -4112,6 +4176,12 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 							  d2.type, d2.len);
 			if (err < 0)
 				goto err3;
+
+			if (d2.type == NFT_DATA_VERDICT &&
+			    (data.verdict.code == NFT_GOTO ||
+			     data.verdict.code == NFT_JUMP))
+				nft_validate_state_update(ctx->net,
+							  NFT_VALIDATE_NEED);
 		}
 
 		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, d2.len);
@@ -4211,7 +4281,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 	const struct nlattr *attr;
 	struct nft_set *set;
 	struct nft_ctx ctx;
-	int rem, err = 0;
+	int rem, err;
 
 	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL)
 		return -EINVAL;
@@ -4232,9 +4302,13 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_add_set_elem(&ctx, set, attr, nlh->nlmsg_flags);
 		if (err < 0)
-			break;
+			return err;
 	}
-	return err;
+
+	if (net->nft.validate_state == NFT_VALIDATE_DO)
+		return nft_table_validate(net, ctx.table);
+
+	return 0;
 }
 
 /**
@@ -5867,6 +5941,27 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	},
 };
 
+static int nf_tables_validate(struct net *net)
+{
+	struct nft_table *table;
+
+	switch (net->nft.validate_state) {
+	case NFT_VALIDATE_SKIP:
+		break;
+	case NFT_VALIDATE_NEED:
+		nft_validate_state_update(net, NFT_VALIDATE_DO);
+		/* fall through */
+	case NFT_VALIDATE_DO:
+		list_for_each_entry(table, &net->nft.tables, list) {
+			if (nft_table_validate(net, table) < 0)
+				return -EAGAIN;
+		}
+		break;
+	}
+
+	return 0;
+}
+
 static void nft_chain_commit_update(struct nft_trans *trans)
 {
 	struct nft_base_chain *basechain;
@@ -6055,6 +6150,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	struct nft_chain *chain;
 	struct nft_table *table;
 
+	/* 0. Validate ruleset, otherwise roll back for error reporting. */
+	if (nf_tables_validate(net) < 0)
+		return -EAGAIN;
+
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		int ret;
@@ -6349,6 +6448,11 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 	return 0;
 }
 
+static void nf_tables_cleanup(struct net *net)
+{
+	nft_validate_state_update(net, NFT_VALIDATE_SKIP);
+}
+
 static bool nf_tables_valid_genid(struct net *net, u32 genid)
 {
 	return net->nft.base_seq == genid;
@@ -6361,6 +6465,7 @@ static const struct nfnetlink_subsystem nf_tables_subsys = {
 	.cb		= nf_tables_cb,
 	.commit		= nf_tables_commit,
 	.abort		= nf_tables_abort,
+	.cleanup	= nf_tables_cleanup,
 	.valid_genid	= nf_tables_valid_genid,
 };
 
@@ -6444,19 +6549,18 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 
 	list_for_each_entry(rule, &chain->rules, list) {
 		nft_rule_for_each_expr(expr, last, rule) {
-			const struct nft_data *data = NULL;
+			struct nft_immediate_expr *priv;
+			const struct nft_data *data;
 			int err;
 
-			if (!expr->ops->validate)
+			if (strcmp(expr->ops->type->name, "immediate"))
 				continue;
 
-			err = expr->ops->validate(ctx, expr, &data);
-			if (err < 0)
-				return err;
-
-			if (data == NULL)
+			priv = nft_expr_priv(expr);
+			if (priv->dreg != NFT_REG_VERDICT)
 				continue;
 
+			data = &priv->data;
 			switch (data->verdict.code) {
 			case NFT_JUMP:
 			case NFT_GOTO:
@@ -6936,6 +7040,8 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&net->nft.tables);
 	INIT_LIST_HEAD(&net->nft.commit_list);
 	net->nft.base_seq = 1;
+	net->nft.validate_state = NFT_VALIDATE_SKIP;
+
 	return 0;
 }
 
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 5a1bd23af1a3..261820627711 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -460,6 +460,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	} else {
 		ss->abort(net, oskb);
 	}
+	if (ss->cleanup)
+		ss->cleanup(net);
 
 	nfnl_err_deliver(&err_list, oskb);
 	nfnl_unlock(subsys_id);
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index aa87ff8beae8..15adf8ca82c3 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -17,12 +17,6 @@
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 
-struct nft_immediate_expr {
-	struct nft_data		data;
-	enum nft_registers	dreg:8;
-	u8			dlen;
-};
-
 static void nft_immediate_eval(const struct nft_expr *expr,
 			       struct nft_regs *regs,
 			       const struct nft_pktinfo *pkt)
@@ -101,12 +95,27 @@ static int nft_immediate_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 static int nft_immediate_validate(const struct nft_ctx *ctx,
 				  const struct nft_expr *expr,
-				  const struct nft_data **data)
+				  const struct nft_data **d)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+	const struct nft_data *data;
+	int err;
 
-	if (priv->dreg == NFT_REG_VERDICT)
-		*data = &priv->data;
+	if (priv->dreg != NFT_REG_VERDICT)
+		return 0;
+
+	data = &priv->data;
+
+	switch (data->verdict.code) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		err = nft_chain_validate(ctx, data->verdict.chain);
+		if (err < 0)
+			return err;
+		break;
+	default:
+		break;
+	}
 
 	return 0;
 }
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index f52da5e2199f..42e6fadf1417 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -149,6 +149,52 @@ static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static int nft_lookup_validate_setelem(const struct nft_ctx *ctx,
+				       struct nft_set *set,
+				       const struct nft_set_iter *iter,
+				       struct nft_set_elem *elem)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	const struct nft_data *data;
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
+	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
+		return 0;
+
+	data = nft_set_ext_data(ext);
+	switch (data->verdict.code) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		return nft_chain_validate(ctx, data->verdict.chain);
+	default:
+		return 0;
+	}
+}
+
+static int nft_lookup_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nft_data **d)
+{
+	const struct nft_lookup *priv = nft_expr_priv(expr);
+	struct nft_set_iter iter;
+
+	if (!(priv->set->flags & NFT_SET_MAP) ||
+	    priv->set->dtype != NFT_DATA_VERDICT)
+		return 0;
+
+	iter.genmask	= nft_genmask_next(ctx->net);
+	iter.skip	= 0;
+	iter.count	= 0;
+	iter.err	= 0;
+	iter.fn		= nft_lookup_validate_setelem;
+
+	priv->set->ops->walk(ctx, priv->set, &iter);
+	if (iter.err < 0)
+		return iter.err;
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_lookup_ops = {
 	.type		= &nft_lookup_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
@@ -156,6 +202,7 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.init		= nft_lookup_init,
 	.destroy	= nft_lookup_destroy,
 	.dump		= nft_lookup_dump,
+	.validate	= nft_lookup_validate,
 };
 
 struct nft_expr_type nft_lookup_type __read_mostly = {
-- 
2.11.0
