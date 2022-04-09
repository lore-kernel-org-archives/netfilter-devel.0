Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6361DC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbiDIOBe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 10:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242300AbiDIOBZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 10:01:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BD43054F
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:59:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndBcS-0008Mw-OC; Sat, 09 Apr 2022 15:59:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 9/9] segtree: add support for get element with sets that contain ifnames
Date:   Sat,  9 Apr 2022 15:58:32 +0200
Message-Id: <20220409135832.17401-10-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409135832.17401-1-fw@strlen.de>
References: <20220409135832.17401-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft get element inet filter s { bla, prefixfoo }
table inet filter {
        set s {
                type ifname
                flags interval
                elements = { "prefixfoo*",
                             "bla" }
        }

Also add test cases for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/segtree.c                                | 59 +++++++++++++++-----
 tests/shell/testcases/sets/sets_with_ifnames | 21 ++++++-
 2 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 0135a07492b0..3ccf5ee129fc 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -774,6 +774,12 @@ static struct expr *get_set_interval_find(const struct set *cache_set,
 
 	list_for_each_entry(i, &set->init->expressions, list) {
 		switch (i->key->etype) {
+		case EXPR_VALUE:
+			if (expr_basetype(i->key)->type != TYPE_STRING)
+				break;
+			/* string type, check if its a range (wildcard), so
+			 * fall through.
+			 */
 		case EXPR_PREFIX:
 		case EXPR_RANGE:
 			range_expr_value_low(val, i);
@@ -796,6 +802,18 @@ out:
 	return range;
 }
 
+static struct expr *expr_value(struct expr *expr)
+{
+	switch (expr->etype) {
+	case EXPR_MAPPING:
+		return expr->left->key;
+	case EXPR_SET_ELEM:
+		return expr->key;
+	default:
+		BUG("invalid expression type %s\n", expr_name(expr));
+	}
+}
+
 static struct expr *__expr_to_set_elem(struct expr *low, struct expr *expr)
 {
 	struct expr *elem = set_elem_expr_alloc(&low->location, expr);
@@ -812,6 +830,31 @@ static struct expr *__expr_to_set_elem(struct expr *low, struct expr *expr)
 	return elem;
 }
 
+static struct expr *expr_to_set_elem(struct expr *e)
+{
+	unsigned int len = div_round_up(e->len, BITS_PER_BYTE);
+	unsigned int str_len;
+	char data[len + 1];
+	struct expr *expr;
+
+	if (expr_basetype(expr_value(e))->type != TYPE_STRING)
+		return expr_clone(e);
+
+	mpz_export_data(data, expr_value(e)->value, BYTEORDER_BIG_ENDIAN, len);
+
+	str_len = strnlen(data, len);
+	if (str_len >= len || str_len == 0)
+		return expr_clone(e);
+
+	data[str_len] = '*';
+
+	expr = constant_expr_alloc(&e->location, e->dtype,
+				   BYTEORDER_HOST_ENDIAN,
+				   (str_len + 1) * BITS_PER_BYTE, data);
+
+	return __expr_to_set_elem(e, expr);
+}
+
 int get_set_decompose(struct set *cache_set, struct set *set)
 {
 	struct expr *i, *next, *range;
@@ -846,7 +889,7 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 					compound_expr_add(new_init, range);
 				else
 					compound_expr_add(new_init,
-							  expr_clone(left));
+							  expr_to_set_elem(left));
 			}
 			left = i;
 		}
@@ -856,7 +899,7 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 		if (range)
 			compound_expr_add(new_init, range);
 		else
-			compound_expr_add(new_init, expr_clone(left));
+			compound_expr_add(new_init, expr_to_set_elem(left));
 	}
 
 	expr_free(set->init);
@@ -878,18 +921,6 @@ static bool range_is_prefix(const mpz_t range)
 	return ret;
 }
 
-static struct expr *expr_value(struct expr *expr)
-{
-	switch (expr->etype) {
-	case EXPR_MAPPING:
-		return expr->left->key;
-	case EXPR_SET_ELEM:
-		return expr->key;
-	default:
-		BUG("invalid expression type %s\n", expr_name(expr));
-	}
-}
-
 static int expr_value_cmp(const void *p1, const void *p2)
 {
 	struct expr *e1 = *(void * const *)p1;
diff --git a/tests/shell/testcases/sets/sets_with_ifnames b/tests/shell/testcases/sets/sets_with_ifnames
index 0f9a6b5b0048..10e6c331bdca 100755
--- a/tests/shell/testcases/sets/sets_with_ifnames
+++ b/tests/shell/testcases/sets/sets_with_ifnames
@@ -22,11 +22,22 @@ check_elem()
 	setname=$1
 	ifname=$2
 	fail=$3
+	result=$4
+
+	if [ -z "$result" ]; then
+		result=$ifname
+	fi
 
 	if [ $fail -eq 1 ]; then
 		ip netns exec "$ns1" $NFT get element inet testifsets $setname { "$ifname" } && exit 2
 	else
-		ip netns exec "$ns1" $NFT get element inet testifsets $setname { "$ifname" } || exit 3
+		result=$(ip netns exec "$ns1" $NFT get element inet testifsets $setname { "$ifname" } | grep "$result" )
+
+		if [ -z "$result" ] ; then
+			echo "empty result, expected $ifname"
+			ip netns exec "$ns1" $NFT get element inet testifsets $setname { "$ifname" }
+			exit 1
+		fi
 	fi
 }
 
@@ -61,6 +72,14 @@ done
 
 check_elem simple foo 1
 
+for n in ppp0 othername;do
+	check_elem simple_wild $n 0
+done
+
+check_elem simple_wild enoent 1
+check_elem simple_wild ppp0 0
+check_elem simple_wild abcdefghijk 0 'abcdef\*'
+
 set -e
 ip -net "$ns1" link set lo up
 ip -net "$ns2" link set lo up
-- 
2.35.1

