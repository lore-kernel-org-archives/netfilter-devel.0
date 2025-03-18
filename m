Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15C7206F1D;
	Tue, 18 Mar 2025 22:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336132; cv=none; b=lqzQQ5mmKheqmfEYqRG7zPolovRzepLokX3JeFl0ratzHL9fL6T8XHyTIvVTKp9wo0mb6cnAbM3cd4af0+lTmuBsOseA6j/deJmu3IlcGXh8OG9rY+avbl35oxGHc8BxVfhxFJddssoZ1q6GfS3Idy1g7y00aUN3eu5K2PtmDjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336132; c=relaxed/simple;
	bh=Qafn44eCZTBukhygaH/K0DcQJZmHzSIAwVoFGB/XFX4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OoHlFx2xwrk5QoZJ9dwUGEp/MsYQRfC6GJTbx+vfdC3pB2b/H4x5msCIrpX8WTaxc0m1Jc9xhLtLoXXncnkKyT0EJlmndLRj5NtOVxWLeLJWfoDIo0FgGQqXvtDUbimm8aYcwe98vRouPXgfsRAgvwoN0oMbllsO/8RdM70qlWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DdH0StiH; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jjO9weEX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DdH0StiH";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jjO9weEX"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 40332605A8; Tue, 18 Mar 2025 23:15:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742336129;
	bh=mrIjGV8KbeK/9HiBJMBBHZvovK/w03/T8X4vsT4GM8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdH0StiH2hsUCDJW6tha+pzDhD3jiTwWJF2kmIquV1iBU1pNArsVrfpPt6BZ17rnm
	 L0UyepV7yMdglWGVJjTAgWFvexrweZJjvJBYT7rlVh6IFl2JctzvSQLGgpFnuTXNIC
	 YC1KmHinMblcy19PEMkoXeZZOAomS7WrgcmSp1Anw8XVIbsMxBW3hsmRYIrai8eAum
	 BxamcRVM+fdSvDxUJPcmeSKGzcec8KUxuqYj+5JI59fYk5jW2Vx9enGcqffv2QmWMq
	 fEFVFgK+TTOvfv1+rLz0q1gto8vhw4N+K/he0ICTMmsMLbKl3SnpZbLuC/bcQWKH+U
	 GgO9F2Hi5kVog==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E4F98605B7;
	Tue, 18 Mar 2025 23:15:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742336128;
	bh=mrIjGV8KbeK/9HiBJMBBHZvovK/w03/T8X4vsT4GM8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjO9weEXsBfnf4fgcdHi9TROTtIgufLFvXESLfNyKEztSif7vvN6DQBKOt69qWrRd
	 xKAGKA+0A7dfVC1utm0U7dbcnlUWkS1ugZ7NlaLOgPVvnhvv3UDMH+2v4t5wlOtsS4
	 rSdalDC/inoNTIqUoP4KxroorF8onTECPUCB8J22xinuy8s7PTKTyaTHC1IYIkE5Ip
	 KHcXkC5iuZMfLdhWGBSBFKla6DAesW5HxcfxheBTat+RZi9DZqajO3YFgf2Q0+BY+7
	 z+J1ln9Vb5t9V63no8CUHV+WJid+UaSZoRgNIGPz9org/Ql5QrknFH1oe4hnpI4LoS
	 S70rkfv+QP0dQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.6 v2 2/2] netfilter: nf_tables: allow clone callbacks to sleep
Date: Tue, 18 Mar 2025 23:15:22 +0100
Message-Id: <20250318221522.225942-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250318221522.225942-1-pablo@netfilter.org>
References: <20250318221522.225942-1-pablo@netfilter.org>
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
index dcbf3f299548..e497501fd34e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -407,7 +407,7 @@ struct nft_expr_info;
 
 int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
 			 struct nft_expr_info *info);
-int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src, gfp_t gfp);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr, bool reset);
@@ -930,7 +930,7 @@ struct nft_expr_ops {
 						struct nft_regs *regs,
 						const struct nft_pktinfo *pkt);
 	int				(*clone)(struct nft_expr *dst,
-						 const struct nft_expr *src);
+						 const struct nft_expr *src, gfp_t gfp);
 	unsigned int			size;
 
 	int				(*init)(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a85f5e0cc9d1..a48b1ece63cd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3332,7 +3332,7 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 	return ERR_PTR(err);
 }
 
-int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src, gfp_t gfp)
 {
 	int err;
 
@@ -3340,7 +3340,7 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
 		return -EINVAL;
 
 	dst->ops = src->ops;
-	err = src->ops->clone(dst, src);
+	err = src->ops->clone(dst, src, gfp);
 	if (err < 0)
 		return err;
 
@@ -6457,7 +6457,7 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 		if (!expr)
 			goto err_expr;
 
-		err = nft_expr_clone(expr, set->exprs[i]);
+		err = nft_expr_clone(expr, set->exprs[i], GFP_KERNEL_ACCOUNT);
 		if (err < 0) {
 			kfree(expr);
 			goto err_expr;
@@ -6496,7 +6496,7 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 
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
index b7aa4d2c8c22..eab0dc66bee6 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -231,7 +231,7 @@ static void nft_counter_destroy(const struct nft_ctx *ctx,
 	nft_counter_do_destroy(priv);
 }
 
-static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src, gfp_t gfp)
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(src);
 	struct nft_counter_percpu_priv *priv_clone = nft_expr_priv(dst);
@@ -241,7 +241,7 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
 
 	nft_counter_fetch(priv, &total);
 
-	cpu_stats = alloc_percpu_gfp(struct nft_counter, GFP_ATOMIC);
+	cpu_stats = alloc_percpu_gfp(struct nft_counter, gfp);
 	if (cpu_stats == NULL)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 629a91a8c614..a81bd69b059b 100644
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
2.30.2

