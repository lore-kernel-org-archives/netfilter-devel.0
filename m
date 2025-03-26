Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4F1254849
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 20:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743020613; cv=none; b=R/SgkbbXICLhoUdai/wXBprEOCUY6NFjpT3i7NbZBdhdV558mdoI7b5rTGyEDJkL52FD7AOwK6QR9MLssnGt+teCTbV3s0rTslkEpsdnTDXERQKovU9Aao59rectK8YdrQLlq2NMOTzgBx9sPIicYLndmYLjUO4JsRmiOHb9rR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743020613; c=relaxed/simple;
	bh=s1Fjlf9+7ky3L2KMVD76f7kbFGev+C9kb0e41IhJJj0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WSkzPFukFyDbk9fdHbcZWzp4Bt+CP4U5mPrTZcOeGDBTUzEnsVFdbGGA1SUG5HAqqi5zaimcgL1f1CjDdesvCKbYD73O3Xy93NP8OQQIsbFbHSjYGzQSjdZXT/tciNB4zpvZrgQDxEo81CXKwr170pPufn9B8F/UHRR18gxj1lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ju/jutB5; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ju/jutB5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ju/jutB5";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ju/jutB5"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EF472607B2; Wed, 26 Mar 2025 21:23:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743020603;
	bh=lHWkHM9LG/De0jprCx09eykwuTgB1QlAz7/TCwxjC58=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ju/jutB5FjBIbqGJ97EmrHbM24yvHKbneWHZbIpBrVRcR0PR+9FPMMHthQJA+34IO
	 bmBj7QPiF7I9FGusGA7qLjw3AnKCXv1SNLjafSIxPxV0N6IU9pd2xy2glQCUD395WW
	 Xb2139jKT492fFLb0NNS8ZhcH+l/xRmsl0mfTWRS24FXRUCI5pOr+saTv5q4uH9ff8
	 DB/2p8LY1ISEF4HFw/3aLEjnOZsE4Ctk+Y7weyjbSFQZM5ylHs/1spLpVqeBg+O+Mr
	 CxMxFsdr2/YRUhVJ8ymD6XPzOiCdaKMxGI8ZGqF/wZorCByQLnf+mm5xjDFRuhnmya
	 T9zI8PQ6kxcQQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 42B9E606B5
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 21:23:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743020603;
	bh=lHWkHM9LG/De0jprCx09eykwuTgB1QlAz7/TCwxjC58=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ju/jutB5FjBIbqGJ97EmrHbM24yvHKbneWHZbIpBrVRcR0PR+9FPMMHthQJA+34IO
	 bmBj7QPiF7I9FGusGA7qLjw3AnKCXv1SNLjafSIxPxV0N6IU9pd2xy2glQCUD395WW
	 Xb2139jKT492fFLb0NNS8ZhcH+l/xRmsl0mfTWRS24FXRUCI5pOr+saTv5q4uH9ff8
	 DB/2p8LY1ISEF4HFw/3aLEjnOZsE4Ctk+Y7weyjbSFQZM5ylHs/1spLpVqeBg+O+Mr
	 CxMxFsdr2/YRUhVJ8ymD6XPzOiCdaKMxGI8ZGqF/wZorCByQLnf+mm5xjDFRuhnmya
	 T9zI8PQ6kxcQQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/4] src: remove flagcmp expression
Date: Wed, 26 Mar 2025 21:23:03 +0100
Message-Id: <20250326202303.20396-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250326202303.20396-1-pablo@netfilter.org>
References: <20250326202303.20396-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This expression is not used anymore, since:

 ("src: transform flag match expression to binop expression from parser")

remove it.

