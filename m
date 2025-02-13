Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A07203703
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Feb 2025 20:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477010; cv=none; b=AtmumndiIaz1B4rRZK0aFgZB29/u3ZrrQ/MeagiF9R4ez3Y/PJKNaDccb4PUOU1lyotM+Pqsz7TMQzJWjxvTjLn/RR3dHDoZWOrjnrmKpVutMaCEHw7UBcao7Dh1aRmQf7v0jGLtLnP6GYLFifMbtPoPlAx+aHxzFf5O38cb/EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477010; c=relaxed/simple;
	bh=AyLf9Qbwjb5QpCz357MdTf/vDbiC6MhAUcprBc2XK88=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=YDX9WTRFR3mBjsHh6/E3SvtC4zMsiGyrCavVL+kuLh3v0MJeu0lYH17k1RORn4efoCTbr06xHZBZ7WJQJQkGyEWWr6+yMSBIleaK4iour7D+JqCiHuPh3mIq+MShJCHGiJEpxrtUEMo6Hlq8oIbi6MhrAbgpGJxnv66EERybqao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n4TV57AH; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n4TV57AH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n4TV57AH";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n4TV57AH"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D667D605E1; Thu, 13 Feb 2025 21:03:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739477003;
	bh=+p0BLOCfUNTfwRyj9cdCOvtnPjC7dgAQSvYgmev0Z4s=;
	h=From:To:Subject:Date:From;
	b=n4TV57AHVe3LpyEsSVgUBSGJp8zlazSvcV0dIXBABruzBUzeWmTzRwC7jcGOj3BMX
	 1I8ZPclwhq7zO7q55RLhvvsWfh9pPbbRfTRT1DuWV2X5vtHFL498VUNoFEZenvkB5+
	 RoN7KQ+CuAfxWdSYv/pJFZY3fTKnAIdMNY9Y3D/7kDNm1k536wXxoXxJFLKIwgDeil
	 5JGbwOq2ecdpGLjdlEk2P6c+66Y3/X5Tf0SKkSLcGe4a7JSd8IWW0wr5IJvzeVfe9k
	 dYtv+zgle5/wtev3cba2arMp8n114NtBwWzZD0HE8UHNUj8A0ZaTd71Fce+P0JtHl+
	 HPQCDx97NJFIA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 381A9605DF
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Feb 2025 21:03:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739477003;
	bh=+p0BLOCfUNTfwRyj9cdCOvtnPjC7dgAQSvYgmev0Z4s=;
	h=From:To:Subject:Date:From;
	b=n4TV57AHVe3LpyEsSVgUBSGJp8zlazSvcV0dIXBABruzBUzeWmTzRwC7jcGOj3BMX
	 1I8ZPclwhq7zO7q55RLhvvsWfh9pPbbRfTRT1DuWV2X5vtHFL498VUNoFEZenvkB5+
	 RoN7KQ+CuAfxWdSYv/pJFZY3fTKnAIdMNY9Y3D/7kDNm1k536wXxoXxJFLKIwgDeil
	 5JGbwOq2ecdpGLjdlEk2P6c+66Y3/X5Tf0SKkSLcGe4a7JSd8IWW0wr5IJvzeVfe9k
	 dYtv+zgle5/wtev3cba2arMp8n114NtBwWzZD0HE8UHNUj8A0ZaTd71Fce+P0JtHl+
	 HPQCDx97NJFIA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: add symbol range expression to further compact intervals
Date: Thu, 13 Feb 2025 21:03:18 +0100
Message-Id: <20250213200318.245342-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update parser to use a new symbol range expression with smaller memory
footprint than range expression + two symbol expressions.

The evaluation step translates this into EXPR_RANGE_VALUE from the
evaluation step for interval sets.

Note that maps or concatenations still use the less compact range
expressions representation, those requires more work to use this new
symbol range expression. The parser also uses the classic range
expression if variables are used.

Testing with a 100k intervals, worst case scenario: no prefix or
singleton elements, show a reduction from 49.58 Mbytes to 35.47 Mbytes
for 100k intervals (-29.56% memory footprint for this case).

