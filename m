Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ECFB170A36;
	Mon, 12 Aug 2024 10:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458474; cv=none; b=KK8uq0fWxKIDZ1FmmHvmTLsVyNx3PInTBEfHY7zjfILmoQdmD949Ezg+C6kM2ZG/Fpt5eqzUTl7Gl0L8sWGrtP/xSBV+/+E0enmKia5aXp4yQF30SvmIF3CTSkTLkPwzRyQaVcZ7/sXeaMVvZp1NoLOcMYk3mRyaicdMNSEA7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458474; c=relaxed/simple;
	bh=liD5x1UIsYlVO7nWnYIE80U3n1aUo3wyI2PTqraLMuY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FyTnjkjU9VgTopd/xkrW/SeImceOA7BO4tXQLxwO6sX0EHbnOL8g3q4iO3o1ANeKrWWmWZuxKfLF2vmKIAyIh6w/uJlUlZq0RXih+KYgPG5cAai4d4nfexpw+tZJxTdCKeecjnbXDRoNJCbyMsvDsmnAmJYG5REEEt+hSIvgFtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10.x 3/4] netfilter: nf_tables: allow clone callbacks to sleep
Date: Mon, 12 Aug 2024 12:27:41 +0200
Message-Id: <20240812102742.388214-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240812102742.388214-1-pablo@netfilter.org>
References: <20240812102742.388214-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 include/net/netfilter/nf_tables.h | 4 ++--
 net/netfilter/nf_tables_api.c     | 8 ++++----
 net/netfilter/nft_connlimit.c     | 2 +-
 net/netfilter/nft_counter.c       | 4 ++--
 net/netfilter/nft_dynset.c        | 2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index dd7c310e7216..3cc25a5faa23 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -786,7 +786,7 @@ struct nft_expr_ops {
 						struct nft_regs *regs,
 						const struct nft_pktinfo *pkt);
 	int				(*clone)(struct nft_expr *dst,
-						 const struct nft_expr *src);
+						 const struct nft_expr *src, gfp_t gfp);
 	unsigned int			size;
 
 	int				(*init)(const struct nft_ctx *ctx,
@@ -837,7 +837,7 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
 	return (void *)expr->data;
 }
 
-int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src, gfp_t gfp);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bf4c455474a6..2b5e9efe86dd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2968,13 +2968,13 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 	return ERR_PTR(err);
 }
 
-int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src, gfp_t gfp)
 {
 	int err;
 
 	if (src->ops->clone) {
 		dst->ops = src->ops;
-		err = src->ops->clone(dst, src);
+		err = src->ops->clone(dst, src, gfp);
 		if (err < 0)
 			return err;
 	} else {
@@ -5524,7 +5524,7 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 	if (expr == NULL)
 		return 0;
 
-	err = nft_expr_clone(elem_expr, expr);
+	err = nft_expr_clone(elem_expr, expr, GFP_KERNEL);
 	if (err < 0)
 		return -ENOMEM;
 
@@ -5632,7 +5632,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (!expr)
 			return -ENOMEM;
 
-		err = nft_expr_clone(expr, set->expr);
+		err = nft_expr_clone(expr, set->expr, GFP_KERNEL);
 		if (err < 0)
 			goto err_set_elem_expr;
 	}
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 7d0761fad37e..091457e5c260 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -195,7 +195,7 @@ static void nft_connlimit_destroy(const struct nft_ctx *ctx,
 	nft_connlimit_do_destroy(ctx, priv);
 }
 
-static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src, gfp_t gfp)
 {
 	struct nft_connlimit *priv_dst = nft_expr_priv(dst);
 	struct nft_connlimit *priv_src = nft_expr_priv(src);
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 85ed461ec24e..75fa6fcd6cd6 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -224,7 +224,7 @@ static void nft_counter_destroy(const struct nft_ctx *ctx,
 	nft_counter_do_destroy(priv);
 }
 
-static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src, gfp_t gfp)
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(src);
 	struct nft_counter_percpu_priv *priv_clone = nft_expr_priv(dst);
@@ -234,7 +234,7 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
 
 	nft_counter_fetch(priv, &total);
 
-	cpu_stats = alloc_percpu_gfp(struct nft_counter, GFP_ATOMIC);
+	cpu_stats = alloc_percpu_gfp(struct nft_counter, gfp);
 	if (cpu_stats == NULL)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 408b7f5faa5e..9461293182e8 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -48,7 +48,7 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 
 	ext = nft_set_elem_ext(set, elem);
 	if (priv->expr != NULL &&
-	    nft_expr_clone(nft_set_ext_expr(ext), priv->expr) < 0)
+	    nft_expr_clone(nft_set_ext_expr(ext), priv->expr, GFP_ATOMIC) < 0)
 		goto err2;
 
 	return elem;
-- 
2.30.2

