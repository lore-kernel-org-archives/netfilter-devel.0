Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBBF175A74
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 22:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787092289; cv=none; b=Y70nG0a9o5JuJ2r/HeEOGfzYX34JmV4zeaX1kpgYrfwBOsgiHN4yDjvZ5YV1aNxn4Xr4hv4eKZfqWZTDboUCE2VHNAtUZhlNGhjufpghzI2HHPPoWBpUgYV++RdtEJOhmBcftkIuzq4Co9tK1GdOvvmFYN9nv6VwR+7L4I61swM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787092289; c=relaxed/simple;
	bh=4HPnqvjaQPUYSy1rMC4v+84g9bMXkSRKcpAIvzt0BuA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MwnMrBA37zq+ZW/IkYB4izmSLfQ9b5JoxXeTTX9+uaq8kMxf/Zq2wbXEQ1Xt2628O3UA7+IJ/HpISmXb6dCRaf7Fc6r+AtFob4AnJFV6lP9BAZliD3iySPxrtGgDtSZ+L6fWeqGvr6CbNTjytqwU8t11+bN2D8BRZqhN48VVxLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JahRq/Bu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JahRq/Bu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787092283;
	bh=LaYFs3EQUHICHT5dIyx0Zf3pxuTHr/ADC7oBkZEwBmQ=;
	h=From:To:Cc:Subject:Date:From;
	b=JahRq/BugijQSejVj7mjkGsoABlG5m5fW7wZunkTXzjTU6AgC/8BKBwZGbwUpwYQe
	 6tQRNVZuPmh5Vi1BxBY+4jK5DdwxmfAGPLcQm+Nj9EixBq7lkRSmhLVqHiHSeMMoj3
	 mlTZu2FU7SFNrPFYdMKu+0CYuCTWDeXkclcgj/0qXq/8GNeqPGHb3UIH4Qb6C8GeFv
	 uo6f2qKnLU4PS3W37sGIqf7efmN8XTsa7y423RtzuUAa/8cFS6s517VdeVu0NRdys8
	 lhHvvFw9TqQQPBeHyNFqpxFP6QmzM89Hy0GlvQZTZcQZrjPts7FzvcdFahB4ejnxOX
	 MPIsqdpHLaXeQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4D4946005E;
	Wed, 19 Aug 2026 00:31:23 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	hdthky0@gmail.com
Subject: [PATCH nf] netfilter: nft_dynset: missing .clone_destroy call when honoring set expression
Date: Wed, 19 Aug 2026 00:31:18 +0200
Message-ID: <20260818223118.1390042-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the set definition provides template stateful expressions and the
dynset expression does not specify any, then these template expressions
are cloned without holding refcount on modules because the template
already did this for us.

The expression cloning is usually reserved to allocate expressions in
the packet. However, this mechanism is also used by the dynset
expression to allocate the template dynset expression.

For the connlimit expression, this results in a WARNING splat due to
module refcount imbalance because the destroy path drops the module
refcount when the clone did not bump it.

To address this issue, annotate that these stateful expressions have
cloned from the set, so the destroy path uses .destroy_clone to release
them.

Fixes: fca05d4d61e6 ("netfilter: nft_dynset: honor stateful expressions in set definition")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     |  4 ++--
 net/netfilter/nft_dynset.c        | 25 ++++++++++++++++++-------
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 238f6ecb90e9..13f8807d05b8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -874,6 +874,8 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_expr *expr_array[]);
 void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 			       struct nft_set_elem_expr *elem_expr);
+void __nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+				 struct nft_expr *expr);
 void nft_set_elem_destroy(const struct nft_set *set,
 			  const struct nft_elem_priv *elem_priv,
 			  bool destroy_expr);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 71f4227d7ac7..06b9754d1c25 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6830,8 +6830,8 @@ struct nft_elem_priv *nft_set_elem_init(const struct nft_set *set,
 	return ERR_PTR(-EINVAL);
 }
 
-static void __nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
-					struct nft_expr *expr)
+void __nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+				 struct nft_expr *expr)
 {
 	if (expr->ops->destroy_clone) {
 		expr->ops->destroy_clone(ctx, expr);
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index ee9d3e7b1ecf..935a07b47a44 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -19,7 +19,8 @@ struct nft_dynset {
 	u8				sreg_key;
 	u8				sreg_data;
 	bool				invert;
-	bool				expr;
+	u8				expr:1,
+					cloned:1;
 	u8				num_exprs;
 	u64				timeout;
 	struct nft_expr			*expr_array[NFT_SET_EXPR_MAX];
@@ -168,6 +169,19 @@ static const struct nla_policy nft_dynset_policy[NFTA_DYNSET_MAX + 1] = {
 	[NFTA_DYNSET_EXPRESSIONS] = { .type = NLA_NESTED },
 };
 
+static void nft_dynset_expr_destroy(const struct nft_ctx *ctx,
+				    struct nft_dynset *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_exprs; i++) {
+		if (priv->cloned)
+			__nft_set_elem_expr_destroy(ctx, priv->expr_array[i]);
+		else
+			nft_expr_destroy(ctx, priv->expr_array[i]);
+	}
+}
+
 static int nft_dynset_init(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr,
 			   const struct nlattr * const tb[])
@@ -312,6 +326,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			return err;
 
 		priv->num_exprs = set->num_exprs;
+		priv->cloned = true;
 	}
 
 	nft_set_ext_prepare(&priv->tmpl);
@@ -339,8 +354,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	return 0;
 
 err_expr_free:
-	for (i = 0; i < priv->num_exprs; i++)
-		nft_expr_destroy(ctx, priv->expr_array[i]);
+	nft_dynset_expr_destroy(ctx, priv);
 	return err;
 }
 
@@ -365,11 +379,8 @@ static void nft_dynset_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
 	struct nft_dynset *priv = nft_expr_priv(expr);
-	int i;
-
-	for (i = 0; i < priv->num_exprs; i++)
-		nft_expr_destroy(ctx, priv->expr_array[i]);
 
+	nft_dynset_expr_destroy(ctx, priv);
 	nf_tables_destroy_set(ctx, priv->set);
 }
 
-- 
2.47.3