This follow up work to previous commits:

 91dc281a82ea ("src: rework singleton interval transformation to reduce memory consumption")
 c9ee9032b0ee ("src: add EXPR_RANGE_VALUE expression and use it")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h | 13 ++++++++++--
 src/evaluate.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++
 src/expression.c     | 45 ++++++++++++++++++++++++++++++++++++++++++
 src/optimize.c       |  3 +++
 src/parser_bison.y   | 11 ++++++++++-
 5 files changed, 116 insertions(+), 3 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index f2b45250872d..8472748621ef 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -49,6 +49,7 @@
  * @EXPR_SET_ELEM_CATCHALL catchall element expression
  * @EXPR_FLAGCMP	flagcmp expression
  * @EXPR_RANGE_VALUE	constant range expression
+ * @EXPR_RANGE_SYMBOL	unparse symbol range expression
  */
 enum expr_types {
 	EXPR_INVALID,
@@ -82,6 +83,7 @@ enum expr_types {
 	EXPR_SET_ELEM_CATCHALL,
 	EXPR_FLAGCMP,
 	EXPR_RANGE_VALUE,
+	EXPR_RANGE_SYMBOL,
 
 	EXPR_MAX = EXPR_FLAGCMP
 };
@@ -261,9 +263,12 @@ struct expr {
 
 	union {
 		struct {
-			/* EXPR_SYMBOL */
+			/* EXPR_SYMBOL, EXPR_RANGE_SYMBOL */
 			const struct scope	*scope;
-			const char		*identifier;
+			union {
+				const char	*identifier;
+				const char	*identifier_range[2];
+			};
 			enum symbol_types	symtype;
 		};
 		struct {
@@ -486,6 +491,10 @@ extern struct expr *constant_range_expr_alloc(const struct location *loc,
 					      unsigned int len,
 					      mpz_t low, mpz_t high);
 
+struct expr *symbol_range_expr_alloc(const struct location *loc,
+				     enum symbol_types type, const struct scope *scope,
+				     const char *identifier_low, const char *identifier_high);
+
 extern struct expr *flag_expr_alloc(const struct location *loc,
 				    const struct datatype *dtype,
 				    enum byteorder byteorder,
diff --git a/src/evaluate.c b/src/evaluate.c
index 692401888d9f..812505868dd1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2319,6 +2319,51 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *left, *right, *range;
+	struct expr *expr = *exprp;
+
+	left = symbol_expr_alloc(&expr->location, expr->symtype, (struct scope *)expr->scope, expr->identifier_range[0]);
+	if (expr_evaluate_symbol(ctx, &left) < 0) {
+		expr_free(left);
+		return -1;
+	}
+
+	right = symbol_expr_alloc(&expr->location, expr->symtype, (struct scope *)expr->scope, expr->identifier_range[1]);
+	if (expr_evaluate_symbol(ctx, &right) < 0) {
+		expr_free(left);
+		expr_free(right);
+		return -1;
+	}
+
+	/* concatenation and maps need more work to use constant_range_expr. */
+	if (ctx->set && !set_is_map(ctx->set->flags) &&
+	    set_is_non_concat_range(ctx->set) &&
+	    left->etype == EXPR_VALUE &&
+	    right->etype == EXPR_VALUE) {
+		range = constant_range_expr_alloc(&expr->location, left->dtype,
+						  left->byteorder,
+						  left->len,
+						  left->value,
+						  right->value);
+		expr_free(left);
+		expr_free(right);
+		expr_free(expr);
+		*exprp = range;
+		return 0;
+	}
+
+	range = range_expr_alloc(&expr->location, left, right);
+	expr_free(expr);
+	*exprp = range;
+
+	if (expr_evaluate(ctx, &range) < 0)
+		return -1;
+
+	return 0;
+}
+
 /* We got datatype context via statement. If the basetype is compatible, set
  * this expression datatype to the one of the statement to make it datatype
  * compatible. This is a more conservative approach than enabling datatype
@@ -3027,6 +3072,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_set_elem_catchall(ctx, expr);
 	case EXPR_FLAGCMP:
 		return expr_evaluate_flagcmp(ctx, expr);
+	case EXPR_RANGE_SYMBOL:
+		return expr_evaluate_symbol_range(ctx, expr);
 	default:
 		BUG("unknown expression type %s\n", expr_name(*expr));
 	}
diff --git a/src/expression.c b/src/expression.c
index b98b3d960a50..53d4c521ae18 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -620,6 +620,50 @@ struct expr *constant_range_expr_alloc(const struct location *loc,
 	return expr;
 }
 
+static void symbol_range_expr_print(const struct expr *expr, struct output_ctx *octx)
+{
+	nft_print(octx, "%s", expr->identifier_range[0]);
+	nft_print(octx, "-");
+	nft_print(octx, "%s", expr->identifier_range[1]);
+}
+
+static void symbol_range_expr_clone(struct expr *new, const struct expr *expr)
+{
+	new->symtype	= expr->symtype;
+	new->scope      = expr->scope;
+	new->identifier_range[0] = xstrdup(expr->identifier_range[0]);
+	new->identifier_range[1] = xstrdup(expr->identifier_range[1]);
+}
+
+static void symbol_range_expr_destroy(struct expr *expr)
+{
+	free_const(expr->identifier_range[0]);
+	free_const(expr->identifier_range[1]);
+}
+
+static const struct expr_ops symbol_range_expr_ops = {
+	.type		= EXPR_RANGE_SYMBOL,
+	.name		= "range_symbol",
+	.print		= symbol_range_expr_print,
+	.clone		= symbol_range_expr_clone,
+	.destroy	= symbol_range_expr_destroy,
+};
+
+struct expr *symbol_range_expr_alloc(const struct location *loc,
+				     enum symbol_types type, const struct scope *scope,
+				     const char *identifier_low, const char *identifier_high)
+{
+	struct expr *expr;
+
+	expr = expr_alloc(loc, EXPR_RANGE_SYMBOL, &invalid_type,
+			  BYTEORDER_INVALID, 0);
+	expr->symtype	 = type;
+	expr->scope	 = scope;
+	expr->identifier_range[0] = xstrdup(identifier_low);
+	expr->identifier_range[1] = xstrdup(identifier_high);
+	return expr;
+}
+
 /*
  * Allocate a constant expression with a single bit set at position n.
  */
@@ -1699,6 +1743,7 @@ static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
 	case EXPR_SET_ELEM_CATCHALL: return &set_elem_catchall_expr_ops;
 	case EXPR_FLAGCMP: return &flagcmp_expr_ops;
 	case EXPR_RANGE_VALUE: return &constant_range_expr_ops;
+	case EXPR_RANGE_SYMBOL: return &symbol_range_expr_ops;
 	}
 
 	return NULL;
diff --git a/src/optimize.c b/src/optimize.c
index 03c8bad234e2..230fe4a23de3 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -139,6 +139,7 @@ static bool stmt_expr_supported(const struct expr *expr)
 {
 	switch (expr->right->etype) {
 	case EXPR_SYMBOL:
+	case EXPR_RANGE_SYMBOL:
 	case EXPR_RANGE:
 	case EXPR_PREFIX:
 	case EXPR_SET:
@@ -630,6 +631,7 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 			case EXPR_SYMBOL:
 			case EXPR_VALUE:
 			case EXPR_PREFIX:
+			case EXPR_RANGE_SYMBOL:
 			case EXPR_RANGE:
 				clone = expr_clone(stmt_a->expr->right);
 				compound_expr_add(concat, clone);
@@ -730,6 +732,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 		stmt_free(counter);
 		break;
 	case EXPR_PREFIX:
+	case EXPR_RANGE_SYMBOL:
 	case EXPR_RANGE:
 	case EXPR_VALUE:
 	case EXPR_SYMBOL:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d15bf212489d..1aaccc00369c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4462,7 +4462,16 @@ prefix_rhs_expr		:	basic_rhs_expr	SLASH	NUM
 
 range_rhs_expr		:	basic_rhs_expr	DASH	basic_rhs_expr
 			{
-				$$ = range_expr_alloc(&@$, $1, $3);
+				if ($1->etype == EXPR_SYMBOL &&
+				    $1->symtype == SYMBOL_VALUE &&
+				    $3->etype == EXPR_SYMBOL &&
+				    $3->symtype == SYMBOL_VALUE) {
+					$$ = symbol_range_expr_alloc(&@$, $1->symtype, $1->scope, $1->identifier, $3->identifier);
+					expr_free($1);
+					expr_free($3);
+				} else {
+					$$ = range_expr_alloc(&@$, $1, $3);
+				}
 			}
 			;
 
-- 
2.30.2

