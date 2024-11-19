Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4ECD13B780
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 12:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732019540; cv=none; b=ClxyT1mXeUDtqwaiFwAEPJVOzvn27J6HwCzFNULRGkaWWnowaoG8l4i5/pY908qgcOS43z1ij/sMmL/pCMLkIIzIysL2HIiYNLN9b/GYZZaonjSWjemqVwjpceFA10vHGpEglj2KbXtWVJn/ui04OPR9SiEnRaaw0adc5xV5joM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732019540; c=relaxed/simple;
	bh=tDFTZGMuSsvdO0g4f+//rG6zALXUJEUAh9Cz58gq+Sc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AcYJmNWFDddAc080yC6gOcxqtvODDlYLaFwFiEd8HPC9wLbFp206Cl2i4jTYXjaqydQsQyd+cOpAovKdEPCpIK4ob92Fa4E/PekTvO/OMkFIyK5n9jT+uF8dJwfAf4gK0xn90ElpAuozwv81ZwkM+al8+xA7qyqnkvUe3MmpxDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH nft] src: allow binop expressions with variable right-hand operands
Date: Tue, 19 Nov 2024 13:31:58 +0100
Message-Id: <20241119123158.185298-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

Hitherto, the kernel has required constant values for the `xor` and
`mask` attributes of boolean bitwise expressions.  This has meant that
the right-hand operand of a boolean binop must be constant.  Now the
kernel has support for AND, OR and XOR operations with right-hand
operands passed via registers, we can relax this restriction.  Allow
non-constant right-hand operands if the left-hand operand is not
constant, e.g.:

  ct mark & 0xffff0000 | meta mark & 0xffff

The kernel now supports performing AND, OR and XOR operations directly,
on one register and an immediate value or on two registers, so we need
to be able to generate and parse bitwise boolean expressions of this
form.

If a boolean operation has a constant RHS, we continue to send a
mask-and-xor expression to the kernel.

Add tests for {ct,meta} mark with variable RHS operands.

JSON support is also included.

This requires Linux kernel >= 6.13-rc.

[ Originally posted as patch 1/8 and 6/8 which has been collapsed and
  simplified to focus on initial {ct,meta} mark support. Tests have
  been extracted from 8/8 including a tests/py fix to payload output
  due to incorrect output in original patchset. JSON support has been
  extracted from patch 7/8 --pablo]

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Only {ct,meta} mark statement support at this stage so kernel space
support for multiregister bitwise gains a users.

I took the freedom to collapse several patches for easier git
annotate/blame later on, just a personal taste decision, original series
was already very good. So any bug in this patch is likely of mine.

This includes a few subtle/small fixes in the original series:

- Swap left and right hand sides if constant is on the lhs of the binary op.
  e.g. ct mark set 0x1 | meta mark
- Incorrect bytecode in ct.t.payload which is coming from a fix already
  in nftables v1.1.1.

@@ -50,8 +50,8 @@ ip6 test-ip6 output
   [ ct load mark => reg 1 ]
   [ payload load 2b @ network header + 0 => reg 2 ]
   [ bitwise reg 2 = ( reg 2 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 2 = ntoh(reg 2, 2, 2) ]
   [ bitwise reg 2 = ( reg 2 >> 0x00000006 ) ]
-  [ byteorder reg 2 = ntoh(reg 2, 2, 1) ]
   [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xfffffdff ) ^ 0x00000200 ]
   [ ct set mark with reg 1 ]

