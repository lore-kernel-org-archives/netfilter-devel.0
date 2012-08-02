From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 4/4] expression: Differentiate expr among anonymous structures in struct expr
Date: Thu,  2 Aug 2012 13:31:35 +0300
Message-ID: <1343903495-14486-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1343903495-14486-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51950 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab2HBKbo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:31:44 -0400
In-Reply-To: <1343903495-14486-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/expression.h      |    4 ++--
 src/evaluate.c            |   20 ++++++++++----------
 src/expression.c          |   20 ++++++++++----------
 src/netlink_delinearize.c |    2 +-
 src/netlink_linearize.c   |    2 +-
 src/segtree.c             |    4 ++--
 6 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 8804284..7074bbe 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -195,7 +195,7 @@ struct expr {
 		};
 		struct {
 			/* EXPR_PREFIX */
-			struct expr		*expr;
+			struct expr		*prefix;
 			unsigned int		prefix_len;
 		};
 		struct {
@@ -219,7 +219,7 @@ struct expr {
 		};
 		struct {
 			/* EXPR_MAP */
-			struct expr		*expr;
+			struct expr		*map;
 			struct expr		*mappings;
 		};
 
diff --git a/src/evaluate.c b/src/evaluate.c
index a371c24..da3a0d4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -291,9 +291,9 @@ static int expr_evaluate_prefix(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *prefix = *expr, *base, *and, *mask;
 
-	if (expr_evaluate(ctx, &prefix->expr) < 0)
+	if (expr_evaluate(ctx, &prefix->prefix) < 0)
 		return -1;
-	base = prefix->expr;
+	base = prefix->prefix;
 
 	if (!expr_is_constant(base))
 		return expr_error(ctx, prefix,
@@ -317,10 +317,10 @@ static int expr_evaluate_prefix(struct eval_ctx *ctx, struct expr **expr)
 	mpz_prefixmask(mask->value, base->len, prefix->prefix_len);
 	and  = binop_expr_alloc(&prefix->location, OP_AND, base, mask);
 
-	prefix->expr = and;
-	if (expr_evaluate(ctx, &prefix->expr) < 0)
+	prefix->prefix = and;
+	if (expr_evaluate(ctx, &prefix->prefix) < 0)
 		return -1;
-	base = prefix->expr;
+	base = prefix->prefix;
 	assert(expr_is_constant(base));
 
 	prefix->dtype	  = base->dtype;
@@ -656,10 +656,10 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	struct expr_ctx ectx = ctx->ectx;
 	struct expr *map = *expr, *mappings;
 
-	if (expr_evaluate(ctx, &map->expr) < 0)
+	if (expr_evaluate(ctx, &map->map) < 0)
 		return -1;
-	if (expr_is_constant(map->expr))
-		return expr_error(ctx, map->expr,
+	if (expr_is_constant(map->map))
+		return expr_error(ctx, map->map,
 				  "Map expression can not be constant");
 
 	mappings = map->mappings;
@@ -695,7 +695,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 
 	/* Data for range lookups needs to be in big endian order */
 	if (map->mappings->set_flags & SET_F_INTERVAL &&
-	    byteorder_conversion(ctx, &map->expr, BYTEORDER_BIG_ENDIAN) < 0)
+	    byteorder_conversion(ctx, &map->map, BYTEORDER_BIG_ENDIAN) < 0)
 		return -1;
 
 	return 0;
@@ -895,7 +895,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		case EXPR_RANGE:
 			goto range;
 		case EXPR_PREFIX:
-			if (byteorder_conversion(ctx, &right->expr, left->byteorder) < 0)
+			if (byteorder_conversion(ctx, &right->prefix, left->byteorder) < 0)
 				return -1;
 			break;
 		case EXPR_VALUE:
diff --git a/src/expression.c b/src/expression.c
index dffe7a8..5dbc327 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -302,7 +302,7 @@ struct expr *constant_expr_splice(struct expr *expr, unsigned int len)
 
 static void prefix_expr_print(const struct expr *expr)
 {
-	expr_print(expr->expr);
+	expr_print(expr->prefix);
 	printf("/%u", expr->prefix_len);
 }
 
@@ -310,18 +310,18 @@ static void prefix_expr_set_type(const struct expr *expr,
 				 const struct datatype *type,
 				 enum byteorder byteorder)
 {
-	expr_set_type(expr->expr, type, byteorder);
+	expr_set_type(expr->prefix, type, byteorder);
 }
 
 static void prefix_expr_clone(struct expr *new, const struct expr *expr)
 {
-	new->expr       = expr_clone(expr->expr);
+	new->prefix     = expr_clone(expr->prefix);
 	new->prefix_len = expr->prefix_len;
 }
 
 static void prefix_expr_destroy(struct expr *expr)
 {
-	expr_free(expr->expr);
+	expr_free(expr->prefix);
 }
 
 static const struct expr_ops prefix_expr_ops = {
@@ -340,7 +340,7 @@ struct expr *prefix_expr_alloc(const struct location *loc,
 
 	prefix = expr_alloc(loc, &prefix_expr_ops, &invalid_type,
 			    BYTEORDER_INVALID, 0);
-	prefix->expr	   = expr;
+	prefix->prefix     = expr;
 	prefix->prefix_len = prefix_len;
 	return prefix;
 }
@@ -374,7 +374,7 @@ static void unary_expr_print(const struct expr *expr)
 
 static void unary_expr_clone(struct expr *new, const struct expr *expr)
 {
-	new->arg = expr_clone(expr->expr);
+	new->arg = expr_clone(expr->arg);
 }
 
 static void unary_expr_destroy(struct expr *expr)
@@ -680,20 +680,20 @@ struct expr *mapping_expr_alloc(const struct location *loc,
 
 static void map_expr_print(const struct expr *expr)
 {
-	expr_print(expr->expr);
+	expr_print(expr->map);
 	printf(" map ");
 	expr_print(expr->mappings);
 }
 
 static void map_expr_clone(struct expr *new, const struct expr *expr)
 {
-	new->expr     = expr_clone(expr->expr);
+	new->map      = expr_clone(expr->map);
 	new->mappings = expr_clone(expr->mappings);
 }
 
 static void map_expr_destroy(struct expr *expr)
 {
-	expr_free(expr->expr);
+	expr_free(expr->map);
 	expr_free(expr->mappings);
 }
 
@@ -711,7 +711,7 @@ struct expr *map_expr_alloc(const struct location *loc, struct expr *arg,
 	struct expr *expr;
 
 	expr = expr_alloc(loc, &map_expr_ops, &invalid_type, BYTEORDER_INVALID, 0);
-	expr->expr     = arg;
+	expr->map      = arg;
 	expr->mappings = mappings;
 	return expr;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d75df21..1963966 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -533,7 +533,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 
 	switch (expr->ops->type) {
 	case EXPR_MAP:
-		expr_postprocess(ctx, stmt, &expr->expr);
+		expr_postprocess(ctx, stmt, &expr->map);
 		expr_postprocess(ctx, stmt, &expr->mappings);
 		break;
 	case EXPR_MAPPING:
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index a3841fb..18315bd 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -114,7 +114,7 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 	else
 		sreg = dreg;
 
-	netlink_gen_expr(ctx, expr->expr, sreg);
+	netlink_gen_expr(ctx, expr->map, sreg);
 
 	nle = alloc_nft_expr(nfnl_nft_lookup_init);
 	nfnl_nft_lookup_set_sreg(nle, sreg);
diff --git a/src/segtree.c b/src/segtree.c
index 9e59bb6..fb404a4 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -240,7 +240,7 @@ static void range_low(mpz_t rop, struct expr *expr)
 	case EXPR_VALUE:
 		return mpz_set(rop, expr->value);
 	case EXPR_PREFIX:
-		return range_low(rop, expr->expr);
+		return range_low(rop, expr->prefix);
 	case EXPR_RANGE:
 		return range_low(rop, expr->left);
 	case EXPR_MAPPING:
@@ -258,7 +258,7 @@ static void range_high(mpz_t rop, const struct expr *expr)
 	case EXPR_VALUE:
 		return mpz_set(rop, expr->value);
 	case EXPR_PREFIX:
-		range_low(rop, expr->expr);
+		range_low(rop, expr->prefix);
 		mpz_init_bitmask(tmp, expr->len - expr->prefix_len);
 		mpz_add(rop, rop, tmp);
 		mpz_clear(tmp);
-- 
1.7.8.6

