Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA60C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242282AbiDIOBA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 10:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiDIOA7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 10:00:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0514AE0AA
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:58:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndBc2-0008Kn-FQ; Sat, 09 Apr 2022 15:58:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 3/9] segtree: split prefix and range creation to a helper function
Date:   Sat,  9 Apr 2022 15:58:26 +0200
Message-Id: <20220409135832.17401-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409135832.17401-1-fw@strlen.de>
References: <20220409135832.17401-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No functional change intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/segtree.c | 95 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 43 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index a61ea3d2854a..188cafedce45 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -773,6 +773,22 @@ out:
 	return range;
 }
 
+static struct expr *__expr_to_set_elem(struct expr *low, struct expr *expr)
+{
+	struct expr *elem = set_elem_expr_alloc(&low->location, expr);
+
+	if (low->etype == EXPR_MAPPING) {
+		interval_expr_copy(elem, low->left);
+
+		elem = mapping_expr_alloc(&low->location, elem,
+						    expr_clone(low->right));
+	} else {
+		interval_expr_copy(elem, low);
+	}
+
+	return elem;
+}
+
 int get_set_decompose(struct set *cache_set, struct set *set)
 {
 	struct expr *i, *next, *range;
@@ -980,6 +996,38 @@ next:
 	}
 }
 
+static struct expr *interval_to_prefix(struct expr *low, struct expr *i, const mpz_t range)
+{
+	unsigned int prefix_len;
+	struct expr *prefix;
+
+	prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
+	prefix = prefix_expr_alloc(&low->location,
+				   expr_clone(expr_value(low)),
+						   prefix_len);
+	prefix->len = expr_value(i)->len;
+
+	return __expr_to_set_elem(low, prefix);
+}
+
+static struct expr *interval_to_range(struct expr *low, struct expr *i, mpz_t range)
+{
+	struct expr *tmp;
+
+	tmp = constant_expr_alloc(&low->location, low->dtype,
+				  low->byteorder, expr_value(low)->len,
+				  NULL);
+
+	mpz_add(range, range, expr_value(low)->value);
+	mpz_set(tmp->value, range);
+
+	tmp = range_expr_alloc(&low->location,
+			       expr_clone(expr_value(low)),
+			       tmp);
+
+	return __expr_to_set_elem(low, tmp);
+}
+
 void interval_map_decompose(struct expr *set)
 {
 	struct expr *i, *next, *low = NULL, *end, *catchall = NULL, *key;
@@ -1065,52 +1113,13 @@ void interval_map_decompose(struct expr *set)
 		else if ((!range_is_prefix(range) ||
 			  !(i->dtype->flags & DTYPE_F_PREFIX)) ||
 			 mpz_cmp_ui(p, 0)) {
-			struct expr *tmp;
-
-			tmp = constant_expr_alloc(&low->location, low->dtype,
-						  low->byteorder, expr_value(low)->len,
-						  NULL);
-
-			mpz_add(range, range, expr_value(low)->value);
-			mpz_set(tmp->value, range);
+			struct expr *expr = interval_to_range(low, i, range);
 
-			tmp = range_expr_alloc(&low->location,
-					       expr_clone(expr_value(low)),
-					       tmp);
-			tmp = set_elem_expr_alloc(&low->location, tmp);
-
-			if (low->etype == EXPR_MAPPING) {
-				interval_expr_copy(tmp, low->left);
-
-				tmp = mapping_expr_alloc(&tmp->location, tmp,
-							 expr_clone(low->right));
-			} else {
-				interval_expr_copy(tmp, low);
-			}
-
-			compound_expr_add(set, tmp);
+			compound_expr_add(set, expr);
 		} else {
-			struct expr *prefix;
-			unsigned int prefix_len;
-
-			prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
-			prefix = prefix_expr_alloc(&low->location,
-						   expr_clone(expr_value(low)),
-						   prefix_len);
-			prefix->len = expr_value(i)->len;
-
-			prefix = set_elem_expr_alloc(&low->location, prefix);
-
-			if (low->etype == EXPR_MAPPING) {
-				interval_expr_copy(prefix, low->left);
-
-				prefix = mapping_expr_alloc(&low->location, prefix,
-							    expr_clone(low->right));
-			} else {
-				interval_expr_copy(prefix, low);
-			}
+			struct expr *expr = interval_to_prefix(low, i, range);
 
-			compound_expr_add(set, prefix);
+			compound_expr_add(set, expr);
 		}
 
 		if (i->flags & EXPR_F_INTERVAL_END) {
-- 
2.35.1

