Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9352B2C028B
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259311; cv=none; b=C6ifHr1qUuujjjfCj9P5b3s/7mdy8bC9hIrRV/yTOCloVQGhxB0lPqaxRkH+Zgdim0LQ2YYkA8aeuaf+2N+PTFVrNn5ktpzShsauSBnl914OsfzoZLvXWS3SOiWJqJH+kvxFVqQEy03b8pejlc4VwTm3FwpLoZSBlpkXGIMlxGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259311; c=relaxed/simple;
	bh=LYWFSjqz9E1ZeiSwa7L3IB6HyTGjKLPKc8XfKhdNMvQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYMvVelrzEgmnwCgkPoFb01JFQPe6B86iPKnABoCHxH5DdzFriCER+5PPAKCdwcfs+RQb3avDsLX3/V+WX1is/kIMLtos+V58wGfMt2TukC3yTq0zTGAOLjvGorEa3lcX4Es2OkQ4+6QyXbXryWfx8eLy8Tr8P9SSl9k+whvqWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=P0ZCV6nA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="P0ZCV6nA"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B988D60871
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259309;
	bh=yvc4KRJ9kwAGV1wuoy+A2IWNDmJWAI72RUPQ66Cm3Zs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=P0ZCV6nAkvB78UQ5nZBA96ma7tZ5aY7LHcVvBlRK9jdAXJUamaE/tlfVTPmmARZ3g
	 cjn9yawtuyX21AS/eNTy9NmPIIhqDlEqgh2n/FSI749w9rTLVT5LmSYPnyQpRuYtbP
	 MAyL40EPndHUWkUBpfKEjNNCFGfnd3GGAWIjYxWvvvc5DR1YedZVjEp5u3QNAbMynA
	 Wk4q8L/m0DGPQF4iMcZy3LC73etTPrcM9e1NEsvIRU0KftWZXXTfDD1wW6mUKEoDkd
	 WhSocGWZbb0S0++YVY4x/B9M3wWAeiuBwZj5MMTCA3bj+dNCNN9vu5RO3dLag+kcOc
	 YP/qTIfDx/jMA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 13/20] segtree: more assert on EXPR_SET_ELEM
Date: Thu,  5 Feb 2026 03:41:22 +0100
Message-ID: <20260205024130.1470284-14-pablo@netfilter.org>
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

More EXPR_SET_ELEM validation, for correctness, to prepare the removal
of this expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c |  4 ++++
 src/segtree.c    | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index 23ff42ac9331..39221ba83fd0 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1458,12 +1458,16 @@ void set_expr_add(struct expr *set, struct expr *elem)
 {
 	struct expr_set *expr_set = expr_set(set);
 
+	assert(elem->etype == EXPR_SET_ELEM);
+
 	list_add_tail(&elem->list, &expr_set->expressions);
 	expr_set->size++;
 }
 
 void set_expr_remove(struct expr *set, struct expr *expr)
 {
+	assert(expr->etype == EXPR_SET_ELEM);
+
 	expr_set(set)->size--;
 	list_del(&expr->list);
 }
