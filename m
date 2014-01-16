From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/2] segtree: fix decomposition of unclosed intervals
Date: Thu, 16 Jan 2014 16:21:52 +0000
Message-ID: <1389889312-4055-3-git-send-email-kaber@trash.net>
References: <1389889312-4055-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57343 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaAPQV6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:21:58 -0500
In-Reply-To: <1389889312-4055-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If intervals are directly adjacent or extend to the right end of the dimension,
they are not closed by a EXPR_F_INTERVAL_END entry. This leads to multiple
errors when decomposing the intervals:

- the last unclosed interval is not shown at all.

- if a range is unclosed and the set is a map, the starting point of the
  next interval is set to the data, not the key, leading to nonsensical
  output.

- if a prefix is unclosed, the interval is assumed to be a prefix as well
  and the same starting point is kept. This makes sense for cases like
  192.168.0.0/24, 192.168.0.0/16, but leads to hard to understand
  results if the next interval is not representable as a prefix.

Fix this by doing two things:

- add an EXPR_F_INTERVAL_END element for each unclosed interval during
  preprocessing.

- process the final unclosed interval extending to the right end of the
  dimension, if present.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/segtree.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index e3bca4c..1a21c6c 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -509,10 +509,11 @@ static struct expr *expr_value(struct expr *expr)
 
 void interval_map_decompose(struct expr *set)
 {
-	struct expr *ranges[set->size];
-	struct expr *i, *next, *low = NULL;
+	struct expr *ranges[set->size * 2];
+	struct expr *i, *next, *low = NULL, *end;
 	unsigned int n, size;
 	mpz_t range, p;
+	bool interval;
 
 	mpz_init(range);
 	mpz_init(p);
@@ -520,8 +521,20 @@ void interval_map_decompose(struct expr *set)
 	size = set->size;
 	n = 0;
 
+	interval = false;
 	list_for_each_entry_safe_reverse(i, next, &set->expressions, list) {
 		compound_expr_remove(set, i);
+
+		if (i->flags & EXPR_F_INTERVAL_END)
+			interval = false;
+		else if (interval) {
+			end = expr_clone(expr_value(i));
+			end->flags |= EXPR_F_INTERVAL_END;
+			ranges[n++] = end;
+			size++;
+		} else
+			interval = true;
+
 		ranges[n++] = i;
 	}
 
@@ -569,8 +582,6 @@ void interval_map_decompose(struct expr *set)
 				tmp = mapping_expr_alloc(&tmp->location, tmp, low->right);
 
 			compound_expr_add(set, tmp);
-
-			low = expr_get(tmp->right);
 		} else {
 			struct expr *prefix;
 			unsigned int prefix_len;
@@ -578,13 +589,9 @@ void interval_map_decompose(struct expr *set)
 			prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
 			prefix = prefix_expr_alloc(&low->location, expr_value(low),
 						   prefix_len);
-
-			if (low->ops->type == EXPR_MAPPING) {
+			if (low->ops->type == EXPR_MAPPING)
 				prefix = mapping_expr_alloc(&low->location, prefix,
 							    low->right);
-				/* Update mapping of "low" to the current mapping */
-				low->right = expr_get(i->right);
-			}
 
 			compound_expr_add(set, prefix);
 		}
@@ -595,4 +602,18 @@ void interval_map_decompose(struct expr *set)
 		}
 		expr_free(i);
 	}
+
+	/* Unclosed interval */
+	if (low != NULL) {
+		i = constant_expr_alloc(&low->location, low->dtype,
+					low->byteorder, expr_value(low)->len,
+					NULL);
+		mpz_init_bitmask(i->value, i->len);
+
+		i = range_expr_alloc(&low->location, expr_value(low), i);
+		if (low->ops->type == EXPR_MAPPING)
+			i = mapping_expr_alloc(&i->location, i, low->right);
+
+		compound_expr_add(set, i);
+	}
 }
-- 
1.8.4.2

