Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B18D2F3C3A
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768221; cv=none; b=g8I9BjuShVT2ILLpesdIb4cRtGqHg0vI1SoYJniIfM0i511NJHvWkcWW2Z5oD18u4l1TeBjgn6HQaG5AGdciTbB4g/lC8cHe0/7VVQntlsve+O7YxstU7hWD8WGK+xSxP+yHe1n0SX+LHuO2s1VpuxtP6BbLStRHfKWg3tIaPX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768221; c=relaxed/simple;
	bh=03fRgcayuHiKPo9zvpfu1U48scjEKNyWXUlqjnlsNCU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mxKisucZAnmW+cbC4irgJvfEHJZfyk1F67OPiq0MiiAbf3kiQDk+qQ+msIZbyLiWnUO58BnsnRYtObocSAx1r8rZ5dSyO7EBU/vsKyWINHSV2uDTIEZ/Uu8FYG+51VzbOtK7Ux2ONaMgIq43DS4dtHoVZ3bOEZfpodK4CQzn1nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lkHA/7JC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lkHA/7JC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lkHA/7JC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lkHA/7JC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D64F9602AF; Thu, 21 Aug 2025 11:23:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768217;
	bh=iLXfpIFupeNsVWsdzjwI51+rbCk8DD1vaR6RksOgfzs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lkHA/7JCxPTKwiIK4JXcQJE5hsVYEOn3KzL1s8/eSM0jVZH2htgN6Epq6uzITCl4c
	 L3vom8+pxSK33xAA0rTHqBXmup2JQKYT522pjMEXFlklPXG/ed5YGP5VfH76fX9DOf
	 7SiqNs0HnoQ0/0LyUr8GIRW7YYd57w5UoGxal51iSApzG+SinlohfqX1XIeYwFqDDw
	 0ZvGLlYoFCZ14EKJXA8Y5slHz9kqXy4ScET1vzFKtcEnCEIgitHOQhjpofaF4J0ff+
	 PUPIBZo9wKqewW7iiOrxAVqv+H7TBPb1VibNBPx2RPgEVbRFfOV8wF/8YEPPpOpTLu
	 cTyDg3+4bHraA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1E38D602AB
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:23:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768217;
	bh=iLXfpIFupeNsVWsdzjwI51+rbCk8DD1vaR6RksOgfzs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lkHA/7JCxPTKwiIK4JXcQJE5hsVYEOn3KzL1s8/eSM0jVZH2htgN6Epq6uzITCl4c
	 L3vom8+pxSK33xAA0rTHqBXmup2JQKYT522pjMEXFlklPXG/ed5YGP5VfH76fX9DOf
	 7SiqNs0HnoQ0/0LyUr8GIRW7YYd57w5UoGxal51iSApzG+SinlohfqX1XIeYwFqDDw
	 0ZvGLlYoFCZ14EKJXA8Y5slHz9kqXy4ScET1vzFKtcEnCEIgitHOQhjpofaF4J0ff+
	 PUPIBZo9wKqewW7iiOrxAVqv+H7TBPb1VibNBPx2RPgEVbRFfOV8wF/8YEPPpOpTLu
	 cTyDg3+4bHraA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 02/11] src: replace compound_expr_add() by type safe set_expr_add()
Date: Thu, 21 Aug 2025 11:23:21 +0200
Message-Id: <20250821092330.2739989-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250821092330.2739989-1-pablo@netfilter.org>
References: <20250821092330.2739989-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace compound_expr_add() by set_expr_add() to validate type.

Add __set_expr_add() to skip size updates in src/intervals.c

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  3 +++
 src/expression.c     | 13 +++++++++++++
 src/intervals.c      |  8 ++++----
 src/monitor.c        |  2 +-
 src/netlink.c        |  2 +-
 src/optimize.c       | 20 ++++++++++----------
 src/parser_bison.y   |  8 ++++----
 src/parser_json.c    |  4 ++--
 src/payload.c        |  6 +++---
 src/segtree.c        | 20 ++++++++++----------
 10 files changed, 51 insertions(+), 35 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 2e0754edaaae..21be74068468 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -531,6 +531,9 @@ struct expr *list_expr_to_binop(struct expr *expr);
 
 extern struct expr *set_expr_alloc(const struct location *loc,
 				   const struct set *set);
+void __set_expr_add(struct expr *set, struct expr *elem);
+void set_expr_add(struct expr *set, struct expr *elem);
+
 extern void concat_range_aggregate(struct expr *set);
 extern void interval_map_decompose(struct expr *set);
 
