From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft v3] src: Pass stateless, numeric, ip2name and handle
 variables as structure members.
Date: Fri, 16 Jun 2017 14:54:06 +0530
Message-ID: <5943a3bc.4c17620a.524bc.7af5@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:32863 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbdFPJYO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2017 05:24:14 -0400
Received: by mail-pg0-f66.google.com with SMTP id a70so5096557pge.0
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jun 2017 02:24:14 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libnftables library will be created soon. So declare numeric_output,
stateless_output, ip2name_output and handle_output as members of
structure output_ctx, instead of global variables. Rename these
variables as following,

numeric_output -> numeric
stateless_output -> stateless
ip2name_output -> ip2name
handle_output -> handle

Also add struct output_ctx *octx as member of struct netlink_ctx.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
Changes in v3:
- Set dummy_octx = *octx in cli_init() in src/cli.c
- Remove struct output_ctx parameter from expr_evaluate.
- Add static struct output_ctx octx_debug_dummy in src/evaluate.c

Changes in v2:
- Renamed struct print_ctx to output_ctx.
- Renamed the global variables by removing trailing _output.
- In src/segtree.c, passed dummy output_ctx to expr_print.
- Added struct output_ctx *octx as member of struct netlink_ctx.
- Edits to commit message.

 include/cli.h        |  4 +--
 include/datatype.h   |  8 +++--
 include/expression.h |  5 +--
 include/netlink.h    |  2 ++
 include/nftables.h   | 14 ++++++---
 include/rule.h       | 10 +++---
 include/statement.h  |  5 +--
 src/cli.c            |  6 ++--
 src/ct.c             | 11 ++++---
 src/datatype.c       | 53 ++++++++++++++++---------------
 src/evaluate.c       |  8 +++--
 src/expression.c     | 86 ++++++++++++++++++++++++++------------------------
 src/exthdr.c         |  2 +-
 src/fib.c            |  2 +-
 src/hash.c           |  4 +--
 src/main.c           | 26 ++++++++--------
 src/meta.c           | 36 +++++++++++----------
 src/netlink.c        | 42 +++++++++++++------------
 src/numgen.c         |  2 +-
 src/payload.c        |  8 ++---
 src/proto.c          |  4 +--
 src/rt.c             |  6 ++--
 src/rule.c           | 59 ++++++++++++++++++-----------------
 src/segtree.c        |  4 ++-
 src/statement.c      | 88 ++++++++++++++++++++++++++--------------------------
 25 files changed, 265 insertions(+), 230 deletions(-)

diff --git a/include/cli.h b/include/cli.h
index 89cb976..1ae1237 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -5,9 +5,9 @@
 
 struct parser_state;
 #ifdef HAVE_LIBREADLINE
-extern int cli_init(struct parser_state *state);
+extern int cli_init(struct parser_state *state, struct output_ctx *octx);
 #else
-static inline int cli_init(struct parser_state *state)
+static inline int cli_init(struct parser_state *state, struct output_ctx *octx)
 {
         return -1;
 }
diff --git a/include/datatype.h b/include/datatype.h
index 04b7d88..58c4d3e 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -145,7 +145,8 @@ struct datatype {
 	const char			*desc;
 	const struct datatype		*basetype;
 	const char			*basefmt;
-	void				(*print)(const struct expr *expr);
+	void				(*print)(const struct expr *expr,
+						 struct output_ctx *octx);
 	struct error_record		*(*parse)(const struct expr *sym,
 						  struct expr **res);
 	const struct symbol_table	*sym_tbl;
@@ -157,7 +158,7 @@ extern const struct datatype *datatype_lookup_byname(const char *name);
 
 extern struct error_record *symbol_parse(const struct expr *sym,
 					 struct expr **res);
-extern void datatype_print(const struct expr *expr);
+extern void datatype_print(const struct expr *expr, struct output_ctx *octx);
 
 static inline bool datatype_equal(const struct datatype *d1,
 				  const struct datatype *d2)
@@ -205,7 +206,8 @@ extern struct error_record *symbolic_constant_parse(const struct expr *sym,
 						    const struct symbol_table *tbl,
 						    struct expr **res);
 extern void symbolic_constant_print(const struct symbol_table *tbl,
-				    const struct expr *expr, bool quotes);
+				    const struct expr *expr, bool quotes,
+				    struct output_ctx *octx);
 extern void symbol_table_print(const struct symbol_table *tbl,
 			       const struct datatype *dtype,
 			       enum byteorder byteorder);
