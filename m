Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC00FC43217
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Feb 2022 00:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241666AbiBTAbA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 19:31:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241952AbiBTAa7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 19:30:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74CA153715
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 16:30:38 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6572260213
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Feb 2022 01:29:47 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 2/5] src: replace interval segment tree overlap and automerge
Date:   Sun, 20 Feb 2022 01:30:21 +0100
Message-Id: <20220220003024.23317-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220220003024.23317-1-pablo@netfilter.org>
References: <20220220003024.23317-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a rewrite of the segtree interval codebase.

This patch now splits the original set_to_interval() function in three
routines:

- add set_automerge() to merge overlapping and contiguous ranges.
  The elements, expressed either as single value, prefix and ranges are
  all first normalized to ranges. This elements expressed as ranges are
  mergesorted. Then, there is a linear list inspection to check for
  merge candidates. This code only merges elements in the same batch,
  ie. it does not merge elements in the kernela and the userspace batch.

- add set_overlap() to check for overlapping set elements. Linux
  kernel >= 5.7 already checks for overlaps, older kernels still needs
  this code. This code checks for two conflict types:

  1) between elements in this batch.
  2) between elements in this batch and kernelspace.

  The elements in the kernel are temporarily merged into the list of
  elements in the batch to check for this overlaps. The EXPR_F_KERNEL
  flag allows us to restore the set cache after the overlap check has
  been performed.

- set_to_interval() now only transforms set elements, expressed as range
  e.g. [a,b], to individual set elements using the EXPR_F_INTERVAL_END
  flag notation to represent e.g. [a,b+1), where b+1 has the
  EXPR_F_INTERVAL_END flag set on.

More relevant updates:

- The overlap and automerge routines are now performed in the evaluation
  phase.

- The userspace set object representation now stores a reference to the
  existing kernel set object (in case there is already a set with this
  same name in the kernel). This is required by the new overlap and
  automerge approach.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/Makefile.am  |   1 +
 include/expression.h |   4 -
 include/intervals.h  |   9 +
 include/rule.h       |   2 +
 src/Makefile.am      |   1 +
 src/evaluate.c       |  50 +++-
 src/intervals.c      | 370 ++++++++++++++++++++++++
 src/mergesort.c      |   1 +
 src/rule.c           |  13 +-
 src/segtree.c        | 649 -------------------------------------------
 10 files changed, 436 insertions(+), 664 deletions(-)
 create mode 100644 include/intervals.h
 create mode 100644 src/intervals.c

diff --git a/include/Makefile.am b/include/Makefile.am
index b997f46b75be..940b7fafb0b4 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -8,6 +8,7 @@ noinst_HEADERS = 	cli.h		\
 			expression.h	\
 			fib.h		\
 			hash.h		\
+			intervals.h	\
 			ipopt.h		\
 			json.h		\
 			mini-gmp.h	\
diff --git a/include/expression.h b/include/expression.h
index 09393f9c2372..9c30883b706a 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -484,10 +484,6 @@ extern struct expr *list_expr_alloc(const struct location *loc);
 
 extern struct expr *set_expr_alloc(const struct location *loc,
 				   const struct set *set);
-extern int set_to_intervals(struct list_head *msgs, struct set *set,
-			    struct expr *init, bool add,
-			    unsigned int debug_mask, bool merge,
-			    struct output_ctx *octx);
 extern void concat_range_aggregate(struct expr *set);
 extern void interval_map_decompose(struct expr *set);
 
diff --git a/include/intervals.h b/include/intervals.h
new file mode 100644
index 000000000000..f69800638070
--- /dev/null
+++ b/include/intervals.h
@@ -0,0 +1,9 @@
+#ifndef NFTABLES_INTERVALS_H
+#define NFTABLES_INTERVALS_H
+
+void set_to_range(struct expr *init);
+int set_automerge(struct list_head *msgs, struct set *set, struct expr *init);
+int set_overlap(struct list_head *msgs, struct set *set, struct expr *init);
+int set_to_intervals(const struct set *set, struct expr *init, bool add);
+
+#endif
diff --git a/include/rule.h b/include/rule.h
index 150576641b39..e232b97afed7 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -324,6 +324,7 @@ void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
  * @key:	key expression (data type, length))
  * @data:	mapping data expression
  * @objtype:	mapping object type
+ * @existing_set: reference to existing set in the kernel
  * @init:	initializer
  * @rg_cache:	cached range element (left)
  * @policy:	set mechanism policy
@@ -345,6 +346,7 @@ struct set {
 	struct expr		*key;
 	struct expr		*data;
 	uint32_t		objtype;
+	struct set		*existing_set;
 	struct expr		*init;
 	struct expr		*rg_cache;
 	uint32_t		policy;
diff --git a/src/Makefile.am b/src/Makefile.am
index 4cfba0af8bfa..9c57ebbb8022 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -48,6 +48,7 @@ libnftables_la_SOURCES =			\
 		exthdr.c			\
 		fib.c				\
 		hash.c				\
+		intervals.c			\
 		ipopt.c				\
 		meta.c				\
 		rt.c				\
diff --git a/src/evaluate.c b/src/evaluate.c
index 437eacb8209f..bf38bd661a53 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -29,6 +29,7 @@
 
 #include <expression.h>
 #include <statement.h>
+#include <intervals.h>
 #include <netlink.h>
 #include <time.h>
 #include <rule.h>
@@ -1422,6 +1423,36 @@ static const struct expr *expr_set_elem(const struct expr *expr)
 	return expr;
 }
 
