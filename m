Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAAB27E1DC
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2026 13:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787147195; cv=none; b=D8SZdp3txL7NmEqnFNR2X/lNgYG2Ybc82ApBJBFk17JqBD8+eAzZrN38VzsItA15eFNxQr/VnYnV4bCbrQkWL01UD0mk5KQOtKzE9/G9itKbeTxQFcHuIRP2Ee400+p9TBVzdwx6Jpeptt5iX8C5OiEXgtQQyL1G80oqItMHfgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787147195; c=relaxed/simple;
	bh=lapnEzJsA2GSlRYwkgtI9KCuH/nqC0+s8fymoZaLcag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PEe4iCrdKbTtzLu8MAi2mhPx323e4YXT6l/ojQrCOW2P+mOLaHZN9EeF8mdaXzsieeyr6alFWKvcZ4DSB8fbV66UgfdwXatDOizw0VDPHeZQ30TgAEJPOLdbtpaPKCCft4NAOfWzBpHawKHJ4D10w4taepzCdMsEr1fk6KdwEPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SBKlsfLM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SBKlsfLM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787147191;
	bh=ffwWv48kmCTdFbByjyenNxvknfXguQvCaYIdEZFVkIg=;
	h=From:To:Cc:Subject:Date:From;
	b=SBKlsfLMymGUj1P+6yY+wFk6+Iu3o/TWeUc2z0ry2rurnnJa4FH74FtttD/yUO+XO
	 pIOUFfnPWtexaAC7xBU8ustyhXW+qR3IHkno06z/JD2FYPpVuGVu9ggDp6QzyMGhA/
	 05uwCjpGqHQ58cvQp1nJUriSw79KMn4tcrG83AiUZ8QUy4YuJHLStw+hAFRj42Q0GX
	 Ws8+xqAm/eHIYTHjnlFYlAHE4ruibsbpUyhihPKZ1tMZZEPby4g15myrV9HYsfKXu2
	 +lBArzF5Vo+PM8dUkbsOkE+JXsjbY8lya094iMsV7PN4pM+Nej0qKoE5xMY2RJPm+p
	 j9Fr0LRcftRcg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5D2B16009D;
	Wed, 19 Aug 2026 15:46:31 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	hdthky0@gmail.com
Subject: [PATCH nf,v3] netfilter: nf_tables: skip double clone set expressions on element insert
Date: Wed, 19 Aug 2026 15:46:28 +0200
Message-ID: <20260819134628.1494340-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both the dynset and newsetelem path clone the existing set expressions
when setting set element expressions if no override expressions are
provided. This results in a double clone, once to clone the template set
expressions then another clone on the new element. Add a flag to
annotate if userspace provides a override expression (ie. expression of
the same type of the set but different configuration), otherwise borrow
the existing expression from the set. Add conditionals to release
expression iif they represent an override.

This simplifies the existing logic and it also fixes a bug with the
connlimit expression which results in a module refcount imbalance
WARNING splat when resorting on the default set expressions.

Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
Fixes: fca05d4d61e6 ("netfilter: nft_dynset: honor stateful expressions in set definition")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: update missing spot in nft_dynset to address leak in error path.

 include/net/netfilter/nf_tables.h |  2 --
 net/netfilter/nf_tables_api.c     | 56 ++++++++++---------------------
 net/netfilter/nft_dynset.c        | 23 ++++++++-----
 3 files changed, 32 insertions(+), 49 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 238f6ecb90e9..9d597482363d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -870,8 +870,6 @@ struct nft_elem_priv *nft_set_elem_init(const struct nft_set *set,
 					const u32 *key, const u32 *key_end,
 					const u32 *data,
 					u64 timeout, u64 expiration, gfp_t gfp);
-int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
-			    struct nft_expr *expr_array[]);
 void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 			       struct nft_set_elem_expr *elem_expr);
 void nft_set_elem_destroy(const struct nft_set *set,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 71f4227d7ac7..20c562174b27 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6921,39 +6921,11 @@ static void nft_trans_elems_destroy(const struct nft_ctx *ctx,
 		nf_tables_set_elem_destroy(ctx, te->set, te->elems[i].priv);
 }
 
-int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
-			    struct nft_expr *expr_array[])
-{
-	struct nft_expr *expr;
-	int err, i, k;
-
-	for (i = 0; i < set->num_exprs; i++) {
-		expr = kzalloc(set->exprs[i]->ops->size, GFP_KERNEL_ACCOUNT);
-		if (!expr)
-			goto err_expr;
-
-		err = nft_expr_clone(expr, set->exprs[i], GFP_KERNEL_ACCOUNT);
-		if (err < 0) {
-			kfree(expr);
-			goto err_expr;
-		}
-		expr_array[i] = expr;
-	}
-
-	return 0;
-
-err_expr:
-	for (k = i - 1; k >= 0; k--)
-		nft_expr_destroy(ctx, expr_array[k]);
-
-	return -ENOMEM;
-}
-
 static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 				   const struct nft_set_ext_tmpl *tmpl,
 				   const struct nft_set_ext *ext,
 				   struct nft_expr *expr_array[],
