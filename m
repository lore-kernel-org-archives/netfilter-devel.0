From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 09/10] src: add support for stateful object maps
Date: Fri, 23 Dec 2016 15:26:54 +0100
Message-ID: <1482503215-25422-9-git-send-email-pablo@netfilter.org>
References: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40186 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941232AbcLWO1S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:27:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2E5C12519A2
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B7988E66B
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A8B28E66B
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:13 +0100 (CET)
In-Reply-To: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

You can create these maps using explicit map declarations:

 # nft add table filter
 # nft add chain filter input { type filter hook input priority 0\; }
 # nft add map filter badguys { type ipv4_addr : counter \; }
 # nft add rule filter input counter name ip saddr map @badguys
 # nft add counter filter badguy1
 # nft add counter filter badguy2
 # nft add element filter badguys { 192.168.2.3 : "badguy1" }
 # nft add element filter badguys { 192.168.2.4 : "badguy2" }

Or through implicit map definitions:

 table ip filter {
        counter http-traffic {
                packets 8 bytes 672
        }

        chain input {
                type filter hook input priority 0; policy accept;
                counter name tcp dport map { 80 : "http-traffic", 443 : "http-traffic"}
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h            |  2 ++
 src/evaluate.c            | 74 ++++++++++++++++++++++++++++++++++++++++++++++-
 src/netlink.c             | 40 ++++++++++++++++++++-----
 src/netlink_delinearize.c | 29 +++++++++++++++++++
 src/netlink_linearize.c   | 26 +++++++++++++++--
 src/parser_bison.y        | 20 ++++++++++++-
 src/rule.c                |  5 +++-
 7 files changed, 182 insertions(+), 14 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 9028c84b0033..86c0392f89af 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -212,6 +212,7 @@ extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
  * @keylen:	key length
  * @datatype:	mapping data type
  * @datalen:	mapping data len
+ * @objtype:	mapping object type
  * @init:	initializer
  * @policy:	set mechanism policy
  * @desc:	set mechanism desc
@@ -228,6 +229,7 @@ struct set {
 	unsigned int		keylen;
 	const struct datatype	*datatype;
 	unsigned int		datalen;
+	uint32_t		objtype;
 	struct expr		*init;
 	uint32_t		policy;
 	struct {
diff --git a/src/evaluate.c b/src/evaluate.c
index b868f1bc283a..cebc5a9ead7a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1188,7 +1188,7 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	if (set == NULL)
 		return expr_error(ctx->msgs, mapping,
 				  "mapping outside of map context");
-	if (!(set->flags & NFT_SET_MAP))
+	if (!(set->flags & (NFT_SET_MAP | NFT_SET_OBJECT)))
 		return set_error(ctx, set, "set is not a map");
 
 	expr_set_context(&ctx->ectx, set->keytype, set->keylen);
@@ -2464,8 +2464,77 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	struct expr *map = stmt->objref.expr;
+	struct expr *mappings;
+
+	expr_set_context(&ctx->ectx, NULL, 0);
+	if (expr_evaluate(ctx, &map->map) < 0)
+		return -1;
+	if (expr_is_constant(map->map))
+		return expr_error(ctx->msgs, map->map,
+				  "Map expression can not be constant");
+
+	mappings = map->mappings;
+	mappings->set_flags |= NFT_SET_OBJECT;
+
+	switch (map->mappings->ops->type) {
+	case EXPR_SET:
+		mappings = implicit_set_declaration(ctx, "__objmap%d",
+						    ctx->ectx.dtype,
+						    ctx->ectx.len,
+						    mappings);
+		mappings->set->datatype = &string_type;
+		mappings->set->datalen  = NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE;
+		mappings->set->objtype  = stmt->objref.type;
+
+		map->mappings = mappings;
+
+		ctx->set = mappings->set;
+		if (expr_evaluate(ctx, &map->mappings->set->init) < 0)
+			return -1;
+		ctx->set = NULL;
+
+		map->mappings->set->flags |=
+			map->mappings->set->init->set_flags;
+	case EXPR_SYMBOL:
+		if (expr_evaluate(ctx, &map->mappings) < 0)
+			return -1;
+		if (map->mappings->ops->type != EXPR_SET_REF ||
+		    !(map->mappings->set->flags & NFT_SET_OBJECT))
+			return expr_error(ctx->msgs, map->mappings,
+					  "Expression is not a map");
+		break;
+	default:
+		BUG("invalid mapping expression %s\n",
+		    map->mappings->ops->name);
+	}
+
+	if (!datatype_equal(map->map->dtype, map->mappings->set->keytype))
+		return expr_binary_error(ctx->msgs, map->mappings, map->map,
+					 "datatype mismatch, map expects %s, "
+					 "mapping expression has type %s",
+					 map->mappings->set->keytype->desc,
+					 map->map->dtype->desc);
+
+	map->dtype = map->mappings->set->datatype;
+	map->flags |= EXPR_F_CONSTANT;
+
+	/* Data for range lookups needs to be in big endian order */
+	if (map->mappings->set->flags & NFT_SET_INTERVAL &&
+	    byteorder_conversion(ctx, &map->map, BYTEORDER_BIG_ENDIAN) < 0)
+		return -1;
+
+	return 0;
+}
+
 static int stmt_evaluate_objref(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	/* We need specific map evaluation for stateful objects. */
+	if (stmt->objref.expr->ops->type == EXPR_MAP)
+		return stmt_evaluate_objref_map(ctx, stmt);
+
 	if (stmt_evaluate_arg(ctx, stmt,
 			      &string_type, NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE,
 			      &stmt->objref.expr) < 0)
@@ -2585,6 +2654,9 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		if (set->datalen == 0 && set->datatype->type != TYPE_VERDICT)
 			return set_error(ctx, set, "unqualified mapping data "
 					 "type specified in map definition");
+	} else if (set->flags & NFT_SET_OBJECT) {
+		set->datatype = &string_type;
+		set->datalen  = NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE;
 	}
 
 	ctx->set = set;
diff --git a/src/netlink.c b/src/netlink.c
index 68bed201a36d..97220f451343 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -205,7 +205,8 @@ struct nftnl_set *alloc_nftnl_set(const struct handle *h)
 	return nls;
 }
 
-static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *expr)
+static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
+						  const struct expr *expr)
 {
 	const struct expr *elem, *key, *data;
 	struct nftnl_set_elem *nlse;
@@ -243,8 +244,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *expr)
 				   nftnl_udata_buf_len(udbuf));
 		nftnl_udata_buf_free(udbuf);
 	}