diff --git a/src/segtree.c b/src/segtree.c
index 95cab41668f0..0ff1577b75b9 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -43,6 +43,9 @@ static enum byteorder get_key_byteorder(const struct expr *e)
 
 static void interval_expr_copy(struct expr *dst, struct expr *src)
 {
+	assert(dst->etype == EXPR_SET_ELEM);
+	assert(src->etype == EXPR_SET_ELEM);
+
 	if (src->comment)
 		dst->comment = xstrdup(src->comment);
 	if (src->timeout)
@@ -131,6 +134,9 @@ static struct expr *get_set_interval_find(const struct set *cache_set,
 	struct expr *i, *key;
 	mpz_t val;
 
+	assert(left->etype == EXPR_SET_ELEM);
+	assert(!right || right->etype == EXPR_SET_ELEM);
+
 	mpz_init2(val, set->key->len);
 
 	list_for_each_entry(i, &expr_set(set->init)->expressions, list) {
@@ -169,6 +175,8 @@ static struct expr *__expr_to_set_elem(struct expr *low, struct expr *expr)
 {
 	struct expr *elem;
 
+	assert(low->etype == EXPR_SET_ELEM);
+
 	if (low->key->etype == EXPR_MAPPING) {
 		expr = mapping_expr_alloc(&low->location, expr,
 					  expr_clone(low->key->right));
@@ -188,6 +196,8 @@ static struct expr *expr_to_set_elem(struct expr *e)
 	char data[len + 1];
 	struct expr *expr;
 
+	assert(e->etype == EXPR_SET_ELEM);
+
 	if (expr_basetype(expr_value(e))->type != TYPE_STRING)
 		return expr_clone(e);
 
@@ -210,6 +220,9 @@ static void set_expr_add_splice(struct expr *compound, struct expr *expr, struct
 {
 	struct expr *elem;
 
+	assert(expr->etype == EXPR_SET_ELEM);
+	assert(orig->etype == EXPR_SET_ELEM);
+
 	switch (expr->etype) {
 	case EXPR_SET_ELEM:
 		list_splice_init(&orig->stmt_list, &expr->stmt_list);
@@ -304,6 +317,9 @@ static int expr_value_cmp(const void *p1, const void *p2)
 	struct expr *e2 = *(void * const *)p2;
 	int ret;
 
+	assert(e1->etype == EXPR_SET_ELEM);
+	assert(e2->etype == EXPR_SET_ELEM);
+
 	if (expr_value(e1)->etype == EXPR_CONCAT)
 		return -1;
 
@@ -468,6 +484,9 @@ static struct expr *interval_to_prefix(struct expr *low, struct expr *i, const m
 	unsigned int prefix_len;
 	struct expr *prefix;
 
+	assert(low->etype == EXPR_SET_ELEM);
+	assert(i->etype == EXPR_SET_ELEM);
+
 	prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
 	prefix = prefix_expr_alloc(&low->location,
 				   expr_clone(expr_value(low)),
@@ -484,6 +503,9 @@ static struct expr *interval_to_string(struct expr *low, struct expr *i, const m
 	char data[len + 2];
 	struct expr *expr;
 
+	assert(low->etype == EXPR_SET_ELEM);
+	assert(i->etype == EXPR_SET_ELEM);
+
 	prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
 
 	if (prefix_len > i->len || prefix_len % BITS_PER_BYTE)
@@ -508,6 +530,9 @@ static struct expr *interval_to_range(struct expr *low, struct expr *i, mpz_t ra
 {
 	struct expr *tmp;
 
+	assert(low->etype == EXPR_SET_ELEM);
+	assert(i->etype == EXPR_SET_ELEM);
+
 	tmp = constant_expr_alloc(&low->location, low->dtype,
 				  low->byteorder, expr_value(low)->len,
 				  NULL);
@@ -528,6 +553,9 @@ add_interval(struct expr *set, struct expr *low, struct expr *i, bool closed)
 	struct expr *expr;
 	mpz_t range, p;
 
+	assert(low->etype == EXPR_SET_ELEM);
+	assert(i->etype == EXPR_SET_ELEM);
+
 	mpz_init(range);
 	mpz_init(p);
 
@@ -596,6 +624,8 @@ void interval_map_decompose(struct expr *set)
 	for (m = 0; m < size; m++) {
 		i = elements[m];
 
+		assert(i->etype == EXPR_SET_ELEM);
+
 		if (i->key->flags & EXPR_F_INTERVAL_END)
 			interval = false;
 		else if (interval) {
@@ -612,6 +642,8 @@ void interval_map_decompose(struct expr *set)
 	for (n = 0; n < size; n++) {
 		i = ranges[n];
 
+		assert(i->etype == EXPR_SET_ELEM);
+
 		if (low == NULL) {
 			if (i->key->flags & EXPR_F_INTERVAL_END) {
 				/*
-- 
2.47.3