payload statement, including {ip,ip6} dscp, will be posted as a different
patch/series recovering Jeremy's work, this is also important.

 include/linux/netfilter/nf_tables.h           | 19 +++++-
 src/evaluate.c                                | 52 ++++++++++-----
 src/netlink_delinearize.c                     | 64 ++++++++++++++-----
 src/netlink_linearize.c                       | 61 +++++++++++++++---
 src/parser_json.c                             |  4 +-
 tests/py/any/ct.t                             |  3 +
 tests/py/any/ct.t.json                        | 60 +++++++++++++++++
 tests/py/any/ct.t.payload                     | 15 +++++
 tests/py/inet/meta.t                          |  2 +
 tests/py/inet/meta.t.json                     | 37 +++++++++++
 tests/py/inet/meta.t.payload                  |  9 +++
 tests/py/ip/ct.t                              |  2 +
 tests/py/ip/ct.t.json                         | 32 ++++++++++
 tests/py/ip/ct.t.payload                      | 11 ++++
 tests/py/ip6/ct.t                             |  1 +
 tests/py/ip6/ct.t.json                        | 32 ++++++++++
 tests/py/ip6/ct.t.payload                     | 12 ++++
 .../shell/testcases/bitwise/0040mark_binop_10 | 11 ++++
 .../shell/testcases/bitwise/0040mark_binop_11 | 11 ++++
 .../shell/testcases/bitwise/0040mark_binop_12 | 11 ++++
 .../shell/testcases/bitwise/0040mark_binop_13 | 11 ++++
 .../testcases/bitwise/0044payload_binop_2     | 11 ++++
 .../testcases/bitwise/0044payload_binop_5     | 11 ++++
 .../bitwise/dumps/0040mark_binop_10.nft       |  6 ++
 .../bitwise/dumps/0040mark_binop_11.nft       |  6 ++
 .../bitwise/dumps/0040mark_binop_12.nft       |  6 ++
 .../bitwise/dumps/0040mark_binop_13.nft       |  6 ++
 .../bitwise/dumps/0044payload_binop_2.nft     |  6 ++
 .../bitwise/dumps/0044payload_binop_5.nft     |  6 ++
 29 files changed, 472 insertions(+), 46 deletions(-)
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_10
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_11
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_12
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_13
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_2
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_5
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_10.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_11.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_12.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_13.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_2.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_5.nft

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c62e6ac56398..f57963e89fd1 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -557,16 +557,27 @@ enum nft_immediate_attributes {
 /**
  * enum nft_bitwise_ops - nf_tables bitwise operations
  *
- * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
- *                    XOR boolean operations
+ * @NFT_BITWISE_MASK_XOR: mask-and-xor operation used to implement NOT, AND, OR
+ *                        and XOR boolean operations
  * @NFT_BITWISE_LSHIFT: left-shift operation
  * @NFT_BITWISE_RSHIFT: right-shift operation
+ * @NFT_BITWISE_AND: and operation
+ * @NFT_BITWISE_OR: or operation
+ * @NFT_BITWISE_XOR: xor operation
  */
 enum nft_bitwise_ops {
-	NFT_BITWISE_BOOL,
+	NFT_BITWISE_MASK_XOR,
 	NFT_BITWISE_LSHIFT,
 	NFT_BITWISE_RSHIFT,
+	NFT_BITWISE_AND,
+	NFT_BITWISE_OR,
+	NFT_BITWISE_XOR,
 };
+/*
+ * Old name for NFT_BITWISE_MASK_XOR, predating the addition of NFT_BITWISE_AND,
+ * NFT_BITWISE_OR and NFT_BITWISE_XOR.  Retained for backwards-compatibility.
+ */
+#define NFT_BITWISE_BOOL NFT_BITWISE_MASK_XOR
 
 /**
  * enum nft_bitwise_attributes - nf_tables bitwise expression netlink attributes
@@ -579,6 +590,7 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_SREG2: second source register (NLA_U32: nft_registers)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -602,6 +614,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
+	NFTA_BITWISE_SREG2,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/src/evaluate.c b/src/evaluate.c
index 593a0140e92a..cd3619a2517c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1487,16 +1487,18 @@ static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 	op->byteorder = byteorder;
 	op->len	      = max_len;
 
-	if (expr_is_constant(left))
+	if (expr_is_constant(left) && expr_is_constant(op->right))
 		return constant_binop_simplify(ctx, expr);
 	return 0;
 }
 
 /*
- * Binop expression: both sides must be of integer base type. The left
- * hand side may be either constant or non-constant; in case its constant
- * it must be a singleton. The ride hand side must always be a constant
- * singleton.
+ * Binop expression: both sides must be of integer base type. The left-hand side
+ * may be either constant or non-constant; if it is constant, it must be a
+ * singleton.  For bitwise operations, the right-hand side must be constant if
+ * the left-hand side is constant; the right-hand side may be constant or
+ * non-constant, if the left-hand side is non-constant; for shifts, the
+ * right-hand side must be constant; if it is constant, it must be a singleton.
  */
 static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 {
@@ -1527,6 +1529,13 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 	right = op->right;
 
+	/* evaluation expects constant to the right hand side. */
+	if (expr_is_constant(left) && !expr_is_constant(right)) {
+		range_expr_swap_values(op);
+		left = op->left;
+		right = op->right;
+	}
+
 	switch (expr_basetype(left)->type) {
 	case TYPE_INTEGER:
 	case TYPE_STRING:
@@ -1544,17 +1553,6 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 					 "for %s expressions",
 					 sym, expr_name(left));
 
-	if (!expr_is_constant(right))
-		return expr_binary_error(ctx->msgs, right, op,
-					 "Right hand side of binary operation "
-					 "(%s) must be constant", sym);
-
-	if (!expr_is_singleton(right))
-		return expr_binary_error(ctx->msgs, left, op,
-					 "Binary operation (%s) is undefined "
-					 "for %s expressions",
-					 sym, expr_name(right));
-
 	if (!datatype_equal(expr_basetype(left), expr_basetype(right)))
 		return expr_binary_error(ctx->msgs, left, op,
 					 "Binary operation (%s) with different base types "
@@ -1564,11 +1562,33 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	switch (op->op) {
 	case OP_LSHIFT:
 	case OP_RSHIFT:
+		if (!expr_is_constant(right))
+			return expr_binary_error(ctx->msgs, right, op,
+						 "Right hand side of binary operation "
+						 "(%s) must be constant", sym);
+
+		if (!expr_is_singleton(right))
+			return expr_binary_error(ctx->msgs, left, op,
+						 "Binary operation (%s) is undefined "
+						 "for %s expressions",
+						 sym, expr_name(right));
+
 		ret = expr_evaluate_shift(ctx, expr);
 		break;
 	case OP_AND:
 	case OP_XOR:
 	case OP_OR:
+		if (expr_is_constant(left) && !expr_is_constant(right))
+			return expr_binary_error(ctx->msgs, right, op,
+						 "Right hand side of binary operation "
+						 "(%s) must be constant", sym);
+
+		if (expr_is_constant(right) && !expr_is_singleton(right))
+			return expr_binary_error(ctx->msgs, left, op,
+						 "Binary operation (%s) is undefined "
+						 "for %s expressions",
+						 sym, expr_name(right));
+
 		ret = expr_evaluate_bitwise(ctx, expr);
 		break;
 	default:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e3d9cfbbede5..db8b6bbe13e8 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -455,12 +455,12 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	ctx->stmt = expr_stmt_alloc(loc, expr);
 }
 
-static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
-					       const struct location *loc,
-					       const struct nftnl_expr *nle,
-					       enum nft_registers sreg,
-					       struct expr *left)
-
+static struct expr *
+netlink_parse_bitwise_mask_xor(struct netlink_parse_ctx *ctx,
+			       const struct location *loc,
+			       const struct nftnl_expr *nle,
+			       enum nft_registers sreg,
+			       struct expr *left)
 {
 	struct nft_data_delinearize nld;
 	struct expr *expr, *mask, *xor, *or;
@@ -520,10 +520,39 @@ static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
 	return expr;
 }
 
+static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
+					       const struct location *loc,
+					       const struct nftnl_expr *nle,
+					       enum nft_bitwise_ops op,
+					       enum nft_registers sreg,
+					       struct expr *left)
+{
+	enum nft_registers sreg2;
+	struct expr *right, *expr;
+
+	sreg2 = netlink_parse_register(nle, NFTNL_EXPR_BITWISE_SREG2);
+	right = netlink_get_register(ctx, loc, sreg2);
+	if (right == NULL) {
+		netlink_error(ctx, loc,
+			      "Bitwise expression has no right-hand expression");
+		return NULL;
+	}
+
+	expr = binop_expr_alloc(loc,
+				op == NFT_BITWISE_XOR ? OP_XOR :
+				op == NFT_BITWISE_AND ? OP_AND : OP_OR,
+				left, right);
+
+	if (left->len > 0)
+		expr->len = left->len;
+
+	return expr;
+}
+
 static struct expr *netlink_parse_bitwise_shift(struct netlink_parse_ctx *ctx,
 						const struct location *loc,
 						const struct nftnl_expr *nle,
-						enum ops op,
+						enum nft_bitwise_ops op,
 						enum nft_registers sreg,
 						struct expr *left)
 {
@@ -534,7 +563,9 @@ static struct expr *netlink_parse_bitwise_shift(struct netlink_parse_ctx *ctx,
 	right = netlink_alloc_value(loc, &nld);
 	right->byteorder = BYTEORDER_HOST_ENDIAN;
 
-	expr = binop_expr_alloc(loc, op, left, right);
+	expr = binop_expr_alloc(loc,
+				op == NFT_BITWISE_LSHIFT ? OP_LSHIFT : OP_RSHIFT,
+				left, right);
 	expr->len = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_LEN) * BITS_PER_BYTE;
 
 	return expr;
@@ -558,16 +589,19 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 	op = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_OP);
 
 	switch (op) {
-	case NFT_BITWISE_BOOL:
-		expr = netlink_parse_bitwise_bool(ctx, loc, nle, sreg,
-						  left);
+	case NFT_BITWISE_MASK_XOR:
+		expr = netlink_parse_bitwise_mask_xor(ctx, loc, nle, sreg,
+						      left);
 		break;
-	case NFT_BITWISE_LSHIFT:
-		expr = netlink_parse_bitwise_shift(ctx, loc, nle, OP_LSHIFT,
-						   sreg, left);
+	case NFT_BITWISE_XOR:
+	case NFT_BITWISE_AND:
+	case NFT_BITWISE_OR:
+		expr = netlink_parse_bitwise_bool(ctx, loc, nle, op,
+						  sreg, left);
 		break;
+	case NFT_BITWISE_LSHIFT:
 	case NFT_BITWISE_RSHIFT:
-		expr = netlink_parse_bitwise_shift(ctx, loc, nle, OP_RSHIFT,
+		expr = netlink_parse_bitwise_shift(ctx, loc, nle, op,
 						   sreg, left);
 		break;
 	default:
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 77bc51493293..42310115f02e 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -664,9 +664,9 @@ static void combine_binop(mpz_t mask, mpz_t xor, const mpz_t m, const mpz_t x)
 	mpz_and(mask, mask, m);
 }
 
-static void netlink_gen_shift(struct netlink_linearize_ctx *ctx,
-			      const struct expr *expr,
-			      enum nft_registers dreg)
+static void netlink_gen_bitwise_shift(struct netlink_linearize_ctx *ctx,
+				      const struct expr *expr,
+				      enum nft_registers dreg)
 {
 	enum nft_bitwise_ops op = expr->op == OP_LSHIFT ?
 		NFT_BITWISE_LSHIFT : NFT_BITWISE_RSHIFT;
@@ -691,9 +691,9 @@ static void netlink_gen_shift(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
-static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
-				const struct expr *expr,
-				enum nft_registers dreg)
+static void netlink_gen_bitwise_mask_xor(struct netlink_linearize_ctx *ctx,
+					 const struct expr *expr,
+					 enum nft_registers dreg)
 {
 	struct expr *binops[NFT_MAX_EXPR_RECURSION];
 	struct nftnl_expr *nle;
@@ -709,7 +709,7 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 	mpz_init(tmp);
 
 	binops[n++] = left = (struct expr *) expr;
-	while (left->etype == EXPR_BINOP && left->left != NULL &&
+	while (left->etype == EXPR_BINOP && left->left != NULL && expr_is_constant(left->right) &&
 	       (left->op == OP_AND || left->op == OP_OR || left->op == OP_XOR)) {
 		if (n == array_size(binops))
 			BUG("NFT_MAX_EXPR_RECURSION limit reached");
@@ -747,7 +747,7 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("bitwise");
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, dreg);
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, dreg);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_BOOL);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_MASK_XOR);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
 
 	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
@@ -763,6 +763,44 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
+static void netlink_gen_bitwise_bool(struct netlink_linearize_ctx *ctx,
+				     const struct expr *expr,
+				     enum nft_registers dreg)
+{
+	enum nft_registers sreg2;
+	struct nftnl_expr *nle;
+	unsigned int len;
+
+	nle = alloc_nft_expr("bitwise");
+
+	switch (expr->op) {
+	case OP_XOR:
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_XOR);
+		break;
+	case OP_AND:
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_AND);
+		break;
+	case OP_OR:
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_OR);
+		break;
+	default:
+		BUG("invalid binary operation %u\n", expr->op);
+	}
+
+	netlink_gen_expr(ctx, expr->left, dreg);
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, dreg);
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, dreg);
+
+	sreg2 = get_register(ctx, expr->right);
+	netlink_gen_expr(ctx, expr->right, sreg2);
+	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG2, sreg2);
+
+	len = div_round_up(expr->len, BITS_PER_BYTE);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 			      const struct expr *expr,
 			      enum nft_registers dreg)
