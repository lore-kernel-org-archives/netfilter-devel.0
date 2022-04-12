Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7A8C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 14:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349098AbiDLOtk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 10:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351937AbiDLOth (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 10:49:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D91015E759
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 07:47:18 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v4 5/7] intervals: add support to automerge with kernel elements
Date:   Tue, 12 Apr 2022 16:47:09 +0200
Message-Id: <20220412144711.93354-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220412144711.93354-1-pablo@netfilter.org>
References: <20220412144711.93354-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend the interval codebase to support for merging elements in the
kernel with userspace element updates.

Add a list of elements to be purged to cmd and set objects. These
elements representing outdated intervals are deleted before adding the
updated ranges.

This routine splices the list of userspace and kernel elements, then it
mergesorts to identify overlapping and contiguous ranges. This splice
operation is undone so the set userspace cache remains consistent.

Incrementally update the elements in the cache, this allows to remove
dd44081d91ce ("segtree: Fix add and delete of element in same batch").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/intervals.h                           |   3 +-
 src/cache.c                                   |   6 +
 src/evaluate.c                                |   8 +-
 src/intervals.c                               | 144 ++++++++++++++----
 src/rule.c                                    |  10 --
 .../shell/testcases/sets/0069interval_merge_0 |  28 ++++
 .../sets/dumps/0069interval_merge_0.nft       |   9 ++
 7 files changed, 168 insertions(+), 40 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0069interval_merge_0
 create mode 100644 tests/shell/testcases/sets/dumps/0069interval_merge_0.nft

diff --git a/include/intervals.h b/include/intervals.h
index f69800638070..797129fc93a5 100644
--- a/include/intervals.h
+++ b/include/intervals.h
@@ -2,7 +2,8 @@
 #define NFTABLES_INTERVALS_H
 
 void set_to_range(struct expr *init);
-int set_automerge(struct list_head *msgs, struct set *set, struct expr *init);
+int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
+		  struct expr *init, unsigned int debug_mask);
 int set_overlap(struct list_head *msgs, struct set *set, struct expr *init);
 int set_to_intervals(const struct set *set, struct expr *init, bool add);
 
diff --git a/src/cache.c b/src/cache.c
index 8e8387f91955..fd8df884c095 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -19,6 +19,8 @@
 
 static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 {
+	struct set *set;
+
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
 		if (!cmd->table)
@@ -29,6 +31,10 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 			 NFT_CACHE_SET |
 			 NFT_CACHE_OBJECT |
 			 NFT_CACHE_FLOWTABLE;
+		list_for_each_entry(set, &cmd->table->sets, list) {
+			if (set->automerge)
+				 flags |= NFT_CACHE_SETELEM_MAYBE;
+		}
 		break;
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_SET:
diff --git a/src/evaluate.c b/src/evaluate.c
index 1b20d76f8111..9951a8349249 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1466,10 +1466,12 @@ static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
 	switch (ctx->cmd->op) {
 	case CMD_CREATE:
 	case CMD_ADD:
-		if (set->automerge)
-			ret = set_automerge(ctx->msgs, set, init);
-		else
+		if (set->automerge) {
+			ret = set_automerge(ctx->msgs, ctx->cmd, set, init,
+					    ctx->nft->debug_mask);
+		} else {
 			ret = set_overlap(ctx->msgs, set, init);
+		}
 		break;
 	case CMD_DELETE:
 		set_to_range(init);
diff --git a/src/intervals.c b/src/intervals.c
index c6f66e634d4c..16debf9cd4be 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -51,11 +51,33 @@ static void setelem_expr_to_range(struct expr *expr)
 	}
 }
 
