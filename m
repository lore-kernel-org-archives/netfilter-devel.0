From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/15] netfilter: nf_tables: bogus EBUSY in chain deletions
Date: Mon, 14 May 2018 00:36:55 +0200
Message-ID: <20180513223656.10077-15-pablo@netfilter.org>
References: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513223656.10077-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

When removing a rule that jumps to chain and such chain in the same
batch, this bogusly hits EBUSY. Add activate and deactivate operations
to expression that can be called from the preparation and the
commit/abort phases.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  5 +++++
 net/netfilter/nf_tables_api.c     | 46 +++++++++++++++++++++++++++++++++++----
 net/netfilter/nft_immediate.c     | 15 ++++++++++---
 3 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cd368d1b8cb8..a1e28dd5d0bf 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -170,6 +170,7 @@ struct nft_data_desc {
 int nft_data_init(const struct nft_ctx *ctx,
 		  struct nft_data *data, unsigned int size,
 		  struct nft_data_desc *desc, const struct nlattr *nla);
+void nft_data_hold(const struct nft_data *data, enum nft_data_types type);
 void nft_data_release(const struct nft_data *data, enum nft_data_types type);
 int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 		  enum nft_data_types type, unsigned int len);
@@ -736,6 +737,10 @@ struct nft_expr_ops {
 	int				(*init)(const struct nft_ctx *ctx,
 						const struct nft_expr *expr,
 						const struct nlattr * const tb[]);
+	void				(*activate)(const struct nft_ctx *ctx,
+						    const struct nft_expr *expr);
+	void				(*deactivate)(const struct nft_ctx *ctx,
+						      const struct nft_expr *expr);
 	void				(*destroy)(const struct nft_ctx *ctx,
 						   const struct nft_expr *expr);
 	int				(*dump)(struct sk_buff *skb,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 785d7fcf1fe1..3806db31cbbf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -214,6 +214,34 @@ static int nft_delchain(struct nft_ctx *ctx)
 	return err;
 }
 
+static void nft_rule_expr_activate(const struct nft_ctx *ctx,
+				   struct nft_rule *rule)
+{
+	struct nft_expr *expr;
+
+	expr = nft_expr_first(rule);
+	while (expr != nft_expr_last(rule) && expr->ops) {
+		if (expr->ops->activate)
+			expr->ops->activate(ctx, expr);
+
+		expr = nft_expr_next(expr);
+	}
+}
+
+static void nft_rule_expr_deactivate(const struct nft_ctx *ctx,
+				     struct nft_rule *rule)
+{
+	struct nft_expr *expr;
+
+	expr = nft_expr_first(rule);
+	while (expr != nft_expr_last(rule) && expr->ops) {
+		if (expr->ops->deactivate)
+			expr->ops->deactivate(ctx, expr);
+
+		expr = nft_expr_next(expr);
+	}
+}
+
 static int
 nf_tables_delrule_deactivate(struct nft_ctx *ctx, struct nft_rule *rule)
 {
@@ -259,6 +287,7 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 		nft_trans_destroy(trans);
 		return err;
 	}
+	nft_rule_expr_deactivate(ctx, rule);
 
 	return 0;
 }
@@ -2238,6 +2267,13 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 	kfree(rule);
 }
 
+static void nf_tables_rule_release(const struct nft_ctx *ctx,
+				   struct nft_rule *rule)
+{
+	nft_rule_expr_deactivate(ctx, rule);
+	nf_tables_rule_destroy(ctx, rule);
+}
+
 #define NFT_RULE_MAXEXPRS	128
 
 static struct nft_expr_info *info;
@@ -2402,7 +2438,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	return 0;
 
 err2:
-	nf_tables_rule_destroy(&ctx, rule);
+	nf_tables_rule_release(&ctx, rule);
 err1:
 	for (i = 0; i < n; i++) {
 		if (info[i].ops != NULL)
@@ -4130,7 +4166,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
  *	NFT_GOTO verdicts. This function must be called on active data objects
  *	from the second phase of the commit protocol.
  */
-static void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
+void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
 {
 	if (type == NFT_DATA_VERDICT) {
 		switch (data->verdict.code) {
@@ -6015,10 +6051,12 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWRULE:
 			trans->ctx.chain->use--;
 			list_del_rcu(&nft_trans_rule(trans)->list);
+			nft_rule_expr_deactivate(&trans->ctx, nft_trans_rule(trans));
 			break;
 		case NFT_MSG_DELRULE:
 			trans->ctx.chain->use++;
 			nft_clear(trans->ctx.net, nft_trans_rule(trans));
+			nft_rule_expr_activate(&trans->ctx, nft_trans_rule(trans));
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSET:
@@ -6594,7 +6632,7 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
 		list_del(&rule->list);
 		ctx->chain->use--;
-		nf_tables_rule_destroy(ctx, rule);
+		nf_tables_rule_release(ctx, rule);
 	}
 	list_del(&ctx->chain->list);
 	ctx->table->use--;
@@ -6632,7 +6670,7 @@ static void __nft_release_tables(struct net *net)
 			list_for_each_entry_safe(rule, nr, &chain->rules, list) {
 				list_del(&rule->list);
 				chain->use--;
-				nf_tables_rule_destroy(&ctx, rule);
+				nf_tables_rule_release(&ctx, rule);
 			}
 		}
 		list_for_each_entry_safe(flowtable, nf, &table->flowtables, list) {
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 4717d7796927..aa87ff8beae8 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -69,8 +69,16 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
 	return err;
 }
 
-static void nft_immediate_destroy(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr)
+static void nft_immediate_activate(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+
+	return nft_data_hold(&priv->data, nft_dreg_to_type(priv->dreg));
+}
+
+static void nft_immediate_deactivate(const struct nft_ctx *ctx,
+				     const struct nft_expr *expr)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 
@@ -108,7 +116,8 @@ static const struct nft_expr_ops nft_imm_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
 	.eval		= nft_immediate_eval,
 	.init		= nft_immediate_init,
-	.destroy	= nft_immediate_destroy,
+	.activate	= nft_immediate_activate,
+	.deactivate	= nft_immediate_deactivate,
 	.dump		= nft_immediate_dump,
 	.validate	= nft_immediate_validate,
 };
-- 
2.11.0
