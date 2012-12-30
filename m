From: pablo@netfilter.org
Subject: [PATCH 3/4] netfilter: nf_tables: validate hooks for compat match/target
Date: Mon, 31 Dec 2012 00:23:15 +0100
Message-ID: <1356909796-3143-3-git-send-email-pablo@netfilter.org>
References: <1356909796-3143-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56042 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab2L3XXb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2012 18:23:31 -0500
In-Reply-To: <1356909796-3143-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch validates that matches/targets are called from the
appropriate hook. This uses the existing loop detection approach
for the case they are not used in base chains. Basically, it
renames the expr->ops->get_verdict callback and generalize it
to expr->ops->validate.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    5 ++-
 net/netfilter/nf_tables_api.c     |   14 ++++++---
 net/netfilter/nft_compat.c        |   62 +++++++++++++++++++++++++++++++++++--
 net/netfilter/nft_immediate.c     |   12 ++++---
 4 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 26d75e4..7f994a2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -257,6 +257,7 @@ struct nft_expr_type {
  *	@destroy: destruction function
  *	@dump: function to dump parameters
  *	@type: expression type
+ *	@validate: validate expression, called during loop detection
  *	@data: extra data to attach to this expression operation
  */
 struct nft_expr;
@@ -272,7 +273,9 @@ struct nft_expr_ops {
 	void				(*destroy)(const struct nft_expr *expr);
 	int				(*dump)(struct sk_buff *skb,
 						const struct nft_expr *expr);
-	const struct nft_data *		(*get_verdict)(const struct nft_expr *expr);
+	int				(*validate)(const struct nft_ctx *ctx,
+						    const struct nft_expr *expr,
+						    const struct nft_data **data);
 	const struct nft_expr_type	*type;
 	void				*data;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 67b4548..0e27d2e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2492,23 +2492,27 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 {
 	const struct nft_rule *rule;
 	const struct nft_expr *expr, *last;
-	const struct nft_data *data;
 	const struct nft_set *set;
 	struct nft_set_binding *binding;
 	struct nft_set_iter iter;
-	int err;
 
 	if (ctx->chain == chain)
 		return -ELOOP;
 
 	list_for_each_entry(rule, &chain->rules, list) {
 		nft_rule_for_each_expr(expr, last, rule) {
-			if (!expr->ops->get_verdict)
+			const struct nft_data *data = NULL;
+			int err;
+
+			if (!expr->ops->validate)
 				continue;
 
-			data = expr->ops->get_verdict(expr);
+			err = expr->ops->validate(ctx, expr, &data);
+			if (err < 0)
+				return err;
+
 			if (data == NULL)
-				break;
+				continue;
 
 			switch (data->verdict) {
 			case NFT_JUMP:
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 91f827b..328abf1 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -118,7 +118,13 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 	par->entryinfo	= NULL;	/* FIXME */
 	par->target	= target;
 	par->targinfo	= info;
-	par->hook_mask	= 0; /* FIXME */
+	if (ctx->chain->flags & NFT_BASE_CHAIN) {
+		const struct nft_base_chain *basechain =
+						nft_base_chain(ctx->chain);
+		const struct nf_hook_ops *ops = &basechain->ops;
+
+		par->hook_mask = 1 << ops->hooknum;
+	}
 	par->family	= ctx->afi->family;
 }
 
@@ -178,6 +184,28 @@ nla_put_failure:
 	return -1;
 }
 
+static int nft_target_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nft_data **data)
+{
+	struct xt_target *target = expr->ops->data;
+	unsigned int hook_mask = 0;
+
+	if (ctx->chain->flags & NFT_BASE_CHAIN) {
+		const struct nft_base_chain *basechain =
+						nft_base_chain(ctx->chain);
+		const struct nf_hook_ops *ops = &basechain->ops;
+
+		hook_mask = 1 << ops->hooknum;
+		if (hook_mask & target->hooks)
+			return 0;
+
+		/* This target is being called from an invalid chain */
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static void nft_match_eval(const struct nft_expr *expr,
 			   struct nft_data data[NFT_REG_MAX + 1],
 			   const struct nft_pktinfo *pkt)
@@ -231,7 +259,13 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 	par->entryinfo	= NULL;	/* FIXME */
 	par->match	= match;
 	par->matchinfo	= info;
-	par->hook_mask	= 0; /* FIXME */
+	if (ctx->chain->flags & NFT_BASE_CHAIN) {
+		const struct nft_base_chain *basechain =
+						nft_base_chain(ctx->chain);
+		const struct nf_hook_ops *ops = &basechain->ops;
+
+		par->hook_mask = 1 << ops->hooknum;
+	}
 	par->family	= ctx->afi->family;
 }
 
@@ -284,6 +318,28 @@ nla_put_failure:
 	return -1;
 }
 
+static int nft_match_validate(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr,
+			      const struct nft_data **data)
+{
+	struct xt_match *match = expr->ops->data;
+	unsigned int hook_mask = 0;
+
+	if (ctx->chain->flags & NFT_BASE_CHAIN) {
+		const struct nft_base_chain *basechain =
+						nft_base_chain(ctx->chain);
+		const struct nf_hook_ops *ops = &basechain->ops;
+
+		hook_mask = 1 << ops->hooknum;
+		if (hook_mask & match->hooks)
+			return 0;
+
+		/* This match is being called from an invalid chain */
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int
 nfnl_compat_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		      int event, u16 family, const char *name,
@@ -453,6 +509,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	nft_match->ops.init = nft_match_init;
 	nft_match->ops.destroy = nft_match_destroy;
 	nft_match->ops.dump = nft_match_dump;
+	nft_match->ops.validate = nft_match_validate;
 	nft_match->ops.data = match;
 
 	list_add(&nft_match->head, &nft_match_list);
@@ -514,6 +571,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	nft_target->ops.init = nft_target_init;
 	nft_target->ops.destroy = nft_target_destroy;
 	nft_target->ops.dump = nft_target_dump;
+	nft_target->ops.validate = nft_target_validate;
 	nft_target->ops.data = target;
 
 	list_add(&nft_target->head, &nft_target_list);
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 1bfeeaf..f169501 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -90,14 +90,16 @@ nla_put_failure:
 	return -1;
 }
 
-static const struct nft_data *nft_immediate_get_verdict(const struct nft_expr *expr)
+static int nft_immediate_validate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr,
+				  const struct nft_data **data)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 
 	if (priv->dreg == NFT_REG_VERDICT)
-		return &priv->data;
-	else
-		return NULL;
+		*data = &priv->data;
+
+	return 0;
 }
 
 static struct nft_expr_type nft_imm_type;
@@ -108,7 +110,7 @@ static const struct nft_expr_ops nft_imm_ops = {
 	.init		= nft_immediate_init,
 	.destroy	= nft_immediate_destroy,
 	.dump		= nft_immediate_dump,
-	.get_verdict	= nft_immediate_get_verdict,
+	.validate	= nft_immediate_validate,
 };
 
 static struct nft_expr_type nft_imm_type __read_mostly = {
-- 
1.7.10.4

