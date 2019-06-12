Return-Path: <SRS0=I0Q5=UL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C44C31E46
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F85E20B7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfFLSN7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 14:13:59 -0400
Received: from mail.us.es ([193.147.175.20]:39134 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfFLSN7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 14:13:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1F7DFB60C1
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 20:13:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09671DA704
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 20:13:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F3136DA707; Wed, 12 Jun 2019 20:13:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B2EADA703
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 20:13:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 12 Jun 2019 20:13:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.99])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1AD064265A2F
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2019 20:13:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/2 nft,v4] src: add reference counter for dynamic datatypes
Date:   Wed, 12 Jun 2019 20:13:39 +0200
Message-Id: <20190612181340.31166-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are two datatypes are using runtime datatype allocation:

* Concatenations.
* Integer, that require byteorder adjustment.

From the evaluation / postprocess step, transformations are common,
hence expressions may end up fetching (infering) datatypes from an
existing one.

This patch adds a reference counter to release the dynamic datatype
object when it is shared.

The API includes the following helper functions:

* datatype_set(expr, datatype), to assign a datatype to an expression.
  This helper already deals with reference counting for dynamic
  datatypes. This also drops the reference counter of any previous
  datatype (to deal with the datatype replacement case).

* datatype_get(datatype) bumps the reference counter. This function also
  deals with nul-pointers, that occurs when the datatype is unset.

* datatype_free() drops the reference counter, and it also releases the
  datatype if there are not more clients of it.

Rule of thumb is: The reference counter of any newly allocated datatype
is set to zero.

This patch also updates every spot to use datatype_set() for non-dynamic
datatypes, for consistency. In this case, the helper just makes an
simple assignment.

Note that expr_alloc() has been updated to call datatype_get() on the
datatype that is assigned to this new expression. Moreover, expr_free()
calls datatype_free().

This fixes valgrind reports like this one:

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

This patch also removes the DTYPE_F_CLONE flag which is broken and not
needed anymore since proper reference counting is in place.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: - merge datatype: add datatype_set() to this patch.
    - do not set refcnt = 1 for dtype_clone() and dtype_alloc(),
      do this from datatype_set().
    - use datatype_set() everywhere.
    - drop reference to previous datatype, in case of replacing datatype.

 include/datatype.h        |  7 +++++--
 include/expression.h      |  2 +-
 src/ct.c                  |  6 +++---
 src/datatype.c            | 45 +++++++++++++++++++++++++++++++++++----------
 src/evaluate.c            | 37 +++++++++++++++++++------------------
 src/expression.c          | 13 +++++++------
 src/exthdr.c              |  4 ++--
 src/netlink.c             |  7 ++++---
 src/netlink_delinearize.c | 20 ++++++++++----------
 src/parser_bison.y        |  6 +++---
 src/parser_json.c         |  3 +--
 src/rt.c                  |  4 ++--
 src/rule.c                |  2 +-
 src/tcpopt.c              |  4 ++--
 14 files changed, 95 insertions(+), 65 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 14ece282902c..23f45ab7d6eb 100644
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
@@ -158,10 +157,14 @@ struct datatype {
 	struct error_record		*(*parse)(const struct expr *sym,
 						  struct expr **res);
 	const struct symbol_table	*sym_tbl;
+	unsigned int			refcnt;
 };
 
 extern const struct datatype *datatype_lookup(enum datatypes type);
 extern const struct datatype *datatype_lookup_byname(const char *name);
+extern struct datatype *datatype_get(const struct datatype *dtype);
+extern void datatype_set(struct expr *expr, const struct datatype *dtype);
+extern void datatype_free(const struct datatype *dtype);
 
 extern struct error_record *symbol_parse(const struct expr *sym,
 					 struct expr **res);
