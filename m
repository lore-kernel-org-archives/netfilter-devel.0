Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77C31A3BB6;
	Thu, 15 Aug 2024 14:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732968; cv=none; b=SwKmOiqTzHG5/I3nVn80jxJvoibxnNcLPOTd6KaEVvWGwj0ykDDwmmf5SlcstvB6ISOX7p9w9uDgB8egwJHXWKl7Lh/SxCFB+qVtyIKD1b5Xuxl8l+E/dbETlBu3Vb4y2XxXhMUyARuNySKWdOJ5HWbqiVNPpe8SqWfIaHeX1Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732968; c=relaxed/simple;
	bh=I6Edb2duoiA7pLuiVt8GLSItNPeq1wPVkc3Gjs0cL1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hy5nqEUPST0p3/vLP6FutcugkNicAZ4Mxw0AQbSWZeaCsLoBhLzeBeUcNA0MfOgO2iSSRoL99BRJeQIk6ElmEkFNdYnZ2zcbqrU74zhCweOMMom8JRnY19gnjApZQLZH1xxpvVy5bStN1PCTYsoLyILy7aVv1JJAg5nvjd0fhdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHKfdBVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHKfdBVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D292C32786;
	Thu, 15 Aug 2024 14:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732967;
	bh=I6Edb2duoiA7pLuiVt8GLSItNPeq1wPVkc3Gjs0cL1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHKfdBVJZQsf9Ii3WLlEw/vd5b9NS8Q+NtkSg/+uoZEnPfiy14P192WOuj33GDT2x
	 IsubK7Bq6M2T6gCgd3mAj5d43EA+qp5dMzsBR5h8uLsuZHR89yyywL4Kszs+gZCdhc
	 NAZOlockSTg72NP9xiXqSan/wJeNYt3doBNz9AiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Auhagen <sven.auhagen@voleatech.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 341/352] netfilter: nf_tables: allow clone callbacks to sleep
Date: Thu, 15 Aug 2024 15:26:47 +0200
Message-ID: <20240815131932.647014447@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    4 ++--
 net/netfilter/nf_tables_api.c     |    8 ++++----
 net/netfilter/nft_connlimit.c     |    2 +-
 net/netfilter/nft_counter.c       |    4 ++--
 net/netfilter/nft_dynset.c        |    2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

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
@@ -837,7 +837,7 @@ static inline void *nft_expr_priv(const
 	return (void *)expr->data;
 }
 
-int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src, gfp_t gfp);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr);
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2968,13 +2968,13 @@ err_expr_parse:
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
@@ -5524,7 +5524,7 @@ static int nft_set_elem_expr_setup(struc
 	if (expr == NULL)
 		return 0;
 
-	err = nft_expr_clone(elem_expr, expr);
+	err = nft_expr_clone(elem_expr, expr, GFP_KERNEL);
 	if (err < 0)
 		return -ENOMEM;
 
@@ -5632,7 +5632,7 @@ static int nft_add_set_elem(struct nft_c
 		if (!expr)
 			return -ENOMEM;
 
-		err = nft_expr_clone(expr, set->expr);
+		err = nft_expr_clone(expr, set->expr, GFP_KERNEL);
 		if (err < 0)
 			goto err_set_elem_expr;
 	}
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -195,7 +195,7 @@ static void nft_connlimit_destroy(const
 	nft_connlimit_do_destroy(ctx, priv);
 }
 
-static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src, gfp_t gfp)
 {
 	struct nft_connlimit *priv_dst = nft_expr_priv(dst);
 	struct nft_connlimit *priv_src = nft_expr_priv(src);
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -224,7 +224,7 @@ static void nft_counter_destroy(const st
 	nft_counter_do_destroy(priv);
 }
 
-static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
+static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src, gfp_t gfp)
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(src);
 	struct nft_counter_percpu_priv *priv_clone = nft_expr_priv(dst);
@@ -234,7 +234,7 @@ static int nft_counter_clone(struct nft_
 
 	nft_counter_fetch(priv, &total);
 
-	cpu_stats = alloc_percpu_gfp(struct nft_counter, GFP_ATOMIC);
+	cpu_stats = alloc_percpu_gfp(struct nft_counter, gfp);
 	if (cpu_stats == NULL)
 		return -ENOMEM;
 
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -48,7 +48,7 @@ static void *nft_dynset_new(struct nft_s
 
 	ext = nft_set_elem_ext(set, elem);
 	if (priv->expr != NULL &&
-	    nft_expr_clone(nft_set_ext_expr(ext), priv->expr) < 0)
+	    nft_expr_clone(nft_set_ext_expr(ext), priv->expr, GFP_ATOMIC) < 0)
 		goto err2;
 
 	return elem;


