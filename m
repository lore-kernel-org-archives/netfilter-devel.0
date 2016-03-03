From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] expression: add helper to decide if operator needs to be shown
Date: Thu,  3 Mar 2016 18:56:52 +0100
Message-ID: <1457027814-14795-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56310 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757951AbcCCR4g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 12:56:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tcp dport 22 is treated as if user had given 'tcp dport == 22'.
When printing, the implicit == is omitted.

In some other cases we use OP_AND instead, e.g.
tcp flags ack means 'tcp flags & ack != 0'.

In all of these cases, we print the rule in the short form,
without showing this implicit operator.

Future patches will add other cases where an operator
other than AND or EQ can be suppressed, so add an explicit
helper that can suppress the operator symbol.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index ab195e5..c96bce4 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -514,21 +514,27 @@ static void binop_arg_print(const struct expr *op, const struct expr *arg)
 		printf(")");
 }
 
-static bool must_print_eq_op(const struct expr *expr)
+static bool must_print_op(const struct expr *binop)
 {
-	if (expr->right->dtype->basetype != NULL &&
-	    expr->right->dtype->basetype->type == TYPE_BITMASK)
-		return true;
+	switch (binop->op) {
+	case OP_EQ:
+		if (binop->right->dtype->basetype != NULL &&
+		     binop->right->dtype->basetype->type == TYPE_BITMASK)
+			return true;
 
-	return expr->left->ops->type == EXPR_BINOP;
+		return binop->left->ops->type == EXPR_BINOP;
+	default:
+		break;
+	}
+
+	return true;
 }
 
 static void binop_expr_print(const struct expr *expr)
 {
 	binop_arg_print(expr, expr->left);
 
-	if (expr_op_symbols[expr->op] &&
-	    (expr->op != OP_EQ || must_print_eq_op(expr)))
+	if (expr_op_symbols[expr->op] && must_print_op(expr))
 		printf(" %s ", expr_op_symbols[expr->op]);
 	else
 		printf(" ");
-- 
2.4.10

