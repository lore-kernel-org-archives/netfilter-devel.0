Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8C737C109
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087132; cv=none; b=ZqHJnXKFiwgRChUjyfrl8U+ob3lsxuPjRiFuFrXfuH02EHlQIFjyhpqt9/GwwCNZPJtsp8ROxRGHgNxRqgXQ92M7fuSAWclmbvde8LJjgYqfDEVieGqi2J0Rf5C3+goladcmWEZbcije3dguosssOXsP4CjChRuQqa0uqKm5bOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087132; c=relaxed/simple;
	bh=hJI8brG2QB7jaO+o0PFbhjH2Y79+3FVz7wG/oy7SWcw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ing18CiDk5pJy1uiaWdy5WpoonpaLvYZ4ZZvZNUu/a1IrVu2BcYEH1S0IT6W9E8bFt/fsI/GrVx2z3CA3PgjbrPktDHNyHQFJw/QFGwFDNw0lmuw6srle/baCTI6flIp9FHFDkrBWU+cNz2MfbG/YPnL9r2f31hDIkibfSgC35w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=O89/gD84; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vQhzA0QZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="O89/gD84";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vQhzA0QZ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E0CD1608D8; Fri,  5 Sep 2025 17:36:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086598;
	bh=xZp2HClDTIecofEJLkr+WhbqNJWV2q8QrV19NX9T3mk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=O89/gD84mBmv56040gXxo9em9QDtEs/jxk2QJKOfq20xkdQQnq4Z86LyY4Iv0gvs1
	 vEo6A1ik2asEpkPSBnwJ3jte/6HEJi3u/iu9CSl98m9ktpTFlHUp39ds/HLeea2wmm
	 hLct0Rmo6jCT/+yx60ynUkTAjkVJOmFzbzf5UhI/V/k4f/qsKy7pYq76Zf2KqFdqxJ
	 p1uBcx63FVSmhAlmTMUT4yYxRkf/xHWIVtr5hiZorwzs6XSq2OipdDxfBvHzXvf+ya
	 DSGpYe2yZKBiTqITb4aRSCfV3/vppBuc/GNDkhDkX527WjTcEpyLbwbPBDdh/l9+0F
	 wnDvxiG8QKldg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 712E2608CC
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 17:36:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086597;
	bh=xZp2HClDTIecofEJLkr+WhbqNJWV2q8QrV19NX9T3mk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vQhzA0QZ6fvYWKa0UghfnOD2yXe8/8UQV0D8ElTznzfjMaFVxPbt0UUQM8Blkn8QD
	 XkHMUKTCbMVlSSziqrmgHOxiGSFJxm4Vlfc/0SRsmuJD6xUfcg7grtMMoVkPbA4UFg
	 qzaQ1lvfGha6kAKzIKZh2EWqRn49Jxhx+SWBivE2nbviVqUY3raYxH9/Qb5ul4Lbke
	 qxxrh7082hLIBzSnsLmidM9LJ9+XnwU75wqr56mTBIp9SUGnscIDxXNaEUNd3+qyHf
	 eiUIes8nKn02c7i5YgvbnhunNjrv7nmmKjjPQwpRYAC6C+n2iZA5jAPSQ7JW4YRquZ
	 WJgtYsltuEw1Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/7] src: assert on EXPR_SET only contains EXPR_SET_ELEM in the expressions list