diff --git a/include/expression.h b/include/expression.h
index 9ba87e8..3e67938 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -157,7 +157,8 @@ struct expr_ops {
 	void			(*set_type)(const struct expr *expr,
 					    const struct datatype *dtype,
 					    enum byteorder byteorder);
-	void			(*print)(const struct expr *expr);
+	void			(*print)(const struct expr *expr,
+					 struct output_ctx *octx);
 	bool			(*cmp)(const struct expr *e1,
 				       const struct expr *e2);
 	void			(*pctx_update)(struct proto_ctx *ctx,
@@ -330,7 +331,7 @@ extern struct expr *expr_alloc(const struct location *loc,
 extern struct expr *expr_clone(const struct expr *expr);
 extern struct expr *expr_get(struct expr *expr);
 extern void expr_free(struct expr *expr);
-extern void expr_print(const struct expr *expr);
+extern void expr_print(const struct expr *expr, struct output_ctx *octx);
 extern bool expr_cmp(const struct expr *e1, const struct expr *e2);
 extern void expr_describe(const struct expr *expr);
 
diff --git a/include/netlink.h b/include/netlink.h
index 81538ff..bb25ad4 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -38,6 +38,7 @@ extern const struct location netlink_location;
  * @set:	current set
  * @data:	pointer to pass data to callback
  * @seqnum:	sequence number
+ * @octx:	output context
  */
 struct netlink_ctx {
 	struct list_head	*msgs;
@@ -47,6 +48,7 @@ struct netlink_ctx {
 	uint32_t		seqnum;
 	struct nftnl_batch	*batch;
 	bool			batch_supported;
+	struct output_ctx	*octx;
 };
 
 extern struct nftnl_table *alloc_nftnl_table(const struct handle *h);
diff --git a/include/nftables.h b/include/nftables.h
index 6f54155..9e10be0 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -24,11 +24,14 @@ enum debug_level {
 
 #define INCLUDE_PATHS_MAX	16
 
+struct output_ctx {
+	unsigned int numeric;
+	unsigned int stateless;
+	unsigned int ip2name;
+	unsigned int handle;
+};
+
 extern unsigned int max_errors;
-extern unsigned int numeric_output;
-extern unsigned int stateless_output;
-extern unsigned int ip2name_output;
-extern unsigned int handle_output;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
@@ -107,6 +110,7 @@ struct input_descriptor {
 
 struct parser_state;
 
-int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs);
+int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs,
+	     struct output_ctx *octx);
 
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/include/rule.h b/include/rule.h
index fb46064..74c204b 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -195,7 +195,7 @@ struct rule {
 extern struct rule *rule_alloc(const struct location *loc,
 			       const struct handle *h);
 extern void rule_free(struct rule *rule);
-extern void rule_print(const struct rule *rule);
+extern void rule_print(const struct rule *rule, struct output_ctx *octx);
 extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
 
 /**
@@ -244,8 +244,8 @@ extern void set_add_hash(struct set *set, struct table *table);
 extern struct set *set_lookup(const struct table *table, const char *name);
 extern struct set *set_lookup_global(uint32_t family, const char *table,
 				     const char *name);
-extern void set_print(const struct set *set);
-extern void set_print_plain(const struct set *s);
+extern void set_print(const struct set *set, struct output_ctx *octx);
+extern void set_print_plain(const struct set *s, struct output_ctx *octx);
 
 #include <statement.h>
 
@@ -292,8 +292,8 @@ void obj_free(struct obj *obj);
 void obj_add_hash(struct obj *obj, struct table *table);
 struct obj *obj_lookup(const struct table *table, const char *name,
 		       uint32_t type);
-void obj_print(const struct obj *n);
-void obj_print_plain(const struct obj *obj);
+void obj_print(const struct obj *n, struct output_ctx *octx);
+void obj_print_plain(const struct obj *obj, struct output_ctx *octx);
 const char *obj_type_name(uint32_t type);
 
 /**
diff --git a/include/statement.h b/include/statement.h
index 317d53e..49fb109 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -261,7 +261,8 @@ struct stmt_ops {
 	enum stmt_types		type;
 	const char		*name;
 	void			(*destroy)(struct stmt *stmt);
-	void			(*print)(const struct stmt *stmt);
+	void			(*print)(const struct stmt *stmt,
+					 struct output_ctx *octx);
 };
 
 enum stmt_flags {
@@ -312,7 +313,7 @@ extern struct stmt *stmt_alloc(const struct location *loc,
 int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt);
 extern void stmt_free(struct stmt *stmt);
 extern void stmt_list_free(struct list_head *list);
-extern void stmt_print(const struct stmt *stmt);
+extern void stmt_print(const struct stmt *stmt, struct output_ctx *octx);
 
 const char *get_rate(uint64_t byte_rate, uint64_t *rate);
 
diff --git a/src/cli.c b/src/cli.c
index a74411a..7b37655 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -39,6 +39,7 @@ static const struct input_descriptor indesc_cli = {
 };
 
 static struct parser_state *state;
+struct output_ctx dummy_octx;
 static void *scanner;
 
 static char histfile[PATH_MAX];
@@ -129,7 +130,7 @@ static void cli_complete(char *line)
 
 	parser_init(state, &msgs);
 	scanner_push_buffer(scanner, &indesc_cli, line);
-	nft_run(scanner, state, &msgs);
+	nft_run(scanner, state, &msgs, &dummy_octx);
 	erec_print_list(stdout, &msgs);
 	xfree(line);
 	cache_release();
@@ -167,10 +168,11 @@ void __fmtstring(1, 0) cli_display(const char *fmt, va_list ap)
 	rl_forced_update_display();
 }
 
-int cli_init(struct parser_state *_state)
+int cli_init(struct parser_state *_state, struct output_ctx *octx)
 {
 	const char *home;
 
+	dummy_octx = *octx;
 	rl_readline_name = "nft";
 	rl_instream  = stdin;
 	rl_outstream = stdout;
diff --git a/src/ct.c b/src/ct.c
index ab50a16..c705750 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -132,7 +132,8 @@ static struct symbol_table *ct_label_tbl;
 
 #define CT_LABEL_BIT_SIZE 128
 
-static void ct_label_type_print(const struct expr *expr)
+static void ct_label_type_print(const struct expr *expr,
+				 struct output_ctx *octx)
 {
 	unsigned long bit = mpz_scan1(expr->value, 0);
 	const struct symbolic_constant *s;
@@ -286,7 +287,7 @@ static void ct_print(enum nft_ct_keys key, int8_t dir)
 	printf("%s", ct_templates[key].token);
 }
 
-static void ct_expr_print(const struct expr *expr)
+static void ct_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	ct_print(expr->ct.key, expr->ct.direction);
 }
@@ -442,11 +443,11 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 	}
 }
 
-static void ct_stmt_print(const struct stmt *stmt)
+static void ct_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	ct_print(stmt->ct.key, stmt->ct.direction);
 	printf(" set ");
-	expr_print(stmt->ct.expr);
+	expr_print(stmt->ct.expr, octx);
 }
 
 static const struct stmt_ops ct_stmt_ops = {
@@ -469,7 +470,7 @@ struct stmt *ct_stmt_alloc(const struct location *loc, enum nft_ct_keys key,
 	return stmt;
 }
 
-static void notrack_stmt_print(const struct stmt *stmt)
+static void notrack_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	printf("notrack");
 }
diff --git a/src/datatype.c b/src/datatype.c
index d2eed76..899e9c0 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -79,16 +79,16 @@ const struct datatype *datatype_lookup_byname(const char *name)
 	return NULL;
 }
 
-void datatype_print(const struct expr *expr)
+void datatype_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct datatype *dtype = expr->dtype;
 
 	do {
 		if (dtype->print != NULL)
-			return dtype->print(expr);
+			return dtype->print(expr, octx);
 		if (dtype->sym_tbl != NULL)
 			return symbolic_constant_print(dtype->sym_tbl, expr,
-						       false);
+						       false, octx);
 	} while ((dtype = dtype->basetype));
 
 	BUG("datatype %s has no print method or symbol table\n",
@@ -156,7 +156,8 @@ out:
 }
 
 void symbolic_constant_print(const struct symbol_table *tbl,
-			     const struct expr *expr, bool quotes)
+			     const struct expr *expr, bool quotes,
+			     struct output_ctx *octx)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	const struct symbolic_constant *s;
@@ -173,12 +174,12 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 	}
 
 	if (s->identifier == NULL)
-		return expr_basetype(expr)->print(expr);
+		return expr_basetype(expr)->print(expr, octx);
 
 	if (quotes)
 		printf("\"");
 
-	if (numeric_output > NUMERIC_ALL)
+	if (octx->numeric > NUMERIC_ALL)
 		printf("%"PRIu64"", val);
 	else
 		printf("%s", s->identifier);
@@ -219,7 +220,7 @@ void symbol_table_print(const struct symbol_table *tbl,
 	}
 }
 
-static void invalid_type_print(const struct expr *expr)
+static void invalid_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	gmp_printf("0x%Zx [invalid type]", expr->value);
 }
@@ -231,7 +232,7 @@ const struct datatype invalid_type = {
 	.print		= invalid_type_print,
 };
 
-static void verdict_type_print(const struct expr *expr)
+static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	switch (expr->verdict) {
 	case NFT_CONTINUE:
@@ -299,7 +300,7 @@ const struct datatype bitmask_type = {
 	.basetype	= &integer_type,
 };
 
-static void integer_type_print(const struct expr *expr)
+static void integer_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct datatype *dtype = expr->dtype;
 	const char *fmt = "%Zu";
@@ -341,7 +342,7 @@ const struct datatype integer_type = {
 	.parse		= integer_type_parse,
 };
 
-static void string_type_print(const struct expr *expr)
+static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	char data[len+1];
@@ -370,7 +371,7 @@ const struct datatype string_type = {
 	.parse		= string_type_parse,
 };
 
-static void lladdr_type_print(const struct expr *expr)
+static void lladdr_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	const char *delim = "";
@@ -419,7 +420,7 @@ const struct datatype lladdr_type = {
 	.parse		= lladdr_type_parse,
 };
 
-static void ipaddr_type_print(const struct expr *expr)
+static void ipaddr_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	struct sockaddr_in sin = { .sin_family = AF_INET, };
 	char buf[NI_MAXHOST];
@@ -428,7 +429,7 @@ static void ipaddr_type_print(const struct expr *expr)
 	sin.sin_addr.s_addr = mpz_get_be32(expr->value);
 	err = getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			  sizeof(buf), NULL, 0,
-			  ip2name_output ? 0 : NI_NUMERICHOST);
+			  octx->ip2name ? 0 : NI_NUMERICHOST);
 	if (err != 0) {
 		getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
@@ -475,7 +476,7 @@ const struct datatype ipaddr_type = {
 	.flags		= DTYPE_F_PREFIX,
 };
 
-static void ip6addr_type_print(const struct expr *expr)
+static void ip6addr_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	struct sockaddr_in6 sin6 = { .sin6_family = AF_INET6 };
 	char buf[NI_MAXHOST];
@@ -486,7 +487,7 @@ static void ip6addr_type_print(const struct expr *expr)
 
 	err = getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			  sizeof(buf), NULL, 0,
-			  ip2name_output ? 0 : NI_NUMERICHOST);
+			  octx->ip2name ? 0 : NI_NUMERICHOST);
 	if (err != 0) {
 		getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
@@ -533,18 +534,19 @@ const struct datatype ip6addr_type = {
 	.flags		= DTYPE_F_PREFIX,
 };
 
-static void inet_protocol_type_print(const struct expr *expr)
+static void inet_protocol_type_print(const struct expr *expr,
+				      struct output_ctx *octx)
 {
 	struct protoent *p;
 
-	if (numeric_output < NUMERIC_ALL) {
+	if (octx->numeric < NUMERIC_ALL) {
 		p = getprotobynumber(mpz_get_uint8(expr->value));
 		if (p != NULL) {
 			printf("%s", p->p_name);
 			return;
 		}
 	}
-	integer_type_print(expr);
+	integer_type_print(expr, octx);
 }
 
 static struct error_record *inet_protocol_type_parse(const struct expr *sym,
@@ -586,13 +588,14 @@ const struct datatype inet_protocol_type = {
 	.parse		= inet_protocol_type_parse,
 };
 
-static void inet_service_type_print(const struct expr *expr)
+static void inet_service_type_print(const struct expr *expr,
+				     struct output_ctx *octx)
 {
-	if (numeric_output >= NUMERIC_PORT) {
-		integer_type_print(expr);
+	if (octx->numeric >= NUMERIC_PORT) {
+		integer_type_print(expr, octx);
 		return;
 	}
-	symbolic_constant_print(&inet_service_tbl, expr, false);
+	symbolic_constant_print(&inet_service_tbl, expr, false, octx);
 }
 
 static struct error_record *inet_service_type_parse(const struct expr *sym,
@@ -711,9 +714,9 @@ static void __exit mark_table_exit(void)
 	rt_symbol_table_free(mark_tbl);
 }
 
-static void mark_type_print(const struct expr *expr)
+static void mark_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	return symbolic_constant_print(mark_tbl, expr, true);
+	return symbolic_constant_print(mark_tbl, expr, true, octx);
 }
 
 static struct error_record *mark_type_parse(const struct expr *sym,
@@ -913,7 +916,7 @@ struct error_record *time_parse(const struct location *loc, const char *str,
 }
 
 
-static void time_type_print(const struct expr *expr)
+static void time_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	time_print(mpz_get_uint64(expr->value) / MSEC_PER_SEC);
 }
diff --git a/src/evaluate.c b/src/evaluate.c
index 311c86c..01e220f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -30,6 +30,7 @@
 #include <utils.h>
 #include <xt.h>
 
+static struct output_ctx octx_debug_dummy;
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
 
 static const char *byteorder_names[] = {
@@ -1698,7 +1699,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &(*expr)->location,
 				   "Evaluate %s", (*expr)->ops->name);
-		erec_print(stdout, erec); expr_print(*expr); printf("\n\n");
+		erec_print(stdout, erec); expr_print(*expr, &octx_debug_dummy);
+		printf("\n\n");
 	}
 #endif
 
@@ -2662,7 +2664,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &stmt->location,
 				   "Evaluate %s", stmt->ops->name);
-		erec_print(stdout, erec); stmt_print(stmt); printf("\n\n");
+		erec_print(stdout, erec); stmt_print(stmt, &octx_debug_dummy);
+		printf("\n\n");
 	}
 #endif
 
@@ -3320,6 +3323,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 #ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
+
 		erec = erec_create(EREC_INFORMATIONAL, &cmd->location,
 				   "Evaluate %s", cmd_op_to_name(cmd->op));
 		erec_print(stdout, erec); printf("\n\n");
diff --git a/src/expression.c b/src/expression.c
index 4fef830..f90ca60 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -70,9 +70,9 @@ void expr_free(struct expr *expr)
 	xfree(expr);
 }
 
-void expr_print(const struct expr *expr)
+void expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	expr->ops->print(expr);
+	expr->ops->print(expr, octx);
 }
 
 bool expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -160,9 +160,9 @@ int __fmtstring(4, 5) expr_binary_error(struct list_head *msgs,
 	return -1;
 }
 
-static void verdict_expr_print(const struct expr *expr)
+static void verdict_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	datatype_print(expr);
+	datatype_print(expr, octx);
 }
 
 static bool verdict_expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -213,7 +213,7 @@ struct expr *verdict_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void symbol_expr_print(const struct expr *expr)
+static void symbol_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	printf("%s%s", expr->scope != NULL ? "$" : "", expr->identifier);
 }
@@ -252,9 +252,10 @@ struct expr *symbol_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void constant_expr_print(const struct expr *expr)
+static void constant_expr_print(const struct expr *expr,
+				 struct output_ctx *octx)
 {
-	datatype_print(expr);
+	datatype_print(expr, octx);
 }
 
 static bool constant_expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -394,9 +395,9 @@ struct expr *bitmask_expr_to_binops(struct expr *expr)
 	return binop;
 }
 
-static void prefix_expr_print(const struct expr *expr)
+static void prefix_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	expr_print(expr->prefix);
+	expr_print(expr->prefix, octx);
 	printf("/%u", expr->prefix_len);
 }
 
@@ -458,9 +459,9 @@ const char *expr_op_symbols[] = {
 	[OP_LOOKUP]	= NULL,
 };
 
-static void unary_expr_print(const struct expr *expr)
+static void unary_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	expr_print(expr->arg);
+	expr_print(expr->arg, octx);
 }
 
 static void unary_expr_clone(struct expr *new, const struct expr *expr)
@@ -501,7 +502,8 @@ static uint8_t expr_binop_precedence[OP_MAX + 1] = {
 	[OP_OR]		= 4,
 };
 
-static void binop_arg_print(const struct expr *op, const struct expr *arg)
+static void binop_arg_print(const struct expr *op, const struct expr *arg,
+			     struct output_ctx *octx)
 {
 	bool prec = false;
 
@@ -512,7 +514,7 @@ static void binop_arg_print(const struct expr *op, const struct expr *arg)
 
 	if (prec)
 		printf("(");
-	expr_print(arg);
+	expr_print(arg, octx);
 	if (prec)
 		printf(")");
 }
@@ -526,9 +528,9 @@ static bool must_print_eq_op(const struct expr *expr)
 	return expr->left->ops->type == EXPR_BINOP;
 }
 
-static void binop_expr_print(const struct expr *expr)
+static void binop_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	binop_arg_print(expr, expr->left);
+	binop_arg_print(expr, expr->left, octx);
 
 	if (expr_op_symbols[expr->op] &&
 	    (expr->op != OP_EQ || must_print_eq_op(expr)))
@@ -536,7 +538,7 @@ static void binop_expr_print(const struct expr *expr)
 	else
 		printf(" ");
 
-	binop_arg_print(expr, expr->right);
+	binop_arg_print(expr, expr->right, octx);
 }
 
 static void binop_expr_clone(struct expr *new, const struct expr *expr)
@@ -596,13 +598,13 @@ struct expr *relational_expr_alloc(const struct location *loc, enum ops op,
 	return expr;
 }
 
-static void range_expr_print(const struct expr *expr)
+static void range_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	numeric_output += NUMERIC_ALL + 1;
-	expr_print(expr->left);
+	octx->numeric += NUMERIC_ALL + 1;
+	expr_print(expr->left, octx);
 	printf("-");
-	expr_print(expr->right);
-	numeric_output -= NUMERIC_ALL + 1;
+	expr_print(expr->right, octx);
+	octx->numeric -= NUMERIC_ALL + 1;
 }
 
 static void range_expr_clone(struct expr *new, const struct expr *expr)
@@ -673,14 +675,15 @@ static void compound_expr_destroy(struct expr *expr)
 		expr_free(i);
 }
 
-static void compound_expr_print(const struct expr *expr, const char *delim)
+static void compound_expr_print(const struct expr *expr, const char *delim,
+				 struct output_ctx *octx)
 {
 	const struct expr *i;
 	const char *d = "";
 
 	list_for_each_entry(i, &expr->expressions, list) {
 		printf("%s", d);
-		expr_print(i);
+		expr_print(i, octx);
 		d = delim;
 	}
 }
@@ -703,9 +706,9 @@ static void concat_expr_destroy(struct expr *expr)
 	compound_expr_destroy(expr);
 }
 
-static void concat_expr_print(const struct expr *expr)
+static void concat_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	compound_expr_print(expr, " . ");
+	compound_expr_print(expr, " . ", octx);
 }
 
 static const struct expr_ops concat_expr_ops = {
@@ -721,9 +724,9 @@ struct expr *concat_expr_alloc(const struct location *loc)
 	return compound_expr_alloc(loc, &concat_expr_ops);
 }
 
-static void list_expr_print(const struct expr *expr)
+static void list_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	compound_expr_print(expr, ",");
+	compound_expr_print(expr, ",", octx);
 }
 
 static const struct expr_ops list_expr_ops = {
@@ -784,7 +787,7 @@ static const char *calculate_delim(const struct expr *expr, int *count)
 	return newline;
 }
 
-static void set_expr_print(const struct expr *expr)
+static void set_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct expr *i;
 	const char *d = "";
@@ -794,7 +797,7 @@ static void set_expr_print(const struct expr *expr)
 
 	list_for_each_entry(i, &expr->expressions, list) {
 		printf("%s", d);
-		expr_print(i);
+		expr_print(i, octx);
 		count++;
 		d = calculate_delim(expr, &count);
 	}
@@ -826,11 +829,11 @@ struct expr *set_expr_alloc(const struct location *loc)
 	return compound_expr_alloc(loc, &set_expr_ops);
 }
 
-static void mapping_expr_print(const struct expr *expr)
+static void mapping_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	expr_print(expr->left);
+	expr_print(expr->left, octx);
 	printf(" : ");
-	expr_print(expr->right);
+	expr_print(expr->right, octx);
 }
 
 static void mapping_expr_set_type(const struct expr *expr,
@@ -873,15 +876,15 @@ struct expr *mapping_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-static void map_expr_print(const struct expr *expr)
+static void map_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	expr_print(expr->map);
+	expr_print(expr->map, octx);
 	if (expr->mappings->ops->type == EXPR_SET_REF &&
 	    expr->mappings->set->datatype->type == TYPE_VERDICT)
 		printf(" vmap ");
 	else
 		printf(" map ");
-	expr_print(expr->mappings);
+	expr_print(expr->mappings, octx);
 }
 
 static void map_expr_clone(struct expr *new, const struct expr *expr)
@@ -915,13 +918,13 @@ struct expr *map_expr_alloc(const struct location *loc, struct expr *arg,
 	return expr;
 }
 
-static void set_ref_expr_print(const struct expr *expr)
+static void set_ref_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	if (expr->set->flags & NFT_SET_ANONYMOUS) {
 		if (expr->set->flags & NFT_SET_EVAL)
 			printf("table %s", expr->set->handle.set);
 		else
-			expr_print(expr->set->init);
+			expr_print(expr->set->init, octx);
 	} else {
 		printf("@%s", expr->set->handle.set);
 	}
@@ -955,14 +958,15 @@ struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 	return expr;
 }
 
-static void set_elem_expr_print(const struct expr *expr)
+static void set_elem_expr_print(const struct expr *expr,
+				 struct output_ctx *octx)
 {
-	expr_print(expr->key);
+	expr_print(expr->key, octx);
 	if (expr->timeout) {
 		printf(" timeout ");
 		time_print(expr->timeout / 1000);
 	}
-	if (!stateless_output && expr->expiration) {
+	if (!octx->stateless && expr->expiration) {
 		printf(" expires ");
 		time_print(expr->expiration / 1000);
 	}
@@ -971,7 +975,7 @@ static void set_elem_expr_print(const struct expr *expr)
 
 	if (expr->stmt) {
 		printf(" : ");
-		stmt_print(expr->stmt);
+		stmt_print(expr->stmt, octx);
 	}
 }
 
diff --git a/src/exthdr.c b/src/exthdr.c
index c8599f2..f31deea 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -22,7 +22,7 @@
 #include <headers.h>
 #include <expression.h>
 
-static void exthdr_expr_print(const struct expr *expr)
+static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT) {
 		/* Offset calcualtion is a bit hacky at this point.
diff --git a/src/fib.c b/src/fib.c
index 28ef4b5..28d2b1d 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -71,7 +71,7 @@ static void __fib_expr_print_f(unsigned int *flags, unsigned int f, const char *
 		printf(" . ");
 }
 
-static void fib_expr_print(const struct expr *expr)
+static void fib_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	unsigned int flags = expr->fib.flags & ~NFTA_FIB_F_PRESENT;
 
diff --git a/src/hash.c b/src/hash.c
index c738d0b..1a4bfb3 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -15,7 +15,7 @@
 #include <hash.h>
 #include <utils.h>
 
-static void hash_expr_print(const struct expr *expr)
+static void hash_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	switch (expr->hash.type) {
 	case NFT_HASH_SYM:
@@ -24,7 +24,7 @@ static void hash_expr_print(const struct expr *expr)
 	case NFT_HASH_JENKINS:
 	default:
 		printf("jhash ");
-		expr_print(expr->hash.expr);
+		expr_print(expr->hash.expr, octx);
 	}
 
 	printf(" mod %u", expr->hash.mod);
diff --git a/src/main.c b/src/main.c
index 5089ff2..d09fd78 100644
--- a/src/main.c
+++ b/src/main.c
@@ -28,11 +28,8 @@
 #include <iface.h>
 #include <cli.h>
 
+struct output_ctx octx;
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
+			struct output_ctx *octx)
 {
 	struct nftnl_batch *batch;
 	struct netlink_ctx ctx;
@@ -198,6 +196,7 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc();
 		ctx.batch = batch;
 		ctx.batch_supported = batch_supported;
+		ctx.octx = octx;
 		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0)
@@ -231,7 +230,8 @@ out:
 	return ret;
 }
 
-int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
+int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs,
+	     struct output_ctx *octx)
 {
 	struct cmd *cmd, *next;
 	int ret;
@@ -241,7 +241,7 @@ int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 		ret = -1;
 		goto err1;
 	}
-	ret = nft_netlink(state, msgs);
+	ret = nft_netlink(state, msgs, octx);
 err1:
 	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
 		list_del(&cmd->list);
@@ -290,7 +290,7 @@ int main(int argc, char * const *argv)
 			include_paths[num_include_paths++] = optarg;
 			break;
 		case OPT_NUMERIC:
-			if (++numeric_output > NUMERIC_ALL) {
+			if (++(octx.numeric) > NUMERIC_ALL) {
 				fprintf(stderr, "Too many numeric options "
 						"used, max. %u\n",
 					NUMERIC_ALL);
@@ -298,10 +298,10 @@ int main(int argc, char * const *argv)
 			}
 			break;
 		case OPT_STATELESS:
-			stateless_output++;
+			octx.stateless++;
 			break;
 		case OPT_IP2NAME:
-			ip2name_output++;
+			octx.ip2name++;
 			break;
 #ifdef DEBUG
 		case OPT_DEBUG:
@@ -333,7 +333,7 @@ int main(int argc, char * const *argv)
 			break;
 #endif
 		case OPT_HANDLE_OUTPUT:
-			handle_output++;
+			octx.handle++;
 			break;
 		case OPT_INVALID:
 			exit(NFT_EXIT_FAILURE);
@@ -364,7 +364,7 @@ int main(int argc, char * const *argv)
 		if (scanner_read_file(scanner, filename, &internal_location) < 0)
 			goto out;
 	} else if (interactive) {
-		if (cli_init(&state) < 0) {
+		if (cli_init(&state, &octx) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
 				argv[0]);
 			exit(NFT_EXIT_FAILURE);
@@ -375,7 +375,7 @@ int main(int argc, char * const *argv)
 		exit(NFT_EXIT_FAILURE);
 	}
 
-	if (nft_run(scanner, &state, &msgs) != 0)
+	if (nft_run(scanner, &state, &msgs, &octx) != 0)
 		rc = NFT_EXIT_FAILURE;
 out:
 	scanner_destroy(scanner);
diff --git a/src/meta.c b/src/meta.c
index dd09d49..4c7a5f4 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -47,9 +47,9 @@ static void __exit realm_table_exit(void)
 	rt_symbol_table_free(realm_tbl);
 }
 
-static void realm_type_print(const struct expr *expr)
+static void realm_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	return symbolic_constant_print(realm_tbl, expr, true);
+	return symbolic_constant_print(realm_tbl, expr, true, octx);
 }
 
 static struct error_record *realm_type_parse(const struct expr *sym,
@@ -70,7 +70,8 @@ static const struct datatype realm_type = {
 	.flags		= DTYPE_F_PREFIX,
 };
 
-static void tchandle_type_print(const struct expr *expr)
+static void tchandle_type_print(const struct expr *expr,
+				 struct output_ctx *octx)
 {
 	uint32_t handle = mpz_get_uint32(expr->value);
 
@@ -149,7 +150,7 @@ static const struct datatype tchandle_type = {
 	.parse		= tchandle_type_parse,
 };
 
-static void ifindex_type_print(const struct expr *expr)
+static void ifindex_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	char name[IFNAMSIZ];
 	int ifindex;
@@ -222,11 +223,11 @@ const struct datatype arphrd_type = {
 	.sym_tbl	= &arphrd_tbl,
 };
 
-static void uid_type_print(const struct expr *expr)
+static void uid_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	struct passwd *pw;
 
-	if (numeric_output < NUMERIC_ALL) {
+	if (octx->numeric < NUMERIC_ALL) {
 		uint32_t uid = mpz_get_uint32(expr->value);
 
 		pw = getpwuid(uid);
@@ -236,7 +237,7 @@ static void uid_type_print(const struct expr *expr)
 			printf("%d", uid);
 		return;
 	}
-	expr_basetype(expr)->print(expr);
+	expr_basetype(expr)->print(expr, octx);
 }
 
 static struct error_record *uid_type_parse(const struct expr *sym,
@@ -274,11 +275,11 @@ static const struct datatype uid_type = {
 	.parse		= uid_type_parse,
 };
 
-static void gid_type_print(const struct expr *expr)
+static void gid_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	struct group *gr;
 
-	if (numeric_output < NUMERIC_ALL) {
+	if (octx->numeric < NUMERIC_ALL) {
 		uint32_t gid = mpz_get_uint32(expr->value);
 
 		gr = getgrgid(gid);
@@ -288,7 +289,7 @@ static void gid_type_print(const struct expr *expr)
 			printf("%u", gid);
 		return;
 	}
-	expr_basetype(expr)->print(expr);
+	expr_basetype(expr)->print(expr, octx);
 }
 
 static struct error_record *gid_type_parse(const struct expr *sym,
@@ -338,9 +339,9 @@ static const struct symbol_table pkttype_type_tbl = {
 	},
 };
 
-static void pkttype_type_print(const struct expr *expr)
+static void pkttype_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	return symbolic_constant_print(&pkttype_type_tbl, expr, false);
+	return symbolic_constant_print(&pkttype_type_tbl, expr, false, octx);
 }
 
 static const struct datatype pkttype_type = {
@@ -365,9 +366,10 @@ static void __exit devgroup_table_exit(void)
 	rt_symbol_table_free(devgroup_tbl);
 }
 
-static void devgroup_type_print(const struct expr *expr)
+static void devgroup_type_print(const struct expr *expr,
+				 struct output_ctx *octx)
 {
-	return symbolic_constant_print(devgroup_tbl, expr, true);
+	return symbolic_constant_print(devgroup_tbl, expr, true, octx);
 }
 
 static struct error_record *devgroup_type_parse(const struct expr *sym,
@@ -464,7 +466,7 @@ static bool meta_key_is_qualified(enum nft_meta_keys key)
 	}
 }
 
-static void meta_expr_print(const struct expr *expr)
+static void meta_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	if (meta_key_is_qualified(expr->meta.key))
 		printf("meta %s", meta_templates[expr->meta.key].token);
@@ -591,14 +593,14 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 	return expr;
 }
 
-static void meta_stmt_print(const struct stmt *stmt)
+static void meta_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	if (meta_key_is_qualified(stmt->meta.key))
 		printf("meta %s set ", meta_templates[stmt->meta.key].token);
 	else
 		printf("%s set ", meta_templates[stmt->meta.key].token);
 
-	expr_print(stmt->meta.expr);
+	expr_print(stmt->meta.expr, octx);
 }
 
 static const struct stmt_ops meta_stmt_ops = {
diff --git a/src/netlink.c b/src/netlink.c
index 6fda0b9..880502c 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2173,7 +2173,7 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 				nftnl_set_free(nls);
 				return MNL_CB_ERROR;
 			}
-			set_print_plain(set);
+			set_print_plain(set, monh->ctx->octx);
 			set_free(set);
 			printf("\n");
 			break;
@@ -2261,7 +2261,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 			goto out;
 		}
 		printf("element %s %s %s ", family2str(family), table, setname);
-		expr_print(dummyset->init);
+		expr_print(dummyset->init, monh->ctx->octx);
 		printf("\n");
 
 		set_free(dummyset);
@@ -2297,7 +2297,7 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 				nftnl_obj_free(nlo);
 				return MNL_CB_ERROR;
 			}
-			obj_print_plain(obj);
+			obj_print_plain(obj, monh->ctx->octx);
 			obj_free(obj);
 			printf("\n");
 			break;
@@ -2355,7 +2355,7 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 			nlr_for_each_set(nlr, rule_map_decompose_cb, NULL);
 
 			printf("add rule %s %s %s ", family, table, chain);
-			rule_print(r);
+			rule_print(r, monh->ctx->octx);
 			printf("\n");
 
 			rule_free(r);
@@ -2611,7 +2611,7 @@ static void trace_print_hdr(const struct nftnl_trace *nlt)
 }
 
 static void trace_print_expr(const struct nftnl_trace *nlt, unsigned int attr,
-			     struct expr *lhs)
+			     struct expr *lhs, struct output_ctx *octx)
 {
 	struct expr *rhs, *rel;
 	const void *data;
@@ -2623,12 +2623,13 @@ static void trace_print_expr(const struct nftnl_trace *nlt, unsigned int attr,
 				   len * BITS_PER_BYTE, data);
 	rel  = relational_expr_alloc(&netlink_location, OP_EQ, lhs, rhs);
 
-	expr_print(rel);
+	expr_print(rel, octx);
 	printf(" ");
 	expr_free(rel);
 }
 
-static void trace_print_verdict(const struct nftnl_trace *nlt)
+static void trace_print_verdict(const struct nftnl_trace *nlt,
+				 struct output_ctx *octx)
 {
 	const char *chain = NULL;
 	unsigned int verdict;
@@ -2640,11 +2641,12 @@ static void trace_print_verdict(const struct nftnl_trace *nlt)
 	expr = verdict_expr_alloc(&netlink_location, verdict, chain);
 
 	printf("verdict ");
-	expr_print(expr);
+	expr_print(expr, octx);
 	expr_free(expr);
 }
 
-static void trace_print_rule(const struct nftnl_trace *nlt)
+static void trace_print_rule(const struct nftnl_trace *nlt,
+			      struct output_ctx *octx)
 {
 	const struct table *table;
 	uint64_t rule_handle;
@@ -2674,9 +2676,9 @@ static void trace_print_rule(const struct nftnl_trace *nlt)
 
 	trace_print_hdr(nlt);
 	printf("rule ");
-	rule_print(rule);
+	rule_print(rule, octx);
 	printf(" (");
-	trace_print_verdict(nlt);
+	trace_print_verdict(nlt, octx);
 	printf(")\n");
 }
 
@@ -2775,7 +2777,8 @@ next:
 	}
 }
 
-static void trace_print_packet(const struct nftnl_trace *nlt)
+static void trace_print_packet(const struct nftnl_trace *nlt,
+			        struct output_ctx *octx)
 {
 	struct list_head stmts = LIST_HEAD_INIT(stmts);
 	const struct proto_desc *ll_desc;
@@ -2791,11 +2794,11 @@ static void trace_print_packet(const struct nftnl_trace *nlt)
 	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_IIF))
 		trace_print_expr(nlt, NFTNL_TRACE_IIF,
 				 meta_expr_alloc(&netlink_location,
-						 NFT_META_IIF));
+						 NFT_META_IIF), octx);
 	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_OIF))
 		trace_print_expr(nlt, NFTNL_TRACE_OIF,
 				 meta_expr_alloc(&netlink_location,
-						 NFT_META_OIF));
+						 NFT_META_OIF), octx);
 
 	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY));
 	ll_desc = ctx.protocol[PROTO_BASE_LL_HDR].desc;
@@ -2822,7 +2825,7 @@ static void trace_print_packet(const struct nftnl_trace *nlt)
 			PROTO_BASE_TRANSPORT_HDR);
 
 	list_for_each_entry_safe(stmt, next, &stmts, list) {
-		stmt_print(stmt);
+		stmt_print(stmt, octx);
 		printf(" ");
 		stmt_free(stmt);
 	}
@@ -2847,24 +2850,25 @@ static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
 	case NFT_TRACETYPE_RULE:
 		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_LL_HEADER) ||
 		    nftnl_trace_is_set(nlt, NFTNL_TRACE_NETWORK_HEADER))
-			trace_print_packet(nlt);
+			trace_print_packet(nlt, monh->ctx->octx);
 
 		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_RULE_HANDLE))
-			trace_print_rule(nlt);
+			trace_print_rule(nlt, monh->ctx->octx);
 		break;
 	case NFT_TRACETYPE_POLICY:
 	case NFT_TRACETYPE_RETURN:
 		trace_print_hdr(nlt);
 
 		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_VERDICT)) {
-			trace_print_verdict(nlt);
+			trace_print_verdict(nlt, monh->ctx->octx);
 			printf(" ");
 		}
 
 		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_MARK))
 			trace_print_expr(nlt, NFTNL_TRACE_MARK,
 					 meta_expr_alloc(&netlink_location,
-							 NFT_META_MARK));
+							 NFT_META_MARK),
+					 monh->ctx->octx);
 		printf("\n");
 		break;
 	}
diff --git a/src/numgen.c b/src/numgen.c
index 5c1d00a..19a4a9c 100644
--- a/src/numgen.c
+++ b/src/numgen.c
@@ -28,7 +28,7 @@ static const char *numgen_type_str(enum nft_ng_types type)
 	return numgen_type[type];
 }
 
-static void numgen_expr_print(const struct expr *expr)
+static void numgen_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	printf("numgen %s mod %u", numgen_type_str(expr->numgen.type),
 	       expr->numgen.mod);
diff --git a/src/payload.c b/src/payload.c
index 11b6df3..7f94ff7 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -38,7 +38,7 @@ bool payload_is_known(const struct expr *expr)
 	       tmpl != &proto_unknown_template;
 }
 
-static void payload_expr_print(const struct expr *expr)
+static void payload_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct proto_desc *desc;
 	const struct proto_hdr_template *tmpl;
@@ -184,11 +184,11 @@ unsigned int payload_hdr_field(const struct expr *expr)
 	return expr->payload.tmpl - expr->payload.desc->templates;
 }
 
-static void payload_stmt_print(const struct stmt *stmt)
+static void payload_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	expr_print(stmt->payload.expr);
+	expr_print(stmt->payload.expr, octx);
 	printf(" set ");
-	expr_print(stmt->payload.val);
+	expr_print(stmt->payload.val, octx);
 }
 
 static const struct stmt_ops payload_stmt_ops = {
diff --git a/src/proto.c b/src/proto.c
index 2afedf7..64d0632 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -893,9 +893,9 @@ static const struct symbol_table ethertype_tbl = {
 	},
 };
 
-static void ethertype_print(const struct expr *expr)
+static void ethertype_print(const struct expr *expr, struct output_ctx *octx)
 {
-	return symbolic_constant_print(&ethertype_tbl, expr, false);
+	return symbolic_constant_print(&ethertype_tbl, expr, false, octx);
 }
 
 const struct datatype ethertype_type = {
diff --git a/src/rt.c b/src/rt.c
index 232c1dc..eb5f9c3 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -34,9 +34,9 @@ static void __exit realm_table_exit(void)
 	rt_symbol_table_free(realm_tbl);
 }
 
-static void realm_type_print(const struct expr *expr)
+static void realm_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	return symbolic_constant_print(realm_tbl, expr, true);
+	return symbolic_constant_print(realm_tbl, expr, true, octx);
 }
 
 static struct error_record *realm_type_parse(const struct expr *sym,
@@ -75,7 +75,7 @@ static const struct rt_template rt_templates[] = {
 					      true),
 };
 
-static void rt_expr_print(const struct expr *expr)
+static void rt_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	printf("rt %s", rt_templates[expr->rt.key].token);
 }
diff --git a/src/rule.c b/src/rule.c
index 0d9e393..2267d1a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -347,19 +347,20 @@ static void set_print_declaration(const struct set *set,
 	}
 }
 
-static void do_set_print(const struct set *set, struct print_fmt_options *opts)
+static void do_set_print(const struct set *set, struct print_fmt_options *opts,
+			  struct output_ctx *octx)
 {
 	set_print_declaration(set, opts);
 
 	if (set->init != NULL && set->init->size > 0) {
 		printf("%s%selements = ", opts->tab, opts->tab);
-		expr_print(set->init);
+		expr_print(set->init, octx);
 		printf("%s", opts->nl);
 	}
 	printf("%s}%s", opts->tab, opts->nl);
 }
 
-void set_print(const struct set *s)
+void set_print(const struct set *s, struct output_ctx *octx)
 {
 	struct print_fmt_options opts = {
 		.tab		= "\t",
@@ -367,10 +368,10 @@ void set_print(const struct set *s)
 		.stmt_separator	= "\n",
 	};
 
-	do_set_print(s, &opts);
+	do_set_print(s, &opts, octx);
 }
 
-void set_print_plain(const struct set *s)
+void set_print_plain(const struct set *s, struct output_ctx *octx)
 {
 	struct print_fmt_options opts = {
 		.tab		= "",
@@ -380,7 +381,7 @@ void set_print_plain(const struct set *s)
 		.stmt_separator	= ";",
 	};
 
-	do_set_print(s, &opts);
+	do_set_print(s, &opts, octx);
 }
 
 struct rule *rule_alloc(const struct location *loc, const struct handle *h)
@@ -404,12 +405,12 @@ void rule_free(struct rule *rule)
 	xfree(rule);
 }
 
-void rule_print(const struct rule *rule)
+void rule_print(const struct rule *rule, struct output_ctx *octx)
 {
 	const struct stmt *stmt;
 
 	list_for_each_entry(stmt, &rule->stmts, list) {
-		stmt->ops->print(stmt);
+		stmt->ops->print(stmt, octx);
 		if (!list_is_last(&stmt->list, &rule->stmts))
 			printf(" ");
 	}
@@ -417,7 +418,7 @@ void rule_print(const struct rule *rule)
 	if (rule->comment)
 		printf(" comment \"%s\"", rule->comment);
 
-	if (handle_output > 0)
+	if (octx->handle > 0)
 		printf(" # handle %" PRIu64, rule->handle.handle.id);
 }
 
@@ -667,7 +668,7 @@ static void chain_print_declaration(const struct chain *chain)
 	}
 }
 
-static void chain_print(const struct chain *chain)
+static void chain_print(const struct chain *chain, struct output_ctx *octx)
 {
 	struct rule *rule;
 
@@ -675,7 +676,7 @@ static void chain_print(const struct chain *chain)
 
 	list_for_each_entry(rule, &chain->rules, list) {
 		printf("\t\t");
-		rule_print(rule);
+		rule_print(rule, octx);
 		printf("\n");
 	}
 	printf("\t}\n");
@@ -774,7 +775,7 @@ static void table_print_options(const struct table *table, const char **delim)
 	}
 }
 
-static void table_print(const struct table *table)
+static void table_print(const struct table *table, struct output_ctx *octx)
 {
 	struct chain *chain;
 	struct obj *obj;
@@ -787,19 +788,19 @@ static void table_print(const struct table *table)
 
 	list_for_each_entry(obj, &table->objs, list) {
 		printf("%s", delim);
-		obj_print(obj);
+		obj_print(obj, octx);
 		delim = "\n";
 	}
 	list_for_each_entry(set, &table->sets, list) {
 		if (set->flags & NFT_SET_ANONYMOUS)
 			continue;
 		printf("%s", delim);
-		set_print(set);
+		set_print(set, octx);
 		delim = "\n";
 	}
 	list_for_each_entry(chain, &table->chains, list) {
 		printf("%s", delim);
-		chain_print(chain);
+		chain_print(chain, octx);
 		delim = "\n";
 	}
 	printf("}\n");
@@ -1106,7 +1107,7 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 			 struct table *table)
 {
-	table_print(table);
+	table_print(table, ctx->octx);
 	return 0;
 }
 
@@ -1194,13 +1195,14 @@ static void print_proto_name_proto(uint8_t l4)
 }
 
 static void obj_print_data(const struct obj *obj,
-			   struct print_fmt_options *opts)
+			   struct print_fmt_options *opts,
+			   struct output_ctx *octx)
 {
 	switch (obj->type) {
 	case NFT_OBJECT_COUNTER:
 		printf(" %s {%s%s%s", obj->handle.obj,
 				      opts->nl, opts->tab, opts->tab);
-		if (stateless_output) {
+		if (octx->stateless) {
 			printf("packets 0 bytes 0");
 			break;
 		}
@@ -1217,7 +1219,7 @@ static void obj_print_data(const struct obj *obj,
 		printf("%s%"PRIu64" %s",
 		       obj->quota.flags & NFT_QUOTA_F_INV ? "over " : "",
 		       bytes, data_unit);
-		if (!stateless_output && obj->quota.used) {
+		if (!octx->stateless && obj->quota.used) {
 			data_unit = get_rate(obj->quota.used, &bytes);
 			printf(" used %"PRIu64" %s", bytes, data_unit);
 		}
@@ -1250,7 +1252,8 @@ const char *obj_type_name(enum stmt_types type)
 }
 
 static void obj_print_declaration(const struct obj *obj,
-				  struct print_fmt_options *opts)
+				  struct print_fmt_options *opts,
+				  struct output_ctx *octx)
 {
 	printf("%s%s", opts->tab, obj_type_name(obj->type));
 
@@ -1260,12 +1263,12 @@ static void obj_print_declaration(const struct obj *obj,
 	if (opts->table != NULL)
 		printf(" %s", opts->table);
 
-	obj_print_data(obj, opts);
+	obj_print_data(obj, opts, octx);
 
 	printf("%s%s}%s", opts->nl, opts->tab, opts->nl);
 }
 
-void obj_print(const struct obj *obj)
+void obj_print(const struct obj *obj, struct output_ctx *octx)
 {
 	struct print_fmt_options opts = {
 		.tab		= "\t",
@@ -1273,10 +1276,10 @@ void obj_print(const struct obj *obj)
 		.stmt_separator	= "\n",
 	};
 
-	obj_print_declaration(obj, &opts);
+	obj_print_declaration(obj, &opts, octx);
 }
 
-void obj_print_plain(const struct obj *obj)
+void obj_print_plain(const struct obj *obj, struct output_ctx *octx)
 {
 	struct print_fmt_options opts = {
 		.tab		= "",
@@ -1285,7 +1288,7 @@ void obj_print_plain(const struct obj *obj)
 		.family		= family2str(obj->handle.family),
 	};
 
-	obj_print_declaration(obj, &opts);
+	obj_print_declaration(obj, &opts, octx);
 }
 
 static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
@@ -1319,7 +1322,7 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 			     strcmp(cmd->handle.obj, obj->handle.obj)))
 				continue;
 
-			obj_print_declaration(obj, &opts);
+			obj_print_declaration(obj, &opts, ctx->octx);
 		}
 
 		printf("}\n");
@@ -1383,7 +1386,7 @@ static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
 		    strcmp(cmd->handle.chain, chain->handle.chain) != 0)
 			continue;
 
-		chain_print(chain);
+		chain_print(chain, ctx->octx);
 	}
 
 	printf("}\n");
@@ -1423,7 +1426,7 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 		return -1;
 
 	table_print_declaration(table);
-	set_print(set);
+	set_print(set, ctx->octx);
 	printf("}\n");
 
 	return 0;
diff --git a/src/segtree.c b/src/segtree.c
index 15e8849..180fab1 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -64,6 +64,8 @@ struct elementary_interval {
 	struct expr			*expr;
 };
 
+struct output_ctx dummy_pctx = {};
+
 static void seg_tree_init(struct seg_tree *tree, const struct set *set,
 			  struct expr *init)
 {
@@ -564,7 +566,7 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 	}
 
 	if (segtree_debug()) {
-		expr_print(init);
+		expr_print(init, &dummy_pctx);
 		pr_gmp_debug("\n");
 	}
 
diff --git a/src/statement.c b/src/statement.c
index d824dc0..0ce875e 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -60,14 +60,14 @@ void stmt_list_free(struct list_head *list)
 	}
 }
 
-void stmt_print(const struct stmt *stmt)
+void stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	stmt->ops->print(stmt);
+	stmt->ops->print(stmt, octx);
 }
 
-static void expr_stmt_print(const struct stmt *stmt)
+static void expr_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	expr_print(stmt->expr);
+	expr_print(stmt->expr, octx);
 }
 
 static void expr_stmt_destroy(struct stmt *stmt)
@@ -107,20 +107,20 @@ struct stmt *verdict_stmt_alloc(const struct location *loc, struct expr *expr)
 	return stmt;
 }
 
-static void flow_stmt_print(const struct stmt *stmt)
+static void flow_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	printf("flow ");
 	if (stmt->flow.set) {
-		expr_print(stmt->flow.set);
+		expr_print(stmt->flow.set, octx);
 		printf(" ");
 	}
 	printf("{ ");
-	expr_print(stmt->flow.key);
+	expr_print(stmt->flow.key, octx);
 	printf(" ");
 
-	stateless_output++;
-	stmt_print(stmt->flow.stmt);
-	stateless_output--;
+	octx->stateless++;
+	stmt_print(stmt->flow.stmt, octx);
+	octx->stateless--;
 
 	printf("} ");
 
@@ -145,11 +145,11 @@ struct stmt *flow_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &flow_stmt_ops);
 }
 
-static void counter_stmt_print(const struct stmt *stmt)
+static void counter_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	printf("counter");
 
-	if (stateless_output)
+	if (octx->stateless)
 		return;
 
 	printf(" packets %" PRIu64 " bytes %" PRIu64,
@@ -185,7 +185,7 @@ static const char *objref_type_name(uint32_t type)
 	return objref_type[type];
 }
 
-static void objref_stmt_print(const struct stmt *stmt)
+static void objref_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	switch (stmt->objref.type) {
 	case NFT_OBJECT_CT_HELPER:
@@ -195,7 +195,7 @@ static void objref_stmt_print(const struct stmt *stmt)
 		printf("%s name ", objref_type_name(stmt->objref.type));
 		break;
 	}
-	expr_print(stmt->objref.expr);
+	expr_print(stmt->objref.expr, octx);
 }
 
 static const struct stmt_ops objref_stmt_ops = {
@@ -231,7 +231,7 @@ static const char *log_level(uint32_t level)
 	return syslog_level[level];
 }
 
-static void log_stmt_print(const struct stmt *stmt)
+static void log_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	printf("log");
 	if (stmt->log.flags & STMT_LOG_PREFIX)
@@ -320,7 +320,7 @@ const char *get_rate(uint64_t byte_rate, uint64_t *rate)
 	return data_unit[i];
 }
 
-static void limit_stmt_print(const struct stmt *stmt)
+static void limit_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	bool inv = stmt->limit.flags & NFT_LIMIT_F_INV;
 	const char *data_unit;
@@ -365,14 +365,14 @@ struct stmt *limit_stmt_alloc(const struct location *loc)
 	return stmt;
 }
 
-static void queue_stmt_print(const struct stmt *stmt)
+static void queue_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	const char *delim = " ";
 
 	printf("queue");
 	if (stmt->queue.queue != NULL) {
 		printf(" num ");
-		expr_print(stmt->queue.queue);
+		expr_print(stmt->queue.queue, octx);
 	}
 	if (stmt->queue.flags & NFT_QUEUE_FLAG_BYPASS) {
 		printf("%sbypass", delim);
@@ -394,7 +394,7 @@ struct stmt *queue_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &queue_stmt_ops);
 }
 
-static void quota_stmt_print(const struct stmt *stmt)
+static void quota_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	bool inv = stmt->quota.flags & NFT_QUOTA_F_INV;
 	const char *data_unit;
@@ -404,7 +404,7 @@ static void quota_stmt_print(const struct stmt *stmt)
 	printf("quota %s%"PRIu64" %s",
 	       inv ? "over " : "", bytes, data_unit);
 
-	if (!stateless_output && stmt->quota.used) {
+	if (!octx->stateless && stmt->quota.used) {
 		data_unit = get_rate(stmt->quota.used, &used);
 		printf(" used %"PRIu64" %s", used, data_unit);
 	}
@@ -425,7 +425,7 @@ struct stmt *quota_stmt_alloc(const struct location *loc)
 	return stmt;
 }
 
-static void reject_stmt_print(const struct stmt *stmt)
+static void reject_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	printf("reject");
 	switch (stmt->reject.type) {
@@ -436,7 +436,7 @@ static void reject_stmt_print(const struct stmt *stmt)
 		if (stmt->reject.icmp_code == NFT_REJECT_ICMPX_PORT_UNREACH)
 			break;
 		printf(" with icmpx type ");
-		expr_print(stmt->reject.expr);
+		expr_print(stmt->reject.expr, octx);
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
 		switch (stmt->reject.family) {
@@ -444,13 +444,13 @@ static void reject_stmt_print(const struct stmt *stmt)
 			if (stmt->reject.icmp_code == ICMP_PORT_UNREACH)
 				break;
 			printf(" with icmp type ");
-			expr_print(stmt->reject.expr);
+			expr_print(stmt->reject.expr, octx);
 			break;
 		case NFPROTO_IPV6:
 			if (stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
 				break;
 			printf(" with icmpv6 type ");
-			expr_print(stmt->reject.expr);
+			expr_print(stmt->reject.expr, octx);
 			break;
 		}
 		break;
@@ -489,7 +489,7 @@ static void print_nf_nat_flags(uint32_t flags)
 		printf("%spersistent", delim);
 }
 
-static void nat_stmt_print(const struct stmt *stmt)
+static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	static const char *nat_types[] = {
 		[NFT_NAT_SNAT]	= "snat",
@@ -502,26 +502,26 @@ static void nat_stmt_print(const struct stmt *stmt)
 			if (stmt->nat.addr->ops->type == EXPR_VALUE &&
 			    stmt->nat.addr->dtype->type == TYPE_IP6ADDR) {
 				printf("[");
-				expr_print(stmt->nat.addr);
+				expr_print(stmt->nat.addr, octx);
 				printf("]");
 			} else if (stmt->nat.addr->ops->type == EXPR_RANGE &&
 				   stmt->nat.addr->left->dtype->type == TYPE_IP6ADDR) {
 				printf("[");
-				expr_print(stmt->nat.addr->left);
+				expr_print(stmt->nat.addr->left, octx);
 				printf("]-[");
-				expr_print(stmt->nat.addr->right);
+				expr_print(stmt->nat.addr->right, octx);
 				printf("]");
 			} else {
-				expr_print(stmt->nat.addr);
+				expr_print(stmt->nat.addr, octx);
 			}
 		} else {
-			expr_print(stmt->nat.addr);
+			expr_print(stmt->nat.addr, octx);
 		}
 	}
 
 	if (stmt->nat.proto) {
 		printf(":");
-		expr_print(stmt->nat.proto);
+		expr_print(stmt->nat.proto, octx);
 	}
 
 	print_nf_nat_flags(stmt->nat.flags);
@@ -545,13 +545,13 @@ struct stmt *nat_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &nat_stmt_ops);
 }
 
-static void masq_stmt_print(const struct stmt *stmt)
+static void masq_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	printf("masquerade");
 
 	if (stmt->masq.proto) {
 		printf(" to :");
-		expr_print(stmt->masq.proto);
+		expr_print(stmt->masq.proto, octx);
 	}
 
 	print_nf_nat_flags(stmt->masq.flags);
@@ -574,13 +574,13 @@ struct stmt *masq_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &masq_stmt_ops);
 }
 
-static void redir_stmt_print(const struct stmt *stmt)
+static void redir_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	printf("redirect");
 
 	if (stmt->redir.proto) {
 		printf(" to :");
-		expr_print(stmt->redir.proto);
+		expr_print(stmt->redir.proto, octx);
 	}
 
 	print_nf_nat_flags(stmt->redir.flags);
@@ -608,12 +608,12 @@ static const char * const set_stmt_op_names[] = {
 	[NFT_DYNSET_OP_UPDATE]	= "update",
 };
 
-static void set_stmt_print(const struct stmt *stmt)
+static void set_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	printf("set %s ", set_stmt_op_names[stmt->set.op]);
-	expr_print(stmt->set.key);
+	expr_print(stmt->set.key, octx);
 	printf(" ");
-	expr_print(stmt->set.set);
+	expr_print(stmt->set.set, octx);
 }
 
 static void set_stmt_destroy(struct stmt *stmt)
@@ -634,16 +634,16 @@ struct stmt *set_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &set_stmt_ops);
 }
 
-static void dup_stmt_print(const struct stmt *stmt)
+static void dup_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	printf("dup");
 	if (stmt->dup.to != NULL) {
 		printf(" to ");
-		expr_print(stmt->dup.to);
+		expr_print(stmt->dup.to, octx);
 
 		if (stmt->dup.dev != NULL) {
 			printf(" device ");
-			expr_print(stmt->dup.dev);
+			expr_print(stmt->dup.dev, octx);
 		}
 	}
 }
@@ -666,10 +666,10 @@ struct stmt *dup_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &dup_stmt_ops);
 }
 
-static void fwd_stmt_print(const struct stmt *stmt)
+static void fwd_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	printf("fwd to ");
-	expr_print(stmt->fwd.to);
+	expr_print(stmt->fwd.to, octx);
 }
 
 static void fwd_stmt_destroy(struct stmt *stmt)
@@ -689,7 +689,7 @@ struct stmt *fwd_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &fwd_stmt_ops);
 }
 
-static void xt_stmt_print(const struct stmt *stmt)
+static void xt_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	xt_stmt_xlate(stmt);
 }
-- 
2.9.4

