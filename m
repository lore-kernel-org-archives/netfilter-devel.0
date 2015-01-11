From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 6/6] netlink_delinearize: cleanup hard to read code
Date: Sun, 11 Jan 2015 08:09:42 +0000
Message-ID: <1420963782-21189-7-git-send-email-kaber@trash.net>
References: <1420963782-21189-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54802 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbbAKIJw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:09:52 -0500
In-Reply-To: <1420963782-21189-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The netlink parsing code is full of long function calls spawning multiple
lines and in some cases parses netlink attributes multiple times.

Use local variables for the registers and other data required to
reconstruct the expressions and statements and reorder the code in
some cases to move related processing next to each other.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_delinearize.c | 139 ++++++++++++++++++++++++++--------------------
 1 file changed, 79 insertions(+), 60 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5a89fce..27801be 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -143,19 +143,21 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 			      const struct nft_rule_expr *nle)
 {
 	struct nft_data_delinearize nld;
+	enum nft_registers sreg;
 	struct expr *expr, *left, *right;
 	struct stmt *stmt;
 	enum ops op;
 
-	nld.value = nft_rule_expr_get(nle, NFT_EXPR_CMP_DATA, &nld.len);
-	left = netlink_get_register(ctx, loc,
-			nft_rule_expr_get_u32(nle, NFT_EXPR_CMP_SREG));
+	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_CMP_SREG);
+	left = netlink_get_register(ctx, loc, sreg);
 	if (left == NULL)
 		return netlink_error(ctx, loc,
 				     "Relational expression has no left "
 				     "hand side");
 
 	op = netlink_parse_cmp_op(nle);
+
+	nld.value = nft_rule_expr_get(nle, NFT_EXPR_CMP_DATA, &nld.len);
 	right = netlink_alloc_value(loc, &nld);
 
 	// FIXME
@@ -173,23 +175,24 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
 				 const struct nft_rule_expr *nle)
 {
+	enum nft_registers sreg, dreg;
+	const char *name;
 	struct stmt *stmt;
 	struct expr *expr, *left, *right;
 	struct set *set;
-	enum nft_registers dreg;
 
-	left = netlink_get_register(ctx, loc,
-			nft_rule_expr_get_u32(nle, NFT_EXPR_LOOKUP_SREG));
+	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_LOOKUP_SREG);
+	left = netlink_get_register(ctx, loc, sreg);
 	if (left == NULL)
 		return netlink_error(ctx, loc,
 				     "Lookup expression has no left hand side");
 
-	set = set_lookup(ctx->table,
-			 nft_rule_expr_get_str(nle, NFT_EXPR_LOOKUP_SET));
+	name = nft_rule_expr_get_str(nle, NFT_EXPR_LOOKUP_SET);
+	set  = set_lookup(ctx->table, name);
 	if (set == NULL)
 		return netlink_error(ctx, loc,
 				     "Unknown set '%s' in lookup expression",
-				     nft_rule_expr_get_str(nle, NFT_EXPR_LOOKUP_SET));
+				     name);
 
 	right = set_ref_expr_alloc(loc, set);
 
