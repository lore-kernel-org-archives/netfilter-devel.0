Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BC61D90DF
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755094316; cv=none; b=XSJfnIP2FbLRd7k6uCQ3OB0gOWZgRyaiwRbP36sPPcAZwrXNpqiw9gWtNbPQwhkyBtqybxP0+MMoWCQx8WB2SIv9gObOWzwEXqDuuk98nJKOS3lAmAnSM/5C0oK5OmJAHo5kiB4i90sk2sZQlvJR7OSxSgD48iCuRmBS7dc4gj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755094316; c=relaxed/simple;
	bh=sFCT6NFOhs6GYI38m2KhaY/QkTl4rVuxXQYQVVOjCwQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=noNc9KNOzaiRtJTpR+oQgsvr21AYwnd6KrfzRuPh1sSmfZPViQa8pAFxuKiQ6vPHg3E9d/UrXuCBL+vdyKQsSdhgj1nynKIU0QqDyv9x909m5CzClUxaCfStri9rBGitb/fSqNhBOJ3+U9u00rYGx/wGxPO14KUBunDfcQaSYYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JhNTJYat; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AsR3KjK6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JhNTJYat";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AsR3KjK6"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 503E660700; Wed, 13 Aug 2025 16:11:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094312;
	bh=pRU/d5pO2awKU7Sl9Ns1n5wSs0lBQeb366KNOkv5G50=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JhNTJYatvu7+eyspnIEsbtNHBGWXyWA/+1wPaeesOP0Cl5vFoeR3ZEOHQ6DJcYlHt
	 8cD+DBNZHrvzroV0QQMlu70Z5QR5P4Vn69hN8keMjIzSQUV/8hEAy0U2j0DOw9Y/1m
	 KNVc1c0i+xRSOfGcO5nZPzW9LJIpCJ8P4Byfn+2coTF00SwSCxDmAiyVy6HrwQvAep
	 WE5Atz7D5fvGF2Ia+BvWTsSmlHOjdK/t0nJ5elJKX5JJ12XcS8yWcFe+Pkcre5CPSw
	 9zLwv019LVL6HlBgZnOqwt3kL/Jcd0RNdT4DwGO4EcBMZ9cfbUCeVO4ECVxXdOjMga
	 7WFjp6KMW9VjA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CC8BE606F1
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 16:11:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094311;
	bh=pRU/d5pO2awKU7Sl9Ns1n5wSs0lBQeb366KNOkv5G50=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AsR3KjK6ZWXqUnvn+3ff9vyVogDEK/TTU/V9j++Z4TnHIwdj1DGl5t2C5wVvL69OQ
	 hbVXfqMSnxQkgw+RoIA+vmBwXLElKqmgvACA9yIywPbKxYdkd++KjnUQVob53viZr4
	 a3QNDY1HRnniaPTq9radDhK+xOiimE5xZ6POR5b4bv02C0Juy3s0JVF+jNR3MZcRC7
	 DAFAWZyOmGkaJlEjEAOrVDkgkTd96C0q/iQ9lsg1Z+Yaa4wNRvW/HZRyeccwp7ETPU
	 H9536ZRcx+rkea9LeZY8ULr0G9Q+rZYmZKiP5/MD0Ich0IvxLGwmYwZ2pNTPHlm01S
	 wCsrrTYsZRK5w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 02/12] src: add expr_type_catchall() helper and use it
Date: Wed, 13 Aug 2025 16:11:34 +0200
Message-Id: <20250813141144.333784-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250813141144.333784-1-pablo@netfilter.org>
References: <20250813141144.333784-1-pablo@netfilter.org>
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
index 8f037601c45f..abbe3bf7e9e5 100644
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

