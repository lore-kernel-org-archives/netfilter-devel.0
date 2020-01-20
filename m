Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEF7C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 16:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99B512087E
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 16:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgATQ0H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 11:26:07 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:60814 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgATQ0H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 11:26:07 -0500
Received: from localhost ([::1]:45672 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1itZsL-00063k-6C; Mon, 20 Jan 2020 17:26:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/4] segtree: Fix for potential NULL-pointer deref in ei_insert()
Date:   Mon, 20 Jan 2020 17:25:39 +0100
Message-Id: <20200120162540.9699-4-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200120162540.9699-1-phil@nwl.cc>
References: <20200120162540.9699-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Covscan complained about potential deref of NULL 'lei' pointer,
Interestingly this can't happen as the relevant goto leading to that
(in line 260) sits in code checking conflicts between new intervals and
since those are sorted upon insertion, only the lower boundary may
conflict (or both, but that's covered before).

Given the needed investigation to proof covscan wrong and the actually
wrong (but impossible) code, better fix this as if element ordering was
arbitrary to avoid surprises if at some point it really becomes that.

Fixes: 4d6ad0f310d6c ("segtree: check for overlapping elements at insertion")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index e8e32412f3a41..04c0e915263b9 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -205,8 +205,11 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 		pr_gmp_debug("insert: [%Zx %Zx]\n", new->left, new->right);
 
 	if (lei != NULL && rei != NULL && lei == rei) {
-		if (!merge)
+		if (!merge) {
+			expr_binary_error(msgs, lei->expr, new->expr,
+					  "conflicting intervals specified");
 			goto err;
+		}
 		/*
 		 * The new interval is entirely contained in the same interval,
 		 * split it into two parts:
@@ -228,8 +231,11 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 		ei_destroy(lei);
 	} else {
 		if (lei != NULL) {
-			if (!merge)
+			if (!merge) {
+				expr_binary_error(msgs, lei->expr, new->expr,
+						  "conflicting intervals specified");
 				goto err;
+			}
 			/*
 			 * Left endpoint is within lei, adjust it so we have:
 			 *
@@ -248,8 +254,11 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 			}
 		}
 		if (rei != NULL) {
-			if (!merge)
+			if (!merge) {
+				expr_binary_error(msgs, rei->expr, new->expr,
+						  "conflicting intervals specified");
 				goto err;
+			}
 			/*
 			 * Right endpoint is within rei, adjust it so we have:
 			 *
@@ -276,8 +285,7 @@ static int ei_insert(struct list_head *msgs, struct seg_tree *tree,
 	return 0;
 err:
 	errno = EEXIST;
-	return expr_binary_error(msgs, lei->expr, new->expr,
-				 "conflicting intervals specified");
+	return -1;
 }
 
 /*
-- 
2.24.1

