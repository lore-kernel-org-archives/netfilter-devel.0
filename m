Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3831B0406
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Feb 2025 23:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740182111; cv=none; b=GqGahs+/CB04mo5jF7Ywy16r1dx9kVjdouKQx22sxiskkB5bkXP5xUSWef7r92bKAzHdsyIdMZy7Yokv6/Iryks+hEwiGQccs9xDwu98241qWnvgd0cRA6UGtIXSIwMMVrFvwcnwifzZRPSmy5NMmK7HnllaDmKnTB6Auuygr5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740182111; c=relaxed/simple;
	bh=l2ZdU6kaWPXg1JXVb0+XVSQ1gKc9KJyVhdeshQjZD9c=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=RqADoJKUZZoa2covbVrLd+mKkD9zZ1NgfPbf+h/hRgsK/g2R5EQbHuuB7CP6qOXc7Jrf12yKLFE6IE/UUm2buUfUdI9G2Ez43o7A301e8f17pD/J4ZFIkPd19qxUby+QiMIuT1W6bsFxBbtV8v0EOAOu2fa98FoFuA5AXEPN9vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DZ6CiL0V; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DZ6CiL0V; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DZ6CiL0V";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DZ6CiL0V"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7C5DA602D3; Sat, 22 Feb 2025 00:54:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740182098;
	bh=M4vS5M0im0M2J+RAFsfSpKFdMNQzq7LFy0345l9yA/8=;
	h=From:To:Subject:Date:From;
	b=DZ6CiL0V7EqH1Mri/a24MVhIfaUNcizCIw3704lkxQ9Ari26UOnVq8ElsRWHLupPS
	 5je2L238X3NbRF1lSd7HZQ1gefj910h/mkMHU1zJbgqlw6UOPR4id3UdkLAmwxzHNs
	 xGMtXE62k55PKfYV9JG4ztwuFrGGJk3wIUcHcv19APiN2q9j42ToJj5H6+seICbr5N
	 Z2RIKNCkIgCNE2iNWysDK4iEJNtpZYZLcDUKb9ftehuyrQKZJnjI3nYLfqWQpac/P2
	 1YaZnEmpc9E1lLFYkMGV97agKfJZ83M+8nS2fsu2un3uSYlWXFajzA/zh7Lj1ePO2t
	 Plvm43d3ebUJA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 199F7602C8
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Feb 2025 00:54:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740182098;
	bh=M4vS5M0im0M2J+RAFsfSpKFdMNQzq7LFy0345l9yA/8=;
	h=From:To:Subject:Date:From;
	b=DZ6CiL0V7EqH1Mri/a24MVhIfaUNcizCIw3704lkxQ9Ari26UOnVq8ElsRWHLupPS
	 5je2L238X3NbRF1lSd7HZQ1gefj910h/mkMHU1zJbgqlw6UOPR4id3UdkLAmwxzHNs
	 xGMtXE62k55PKfYV9JG4ztwuFrGGJk3wIUcHcv19APiN2q9j42ToJj5H6+seICbr5N
	 Z2RIKNCkIgCNE2iNWysDK4iEJNtpZYZLcDUKb9ftehuyrQKZJnjI3nYLfqWQpac/P2
	 1YaZnEmpc9E1lLFYkMGV97agKfJZ83M+8nS2fsu2un3uSYlWXFajzA/zh7Lj1ePO2t
	 Plvm43d3ebUJA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: consolidate evaluation of symbol range expression
Date: Sat, 22 Feb 2025 00:54:54 +0100
Message-Id: <20250221235454.503140-1-pablo@netfilter.org>
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
index ddc46754fc67..5b98c0beea45 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2321,46 +2321,45 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 
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

