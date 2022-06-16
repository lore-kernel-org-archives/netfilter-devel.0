Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3117C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jun 2022 09:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376445AbiFPJEz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 05:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiFPJEx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 05:04:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BDF2338BF
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2022 02:04:51 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 2/2,v2] intervals: Do not sort cached set elements over and over again
Date:   Thu, 16 Jun 2022 11:04:46 +0200
Message-Id: <20220616090446.275985-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220616090446.275985-1-pablo@netfilter.org>
References: <20220616090446.275985-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

When adding element(s) to a non-empty set, code merged the two lists and
sorted the result. With many individual 'add element' commands this
causes substantial overhead. Make use of the fact that
existing_set->init is sorted already, sort only the list of new elements
and use list_splice_sorted() to merge the two sorted lists.

Add set_sort_splice() and use it for set element overlap detection and
automerge.

A test case adding ~25k elements in individual commands completes in
about 1/4th of the time with this patch applied.

Joint work with Pablo.

Fixes: 3da9643fb9ff9 ("intervals: add support to automerge with kernel elements")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: add set_sort_splice() and reuse it for the automerge case.

 include/expression.h |  1 +
 src/intervals.c      | 46 +++++++++++++++++++++-----------------------
 src/mergesort.c      |  2 +-
 3 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 2c3818e89b79..0f7ffb3a0a62 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -480,6 +480,7 @@ extern struct expr *compound_expr_alloc(const struct location *loc,
 extern void compound_expr_add(struct expr *compound, struct expr *expr);
 extern void compound_expr_remove(struct expr *compound, struct expr *expr);
 extern void list_expr_sort(struct list_head *head);
+extern void list_splice_sorted(struct list_head *list, struct list_head *head);
 
 extern struct expr *concat_expr_alloc(const struct location *loc);
 
diff --git a/src/intervals.c b/src/intervals.c
index e20341320da2..dcc06d18d594 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -118,6 +118,26 @@ static bool merge_ranges(struct set_automerge_ctx *ctx,
 	return false;
 }
 
+static void set_sort_splice(struct expr *init, struct set *set)
+{
+	struct set *existing_set = set->existing_set;
+
+	set_to_range(init);
+	list_expr_sort(&init->expressions);
+
+	if (!existing_set)
+		return;
+
+	if (existing_set->init) {
+		set_to_range(existing_set->init);
+		list_splice_sorted(&existing_set->init->expressions,
+				   &init->expressions);
+		init_list_head(&existing_set->init->expressions);
+	} else {
+		existing_set->init = set_expr_alloc(&internal_location, set);
+	}
+}
+
 static void setelem_automerge(struct set_automerge_ctx *ctx)
 {
 	struct expr *i, *next, *prev = NULL;
@@ -222,18 +242,7 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 		return 0;
 	}
 
-	if (existing_set) {
-		if (existing_set->init) {
-			list_splice_init(&existing_set->init->expressions,
-					 &init->expressions);
-		} else {
-			existing_set->init = set_expr_alloc(&internal_location,
-							    set);
-		}
-	}
-
-	set_to_range(init);
-	list_expr_sort(&init->expressions);
+	set_sort_splice(init, set);
 
 	ctx.purge = set_expr_alloc(&internal_location, set);
 
@@ -591,18 +600,7 @@ int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 	struct expr *i, *n, *clone;
 	int err;
 
-	if (existing_set) {
-		if (existing_set->init) {
-			list_splice_init(&existing_set->init->expressions,
-					 &init->expressions);
-		} else {
-			existing_set->init = set_expr_alloc(&internal_location,
-							    set);
-		}
-	}
-
-	set_to_range(init);
-	list_expr_sort(&init->expressions);
+	set_sort_splice(init, set);
 
 	err = setelem_overlap(msgs, set, init);
 
diff --git a/src/mergesort.c b/src/mergesort.c
index 8e6aac5fb24e..dca71422dd94 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -70,7 +70,7 @@ static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
 	return ret;
 }
 
-static void list_splice_sorted(struct list_head *list, struct list_head *head)
+void list_splice_sorted(struct list_head *list, struct list_head *head)
 {
 	struct list_head *h = head->next;
 	struct list_head *l = list->next;
-- 
2.30.2

