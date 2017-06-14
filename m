From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] src: Pass stateless, numeric, ip2name and handle
 variables as structure members.
Date: Thu, 15 Jun 2017 01:01:57 +0530
Message-ID: <59418f32.1623620a.a2188.374c@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35744 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751934AbdFNTcF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 15:32:05 -0400
Received: by mail-pg0-f68.google.com with SMTP id f127so1204381pgc.2
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 12:32:04 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libnftables library will be created soon. So, declare numeric_output,
stateless_output, ip2name_output and handle_output as members of
structure print_ctx, instead of global variables.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/datatype.h   |   8 +--
 include/expression.h |   7 +--
 include/netlink.h    |   1 +
 include/nftables.h   |  15 ++++--
 include/rule.h       |   9 ++--
 include/statement.h  |   5 +-
 src/cli.c            |   2 +-
 src/ct.c             |  10 ++--
 src/datatype.c       |  51 +++++++++---------
 src/evaluate.c       |  72 ++++++++++++++------------
 src/expression.c     |  84 +++++++++++++++---------------
 src/exthdr.c         |   2 +-
 src/fib.c            |   2 +-
 src/hash.c           |   4 +-
 src/main.c           |  25 +++++----
 src/meta.c           |  34 ++++++------
 src/netlink.c        |  38 ++++++++------
 src/numgen.c         |   2 +-
 src/payload.c        |   8 +--
 src/proto.c          |   4 +-
 src/rt.c             |   6 +--
 src/rule.c           | 142 +++++++++++++++++++++++++++------------------------
 src/segtree.c        |   4 +-
 src/statement.c      |  88 +++++++++++++++----------------
 24 files changed, 327 insertions(+), 296 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 04b7d88..748688e 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -145,7 +145,8 @@ struct datatype {
 	const char			*desc;
 	const struct datatype		*basetype;
 	const char			*basefmt;
-	void				(*print)(const struct expr *expr);
+	void				(*print)(const struct expr *expr,
+						 struct print_ctx *ct);
 	struct error_record		*(*parse)(const struct expr *sym,
 						  struct expr **res);
 	const struct symbol_table	*sym_tbl;
@@ -157,7 +158,7 @@ extern const struct datatype *datatype_lookup_byname(const char *name);
 
 extern struct error_record *symbol_parse(const struct expr *sym,
 					 struct expr **res);
-extern void datatype_print(const struct expr *expr);
+extern void datatype_print(const struct expr *expr, struct print_ctx *ct);
 
 static inline bool datatype_equal(const struct datatype *d1,
 				  const struct datatype *d2)
@@ -205,7 +206,8 @@ extern struct error_record *symbolic_constant_parse(const struct expr *sym,
 						    const struct symbol_table *tbl,
 						    struct expr **res);
 extern void symbolic_constant_print(const struct symbol_table *tbl,
-				    const struct expr *expr, bool quotes);
+				    const struct expr *expr, bool quotes,
+				    struct print_ctx *ct);
 extern void symbol_table_print(const struct symbol_table *tbl,
 			       const struct datatype *dtype,
 			       enum byteorder byteorder);
