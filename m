Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97F72BEC43
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259300; cv=none; b=N+Uu7kdBCqb4wQZfnFJUVFb8grSrGX5P51hLyYaiM/DuDn51uyMwFoTnxic9FGmts98oHdDiA5OOj54Y69fONSnIkVYoXTol3X7GThrXcR/EtWyyNAk0BwyGiVQ8EjN87fpm9khJ/kq3URU3SiFJSC2Gi6oBTPs1Ei3TQw8XX8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259300; c=relaxed/simple;
	bh=vf1Ez9qid1UdwkWSniaOE8pMVRpdDnixJYqeukx8RoM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjOnECCuka2PlZ9AzKQbQ/lXKLQl7nD0/4GrBjx8zJOdQKkrZP70c/knqwhEKcRs0ogGH9dKfAwMwBTQCQCDLWktGKdYsHCrpF3u19TrTkf1xLgNd1ou7dawgX3grXrsuqPJwttolKz8JphfWRAtHlvb87UTeycpMJ7Ipagfx2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d799aQZV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d799aQZV"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A0C4D6087F
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259298;
	bh=kkBE5BrQKcpLlBL5siZw4kzuVMrcf+W/qZhhnxhHmPs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=d799aQZVmdKbXrZAy28VuUxTx/TiNIv3IIoqzq50fAq9dIFa12WBpKQLTmrzWAPAk
	 Ca9HJeV2bFu2R5zgbe8oqZMhf2u2sLL4gCkjFFyNvOJ4dkXvQF5nRE8EDO1JCvqmKI
	 osMDW96JqUirzDI/tGUgjit8gi5GqplxGNNPblfv+uHyCIMz5FGLVZUdBbiK5Jp9Ha
	 +s2nP/8ngvSwdKVgAjpC/qcCs8/RB2B2oFBsg+W96ywZqxOfh2XVkRkuKCI0ddyo9A
	 XDQhJ0kc3snjdGW238rCWKQ2V4r8GW1C7nCXcmnRXg2VCvv7bHUPdOTFONsMmxvnYK
	 zSHTpfTsf8W3w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 03/20] src: assert on EXPR_SET only contains EXPR_SET_ELEM in the expressions list
