Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3E6CA0FF6
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Sep 2023 08:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350324AbjIBIhv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Sep 2023 04:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239611AbjIBIhv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Sep 2023 04:37:51 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69C4910F4
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Sep 2023 01:37:46 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: revisit anonymous set with single element optimization
Date:   Sat,  2 Sep 2023 10:37:39 +0200
Message-Id: <20230902083739.219746-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch reworks it to perform this optimization from the evaluation
step of the relational expression. Hence, when optimizing for protocol
flags, use OP_EQ instead of OP_IMPLICIT, that is:

	tcp flags { syn }

becomes (to represent an exact match):

	tcp flags == syn

given OP_IMPLICIT and OP_EQ are not equivalent for flags.

01167c393a12 ("evaluate: do not remove anonymous set with protocol flags
and single element") disabled this optimization, which is enabled again
after this patch.

Fixes: 01167c393a12 ("evaluate: do not remove anonymous set with protocol flags and single element")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 52 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index a7725f4e4c96..746719e85420 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1815,26 +1815,6 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 	if (ctx->set) {
 		if (ctx->set->flags & NFT_SET_CONCAT)
 			set->set_flags |= NFT_SET_CONCAT;
-	} else if (set->size == 1) {
-		i = list_first_entry(&set->expressions, struct expr, list);
-		if (i->etype == EXPR_SET_ELEM &&
-		    (!i->dtype->basetype ||
-		     i->dtype->basetype->type != TYPE_BITMASK ||
-		     i->dtype->type == TYPE_CT_STATE) &&
-		    list_empty(&i->stmt_list)) {
-
-			switch (i->key->etype) {
-			case EXPR_PREFIX:
-			case EXPR_RANGE:
-			case EXPR_VALUE:
-				*expr = i->key;
-				i->key = NULL;
-				expr_free(set);
-				return 0;
-			default:
-				break;
-			}
-		}
 	}
 
 	set->set_flags |= NFT_SET_CONSTANT;
@@ -2355,6 +2335,35 @@ static bool range_needs_swap(const struct expr *range)
 	return mpz_cmp(left->value, right->value) > 0;
 }
 
+static void optimize_singleton_set(struct expr *rel, struct expr **expr)
+{
+	struct expr *set = rel->right, *i;
+
+	i = list_first_entry(&set->expressions, struct expr, list);
+	if (i->etype == EXPR_SET_ELEM &&
+	    list_empty(&i->stmt_list)) {
+
+		switch (i->key->etype) {
+		case EXPR_PREFIX:
+		case EXPR_RANGE:
+		case EXPR_VALUE:
+			rel->right = *expr = i->key;
+			i->key = NULL;
+			expr_free(set);
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (rel->op == OP_IMPLICIT &&
+	    rel->right->dtype->basetype &&
+	    rel->right->dtype->basetype->type == TYPE_BITMASK &&
+	    rel->right->dtype->type != TYPE_CT_STATE) {
+		rel->op = OP_EQ;
+	}
+}
+
 static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *rel = *expr, *left, *right;
@@ -2437,6 +2446,9 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 	switch (rel->op) {
 	case OP_EQ:
 	case OP_IMPLICIT:
+		if (right->etype == EXPR_SET && right->size == 1)
+			optimize_singleton_set(rel, &right);
+
 		/*
 		 * Update protocol context for payload and meta iiftype
 		 * equality expressions.
-- 
2.30.2

