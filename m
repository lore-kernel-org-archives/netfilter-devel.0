From: Eric Leblond <eric@regit.org>
Subject: [PATH nft v2 12/18] libnftables: get rid of printf
Date: Sat, 19 Aug 2017 17:24:14 +0200
Message-ID: <20170819152420.22563-13-eric@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:33778 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751593AbdHSPcr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 11:32:47 -0400
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use a custom print function that user will be able to set instead of
using a direct call to printf.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/datatype.h   |   5 +-
 include/expression.h |   2 +-
 include/nftables.h   |   2 +
 src/ct.c             |  20 +++----
 src/datatype.c       |  61 +++++++++++---------
 src/expression.c     |  70 +++++++++++------------
 src/exthdr.c         |   8 +--
 src/fib.c            |  23 ++++----
 src/hash.c           |  10 ++--
 src/libnftables.c    |  14 +++++
 src/meta.c           |  26 ++++-----
 src/numgen.c         |   4 +-
 src/payload.c        |   4 +-
 src/rule.c           | 159 ++++++++++++++++++++++++++-------------------------
 src/statement.c      | 122 +++++++++++++++++++--------------------
 15 files changed, 279 insertions(+), 251 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 2e34591..e9f6079 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -209,7 +209,8 @@ extern void symbolic_constant_print(const struct symbol_table *tbl,
 				    struct output_ctx *octx);
 extern void symbol_table_print(const struct symbol_table *tbl,
 			       const struct datatype *dtype,
-			       enum byteorder byteorder);
+			       enum byteorder byteorder,
+			       struct output_ctx *octx);
 
 extern struct symbol_table *rt_symbol_table_init(const char *filename);
 extern void rt_symbol_table_free(struct symbol_table *tbl);
@@ -261,7 +262,7 @@ extern const struct datatype *
 set_datatype_alloc(const struct datatype *orig_dtype, unsigned int byteorder);
 extern void set_datatype_destroy(const struct datatype *dtype);
 
-extern void time_print(uint64_t seconds);
+extern void time_print(uint64_t seconds, struct output_ctx *octx);
 extern struct error_record *time_parse(const struct location *loc,
 				       const char *c, uint64_t *res);
 
diff --git a/include/expression.h b/include/expression.h
index 828dbae..d82642d 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -334,7 +334,7 @@ extern struct expr *expr_get(struct expr *expr);
 extern void expr_free(struct expr *expr);
 extern void expr_print(const struct expr *expr, struct output_ctx *octx);
 extern bool expr_cmp(const struct expr *e1, const struct expr *e2);
-extern void expr_describe(const struct expr *expr);
+extern void expr_describe(const struct expr *expr, struct output_ctx *octx);
 
 extern const struct datatype *expr_basetype(const struct expr *expr);
 extern void expr_set_type(struct expr *expr, const struct datatype *dtype,
diff --git a/include/nftables.h b/include/nftables.h
index 348fbb0..ddff5d8 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -30,6 +30,8 @@ struct output_ctx {
 	unsigned int ip2name;
 	unsigned int handle;
 	unsigned int echo;
+	void *ctx;
+	int (*print)(void *ctx, const char *format, ...);
 };
 
 struct nft_cache {
diff --git a/src/ct.c b/src/ct.c
index d64f467..4367b21 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -141,11 +141,11 @@ static void ct_label_type_print(const struct expr *expr,
 	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
 		if (bit != s->value)
 			continue;
-		printf("\"%s\"", s->identifier);
+		octx->print(octx->ctx, "\"%s\"", s->identifier);
 		return;
 	}
 	/* can happen when connlabel.conf is altered after rules were added */
-	printf("%ld\n", (long)mpz_scan1(expr->value, 0));
+	octx->print(octx->ctx, "%ld\n", (long)mpz_scan1(expr->value, 0));
 }
 
 static struct error_record *ct_label_type_parse(const struct expr *sym,
@@ -269,27 +269,27 @@ static const struct ct_template ct_templates[] = {
 					      BYTEORDER_HOST_ENDIAN, 32),
 };
 
-static void ct_print(enum nft_ct_keys key, int8_t dir)
+static void ct_print(enum nft_ct_keys key, int8_t dir, struct output_ctx *octx)
 {
 	const struct symbolic_constant *s;
 
-	printf("ct ");
+	octx->print(octx->ctx, "ct ");
 	if (dir < 0)
 		goto done;
 
 	for (s = ct_dir_tbl.symbols; s->identifier != NULL; s++) {
 		if (dir == (int)s->value) {
-			printf("%s ", s->identifier);
+			octx->print(octx->ctx, "%s ", s->identifier);
 			break;
 		}
 	}
  done:
-	printf("%s", ct_templates[key].token);
+	octx->print(octx->ctx, "%s", ct_templates[key].token);
 }
 
 static void ct_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	ct_print(expr->ct.key, expr->ct.direction);
+	ct_print(expr->ct.key, expr->ct.direction, octx);
 }
 
 static bool ct_expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -445,8 +445,8 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 
 static void ct_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	ct_print(stmt->ct.key, stmt->ct.direction);
-	printf(" set ");
+	ct_print(stmt->ct.key, stmt->ct.direction, octx);
+	octx->print(octx->ctx, " set ");
 	expr_print(stmt->ct.expr, octx);
 }
 
@@ -472,7 +472,7 @@ struct stmt *ct_stmt_alloc(const struct location *loc, enum nft_ct_keys key,
 
 static void notrack_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("notrack");
+	octx->print(octx->ctx, "notrack");
 }
 
 static const struct stmt_ops notrack_stmt_ops = {
diff --git a/src/datatype.c b/src/datatype.c
index 5bd0c7b..1f500e2 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -192,15 +192,15 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 		return expr_basetype(expr)->print(expr, octx);
 
 	if (quotes)
-		printf("\"");
+		octx->print(octx->ctx, "\"");
 
 	if (octx->numeric > NUMERIC_ALL)
-		printf("%"PRIu64"", val);
+		octx->print(octx->ctx, "%"PRIu64"", val);
 	else
-		printf("%s", s->identifier);
+		octx->print(octx->ctx, "%s", s->identifier);
 
 	if (quotes)
-		printf("\"");
+		octx->print(octx->ctx, "\"");
 }
 
 static void switch_byteorder(void *data, unsigned int len)
