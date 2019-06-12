Return-Path: <SRS0=I0Q5=UL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D1FC31E47
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 12:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C29D20874
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 12:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbfFLMXi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:23:38 -0400
Received: from mail.us.es ([193.147.175.20]:42410 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbfFLMXi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 08:23:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6FDC0154E85
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 14:23:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E6ABDA705
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 14:23:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53E9FDA706; Wed, 12 Jun 2019 14:23:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3D6DDA705
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 14:23:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 12 Jun 2019 14:23:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CDD304265A2F
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 14:23:30 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3,v3] src: add reference counter for dynamic datatypes
Date:   Wed, 12 Jun 2019 14:23:26 +0200
Message-Id: <20190612122328.3889-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Two datatypes are using runtime datatype allocation:

* Concatenations.
* Integer, that require byteorder adjustment.

Add a reference counter to release the dynamic datatype object when it
is shared, which occurs from the following paths:

* netlink_delinearize_setelem(), when elements refer to the datatype of
  an existing set in the cache.
* set_expr_alloc(), for implicit set/maps and update statement from the
  packet path.
* set_ref_expr_alloc(), for set and map references via @.
* expr_evaluate_set_elem(), when elements are added and they refer to
  the set datatype, ie. add element command.

valgrind reports memleaks like this one:

==28352== 1,350 (440 direct, 910 indirect) bytes in 5 blocks are definitely lost in loss recor 3 of 3
==28352==    at 0x4C2BBAF: malloc (vg_replace_malloc.c:299)
==28352==    by 0x4E79558: xmalloc (utils.c:36)
==28352==    by 0x4E7963D: xzalloc (utils.c:65)
==28352==    by 0x4E6029B: dtype_alloc (datatype.c:1073)
==28352==    by 0x4E6029B: concat_type_alloc (datatype.c:1127)
==28352==    by 0x4E6D3B3: netlink_delinearize_set (netlink.c:578)
==28352==    by 0x4E6D68E: list_set_cb (netlink.c:648)
==28352==    by 0x5D74023: nftnl_set_list_foreach (set.c:780)
==28352==    by 0x4E6D6F3: netlink_list_sets (netlink.c:669)
==28352==    by 0x4E5A7A3: cache_init_objects (rule.c:159)
==28352==    by 0x4E5A7A3: cache_init (rule.c:216)
==28352==    by 0x4E5A7A3: cache_update (rule.c:266)
==28352==    by 0x4E7E0EE: nft_evaluate (libnftables.c:388)
==28352==    by 0x4E7EADD: nft_run_cmd_from_filename (libnftables.c:479)
==28352==    by 0x109A53: main (main.c:310)

Remove DTYPE_F_CLONE flag, which is replaced by proper reference
counter.  Call datatype_free() from expr_free() path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: deal with dynamic integer datatype allocations.

 include/datatype.h |  6 ++++--
 src/datatype.c     | 42 +++++++++++++++++++++++++++++++-----------
 src/evaluate.c     | 24 ++++++++++++------------
 src/expression.c   | 11 ++++++-----
 src/netlink.c      |  2 +-
 src/segtree.c      |  9 +++++----
 6 files changed, 59 insertions(+), 35 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 14ece282902c..5765c1ba7502 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -117,12 +117,10 @@ struct expr;
  *
  * @DTYPE_F_ALLOC:		datatype is dynamically allocated
  * @DTYPE_F_PREFIX:		preferred representation for ranges is a prefix
