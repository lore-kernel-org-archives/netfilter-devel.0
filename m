Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64674C0650F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DD37206E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbfG3Oiz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:38:55 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42932 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728532AbfG3Oiy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 10:38:54 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hsTH9-0004Wi-Fl; Tue, 30 Jul 2019 16:38:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] src: store expr, not dtype to track data in sets
Date:   Tue, 30 Jul 2019 16:37:31 +0200
Message-Id: <20190730143732.2126-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190730143732.2126-1-fw@strlen.de>
References: <20190730143732.2126-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This will be needed once we add support for the 'typeof' keyword to
handle maps that could e.g. store 'ct helper' "type" values.

Instead of:

set foo {
	type ipv4_addr . mark;

this would allow

set foo {
	typeof(ip saddr) . typeof(ct mark);

(exact syntax TBD).

This would be needed to allow sets that store variable-sized data types
(string, integer and the like) that can't be used at at the moment.

Adding special data types for everything is problematic due to the
large amount of different types needed.

For anonymous sets, e.g. "string" can be used because the needed size can
be inferred from the statement, e.g.  'osf name { "Windows", "Linux }',
but in case of named sets that won't work because 'type string' lacks the
context needed to derive the size information.

With 'typeof(osf name)' the context is there, but at the moment it won't
help because the expression is discarded instantly and only the data
type is retained.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/datatype.h   |   1 -
 include/netlink.h    |   1 -
 include/rule.h       |   6 +--
 src/datatype.c       |   5 --
 src/evaluate.c       | 111 ++++++++++++++++++++++++++++++++++++-------
 src/expression.c     |   2 +-
 src/json.c           |   4 +-
 src/mnl.c            |   6 +--
 src/monitor.c        |   2 +-
 src/netlink.c        |  40 ++++++++--------
 src/parser_bison.y   |   3 +-
 src/parser_json.c    |  50 ++++++++++++++++++-
 src/rule.c           |   7 ++-
 src/segtree.c        |   8 +++-
 tests/py/nft-test.py |   1 +
 15 files changed, 180 insertions(+), 67 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 63617ebd2753..9059cc0788b8 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -279,7 +279,6 @@ concat_subtype_lookup(uint32_t type, unsigned int n)
 
 extern const struct datatype *
 set_datatype_alloc(const struct datatype *orig_dtype, unsigned int byteorder);
-extern void set_datatype_destroy(const struct datatype *dtype);
 
 extern void time_print(uint64_t msec, struct output_ctx *octx);
 extern struct error_record *time_parse(const struct location *loc,
diff --git a/include/netlink.h b/include/netlink.h
index 279723f33d31..6aead9a8c5e2 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -190,6 +190,5 @@ int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
 			    struct netlink_mon_handler *monh);
 
 enum nft_data_types dtype_map_to_kernel(const struct datatype *dtype);
-const struct datatype *dtype_map_from_kernel(enum nft_data_types type);
 
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/rule.h b/include/rule.h
index ee881b9ccd17..dfb6b5482a1c 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -277,8 +277,7 @@ extern struct rule *rule_lookup_by_index(const struct chain *chain,
  * @gc_int:	garbage collection interval
  * @timeout:	default timeout value
  * @key:	key expression (data type, length))
- * @datatype:	mapping data type
- * @datalen:	mapping data len
+ * @data:	mapping data expression
  * @objtype:	mapping object type
  * @init:	initializer
  * @rg_cache:	cached range element (left)
@@ -295,8 +294,7 @@ struct set {
 	uint32_t		gc_int;
 	uint64_t		timeout;
 	struct expr		*key;
-	const struct datatype	*datatype;
-	unsigned int		datalen;
+	struct expr		*data;
 	uint32_t		objtype;
 	struct expr		*init;
 	struct expr		*rg_cache;
diff --git a/src/datatype.c b/src/datatype.c
index 6d6826e9d745..4942f83a736e 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1168,11 +1168,6 @@ const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
 	return dtype;
 }
 
-void set_datatype_destroy(const struct datatype *dtype)
-{
-	datatype_free(dtype);
-}
-
 static struct error_record *time_unit_parse(const struct location *loc,
 					    const char *str, uint64_t *unit)
 {
diff --git a/src/evaluate.c b/src/evaluate.c
index 48c65cd2f35a..6277f6545c1b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1332,6 +1332,63 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static struct expr *concat_expr_alloc_by_type_FIXME(uint32_t type)
+{
+	struct expr *concat_expr = concat_expr_alloc(&netlink_location);
+	unsigned int n;
+	int size = 0;
+
+	n = div_round_up(fls(type), TYPE_BITS);
+	while (n > 0 && concat_subtype_id(type, --n)) {
+		const struct datatype *i;
+		struct expr *expr;
+
+		i = concat_subtype_lookup(type, n);
+		if (i == NULL)
+			return NULL;
+
+		if (i->size == 0)
+			size = -1;
+		else if (size >= 0)
+			size += i->size;
+
+		expr = constant_expr_alloc(&netlink_location, i, i->byteorder,
+					   i->size, NULL);
+
+		compound_expr_add(concat_expr, expr);
+	}
+
+	/* can be incorrect in case of i->size being 0 (variable length). */
+	concat_expr->len = size > 0 ? size : 0;
+
+	return concat_expr;
+}
+
+static struct expr *
+data_expr_alloc_by_type_FIXME(enum nft_data_types type, enum byteorder keybyteorder)
+{
+	const struct datatype *dtype;
+
+	switch (type) {
+	case NFT_DATA_VERDICT:
+		return verdict_expr_alloc(&netlink_location, 0, NULL);
+	default:
+		if (type & ~TYPE_MASK)
+			return concat_expr_alloc_by_type_FIXME(type);
+
+		dtype = datatype_lookup(type);
+		if (!dtype)
+			return NULL;
+
+		if (dtype->byteorder != BYTEORDER_INVALID) {
+			assert(dtype->byteorder == keybyteorder);
+		}
+
+		return constant_expr_alloc(&netlink_location, dtype, keybyteorder,
+					   dtype->size, NULL);
+	}
+}
+
 static int binop_transfer(struct eval_ctx *ctx, struct expr **expr);
 static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
@@ -1359,10 +1416,14 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    key,
 						    mappings);
-		mappings->set->datatype =
-			datatype_get(set_datatype_alloc(ectx.dtype,
-							ectx.byteorder));
-		mappings->set->datalen  = ectx.len;
+
+
+		mappings->set->data = data_expr_alloc_by_type_FIXME(ectx.dtype->type, ectx.dtype->byteorder);
+		if (mappings->set->data->len == 0)
+			mappings->set->data->len = ectx.len;
+
+		if (ectx.len && mappings->set->data->len != ectx.len)
+			BUG("%d vs %d\n", mappings->set->data->len, ectx.len);
 
 		map->mappings = mappings;
 
@@ -1398,7 +1459,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 					 map->mappings->set->key->dtype->desc,
 					 map->map->dtype->desc);
 
-	datatype_set(map, map->mappings->set->datatype);
+	datatype_set(map, map->mappings->set->data->dtype);
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
@@ -1428,7 +1489,12 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 				  "Key must be a constant");
 	mapping->flags |= mapping->left->flags & EXPR_F_SINGLETON;
 