diff --git a/include/expression.h b/include/expression.h
index ef4125549214..4de53682754b 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -415,7 +415,7 @@ static inline void symbol_expr_set_type(struct expr *expr,
 					const struct datatype *dtype)
 {
 	if (expr->etype == EXPR_SYMBOL)
-		expr->dtype = dtype;
+		datatype_set(expr, dtype);
 }
 
 struct expr *variable_expr_alloc(const struct location *loc,
diff --git a/src/ct.c b/src/ct.c
index 2256ce322291..72346cd54338 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -413,10 +413,10 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
 		if (desc == &proto_ip) {
-			expr->dtype = &ipaddr_type;
+			datatype_set(expr, &ipaddr_type);
 			expr->ct.nfproto = NFPROTO_IPV4;
 		} else if (desc == &proto_ip6) {
-			expr->dtype = &ip6addr_type;
+			datatype_set(expr, &ip6addr_type);
 			expr->ct.nfproto = NFPROTO_IPV6;
 		}
 
@@ -426,7 +426,7 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 	case NFT_CT_PROTO_DST:
 		if (desc == NULL)
 			break;
-		expr->dtype = &inet_service_type;
+		datatype_set(expr, &inet_service_type);
 		break;
 	default:
 		break;
diff --git a/src/datatype.c b/src/datatype.c
index 1d5ed6f798de..c04fc0c6badf 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1076,6 +1076,25 @@ static struct datatype *dtype_alloc(void)
 	return dtype;
 }
 
+struct datatype *datatype_get(const struct datatype *ptr)
+{
+	struct datatype *dtype = (struct datatype *)ptr;
+
+	if (!dtype)
+		return NULL;
+	if (!(dtype->flags & DTYPE_F_ALLOC))
+		return dtype;
+
+	dtype->refcnt++;
+	return dtype;
+}
+
+void datatype_set(struct expr *expr, const struct datatype *dtype)
+{
+	datatype_free(expr->dtype);
+	expr->dtype = datatype_get(dtype);
+}
+
 static struct datatype *dtype_clone(const struct datatype *orig_dtype)
 {
 	struct datatype *dtype;
@@ -1084,18 +1103,25 @@ static struct datatype *dtype_clone(const struct datatype *orig_dtype)
 	*dtype = *orig_dtype;
 	dtype->name = xstrdup(orig_dtype->name);
 	dtype->desc = xstrdup(orig_dtype->desc);
-	dtype->flags = DTYPE_F_ALLOC | DTYPE_F_CLONE;
+	dtype->flags = DTYPE_F_ALLOC;
 
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
@@ -1137,7 +1163,7 @@ const struct datatype *concat_type_alloc(uint32_t type)
 
 void concat_type_destroy(const struct datatype *dtype)
 {
-	dtype_free(dtype);
+	datatype_free(dtype);
 }
 
 const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
@@ -1157,8 +1183,7 @@ const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
 
 void set_datatype_destroy(const struct datatype *dtype)
 {
-	if (dtype && dtype->flags & DTYPE_F_CLONE)
-		dtype_free(dtype);
+	datatype_free(dtype);
 }
 
 static struct error_record *time_unit_parse(const struct location *loc,
diff --git a/src/evaluate.c b/src/evaluate.c
index 39101b486b2f..4a06c7e8f673 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -70,7 +70,7 @@ static void key_fix_dtype_byteorder(struct expr *key)
 	if (dtype->byteorder == key->byteorder)
 		return;
 
-	key->dtype = set_datatype_alloc(dtype, key->byteorder);
+	datatype_set(key, set_datatype_alloc(dtype, key->byteorder));
 	if (dtype->flags & DTYPE_F_ALLOC)
 		concat_type_destroy(dtype);
 }
@@ -229,7 +229,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 
 	switch ((*expr)->symtype) {
 	case SYMBOL_VALUE:
-		(*expr)->dtype = ctx->ectx.dtype;
+		datatype_set(*expr, ctx->ectx.dtype);
 		erec = symbol_parse(*expr, &new);
 		if (erec != NULL) {
 			erec_queue(erec, ctx->msgs);
@@ -312,7 +312,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 
 	prefix = prefix_expr_alloc(&expr->location, value,
 				   datalen * BITS_PER_BYTE);
-	prefix->dtype = ctx->ectx.dtype;
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
 
-	range->dtype = left->dtype;
+	datatype_set(range, left->dtype);
 	range->flags |= EXPR_F_CONSTANT;
 	return 0;
 }
@@ -1172,7 +1172,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr,
 	}
 
 	(*expr)->flags |= flags;
-	(*expr)->dtype = concat_type_alloc(ntype);
+	datatype_set(*expr, concat_type_alloc(ntype));
 	(*expr)->len   = (*expr)->dtype->size;
 
 	if (off > 0)
@@ -1239,7 +1239,7 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 		}
 	}
 
-	elem->dtype = elem->key->dtype;
+	datatype_set(elem, elem->key->dtype);
 	elem->len   = elem->key->len;
 	elem->flags = elem->key->flags;
 	return 0;