@@ -215,7 +215,8 @@ static void switch_byteorder(void *data, unsigned int len)
 
 void symbol_table_print(const struct symbol_table *tbl,
 			const struct datatype *dtype,
-			enum byteorder byteorder)
+			enum byteorder byteorder,
+			struct output_ctx *octx)
 {
 	const struct symbolic_constant *s;
 	unsigned int len = dtype->size / BITS_PER_BYTE;
@@ -228,16 +229,18 @@ void symbol_table_print(const struct symbol_table *tbl,
 			switch_byteorder(&value, len);
 
 		if (tbl->base == BASE_DECIMAL)
-			printf("\t%-30s\t%20"PRIu64"\n", s->identifier, value);
+			octx->print(octx->ctx, "\t%-30s\t%20"PRIu64"\n", s->identifier, value);
 		else
-			printf("\t%-30s\t0x%.*" PRIx64 "\n",
+			octx->print(octx->ctx, "\t%-30s\t0x%.*" PRIx64 "\n",
 			       s->identifier, 2 * len, value);
 	}
 }
 
 static void invalid_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	gmp_printf("0x%Zx [invalid type]", expr->value);
+	char buf[512];
+	gmp_snprintf(buf, sizeof(buf), "0x%Zx [invalid type]", expr->value);
+	octx->print(octx->ctx, "%s", buf);
 }
 
 const struct datatype invalid_type = {
@@ -251,30 +254,30 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	switch (expr->verdict) {
 	case NFT_CONTINUE:
-		printf("continue");
+		octx->print(octx->ctx, "continue");
 		break;
 	case NFT_BREAK:
-		printf("break");
+		octx->print(octx->ctx, "break");
 		break;
 	case NFT_JUMP:
-		printf("jump %s", expr->chain);
+		octx->print(octx->ctx, "jump %s", expr->chain);
 		break;
 	case NFT_GOTO:
-		printf("goto %s", expr->chain);
+		octx->print(octx->ctx, "goto %s", expr->chain);
 		break;
 	case NFT_RETURN:
-		printf("return");
+		octx->print(octx->ctx, "return");
 		break;
 	default:
 		switch (expr->verdict & NF_VERDICT_MASK) {
 		case NF_ACCEPT:
-			printf("accept");
+			octx->print(octx->ctx, "accept");
 			break;
 		case NF_DROP:
-			printf("drop");
+			octx->print(octx->ctx, "drop");
 			break;
 		case NF_QUEUE:
-			printf("queue");
+			octx->print(octx->ctx, "queue");
 			break;
 		default:
 			BUG("invalid verdict value %u\n", expr->verdict);
@@ -319,6 +322,7 @@ static void integer_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct datatype *dtype = expr->dtype;
 	const char *fmt = "%Zu";
+	char buf[256];
 
 	do {
 		if (dtype->basefmt != NULL) {
@@ -327,7 +331,8 @@ static void integer_type_print(const struct expr *expr, struct output_ctx *octx)
 		}
 	} while ((dtype = dtype->basetype));
 
-	gmp_printf(fmt, expr->value);
+	gmp_snprintf(buf, sizeof(buf),fmt, expr->value);
+	octx->print(octx->ctx, "%s", buf);
 }
 
 static struct error_record *integer_type_parse(const struct expr *sym,
@@ -364,7 +369,7 @@ static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 
 	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
 	data[len] = '\0';
-	printf("\"%s\"", data);
+	octx->print(octx->ctx, "\"%s\"", data);
 }
 
 static struct error_record *string_type_parse(const struct expr *sym,
@@ -396,7 +401,7 @@ static void lladdr_type_print(const struct expr *expr, struct output_ctx *octx)
 	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 
 	for (i = 0; i < len; i++) {
-		printf("%s%.2x", delim, data[i]);
+		octx->print(octx->ctx, "%s%.2x", delim, data[i]);
 		delim = ":";
 	}
 }
@@ -449,7 +454,7 @@ static void ipaddr_type_print(const struct expr *expr, struct output_ctx *octx)
 		getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
 	}
-	printf("%s", buf);
+	octx->print(octx->ctx, "%s", buf);
 }
 
 static struct error_record *ipaddr_type_parse(const struct expr *sym,
@@ -507,7 +512,7 @@ static void ip6addr_type_print(const struct expr *expr, struct output_ctx *octx)
 		getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
 	}
-	printf("%s", buf);
+	octx->print(octx->ctx, "%s", buf);
 }
 
 static struct error_record *ip6addr_type_parse(const struct expr *sym,
@@ -557,7 +562,7 @@ static void inet_protocol_type_print(const struct expr *expr,
 	if (octx->numeric < NUMERIC_ALL) {
 		p = getprotobynumber(mpz_get_uint8(expr->value));
 		if (p != NULL) {
-			printf("%s", p->p_name);
+			octx->print(octx->ctx, "%s", p->p_name);
 			return;
 		}
 	}
@@ -821,7 +826,7 @@ const struct datatype icmpx_code_type = {
 	.sym_tbl	= &icmpx_code_tbl,
 };
 
-void time_print(uint64_t seconds)
+void time_print(uint64_t seconds, struct output_ctx *octx)
 {
 	uint64_t days, hours, minutes;
 
@@ -835,13 +840,13 @@ void time_print(uint64_t seconds)
 	seconds %= 60;
 
 	if (days > 0)
-		printf("%"PRIu64"d", days);
+		octx->print(octx->ctx, "%"PRIu64"d", days);
 	if (hours > 0)
-		printf("%"PRIu64"h", hours);
+		octx->print(octx->ctx, "%"PRIu64"h", hours);
 	if (minutes > 0)
-		printf("%"PRIu64"m", minutes);
+		octx->print(octx->ctx, "%"PRIu64"m", minutes);
 	if (seconds > 0)
-		printf("%"PRIu64"s", seconds);
+		octx->print(octx->ctx, "%"PRIu64"s", seconds);
 }
 
 enum {
@@ -933,7 +938,7 @@ struct error_record *time_parse(const struct location *loc, const char *str,
 
 static void time_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	time_print(mpz_get_uint64(expr->value) / MSEC_PER_SEC);
+	time_print(mpz_get_uint64(expr->value) / MSEC_PER_SEC, octx);
 }
 
 static struct error_record *time_type_parse(const struct expr *sym,
diff --git a/src/expression.c b/src/expression.c
index d41ada3..6d70739 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -86,41 +86,41 @@ bool expr_cmp(const struct expr *e1, const struct expr *e2)
 	return e1->ops->cmp(e1, e2);
 }
 
-void expr_describe(const struct expr *expr)
+void expr_describe(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct datatype *dtype = expr->dtype;
 	const char *delim = "";
 
-	printf("%s expression, datatype %s (%s)",
+	octx->print(octx->ctx, "%s expression, datatype %s (%s)",
 		expr->ops->name, dtype->name, dtype->desc);
 	if (dtype->basetype != NULL) {
-		printf(" (basetype ");
+		octx->print(octx->ctx, " (basetype ");
 		for (dtype = dtype->basetype; dtype != NULL;
 		     dtype = dtype->basetype) {
-			printf("%s%s", delim, dtype->desc);
+			octx->print(octx->ctx, "%s%s", delim, dtype->desc);
 			delim = ", ";
 		}
-		printf(")");
+		octx->print(octx->ctx, ")");
 	}
 
 	if (expr_basetype(expr)->type == TYPE_STRING) {
 		if (expr->len)
-			printf(", %u characters", expr->len / BITS_PER_BYTE);
+			octx->print(octx->ctx, ", %u characters", expr->len / BITS_PER_BYTE);
 		else
-			printf(", dynamic length");
+			octx->print(octx->ctx, ", dynamic length");
 	} else
-		printf(", %u bits", expr->len);
+		octx->print(octx->ctx, ", %u bits", expr->len);
 
-	printf("\n");
+	octx->print(octx->ctx, "\n");
 
 	if (expr->dtype->sym_tbl != NULL) {
-		printf("\npre-defined symbolic constants ");
+		octx->print(octx->ctx, "\npre-defined symbolic constants ");
 		if (expr->dtype->sym_tbl->base == BASE_DECIMAL)
-			printf("(in decimal):\n");
+			octx->print(octx->ctx, "(in decimal):\n");
 		else
-			printf("(in hexadecimal):\n");
+			octx->print(octx->ctx, "(in hexadecimal):\n");
 		symbol_table_print(expr->dtype->sym_tbl, expr->dtype,
-				   expr->byteorder);
+				   expr->byteorder, octx);
 	}
 }
 
@@ -215,7 +215,7 @@ struct expr *verdict_expr_alloc(const struct location *loc,
 
 static void symbol_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	printf("%s%s", expr->scope != NULL ? "$" : "", expr->identifier);
+	octx->print(octx->ctx, "%s%s", expr->scope != NULL ? "$" : "", expr->identifier);
 }
 
 static void symbol_expr_clone(struct expr *new, const struct expr *expr)
@@ -398,7 +398,7 @@ struct expr *bitmask_expr_to_binops(struct expr *expr)
 static void prefix_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	expr_print(expr->prefix, octx);
-	printf("/%u", expr->prefix_len);
+	octx->print(octx->ctx, "/%u", expr->prefix_len);
 }
 
 static void prefix_expr_set_type(const struct expr *expr,
@@ -513,10 +513,10 @@ static void binop_arg_print(const struct expr *op, const struct expr *arg,
 		prec = 1;
 
 	if (prec)
-		printf("(");
+		octx->print(octx->ctx, "(");
 	expr_print(arg, octx);
 	if (prec)
-		printf(")");
+		octx->print(octx->ctx, ")");
 }
 
 static bool must_print_eq_op(const struct expr *expr)
@@ -534,9 +534,9 @@ static void binop_expr_print(const struct expr *expr, struct output_ctx *octx)
 
 	if (expr_op_symbols[expr->op] &&
 	    (expr->op != OP_EQ || must_print_eq_op(expr)))
-		printf(" %s ", expr_op_symbols[expr->op]);
+		octx->print(octx->ctx, " %s ", expr_op_symbols[expr->op]);
 	else
-		printf(" ");
+		octx->print(octx->ctx, " ");
 
 	binop_arg_print(expr, expr->right, octx);
 }
@@ -602,7 +602,7 @@ static void range_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	octx->numeric += NUMERIC_ALL + 1;
 	expr_print(expr->left, octx);
-	printf("-");
+	octx->print(octx->ctx, "-");
 	expr_print(expr->right, octx);
 	octx->numeric -= NUMERIC_ALL + 1;
 }
@@ -682,7 +682,7 @@ static void compound_expr_print(const struct expr *expr, const char *delim,
 	const char *d = "";
 
 	list_for_each_entry(i, &expr->expressions, list) {
-		printf("%s", d);
+		octx->print(octx->ctx, "%s", d);
 		expr_print(i, octx);
 		d = delim;
 	}
@@ -793,16 +793,16 @@ static void set_expr_print(const struct expr *expr, struct output_ctx *octx)
 	const char *d = "";
 	int count = 0;
 
-	printf("{ ");
+	octx->print(octx->ctx, "{ ");
 
 	list_for_each_entry(i, &expr->expressions, list) {
-		printf("%s", d);
+		octx->print(octx->ctx, "%s", d);
 		expr_print(i, octx);
 		count++;
 		d = calculate_delim(expr, &count);
 	}
 
-	printf(" }");
+	octx->print(octx->ctx, " }");
 }
 
 static void set_expr_set_type(const struct expr *expr,
@@ -840,7 +840,7 @@ struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 static void mapping_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	expr_print(expr->left, octx);
-	printf(" : ");
+	octx->print(octx->ctx, " : ");
 	expr_print(expr->right, octx);
 }
 
@@ -889,9 +889,9 @@ static void map_expr_print(const struct expr *expr, struct output_ctx *octx)
 	expr_print(expr->map, octx);
 	if (expr->mappings->ops->type == EXPR_SET_REF &&
 	    expr->mappings->set->datatype->type == TYPE_VERDICT)
-		printf(" vmap ");
+		octx->print(octx->ctx, " vmap ");
 	else
-		printf(" map ");
+		octx->print(octx->ctx, " map ");
 	expr_print(expr->mappings, octx);
 }
 
