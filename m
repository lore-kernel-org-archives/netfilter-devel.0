From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] segtree: sort set elements before decomposition
Date: Fri,  7 Mar 2014 11:30:26 +0100
Message-ID: <1394188226-5219-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36226 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaCGKbF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:31:05 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The decomposition phase currently depends on the kernel returning elements
in sorted order. This is a fragile assumption, change the code to sort the
elements itself.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/segtree.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index c169f8d..1785f64 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -516,23 +516,39 @@ static struct expr *expr_value(struct expr *expr)
 		return expr;
 }
 
+static int expr_value_cmp(const void *p1, const void *p2)
+{
+	struct expr *e1 = *(void * const *)p1;
+	struct expr *e2 = *(void * const *)p2;
+
+	return mpz_cmp(expr_value(e1)->value, expr_value(e2)->value);
+}
+
 void interval_map_decompose(struct expr *set)
 {
-	struct expr *ranges[set->size * 2];
+	struct expr *elements[set->size], *ranges[set->size * 2];
 	struct expr *i, *next, *low = NULL, *end;
-	unsigned int n, size;
+	unsigned int n, m, size;
 	mpz_t range, p;
 	bool interval;
 
 	mpz_init(range);
 	mpz_init(p);
 
-	size = set->size;
+	/* Sort elements */
 	n = 0;
+	list_for_each_entry_safe(i, next, &set->expressions, list) {
+		compound_expr_remove(set, i);
+		elements[n++] = i;
+	}
+	qsort(elements, n, sizeof(elements[0]), expr_value_cmp);
+	size = n;
 
+	/* Transform points (single values) into half-closed intervals */
+	n = 0;
 	interval = false;
-	list_for_each_entry_safe_reverse(i, next, &set->expressions, list) {
-		compound_expr_remove(set, i);
+	for (m = 0; m < size; m++) {
+		i = elements[m];
 
 		if (i->flags & EXPR_F_INTERVAL_END)
 			interval = false;
@@ -540,12 +556,12 @@ void interval_map_decompose(struct expr *set)
 			end = expr_clone(expr_value(i));
 			end->flags |= EXPR_F_INTERVAL_END;
 			ranges[n++] = end;
-			size++;
 		} else
 			interval = true;
 
 		ranges[n++] = i;
 	}
+	size = n;
 
 	for (n = 0; n < size; n++) {
 		i = ranges[n];
-- 
1.8.5.3