-
-	if (data != NULL) {
+	if (set->set_flags & NFT_SET_MAP && data != NULL) {
 		netlink_gen_data(data, &nld);
 		switch (data->ops->type) {
 		case EXPR_VERDICT:
@@ -263,6 +263,11 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *expr)
 			break;
 		}
 	}
+	if (set->set_flags & NFT_SET_OBJECT) {
+		netlink_gen_data(data, &nld);
+		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_OBJREF,
+				   nld.value, nld.len);
+	}
 
 	if (expr->flags & EXPR_F_INTERVAL_END)
 		nftnl_set_elem_set_u32(nlse, NFTNL_SET_ELEM_FLAGS,
@@ -1110,7 +1115,7 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 {
 	struct set *set;
 	const struct datatype *keytype, *datatype;
-	uint32_t flags, key, data, data_len;
+	uint32_t flags, key, data, data_len, objtype = 0;
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
 	keytype = dtype_map_from_kernel(key);
@@ -1133,6 +1138,11 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	} else
 		datatype = NULL;
 
+	if (flags & NFT_SET_OBJECT) {
+		objtype = nftnl_set_get_u32(nls, NFTNL_SET_OBJ_TYPE);
+		datatype = &string_type;
+	}
+
 	set = set_alloc(&netlink_location);
 	set->handle.family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
 	set->handle.table  = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_TABLE));