@@ -930,11 +930,11 @@ static void set_ref_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	if (expr->set->flags & NFT_SET_ANONYMOUS) {
 		if (expr->set->flags & NFT_SET_EVAL)
-			printf("table %s", expr->set->handle.set);
+			octx->print(octx->ctx, "table %s", expr->set->handle.set);
 		else
 			expr_print(expr->set->init, octx);
 	} else {
-		printf("@%s", expr->set->handle.set);
+		octx->print(octx->ctx, "@%s", expr->set->handle.set);
 	}
 }
 
@@ -971,18 +971,18 @@ static void set_elem_expr_print(const struct expr *expr,
 {
 	expr_print(expr->key, octx);
 	if (expr->timeout) {
-		printf(" timeout ");
-		time_print(expr->timeout / 1000);
+		octx->print(octx->ctx, " timeout ");
+		time_print(expr->timeout / 1000, octx);
 	}
 	if (!octx->stateless && expr->expiration) {
-		printf(" expires ");
-		time_print(expr->expiration / 1000);
+		octx->print(octx->ctx, " expires ");
+		time_print(expr->expiration / 1000, octx);
 	}
 	if (expr->comment)
-		printf(" comment \"%s\"", expr->comment);
+		octx->print(octx->ctx, " comment \"%s\"", expr->comment);
 
 	if (expr->stmt) {
-		printf(" : ");
+		octx->print(octx->ctx, " : ");
 		stmt_print(expr->stmt, octx);
 	}
 }
diff --git a/src/exthdr.c b/src/exthdr.c
index a412025..21ceedd 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -33,19 +33,19 @@ static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 		char buf[9] = {0};
 
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT) {
-			printf("tcp option %s", expr->exthdr.desc->name);
+			octx->print(octx->ctx, "tcp option %s", expr->exthdr.desc->name);
 			return;
 		}
 
 		if (offset)
 			snprintf(buf, sizeof buf, "%d", offset);
-		printf("tcp option %s%s %s", expr->exthdr.desc->name, buf,
+		octx->print(octx->ctx, "tcp option %s%s %s", expr->exthdr.desc->name, buf,
 					     expr->exthdr.tmpl->token);
 	} else {
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
-			printf("exthdr %s", expr->exthdr.desc->name);
+			octx->print(octx->ctx, "exthdr %s", expr->exthdr.desc->name);
 		else {
-			printf("%s %s", expr->exthdr.desc ? expr->exthdr.desc->name : "unknown-exthdr",
+			octx->print(octx->ctx, "%s %s", expr->exthdr.desc ? expr->exthdr.desc->name : "unknown-exthdr",
 					expr->exthdr.tmpl->token);
 		}
 	}
diff --git a/src/fib.c b/src/fib.c
index b3488af..202b6b1 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -60,32 +60,33 @@ static const char *fib_result_str(enum nft_fib_result result)
 	return "unknown";
 }
 
-static void __fib_expr_print_f(unsigned int *flags, unsigned int f, const char *s)
+static void __fib_expr_print_f(unsigned int *flags, unsigned int f,
+			       const char *s, struct output_ctx *octx)
 {
 	if ((*flags & f) == 0)
 		return;
 
-	printf("%s", s);
+	octx->print(octx->ctx, "%s", s);
 	*flags &= ~f;
 	if (*flags)
-		printf(" . ");
+		octx->print(octx->ctx, " . ");
 }
 
 static void fib_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	unsigned int flags = expr->fib.flags & ~NFTA_FIB_F_PRESENT;
 
