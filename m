Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A5C2BEFFE
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259307; cv=none; b=I8Hvq8h7e48Dgi+7BhcMV8zHGUZWEBfbJHhoYhj5/Tfg1+VavZm94JkxFiP5X+J5m6/dJI5ntUMhVPlNEwuBQjgZveYkX9sIZglpKmBi/F0D8jSw0BBQ/X2F/X2fYIXO/C/NsUNJKUX4Ya7aDiOAy+0loqjvFGuMg1+vXTU/V5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259307; c=relaxed/simple;
	bh=PoYWdW9LGz2fco0qIXIKqpcf975hQ8vmAG/0289OVUY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Su6NJtuK89rInTdOOGnXzYOfoREdOJUvEZ1JI7cpvJgTG+mJ5Ga2KyHmM9SE65Wlm/M6D10+1NTAeD8toh9rXEl6T+VhRsfbkShY0FRhHzDoGlmrv2bh9cQA6fFWQsc4TYo5ibI/vFhodfTHWSLz6kJh5qJoJ9LTdDQXXtkJdzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pqIZCd3o; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pqIZCd3o"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A3DBB60882
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259305;
	bh=gKy/yEaOSMv1QNEwxZrxPd5MOyiaFHpaE/LYqGoh6zQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pqIZCd3oWvkaIDsJtTy/Y1rKAel0tMhFkxe7JFVT6kBa7VUDJ3UKS4hf1wWODx6T6
	 8lVifN4YWB++KpbA+8lrx0hc9etdzG+4FUvmCaoFWIhDQyvFHPXr9isJXI9dH/JS46
	 AKzaayf68Py8ibsOOhSbEoQdfjbjNeax5qKKivdGz849qBsVSsj7/An8w1wvWylgO6
	 ykgSx+rbsvXNBPsKi9niUChy0EOEw+7PnBKWTycMpLpd5fQH4pTQAE6GnYTlrjCEsU
	 5IXewxy08VMdhIstaTshW6alauopGP8dyHUridbR/hG0/MHO5MH/4wxMs8TsXfmIrR
	 xs/0SzyG7kbpg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 09/20] src: use key location to prepare removal of EXPR_SET_ELEM
Date: Thu,  5 Feb 2026 03:41:18 +0100
Message-ID: <20260205024130.1470284-10-pablo@netfilter.org>
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