@@ -210,12 +213,13 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nft_rule_expr *nle)
 {
+	struct nft_data_delinearize nld;
+	enum nft_registers sreg, dreg;
 	struct expr *expr, *left, *mask, *xor, *or;
 	mpz_t m, x, o;
-	struct nft_data_delinearize nld;
 
-	left = netlink_get_register(ctx, loc,
-			nft_rule_expr_get_u32(nle, NFT_EXPR_BITWISE_SREG));
+	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_BITWISE_SREG);
+	left = netlink_get_register(ctx, loc, sreg);
 	if (left == NULL)
 		return netlink_error(ctx, loc,
 				     "Bitwise expression has no left "
@@ -224,12 +228,10 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 	expr = left;
 
 	nld.value = nft_rule_expr_get(nle, NFT_EXPR_BITWISE_MASK, &nld.len);
-
 	mask = netlink_alloc_value(loc, &nld);
 	mpz_init_set(m, mask->value);
 
 	nld.value = nft_rule_expr_get(nle, NFT_EXPR_BITWISE_XOR, &nld.len);
-
 	xor  = netlink_alloc_value(loc, &nld);
 	mpz_init_set(x, xor->value);
 
@@ -272,20 +274,20 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 	mpz_clear(x);
 	mpz_clear(o);
 
-	netlink_set_register(ctx,
-			     nft_rule_expr_get_u32(nle, NFT_EXPR_BITWISE_DREG),
-			     expr);
+	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_BITWISE_DREG);
+	netlink_set_register(ctx, dreg, expr);
 }
 
 static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nft_rule_expr *nle)
 {
+	enum nft_registers sreg, dreg;
 	struct expr *expr, *arg;
 	enum ops op;
 
-	arg = netlink_get_register(ctx, loc,
-		nft_rule_expr_get_u32(nle, NFT_EXPR_BYTEORDER_SREG));
+	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_BYTEORDER_SREG);
+	arg = netlink_get_register(ctx, loc, sreg);
 	if (arg == NULL)
 		return netlink_error(ctx, loc,
 				     "Byteorder expression has no left "
@@ -305,68 +307,79 @@ static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 
 	expr = unary_expr_alloc(loc, op, arg);
 	expr->len = arg->len;
-	netlink_set_register(ctx,
-			     nft_rule_expr_get_u32(nle, NFT_EXPR_BYTEORDER_DREG),
-			     expr);
+
+	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_BYTEORDER_DREG);
+	netlink_set_register(ctx, dreg, expr);
 }
 
 static void netlink_parse_payload(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nft_rule_expr *nle)
 {
+	enum nft_registers dreg;
+	uint32_t base, offset, len;
 	struct expr *expr;
 
+	base   = nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_BASE) + 1;
+	offset = nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_OFFSET) * BITS_PER_BYTE;
+	len    = nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_LEN) * BITS_PER_BYTE;
+
 	expr = payload_expr_alloc(loc, NULL, 0);
-	payload_init_raw(expr, nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_BASE) + 1,
-			 nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_OFFSET) * BITS_PER_BYTE,
-			 nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_LEN) * BITS_PER_BYTE);
+	payload_init_raw(expr, base, offset, len);
 