Date: Fri,  5 Sep 2025 17:36:23 +0200
Message-Id: <20250905153627.1315405-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250905153627.1315405-1-pablo@netfilter.org>
References: <20250905153627.1315405-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normalize the representation so the expressions list in EXPR_SET always
contains EXPR_SET_ELEM. Add assert() to validate this.

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
index b0a3e990e476..0b7508a18ede 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2069,6 +2069,8 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			struct expr *new, *j;
 
 			list_for_each_entry(j, &expr_set(i->key->left)->expressions, list) {
+				assert(j->etype == EXPR_SET_ELEM);
+
 				new = mapping_expr_alloc(&i->location,
 							 expr_get(j->key),
 							 expr_get(i->key->right));
@@ -2770,9 +2772,9 @@ static void optimize_singleton_set(struct expr *rel, struct expr **expr)
 	struct expr *set = rel->right, *i;
 
 	i = list_first_entry(&expr_set(set)->expressions, struct expr, list);
-	if (i->etype == EXPR_SET_ELEM &&
-	    list_empty(&i->stmt_list)) {
+	assert (i->etype == EXPR_SET_ELEM);
 
+	if (list_empty(&i->stmt_list)) {
 		switch (i->key->etype) {
 		case EXPR_PREFIX:
 		case EXPR_RANGE:
@@ -5476,19 +5478,12 @@ static struct expr *expr_set_to_list(struct eval_ctx *ctx, struct expr *dev_expr
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
-			BUG("invalid expression type %s\n", expr_name(expr));
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
index 8b54b6a38ae5..68e2fec192b2 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -941,8 +941,9 @@ void relational_expr_pctx_update(struct proto_ctx *ctx,
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
@@ -1378,6 +1379,8 @@ static void set_expr_print(const struct expr *expr, struct output_ctx *octx)
 	nft_print(octx, "{ ");
 
 	list_for_each_entry(i, &expr_set(expr)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
+
 		nft_print(octx, "%s", d);
 		expr_print(i, octx);
 		count++;
@@ -1400,8 +1403,10 @@ static void set_expr_destroy(struct expr *expr)
 {
 	struct expr *i, *next;
 
-	list_for_each_entry_safe(i, next, &expr_set(expr)->expressions, list)
+	list_for_each_entry_safe(i, next, &expr_set(expr)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
 		expr_free(i);
+	}
 }
 
 static void set_expr_set_type(const struct expr *expr,
@@ -1410,8 +1415,11 @@ static void set_expr_set_type(const struct expr *expr,
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
index 7df5ce2ab4db..3ac45cf29abd 100644
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
index 36c03e581b4a..612e8e6999eb 100644
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
@@ -763,8 +766,11 @@ json_t *set_expr_json(const struct expr *expr, struct output_ctx *octx)
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
index 10817e5cfb53..7a17f394c69f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1219,6 +1219,8 @@ void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
 	const struct expr *expr;
 
 	list_for_each_entry(expr, &expr_set(set)->expressions, list) {
+		assert(expr->etype == EXPR_SET_ELEM);
+
 		nlse = alloc_nftnl_setelem(set, expr);
 		nftnl_set_elem_add(nls, nlse);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f4ebdfcbf2f3..3db5502910ad 100644
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
@@ -2882,8 +2882,11 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		expr_postprocess(ctx, &expr->right);
 		break;
 	case EXPR_SET:
-		list_for_each_entry(i, &expr_set(expr)->expressions, list)
+		list_for_each_entry(i, &expr_set(expr)->expressions, list) {
+			assert(i->etype == EXPR_SET);
+
 			expr_postprocess(ctx, &i);
+		}
 		break;
 	case EXPR_CONCAT:
 		expr_postprocess_concat(ctx, exprp);
diff --git a/src/optimize.c b/src/optimize.c
index 422990d1ca6f..e537f48adf58 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -589,6 +589,7 @@ static void merge_vmap(const struct optimize_ctx *ctx,
 
 	mappings = stmt_b->expr->mappings;
 	list_for_each_entry(expr, &expr_set(mappings)->expressions, list) {
+		assert(expr->etype == EXPR_SET_ELEM);
 		mapping = expr_clone(expr);
 		set_expr_add(stmt_a->expr->mappings, mapping);
 	}
@@ -655,6 +656,7 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 			switch (stmt_a->expr->right->etype) {
 			case EXPR_SET:
 				list_for_each_entry(expr, &expr_set(stmt_a->expr->right)->expressions, list) {
+					assert(expr->etype == EXPR_SET_ELEM);
 					concat_clone = expr_clone(concat);
 					clone = expr_clone(expr->key);
 					concat_expr_add(concat_clone, clone);
@@ -766,6 +768,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 		break;
 	case EXPR_SET:
 		list_for_each_entry(item, &expr_set(expr)->expressions, list) {
+			assert(item->etype == EXPR_SET_ELEM);
 			mapping = mapping_expr_alloc(&internal_location, expr_get(item->key),
 						     expr_get(verdict->expr));
 
diff --git a/src/segtree.c b/src/segtree.c
index b5be0005d1ea..f95a7ce1c8a8 100644
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
2.30.2

