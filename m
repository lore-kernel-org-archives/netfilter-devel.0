Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD48C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 08:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239415AbiFTIc1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 04:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239445AbiFTIcZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 04:32:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EFF312A88
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 01:32:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 01/18] optimize: do not compare relational expression rhs when collecting statements
Date:   Mon, 20 Jun 2022 10:31:58 +0200
Message-Id: <20220620083215.1021238-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620083215.1021238-1-pablo@netfilter.org>
References: <20220620083215.1021238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When building the statement matrix, do not compare expression right hand
side, otherwise bogus mismatches might occur.

The fully compared flag is set on when comparing rules to look for
possible mergers.

Fixes: 3f36cc6c3dcd ("optimize: do not merge unsupported statement expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 3a3049d43690..a2a4e587e125 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -105,7 +105,8 @@ static bool stmt_expr_supported(const struct expr *expr)
 	return false;
 }
 
-static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
+static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b,
+			   bool fully_compare)
 {
 	struct expr *expr_a, *expr_b;
 
@@ -117,9 +118,11 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 		expr_a = stmt_a->expr;
 		expr_b = stmt_b->expr;
 
-		if (!stmt_expr_supported(expr_a) ||
-		    !stmt_expr_supported(expr_b))
-			return false;
+		if (fully_compare) {
+			if (!stmt_expr_supported(expr_a) ||
+			    !stmt_expr_supported(expr_b))
+				return false;
+		}
 
 		return __expr_cmp(expr_a->left, expr_b->left);
 	case STMT_COUNTER:
@@ -237,24 +240,12 @@ static bool stmt_verdict_eq(const struct stmt *stmt_a, const struct stmt *stmt_b
 	return false;
 }
 
-static bool stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
-{
-	if (!stmt_a && !stmt_b)
-		return true;
-	else if (!stmt_a)
-		return false;
-	else if (!stmt_b)
-		return false;
-
-	return __stmt_type_eq(stmt_a, stmt_b);
-}
-
 static bool stmt_type_find(struct optimize_ctx *ctx, const struct stmt *stmt)
 {
 	uint32_t i;
 
 	for (i = 0; i < ctx->num_stmts; i++) {
-		if (__stmt_type_eq(stmt, ctx->stmt[i]))
+		if (__stmt_type_eq(stmt, ctx->stmt[i], false))
 			return true;
 	}
 
@@ -321,7 +312,7 @@ static int cmd_stmt_find_in_stmt_matrix(struct optimize_ctx *ctx, struct stmt *s
 	uint32_t i;
 
 	for (i = 0; i < ctx->num_stmts; i++) {
-		if (__stmt_type_eq(stmt, ctx->stmt[i]))
+		if (__stmt_type_eq(stmt, ctx->stmt[i], false))
 			return i;
 	}
 	/* should not ever happen. */
@@ -886,6 +877,18 @@ static void merge_rules(const struct optimize_ctx *ctx,
 	fprintf(octx->error_fp, "\n");
 }
 
+static bool stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
+{
+	if (!stmt_a && !stmt_b)
+		return true;
+	else if (!stmt_a)
+		return false;
+	else if (!stmt_b)
+		return false;
+
+	return __stmt_type_eq(stmt_a, stmt_b, true);
+}
+
 static bool rules_eq(const struct optimize_ctx *ctx, int i, int j)
 {
 	uint32_t k;
-- 
2.30.2