-	printf("fib ");
-	__fib_expr_print_f(&flags, NFTA_FIB_F_SADDR, "saddr");
-	__fib_expr_print_f(&flags, NFTA_FIB_F_DADDR, "daddr");
-	__fib_expr_print_f(&flags, NFTA_FIB_F_MARK, "mark");
-	__fib_expr_print_f(&flags, NFTA_FIB_F_IIF, "iif");
-	__fib_expr_print_f(&flags, NFTA_FIB_F_OIF, "oif");
+	octx->print(octx->ctx, "fib ");
+	__fib_expr_print_f(&flags, NFTA_FIB_F_SADDR, "saddr", octx);
+	__fib_expr_print_f(&flags, NFTA_FIB_F_DADDR, "daddr", octx);
+	__fib_expr_print_f(&flags, NFTA_FIB_F_MARK, "mark", octx);
+	__fib_expr_print_f(&flags, NFTA_FIB_F_IIF, "iif", octx);
+	__fib_expr_print_f(&flags, NFTA_FIB_F_OIF, "oif", octx);
 
 	if (flags)
-		printf("0x%x", flags);
+		octx->print(octx->ctx, "0x%x", flags);
 
-	printf(" %s", fib_result_str(expr->fib.result));
+	octx->print(octx->ctx, " %s", fib_result_str(expr->fib.result));
 }
 
 static bool fib_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/hash.c b/src/hash.c
index 1a4bfb3..c42d360 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -19,19 +19,19 @@ static void hash_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	switch (expr->hash.type) {
 	case NFT_HASH_SYM:
-		printf("symhash");
+		octx->print(octx->ctx, "symhash");
 	break;
 	case NFT_HASH_JENKINS:
 	default:
-		printf("jhash ");
+		octx->print(octx->ctx, "jhash ");
 		expr_print(expr->hash.expr, octx);
 	}
 
-	printf(" mod %u", expr->hash.mod);
+	octx->print(octx->ctx, " mod %u", expr->hash.mod);
 	if (expr->hash.seed_set)
-		printf(" seed 0x%x", expr->hash.seed);
+		octx->print(octx->ctx, " seed 0x%x", expr->hash.seed);
 	if (expr->hash.offset)
-		printf(" offset %u", expr->hash.offset);
+		octx->print(octx->ctx, " offset %u", expr->hash.offset);
 }
 
 static bool hash_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/libnftables.c b/src/libnftables.c
index 2228156..7209885 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -58,6 +58,17 @@ void nft_global_deinit(void)
 	mark_table_exit();
 }
 
+__attribute__((format(printf, 2, 0)))
+static int nft_print(void *ctx, const char *fmt, ...)
+{
+	va_list arg;
+	va_start(arg, fmt);
+	vfprintf(stdout, fmt, arg);
+	va_end(arg);
+
+	return 0;
+} 
+
 struct nft_ctx *nft_context_new(void)
 {
 	struct nft_ctx *ctx = NULL;
@@ -67,8 +78,11 @@ struct nft_ctx *nft_context_new(void)
 
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->nf_sock = netlink_open_sock();
+
 	init_list_head(&ctx->cache.list);
 
+	ctx->output.ctx = ctx;
+	ctx->output.print = nft_print;
 	return ctx;
 }
 
diff --git a/src/meta.c b/src/meta.c
index 9c80893..9994d57 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -54,13 +54,13 @@ static void tchandle_type_print(const struct expr *expr,
 
 	switch(handle) {
 	case TC_H_ROOT:
-		printf("root");
+		octx->print(octx->ctx, "root");
 		break;
 	case TC_H_UNSPEC:
-		printf("none");
+		octx->print(octx->ctx, "none");
 		break;
 	default:
-		printf("%0x:%0x", TC_H_MAJ(handle) >> 16, TC_H_MIN(handle));
+		octx->print(octx->ctx, "%0x:%0x", TC_H_MAJ(handle) >> 16, TC_H_MIN(handle));
 		break;
 	}
 }
@@ -134,9 +134,9 @@ static void ifindex_type_print(const struct expr *expr, struct output_ctx *octx)
 
 	ifindex = mpz_get_uint32(expr->value);
 	if (nft_if_indextoname(ifindex, name))
-		printf("\"%s\"", name);
+		octx->print(octx->ctx, "\"%s\"", name);
 	else
-		printf("%d", ifindex);
+		octx->print(octx->ctx, "%d", ifindex);
 }
 
 static struct error_record *ifindex_type_parse(const struct expr *sym,
@@ -209,9 +209,9 @@ static void uid_type_print(const struct expr *expr, struct output_ctx *octx)
 
 		pw = getpwuid(uid);
 		if (pw != NULL)
-			printf("\"%s\"", pw->pw_name);
+			octx->print(octx->ctx, "\"%s\"", pw->pw_name);
 		else
-			printf("%d", uid);
+			octx->print(octx->ctx, "%d", uid);
 		return;
 	}
 	expr_basetype(expr)->print(expr, octx);
@@ -261,9 +261,9 @@ static void gid_type_print(const struct expr *expr, struct output_ctx *octx)
 
 		gr = getgrgid(gid);
 		if (gr != NULL)
-			printf("\"%s\"", gr->gr_name);
+			octx->print(octx->ctx, "\"%s\"", gr->gr_name);
 		else
-			printf("%u", gid);
+			octx->print(octx->ctx, "%u", gid);
 		return;
 	}
 	expr_basetype(expr)->print(expr, octx);
@@ -446,9 +446,9 @@ static bool meta_key_is_qualified(enum nft_meta_keys key)
 static void meta_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	if (meta_key_is_qualified(expr->meta.key))
-		printf("meta %s", meta_templates[expr->meta.key].token);
+		octx->print(octx->ctx, "meta %s", meta_templates[expr->meta.key].token);
 	else
-		printf("%s", meta_templates[expr->meta.key].token);
+		octx->print(octx->ctx, "%s", meta_templates[expr->meta.key].token);
 }
 
 static bool meta_expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -573,9 +573,9 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 static void meta_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	if (meta_key_is_qualified(stmt->meta.key))
-		printf("meta %s set ", meta_templates[stmt->meta.key].token);
+		octx->print(octx->ctx, "meta %s set ", meta_templates[stmt->meta.key].token);
 	else
-		printf("%s set ", meta_templates[stmt->meta.key].token);
+		octx->print(octx->ctx, "%s set ", meta_templates[stmt->meta.key].token);
 
 	expr_print(stmt->meta.expr, octx);
 }
diff --git a/src/numgen.c b/src/numgen.c
index 19a4a9c..e6938ce 100644
--- a/src/numgen.c
+++ b/src/numgen.c
@@ -30,10 +30,10 @@ static const char *numgen_type_str(enum nft_ng_types type)
 
 static void numgen_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	printf("numgen %s mod %u", numgen_type_str(expr->numgen.type),
+	octx->print(octx->ctx, "numgen %s mod %u", numgen_type_str(expr->numgen.type),
 	       expr->numgen.mod);
 	if (expr->numgen.offset)
-		printf(" offset %u", expr->numgen.offset);
+		octx->print(octx->ctx, " offset %u", expr->numgen.offset);
 }
 
 static bool numgen_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/payload.c b/src/payload.c
index 7f94ff7..fd6cb3a 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -46,9 +46,9 @@ static void payload_expr_print(const struct expr *expr, struct output_ctx *octx)
 	desc = expr->payload.desc;
 	tmpl = expr->payload.tmpl;
 	if (payload_is_known(expr))
-		printf("%s %s", desc->name, tmpl->token);
+		octx->print(octx->ctx, "%s %s", desc->name, tmpl->token);
 	else
-		printf("payload @%s,%u,%u",
+		octx->print(octx->ctx, "payload @%s,%u,%u",
 		       proto_base_tokens[expr->payload.base],
 		       expr->payload.offset, expr->len);
 }
