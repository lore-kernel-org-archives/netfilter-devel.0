Return-Path: <SRS0=I0Q5=UL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5615C31E46
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 12:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9325E20874
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 12:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbfFLMXg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:23:36 -0400
Received: from mail.us.es ([193.147.175.20]:42414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730260AbfFLMXg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 08:23:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D6DE5154E87
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 14:23:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4ABDDA707
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 14:23:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BA4B5DA701; Wed, 12 Jun 2019 14:23:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AEE05DA707
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 14:23:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 12 Jun 2019 14:23:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 977AD4265A2F
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 14:23:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] datatype: add datatype_set()
Date:   Wed, 12 Jun 2019 14:23:27 +0200
Message-Id: <20190612122328.3889-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612122328.3889-1-pablo@netfilter.org>
References: <20190612122328.3889-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use this function to assign a datatype to expression, this helper
already deals with reference counting for dynamic datatypes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h |  1 +
 src/datatype.c     |  7 +++++++
 src/evaluate.c     | 22 +++++++++++-----------
 src/expression.c   |  2 +-
 4 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 5765c1ba7502..23f45ab7d6eb 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -163,6 +163,7 @@ struct datatype {
 extern const struct datatype *datatype_lookup(enum datatypes type);
 extern const struct datatype *datatype_lookup_byname(const char *name);
 extern struct datatype *datatype_get(const struct datatype *dtype);
+extern void datatype_set(struct expr *expr, const struct datatype *dtype);
 extern void datatype_free(const struct datatype *dtype);
 
 extern struct error_record *symbol_parse(const struct expr *sym,
diff --git a/src/datatype.c b/src/datatype.c
index 2aabddbdd0ec..74df89c3219f 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1088,6 +1088,13 @@ struct datatype *datatype_get(const struct datatype *ptr)
 	return dtype;
 }
 
+void datatype_set(struct expr *expr, const struct datatype *dtype)
+{
+	expr->dtype = dtype;
+	if (dtype)
+		datatype_get(dtype);
+}
+
 static struct datatype *dtype_clone(const struct datatype *orig_dtype)
 {
 	struct datatype *dtype;
diff --git a/src/evaluate.c b/src/evaluate.c
index 904e65718ed5..3ba770e898fd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -229,7 +229,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 
 	switch ((*expr)->symtype) {
 	case SYMBOL_VALUE:
-		(*expr)->dtype = datatype_get(ctx->ectx.dtype);
+		datatype_set(*expr, ctx->ectx.dtype);
 		erec = symbol_parse(*expr, &new);
 		if (erec != NULL) {
 			erec_queue(erec, ctx->msgs);
@@ -312,7 +312,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 
 	prefix = prefix_expr_alloc(&expr->location, value,
 				   datalen * BITS_PER_BYTE);
-	prefix->dtype = datatype_get(ctx->ectx.dtype);
+	datatype_set(prefix, ctx->ectx.dtype);
 	prefix->flags |= EXPR_F_CONSTANT;
 	prefix->byteorder = BYTEORDER_HOST_ENDIAN;
 
@@ -489,7 +489,7 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 	struct expr *expr = *exprp;
 
 	if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
-		expr->dtype = &boolean_type;
+		datatype_set(expr, &boolean_type);
 
 	if (expr_evaluate_primary(ctx, exprp) < 0)
 		return -1;
@@ -915,7 +915,7 @@ static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
 		return expr_error(ctx->msgs, range,
 				  "Range has zero or negative size");
 
-	range->dtype = datatype_get(left->dtype);
+	datatype_set(range, left->dtype);
 	range->flags |= EXPR_F_CONSTANT;
 	return 0;
 }
@@ -1239,7 +1239,7 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 		}
 	}
 
-	elem->dtype = datatype_get(elem->key->dtype);
+	datatype_set(elem, elem->key->dtype);
 	elem->len   = elem->key->len;
 	elem->flags = elem->key->flags;
 	return 0;
@@ -1285,7 +1285,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 
 	set->set_flags |= NFT_SET_CONSTANT;
 
-	set->dtype = datatype_get(ctx->ectx.dtype);
+	datatype_set(set, ctx->ectx.dtype);
 	set->len   = ctx->ectx.len;
 	set->flags |= EXPR_F_CONSTANT;
 	return 0;
@@ -1356,7 +1356,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 					 map->mappings->set->key->dtype->desc,
 					 map->map->dtype->desc);
 
-	map->dtype = datatype_get(map->mappings->set->datatype);
+	datatype_set(map, map->mappings->set->datatype);
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
@@ -1413,7 +1413,7 @@ static void expr_dtype_integer_compatible(struct eval_ctx *ctx,
 	if (ctx->ectx.dtype &&
 	    ctx->ectx.dtype->basetype == &integer_type &&
 	    ctx->ectx.len == 4 * BITS_PER_BYTE) {
-		expr->dtype = datatype_get(ctx->ectx.dtype);
+		datatype_set(expr, ctx->ectx.dtype);
 		expr->len   = ctx->ectx.len;
 	}
 }
@@ -1554,7 +1554,7 @@ static void binop_transfer_handle_lhs(struct expr **expr)
 	case OP_LSHIFT:
 	case OP_XOR:
 		tmp = expr_get(left->left);
-		tmp->dtype = datatype_get(left->dtype);
+		datatype_set(tmp, left->dtype);
 		expr_free(left);
 		*expr = tmp;
 		break;
@@ -1745,7 +1745,7 @@ static int expr_evaluate_fib(struct eval_ctx *ctx, struct expr **exprp)
 
 	if (expr->flags & EXPR_F_BOOLEAN) {
 		expr->fib.flags |= NFTA_FIB_F_PRESENT;
-		expr->dtype = &boolean_type;
+		datatype_set(expr, &boolean_type);
 	}
 	return expr_evaluate_primary(ctx, exprp);
 }
@@ -2965,7 +2965,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 					 map->mappings->set->key->dtype->desc,
 					 map->map->dtype->desc);
 
-	map->dtype = datatype_get(map->mappings->set->datatype);
+	datatype_set(map, map->mappings->set->datatype);
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
diff --git a/src/expression.c b/src/expression.c
index d1cfb24681d9..f2fde72bf8a5 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -937,7 +937,7 @@ struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 		return set_expr;
 
 	set_expr->set_flags = set->flags;
-	set_expr->dtype = datatype_get(set->key->dtype);
+	datatype_set(set_expr, set->key->dtype);
 
 	return set_expr;
 }
-- 
2.11.0