-	expr_set_context(&ctx->ectx, set->datatype, set->datalen);
+	if (set->data) {
+		expr_set_context(&ctx->ectx, set->data->dtype, set->data->len);
+	} else {
+		assert((set->flags & NFT_SET_MAP) == 0);
+	}
+
 	if (expr_evaluate(ctx, &mapping->right) < 0)
 		return -1;
 	if (!expr_is_constant(mapping->right))
@@ -1998,7 +2064,7 @@ static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 					 (*expr)->len);
 	else if ((*expr)->dtype->type != TYPE_INTEGER &&
 		 !datatype_equal((*expr)->dtype, dtype))
-		return stmt_binary_error(ctx, *expr, stmt,
+		return stmt_binary_error(ctx, *expr, stmt,		/* verdict vs invalid? */
 					 "datatype mismatch: expected %s, "
 					 "expression has type %s",
 					 dtype->desc, (*expr)->dtype->desc);
@@ -2981,9 +3047,9 @@ static int stmt_evaluate_map(struct eval_ctx *ctx, struct stmt *stmt)
 				  "Key expression comments are not supported");
 
 	if (stmt_evaluate_arg(ctx, stmt,
-			      stmt->map.set->set->datatype,
-			      stmt->map.set->set->datalen,
-			      stmt->map.set->set->datatype->byteorder,
+			      stmt->map.set->set->data->dtype,
+			      stmt->map.set->set->data->len,
+			      stmt->map.set->set->data->dtype->byteorder,
 			      &stmt->map.data->key) < 0)
 		return -1;
 	if (expr_is_constant(stmt->map.data))
