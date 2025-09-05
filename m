Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F97D37C10A
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087132; cv=none; b=mrITcnpkWqXSv/UhWaoLg9t2jy9ytJ0rwwnLdRs97xB91a9zZdnmEJXwhbKcBd1YTFXGjSNSVtK+nZhtP4+HS26bQP0lT7zdii7LBl+24Grx6rKdIDxsK81ryGiW2cgShCaH1N9mPPycKekkEfUG0ob6CJUmDBPrEeSLHQY90vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087132; c=relaxed/simple;
	bh=a71S/6RhMIM8LrslL/28jRP42fN/tpKY7RzKzP4VpiQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ruAf1clkI9xOWbdH1JONaBVU4XVGCirfATRZYTyCHrOW9Em830A5vERsqxVitdoK1Z1ECMn+Y42JV8yc0T7mrN8mOa6WcljuhNy82eVq6PoajqM+XiMCzUQ+E2ZF92f2dcDuQLff673AhN4+xTk1pw+mUsUP9KpTN2sgQja2Sr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ED03N9Fz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=N3ndD4xv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ED03N9Fz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="N3ndD4xv"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BEA7F608CC; Fri,  5 Sep 2025 17:36:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086599;
	bh=HHVGKWHT8IK1M9mab/txsa6wbMI+4yBkjKcC2paXV7I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ED03N9FzjqFpdrlbblOjvlmEp1WPN6T71iJj9xFIbqMq8vyRXb2p2OJ2UyGXrEsc+
	 cE9h1aF6yokSOMrGnmTQkc4MxY099Lwf8gnH0YE4AttejKog0cdmA2edz1Ton445Y8
	 WuzoK75PJO7xGflQJ21o+pgyv9OnOqbsQT/uaz6MCNqGZBCvQ2eRgQXopDOrkMsklT
	 BX2alQgJiRAs41P9S0tMjxH8YeafNRpzdY+8TzZvP6Is0N6p6H4IoyYLNKyEbU6Gh9
	 3mbOQK7i1dPKIxZw/CfMkcy4nSxriGZV68MaJfdTA0FcmCX7kZd+KNOQkl6NTBXzRz
	 uNtovmvzjgBrg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BEEEC608BA
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 17:36:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086597;
	bh=HHVGKWHT8IK1M9mab/txsa6wbMI+4yBkjKcC2paXV7I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=N3ndD4xvven6rYSTT0aUINeYLaFLj7kYu4vnf3ygkxJGdqAoOVvBRVxPsGHkRkog+
	 dNNc6mNL0wvqRnMpjjox4N1beZ/KoU5w/JOiuhzyikHONahvxlaRbWarUT9m91t9XE
	 z3y00oaGgFnNScSq8BQi55vT8oPDj6lDlHl2F8jq6jxS5PS1Cv8NynhptBblXF9LGb
	 1BgOH0MsVRquTP/XMkdLHhC5JICa6ttY5F1lmPwgr6O1zGVi9ts72MNpyTKwH4qV7e
	 tmQBtHAFX+MiS0Ck2LnHEODbeFN94FMv6TRVA89Ya48Lx0xXAu/q+iCw0db17WTwJm
	 GEE/+2ezUbWQA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/7] evaluate: simplify sets as set elems evaluation
Date: Fri,  5 Sep 2025 17:36:24 +0200
Message-Id: <20250905153627.1315405-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250905153627.1315405-1-pablo@netfilter.org>
References: <20250905153627.1315405-1-pablo@netfilter.org>
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

Extend tests/shell coverage to exercise merging nested sets.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 0b7508a18ede..85c446a124ee 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2090,27 +2090,17 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
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
2.30.2