diff --git a/src/rule.c b/src/rule.c
index ef12bec..364dd13 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -271,7 +271,8 @@ static const char *set_policy2str(uint32_t policy)
 }
 
 static void set_print_declaration(const struct set *set,
-				  struct print_fmt_options *opts)
+				  struct print_fmt_options *opts,
+				  struct output_ctx *octx)
 {
 	const char *delim = "";
 	const char *type;
@@ -284,33 +285,33 @@ static void set_print_declaration(const struct set *set,
 	else
 		type = "set";
 
-	printf("%s%s", opts->tab, type);
+	octx->print(octx->ctx, "%s%s", opts->tab, type);
 
 	if (opts->family != NULL)
-		printf(" %s", opts->family);
+		octx->print(octx->ctx, " %s", opts->family);
 
 	if (opts->table != NULL)
-		printf(" %s", opts->table);
+		octx->print(octx->ctx, " %s", opts->table);
 
-	printf(" %s {%s", set->handle.set, opts->nl);
+	octx->print(octx->ctx, " %s {%s", set->handle.set, opts->nl);
 
-	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
+	octx->print(octx->ctx, "%s%stype %s", opts->tab, opts->tab, set->keytype->name);
 	if (set->flags & NFT_SET_MAP)
-		printf(" : %s", set->datatype->name);
+		octx->print(octx->ctx, " : %s", set->datatype->name);
 	else if (set->flags & NFT_SET_OBJECT)
-		printf(" : %s", obj_type_name(set->objtype));
+		octx->print(octx->ctx, " : %s", obj_type_name(set->objtype));
 
-	printf("%s", opts->stmt_separator);
+	octx->print(octx->ctx, "%s", opts->stmt_separator);
 
 	if (!(set->flags & (NFT_SET_CONSTANT))) {
 		if (set->policy != NFT_SET_POL_PERFORMANCE) {
-			printf("%s%spolicy %s%s", opts->tab, opts->tab,
+			octx->print(octx->ctx, "%s%spolicy %s%s", opts->tab, opts->tab,
 			       set_policy2str(set->policy),
 			       opts->stmt_separator);
 		}
 
 		if (set->desc.size > 0) {
-			printf("%s%ssize %u%s", opts->tab, opts->tab,
+			octx->print(octx->ctx, "%s%ssize %u%s", opts->tab, opts->tab,
 			       set->desc.size, opts->stmt_separator);
 		}
 	}
@@ -321,45 +322,45 @@ static void set_print_declaration(const struct set *set,
 		flags &= ~NFT_SET_TIMEOUT;
 
 	if (flags & (NFT_SET_CONSTANT | NFT_SET_INTERVAL | NFT_SET_TIMEOUT)) {
-		printf("%s%sflags ", opts->tab, opts->tab);
+		octx->print(octx->ctx, "%s%sflags ", opts->tab, opts->tab);
 		if (set->flags & NFT_SET_CONSTANT) {
-			printf("%sconstant", delim);
+			octx->print(octx->ctx, "%sconstant", delim);
 			delim = ",";
 		}
 		if (set->flags & NFT_SET_INTERVAL) {
-			printf("%sinterval", delim);
+			octx->print(octx->ctx, "%sinterval", delim);
 			delim = ",";
 		}
 		if (set->flags & NFT_SET_TIMEOUT) {
-			printf("%stimeout", delim);
+			octx->print(octx->ctx, "%stimeout", delim);
 			delim = ",";
 		}
-		printf("%s", opts->stmt_separator);
+		octx->print(octx->ctx, "%s", opts->stmt_separator);
 	}
 
 	if (set->timeout) {
-		printf("%s%stimeout ", opts->tab, opts->tab);
-		time_print(set->timeout / 1000);
-		printf("%s", opts->stmt_separator);
+		octx->print(octx->ctx, "%s%stimeout ", opts->tab, opts->tab);
+		time_print(set->timeout / 1000, octx);
+		octx->print(octx->ctx, "%s", opts->stmt_separator);
 	}
 	if (set->gc_int) {
-		printf("%s%sgc-interval ", opts->tab, opts->tab);
-		time_print(set->gc_int / 1000);
-		printf("%s", opts->stmt_separator);
+		octx->print(octx->ctx, "%s%sgc-interval ", opts->tab, opts->tab);
+		time_print(set->gc_int / 1000, octx);
+		octx->print(octx->ctx, "%s", opts->stmt_separator);
 	}
 }
 
 static void do_set_print(const struct set *set, struct print_fmt_options *opts,
 			  struct output_ctx *octx)
 {
-	set_print_declaration(set, opts);
+	set_print_declaration(set, opts, octx);
 
 	if (set->init != NULL && set->init->size > 0) {
-		printf("%s%selements = ", opts->tab, opts->tab);
+		octx->print(octx->ctx, "%s%selements = ", opts->tab, opts->tab);
 		expr_print(set->init, octx);
-		printf("%s", opts->nl);
+		octx->print(octx->ctx, "%s", opts->nl);
 	}
-	printf("%s}%s", opts->tab, opts->nl);
+	octx->print(octx->ctx, "%s}%s", opts->tab, opts->nl);
 }
 
 void set_print(const struct set *s, struct output_ctx *octx)
@@ -424,14 +425,14 @@ void rule_print(const struct rule *rule, struct output_ctx *octx)
 	list_for_each_entry(stmt, &rule->stmts, list) {
 		stmt->ops->print(stmt, octx);
 		if (!list_is_last(&stmt->list, &rule->stmts))
-			printf(" ");
+			octx->print(octx->ctx, " ");
 	}
 
 	if (rule->comment)
-		printf(" comment \"%s\"", rule->comment);
+		octx->print(octx->ctx, " comment \"%s\"", rule->comment);
 
 	if (octx->handle > 0)
-		printf(" # handle %" PRIu64, rule->handle.handle.id);
+		octx->print(octx->ctx, " # handle %" PRIu64, rule->handle.handle.id);
 }
 
 struct rule *rule_lookup(const struct chain *chain, uint64_t handle)
@@ -661,18 +662,19 @@ static const char *chain_policy2str(uint32_t policy)
 	return "unknown";
 }
 
-static void chain_print_declaration(const struct chain *chain)
+static void chain_print_declaration(const struct chain *chain,
+				    struct output_ctx *octx)
 {
-	printf("\tchain %s {\n", chain->handle.chain);
+	octx->print(octx->ctx, "\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		if (chain->dev != NULL) {
-			printf("\t\ttype %s hook %s device %s priority %d; policy %s;\n",
+			octx->print(octx->ctx, "\t\ttype %s hook %s device %s priority %d; policy %s;\n",
 			       chain->type,
 			       hooknum2str(chain->handle.family, chain->hooknum),
 			       chain->dev, chain->priority,
 			       chain_policy2str(chain->policy));
 		} else {
-			printf("\t\ttype %s hook %s priority %d; policy %s;\n",
+			octx->print(octx->ctx, "\t\ttype %s hook %s priority %d; policy %s;\n",
 			       chain->type,
 			       hooknum2str(chain->handle.family, chain->hooknum),
 			       chain->priority, chain_policy2str(chain->policy));
@@ -684,14 +686,14 @@ static void chain_print(const struct chain *chain, struct output_ctx *octx)
 {
 	struct rule *rule;
 
-	chain_print_declaration(chain);
+	chain_print_declaration(chain, octx);
 
 	list_for_each_entry(rule, &chain->rules, list) {
-		printf("\t\t");
+		octx->print(octx->ctx, "\t\t");
 		rule_print(rule, octx);
-		printf("\n");
+		octx->print(octx->ctx, "\n");
 	}
-	printf("\t}\n");
+	octx->print(octx->ctx, "\t}\n");
 }
 
 void chain_print_plain(const struct chain *chain)
@@ -796,27 +798,27 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 	const char *delim = "";
 	const char *family = family2str(table->handle.family);
 
-	printf("table %s %s {\n", family, table->handle.table);
+	octx->print(octx->ctx, "table %s %s {\n", family, table->handle.table);
 	table_print_options(table, &delim);
 
 	list_for_each_entry(obj, &table->objs, list) {
-		printf("%s", delim);
+		octx->print(octx->ctx, "%s", delim);
 		obj_print(obj, octx);
 		delim = "\n";
 	}
 	list_for_each_entry(set, &table->sets, list) {
 		if (set->flags & NFT_SET_ANONYMOUS)
 			continue;
-		printf("%s", delim);
+		octx->print(octx->ctx, "%s", delim);
 		set_print(set, octx);
 		delim = "\n";
 	}
 	list_for_each_entry(chain, &table->chains, list) {
-		printf("%s", delim);
+		octx->print(octx->ctx, "%s", delim);
 		chain_print(chain, octx);
 		delim = "\n";
 	}
-	printf("}\n");
+	octx->print(octx->ctx, "}\n");
 }
 
 struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
@@ -1176,7 +1178,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		printf("table %s %s {\n",
+		ctx->octx->print(ctx->octx->ctx, "table %s %s {\n",
 		       family2str(table->handle.family),
 		       table->handle.table);
 
@@ -1191,11 +1193,12 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 			if (cmd->obj == CMD_OBJ_MAPS &&
 			    !(set->flags & NFT_SET_MAP))
 				continue;
-			set_print_declaration(set, &opts);
-			printf("%s}%s", opts.tab, opts.nl);
+			set_print_declaration(set, &opts, ctx->octx);
+			ctx->octx->print(ctx->octx->ctx, "%s}%s",
+					 opts.tab, opts.nl);
 		}
 
-		printf("}\n");
+		ctx->octx->print(ctx->octx->ctx, "}\n");
 	}
 	return 0;
 }
@@ -1260,40 +1263,40 @@ static void obj_print_data(const struct obj *obj,
 {
 	switch (obj->type) {
 	case NFT_OBJECT_COUNTER:
-		printf(" %s {%s%s%s", obj->handle.obj,
+		octx->print(octx->ctx, " %s {%s%s%s", obj->handle.obj,
 				      opts->nl, opts->tab, opts->tab);
 		if (octx->stateless) {
-			printf("packets 0 bytes 0");
+			octx->print(octx->ctx, "packets 0 bytes 0");
 			break;
 		}
-		printf("packets %"PRIu64" bytes %"PRIu64"",
+		octx->print(octx->ctx, "packets %"PRIu64" bytes %"PRIu64"",
 		       obj->counter.packets, obj->counter.bytes);
 		break;
 	case NFT_OBJECT_QUOTA: {
 		const char *data_unit;
 		uint64_t bytes;
 
-		printf(" %s {%s%s%s", obj->handle.obj,
+		octx->print(octx->ctx, " %s {%s%s%s", obj->handle.obj,
 				      opts->nl, opts->tab, opts->tab);
 		data_unit = get_rate(obj->quota.bytes, &bytes);
-		printf("%s%"PRIu64" %s",
+		octx->print(octx->ctx, "%s%"PRIu64" %s",
 		       obj->quota.flags & NFT_QUOTA_F_INV ? "over " : "",
 		       bytes, data_unit);
 		if (!octx->stateless && obj->quota.used) {
 			data_unit = get_rate(obj->quota.used, &bytes);
-			printf(" used %"PRIu64" %s", bytes, data_unit);
+			octx->print(octx->ctx, " used %"PRIu64" %s", bytes, data_unit);
 		}
 		}
 		break;
 	case NFT_OBJECT_CT_HELPER: {
-		printf("ct helper %s {\n", obj->handle.obj);
-		printf("\t\ttype \"%s\" protocol ", obj->ct_helper.name);
+		octx->print(octx->ctx, "ct helper %s {\n", obj->handle.obj);
+		octx->print(octx->ctx, "\t\ttype \"%s\" protocol ", obj->ct_helper.name);
 		print_proto_name_proto(obj->ct_helper.l4proto);
-		printf("\t\tl3proto %s", family2str(obj->ct_helper.l3proto));
+		octx->print(octx->ctx, "\t\tl3proto %s", family2str(obj->ct_helper.l3proto));
 		break;
 		}
 	default:
-		printf("unknown {%s", opts->nl);
+		octx->print(octx->ctx, "unknown {%s", opts->nl);
 		break;
 	}
 }
@@ -1328,17 +1331,17 @@ static void obj_print_declaration(const struct obj *obj,
 				  struct print_fmt_options *opts,
 				  struct output_ctx *octx)
 {
-	printf("%s%s", opts->tab, obj_type_name(obj->type));
+	octx->print(octx->ctx, "%s%s", opts->tab, obj_type_name(obj->type));
 
 	if (opts->family != NULL)
-		printf(" %s", opts->family);
+		octx->print(octx->ctx, " %s", opts->family);
 
 	if (opts->table != NULL)
-		printf(" %s", opts->table);
+		octx->print(octx->ctx, " %s", opts->table);
 
 	obj_print_data(obj, opts, octx);
 
-	printf("%s%s}%s", opts->nl, opts->tab, opts->nl);
+	octx->print(octx->ctx, "%s%s}%s", opts->nl, opts->tab, opts->nl);
 }
 
 void obj_print(const struct obj *obj, struct output_ctx *octx)
@@ -1379,13 +1382,13 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		printf("table %s %s {\n",
+		ctx->octx->print(ctx->octx->ctx, "table %s %s {\n",
 		       family2str(table->handle.family),
 		       table->handle.table);
 
 		if (cmd->handle.table != NULL &&
 		    strcmp(cmd->handle.table, table->handle.table)) {
-			printf("}\n");
+			ctx->octx->print(ctx->octx->ctx, "}\n");
 			continue;
 		}
 
@@ -1398,7 +1401,7 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 			obj_print_declaration(obj, &opts, ctx->octx);
 		}
 
-		printf("}\n");
+		ctx->octx->print(ctx->octx->ctx, "}\n");
 	}
 	return 0;
 }
@@ -1434,7 +1437,7 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		printf("table %s %s\n",
+		ctx->octx->print(ctx->octx->ctx, "table %s %s\n",
 		       family2str(table->handle.family),
 		       table->handle.table);
 	}
@@ -1442,9 +1445,10 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
-static void table_print_declaration(struct table *table)
+static void table_print_declaration(struct table *table,
+				    struct output_ctx *octx)
 {
-	printf("table %s %s {\n",
+	octx->print(octx->ctx, "table %s %s {\n",
 		family2str(table->handle.family),
 		table->handle.table);
 }
@@ -1454,7 +1458,7 @@ static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
 {
 	struct chain *chain;
 
-	table_print_declaration(table);
+	table_print_declaration(table, ctx->octx);
 
 	list_for_each_entry(chain, &table->chains, list) {
 		if (chain->handle.family != cmd->handle.family ||
@@ -1464,7 +1468,7 @@ static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
 		chain_print(chain, ctx->octx);
 	}
 
-	printf("}\n");
+	ctx->octx->print(ctx->octx->ctx, "}\n");
 
 	return 0;
 }
@@ -1479,13 +1483,13 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		table_print_declaration(table);
+		table_print_declaration(table, ctx->octx);
 
 		list_for_each_entry(chain, &table->chains, list) {
-			chain_print_declaration(chain);
-			printf("\t}\n");
+			chain_print_declaration(chain, ctx->octx);
+			ctx->octx->print(ctx->octx->ctx, "\t}\n");
 		}
-		printf("}\n");
+		ctx->octx->print(ctx->octx->ctx, "}\n");
 	}
 
 	return 0;
@@ -1500,9 +1504,9 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 	if (set == NULL)
 		return -1;
 
-	table_print_declaration(table);
+	table_print_declaration(table, ctx->octx);
 	set_print(set, ctx->octx);
-	printf("}\n");
+	ctx->octx->print(ctx->octx->ctx, "}\n");
 
 	return 0;
 }
@@ -1689,9 +1693,10 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 	return netlink_monitor(&monhandler, ctx->nf_sock);
 }
 
-static int do_command_describe(struct netlink_ctx *ctx, struct cmd *cmd)
+static int do_command_describe(struct netlink_ctx *ctx, struct cmd *cmd,
+			       struct output_ctx *octx)
 {
-	expr_describe(cmd->expr);
+	expr_describe(cmd->expr, octx);
 	return 0;
 }
 
@@ -1737,7 +1742,7 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_MONITOR:
 		return do_command_monitor(ctx, cmd);
 	case CMD_DESCRIBE:
-		return do_command_describe(ctx, cmd);
+		return do_command_describe(ctx, cmd, ctx->octx);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/statement.c b/src/statement.c
index 0ce875e..bb9b862 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -109,20 +109,20 @@ struct stmt *verdict_stmt_alloc(const struct location *loc, struct expr *expr)
 
 static void flow_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("flow ");
+	octx->print(octx->ctx, "flow ");
 	if (stmt->flow.set) {
 		expr_print(stmt->flow.set, octx);
-		printf(" ");
+		octx->print(octx->ctx, " ");
 	}
-	printf("{ ");
+	octx->print(octx->ctx, "{ ");
 	expr_print(stmt->flow.key, octx);
-	printf(" ");
+	octx->print(octx->ctx, " ");
 
 	octx->stateless++;
 	stmt_print(stmt->flow.stmt, octx);
 	octx->stateless--;
 
-	printf("} ");
+	octx->print(octx->ctx, "} ");
 
 }
 
@@ -147,12 +147,12 @@ struct stmt *flow_stmt_alloc(const struct location *loc)
 
 static void counter_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("counter");
+	octx->print(octx->ctx, "counter");
 
 	if (octx->stateless)
 		return;
 
-	printf(" packets %" PRIu64 " bytes %" PRIu64,
+	octx->print(octx->ctx, " packets %" PRIu64 " bytes %" PRIu64,
 	       stmt->counter.packets, stmt->counter.bytes);
 }
 
@@ -189,10 +189,10 @@ static void objref_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	switch (stmt->objref.type) {
 	case NFT_OBJECT_CT_HELPER:
-		printf("ct helper set ");
+		octx->print(octx->ctx, "ct helper set ");
 		break;
 	default:
-		printf("%s name ", objref_type_name(stmt->objref.type));
+		octx->print(octx->ctx, "%s name ", objref_type_name(stmt->objref.type));
 		break;
 	}
 	expr_print(stmt->objref.expr, octx);
@@ -233,39 +233,39 @@ static const char *log_level(uint32_t level)
 
 static void log_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("log");
+	octx->print(octx->ctx, "log");
 	if (stmt->log.flags & STMT_LOG_PREFIX)
-		printf(" prefix \"%s\"", stmt->log.prefix);
+		octx->print(octx->ctx, " prefix \"%s\"", stmt->log.prefix);
 	if (stmt->log.flags & STMT_LOG_GROUP)
-		printf(" group %u", stmt->log.group);
+		octx->print(octx->ctx, " group %u", stmt->log.group);
 	if (stmt->log.flags & STMT_LOG_SNAPLEN)
-		printf(" snaplen %u", stmt->log.snaplen);
+		octx->print(octx->ctx, " snaplen %u", stmt->log.snaplen);
 	if (stmt->log.flags & STMT_LOG_QTHRESHOLD)
-		printf(" queue-threshold %u", stmt->log.qthreshold);
+		octx->print(octx->ctx, " queue-threshold %u", stmt->log.qthreshold);
 	if ((stmt->log.flags & STMT_LOG_LEVEL) &&
 	    stmt->log.level != LOG_WARNING)
-		printf(" level %s", log_level(stmt->log.level));
+		octx->print(octx->ctx, " level %s", log_level(stmt->log.level));
 
 	if ((stmt->log.logflags & NF_LOG_MASK) == NF_LOG_MASK) {
-		printf(" flags all");
+		octx->print(octx->ctx, " flags all");
 	} else {
 		if (stmt->log.logflags & (NF_LOG_TCPSEQ | NF_LOG_TCPOPT)) {
 			const char *delim = " ";
 
-			printf(" flags tcp");
+			octx->print(octx->ctx, " flags tcp");
 			if (stmt->log.logflags & NF_LOG_TCPSEQ) {
-				printf(" sequence");
+				octx->print(octx->ctx, " sequence");
 				delim = ",";
 			}
 			if (stmt->log.logflags & NF_LOG_TCPOPT)
-				printf("%soptions", delim);
+				octx->print(octx->ctx, "%soptions", delim);
 		}
 		if (stmt->log.logflags & NF_LOG_IPOPT)
-			printf(" flags ip options");
+			octx->print(octx->ctx, " flags ip options");
 		if (stmt->log.logflags & NF_LOG_UID)
-			printf(" flags skuid");
+			octx->print(octx->ctx, " flags skuid");
 		if (stmt->log.logflags & NF_LOG_MACDECODE)
-			printf(" flags ether");
+			octx->print(octx->ctx, " flags ether");
 	}
 }
 
@@ -328,23 +328,23 @@ static void limit_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 
 	switch (stmt->limit.type) {
 	case NFT_LIMIT_PKTS:
-		printf("limit rate %s%" PRIu64 "/%s",
+		octx->print(octx->ctx, "limit rate %s%" PRIu64 "/%s",
 		       inv ? "over " : "", stmt->limit.rate,
 		       get_unit(stmt->limit.unit));
 		if (stmt->limit.burst > 0)
-			printf(" burst %u packets", stmt->limit.burst);
+			octx->print(octx->ctx, " burst %u packets", stmt->limit.burst);
 		break;
 	case NFT_LIMIT_PKT_BYTES:
 		data_unit = get_rate(stmt->limit.rate, &rate);
 
-		printf("limit rate %s%" PRIu64 " %s/%s",
+		octx->print(octx->ctx, "limit rate %s%" PRIu64 " %s/%s",
 		       inv ? "over " : "", rate, data_unit,
 		       get_unit(stmt->limit.unit));
 		if (stmt->limit.burst > 0) {
 			uint64_t burst;
 
 			data_unit = get_rate(stmt->limit.burst, &burst);
-			printf(" burst %"PRIu64" %s", burst, data_unit);
+			octx->print(octx->ctx, " burst %"PRIu64" %s", burst, data_unit);
 		}
 		break;
 	}
@@ -369,17 +369,17 @@ static void queue_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	const char *delim = " ";
 
-	printf("queue");
+	octx->print(octx->ctx, "queue");
 	if (stmt->queue.queue != NULL) {
-		printf(" num ");
+		octx->print(octx->ctx, " num ");
 		expr_print(stmt->queue.queue, octx);
 	}
 	if (stmt->queue.flags & NFT_QUEUE_FLAG_BYPASS) {
-		printf("%sbypass", delim);
+		octx->print(octx->ctx, "%sbypass", delim);
 		delim = ",";
 	}
 	if (stmt->queue.flags & NFT_QUEUE_FLAG_CPU_FANOUT)
-		printf("%sfanout", delim);
+		octx->print(octx->ctx, "%sfanout", delim);
 
 }
 
@@ -401,12 +401,12 @@ static void quota_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	uint64_t bytes, used;
 
 	data_unit = get_rate(stmt->quota.bytes, &bytes);
-	printf("quota %s%"PRIu64" %s",
+	octx->print(octx->ctx, "quota %s%"PRIu64" %s",
 	       inv ? "over " : "", bytes, data_unit);
 
 	if (!octx->stateless && stmt->quota.used) {
 		data_unit = get_rate(stmt->quota.used, &used);
-		printf(" used %"PRIu64" %s", used, data_unit);
+		octx->print(octx->ctx, " used %"PRIu64" %s", used, data_unit);
 	}
 }
 
@@ -427,15 +427,15 @@ struct stmt *quota_stmt_alloc(const struct location *loc)
 
 static void reject_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("reject");
+	octx->print(octx->ctx, "reject");
 	switch (stmt->reject.type) {
 	case NFT_REJECT_TCP_RST:
-		printf(" with tcp reset");
+		octx->print(octx->ctx, " with tcp reset");
 		break;
 	case NFT_REJECT_ICMPX_UNREACH:
 		if (stmt->reject.icmp_code == NFT_REJECT_ICMPX_PORT_UNREACH)
 			break;
-		printf(" with icmpx type ");
+		octx->print(octx->ctx, " with icmpx type ");
 		expr_print(stmt->reject.expr, octx);
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
@@ -443,13 +443,13 @@ static void reject_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		case NFPROTO_IPV4:
 			if (stmt->reject.icmp_code == ICMP_PORT_UNREACH)
 				break;
-			printf(" with icmp type ");
+			octx->print(octx->ctx, " with icmp type ");
 			expr_print(stmt->reject.expr, octx);
 			break;
 		case NFPROTO_IPV6:
 			if (stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
 				break;
-			printf(" with icmpv6 type ");
+			octx->print(octx->ctx, " with icmpv6 type ");
 			expr_print(stmt->reject.expr, octx);
 			break;
 		}
@@ -468,7 +468,7 @@ struct stmt *reject_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &reject_stmt_ops);
 }
 
-static void print_nf_nat_flags(uint32_t flags)
+static void print_nf_nat_flags(uint32_t flags, struct output_ctx *octx)
 {
 	const char *delim = " ";
 
@@ -476,17 +476,17 @@ static void print_nf_nat_flags(uint32_t flags)
 		return;
 
 	if (flags & NF_NAT_RANGE_PROTO_RANDOM) {
-		printf("%srandom", delim);
+		octx->print(octx->ctx, "%srandom", delim);
 		delim = ",";
 	}
 
 	if (flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
-		printf("%sfully-random", delim);
+		octx->print(octx->ctx, "%sfully-random", delim);
 		delim = ",";
 	}
 
 	if (flags & NF_NAT_RANGE_PERSISTENT)
-		printf("%spersistent", delim);
+		octx->print(octx->ctx, "%spersistent", delim);
 }
 
 static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
@@ -496,21 +496,21 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		[NFT_NAT_DNAT]	= "dnat",
 	};
 
-	printf("%s to ", nat_types[stmt->nat.type]);
+	octx->print(octx->ctx, "%s to ", nat_types[stmt->nat.type]);
 	if (stmt->nat.addr) {
 		if (stmt->nat.proto) {
 			if (stmt->nat.addr->ops->type == EXPR_VALUE &&
 			    stmt->nat.addr->dtype->type == TYPE_IP6ADDR) {
-				printf("[");
+				octx->print(octx->ctx, "[");
 				expr_print(stmt->nat.addr, octx);
-				printf("]");
+				octx->print(octx->ctx, "]");
 			} else if (stmt->nat.addr->ops->type == EXPR_RANGE &&
 				   stmt->nat.addr->left->dtype->type == TYPE_IP6ADDR) {
-				printf("[");
+				octx->print(octx->ctx, "[");
 				expr_print(stmt->nat.addr->left, octx);
-				printf("]-[");
+				octx->print(octx->ctx, "]-[");
 				expr_print(stmt->nat.addr->right, octx);
-				printf("]");
+				octx->print(octx->ctx, "]");
 			} else {
 				expr_print(stmt->nat.addr, octx);
 			}
@@ -520,11 +520,11 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	}
 
 	if (stmt->nat.proto) {
-		printf(":");
+		octx->print(octx->ctx, ":");
 		expr_print(stmt->nat.proto, octx);
 	}
 
-	print_nf_nat_flags(stmt->nat.flags);
+	print_nf_nat_flags(stmt->nat.flags, octx);
 }
 
 static void nat_stmt_destroy(struct stmt *stmt)
@@ -547,14 +547,14 @@ struct stmt *nat_stmt_alloc(const struct location *loc)
 
 static void masq_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("masquerade");
+	octx->print(octx->ctx, "masquerade");
 
 	if (stmt->masq.proto) {
-		printf(" to :");
+		octx->print(octx->ctx, " to :");
 		expr_print(stmt->masq.proto, octx);
 	}
 
-	print_nf_nat_flags(stmt->masq.flags);
+	print_nf_nat_flags(stmt->masq.flags, octx);
 }
 
 static void masq_stmt_destroy(struct stmt *stmt)
@@ -576,14 +576,14 @@ struct stmt *masq_stmt_alloc(const struct location *loc)
 
 static void redir_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("redirect");
+	octx->print(octx->ctx, "redirect");
 
 	if (stmt->redir.proto) {
-		printf(" to :");
+		octx->print(octx->ctx, " to :");
 		expr_print(stmt->redir.proto, octx);
 	}
 
-	print_nf_nat_flags(stmt->redir.flags);
+	print_nf_nat_flags(stmt->redir.flags, octx);
 }
 
 static void redir_stmt_destroy(struct stmt *stmt)