@@ -3029,8 +3095,15 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 
 		mappings = implicit_set_declaration(ctx, "__objmap%d",
 						    key, mappings);
-		mappings->set->datatype = &string_type;
-		mappings->set->datalen  = NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE;
+		if (mappings->set->data) {
+			assert( mappings->set_flags & NFT_SET_MAP);
+			// type = set->flags & NFT_SET_MAP ? "map" : "set";
+
+			mappings->set->data->dtype = &string_type;
+			mappings->set->data->len  = NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE;
+		} else {
+			assert((mappings->set_flags & NFT_SET_MAP) == 0);
+		}
 		mappings->set->objtype  = stmt->objref.type;
 
 		map->mappings = mappings;
@@ -3065,7 +3138,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 					 map->mappings->set->key->dtype->desc,
 					 map->map->dtype->desc);
 
-	datatype_set(map, map->mappings->set->datatype);
+	datatype_set(map, map->mappings->set->data->dtype);
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
@@ -3210,17 +3283,19 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		return set_error(ctx, set, "concatenated types not supported in interval sets");
 
 	if (set_is_datamap(set->flags)) {
-		if (set->datatype == NULL)
+		if (set->data == NULL)
 			return set_error(ctx, set, "map definition does not "
 					 "specify mapping data type");
 
-		set->datalen = set->datatype->size;
-		if (set->datalen == 0 && set->datatype->type != TYPE_VERDICT)
+		if (set->data->len == 0)
 			return set_error(ctx, set, "unqualified mapping data "
 					 "type specified in map definition");
 	} else if (set_is_objmap(set->flags)) {
-		set->datatype = &string_type;
-		set->datalen  = NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE;
+		assert(set->data->etype == EXPR_VALUE);
+		assert(set->data->dtype == &string_type);
+
+		set->data->dtype = &string_type;
+		set->data->len  = NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE;
 	}
 
 	ctx->set = set;
diff --git a/src/expression.c b/src/expression.c
index cb49e0b73f5a..09005c650ede 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -994,7 +994,7 @@ static void map_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	expr_print(expr->map, octx);
 	if (expr->mappings->etype == EXPR_SET_REF &&
-	    expr->mappings->set->datatype->type == TYPE_VERDICT)
+	    expr->mappings->set->data->dtype->type == TYPE_VERDICT)
 		nft_print(octx, " vmap ");
 	else
 		nft_print(octx, " map ");
diff --git a/src/json.c b/src/json.c
index 33e0ec15f2ee..04467e7645cb 100644
--- a/src/json.c
+++ b/src/json.c
@@ -82,7 +82,7 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 
 	if (set_is_datamap(set->flags)) {
 		type = "map";
-		datatype_ext = set->datatype->name;
+		datatype_ext = set->data->dtype->name;
 	} else if (set_is_objmap(set->flags)) {
 		type = "map";
 		datatype_ext = obj_type_name(set->objtype);
@@ -609,7 +609,7 @@ json_t *map_expr_json(const struct expr *expr, struct output_ctx *octx)
 	const char *type = "map";
 
 	if (expr->mappings->etype == EXPR_SET_REF &&
-	    expr->mappings->set->datatype->type == TYPE_VERDICT)
+	    expr->mappings->set->data->dtype->type == TYPE_VERDICT)
 		type = "vmap";
 
 	return json_pack("{s:{s:o, s:o}}", type,
diff --git a/src/mnl.c b/src/mnl.c
index eab8d5486437..2d3e910fda71 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -801,9 +801,9 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 			  div_round_up(set->key->len, BITS_PER_BYTE));
 	if (set_is_datamap(set->flags)) {
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_TYPE,
-				  dtype_map_to_kernel(set->datatype));
+				  dtype_map_to_kernel(set->data->dtype));
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_LEN,
-				  set->datalen / BITS_PER_BYTE);
+				  set->data->len / BITS_PER_BYTE);
 	}
 	if (set_is_objmap(set->flags))
 		nftnl_set_set_u32(nls, NFTNL_SET_OBJ_TYPE, set->objtype);
