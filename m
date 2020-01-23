Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1397C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 14:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C297F2077C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 14:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgAWOan (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 09:30:43 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:39884 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgAWOan (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 09:30:43 -0500
Received: from localhost ([::1]:52972 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iudVK-0000n9-Db; Thu, 23 Jan 2020 15:30:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 1/4] segtree: Drop needless insertion in ei_insert()
Date:   Thu, 23 Jan 2020 15:30:46 +0100
Message-Id: <20200123143049.13888-2-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123143049.13888-1-phil@nwl.cc>
References: <20200123143049.13888-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Code checks whether for two new ranges one fully includes the other. If
so, it would add the contained one only for segtree_linearize() to later
omit the redundant items.

Instead just drop the contained item (which will always come last
because caller orders the new elements in beforehand).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index e8e32412f3a41..aa1f1c38d789c 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -191,9 +191,6 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 		     struct elementary_interval *new, bool merge)
 {
 	struct elementary_interval *lei, *rei;
-	mpz_t p;
-
-	mpz_init2(p, tree->keylen);
 
 	/*
 	 * Lookup the intervals containing the left and right endpoints.
@@ -207,25 +204,9 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 	if (lei != NULL && rei != NULL && lei == rei) {
 		if (!merge)
 			goto err;
-		/*
-		 * The new interval is entirely contained in the same interval,
-		 * split it into two parts:
-		 *
-		 * [lei_left, new_left) and (new_right, rei_right]
-		 */
-		if (segtree_debug(tree->debug_mask))
-			pr_gmp_debug("split [%Zx %Zx]\n", lei->left, lei->right);
 
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
+		ei_destroy(new);
+		return 0;
 	} else {
 		if (lei != NULL) {
 			if (!merge)
@@ -271,8 +252,6 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 
 	__ei_insert(tree, new);
 
-	mpz_clear(p);
-
 	return 0;
 err:
 	errno = EEXIST;
-- 
2.24.1

