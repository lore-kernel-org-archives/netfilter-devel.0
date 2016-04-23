From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/4] segtree: add interval overlap detection for dynamic updates
Date: Sat, 23 Apr 2016 18:08:40 +0200
Message-ID: <1461427720-4939-5-git-send-email-pablo@netfilter.org>
References: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33752 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbcDWQIz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Apr 2016 12:08:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A43B8114805
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 94A499D0E2
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 842D09D0E2
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:51 +0200 (CEST)
In-Reply-To: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure the new intervals that we want to add are not overlapping with
any of the existing ones.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 879264b..1d505a5 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -327,12 +327,61 @@ static unsigned int expr_to_intervals(const struct expr *set,
 	return n;
 }
 
-static int set_to_segtree(struct list_head *msgs, struct expr *init,
-			  struct seg_tree *tree)
+/* This function checks for overlaps in two ways:
+ *
+ * 1) A new interval end intersects an existing interval.
+ * 2) New intervals that are larger than existing ones, that don't intersect
+ *    at all, but that wrap the existing ones.
+ */
+static bool interval_overlap(const struct elementary_interval *e1,
+			     const struct elementary_interval *e2)
+{
+	return (mpz_cmp(e1->left, e2->left) >= 0 &&
+	        mpz_cmp(e1->left, e2->right) <= 0) ||
+	       (mpz_cmp(e1->right, e2->left) >= 0 &&
+	        mpz_cmp(e1->right, e2->right) <= 0) ||
+	       (mpz_cmp(e1->left, e2->left) <= 0 &&
+		mpz_cmp(e1->right, e2->right) >= 0);
+}
+
+static int set_overlap(struct list_head *msgs, const struct set *set,
+		       struct expr *init, unsigned int keylen)
+{
+	struct elementary_interval *new_intervals[init->size];
+	struct elementary_interval *intervals[set->init->size];
+	unsigned int n, m, i, j;
+
+	n = expr_to_intervals(init, keylen, new_intervals);
+	m = expr_to_intervals(set->init, keylen, intervals);
+
+	for (i = 0; i < n; i++) {
+		for (j = 0; j < m; j++) {
+			if (interval_overlap(new_intervals[i], intervals[j]))
+				return expr_error(msgs,
+					new_intervals[i]->expr,
+					"interval overlaps with an existing one");
+		}
+	}
+
+	return 0;
+}
+
+static int set_to_segtree(struct list_head *msgs, struct set *set,
+			  struct expr *init, struct seg_tree *tree, bool add)
 {
 	struct elementary_interval *intervals[init->size];
 	struct expr *i, *next;
 	unsigned int n;
+	int err;
+
+	/* We are updating an existing set with new elements, check if the new
+	 * interval overlaps with any of the existing ones.
+	 */
+	if (add && set->init != init) {
+		err = set_overlap(msgs, set, init, tree->keylen);
+		if (err < 0)
+			return err;
+	}
 
 	n = expr_to_intervals(init, tree->keylen, intervals);
 
@@ -491,7 +540,7 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 	LIST_HEAD(list);
 
 	seg_tree_init(&tree, set, init);
-	if (set_to_segtree(errs, init, &tree) < 0)
+	if (set_to_segtree(errs, set, init, &tree, add) < 0)
 		return -1;
 	segtree_linearize(&list, set, init, &tree, add);
 
-- 
2.1.4