+static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
+			     struct expr *init)
+{
+	int ret;
+
+	if (!init)
+		return 0;
+
+	ret = 0;
+	switch (ctx->cmd->op) {
+	case CMD_CREATE:
+	case CMD_ADD:
+		if (set->automerge)
+			ret = set_automerge(ctx->msgs, set, init);
+		else
+			ret = set_overlap(ctx->msgs, set, init);
+		break;
+	case CMD_DELETE:
+		set_to_range(init);
+		break;
+	case CMD_GET:
+		break;
+	default:
+		assert(1);
+		break;
+	}
+
+	return ret;
+}
+
 static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *set = *expr, *i, *next;
@@ -1509,6 +1540,12 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 	datatype_set(set, ctx->ectx.dtype);
 	set->len   = ctx->ectx.len;
 	set->flags |= EXPR_F_CONSTANT;
+
+	if (ctx->set &&
+	    (set_is_interval(ctx->set->flags) || set_is_interval (set->set_flags)) &&
+	    !(set->set_flags & NFT_SET_CONCAT))
+		return interval_set_eval(ctx, ctx->set, set);
+
 	return 0;
 }
 
@@ -3878,6 +3915,7 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 		return set_not_found(ctx, &ctx->cmd->handle.set.location,
 				     ctx->cmd->handle.set.name);
 
+	set->existing_set = set;
 	ctx->set = set;
 	expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
 	if (expr_evaluate(ctx, &cmd->expr) < 0)
@@ -3944,6 +3982,7 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 
 static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 {
+	struct set *existing_set = NULL;
 	unsigned int num_stmts = 0;
 	struct table *table;
 	struct stmt *stmt;
@@ -3956,7 +3995,8 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		if (!set_cache_find(table, set->handle.set.name))
+		existing_set = set_cache_find(table, set->handle.set.name);
+		if (!existing_set)
 			set_cache_add(set_get(set), table);
 	}
 
@@ -4020,9 +4060,15 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	if (num_stmts > 1)
 		set->flags |= NFT_SET_EXPR;
 
-	if (set_is_anonymous(set->flags))
+	if (set_is_anonymous(set->flags)) {
+		if (set_is_interval(set->flags) && !(set->flags & NFT_SET_CONCAT) &&
+		    interval_set_eval(ctx, set, set->init) < 0)
+			return -1;
+
 		return 0;
+	}
 
