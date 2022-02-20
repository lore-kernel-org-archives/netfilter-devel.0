Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC03C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Feb 2022 00:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241952AbiBTAbB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 19:31:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242116AbiBTAbA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 19:31:00 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0912F53B44
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 16:30:39 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0971D60215
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Feb 2022 01:29:49 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 5/5] intervals: add support to automerge with kernel elements
Date:   Sun, 20 Feb 2022 01:30:24 +0100
Message-Id: <20220220003024.23317-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220220003024.23317-1-pablo@netfilter.org>
References: <20220220003024.23317-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend the interval codebase to support for merging elements in the
kernel with userspace element updates.

Add a list of elements to be purged to set objects. These elements
representing outdated intervals are deleted before adding the updated
ranges.

This routine splices the list of userspace and kernel elements, then it
mergesorts to identify overlapping and contiguous ranges. This splice
operation is undone so the set userspace cache remains consistent.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - remove EXPR_F_REMOVE flag, instead add element to purge list directly
    - turn on NFT_CACHE_SETELEM_MAYBE only if auto-merge is enabled
    - restore debugging via --debug=segtree

 include/intervals.h |  3 +-
 include/rule.h      |  1 +
 src/cache.c         |  6 +++
 src/evaluate.c      |  8 ++--
 src/intervals.c     | 95 ++++++++++++++++++++++++++++++++++++---------
 src/rule.c          | 10 +++++
 6 files changed, 100 insertions(+), 23 deletions(-)

diff --git a/include/intervals.h b/include/intervals.h
index f69800638070..db2b37a0baee 100644
--- a/include/intervals.h
+++ b/include/intervals.h
@@ -2,7 +2,8 @@
 #define NFTABLES_INTERVALS_H
 
 void set_to_range(struct expr *init);
-int set_automerge(struct list_head *msgs, struct set *set, struct expr *init);
+int set_automerge(struct list_head *msgs, struct set *set, struct expr *init,
+		  unsigned int debug_mask);
 int set_overlap(struct list_head *msgs, struct set *set, struct expr *init);
 int set_to_intervals(const struct set *set, struct expr *init, bool add);
 
diff --git a/include/rule.h b/include/rule.h
index e232b97afed7..ccd5e0715808 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -348,6 +348,7 @@ struct set {
 	uint32_t		objtype;
 	struct set		*existing_set;
 	struct expr		*init;
+	struct expr		*purge;
 	struct expr		*rg_cache;
 	uint32_t		policy;
 	struct list_head	stmt_list;
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
index bf38bd661a53..3dfefaad0166 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1435,10 +1435,12 @@ static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
 	switch (ctx->cmd->op) {
 	case CMD_CREATE:
 	case CMD_ADD:
-		if (set->automerge)
-			ret = set_automerge(ctx->msgs, set, init);
-		else
+		if (set->automerge) {
+			ret = set_automerge(ctx->msgs, set, init,
+					    ctx->nft->debug_mask);
+		} else {
 			ret = set_overlap(ctx->msgs, set, init);
+		}
 		break;
 	case CMD_DELETE:
 		set_to_range(init);
diff --git a/src/intervals.c b/src/intervals.c
index 2e5ea122835e..1de298edd2f4 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -51,8 +51,25 @@ static void setelem_expr_to_range(struct expr *expr)
 	}
 }
 