-static void remove_overlapping_range(struct expr *i, struct expr *init)
+struct set_automerge_ctx {
+	struct set	*set;
+	struct expr	*init;
+	struct expr	*purge;
+	unsigned int	debug_mask;
+};
+
+static void purge_elem(struct set_automerge_ctx *ctx, struct expr *i)
 {
+	if (ctx->debug_mask & NFT_DEBUG_SEGTREE) {
+		pr_gmp_debug("remove: [%Zx-%Zx]\n",
+			     i->key->left->value,
+			     i->key->right->value);
+	}
+	list_move_tail(&i->list, &ctx->purge->expressions);
+}
+
+static void remove_overlapping_range(struct set_automerge_ctx *ctx,
+				     struct expr *prev, struct expr *i)
+{
+	if (i->flags & EXPR_F_KERNEL) {
+		purge_elem(ctx, i);
+		return;
+	}
 	list_del(&i->list);
 	expr_free(i);
-	init->size--;
+	ctx->init->size--;
 }
 
 struct range {
@@ -63,20 +85,33 @@ struct range {
 	mpz_t	high;
 };
 
-static void merge_ranges(struct expr *prev, struct expr *i,
-			 struct range *prev_range, struct range *range,
-			 struct expr *init)
+static bool merge_ranges(struct set_automerge_ctx *ctx,
+			 struct expr *prev, struct expr *i,
+			 struct range *prev_range, struct range *range)
 {
-	expr_free(prev->key->right);
-	prev->key->right = expr_get(i->key->right);
-	list_del(&i->list);
-	expr_free(i);
-	mpz_set(prev_range->high, range->high);
-	init->size--;
+	if (prev->flags & EXPR_F_KERNEL) {
+		purge_elem(ctx, prev);
+		expr_free(i->key->left);
+		i->key->left = expr_get(prev->key->left);
+		mpz_set(prev_range->high, range->high);
+		return true;
+	} else if (i->flags & EXPR_F_KERNEL) {
+		purge_elem(ctx, i);
+		expr_free(prev->key->right);
+		prev->key->right = expr_get(i->key->right);
+		mpz_set(prev_range->high, range->high);
+	} else {
+		expr_free(prev->key->right);
+		prev->key->right = expr_get(i->key->right);
+		mpz_set(prev_range->high, range->high);
+		list_del(&i->list);
+		expr_free(i);
+		ctx->init->size--;
+	}
+	return false;
 }
 
-static void setelem_automerge(struct list_head *msgs, struct set *set,
-			      struct expr *init)
+static void setelem_automerge(struct set_automerge_ctx *ctx)
 {
 	struct expr *i, *next, *prev = NULL;
 	struct range range, prev_range;
@@ -88,7 +123,7 @@ static void setelem_automerge(struct list_head *msgs, struct set *set,
 	mpz_init(range.high);
 	mpz_init(rop);
 
-	list_for_each_entry_safe(i, next, &init->expressions, list) {
+	list_for_each_entry_safe(i, next, &ctx->init->expressions, list) {
 		if (i->key->etype == EXPR_SET_ELEM_CATCHALL)
 			continue;
 
@@ -104,16 +139,18 @@ static void setelem_automerge(struct list_head *msgs, struct set *set,
 
 		if (mpz_cmp(prev_range.low, range.low) <= 0 &&
 		    mpz_cmp(prev_range.high, range.high) >= 0) {
-			remove_overlapping_range(i, init);
+			remove_overlapping_range(ctx, prev, i);
 			continue;
 		} else if (mpz_cmp(range.low, prev_range.high) <= 0) {
-			merge_ranges(prev, i, &prev_range, &range, init);
+			if (merge_ranges(ctx, prev, i, &prev_range, &range))
+				prev = i;
 			continue;
-		} else if (set->automerge) {
+		} else if (ctx->set->automerge) {
 			mpz_sub(rop, range.low, prev_range.high);
 			/* two contiguous ranges */
 			if (mpz_cmp_ui(rop, 1) == 0) {
-				merge_ranges(prev, i, &prev_range, &range, init);
+				if (merge_ranges(ctx, prev, i, &prev_range, &range))
+					prev = i;
 				continue;
 			}
 		}
@@ -157,18 +194,63 @@ void set_to_range(struct expr *init)
 		elem = interval_expr_key(i);
 		setelem_expr_to_range(elem);
 	}
-
-	list_expr_sort(&init->expressions);
 }
 
-int set_automerge(struct list_head *msgs, struct set *set, struct expr *init)
+int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
+		  struct expr *init, unsigned int debug_mask)
 {
+	struct set *existing_set = set->existing_set;
+	struct set_automerge_ctx ctx = {
+		.set		= set,
+		.init		= init,
+		.debug_mask	= debug_mask,
+	};
+	struct expr *i, *next, *clone;
+	struct cmd *purge_cmd;
+	struct handle h = {};
+
+	if (existing_set) {
+		if (existing_set->init) {
+			list_splice_init(&existing_set->init->expressions,
+					 &init->expressions);
+		} else {
+			existing_set->init = set_expr_alloc(&internal_location,
+							    set);
+		}
+	}
+
 	set_to_range(init);
+	list_expr_sort(&init->expressions);
 
 	if (set->flags & NFT_SET_MAP)
 		return 0;
 
-	setelem_automerge(msgs, set, init);
+	ctx.purge = set_expr_alloc(&internal_location, set);
+
+	setelem_automerge(&ctx);
+
+	list_for_each_entry_safe(i, next, &init->expressions, list) {
+		if (i->flags & EXPR_F_KERNEL) {
+			list_move_tail(&i->list, &existing_set->init->expressions);
+		} else if (existing_set) {
+			if (debug_mask & NFT_DEBUG_SEGTREE) {
+				pr_gmp_debug("add: [%Zx-%Zx]\n",
+					     i->key->left->value, i->key->right->value);
+			}
+			clone = expr_clone(i);
+			list_add_tail(&clone->list, &existing_set->init->expressions);
+		}
+	}
+
+	if (list_empty(&ctx.purge->expressions)) {
+		expr_free(ctx.purge);
+		return 0;
+	}
+
+	handle_merge(&h, &set->handle);
+	purge_cmd = cmd_alloc(CMD_DELETE, CMD_OBJ_ELEMENTS, &h, &init->location, ctx.purge);
+	purge_cmd->elem.set = set_get(set);
+	list_add_tail(&purge_cmd->list, &cmd->list);
 
 	return 0;
 }
@@ -250,21 +332,31 @@ err_out:
 int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 {
 	struct set *existing_set = set->existing_set;
-	struct expr *i, *n;
+	struct expr *i, *n, *clone;
 	int err;
 
-	if (existing_set && existing_set->init) {
-		list_splice_init(&existing_set->init->expressions,
-				 &init->expressions);
+	if (existing_set) {
+		if (existing_set->init) {
+			list_splice_init(&existing_set->init->expressions,
+					 &init->expressions);
+		} else {
+			existing_set->init = set_expr_alloc(&internal_location,
+							    set);
+		}
 	}
 
 	set_to_range(init);
+	list_expr_sort(&init->expressions);
 
 	err = setelem_overlap(msgs, set, init);
 
 	list_for_each_entry_safe(i, n, &init->expressions, list) {
 		if (i->flags & EXPR_F_KERNEL)
 			list_move_tail(&i->list, &existing_set->init->expressions);
+		else if (existing_set) {
+			clone = expr_clone(i);
+			list_add_tail(&clone->list, &existing_set->init->expressions);
+		}
 	}
 
 	return err;
diff --git a/src/rule.c b/src/rule.c
index 44e1febf0793..799092eb15c5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1476,16 +1476,6 @@ static int __do_add_elements(struct netlink_ctx *ctx, struct set *set,
 	if (mnl_nft_setelem_add(ctx, set, expr, flags) < 0)
 		return -1;
 
-	if (!set_is_anonymous(set->flags) &&
-	    set->init != NULL && set->init != expr &&
-	    set->flags & NFT_SET_INTERVAL &&
-	    set->desc.field_count <= 1) {
-		interval_map_decompose(expr);
-		list_splice_tail_init(&expr->expressions, &set->init->expressions);
-		set->init->size += expr->size;
-		expr->size = 0;
-	}
-
 	return 0;
 }
 
diff --git a/tests/shell/testcases/sets/0069interval_merge_0 b/tests/shell/testcases/sets/0069interval_merge_0
new file mode 100755
index 000000000000..edb6422a1fc0
--- /dev/null
+++ b/tests/shell/testcases/sets/0069interval_merge_0
@@ -0,0 +1,28 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+        set y {
+                type ipv4_addr
+                flags interval
+                auto-merge
+                elements = { 1.2.3.0, 1.2.3.255, 1.2.3.0/24, 3.3.3.3, 4.4.4.4, 4.4.4.4-4.4.4.8, 3.3.3.4, 3.3.3.5 }
+        }
+}"
+
+$NFT -f - <<< $RULESET
+
+RULESET="table ip x {
+        set y {
+                type ipv4_addr
+                flags interval
+                auto-merge
+                elements = { 1.2.4.0, 3.3.3.6, 4.4.4.0/24 }
+        }
+}"
+
+$NFT -f - <<< $RULESET
+
+$NFT add element ip x y { 1.2.3.0-1.2.4.255, 3.3.3.5, 4.4.4.1 }
+$NFT add element ip x y { 1.2.3.0-1.2.4.255, 3.3.3.5, 4.4.5.0 }
diff --git a/tests/shell/testcases/sets/dumps/0069interval_merge_0.nft b/tests/shell/testcases/sets/dumps/0069interval_merge_0.nft
new file mode 100644
index 000000000000..2d4e1706f43e
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0069interval_merge_0.nft
@@ -0,0 +1,9 @@
+table ip x {
+	set y {
+		type ipv4_addr
+		flags interval
+		auto-merge
+		elements = { 1.2.3.0-1.2.4.255, 3.3.3.3-3.3.3.6,
+			     4.4.4.0-4.4.5.0 }
+	}
+}
-- 
2.30.2