+	set->existing_set = existing_set;
 	ctx->set = set;
 	if (set->init != NULL) {
 		__expr_set_context(&ctx->ectx, set->key->dtype,
diff --git a/src/intervals.c b/src/intervals.c
new file mode 100644
index 000000000000..2e5ea122835e
--- /dev/null
+++ b/src/intervals.c
@@ -0,0 +1,370 @@
+/*
+ * Copyright (c) 2022 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
+#include <nftables.h>
+#include <expression.h>
+#include <intervals.h>
+#include <rule.h>
+
+static void setelem_expr_to_range(struct expr *expr)
+{
+	unsigned char data[sizeof(struct in6_addr) * BITS_PER_BYTE];
+	struct expr *key, *value;
+	mpz_t rop;
+
+	assert(expr->etype == EXPR_SET_ELEM);
+
+	switch (expr->key->etype) {
+	case EXPR_RANGE:
+		break;
+	case EXPR_PREFIX:
+		mpz_init(rop);
+		mpz_bitmask(rop, expr->key->len - expr->key->prefix_len);
+		mpz_ior(rop, rop, expr->key->prefix->value);
+	        mpz_export_data(data, rop, expr->key->prefix->byteorder,
+				expr->key->prefix->len / BITS_PER_BYTE);
+		mpz_clear(rop);
+		value = constant_expr_alloc(&expr->location,
+					    expr->key->prefix->dtype,
+					    expr->key->prefix->byteorder,
+					    expr->key->prefix->len, data);
+		key = range_expr_alloc(&expr->location,
+				       expr_get(expr->key->prefix),
+				       value);
+		expr_free(expr->key);
+		expr->key = key;
+		break;
+	case EXPR_VALUE:
+		key = range_expr_alloc(&expr->location,
+				       expr_get(expr->key),
+				       expr_get(expr->key));
+		expr_free(expr->key);
+		expr->key = key;
+		break;
+	default:
+		assert(1);
+	}
+}
+
+static void remove_overlapping_range(struct expr *i, struct expr *init)
+{
+	list_del(&i->list);
+	expr_free(i);
+	init->size--;
+}
+
+struct range {
+	mpz_t	low;
+	mpz_t	high;
+};
+
+static void merge_ranges(struct expr *prev, struct expr *i,
+			 struct range *prev_range, struct range *range,
+			 struct expr *init)
+{
+	expr_free(prev->key->right);
+	prev->key->right = expr_get(i->key->right);
+	list_del(&i->list);
+	expr_free(i);
+	mpz_set(prev_range->high, range->high);
+	init->size--;
+}
+
+static int setelem_automerge(struct list_head *msgs, struct set *set,
+			     struct expr *init)
+{
+	struct expr *i, *next, *prev = NULL;
+	struct range range, prev_range;
+	int err = 0;
+	mpz_t rop;
+
+	mpz_init(prev_range.low);
+	mpz_init(prev_range.high);
+	mpz_init(range.low);
+	mpz_init(range.high);
+	mpz_init(rop);
+
+	list_for_each_entry_safe(i, next, &init->expressions, list) {
+		if (i->key->etype == EXPR_SET_ELEM_CATCHALL)
+			continue;
+
+		range_expr_value_low(range.low, i);
+		range_expr_value_high(range.high, i);
+
+		if (!prev) {
+			prev = i;
+			mpz_set(prev_range.low, range.low);
+			mpz_set(prev_range.high, range.high);
+			continue;
+		}
+
+		if (mpz_cmp(prev_range.low, range.low) <= 0 &&
+		    mpz_cmp(prev_range.high, range.high) >= 0) {
+			remove_overlapping_range(i, init);
+			continue;
+		} else if (mpz_cmp(range.low, prev_range.high) <= 0) {
+			merge_ranges(prev, i, &prev_range, &range, init);
+			continue;
+		} else if (set->automerge) {
+			mpz_sub(rop, range.low, prev_range.high);
+			/* two contiguous ranges */
+			if (mpz_cmp_ui(rop, 1) == 0) {
+				merge_ranges(prev, i, &prev_range, &range, init);
+				continue;
+			}
+		}
+
+		prev = i;
+		mpz_set(prev_range.low, range.low);
+		mpz_set(prev_range.high, range.high);
+	}
+
+	mpz_clear(prev_range.low);
+	mpz_clear(prev_range.high);
+	mpz_clear(range.low);
+	mpz_clear(range.high);
+	mpz_clear(rop);
+
+	return err;
+}
+
+void set_to_range(struct expr *init)
+{
+	struct expr *i, *elem;
+
+	list_for_each_entry(i, &init->expressions, list) {
+		switch (i->etype) {
+		case EXPR_MAPPING:
+			elem = i->left;
+			break;
+		case EXPR_SET_ELEM:
+			elem = i;
+			break;
+		default:
+			assert(1);
+		}
+		setelem_expr_to_range(elem);
+	}
+
+	list_expr_sort(&init->expressions);
+}
+
+int set_automerge(struct list_head *msgs, struct set *set, struct expr *init)
+{
+	set_to_range(init);
+
+	if (set->flags & NFT_SET_MAP)
+		return 0;
+
+	return setelem_automerge(msgs, set, init);
+}
+
+static int setelem_overlap(struct list_head *msgs, struct set *set,
+			   struct expr *init)
+{
+	struct expr *i, *next, *elem, *prev = NULL;
+	struct range range, prev_range;
+	int err = 0;
+	mpz_t rop;
+
+	mpz_init(prev_range.low);
+	mpz_init(prev_range.high);
+	mpz_init(range.low);
+	mpz_init(range.high);
+	mpz_init(rop);
+
+	list_for_each_entry_safe(elem, next, &init->expressions, list) {
+		switch (elem->etype) {
+		case EXPR_MAPPING:
+			i = elem->left;
+			break;
+		case EXPR_SET_ELEM:
+			i = elem;
+			break;
+		default:
+			assert(1);
+		}
+
+		if (i->key->etype == EXPR_SET_ELEM_CATCHALL)
+			continue;
+
+		range_expr_value_low(range.low, i);
+		range_expr_value_high(range.high, i);
+
+		if (!prev) {
+			prev = elem;
+			mpz_set(prev_range.low, range.low);
+			mpz_set(prev_range.high, range.high);
+			continue;
+		}
+
+		if (mpz_cmp(prev_range.low, range.low) == 0 &&
+		    mpz_cmp(prev_range.high, range.high) == 0 &&
+		    (elem->flags & EXPR_F_KERNEL || prev->flags & EXPR_F_KERNEL))
+			goto next;
+
+		if (mpz_cmp(prev_range.low, range.low) <= 0 &&
+		    mpz_cmp(prev_range.high, range.high) >= 0) {
+			if (prev->flags & EXPR_F_KERNEL)
+				expr_error(msgs, i, "interval overlaps with an existing one");
+			else if (elem->flags & EXPR_F_KERNEL)
+				expr_error(msgs, prev, "interval overlaps with an existing one");
+			else
+				expr_binary_error(msgs, i, prev,
+						  "conflicting intervals specified");
+			err = -1;
+			goto err_out;
+		} else if (mpz_cmp(range.low, prev_range.high) <= 0) {
+			if (prev->flags & EXPR_F_KERNEL)
+				expr_error(msgs, i, "interval overlaps with an existing one");
+			else if (elem->flags & EXPR_F_KERNEL)
+				expr_error(msgs, prev, "interval overlaps with an existing one");
+			else
+				expr_binary_error(msgs, i, prev,
+						  "conflicting intervals specified");
+			err = -1;
+			goto err_out;
+		}
+next:
+		prev = elem;
+		mpz_set(prev_range.low, range.low);
+		mpz_set(prev_range.high, range.high);
+	}
+
+err_out:
+	mpz_clear(prev_range.low);
+	mpz_clear(prev_range.high);
+	mpz_clear(range.low);
+	mpz_clear(range.high);
+	mpz_clear(rop);
+
+	return err;
+}
+
+/* overlap detection for intervals already exists in Linux kernels >= 5.7. */
+int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
+{
+	struct set *existing_set = set->existing_set;
+	struct expr *i, *n;
+	int err;
+
+	if (existing_set && existing_set->init) {
+		list_splice_init(&existing_set->init->expressions,
+				 &init->expressions);
+	}
+
+	set_to_range(init);
+
+	err = setelem_overlap(msgs, set, init);
+
+	list_for_each_entry_safe(i, n, &init->expressions, list) {
+		if (i->flags & EXPR_F_KERNEL)
+			list_move_tail(&i->list, &existing_set->init->expressions);
+	}
+
+	return err;
+}
+
+static bool segtree_needs_first_segment(const struct set *set,
+					const struct expr *init, bool add)
+{
+	if (add && !set->root) {
+		/* Add the first segment in four situations:
+		 *
+		 * 1) This is an anonymous set.
+		 * 2) This set exists and it is empty.
+		 * 3) New empty set and, separately, new elements are added.
+		 * 4) This set is created with a number of initial elements.
+		 */
+		if ((set_is_anonymous(set->flags)) ||
+		    (set->init && set->init->size == 0) ||
+		    (set->init == NULL && init) ||
+		    (set->init == init)) {
+			return true;
+		}
+	}
+	/* This is an update for a set that already contains elements, so don't
+	 * add the first non-matching elements otherwise we hit EEXIST.
+	 */
+	return false;
+}
+
+int set_to_intervals(const struct set *set, struct expr *init, bool add)
+{
+	struct expr *i, *n, *prev = NULL, *elem, *newelem, *expr;
+	uint32_t flags;
+	mpz_t p, q;
+
+	mpz_init2(p, set->key->len);
+	mpz_init2(q, set->key->len);
+
+	list_for_each_entry_safe(i, n, &init->expressions, list) {
+		flags = 0;
+
+		if (i->etype == EXPR_MAPPING) {
+			elem = i->left;
+		} else if (i->etype == EXPR_SET_ELEM) {
+			elem = i;
+		} else {
+			assert(1);
+			return -1;
+		}
+
+		if (elem->key->etype == EXPR_SET_ELEM_CATCHALL)
+			continue;
+
+		if (!prev && segtree_needs_first_segment(set, init, add) &&
+		    mpz_cmp_ui(elem->key->left->value, 0)) {
+			mpz_set_ui(p, 0);
+			expr = constant_expr_alloc(&internal_location,
+						   set->key->dtype,
+						   set->key->byteorder,
+						   set->key->len, NULL);
+			mpz_set(expr->value, p);
+			newelem = set_elem_expr_alloc(&internal_location, expr);
+			newelem->flags |= EXPR_F_INTERVAL_END;
+			list_add(&newelem->list, &init->expressions);
+			init->size++;
+		}
+
+		if (mpz_scan0(elem->key->right->value, 0) != set->key->len) {
+			mpz_add_ui(p, elem->key->right->value, 1);
+			expr = constant_expr_alloc(&elem->key->location, set->key->dtype,
+						   set->key->byteorder, set->key->len,
+						   NULL);
+			mpz_set(expr->value, p);
+			if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
+				mpz_switch_byteorder(expr->value, set->key->len / BITS_PER_BYTE);
+
+			newelem = set_elem_expr_alloc(&internal_location, expr);
+			newelem->flags |= EXPR_F_INTERVAL_END;
+			list_add(&newelem->list, &i->list);
+		} else {
+			flags = NFTNL_SET_ELEM_F_INTERVAL_OPEN;
+		}
+
+		expr = constant_expr_alloc(&elem->key->location, set->key->dtype,
+					   set->key->byteorder, set->key->len, NULL);
+
+		mpz_set(expr->value, elem->key->left->value);
+		if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
+			mpz_switch_byteorder(expr->value, set->key->len / BITS_PER_BYTE);
+
+		expr_free(elem->key);
+		elem->key = expr;
+		elem->elem_flags |= flags;
+		init->size++;
+
+		prev = i;
+	}
+
+	mpz_clear(p);
+	mpz_clear(q);
+
+	return 0;
+}
diff --git a/src/mergesort.c b/src/mergesort.c
index 152b0556b164..8e6aac5fb24e 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -36,6 +36,7 @@ static void expr_msort_value(const struct expr *expr, mpz_t value)
 		break;
 	case EXPR_BINOP:
 	case EXPR_MAPPING:
