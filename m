Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE48C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 14:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1823E214AF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 14:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgAWOat (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 09:30:49 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:39894 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbgAWOat (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 09:30:49 -0500
Received: from localhost ([::1]:52982 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iudVP-0000nW-Uz; Thu, 23 Jan 2020 15:30:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 4/4] segtree: Refactor ei_insert()
Date:   Thu, 23 Jan 2020 15:30:49 +0100
Message-Id: <20200123143049.13888-5-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123143049.13888-1-phil@nwl.cc>
References: <20200123143049.13888-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With all simplifications in place, reorder the code to streamline it
further. Apart from making the second call to ei_lookup() conditional,
debug output is slightly enhanced.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 63 +++++++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 35 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 3c0989e76093a..edec9f4ebf174 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -192,48 +192,41 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 {
 	struct elementary_interval *lei, *rei;
 
-	/*
-	 * Lookup the intervals containing the left and right endpoints.
-	 */
 	lei = ei_lookup(tree, new->left);
-	rei = ei_lookup(tree, new->right);
-
-	if (segtree_debug(tree->debug_mask))
-		pr_gmp_debug("insert: [%Zx %Zx]\n", new->left, new->right);
-
-	if (lei != NULL && rei != NULL && lei == rei) {
-		if (!merge)
-			goto err;
-
-		ei_destroy(new);
+	if (lei == NULL) {
+		/* no overlaps, just add the new interval */
+		if (segtree_debug(tree->debug_mask))
+			pr_gmp_debug("insert: [%Zx %Zx]\n",
+				     new->left, new->right);
+		__ei_insert(tree, new);
 		return 0;
-	} else {
-		if (lei != NULL) {
-			if (!merge)
-				goto err;
-			/*
-			 * Left endpoint is within lei, adjust it so we have:
-			 *
-			 * [lei_left, new_right]
-			 */
-			if (segtree_debug(tree->debug_mask)) {
-				pr_gmp_debug("adjust left [%Zx %Zx]\n",
-					     lei->left, lei->right);
-			}
+	}
 
-			mpz_set(lei->right, new->right);
-			ei_destroy(new);
-			return 0;
-		}
+	if (!merge) {
+		errno = EEXIST;
+		return expr_binary_error(msgs, lei->expr, new->expr,
+					 "conflicting intervals specified");
 	}
 
-	__ei_insert(tree, new);
+	/* caller sorted intervals, so rei is either equal to lei or NULL */
+	rei = ei_lookup(tree, new->right);
+	if (rei != lei) {
+		/*
+		 * Left endpoint is within lei, adjust it so we have:
+		 *
+		 * [lei_left, new_right]
+		 */
+		if (segtree_debug(tree->debug_mask))
+			pr_gmp_debug("adjust right: [%Zx %Zx]\n",
+				     lei->left, lei->right);
+		mpz_set(lei->right, new->right);
+	} else if (segtree_debug(tree->debug_mask)) {
+		pr_gmp_debug("skip new: [%Zx %Zx] for old: [%Zx %Zx]\n",
+			     new->left, new->right, lei->left, lei->right);
+	}
 
+	ei_destroy(new);
 	return 0;
-err:
-	errno = EEXIST;
-	return expr_binary_error(msgs, lei->expr, new->expr,
-				 "conflicting intervals specified");
 }
 
 /*
-- 
2.24.1

