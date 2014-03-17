From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] expr: do not suppress OP_EQ when RHS is bitmask type
Date: Mon, 17 Mar 2014 23:08:38 +0100
Message-ID: <1395094118-32580-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54440 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbaCQWM7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:12:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

bitmask types default to flagcmp now, thus do not suppress OP_EQ.  Else,

rule filter output tcp flags syn
rule filter output tcp flags == syn

are both displayed as 'flags syn'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 1313925..fa14d99 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -514,13 +514,21 @@ static void binop_arg_print(const struct expr *op, const struct expr *arg)
 		printf(")");
 }
 
+static bool must_print_eq_op(const struct expr *expr)
+{
+	if (expr->right->dtype->basetype != NULL &&
+	    expr->right->dtype->basetype->type == TYPE_BITMASK)
+		return true;
+
+	return expr->left->ops->type == EXPR_BINOP;
+}
+
 static void binop_expr_print(const struct expr *expr)
 {
 	binop_arg_print(expr, expr->left);
 
 	if (expr_op_symbols[expr->op] &&
-	    (expr->op != OP_EQ ||
-	     expr->left->ops->type == EXPR_BINOP))
+	    (expr->op != OP_EQ || must_print_eq_op(expr)))
 		printf(" %s ", expr_op_symbols[expr->op]);
 	else
 		printf(" ");
-- 
1.8.1.5

