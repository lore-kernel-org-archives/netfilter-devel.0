Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB472BEFFE
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259305; cv=none; b=U46NU6KR1W+99A6TS2Xdpqt3dGKislE0pKu/kWX8DNoH0GwVF/L228NrJaXAmEfbKaTJVbd2IT9iOM3yUyvDD2DpyV3uWOne9/Tu+cRN/w+eet7WVPLr1iI9/sSbjwNmtc26pC/TIXXZl5BBm44Am888lpdDQvsVt1NfAqwUNTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259305; c=relaxed/simple;
	bh=KD6pccF6zm+4o4xKXJ60mlu7meCgq6xxj6V6/GexXck=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIkSJpuftP5wtZVc8Bv6orBink1hPcCMxaRmBo37oKuxNWDkW8AOq7D+7hZUIlDVTlRpoT7wZb6pT8kkAyZOYO3qYF5CnCZCo8qulAX3GqY5GqI1xjcWNZB41OUvZIdm68S9ITHq7h+tNpCJCCJ8O6+rj5EDtqJMByZLVCLb+2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aC8nDfAl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aC8nDfAl"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A4F2E60871
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259302;
	bh=oywQIM+1ulS4F1BWUUPFBaJsLddnpyKscDTqbdTIE0M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=aC8nDfAl7eZGkJriecDTZ+O2hIsbZS/mbjorn8ZilPLqwxBb/YJqVC1ckRWwBjg5Q
	 oX3gcx/m0XTiQi3pjZ8HyVv6fOHtRPsCV//Z6LLDkLZtQvjzf4TiVgXtiaEpaiCN5B
	 LVcjsTP4Q6lQ1jiU5RiW2rJLSiCf4mY9PsFvK7neYsLeD+GkACNoCTjNDFVrD3hdCy
	 fR/pZhoVJQBisRSdyaU+sUp11Zwdh+Wxipt3l+/Yq0QZT3js1qWmlFrFQj7NjrNS9x
	 fv/A0xbQnjTB0SsyfDnykxZOq/5TvZoy4e4qihhxU4G8Tj4P9Qg3+GQ4SAvZUKlkkB
	 gseAu2QTs/Ptg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 07/20] src: move flags from EXPR_SET_ELEM to key
Date: Thu,  5 Feb 2026 03:41:16 +0100
Message-ID: <20260205024130.1470284-8-pablo@netfilter.org>
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

This is to prepare to replace EXPR_SET_ELEM by struct set_elem.

Check that expr->flags for EXPR_SET_ELEM are zero from
set_elem_expr_destroy() to validate that there are no more users.

