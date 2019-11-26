Return-Path: <SRS0=M/8g=ZS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E560C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 10:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D8EA2071E
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 10:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfKZKea (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Nov 2019 05:34:30 -0500
Received: from correo.us.es ([193.147.175.20]:40746 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727810AbfKZKea (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 05:34:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 006FD508CEE
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Nov 2019 11:34:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5489B8019
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Nov 2019 11:34:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E49EEB8017; Tue, 26 Nov 2019 11:34:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9CA0FB362;
        Tue, 26 Nov 2019 11:34:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 26 Nov 2019 11:34:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (barqueta.lsi.us.es [150.214.188.150])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B637C426CCBA;
        Tue, 26 Nov 2019 11:34:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 1/2] Revert "segtree: Check ranges when deleting elements"
Date:   Tue, 26 Nov 2019 11:34:21 +0100
Message-Id: <20191126103422.29501-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This partially reverts commit decc12ec2dc3 ("segtree: Check ranges when
deleting elements").

The tests/shell/testcases/sets/0039delete_interval_0 file is left in
place.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c                                    | 41 +++++++-----------------
 tests/shell/testcases/sets/0039delete_interval_0 |  0
 2 files changed, 11 insertions(+), 30 deletions(-)
 mode change 100755 => 100644 tests/shell/testcases/sets/0039delete_interval_0

diff --git a/src/segtree.c b/src/segtree.c
index 9f1eecc0ae7e..50e34050c167 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -334,13 +334,6 @@ static unsigned int expr_to_intervals(const struct expr *set,
 	return n;
 }
 
-static bool intervals_match(const struct elementary_interval *e1,
-			    const struct elementary_interval *e2)
-{
-	return mpz_cmp(e1->left, e2->left) == 0 &&
-	       mpz_cmp(e1->right, e2->right) == 0;
-}
-
 /* This function checks for overlaps in two ways:
  *
  * 1) A new interval end intersects an existing interval.
@@ -350,7 +343,8 @@ static bool intervals_match(const struct elementary_interval *e1,
 static bool interval_overlap(const struct elementary_interval *e1,
 			     const struct elementary_interval *e2)
 {
-	if (intervals_match(e1, e2))
+	if (mpz_cmp(e1->left, e2->left) == 0 &&
+	    mpz_cmp(e1->right, e2->right) == 0)
 		return false;
 
 	return (mpz_cmp(e1->left, e2->left) >= 0 &&
@@ -362,7 +356,7 @@ static bool interval_overlap(const struct elementary_interval *e1,
 }
 
 static int set_overlap(struct list_head *msgs, const struct set *set,
-		       struct expr *init, unsigned int keylen, bool add)
+		       struct expr *init, unsigned int keylen)
 {
 	struct elementary_interval *new_intervals[init->size];
 	struct elementary_interval *intervals[set->init->size];
@@ -373,28 +367,15 @@ static int set_overlap(struct list_head *msgs, const struct set *set,
 	m = expr_to_intervals(set->init, keylen, intervals);
 
 	for (i = 0; i < n; i++) {
-		bool found = false;
-
 		for (j = 0; j < m; j++) {
-			if (add && interval_overlap(new_intervals[i],
-						    intervals[j])) {
-				expr_error(msgs, new_intervals[i]->expr,
-					   "interval overlaps with an existing one");
-				errno = EEXIST;
-				ret = -1;
-				goto out;
-			} else if (!add && intervals_match(new_intervals[i],
-							   intervals[j])) {
-				found = true;
-				break;
-			}
-		}
-		if (!add && !found) {
+			if (!interval_overlap(new_intervals[i], intervals[j]))
+				continue;
+
 			expr_error(msgs, new_intervals[i]->expr,
-				   "interval not found in set");
-			errno = ENOENT;
+				   "interval overlaps with an existing one");
+			errno = EEXIST;
 			ret = -1;
-			break;
+			goto out;
 		}
 	}
 out:
@@ -418,8 +399,8 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 	/* We are updating an existing set with new elements, check if the new
 	 * interval overlaps with any of the existing ones.
 	 */
-	if (set->init && set->init != init) {
-		err = set_overlap(msgs, set, init, tree->keylen, add);
+	if (add && set->init && set->init != init) {
+		err = set_overlap(msgs, set, init, tree->keylen);
 		if (err < 0)
 			return err;
 	}
diff --git a/tests/shell/testcases/sets/0039delete_interval_0 b/tests/shell/testcases/sets/0039delete_interval_0
old mode 100755
new mode 100644
-- 
2.11.0

