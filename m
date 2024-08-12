Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C0516EB60;
	Mon, 12 Aug 2024 10:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458213; cv=none; b=dBOHdtJYEbiEzTxWxUZWIUh+4zKdodTHzqNQDtfd7rKJ65SlOkLqzoTuAz+qmYYF2WMLCaZBxxxUKXLTf62MXr4VPr97z+37oVaELf1BMshfHOYwUp/gVQjj3cVW+n49FQZajvFPPn+umokxjpYNVLPcaeegQa9mSiFP3kBkPT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458213; c=relaxed/simple;
	bh=G56i3TXX2jgchcS/W51ligIXRHo1rsqhuDD+HGHW15E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VrAaPZA06sPojnOxh7GksD7bpTkIA3XjZCeBgF0185dBgBBQR+mZgy3LUZf8ruSqhNduqKvEoHH9C+trzIms9Z7pF8vS7pb4Sx/Vokht2tn6AzASdM6OtQi8zOg+iQi1ZssBH8X19b1AdAwZA8JwLBD+6o8aqyfzeyHJTjndqNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.1.x 2/3] netfilter: nf_tables: allow clone callbacks to sleep
Date: Mon, 12 Aug 2024 12:23:19 +0200
Message-Id: <20240812102320.359247-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240812102320.359247-1-pablo@netfilter.org>
References: <20240812102320.359247-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

commit fa23e0d4b756d25829e124d6b670a4c6bbd4bf7e upstream.

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index 9a80d0251d8f..e365302fed95 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -387,7 +387,7 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
 	return (void *)expr->data;
 }
 
-int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src, gfp_t gfp);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr);
@@ -889,7 +889,7 @@ struct nft_expr_ops {
 						struct nft_regs *regs,
 						const struct nft_pktinfo *pkt);
 	int				(*clone)(struct nft_expr *dst,
-						 const struct nft_expr *src);
+						 const struct nft_expr *src, gfp_t gfp);
 	unsigned int			size;
 
 	int				(*init)(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 85d7250a29a2..8f8470ba6c37 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3119,7 +3119,7 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 	return ERR_PTR(err);
 }
 
-int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src, gfp_t gfp)
 {
 	int err;
 
@@ -3127,7 +3127,7 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
 		return -EINVAL;
 
 	dst->ops = src->ops;
-	err = src->ops->clone(dst, src);
+	err = src->ops->clone(dst, src, gfp);
 	if (err < 0)
 		return err;
 
@@ -6059,7 +6059,7 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 		if (!expr)
 			goto err_expr;
 
-		err = nft_expr_clone(expr, set->exprs[i]);
+		err = nft_expr_clone(expr, set->exprs[i], GFP_KERNEL_ACCOUNT);
 		if (err < 0) {
 			kfree(expr);
 			goto err_expr;
@@ -6098,7 +6098,7 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 
 	for (i = 0; i < num_exprs; i++) {
 		expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
-		err = nft_expr_clone(expr, expr_array[i]);
+		err = nft_expr_clone(expr, expr_array[i], GFP_KERNEL_ACCOUNT);
 		if (err < 0)
 			goto err_elem_expr_setup;
 
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index d657f999a11b..793994622b87 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -209,12 +209,12 @@ static void nft_connlimit_destroy(const struct nft_ctx *ctx,
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
index f4d3573e8782..b5fe7fe4b60d 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -225,7 +225,7 @@ static void nft_counter_destroy(const struct nft_ctx *ctx,
 	nft_counter_do_destroy(priv);
 }
 
-static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src, gfp_t gfp)
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(src);
 	struct nft_counter_percpu_priv *priv_clone = nft_expr_priv(dst);
@@ -235,7 +235,7 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
 
 	nft_counter_fetch(priv, &total);
 
-	cpu_stats = alloc_percpu_gfp(struct nft_counter, GFP_ATOMIC);
+	cpu_stats = alloc_percpu_gfp(struct nft_counter, gfp);
 	if (cpu_stats == NULL)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index a470e5f61284..953aba871f45 100644
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
index eaa54964cf23..2ff387b649cf 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -101,12 +101,12 @@ static void nft_last_destroy(const struct nft_ctx *ctx,
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
index 36ded7d43262..a263596da99a 100644
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
 
@@ -222,14 +222,15 @@ static void nft_limit_pkts_destroy(const struct nft_ctx *ctx,
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
@@ -280,12 +281,13 @@ static void nft_limit_bytes_destroy(const struct nft_ctx *ctx,
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
index 410a5fcf8830..ef8e7cdbd0e6 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -232,7 +232,7 @@ static void nft_quota_destroy(const struct nft_ctx *ctx,
 	return nft_quota_do_destroy(ctx, priv);
 }
 
-static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src, gfp_t gfp)
 {
 	struct nft_quota *priv_dst = nft_expr_priv(dst);
 	struct nft_quota *priv_src = nft_expr_priv(src);
@@ -240,7 +240,7 @@ static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
 	priv_dst->quota = priv_src->quota;
 	priv_dst->flags = priv_src->flags;
 
-	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), GFP_ATOMIC);
+	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), gfp);
 	if (!priv_dst->consumed)
 		return -ENOMEM;
 
-- 
2.30.2