+	case EXPR_RANGE:
 		expr_msort_value(expr->left, value);
 		break;
 	case EXPR_VALUE:
diff --git a/src/rule.c b/src/rule.c
index b1700c40079d..f2ca2621e895 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -26,6 +26,7 @@
 #include <json.h>
 #include <cache.h>
 #include <owner.h>
+#include <intervals.h>
 
 #include <libnftnl/common.h>
 #include <libnftnl/ruleset.h>
@@ -1492,9 +1493,7 @@ static int do_add_elements(struct netlink_ctx *ctx, struct cmd *cmd,
 	struct set *set = cmd->elem.set;
 
 	if (set_is_non_concat_range(set) &&
-	    set_to_intervals(ctx->msgs, set, init, true,
-			     ctx->nft->debug_mask, set->automerge,
-			     &ctx->nft->output) < 0)
+	    set_to_intervals(set, init, true) < 0)
 		return -1;
 
 	return __do_add_elements(ctx, set, init, flags);
@@ -1519,9 +1518,7 @@ static int do_add_set(struct netlink_ctx *ctx, struct cmd *cmd,
 		 * comes too late which might result in spurious ENFILE errors.
 		 */
 		if (set_is_non_concat_range(set) &&
-		    set_to_intervals(ctx->msgs, set, set->init, true,
-				     ctx->nft->debug_mask, set->automerge,
-				     &ctx->nft->output) < 0)
+		    set_to_intervals(set, set->init, true) < 0)
 			return -1;
 	}
 
@@ -1598,9 +1595,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct set *set = cmd->elem.set;
 
 	if (set_is_non_concat_range(set) &&
-	    set_to_intervals(ctx->msgs, set, expr, false,
-			     ctx->nft->debug_mask, set->automerge,
-			     &ctx->nft->output) < 0)
+	    set_to_intervals(set, expr, false) < 0)
 		return -1;
 
 	if (mnl_nft_setelem_del(ctx, cmd) < 0)
