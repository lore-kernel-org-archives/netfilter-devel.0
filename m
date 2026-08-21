Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD5F47DF96
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 10:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787309368; cv=none; b=S9aMiG5492MmxEmR8/hXcOmDx3xdJX1NVXHpUm7XoumRMCBVi0ilCCy+g8rmIkUPsliPOIDzeSFgAgpvB50CnzRHR2pKSl4lhwGAw0CioEBgKQiCl69MsDcLY5zQ9lN6PpQqRrBpxzc2Vi8SDUhCFMfdR20UV8L3BwdFqXK+668=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787309368; c=relaxed/simple;
	bh=qDISSs3gN/Vkmt3SDfLKhg84t6VQxvYc73QGUfLBavU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OJgrMB39E6kokihOAIxr5WwdiFmzb6WaZmvGkD1WO9v8lKNdbIi2sqOtYDE0+F1WvfTvpdxXa+ZSb0TEe1GYcjBqsv6XtW2LjDxTr4KL7t1mVZQ1z8d/JLno3BPTX02/rJaVS9ADTRYqLxNDJZgWRdcDdOczxluFTUZr5K722BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UDBgqiG8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UDBgqiG8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787309360;
	bh=XCnrbWJarbWZxBZ1tdV3guxtJbpmnYRa1A8ONxOvUps=;
	h=From:To:Subject:Date:From;
	b=UDBgqiG8vbDCr7hCkxBJ4g3zqTWwLeuVp3O5qTBm39sqm2y9IeTTVMx4krq6lL6Ij
	 wnS5nN439jNEj48g+IpION+FVREVNA0Mnt2ghbcou/7FcI0Uy0HRQ1Pw3ktMezZkk/
	 J8OV48JVw3ohn3vdvaqLI6MEghzcxHAz+PA3AKnqyh9tJ69QZpRwpmqV+H/tv6BqIp
	 Vee9hmWE6NHm0chNkqloYi+0SLAQRiPmojnkrZw4ieKXY2fdnYa6ElvFzbZKGDtikB
	 IJTP7Xce4ZCe9vG1ywSe0P2Sw9kFmynZb9vinZUOzfv/X7Ggh1M7jP9cmA+gjuepk3
	 LY4eRb3YXw0hA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 900F66005B
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 12:49:19 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nf_tables: skip double clone set expressions on element insert
Date: Fri, 21 Aug 2026 12:49:14 +0200
Message-ID: <20260821104915.15436-1-pablo@netfilter.org>
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
index c83fd55aa44a..f89605e68ba1 100644
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