@@ -835,7 +835,7 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 
 	if (set_is_datamap(set->flags) &&
 	    !nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_DATABYTEORDER,
-				 set->datatype->byteorder))
+				 set->data->byteorder))
 		memory_allocation_error();
 
 	if (set->automerge &&
diff --git a/src/monitor.c b/src/monitor.c
index 40c381149cda..d90bbfd4d505 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -401,7 +401,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 	 */
 	dummyset = set_alloc(monh->loc);
 	dummyset->key = expr_clone(set->key);
-	dummyset->datatype = set->datatype;
+	dummyset->data = set->data;
 	dummyset->flags = set->flags;
 	dummyset->init = set_expr_alloc(monh->loc, set);
 
diff --git a/src/netlink.c b/src/netlink.c
index 14b0df410726..5d019b3011b0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -498,7 +498,7 @@ enum nft_data_types dtype_map_to_kernel(const struct datatype *dtype)
 	}
 }
 
-const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
+static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 {
 	switch (type) {
 	case NFT_DATA_VERDICT:
@@ -545,10 +545,10 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 				    const struct nftnl_set *nls)
 {
 	const struct nftnl_udata *ud[NFTNL_UDATA_SET_MAX + 1] = {};
-	uint32_t flags, key, data, data_len, objtype = 0;
 	enum byteorder keybyteorder = BYTEORDER_INVALID;
 	enum byteorder databyteorder = BYTEORDER_INVALID;
-	const struct datatype *keytype, *datatype;
+	const struct datatype *keytype, *datatype = NULL;
+	uint32_t flags, key, objtype = 0;
 	bool automerge = false;
 	const char *udata;
 	struct set *set;
@@ -582,6 +582,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 
 	flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 	if (set_is_datamap(flags)) {
+		uint32_t data;
+
 		data = nftnl_set_get_u32(nls, NFTNL_SET_DATA_TYPE);
 		datatype = dtype_map_from_kernel(data);
 		if (datatype == NULL) {
@@ -590,8 +592,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 					 data);
 			return NULL;
 		}
-	} else
-		datatype = NULL;
+	}
 
 	if (set_is_objmap(flags)) {
 		objtype = nftnl_set_get_u32(nls, NFTNL_SET_OBJ_TYPE);
@@ -605,25 +606,22 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->automerge	   = automerge;
 
 	set->key     = constant_expr_alloc(&netlink_location,
-					   set_datatype_alloc(keytype, keybyteorder),
-					   keybyteorder,
-					   nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE,
-					   NULL);
+                                           set_datatype_alloc(keytype, keybyteorder),
+                                           keybyteorder,
+                                           nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE,
+                                           NULL);
 	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 	set->handle.handle.id = nftnl_set_get_u64(nls, NFTNL_SET_HANDLE);
 
 	set->objtype = objtype;
 
+	set->data = NULL;
 	if (datatype)
-		set->datatype = datatype_get(set_datatype_alloc(datatype,
-								databyteorder));
-	else
-		set->datatype = NULL;
-
-	if (nftnl_set_is_set(nls, NFTNL_SET_DATA_LEN)) {
-		data_len = nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN);
-		set->datalen = data_len * BITS_PER_BYTE;
-	}
+		set->data = constant_expr_alloc(&netlink_location,
+						set_datatype_alloc(datatype, databyteorder),
+						databyteorder,
+						nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN) * BITS_PER_BYTE,
+						NULL);
 
 	if (nftnl_set_is_set(nls, NFTNL_SET_TIMEOUT))
 		set->timeout = nftnl_set_get_u64(nls, NFTNL_SET_TIMEOUT);
@@ -808,10 +806,10 @@ int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 			goto out;
 
 		data = netlink_alloc_data(&netlink_location, &nld,
-					  set->datatype->type == TYPE_VERDICT ?
+					  set->data->dtype->type == TYPE_VERDICT ?
 					  NFT_REG_VERDICT : NFT_REG_1);
-		datatype_set(data, set->datatype);
-		data->byteorder = set->datatype->byteorder;
+		datatype_set(data, set->data->dtype);
+		data->byteorder = set->data->byteorder;
 		if (data->byteorder == BYTEORDER_HOST_ENDIAN)
 			mpz_switch_byteorder(data->value, data->len / BITS_PER_BYTE);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 53e669521efa..5771f9f7469e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1688,9 +1688,8 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 						stmt_separator
 			{
 				$1->key = $3;
-				$1->datatype = $5->dtype;
+				$1->data = $5;
 
-				expr_free($5);
 				$1->flags |= NFT_SET_MAP;
 				$$ = $1;
 			}
diff --git a/src/parser_json.c b/src/parser_json.c
index 76c0a5ccdddd..1003e6d160fe 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2720,6 +2720,50 @@ static int string_to_set_flag(const char *str)
 	return 0;
 }
 
