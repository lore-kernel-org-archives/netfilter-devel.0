Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42B4C48BCD
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 14:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDA52613C3
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 14:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbhFIOEZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 10:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237223AbhFIOEV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 10:04:21 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5B8C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Jun 2021 07:02:23 -0700 (PDT)
Received: from localhost ([::1]:35102 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1lqymi-0004kE-5W; Wed, 09 Jun 2021 16:02:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] segtree: Fix segfault when restoring a huge interval set
Date:   Wed,  9 Jun 2021 16:02:33 +0200
Message-Id: <20210609140233.8085-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Restoring a set of IPv4 prefixes with about 1.1M elements crashes nft as
set_to_segtree() exhausts the stack. Prevent this by allocating the
pointer array on heap and make sure it is freed before returning to
caller.

With this patch in place, restoring said set succeeds with allocation of
about 3GB of memory, according to valgrind.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index a4e047e79fc4f..9de5422c7d7f6 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -435,10 +435,10 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 			  struct expr *init, struct seg_tree *tree,
 			  bool add, bool merge)
 {
-	struct elementary_interval *intervals[init->size];
+	struct elementary_interval **intervals;
 	struct expr *i, *next;
 	unsigned int n;
-	int err;
+	int err = 0;
 
 	/* We are updating an existing set with new elements, check if the new
 	 * interval overlaps with any of the existing ones.
@@ -449,6 +449,7 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 			return err;
 	}
 
+	intervals = xmalloc_array(init->size, sizeof(intervals[0]));
 	n = expr_to_intervals(init, tree->keylen, intervals);
 
 	list_for_each_entry_safe(i, next, &init->expressions, list) {
@@ -467,10 +468,11 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 	for (n = 0; n < init->size; n++) {
 		err = ei_insert(msgs, tree, intervals[n], merge);
 		if (err < 0)
-			return err;
+			break;
 	}
 
-	return 0;
+	xfree(intervals);
+	return err;
 }
 
 static bool segtree_needs_first_segment(const struct set *set,
-- 
2.31.1

