From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] src: store expression as set key instead of data type
Date: Tue, 19 Sep 2017 14:49:54 +0200
Message-ID: <20170919124954.26852-3-fw@strlen.de>
References: <20170919124954.26852-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54698 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751687AbdISMtn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2017 08:49:43 -0400
In-Reply-To: <20170919124954.26852-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Doing so retains legth information in case of unqualified data types,
e.g. we now have 'meta iifname' expression instead of an (unqualified)
string type.

This allows to eventually use iifnames as set keys without adding yet
another special data type for them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h            |  6 ++---
 src/evaluate.c            | 69 ++++++++++++++++++++++++++++-------------------
 src/expression.c          |  4 +--
 src/netlink.c             | 27 ++++++++++---------
 src/netlink_delinearize.c | 12 ++++-----
 src/parser_bison.y        | 65 ++++++++++++++++++++++----------------------
 src/rule.c                |  4 +--
 src/segtree.c             |  4 +--
 8 files changed, 104 insertions(+), 87 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 631a1bcdf84e..48b3d731b8a1 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -212,8 +212,7 @@ extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
  * @flags:	bitmask of set flags
  * @gc_int:	garbage collection interval
  * @timeout:	default timeout value
- * @keytype:	key data type
- * @keylen:	key length
+ * @key:	key expression (data type, length))
  * @datatype:	mapping data type
  * @datalen:	mapping data len
  * @objtype:	mapping object type
@@ -230,8 +229,7 @@ struct set {
 	uint32_t		flags;
 	uint32_t		gc_int;
 	uint64_t		timeout;
-	const struct datatype	*keytype;
-	unsigned int		keylen;
+	struct expr		*key;
 	const struct datatype	*datatype;
 	unsigned int		datalen;
 	uint32_t		objtype;
diff --git a/src/evaluate.c b/src/evaluate.c
index 86159cf55f94..dd7bf5076e7c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -60,6 +60,18 @@ static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 	return -1;
 }
 
+static void key_fix_dtype_byteorder(struct expr *key)
+{
+	const struct datatype *dtype = key->dtype;
+
+	if (dtype->byteorder == key->byteorder)
+		return;
+
+	key->dtype = set_datatype_alloc(dtype, key->byteorder);
+	if (dtype->flags & DTYPE_F_ALLOC)
+		concat_type_destroy(dtype);
+}
+
 static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 					     const char *name,
 					     struct expr *key,
@@ -69,11 +81,12 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	struct set *set;
 	struct handle h;
 
+	key_fix_dtype_byteorder(key);
+
 	set = set_alloc(&expr->location);
 	set->flags	= NFT_SET_ANONYMOUS | expr->set_flags;
-	set->handle.set = xstrdup(name),
-	set->keytype 	= set_datatype_alloc(key->dtype, key->byteorder);
-	set->keylen	= key->len;
+	set->handle.set = xstrdup(name);
+	set->key	= key;
 	set->init	= expr;
 
 	if (ctx->table != NULL)
@@ -1023,7 +1036,8 @@ static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	return err;
 }
 
-static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
+static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr,
+				bool evaluate)
 {
 	const struct datatype *dtype = ctx->ectx.dtype, *tmp;
 	uint32_t type = dtype ? dtype->type : 0, ntype = 0;
@@ -1044,7 +1058,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 			tmp = concat_subtype_lookup(type, --off);
 		expr_set_context(&ctx->ectx, tmp, tmp->size);
 
-		if (list_member_evaluate(ctx, &i) < 0)
+		if (evaluate && list_member_evaluate(ctx, &i) < 0)
 			return -1;
 		flags &= i->flags;
 
@@ -1204,8 +1218,6 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    key,
 						    mappings);
-		expr_free(key);
-
 		mappings->set->datatype = set_datatype_alloc(ectx.dtype,
 							     ectx.byteorder);
 		mappings->set->datalen  = ectx.len;