- * @DTYPE_F_CLONE:		this is an instance from original datatype
  */
 enum datatype_flags {
 	DTYPE_F_ALLOC		= (1 << 0),
 	DTYPE_F_PREFIX		= (1 << 1),
-	DTYPE_F_CLONE		= (1 << 2),
 };
 
 /**
@@ -140,6 +138,7 @@ enum datatype_flags {
  * @print:	function to print a constant of this type
  * @parse:	function to parse a symbol and return an expression
  * @sym_tbl:	symbol table for this type
+ * @refcnt:	reference counter (only for DTYPE_F_ALLOC)
  */
 struct datatype {
 	uint32_t			type;
@@ -158,10 +157,13 @@ struct datatype {
 	struct error_record		*(*parse)(const struct expr *sym,
 						  struct expr **res);
 	const struct symbol_table	*sym_tbl;
+	unsigned int			refcnt;
 };
 
 extern const struct datatype *datatype_lookup(enum datatypes type);
 extern const struct datatype *datatype_lookup_byname(const char *name);
+extern struct datatype *datatype_get(const struct datatype *dtype);
+extern void datatype_free(const struct datatype *dtype);
 
 extern struct error_record *symbol_parse(const struct expr *sym,
 					 struct expr **res);
diff --git a/src/datatype.c b/src/datatype.c
index 1d5ed6f798de..2aabddbdd0ec 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1072,10 +1072,22 @@ static struct datatype *dtype_alloc(void)
 
 	dtype = xzalloc(sizeof(*dtype));
 	dtype->flags = DTYPE_F_ALLOC;
+	dtype->refcnt = 1;
 
 	return dtype;
 }
 
+struct datatype *datatype_get(const struct datatype *ptr)
+{
+	struct datatype *dtype = (struct datatype *)ptr;
+
+	if (!(dtype->flags & DTYPE_F_ALLOC))
+		return dtype;
+
+	dtype->refcnt++;
+	return dtype;
+}
+
 static struct datatype *dtype_clone(const struct datatype *orig_dtype)
 {
 	struct datatype *dtype;
@@ -1084,18 +1096,26 @@ static struct datatype *dtype_clone(const struct datatype *orig_dtype)
 	*dtype = *orig_dtype;
 	dtype->name = xstrdup(orig_dtype->name);
 	dtype->desc = xstrdup(orig_dtype->desc);
-	dtype->flags = DTYPE_F_ALLOC | DTYPE_F_CLONE;
+	dtype->flags = DTYPE_F_ALLOC;
+	dtype->refcnt = 1;
 
 	return dtype;
 }
 
-static void dtype_free(const struct datatype *dtype)
+void datatype_free(const struct datatype *ptr)
 {
-	if (dtype->flags & DTYPE_F_ALLOC) {
-		xfree(dtype->name);
-		xfree(dtype->desc);
-		xfree(dtype);
-	}
+	struct datatype *dtype = (struct datatype *)ptr;
+
+	if (!dtype)
+		return;
+	if (!(dtype->flags & DTYPE_F_ALLOC))
+		return;
+	if (--dtype->refcnt > 0)
+		return;
+
+	xfree(dtype->name);
+	xfree(dtype->desc);
+	xfree(dtype);
 }
 
 const struct datatype *concat_type_alloc(uint32_t type)
@@ -1137,7 +1157,7 @@ const struct datatype *concat_type_alloc(uint32_t type)
 
 void concat_type_destroy(const struct datatype *dtype)
 {
-	dtype_free(dtype);
+	datatype_free(dtype);
 }
 
 const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
@@ -1152,13 +1172,13 @@ const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
 	dtype = dtype_clone(orig_dtype);
 	dtype->byteorder = byteorder;
 
