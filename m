From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/4] segtree: add expr_to_intervals()
Date: Sat, 23 Apr 2016 18:08:38 +0200
Message-ID: <1461427720-4939-3-git-send-email-pablo@netfilter.org>
References: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33749 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbcDWQIx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Apr 2016 12:08:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0C493114812
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F2E009D119
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E3CC69D119
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:49 +0200 (CEST)
In-Reply-To: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Refactor code to add the new expr_to_intervals(). This function takes
the list of set element expressions and convert them to a list of
half-closed intervals.

This is useful for different purposes, such as interval overlap
and conflicts detection.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index f544704..c8d63b8 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -299,20 +299,20 @@ static bool interval_conflict(const struct elementary_interval *e1,
 		return false;
 }
 
-static int set_to_segtree(struct list_head *msgs, struct expr *set,
-			  struct seg_tree *tree)
+static unsigned int expr_to_intervals(const struct expr *set,
+				      unsigned int keylen,
+				      struct elementary_interval **intervals)
 {
-	struct elementary_interval *intervals[set->size];
 	struct elementary_interval *ei;
 	struct expr *i, *next;
 	unsigned int n;
 	mpz_t low, high;
 
-	mpz_init2(low, tree->keylen);
-	mpz_init2(high, tree->keylen);
+	mpz_init2(low, keylen);
+	mpz_init2(high, keylen);
 
 	/*
-	 * Convert elements to intervals and sort by priority.
+	 * Convert elements to intervals
 	 */
 	n = 0;
 	list_for_each_entry_safe(i, next, &set->expressions, list) {
@@ -320,10 +320,30 @@ static int set_to_segtree(struct list_head *msgs, struct expr *set,
 		range_expr_value_high(high, i);
 		ei = ei_alloc(low, high, i, 0);
 		intervals[n++] = ei;
+	}
+	mpz_clear(high);
+	mpz_clear(low);
+
+	return n;
+}
+
+static int set_to_segtree(struct list_head *msgs, struct expr *set,
+			  struct seg_tree *tree)
+{
+	struct elementary_interval *intervals[set->size];
+	struct expr *i, *next;
+	unsigned int n;
+
+	n = expr_to_intervals(set, tree->keylen, intervals);
 
+	list_for_each_entry_safe(i, next, &set->expressions, list) {
 		list_del(&i->list);
 		expr_free(i);
 	}
+
+	/*
+	 * Sort intervals by priority.
+	 */
 	qsort(intervals, n, sizeof(intervals[0]), interval_cmp);
 
 	/*
@@ -340,8 +360,6 @@ static int set_to_segtree(struct list_head *msgs, struct expr *set,
 		ei_insert(tree, intervals[n]);
 	}
 
-	mpz_clear(high);
-	mpz_clear(low);
 	return 0;
 }
 
-- 
2.1.4