@@ -1232,11 +1244,11 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		    map->mappings->ops->name);
 	}
 
-	if (!datatype_equal(map->map->dtype, map->mappings->set->keytype))
+	if (!datatype_equal(map->map->dtype, map->mappings->set->key->dtype))
 		return expr_binary_error(ctx->msgs, map->mappings, map->map,
 					 "datatype mismatch, map expects %s, "
 					 "mapping expression has type %s",
-					 map->mappings->set->keytype->desc,
+					 map->mappings->set->key->dtype->desc,
 					 map->map->dtype->desc);
 
 	map->dtype = map->mappings->set->datatype;
@@ -1261,7 +1273,7 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	if (!(set->flags & (NFT_SET_MAP | NFT_SET_OBJECT)))
 		return set_error(ctx, set, "set is not a map");
 
-	expr_set_context(&ctx->ectx, set->keytype, set->keylen);
+	expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
 	if (expr_evaluate(ctx, &mapping->left) < 0)
 		return -1;
 	if (!expr_is_constant(mapping->left))
@@ -1747,7 +1759,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_BINOP:
 		return expr_evaluate_binop(ctx, expr);
 	case EXPR_CONCAT:
-		return expr_evaluate_concat(ctx, expr);
+		return expr_evaluate_concat(ctx, expr, true);
 	case EXPR_LIST:
 		return expr_evaluate_list(ctx, expr);
 	case EXPR_SET:
@@ -2589,9 +2601,9 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 				  "Expression does not refer to a set");
 
 	if (stmt_evaluate_arg(ctx, stmt,
-			      stmt->set.set->set->keytype,
-			      stmt->set.set->set->keylen,
-			      stmt->set.set->set->keytype->byteorder,
+			      stmt->set.set->set->key->dtype,
+			      stmt->set.set->set->key->len,
+			      stmt->set.set->set->key->byteorder,
 			      &stmt->set.key) < 0)
 		return -1;
 	if (expr_is_constant(stmt->set.key))
@@ -2629,8 +2641,6 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 
 		mappings = implicit_set_declaration(ctx, "__objmap%d",
 						    key, mappings);
-		expr_free(key);
-
 		mappings->set->datatype = &string_type;
 		mappings->set->datalen  = NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE;
 		mappings->set->objtype  = stmt->objref.type;
@@ -2657,11 +2667,11 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 		    map->mappings->ops->name);
 	}
 
-	if (!datatype_equal(map->map->dtype, map->mappings->set->keytype))
+	if (!datatype_equal(map->map->dtype, map->mappings->set->key->dtype))
 		return expr_binary_error(ctx->msgs, map->mappings, map->map,
 					 "datatype mismatch, map expects %s, "
 					 "mapping expression has type %s",
-					 map->mappings->set->keytype->desc,
+					 map->mappings->set->key->dtype->desc,
 					 map->map->dtype->desc);
 
 	map->dtype = map->mappings->set->datatype;
@@ -2765,7 +2775,7 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 				 ctx->cmd->handle.set);
 
 	ctx->set = set;
-	expr_set_context(&ctx->ectx, set->keytype, set->keylen);
+	expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
 	if (expr_evaluate(ctx, expr) < 0)
 		return -1;
 	ctx->set = NULL;
@@ -2784,15 +2794,20 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 
 	type = set->flags & NFT_SET_MAP ? "map" : "set";
 
-	if (set->keytype == NULL)
-		return set_error(ctx, set, "%s definition does not specify "
-				 "key data type", type);
+	if (set->key == NULL)
+		return set_error(ctx, set, "%s definition does not specify key",
+				 type);
 
