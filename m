From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 3/3] Revert "evaluate: check for NULL datatype in rhs in lookup expr"
Date: Mon, 28 Nov 2016 17:43:10 +0100
Message-ID: <939f5cc247927ef24c567d7ebba3112d37faae4c.1480350941.git.anatole@rezel.net>
References: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:39578 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933062AbcK1Qnc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 11:43:32 -0500
In-Reply-To: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
In-Reply-To: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
References: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This reverts commit 5afa5a164ff1c066af1ec56d875b91562882bd50.
This commit is obsoleted by removing the possibility for a NULL right->dtype in
the first place, at set declaration.

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 src/evaluate.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index b12af14..51d644f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1467,33 +1467,18 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 
 	switch (rel->op) {
 	case OP_LOOKUP:
-		switch (right->ops->type) {
-		case EXPR_SET:
-			/* A literal set expression implicitly declares
-			 * the set
-			 */
+		/* A literal set expression implicitly declares the set */
+		if (right->ops->type == EXPR_SET)
 			right = rel->right =
 				implicit_set_declaration(ctx, "__set%d",
 							 left->dtype,
 							 left->len, right);
-			break;
-		case EXPR_SET_REF:
-			if (right->dtype == NULL)
-				return expr_binary_error(ctx->msgs, right,
-							 left, "the referenced"
-							 " set does not "
-							 "exist");
-			if (!datatype_equal(left->dtype, right->dtype))
-				return expr_binary_error(ctx->msgs, right,
-							 left, "datatype "
-							 "mismatch, expected "
-							 "%s, set has type %s",
-							 left->dtype->desc,
-							 right->dtype->desc);
-			break;
-		default:
-			BUG("Unknown expression %s\n", right->ops->name);
-		}
+		else if (!datatype_equal(left->dtype, right->dtype))
+			return expr_binary_error(ctx->msgs, right, left,
+						 "datatype mismatch, expected %s, "
+						 "set has type %s",
+						 left->dtype->desc,
+						 right->dtype->desc);
 
 		/* Data for range lookups needs to be in big endian order */
 		if (right->set->flags & SET_F_INTERVAL &&
-- 
2.11.0.rc2

