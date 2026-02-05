Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAE62C027C
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259315; cv=none; b=X8q6pR5B6x1Km4xYZMrGv1QC7q+gmcEYW+Rva5ag4CDMQ0kR/XTy+Vc6Fg0CItHZw+bUFGSHPVvJIWtH3rV9Q6V5+w/W1eRgCd60iT9P3cenTvcuALHAX6EceCs4WtafRxFbt9Lzp2J8emhQ0eTomLOM3AUTSpRzFKDKPHawmcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259315; c=relaxed/simple;
	bh=TtP8shGQ+hoU57q0TGss27IeQXy6jG4qJt1HwbMJ3v8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeKrVwkjVoOq4koHFHXIt+2rfKuN7L717viAVeyndBm2mQW3SRqKngtNDt6XIQVZQZkfdD28+WrrBpR2N4b0RG2oGSVXoRCxb2q8Fo8P3LS9cMcoKKsrdbrnJZuE1pe0JYye4rQ+6rijuoPrIcLRRH7E0Qk8d8sjU2KBtBLyK4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Do080dEH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Do080dEH"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 670F56087B
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259313;
	bh=n1h404H1BZlbg2wk/qnHQLHnhm6brLzPMslbYI38+pQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Do080dEH4Ey6DlfTRCDkBn9TUQ6M7LGUN9tGT1TTKkemBVy0cIl1835ZjUy+8W7WY
	 WuuqYlN2VR/IMGG21zM7+VEW+SM8KBpmzc4mQ8TxRX6s6NLkGMo8RrTPylhZm+Jgw6
	 nxg4fKHAE6BekSbtDUz84/DSJ9P08t4uuLBnmNSssyVJ2y4Qz5nI5ViIdagWEPUG8p
	 ryfJa2+QvDzKdzGHX/u/cazGFD3Y2ZRXwY+AT+V0gonATrSytOfx8AwC4Tzk1Hd8LY
	 4H50efCtleeWnZCPzSWMAxwaNLjvdTfO6uNuxoQOQ9FepYRhxegtJOSwIMI9qVoZfp
	 BZKdTxy9ICkbQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 17/20] segtree: consolidate calls to expr_value() to fetch the element key
Date: Thu,  5 Feb 2026 03:41:26 +0100
Message-ID: <20260205024130.1470284-18-pablo@netfilter.org>
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