Date: Thu,  5 Feb 2026 03:41:12 +0100
Message-ID: <20260205024130.1470284-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260205024130.1470284-1-pablo@netfilter.org>
References: <20260205024130.1470284-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add assert() to validate that expression lists contain EXPR_SET_ELEM.
This allows to detect potential subtle bugs when dereferencing struct
expr.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c            | 23 +++++++++--------------
 src/expression.c          | 16 ++++++++++++----
 src/intervals.c           | 14 ++++++++++++++
 src/json.c                | 10 ++++++++--
 src/netlink.c             |  2 ++
 src/netlink_delinearize.c |  9 ++++++---
 src/optimize.c            |  3 +++
 src/segtree.c             |  6 ++++++
 8 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e6689adf0880..f0a82a2c46eb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2080,6 +2080,8 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			struct expr *new, *j;
 
 			list_for_each_entry(j, &expr_set(i->key->left)->expressions, list) {
+				assert(j->etype == EXPR_SET_ELEM);
+
 				new = mapping_expr_alloc(&i->location,
 							 expr_get(j->key),
 							 expr_get(i->key->right));
@@ -2781,9 +2783,9 @@ static void optimize_singleton_set(struct expr *rel, struct expr **expr)
 	struct expr *set = rel->right, *i;
 
 	i = list_first_entry(&expr_set(set)->expressions, struct expr, list);
-	if (i->etype == EXPR_SET_ELEM &&
-	    list_empty(&i->stmt_list)) {
+	assert (i->etype == EXPR_SET_ELEM);
 
+	if (list_empty(&i->stmt_list)) {
 		switch (i->key->etype) {
 		case EXPR_PREFIX:
 		case EXPR_RANGE:
@@ -5488,19 +5490,12 @@ static struct expr *expr_set_to_list(struct eval_ctx *ctx, struct expr *dev_expr
 	LIST_HEAD(tmp);
 
 	list_for_each_entry_safe(expr, next, &expr_set(dev_expr)->expressions, list) {
-		list_del(&expr->list);
-
-		switch (expr->etype) {
-		case EXPR_SET_ELEM:
-			key = expr_clone(expr->key);
-			expr_free(expr);
-			expr = key;
-			break;
-		default:
-			BUG("invalid expression type %s", expr_name(expr));
-			break;
-		}
+		assert(expr->etype == EXPR_SET_ELEM);
 
+		list_del(&expr->list);
+		key = expr_clone(expr->key);
+		expr_free(expr);
+		expr = key;
 		list_add(&expr->list, &tmp);
 	}
 
diff --git a/src/expression.c b/src/expression.c
index 5aac7165319f..f356cf117307 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -946,8 +946,9 @@ void relational_expr_pctx_update(struct proto_ctx *ctx,
 			ops->pctx_update(ctx, &expr->location, left, right);
 		else if (right->etype == EXPR_SET) {
 			list_for_each_entry(i, &expr_set(right)->expressions, list) {
-				if (i->etype == EXPR_SET_ELEM &&
-				    i->key->etype == EXPR_VALUE)
+				assert(i->etype == EXPR_SET_ELEM);
+
+				if (i->key->etype == EXPR_VALUE)
 					ops->pctx_update(ctx, &expr->location, left, i->key);
 			}
 		} else if (ops == &meta_expr_ops &&
@@ -1384,6 +1385,8 @@ static void set_expr_print(const struct expr *expr, struct output_ctx *octx)
 	nft_print(octx, "{ ");
 
 	list_for_each_entry(i, &expr_set(expr)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		nft_print(octx, "%s", d);
 		expr_print(i, octx);
 		count++;
@@ -1406,8 +1409,10 @@ static void set_expr_destroy(struct expr *expr)
 {
 	struct expr *i, *next;
 
-	list_for_each_entry_safe(i, next, &expr_set(expr)->expressions, list)
+	list_for_each_entry_safe(i, next, &expr_set(expr)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
 		expr_free(i);
+	}
 }
 
 static void set_expr_set_type(const struct expr *expr,
@@ -1416,8 +1421,11 @@ static void set_expr_set_type(const struct expr *expr,
 {
 	struct expr *i;
 
-	list_for_each_entry(i, &expr_set(expr)->expressions, list)
+	list_for_each_entry(i, &expr_set(expr)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		expr_set_type(i, dtype, byteorder);
+	}
 }
 
 static const struct expr_ops set_expr_ops = {
diff --git a/src/intervals.c b/src/intervals.c
index 9ab2cc20533a..ec4435e08690 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -183,6 +183,8 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
 	mpz_init(rop);
 
 	list_for_each_entry_safe(i, next, &expr_set(ctx->init)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		if (expr_type_catchall(i->key))
 			continue;
 
@@ -243,6 +245,8 @@ static void set_to_range(struct expr *init)
 	struct expr *i, *elem;
 
 	list_for_each_entry(i, &expr_set(init)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		elem = interval_expr_key(i);
 		setelem_expr_to_range(elem);
 	}
@@ -274,6 +278,8 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	setelem_automerge(&ctx);
 
 	list_for_each_entry_safe(i, next, &expr_set(init)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		if (i->flags & EXPR_F_KERNEL) {
 			list_move_tail(&i->list, &expr_set(existing_set->init)->expressions);
 		} else if (existing_set) {
@@ -413,6 +419,8 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 	mpz_init(rop);
 
 	list_for_each_entry_safe(elem, next, &expr_set(elems)->expressions, list) {
+		assert(elem->etype == EXPR_SET_ELEM);
+
 		i = interval_expr_key(elem);
 
 		if (expr_type_catchall(i->key)) {
@@ -585,6 +593,8 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 	mpz_init(rop);
 
 	list_for_each_entry_safe(elem, next, &expr_set(init)->expressions, list) {
+		assert(elem->etype == EXPR_SET_ELEM);
+
 		i = interval_expr_key(elem);
 
 		if (expr_type_catchall(i->key))
@@ -654,6 +664,8 @@ int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 	err = setelem_overlap(msgs, set, init);
 
 	list_for_each_entry_safe(i, n, &expr_set(init)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		if (i->flags & EXPR_F_KERNEL)
 			list_move_tail(&i->list, &expr_set(existing_set->init)->expressions);
 		else if (existing_set) {
@@ -711,6 +723,8 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 	mpz_t p;
 
 	list_for_each_entry_safe(i, n, &expr_set(init)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		elem = interval_expr_key(i);
 
 		if (expr_type_catchall(elem->key))
diff --git a/src/json.c b/src/json.c
index 937a82dc19e9..3c369fb916d0 100644
--- a/src/json.c
+++ b/src/json.c
@@ -232,8 +232,11 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 		json_t *array = json_array();
 		const struct expr *i;
 
-		list_for_each_entry(i, &expr_set(set->init)->expressions, list)
+		list_for_each_entry(i, &expr_set(set->init)->expressions, list) {
+			assert(i->etype == EXPR_SET_ELEM);
+
 			json_array_append_new(array, expr_print_json(i, octx));
+		}
 
 		json_object_set_new(root, "elem", array);
 	}
@@ -768,8 +771,11 @@ json_t *set_expr_json(const struct expr *expr, struct output_ctx *octx)
 	json_t *array = json_array();
 	const struct expr *i;
 
-	list_for_each_entry(i, &expr_set(expr)->expressions, list)
+	list_for_each_entry(i, &expr_set(expr)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		json_array_append_new(array, expr_print_json(i, octx));
+	}
 
 	return nft_json_pack("{s:o}", "set", array);
 }
diff --git a/src/netlink.c b/src/netlink.c
index 3a28978547c3..34c667995489 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1309,6 +1309,8 @@ void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
 	const struct expr *expr;
 
 	list_for_each_entry(expr, &expr_set(set)->expressions, list) {
+		assert(expr->etype == EXPR_SET_ELEM);
+
 		nlse = alloc_nftnl_setelem(set, expr);
 		nftnl_set_elem_add(nls, nlse);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index fc359d6d9294..81763206f136 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2206,9 +2206,9 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 				struct expr *elem;
 
 				elem = list_first_entry(&expr_set(set->init)->expressions, struct expr, list);
+				assert(elem->etype == EXPR_SET_ELEM);
 
-				if (elem->etype == EXPR_SET_ELEM &&
-				    elem->key->etype == EXPR_VALUE)
+				if (elem->key->etype == EXPR_VALUE)
 					payload_icmp_check(ctx, payload, elem->key);
 			}
 		}
@@ -2883,8 +2883,11 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		expr_postprocess(ctx, &expr->right);
 		break;
 	case EXPR_SET:
-		list_for_each_entry(i, &expr_set(expr)->expressions, list)
+		list_for_each_entry(i, &expr_set(expr)->expressions, list) {
+			assert(i->etype == EXPR_SET_ELEM);
+
 			expr_postprocess(ctx, &i);
+		}
 		break;
 	case EXPR_CONCAT:
 		expr_postprocess_concat(ctx, exprp);
diff --git a/src/optimize.c b/src/optimize.c
index 3e6e24cf7b90..a2bd3aab72d0 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -594,6 +594,7 @@ static void merge_vmap(const struct optimize_ctx *ctx,
 
 	mappings = stmt_b->expr->mappings;
 	list_for_each_entry(expr, &expr_set(mappings)->expressions, list) {
+		assert(expr->etype == EXPR_SET_ELEM);
 		mapping = expr_clone(expr);
 		set_expr_add(stmt_a->expr->mappings, mapping);
 	}
@@ -660,6 +661,7 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 			switch (stmt_a->expr->right->etype) {
 			case EXPR_SET:
 				list_for_each_entry(expr, &expr_set(stmt_a->expr->right)->expressions, list) {
+					assert(expr->etype == EXPR_SET_ELEM);
 					concat_clone = expr_clone(concat);
 					clone = expr_clone(expr->key);
 					concat_expr_add(concat_clone, clone);
@@ -771,6 +773,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 		break;
 	case EXPR_SET:
 		list_for_each_entry(item, &expr_set(expr)->expressions, list) {
+			assert(item->etype == EXPR_SET_ELEM);
 			mapping = mapping_expr_alloc(&internal_location, expr_get(item->key),
 						     expr_get(verdict->expr));
 
diff --git a/src/segtree.c b/src/segtree.c
index 6d96b4f8a0a9..90e4a616edf0 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -80,6 +80,8 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 	new_init = set_expr_alloc(&internal_location, NULL);
 
 	list_for_each_entry(i, &expr_set(init)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		switch (i->key->etype) {
 		case EXPR_VALUE:
 			set_elem_add(set, new_init, i->key->value,
@@ -137,6 +139,8 @@ static struct expr *get_set_interval_find(const struct set *cache_set,
 	mpz_init2(val, set->key->len);
 
 	list_for_each_entry(i, &expr_set(set->init)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		key = expr_value(i);
 		switch (key->etype) {
 		case EXPR_VALUE:
@@ -357,6 +361,8 @@ void concat_range_aggregate(struct expr *set)
 	mpz_t range, p;
 
 	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		if (!start) {
 			start = i;
 			continue;
-- 
2.47.3