diff --git a/src/expression.c b/src/expression.c
index 8cb639797284..32e101ea9070 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1392,6 +1392,19 @@ struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 	return set_expr;
 }
 
+void __set_expr_add(struct expr *set, struct expr *elem)
+{
+	list_add_tail(&elem->list, &expr_set(set)->expressions);
+}
+
+void set_expr_add(struct expr *set, struct expr *elem)
+{
+	struct expr_set *expr_set = expr_set(set);
+
+	list_add_tail(&elem->list, &expr_set->expressions);
+	expr_set->size++;
+}
+
 static void mapping_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	expr_print(expr->left, octx);
diff --git a/src/intervals.c b/src/intervals.c
index d5afffd2120a..a63c58ac9606 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -278,7 +278,7 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 			}
 			clone = expr_clone(i);
 			clone->flags |= EXPR_F_KERNEL;
-			list_add_tail(&clone->list, &expr_set(existing_set->init)->expressions);
+			__set_expr_add(existing_set->init, clone);
 		}
 	}
 
@@ -359,7 +359,7 @@ static void split_range(struct set *set, struct expr *prev, struct expr *i,
 	clone = expr_clone(prev);
 	mpz_set(clone->key->range.low, i->key->range.high);
 	mpz_add_ui(clone->key->range.low, i->key->range.high, 1);
-	list_add_tail(&clone->list, &expr_set(set->existing_set->init)->expressions);
+	__set_expr_add(set->existing_set->init, clone);
 
 	mpz_set(prev->key->range.high, i->key->range.low);
 	mpz_sub_ui(prev->key->range.high, i->key->range.low, 1);
@@ -527,7 +527,7 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	list_for_each_entry(i, &expr_set(existing_set->init)->expressions, list) {
 		if (!(i->flags & EXPR_F_KERNEL)) {
 			clone = expr_clone(i);
-			list_add_tail(&clone->list, &expr_set(add)->expressions);
+			__set_expr_add(add, clone);
 			i->flags |= EXPR_F_KERNEL;
 		}
 	}
@@ -646,7 +646,7 @@ int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 		else if (existing_set) {
 			clone = expr_clone(i);
 			clone->flags |= EXPR_F_KERNEL;
-			list_add_tail(&clone->list, &expr_set(existing_set->init)->expressions);
+			__set_expr_add(existing_set->init, clone);
 		}
 	}
 
diff --git a/src/monitor.c b/src/monitor.c
index da1ad880f0c8..e58f62252ca2 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -400,7 +400,7 @@ static bool netlink_event_range_cache(struct set *cached_set,
 
 	/* if cache exists, dummyset must contain the other end of the range */
 	if (cached_set->rg_cache) {
-		compound_expr_add(dummyset->init, cached_set->rg_cache);
+		set_expr_add(dummyset->init, cached_set->rg_cache);
 		cached_set->rg_cache = NULL;
 		goto out_decompose;
 	}
diff --git a/src/netlink.c b/src/netlink.c
index 94cbcbfc6c09..30dd6c9b4f0d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1591,7 +1591,7 @@ key_end:
 		expr = mapping_expr_alloc(&netlink_location, expr, data);
 	}
 out:
-	compound_expr_add(set->init, expr);
+	set_expr_add(set->init, expr);
 
 	if (!(flags & NFT_SET_ELEM_INTERVAL_END) &&
 	    nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_KEY_END)) {
diff --git a/src/optimize.c b/src/optimize.c
index 40756cecbbc3..b2fd9e829f00 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -569,13 +569,13 @@ static void merge_expr_stmts(const struct optimize_ctx *ctx,
 
 	expr_a = stmt_a->expr->right;
 	elem = set_elem_expr_alloc(&internal_location, expr_get(expr_a));
-	compound_expr_add(set, elem);
+	set_expr_add(set, elem);
 
 	for (i = from + 1; i <= to; i++) {
 		stmt_b = ctx->stmt_matrix[i][merge->stmt[0]];
 		expr_b = stmt_b->expr->right;
 		elem = set_elem_expr_alloc(&internal_location, expr_get(expr_b));
-		compound_expr_add(set, elem);
+		set_expr_add(set, elem);
 	}
 
 	expr_free(stmt_a->expr->right);
@@ -590,7 +590,7 @@ static void merge_vmap(const struct optimize_ctx *ctx,
 	mappings = stmt_b->expr->mappings;
 	list_for_each_entry(expr, &expr_set(mappings)->expressions, list) {
 		mapping = expr_clone(expr);
-		compound_expr_add(stmt_a->expr->mappings, mapping);
+		set_expr_add(stmt_a->expr->mappings, mapping);
 	}
 }
 
@@ -702,7 +702,7 @@ static void __merge_concat_stmts(const struct optimize_ctx *ctx, uint32_t i,
 	list_for_each_entry_safe(concat, next, &concat_list, list) {
 		list_del(&concat->list);
 		elem = set_elem_expr_alloc(&internal_location, concat);
-		compound_expr_add(set, elem);
+		set_expr_add(set, elem);
 	}
 }
 
@@ -759,7 +759,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 
 			mapping = mapping_expr_alloc(&internal_location, elem,
 						     expr_get(verdict->expr));
-			compound_expr_add(set, mapping);
+			set_expr_add(set, mapping);
 		}
 		stmt_free(counter);
 		break;
@@ -773,7 +773,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 
 			mapping = mapping_expr_alloc(&internal_location, elem,
 						     expr_get(verdict->expr));
-			compound_expr_add(set, mapping);
+			set_expr_add(set, mapping);
 		}
 		stmt_free(counter);
 		break;