diff --git a/include/expression.h b/include/expression.h
index 9ba87e8..80f91d0 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -157,7 +157,8 @@ struct expr_ops {
 	void			(*set_type)(const struct expr *expr,
 					    const struct datatype *dtype,
 					    enum byteorder byteorder);
-	void			(*print)(const struct expr *expr);
+	void			(*print)(const struct expr *expr,
+					 struct print_ctx *ct);
 	bool			(*cmp)(const struct expr *e1,
 				       const struct expr *e2);
 	void			(*pctx_update)(struct proto_ctx *ctx,
@@ -330,7 +331,7 @@ extern struct expr *expr_alloc(const struct location *loc,
 extern struct expr *expr_clone(const struct expr *expr);
 extern struct expr *expr_get(struct expr *expr);
 extern void expr_free(struct expr *expr);
-extern void expr_print(const struct expr *expr);
+extern void expr_print(const struct expr *expr, struct print_ctx *ct);
 extern bool expr_cmp(const struct expr *e1, const struct expr *e2);
 extern void expr_describe(const struct expr *expr);
 
@@ -410,7 +411,7 @@ extern struct expr *list_expr_alloc(const struct location *loc);
 
 extern struct expr *set_expr_alloc(const struct location *loc);
 extern int set_to_intervals(struct list_head *msgs, struct set *set,
-			    struct expr *init, bool add);
+			    struct expr *init, bool add, struct print_ctx *ct);
 extern void interval_map_decompose(struct expr *set);
 
 extern struct expr *mapping_expr_alloc(const struct location *loc,
diff --git a/include/netlink.h b/include/netlink.h
index 81538ff..0c7cd90 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -213,6 +213,7 @@ struct netlink_mon_handler {
 	struct netlink_ctx	*ctx;
 	const struct location	*loc;
 	bool			cache_needed;
+	struct print_ctx	*ct;
 };
 
 extern int netlink_monitor(struct netlink_mon_handler *monhandler);
diff --git a/include/nftables.h b/include/nftables.h
index 6f54155..1c747d6 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -24,12 +24,16 @@ enum debug_level {
 
 #define INCLUDE_PATHS_MAX	16
 
+struct print_ctx {
+	unsigned int numeric_output;
+	unsigned int stateless_output;
+	unsigned int ip2name_output;
+	unsigned int handle_output;
+};
+
 extern unsigned int max_errors;
-extern unsigned int numeric_output;
-extern unsigned int stateless_output;
-extern unsigned int ip2name_output;
-extern unsigned int handle_output;
 extern unsigned int debug_level;
+
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
 enum nftables_exit_codes {
@@ -107,6 +111,7 @@ struct input_descriptor {
 
 struct parser_state;
 
-int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs);
+int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs,
+	     struct print_ctx *ct);
 
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/include/rule.h b/include/rule.h
index fb46064..48cb5f1 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -195,7 +195,7 @@ struct rule {
 extern struct rule *rule_alloc(const struct location *loc,
 			       const struct handle *h);
 extern void rule_free(struct rule *rule);
-extern void rule_print(const struct rule *rule);
+extern void rule_print(const struct rule *rule, struct print_ctx *ct);
 extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
 
 /**
@@ -244,7 +244,7 @@ extern void set_add_hash(struct set *set, struct table *table);
 extern struct set *set_lookup(const struct table *table, const char *name);
 extern struct set *set_lookup_global(uint32_t family, const char *table,
 				     const char *name);
-extern void set_print(const struct set *set);
+extern void set_print(const struct set *set, struct print_ctx *ct);
 extern void set_print_plain(const struct set *s);
 
 #include <statement.h>
@@ -292,7 +292,7 @@ void obj_free(struct obj *obj);
 void obj_add_hash(struct obj *obj, struct table *table);
 struct obj *obj_lookup(const struct table *table, const char *name,
 		       uint32_t type);
-void obj_print(const struct obj *n);
+void obj_print(const struct obj *n, struct print_ctx *ct);
 void obj_print_plain(const struct obj *obj);
 const char *obj_type_name(uint32_t type);
 
@@ -475,7 +475,8 @@ extern int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd);
 extern struct error_record *rule_postprocess(struct rule *rule);
 
 struct netlink_ctx;
-extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
+extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd,
+		       struct print_ctx *ct);
 
 extern int cache_update(enum cmd_ops cmd, struct list_head *msgs);
 extern void cache_flush(void);
diff --git a/include/statement.h b/include/statement.h
index 317d53e..d6ebc01 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -261,7 +261,8 @@ struct stmt_ops {
 	enum stmt_types		type;
 	const char		*name;
 	void			(*destroy)(struct stmt *stmt);
-	void			(*print)(const struct stmt *stmt);
+	void			(*print)(const struct stmt *stmt,
+					 struct print_ctx *ct);
 };
 
 enum stmt_flags {
@@ -312,7 +313,7 @@ extern struct stmt *stmt_alloc(const struct location *loc,
 int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt);
 extern void stmt_free(struct stmt *stmt);
 extern void stmt_list_free(struct list_head *list);
-extern void stmt_print(const struct stmt *stmt);
+extern void stmt_print(const struct stmt *stmt, struct print_ctx *ct);
 
 const char *get_rate(uint64_t byte_rate, uint64_t *rate);
 
diff --git a/src/cli.c b/src/cli.c
index a74411a..c91eced 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -129,7 +129,7 @@ static void cli_complete(char *line)
 
 	parser_init(state, &msgs);
 	scanner_push_buffer(scanner, &indesc_cli, line);
-	nft_run(scanner, state, &msgs);
+	nft_run(scanner, state, &msgs, NULL);
 	erec_print_list(stdout, &msgs);
 	xfree(line);
 	cache_release();
diff --git a/src/ct.c b/src/ct.c
index ab50a16..46628cb 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -132,7 +132,7 @@ static struct symbol_table *ct_label_tbl;
 
 #define CT_LABEL_BIT_SIZE 128
 
-static void ct_label_type_print(const struct expr *expr)
+static void ct_label_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	unsigned long bit = mpz_scan1(expr->value, 0);
 	const struct symbolic_constant *s;
@@ -286,7 +286,7 @@ static void ct_print(enum nft_ct_keys key, int8_t dir)
 	printf("%s", ct_templates[key].token);
 }
 
-static void ct_expr_print(const struct expr *expr)
+static void ct_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
 	ct_print(expr->ct.key, expr->ct.direction);
 }
@@ -442,11 +442,11 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 	}
 }
 
-static void ct_stmt_print(const struct stmt *stmt)
+static void ct_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	ct_print(stmt->ct.key, stmt->ct.direction);
 	printf(" set ");
-	expr_print(stmt->ct.expr);
+	expr_print(stmt->ct.expr, ct);
 }
 
 static const struct stmt_ops ct_stmt_ops = {
@@ -469,7 +469,7 @@ struct stmt *ct_stmt_alloc(const struct location *loc, enum nft_ct_keys key,
 	return stmt;
 }
 
-static void notrack_stmt_print(const struct stmt *stmt)
+static void notrack_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	printf("notrack");
 }
diff --git a/src/datatype.c b/src/datatype.c
index d2eed76..2fa1a48 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -79,16 +79,16 @@ const struct datatype *datatype_lookup_byname(const char *name)
 	return NULL;
 }
 
-void datatype_print(const struct expr *expr)
+void datatype_print(const struct expr *expr, struct print_ctx *ct)
 {
 	const struct datatype *dtype = expr->dtype;
 
 	do {
 		if (dtype->print != NULL)
-			return dtype->print(expr);
+			return dtype->print(expr, ct);
 		if (dtype->sym_tbl != NULL)
 			return symbolic_constant_print(dtype->sym_tbl, expr,
-						       false);
+						       false, ct);
 	} while ((dtype = dtype->basetype));
 
 	BUG("datatype %s has no print method or symbol table\n",
@@ -156,7 +156,8 @@ out:
 }
 
 void symbolic_constant_print(const struct symbol_table *tbl,
-			     const struct expr *expr, bool quotes)
+			     const struct expr *expr, bool quotes,
+			     struct print_ctx *ct)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	const struct symbolic_constant *s;
@@ -173,12 +174,12 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 	}
 
 	if (s->identifier == NULL)
-		return expr_basetype(expr)->print(expr);
+		return expr_basetype(expr)->print(expr, ct);
 
 	if (quotes)
 		printf("\"");
 
-	if (numeric_output > NUMERIC_ALL)
+	if (ct->numeric_output > NUMERIC_ALL)
 		printf("%"PRIu64"", val);
 	else
 		printf("%s", s->identifier);
@@ -219,7 +220,7 @@ void symbol_table_print(const struct symbol_table *tbl,
 	}
 }
 
-static void invalid_type_print(const struct expr *expr)
+static void invalid_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	gmp_printf("0x%Zx [invalid type]", expr->value);
 }
@@ -231,7 +232,7 @@ const struct datatype invalid_type = {
 	.print		= invalid_type_print,
 };
 
-static void verdict_type_print(const struct expr *expr)
+static void verdict_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	switch (expr->verdict) {
 	case NFT_CONTINUE:
@@ -299,7 +300,7 @@ const struct datatype bitmask_type = {
 	.basetype	= &integer_type,
 };
 
-static void integer_type_print(const struct expr *expr)
+static void integer_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	const struct datatype *dtype = expr->dtype;
 	const char *fmt = "%Zu";
@@ -341,7 +342,7 @@ const struct datatype integer_type = {
 	.parse		= integer_type_parse,
 };
 
-static void string_type_print(const struct expr *expr)
+static void string_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	char data[len+1];
@@ -370,7 +371,7 @@ const struct datatype string_type = {
 	.parse		= string_type_parse,
 };
 
-static void lladdr_type_print(const struct expr *expr)
+static void lladdr_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	const char *delim = "";
@@ -419,7 +420,7 @@ const struct datatype lladdr_type = {
 	.parse		= lladdr_type_parse,
 };
 
-static void ipaddr_type_print(const struct expr *expr)
+static void ipaddr_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	struct sockaddr_in sin = { .sin_family = AF_INET, };
 	char buf[NI_MAXHOST];
@@ -428,7 +429,7 @@ static void ipaddr_type_print(const struct expr *expr)
 	sin.sin_addr.s_addr = mpz_get_be32(expr->value);
 	err = getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			  sizeof(buf), NULL, 0,
-			  ip2name_output ? 0 : NI_NUMERICHOST);
+			  ct->ip2name_output ? 0 : NI_NUMERICHOST);
 	if (err != 0) {
 		getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
@@ -475,7 +476,7 @@ const struct datatype ipaddr_type = {
 	.flags		= DTYPE_F_PREFIX,
 };
 
-static void ip6addr_type_print(const struct expr *expr)
+static void ip6addr_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	struct sockaddr_in6 sin6 = { .sin6_family = AF_INET6 };
 	char buf[NI_MAXHOST];
@@ -486,7 +487,7 @@ static void ip6addr_type_print(const struct expr *expr)
 
 	err = getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			  sizeof(buf), NULL, 0,
-			  ip2name_output ? 0 : NI_NUMERICHOST);
+			  ct->ip2name_output ? 0 : NI_NUMERICHOST);
 	if (err != 0) {
 		getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
@@ -533,18 +534,18 @@ const struct datatype ip6addr_type = {
 	.flags		= DTYPE_F_PREFIX,
 };
 
-static void inet_protocol_type_print(const struct expr *expr)
+static void inet_protocol_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	struct protoent *p;
 
-	if (numeric_output < NUMERIC_ALL) {
+	if (ct->numeric_output < NUMERIC_ALL) {
 		p = getprotobynumber(mpz_get_uint8(expr->value));
 		if (p != NULL) {
 			printf("%s", p->p_name);
 			return;
 		}
 	}
-	integer_type_print(expr);
+	integer_type_print(expr, ct);
 }
 
 static struct error_record *inet_protocol_type_parse(const struct expr *sym,
@@ -586,13 +587,13 @@ const struct datatype inet_protocol_type = {
 	.parse		= inet_protocol_type_parse,
 };
 
-static void inet_service_type_print(const struct expr *expr)
+static void inet_service_type_print(const struct expr *expr, struct print_ctx *ct)
 {
-	if (numeric_output >= NUMERIC_PORT) {
-		integer_type_print(expr);
+	if (ct->numeric_output >= NUMERIC_PORT) {
+		integer_type_print(expr, ct);
 		return;
 	}
-	symbolic_constant_print(&inet_service_tbl, expr, false);
+	symbolic_constant_print(&inet_service_tbl, expr, false, ct);
 }
 
 static struct error_record *inet_service_type_parse(const struct expr *sym,
@@ -711,9 +712,9 @@ static void __exit mark_table_exit(void)
 	rt_symbol_table_free(mark_tbl);
 }
 
-static void mark_type_print(const struct expr *expr)
+static void mark_type_print(const struct expr *expr, struct print_ctx *ct)
 {
-	return symbolic_constant_print(mark_tbl, expr, true);
+	return symbolic_constant_print(mark_tbl, expr, true, ct);
 }
 
 static struct error_record *mark_type_parse(const struct expr *sym,
@@ -913,7 +914,7 @@ struct error_record *time_parse(const struct location *loc, const char *str,
 }
 
 
-static void time_type_print(const struct expr *expr)
+static void time_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	time_print(mpz_get_uint64(expr->value) / MSEC_PER_SEC);
 }
diff --git a/src/evaluate.c b/src/evaluate.c
index 311c86c..f37cbc8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -30,7 +30,8 @@
 #include <utils.h>
 #include <xt.h>
 
-static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
+static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr,
+			  struct print_ctx *ct);
 
 static const char *byteorder_names[] = {
 	[BYTEORDER_INVALID]		= "invalid",
@@ -130,7 +131,7 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 	else {
 		op = byteorder_conversion_op(*expr, byteorder);
 		*expr = unary_expr_alloc(&(*expr)->location, op, *expr);
-		if (expr_evaluate(ctx, expr) < 0)
+		if (expr_evaluate(ctx, expr, NULL) < 0)
 			return -1;
 	}
 	return 0;
@@ -200,7 +201,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 	expr_free(*expr);
 	*expr = new;
 
-	return expr_evaluate(ctx, expr);
+	return expr_evaluate(ctx, expr, NULL);
 }
 
 static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
@@ -716,7 +717,7 @@ static int expr_evaluate_prefix(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *prefix = *expr, *base, *and, *mask;
 
-	if (expr_evaluate(ctx, &prefix->prefix) < 0)
+	if (expr_evaluate(ctx, &prefix->prefix, NULL) < 0)
 		return -1;
 	base = prefix->prefix;
 
@@ -755,7 +756,7 @@ static int expr_evaluate_prefix(struct eval_ctx *ctx, struct expr **expr)
 	}
 	and  = binop_expr_alloc(&prefix->location, OP_AND, base, mask);
 	prefix->prefix = and;
-	if (expr_evaluate(ctx, &prefix->prefix) < 0)
+	if (expr_evaluate(ctx, &prefix->prefix, NULL) < 0)
 		return -1;
 	base = prefix->prefix;
 	assert(expr_is_constant(base));
@@ -774,7 +775,7 @@ static int expr_evaluate_range_expr(struct eval_ctx *ctx,
 				    const struct expr *range,
 				    struct expr **expr)
 {
-	if (expr_evaluate(ctx, expr) < 0)
+	if (expr_evaluate(ctx, expr, NULL) < 0)
 		return -1;
 
 	if (expr_basetype(*expr)->type != TYPE_INTEGER)
@@ -817,7 +818,7 @@ static int expr_evaluate_unary(struct eval_ctx *ctx, struct expr **expr)
 	struct expr *unary = *expr, *arg;
 	enum byteorder byteorder;
 
-	if (expr_evaluate(ctx, &unary->arg) < 0)
+	if (expr_evaluate(ctx, &unary->arg, NULL) < 0)
 		return -1;
 	arg = unary->arg;
 
@@ -899,7 +900,7 @@ static int constant_binop_simplify(struct eval_ctx *ctx, struct expr **expr)
 	mpz_clear(mask);
 	mpz_clear(val);
 
-	return expr_evaluate(ctx, expr);
+	return expr_evaluate(ctx, expr, NULL);
 }
 
 static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
@@ -957,13 +958,13 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	struct expr *op = *expr, *left, *right;
 	const char *sym = expr_op_symbols[op->op];
 
-	if (expr_evaluate(ctx, &op->left) < 0)
+	if (expr_evaluate(ctx, &op->left, NULL) < 0)
 		return -1;
 	left = op->left;
 
 	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT)
 		expr_set_context(&ctx->ectx, &integer_type, ctx->ectx.len);
-	if (expr_evaluate(ctx, &op->right) < 0)
+	if (expr_evaluate(ctx, &op->right, NULL) < 0)
 		return -1;
 	right = op->right;
 
@@ -1018,7 +1019,7 @@ static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
 
 	assert(*expr != next);
 	list_del(&(*expr)->list);
-	err = expr_evaluate(ctx, expr);
+	err = expr_evaluate(ctx, expr, NULL);
 	list_add_tail(&(*expr)->list, &next->list);
 	return err;
 }
@@ -1107,7 +1108,7 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *elem = *expr;
 
-	if (expr_evaluate(ctx, &elem->key) < 0)
+	if (expr_evaluate(ctx, &elem->key, NULL) < 0)
 		return -1;
 
 	if (ctx->set &&
@@ -1183,7 +1184,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	struct expr *map = *expr, *mappings;
 
 	expr_set_context(&ctx->ectx, NULL, 0);
-	if (expr_evaluate(ctx, &map->map) < 0)
+	if (expr_evaluate(ctx, &map->map, NULL) < 0)
 		return -1;
 	if (expr_is_constant(map->map))
 		return expr_error(ctx->msgs, map->map,
@@ -1207,14 +1208,14 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		map->mappings = mappings;
 
 		ctx->set = mappings->set;
-		if (expr_evaluate(ctx, &map->mappings->set->init) < 0)
+		if (expr_evaluate(ctx, &map->mappings->set->init, NULL) < 0)
 			return -1;
 		ctx->set = NULL;
 
 		map->mappings->set->flags |= map->mappings->set->init->set_flags;
 		break;
 	case EXPR_SYMBOL:
-		if (expr_evaluate(ctx, &map->mappings) < 0)
+		if (expr_evaluate(ctx, &map->mappings, NULL) < 0)
 			return -1;
 		if (map->mappings->ops->type != EXPR_SET_REF ||
 		    !(map->mappings->set->flags & NFT_SET_MAP))
@@ -1256,7 +1257,7 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 		return set_error(ctx, set, "set is not a map");
 
 	expr_set_context(&ctx->ectx, set->keytype, set->keylen);
-	if (expr_evaluate(ctx, &mapping->left) < 0)
+	if (expr_evaluate(ctx, &mapping->left, NULL) < 0)
 		return -1;
 	if (!expr_is_constant(mapping->left))
 		return expr_error(ctx->msgs, mapping->left,
@@ -1264,7 +1265,7 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	mapping->flags |= mapping->left->flags & EXPR_F_SINGLETON;
 
 	expr_set_context(&ctx->ectx, set->datatype, set->datalen);
-	if (expr_evaluate(ctx, &mapping->right) < 0)
+	if (expr_evaluate(ctx, &mapping->right, NULL) < 0)
 		return -1;
 	if (!expr_is_constant(mapping->right))
 		return expr_error(ctx->msgs, mapping->right,
@@ -1314,7 +1315,7 @@ static int expr_evaluate_hash(struct eval_ctx *ctx, struct expr **exprp)
 
 	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr->hash.expr &&
-	    expr_evaluate(ctx, &expr->hash.expr) < 0)
+	    expr_evaluate(ctx, &expr->hash.expr, NULL) < 0)
 		return -1;
 
 	/* expr_evaluate_primary() sets the context to what to the input
@@ -1374,7 +1375,7 @@ static int binop_transfer_one(struct eval_ctx *ctx,
 		BUG("invalid binary operation %u\n", left->op);
 	}
 
-	return expr_evaluate(ctx, right);
+	return expr_evaluate(ctx, right, NULL);
 }
 
 static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
@@ -1489,11 +1490,11 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *rel = *expr, *left, *right;
 
-	if (expr_evaluate(ctx, &rel->left) < 0)
+	if (expr_evaluate(ctx, &rel->left, NULL) < 0)
 		return -1;
 	left = rel->left;
 
-	if (expr_evaluate(ctx, &rel->right) < 0)
+	if (expr_evaluate(ctx, &rel->right, NULL) < 0)
 		return -1;
 	right = rel->right;
 
@@ -1691,14 +1692,15 @@ static int expr_evaluate_fib(struct eval_ctx *ctx, struct expr **exprp)
 	return expr_evaluate_primary(ctx, exprp);
 }
 
-static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
+static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr,
+			  struct print_ctx *ct)
 {
 #ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &(*expr)->location,
 				   "Evaluate %s", (*expr)->ops->name);
-		erec_print(stdout, erec); expr_print(*expr); printf("\n\n");
+		erec_print(stdout, erec); expr_print(*expr, ct); printf("\n\n");
 	}
 #endif
 
@@ -1756,7 +1758,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 static int stmt_evaluate_expr(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
-	return expr_evaluate(ctx, &stmt->expr);
+	return expr_evaluate(ctx, &stmt->expr, NULL);
 }
 
 static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
@@ -1764,7 +1766,7 @@ static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 			     enum byteorder byteorder, struct expr **expr)
 {
 	__expr_set_context(&ctx->ectx, dtype, byteorder, len, 0);
-	if (expr_evaluate(ctx, expr) < 0)
+	if (expr_evaluate(ctx, expr, NULL) < 0)
 		return -1;
 
 	if (!datatype_equal((*expr)->dtype, dtype))
@@ -1919,7 +1921,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 	binop->len		= mask->len;
 	stmt->payload.val = binop;
 
-	return expr_evaluate(ctx, &stmt->payload.val);
+	return expr_evaluate(ctx, &stmt->payload.val, NULL);
 }
 
 static int stmt_evaluate_flow(struct eval_ctx *ctx, struct stmt *stmt)
@@ -1927,7 +1929,7 @@ static int stmt_evaluate_flow(struct eval_ctx *ctx, struct stmt *stmt)
 	struct expr *key, *set, *setref;
 
 	expr_set_context(&ctx->ectx, NULL, 0);
-	if (expr_evaluate(ctx, &stmt->flow.key) < 0)
+	if (expr_evaluate(ctx, &stmt->flow.key, NULL) < 0)
 		return -1;
 	if (expr_is_constant(stmt->flow.key))
 		return expr_error(ctx->msgs, stmt->flow.key,
@@ -2549,7 +2551,7 @@ static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	expr_set_context(&ctx->ectx, NULL, 0);
-	if (expr_evaluate(ctx, &stmt->set.set) < 0)
+	if (expr_evaluate(ctx, &stmt->set.set, NULL) < 0)
 		return -1;
 	if (stmt->set.set->ops->type != EXPR_SET_REF)
 		return expr_error(ctx->msgs, stmt->set.set,
@@ -2577,7 +2579,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 	struct expr *mappings;
 
 	expr_set_context(&ctx->ectx, NULL, 0);
-	if (expr_evaluate(ctx, &map->map) < 0)
+	if (expr_evaluate(ctx, &map->map, NULL) < 0)
 		return -1;
 	if (expr_is_constant(map->map))
 		return expr_error(ctx->msgs, map->map,
@@ -2600,14 +2602,14 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 		map->mappings = mappings;
 
 		ctx->set = mappings->set;
-		if (expr_evaluate(ctx, &map->mappings->set->init) < 0)
+		if (expr_evaluate(ctx, &map->mappings->set->init, NULL) < 0)
 			return -1;
 		ctx->set = NULL;
 
 		map->mappings->set->flags |=
 			map->mappings->set->init->set_flags;
 	case EXPR_SYMBOL:
-		if (expr_evaluate(ctx, &map->mappings) < 0)
+		if (expr_evaluate(ctx, &map->mappings, NULL) < 0)
 			return -1;
 		if (map->mappings->ops->type != EXPR_SET_REF ||
 		    !(map->mappings->set->flags & NFT_SET_OBJECT))
@@ -2662,7 +2664,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &stmt->location,
 				   "Evaluate %s", stmt->ops->name);
-		erec_print(stdout, erec); stmt_print(stmt); printf("\n\n");
+		erec_print(stdout, erec); stmt_print(stmt, NULL);
+		printf("\n\n");
 	}
 #endif
 
@@ -2726,7 +2729,7 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 
 	ctx->set = set;
 	expr_set_context(&ctx->ectx, set->keytype, set->keylen);
-	if (expr_evaluate(ctx, expr) < 0)
+	if (expr_evaluate(ctx, expr, NULL) < 0)
 		return -1;
 	ctx->set = NULL;
 	return 0;
@@ -2770,7 +2773,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	ctx->set = set;
 	if (set->init != NULL) {
 		expr_set_context(&ctx->ectx, set->keytype, set->keylen);
-		if (expr_evaluate(ctx, &set->init) < 0)
+		if (expr_evaluate(ctx, &set->init, NULL) < 0)
 			return -1;
 	}
 	ctx->set = NULL;
@@ -3320,6 +3323,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 #ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
+
 		erec = erec_create(EREC_INFORMATIONAL, &cmd->location,
 				   "Evaluate %s", cmd_op_to_name(cmd->op));
 		erec_print(stdout, erec); printf("\n\n");
diff --git a/src/expression.c b/src/expression.c
index 4fef830..4249fe8 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -70,9 +70,9 @@ void expr_free(struct expr *expr)
 	xfree(expr);
 }
 
-void expr_print(const struct expr *expr)
+void expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	expr->ops->print(expr);
+	expr->ops->print(expr, ct);
 }
 
 bool expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -160,9 +160,9 @@ int __fmtstring(4, 5) expr_binary_error(struct list_head *msgs,
 	return -1;
 }
 
-static void verdict_expr_print(const struct expr *expr)
+static void verdict_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	datatype_print(expr);
+	datatype_print(expr, ct);
 }
 
 static bool verdict_expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -213,7 +213,7 @@ struct expr *verdict_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void symbol_expr_print(const struct expr *expr)
+static void symbol_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
 	printf("%s%s", expr->scope != NULL ? "$" : "", expr->identifier);
 }
@@ -252,9 +252,9 @@ struct expr *symbol_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void constant_expr_print(const struct expr *expr)
+static void constant_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	datatype_print(expr);
+	datatype_print(expr, ct);
 }
 
 static bool constant_expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -394,9 +394,9 @@ struct expr *bitmask_expr_to_binops(struct expr *expr)
 	return binop;
 }
 
-static void prefix_expr_print(const struct expr *expr)
+static void prefix_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	expr_print(expr->prefix);
+	expr_print(expr->prefix, ct);
 	printf("/%u", expr->prefix_len);
 }
 
@@ -458,9 +458,9 @@ const char *expr_op_symbols[] = {
 	[OP_LOOKUP]	= NULL,
 };
 
-static void unary_expr_print(const struct expr *expr)
+static void unary_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	expr_print(expr->arg);
+	expr_print(expr->arg, ct);
 }
 
 static void unary_expr_clone(struct expr *new, const struct expr *expr)
@@ -501,7 +501,8 @@ static uint8_t expr_binop_precedence[OP_MAX + 1] = {
 	[OP_OR]		= 4,
 };
 
-static void binop_arg_print(const struct expr *op, const struct expr *arg)
+static void binop_arg_print(const struct expr *op, const struct expr *arg,
+			     struct print_ctx *ct)
 {
 	bool prec = false;
 
@@ -512,7 +513,7 @@ static void binop_arg_print(const struct expr *op, const struct expr *arg)
 
 	if (prec)
 		printf("(");
-	expr_print(arg);
+	expr_print(arg, ct);
 	if (prec)
 		printf(")");
 }
@@ -526,9 +527,9 @@ static bool must_print_eq_op(const struct expr *expr)
 	return expr->left->ops->type == EXPR_BINOP;
 }
 
-static void binop_expr_print(const struct expr *expr)
+static void binop_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	binop_arg_print(expr, expr->left);
+	binop_arg_print(expr, expr->left, ct);
 
 	if (expr_op_symbols[expr->op] &&
 	    (expr->op != OP_EQ || must_print_eq_op(expr)))
@@ -536,7 +537,7 @@ static void binop_expr_print(const struct expr *expr)
 	else
 		printf(" ");
 
-	binop_arg_print(expr, expr->right);
+	binop_arg_print(expr, expr->right, ct);
 }
 
 static void binop_expr_clone(struct expr *new, const struct expr *expr)
@@ -596,13 +597,13 @@ struct expr *relational_expr_alloc(const struct location *loc, enum ops op,
 	return expr;
 }
 
-static void range_expr_print(const struct expr *expr)
+static void range_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	numeric_output += NUMERIC_ALL + 1;
-	expr_print(expr->left);
+	ct->numeric_output += NUMERIC_ALL + 1;
+	expr_print(expr->left, ct);
 	printf("-");
-	expr_print(expr->right);
-	numeric_output -= NUMERIC_ALL + 1;
+	expr_print(expr->right, ct);
+	ct->numeric_output -= NUMERIC_ALL + 1;
 }
 
 static void range_expr_clone(struct expr *new, const struct expr *expr)
@@ -673,14 +674,15 @@ static void compound_expr_destroy(struct expr *expr)
 		expr_free(i);
 }
 
-static void compound_expr_print(const struct expr *expr, const char *delim)
+static void compound_expr_print(const struct expr *expr, const char *delim,
+				struct print_ctx *ct)
 {
 	const struct expr *i;
 	const char *d = "";
 
 	list_for_each_entry(i, &expr->expressions, list) {
 		printf("%s", d);
-		expr_print(i);
+		expr_print(i, ct);
 		d = delim;
 	}
 }
@@ -703,9 +705,9 @@ static void concat_expr_destroy(struct expr *expr)
 	compound_expr_destroy(expr);
 }
 
-static void concat_expr_print(const struct expr *expr)
+static void concat_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	compound_expr_print(expr, " . ");
+	compound_expr_print(expr, " . ", ct);
 }
 
 static const struct expr_ops concat_expr_ops = {
@@ -721,9 +723,9 @@ struct expr *concat_expr_alloc(const struct location *loc)
 	return compound_expr_alloc(loc, &concat_expr_ops);
 }
 
-static void list_expr_print(const struct expr *expr)
+static void list_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	compound_expr_print(expr, ",");
+	compound_expr_print(expr, ",", ct);
 }
 
 static const struct expr_ops list_expr_ops = {
@@ -784,7 +786,7 @@ static const char *calculate_delim(const struct expr *expr, int *count)
 	return newline;
 }
 
-static void set_expr_print(const struct expr *expr)
+static void set_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
 	const struct expr *i;
 	const char *d = "";
@@ -794,7 +796,7 @@ static void set_expr_print(const struct expr *expr)
 
 	list_for_each_entry(i, &expr->expressions, list) {
 		printf("%s", d);
-		expr_print(i);
+		expr_print(i, ct);
 		count++;
 		d = calculate_delim(expr, &count);
 	}
@@ -826,11 +828,11 @@ struct expr *set_expr_alloc(const struct location *loc)
 	return compound_expr_alloc(loc, &set_expr_ops);
 }
 
-static void mapping_expr_print(const struct expr *expr)
+static void mapping_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	expr_print(expr->left);
+	expr_print(expr->left, ct);
 	printf(" : ");
-	expr_print(expr->right);
+	expr_print(expr->right, ct);
 }
 
 static void mapping_expr_set_type(const struct expr *expr,
@@ -873,15 +875,15 @@ struct expr *mapping_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void map_expr_print(const struct expr *expr)
+static void map_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	expr_print(expr->map);
+	expr_print(expr->map, ct);
 	if (expr->mappings->ops->type == EXPR_SET_REF &&
 	    expr->mappings->set->datatype->type == TYPE_VERDICT)
 		printf(" vmap ");
 	else
 		printf(" map ");
-	expr_print(expr->mappings);
+	expr_print(expr->mappings, ct);
 }
 
 static void map_expr_clone(struct expr *new, const struct expr *expr)
@@ -915,13 +917,13 @@ struct expr *map_expr_alloc(const struct location *loc, struct expr *arg,
 	return expr;
 }
 
-static void set_ref_expr_print(const struct expr *expr)
+static void set_ref_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
 	if (expr->set->flags & NFT_SET_ANONYMOUS) {
 		if (expr->set->flags & NFT_SET_EVAL)
 			printf("table %s", expr->set->handle.set);
 		else
-			expr_print(expr->set->init);
+			expr_print(expr->set->init, ct);
 	} else {
 		printf("@%s", expr->set->handle.set);
 	}
@@ -955,14 +957,14 @@ struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 	return expr;
 }
 
-static void set_elem_expr_print(const struct expr *expr)
+static void set_elem_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
-	expr_print(expr->key);
+	expr_print(expr->key, ct);
 	if (expr->timeout) {
 		printf(" timeout ");
 		time_print(expr->timeout / 1000);
 	}
-	if (!stateless_output && expr->expiration) {
+	if (!ct->stateless_output && expr->expiration) {
 		printf(" expires ");
 		time_print(expr->expiration / 1000);
 	}
@@ -971,7 +973,7 @@ static void set_elem_expr_print(const struct expr *expr)
 
 	if (expr->stmt) {
 		printf(" : ");
-		stmt_print(expr->stmt);
+		stmt_print(expr->stmt, ct);
 	}
 }
 
diff --git a/src/exthdr.c b/src/exthdr.c
index c8599f2..51cd342 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -22,7 +22,7 @@
 #include <headers.h>
 #include <expression.h>
 
-static void exthdr_expr_print(const struct expr *expr)
+static void exthdr_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
 	if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT) {
 		/* Offset calcualtion is a bit hacky at this point.
diff --git a/src/fib.c b/src/fib.c
index 28ef4b5..411ccff 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -71,7 +71,7 @@ static void __fib_expr_print_f(unsigned int *flags, unsigned int f, const char *
 		printf(" . ");
 }
 
-static void fib_expr_print(const struct expr *expr)
+static void fib_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
 	unsigned int flags = expr->fib.flags & ~NFTA_FIB_F_PRESENT;
 
diff --git a/src/hash.c b/src/hash.c
index c738d0b..7424481 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -15,7 +15,7 @@
 #include <hash.h>
 #include <utils.h>
 
-static void hash_expr_print(const struct expr *expr)
+static void hash_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
 	switch (expr->hash.type) {
 	case NFT_HASH_SYM:
@@ -24,7 +24,7 @@ static void hash_expr_print(const struct expr *expr)
 	case NFT_HASH_JENKINS:
 	default:
 		printf("jhash ");
-		expr_print(expr->hash.expr);
+		expr_print(expr->hash.expr, ct);
 	}
 
 	printf(" mod %u", expr->hash.mod);
diff --git a/src/main.c b/src/main.c
index 5089ff2..e139cad 100644
--- a/src/main.c
+++ b/src/main.c
@@ -28,11 +28,8 @@
 #include <iface.h>
 #include <cli.h>
 
+struct print_ctx ct;
 unsigned int max_errors = 10;
-unsigned int numeric_output;
-unsigned int stateless_output;
-unsigned int ip2name_output;
-unsigned int handle_output;
 #ifdef DEBUG
 unsigned int debug_level;
 #endif
@@ -178,7 +175,8 @@ static const struct input_descriptor indesc_cmdline = {
 	.name	= "<cmdline>",
 };
 
-static int nft_netlink(struct parser_state *state, struct list_head *msgs)
+static int nft_netlink(struct parser_state *state, struct list_head *msgs,
+			struct print_ctx *ct)
 {
 	struct nftnl_batch *batch;
 	struct netlink_ctx ctx;
@@ -199,7 +197,7 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 		ctx.batch = batch;
 		ctx.batch_supported = batch_supported;
 		init_list_head(&ctx.list);
-		ret = do_command(&ctx, cmd);
+		ret = do_command(&ctx, cmd, ct);
 		if (ret < 0)
 			goto out;
 	}
@@ -231,7 +229,8 @@ out:
 	return ret;
 }
 
-int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
+int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs,
+	     struct print_ctx *ct)
 {
 	struct cmd *cmd, *next;
 	int ret;
@@ -241,7 +240,7 @@ int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 		ret = -1;
 		goto err1;
 	}
-	ret = nft_netlink(state, msgs);
+	ret = nft_netlink(state, msgs, ct);
 err1:
 	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
 		list_del(&cmd->list);
@@ -290,7 +289,7 @@ int main(int argc, char * const *argv)
 			include_paths[num_include_paths++] = optarg;
 			break;
 		case OPT_NUMERIC:
-			if (++numeric_output > NUMERIC_ALL) {
+			if (++(ct.numeric_output) > NUMERIC_ALL) {
 				fprintf(stderr, "Too many numeric options "
 						"used, max. %u\n",
 					NUMERIC_ALL);
@@ -298,10 +297,10 @@ int main(int argc, char * const *argv)
 			}
 			break;
 		case OPT_STATELESS:
-			stateless_output++;
+			ct.stateless_output++;
 			break;
 		case OPT_IP2NAME:
-			ip2name_output++;
+			ct.ip2name_output++;
 			break;
 #ifdef DEBUG
 		case OPT_DEBUG:
@@ -333,7 +332,7 @@ int main(int argc, char * const *argv)
 			break;
 #endif
 		case OPT_HANDLE_OUTPUT:
-			handle_output++;
+			ct.handle_output++;
 			break;
 		case OPT_INVALID:
 			exit(NFT_EXIT_FAILURE);
@@ -375,7 +374,7 @@ int main(int argc, char * const *argv)
 		exit(NFT_EXIT_FAILURE);
 	}
 
-	if (nft_run(scanner, &state, &msgs) != 0)
+	if (nft_run(scanner, &state, &msgs, &ct) != 0)
 		rc = NFT_EXIT_FAILURE;
 out:
 	scanner_destroy(scanner);
diff --git a/src/meta.c b/src/meta.c
index dd09d49..6580dca 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -47,9 +47,9 @@ static void __exit realm_table_exit(void)
 	rt_symbol_table_free(realm_tbl);
 }
 
-static void realm_type_print(const struct expr *expr)
+static void realm_type_print(const struct expr *expr, struct print_ctx *ct)
 {
-	return symbolic_constant_print(realm_tbl, expr, true);
+	return symbolic_constant_print(realm_tbl, expr, true, ct);
 }
 
 static struct error_record *realm_type_parse(const struct expr *sym,
@@ -70,7 +70,7 @@ static const struct datatype realm_type = {
 	.flags		= DTYPE_F_PREFIX,
 };
 
-static void tchandle_type_print(const struct expr *expr)
+static void tchandle_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	uint32_t handle = mpz_get_uint32(expr->value);
 
@@ -149,7 +149,7 @@ static const struct datatype tchandle_type = {
 	.parse		= tchandle_type_parse,
 };
 
-static void ifindex_type_print(const struct expr *expr)
+static void ifindex_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	char name[IFNAMSIZ];
 	int ifindex;
@@ -222,11 +222,11 @@ const struct datatype arphrd_type = {
 	.sym_tbl	= &arphrd_tbl,
 };
 
-static void uid_type_print(const struct expr *expr)
+static void uid_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	struct passwd *pw;
 
-	if (numeric_output < NUMERIC_ALL) {
+	if (ct->numeric_output < NUMERIC_ALL) {
 		uint32_t uid = mpz_get_uint32(expr->value);
 
 		pw = getpwuid(uid);
@@ -236,7 +236,7 @@ static void uid_type_print(const struct expr *expr)
 			printf("%d", uid);
 		return;
 	}
-	expr_basetype(expr)->print(expr);
+	expr_basetype(expr)->print(expr, ct);
 }
 
 static struct error_record *uid_type_parse(const struct expr *sym,
@@ -274,11 +274,11 @@ static const struct datatype uid_type = {
 	.parse		= uid_type_parse,
 };
 
-static void gid_type_print(const struct expr *expr)
+static void gid_type_print(const struct expr *expr, struct print_ctx *ct)
 {
 	struct group *gr;
 
-	if (numeric_output < NUMERIC_ALL) {
+	if (ct->numeric_output < NUMERIC_ALL) {
 		uint32_t gid = mpz_get_uint32(expr->value);
 
 		gr = getgrgid(gid);
@@ -288,7 +288,7 @@ static void gid_type_print(const struct expr *expr)
 			printf("%u", gid);
 		return;
 	}
-	expr_basetype(expr)->print(expr);
+	expr_basetype(expr)->print(expr, ct);
 }
 
 static struct error_record *gid_type_parse(const struct expr *sym,
@@ -338,9 +338,9 @@ static const struct symbol_table pkttype_type_tbl = {
 	},
 };
 
-static void pkttype_type_print(const struct expr *expr)
+static void pkttype_type_print(const struct expr *expr, struct print_ctx *ct)
 {
-	return symbolic_constant_print(&pkttype_type_tbl, expr, false);
+	return symbolic_constant_print(&pkttype_type_tbl, expr, false, ct);
 }
 
 static const struct datatype pkttype_type = {
@@ -365,9 +365,9 @@ static void __exit devgroup_table_exit(void)
 	rt_symbol_table_free(devgroup_tbl);
 }
 
-static void devgroup_type_print(const struct expr *expr)
+static void devgroup_type_print(const struct expr *expr, struct print_ctx *ct)
 {
-	return symbolic_constant_print(devgroup_tbl, expr, true);
+	return symbolic_constant_print(devgroup_tbl, expr, true, ct);
 }
 
 static struct error_record *devgroup_type_parse(const struct expr *sym,
@@ -464,7 +464,7 @@ static bool meta_key_is_qualified(enum nft_meta_keys key)
 	}
 }
 
-static void meta_expr_print(const struct expr *expr)
+static void meta_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
 	if (meta_key_is_qualified(expr->meta.key))
 		printf("meta %s", meta_templates[expr->meta.key].token);
@@ -591,14 +591,14 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 	return expr;
 }
 
-static void meta_stmt_print(const struct stmt *stmt)
+static void meta_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	if (meta_key_is_qualified(stmt->meta.key))
 		printf("meta %s set ", meta_templates[stmt->meta.key].token);
 	else
 		printf("%s set ", meta_templates[stmt->meta.key].token);
 
-	expr_print(stmt->meta.expr);
+	expr_print(stmt->meta.expr, ct);
 }
 
 static const struct stmt_ops meta_stmt_ops = {
diff --git a/src/netlink.c b/src/netlink.c
index 6fda0b9..72fc2c8 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2261,7 +2261,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 			goto out;
 		}
 		printf("element %s %s %s ", family2str(family), table, setname);
-		expr_print(dummyset->init);
+		expr_print(dummyset->init, monh->ct);
 		printf("\n");
 
 		set_free(dummyset);
@@ -2355,7 +2355,7 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 			nlr_for_each_set(nlr, rule_map_decompose_cb, NULL);
 
 			printf("add rule %s %s %s ", family, table, chain);
-			rule_print(r);
+			rule_print(r, monh->ct);
 			printf("\n");
 
 			rule_free(r);
@@ -2611,7 +2611,7 @@ static void trace_print_hdr(const struct nftnl_trace *nlt)
 }
 
 static void trace_print_expr(const struct nftnl_trace *nlt, unsigned int attr,
-			     struct expr *lhs)
+			     struct expr *lhs, struct print_ctx *ct)
 {
 	struct expr *rhs, *rel;
 	const void *data;
@@ -2623,12 +2623,13 @@ static void trace_print_expr(const struct nftnl_trace *nlt, unsigned int attr,
 				   len * BITS_PER_BYTE, data);
 	rel  = relational_expr_alloc(&netlink_location, OP_EQ, lhs, rhs);
 
-	expr_print(rel);
+	expr_print(rel, ct);
 	printf(" ");
 	expr_free(rel);
 }
 
-static void trace_print_verdict(const struct nftnl_trace *nlt)
+static void trace_print_verdict(const struct nftnl_trace *nlt,
+				 struct print_ctx *ct)
 {
 	const char *chain = NULL;
 	unsigned int verdict;
@@ -2640,11 +2641,12 @@ static void trace_print_verdict(const struct nftnl_trace *nlt)
 	expr = verdict_expr_alloc(&netlink_location, verdict, chain);
 
 	printf("verdict ");
-	expr_print(expr);
+	expr_print(expr, ct);
 	expr_free(expr);
 }
 
-static void trace_print_rule(const struct nftnl_trace *nlt)
+static void trace_print_rule(const struct nftnl_trace *nlt,
+			      struct print_ctx *ct)
 {
 	const struct table *table;
 	uint64_t rule_handle;
@@ -2674,9 +2676,9 @@ static void trace_print_rule(const struct nftnl_trace *nlt)
 
 	trace_print_hdr(nlt);
 	printf("rule ");
-	rule_print(rule);
+	rule_print(rule, ct);
 	printf(" (");
-	trace_print_verdict(nlt);
+	trace_print_verdict(nlt, ct);
 	printf(")\n");
 }
 
@@ -2775,7 +2777,8 @@ next:
 	}
 }
 
-static void trace_print_packet(const struct nftnl_trace *nlt)
+static void trace_print_packet(const struct nftnl_trace *nlt,
+			        struct print_ctx *ct)
 {
 	struct list_head stmts = LIST_HEAD_INIT(stmts);
 	const struct proto_desc *ll_desc;
@@ -2791,11 +2794,11 @@ static void trace_print_packet(const struct nftnl_trace *nlt)
 	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_IIF))
 		trace_print_expr(nlt, NFTNL_TRACE_IIF,
 				 meta_expr_alloc(&netlink_location,
-						 NFT_META_IIF));
+						 NFT_META_IIF), ct);
 	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_OIF))
 		trace_print_expr(nlt, NFTNL_TRACE_OIF,
 				 meta_expr_alloc(&netlink_location,
-						 NFT_META_OIF));
+						 NFT_META_OIF), ct);
 
 	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY));
 	ll_desc = ctx.protocol[PROTO_BASE_LL_HDR].desc;
@@ -2822,7 +2825,7 @@ static void trace_print_packet(const struct nftnl_trace *nlt)
 			PROTO_BASE_TRANSPORT_HDR);
 
 	list_for_each_entry_safe(stmt, next, &stmts, list) {
-		stmt_print(stmt);
+		stmt_print(stmt, ct);
 		printf(" ");
 		stmt_free(stmt);
 	}
@@ -2847,24 +2850,25 @@ static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
 	case NFT_TRACETYPE_RULE:
 		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_LL_HEADER) ||
 		    nftnl_trace_is_set(nlt, NFTNL_TRACE_NETWORK_HEADER))
-			trace_print_packet(nlt);
+			trace_print_packet(nlt, monh->ct);
 
 		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_RULE_HANDLE))
-			trace_print_rule(nlt);
+			trace_print_rule(nlt, monh->ct);
 		break;
 	case NFT_TRACETYPE_POLICY:
 	case NFT_TRACETYPE_RETURN:
 		trace_print_hdr(nlt);
 
 		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_VERDICT)) {
-			trace_print_verdict(nlt);
+			trace_print_verdict(nlt, monh->ct);
 			printf(" ");
 		}
 
 		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_MARK))
 			trace_print_expr(nlt, NFTNL_TRACE_MARK,
 					 meta_expr_alloc(&netlink_location,
-							 NFT_META_MARK));
+							 NFT_META_MARK),
+					 monh->ct);
 		printf("\n");
 		break;
 	}
diff --git a/src/numgen.c b/src/numgen.c
index 5c1d00a..0d0fe85 100644
--- a/src/numgen.c
+++ b/src/numgen.c
@@ -28,7 +28,7 @@ static const char *numgen_type_str(enum nft_ng_types type)
 	return numgen_type[type];
 }
 
-static void numgen_expr_print(const struct expr *expr)
+static void numgen_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
 	printf("numgen %s mod %u", numgen_type_str(expr->numgen.type),
 	       expr->numgen.mod);
diff --git a/src/payload.c b/src/payload.c
index 11b6df3..da20ed5 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -38,7 +38,7 @@ bool payload_is_known(const struct expr *expr)
 	       tmpl != &proto_unknown_template;
 }
 
-static void payload_expr_print(const struct expr *expr)
+static void payload_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
 	const struct proto_desc *desc;
 	const struct proto_hdr_template *tmpl;
@@ -184,11 +184,11 @@ unsigned int payload_hdr_field(const struct expr *expr)
 	return expr->payload.tmpl - expr->payload.desc->templates;
 }
 
-static void payload_stmt_print(const struct stmt *stmt)
+static void payload_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
-	expr_print(stmt->payload.expr);
+	expr_print(stmt->payload.expr, ct);
 	printf(" set ");
-	expr_print(stmt->payload.val);
+	expr_print(stmt->payload.val, ct);
 }
 
 static const struct stmt_ops payload_stmt_ops = {
diff --git a/src/proto.c b/src/proto.c
index 2afedf7..6eaf43c 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -893,9 +893,9 @@ static const struct symbol_table ethertype_tbl = {
 	},
 };
 
-static void ethertype_print(const struct expr *expr)
+static void ethertype_print(const struct expr *expr, struct print_ctx *ct)
 {
-	return symbolic_constant_print(&ethertype_tbl, expr, false);
+	return symbolic_constant_print(&ethertype_tbl, expr, false, ct);
 }
 
 const struct datatype ethertype_type = {
diff --git a/src/rt.c b/src/rt.c
index 232c1dc..e9001ba 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -34,9 +34,9 @@ static void __exit realm_table_exit(void)
 	rt_symbol_table_free(realm_tbl);
 }
 
-static void realm_type_print(const struct expr *expr)
+static void realm_type_print(const struct expr *expr, struct print_ctx *ct)
 {
-	return symbolic_constant_print(realm_tbl, expr, true);
+	return symbolic_constant_print(realm_tbl, expr, true, ct);
 }
 
 static struct error_record *realm_type_parse(const struct expr *sym,
@@ -75,7 +75,7 @@ static const struct rt_template rt_templates[] = {
 					      true),
 };
 
-static void rt_expr_print(const struct expr *expr)
+static void rt_expr_print(const struct expr *expr, struct print_ctx *ct)
 {
 	printf("rt %s", rt_templates[expr->rt.key].token);
 }
diff --git a/src/rule.c b/src/rule.c
index 0d9e393..8bb8719 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -347,19 +347,20 @@ static void set_print_declaration(const struct set *set,
 	}
 }
 
-static void do_set_print(const struct set *set, struct print_fmt_options *opts)
+static void do_set_print(const struct set *set, struct print_fmt_options *opts,
+			  struct print_ctx *ct)
 {
 	set_print_declaration(set, opts);
 
 	if (set->init != NULL && set->init->size > 0) {
 		printf("%s%selements = ", opts->tab, opts->tab);
-		expr_print(set->init);
+		expr_print(set->init, ct);
 		printf("%s", opts->nl);
 	}
 	printf("%s}%s", opts->tab, opts->nl);
 }
 
-void set_print(const struct set *s)
+void set_print(const struct set *s, struct print_ctx *ct)
 {
 	struct print_fmt_options opts = {
 		.tab		= "\t",
@@ -367,7 +368,7 @@ void set_print(const struct set *s)
 		.stmt_separator	= "\n",
 	};
 
-	do_set_print(s, &opts);
+	do_set_print(s, &opts, ct);
 }
 
 void set_print_plain(const struct set *s)
@@ -380,7 +381,7 @@ void set_print_plain(const struct set *s)
 		.stmt_separator	= ";",
 	};
 
-	do_set_print(s, &opts);
+	do_set_print(s, &opts, NULL);
 }
 
 struct rule *rule_alloc(const struct location *loc, const struct handle *h)
@@ -404,12 +405,12 @@ void rule_free(struct rule *rule)
 	xfree(rule);
 }
 
-void rule_print(const struct rule *rule)
+void rule_print(const struct rule *rule, struct print_ctx *ct)
 {
 	const struct stmt *stmt;
 
 	list_for_each_entry(stmt, &rule->stmts, list) {
-		stmt->ops->print(stmt);
+		stmt->ops->print(stmt, ct);
 		if (!list_is_last(&stmt->list, &rule->stmts))
 			printf(" ");
 	}
@@ -417,7 +418,7 @@ void rule_print(const struct rule *rule)
 	if (rule->comment)
 		printf(" comment \"%s\"", rule->comment);
 
-	if (handle_output > 0)
+	if (ct->handle_output > 0)
 		printf(" # handle %" PRIu64, rule->handle.handle.id);
 }
 
@@ -667,7 +668,7 @@ static void chain_print_declaration(const struct chain *chain)
 	}
 }
 
-static void chain_print(const struct chain *chain)
+static void chain_print(const struct chain *chain, struct print_ctx *ct)
 {
 	struct rule *rule;
 
@@ -675,7 +676,7 @@ static void chain_print(const struct chain *chain)
 
 	list_for_each_entry(rule, &chain->rules, list) {
 		printf("\t\t");
-		rule_print(rule);
+		rule_print(rule, ct);
 		printf("\n");
 	}
 	printf("\t}\n");
@@ -774,7 +775,7 @@ static void table_print_options(const struct table *table, const char **delim)
 	}
 }
 
-static void table_print(const struct table *table)
+static void table_print(const struct table *table, struct print_ctx *ct)
 {
 	struct chain *chain;
 	struct obj *obj;
@@ -787,19 +788,19 @@ static void table_print(const struct table *table)
 
 	list_for_each_entry(obj, &table->objs, list) {
 		printf("%s", delim);
-		obj_print(obj);
+		obj_print(obj, ct);
 		delim = "\n";
 	}
 	list_for_each_entry(set, &table->sets, list) {
 		if (set->flags & NFT_SET_ANONYMOUS)
 			continue;
 		printf("%s", delim);
-		set_print(set);
+		set_print(set, ct);
 		delim = "\n";
 	}
 	list_for_each_entry(chain, &table->chains, list) {
 		printf("%s", delim);
-		chain_print(chain);
+		chain_print(chain, ct);
 		delim = "\n";
 	}
 	printf("}\n");
@@ -922,7 +923,7 @@ static int __do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 }
 
 static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			   struct expr *init, bool excl)
+			   struct expr *init, bool excl, struct print_ctx *ct)
 {
 	struct table *table;
 	struct set *set;
@@ -931,18 +932,18 @@ static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	set = set_lookup(table, h->set);
 
 	if (set->flags & NFT_SET_INTERVAL &&
-	    set_to_intervals(ctx->msgs, set, init, true) < 0)
+	    set_to_intervals(ctx->msgs, set, init, true, ct) < 0)
 		return -1;
 
 	return __do_add_setelems(ctx, h, set, init, excl);
 }
 
 static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
-		      struct set *set, bool excl)
+		      struct set *set, bool excl, struct print_ctx *ct)
 {
 	if (set->init != NULL) {
 		if (set->flags & NFT_SET_INTERVAL &&
-		    set_to_intervals(ctx->msgs, set, set->init, true) < 0)
+		    set_to_intervals(ctx->msgs, set, set->init, true, ct) < 0)
 			return -1;
 	}
 	if (netlink_add_set(ctx, h, set, excl) < 0)
@@ -956,7 +957,7 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 
 static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 			const struct location *loc, struct table *table,
-			bool excl)
+			bool excl, struct print_ctx *ct)
 {
 	struct chain *chain;
 	struct obj *obj;
@@ -978,7 +979,7 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 		}
 		list_for_each_entry(set, &table->sets, list) {
 			handle_merge(&set->handle, &table->handle);
-			if (do_add_set(ctx, &set->handle, set, excl) < 0)
+			if (do_add_set(ctx, &set->handle, set, excl, ct) < 0)
 				return -1;
 		}
 		list_for_each_entry(chain, &table->chains, list) {
@@ -989,12 +990,13 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 	return 0;
 }
 
-static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
+static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl,
+			   struct print_ctx *ct)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
 		return do_add_table(ctx, &cmd->handle, &cmd->location,
-				    cmd->table, excl);
+				    cmd->table, excl, ct);
 	case CMD_OBJ_CHAIN:
 		return do_add_chain(ctx, &cmd->handle, &cmd->location,
 				    cmd->chain, excl);
@@ -1002,9 +1004,9 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 		return netlink_add_rule_batch(ctx, &cmd->handle,
 					      cmd->rule, NLM_F_APPEND);
 	case CMD_OBJ_SET:
-		return do_add_set(ctx, &cmd->handle, cmd->set, excl);
+		return do_add_set(ctx, &cmd->handle, cmd->set, excl, ct);
 	case CMD_OBJ_SETELEM:
-		return do_add_setelems(ctx, &cmd->handle, cmd->expr, excl);
+		return do_add_setelems(ctx, &cmd->handle, cmd->expr, excl, ct);
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
@@ -1040,7 +1042,7 @@ static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 }
 
 static int do_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			      struct expr *expr)
+			      struct expr *expr, struct print_ctx *ct)
 {
 	struct table *table;
 	struct set *set;
@@ -1049,7 +1051,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	set = set_lookup(table, h->set);
 
 	if (set->flags & NFT_SET_INTERVAL &&
-	    set_to_intervals(ctx->msgs, set, expr, false) < 0)
+	    set_to_intervals(ctx->msgs, set, expr, false, ct) < 0)
 		return -1;
 
 	if (netlink_delete_setelems(ctx, h, expr) < 0)
@@ -1058,7 +1060,8 @@ static int do_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	return 0;
 }
 
-static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
+static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd,
+			      struct print_ctx *ct)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
@@ -1071,7 +1074,7 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 		return netlink_delete_set(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_SETELEM:
-		return do_delete_setelems(ctx, &cmd->handle, cmd->expr);
+		return do_delete_setelems(ctx, &cmd->handle, cmd->expr, ct);
 	case CMD_OBJ_COUNTER:
 		return netlink_delete_obj(ctx, &cmd->handle, &cmd->location,
 					  NFT_OBJECT_COUNTER);
@@ -1104,9 +1107,9 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 }
 
 static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
-			 struct table *table)
+			 struct table *table, struct print_ctx *ct)
 {
-	table_print(table);
+	table_print(table, ct);
 	return 0;
 }
 
@@ -1194,13 +1197,13 @@ static void print_proto_name_proto(uint8_t l4)
 }
 
 static void obj_print_data(const struct obj *obj,
-			   struct print_fmt_options *opts)
+			   struct print_fmt_options *opts, struct print_ctx *ct)
 {
 	switch (obj->type) {
 	case NFT_OBJECT_COUNTER:
 		printf(" %s {%s%s%s", obj->handle.obj,
 				      opts->nl, opts->tab, opts->tab);
-		if (stateless_output) {
+		if (ct->stateless_output) {
 			printf("packets 0 bytes 0");
 			break;
 		}
@@ -1217,7 +1220,7 @@ static void obj_print_data(const struct obj *obj,
 		printf("%s%"PRIu64" %s",
 		       obj->quota.flags & NFT_QUOTA_F_INV ? "over " : "",
 		       bytes, data_unit);
-		if (!stateless_output && obj->quota.used) {
+		if (!ct->stateless_output && obj->quota.used) {
 			data_unit = get_rate(obj->quota.used, &bytes);
 			printf(" used %"PRIu64" %s", bytes, data_unit);
 		}
@@ -1250,7 +1253,8 @@ const char *obj_type_name(enum stmt_types type)
 }
 
 static void obj_print_declaration(const struct obj *obj,
-				  struct print_fmt_options *opts)
+				  struct print_fmt_options *opts,
+				  struct print_ctx *ct)
 {
 	printf("%s%s", opts->tab, obj_type_name(obj->type));
 
@@ -1260,12 +1264,12 @@ static void obj_print_declaration(const struct obj *obj,
 	if (opts->table != NULL)
 		printf(" %s", opts->table);
 
-	obj_print_data(obj, opts);
+	obj_print_data(obj, opts, ct);
 
 	printf("%s%s}%s", opts->nl, opts->tab, opts->nl);
 }
 
-void obj_print(const struct obj *obj)
+void obj_print(const struct obj *obj, struct print_ctx *ct)
 {
 	struct print_fmt_options opts = {
 		.tab		= "\t",
@@ -1273,7 +1277,7 @@ void obj_print(const struct obj *obj)
 		.stmt_separator	= "\n",
 	};
 
-	obj_print_declaration(obj, &opts);
+	obj_print_declaration(obj, &opts, ct);
 }
 
 void obj_print_plain(const struct obj *obj)
@@ -1285,10 +1289,11 @@ void obj_print_plain(const struct obj *obj)
 		.family		= family2str(obj->handle.family),
 	};
 
-	obj_print_declaration(obj, &opts);
+	obj_print_declaration(obj, &opts, NULL);
 }
 
-static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
+static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type,
+			struct print_ctx *ct)
 {
 	struct print_fmt_options opts = {
 		.tab		= "\t",
@@ -1319,7 +1324,7 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 			     strcmp(cmd->handle.obj, obj->handle.obj)))
 				continue;
 
-			obj_print_declaration(obj, &opts);
+			obj_print_declaration(obj, &opts, ct);
 		}
 
 		printf("}\n");
@@ -1327,7 +1332,8 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 	return 0;
 }
 
-static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
+static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd,
+			    struct print_ctx *ct)
 {
 	unsigned int family = cmd->handle.family;
 	struct table *table;
@@ -1340,7 +1346,7 @@ static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 		cmd->handle.family = table->handle.family;
 		cmd->handle.table = xstrdup(table->handle.table);
 
-		if (do_list_table(ctx, cmd, table) < 0)
+		if (do_list_table(ctx, cmd, table, ct) < 0)
 			return -1;
 	}
 
@@ -1372,7 +1378,7 @@ static void table_print_declaration(struct table *table)
 }
 
 static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
-			 struct table *table)
+			 struct table *table, struct print_ctx *ct)
 {
 	struct chain *chain;
 
@@ -1383,7 +1389,7 @@ static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
 		    strcmp(cmd->handle.chain, chain->handle.chain) != 0)
 			continue;
 
-		chain_print(chain);
+		chain_print(chain, ct);
 	}
 
 	printf("}\n");
@@ -1414,7 +1420,7 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 }
 
 static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
-		       struct table *table)
+		       struct table *table, struct print_ctx *ct)
 {
 	struct set *set;
 
@@ -1423,13 +1429,14 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 		return -1;
 
 	table_print_declaration(table);
-	set_print(set);
+	set_print(set, ct);
 	printf("}\n");
 
 	return 0;
 }
 
-static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
+static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd,
+			    struct print_ctx *ct)
 {
 	struct table *table = NULL;
 
@@ -1440,34 +1447,34 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_TABLE:
 		if (!cmd->handle.table)
 			return do_list_tables(ctx, cmd);
-		return do_list_table(ctx, cmd, table);
+		return do_list_table(ctx, cmd, table, ct);
 	case CMD_OBJ_CHAIN:
-		return do_list_chain(ctx, cmd, table);
+		return do_list_chain(ctx, cmd, table, ct);
 	case CMD_OBJ_CHAINS:
 		return do_list_chains(ctx, cmd);
 	case CMD_OBJ_SETS:
 		return do_list_sets(ctx, cmd);
 	case CMD_OBJ_SET:
-		return do_list_set(ctx, cmd, table);
+		return do_list_set(ctx, cmd, table, ct);
 	case CMD_OBJ_RULESET:
-		return do_list_ruleset(ctx, cmd);
+		return do_list_ruleset(ctx, cmd, ct);
 	case CMD_OBJ_FLOWTABLES:
 		return do_list_sets(ctx, cmd);
 	case CMD_OBJ_FLOWTABLE:
-		return do_list_set(ctx, cmd, table);
+		return do_list_set(ctx, cmd, table, ct);
 	case CMD_OBJ_MAPS:
 		return do_list_sets(ctx, cmd);
 	case CMD_OBJ_MAP:
-		return do_list_set(ctx, cmd, table);
+		return do_list_set(ctx, cmd, table, ct);
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_COUNTERS:
-		return do_list_obj(ctx, cmd, NFT_OBJECT_COUNTER);
+		return do_list_obj(ctx, cmd, NFT_OBJECT_COUNTER, ct);
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_QUOTAS:
-		return do_list_obj(ctx, cmd, NFT_OBJECT_QUOTA);
+		return do_list_obj(ctx, cmd, NFT_OBJECT_QUOTA, ct);
 	case CMD_OBJ_CT_HELPER:
 	case CMD_OBJ_CT_HELPERS:
-		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_HELPER);
+		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_HELPER, ct);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -1475,7 +1482,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
-static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
+static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd,
+			     struct print_ctx *ct)
 {
 	struct obj *obj, *next;
 	struct table *table;
@@ -1506,7 +1514,7 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 	if (ret < 0)
 		return ret;
 
-	return do_list_obj(ctx, cmd, type);
+	return do_list_obj(ctx, cmd, type, ct);
 }
 
 static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
@@ -1563,7 +1571,8 @@ static bool need_cache(const struct cmd *cmd)
 	return false;
 }
 
-static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
+static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd,
+			       struct print_ctx *ct)
 {
 	struct table *t;
 	struct set *s;
@@ -1606,6 +1615,7 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 	monhandler.format = cmd->monitor->format;
 	monhandler.ctx = ctx;
 	monhandler.loc = &cmd->location;
+	monhandler.ct = ct;
 
 	return netlink_monitor(&monhandler);
 }
@@ -1632,23 +1642,23 @@ struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type, const struct handle *h,
 	return cmd_alloc(op, cmd_obj, h, loc, data);
 }
 
-int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
+int do_command(struct netlink_ctx *ctx, struct cmd *cmd, struct print_ctx *ct)
 {
 	switch (cmd->op) {
 	case CMD_ADD:
-		return do_command_add(ctx, cmd, false);
+		return do_command_add(ctx, cmd, false, ct);
 	case CMD_CREATE:
-		return do_command_add(ctx, cmd, true);
+		return do_command_add(ctx, cmd, true, ct);
 	case CMD_INSERT:
 		return do_command_insert(ctx, cmd);
 	case CMD_REPLACE:
 		return do_command_replace(ctx, cmd);
 	case CMD_DELETE:
-		return do_command_delete(ctx, cmd);
+		return do_command_delete(ctx, cmd, ct);
 	case CMD_LIST:
-		return do_command_list(ctx, cmd);
+		return do_command_list(ctx, cmd, ct);
 	case CMD_RESET:
-		return do_command_reset(ctx, cmd);
+		return do_command_reset(ctx, cmd, ct);
 	case CMD_FLUSH:
 		return do_command_flush(ctx, cmd);
 	case CMD_RENAME:
@@ -1656,7 +1666,7 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_EXPORT:
 		return do_command_export(ctx, cmd);
 	case CMD_MONITOR:
-		return do_command_monitor(ctx, cmd);
+		return do_command_monitor(ctx, cmd, ct);
 	case CMD_DESCRIBE:
 		return do_command_describe(ctx, cmd);
 	default:
diff --git a/src/segtree.c b/src/segtree.c
index 15e8849..dd3c698 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -541,7 +541,7 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 }
 
 int set_to_intervals(struct list_head *errs, struct set *set,
-		     struct expr *init, bool add)
+		     struct expr *init, bool add, struct print_ctx *ct)
 {
 	struct elementary_interval *ei, *next;
 	struct seg_tree tree;
@@ -564,7 +564,7 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 	}
 
 	if (segtree_debug()) {
-		expr_print(init);
+		expr_print(init, ct);
 		pr_gmp_debug("\n");
 	}
 
diff --git a/src/statement.c b/src/statement.c
index d824dc0..9923dc0 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -60,14 +60,14 @@ void stmt_list_free(struct list_head *list)
 	}
 }
 
-void stmt_print(const struct stmt *stmt)
+void stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
-	stmt->ops->print(stmt);
+	stmt->ops->print(stmt, ct);
 }
 
-static void expr_stmt_print(const struct stmt *stmt)
+static void expr_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
-	expr_print(stmt->expr);
+	expr_print(stmt->expr, ct);
 }
 
 static void expr_stmt_destroy(struct stmt *stmt)
@@ -107,20 +107,20 @@ struct stmt *verdict_stmt_alloc(const struct location *loc, struct expr *expr)
 	return stmt;
 }
 
-static void flow_stmt_print(const struct stmt *stmt)
+static void flow_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	printf("flow ");
 	if (stmt->flow.set) {
-		expr_print(stmt->flow.set);
+		expr_print(stmt->flow.set, ct);
 		printf(" ");
 	}
 	printf("{ ");
-	expr_print(stmt->flow.key);
+	expr_print(stmt->flow.key, ct);
 	printf(" ");
 
-	stateless_output++;
-	stmt_print(stmt->flow.stmt);
-	stateless_output--;
+	ct->stateless_output++;
+	stmt_print(stmt->flow.stmt, ct);
+	ct->stateless_output--;
 
 	printf("} ");
 
@@ -145,11 +145,11 @@ struct stmt *flow_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &flow_stmt_ops);
 }
 
-static void counter_stmt_print(const struct stmt *stmt)
+static void counter_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	printf("counter");
 
-	if (stateless_output)
+	if (ct->stateless_output)
 		return;
 
 	printf(" packets %" PRIu64 " bytes %" PRIu64,
@@ -185,7 +185,7 @@ static const char *objref_type_name(uint32_t type)
 	return objref_type[type];
 }
 
-static void objref_stmt_print(const struct stmt *stmt)
+static void objref_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	switch (stmt->objref.type) {
 	case NFT_OBJECT_CT_HELPER:
@@ -195,7 +195,7 @@ static void objref_stmt_print(const struct stmt *stmt)
 		printf("%s name ", objref_type_name(stmt->objref.type));
 		break;
 	}
-	expr_print(stmt->objref.expr);
+	expr_print(stmt->objref.expr, ct);
 }
 
 static const struct stmt_ops objref_stmt_ops = {
@@ -231,7 +231,7 @@ static const char *log_level(uint32_t level)
 	return syslog_level[level];
 }
 
-static void log_stmt_print(const struct stmt *stmt)
+static void log_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	printf("log");
 	if (stmt->log.flags & STMT_LOG_PREFIX)
@@ -320,7 +320,7 @@ const char *get_rate(uint64_t byte_rate, uint64_t *rate)
 	return data_unit[i];
 }
 
-static void limit_stmt_print(const struct stmt *stmt)
+static void limit_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	bool inv = stmt->limit.flags & NFT_LIMIT_F_INV;
 	const char *data_unit;
@@ -365,14 +365,14 @@ struct stmt *limit_stmt_alloc(const struct location *loc)
 	return stmt;
 }
 
-static void queue_stmt_print(const struct stmt *stmt)
+static void queue_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	const char *delim = " ";
 
 	printf("queue");
 	if (stmt->queue.queue != NULL) {
 		printf(" num ");
-		expr_print(stmt->queue.queue);
+		expr_print(stmt->queue.queue, ct);
 	}
 	if (stmt->queue.flags & NFT_QUEUE_FLAG_BYPASS) {
 		printf("%sbypass", delim);
@@ -394,7 +394,7 @@ struct stmt *queue_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &queue_stmt_ops);
 }
 
-static void quota_stmt_print(const struct stmt *stmt)
+static void quota_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	bool inv = stmt->quota.flags & NFT_QUOTA_F_INV;
 	const char *data_unit;
@@ -404,7 +404,7 @@ static void quota_stmt_print(const struct stmt *stmt)
 	printf("quota %s%"PRIu64" %s",
 	       inv ? "over " : "", bytes, data_unit);
 
-	if (!stateless_output && stmt->quota.used) {
+	if (!ct->stateless_output && stmt->quota.used) {
 		data_unit = get_rate(stmt->quota.used, &used);
 		printf(" used %"PRIu64" %s", used, data_unit);
 	}
@@ -425,7 +425,7 @@ struct stmt *quota_stmt_alloc(const struct location *loc)
 	return stmt;
 }
 
-static void reject_stmt_print(const struct stmt *stmt)
+static void reject_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	printf("reject");
 	switch (stmt->reject.type) {
@@ -436,7 +436,7 @@ static void reject_stmt_print(const struct stmt *stmt)
 		if (stmt->reject.icmp_code == NFT_REJECT_ICMPX_PORT_UNREACH)
 			break;
 		printf(" with icmpx type ");
-		expr_print(stmt->reject.expr);
+		expr_print(stmt->reject.expr, ct);
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
 		switch (stmt->reject.family) {
@@ -444,13 +444,13 @@ static void reject_stmt_print(const struct stmt *stmt)
 			if (stmt->reject.icmp_code == ICMP_PORT_UNREACH)
 				break;
 			printf(" with icmp type ");
-			expr_print(stmt->reject.expr);
+			expr_print(stmt->reject.expr, ct);
 			break;
 		case NFPROTO_IPV6:
 			if (stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
 				break;
 			printf(" with icmpv6 type ");
-			expr_print(stmt->reject.expr);
+			expr_print(stmt->reject.expr, ct);
 			break;
 		}
 		break;
@@ -489,7 +489,7 @@ static void print_nf_nat_flags(uint32_t flags)
 		printf("%spersistent", delim);
 }
 
-static void nat_stmt_print(const struct stmt *stmt)
+static void nat_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	static const char *nat_types[] = {
 		[NFT_NAT_SNAT]	= "snat",
@@ -502,26 +502,26 @@ static void nat_stmt_print(const struct stmt *stmt)
 			if (stmt->nat.addr->ops->type == EXPR_VALUE &&
 			    stmt->nat.addr->dtype->type == TYPE_IP6ADDR) {
 				printf("[");
-				expr_print(stmt->nat.addr);
+				expr_print(stmt->nat.addr, ct);
 				printf("]");
 			} else if (stmt->nat.addr->ops->type == EXPR_RANGE &&
 				   stmt->nat.addr->left->dtype->type == TYPE_IP6ADDR) {
 				printf("[");
-				expr_print(stmt->nat.addr->left);
+				expr_print(stmt->nat.addr->left, ct);
 				printf("]-[");
-				expr_print(stmt->nat.addr->right);
+				expr_print(stmt->nat.addr->right, ct);
 				printf("]");
 			} else {
-				expr_print(stmt->nat.addr);
+				expr_print(stmt->nat.addr, ct);
 			}
 		} else {
-			expr_print(stmt->nat.addr);
+			expr_print(stmt->nat.addr, ct);
 		}
 	}
 
 	if (stmt->nat.proto) {
 		printf(":");
-		expr_print(stmt->nat.proto);
+		expr_print(stmt->nat.proto, ct);
 	}
 
 	print_nf_nat_flags(stmt->nat.flags);
@@ -545,13 +545,13 @@ struct stmt *nat_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &nat_stmt_ops);
 }
 
-static void masq_stmt_print(const struct stmt *stmt)
+static void masq_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	printf("masquerade");
 
 	if (stmt->masq.proto) {
 		printf(" to :");
-		expr_print(stmt->masq.proto);
+		expr_print(stmt->masq.proto, ct);
 	}
 
 	print_nf_nat_flags(stmt->masq.flags);
@@ -574,13 +574,13 @@ struct stmt *masq_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &masq_stmt_ops);
 }
 
-static void redir_stmt_print(const struct stmt *stmt)
+static void redir_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	printf("redirect");
 
 	if (stmt->redir.proto) {
 		printf(" to :");
-		expr_print(stmt->redir.proto);
+		expr_print(stmt->redir.proto, ct);
 	}
 
 	print_nf_nat_flags(stmt->redir.flags);
@@ -608,12 +608,12 @@ static const char * const set_stmt_op_names[] = {
 	[NFT_DYNSET_OP_UPDATE]	= "update",
 };
 
-static void set_stmt_print(const struct stmt *stmt)
+static void set_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	printf("set %s ", set_stmt_op_names[stmt->set.op]);
-	expr_print(stmt->set.key);
+	expr_print(stmt->set.key, ct);
 	printf(" ");
-	expr_print(stmt->set.set);
+	expr_print(stmt->set.set, ct);
 }
 
 static void set_stmt_destroy(struct stmt *stmt)
@@ -634,16 +634,16 @@ struct stmt *set_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &set_stmt_ops);
 }
 
-static void dup_stmt_print(const struct stmt *stmt)
+static void dup_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	printf("dup");
 	if (stmt->dup.to != NULL) {
 		printf(" to ");
-		expr_print(stmt->dup.to);
+		expr_print(stmt->dup.to, ct);
 
 		if (stmt->dup.dev != NULL) {
 			printf(" device ");
-			expr_print(stmt->dup.dev);
+			expr_print(stmt->dup.dev, ct);
 		}
 	}
 }
@@ -666,10 +666,10 @@ struct stmt *dup_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &dup_stmt_ops);
 }
 
-static void fwd_stmt_print(const struct stmt *stmt)
+static void fwd_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	printf("fwd to ");
-	expr_print(stmt->fwd.to);
+	expr_print(stmt->fwd.to, ct);
 }
 
 static void fwd_stmt_destroy(struct stmt *stmt)
@@ -689,7 +689,7 @@ struct stmt *fwd_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &fwd_stmt_ops);
 }
 
-static void xt_stmt_print(const struct stmt *stmt)
+static void xt_stmt_print(const struct stmt *stmt, struct print_ctx *ct)
 {
 	xt_stmt_xlate(stmt);
 }
-- 
2.9.4

