Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B942209D
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 12:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rFvZt-0006po-Ki; Wed, 20 Dec 2023 13:21:33 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: do not allow to chain more than 16 binops
Date: Wed, 20 Dec 2023 13:21:24 +0100
Message-ID: <20231220122128.10645-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

netlink_linearize.c has never supported more than 16 chained binops.
Adding more is possible but overwrites the stack in
netlink_gen_bitwise().

Add a recursion counter to catch this at eval stage.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/expression.h                          |  1 +
 include/rule.h                                |  6 +++++-
 src/evaluate.c                                | 20 +++++++++++++++++--
 src/netlink_linearize.c                       |  7 +++++--
 .../bogons/nft-f/huge_binop_expr_chain_crash  |  5 +++++
 5 files changed, 34 insertions(+), 5 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/huge_binop_expr_chain_crash

diff --git a/include/expression.h b/include/expression.h
index 809089c89974..f5d7e160a9aa 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -13,6 +13,7 @@
 
 #define NFT_MAX_EXPR_LEN_BYTES (NFT_REG32_COUNT * sizeof(uint32_t))
 #define NFT_MAX_EXPR_LEN_BITS  (NFT_MAX_EXPR_LEN_BYTES * BITS_PER_BYTE)
+#define NFT_MAX_EXPR_RECURSION 16
 
 /**
  * enum expr_types
diff --git a/include/rule.h b/include/rule.h
index 6236d2927c0a..6835fe069165 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -753,10 +753,13 @@ extern void cmd_free(struct cmd *cmd);
  * @rule:	current rule
  * @set:	current set
  * @stmt:	current statement
+ * @stmt_len:	current statement template length
+ * @recursion:  expr evaluation recursion counter
  * @cache:	cache context
  * @debug_mask: debugging bitmask
  * @ectx:	expression context
- * @pctx:	payload context
+ * @_pctx:	payload contexts
+ * @inner_desc: inner header description
  */
 struct eval_ctx {
 	struct nft_ctx		*nft;
@@ -767,6 +770,7 @@ struct eval_ctx {
 	struct set		*set;
 	struct stmt		*stmt;
 	uint32_t		stmt_len;
+	uint32_t		recursion;
 	struct expr_ctx		ectx;
 	struct proto_ctx	_pctx[2];
 	const struct proto_desc	*inner_desc;
diff --git a/src/evaluate.c b/src/evaluate.c
index 26f0110f66ea..24737fa7263f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1418,6 +1418,13 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	struct expr *op = *expr, *left, *right;
 	const char *sym = expr_op_symbols[op->op];
 	unsigned int max_shift_len = ctx->ectx.len;
+	int ret = -1;
+
+	if (ctx->recursion >= NFT_MAX_EXPR_RECURSION)
+		return expr_binary_error(ctx->msgs, op, NULL,
+					 "Binary operation limit %u reached ",
+					 ctx->recursion);
+	ctx->recursion++;
 
 	if (expr_evaluate(ctx, &op->left) < 0)
 		return -1;
@@ -1472,14 +1479,23 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	switch (op->op) {
 	case OP_LSHIFT:
 	case OP_RSHIFT:
-		return expr_evaluate_shift(ctx, expr);
+		ret = expr_evaluate_shift(ctx, expr);
+		break;
 	case OP_AND:
 	case OP_XOR:
 	case OP_OR:
-		return expr_evaluate_bitwise(ctx, expr);
+		ret = expr_evaluate_bitwise(ctx, expr);
+		break;
 	default:
 		BUG("invalid binary operation %u\n", op->op);
 	}
+
+
+	if (ctx->recursion == 0)
+		BUG("recursion counter underflow");
+
+	ctx->recursion--;
+	return ret;
 }
 
 static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index d8b41a088948..50dbd36c1b8e 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -695,10 +695,10 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 				const struct expr *expr,
 				enum nft_registers dreg)
 {
+	struct expr *binops[NFT_MAX_EXPR_RECURSION];
 	struct nftnl_expr *nle;
 	struct nft_data_linearize nld;
 	struct expr *left, *i;
-	struct expr *binops[16];
 	mpz_t mask, xor, val, tmp;
 	unsigned int len;
 	int n = 0;
@@ -710,8 +710,11 @@ static void netlink_gen_bitwise(struct netlink_linearize_ctx *ctx,
 
 	binops[n++] = left = (struct expr *) expr;
 	while (left->etype == EXPR_BINOP && left->left != NULL &&
-	       (left->op == OP_AND || left->op == OP_OR || left->op == OP_XOR))
+	       (left->op == OP_AND || left->op == OP_OR || left->op == OP_XOR)) {
+		if (n == array_size(binops))
+			BUG("NFT_MAX_EXPR_RECURSION limit reached");
 		binops[n++] = left = left->left;
+	}
 
 	netlink_gen_expr(ctx, binops[--n], dreg);
 
diff --git a/tests/shell/testcases/bogons/nft-f/huge_binop_expr_chain_crash b/tests/shell/testcases/bogons/nft-f/huge_binop_expr_chain_crash
new file mode 100644
index 000000000000..8d1da7262cfb
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/huge_binop_expr_chain_crash
@@ -0,0 +1,5 @@
+table t {
+	chain c {
+		meta oifname^a^b^c^d^e^f^g^h^i^j^k^l^m^n^o^p^q^r^s^t^u^v^w^x^y^z^A^B^C^D^E^F^G^H^I^J^K^L^M^N^O^P^Q^R^S^T^U^V^W^X^Y^Z^0^1^2^3^4^5^6^7^8^9 bar
+	}
+}
-- 
2.41.0