+static struct expr *concat_expr_alloc_by_type(uint32_t type)
+{
+	struct expr *concat_expr = concat_expr_alloc(&netlink_location);
+	unsigned int n;
+
+	n = div_round_up(fls(type), TYPE_BITS);
+	while (n > 0 && concat_subtype_id(type, --n)) {
+		const struct datatype *i;
+		struct expr *expr;
+
+		i = concat_subtype_lookup(type, n);
+		if (i == NULL)
+			return NULL;
+
+		expr = constant_expr_alloc(&netlink_location, i, i->byteorder,
+					   i->size, NULL);
+
+		compound_expr_add(concat_expr, expr);
+	}
+
+	return concat_expr;
+}
+
+static struct expr *dtype_map_from_kernel(enum nft_data_types type)
+{
+	const struct datatype *dtype;
+
+	switch (type) {
+	case NFT_DATA_VERDICT:
+		return verdict_expr_alloc(&netlink_location, 0, NULL);
+	default:
+		if (type & ~TYPE_MASK)
+			return concat_expr_alloc_by_type(type);
+
+		dtype = datatype_lookup(type);
+		if (!dtype)
+			return NULL;
+
+		return constant_expr_alloc(&netlink_location, dtype, dtype->byteorder,
+					   dtype->size, NULL);
+	}
+}
+/* FIX THE ABOVE */
+
 static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 					  enum cmd_ops op, enum cmd_obj obj)
 {
@@ -2776,11 +2820,13 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 	}
 
 	if (!json_unpack(root, "{s:s}", "map", &dtype_ext)) {
+		const struct datatype *dtype;
+
 		set->objtype = string_to_nft_object(dtype_ext);
 		if (set->objtype) {
 			set->flags |= NFT_SET_OBJECT;
-		} else if (datatype_lookup_byname(dtype_ext)) {
-			set->datatype = datatype_lookup_byname(dtype_ext);
+		} else if ((dtype = datatype_lookup_byname(dtype_ext))) {
+			set->data = dtype_map_from_kernel(dtype->type);
 			set->flags |= NFT_SET_MAP;
 		} else {
 			json_error(ctx, "Invalid map type '%s'.", dtype_ext);
diff --git a/src/rule.c b/src/rule.c
index 293606576044..d3e0b356f714 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -330,8 +330,7 @@ struct set *set_clone(const struct set *set)
 	new_set->gc_int		= set->gc_int;
 	new_set->timeout	= set->timeout;
 	new_set->key		= expr_clone(set->key);
-	new_set->datatype	= datatype_get(set->datatype);
-	new_set->datalen	= set->datalen;
+	new_set->data		= expr_clone(set->data);
 	new_set->objtype	= set->objtype;
 	new_set->policy		= set->policy;
 	new_set->automerge	= set->automerge;
@@ -354,7 +353,7 @@ void set_free(struct set *set)
 		expr_free(set->init);
 	handle_free(&set->handle);
 	expr_free(set->key);
-	set_datatype_destroy(set->datatype);
+	expr_free(set->data);
 	xfree(set);
 }
 
@@ -468,7 +467,7 @@ static void set_print_declaration(const struct set *set,
 	nft_print(octx, "%s%stype %s",
 		  opts->tab, opts->tab, set->key->dtype->name);
 	if (set_is_datamap(set->flags))
-		nft_print(octx, " : %s", set->datatype->name);
+		nft_print(octx, " : %s", set->data->dtype->name);
 	else if (set_is_objmap(set->flags))
 		nft_print(octx, " : %s", obj_type_name(set->objtype));
 
diff --git a/src/segtree.c b/src/segtree.c
index eff0653a8dfb..cfb892c3bb34 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -79,8 +79,12 @@ static void seg_tree_init(struct seg_tree *tree, const struct set *set,
 	tree->root	= RB_ROOT;
 	tree->keytype	= set->key->dtype;
 	tree->keylen	= set->key->len;
-	tree->datatype	= set->datatype;
-	tree->datalen	= set->datalen;
+	tree->datatype	= NULL;
+	tree->datalen	= 0;
+	if (set->data) {
+		tree->datatype	= set->data->dtype;
+		tree->datalen	= set->data->len;
+	}
 	tree->byteorder	= first->byteorder;
 	tree->debug_mask = debug_mask;
 }
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 7f424cf1e92d..bc0849e0410b 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -138,6 +138,7 @@ def color_differences(rule, other, color):
     rlen = len(rule)
     olen = len(other)
     out = ""
+    i = 0
 
     # find equal part at start
     for i in range(rlen):
-- 
2.21.0