Again, to prepare for the removal of EXPR_SET_ELEM, use the key
location instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 32 ++++++++++++++++----------------
 src/mergesort.c |  8 ++++----
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 4f15095c4bb4..bf0c5573ee1d 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -106,7 +106,7 @@ static void remove_overlapping_range(struct set_automerge_ctx *ctx,
 				     struct expr *prev, struct expr *i)
 {
 	if (i->key->flags & EXPR_F_KERNEL) {
-		i->location = prev->location;
+		i->key->location = prev->key->location;
 		purge_elem(ctx, i);
 		return;
 	}
@@ -125,13 +125,13 @@ static bool merge_ranges(struct set_automerge_ctx *ctx,
 			 struct range *prev_range, struct range *range)
 {
 	if (prev->key->flags & EXPR_F_KERNEL) {
-		prev->location = i->location;
+		prev->key->location = i->key->location;
 		purge_elem(ctx, prev);
 		mpz_set(i->key->range.low, prev->key->range.low);
 		mpz_set(prev_range->high, range->high);
 		return true;
 	} else if (i->key->flags & EXPR_F_KERNEL) {
-		i->location = prev->location;
+		i->key->location = prev->key->location;
 		purge_elem(ctx, i);
 		mpz_set(prev->key->range.high, i->key->range.high);
 		mpz_set(prev_range->high, range->high);
@@ -330,7 +330,7 @@ static void __adjust_elem_left(struct set *set, struct expr *prev, struct expr *
 static void adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
 			     struct expr *purge)
 {
-	prev->location = i->location;
+	prev->key->location = i->key->location;
 	remove_elem(prev, set, purge);
 	__adjust_elem_left(set, prev, i);
 
@@ -349,7 +349,7 @@ static void __adjust_elem_right(struct set *set, struct expr *prev, struct expr
 static void adjust_elem_right(struct set *set, struct expr *prev, struct expr *i,
 			      struct expr *purge)
 {
-	prev->location = i->location;
+	prev->key->location = i->key->location;
 	remove_elem(prev, set, purge);
 	__adjust_elem_right(set, prev, i);
 
@@ -362,7 +362,7 @@ static void split_range(struct set *set, struct expr *prev, struct expr *i,
 {
 	struct expr *clone;
 
-	prev->location = i->location;
+	prev->key->location = i->key->location;
 
 	if (prev->key->flags & EXPR_F_KERNEL) {
 		clone = expr_clone(prev);
@@ -444,7 +444,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 		}
 
 		if (!prev && elem->key->flags & EXPR_F_REMOVE) {
-			expr_error(msgs, i, "element does not exist");
+			expr_error(msgs, i->key, "element does not exist");
 			err = -1;
 			goto err;
 		}
@@ -460,7 +460,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 		    mpz_cmp(prev_range.high, range.high) == 0) {
 			if (elem->key->flags & EXPR_F_REMOVE) {
 				if (prev->key->flags & EXPR_F_KERNEL) {
-					prev->location = elem->location;
+					prev->key->location = elem->key->location;
 					list_move_tail(&prev->list, &expr_set(purge)->expressions);
 				}
 
@@ -469,12 +469,12 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 			}
 		} else if (set->automerge) {
 			if (setelem_adjust(set, purge, &prev_range, &range, prev, i) < 0) {
-				expr_error(msgs, i, "element does not exist");
+				expr_error(msgs, i->key, "element does not exist");
 				err = -1;
 				goto err;
 			}
 		} else if (elem->key->flags & EXPR_F_REMOVE) {
-			expr_error(msgs, i, "element does not exist");
+			expr_error(msgs, i->key, "element does not exist");
 			err = -1;
 			goto err;
 		}
@@ -620,21 +620,21 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 		if (mpz_cmp(prev_range.low, range.low) <= 0 &&
 		    mpz_cmp(prev_range.high, range.high) >= 0) {
 			if (prev->key->flags & EXPR_F_KERNEL)
-				expr_error(msgs, i, "interval overlaps with an existing one");
+				expr_error(msgs, i->key, "interval overlaps with an existing one");
 			else if (elem->key->flags & EXPR_F_KERNEL)
-				expr_error(msgs, prev, "interval overlaps with an existing one");
+				expr_error(msgs, prev->key, "interval overlaps with an existing one");
 			else
-				expr_binary_error(msgs, i, prev,
+				expr_binary_error(msgs, i->key, prev->key,
 						  "conflicting intervals specified");
 			err = -1;
 			goto err_out;
 		} else if (mpz_cmp(range.low, prev_range.high) <= 0) {
 			if (prev->key->flags & EXPR_F_KERNEL)
-				expr_error(msgs, i, "interval overlaps with an existing one");
+				expr_error(msgs, i->key, "interval overlaps with an existing one");
 			else if (elem->key->flags & EXPR_F_KERNEL)
-				expr_error(msgs, prev, "interval overlaps with an existing one");
+				expr_error(msgs, prev->key, "interval overlaps with an existing one");
 			else
-				expr_binary_error(msgs, i, prev,
+				expr_binary_error(msgs, i->key, prev->key,
 						  "conflicting intervals specified");
 			err = -1;
 			goto err_out;
diff --git a/src/mergesort.c b/src/mergesort.c
index 7b318423a572..2e8ddd22f813 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -30,8 +30,6 @@ static void concat_expr_msort_value(const struct expr *expr, mpz_t value)
 static mpz_srcptr expr_msort_value(const struct expr *expr, mpz_t value)
 {
 	switch (expr->etype) {
-	case EXPR_SET_ELEM:
-		return expr_msort_value(expr->key, value);
 	case EXPR_BINOP:
 	case EXPR_MAPPING:
 	case EXPR_RANGE:
@@ -68,10 +66,12 @@ static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
 	mpz_t value2_tmp;
 	int ret;
 
+	assert(e1->etype == EXPR_SET_ELEM && e2->etype == EXPR_SET_ELEM);
+
 	mpz_init(value1_tmp);
 	mpz_init(value2_tmp);
-	value1 = expr_msort_value(e1, value1_tmp);
-	value2 = expr_msort_value(e2, value2_tmp);
+	value1 = expr_msort_value(e1->key, value1_tmp);
+	value2 = expr_msort_value(e2->key, value2_tmp);
 	ret = mpz_cmp(value1, value2);
 	mpz_clear(value1_tmp);
 	mpz_clear(value2_tmp);
-- 
2.47.3