-	set->keylen = set->keytype->size;
-	if (set->keylen == 0)
-		return set_error(ctx, set, "unqualified key data type "
-				 "specified in %s definition", type);
+	if (set->key->len == 0) {
+		if (set->key->ops->type == EXPR_CONCAT &&
+		    expr_evaluate_concat(ctx, &set->key, false) < 0)
+			return -1;
 
+		if (set->key->len == 0)
+			return set_error(ctx, set, "unqualified key type %s "
+					 "specified in %s definition",
+					 set->key->dtype->name, type);
+	}
 	if (set->flags & NFT_SET_MAP) {
 		if (set->datatype == NULL)
 			return set_error(ctx, set, "map definition does not "
@@ -2809,7 +2824,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 
 	ctx->set = set;
 	if (set->init != NULL) {
-		expr_set_context(&ctx->ectx, set->keytype, set->keylen);
+		expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
 		if (expr_evaluate(ctx, &set->init) < 0)
 			return -1;
 	}
diff --git a/src/expression.c b/src/expression.c
index d41ada39cc0f..ff3550c7cd85 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -832,7 +832,7 @@ struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 		return set_expr;
 
 	set_expr->set_flags = set->flags;
-	set_expr->dtype = set->keytype;
+	set_expr->dtype = set->key->dtype;
 
 	return set_expr;
 }
@@ -960,7 +960,7 @@ struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 {
 	struct expr *expr;
 
-	expr = expr_alloc(loc, &set_ref_expr_ops, set->keytype, 0, 0);
+	expr = expr_alloc(loc, &set_ref_expr_ops, set->key->dtype, 0, 0);
 	expr->set = set_get(set);
 	expr->flags |= EXPR_F_CONSTANT;
 	return expr;
diff --git a/src/netlink.c b/src/netlink.c
index 291bbdeeaa68..e414718ba1b9 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1118,8 +1118,11 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->handle.table  = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_TABLE));
 	set->handle.set    = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 
-	set->keytype = set_datatype_alloc(keytype, keybyteorder);
-	set->keylen  = nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
+	set->key     = constant_expr_alloc(&netlink_location,
+					   set_datatype_alloc(keytype, keybyteorder),
+					   keybyteorder,
+					   nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE,
+					   NULL);
 	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 
 	set->objtype = objtype;
@@ -1158,9 +1161,9 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 	nls = alloc_nftnl_set(h);
 	nftnl_set_set_u32(nls, NFTNL_SET_FLAGS, set->flags);
 	nftnl_set_set_u32(nls, NFTNL_SET_KEY_TYPE,
-			  dtype_map_to_kernel(set->keytype));
+			  dtype_map_to_kernel(set->key->dtype));
 	nftnl_set_set_u32(nls, NFTNL_SET_KEY_LEN,
-			  div_round_up(set->keylen, BITS_PER_BYTE));
+			  div_round_up(set->key->len, BITS_PER_BYTE));
 	if (set->flags & NFT_SET_MAP) {
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_TYPE,
 				  dtype_map_to_kernel(set->datatype));
@@ -1192,9 +1195,9 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	nls = alloc_nftnl_set(h);
 	nftnl_set_set_u32(nls, NFTNL_SET_FLAGS, set->flags);
 	nftnl_set_set_u32(nls, NFTNL_SET_KEY_TYPE,
-			  dtype_map_to_kernel(set->keytype));
+			  dtype_map_to_kernel(set->key->dtype));
 	nftnl_set_set_u32(nls, NFTNL_SET_KEY_LEN,
-			  div_round_up(set->keylen, BITS_PER_BYTE));
+			  div_round_up(set->key->len, BITS_PER_BYTE));
 	if (set->flags & NFT_SET_MAP) {
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_TYPE,
 				  dtype_map_to_kernel(set->datatype));
