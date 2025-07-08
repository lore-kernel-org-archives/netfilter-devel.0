Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5457E107
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 23:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752017045; cv=none; b=gABNOGfCVTpXdLJUcgixfrcq3bREvjHx+5UEvrMcS7uo5hm2kCI/K4b52dWdmkPxr8+80+Zi9D2MjIrXfE8aF3zZGfez12MCsLsnvfw8YoLPA5x4UNfeqdgOAFP01xtTt3mEGUpbmGj9Y+Kpy4oUl5egHthx1u98gBAJHE3vROk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752017045; c=relaxed/simple;
	bh=nsE+Ef8IU3IWyx4kzg451LkHXzh5+FVxE5Fdr61Tgtw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fWIsXT3A63apebN4n3SgSWUyl6HSHxbm0SurF5feMKcID36s3Vj8AHU0UC6k9ahMVIcOgiKakEDTa6UypudXohSCvfPRbbg9sdArHs/7YEJquJCB4gPC9wiw5d1QwtNeUwq6IIs59I9iSO6d1JLL84Rc/40TRZwslgSGRkF5eGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a72Iuhd0; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TMg/OvRM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a72Iuhd0";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TMg/OvRM"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6DDF160273; Wed,  9 Jul 2025 01:24:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752017041;
	bh=O7Bq5V33UoG7/4+TvQ0WrBmu9JiGKgvbZLcaOgx18pM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=a72Iuhd0s7jYQs84FV6e1CfFthrrk09EvUvawYdxOe0MurBo+q6KaOTMSgZMpW7cD
	 EX0o0DZwoPH5MOSHOu39nBkftsSQc6BMD9bNr4P6BYlwyIRidhaMWzCkdUNdUg2zSc
	 UsBOdkwssul2RYe/n7DEzD+NKGP99hfaK21h2SG7D9ZfzCIL54EzhzF/gH4XLQnMNM
	 uoX9OOLYHQD89YKEeu9alG1PYMFRhBaQXAQ9QD/pzOelE2wp8jGheMaKD0Y+DG7pnJ
	 RZiW45DtKkh0GvLAAID4MA6Htd62ZbdqjHp/th7ztazZbOxUHi51qVLDotsOfpBEx4
	 5AQ/Rr3hDQKNA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B2F0060273
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 01:24:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752017040;
	bh=O7Bq5V33UoG7/4+TvQ0WrBmu9JiGKgvbZLcaOgx18pM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TMg/OvRM4ncpFbQZ2YUnQq3vU0atjc1peouu0+pbNLPneg+U33+aDfVQkhvsLt6PD
	 1ITZTg24FQBKU43ez/Umw42tnw3cAqkr6rqyfafzqgXX5DIDlyqhW/MtK7Corii4td
	 Jx87aU7KbkSbBCl9s7txt07zidXh4+3ScaYbgtQBLobT+Xl/DinjrkwLzvtxp75ooL
	 mSlmXBvLxlMXvTranHCPaEoBp1EFYEioRpRKqXNnrJnzTeof+/LUdu8mxJ1Wvt/2Dg
	 rme9LQZlMSPbJt1yAEPov4CKqTCAFRiglNp+u4Au1Cvi3TZ2TyddDVC6OipHOVNgyh
	 jbT3cPY1uUk4g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] src: convert set to list expression
Date: Wed,  9 Jul 2025 01:23:53 +0200
Message-Id: <20250708232354.2189045-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250708232354.2189045-1-pablo@netfilter.org>
References: <20250708232354.2189045-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following definition:

 define xyz = { "dummy0", "dummy1" }

is represented as a set expression to ease integration with sets.

However, this definition can be used in chains and flowtables to specify
the devices, for instance:

  table netdev x {
    chain y {
      type filter hook ingress devices = $xyz priority 0; policy drop;
    }
  }

in this context, $xyz defines a _list_ of devices, not a set.

Transform the set to list expression from the evaluation step for chains
and flowtables.

This patch also handles:

 define xyz = { "dummy0", $abc }