This completes the revert of c3d57114f119 ("parser_bison: add shortcut
syntax for matching flags without binary operations"), except the parser
chunk for backwards compatibility.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h | 14 +----------
 include/json.h       |  2 --
 src/evaluate.c       | 21 -----------------
 src/expression.c     | 56 --------------------------------------------
 src/json.c           | 14 -----------
 5 files changed, 1 insertion(+), 106 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 818d7a7dc74b..8399fae88d78 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -47,7 +47,6 @@
  * @EXPR_FIB		forward information base expression
  * @EXPR_XFRM		XFRM (ipsec) expression
  * @EXPR_SET_ELEM_CATCHALL catchall element expression
- * @EXPR_FLAGCMP	flagcmp expression
  * @EXPR_RANGE_VALUE	constant range expression
  * @EXPR_RANGE_SYMBOL	unparse symbol range expression
  */
@@ -81,11 +80,10 @@ enum expr_types {
 	EXPR_FIB,
 	EXPR_XFRM,
 	EXPR_SET_ELEM_CATCHALL,
-	EXPR_FLAGCMP,
 	EXPR_RANGE_VALUE,
 	EXPR_RANGE_SYMBOL,
 
-	EXPR_MAX = EXPR_FLAGCMP
+	EXPR_MAX = EXPR_SET_ELEM_CATCHALL
 };
 
 enum ops {
@@ -402,12 +400,6 @@ struct expr {
 			uint8_t			ttl;
 			uint32_t		flags;
 		} osf;
-		struct {
-			/* EXPR_FLAGCMP */
-			struct expr		*expr;
-			struct expr		*mask;
-			struct expr		*value;
-		} flagcmp;
 	};
 };
 
