Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21BF56B70
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2024 12:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715172769; cv=none; b=uh2Brh+rckxF7/E4hZVVdiOsn3Ck1Gm5/tlhCu6oD/Zd8oNmJRmxYGDYDDyFOVlY4tWIPoee2d8blNM7GyUQfPrqHwq2OoECOyKhu9WrHBuqfTeZisKKPNEmGTb/SZf3Z+BPxp14oeeG3FIM83FEbhipUbPbUj9t3qHX/6OXAXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715172769; c=relaxed/simple;
	bh=8haH6aEm4xVJV69oRnZ9hfZYh8xbaoEzQay4eCoJx5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULxlCe676Vz/qNJm+CY8CeTmUnSzkcNTyKFI9UiSnBaL4pxmqrXv4R7TjQx++VtCfI6MfQUEVWEMwUkpHPQKx7Ko/gyaVye+e6SDp/qzSVJFovJ+yx9i8DN97yVHFv6tmE8Nb+UvGldUl4+FpWeVclXPxJrYQkW0d5LSQAe52cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s4gmq-0004aT-Au; Wed, 08 May 2024 14:52:44 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH nf-next] netfilter: nf_tables: allow clone callbacks to sleep
Date: Wed,  8 May 2024 14:52:47 +0200
Message-ID: <20240508125303.22130-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sven Auhagen reports transaction failures with following error:
  ./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
  percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left

This points to failing pcpu allocation with GFP_ATOMIC flag.
However, transactions happen from user context and are allowed to sleep.

One case where we can call into percpu allocator with GFP_ATOMIC is
nft_counter expression.

Normally this happens from control plane, so this could use GFP_KERNEL
instead.  But one use case, element insertion from packet path,
needs to use GFP_ATOMIC allocations (nft_dynset expression).

At this time, .clone callbacks always use GFP_ATOMIC for this reason.

Add gfp_t argument to the .clone function and pass GFP_KERNEL or
GFP_ATOMIC flag depending on context, this allows all clone memory
allocations to sleep for the normal (transaction) case.

Cc: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  4 ++--
 net/netfilter/nf_tables_api.c     |  8 ++++----
 net/netfilter/nft_connlimit.c     |  4 ++--
 net/netfilter/nft_counter.c       |  4 ++--
 net/netfilter/nft_dynset.c        |  2 +-
 net/netfilter/nft_last.c          |  4 ++--
 net/netfilter/nft_limit.c         | 14 ++++++++------
 net/netfilter/nft_quota.c         |  4 ++--
 8 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3f1ed467f951..2796153b03da 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -416,7 +416,7 @@ struct nft_expr_info;
 
 int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
 			 struct nft_expr_info *info);
-int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src, gfp_t gfp);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr, bool reset);
@@ -935,7 +935,7 @@ struct nft_expr_ops {
 						struct nft_regs *regs,
 						const struct nft_pktinfo *pkt);
 	int				(*clone)(struct nft_expr *dst,
-						 const struct nft_expr *src);
+						 const struct nft_expr *src, gfp_t gfp);
 	unsigned int			size;
 
 	int				(*init)(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 167074283ea9..c0a4813c80c9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3333,7 +3333,7 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 	return ERR_PTR(err);
 }
 
