Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD89C2877C3
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259309; cv=none; b=eMwD50cvniXmsTcG6BxIb2DjyjPCRbZ9b+6AiQzvWBg4IeGGXhwi4bZG1UgIf4G46UAIW/oQaNbADyuwJ+hBVbCVyVIhHXAU6BVsMGXqzhuZigRoK1w5KzmC8qsqBOwd9X4iXE16S+b06TA205Mv9oBPwQNvZqed5aLZ0l1vAPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259309; c=relaxed/simple;
	bh=RVHQUG6YtQCws2rIecCCqw1gaNx8EKuGsHtPqaoBsag=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwYGTdUV4AQPcHtIDXCvagVd2paBNe9N4R1tr+KEuV68bTJoluvEJtbI6JGnSYdq6iAdFwGSl3gnDzK0Qur5/yjw/SAcW9Un5DrW5nFO8I+O3ep07JpLtKnJA+Sv5SfsZC74918U+ZRn/Wf8kvX8zFl08NVEjHFErUM3Jkk1Xjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OLUpqeHR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OLUpqeHR"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B7EE460871
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259306;
	bh=mji3hEaz82SZE4lU5LsOV+xD6TCwRKkZt/OWdDi73Zw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OLUpqeHRcSSTXBTAUfFCqAmNELee9MB02gHSKWvzzODzvwblU0GUvgfZrdzWwGq3L
	 5yN/GR3LCMiXHCGeFgZ4gFuftuVc+yJz5xnQoG4BUNi61E5mXDMCOUspSE3o+qtEB8
	 lJGQge0ML6wm5gobsAPUGRPJkbXJfNFSoCBVuAvnw7Whpc6yyX1xqm/Q+rhmI72hNu
	 YGdrHmEpwtgsFnKbfWlh4nlW4tLxZ4doct1GG/WjEU+Ygxsg9MWntiZSXzwRG8JVmE
	 HpR+p+NzXVZGmrLE9WNGkTZefI/A1PlKsjmP/GXnLTrmEaElqUBxNV9OQtBmoDNwAu
	 mO43lU+jNredw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 10/20] intervals: remove interval_expr_key()
Date: Thu,  5 Feb 2026 03:41:19 +0100
Message-ID: <20260205024130.1470284-11-pablo@netfilter.org>
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

Since ("src: normalize set element with EXPR_MAPPING"), this became an
empty shim function, remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 72 +++++++++++++++++--------------------------------
 1 file changed, 24 insertions(+), 48 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index bf0c5573ee1d..743e034519b5 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -227,31 +227,14 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
 	mpz_clear(rop);
 }
 
-static struct expr *interval_expr_key(struct expr *i)
-{
-	struct expr *elem;
-
-	switch (i->etype) {
-	case EXPR_SET_ELEM:
-		elem = i;
-		break;
-	default:
-		BUG("unhandled expression type %d", i->etype);
-		return NULL;
-	}
-
-	return elem;
-}
-
 static void set_to_range(struct expr *init)
 {
-	struct expr *i, *elem;
+	struct expr *i;
 
 	list_for_each_entry(i, &expr_set(init)->expressions, list) {
 		assert(i->etype == EXPR_SET_ELEM);
 
-		elem = interval_expr_key(i);
-		setelem_expr_to_range(elem);
+		setelem_expr_to_range(i);
 	}
 }
 
