From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH 1/3] evaluate: Remove unnecessary spaces
Date: Mon,  2 Oct 2017 13:02:48 +0530
Message-ID: <131c45f3b814d80f5339fb08d521261d087385fb.1506928244.git.harshasharmaiitr@gmail.com>
References: <cover.1506928244.git.harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1506928244.git.harshasharmaiitr@gmail.com>
In-Reply-To: <cover.1506928244.git.harshasharmaiitr@gmail.com>
References: <cover.1506928244.git.harshasharmaiitr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Code indent should use tabs wherever possible

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 src/evaluate.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e767542..5624ca2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -122,7 +122,7 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 		return 0;
 	if (expr_basetype(*expr)->type != TYPE_INTEGER)
 		return expr_error(ctx->msgs, *expr,
-			 	  "Byteorder mismatch: expected %s, got %s",
+				  "Byteorder mismatch: expected %s, got %s",
 				  byteorder_names[byteorder],
 				  byteorder_names[(*expr)->byteorder]);
 
@@ -1321,7 +1321,7 @@ static int expr_evaluate_hash(struct eval_ctx *ctx, struct expr **exprp)
 		return -1;
 
 	/* expr_evaluate_primary() sets the context to what to the input
-         * expression to be hashed. Since this input is transformed to a 4 bytes
+	 * expression to be hashed. Since this input is transformed to a 4 bytes
 	 * integer, restore context to the datatype that results from hashing.
 	 */
 	__expr_set_context(&ctx->ectx, expr->dtype, expr->byteorder, expr->len,
@@ -1627,7 +1627,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		case EXPR_CONCAT:
 			return expr_binary_error(ctx->msgs, left, rel,
 					"Relational expression (%s) is undefined "
-				        "for %s expressions",
+					"for %s expressions",
 					expr_op_symbols[rel->op],
 					left->ops->name);
 		default:
@@ -1637,7 +1637,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		if (!expr_is_singleton(right))
 			return expr_binary_error(ctx->msgs, right, rel,
 					"Relational expression (%s) is undefined "
-				        "for %s expressions",
+					"for %s expressions",
 					expr_op_symbols[rel->op],
 					right->ops->name);
 
@@ -1659,7 +1659,7 @@ range:
 		case EXPR_CONCAT:
 			return expr_binary_error(ctx->msgs, left, rel,
 					"Relational expression (%s) is undefined"
-				        "for %s expressions",
+					"for %s expressions",
 					expr_op_symbols[rel->op],
 					left->ops->name);
 		default:
-- 
1.9.1