@@ -770,10 +808,13 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 	switch(expr->op) {
 	case OP_LSHIFT:
 	case OP_RSHIFT:
-		netlink_gen_shift(ctx, expr, dreg);
+		netlink_gen_bitwise_shift(ctx, expr, dreg);
 		break;
 	default:
-		netlink_gen_bitwise(ctx, expr, dreg);
+		if (expr_is_constant(expr->right))
+			netlink_gen_bitwise_mask_xor(ctx, expr, dreg);
+		else
+			netlink_gen_bitwise_bool(ctx, expr, dreg);
 		break;
 	}
 }
diff --git a/src/parser_json.c b/src/parser_json.c
index bae2c3c099e9..5ac5f0270d32 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1557,12 +1557,12 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		{ "ip option", json_parse_ip_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
 		{ "sctp chunk", json_parse_sctp_chunk_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
 		{ "dccp option", json_parse_dccp_option_expr, CTX_F_PRIMARY },
-		{ "meta", json_parse_meta_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
+		{ "meta", json_parse_meta_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "osf", json_parse_osf_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_MAP | CTX_F_CONCAT },
 		{ "ipsec", json_parse_xfrm_expr, CTX_F_PRIMARY | CTX_F_MAP | CTX_F_CONCAT },
 		{ "socket", json_parse_socket_expr, CTX_F_PRIMARY | CTX_F_CONCAT },
 		{ "rt", json_parse_rt_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
-		{ "ct", json_parse_ct_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
+		{ "ct", json_parse_ct_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "numgen", json_parse_numgen_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		/* below two are hash expr */
 		{ "jhash", json_parse_hash_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index f73fa4e7aedb..0059e49c1188 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -40,7 +40,9 @@ ct mark and 0x23 == 0x11;ok;ct mark & 0x00000023 == 0x00000011
 ct mark and 0x3 != 0x1;ok;ct mark & 0x00000003 != 0x00000001
 ct mark xor 0x23 == 0x11;ok;ct mark 0x00000032
 ct mark xor 0x3 != 0x1;ok;ct mark != 0x00000002
+
 ct mark set ct mark or 0x00000001;ok;ct mark set ct mark | 0x00000001
+ct mark set 0x00000001 or ct mark;ok;ct mark set ct mark | 0x00000001
 
 ct mark 0x00000032;ok
 ct mark != 0x00000032;ok
@@ -61,6 +63,7 @@ ct mark set 0x11;ok;ct mark set 0x00000011
 ct mark set mark;ok;ct mark set meta mark
 ct mark set (meta mark | 0x10) << 8;ok;ct mark set (meta mark | 0x00000010) << 8
 ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 };ok;ct mark set meta mark map { 0x00000003 : 0x0000001e, 0x00000002 : 0x00000014, 0x00000001 : 0x0000000a}
+ct mark set ct mark and 0xffff0000 or meta mark and 0xffff;ok;ct mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
 
 ct mark set {0x11333, 0x11};fail
 ct zone set {123, 127};fail
diff --git a/tests/py/any/ct.t.json b/tests/py/any/ct.t.json
index a2a06025992c..ef3500008ca6 100644
--- a/tests/py/any/ct.t.json
+++ b/tests/py/any/ct.t.json
@@ -560,6 +560,29 @@
     }
 ]
 
+# ct mark set 0x00000001 or ct mark
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "ct": {
+                            "key": "mark"
+                        }
+                    },
+                    1
+                ]
+            }
+        }
+    }
+]
+
 # ct mark 0x00000032
 [
     {
@@ -817,6 +840,43 @@
     }
 ]
 
+# ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "&": [
+                            {
+                                "ct": {
+                                    "key": "mark"
+                                }
+                            },
+                            4294901760
+                        ]
+                    },
+                    {
+                        "&": [
+                            {
+                                "meta": {
+                                    "key": "mark"
+                                }
+                            },
+                            65535
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
 # ct expiration 30s
 [
     {
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index ed868e53277d..14385cf7ead2 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -336,6 +336,15 @@ ip test-ip4 output
   [ lookup reg 1 set __map%d dreg 1 ]
   [ ct set mark with reg 1 ]
 
+# ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+ip
+  [ ct load mark => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000ffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ ct set mark with reg 1 ]
+
 # ct original bytes > 100000
 ip test-ip4 output
   [ ct load bytes => reg 1 , dir original ]
@@ -497,6 +506,12 @@ ip test-ip4 output
   [ bitwise reg 1 = ( reg 1 & 0xfffffffe ) ^ 0x00000001 ]
   [ ct set mark with reg 1 ]
 
+# ct mark set 0x00000001 or ct mark
+ip test-ip4 output
+  [ ct load mark => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffffe ) ^ 0x00000001 ]
+  [ ct set mark with reg 1 ]
+
 # ct id 12345
 ip test-ip4 output
   [ ct load unknown => reg 1 ]
diff --git a/tests/py/inet/meta.t b/tests/py/inet/meta.t
index 7d2515c97f47..5c5c11d4aa9e 100644
--- a/tests/py/inet/meta.t
+++ b/tests/py/inet/meta.t
@@ -31,3 +31,5 @@ meta mark set ip dscp;ok
 meta mark set ip dscp | 0x40;ok
 meta mark set ip6 dscp;ok
 meta mark set ip6 dscp | 0x40;ok
+
+meta mark set ct mark and 0xffff0000 or meta mark and 0xffff;ok;meta mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
diff --git a/tests/py/inet/meta.t.json b/tests/py/inet/meta.t.json
index 0fee165ff18a..4352b963885b 100644
--- a/tests/py/inet/meta.t.json
+++ b/tests/py/inet/meta.t.json
@@ -236,6 +236,43 @@
     }
 ]
 
+# meta mark set ct mark and 0xffff0000 or meta mark and 0xffff
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "&": [
+                            {
+                                "ct": {
+                                    "key": "mark"
+                                }
+                            },
+                            4294901760
+                        ]
+                    },
+                    {
+                        "&": [
+                            {
+                                "meta": {
+                                    "key": "mark"
+                                }
+                            },
+                            65535
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
 # meta protocol ip udp dport 67
 [
     {
diff --git a/tests/py/inet/meta.t.payload b/tests/py/inet/meta.t.payload
index 7184fa0c0c9d..04dfbd8fbd33 100644
--- a/tests/py/inet/meta.t.payload
+++ b/tests/py/inet/meta.t.payload
@@ -80,6 +80,15 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 >> 0x00000008 ) ]
   [ meta set mark with reg 1 ]
 
+# meta mark set ct mark and 0xffff0000 or meta mark and 0xffff
+inet test-inet input
+  [ ct load mark => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000ffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ meta set mark with reg 1 ]
+
 # meta protocol ip udp dport 67
 inet test-inet input
   [ meta load protocol => reg 1 ]
diff --git a/tests/py/ip/ct.t b/tests/py/ip/ct.t
index a0a222893dd0..523d02442d2e 100644
--- a/tests/py/ip/ct.t
+++ b/tests/py/ip/ct.t
@@ -28,9 +28,11 @@ meta mark set ct original saddr . meta mark map { 1.1.1.1 . 0x00000014 : 0x00000
 meta mark set ct original ip saddr . meta mark map { 1.1.1.1 . 0x00000014 : 0x0000001e };ok
 ct original saddr . meta mark { 1.1.1.1 . 0x00000014 };fail
 ct original ip saddr . meta mark { 1.1.1.1 . 0x00000014 };ok
+
 ct mark set ip dscp << 2 | 0x10;ok
 ct mark set ip dscp << 26 | 0x10;ok
 ct mark set ip dscp & 0x0f << 1;ok;ct mark set ip dscp & af33
 ct mark set ip dscp & 0x0f << 2;ok;ct mark set ip dscp & 0x3c
 ct mark set ip dscp | 0x04;ok
 ct mark set ip dscp | 1 << 20;ok;ct mark set ip dscp | 0x100000
+ct mark set ct mark | ip dscp | 0x200 counter;ok;ct mark set ct mark | ip dscp | 0x00000200 counter
diff --git a/tests/py/ip/ct.t.json b/tests/py/ip/ct.t.json
index 915632aef076..9e60f7e22148 100644
--- a/tests/py/ip/ct.t.json
+++ b/tests/py/ip/ct.t.json
@@ -479,3 +479,35 @@
         }
     }
 ]
