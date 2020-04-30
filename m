Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C33C47247
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3F920661
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgD3POY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 11:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726661AbgD3POY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 11:14:24 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0904C035494
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 08:14:23 -0700 (PDT)
Received: from localhost ([::1]:43932 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jUAtK-0008Af-Lp; Thu, 30 Apr 2020 17:14:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/4] segtree: Merge get_set_interval_find() and get_set_interval_end()
Date:   Thu, 30 Apr 2020 17:14:07 +0200
Message-Id: <20200430151408.32283-4-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200430151408.32283-1-phil@nwl.cc>
References: <20200430151408.32283-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Both functions were very similar already. Under the assumption that they
will always either see a range (or start of) that matches exactly or not
at all, reduce complexity and make get_set_interval_find() accept NULL
(left or) right values. This way it becomes a full replacement for
get_set_interval_end().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 63 +++++++++++++--------------------------------------
 1 file changed, 16 insertions(+), 47 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index f81a66e185990..6aa6f97a4ebfe 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -694,63 +694,31 @@ static struct expr *get_set_interval_find(const struct table *table,
 {
 	struct expr *range = NULL;
 	struct set *set;
-	mpz_t low, high;
 	struct expr *i;
+	mpz_t val;
 
 	set = set_lookup(table, set_name);
-	mpz_init2(low, set->key->len);
-	mpz_init2(high, set->key->len);
+	mpz_init2(val, set->key->len);
 
 	list_for_each_entry(i, &set->init->expressions, list) {
 		switch (i->key->etype) {
 		case EXPR_RANGE:
-			range_expr_value_low(low, i);
-			range_expr_value_high(high, i);
-			if (mpz_cmp(left->key->value, low) >= 0 &&
-			    mpz_cmp(right->key->value, high) <= 0) {
-				range = expr_clone(i->key);
-				goto out;
-			}
-			break;
-		default:
-			break;
-		}
-	}
-out:
-	mpz_clear(low);
-	mpz_clear(high);
-
-	return range;
-}
-
-static struct expr *get_set_interval_end(const struct table *table,
-					 const char *set_name,
-					 struct expr *left)
-{
-	struct expr *i, *range = NULL;
-	struct set *set;
-	mpz_t low, high;
+			range_expr_value_low(val, i);
+			if (left && mpz_cmp(left->key->value, val))
+				break;
 
-	set = set_lookup(table, set_name);
-	mpz_init2(low, set->key->len);
-	mpz_init2(high, set->key->len);
+			range_expr_value_high(val, i);
+			if (right && mpz_cmp(right->key->value, val))
+				break;
 
-	list_for_each_entry(i, &set->init->expressions, list) {
-		switch (i->key->etype) {
-		case EXPR_RANGE:
-			range_expr_value_low(low, i);
-			if (mpz_cmp(low, left->key->value) == 0) {
-				range = expr_clone(i->key);
-				goto out;
-			}
-			break;
+			range = expr_clone(i->key);
+			goto out;
 		default:
 			break;
 		}
 	}
 out:
-	mpz_clear(low);
-	mpz_clear(high);
+	mpz_clear(val);
 
 	return range;
 }
@@ -780,9 +748,9 @@ int get_set_decompose(struct table *table, struct set *set)
 			left = NULL;
 		} else {
 			if (left) {
-				range = get_set_interval_end(table,
-							     set->handle.set.name,
-							     left);
+				range = get_set_interval_find(table,
+							      set->handle.set.name,
+							      left, NULL);
 				if (range)
 					compound_expr_add(new_init, range);
 				else
@@ -793,7 +761,8 @@ int get_set_decompose(struct table *table, struct set *set)
 		}
 	}
 	if (left) {
-		range = get_set_interval_end(table, set->handle.set.name, left);
+		range = get_set_interval_find(table, set->handle.set.name,
+					      left, NULL);
 		if (range)
 			compound_expr_add(new_init, range);
 		else
-- 
2.25.1

