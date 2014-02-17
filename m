From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/4] binop: take care of operator precedence when printing binop arguments
Date: Mon, 17 Feb 2014 17:20:50 +0000
Message-ID: <1392657652-9815-3-git-send-email-kaber@trash.net>
References: <1392657652-9815-1-git-send-email-kaber@trash.net>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51567 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaBQRU7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:20:59 -0500
In-Reply-To: <1392657652-9815-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When the argument of a binop is a binop itself, we may need to add parens
if the precedence of the argument is lower then the binop.

Before:

tcp flags & syn | ack == syn | ack
tcp flags & syn | ack != syn | ack

After:

tcp flags & (syn | ack) == syn | ack
tcp flags & (syn | ack) != syn | ack

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h |  2 ++
 src/expression.c     | 30 ++++++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 0633102..5128a5b 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -80,7 +80,9 @@ enum ops {
 	OP_FLAGCMP,
 	/* Set lookup */
 	OP_LOOKUP,
+	__OP_MAX
 };
+#define OP_MAX		(__OP_MAX - 1)
 
 extern const char *expr_op_symbols[];
 
diff --git a/src/expression.c b/src/expression.c
index c856622..6cc79b2 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -404,16 +404,42 @@ struct expr *unary_expr_alloc(const struct location *loc,
 	return expr;
 }
 
+static uint8_t expr_binop_precedence[OP_MAX + 1] = {
+	[OP_LSHIFT]	= 1,
+	[OP_RSHIFT]	= 1,
+	[OP_AND]	= 2,
+	[OP_XOR]	= 3,
+	[OP_OR]		= 4,
+};
+
+static void binop_arg_print(const struct expr *op, const struct expr *arg)
+{
+	bool prec = false;
+
+	if (arg->ops->type == EXPR_BINOP &&
+	    expr_binop_precedence[op->op] != 0 &&
+	    expr_binop_precedence[op->op] < expr_binop_precedence[arg->op])
+		prec = 1;
+
+	if (prec)
+		printf("(");
+	expr_print(arg);
+	if (prec)
+		printf(")");
+}
+
 static void binop_expr_print(const struct expr *expr)
 {
-	expr_print(expr->left);
+	binop_arg_print(expr, expr->left);
+
 	if (expr_op_symbols[expr->op] &&
 	    (expr->op != OP_EQ ||
 	     expr->left->ops->type == EXPR_BINOP))
 		printf(" %s ", expr_op_symbols[expr->op]);
 	else
 		printf(" ");
-	expr_print(expr->right);
+
+	binop_arg_print(expr, expr->right);
 }
 
 static void binop_expr_clone(struct expr *new, const struct expr *expr)
-- 
1.8.5.3