@@ -410,7 +393,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 			  struct expr *purge, struct expr *elems,
 			  unsigned int debug_mask)
 {
-	struct expr *i, *next, *elem, *prev = NULL;
+	struct expr *i, *next, *prev = NULL;
 	struct range range, prev_range;
 	int err = 0;
 	mpz_t rop;
@@ -421,10 +404,8 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 	mpz_init(range.high);
 	mpz_init(rop);
 
-	list_for_each_entry_safe(elem, next, &expr_set(elems)->expressions, list) {
-		assert(elem->etype == EXPR_SET_ELEM);
-
-		i = interval_expr_key(elem);
+	list_for_each_entry_safe(i, next, &expr_set(elems)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
 
 		if (expr_type_catchall(i->key)) {
 			uint32_t len;
@@ -443,14 +424,14 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 			range_expr_value_high(range.high, i->key);
 		}
 
-		if (!prev && elem->key->flags & EXPR_F_REMOVE) {
+		if (!prev && i->key->flags & EXPR_F_REMOVE) {
 			expr_error(msgs, i->key, "element does not exist");
 			err = -1;
 			goto err;
 		}
 
-		if (!(elem->key->flags & EXPR_F_REMOVE)) {
-			prev = elem;
+		if (!(i->key->flags & EXPR_F_REMOVE)) {
+			prev = i;
 			mpz_set(prev_range.low, range.low);
 			mpz_set(prev_range.high, range.high);
 			continue;
@@ -458,14 +439,14 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 
 		if (mpz_cmp(prev_range.low, range.low) == 0 &&
 		    mpz_cmp(prev_range.high, range.high) == 0) {
-			if (elem->key->flags & EXPR_F_REMOVE) {
+			if (i->key->flags & EXPR_F_REMOVE) {
 				if (prev->key->flags & EXPR_F_KERNEL) {
-					prev->key->location = elem->key->location;
+					prev->key->location = i->key->location;
 					list_move_tail(&prev->list, &expr_set(purge)->expressions);
 				}
 
-				list_del(&elem->list);
-				expr_free(elem);
+				list_del(&i->list);
+				expr_free(i);
 			}
 		} else if (set->automerge) {
 			if (setelem_adjust(set, purge, &prev_range, &range, prev, i) < 0) {
@@ -473,7 +454,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 				err = -1;
 				goto err;
 			}
-		} else if (elem->key->flags & EXPR_F_REMOVE) {
+		} else if (i->key->flags & EXPR_F_REMOVE) {
 			expr_error(msgs, i->key, "element does not exist");
 			err = -1;
 			goto err;
@@ -584,7 +565,7 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 static int setelem_overlap(struct list_head *msgs, struct set *set,
 			   struct expr *init)
 {
-	struct expr *i, *next, *elem, *prev = NULL;
+	struct expr *i, *next, *prev = NULL;
 	struct range range, prev_range;
 	int err = 0;
 	mpz_t rop;
@@ -595,10 +576,8 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 	mpz_init(range.high);
 	mpz_init(rop);
 
-	list_for_each_entry_safe(elem, next, &expr_set(init)->expressions, list) {
-		assert(elem->etype == EXPR_SET_ELEM);
-
-		i = interval_expr_key(elem);
+	list_for_each_entry_safe(i, next, &expr_set(init)->expressions, list) {
+		assert(i->etype == EXPR_SET_ELEM);
 
 		if (expr_type_catchall(i->key))
 			continue;
@@ -607,7 +586,7 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 		range_expr_value_high(range.high, i->key);
 
 		if (!prev) {
-			prev = elem;
+			prev = i;
 			mpz_set(prev_range.low, range.low);
 			mpz_set(prev_range.high, range.high);
 			continue;
@@ -621,7 +600,7 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 		    mpz_cmp(prev_range.high, range.high) >= 0) {
 			if (prev->key->flags & EXPR_F_KERNEL)
 				expr_error(msgs, i->key, "interval overlaps with an existing one");
-			else if (elem->key->flags & EXPR_F_KERNEL)
+			else if (i->key->flags & EXPR_F_KERNEL)
 				expr_error(msgs, prev->key, "interval overlaps with an existing one");
 			else
 				expr_binary_error(msgs, i->key, prev->key,
@@ -631,7 +610,7 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 		} else if (mpz_cmp(range.low, prev_range.high) <= 0) {
 			if (prev->key->flags & EXPR_F_KERNEL)
 				expr_error(msgs, i->key, "interval overlaps with an existing one");
-			else if (elem->key->flags & EXPR_F_KERNEL)
+			else if (i->key->flags & EXPR_F_KERNEL)
 				expr_error(msgs, prev->key, "interval overlaps with an existing one");
 			else
 				expr_binary_error(msgs, i->key, prev->key,
@@ -640,7 +619,7 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 			goto err_out;
 		}
 next:
-		prev = elem;
+		prev = i;
 		mpz_set(prev_range.low, range.low);
 		mpz_set(prev_range.high, range.high);
 	}
@@ -721,23 +700,20 @@ static bool range_low_is_non_zero(const struct expr *expr)
 
 int set_to_intervals(const struct set *set, struct expr *init, bool add)
 {
-	struct expr *i, *n, *prev = NULL, *elem, *root, *expr;
+	struct expr *i, *n, *prev = NULL, *root, *expr;
 	LIST_HEAD(intervals);
 	mpz_t p;
 
 	list_for_each_entry_safe(i, n, &expr_set(init)->expressions, list) {
-		assert(i->etype == EXPR_SET_ELEM);
 
-		elem = interval_expr_key(i);
-
-		if (expr_type_catchall(elem->key))
+		if (expr_type_catchall(i->key))
 			continue;
 
 		if (prev)
 			break;
 
 		if (segtree_needs_first_segment(set, init, add) &&
-		    range_low_is_non_zero(elem->key)) {
+		    range_low_is_non_zero(i->key)) {
 			mpz_init2(p, set->key->len);
 			mpz_set_ui(p, 0);
 			expr = constant_range_expr_alloc(&internal_location,
@@ -845,7 +821,7 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 					 low, expr_get(elem->key->right));
 
 	low = set_elem_expr_alloc(&key->location, low);
-	set_elem_expr_copy(low, interval_expr_key(elem));
+	set_elem_expr_copy(low, elem);
 
 	list_add_tail(&low->list, intervals);
 
-- 
2.47.3

