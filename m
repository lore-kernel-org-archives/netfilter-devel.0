Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0C6C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Apr 2022 09:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345471AbiDOJpl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 05:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243176AbiDOJpk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 05:45:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DCF4B1A88
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2022 02:43:12 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 3/3] intervals: build list of elements to be added from cache
Date:   Fri, 15 Apr 2022 11:43:06 +0200
Message-Id: <20220415094306.642207-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220415094306.642207-1-pablo@netfilter.org>
References: <20220415094306.642207-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Loop over the set cache and add elements that have no EXPR_F_KERNEL,
meaning that these are new elements in the set that have resulted
from adjusting/split existing ranges.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series.

 src/intervals.c | 70 +++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 40 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index e66501c571ab..584c69d5189b 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -274,58 +274,46 @@ static void remove_elem(struct expr *prev, struct set *set, struct expr *purge)
 	}
 }
 
-static void __adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
-			       struct expr *add)
+static void __adjust_elem_left(struct set *set, struct expr *prev, struct expr *i)
 {
 	prev->flags &= ~EXPR_F_KERNEL;
 	expr_free(prev->key->left);
 	prev->key->left = expr_get(i->key->right);
 	mpz_add_ui(prev->key->left->value, prev->key->left->value, 1);
-	list_move(&prev->list, &add->expressions);
+	list_move(&prev->list, &set->existing_set->init->expressions);
 }
 
 static void adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
-			     struct expr *add, struct expr *purge)
+			     struct expr *purge)
 {
-	struct expr *clone;
-
 	remove_elem(prev, set, purge);
-	__adjust_elem_left(set, prev, i, add);
+	__adjust_elem_left(set, prev, i);
 
 	list_del(&i->list);
 	expr_free(i);
-
-	clone = expr_clone(prev);
-	list_add_tail(&clone->list, &set->existing_set->init->expressions);
 }
 
