Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBCFC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242286AbiDIOBI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 10:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiDIOBH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 10:01:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53B2DF2B
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:59:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndBcB-0008LX-9G; Sat, 09 Apr 2022 15:58:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 5/9] src: make interval sets work with string datatypes
Date:   Sat,  9 Apr 2022 15:58:28 +0200
Message-Id: <20220409135832.17401-6-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409135832.17401-1-fw@strlen.de>
References: <20220409135832.17401-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allows to interface names in interval sets:

table inet filter {
        set s {
                type ifname
                flags interval
                elements = { eth*, foo }
        }

Concatenations are not yet supported, also, listing is broken,
those strings will not be printed back because the values will remain
in big-endian order.  Followup patch will extend segtree to translate
this back to host byte order.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c |  8 ++++++--
 src/segtree.c    | 30 ++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index deb649e1847b..5d879b535990 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1442,7 +1442,11 @@ void range_expr_value_low(mpz_t rop, const struct expr *expr)
 {
 	switch (expr->etype) {
 	case EXPR_VALUE:
-		return mpz_set(rop, expr->value);
+		mpz_set(rop, expr->value);
+		if (expr->byteorder == BYTEORDER_HOST_ENDIAN &&
+		    expr_basetype(expr)->type == TYPE_STRING)
+			mpz_switch_byteorder(rop, expr->len / BITS_PER_BYTE);
+		return;
 	case EXPR_PREFIX:
 		return range_expr_value_low(rop, expr->prefix);
 	case EXPR_RANGE:
@@ -1462,7 +1466,7 @@ void range_expr_value_high(mpz_t rop, const struct expr *expr)
 
 	switch (expr->etype) {
 	case EXPR_VALUE:
-		return mpz_set(rop, expr->value);
+		return range_expr_value_low(rop, expr);
 	case EXPR_PREFIX:
 		range_expr_value_low(rop, expr->prefix);
 		assert(expr->len >= expr->prefix_len);
diff --git a/src/segtree.c b/src/segtree.c
index 188cafedce45..b4e76bf530d6 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -70,12 +70,30 @@ struct elementary_interval {
 	struct expr			*expr;
 };
 
+static enum byteorder get_key_byteorder(const struct expr *e)
+{
+	enum datatypes basetype = expr_basetype(e)->type;
+
+	switch (basetype) {
+	case TYPE_INTEGER:
+		/* For ranges, integers MUST be in BYTEORDER_BIG_ENDIAN.
+		 * If the LHS (lookup key, e.g. 'meta mark', is host endian,
+		 * a byteorder expression is injected to convert the register
+		 * content before lookup.
+		 */
+		return BYTEORDER_BIG_ENDIAN;
+	case TYPE_STRING:
+		return BYTEORDER_HOST_ENDIAN;
+	default:
+		break;
+	}
+
+	return BYTEORDER_INVALID;
+}
+
 static void seg_tree_init(struct seg_tree *tree, const struct set *set,
 			  struct expr *init, unsigned int debug_mask)
 {
-	struct expr *first;
-
-	first = list_entry(init->expressions.next, struct expr, list);
 	tree->root	= RB_ROOT;
 	tree->keytype	= set->key->dtype;
 	tree->keylen	= set->key->len;
@@ -85,7 +103,8 @@ static void seg_tree_init(struct seg_tree *tree, const struct set *set,
 		tree->datatype	= set->data->dtype;
 		tree->datalen	= set->data->len;
 	}
-	tree->byteorder	= first->byteorder;
+
+	tree->byteorder = get_key_byteorder(set->key);
 	tree->debug_mask = debug_mask;
 }
 
@@ -608,6 +627,9 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 	expr = constant_expr_alloc(&internal_location, tree->keytype,
 				   tree->byteorder, tree->keylen, NULL);
 	mpz_set(expr->value, ei->left);
+	if (tree->byteorder == BYTEORDER_HOST_ENDIAN)
+		mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
+
 	expr = set_elem_expr_alloc(&internal_location, expr);
 
 	if (ei->expr != NULL) {
-- 
2.35.1

