Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DF9255E24
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Feb 2025 23:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740182289; cv=none; b=rv3tORlakZwn5lco42CbxDcSCQcFv8cKJbRqGL6D9TghBfZsb4q4xmlG1pzgaOLmlR0Bi2E1O4UXunlRhimijKgsNFLJ3xKjLg61nY6G+oOfkAjAJ994DGdxiYVQmahS3If8L2DInCYY/8HkC1XGbaH+F2bJS+DXnStp2os7Alc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740182289; c=relaxed/simple;
	bh=vBf20CGV5PtCrppIXqRN0TwipMFEIW/od/G5H1SZsvU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=jnAwdaH739vA0VLqGxcsCL9s3v5n7ZhoMfPkBy1oFGEVuEUIwvYJZ13gZy6s4LAH1gsH2Nj0i2WL0sMDXIMXUsYJKWWFx9yW9wjfnJq20O3NEdqYaXQs7AbdhaqLkPZYXOlkSGNU2u4RPZKmG1oErkDhxn94B9ZMR94rJY8vMV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ecbU5Ovw; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ecbU5Ovw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ecbU5Ovw";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ecbU5Ovw"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B91F6602D1; Sat, 22 Feb 2025 00:58:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740182284;
	bh=umqbBAHCgf56L7jrqSN9keWF+DGm+LWW7IlOlrpqGqw=;
	h=From:To:Subject:Date:From;
	b=ecbU5OvwTAer7u+hvMHuMID6c7S1WGFX/0vdlyWMzcDlQVOkaKFf0VGu2hiC3Pt0m
	 KgEissyb+e5GJxY08vujRHkeRAekKgLMck+ObppNGe6GLDJlLsVvLi/oVUuxIPqei6
	 DMPZycRGbIgtg3pG+dhzNpFzP1SX2azedi8LJ7d/gcwOFVsaQogNYyqmjxRHW8GsHj
	 e/VqX39QzdqaBZePATwfXmP1JidvN9ES3Uf4znEmSk687WzC/yVhs8/3Vlcs4iHpS6
	 dQmC5S4SHpCSiTeUoZEHrIZLy8M5rcVqvkYxsu7evxq+9TQvp5dtyuW6tDXynWIwWn
	 ZJ/ddSOnkhxKg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 523EA602CD
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Feb 2025 00:58:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740182284;
	bh=umqbBAHCgf56L7jrqSN9keWF+DGm+LWW7IlOlrpqGqw=;
	h=From:To:Subject:Date:From;
	b=ecbU5OvwTAer7u+hvMHuMID6c7S1WGFX/0vdlyWMzcDlQVOkaKFf0VGu2hiC3Pt0m
	 KgEissyb+e5GJxY08vujRHkeRAekKgLMck+ObppNGe6GLDJlLsVvLi/oVUuxIPqei6
	 DMPZycRGbIgtg3pG+dhzNpFzP1SX2azedi8LJ7d/gcwOFVsaQogNYyqmjxRHW8GsHj
	 e/VqX39QzdqaBZePATwfXmP1JidvN9ES3Uf4znEmSk687WzC/yVhs8/3Vlcs4iHpS6
	 dQmC5S4SHpCSiTeUoZEHrIZLy8M5rcVqvkYxsu7evxq+9TQvp5dtyuW6tDXynWIwWn
	 ZJ/ddSOnkhxKg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: consolidate evaluation of symbol range expression
Date: Sat, 22 Feb 2025 00:58:00 +0100
Message-Id: <20250221235800.519884-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expand symbol_range to range expression to consolidate evaluation.

I found a bug when testing for negative ranges:

  test.nft:5:16-30: Error: Could not process rule: File exists
                  elements = { 1.1.1.1-1.1.1.0 }
                               ^^^^^^^^^^^^^^^

after this patch, error reporting has been restored:

  test.nft:5:16-30: Error: Range negative size
                  elements = { 1.1.1.1-1.1.1.0 }
                               ^^^^^^^^^^^^^^^

Fixes: 347039f64509 ("src: add symbol range expression to further compact intervals")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ee66b93d7c23..25c07d90695b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2327,46 +2327,45 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 
 static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
 {
-	struct expr *left, *right, *range;
+	struct expr *left, *right, *range, *constant_range;
 	struct expr *expr = *exprp;
 
-	left = symbol_expr_alloc(&expr->location, expr->symtype, (struct scope *)expr->scope, expr->identifier_range[0]);
-	if (expr_evaluate_symbol(ctx, &left) < 0) {
-		expr_free(left);
-		return -1;
-	}
+	/* expand to symbol and range expressions to consolidate evaluation. */
+	left = symbol_expr_alloc(&expr->location, expr->symtype,
+				 (struct scope *)expr->scope,
+				 expr->identifier_range[0]);
+	right = symbol_expr_alloc(&expr->location, expr->symtype,
+				  (struct scope *)expr->scope,
+				  expr->identifier_range[1]);
+	range = range_expr_alloc(&expr->location, left, right);
 
-	right = symbol_expr_alloc(&expr->location, expr->symtype, (struct scope *)expr->scope, expr->identifier_range[1]);
-	if (expr_evaluate_symbol(ctx, &right) < 0) {
-		expr_free(left);
-		expr_free(right);
+	if (expr_evaluate(ctx, &range) < 0) {
+		expr_free(range);
 		return -1;
 	}
+	left = range->left;
+	right = range->right;
 
 	/* concatenation and maps need more work to use constant_range_expr. */
 	if (ctx->set && !set_is_map(ctx->set->flags) &&
 	    set_is_non_concat_range(ctx->set) &&
 	    left->etype == EXPR_VALUE &&
 	    right->etype == EXPR_VALUE) {
-		range = constant_range_expr_alloc(&expr->location, left->dtype,
-						  left->byteorder,
-						  left->len,
-						  left->value,
-						  right->value);
-		expr_free(left);
-		expr_free(right);
+		constant_range = constant_range_expr_alloc(&expr->location,
+							   left->dtype,
+							   left->byteorder,
+							   left->len,
+							   left->value,
+							   right->value);
+		expr_free(range);
 		expr_free(expr);
-		*exprp = range;
+		*exprp = constant_range;
 		return 0;
 	}
 
-	range = range_expr_alloc(&expr->location, left, right);
 	expr_free(expr);
 	*exprp = range;
 
-	if (expr_evaluate(ctx, exprp) < 0)
-		return -1;
-
 	return 0;
 }
 
-- 
2.30.2