@@ -1142,6 +1152,8 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->keylen  = nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
 	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 
+	set->objtype = objtype;
+
 	set->datatype = datatype;
 	if (nftnl_set_is_set(nls, NFTNL_SET_DATA_LEN)) {
 		data_len = nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN);
@@ -1214,6 +1226,9 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_LEN,
 				  set->datalen / BITS_PER_BYTE);
 	}
+	if (set->flags & NFT_SET_OBJECT)
+		nftnl_set_set_u32(nls, NFTNL_SET_OBJ_TYPE, set->objtype);
+
 	if (set->timeout)
 		nftnl_set_set_u64(nls, NFTNL_SET_TIMEOUT, set->timeout);
 	if (set->gc_int)
@@ -1357,7 +1372,7 @@ static void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
 	const struct expr *expr;
 
 	list_for_each_entry(expr, &set->expressions, list) {
-		nlse = alloc_nftnl_setelem(expr);
+		nlse = alloc_nftnl_setelem(set, expr);
 		nftnl_set_elem_add(nls, nlse);
 	}
 }
@@ -1577,10 +1592,10 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		nle = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_EXPR, NULL);
 		expr->stmt = netlink_parse_set_expr(set, nle);
 	}
-
-	if (flags & NFT_SET_ELEM_INTERVAL_END) {
+	if (flags & NFT_SET_ELEM_INTERVAL_END)
 		expr->flags |= EXPR_F_INTERVAL_END;
-	} else {
+
+	if (set->flags & NFT_SET_MAP) {
 		if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_DATA)) {
 			nld.value = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_DATA,
 						       &nld.len);
@@ -1602,6 +1617,15 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 
 		expr = mapping_expr_alloc(&netlink_location, expr, data);
 	}
+	if (set->flags & NFT_SET_OBJECT) {
+		nld.value = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_OBJREF,
+					       &nld.len);
+		data = netlink_alloc_value(&netlink_location, &nld);
+		data->dtype = &string_type;
+		data->byteorder = BYTEORDER_HOST_ENDIAN;
+		mpz_switch_byteorder(data->value, data->len / BITS_PER_BYTE);
+		expr = mapping_expr_alloc(&netlink_location, expr, data);
+	}
 out:
 	compound_expr_add(set->init, expr);
 	return 0;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 90fb9e670751..48968442d9bc 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1142,6 +1142,35 @@ static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
 		expr = netlink_alloc_value(&netlink_location, &nld);
 		expr->dtype = &string_type;
 		expr->byteorder = BYTEORDER_HOST_ENDIAN;