Consolidate calls to expr_value() so the key is fetched only once.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 51 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 7fed4df6e178..fde9473dd366 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -198,16 +198,17 @@ static struct expr *__expr_to_set_elem(struct expr *low, struct expr *expr)
 static struct expr *expr_to_set_elem(struct expr *e)
 {
 	unsigned int len = div_round_up(e->len, BITS_PER_BYTE);
+	struct expr *expr, *key;
 	unsigned int str_len;
 	char data[len + 1];
-	struct expr *expr;
 
 	assert(e->etype == EXPR_SET_ELEM);
 
-	if (expr_basetype(expr_value(e))->type != TYPE_STRING)
+	key = expr_value(e);
+	if (expr_basetype(key)->type != TYPE_STRING)
 		return expr_clone(e);
 
-	mpz_export_data(data, expr_value(e)->value, BYTEORDER_BIG_ENDIAN, len);
+	mpz_export_data(data, key->value, BYTEORDER_BIG_ENDIAN, len);
 
 	str_len = strnlen(data, len);
 	if (str_len >= len || str_len == 0)
@@ -306,15 +307,18 @@ static int expr_value_cmp(const void *p1, const void *p2)
 {
 	struct expr *e1 = *(void * const *)p1;
 	struct expr *e2 = *(void * const *)p2;
+	struct expr *key_e1, *key_e2;
 	int ret;
 
 	assert(e1->etype == EXPR_SET_ELEM);
 	assert(e2->etype == EXPR_SET_ELEM);
 
-	if (expr_value(e1)->etype == EXPR_CONCAT)
+	key_e1 = expr_value(e1);
+	if (key_e1->etype == EXPR_CONCAT)
 		return -1;
 
-	ret = mpz_cmp(expr_value(e1)->value, expr_value(e2)->value);
+	key_e2 = expr_value(e2);
+	ret = mpz_cmp(key_e1->value, key_e2->value);
 	if (ret == 0) {
 		if (e1->key->flags & EXPR_F_INTERVAL_END)
 			return -1;
@@ -475,15 +479,17 @@ static struct expr *interval_to_prefix(struct expr *low, struct expr *i, const m
 {
 	unsigned int prefix_len;
 	struct expr *prefix;
+	struct expr *key;
 
 	assert(low->etype == EXPR_SET_ELEM);
 	assert(i->etype == EXPR_SET_ELEM);
 
-	prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
+	key = expr_value(i);
+	prefix_len = key->len - mpz_scan0(range, 0);
 	prefix = prefix_expr_alloc(&low->location,
 				   expr_clone(expr_value(low)),
 						   prefix_len);
-	prefix->len = expr_value(i)->len;
+	prefix->len = key->len;
 
 	return __expr_to_set_elem(low, prefix);
 }
@@ -494,11 +500,13 @@ static struct expr *interval_to_string(struct expr *low, struct expr *i, const m
 	unsigned int prefix_len, str_len;
 	char data[len + 2];
 	struct expr *expr;
+	struct expr *key;
 
 	assert(low->etype == EXPR_SET_ELEM);
 	assert(i->etype == EXPR_SET_ELEM);
 
-	prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
+	key = expr_value(i);
+	prefix_len = key->len - mpz_scan0(range, 0);
 
 	if (prefix_len > i->len || prefix_len % BITS_PER_BYTE)
 		return interval_to_prefix(low, i, range);
@@ -520,21 +528,20 @@ static struct expr *interval_to_string(struct expr *low, struct expr *i, const m
 
 static struct expr *interval_to_range(struct expr *low, struct expr *i, mpz_t range)
 {
-	struct expr *tmp;
+	struct expr *tmp, *key;
 
 	assert(low->etype == EXPR_SET_ELEM);
 	assert(i->etype == EXPR_SET_ELEM);
 
+	key = expr_value(low);
 	tmp = constant_expr_alloc(&low->location, low->dtype,
-				  low->byteorder, expr_value(low)->len,
+				  low->byteorder, key->len,
 				  NULL);
 
-	mpz_add(range, range, expr_value(low)->value);
+	mpz_add(range, range, key->value);
 	mpz_set(tmp->value, range);
 
-	tmp = range_expr_alloc(&low->location,
-			       expr_clone(expr_value(low)),
-			       tmp);
+	tmp = range_expr_alloc(&low->location, expr_clone(key), tmp);
 
 	return __expr_to_set_elem(low, tmp);
 }
@@ -542,7 +549,7 @@ static struct expr *interval_to_range(struct expr *low, struct expr *i, mpz_t ra
 static void
 add_interval(struct expr *set, struct expr *low, struct expr *i, bool closed)
 {
-	struct expr *expr;
+	struct expr *expr, *key;
 	mpz_t range, p;
 
 	assert(low->etype == EXPR_SET_ELEM);
@@ -551,16 +558,17 @@ add_interval(struct expr *set, struct expr *low, struct expr *i, bool closed)
 	mpz_init(range);
 	mpz_init(p);
 
-	mpz_sub(range, expr_value(i)->value, expr_value(low)->value);
+	key = expr_value(low);
+	mpz_sub(range, expr_value(i)->value, key->value);
 	if (closed)
 		mpz_sub_ui(range, range, 1);
 
-	mpz_and(p, expr_value(low)->value, range);
+	mpz_and(p, key->value, range);
 
 	if (!mpz_cmp_ui(range, 0)) {
 		if (expr_basetype(low)->type == TYPE_STRING)
-			mpz_switch_byteorder(expr_value(low)->value,
-					     expr_value(low)->len / BITS_PER_BYTE);
+			mpz_switch_byteorder(key->value,
+					     key->len / BITS_PER_BYTE);
 		low->key->flags |= EXPR_F_KERNEL;
 		expr = expr_get(low);
 	} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
@@ -664,12 +672,13 @@ void interval_map_decompose(struct expr *set)
 	if (!low) /* no unclosed interval at end */
 		goto out;
 
+	key = expr_value(low);
 	i = constant_expr_alloc(&low->location, low->dtype,
-				low->byteorder, expr_value(low)->len, NULL);
+				low->byteorder, key->len, NULL);
 	mpz_bitmask(i->value, i->len);
 	i = set_elem_expr_alloc(&low->location, i);
 
-	if (!mpz_cmp(i->key->value, expr_value(low)->value)) {
+	if (!mpz_cmp(i->key->value, key->value)) {
 		set_expr_add(set, low);
 	} else {
 		add_interval(set, low, i, false);
-- 
2.47.3