@@ -1285,7 +1285,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 
 	set->set_flags |= NFT_SET_CONSTANT;
 
-	set->dtype = ctx->ectx.dtype;
+	datatype_set(set, ctx->ectx.dtype);
 	set->len   = ctx->ectx.len;
 	set->flags |= EXPR_F_CONSTANT;
 	return 0;
@@ -1311,15 +1311,16 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	switch (map->mappings->etype) {
 	case EXPR_SET:
 		key = constant_expr_alloc(&map->location,
-				 ctx->ectx.dtype,
-				 ctx->ectx.byteorder,
-				 ctx->ectx.len, NULL);
+					  ctx->ectx.dtype,
+					  ctx->ectx.byteorder,
+					  ctx->ectx.len, NULL);
 
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    key,
 						    mappings);
-		mappings->set->datatype = set_datatype_alloc(ectx.dtype,
-							     ectx.byteorder);
+		mappings->set->datatype =
+			datatype_get(set_datatype_alloc(ectx.dtype,
+							ectx.byteorder));
 		mappings->set->datalen  = ectx.len;
 
 		map->mappings = mappings;
@@ -1356,7 +1357,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 					 map->mappings->set->key->dtype->desc,
 					 map->map->dtype->desc);
 
-	map->dtype = map->mappings->set->datatype;
+	datatype_set(map, map->mappings->set->datatype);
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
@@ -1413,7 +1414,7 @@ static void expr_dtype_integer_compatible(struct eval_ctx *ctx,
 	if (ctx->ectx.dtype &&
 	    ctx->ectx.dtype->basetype == &integer_type &&
 	    ctx->ectx.len == 4 * BITS_PER_BYTE) {
-		expr->dtype = ctx->ectx.dtype;
+		datatype_set(expr, ctx->ectx.dtype);
 		expr->len   = ctx->ectx.len;
 	}
 }
@@ -1554,7 +1555,7 @@ static void binop_transfer_handle_lhs(struct expr **expr)
 	case OP_LSHIFT:
 	case OP_XOR:
 		tmp = expr_get(left->left);
-		tmp->dtype = left->dtype;
+		datatype_set(tmp, left->dtype);
 		expr_free(left);
 		*expr = tmp;
 		break;
@@ -1745,7 +1746,7 @@ static int expr_evaluate_fib(struct eval_ctx *ctx, struct expr **exprp)
 
 	if (expr->flags & EXPR_F_BOOLEAN) {
 		expr->fib.flags |= NFTA_FIB_F_PRESENT;
-		expr->dtype = &boolean_type;
+		datatype_set(expr, &boolean_type);
 	}
 	return expr_evaluate_primary(ctx, exprp);
 }
@@ -2965,7 +2966,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 					 map->mappings->set->key->dtype->desc,
 					 map->map->dtype->desc);
 
-	map->dtype = map->mappings->set->datatype;
+	datatype_set(map, map->mappings->set->datatype);
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
diff --git a/src/expression.c b/src/expression.c
index ef694f2a194d..5d0b4f82cae4 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -44,7 +44,7 @@ struct expr *expr_alloc(const struct location *loc, enum expr_types etype,
 
 	expr = xzalloc(sizeof(*expr));
 	expr->location  = *loc;
-	expr->dtype	= dtype;
+	expr->dtype	= datatype_get(dtype);
 	expr->etype	= etype;
 	expr->byteorder	= byteorder;
 	expr->len	= len;
@@ -57,8 +57,8 @@ struct expr *expr_clone(const struct expr *expr)
 {
 	struct expr *new;
 
-	new = expr_alloc(&expr->location, expr->etype, expr->dtype,
-			 expr->byteorder, expr->len);
+	new = expr_alloc(&expr->location, expr->etype,
+			 expr->dtype, expr->byteorder, expr->len);
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
@@ -165,7 +167,7 @@ void expr_set_type(struct expr *expr, const struct datatype *dtype,
 	if (ops->set_type)
 		ops->set_type(expr, dtype, byteorder);
 	else {
-		expr->dtype	= dtype;
+		datatype_set(expr, dtype);
 		expr->byteorder	= byteorder;
 	}
 }
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
+	datatype_set(set_expr, set->key->dtype);
 
 	return set_expr;
 }
diff --git a/src/exthdr.c b/src/exthdr.c
index 0cd031980073..c9c2bf503508 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -206,9 +206,9 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
  out:
 	expr->exthdr.tmpl = tmpl;
 	if (flags & NFT_EXTHDR_F_PRESENT)
-		expr->dtype = &boolean_type;
+		datatype_set(expr, &boolean_type);
 	else
-		expr->dtype = tmpl->dtype;
+		datatype_set(expr, tmpl->dtype);
 }
 
 static unsigned int mask_length(const struct expr *mask)