where $abc is also transformed to a list expression in the context of
chains and flowtables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 66 +++++++++++++++++++++++++++++++++++++++++++-------
 src/mnl.c      |  1 -
 2 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index f4f72ee4a4f7..fb6c4e06ae32 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5393,9 +5393,54 @@ static bool evaluate_expr_variable(struct eval_ctx *ctx, struct expr **exprp)
 	return true;
 }
 
-static bool evaluate_device_expr(struct eval_ctx *ctx, struct expr **dev_expr)
+static struct expr *expr_set_to_list(struct eval_ctx *ctx, struct expr *dev_expr)
 {
 	struct expr *expr, *next, *key;
+	struct location loc;
+	LIST_HEAD(tmp);
+
+	list_for_each_entry_safe(expr, next, &dev_expr->expressions, list) {
+		list_del(&expr->list);
+
+		switch (expr->etype) {
+		case EXPR_VARIABLE:
+			expr_set_context(&ctx->ectx, &ifname_type,
+					 IFNAMSIZ * BITS_PER_BYTE);
+			if (!evaluate_expr_variable(ctx, &expr))
+				return false;
+
+			if (expr->etype == EXPR_SET) {
+				expr = expr_set_to_list(ctx, expr);
+				list_splice_init(&expr->expressions, &tmp);
+				expr_free(expr);
+				continue;
+			}
+			break;
+		case EXPR_SET_ELEM:
+			key = expr_clone(expr->key);
+			expr_free(expr);
+			expr = key;
+			break;
+		case EXPR_VALUE:
+			break;
+		default:
+			break;
+		}
+
+		list_add(&expr->list, &tmp);
+	}
+
+	loc = dev_expr->location;
+	expr_free(dev_expr);
+	dev_expr = compound_expr_alloc(&loc, EXPR_LIST);
+	list_splice_init(&tmp, &dev_expr->expressions);
+
+	return dev_expr;
+}
+
+static bool evaluate_device_expr(struct eval_ctx *ctx, struct expr **dev_expr)
+{
+	struct expr *expr, *next;
 	LIST_HEAD(tmp);
 
 	if ((*dev_expr)->etype == EXPR_VARIABLE) {
@@ -5405,9 +5450,10 @@ static bool evaluate_device_expr(struct eval_ctx *ctx, struct expr **dev_expr)
 			return false;
 	}
 
-	if ((*dev_expr)->etype != EXPR_SET &&
-	    (*dev_expr)->etype != EXPR_LIST)
-		return true;
+	if ((*dev_expr)->etype == EXPR_SET)
+		*dev_expr = expr_set_to_list(ctx, *dev_expr);
+
+	assert((*dev_expr)->etype == EXPR_LIST);
 
 	list_for_each_entry_safe(expr, next, &(*dev_expr)->expressions, list) {
 		list_del(&expr->list);
@@ -5418,11 +5464,13 @@ static bool evaluate_device_expr(struct eval_ctx *ctx, struct expr **dev_expr)
 					 IFNAMSIZ * BITS_PER_BYTE);
 			if (!evaluate_expr_variable(ctx, &expr))
 				return false;
-			break;
-		case EXPR_SET_ELEM:
-			key = expr_clone(expr->key);
-			expr_free(expr);
-			expr = key;
+
+			if (expr->etype == EXPR_SET) {
+				expr = expr_set_to_list(ctx, expr);
+				list_splice_init(&expr->expressions, &tmp);
+				expr_free(expr);
+				continue;
+			}
 			break;
 		case EXPR_VALUE:
 			break;
diff --git a/src/mnl.c b/src/mnl.c
index 8a8dc4d6ef1c..cc20908fd636 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -757,7 +757,6 @@ static struct nft_dev *nft_dev_array(const struct expr *dev_expr, int *num_devs)
 	struct expr *expr;
 
 	switch (dev_expr->etype) {
-	case EXPR_SET:
 	case EXPR_LIST:
 		list_for_each_entry(expr, &dev_expr->expressions, list)
 			len++;
-- 
2.30.2