Only EXPR_F_KERNEL is taken in interval.c when converting to constant,
prefix and range in __setelem_expr_to_range().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c   | 13 +++++----
 src/expression.c |  2 ++
 src/intervals.c  | 69 +++++++++++++++++++++++++-----------------------
 src/monitor.c    |  2 +-
 src/netlink.c    | 12 ++++-----
 src/segtree.c    | 26 +++++++++---------
 6 files changed, 64 insertions(+), 60 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7caa161bbe23..3b6008149801 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1896,7 +1896,7 @@ static int __expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr *elem)
 		struct stmt *set_stmt, *elem_stmt;
 
 		if (num_set_exprs > 0 && num_elem_exprs != num_set_exprs) {
-			return expr_error(ctx->msgs, elem,
+			return expr_error(ctx->msgs, elem->key,
 					  "number of statements mismatch, set expects %d "
 					  "but element has %d", num_set_exprs,
 					  num_elem_exprs);
@@ -1992,14 +1992,13 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 	}
 
 	if (ctx->set && !elem_key_compatible(ctx->set->key, elem->key))
-		return expr_error(ctx->msgs, elem,
+		return expr_error(ctx->msgs, elem->key,
 				  "Element mismatches %s definition, expected %s, not '%s'",
 				  set_is_map(ctx->set->flags) ? "map" : "set",
 				  ctx->set->key->dtype->desc, elem->key->dtype->desc);
 
 	datatype_set(elem, elem->key->dtype);
 	elem->len   = elem->key->len;
-	elem->flags = elem->key->flags;
 
 	return 0;
 
@@ -2094,11 +2093,11 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 		}
 
 		if (i->key->etype == EXPR_SET_REF)
-			return expr_error(ctx->msgs, i,
+			return expr_error(ctx->msgs, i->key,
 					  "Set reference cannot be part of another set");
 
-		if (!expr_is_constant(i))
-			return expr_error(ctx->msgs, i,
+		if (!expr_is_constant(i->key))
+			return expr_error(ctx->msgs, i->key,
 					  "Set member is not constant");
 
 		if (i->key->etype == EXPR_SET) {
@@ -2108,7 +2107,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			expr_set(set)->size      += expr_set(i->key)->size - 1;
 			expr_set(set)->set_flags |= expr_set(i->key)->set_flags;
 			expr_free(i);
-		} else if (!expr_is_singleton(i)) {
+		} else if (!expr_is_singleton(i->key)) {
 			expr_set(set)->set_flags |= NFT_SET_INTERVAL;
 			if ((i->key->etype == EXPR_MAPPING &&
 			     i->key->left->etype == EXPR_CONCAT) ||
diff --git a/src/expression.c b/src/expression.c
index f356cf117307..fac4901d8ecc 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1704,6 +1704,8 @@ static void set_elem_expr_destroy(struct expr *expr)
 {
 	struct stmt *stmt, *next;
 
+	assert(expr->flags == 0);
+
 	free_const(expr->comment);
 	expr_free(expr->key);
 	list_for_each_entry_safe(stmt, next, &expr->stmt_list, list)
diff --git a/src/intervals.c b/src/intervals.c
index ec4435e08690..0a1e8fc79ecd 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -31,6 +31,7 @@ static void __setelem_expr_to_range(struct expr **exprp)
 						expr->len,
 						expr->left->value,
 						expr->right->value);
+		key->flags |= expr->flags & EXPR_F_KERNEL;
 		expr_free(*exprp);
 		*exprp = key;
 		break;
@@ -50,6 +51,7 @@ static void __setelem_expr_to_range(struct expr **exprp)
 						expr->len,
 						expr->prefix->value,
 						rop);
+		key->flags |= expr->flags & EXPR_F_KERNEL;
 		mpz_clear(rop);
 		expr_free(*exprp);
 		*exprp = key;
@@ -64,6 +66,7 @@ static void __setelem_expr_to_range(struct expr **exprp)
 						expr->len,
 						expr->value,
 						expr->value);
+		key->flags |= expr->flags & EXPR_F_KERNEL;
 		expr_free(*exprp);
 		*exprp = key;
 		break;
@@ -102,7 +105,7 @@ static void purge_elem(struct set_automerge_ctx *ctx, struct expr *i)
 static void remove_overlapping_range(struct set_automerge_ctx *ctx,
 				     struct expr *prev, struct expr *i)
 {
-	if (i->flags & EXPR_F_KERNEL) {
+	if (i->key->flags & EXPR_F_KERNEL) {
 		i->location = prev->location;
 		purge_elem(ctx, i);
 		return;
@@ -121,13 +124,13 @@ static bool merge_ranges(struct set_automerge_ctx *ctx,
 			 struct expr *prev, struct expr *i,
 			 struct range *prev_range, struct range *range)
 {
-	if (prev->flags & EXPR_F_KERNEL) {
+	if (prev->key->flags & EXPR_F_KERNEL) {
 		prev->location = i->location;
 		purge_elem(ctx, prev);
 		mpz_set(i->key->range.low, prev->key->range.low);
 		mpz_set(prev_range->high, range->high);
 		return true;
-	} else if (i->flags & EXPR_F_KERNEL) {
+	} else if (i->key->flags & EXPR_F_KERNEL) {
 		i->location = prev->location;
 		purge_elem(ctx, i);
 		mpz_set(prev->key->range.high, i->key->range.high);
@@ -280,7 +283,7 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	list_for_each_entry_safe(i, next, &expr_set(init)->expressions, list) {
 		assert(i->etype == EXPR_SET_ELEM);
 
-		if (i->flags & EXPR_F_KERNEL) {
+		if (i->key->flags & EXPR_F_KERNEL) {
 			list_move_tail(&i->list, &expr_set(existing_set->init)->expressions);
 		} else if (existing_set) {
 			if (debug_mask & NFT_DEBUG_SEGTREE) {
@@ -288,7 +291,7 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 					     i->key->range.low, i->key->range.high);
 			}
 			clone = expr_clone(i);
-			clone->flags |= EXPR_F_KERNEL;
+			clone->key->flags |= EXPR_F_KERNEL;
 			__set_expr_add(existing_set->init, clone);
 		}
 	}
@@ -310,7 +313,7 @@ static void remove_elem(struct expr *prev, struct set *set, struct expr *purge)
 {
 	struct expr *clone;
 
-	if (prev->flags & EXPR_F_KERNEL) {
+	if (prev->key->flags & EXPR_F_KERNEL) {
 		clone = expr_clone(prev);
 		list_move_tail(&clone->list, &expr_set(purge)->expressions);
 	}
@@ -318,7 +321,7 @@ static void remove_elem(struct expr *prev, struct set *set, struct expr *purge)
 
 static void __adjust_elem_left(struct set *set, struct expr *prev, struct expr *i)
 {
-	prev->flags &= ~EXPR_F_KERNEL;
+	prev->key->flags &= ~EXPR_F_KERNEL;
 	mpz_set(prev->key->range.low, i->key->range.high);
 	mpz_add_ui(prev->key->range.low, prev->key->range.low, 1);
 	list_move(&prev->list, &expr_set(set->existing_set->init)->expressions);
@@ -337,7 +340,7 @@ static void adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
 
 static void __adjust_elem_right(struct set *set, struct expr *prev, struct expr *i)
 {
-	prev->flags &= ~EXPR_F_KERNEL;
+	prev->key->flags &= ~EXPR_F_KERNEL;
 	mpz_set(prev->key->range.high, i->key->range.low);
 	mpz_sub_ui(prev->key->range.high, prev->key->range.high, 1);
 	list_move(&prev->list, &expr_set(set->existing_set->init)->expressions);
@@ -361,12 +364,12 @@ static void split_range(struct set *set, struct expr *prev, struct expr *i,
 
 	prev->location = i->location;
 
-	if (prev->flags & EXPR_F_KERNEL) {
+	if (prev->key->flags & EXPR_F_KERNEL) {
 		clone = expr_clone(prev);
 		list_move_tail(&clone->list, &expr_set(purge)->expressions);
 	}
 
-	prev->flags &= ~EXPR_F_KERNEL;
+	prev->key->flags &= ~EXPR_F_KERNEL;
 	clone = expr_clone(prev);
 	mpz_set(clone->key->range.low, i->key->range.high);
 	mpz_add_ui(clone->key->range.low, i->key->range.high, 1);
@@ -386,15 +389,15 @@ static int setelem_adjust(struct set *set, struct expr *purge,
 {
 	if (mpz_cmp(prev_range->low, range->low) == 0 &&
 	    mpz_cmp(prev_range->high, range->high) > 0) {
-		if (i->flags & EXPR_F_REMOVE)
+		if (i->key->flags & EXPR_F_REMOVE)
 			adjust_elem_left(set, prev, i, purge);
 	} else if (mpz_cmp(prev_range->low, range->low) < 0 &&
 		   mpz_cmp(prev_range->high, range->high) == 0) {
-		if (i->flags & EXPR_F_REMOVE)
+		if (i->key->flags & EXPR_F_REMOVE)
 			adjust_elem_right(set, prev, i, purge);
 	} else if (mpz_cmp(prev_range->low, range->low) < 0 &&
 		   mpz_cmp(prev_range->high, range->high) > 0) {
-		if (i->flags & EXPR_F_REMOVE)
+		if (i->key->flags & EXPR_F_REMOVE)
 			split_range(set, prev, i, purge);
 	} else {
 		return -1;
@@ -440,13 +443,13 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 			range_expr_value_high(range.high, i);
 		}
 
-		if (!prev && elem->flags & EXPR_F_REMOVE) {
+		if (!prev && elem->key->flags & EXPR_F_REMOVE) {
 			expr_error(msgs, i, "element does not exist");
 			err = -1;
 			goto err;
 		}
 
-		if (!(elem->flags & EXPR_F_REMOVE)) {
+		if (!(elem->key->flags & EXPR_F_REMOVE)) {
 			prev = elem;
 			mpz_set(prev_range.low, range.low);
 			mpz_set(prev_range.high, range.high);
@@ -455,8 +458,8 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 
 		if (mpz_cmp(prev_range.low, range.low) == 0 &&
 		    mpz_cmp(prev_range.high, range.high) == 0) {
-			if (elem->flags & EXPR_F_REMOVE) {
-				if (prev->flags & EXPR_F_KERNEL) {
+			if (elem->key->flags & EXPR_F_REMOVE) {
+				if (prev->key->flags & EXPR_F_KERNEL) {
 					prev->location = elem->location;
 					list_move_tail(&prev->list, &expr_set(purge)->expressions);
 				}
@@ -470,7 +473,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 				err = -1;
 				goto err;
 			}
-		} else if (elem->flags & EXPR_F_REMOVE) {
+		} else if (elem->key->flags & EXPR_F_REMOVE) {
 			expr_error(msgs, i, "element does not exist");
 			err = -1;
 			goto err;
@@ -506,7 +509,7 @@ static int __set_delete(struct list_head *msgs, struct expr *i,	struct set *set,
 			struct expr *init, struct set *existing_set,
 			unsigned int debug_mask)
 {
-	i->flags |= EXPR_F_REMOVE;
+	i->key->flags |= EXPR_F_REMOVE;
 	list_move_tail(&i->list, &expr_set(existing_set->init)->expressions);
 	list_expr_sort(&expr_set(existing_set->init)->expressions);
 
@@ -546,10 +549,10 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 
 	add = set_expr_alloc(&internal_location, set);
 	list_for_each_entry(i, &expr_set(existing_set->init)->expressions, list) {
-		if (!(i->flags & EXPR_F_KERNEL)) {
+		if (!(i->key->flags & EXPR_F_KERNEL)) {
 			clone = expr_clone(i);
 			__set_expr_add(add, clone);
-			i->flags |= EXPR_F_KERNEL;
+			i->key->flags |= EXPR_F_KERNEL;
 		}
 	}
 
@@ -616,9 +619,9 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 
 		if (mpz_cmp(prev_range.low, range.low) <= 0 &&
 		    mpz_cmp(prev_range.high, range.high) >= 0) {
-			if (prev->flags & EXPR_F_KERNEL)
+			if (prev->key->flags & EXPR_F_KERNEL)
 				expr_error(msgs, i, "interval overlaps with an existing one");
-			else if (elem->flags & EXPR_F_KERNEL)
+			else if (elem->key->flags & EXPR_F_KERNEL)
 				expr_error(msgs, prev, "interval overlaps with an existing one");
 			else
 				expr_binary_error(msgs, i, prev,
@@ -626,9 +629,9 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 			err = -1;
 			goto err_out;
 		} else if (mpz_cmp(range.low, prev_range.high) <= 0) {
-			if (prev->flags & EXPR_F_KERNEL)
+			if (prev->key->flags & EXPR_F_KERNEL)
 				expr_error(msgs, i, "interval overlaps with an existing one");
-			else if (elem->flags & EXPR_F_KERNEL)
+			else if (elem->key->flags & EXPR_F_KERNEL)
 				expr_error(msgs, prev, "interval overlaps with an existing one");
 			else
 				expr_binary_error(msgs, i, prev,
@@ -666,11 +669,11 @@ int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 	list_for_each_entry_safe(i, n, &expr_set(init)->expressions, list) {
 		assert(i->etype == EXPR_SET_ELEM);
 
-		if (i->flags & EXPR_F_KERNEL)
+		if (i->key->flags & EXPR_F_KERNEL)
 			list_move_tail(&i->list, &expr_set(existing_set->init)->expressions);
 		else if (existing_set) {
 			clone = expr_clone(i);
-			clone->flags |= EXPR_F_KERNEL;
+			clone->key->flags |= EXPR_F_KERNEL;
 			__set_expr_add(existing_set->init, clone);
 		}
 	}
@@ -745,7 +748,7 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 
 			root = set_elem_expr_alloc(&internal_location, expr);
 
-			root->flags |= EXPR_F_INTERVAL_END;
+			root->key->flags |= EXPR_F_INTERVAL_END;
 			list_add(&root->list, &intervals);
 			break;
 		}
@@ -821,7 +824,7 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 	assert(!next_key || next_key->etype == EXPR_RANGE_VALUE);
 
 	/* skip end element for adjacents intervals in anonymous sets. */
-	if (!(elem->flags & EXPR_F_INTERVAL_END) && next_key) {
+	if (!(elem->key->flags & EXPR_F_INTERVAL_END) && next_key) {
 		mpz_t p;
 
 		mpz_init2(p, set->key->len);
@@ -848,11 +851,11 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 
 	if (adjacent)
 		return 0;
-	else if (!mpz_cmp_ui(key->value, 0) && elem->flags & EXPR_F_INTERVAL_END) {
-		low->flags |= EXPR_F_INTERVAL_END;
+	else if (!mpz_cmp_ui(key->value, 0) && elem->key->flags & EXPR_F_INTERVAL_END) {
+		low->key->flags |= EXPR_F_INTERVAL_END;
 		return 0;
 	} else if (mpz_scan0(key->range.high, 0) == set->key->len) {
-		low->flags |= EXPR_F_INTERVAL_OPEN;
+		low->key->flags |= EXPR_F_INTERVAL_OPEN;
 		return 0;
 	}
 
@@ -865,7 +868,7 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 
 	high = set_elem_expr_alloc(&key->location, high);
 
-	high->flags |= EXPR_F_INTERVAL_END;
+	high->key->flags |= EXPR_F_INTERVAL_END;
 	list_add_tail(&high->list, intervals);
 
 	return 0;
diff --git a/src/monitor.c b/src/monitor.c
index 6532c9c50f8d..e5803e32a467 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -380,7 +380,7 @@ static bool set_elem_is_open_interval(struct expr *elem)
 {
 	switch (elem->etype) {
 	case EXPR_SET_ELEM:
-		return elem->flags & EXPR_F_INTERVAL_OPEN;
+		return elem->key->flags & EXPR_F_INTERVAL_OPEN;
 	case EXPR_MAPPING:
 		return set_elem_is_open_interval(elem->left);
 	default:
diff --git a/src/netlink.c b/src/netlink.c
index 34c667995489..5e59cb7b2d8f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -186,7 +186,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 						netlink_gen_stmt_stateful(stmt));
 		}
 	}
-	if (elem->comment || expr->flags & EXPR_F_INTERVAL_OPEN) {
+	if (elem->comment || expr->key->flags & EXPR_F_INTERVAL_OPEN) {
 		udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 		if (!udbuf)
 			memory_allocation_error();
@@ -196,7 +196,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 					  elem->comment))
 			memory_allocation_error();
 	}
-	if (expr->flags & EXPR_F_INTERVAL_OPEN) {
+	if (expr->key->flags & EXPR_F_INTERVAL_OPEN) {
 		if (!nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_ELEM_FLAGS,
 					 NFTNL_SET_ELEM_F_INTERVAL_OPEN))
 			memory_allocation_error();
@@ -239,7 +239,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 				   nld.value, nld.len);
 	}
 
-	if (expr->flags & EXPR_F_INTERVAL_END)
+	if (expr->key->flags & EXPR_F_INTERVAL_END)
 		flags |= NFT_SET_ELEM_INTERVAL_END;
 	if (key->etype == EXPR_SET_ELEM_CATCHALL)
 		flags |= NFT_SET_ELEM_CATCHALL;
@@ -1556,7 +1556,7 @@ static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
 		elem_flags =
 			nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_ELEM_FLAGS]);
 		if (elem_flags & NFTNL_SET_ELEM_F_INTERVAL_OPEN)
-			expr->flags |= EXPR_F_INTERVAL_OPEN;
+			expr->key->flags |= EXPR_F_INTERVAL_OPEN;
 	}
 }
 
@@ -1653,7 +1653,7 @@ key_end:
 	}
 out:
 	expr = set_elem_expr_alloc(&netlink_location, key);
-	expr->flags |= EXPR_F_KERNEL;
+	expr->key->flags |= EXPR_F_KERNEL;
 
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_TIMEOUT)) {
 		expr->timeout	 = nftnl_set_elem_get_u64(nlse, NFTNL_SET_ELEM_TIMEOUT);
@@ -1682,7 +1682,7 @@ out:
 	list_splice_tail_init(&setelem_parse_ctx.stmt_list, &expr->stmt_list);
 
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
-		expr->flags |= EXPR_F_INTERVAL_END;
+		expr->key->flags |= EXPR_F_INTERVAL_END;
 		if (mpz_cmp_ui(set->key->value, 0) == 0)
 			set->root = true;
 	}
diff --git a/src/segtree.c b/src/segtree.c
index bf543b9b91ab..37bdcb5867cf 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -62,7 +62,7 @@ static void set_elem_expr_add(const struct set *set, struct expr *init,
 				   byteorder, set->key->len, NULL);
 	mpz_set(expr->value, value);
 	expr = set_elem_expr_alloc(&internal_location, expr);
-	expr->flags = flags;
+	expr->key->flags = flags;
 
 	set_expr_add(init, expr);
 }
@@ -85,11 +85,11 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 		switch (i->key->etype) {
 		case EXPR_VALUE:
 			set_elem_expr_add(set, new_init, i->key->value,
-					  i->flags, byteorder);
+					  i->key->flags, byteorder);
 			break;
 		case EXPR_CONCAT:
 			set_expr_add(new_init, expr_clone(i));
-			i->flags |= EXPR_F_INTERVAL_END;
+			i->key->flags |= EXPR_F_INTERVAL_END;
 			set_expr_add(new_init, expr_clone(i));
 			break;
 		case EXPR_SET_ELEM_CATCHALL:
@@ -180,7 +180,7 @@ static struct expr *__expr_to_set_elem(struct expr *low, struct expr *expr)
 	}
 
 	elem = set_elem_expr_alloc(&low->location, expr);
-	elem->flags |= EXPR_F_KERNEL;
+	elem->key->flags |= EXPR_F_KERNEL;
 	interval_expr_copy(elem, low);
 
 	return elem;
@@ -243,7 +243,7 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 	list_for_each_entry_safe(i, next, &expr_set(set->init)->expressions, list) {
 		assert(i->etype == EXPR_SET_ELEM);
 
-		if (i->flags & EXPR_F_INTERVAL_END && left) {
+		if (i->key->flags & EXPR_F_INTERVAL_END && left) {
 			list_del(&left->list);
 			list_del(&i->list);
 			mpz_sub_ui(i->key->value, i->key->value, 1);
@@ -314,9 +314,9 @@ static int expr_value_cmp(const void *p1, const void *p2)
 
 	ret = mpz_cmp(expr_value(e1)->value, expr_value(e2)->value);
 	if (ret == 0) {
-		if (e1->flags & EXPR_F_INTERVAL_END)
+		if (e1->key->flags & EXPR_F_INTERVAL_END)
 			return -1;
-		else if (e2->flags & EXPR_F_INTERVAL_END)
+		else if (e2->key->flags & EXPR_F_INTERVAL_END)
 			return 1;
 	}
 
@@ -546,7 +546,7 @@ add_interval(struct expr *set, struct expr *low, struct expr *i)
 		if (expr_basetype(low)->type == TYPE_STRING)
 			mpz_switch_byteorder(expr_value(low)->value,
 					     expr_value(low)->len / BITS_PER_BYTE);
-		low->flags |= EXPR_F_KERNEL;
+		low->key->flags |= EXPR_F_KERNEL;
 		expr = expr_get(low);
 	} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
 
@@ -601,11 +601,11 @@ void interval_map_decompose(struct expr *set)
 	for (m = 0; m < size; m++) {
 		i = elements[m];
 
-		if (i->flags & EXPR_F_INTERVAL_END)
+		if (i->key->flags & EXPR_F_INTERVAL_END)
 			interval = false;
 		else if (interval) {
 			end = expr_clone(i);
-			end->flags |= EXPR_F_INTERVAL_END;
+			end->key->flags |= EXPR_F_INTERVAL_END;
 			ranges[n++] = end;
 		} else
 			interval = true;
@@ -618,7 +618,7 @@ void interval_map_decompose(struct expr *set)
 		i = ranges[n];
 
 		if (low == NULL) {
-			if (i->flags & EXPR_F_INTERVAL_END) {
+			if (i->key->flags & EXPR_F_INTERVAL_END) {
 				/*
 				 * End of interval mark
 				 */
@@ -635,7 +635,7 @@ void interval_map_decompose(struct expr *set)
 
 		add_interval(set, low, i);
 
-		if (i->flags & EXPR_F_INTERVAL_END) {
+		if (i->key->flags & EXPR_F_INTERVAL_END) {
 			expr_free(low);
 			low = NULL;
 		}
@@ -660,7 +660,7 @@ void interval_map_decompose(struct expr *set)
 
 out:
 	if (catchall) {
-		catchall->flags |= EXPR_F_KERNEL;
+		catchall->key->flags |= EXPR_F_KERNEL;
 		set_expr_add(set, catchall);
 	}
 
-- 
2.47.3

