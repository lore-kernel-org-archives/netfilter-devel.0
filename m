Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFCBC4167B
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Apr 2022 01:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiDMBwB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 21:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiDMBv6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 21:51:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51CF024085
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 18:49:38 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft,v6 8/8] src: restore interval sets work with string datatypes
Date:   Wed, 13 Apr 2022 03:49:30 +0200
Message-Id: <20220413014930.410728-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220413014930.410728-1-pablo@netfilter.org>
References: <20220413014930.410728-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Switch byteorder of string datatypes to host byteorder.

Partial revert of ("src: make interval sets work with string datatypes")
otherwise new interval code complains with conflicting intervals.

testcases/sets/sets_with_ifnames passes fine again.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 8 ++------
 src/intervals.c  | 6 ++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 5d879b535990..deb649e1847b 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1442,11 +1442,7 @@ void range_expr_value_low(mpz_t rop, const struct expr *expr)
 {
 	switch (expr->etype) {
 	case EXPR_VALUE:
-		mpz_set(rop, expr->value);
-		if (expr->byteorder == BYTEORDER_HOST_ENDIAN &&
-		    expr_basetype(expr)->type == TYPE_STRING)
-			mpz_switch_byteorder(rop, expr->len / BITS_PER_BYTE);
-		return;
+		return mpz_set(rop, expr->value);
 	case EXPR_PREFIX:
 		return range_expr_value_low(rop, expr->prefix);
 	case EXPR_RANGE:
@@ -1466,7 +1462,7 @@ void range_expr_value_high(mpz_t rop, const struct expr *expr)
 
 	switch (expr->etype) {
 	case EXPR_VALUE:
-		return range_expr_value_low(rop, expr);
+		return mpz_set(rop, expr->value);
 	case EXPR_PREFIX:
 		range_expr_value_low(rop, expr->prefix);
 		assert(expr->len >= expr->prefix_len);
diff --git a/src/intervals.c b/src/intervals.c
index f672d0aac573..451bc4dd4dd4 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -25,6 +25,9 @@ static void setelem_expr_to_range(struct expr *expr)
 	case EXPR_PREFIX:
 		mpz_init(rop);
 		mpz_bitmask(rop, expr->key->len - expr->key->prefix_len);
+		if (expr_basetype(expr)->type == TYPE_STRING)
+			mpz_switch_byteorder(expr->key->prefix->value, expr->len / BITS_PER_BYTE);
+
 		mpz_ior(rop, rop, expr->key->prefix->value);
 	        mpz_export_data(data, rop, expr->key->prefix->byteorder,
 				expr->key->prefix->len / BITS_PER_BYTE);
@@ -40,6 +43,9 @@ static void setelem_expr_to_range(struct expr *expr)
 		expr->key = key;
 		break;
 	case EXPR_VALUE:
+		if (expr_basetype(expr)->type == TYPE_STRING)
+			mpz_switch_byteorder(expr->key->value, expr->len / BITS_PER_BYTE);
+
 		key = range_expr_alloc(&expr->location,
 				       expr_clone(expr->key),
 				       expr_get(expr->key));
-- 
2.30.2