-	return dtype;
+	return datatype_get(dtype);
 }
 
 void set_datatype_destroy(const struct datatype *dtype)
 {
-	if (dtype && dtype->flags & DTYPE_F_CLONE)
-		dtype_free(dtype);
+	if (dtype)
+		datatype_free(dtype);
 }
 
 static struct error_record *time_unit_parse(const struct location *loc,
diff --git a/src/evaluate.c b/src/evaluate.c
index 39101b486b2f..904e65718ed5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -229,7 +229,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 
 	switch ((*expr)->symtype) {
 	case SYMBOL_VALUE:
-		(*expr)->dtype = ctx->ectx.dtype;
+		(*expr)->dtype = datatype_get(ctx->ectx.dtype);
 		erec = symbol_parse(*expr, &new);
 		if (erec != NULL) {
 			erec_queue(erec, ctx->msgs);
@@ -312,7 +312,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 
 	prefix = prefix_expr_alloc(&expr->location, value,
 				   datalen * BITS_PER_BYTE);
-	prefix->dtype = ctx->ectx.dtype;
+	prefix->dtype = datatype_get(ctx->ectx.dtype);
 	prefix->flags |= EXPR_F_CONSTANT;
 	prefix->byteorder = BYTEORDER_HOST_ENDIAN;
 
@@ -915,7 +915,7 @@ static int expr_evaluate_range(struct eval_ctx *ctx, struct expr **expr)
 		return expr_error(ctx->msgs, range,
 				  "Range has zero or negative size");
 
-	range->dtype = left->dtype;
+	range->dtype = datatype_get(left->dtype);
 	range->flags |= EXPR_F_CONSTANT;
 	return 0;
 }
@@ -1239,7 +1239,7 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 		}
 	}
 
-	elem->dtype = elem->key->dtype;
+	elem->dtype = datatype_get(elem->key->dtype);
 	elem->len   = elem->key->len;
 	elem->flags = elem->key->flags;
 	return 0;
@@ -1285,7 +1285,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 
 	set->set_flags |= NFT_SET_CONSTANT;
 
-	set->dtype = ctx->ectx.dtype;
+	set->dtype = datatype_get(ctx->ectx.dtype);
 	set->len   = ctx->ectx.len;
 	set->flags |= EXPR_F_CONSTANT;
 	return 0;
@@ -1311,9 +1311,9 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	switch (map->mappings->etype) {
 	case EXPR_SET:
 		key = constant_expr_alloc(&map->location,
-				 ctx->ectx.dtype,
-				 ctx->ectx.byteorder,
-				 ctx->ectx.len, NULL);
+					  datatype_get(ctx->ectx.dtype),
+					  ctx->ectx.byteorder,
+					  ctx->ectx.len, NULL);
 
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    key,
@@ -1356,7 +1356,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 					 map->mappings->set->key->dtype->desc,
 					 map->map->dtype->desc);
 
-	map->dtype = map->mappings->set->datatype;
+	map->dtype = datatype_get(map->mappings->set->datatype);
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
@@ -1413,7 +1413,7 @@ static void expr_dtype_integer_compatible(struct eval_ctx *ctx,
 	if (ctx->ectx.dtype &&
 	    ctx->ectx.dtype->basetype == &integer_type &&
 	    ctx->ectx.len == 4 * BITS_PER_BYTE) {
-		expr->dtype = ctx->ectx.dtype;
+		expr->dtype = datatype_get(ctx->ectx.dtype);
 		expr->len   = ctx->ectx.len;
 	}
 }
@@ -1554,7 +1554,7 @@ static void binop_transfer_handle_lhs(struct expr **expr)
 	case OP_LSHIFT:
 	case OP_XOR:
 		tmp = expr_get(left->left);
-		tmp->dtype = left->dtype;
+		tmp->dtype = datatype_get(left->dtype);
 		expr_free(left);
 		*expr = tmp;
 		break;
@@ -2965,7 +2965,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 					 map->mappings->set->key->dtype->desc,
 					 map->map->dtype->desc);
 