diff --git a/src/netlink.c b/src/netlink.c
index 7a4312498ce8..a6d81b4f6424 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -617,7 +617,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->objtype = objtype;
 
 	if (datatype)
-		set->datatype = set_datatype_alloc(datatype, databyteorder);
+		set->datatype = datatype_get(set_datatype_alloc(datatype,
+								databyteorder));
 	else
 		set->datatype = NULL;
 
@@ -767,7 +768,7 @@ int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		flags = nftnl_set_elem_get_u32(nlse, NFTNL_SET_ELEM_FLAGS);
 
 	key = netlink_alloc_value(&netlink_location, &nld);
-	key->dtype	= set->key->dtype;
+	datatype_set(key, set->key->dtype);
 	key->byteorder	= set->key->byteorder;
 	if (set->key->dtype->subtypes)
 		key = netlink_parse_concat_elem(set->key->dtype, key);
@@ -811,7 +812,7 @@ int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		data = netlink_alloc_data(&netlink_location, &nld,
 					  set->datatype->type == TYPE_VERDICT ?
 					  NFT_REG_VERDICT : NFT_REG_1);
-		data->dtype = set->datatype;
+		datatype_set(data, set->datatype);
 		data->byteorder = set->datatype->byteorder;
 		if (data->byteorder == BYTEORDER_HOST_ENDIAN)
 			mpz_switch_byteorder(data->value, data->len / BITS_PER_BYTE);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 0270e1fd7067..6576687ce627 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1389,7 +1389,7 @@ static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
 		nld.value = nftnl_expr_get(nle, NFTNL_EXPR_OBJREF_IMM_NAME,
 					   &nld.len);
 		expr = netlink_alloc_value(&netlink_location, &nld);
-		expr->dtype = &string_type;
+		datatype_set(expr, &string_type);
 		expr->byteorder = BYTEORDER_HOST_ENDIAN;
 	} else if (nftnl_expr_is_set(nle, NFTNL_EXPR_OBJREF_SET_SREG)) {
 		struct expr *left, *right;
@@ -2064,7 +2064,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 
 			ntype = concat_subtype_add(ntype, i->dtype->type);
 		}
-		expr->dtype = concat_type_alloc(ntype);
+		datatype_set(expr, concat_type_alloc(ntype));
 		break;
 	}
 	case EXPR_UNARY:
@@ -2165,7 +2165,7 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 	switch (rctx->pctx.family) {
 	case NFPROTO_IPV4:
 		stmt->reject.family = rctx->pctx.family;
-		stmt->reject.expr->dtype = &icmp_code_type;
+		datatype_set(stmt->reject.expr, &icmp_code_type);
 		if (stmt->reject.type == NFT_REJECT_TCP_RST &&
 		    payload_dependency_exists(&rctx->pdctx,
 					      PROTO_BASE_TRANSPORT_HDR))
@@ -2173,7 +2173,7 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		break;
 	case NFPROTO_IPV6:
 		stmt->reject.family = rctx->pctx.family;
-		stmt->reject.expr->dtype = &icmpv6_code_type;
+		datatype_set(stmt->reject.expr, &icmpv6_code_type);
 		if (stmt->reject.type == NFT_REJECT_TCP_RST &&
 		    payload_dependency_exists(&rctx->pdctx,
 					      PROTO_BASE_TRANSPORT_HDR))
@@ -2181,7 +2181,7 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		break;
 	case NFPROTO_INET:
 		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH) {
-			stmt->reject.expr->dtype = &icmpx_code_type;
+			datatype_set(stmt->reject.expr, &icmpx_code_type);
 			break;
 		}
 		base = rctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
@@ -2189,17 +2189,17 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case NFPROTO_IPV4:
-			stmt->reject.expr->dtype = &icmp_code_type;
+			datatype_set(stmt->reject.expr, &icmp_code_type);
 			break;
 		case NFPROTO_IPV6:
