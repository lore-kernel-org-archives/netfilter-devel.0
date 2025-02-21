Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580A9433DE
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Feb 2025 23:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740182221; cv=none; b=E2hrkDvUWjCmhkos/EHNKzT4flDdl6S9+Amgucq8eLvdltEa1yCxe0hF1YtRQ1lyBsZ4jRaQe77EWJBCQvxA0HbI4SmhXqulYAboZpSZxTV0Cs/qTnrf4PY+rj6m1QJhiTUjf6XP21hHQPBH7Ef7L5CfWG/eVnEEodZu+DTDFYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740182221; c=relaxed/simple;
	bh=nBZuCAWV1eJs6DAjDxJtx7C9XcBdwJnPUUonp2bIzZQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=brIxqhux65KIWuZvY5UWfH9SVFmQftDFV2Y086RYiJ2zvngvFiCE7YgoDCVTf9zYNMq+XuJ8xK9PF44O9coCrmV6VnjszNb8/BhMzalOVScmTq83hB0CJXJvPHdr0v0sX6YhGOf6vl10/nDdnqZEjUQh7F/ZZ6mksdLxFmX8y48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Y3eu9yul; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Y3eu9yul; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Y3eu9yul";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Y3eu9yul"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9325E602DB; Sat, 22 Feb 2025 00:56:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740182216;
	bh=wbYCZxKicCtOs62MW/v/PVy5vm7wZCxyFjoU3zebt2Y=;
	h=From:To:Subject:Date:From;
	b=Y3eu9yulNhCQkFZVdtD4o+Fe0KlSHKEF7znmPzdc5a9NCy2JyhZvcKL9CZDLoW5J5
	 TqYlO4ovAa90vHewm5JDT8GkUoRfaZTNnO7+Ox7migwxxerk3goutvvqVR0PT3b03W
	 SFi7UsdStLc/dpsu/nw6dT+2d7ZC/aRaL49QZn2rx54rGTUSVFVrEq9pX6Zbkh7IMV
	 g89u0Br5Vk1HRXMmEUbqDZKdgBgXoW1+aPtN1ftDg7QaBE8zURayUC7batYtnOfJp/
	 GgMcXAfDdLcfM1Ztr/7e3OSezLag47RN1prLu/I3V+t6mfTS8sAsuSTOB+XFDcNoCC
	 QC/jZ8vib4x4w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 36918602D5
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Feb 2025 00:56:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740182216;
	bh=wbYCZxKicCtOs62MW/v/PVy5vm7wZCxyFjoU3zebt2Y=;
	h=From:To:Subject:Date:From;
	b=Y3eu9yulNhCQkFZVdtD4o+Fe0KlSHKEF7znmPzdc5a9NCy2JyhZvcKL9CZDLoW5J5
	 TqYlO4ovAa90vHewm5JDT8GkUoRfaZTNnO7+Ox7migwxxerk3goutvvqVR0PT3b03W
	 SFi7UsdStLc/dpsu/nw6dT+2d7ZC/aRaL49QZn2rx54rGTUSVFVrEq9pX6Zbkh7IMV
	 g89u0Br5Vk1HRXMmEUbqDZKdgBgXoW1+aPtN1ftDg7QaBE8zURayUC7batYtnOfJp/
	 GgMcXAfDdLcfM1Ztr/7e3OSezLag47RN1prLu/I3V+t6mfTS8sAsuSTOB+XFDcNoCC
	 QC/jZ8vib4x4w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: optimize zero length range
Date: Sat, 22 Feb 2025 00:56:52 +0100
Message-Id: <20250221235652.517872-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A rule like the following:

  ... tcp dport 22-22 ...

results in a range expression to match from 22 to 22.

Simplify to singleton value so a cmp is used instead.

This optimization already exists in set elements which might explain
this overlook.

Fixes: 7a6e16040d65 ("evaluate: allow for zero length ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ddc46754fc67..ee66b93d7c23 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1305,12 +1305,12 @@ static int __expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
-static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
+static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **exprp)
 {
-	struct expr *range = *expr, *left, *right;
+	struct expr *range = *exprp, *left, *right;
 	int rc;
 
-	rc = __expr_evaluate_range(ctx, expr);
+	rc = __expr_evaluate_range(ctx, exprp);
 	if (rc)
 		return rc;
 
@@ -1320,6 +1320,12 @@ static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
 	if (mpz_cmp(left->value, right->value) > 0)
 		return expr_error(ctx->msgs, range, "Range negative size");
 
+	if (mpz_cmp(left->value, right->value) == 0) {
+		*exprp = expr_get(left);
+		expr_free(range);
+		return 0;
+	}
+
 	datatype_set(range, left->dtype);
 	range->flags |= EXPR_F_CONSTANT;
 	return 0;
-- 
2.30.2