+	} else if (nftnl_expr_is_set(nle, NFTNL_EXPR_OBJREF_SET_SREG)) {
+		struct expr *left, *right;
+		enum nft_registers sreg;
+		const char *name;
+		struct set *set;
+
+		name = nftnl_expr_get_str(nle, NFTNL_EXPR_OBJREF_SET_NAME);
+		set  = set_lookup(ctx->table, name);
+		if (set == NULL)
+			return netlink_error(ctx, loc,
+					     "Unknown set '%s' in objref expression",
+					     name);
+
+		sreg = netlink_parse_register(nle, NFTNL_EXPR_OBJREF_SET_SREG);
+		left = netlink_get_register(ctx, loc, sreg);
+		if (left == NULL)
+			return netlink_error(ctx, loc,
+					     "objref expression has no left hand side");
+
+		if (left->len < set->keylen) {
+			left = netlink_parse_concat_expr(ctx, loc, sreg, set->keylen);
+			if (left == NULL)
+				return;
+		}
+
+		right = set_ref_expr_alloc(loc, set);
+		expr = map_expr_alloc(loc, left, right);
+		expr_set_type(expr, &string_type, BYTEORDER_HOST_ENDIAN);
+		type = set->objtype;
 	} else {
 		netlink_error(ctx, loc, "unknown objref expression type %u",
 			      type);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c9488b3212bc..5030135cd5d5 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -692,14 +692,34 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 static void netlink_gen_objref_stmt(struct netlink_linearize_ctx *ctx,
 				    const struct stmt *stmt)
 {
+	struct expr *expr = stmt->objref.expr;
 	struct nft_data_linearize nld;
 	struct nftnl_expr *nle;
+	uint32_t sreg_key;
 
 	nle = alloc_nft_expr("objref");
-	netlink_gen_data(stmt->objref.expr, &nld);
-	nftnl_expr_set(nle, NFTNL_EXPR_OBJREF_IMM_NAME, nld.value, nld.len);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_OBJREF_IMM_TYPE, stmt->objref.type);
+	switch (expr->ops->type) {
+	case EXPR_MAP:
+		sreg_key = get_register(ctx, expr->map);
+		netlink_gen_expr(ctx, expr->map, sreg_key);
+		release_register(ctx, expr->map);
 
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_OBJREF_SET_SREG, sreg_key);
+		nftnl_expr_set_str(nle, NFTNL_EXPR_OBJREF_SET_NAME,
+				   expr->mappings->set->handle.set);
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_OBJREF_SET_ID,
+				   expr->mappings->set->handle.set_id);
+		break;
+	case EXPR_VALUE:
+		netlink_gen_data(stmt->objref.expr, &nld);
+		nftnl_expr_set(nle, NFTNL_EXPR_OBJREF_IMM_NAME,
+			       nld.value, nld.len);
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_OBJREF_IMM_TYPE,
+				   stmt->objref.type);
+		break;
+	default:
+		BUG("unsupported expression %u\n", expr->ops->type);
+	}
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 795b0ee210a3..122e2496acde 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1218,7 +1218,6 @@ set_flag		:	CONSTANT	{ $$ = NFT_SET_CONSTANT; }
 map_block_alloc		:	/* empty */
 			{
 				$$ = set_alloc(NULL);
-				$$->flags |= NFT_SET_MAP;
 			}
 			;
 
@@ -1231,6 +1230,25 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			{
 				$1->keytype  = $3;
 				$1->datatype = $5;
+				$1->flags |= NFT_SET_MAP;
+				$$ = $1;
+			}
+			|	map_block	TYPE
+						data_type	COLON	COUNTER
+						stmt_seperator
+			{
+				$1->keytype = $3;
+				$1->objtype = NFT_OBJECT_COUNTER;
+				$1->flags  |= NFT_SET_OBJECT;
+				$$ = $1;
+			}
+			|	map_block	TYPE
+						data_type	COLON	QUOTA
+						stmt_seperator
+			{
+				$1->keytype = $3;
+				$1->objtype = NFT_OBJECT_QUOTA;
+				$1->flags  |= NFT_SET_OBJECT;
 				$$ = $1;
 			}
 			|	map_block	FLAGS		set_flag_list	stmt_seperator
diff --git a/src/rule.c b/src/rule.c
index 9eeb436cd37a..b97213e94954 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -273,7 +273,7 @@ static void set_print_declaration(const struct set *set,
 	const char *type;
 	uint32_t flags;
 
-	if (set->flags & NFT_SET_MAP)
+	if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
 		type = "map";
 	else if (set->flags & NFT_SET_EVAL)
 		type = "flow table";
@@ -293,6 +293,8 @@ static void set_print_declaration(const struct set *set,
 	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
 	if (set->flags & NFT_SET_MAP)
 		printf(" : %s", set->datatype->name);
+	else if (set->flags & NFT_SET_OBJECT)
+		printf(" : %s", obj_type_name(set->objtype));
 
 	printf("%s", opts->stmt_separator);
 
@@ -913,6 +915,7 @@ static int __do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	    set_to_intervals(ctx->msgs, set, expr, true) < 0)
 		return -1;
 
+	expr->set_flags |= set->flags;
 	if (netlink_add_setelems(ctx, h, expr, excl) < 0)
 		return -1;
 
-- 
2.1.4

