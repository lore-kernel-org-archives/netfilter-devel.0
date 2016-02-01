From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] evaluate: move default op lookup into helper
Date: Tue,  2 Feb 2016 00:18:59 +0100
Message-ID: <1454368741-16368-2-git-send-email-fw@strlen.de>
References: <1454368741-16368-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35228 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726AbcBAXVh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 18:21:37 -0500
In-Reply-To: <1454368741-16368-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Split it into its own function, caller is already quite big.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ed78896..4d741e3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1119,6 +1119,26 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static enum ops expr_defaultop(const struct expr *e)
+{
+	switch (e->ops->type) {
+	case EXPR_RANGE:
+		return OP_RANGE;
+	case EXPR_SET:
+	case EXPR_SET_REF:
+		return OP_LOOKUP;
+	case EXPR_LIST:
+		return OP_FLAGCMP;
+	default:
+		if (e->dtype->basetype != NULL &&
+		    e->dtype->basetype->type == TYPE_BITMASK)
+			return OP_FLAGCMP;
+		break;
+	}
+
+	return OP_EQ;
+}
+
 static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *rel = *expr, *left, *right;
@@ -1131,27 +1151,8 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 	right = rel->right;
 
-	if (rel->op == OP_IMPLICIT) {
-		switch (right->ops->type) {
-		case EXPR_RANGE:
-			rel->op = OP_RANGE;
-			break;
-		case EXPR_SET:
-		case EXPR_SET_REF:
-			rel->op = OP_LOOKUP;
-			break;
-		case EXPR_LIST:
-			rel->op = OP_FLAGCMP;
-			break;
-		default:
-			if (right->dtype->basetype != NULL &&
-			    right->dtype->basetype->type == TYPE_BITMASK)
-				rel->op = OP_FLAGCMP;
-			else
-				rel->op = OP_EQ;
-			break;
-		}
-	}
+	if (rel->op == OP_IMPLICIT)
+		rel->op = expr_defaultop(rel->right);
 
 	if (!expr_is_constant(right))
 		return expr_binary_error(ctx->msgs, right, rel,
-- 
2.4.10