-static void __adjust_elem_right(struct set *set, struct expr *prev, struct expr *i,
-				struct expr *add)
+static void __adjust_elem_right(struct set *set, struct expr *prev, struct expr *i)
 {
 	prev->flags &= ~EXPR_F_KERNEL;
 	expr_free(prev->key->right);
 	prev->key->right = expr_get(i->key->left);
 	mpz_sub_ui(prev->key->right->value, prev->key->right->value, 1);
-	list_move(&prev->list, &add->expressions);
+	list_move(&prev->list, &set->existing_set->init->expressions);
 }
 
 static void adjust_elem_right(struct set *set, struct expr *prev, struct expr *i,
-			      struct expr *add, struct expr *purge)
+			      struct expr *purge)
 {
-	struct expr *clone;
-
 	remove_elem(prev, set, purge);
-	__adjust_elem_right(set, prev, i, add);
+	__adjust_elem_right(set, prev, i);
 
 	list_del(&i->list);
 	expr_free(i);
-
-	clone = expr_clone(prev);
-	list_add_tail(&clone->list, &set->existing_set->init->expressions);
 }
 
 static void split_range(struct set *set, struct expr *prev, struct expr *i,
-			struct expr *add, struct expr *purge)
+			struct expr *purge)
 {
 	struct expr *clone;
 
@@ -339,37 +327,33 @@ static void split_range(struct set *set, struct expr *prev, struct expr *i,
 	expr_free(clone->key->left);
 	clone->key->left = expr_get(i->key->right);
 	mpz_add_ui(clone->key->left->value, i->key->right->value, 1);
-	list_move(&clone->list, &add->expressions);
-	clone = expr_clone(clone);
 	list_add_tail(&clone->list, &set->existing_set->init->expressions);
 
 	expr_free(prev->key->right);
 	prev->key->right = expr_get(i->key->left);
 	mpz_sub_ui(prev->key->right->value, i->key->left->value, 1);
-	list_move(&prev->list, &add->expressions);
-	clone = expr_clone(prev);
-	list_add_tail(&clone->list, &set->existing_set->init->expressions);
+	list_move(&prev->list, &set->existing_set->init->expressions);
 
 	list_del(&i->list);
 	expr_free(i);
 }
 
-static int setelem_adjust(struct set *set, struct expr *add, struct expr *purge,
+static int setelem_adjust(struct set *set, struct expr *purge,
 			  struct range *prev_range, struct range *range,
 			  struct expr *prev, struct expr *i)
 {
 	if (mpz_cmp(prev_range->low, range->low) == 0 &&
 	    mpz_cmp(prev_range->high, range->high) > 0) {
 		if (i->flags & EXPR_F_REMOVE)
-			adjust_elem_left(set, prev, i, add, purge);
+			adjust_elem_left(set, prev, i, purge);
 	} else if (mpz_cmp(prev_range->low, range->low) < 0 &&
 		   mpz_cmp(prev_range->high, range->high) == 0) {
 		if (i->flags & EXPR_F_REMOVE)
-			adjust_elem_right(set, prev, i, add, purge);
+			adjust_elem_right(set, prev, i, purge);
 	} else if (mpz_cmp(prev_range->low, range->low) < 0 &&
 		   mpz_cmp(prev_range->high, range->high) > 0) {
 		if (i->flags & EXPR_F_REMOVE)
-			split_range(set, prev, i, add, purge);
+			split_range(set, prev, i, purge);
 	} else {
 		return -1;
 	}
@@ -378,8 +362,8 @@ static int setelem_adjust(struct set *set, struct expr *add, struct expr *purge,
 }
 
 static int setelem_delete(struct list_head *msgs, struct set *set,
-			  struct expr *add, struct expr *purge,
-			  struct expr *elems, unsigned int debug_mask)
+			  struct expr *purge, struct expr *elems,
+			  unsigned int debug_mask)
 {
 	struct expr *i, *next, *prev = NULL;
 	struct range range, prev_range;
@@ -422,7 +406,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 				expr_free(i);
 			}
 		} else if (set->automerge &&
-			   setelem_adjust(set, add, purge, &prev_range, &range, prev, i) < 0) {
+			   setelem_adjust(set, purge, &prev_range, &range, prev, i) < 0) {
 			expr_error(msgs, i, "element does not exist");
 			err = -1;
 			goto err;
@@ -455,14 +439,14 @@ static void automerge_delete(struct list_head *msgs, struct set *set,
 }
 
 static int __set_delete(struct list_head *msgs, struct expr *i,	struct set *set,
-			struct expr *add, struct expr *init,
-			struct set *existing_set, unsigned int debug_mask)
+			struct expr *init, struct set *existing_set,
+			unsigned int debug_mask)
 {
 	i->flags |= EXPR_F_REMOVE;
 	list_move(&i->list, &existing_set->init->expressions);
 	list_expr_sort(&existing_set->init->expressions);
 
-	return setelem_delete(msgs, set, add, init, existing_set->init, debug_mask);
+	return setelem_delete(msgs, set, init, existing_set->init, debug_mask);
 }
 
 /* detection for unexisting intervals already exists in Linux kernels >= 5.7. */
@@ -470,7 +454,7 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	       struct expr *init, unsigned int debug_mask)
 {
 	struct set *existing_set = set->existing_set;
-	struct expr *i, *next, *add;
+	struct expr *i, *next, *add, *clone;
 	struct handle h = {};
 	struct cmd *add_cmd;
 	LIST_HEAD(del_list);
@@ -481,19 +465,25 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 		automerge_delete(msgs, set, init, debug_mask);
 
 	set_to_range(existing_set->init);
-	add = set_expr_alloc(&internal_location, set);
 
 	list_splice_init(&init->expressions, &del_list);
 
 	list_for_each_entry_safe(i, next, &del_list, list) {
-		err = __set_delete(msgs, i, set, add, init, existing_set, debug_mask);
+		err = __set_delete(msgs, i, set, init, existing_set, debug_mask);
 		if (err < 0) {
 			list_splice(&del_list, &init->expressions);
-			expr_free(add);
 			return err;
 		}
 	}
 
+	add = set_expr_alloc(&internal_location, set);
+	list_for_each_entry(i, &existing_set->init->expressions, list) {
+		if (!(i->flags & EXPR_F_KERNEL)) {
+			clone = expr_clone(i);
+			list_add_tail(&clone->list, &add->expressions);
+		}
+	}
+
 	if (debug_mask & NFT_DEBUG_SEGTREE) {
 		list_for_each_entry(i, &init->expressions, list)
 			gmp_printf("remove: [%Zx-%Zx]\n",
-- 
2.30.2