-int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src, gfp_t gfp)
 {
 	int err;
 
@@ -3341,7 +3341,7 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
 		return -EINVAL;
 
 	dst->ops = src->ops;
-	err = src->ops->clone(dst, src);
+	err = src->ops->clone(dst, src, gfp);
 	if (err < 0)
 		return err;
 
@@ -6525,7 +6525,7 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 		if (!expr)
 			goto err_expr;
 
-		err = nft_expr_clone(expr, set->exprs[i]);
+		err = nft_expr_clone(expr, set->exprs[i], GFP_KERNEL_ACCOUNT);
 		if (err < 0) {
 			kfree(expr);
 			goto err_expr;
@@ -6564,7 +6564,7 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 
 	for (i = 0; i < num_exprs; i++) {
 		expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
-		err = nft_expr_clone(expr, expr_array[i]);
+		err = nft_expr_clone(expr, expr_array[i], GFP_KERNEL_ACCOUNT);
 		if (err < 0)
 			goto err_elem_expr_setup;
 
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index de9d1980df69..92b984fa8175 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -210,12 +210,12 @@ static void nft_connlimit_destroy(const struct nft_ctx *ctx,
 	nft_connlimit_do_destroy(ctx, priv);
 }
 
-static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src, gfp_t gfp)
 {
 	struct nft_connlimit *priv_dst = nft_expr_priv(dst);
 	struct nft_connlimit *priv_src = nft_expr_priv(src);
 
-	priv_dst->list = kmalloc(sizeof(*priv_dst->list), GFP_ATOMIC);
+	priv_dst->list = kmalloc(sizeof(*priv_dst->list), gfp);
 	if (!priv_dst->list)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index dccc68a5135a..291ed2026367 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -226,7 +226,7 @@ static void nft_counter_destroy(const struct nft_ctx *ctx,
 	nft_counter_do_destroy(priv);
 }
 
-static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src, gfp_t gfp)
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(src);
 	struct nft_counter_percpu_priv *priv_clone = nft_expr_priv(dst);
@@ -236,7 +236,7 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
 
 	nft_counter_fetch(priv, &total);
 
-	cpu_stats = alloc_percpu_gfp(struct nft_counter, GFP_ATOMIC);
+	cpu_stats = alloc_percpu_gfp(struct nft_counter, gfp);
 	if (cpu_stats == NULL)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index c09dba57354c..b4ada3ab2167 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -35,7 +35,7 @@ static int nft_dynset_expr_setup(const struct nft_dynset *priv,
 
 	for (i = 0; i < priv->num_exprs; i++) {
 		expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
-		if (nft_expr_clone(expr, priv->expr_array[i]) < 0)
+		if (nft_expr_clone(expr, priv->expr_array[i], GFP_ATOMIC) < 0)
 			return -1;
 
 		elem_expr->size += priv->expr_array[i]->ops->size;
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 8e6d7eaf9dc8..de1b6066bfa8 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -102,12 +102,12 @@ static void nft_last_destroy(const struct nft_ctx *ctx,
 	kfree(priv->last);
 }
 
-static int nft_last_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_last_clone(struct nft_expr *dst, const struct nft_expr *src, gfp_t gfp)
 {
 	struct nft_last_priv *priv_dst = nft_expr_priv(dst);
 	struct nft_last_priv *priv_src = nft_expr_priv(src);
 
-	priv_dst->last = kzalloc(sizeof(*priv_dst->last), GFP_ATOMIC);
+	priv_dst->last = kzalloc(sizeof(*priv_dst->last), gfp);
 	if (!priv_dst->last)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index cefa25e0dbb0..21d26b79b460 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -150,7 +150,7 @@ static void nft_limit_destroy(const struct nft_ctx *ctx,
 }
 
 static int nft_limit_clone(struct nft_limit_priv *priv_dst,
-			   const struct nft_limit_priv *priv_src)
+			   const struct nft_limit_priv *priv_src, gfp_t gfp)
 {
 	priv_dst->tokens_max = priv_src->tokens_max;
 	priv_dst->rate = priv_src->rate;
@@ -158,7 +158,7 @@ static int nft_limit_clone(struct nft_limit_priv *priv_dst,
 	priv_dst->burst = priv_src->burst;
 	priv_dst->invert = priv_src->invert;
 
-	priv_dst->limit = kmalloc(sizeof(*priv_dst->limit), GFP_ATOMIC);
+	priv_dst->limit = kmalloc(sizeof(*priv_dst->limit), gfp);
 	if (!priv_dst->limit)
 		return -ENOMEM;
 
@@ -223,14 +223,15 @@ static void nft_limit_pkts_destroy(const struct nft_ctx *ctx,
 	nft_limit_destroy(ctx, &priv->limit);
 }
 
-static int nft_limit_pkts_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_limit_pkts_clone(struct nft_expr *dst, const struct nft_expr *src,
+				gfp_t gfp)
 {
 	struct nft_limit_priv_pkts *priv_dst = nft_expr_priv(dst);
 	struct nft_limit_priv_pkts *priv_src = nft_expr_priv(src);
 
 	priv_dst->cost = priv_src->cost;
 
-	return nft_limit_clone(&priv_dst->limit, &priv_src->limit);
+	return nft_limit_clone(&priv_dst->limit, &priv_src->limit, gfp);
 }
 
 static struct nft_expr_type nft_limit_type;
@@ -281,12 +282,13 @@ static void nft_limit_bytes_destroy(const struct nft_ctx *ctx,
 	nft_limit_destroy(ctx, priv);
 }
 
-static int nft_limit_bytes_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_limit_bytes_clone(struct nft_expr *dst, const struct nft_expr *src,
+				 gfp_t gfp)
 {
 	struct nft_limit_priv *priv_dst = nft_expr_priv(dst);
 	struct nft_limit_priv *priv_src = nft_expr_priv(src);
 
-	return nft_limit_clone(priv_dst, priv_src);
+	return nft_limit_clone(priv_dst, priv_src, gfp);
 }
 
 static const struct nft_expr_ops nft_limit_bytes_ops = {
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 3ba12a7471b0..9b2d7463d3d3 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -233,7 +233,7 @@ static void nft_quota_destroy(const struct nft_ctx *ctx,
 	return nft_quota_do_destroy(ctx, priv);
 }
 
-static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src, gfp_t gfp)
 {
 	struct nft_quota *priv_dst = nft_expr_priv(dst);
 	struct nft_quota *priv_src = nft_expr_priv(src);
@@ -241,7 +241,7 @@ static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
 	priv_dst->quota = priv_src->quota;
 	priv_dst->flags = priv_src->flags;
 
-	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), GFP_ATOMIC);
+	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), gfp);
 	if (!priv_dst->consumed)
 		return -ENOMEM;
 
-- 
2.43.2