-				   u32 num_exprs)
+				   u32 num_exprs, bool override_exprs)
 {
 	struct nft_set_elem_expr *elem_expr = nft_set_ext_expr(ext);
 	u32 len = sizeof(struct nft_set_elem_expr);
@@ -6976,7 +6948,8 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 			goto err_elem_expr_setup;
 
 		elem_expr->size += expr_array[i]->ops->size;
-		nft_expr_destroy(ctx, expr_array[i]);
+		if (override_exprs)
+			nft_expr_destroy(ctx, expr_array[i]);
 		expr_array[i] = NULL;
 	}
 
@@ -6984,7 +6957,9 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 
 err_elem_expr_setup:
 	for (; i < num_exprs; i++) {
-		nft_expr_destroy(ctx, expr_array[i]);
+		if (override_exprs)
+			nft_expr_destroy(ctx, expr_array[i]);
+
 		expr_array[i] = NULL;
 	}
 
@@ -7280,6 +7255,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_binding *binding;
 	struct nft_elem_priv *elem_priv;
 	struct nft_object *obj = NULL;
+	bool override_exprs = false;
 	struct nft_userdata *udata;
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
@@ -7385,6 +7361,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 		expr_array[0] = expr;
 		num_exprs = 1;
+		override_exprs = true;
 
 		if (set->num_exprs && set->exprs[0]->ops != expr->ops) {
 			err = -EOPNOTSUPP;
@@ -7413,6 +7390,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			}
 			expr_array[i] = expr;
 			num_exprs++;
+			override_exprs = true;
 
 			if (set->num_exprs && expr->ops != set->exprs[i]->ops) {
 				err = -EOPNOTSUPP;
@@ -7426,9 +7404,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		}
 	} else if (set->num_exprs > 0 &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		err = nft_set_elem_expr_clone(ctx, set, expr_array);
-		if (err < 0)
-			goto err_set_elem_expr_clone;
+		for (i = 0; i < set->num_exprs; i++)
+			expr_array[i] = set->exprs[i];
 
 		num_exprs = set->num_exprs;
 	}
@@ -7567,7 +7544,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		udata->len = ulen - 1;
 		nla_memcpy(&udata->data, nla[NFTA_SET_ELEM_USERDATA], ulen);
 	}
-	err = nft_set_elem_expr_setup(ctx, &tmpl, ext, expr_array, num_exprs);
+	err = nft_set_elem_expr_setup(ctx, &tmpl, ext, expr_array, num_exprs,
+				      override_exprs);
 	if (err < 0)
 		goto err_elem_free;
 
@@ -7675,9 +7653,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 err_parse_key:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 err_set_elem_expr:
-	for (i = 0; i < num_exprs && expr_array[i]; i++)
-		nft_expr_destroy(ctx, expr_array[i]);
-err_set_elem_expr_clone:
+	if (override_exprs) {
+		for (i = 0; i < num_exprs && expr_array[i]; i++)
+			nft_expr_destroy(ctx, expr_array[i]);
+	}
+
 	return err;
 }
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index ee9d3e7b1ecf..83e56b1aa858 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -19,7 +19,8 @@ struct nft_dynset {
 	u8				sreg_key;
 	u8				sreg_data;
 	bool				invert;
-	bool				expr;
+	bool				expr:1,
+					override_exprs:1;
 	u8				num_exprs;
 	u64				timeout;
 	struct nft_expr			*expr_array[NFT_SET_EXPR_MAX];
@@ -257,6 +258,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 
 		priv->num_exprs++;
 		priv->expr_array[0] = dynset_expr;
+		priv->override_exprs = true;
 
 		if (set->num_exprs > 1 ||
 		    (set->num_exprs == 1 &&
@@ -289,6 +291,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			}
 			priv->expr_array[i] = dynset_expr;
 			priv->num_exprs++;
+			priv->override_exprs = true;
 
 			if (set->num_exprs) {
 				if (i >= set->num_exprs) {
@@ -307,9 +310,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			goto err_expr_free;
 		}
 	} else if (set->num_exprs > 0) {
-		err = nft_set_elem_expr_clone(ctx, set, priv->expr_array);
-		if (err < 0)
-			return err;
+		for (i = 0; i < set->num_exprs; i++)
+			priv->expr_array[i] = set->exprs[i];
 
 		priv->num_exprs = set->num_exprs;
 	}
@@ -339,8 +341,10 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	return 0;
 
 err_expr_free:
-	for (i = 0; i < priv->num_exprs; i++)
-		nft_expr_destroy(ctx, priv->expr_array[i]);
+	if (priv->override_exprs) {
+		for (i = 0; i < priv->num_exprs; i++)
+			nft_expr_destroy(ctx, priv->expr_array[i]);
+	}
 	return err;
 }
 
@@ -367,9 +371,10 @@ static void nft_dynset_destroy(const struct nft_ctx *ctx,
 	struct nft_dynset *priv = nft_expr_priv(expr);
 	int i;
 
-	for (i = 0; i < priv->num_exprs; i++)
-		nft_expr_destroy(ctx, priv->expr_array[i]);
-
+	if (priv->override_exprs) {
+		for (i = 0; i < priv->num_exprs; i++)
+			nft_expr_destroy(ctx, priv->expr_array[i]);
+	}
 	nf_tables_destroy_set(ctx, priv->set);
 }
 
-- 
2.47.3