@@ -1226,7 +1229,7 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	if (!udbuf)
 		memory_allocation_error();
 	if (!nftnl_udata_put_u32(udbuf, UDATA_SET_KEYBYTEORDER,
-				 set->keytype->byteorder))
+				 set->key->byteorder))
 		memory_allocation_error();
 
 	if (set->flags & NFT_SET_MAP &&
@@ -1537,10 +1540,10 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		flags = nftnl_set_elem_get_u32(nlse, NFTNL_SET_ELEM_FLAGS);
 
 	key = netlink_alloc_value(&netlink_location, &nld);
-	key->dtype	= set->keytype;
-	key->byteorder	= set->keytype->byteorder;
-	if (set->keytype->subtypes)
-		key = netlink_parse_concat_elem(set->keytype, key);
+	key->dtype	= set->key->dtype;
+	key->byteorder	= set->key->byteorder;
+	if (set->key->dtype->subtypes)
+		key = netlink_parse_concat_elem(set->key->dtype, key);
 
 	if (!(set->flags & NFT_SET_INTERVAL) &&
 	    key->byteorder == BYTEORDER_HOST_ENDIAN)
@@ -2197,7 +2200,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		 * used by named sets, so use a dummy set.
 		 */
 		dummyset = set_alloc(monh->loc);
-		dummyset->keytype = set->keytype;
+		dummyset->key = expr_clone(set->key);
 		dummyset->datatype = set->datatype;
 		dummyset->flags = set->flags;
 		dummyset->init = set_expr_alloc(monh->loc, set);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3f42d092d204..42206ebcfff2 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -307,8 +307,8 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 		return netlink_error(ctx, loc,
 				     "Lookup expression has no left hand side");
 
-	if (left->len < set->keylen) {
-		left = netlink_parse_concat_expr(ctx, loc, sreg, set->keylen);
+	if (left->len < set->key->len) {
+		left = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
 		if (left == NULL)
 			return;
 	}
@@ -1122,8 +1122,8 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 		return netlink_error(ctx, loc,
 				     "Dynset statement has no key expression");
 
-	if (expr->len < set->keylen) {
-		expr = netlink_parse_concat_expr(ctx, loc, sreg, set->keylen);
+	if (expr->len < set->key->len) {
+		expr = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
 		if (expr == NULL)
 			return;
 	}
@@ -1193,8 +1193,8 @@ static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
 			return netlink_error(ctx, loc,
 					     "objref expression has no left hand side");
 
-		if (left->len < set->keylen) {
-			left = netlink_parse_concat_expr(ctx, loc, sreg, set->keylen);
+		if (left->len < set->key->len) {
+			left = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
 			if (left == NULL)
 				return;
 		}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 31a7e8be2bcd..b203599f7be6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -469,8 +469,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <val>			time_spec quota_used
 
-%type <val>			type_identifier_list
-%type <datatype>		data_type
+%type <expr>			data_type_expr data_type_atom_expr
+%destructor { expr_free($$); }  data_type_expr data_type_atom_expr
 
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
@@ -1387,9 +1387,9 @@ set_block_alloc		:	/* empty */
 set_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	set_block	common_block
 			|	set_block	stmt_separator
-			|	set_block	TYPE		data_type	stmt_separator
+			|	set_block	TYPE		data_type_expr	stmt_separator
 			{
-				$1->keytype = $3;
+				$1->key = $3;
 				$$ = $1;
 			}
 			|	set_block	FLAGS		set_flag_list	stmt_separator
@@ -1441,28 +1441,30 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	map_block	common_block
 			|	map_block	stmt_separator
 			|	map_block	TYPE
-						data_type	COLON	data_type
+						data_type_expr	COLON	data_type_expr
 						stmt_separator
 			{
-				$1->keytype  = $3;
-				$1->datatype = $5;
+				$1->key = $3;
+				$1->datatype = $5->dtype;
+
+				expr_free($5);
 				$1->flags |= NFT_SET_MAP;
 				$$ = $1;
 			}
 			|	map_block	TYPE
-						data_type	COLON	COUNTER
+						data_type_expr	COLON	COUNTER
 						stmt_separator
 			{
-				$1->keytype = $3;
+				$1->key = $3;
 				$1->objtype = NFT_OBJECT_COUNTER;
 				$1->flags  |= NFT_SET_OBJECT;
 				$$ = $1;
 			}
 			|	map_block	TYPE
-						data_type	COLON	QUOTA
+						data_type_expr	COLON	QUOTA
 						stmt_separator
 			{
-				$1->keytype = $3;
+				$1->key = $3;
 				$1->objtype = NFT_OBJECT_QUOTA;
 				$1->flags  |= NFT_SET_OBJECT;
 				$$ = $1;
@@ -1494,16 +1496,7 @@ set_policy_spec		:	PERFORMANCE	{ $$ = NFT_SET_POL_PERFORMANCE; }
 			|	MEMORY		{ $$ = NFT_SET_POL_MEMORY; }
 			;
 
-data_type		:	type_identifier_list
-			{
-				if ($1 & ~TYPE_MASK)
-					$$ = concat_type_alloc($1);
-				else
-					$$ = datatype_lookup($1);
-			}
-			;
-
-type_identifier_list	:	type_identifier
+data_type_atom_expr	:	type_identifier
 			{
 				const struct datatype *dtype = datatype_lookup_byname($1);
 				if (dtype == NULL) {
@@ -1512,20 +1505,28 @@ type_identifier_list	:	type_identifier
 					xfree($1);
 					YYERROR;
 				}
-				xfree($1);
-				$$ = dtype->type;
+				$$ = constant_expr_alloc(&@1, dtype, dtype->byteorder,
+							 dtype->size, NULL);
 			}
-			|	type_identifier_list	DOT	type_identifier
+			;
+
+data_type_expr		:	data_type_atom_expr
+			|	data_type_expr	DOT	data_type_atom_expr
 			{
-				const struct datatype *dtype = datatype_lookup_byname($3);
-				if (dtype == NULL) {
-					erec_queue(error(&@3, "unknown datatype %s", $3),
-						   state->msgs);
-					xfree($3);
-					YYERROR;
+				if ($1->ops->type != EXPR_CONCAT) {
+					$$ = concat_expr_alloc(&@$);
+					compound_expr_add($$, $1);
+				} else {
+					struct location rhs[] = {
+						[1]	= @2,
+						[2]	= @3,
+					};
+					location_update(&$3->location, rhs, 2);
+
+					$$ = $1;
+					$$->location = @$;
 				}
-				xfree($3);
-				$$ = concat_subtype_add($$, dtype->type);
+				compound_expr_add($$, $3);
 			}
 			;
 
diff --git a/src/rule.c b/src/rule.c
index 1bb7b4756171..a417c307dfe8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -215,7 +215,7 @@ void set_free(struct set *set)
 	if (set->init != NULL)
 		expr_free(set->init);
 	handle_free(&set->handle);
-	set_datatype_destroy(set->keytype);
+	expr_free(set->key);
 	set_datatype_destroy(set->datatype);
 	xfree(set);
 }
@@ -296,7 +296,7 @@ static void set_print_declaration(const struct set *set,
 
 	printf(" %s {%s", set->handle.set, opts->nl);
 
-	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
+	printf("%s%stype %s", opts->tab, opts->tab, set->key->dtype->name);
 	if (set->flags & NFT_SET_MAP)
 		printf(" : %s", set->datatype->name);
 	else if (set->flags & NFT_SET_OBJECT)
diff --git a/src/segtree.c b/src/segtree.c
index f81e117421a1..f0efd155f0be 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -76,8 +76,8 @@ static void seg_tree_init(struct seg_tree *tree, const struct set *set,
 
 	first = list_entry(init->expressions.next, struct expr, list);
 	tree->root	= RB_ROOT;
-	tree->keytype	= set->keytype;
-	tree->keylen	= set->keylen;
+	tree->keytype	= set->key->dtype;
+	tree->keylen	= set->key->len;
 	tree->datatype	= set->datatype;
 	tree->datalen	= set->datalen;
 	tree->byteorder	= first->byteorder;
-- 
2.13.5

