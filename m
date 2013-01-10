From: pablo@netfilter.org
Subject: [PATCH 6/7] netfilter: nf_tables: support 32bits-64bits x_tables compat
Date: Thu, 10 Jan 2013 16:28:40 +0100
Message-ID: <1357831721-10182-6-git-send-email-pablo@netfilter.org>
References: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37157 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab3AJP3B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:29:01 -0500
In-Reply-To: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds support for existing compat infrastructure in
matches/targets.

This adds a new callback compat_to_blob that uses memcpy
instead of copy_to_user.

The standard target has no compat_to_blob since user-space
is using the native immediate expression to issue verdicts.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h |    2 +
 net/ipv4/netfilter/ipt_ULOG.c      |   14 ++++++
 net/netfilter/nft_compat.c         |   83 ++++++++++++++++++++++++++++++++----
 net/netfilter/xt_limit.c           |   16 +++++++
 4 files changed, 107 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 8d674a7..f2cc078 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -307,6 +307,7 @@ struct xt_match {
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, const void *src);
 	int (*compat_to_user)(void __user *dst, const void *src);
+	void (*compat_to_blob)(void *dst, const void *src);
 #endif
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -347,6 +348,7 @@ struct xt_target {
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, const void *src);
 	int (*compat_to_user)(void __user *dst, const void *src);
+	void (*compat_to_blob)(void *dst, const void *src);
 #endif
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index b5ef3cb..6941581 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -356,6 +356,19 @@ static int ulog_tg_compat_to_user(void __user *dst, const void *src)
 	memcpy(cl.prefix, l->prefix, sizeof(cl.prefix));
 	return copy_to_user(dst, &cl, sizeof(cl)) ? -EFAULT : 0;
 }
