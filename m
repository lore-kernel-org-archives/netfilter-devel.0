Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B7EECAAD8
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Sep 2022 17:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiIRRXK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Sep 2022 13:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIRRXJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Sep 2022 13:23:09 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC526640D
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Sep 2022 10:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V9NqDssTA/re+0bfPSLAKXOUYyY5fisFk8nhtord1Jk=; b=OpUBCOy+gP7YE1r+5kOS2eMAJN
        XkBBJRMOppqr7k5XeK//bWY21en9gIL8vd9+t/0b7qI6AQrmCgYpjd7yP3jZXMm7pNZaTg7XOiE9h
        G2BHnHg0XNZ+nj2X/1Xsx9sSGOHlTg4eJ12t08jopXCVp+7u+rGVoRlNlyc5kPxYo0JN+3VszECml
        t9wv2/T6WsAyN4YQ8OyYrLDOyfhnuQYZv5Z+/F51K3fo10qGwjbwQSomI9QdkoARLQEzZWe1ChT80
        YipQjHjpMrywM9OHAJrHM2315mDLhnzc9nVbroJQRe1rRutnsu53juKV9PQ4Pzhcg2mvGhBY6R7JU
        SRPMKyyw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oZy0Z-004VxI-1N
        for netfilter-devel@vger.kernel.org; Sun, 18 Sep 2022 18:23:07 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 1/2] segtree: refactor decomposition of closed intervals
Date:   Sun, 18 Sep 2022 18:22:11 +0100
Message-Id: <20220918172212.3681553-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220918172212.3681553-1-jeremy@azazel.net>
References: <20220918172212.3681553-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move the code in `interval_map_decompose` which adds a new closed
interval to the set into a separate function.  In addition to the moving
of the code, there is one other change: `compound_expr_add` is called
once, after the main conditional, instead of being called in each
branch.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/segtree.c | 71 +++++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index c36497ce6253..d15c39f31f3a 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -493,12 +493,48 @@ static struct expr *interval_to_range(struct expr *low, struct expr *i, mpz_t ra
 	return __expr_to_set_elem(low, tmp);
 }
 
+static void
+add_interval(struct expr *set, struct expr *low, struct expr *i)
+{
+	struct expr *expr;
+	mpz_t range, p;
+
+	mpz_init(range);
+	mpz_init(p);
+
+	mpz_sub(range, expr_value(i)->value, expr_value(low)->value);
+	mpz_sub_ui(range, range, 1);
+
+	mpz_and(p, expr_value(low)->value, range);
+
+	if (!mpz_cmp_ui(range, 0)) {
+		if (expr_basetype(low)->type == TYPE_STRING)
+			mpz_switch_byteorder(expr_value(low)->value,
+					     expr_value(low)->len / BITS_PER_BYTE);
+		low->flags |= EXPR_F_KERNEL;
+		expr = expr_get(low);
+	} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
+
+		if (i->dtype->flags & DTYPE_F_PREFIX)
+			expr = interval_to_prefix(low, i, range);
+		else if (expr_basetype(i)->type == TYPE_STRING)
+			expr = interval_to_string(low, i, range);
+		else
+			expr = interval_to_range(low, i, range);
+	} else
+		expr = interval_to_range(low, i, range);
+
+	compound_expr_add(set, expr);
+
+	mpz_clear(range);
+	mpz_clear(p);
+}
+
 void interval_map_decompose(struct expr *set)
 {
 	struct expr *i, *next, *low = NULL, *end, *catchall = NULL, *key;
 	struct expr **elements, **ranges;
 	unsigned int n, m, size;
-	mpz_t range, p;
 	bool interval;
 
 	if (set->size == 0)
@@ -507,9 +543,6 @@ void interval_map_decompose(struct expr *set)
 	elements = xmalloc_array(set->size, sizeof(struct expr *));
 	ranges = xmalloc_array(set->size * 2, sizeof(struct expr *));
 
-	mpz_init(range);
-	mpz_init(p);
-
 	/* Sort elements */
 	n = 0;
 	list_for_each_entry_safe(i, next, &set->expressions, list) {
@@ -568,32 +601,7 @@ void interval_map_decompose(struct expr *set)
 			}
 		}
 
-		mpz_sub(range, expr_value(i)->value, expr_value(low)->value);
-		mpz_sub_ui(range, range, 1);
-
-		mpz_and(p, expr_value(low)->value, range);
-
-		if (!mpz_cmp_ui(range, 0)) {
-			if (expr_basetype(low)->type == TYPE_STRING)
-				mpz_switch_byteorder(expr_value(low)->value, expr_value(low)->len / BITS_PER_BYTE);
-			low->flags |= EXPR_F_KERNEL;
-			compound_expr_add(set, expr_get(low));
-		} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
-			struct expr *expr;
-
-			if (i->dtype->flags & DTYPE_F_PREFIX)
-				expr = interval_to_prefix(low, i, range);
-			else if (expr_basetype(i)->type == TYPE_STRING)
-				expr = interval_to_string(low, i, range);
-			else
-				expr = interval_to_range(low, i, range);
-
-			compound_expr_add(set, expr);
-		} else {
-			struct expr *expr = interval_to_range(low, i, range);
-
-			compound_expr_add(set, expr);
-		}
+		add_interval(set, low, i);
 
 		if (i->flags & EXPR_F_INTERVAL_END) {
 			expr_free(low);
@@ -633,9 +641,6 @@ out:
 	if (catchall)
 		compound_expr_add(set, catchall);
 
-	mpz_clear(range);
-	mpz_clear(p);
-
 	xfree(ranges);
 	xfree(elements);
 }
-- 
2.35.1

