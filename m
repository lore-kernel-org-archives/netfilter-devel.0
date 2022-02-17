Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E89C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Feb 2022 17:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243640AbiBQRRm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Feb 2022 12:17:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243636AbiBQRRl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Feb 2022 12:17:41 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EE571746B4
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Feb 2022 09:17:26 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 04BEC601E7
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Feb 2022 18:16:43 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v1 1/1] intervals: add support to automerge with kernel elements
Date:   Thu, 17 Feb 2022 18:17:00 +0100
Message-Id: <20220217171705.2637781-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220217171705.2637781-1-pablo@netfilter.org>
References: <20220217171705.2637781-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend the interval codebase to support for merging elements in the
kernel with userspace element updates.

Add EXPR_F_REMOVE flag to specify that a range needs to be removed
due to update (e.g. the range has been extended).

Add a list of elements to be purged to set objects. These elements
representing outdated intervals are deleted before adding the updated
ranged.

This routine splices the list of userspace and kernel elements, then it
mergesorts to identify overlapping and contiguous ranges.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  1 +
 include/rule.h       |  1 +
 src/cache.c          |  3 +-
 src/intervals.c      | 77 ++++++++++++++++++++++++++++++++++----------
 src/rule.c           | 10 ++++++
 5 files changed, 74 insertions(+), 18 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 9c30883b706a..5ae435d0e3f9 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -200,6 +200,7 @@ enum expr_flags {
 	EXPR_F_BOOLEAN		= 0x10,
 	EXPR_F_INTERVAL		= 0x20,
 	EXPR_F_KERNEL		= 0x40,
+	EXPR_F_REMOVE		= 0x80,
 };
 
 #include <payload.h>
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
index 8e8387f91955..02882c5068c8 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -28,7 +28,8 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 			 NFT_CACHE_CHAIN |
 			 NFT_CACHE_SET |
 			 NFT_CACHE_OBJECT |
-			 NFT_CACHE_FLOWTABLE;
+			 NFT_CACHE_FLOWTABLE |
+			 NFT_CACHE_SETELEM_MAYBE;
 		break;
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_SET:
diff --git a/src/intervals.c b/src/intervals.c
index 2e5ea122835e..492c9d55848d 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -51,8 +51,13 @@ static void setelem_expr_to_range(struct expr *expr)
 	}
 }
 
-static void remove_overlapping_range(struct expr *i, struct expr *init)
+static void remove_overlapping_range(struct expr *prev, struct expr *i,
+				     struct expr *init)
 {
+	if (i->flags & EXPR_F_KERNEL) {
+		i->flags |= EXPR_F_REMOVE;
+		return;
+	}
 	list_del(&i->list);
 	expr_free(i);
 	init->size--;
@@ -63,24 +68,37 @@ struct range {
 	mpz_t	high;
 };
 
-static void merge_ranges(struct expr *prev, struct expr *i,
+static bool merge_ranges(struct expr *prev, struct expr *i,
 			 struct range *prev_range, struct range *range,
 			 struct expr *init)
 {
-	expr_free(prev->key->right);
-	prev->key->right = expr_get(i->key->right);
-	list_del(&i->list);
-	expr_free(i);
-	mpz_set(prev_range->high, range->high);
-	init->size--;
+	if (prev->flags & EXPR_F_KERNEL) {
+		prev->flags |= EXPR_F_REMOVE;
+		expr_free(i->key->left);
+		i->key->left = expr_get(prev->key->left);
+		mpz_set(prev_range->high, range->high);
+		return true;
+	} else if (i->flags & EXPR_F_KERNEL) {
+		i->flags |= EXPR_F_REMOVE;
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
+			      struct expr *init)
 {
 	struct expr *i, *next, *prev = NULL;
 	struct range range, prev_range;
-	int err = 0;
 	mpz_t rop;
 
 	mpz_init(prev_range.low);
@@ -105,16 +123,18 @@ static int setelem_automerge(struct list_head *msgs, struct set *set,
 
 		if (mpz_cmp(prev_range.low, range.low) <= 0 &&
 		    mpz_cmp(prev_range.high, range.high) >= 0) {
-			remove_overlapping_range(i, init);
+			remove_overlapping_range(prev, i, init);
 			continue;
 		} else if (mpz_cmp(range.low, prev_range.high) <= 0) {
-			merge_ranges(prev, i, &prev_range, &range, init);
+			if (merge_ranges(prev, i, &prev_range, &range, init))
+				prev = i;
 			continue;
 		} else if (set->automerge) {
 			mpz_sub(rop, range.low, prev_range.high);
 			/* two contiguous ranges */
 			if (mpz_cmp_ui(rop, 1) == 0) {
-				merge_ranges(prev, i, &prev_range, &range, init);
+				if (merge_ranges(prev, i, &prev_range, &range, init))
+					prev = i;
 				continue;
 			}
 		}
@@ -129,8 +149,6 @@ static int setelem_automerge(struct list_head *msgs, struct set *set,
 	mpz_clear(range.low);
 	mpz_clear(range.high);
 	mpz_clear(rop);
-
-	return err;
 }
 
 void set_to_range(struct expr *init)
@@ -156,12 +174,37 @@ void set_to_range(struct expr *init)
 
 int set_automerge(struct list_head *msgs, struct set *set, struct expr *init)
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
+	setelem_automerge(msgs, set, init);
+
+	if (!set->purge)
+		set->purge = set_expr_alloc(&internal_location, set);
+
+	list_for_each_entry_safe(i, next, &init->expressions, list) {
+		if (i->flags & EXPR_F_KERNEL) {
+			if (i->flags & EXPR_F_REMOVE)
+				list_move_tail(&i->list, &set->purge->expressions);
+			else
+				list_move_tail(&i->list, &existing_set->init->expressions);
+		} else if (existing_set && existing_set->init) {
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

