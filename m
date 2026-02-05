Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B222C031B
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259301; cv=none; b=N1tmOeq+pOeXRyzFmOHFhn8qpgDiVbzkKLqijCOFXSpvQJEBN/Z2j2o6uQQ2d3s+TGu35cxgWICKSUNZNKHdc+QwtWG7AnfreTBe3ihFPAsfoklJTv8jte1s1EndeXo+84BQ2MQvhV3ggIb74pBnOOjdxsA+vVbVl3NDdo+a0SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259301; c=relaxed/simple;
	bh=novmyUBpuHpM0I0YfdgFB4PVawA2Pv4N0jXfUU68qzw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rth+B9C6bK1RZZmT5xcJLgj+AvR/strYK2X+8T+yskHpJIRlDJFrPVI3iipVZLNbAAP2TTPC/DJrxaUkX9UK/yf16bq3WkTosTi3hMDy1F/KxvElUf65GH721lfmkqOW2o98t7W5iiQ6iFcU5rJEspgNcXe+iRBFSAD4tVJhOOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gbhwuR7A; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gbhwuR7A"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F0BC360871
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259300;
	bh=tm0XnKVx+Y7XWHnZ1NGBO4lp5RKVM5oxbZIIGsGJpjw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gbhwuR7AFCmq0/AbdM66MvX33bwI8BMxuiZgZhd9o7QlFL1TN9RUCOcMzBmJJub7p
	 8hrxrW30YmDucmk6j+aBIky2V9H9CD+rjemRmhnfIx5bvXJyaR+VfZLPVJWYu41ViT
	 s/2fOOoptR1B2A6KMR6wZDOpnEjQWK8J+rz+JJ+7kUQrWTQCt8iUsHBsnKt4tXom0l
	 6CH0Y0M44P9ZYdnw3lCcIjed4AMH8eq+72UTNjFHB5eOA5ltHf0X74xpYz1AMhHlqC
	 /l4hzgecUarolctBs9mlP4+Lc8v/L4oIvoUgCHBjNWk59swMrExFT3HVOWn+hsKPbm
	 FDOSJRLFvMvnA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 04/20] evaluate: simplify sets as set elems evaluation
Date: Thu,  5 Feb 2026 03:41:13 +0100
Message-ID: <20260205024130.1470284-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260205024130.1470284-1-pablo@netfilter.org>
References: <20260205024130.1470284-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After normalizing set element representation for EXPR_MAPPING, it is
possible to simplify:

  a6b75b837f5e ("evaluate: set: Allow for set elems to be sets")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index f0a82a2c46eb..556664d640a3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2101,27 +2101,17 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			return expr_error(ctx->msgs, i,
 					  "Set reference cannot be part of another set");
 
-		if (elem->etype == EXPR_SET_ELEM &&
-		    elem->key->etype == EXPR_SET) {
-			struct expr *new = expr_get(elem->key);
-
-			expr_set(set)->set_flags |= expr_set(elem->key)->set_flags;
-			list_replace(&i->list, &new->list);
-			expr_free(i);
-			i = new;
-			elem = i;
-		}
-
 		if (!expr_is_constant(i))
 			return expr_error(ctx->msgs, i,
 					  "Set member is not constant");
 
-		if (i->etype == EXPR_SET) {
+		if (i->etype == EXPR_SET_ELEM &&
+		    i->key->etype == EXPR_SET) {
 			/* Merge recursive set definitions */
-			list_splice_tail_init(&expr_set(i)->expressions, &i->list);
+			list_splice_tail_init(&expr_set(i->key)->expressions, &i->list);
 			list_del(&i->list);
-			expr_set(set)->size      += expr_set(i)->size - 1;
-			expr_set(set)->set_flags |= expr_set(i)->set_flags;
+			expr_set(set)->size      += expr_set(i->key)->size - 1;
+			expr_set(set)->set_flags |= expr_set(i->key)->set_flags;
 			expr_free(i);
 		} else if (!expr_is_singleton(i)) {
 			expr_set(set)->set_flags |= NFT_SET_INTERVAL;
-- 
2.47.3