diff --git a/src/segtree.c b/src/segtree.c
index 832bc7dd1402..87dfbce38ed8 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -21,573 +21,6 @@
 #include <utils.h>
 #include <rbtree.h>
 
-/**
- * struct seg_tree - segment tree
- *
- * @root:	the rbtree's root
- * @type:	the datatype of the dimension
- * @dwidth:	width of the dimension
- * @byteorder:	byteorder of elements
- * @debug_mask:	display debugging information
- */
-struct seg_tree {
-	struct rb_root			root;
-	const struct datatype		*keytype;
-	unsigned int			keylen;
-	const struct datatype		*datatype;
-	unsigned int			datalen;
-	enum byteorder			byteorder;
-	unsigned int			debug_mask;
-};
-
-enum elementary_interval_flags {
-	EI_F_INTERVAL_END	= 0x1,
-	EI_F_INTERVAL_OPEN	= 0x2,
-};
-
-/**
- * struct elementary_interval - elementary interval [left, right]
- *
- * @rb_node:	seg_tree rb node
- * @list:	list node for linearized tree
- * @left:	left endpoint
- * @right:	right endpoint
- * @size:	interval size (right - left)
- * @flags:	flags
- * @expr:	associated expression
- */
-struct elementary_interval {
-	union {
-		struct rb_node		rb_node;
-		struct list_head	list;
-	};
-
-	mpz_t				left;
-	mpz_t				right;
-	mpz_t				size;
-
-	enum elementary_interval_flags	flags;
-	struct expr			*expr;
-};
-
-static void seg_tree_init(struct seg_tree *tree, const struct set *set,
-			  struct expr *init, unsigned int debug_mask)
-{
-	struct expr *first;
-
-	first = list_entry(init->expressions.next, struct expr, list);
-	tree->root	= RB_ROOT;
-	tree->keytype	= set->key->dtype;
-	tree->keylen	= set->key->len;
-	tree->datatype	= NULL;
-	tree->datalen	= 0;
-	if (set->data) {
-		tree->datatype	= set->data->dtype;
-		tree->datalen	= set->data->len;
-	}
-	tree->byteorder	= first->byteorder;
-	tree->debug_mask = debug_mask;
-}
-
-static struct elementary_interval *ei_alloc(const mpz_t left, const mpz_t right,
-					    struct expr *expr,
-					    enum elementary_interval_flags flags)
-{
-	struct elementary_interval *ei;
-
-	ei = xzalloc(sizeof(*ei));
-	mpz_init_set(ei->left, left);
-	mpz_init_set(ei->right, right);
-	mpz_init(ei->size);
-	mpz_sub(ei->size, right, left);
-	if (expr != NULL)
-		ei->expr = expr_get(expr);
-	ei->flags = flags;
-	return ei;
-}
-
-static void ei_destroy(struct elementary_interval *ei)
-{
-	mpz_clear(ei->left);
-	mpz_clear(ei->right);
-	mpz_clear(ei->size);
-	if (ei->expr != NULL)
-		expr_free(ei->expr);
-	xfree(ei);
-}
-
-/**
- * ei_lookup - find elementary interval containing point p
- *
- * @tree:	segment tree
- * @p:		the point
- */
-static struct elementary_interval *ei_lookup(struct seg_tree *tree, const mpz_t p)
-{
-	struct rb_node *n = tree->root.rb_node;
-	struct elementary_interval *ei;
-
-	while (n != NULL) {
-		ei = rb_entry(n, struct elementary_interval, rb_node);
-
-		if (mpz_cmp(p, ei->left) >= 0 &&
-		    mpz_cmp(p, ei->right) <= 0)
-			return ei;
-		else if (mpz_cmp(p, ei->left) <= 0)
-			n = n->rb_left;
-		else if (mpz_cmp(p, ei->right) > 0)
-			n = n->rb_right;
-	}
-	return NULL;
-}
-
-static void ei_remove(struct seg_tree *tree, struct elementary_interval *ei)
-{
-	rb_erase(&ei->rb_node, &tree->root);
-}
-
-static void __ei_insert(struct seg_tree *tree, struct elementary_interval *new)
-{
-	struct rb_node **p = &tree->root.rb_node;
-	struct rb_node *parent = NULL;
-	struct elementary_interval *ei;
-
-	while (*p != NULL) {
-		parent = *p;
-		ei = rb_entry(parent, struct elementary_interval, rb_node);
-
-		if (mpz_cmp(new->left, ei->left) >= 0 &&
-		    mpz_cmp(new->left, ei->right) <= 0)
-			break;
-		else if (mpz_cmp(new->left, ei->left) <= 0)
-			p = &(*p)->rb_left;
-		else if (mpz_cmp(new->left, ei->left) > 0)
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&new->rb_node, parent, p);
-	rb_insert_color(&new->rb_node, &tree->root);
-}
-
-static bool segtree_debug(unsigned int debug_mask)
-{
-	if (debug_mask & NFT_DEBUG_SEGTREE)
-		return true;
-
-	return false;
-}
-
-/**
- * ei_insert - insert an elementary interval into the tree
- *
- * @tree:	the seg_tree
- * @new:	the elementary interval
- *
- * New entries take precedence over existing ones. Insertions are assumed to
- * be ordered by descending interval size, meaning the new interval never
- * extends over more than two existing intervals.
- */
-static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
-		     struct elementary_interval *new, bool merge)
-{
-	struct elementary_interval *lei, *rei, *ei;
-	struct expr *new_expr, *expr;
-	mpz_t p;
-
-	mpz_init2(p, tree->keylen);
-
-	/*
-	 * Lookup the intervals containing the left and right endpoints.
-	 */
-	lei = ei_lookup(tree, new->left);
-	rei = ei_lookup(tree, new->right);
-
-	if (segtree_debug(tree->debug_mask))
-		pr_gmp_debug("insert: [%Zx %Zx]\n", new->left, new->right);
-
-	if (lei != NULL && rei != NULL && lei == rei) {
-		if (!merge) {
-			ei = lei;
-			goto err;
-		}
-		/* single element contained in an existing interval */
-		if (mpz_cmp(new->left, new->right) == 0) {
-			ei_destroy(new);
-			goto out;
-		}
-
-		/*
-		 * The new interval is entirely contained in the same interval,
-		 * split it into two parts:
-		 *
-		 * [lei_left, new_left) and (new_right, rei_right]
-		 */
-		if (segtree_debug(tree->debug_mask))
-			pr_gmp_debug("split [%Zx %Zx]\n", lei->left, lei->right);
-
-		ei_remove(tree, lei);
-
-		mpz_sub_ui(p, new->left, 1);
-		if (mpz_cmp(lei->left, p) <= 0)
-			__ei_insert(tree, ei_alloc(lei->left, p, lei->expr, 0));
-
-		mpz_add_ui(p, new->right, 1);
-		if (mpz_cmp(p, rei->right) < 0)
-			__ei_insert(tree, ei_alloc(p, rei->right, lei->expr, 0));
-		ei_destroy(lei);
-	} else {
-		if (lei != NULL) {
-			if (!merge) {
-				ei = lei;
-				goto err;
-			}
-			/*
-			 * Left endpoint is within lei, adjust it so we have:
-			 *
-			 * [lei_left, new_left)[new_left, new_right]
-			 */
-			if (segtree_debug(tree->debug_mask)) {
-				pr_gmp_debug("adjust left [%Zx %Zx]\n",
-					     lei->left, lei->right);
-			}
-
-			mpz_sub_ui(lei->right, new->left, 1);
-			mpz_sub(lei->size, lei->right, lei->left);
-			if (mpz_sgn(lei->size) < 0) {
-				ei_remove(tree, lei);
-				ei_destroy(lei);
-			}
-		}
-		if (rei != NULL) {
-			if (!merge) {
-				ei = rei;
-				goto err;
-			}
-			/*
-			 * Right endpoint is within rei, adjust it so we have:
-			 *
-			 * [new_left, new_right](new_right, rei_right]
-			 */
-			if (segtree_debug(tree->debug_mask)) {
-				pr_gmp_debug("adjust right [%Zx %Zx]\n",
-					     rei->left, rei->right);
-			}
-
-			mpz_add_ui(rei->left, new->right, 1);
-			mpz_sub(rei->size, rei->right, rei->left);
-			if (mpz_sgn(rei->size) < 0) {
-				ei_remove(tree, rei);
-				ei_destroy(rei);
-			}
-		}
-	}
-
-	__ei_insert(tree, new);
-out:
-	mpz_clear(p);
-
-	return 0;
-err:
-	mpz_clear(p);
-	errno = EEXIST;
-	if (new->expr->etype == EXPR_MAPPING) {
-		new_expr = new->expr->left;
-		expr = ei->expr->left;
-	} else {
-		new_expr = new->expr;
-		expr = ei->expr;
-	}
-
-	return expr_binary_error(msgs, new_expr, expr,
-				 "conflicting intervals specified");
-}
-
-/*
- * Sort intervals according to their priority, which is defined inversely to
- * their size.
- *
- * The beginning of the interval is used as secondary sorting criterion. This
- * makes sure that overlapping ranges with equal priority are next to each
- * other, allowing to easily detect unsolvable conflicts during insertion.
- *
- * Note: unsolvable conflicts can only occur when using ranges or two identical
- * prefix specifications.
- */
-static int interval_cmp(const void *p1, const void *p2)
-{
-	const struct elementary_interval *e1 = *(void * const *)p1;
-	const struct elementary_interval *e2 = *(void * const *)p2;
-	mpz_t d;
-	int ret;
-
-	mpz_init(d);
-
-	mpz_sub(d, e2->size, e1->size);
-	if (mpz_cmp_ui(d, 0))
-		ret = mpz_sgn(d);
-	else
-		ret = mpz_cmp(e1->left, e2->left);
-
-	mpz_clear(d);
-	return ret;
-}
-
-static unsigned int expr_to_intervals(const struct expr *set,
-				      unsigned int keylen,
-				      struct elementary_interval **intervals)
-{
-	struct elementary_interval *ei;
-	struct expr *i, *next;
-	unsigned int n;
-	mpz_t low, high;
-
-	mpz_init2(low, keylen);
-	mpz_init2(high, keylen);
-
-	/*
-	 * Convert elements to intervals.
-	 */
-	n = 0;
-	list_for_each_entry_safe(i, next, &set->expressions, list) {
-		range_expr_value_low(low, i);
-		range_expr_value_high(high, i);
-		ei = ei_alloc(low, high, i, 0);
-		intervals[n++] = ei;
-	}
-	mpz_clear(high);
-	mpz_clear(low);
-
-	return n;
-}
-
-static bool intervals_match(const struct elementary_interval *e1,
-			    const struct elementary_interval *e2)
-{
-	return mpz_cmp(e1->left, e2->left) == 0 &&
-	       mpz_cmp(e1->right, e2->right) == 0;
-}
-
-/* This function checks for overlaps in two ways:
- *
- * 1) A new interval end intersects an existing interval.
- * 2) New intervals that are larger than existing ones, that don't intersect
- *    at all, but that wrap the existing ones.
- */
-static bool interval_overlap(const struct elementary_interval *e1,
-			     const struct elementary_interval *e2)
-{
-	if (intervals_match(e1, e2))
-		return false;
-
-	return (mpz_cmp(e1->left, e2->left) >= 0 &&
-	        mpz_cmp(e1->left, e2->right) <= 0) ||
-	       (mpz_cmp(e1->right, e2->left) >= 0 &&
-	        mpz_cmp(e1->right, e2->right) <= 0) ||
-	       (mpz_cmp(e1->left, e2->left) <= 0 &&
-		mpz_cmp(e1->right, e2->right) >= 0);
-}
-
-static int set_overlap(struct list_head *msgs, const struct set *set,
-		       struct expr *init, unsigned int keylen, bool add)
-{
-	struct elementary_interval *new_intervals[init->size + 1];
-	struct elementary_interval *intervals[set->init->size + 1];
-	unsigned int n, m, i, j;
-	int ret = 0;
-
-	n = expr_to_intervals(init, keylen, new_intervals);
-	m = expr_to_intervals(set->init, keylen, intervals);
-
-	for (i = 0; i < n; i++) {
-		bool found = false;
-
-		for (j = 0; j < m; j++) {
-			if (add && interval_overlap(new_intervals[i],
-						    intervals[j])) {
-				expr_error(msgs, new_intervals[i]->expr,
-					   "interval overlaps with an existing one");
-				errno = EEXIST;
-				ret = -1;
-				goto out;
-			} else if (!add && intervals_match(new_intervals[i],
-							   intervals[j])) {
-				found = true;
-				break;
-			}
-		}
-		if (!add && !found) {
-			expr_error(msgs, new_intervals[i]->expr,
-				   "interval not found in set");
-			errno = ENOENT;
-			ret = -1;
-			break;
-		}
-	}
-out:
-	for (i = 0; i < n; i++)
-		ei_destroy(new_intervals[i]);
-	for (i = 0; i < m; i++)
-		ei_destroy(intervals[i]);
-
-	return ret;
-}
-
-static int set_to_segtree(struct list_head *msgs, struct set *set,
-			  struct expr *init, struct seg_tree *tree,
-			  bool add, bool merge)
-{
-	struct elementary_interval **intervals;
-	struct expr *i, *next;
-	unsigned int n, m;
-	int err = 0;
-
-	/* We are updating an existing set with new elements, check if the new
-	 * interval overlaps with any of the existing ones.
-	 */
-	if (set->init && set->init != init) {
-		err = set_overlap(msgs, set, init, tree->keylen, add);
-		if (err < 0)
-			return err;
-	}
-
-	intervals = xmalloc_array(init->size, sizeof(intervals[0]));
-	n = expr_to_intervals(init, tree->keylen, intervals);
-
-	list_for_each_entry_safe(i, next, &init->expressions, list) {
-		list_del(&i->list);
-		expr_free(i);
-	}
-
-	/*
-	 * Sort intervals by priority.
-	 */
-	qsort(intervals, n, sizeof(intervals[0]), interval_cmp);
-
-	/*
-	 * Insert elements into tree
-	 */
-	for (n = 0; n < init->size; n++) {
-		err = ei_insert(msgs, tree, intervals[n], merge);
-		if (err < 0) {
-			struct elementary_interval *ei;
-			struct rb_node *node, *next;
-
-			for (m = n; m < init->size; m++)
-				ei_destroy(intervals[m]);
-
-			rb_for_each_entry_safe(ei, node, next, &tree->root, rb_node) {
-				ei_remove(tree, ei);
-				ei_destroy(ei);
-			}
-			break;
-		}
-	}
-
-	xfree(intervals);
-	return err;
-}
-
-static bool segtree_needs_first_segment(const struct set *set,
-					const struct expr *init, bool add)
-{
-	if (add && !set->root) {
-		/* Add the first segment in four situations:
-		 *
-		 * 1) This is an anonymous set.
-		 * 2) This set exists and it is empty.
-		 * 3) New empty set and, separately, new elements are added.
-		 * 4) This set is created with a number of initial elements.
-		 */
-		if ((set_is_anonymous(set->flags)) ||
-		    (set->init && set->init->size == 0) ||
-		    (set->init == NULL && init) ||
-		    (set->init == init)) {
-			return true;
-		}
-	}
-	/* This is an update for a set that already contains elements, so don't
-	 * add the first non-matching elements otherwise we hit EEXIST.
-	 */
-	return false;
-}
-
-static void segtree_linearize(struct list_head *list, const struct set *set,
-			      const struct expr *init, struct seg_tree *tree,
-			      bool add, bool merge)
-{
-	bool needs_first_segment = segtree_needs_first_segment(set, init, add);
-	struct elementary_interval *ei, *nei, *prev = NULL;
-	struct rb_node *node, *next;
-	mpz_t p, q;
-
-	mpz_init2(p, tree->keylen);
-	mpz_init2(q, tree->keylen);
-
-	/*
-	 * Convert the tree of open intervals to half-closed map expressions.
-	 */
-	rb_for_each_entry_safe(ei, node, next, &tree->root, rb_node) {
-		if (segtree_debug(tree->debug_mask))
-			pr_gmp_debug("iter: [%Zx %Zx]\n", ei->left, ei->right);
-
-		if (prev == NULL) {
-			/*
-			 * If the first segment doesn't begin at zero, insert a
-			 * non-matching segment to cover [0, first_left).
-			 */
-			if (needs_first_segment && mpz_cmp_ui(ei->left, 0)) {
-				mpz_set_ui(p, 0);
-				mpz_sub_ui(q, ei->left, 1);
-				nei = ei_alloc(p, q, NULL, EI_F_INTERVAL_END);
-				list_add_tail(&nei->list, list);
-			}
-		} else {
-			/*
-			 * If the previous segment doesn't end directly left to
-			 * this one, insert a non-matching segment to cover
-			 * (prev_right, ei_left).
-			 */
-			mpz_add_ui(p, prev->right, 1);
-			if (mpz_cmp(p, ei->left) < 0 ||
-			    (!set_is_anonymous(set->flags) && !merge)) {
-				mpz_sub_ui(q, ei->left, 1);
-				nei = ei_alloc(p, q, NULL, EI_F_INTERVAL_END);
-				list_add_tail(&nei->list, list);
-			} else if (add && merge &&
-			           ei->expr->etype != EXPR_MAPPING) {
-				/* Merge contiguous segments only in case of
-				 * new additions.
-				 */
-				mpz_set(prev->right, ei->right);
-				ei_remove(tree, ei);
-				ei_destroy(ei);
-				continue;
-			}
-		}
-
-		ei_remove(tree, ei);
-		list_add_tail(&ei->list, list);
-
-		prev = ei;
-	}
-
-	/*
-	 * If the last segment doesn't end at the right side of the dimension,
-	 * insert a non-matching segment to cover (last_right, end].
-	 */
-	if (mpz_scan0(prev->right, 0) != tree->keylen) {
-		mpz_add_ui(p, prev->right, 1);
-		mpz_bitmask(q, tree->keylen);
-		nei = ei_alloc(p, q, NULL, EI_F_INTERVAL_END);
-		list_add_tail(&nei->list, list);
-	} else {
-		prev->flags |= EI_F_INTERVAL_OPEN;
-	}
-
-	mpz_clear(p);
-	mpz_clear(q);
-}
-
 static void interval_expr_copy(struct expr *dst, struct expr *src)
 {
 	if (src->comment)
@@ -600,88 +33,6 @@ static void interval_expr_copy(struct expr *dst, struct expr *src)
 	list_splice_init(&src->stmt_list, &dst->stmt_list);
 }
 
