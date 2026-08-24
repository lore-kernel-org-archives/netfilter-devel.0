Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDEB391838
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 21:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787606960; cv=none; b=lVnkx4OAjdCgTA0R65FvzmlNC/VVztQZVaSBE7aqEk2YsU8upEMUQrb6lm8v0OKXJOe1uFmRhitUSSp1TlC32Z6SLTtb/LQ50a61Wyy1LFg1j5svVvdKeQfqjM/aI7FQaGkyHjhGsuh8IvG82MIudEXWjj5qrc5Nfk51A4IhfIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787606960; c=relaxed/simple;
	bh=vCyUh9tRDuj2g1TYEpUFi2QkkQNEn/oraczu2x2JdDs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4V8tN5XQnLcm84QYa8JCwVyiIYYpQitgZ51JctDFdu5n0ekMxpy0dvtzASUx9e0SYpj3mX4+J9IpuZbVpW7LDV9bbAexUXGM23CltzcMr8OZczDZ8f4W4GctQ6eBp6Z++zxCz15E5hkMgmtmU1IU10a8P1WDRmdL9ZeHFk85UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Q3Ws7AIl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Q3Ws7AIl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787606957;
	bh=OAkz+mfvawocYdQZY3GvjZyZtewLrDeTS6Mwz83ZLwg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Q3Ws7AIlSsKxHt+zQggzU+s6Hkx6OvbepOPOqTYscDL2Fkyrj9H/U6xaRB6DSOag8
	 +4U8yGOfXaqTLei1jUevG9lFPwA54VjJSwGC1m6hW8BEJsRSKoK95lQqjfgD8bJ8C/
	 crD3wCE8YlMBaugrAEhYZZiQ/ZsQc8JYuXCoQqjTtBhJZy3DrXHUoYlxbHyBf5qDNN
	 4Y/A4ITDjcCegPzPU/2/3SycSrF7joY2bnNVmWJXSL6o5KoOb62xnR5CSvVrRJ8EqK
	 3lyiBFr129jzK39deXD5RukPY2XDbKfFisjB24J+RgoTpky3CPz82ZHqHswGWZFCwk
	 YEK2Toinz07VA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F111F6007E
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 23:29:16 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] Revert "segtree: basic support for binary operations in concatenated set ranges"
Date: Mon, 24 Aug 2026 23:29:08 +0200
Message-ID: <20260824212909.68597-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260824212909.68597-1-pablo@netfilter.org>
References: <20260824212909.68597-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handling binary expression from the interval set postprocessing step is
tricky, it is easier to handle set element key as value at that stage.
Revert 1de3568ef07f ("segtree: basic support for binary operations in
concatenated set ranges"), this only works for concatenated set ranges.

A follow up patch postpones the conversion from value to symbol for
TYPE_BITMASK expressions after the interval set postprocessing.

Fixes: 1de3568ef07f ("segtree: basic support for binary operations in concatenated set ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 4f758e6c9f99..5e178fa3c48d 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -369,29 +369,6 @@ static int range_mask_len(const mpz_t start, const mpz_t end, unsigned int len)
 	return ret;
 }
 
-static int concat_expr_cmp(const struct expr *r1, const struct expr *r2)
-{
-	int ret;
-
-	assert(r1->etype == r2->etype);
-
-	switch (r1->etype) {
-	case EXPR_BINOP:
-		assert(r1->op == r2->op);
-		ret = 0;
-		ret = mpz_cmp(r1->left->value, r2->left->value);
-		ret |= mpz_cmp(r1->right->value, r2->right->value);
-		break;
-	case EXPR_VALUE:
-		ret = mpz_cmp(r1->value, r2->value);
-		break;
-	default:
-		BUG("unexpected expression %s", expr_name(r1->key));
-	}
-
-	return ret;
-}
-
 /* Given a set with two elements (start and end), transform them into a
  * concatenation of ranges. That is, from a list of start expressions and a list
  * of end expressions, form a list of start - end expressions.
@@ -431,13 +408,13 @@ void concat_range_aggregate(struct expr *set)
 			r2_next = r2->list.next;
 			free_r1 = 0;
 
-			if (!concat_expr_cmp(r1, r2)) {
+			assert(r1->etype == EXPR_VALUE && r1->etype == EXPR_VALUE);
+
+			if (!mpz_cmp(r1->value, r2->value)) {
 				free_r1 = 1;
 				goto next;
 			}
 
-			assert(r1->etype == EXPR_VALUE && r1->etype == EXPR_VALUE);
-
 			if (expr_basetype(r1)->type == TYPE_STRING &&
 			    expr_basetype(r2)->type == TYPE_STRING) {
 				string_type = true;
-- 
2.47.3