@@ -790,7 +790,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 
 		mapping = mapping_expr_alloc(&internal_location, elem,
 					     expr_get(verdict->expr));
-		compound_expr_add(set, mapping);
+		set_expr_add(set, mapping);
 		break;
 	default:
 		assert(0);
@@ -898,7 +898,7 @@ static void __merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 
 		mapping = mapping_expr_alloc(&internal_location, elem,
 					     expr_get(verdict->expr));
-		compound_expr_add(set, mapping);
+		set_expr_add(set, mapping);
 	}
 	stmt_free(counter);
 }
@@ -1061,7 +1061,7 @@ static void merge_nat(const struct optimize_ctx *ctx,
 
 		elem = set_elem_expr_alloc(&internal_location, expr_get(expr));
 		mapping = mapping_expr_alloc(&internal_location, elem, nat_expr);
-		compound_expr_add(set, mapping);
+		set_expr_add(set, mapping);
 	}
 
 	stmt = ctx->stmt_matrix[from][merge->stmt[0]];
@@ -1118,7 +1118,7 @@ static void merge_concat_nat(const struct optimize_ctx *ctx,
 
 		elem = set_elem_expr_alloc(&internal_location, concat);
 		mapping = mapping_expr_alloc(&internal_location, elem, nat_expr);
-		compound_expr_add(set, mapping);
+		set_expr_add(set, mapping);
 	}
 
 	concat = concat_expr_alloc(&internal_location);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1e4b3f8a50c5..aab1cc675234 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3276,11 +3276,11 @@ verdict_map_expr	:	'{'	verdict_map_list_expr	'}'
 verdict_map_list_expr	:	verdict_map_list_member_expr
 			{
 				$$ = set_expr_alloc(&@$, NULL);
-				compound_expr_add($$, $1);
+				set_expr_add($$, $1);
 			}
 			|	verdict_map_list_expr	COMMA	verdict_map_list_member_expr
 			{
-				compound_expr_add($1, $3);
+				set_expr_add($1, $3);
 				$$ = $1;
 			}
 			|	verdict_map_list_expr	COMMA	opt_newline
@@ -4533,11 +4533,11 @@ set_expr		:	'{'	set_list_expr		'}'
 set_list_expr		:	set_list_member_expr
 			{
 				$$ = set_expr_alloc(&@$, NULL);
-				compound_expr_add($$, $1);
+				set_expr_add($$, $1);
 			}
 			|	set_list_expr		COMMA	set_list_member_expr
 			{
-				compound_expr_add($1, $3);
+				set_expr_add($1, $3);
 				$$ = $1;
 			}
 			|	set_list_expr		COMMA	opt_newline
diff --git a/src/parser_json.c b/src/parser_json.c
index 71e44f19c9f1..1a37246ef7f6 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1454,7 +1454,7 @@ static struct expr *json_parse_set_expr(struct json_ctx *ctx,
 
 		expr = set_elem_expr_alloc(int_loc, expr);
 		set_expr = set_expr_alloc(int_loc, NULL);
-		compound_expr_add(set_expr, expr);
+		set_expr_add(set_expr, expr);
 		return set_expr;
 	}
 
@@ -1498,7 +1498,7 @@ static struct expr *json_parse_set_expr(struct json_ctx *ctx,
 
 		if (!set_expr)
 			set_expr = set_expr_alloc(int_loc, NULL);
-		compound_expr_add(set_expr, expr);
+		set_expr_add(set_expr, expr);
 	}
 	return set_expr;
 }