-static void remove_overlapping_range(struct expr *i, struct expr *init)
+static void purge_elem(struct set *set, struct expr *i, unsigned int debug_mask)
 {
+	if (debug_mask & NFT_DEBUG_SEGTREE) {
+		pr_gmp_debug("remove: [%Zx-%Zx]\n",
+			     i->key->left->value,
+			     i->key->right->value);
+	}
+	list_move_tail(&i->list, &set->purge->expressions);
+}
+
+static void remove_overlapping_range(struct set *set, struct expr *prev,
+				     struct expr *i, struct expr *init,
+				     unsigned int debug_mask)
+{
+	if (i->flags & EXPR_F_KERNEL) {
+		purge_elem(set, i, debug_mask);
+		list_move_tail(&i->list, &set->purge->expressions);
+		return;
+	}
 	list_del(&i->list);
 	expr_free(i);
 	init->size--;
@@ -63,24 +80,37 @@ struct range {
 	mpz_t	high;
 };
 
-static void merge_ranges(struct expr *prev, struct expr *i,
+static bool merge_ranges(struct set *set, struct expr *prev, struct expr *i,
 			 struct range *prev_range, struct range *range,
-			 struct expr *init)
+			 struct expr *init, unsigned int debug_mask)
 {
-	expr_free(prev->key->right);
-	prev->key->right = expr_get(i->key->right);
-	list_del(&i->list);
-	expr_free(i);
-	mpz_set(prev_range->high, range->high);
-	init->size--;
+	if (prev->flags & EXPR_F_KERNEL) {
+		purge_elem(set, prev, debug_mask);
+		expr_free(i->key->left);
+		i->key->left = expr_get(prev->key->left);
+		mpz_set(prev_range->high, range->high);
+		return true;
+	} else if (i->flags & EXPR_F_KERNEL) {
+		purge_elem(set, i, debug_mask);
+		expr_free(prev->key->right);
+		prev->key->right = expr_get(i->key->right);
+		mpz_set(prev_range->high, range->high);
+	} else {
+		expr_free(prev->key->right);
+		prev->key->right = expr_get(i->key->right);
+		mpz_set(prev_range->high, range->high);
+		list_del(&i->list);
+		expr_free(i);
+		init->size--;
+	}
+	return false;
 }
 
-static int setelem_automerge(struct list_head *msgs, struct set *set,
-			     struct expr *init)
+static void setelem_automerge(struct list_head *msgs, struct set *set,
+			      struct expr *init, unsigned int debug_mask)
 {
 	struct expr *i, *next, *prev = NULL;
 	struct range range, prev_range;
-	int err = 0;
 	mpz_t rop;
 
 	mpz_init(prev_range.low);
@@ -105,16 +135,18 @@ static int setelem_automerge(struct list_head *msgs, struct set *set,
 
 		if (mpz_cmp(prev_range.low, range.low) <= 0 &&
 		    mpz_cmp(prev_range.high, range.high) >= 0) {
-			remove_overlapping_range(i, init);
+			remove_overlapping_range(set, prev, i, init, debug_mask);
 			continue;
 		} else if (mpz_cmp(range.low, prev_range.high) <= 0) {
-			merge_ranges(prev, i, &prev_range, &range, init);
+			if (merge_ranges(set, prev, i, &prev_range, &range, init, debug_mask))
+				prev = i;
 			continue;
 		} else if (set->automerge) {
 			mpz_sub(rop, range.low, prev_range.high);
 			/* two contiguous ranges */
 			if (mpz_cmp_ui(rop, 1) == 0) {
-				merge_ranges(prev, i, &prev_range, &range, init);
+				if (merge_ranges(set, prev, i, &prev_range, &range, init, debug_mask))
+					prev = i;
 				continue;
 			}
 		}
@@ -129,8 +161,6 @@ static int setelem_automerge(struct list_head *msgs, struct set *set,
 	mpz_clear(range.low);
 	mpz_clear(range.high);
 	mpz_clear(rop);
-
-	return err;
 }
 
 void set_to_range(struct expr *init)
@@ -154,14 +184,41 @@ void set_to_range(struct expr *init)
 	list_expr_sort(&init->expressions);
 }
 
-int set_automerge(struct list_head *msgs, struct set *set, struct expr *init)
+int set_automerge(struct list_head *msgs, struct set *set, struct expr *init,
+		  unsigned int debug_mask)
 {
+	struct set *existing_set = set->existing_set;
+	struct expr *i, *next, *clone;
+
+	if (existing_set && existing_set->init) {
+		list_splice_tail_init(&existing_set->init->expressions,
+				      &init->expressions);
+	}
+
 	set_to_range(init);
 
 	if (set->flags & NFT_SET_MAP)
 		return 0;
 
-	return setelem_automerge(msgs, set, init);
+	if (!set->purge)
+		set->purge = set_expr_alloc(&internal_location, set);
+
+	setelem_automerge(msgs, set, init, debug_mask);
+
+	list_for_each_entry_safe(i, next, &init->expressions, list) {
+		if (i->flags & EXPR_F_KERNEL) {
+			list_move_tail(&i->list, &existing_set->init->expressions);
+		} else if (existing_set && existing_set->init) {
+			if (debug_mask & NFT_DEBUG_SEGTREE) {
+				pr_gmp_debug("add: [%Zx-%Zx]\n",
+					     i->key->left->value, i->key->right->value);
+			}
+			clone = expr_clone(i);
+			list_add_tail(&clone->list, &existing_set->init->expressions);
+		}
+	}
+
+	return 0;
 }
 
 static int setelem_overlap(struct list_head *msgs, struct set *set,
diff --git a/src/rule.c b/src/rule.c
index e57e037a9e99..dc4c21c2dbb4 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -192,6 +192,8 @@ void set_free(struct set *set)
 		return;
 	if (set->init != NULL)
 		expr_free(set->init);
+	if (set->purge)
+		expr_free(set->purge);
 	if (set->comment)
 		xfree(set->comment);
 	handle_free(&set->handle);
@@ -1470,6 +1472,14 @@ static int __do_add_elements(struct netlink_ctx *ctx, struct set *set,
 			     struct expr *expr, uint32_t flags)
 {
 	expr->set_flags |= set->flags;
+
+	if (set->purge) {
+		if (set_to_intervals(set, set->purge, false) < 0)
+			return -1;
+		if (mnl_nft_setelem_del(ctx, &set->handle, set->purge) < 0)
+			return -1;
+	}
+
 	if (mnl_nft_setelem_add(ctx, set, expr, flags) < 0)
 		return -1;
 
-- 
2.30.2