-	netlink_set_register(ctx,
-			     nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_DREG),
-			     expr);
+	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_DREG);
+	netlink_set_register(ctx, dreg, expr);
 }
 
 static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
 				 const struct nft_rule_expr *nle)
 {
+	enum nft_registers dreg;
+	uint32_t offset, len;
+	uint8_t type;
 	struct expr *expr;
 
+	type   = nft_rule_expr_get_u8(nle, NFT_EXPR_EXTHDR_TYPE);
+	offset = nft_rule_expr_get_u32(nle, NFT_EXPR_EXTHDR_OFFSET) * BITS_PER_BYTE;
+	len    = nft_rule_expr_get_u32(nle, NFT_EXPR_EXTHDR_LEN) * BITS_PER_BYTE;
+
 	expr = exthdr_expr_alloc(loc, NULL, 0);
-	exthdr_init_raw(expr, nft_rule_expr_get_u8(nle, NFT_EXPR_EXTHDR_TYPE),
-			nft_rule_expr_get_u32(nle, NFT_EXPR_EXTHDR_OFFSET) * BITS_PER_BYTE,
-			nft_rule_expr_get_u32(nle, NFT_EXPR_EXTHDR_LEN) * BITS_PER_BYTE);
+	exthdr_init_raw(expr, type, offset, len);
 
-	netlink_set_register(ctx,
-			     nft_rule_expr_get_u32(nle, NFT_EXPR_EXTHDR_DREG),
-			     expr);
+	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_EXTHDR_DREG);
+	netlink_set_register(ctx, dreg, expr);
 }
 
 static void netlink_parse_meta_expr(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nft_rule_expr *nle)
 {
+	enum nft_registers dreg;
+	uint32_t key;
 	struct expr *expr;
 
-	expr = meta_expr_alloc(loc,
-			       nft_rule_expr_get_u32(nle, NFT_EXPR_META_KEY));
-	netlink_set_register(ctx,
-			     nft_rule_expr_get_u32(nle, NFT_EXPR_META_DREG),
-			     expr);
+	key  = nft_rule_expr_get_u32(nle, NFT_EXPR_META_KEY);
+	expr = meta_expr_alloc(loc, key);
+
+	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_META_DREG);
+	netlink_set_register(ctx, dreg, expr);
 }
 
 static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nft_rule_expr *nle)
 {
+	enum nft_registers sreg;
+	uint32_t key;
 	struct stmt *stmt;
 	struct expr *expr;
 
-	expr = netlink_get_register(ctx, loc,
-			nft_rule_expr_get_u32(nle, NFT_EXPR_META_SREG));
-	stmt = meta_stmt_alloc(loc,
-			       nft_rule_expr_get_u32(nle, NFT_EXPR_META_KEY),
-			       expr);
+	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_META_SREG);
+	expr = netlink_get_register(ctx, loc, sreg);
+
+	key  = nft_rule_expr_get_u32(nle, NFT_EXPR_META_KEY);
+	stmt = meta_stmt_alloc(loc, key, expr);
 	expr_set_type(expr, stmt->meta.tmpl->dtype, stmt->meta.tmpl->byteorder);
 
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
@@ -386,15 +399,16 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nft_rule_expr *nle)
 {
+	enum nft_registers sreg;
+	uint32_t key;
 	struct stmt *stmt;
 	struct expr *expr;
 
-	expr = netlink_get_register(ctx, loc,
-				    nft_rule_expr_get_u32(nle,
-							  NFT_EXPR_CT_SREG));
-	stmt = ct_stmt_alloc(loc,
-			     nft_rule_expr_get_u32(nle, NFT_EXPR_CT_KEY),
-			     expr);
+	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_CT_SREG);
+	expr = netlink_get_register(ctx, loc, sreg);
+
+	key  = nft_rule_expr_get_u32(nle, NFT_EXPR_CT_KEY);
+	stmt = ct_stmt_alloc(loc, key, expr);
 	expr_set_type(expr, stmt->ct.tmpl->dtype, stmt->ct.tmpl->byteorder);
 
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
@@ -404,12 +418,15 @@ static void netlink_parse_ct_expr(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nft_rule_expr *nle)
 {
+	enum nft_registers dreg;
+	uint32_t key;
 	struct expr *expr;
 
-	expr = ct_expr_alloc(loc, nft_rule_expr_get_u32(nle, NFT_EXPR_CT_KEY));
-	netlink_set_register(ctx,
-			     nft_rule_expr_get_u32(nle, NFT_EXPR_CT_DREG),
-			     expr);
+	key  = nft_rule_expr_get_u32(nle, NFT_EXPR_CT_KEY);
+	expr = ct_expr_alloc(loc, key);
+
+	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_CT_DREG);
+	netlink_set_register(ctx, dreg, expr);
 }
 
 static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
@@ -479,8 +496,8 @@ static void netlink_parse_limit(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 
 	stmt = limit_stmt_alloc(loc);
-	stmt->limit.rate  = nft_rule_expr_get_u64(nle, NFT_EXPR_LIMIT_RATE);
-	stmt->limit.unit  = nft_rule_expr_get_u64(nle, NFT_EXPR_LIMIT_UNIT);
+	stmt->limit.rate = nft_rule_expr_get_u64(nle, NFT_EXPR_LIMIT_RATE);
+	stmt->limit.unit = nft_rule_expr_get_u64(nle, NFT_EXPR_LIMIT_UNIT);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
@@ -587,12 +604,14 @@ static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
 			       const struct nft_rule_expr *nle)
 {
 	struct stmt *stmt;
+	uint32_t flags;
 
-	stmt = masq_stmt_alloc(loc);
-
+	flags = 0;
 	if (nft_rule_expr_is_set(nle, NFT_EXPR_MASQ_FLAGS))
-		stmt->masq.flags = nft_rule_expr_get_u32(nle,
-							 NFT_EXPR_MASQ_FLAGS);
+		flags = nft_rule_expr_get_u32(nle, NFT_EXPR_MASQ_FLAGS);
+
+	stmt = masq_stmt_alloc(loc);
+	stmt->masq.flags = flags;
 
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
-- 
2.1.0

