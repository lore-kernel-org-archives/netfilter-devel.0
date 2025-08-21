Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C812EE61E
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768219; cv=none; b=eZh0938XNeRwSqt0EVzjyfgiKw94iLTagoAIRrisMTVI3qTThb2RuHdeCi1oAPTO/kC2tXbJysBs8mhDWvGp0p3NOxFc/2zYPlniUJaqrPw3W5n+TeG7Pka99ySZn9/DM6fRVEPMwFYlDZ7fykHOxyVjHS8UsiN27D9PNfOrTYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768219; c=relaxed/simple;
	bh=1uB8aZAqJuZdtQnxpVl0bn0NUZ4afgxuxLL1vAq/+Fs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YlWq9mXxAkr9FREnMm3lTXHN/B61r/Yik5efkH3Jx5U1ojdqZfBu4QZViQe5mLCLFCrlCopyEzq3GUk2Lw/xQwYO9XGFPviTAuAZy/ydZ+7wHkbHSTj132IpSDjS/OrCNZTaNH0Lff37YB653H3hmZ0rucloLg+dmJlUXOgTJIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AkbW1weC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AkbW1weC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AkbW1weC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AkbW1weC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F1ABC602AE; Thu, 21 Aug 2025 11:23:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768215;
	bh=nt0RmWIrQQl/bGwExPauCWBgBDb3h6I6L7/+1NYYH1Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AkbW1weCRD68ct/LSYfo9S7bprzWq1sj7B7TUqIQXJo0OI8mlWVtBo1vg2dATfFYg
	 XEyo08E3rO0DRFf2qi8hn4QYWfqG0NgrA6d1eqyl7XoMnITkqWSy6dpzhMaSEj4cDg
	 DTfvP3BajWr41S0NG0dsvH+E+0b3jPqlUantRbclau3lPEPt1sRaMi3uHOgE0QkHdn
	 KTVlNMSUf50nUdhkCEnyW6fvqX9NSMuza3JFy+SxDHNGoxv1P8Sj2j/mL+zT2TqLro
	 LoJWhJcw/D3YKTMALuYj+T7LoZhDbzERaDhKZJ0BaBJCldGoWvhp/yR6qa79j7kFLW
	 TKIiog7axWx4A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7F777602AB
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:23:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768215;
	bh=nt0RmWIrQQl/bGwExPauCWBgBDb3h6I6L7/+1NYYH1Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AkbW1weCRD68ct/LSYfo9S7bprzWq1sj7B7TUqIQXJo0OI8mlWVtBo1vg2dATfFYg
	 XEyo08E3rO0DRFf2qi8hn4QYWfqG0NgrA6d1eqyl7XoMnITkqWSy6dpzhMaSEj4cDg
	 DTfvP3BajWr41S0NG0dsvH+E+0b3jPqlUantRbclau3lPEPt1sRaMi3uHOgE0QkHdn
	 KTVlNMSUf50nUdhkCEnyW6fvqX9NSMuza3JFy+SxDHNGoxv1P8Sj2j/mL+zT2TqLro
	 LoJWhJcw/D3YKTMALuYj+T7LoZhDbzERaDhKZJ0BaBJCldGoWvhp/yR6qa79j7kFLW
	 TKIiog7axWx4A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 01/11] src: add expr_type_catchall() helper and use it
Date: Thu, 21 Aug 2025 11:23:20 +0200
Message-Id: <20250821092330.2739989-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250821092330.2739989-1-pablo@netfilter.org>
References: <20250821092330.2739989-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helper function to check if this is a catchall expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  3 +++
 src/evaluate.c       |  2 +-
 src/intervals.c      | 12 ++++++------
 src/segtree.c        |  2 +-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index e483b7e76f4c..2e0754edaaae 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -552,6 +552,9 @@ extern struct expr *set_elem_expr_alloc(const struct location *loc,
 
 struct expr *set_elem_catchall_expr_alloc(const struct location *loc);
 
+#define expr_type_catchall(__expr)			\
+	((__expr)->etype == EXPR_SET_ELEM_CATCHALL)
+
 extern void range_expr_value_low(mpz_t rop, const struct expr *expr);
 extern void range_expr_value_high(mpz_t rop, const struct expr *expr);
 void range_expr_swap_values(struct expr *range);
diff --git a/src/evaluate.c b/src/evaluate.c
index a2ca3aaea35c..fc9177d3a91e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1928,7 +1928,7 @@ static bool elem_key_compatible(const struct expr *set_key,
 				const struct expr *elem_key)
 {
 	/* Catchall element is always compatible with the set key declaration */
-	if (elem_key->etype == EXPR_SET_ELEM_CATCHALL)
+	if (expr_type_catchall(elem_key))
 		return true;
 
 	return datatype_compatible(set_key->dtype, elem_key->dtype);
diff --git a/src/intervals.c b/src/intervals.c
index 8c8ce8c8a305..d5afffd2120a 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -175,7 +175,7 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
 	mpz_init(rop);
 
 	list_for_each_entry_safe(i, next, &expr_set(ctx->init)->expressions, list) {
-		if (i->key->etype == EXPR_SET_ELEM_CATCHALL)
+		if (expr_type_catchall(i->key))
 			continue;
 
 		range_expr_value_low(range.low, i);
@@ -410,7 +410,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 	list_for_each_entry_safe(elem, next, &expr_set(elems)->expressions, list) {
 		i = interval_expr_key(elem);
 
-		if (i->key->etype == EXPR_SET_ELEM_CATCHALL) {
+		if (expr_type_catchall(i->key)) {
 			/* Assume max value to simplify handling. */
 			mpz_bitmask(range.low, i->len);
 			mpz_bitmask(range.high, i->len);
@@ -574,7 +574,7 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 	list_for_each_entry_safe(elem, next, &expr_set(init)->expressions, list) {
 		i = interval_expr_key(elem);
 
-		if (i->key->etype == EXPR_SET_ELEM_CATCHALL)
+		if (expr_type_catchall(i->key))
 			continue;
 
 		range_expr_value_low(range.low, i);
@@ -686,7 +686,7 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 	list_for_each_entry_safe(i, n, &expr_set(init)->expressions, list) {
 		elem = interval_expr_key(i);
 
-		if (elem->key->etype == EXPR_SET_ELEM_CATCHALL)
+		if (expr_type_catchall(elem->key))
 			continue;
 
 		if (prev)
@@ -770,12 +770,12 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 	bool adjacent = false;
 
 	key = setelem_key(elem);
-	if (key->etype == EXPR_SET_ELEM_CATCHALL)
+	if (expr_type_catchall(key))
 		return 0;
 
 	if (next_elem) {
 		next_key = setelem_key(next_elem);
-		if (next_key->etype == EXPR_SET_ELEM_CATCHALL)
+		if (expr_type_catchall(next_key))
 			next_key = NULL;
 	}
 
diff --git a/src/segtree.c b/src/segtree.c
index fd77e03fbff5..607f002f181e 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -579,7 +579,7 @@ void interval_map_decompose(struct expr *set)
 		else if (i->etype == EXPR_MAPPING)
 			key = i->left->key;
 
-		if (key && key->etype == EXPR_SET_ELEM_CATCHALL) {
+		if (key && expr_type_catchall(key)) {
 			list_del(&i->list);
 			catchall = i;
 			continue;
-- 
2.30.2