+
+static void ulog_tg_compat_to_blob(void *dst, const void *src)
+{
+	const struct ipt_ulog_info *l = src;
+	struct compat_ipt_ulog_info cl = {
+		.nl_group	= l->nl_group,
+		.copy_range	= l->copy_range,
+		.qthreshold	= l->qthreshold,
+	};
+
+	memcpy(cl.prefix, l->prefix, sizeof(cl.prefix));
+	memcpy(dst, &cl, sizeof(cl));
+}
 #endif /* CONFIG_COMPAT */
 
 static struct xt_target ulog_tg_reg __read_mostly = {
@@ -368,6 +381,7 @@ static struct xt_target ulog_tg_reg __read_mostly = {
 	.compatsize	= sizeof(struct compat_ipt_ulog_info),
 	.compat_from_user = ulog_tg_compat_from_user,
 	.compat_to_user	= ulog_tg_compat_to_user,
+	.compat_to_blob	= ulog_tg_compat_to_blob,
 #endif
 	.me		= THIS_MODULE,
 };
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 9f84e23..3cd6fd6 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -1,5 +1,5 @@
 /*
- * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -82,6 +82,19 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 	par->family	= ctx->afi->family;
 }
 
+static void target_compat_from_user(struct xt_target *t, void *in, void *out)
+{
+	int pad;
+
+	if (t->compat_from_user) {
+		t->compat_from_user(out, in);
+		pad = XT_ALIGN(t->targetsize) - t->targetsize;
+		if (pad > 0)
+			memset(out + t->targetsize, 0, pad);
+	} else
+		memcpy(out, in, XT_ALIGN(t->targetsize));
+}
+
 static int
 nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		const struct nlattr * const tb[])
@@ -92,8 +105,7 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	size_t size = XT_ALIGN(nla_len(tb[NFTA_TARGET_INFO]));
 	int ret;
 
-	memcpy(info, nla_data(tb[NFTA_TARGET_INFO]),
-	       XT_ALIGN(target->targetsize));
+	target_compat_from_user(target, nla_data(tb[NFTA_TARGET_INFO]), info);
 
 	nft_target_set_tgchk_param(&par, ctx, target, info);
 
@@ -122,6 +134,26 @@ nft_target_destroy(const struct nft_expr *expr)
 	module_put(target->me);
 }
 
+static int
+target_dump_info(struct sk_buff *skb, const struct xt_target *t, const void *in)
+{
+	void *out;
+	int ret;
+
+	if (t->compat_to_blob) {
+		out = kmalloc(XT_ALIGN(t->targetsize), GFP_ATOMIC);
+		if (out == NULL)
+			return -ENOMEM;
+
+		t->compat_to_blob(out, in);
+		ret = nla_put(skb, NFTA_TARGET_INFO, XT_ALIGN(t->targetsize), out);
+		kfree(out);
+	} else
+		ret = nla_put(skb, NFTA_TARGET_INFO, XT_ALIGN(t->targetsize), in);
+
+	return ret;
+}
+
 static int nft_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct xt_target *target = expr->ops->data;
@@ -129,7 +161,7 @@ static int nft_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 	if (nla_put_string(skb, NFTA_TARGET_NAME, target->name) ||
 	    nla_put_be32(skb, NFTA_TARGET_REV, htonl(target->revision)) ||
-	    nla_put(skb, NFTA_TARGET_INFO, XT_ALIGN(target->targetsize), info))
+	    target_dump_info(skb, target, info))
 		goto nla_put_failure;
 
 	return 0;
@@ -214,6 +246,19 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 	par->family	= ctx->afi->family;
 }
 
+static void match_compat_from_user(struct xt_match *m, void *in, void *out)
+{
+	int pad;
+
+	if (m->compat_from_user) {
+		m->compat_from_user(out, in);
+		pad = XT_ALIGN(m->matchsize) - m->matchsize;
+		if (pad > 0)
+			memset(out + m->matchsize, 0, pad);
+	} else
+		memcpy(out, in, XT_ALIGN(m->matchsize));
+}
+
 static int
 nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		const struct nlattr * const tb[])
@@ -224,7 +269,7 @@ nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	size_t size = XT_ALIGN(nla_len(tb[NFTA_MATCH_INFO]));
 	int ret;
 
-	memcpy(info, nla_data(tb[NFTA_MATCH_INFO]), XT_ALIGN(match->matchsize));
+	match_compat_from_user(match, nla_data(tb[NFTA_MATCH_INFO]), info);
 
 	nft_match_set_mtchk_param(&par, ctx, match, info);
 
@@ -247,6 +292,26 @@ nft_match_destroy(const struct nft_expr *expr)
 	module_put(match->me);
 }
 
+static int
+match_dump_info(struct sk_buff *skb, const struct xt_match *m, const void *in)
+{
+	void *out;
+	int ret;
+
+	if (m->compat_to_blob) {
+		out = kmalloc(XT_ALIGN(m->matchsize), GFP_ATOMIC);
+		if (out == NULL)
+			return -ENOMEM;
+
+		m->compat_to_blob(out, in);
+		ret = nla_put(skb, NFTA_MATCH_INFO, XT_ALIGN(m->matchsize), out);
+		kfree(out);
+	} else
+		ret = nla_put(skb, NFTA_MATCH_INFO, XT_ALIGN(m->matchsize), in);
+
+	return ret;
+}
+
 static int nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	void *info = nft_expr_priv(expr);
@@ -254,7 +319,7 @@ static int nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 	if (nla_put_string(skb, NFTA_MATCH_NAME, match->name) ||
 	    nla_put_be32(skb, NFTA_MATCH_REV, htonl(match->revision)) ||
-	    nla_put(skb, NFTA_MATCH_INFO, XT_ALIGN(match->matchsize), info))
+	    match_dump_info(skb, match, info))
 		goto nla_put_failure;
 
 	return 0;
@@ -449,7 +514,8 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	nft_match->ops.type = &nft_match_type;
-	nft_match->ops.size = NFT_EXPR_SIZE(XT_ALIGN(match->matchsize));
+	nft_match->ops.size = NFT_EXPR_SIZE(XT_ALIGN(match->matchsize) +
+					    xt_compat_match_offset(match));
 	nft_match->ops.eval = nft_match_eval;
 	nft_match->ops.init = nft_match_init;
 	nft_match->ops.destroy = nft_match_destroy;
@@ -519,7 +585,8 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	nft_target->ops.type = &nft_target_type;
-	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
+	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize) +
+					     xt_compat_target_offset(target));
 	nft_target->ops.eval = nft_target_eval;
 	nft_target->ops.init = nft_target_init;
 	nft_target->ops.destroy = nft_target_destroy;
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 5c22ce8..4a19bd4 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -177,6 +177,21 @@ static int limit_mt_compat_to_user(void __user *dst, const void *src)
 	};
 	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
 }
+
+static void limit_mt_compat_to_blob(void *dst, const void *src)
+{
+	const struct xt_rateinfo *m = src;
+	struct compat_xt_rateinfo cm = {
+		.avg		= m->avg,
+		.burst		= m->burst,
+		.prev		= m->prev,
+		.credit		= m->credit,
+		.credit_cap	= m->credit_cap,
+		.cost		= m->cost,
+		.master		= m->prev >> 32,
+	};
+	memcpy(dst, &cm, sizeof(cm));
+}
 #endif /* CONFIG_COMPAT */
 
 static struct xt_match limit_mt_reg __read_mostly = {
@@ -191,6 +206,7 @@ static struct xt_match limit_mt_reg __read_mostly = {
 	.compatsize       = sizeof(struct compat_xt_rateinfo),
 	.compat_from_user = limit_mt_compat_from_user,
 	.compat_to_user   = limit_mt_compat_to_user,
+	.compat_to_blob   = limit_mt_compat_to_blob,
 #endif
 	.me               = THIS_MODULE,
 };
-- 
1.7.10.4