+
+# ct mark set ct mark | ip dscp | 0x200 counter
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                  {
+                    "ct": {
+                      "key": "mark"
+                    }
+                  },
+                  {
+                    "payload": {
+                      "protocol": "ip",
+                      "field": "dscp"
+                    }
+                  },
+                  512
+                ]
+            }
+        }
+    },
+    {
+        "counter": null
+    }
+]
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index 692011d0f860..823de5974228 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -134,3 +134,14 @@ ip test-ip4 output
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffefffff ) ^ 0x00100000 ]
   [ ct set mark with reg 1 ]
+
+# ct mark set ct mark | ip dscp | 0x200 counter
+ip test-ip4 output
+  [ ct load mark => reg 1 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffdff ) ^ 0x00000200 ]
+  [ ct set mark with reg 1 ]
+  [ counter pkts 0 bytes 0 ]
diff --git a/tests/py/ip6/ct.t b/tests/py/ip6/ct.t
index c06fd6a0441d..1617c68b6da2 100644
--- a/tests/py/ip6/ct.t
+++ b/tests/py/ip6/ct.t
@@ -7,3 +7,4 @@ ct mark set ip6 dscp << 26 | 0x10;ok
 ct mark set ip6 dscp | 0x04;ok
 ct mark set ip6 dscp | 0xff000000;ok
 ct mark set ip6 dscp & 0x0f << 2;ok;ct mark set ip6 dscp & 0x3c