-	map->dtype = map->mappings->set->datatype;
+	map->dtype = datatype_get(map->mappings->set->datatype);
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
diff --git a/src/expression.c b/src/expression.c
index ef694f2a194d..d1cfb24681d9 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -57,8 +57,8 @@ struct expr *expr_clone(const struct expr *expr)
 {
 	struct expr *new;
 
-	new = expr_alloc(&expr->location, expr->etype, expr->dtype,
-			 expr->byteorder, expr->len);
+	new = expr_alloc(&expr->location, expr->etype,
+			 datatype_get(expr->dtype), expr->byteorder, expr->len);
 	new->flags = expr->flags;
 	new->op    = expr->op;
 	expr_ops(expr)->clone(new, expr);
@@ -86,6 +86,8 @@ void expr_free(struct expr *expr)
 	if (--expr->refcnt > 0)
 		return;
 
+	datatype_free(expr->dtype);
+
 	/* EXPR_INVALID expressions lack ->ops structure.
 	 * This happens for compound types.
 	 */
@@ -803,7 +805,6 @@ void compound_expr_remove(struct expr *compound, struct expr *expr)
 
 static void concat_expr_destroy(struct expr *expr)
 {
-	concat_type_destroy(expr->dtype);
 	compound_expr_destroy(expr);
 }
 
@@ -936,7 +937,7 @@ struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 		return set_expr;
 
 	set_expr->set_flags = set->flags;
-	set_expr->dtype = set->key->dtype;
+	set_expr->dtype = datatype_get(set->key->dtype);
 
 	return set_expr;
 }
@@ -1067,7 +1068,7 @@ struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 {
 	struct expr *expr;
 
-	expr = expr_alloc(loc, EXPR_SET_REF, set->key->dtype, 0, 0);
+	expr = expr_alloc(loc, EXPR_SET_REF, datatype_get(set->key->dtype), 0, 0);
 	expr->set = set_get(set);
 	expr->flags |= EXPR_F_CONSTANT;
 	return expr;
diff --git a/src/netlink.c b/src/netlink.c
index 7a4312498ce8..c5567c0d29ca 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -767,7 +767,7 @@ int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		flags = nftnl_set_elem_get_u32(nlse, NFTNL_SET_ELEM_FLAGS);
 
 	key = netlink_alloc_value(&netlink_location, &nld);
-	key->dtype	= set->key->dtype;
+	key->dtype	= datatype_get(set->key->dtype);
 	key->byteorder	= set->key->byteorder;
 	if (set->key->dtype->subtypes)
 		key = netlink_parse_concat_elem(set->key->dtype, key);
diff --git a/src/segtree.c b/src/segtree.c
index a21270a08c46..082f2093068a 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -540,7 +540,8 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 {
 	struct expr *expr;
 
-	expr = constant_expr_alloc(&internal_location, tree->keytype,
+	expr = constant_expr_alloc(&internal_location,
+				   datatype_get(tree->keytype),
 				   tree->byteorder, tree->keylen, NULL);
 	mpz_set(expr->value, ei->left);
 	expr = set_elem_expr_alloc(&internal_location, expr);
@@ -606,7 +607,7 @@ static void set_elem_add(const struct set *set, struct expr *init, mpz_t value,
 {
 	struct expr *expr;
 
-	expr = constant_expr_alloc(&internal_location, set->key->dtype,
+	expr = constant_expr_alloc(&internal_location, datatype_get(set->key->dtype),
 				   set->key->byteorder, set->key->len, NULL);
 	mpz_set(expr->value, value);
 	expr = set_elem_expr_alloc(&internal_location, expr);
@@ -888,7 +889,7 @@ void interval_map_decompose(struct expr *set)
 			 mpz_cmp_ui(p, 0)) {
 			struct expr *tmp;
 
-			tmp = constant_expr_alloc(&low->location, low->dtype,
+			tmp = constant_expr_alloc(&low->location, datatype_get(low->dtype),
 						  low->byteorder, expr_value(low)->len,
 						  NULL);
 
@@ -964,7 +965,7 @@ void interval_map_decompose(struct expr *set)
 	if (!low) /* no unclosed interval at end */
 		goto out;
 
-	i = constant_expr_alloc(&low->location, low->dtype,
+	i = constant_expr_alloc(&low->location, datatype_get(low->dtype),
 				low->byteorder, expr_value(low)->len, NULL);
 	mpz_init_bitmask(i->value, i->len);
 
-- 
2.11.0

