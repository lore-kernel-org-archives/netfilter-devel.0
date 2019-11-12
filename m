Return-Path: <SRS0=y7H9=ZE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13363C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 19:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E61BF21783
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 19:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKLTKN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 14:10:13 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:48530 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbfKLTKN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 14:10:13 -0500
Received: from localhost ([::1]:33388 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iUbYK-0006z4-IA; Tue, 12 Nov 2019 20:10:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] segtree: Check ranges when deleting elements
Date:   Tue, 12 Nov 2019 20:10:07 +0100
Message-Id: <20191112191007.9752-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make sure any intervals to delete actually exist, otherwise reject the
command. Without this, it is possible to mess up rbtree contents:

| # nft list ruleset
| table ip t {
| 	set s {
| 		type ipv4_addr
| 		flags interval
| 		auto-merge
| 		elements = { 192.168.1.0-192.168.1.254, 192.168.1.255 }
| 	}
| }
| # nft delete element t s '{ 192.168.1.0/24 }'
| # nft list ruleset
| table ip t {
| 	set s {
| 		type ipv4_addr
| 		flags interval
| 		auto-merge
| 		elements = { 192.168.1.255-255.255.255.255 }
| 	}
| }

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c                                 | 41 ++++++++++++++-----
 .../testcases/sets/0039delete_interval_0      | 17 ++++++++
 2 files changed, 47 insertions(+), 11 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0039delete_interval_0

diff --git a/src/segtree.c b/src/segtree.c
index 5d6ecd4fcab1f..10c82eed5378f 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -334,6 +334,13 @@ static unsigned int expr_to_intervals(const struct expr *set,
 	return n;
 }
 
+static bool intervals_match(const struct elementary_interval *e1,
+			    const struct elementary_interval *e2)
+{
+	return mpz_cmp(e1->left, e2->left) == 0 &&
+	       mpz_cmp(e1->right, e2->right) == 0;
+}
+
 /* This function checks for overlaps in two ways:
  *
  * 1) A new interval end intersects an existing interval.
@@ -343,8 +350,7 @@ static unsigned int expr_to_intervals(const struct expr *set,
 static bool interval_overlap(const struct elementary_interval *e1,
 			     const struct elementary_interval *e2)
 {
-	if (mpz_cmp(e1->left, e2->left) == 0 &&
-	    mpz_cmp(e1->right, e2->right) == 0)
+	if (intervals_match(e1, e2))
 		return false;
 
 	return (mpz_cmp(e1->left, e2->left) >= 0 &&
@@ -356,7 +362,7 @@ static bool interval_overlap(const struct elementary_interval *e1,
 }
 
 static int set_overlap(struct list_head *msgs, const struct set *set,
-		       struct expr *init, unsigned int keylen)
+		       struct expr *init, unsigned int keylen, bool add)
 {
 	struct elementary_interval *new_intervals[init->size];
 	struct elementary_interval *intervals[set->init->size];
@@ -367,15 +373,28 @@ static int set_overlap(struct list_head *msgs, const struct set *set,
 	m = expr_to_intervals(set->init, keylen, intervals);
 
 	for (i = 0; i < n; i++) {
-		for (j = 0; j < m; j++) {
-			if (!interval_overlap(new_intervals[i], intervals[j]))
-				continue;
+		bool found = false;
 
+		for (j = 0; j < m; j++) {
+			if (add && interval_overlap(new_intervals[i],
+						    intervals[j])) {
+				expr_error(msgs, new_intervals[i]->expr,
+					   "interval overlaps with an existing one");
+				errno = EEXIST;
+				ret = -1;
+				goto out;
+			} else if (!add && intervals_match(new_intervals[i],
+							   intervals[j])) {
+				found = true;
+				break;
+			}
+		}
+		if (!add && !found) {
 			expr_error(msgs, new_intervals[i]->expr,
-				   "interval overlaps with an existing one");
-			errno = EEXIST;
+				   "interval not found in set");
+			errno = ENOENT;
 			ret = -1;
-			goto out;
+			break;
 		}
 	}
 out:
@@ -399,8 +418,8 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 	/* We are updating an existing set with new elements, check if the new
 	 * interval overlaps with any of the existing ones.
 	 */
-	if (add && set->init && set->init != init) {
-		err = set_overlap(msgs, set, init, tree->keylen);
+	if (set->init && set->init != init) {
+		err = set_overlap(msgs, set, init, tree->keylen, add);
 		if (err < 0)
 			return err;
 	}
diff --git a/tests/shell/testcases/sets/0039delete_interval_0 b/tests/shell/testcases/sets/0039delete_interval_0
new file mode 100755
index 0000000000000..19df16ec0e588
--- /dev/null
+++ b/tests/shell/testcases/sets/0039delete_interval_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+# Make sure nft allows to delete existing ranges only
+
+RULESET="
+table t {
+	set s {
+		type ipv4_addr
+		flags interval
+		elements = { 192.168.1.0-192.168.1.254, 192.168.1.255 }
+	}
+}"
+
+$NFT -f - <<< "$RULESET" || { echo "E: Can't load basic ruleset" 1>&2; exit 1; }
+
+$NFT delete element t s '{ 192.168.1.0/24 }' 2>/dev/null || exit 0
+echo "E: Deletion of non-existing range allowed" 1>&2
-- 
2.24.0

