From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/8] evaluate: determine implicit relational op before RHS constant checks
Date: Tue,  4 Feb 2014 08:35:13 +0000
Message-ID: <1391502920-19186-2-git-send-email-kaber@trash.net>
References: <1391502920-19186-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43620 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaBDIfZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:35:25 -0500
In-Reply-To: <1391502920-19186-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The symbol for the relational op is shown in the error message. Since
OP_IMPLICIT doesn't have a symbol, (null) is shown. Fix by determining
the implicit op before checking for constants.

Error: Right hand side of relational expression ((null)) must be constant
=>
Error: Right hand side of relational expression (==) must be constant

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 215a004..a01d2a5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -872,17 +872,6 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 	right = rel->right;
 
-	if (!expr_is_constant(right))
-		return expr_binary_error(ctx, right, rel,
-					 "Right hand side of relational "
-					 "expression (%s) must be constant",
-					 expr_op_symbols[rel->op]);
-	if (expr_is_constant(left))
-		return expr_binary_error(ctx, left, right,
-					 "Relational expression (%s) has "
-					 "constant value",
-					 expr_op_symbols[rel->op]);
-
 	if (rel->op == OP_IMPLICIT) {
 		switch (right->ops->type) {
 		case EXPR_RANGE:
@@ -901,6 +890,17 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		}
 	}
 
+	if (!expr_is_constant(right))
+		return expr_binary_error(ctx, right, rel,
+					 "Right hand side of relational "
+					 "expression (%s) must be constant",
+					 expr_op_symbols[rel->op]);
+	if (expr_is_constant(left))
+		return expr_binary_error(ctx, left, right,
+					 "Relational expression (%s) has "
+					 "constant value",
+					 expr_op_symbols[rel->op]);
+
 	switch (rel->op) {
 	case OP_LOOKUP:
 		/* A literal set expression implicitly declares the set */
-- 
1.8.5.3