@@ -610,9 +610,9 @@ static const char * const set_stmt_op_names[] = {
 
 static void set_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("set %s ", set_stmt_op_names[stmt->set.op]);
+	octx->print(octx->ctx, "set %s ", set_stmt_op_names[stmt->set.op]);
 	expr_print(stmt->set.key, octx);
-	printf(" ");
+	octx->print(octx->ctx, " ");
 	expr_print(stmt->set.set, octx);
 }
 
@@ -636,13 +636,13 @@ struct stmt *set_stmt_alloc(const struct location *loc)
 
 static void dup_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("dup");
+	octx->print(octx->ctx, "dup");
 	if (stmt->dup.to != NULL) {
-		printf(" to ");
+		octx->print(octx->ctx, " to ");
 		expr_print(stmt->dup.to, octx);
 
 		if (stmt->dup.dev != NULL) {
-			printf(" device ");
+			octx->print(octx->ctx, " device ");
 			expr_print(stmt->dup.dev, octx);
 		}
 	}
@@ -668,7 +668,7 @@ struct stmt *dup_stmt_alloc(const struct location *loc)
 
 static void fwd_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("fwd to ");
+	octx->print(octx->ctx, "fwd to ");
 	expr_print(stmt->fwd.to, octx);
 }
 
-- 
2.14.1

