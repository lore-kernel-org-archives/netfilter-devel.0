From: pablo@netfilter.org
Subject: [PATCH 2/4] netfilter: nf_tables: nft_compat: private data of target and matches in contiguous area
Date: Mon, 31 Dec 2012 00:23:14 +0100
Message-ID: <1356909796-3143-2-git-send-email-pablo@netfilter.org>
References: <1356909796-3143-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56036 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab2L3XX2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2012 18:23:28 -0500
In-Reply-To: <1356909796-3143-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch reworks the compatibility infrastructure to place the private
match and target information in the contiguous area just after the nft_expr
header.

The compatibility infrastructure registers a native operation that
maps to one of the existing matches/targets. This allows no modification
in the layout of the nft_expr to include any new size field.

Original idea from Patrick McHardy.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    5 +-
 net/netfilter/nf_tables_api.c     |   11 +-
 net/netfilter/nft_cmp.c           |    3 +-
 net/netfilter/nft_compat.c        |  279 +++++++++++++++++++++----------------
 net/netfilter/nft_payload.c       |    3 +-
 5 files changed, 172 insertions(+), 129 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e7dc1da..26d75e4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -238,7 +238,8 @@ extern void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
  *	@maxattr: highest netlink attribute number
  */
 struct nft_expr_type {
-	const struct nft_expr_ops	*(*select_ops)(const struct nlattr * const tb[]);
+	const struct nft_expr_ops	*(*select_ops)(const struct nft_ctx *,
+						       const struct nlattr * const tb[]);
 	const struct nft_expr_ops	*ops;
 	struct list_head		list;
 	const char			*name;
@@ -256,6 +257,7 @@ struct nft_expr_type {
  *	@destroy: destruction function
  *	@dump: function to dump parameters
  *	@type: expression type
+ *	@data: extra data to attach to this expression operation
  */
 struct nft_expr;
 struct nft_expr_ops {
@@ -272,6 +274,7 @@ struct nft_expr_ops {
 						const struct nft_expr *expr);
 	const struct nft_data *		(*get_verdict)(const struct nft_expr *expr);
 	const struct nft_expr_type	*type;
+	void				*data;
 };
 
 #define NFT_EXPR_MAXATTR		16
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a847375..67b4548 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1026,7 +1026,8 @@ struct nft_expr_info {
 	struct nlattr			*tb[NFT_EXPR_MAXATTR + 1];
 };
 
-static int nf_tables_expr_parse(const struct nlattr *nla,
+static int nf_tables_expr_parse(const struct nft_ctx *ctx,
+				const struct nlattr *nla,
 				struct nft_expr_info *info)
 {
 	const struct nft_expr_type *type;
@@ -1051,7 +1052,8 @@ static int nf_tables_expr_parse(const struct nlattr *nla,
 		memset(info->tb, 0, sizeof(info->tb[0]) * (type->maxattr + 1));
 
 	if (type->select_ops != NULL) {
-		ops = type->select_ops((const struct nlattr * const *)info->tb);
+		ops = type->select_ops(ctx,
+				       (const struct nlattr * const *)info->tb);
 		if (IS_ERR(ops)) {
 			err = PTR_ERR(ops);
 			goto err1;
@@ -1385,6 +1387,8 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 		handle = nf_tables_alloc_handle(table);
 	}
 
+	nft_ctx_init(&ctx, skb, nlh, afi, table, chain);
+
 	n = 0;
 	size = 0;
 	if (nla[NFTA_RULE_EXPRESSIONS]) {
@@ -1394,7 +1398,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 				goto err1;
 			if (n == NFT_RULE_MAXEXPRS)
 				goto err1;
-			err = nf_tables_expr_parse(tmp, &info[n]);
+			err = nf_tables_expr_parse(&ctx, tmp, &info[n]);
 			if (err < 0)
 				goto err1;
 			size += info[n].ops->size;
@@ -1410,7 +1414,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	rule->handle = handle;
 	rule->dlen   = size;
 
-	nft_ctx_init(&ctx, skb, nlh, afi, table, chain);
 	expr = nft_expr_first(rule);
 	for (i = 0; i < n; i++) {
 		err = nf_tables_newexpr(&ctx, &info[i], expr);
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 37134f3..954925d 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -162,7 +162,8 @@ const struct nft_expr_ops nft_cmp_fast_ops = {
 	.dump		= nft_cmp_fast_dump,
 };
 
-static const struct nft_expr_ops *nft_cmp_select_ops(const struct nlattr * const tb[])
+static const struct nft_expr_ops *
+nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 {
 	struct nft_data_desc desc;
 	struct nft_data data;
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index b4a3ad3..91f827b 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -66,34 +66,27 @@ nft_compat_set_par(struct xt_action_param *par, const struct nft_pktinfo *pkt,
 	par->fragoff	= pkt->fragoff;
 }
 
-struct nft_target {
-	struct xt_target	*target;
-	__u32			family;
-	__u32			info_len;
-	void			*info;
-};
-
 static void nft_target_eval(const struct nft_expr *expr,
 			    struct nft_data data[NFT_REG_MAX + 1],
 			    const struct nft_pktinfo *pkt)
 {
-	const struct nft_target *priv = nft_expr_priv(expr);
+	void *info = nft_expr_priv(expr);
+	struct xt_target *target = expr->ops->data;
 	struct sk_buff *skb = pkt->skb;
 	struct xt_action_param par;
 	int ret;
 
 	if (!pkt->compat_set) {
 		if (nft_compat_set_pktinfo((struct nft_pktinfo *)pkt,
-					   priv->family) < 0) {
+					   target->family) < 0) {
 			data[NFT_REG_VERDICT].verdict = NF_DROP;
 			return;
 		}
 	}
 
-	nft_compat_set_par(&par, pkt, priv->target, priv->info,
-			   priv->family);
+	nft_compat_set_par(&par, pkt, target, info, target->family);
 
-	ret = priv->target->target(skb, &par);
+	ret = target->target(skb, &par);
 
 	if (par.hotdrop)
 		ret = NF_DROP;
@@ -117,13 +110,14 @@ static const struct nla_policy nft_target_policy[NFTA_TARGET_MAX + 1] = {
 
 static void
 nft_target_set_tgchk_param(struct xt_tgchk_param *par,
-			   const struct nft_ctx *ctx, struct nft_target *priv)
+			   const struct nft_ctx *ctx,
+			   struct xt_target *target, void *info)
 {
 	par->net	= &init_net;
 	par->table	= ctx->table->name;
 	par->entryinfo	= NULL;	/* FIXME */
-	par->target	= priv->target;
-	par->targinfo	= priv->info;
+	par->target	= target;
+	par->targinfo	= info;
 	par->hook_mask	= 0; /* FIXME */
 	par->family	= ctx->afi->family;
 }
@@ -132,71 +126,50 @@ static int
 nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		const struct nlattr * const tb[])
 {
-	struct nft_target *priv = nft_expr_priv(expr);
+	void *info = nft_expr_priv(expr);
+	struct xt_target *target = expr->ops->data;
 	struct xt_tgchk_param par;
-	const char *tg_name;
-	__u32 rev;
+	size_t size = XT_ALIGN(nla_len(tb[NFTA_TARGET_INFO]));
 	int ret;
 
-	if (tb[NFTA_TARGET_NAME] == NULL ||
-	    tb[NFTA_TARGET_REV] == NULL ||
-	    tb[NFTA_TARGET_INFO] == NULL)
-		return -EINVAL;
-
-	tg_name = nla_data(tb[NFTA_TARGET_NAME]);
-	rev = ntohl(nla_get_be32(tb[NFTA_TARGET_REV]));
-	priv->family = ctx->afi->family;
-
-	priv->target = xt_request_find_target(priv->family, tg_name, rev);
-	if (IS_ERR(priv->target))
-		return PTR_ERR(priv->target);
-
-	priv->info_len = nla_len(tb[NFTA_TARGET_INFO]);
-	if (priv->info_len == 0)
-		return -EINVAL;
-
-	priv->info = kzalloc(priv->info_len, GFP_ATOMIC);
-	if (priv->info == NULL)
-		return -ENOMEM;
+	memcpy(info, nla_data(tb[NFTA_TARGET_INFO]),
+	       XT_ALIGN(target->targetsize));
 
-	memcpy(priv->info, nla_data(tb[NFTA_TARGET_INFO]), priv->info_len);
-
-	nft_target_set_tgchk_param(&par, ctx, priv);
+	nft_target_set_tgchk_param(&par, ctx, target, info);
 
 	/* FIXME: not checking protocol and inversion */
-	ret = xt_check_target(&par, priv->info_len, 0, false);
+	ret = xt_check_target(&par, size, 0, false);
 	if (ret < 0)
 		goto err;
 
 	/* The standard target cannot be used */
-	if (priv->target->target == NULL) {
+	if (target->target == NULL) {
 		ret = -EINVAL;
 		goto err;
 	}
 
 	return 0;
 err:
-	kfree(priv->info);
-	module_put(priv->target->me);
+	module_put(target->me);
 	return ret;
 }
 
 static void
 nft_target_destroy(const struct nft_expr *expr)
 {
-	struct nft_target *priv = nft_expr_priv(expr);
+	struct xt_target *target = expr->ops->data;
 
-	module_put(priv->target->me);
-	kfree(priv->info);
+	module_put(target->me);
 }
 
 static int nft_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
-	const struct nft_target *priv = nft_expr_priv(expr);
+	const struct xt_target *target = expr->ops->data;
+	void *info = nft_expr_priv(expr);
 
-	if (nla_put_string(skb, NFTA_TARGET_NAME, priv->target->name) ||
-	    nla_put_be32(skb, NFTA_TARGET_REV, htonl(priv->target->revision)) ||
-	    nla_put(skb, NFTA_TARGET_INFO, priv->info_len, priv->info))
+	if (nla_put_string(skb, NFTA_TARGET_NAME, target->name) ||
+	    nla_put_be32(skb, NFTA_TARGET_REV, htonl(target->revision)) ||
+	    nla_put(skb, NFTA_TARGET_INFO, XT_ALIGN(target->targetsize), info))
 		goto nla_put_failure;
 
 	return 0;
@@ -205,34 +178,27 @@ nla_put_failure:
 	return -1;
 }
 
-struct nft_match {
-	struct xt_match		*match;
-	__u32			family;
-	__u32			info_len;
-	void			*info;
-};
-
 static void nft_match_eval(const struct nft_expr *expr,
 			   struct nft_data data[NFT_REG_MAX + 1],
 			   const struct nft_pktinfo *pkt)
 {
-	const struct nft_match *priv = nft_expr_priv(expr);
+	void *info = nft_expr_priv(expr);
+	struct xt_match *match = expr->ops->data;
 	struct sk_buff *skb = pkt->skb;
 	struct xt_action_param par;
 	bool ret;
 
 	if (!pkt->compat_set) {
 		if (nft_compat_set_pktinfo((struct nft_pktinfo *)pkt,
-					   priv->family) < 0) {
+					   match->family) < 0) {
 			data[NFT_REG_VERDICT].verdict = NF_DROP;
 			return;
 		}
 	}
 
-	nft_compat_set_par(&par, pkt, priv->match, priv->info,
-			   priv->family);
+	nft_compat_set_par(&par, pkt, match, info, match->family);
 
-	ret = priv->match->match(skb, &par);
+	ret = match->match(skb, &par);
 
 	if (par.hotdrop) {
 		data[NFT_REG_VERDICT].verdict = NF_DROP;
@@ -257,14 +223,14 @@ static const struct nla_policy nft_match_policy[NFTA_MATCH_MAX + 1] = {
 
 /* struct xt_mtchk_param and xt_tgchk_param look very similar */
 static void
-nft_match_set_mtchk_param(struct xt_mtchk_param *par,
-			   const struct nft_ctx *ctx, struct nft_match *priv)
+nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
+			  struct xt_match *match, void *info)
 {
 	par->net	= &init_net;
 	par->table	= ctx->table->name;
 	par->entryinfo	= NULL;	/* FIXME */
-	par->match	= priv->match;
-	par->matchinfo	= priv->info;
+	par->match	= match;
+	par->matchinfo	= info;
 	par->hook_mask	= 0; /* FIXME */
 	par->family	= ctx->afi->family;
 }
@@ -273,65 +239,43 @@ static int
 nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		const struct nlattr * const tb[])
 {
-	struct nft_match *priv = nft_expr_priv(expr);
+	void *info = nft_expr_priv(expr);
+	struct xt_match *match = expr->ops->data;
 	struct xt_mtchk_param par;
-	const char *mt_name;
-	__u32 rev;
+	size_t size = XT_ALIGN(nla_len(tb[NFTA_MATCH_INFO]));
 	int ret;
 
-	if (tb[NFTA_MATCH_NAME] == NULL ||
-	    tb[NFTA_MATCH_REV] == NULL ||
-	    tb[NFTA_MATCH_INFO] == NULL)
-		return -EINVAL;
-
-	mt_name = nla_data(tb[NFTA_MATCH_NAME]);
-	rev = ntohl(nla_get_be32(tb[NFTA_MATCH_REV]));
-	priv->family = ctx->afi->family;
-
-	priv->match = xt_request_find_match(priv->family, mt_name, rev);
-	if (IS_ERR(priv->match))
-		return PTR_ERR(priv->match);
-
-	priv->info_len = nla_len(tb[NFTA_MATCH_INFO]);
-	if (priv->info_len == 0)
-		return -EINVAL;
-
-	priv->info = kzalloc(priv->info_len, GFP_ATOMIC);
-	if (priv->info == NULL)
-		return -ENOMEM;
-
-	memcpy(priv->info, nla_data(tb[NFTA_MATCH_INFO]), priv->info_len);
+	memcpy(info, nla_data(tb[NFTA_MATCH_INFO]), XT_ALIGN(match->matchsize));
 
-	nft_match_set_mtchk_param(&par, ctx, priv);
+	nft_match_set_mtchk_param(&par, ctx, match, info);
 
 	/* FIXME: not checking protocol and inversion, do this in userspace */
-	ret = xt_check_match(&par, priv->info_len, 0, false);
+	ret = xt_check_match(&par, size, 0, false);
 	if (ret < 0)
 		goto err;
 
 	return 0;
 err:
-	kfree(priv->info);
-	module_put(priv->match->me);
+	module_put(match->me);
 	return ret;
 }
 
 static void
 nft_match_destroy(const struct nft_expr *expr)
 {
-	struct nft_match *priv = nft_expr_priv(expr);
+	struct xt_match *match = expr->ops->data;
 
-	module_put(priv->match->me);
-	kfree(priv->info);
+	module_put(match->me);
 }
 
 static int nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
-	const struct nft_match *priv = nft_expr_priv(expr);
+	void *info = nft_expr_priv(expr);
+	struct xt_match *match = expr->ops->data;
 
-	if (nla_put_string(skb, NFTA_MATCH_NAME, priv->match->name) ||
-	    nla_put_be32(skb, NFTA_MATCH_REV, htonl(priv->match->revision)) ||
-	    nla_put(skb, NFTA_MATCH_INFO, priv->info_len, priv->info))
+	if (nla_put_string(skb, NFTA_MATCH_NAME, match->name) ||
+	    nla_put_be32(skb, NFTA_MATCH_REV, htonl(match->revision)) ||
+	    nla_put(skb, NFTA_MATCH_INFO, XT_ALIGN(match->matchsize), info))
 		goto nla_put_failure;
 
 	return 0;
@@ -458,37 +402,128 @@ static const struct nfnetlink_subsystem nfnl_compat_subsys = {
 	.cb		= nfnl_nft_compat_cb,
 };
 
-static struct nft_expr_type nft_match_type;
-static const struct nft_expr_ops nft_match_ops = {
-	.type		= &nft_match_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_match)),
-	.eval		= nft_match_eval,
-	.init		= nft_match_init,
-	.destroy	= nft_match_destroy,
-	.dump		= nft_match_dump,
+static LIST_HEAD(nft_match_list);
+
+struct nft_xt {
+	struct list_head	head;
+	struct nft_expr_ops	ops;
 };
 
+static struct nft_expr_type nft_match_type;
+
+static const struct nft_expr_ops *
+nft_match_select_ops(const struct nft_ctx *ctx,
+		     const struct nlattr * const tb[])
+{
+	struct nft_xt *nft_match;
+	struct xt_match *match;
+	char *mt_name;
+	__u32 rev, family;
+
+	if (tb[NFTA_MATCH_NAME] == NULL ||
+	    tb[NFTA_MATCH_REV] == NULL ||
+	    tb[NFTA_MATCH_INFO] == NULL)
+		return ERR_PTR(-EINVAL);
+
+	mt_name = nla_data(tb[NFTA_MATCH_NAME]);
+	rev = ntohl(nla_get_be32(tb[NFTA_MATCH_REV]));
+	family = ctx->afi->family;
+
+	/* Re-use the existing match if it's already loaded. */
+	list_for_each_entry(nft_match, &nft_match_list, head) {
+		struct xt_match *match = nft_match->ops.data;
+
+		if (strcmp(match->name, mt_name) == 0 &&
+		    match->revision == rev && match->family == family)
+			return &nft_match->ops;
+	}
+
+	match = xt_request_find_match(family, mt_name, rev);
+	if (IS_ERR(match))
+		return ERR_PTR(-ENOENT);
+
+	/* This is the first time we use this match, allocate operations */
+	nft_match = kzalloc(sizeof(struct nft_xt), GFP_KERNEL);
+	if (nft_match == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	nft_match->ops.type = &nft_match_type;
+	nft_match->ops.size = NFT_EXPR_SIZE(XT_ALIGN(match->matchsize));
+	nft_match->ops.eval = nft_match_eval;
+	nft_match->ops.init = nft_match_init;
+	nft_match->ops.destroy = nft_match_destroy;
+	nft_match->ops.dump = nft_match_dump;
+	nft_match->ops.data = match;
+
+	list_add(&nft_match->head, &nft_match_list);
+
+	return &nft_match->ops;
+}
+
 static struct nft_expr_type nft_match_type __read_mostly = {
 	.name		= "match",
-	.ops		= &nft_match_ops,
+	.select_ops	= nft_match_select_ops,
 	.policy		= nft_match_policy,
 	.maxattr	= NFTA_MATCH_MAX,
 	.owner		= THIS_MODULE,
 };
 
+static LIST_HEAD(nft_target_list);
+
 static struct nft_expr_type nft_target_type;
-static const struct nft_expr_ops nft_target_ops = {
-	.type		= &nft_target_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_target)),
-	.eval		= nft_target_eval,
-	.init		= nft_target_init,
-	.destroy	= nft_target_destroy,
-	.dump		= nft_target_dump,
-};
+
+static const struct nft_expr_ops *
+nft_target_select_ops(const struct nft_ctx *ctx,
+		      const struct nlattr * const tb[])
+{
+	struct nft_xt *nft_target;
+	struct xt_target *target;
+	char *tg_name;
+	__u32 rev, family;
+
+	if (tb[NFTA_TARGET_NAME] == NULL ||
+	    tb[NFTA_TARGET_REV] == NULL ||
+	    tb[NFTA_TARGET_INFO] == NULL)
+		return ERR_PTR(-EINVAL);
+
+	tg_name = nla_data(tb[NFTA_TARGET_NAME]);
+	rev = ntohl(nla_get_be32(tb[NFTA_TARGET_REV]));
+	family = ctx->afi->family;
+
+	/* Re-use the existing target if it's already loaded. */
+	list_for_each_entry(nft_target, &nft_match_list, head) {
+		struct xt_target *target = nft_target->ops.data;
+
+		if (strcmp(target->name, tg_name) == 0 &&
+		    target->revision == rev && target->family == family)
+			return &nft_target->ops;
+	}
+
+	target = xt_request_find_target(family, tg_name, rev);
+	if (IS_ERR(target))
+		return ERR_PTR(-ENOENT);
+
+	/* This is the first time we use this target, allocate operations */
+	nft_target = kzalloc(sizeof(struct nft_xt), GFP_KERNEL);
+	if (nft_target == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	nft_target->ops.type = &nft_target_type;
+	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
+	nft_target->ops.eval = nft_target_eval;
+	nft_target->ops.init = nft_target_init;
+	nft_target->ops.destroy = nft_target_destroy;
+	nft_target->ops.dump = nft_target_dump;
+	nft_target->ops.data = target;
+
+	list_add(&nft_target->head, &nft_target_list);
+
+	return &nft_target->ops;
+}
 
 static struct nft_expr_type nft_target_type __read_mostly = {
 	.name		= "target",
-	.ops		= &nft_target_ops,
+	.select_ops	= nft_target_select_ops,
 	.policy		= nft_target_policy,
 	.maxattr	= NFTA_TARGET_MAX,
 	.owner		= THIS_MODULE,
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 6c81078..028e4d8 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -107,7 +107,8 @@ const struct nft_expr_ops nft_payload_fast_ops = {
 };
 
 static const struct nft_expr_ops *
-nft_payload_select_ops(const struct nlattr * const tb[])
+nft_payload_select_ops(const struct nft_ctx *ctx,
+		       const struct nlattr * const tb[])
 {
 	enum nft_payload_bases base;
 	unsigned int offset, len;
-- 
1.7.10.4

