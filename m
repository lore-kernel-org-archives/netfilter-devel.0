From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/5] evaluate: handle binop adjustment recursively
Date: Thu, 11 Jan 2018 16:30:22 +0100
Message-ID: <20180111153024.25198-5-fw@strlen.de>
References: <20180111153024.25198-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57496 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932470AbeAKPmr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 10:42:47 -0500
In-Reply-To: <20180111153024.25198-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

currently this is fine, but a followup commit will add
EXPR_SET_ELEM handling.

And unlike RANGE we cannot assume the key is a value.
Therefore make binop_can_transfer and binop_transfer_one handle
right hand recursively if needed.  For RANGE, call it again with
from/to.

For future SET_ELEM, we can then just call the function recursively
again with right->key as new RHS.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 55 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7fe738d8d590..cc32f74bd95e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1408,6 +1408,21 @@ static int expr_evaluate_hash(struct eval_ctx *ctx, struct expr **exprp)
 static int binop_can_transfer(struct eval_ctx *ctx,
 			      struct expr *left, struct expr *right)
 {
+	int err;
+
+	switch (right->ops->type) {
+	case EXPR_VALUE:
+		break;
+	case EXPR_RANGE:
+		err = binop_can_transfer(ctx, left, right->left);
+		if (err <= 0)
+			return err;
+		return binop_can_transfer(ctx, left, right->right);
+	default:
+		fprintf(stderr, "ERR: UNHANDLED %s\n", right->ops->name);
+		return 0;
+	}
+
 	switch (left->op) {
 	case OP_LSHIFT:
 		if (mpz_scan1(right->value, 0) < mpz_get_uint32(left->right->value))
@@ -1428,6 +1443,21 @@ static int binop_can_transfer(struct eval_ctx *ctx,
 static int binop_transfer_one(struct eval_ctx *ctx,
 			      const struct expr *left, struct expr **right)
 {
+	int err;
+
+	switch ((*right)->ops->type) {
+	case EXPR_VALUE:
+		break;
+	case EXPR_RANGE:
+		err = binop_transfer_one(ctx, left, &(*right)->left);
+		if (err < 0)
+			return err;
+		return binop_transfer_one(ctx, left, &(*right)->right);
+	default:
+		fprintf(stderr, "ERR2: UNHANDLED %s\n", (*right)->ops->name);
+		return 0;
+	}
+
 	expr_get(*right);
 
 	switch (left->op) {
@@ -1468,15 +1498,10 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 			return -1;
 		break;
 	case EXPR_RANGE:
-		err = binop_can_transfer(ctx, left, (*expr)->right->left);
-		if (err <= 0)
-			return err;
-		err = binop_can_transfer(ctx, left, (*expr)->right->right);
+		err = binop_can_transfer(ctx, left, (*expr)->right);
 		if (err <= 0)
 			return err;
-		if (binop_transfer_one(ctx, left, &(*expr)->right->left) < 0)
-			return -1;
-		if (binop_transfer_one(ctx, left, &(*expr)->right->right) < 0)
+		if (binop_transfer_one(ctx, left, &(*expr)->right) < 0)
 			return -1;
 		break;
 	case EXPR_SET:
@@ -1497,15 +1522,8 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 		list_for_each_entry(i, &(*expr)->right->set->init->expressions, list) {
 			switch (i->key->ops->type) {
 			case EXPR_VALUE:
-				err = binop_can_transfer(ctx, left, i->key);
-				if (err <= 0)
-					return err;
-				break;
 			case EXPR_RANGE:
-				err = binop_can_transfer(ctx, left, i->key->left);
-				if (err <= 0)
-					return err;
-				err = binop_can_transfer(ctx, left, i->key->right);
+				err = binop_can_transfer(ctx, left, i->key);
 				if (err <= 0)
 					return err;
 				break;
@@ -1518,13 +1536,8 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 			list_del(&i->list);
 			switch (i->key->ops->type) {
 			case EXPR_VALUE:
-				if (binop_transfer_one(ctx, left, &i->key) < 0)
-					return -1;
-				break;
 			case EXPR_RANGE:
-				if (binop_transfer_one(ctx, left, &i->key->left) < 0)
-					return -1;
-				if (binop_transfer_one(ctx, left, &i->key->right) < 0)
+				if (binop_transfer_one(ctx, left, &i->key) < 0)
 					return -1;
 				break;
 			default:
-- 
2.13.6

