Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B859CCA480
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jun 2022 17:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347829AbiFOReC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 13:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357970AbiFORdn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 13:33:43 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC00F60C1
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 10:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hZt7VL1FtEraS75sHEmF0+YK88jjNccBU0+xZmjUc3Q=; b=RmHkRvjQKG11yhnTKXZoY5f6z/
        Y/wuvon6h5XEb4xTr+Q2RLV0NNtRb+Rgpg81DwBVVOSOEARb9gq80trByKEVAvz0N4WW+YSqfC9qU
        lcyC1aNRBRGb9Ia1hDI40j8JMGs+i1QScqr1xfXfyUiKkSGlVAFbR81r6jEbhsRqvf2OOOdsA3gWD
        VVLB/ZGEooyWauO8q+AyRhRzdaP0ZrJdPtBaSP1AHGlIbAic+qW+iUcIQ/amAw4y9Z6VHwfbJzGm/
        XfaaKU9ZCcUY/UB/lJvfzcQ2JUSxpwRnEgPt/TcU0RrfPA8Nb8pR37n+kSNOXOzRleWYqu1dcXxfY
        rbYHkuHw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1o1Wte-0005nf-Kc; Wed, 15 Jun 2022 19:33:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] intervals: Do not sort cached set elements over and over again
Date:   Wed, 15 Jun 2022 19:33:29 +0200
Message-Id: <20220615173329.8595-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When adding element(s) to a non-empty set, code merged the two lists and
sorted the result. With many individual 'add element' commands this
causes substantial overhead. Make use of the fact that
existing_set->init is sorted already, sort only the list of new elements
and use list_splice_sorted() to merge the two sorted lists.

A test case adding ~25k elements in individual commands completes in
about 1/4th of the time with this patch applied.

Fixes: 3da9643fb9ff9 ("intervals: add support to automerge with kernel elements")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expression.h |  1 +
 src/intervals.c      | 10 ++++++----
 src/mergesort.c      |  2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 2c3818e89b791..0f7ffb3a0a623 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -480,6 +480,7 @@ extern struct expr *compound_expr_alloc(const struct location *loc,
 extern void compound_expr_add(struct expr *compound, struct expr *expr);
 extern void compound_expr_remove(struct expr *compound, struct expr *expr);
 extern void list_expr_sort(struct list_head *head);
+extern void list_splice_sorted(struct list_head *list, struct list_head *head);
 
 extern struct expr *concat_expr_alloc(const struct location *loc);
 
diff --git a/src/intervals.c b/src/intervals.c
index bc414d6c87976..a18967ee21061 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -589,19 +589,21 @@ int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 	struct expr *i, *n, *clone;
 	int err;
 
+	set_to_range(init);
+	list_expr_sort(&init->expressions);
+
 	if (existing_set) {
 		if (existing_set->init) {
-			list_splice_init(&existing_set->init->expressions,
+			set_to_range(existing_set->init);
+			list_splice_sorted(&existing_set->init->expressions,
 					 &init->expressions);
+			init_list_head(&existing_set->init->expressions);
 		} else {
 			existing_set->init = set_expr_alloc(&internal_location,
 							    set);
 		}
 	}
 
-	set_to_range(init);
-	list_expr_sort(&init->expressions);
-
 	err = setelem_overlap(msgs, set, init);
 
 	list_for_each_entry_safe(i, n, &init->expressions, list) {
diff --git a/src/mergesort.c b/src/mergesort.c
index 8e6aac5fb24ed..dca71422dd947 100644
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
2.34.1