+ct mark set ct mark | ip6 dscp | 0x200 counter;ok;ct mark set ct mark | ip6 dscp | 0x00000200 counter
diff --git a/tests/py/ip6/ct.t.json b/tests/py/ip6/ct.t.json
index 7d8c88bb09cb..2633c2b9433c 100644
--- a/tests/py/ip6/ct.t.json
+++ b/tests/py/ip6/ct.t.json
@@ -291,3 +291,35 @@
         }
     }
 ]
+
+# ct mark set ct mark | ip6 dscp | 0x200 counter
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                  {
+                    "ct": {
+                      "key": "mark"
+                    }
+                  },
+                  {
+                    "payload": {
+                      "protocol": "ip6",
+                      "field": "dscp"
+                    }
+                  },
+                  512
+                ]
+            }
+        }
+    },
+    {
+        "counter": null
+    }
+]
diff --git a/tests/py/ip6/ct.t.payload b/tests/py/ip6/ct.t.payload
index 944208f2dde4..a7a56d4be80b 100644
--- a/tests/py/ip6/ct.t.payload
+++ b/tests/py/ip6/ct.t.payload
@@ -44,3 +44,15 @@ ip6 test-ip6 output
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x0000003c ) ^ 0x00000000 ]
   [ ct set mark with reg 1 ]