diff --git a/src/payload.c b/src/payload.c
index a38f5bf730d1..162367eb7fd0 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -1534,13 +1534,13 @@ __payload_gen_icmp_echo_dependency(struct eval_ctx *ctx, const struct expr *expr
 				    BYTEORDER_BIG_ENDIAN, BITS_PER_BYTE,
 				    constant_data_ptr(echo, BITS_PER_BYTE));
 	right = set_elem_expr_alloc(&expr->location, right);
-	compound_expr_add(set, right);
+	set_expr_add(set, right);
 
 	right = constant_expr_alloc(&expr->location, icmp_type,
 				    BYTEORDER_BIG_ENDIAN, BITS_PER_BYTE,
 				    constant_data_ptr(reply, BITS_PER_BYTE));
 	right = set_elem_expr_alloc(&expr->location, right);
-	compound_expr_add(set, right);
+	set_expr_add(set, right);
 
 	dep = relational_expr_alloc(&expr->location, OP_IMPLICIT, left, set);
 	return expr_stmt_alloc(&dep->location, dep);
@@ -1571,7 +1571,7 @@ __payload_gen_icmp6_addr_dependency(struct eval_ctx *ctx, const struct expr *exp
 					    constant_data_ptr(icmp_addr_types[i],
 							      BITS_PER_BYTE));
 		right = set_elem_expr_alloc(&expr->location, right);
-		compound_expr_add(set, right);
+		set_expr_add(set, right);
 	}
 
 	dep = relational_expr_alloc(&expr->location, OP_IMPLICIT, left, set);
diff --git a/src/segtree.c b/src/segtree.c
index 607f002f181e..9395b5388507 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -64,7 +64,7 @@ static void set_elem_add(const struct set *set, struct expr *init, mpz_t value,
 	expr = set_elem_expr_alloc(&internal_location, expr);
 	expr->flags = flags;
 
-	compound_expr_add(init, expr);
+	set_expr_add(init, expr);
 }
 
 struct expr *get_set_intervals(const struct set *set, const struct expr *init)
@@ -86,12 +86,12 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 				     i->flags, byteorder);
 			break;
 		case EXPR_CONCAT:
-			compound_expr_add(new_init, expr_clone(i));
+			set_expr_add(new_init, expr_clone(i));
 			i->flags |= EXPR_F_INTERVAL_END;
-			compound_expr_add(new_init, expr_clone(i));
+			set_expr_add(new_init, expr_clone(i));
 			break;
 		case EXPR_SET_ELEM_CATCHALL:
-			compound_expr_add(new_init, expr_clone(i));
+			set_expr_add(new_init, expr_clone(i));
 			break;
 		default:
 			range_expr_value_low(low, i);
@@ -214,16 +214,16 @@ static void set_compound_expr_add(struct expr *compound, struct expr *expr, stru
 	switch (expr->etype) {
 	case EXPR_SET_ELEM:
 		list_splice_init(&orig->stmt_list, &expr->stmt_list);
-		compound_expr_add(compound, expr);
+		set_expr_add(compound, expr);
 		break;
 	case EXPR_MAPPING:
 		list_splice_init(&orig->left->stmt_list, &expr->left->stmt_list);
-		compound_expr_add(compound, expr);
+		set_expr_add(compound, expr);
 		break;
 	default:
 		elem = set_elem_expr_alloc(&orig->location, expr);
 		list_splice_init(&orig->stmt_list, &elem->stmt_list);
-		compound_expr_add(compound, elem);
+		set_expr_add(compound, elem);
 		break;
 	}
 }
@@ -551,7 +551,7 @@ add_interval(struct expr *set, struct expr *low, struct expr *i)
 	} else
 		expr = interval_to_range(low, i, range);
 
-	compound_expr_add(set, expr);
+	set_expr_add(set, expr);
 
 	mpz_clear(range);
 	mpz_clear(p);
@@ -645,7 +645,7 @@ void interval_map_decompose(struct expr *set)
 	mpz_bitmask(i->value, i->len);
 
 	if (!mpz_cmp(i->value, expr_value(low)->value)) {
-		compound_expr_add(set, low);
+		set_expr_add(set, low);
 	} else {
 		add_interval(set, low, i);
 		expr_free(low);
@@ -656,7 +656,7 @@ void interval_map_decompose(struct expr *set)
 out:
 	if (catchall) {
 		catchall->flags |= EXPR_F_KERNEL;
-		compound_expr_add(set, catchall);
+		set_expr_add(set, catchall);
 	}
 
 	free(ranges);
-- 
2.30.2