@@ -544,10 +536,6 @@ extern struct expr *set_elem_expr_alloc(const struct location *loc,
 
 struct expr *set_elem_catchall_expr_alloc(const struct location *loc);
 
-struct expr *flagcmp_expr_alloc(const struct location *loc, enum ops op,
-				struct expr *expr, struct expr *mask,
-				struct expr *value);
-
 extern void range_expr_value_low(mpz_t rop, const struct expr *expr);
 extern void range_expr_value_high(mpz_t rop, const struct expr *expr);
 void range_expr_swap_values(struct expr *range);
diff --git a/include/json.h b/include/json.h
index 0670b8714519..b61eeafe8d7e 100644
--- a/include/json.h
+++ b/include/json.h
@@ -29,7 +29,6 @@ struct list_head;
 
 json_t *binop_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *relational_expr_json(const struct expr *expr, struct output_ctx *octx);
-json_t *flagcmp_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *range_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *meta_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *payload_expr_json(const struct expr *expr, struct output_ctx *octx);
@@ -137,7 +136,6 @@ static inline json_t *name##_json(arg1_t arg1, arg2_t arg2) { return NULL; }
 	JSON_PRINT_STUB(name##_stmt, const struct stmt *, struct output_ctx *)
 
 EXPR_PRINT_STUB(binop_expr)
-EXPR_PRINT_STUB(flagcmp_expr)
 EXPR_PRINT_STUB(relational_expr)
 EXPR_PRINT_STUB(range_expr)
 EXPR_PRINT_STUB(meta_expr)
diff --git a/src/evaluate.c b/src/evaluate.c
index a27961193da5..8a61dcc4a4e9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2977,25 +2977,6 @@ static int expr_evaluate_xfrm(struct eval_ctx *ctx, struct expr **exprp)
 	return expr_evaluate_primary(ctx, exprp);
 }
 
-static int expr_evaluate_flagcmp(struct eval_ctx *ctx, struct expr **exprp)
-{
-	struct expr *expr = *exprp, *binop, *rel;
-
-	if (expr->op != OP_EQ &&
-	    expr->op != OP_NEQ)
-		return expr_error(ctx->msgs, expr, "either == or != is allowed");
-
-	binop = binop_expr_alloc(&expr->location, OP_AND,
-				 expr_get(expr->flagcmp.expr),
-				 expr_get(expr->flagcmp.mask));
-	rel = relational_expr_alloc(&expr->location, expr->op, binop,
-				    expr_get(expr->flagcmp.value));
-	expr_free(expr);
-	*exprp = rel;
-
-	return expr_evaluate(ctx, exprp);
-}
-
 static int verdict_validate_chainlen(struct eval_ctx *ctx,
 				     struct expr *chain)
 {
@@ -3095,8 +3076,6 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_xfrm(ctx, expr);
 	case EXPR_SET_ELEM_CATCHALL:
 		return expr_evaluate_set_elem_catchall(ctx, expr);
-	case EXPR_FLAGCMP:
-		return expr_evaluate_flagcmp(ctx, expr);
 	case EXPR_RANGE_SYMBOL:
 		return expr_evaluate_symbol_range(ctx, expr);
 	default:
diff --git a/src/expression.c b/src/expression.c
index 2a30d5af92a4..fdf9fb97daac 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1680,61 +1680,6 @@ struct expr *set_elem_catchall_expr_alloc(const struct location *loc)
 	return expr;
 }
 
-static void flagcmp_expr_print(const struct expr *expr, struct output_ctx *octx)
-{
-	expr_print(expr->flagcmp.expr, octx);
-
-	if (expr->op == OP_NEQ)
-		nft_print(octx, " != ");
-	else
-		nft_print(octx, " ");
-
-	expr_print(expr->flagcmp.value, octx);
-	nft_print(octx, " / ");
-	expr_print(expr->flagcmp.mask, octx);
-}
-
-static void flagcmp_expr_clone(struct expr *new, const struct expr *expr)
-{
-	new->flagcmp.expr = expr_clone(expr->flagcmp.expr);
-	new->flagcmp.mask = expr_clone(expr->flagcmp.mask);
-	new->flagcmp.value = expr_clone(expr->flagcmp.value);
-}
-
-static void flagcmp_expr_destroy(struct expr *expr)
-{
-	expr_free(expr->flagcmp.expr);
-	expr_free(expr->flagcmp.mask);
-	expr_free(expr->flagcmp.value);
-}
-
-static const struct expr_ops flagcmp_expr_ops = {
-	.type		= EXPR_FLAGCMP,
-	.name		= "flags comparison",
-	.print		= flagcmp_expr_print,
-	.json		= flagcmp_expr_json,
-	.clone		= flagcmp_expr_clone,
-	.destroy	= flagcmp_expr_destroy,
-};
-
-struct expr *flagcmp_expr_alloc(const struct location *loc, enum ops op,
-				struct expr *match, struct expr *mask,
-				struct expr *value)
-{
-	struct expr *expr;
-
-	expr = expr_alloc(loc, EXPR_FLAGCMP, match->dtype, match->byteorder,
-			  match->len);
-	expr->op = op;
-	expr->flagcmp.expr = match;
-	expr->flagcmp.mask = mask;
-	/* json output needs this operation for compatibility */
-	expr->flagcmp.mask->op = OP_OR;
-	expr->flagcmp.value = value;
-
-	return expr;
-}
-
 void range_expr_value_low(mpz_t rop, const struct expr *expr)
 {
 	switch (expr->etype) {
@@ -1814,7 +1759,6 @@ static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
 	case EXPR_FIB: return &fib_expr_ops;
 	case EXPR_XFRM: return &xfrm_expr_ops;
 	case EXPR_SET_ELEM_CATCHALL: return &set_elem_catchall_expr_ops;
-	case EXPR_FLAGCMP: return &flagcmp_expr_ops;
 	case EXPR_RANGE_VALUE: return &constant_range_expr_ops;
 	case EXPR_RANGE_SYMBOL: return &symbol_range_expr_ops;
 	}
diff --git a/src/json.c b/src/json.c
index 96413d70895a..d15e7017b892 100644
--- a/src/json.c
+++ b/src/json.c
@@ -547,20 +547,6 @@ static json_t *table_print_json(const struct table *table)
 	return json_pack("{s:o}", "table", root);
 }
 
-json_t *flagcmp_expr_json(const struct expr *expr, struct output_ctx *octx)
-{
-	json_t *left;
-
-	left = json_pack("{s:[o, o]}", expr_op_symbols[OP_AND],
-			 expr_print_json(expr->flagcmp.expr, octx),
-			 expr_print_json(expr->flagcmp.mask, octx));
-
-	return json_pack("{s:{s:s, s:o, s:o}}", "match",
-			 "op", expr_op_symbols[expr->op] ? : "in",
-			 "left", left,
-			 "right", expr_print_json(expr->flagcmp.value, octx));
-}
-
 static json_t *
 __binop_expr_json(int op, const struct expr *expr, struct output_ctx *octx)
 {
-- 
2.30.2