+
+# ct mark set ct mark | ip6 dscp | 0x200 counter
+ip6 test-ip6 output
+  [ ct load mark => reg 1 ]
+  [ payload load 2b @ network header + 0 => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 2 = ntoh(reg 2, 2, 2) ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000006 ) ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffdff ) ^ 0x00000200 ]
+  [ ct set mark with reg 1 ]
+  [ counter pkts 0 bytes 0 ]
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_10 b/tests/shell/testcases/bitwise/0040mark_binop_10
new file mode 100755
index 000000000000..8e9bc6ad4329
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0040mark_binop_10
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_11 b/tests/shell/testcases/bitwise/0040mark_binop_11
new file mode 100755
index 000000000000..7825b0827851
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0040mark_binop_11
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook input priority filter; }
+  add rule t c meta mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_12 b/tests/shell/testcases/bitwise/0040mark_binop_12
new file mode 100755
index 000000000000..aa27cdc5303c
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0040mark_binop_12
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_13 b/tests/shell/testcases/bitwise/0040mark_binop_13
new file mode 100755
index 000000000000..53a7e2ec6c6f
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0040mark_binop_13
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook input priority filter; }
+  add rule ip6 t c meta mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0044payload_binop_2 b/tests/shell/testcases/bitwise/0044payload_binop_2
new file mode 100755
index 000000000000..2d09d24479d0
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0044payload_binop_2
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ct mark set ct mark | ip dscp | 0x200 counter
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0044payload_binop_5 b/tests/shell/testcases/bitwise/0044payload_binop_5
new file mode 100755
index 000000000000..aa82cd1c299e
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0044payload_binop_5
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ct mark set ct mark | ip6 dscp | 0x200 counter
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_10.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_10.nft
new file mode 100644
index 000000000000..5566f7298461
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_10.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_11.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_11.nft
new file mode 100644
index 000000000000..719980d55341
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_11.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		meta mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_12.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_12.nft
new file mode 100644
index 000000000000..bd589fe549f7
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_12.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_13.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_13.nft
new file mode 100644
index 000000000000..2b046b128fb2
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_13.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		meta mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0044payload_binop_2.nft b/tests/shell/testcases/bitwise/dumps/0044payload_binop_2.nft
new file mode 100644
index 000000000000..ed347bb2788a
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0044payload_binop_2.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark | ip dscp | 0x00000200 counter packets 0 bytes 0
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0044payload_binop_5.nft b/tests/shell/testcases/bitwise/dumps/0044payload_binop_5.nft
new file mode 100644
index 000000000000..ccdb93d74a9a
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0044payload_binop_5.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark | ip6 dscp | 0x00000200 counter packets 0 bytes 0
+	}
+}
-- 
2.30.2