-static void set_insert_interval(struct expr *set, struct seg_tree *tree,
-				const struct elementary_interval *ei)
-{
-	struct expr *expr;
-
-	expr = constant_expr_alloc(&internal_location, tree->keytype,
-				   tree->byteorder, tree->keylen, NULL);
-	mpz_set(expr->value, ei->left);
-	expr = set_elem_expr_alloc(&internal_location, expr);
-
-	if (ei->expr != NULL) {
-		if (ei->expr->etype == EXPR_MAPPING) {
-			interval_expr_copy(expr, ei->expr->left);
-			expr = mapping_expr_alloc(&ei->expr->location, expr,
-						  expr_get(ei->expr->right));
-		} else {
-			interval_expr_copy(expr, ei->expr);
-		}
-	}
-
-	if (ei->flags & EI_F_INTERVAL_END)
-		expr->flags |= EXPR_F_INTERVAL_END;
-	if (ei->flags & EI_F_INTERVAL_OPEN)
-		expr->elem_flags |= NFTNL_SET_ELEM_F_INTERVAL_OPEN;
-
-	compound_expr_add(set, expr);
-}
-
-int set_to_intervals(struct list_head *errs, struct set *set,
-		     struct expr *init, bool add, unsigned int debug_mask,
-		     bool merge, struct output_ctx *octx)
-{
-	struct expr *catchall = NULL, *i, *in, *key;
-	struct elementary_interval *ei, *next;
-	struct seg_tree tree;
-	LIST_HEAD(list);
-
-	list_for_each_entry_safe(i, in, &init->expressions, list) {
-		if (i->etype == EXPR_MAPPING)
-			key = i->left->key;
-		else if (i->etype == EXPR_SET_ELEM)
-			key = i->key;
-		else
-			continue;
-
-		if (key->etype == EXPR_SET_ELEM_CATCHALL) {
-			init->size--;
-			catchall = i;
-			list_del(&i->list);
-			break;
-		}
-	}
-
-	seg_tree_init(&tree, set, init, debug_mask);
-	if (set_to_segtree(errs, set, init, &tree, add, merge) < 0)
-		return -1;
-	segtree_linearize(&list, set, init, &tree, add, merge);
-
-	init->size = 0;
-	list_for_each_entry_safe(ei, next, &list, list) {
-		if (segtree_debug(tree.debug_mask)) {
-			pr_gmp_debug("list: [%.*Zx %.*Zx]\n",
-				     2 * tree.keylen / BITS_PER_BYTE, ei->left,
-				     2 * tree.keylen / BITS_PER_BYTE, ei->right);
-		}
-		set_insert_interval(init, &tree, ei);
-		ei_destroy(ei);
-	}
-
-	if (segtree_debug(tree.debug_mask)) {
-		expr_print(init, octx);
-		pr_gmp_debug("\n");
-	}
-
-	if (catchall) {
-		list_add_tail(&catchall->list, &init->expressions);
-		init->size++;
-	}
-
-	return 0;
-}
-
 static void set_elem_add(const struct set *set, struct expr *init, mpz_t value,
 			 uint32_t flags, enum byteorder byteorder)
 {
-- 
2.30.2

