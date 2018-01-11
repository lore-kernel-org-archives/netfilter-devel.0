From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/5] src: evaluate: add binop transfer support for vmaps
Date: Thu, 11 Jan 2018 16:30:23 +0100
Message-ID: <20180111153024.25198-6-fw@strlen.de>
References: <20180111153024.25198-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57500 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932470AbeAKPmu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 10:42:50 -0500
In-Reply-To: <20180111153024.25198-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft add rule ip filter input ip dscp vmap \{ 4 : accept, 63 : continue \}
BUG: invalid binary operation 5

Unlike plain "ip dscp { 4, 63 }", we don't have a relational op in case
of vmap, we need to do the binop ifxups when evaluating the map
statement.

NB: This patch is incorrect or incomplete:

  nft add rule --debug=netlink ip6 test-ip6 input ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter

doesn't work, even though the generated expressions look sane.
It looks like there is disagreement between the key size and the sizes
of the individual elements in the set, but I don't know why this occurs
(and not e.g. with ip dscp).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index cc32f74bd95e..f62f727ffd34 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1247,6 +1247,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static int binop_transfer(struct eval_ctx *ctx, struct expr **expr);
 static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr_ctx ectx = ctx->ectx;
@@ -1282,8 +1283,12 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		ctx->set = mappings->set;
 		if (expr_evaluate(ctx, &map->mappings->set->init) < 0)
 			return -1;
-		ctx->set = NULL;
+		expr_set_context(&ctx->ectx, ctx->set->key->dtype, ctx->set->key->len);
+		if (binop_transfer(ctx, expr) < 0)
+			return -1;
 
+		map = *expr;
+		ctx->set = NULL;
 		map->mappings->set->flags |= map->mappings->set->init->set_flags;
 		break;
 	case EXPR_SYMBOL:
@@ -1413,6 +1418,8 @@ static int binop_can_transfer(struct eval_ctx *ctx,
 	switch (right->ops->type) {
 	case EXPR_VALUE:
 		break;
+	case EXPR_SET_ELEM:
+		return binop_can_transfer(ctx, left, right->key);
 	case EXPR_RANGE:
 		err = binop_can_transfer(ctx, left, right->left);
 		if (err <= 0)
@@ -1448,6 +1455,8 @@ static int binop_transfer_one(struct eval_ctx *ctx,
 	switch ((*right)->ops->type) {
 	case EXPR_VALUE:
 		break;
+	case EXPR_SET_ELEM:
+		return binop_transfer_one(ctx, left, &(*right)->key);
 	case EXPR_RANGE:
 		err = binop_transfer_one(ctx, left, &(*right)->left);
 		if (err < 0)
@@ -1523,6 +1532,7 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 			switch (i->key->ops->type) {
 			case EXPR_VALUE:
 			case EXPR_RANGE:
+			case EXPR_SET_ELEM:
 				err = binop_can_transfer(ctx, left, i->key);
 				if (err <= 0)
 					return err;
@@ -1537,6 +1547,7 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 			switch (i->key->ops->type) {
 			case EXPR_VALUE:
 			case EXPR_RANGE:
+			case EXPR_SET_ELEM:
 				if (binop_transfer_one(ctx, left, &i->key) < 0)
 					return -1;
 				break;
-- 
2.13.6