-			stmt->reject.expr->dtype = &icmpv6_code_type;
+			datatype_set(stmt->reject.expr, &icmpv6_code_type);
 			break;
 		}
 		stmt->reject.family = protocol;
 		break;
 	case NFPROTO_BRIDGE:
 		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH) {
-			stmt->reject.expr->dtype = &icmpx_code_type;
+			datatype_set(stmt->reject.expr, &icmpx_code_type);
 			break;
 		}
 		base = rctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
@@ -2208,11 +2208,11 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		switch (protocol) {
 		case __constant_htons(ETH_P_IP):
 			stmt->reject.family = NFPROTO_IPV4;
-			stmt->reject.expr->dtype = &icmp_code_type;
+			datatype_set(stmt->reject.expr, &icmp_code_type);
 			break;
 		case __constant_htons(ETH_P_IPV6):
 			stmt->reject.family = NFPROTO_IPV6;
-			stmt->reject.expr->dtype = &icmpv6_code_type;
+			datatype_set(stmt->reject.expr, &icmpv6_code_type);
 			break;
 		default:
 			break;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 97a48f38af0c..1c0b60cf40fd 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2598,7 +2598,7 @@ reject_opts		:       /* empty */
 					symbol_expr_alloc(&@$, SYMBOL_VALUE,
 							  current_scope(state),
 							  $4);
-				$<stmt>0->reject.expr->dtype = &icmp_code_type;
+				datatype_set($<stmt>0->reject.expr, &icmp_code_type);
 				xfree($4);
 			}
 			|	WITH	ICMP6	TYPE	STRING
@@ -2609,7 +2609,7 @@ reject_opts		:       /* empty */
 					symbol_expr_alloc(&@$, SYMBOL_VALUE,
 							  current_scope(state),
 							  $4);
-				$<stmt>0->reject.expr->dtype = &icmpv6_code_type;
+				datatype_set($<stmt>0->reject.expr, &icmpv6_code_type);
 				xfree($4);
 			}
 			|	WITH	ICMPX	TYPE	STRING
@@ -2619,7 +2619,7 @@ reject_opts		:       /* empty */
 					symbol_expr_alloc(&@$, SYMBOL_VALUE,
 							  current_scope(state),
 							  $4);
-				$<stmt>0->reject.expr->dtype = &icmpx_code_type;
+				datatype_set($<stmt>0->reject.expr, &icmpx_code_type);
 				xfree($4);
 			}
 			|	WITH	TCP	RESET
diff --git a/src/parser_json.c b/src/parser_json.c
index ac110f16fe81..af7701fcc240 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1966,8 +1966,7 @@ static struct stmt *json_parse_reject_stmt(struct json_ctx *ctx,
 			stmt_free(stmt);
 			return NULL;
 		}
-		if (dtype)
-			stmt->reject.expr->dtype = dtype;
+		datatype_set(stmt->reject.expr, dtype);
 	}
 	return stmt;
 }
diff --git a/src/rt.c b/src/rt.c
index 090831fe42a9..3ad77bcdda4d 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -148,10 +148,10 @@ void rt_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 	case NFT_RT_NEXTHOP4:
 		desc = ctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 		if (desc == &proto_ip)
-			expr->dtype = &ipaddr_type;
+			datatype_set(expr, &ipaddr_type);
 		else if (desc == &proto_ip6) {
 			expr->rt.key++;
-			expr->dtype = &ip6addr_type;
+			datatype_set(expr, &ip6addr_type);
 		}
 		expr->len = expr->dtype->size;
 		break;
diff --git a/src/rule.c b/src/rule.c
index ad549b1eee8a..7eb89a00b85b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -341,7 +341,7 @@ struct set *set_clone(const struct set *set)
 	new_set->gc_int		= set->gc_int;
 	new_set->timeout	= set->timeout;
 	new_set->key		= expr_clone(set->key);
-	new_set->datatype	= set->datatype;
+	new_set->datatype	= datatype_get(set->datatype);
 	new_set->datalen	= set->datalen;
 	new_set->objtype	= set->objtype;
 	new_set->policy		= set->policy;
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 6920ff945590..ec305d9466d5 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -218,9 +218,9 @@ void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
 			continue;
 
 		if (flags & NFT_EXTHDR_F_PRESENT)
-			expr->dtype = &boolean_type;
+			datatype_set(expr, &boolean_type);
 		else
-			expr->dtype = tmpl->dtype;
+			datatype_set(expr, tmpl->dtype);
 		expr->exthdr.tmpl = tmpl;
 		expr->exthdr.op   = NFT_EXTHDR_OP_TCPOPT;
 		break;
-- 
2.11.0


