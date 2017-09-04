From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH v2 2/2] src: get rid of printf
Date: Mon,  4 Sep 2017 09:55:58 +0200
Message-ID: <20170904075558.10129-3-eric@regit.org>
References: <20170903223441.GB12383@salvia>
 <20170904075558.10129-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:45430 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751949AbdIDH40 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2017 03:56:26 -0400
In-Reply-To: <20170904075558.10129-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces the nft_print function that has to be used
instead of printf to output information that were previously send
to stdout. This function accumulate the output in a buffer that can
be fetched by the user with the nft_ctx_get_output() function.

This modification will allow the libnftables library to provide an
easy way to the users to get the output data and display them like
they want.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/datatype.h   |   5 +-
 include/expression.h |   2 +-
 include/nftables.h   |   5 ++
 src/cli.c            |   1 +
 src/ct.c             |  20 ++---
 src/datatype.c       |  66 ++++++++-------
 src/expression.c     |  75 ++++++++---------
 src/exthdr.c         |  16 ++--
 src/fib.c            |  23 +++---
 src/hash.c           |  10 +--
 src/main.c           |  45 +++++++++++
 src/meta.c           |  32 +++++---
 src/numgen.c         |   8 +-
 src/payload.c        |   8 +-
 src/rule.c           | 222 ++++++++++++++++++++++++++++-----------------------
 src/statement.c      | 139 ++++++++++++++++----------------
 16 files changed, 390 insertions(+), 287 deletions(-)

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
index 32d4423..ce6b702 100644
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
index 3429e4c..0ddfd3d 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -30,6 +30,8 @@ struct output_ctx {
 	unsigned int ip2name;
 	unsigned int handle;
 	unsigned int echo;
+	char *output_buf;
+	size_t output_buf_len;
 };
 
 struct nft_cache {
@@ -148,4 +150,7 @@ void realm_table_meta_exit(void);
 void devgroup_table_exit(void);
 void realm_table_rt_exit(void);
 
+int nft_print(struct output_ctx *octx, const char *fmt, ...);
+char *nft_ctx_get_output(struct nft_ctx *ctx);
+
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/src/cli.c b/src/cli.c
index d923ff7..ca4418c 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -138,6 +138,7 @@ static void cli_complete(char *line)
 		    cli_nft->debug_mask);
 	scanner_push_buffer(scanner, &indesc_cli, line);
 	nft_run(cli_nft, cli_nf_sock, scanner, state, &msgs);
+	printf("%s", nft_ctx_get_output(cli_nft));
 	erec_print_list(stdout, &msgs, cli_nft->debug_mask);
 	xfree(line);
 	cache_release(&cli_nft->cache);
diff --git a/src/ct.c b/src/ct.c
index d64f467..482fbe0 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -141,11 +141,11 @@ static void ct_label_type_print(const struct expr *expr,
 	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
 		if (bit != s->value)
 			continue;
-		printf("\"%s\"", s->identifier);
+		nft_print(octx, "\"%s\"", s->identifier);
 		return;
 	}
 	/* can happen when connlabel.conf is altered after rules were added */
-	printf("%ld\n", (long)mpz_scan1(expr->value, 0));
+	nft_print(octx, "%ld\n", (long)mpz_scan1(expr->value, 0));
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
+	nft_print(octx, "ct ");
 	if (dir < 0)
 		goto done;
 
 	for (s = ct_dir_tbl.symbols; s->identifier != NULL; s++) {
 		if (dir == (int)s->value) {
-			printf("%s ", s->identifier);
+			nft_print(octx, "%s ", s->identifier);
 			break;
 		}
 	}
  done:
-	printf("%s", ct_templates[key].token);
+	nft_print(octx, "%s", ct_templates[key].token);
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
+	nft_print(octx, " set ");
 	expr_print(stmt->ct.expr, octx);
 }
 
@@ -472,7 +472,7 @@ struct stmt *ct_stmt_alloc(const struct location *loc, enum nft_ct_keys key,
 
 static void notrack_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("notrack");
+	nft_print(octx, "notrack");
 }
 
 static const struct stmt_ops notrack_stmt_ops = {
diff --git a/src/datatype.c b/src/datatype.c
index 5bd0c7b..f7335a3 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -192,15 +192,15 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 		return expr_basetype(expr)->print(expr, octx);
 
 	if (quotes)
-		printf("\"");
+		nft_print(octx, "\"");
 
 	if (octx->numeric > NUMERIC_ALL)
-		printf("%"PRIu64"", val);
+		nft_print(octx, "%" PRIu64 "", val);
 	else
-		printf("%s", s->identifier);
+		nft_print(octx, "%s", s->identifier);
 
 	if (quotes)
-		printf("\"");
+		nft_print(octx, "\"");
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
@@ -228,16 +229,21 @@ void symbol_table_print(const struct symbol_table *tbl,
 			switch_byteorder(&value, len);
 
 		if (tbl->base == BASE_DECIMAL)
-			printf("\t%-30s\t%20"PRIu64"\n", s->identifier, value);
+			nft_print(octx,
+				  "\t%-30s\t%20" PRIu64 "\n",
+				  s->identifier, value);
 		else
-			printf("\t%-30s\t0x%.*" PRIx64 "\n",
-			       s->identifier, 2 * len, value);
+			nft_print(octx,
+				  "\t%-30s\t0x%.*" PRIx64 "\n",
+				  s->identifier, 2 * len, value);
 	}
 }
 
 static void invalid_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	gmp_printf("0x%Zx [invalid type]", expr->value);
+	char buf[512];
+	gmp_snprintf(buf, sizeof(buf), "0x%Zx [invalid type]", expr->value);
+	nft_print(octx, "%s", buf);
 }
 
 const struct datatype invalid_type = {
@@ -251,30 +257,30 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	switch (expr->verdict) {
 	case NFT_CONTINUE:
-		printf("continue");
+		nft_print(octx, "continue");
 		break;
 	case NFT_BREAK:
-		printf("break");
+		nft_print(octx, "break");
 		break;
 	case NFT_JUMP:
-		printf("jump %s", expr->chain);
+		nft_print(octx, "jump %s", expr->chain);
 		break;
 	case NFT_GOTO:
-		printf("goto %s", expr->chain);
+		nft_print(octx, "goto %s", expr->chain);
 		break;
 	case NFT_RETURN:
-		printf("return");
+		nft_print(octx, "return");
 		break;
 	default:
 		switch (expr->verdict & NF_VERDICT_MASK) {
 		case NF_ACCEPT:
-			printf("accept");
+			nft_print(octx, "accept");
 			break;
 		case NF_DROP:
-			printf("drop");
+			nft_print(octx, "drop");
 			break;
 		case NF_QUEUE:
-			printf("queue");
+			nft_print(octx, "queue");
 			break;
 		default:
 			BUG("invalid verdict value %u\n", expr->verdict);
@@ -319,6 +325,7 @@ static void integer_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct datatype *dtype = expr->dtype;
 	const char *fmt = "%Zu";
+	char buf[256];
 
 	do {
 		if (dtype->basefmt != NULL) {
@@ -327,7 +334,8 @@ static void integer_type_print(const struct expr *expr, struct output_ctx *octx)
 		}
 	} while ((dtype = dtype->basetype));
 
-	gmp_printf(fmt, expr->value);
+	gmp_snprintf(buf, sizeof(buf),fmt, expr->value);
+	nft_print(octx, "%s", buf);
 }
 
 static struct error_record *integer_type_parse(const struct expr *sym,
@@ -364,7 +372,7 @@ static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 
 	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
 	data[len] = '\0';
-	printf("\"%s\"", data);
+	nft_print(octx, "\"%s\"", data);
 }
 
 static struct error_record *string_type_parse(const struct expr *sym,
@@ -396,7 +404,7 @@ static void lladdr_type_print(const struct expr *expr, struct output_ctx *octx)
 	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 
 	for (i = 0; i < len; i++) {
-		printf("%s%.2x", delim, data[i]);
+		nft_print(octx, "%s%.2x", delim, data[i]);
 		delim = ":";
 	}
 }
@@ -449,7 +457,7 @@ static void ipaddr_type_print(const struct expr *expr, struct output_ctx *octx)
 		getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
 	}
-	printf("%s", buf);
+	nft_print(octx, "%s", buf);
 }
 
 static struct error_record *ipaddr_type_parse(const struct expr *sym,
@@ -507,7 +515,7 @@ static void ip6addr_type_print(const struct expr *expr, struct output_ctx *octx)
 		getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
 	}
-	printf("%s", buf);
+	nft_print(octx, "%s", buf);
 }
 
 static struct error_record *ip6addr_type_parse(const struct expr *sym,
@@ -557,7 +565,7 @@ static void inet_protocol_type_print(const struct expr *expr,
 	if (octx->numeric < NUMERIC_ALL) {
 		p = getprotobynumber(mpz_get_uint8(expr->value));
 		if (p != NULL) {
-			printf("%s", p->p_name);
+			nft_print(octx, "%s", p->p_name);
 			return;
 		}
 	}
@@ -821,7 +829,7 @@ const struct datatype icmpx_code_type = {
 	.sym_tbl	= &icmpx_code_tbl,
 };
 
-void time_print(uint64_t seconds)
+void time_print(uint64_t seconds, struct output_ctx *octx)
 {
 	uint64_t days, hours, minutes;
 
@@ -835,13 +843,13 @@ void time_print(uint64_t seconds)
 	seconds %= 60;
 
 	if (days > 0)
-		printf("%"PRIu64"d", days);
+		nft_print(octx, "%" PRIu64 "d", days);
 	if (hours > 0)
-		printf("%"PRIu64"h", hours);
+		nft_print(octx, "%" PRIu64 "h", hours);
 	if (minutes > 0)
-		printf("%"PRIu64"m", minutes);
+		nft_print(octx, "%" PRIu64 "m", minutes);
 	if (seconds > 0)
-		printf("%"PRIu64"s", seconds);
+		nft_print(octx, "%" PRIu64 "s", seconds);
 }
 
 enum {
@@ -933,7 +941,7 @@ struct error_record *time_parse(const struct location *loc, const char *str,
 
 static void time_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	time_print(mpz_get_uint64(expr->value) / MSEC_PER_SEC);
+	time_print(mpz_get_uint64(expr->value) / MSEC_PER_SEC, octx);
 }
 
 static struct error_record *time_type_parse(const struct expr *sym,
diff --git a/src/expression.c b/src/expression.c
index d41ada3..98868d8 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -86,41 +86,42 @@ bool expr_cmp(const struct expr *e1, const struct expr *e2)
 	return e1->ops->cmp(e1, e2);
 }
 
-void expr_describe(const struct expr *expr)
+void expr_describe(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct datatype *dtype = expr->dtype;
 	const char *delim = "";
 
-	printf("%s expression, datatype %s (%s)",
-		expr->ops->name, dtype->name, dtype->desc);
+	nft_print(octx, "%s expression, datatype %s (%s)",
+				expr->ops->name, dtype->name, dtype->desc);
 	if (dtype->basetype != NULL) {
-		printf(" (basetype ");
+		nft_print(octx, " (basetype ");
 		for (dtype = dtype->basetype; dtype != NULL;
 		     dtype = dtype->basetype) {
-			printf("%s%s", delim, dtype->desc);
+			nft_print(octx, "%s%s", delim, dtype->desc);
 			delim = ", ";
 		}
-		printf(")");
+		nft_print(octx, ")");
 	}
 
 	if (expr_basetype(expr)->type == TYPE_STRING) {
 		if (expr->len)
-			printf(", %u characters", expr->len / BITS_PER_BYTE);
+			nft_print(octx, ", %u characters",
+				  expr->len / BITS_PER_BYTE);
 		else
-			printf(", dynamic length");
+			nft_print(octx, ", dynamic length");
 	} else
-		printf(", %u bits", expr->len);
+		nft_print(octx, ", %u bits", expr->len);
 
-	printf("\n");
+	nft_print(octx, "\n");
 
 	if (expr->dtype->sym_tbl != NULL) {
-		printf("\npre-defined symbolic constants ");
+		nft_print(octx, "\npre-defined symbolic constants ");
 		if (expr->dtype->sym_tbl->base == BASE_DECIMAL)
-			printf("(in decimal):\n");
+			nft_print(octx, "(in decimal):\n");
 		else
-			printf("(in hexadecimal):\n");
+			nft_print(octx, "(in hexadecimal):\n");
 		symbol_table_print(expr->dtype->sym_tbl, expr->dtype,
-				   expr->byteorder);
+				   expr->byteorder, octx);
 	}
 }
 
@@ -215,7 +216,8 @@ struct expr *verdict_expr_alloc(const struct location *loc,
 
 static void symbol_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	printf("%s%s", expr->scope != NULL ? "$" : "", expr->identifier);
+	nft_print(octx, "%s%s", expr->scope != NULL ? "$" : "",
+		  expr->identifier);
 }
 
 static void symbol_expr_clone(struct expr *new, const struct expr *expr)
@@ -398,7 +400,7 @@ struct expr *bitmask_expr_to_binops(struct expr *expr)
 static void prefix_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	expr_print(expr->prefix, octx);
-	printf("/%u", expr->prefix_len);
+	nft_print(octx, "/%u", expr->prefix_len);
 }
 
 static void prefix_expr_set_type(const struct expr *expr,
@@ -513,10 +515,10 @@ static void binop_arg_print(const struct expr *op, const struct expr *arg,
 		prec = 1;
 
 	if (prec)
-		printf("(");
+		nft_print(octx, "(");
 	expr_print(arg, octx);
 	if (prec)
-		printf(")");
+		nft_print(octx, ")");
 }
 
 static bool must_print_eq_op(const struct expr *expr)
@@ -534,9 +536,9 @@ static void binop_expr_print(const struct expr *expr, struct output_ctx *octx)
 
 	if (expr_op_symbols[expr->op] &&
 	    (expr->op != OP_EQ || must_print_eq_op(expr)))
-		printf(" %s ", expr_op_symbols[expr->op]);
+		nft_print(octx, " %s ", expr_op_symbols[expr->op]);
 	else
-		printf(" ");
+		nft_print(octx, " ");
 
 	binop_arg_print(expr, expr->right, octx);
 }
@@ -602,7 +604,7 @@ static void range_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	octx->numeric += NUMERIC_ALL + 1;
 	expr_print(expr->left, octx);
-	printf("-");
+	nft_print(octx, "-");
 	expr_print(expr->right, octx);
 	octx->numeric -= NUMERIC_ALL + 1;
 }
@@ -682,7 +684,7 @@ static void compound_expr_print(const struct expr *expr, const char *delim,
 	const char *d = "";
 
 	list_for_each_entry(i, &expr->expressions, list) {
-		printf("%s", d);
+		nft_print(octx, "%s", d);
 		expr_print(i, octx);
 		d = delim;
 	}
@@ -793,16 +795,16 @@ static void set_expr_print(const struct expr *expr, struct output_ctx *octx)
 	const char *d = "";
 	int count = 0;
 
-	printf("{ ");
+	nft_print(octx, "{ ");
 
 	list_for_each_entry(i, &expr->expressions, list) {
-		printf("%s", d);
+		nft_print(octx, "%s", d);
 		expr_print(i, octx);
 		count++;
 		d = calculate_delim(expr, &count);
 	}
 
-	printf(" }");
+	nft_print(octx, " }");
 }
 
 static void set_expr_set_type(const struct expr *expr,
@@ -840,7 +842,7 @@ struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 static void mapping_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	expr_print(expr->left, octx);
-	printf(" : ");
+	nft_print(octx, " : ");
 	expr_print(expr->right, octx);
 }
 
@@ -889,9 +891,9 @@ static void map_expr_print(const struct expr *expr, struct output_ctx *octx)
 	expr_print(expr->map, octx);
 	if (expr->mappings->ops->type == EXPR_SET_REF &&
 	    expr->mappings->set->datatype->type == TYPE_VERDICT)
-		printf(" vmap ");
+		nft_print(octx, " vmap ");
 	else
-		printf(" map ");
+		nft_print(octx, " map ");
 	expr_print(expr->mappings, octx);
 }
 
@@ -930,11 +932,11 @@ static void set_ref_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	if (expr->set->flags & NFT_SET_ANONYMOUS) {
 		if (expr->set->flags & NFT_SET_EVAL)
-			printf("table %s", expr->set->handle.set);
+			nft_print(octx, "table %s", expr->set->handle.set);
 		else
 			expr_print(expr->set->init, octx);
 	} else {
-		printf("@%s", expr->set->handle.set);
+		nft_print(octx, "@%s", expr->set->handle.set);
 	}
 }
 
@@ -971,18 +973,19 @@ static void set_elem_expr_print(const struct expr *expr,
 {
 	expr_print(expr->key, octx);
 	if (expr->timeout) {
-		printf(" timeout ");
-		time_print(expr->timeout / 1000);
+		nft_print(octx, " timeout ");
+		time_print(expr->timeout / 1000, octx);
 	}
 	if (!octx->stateless && expr->expiration) {
-		printf(" expires ");
-		time_print(expr->expiration / 1000);
+		nft_print(octx, " expires ");
+		time_print(expr->expiration / 1000, octx);
 	}
 	if (expr->comment)
-		printf(" comment \"%s\"", expr->comment);
+		nft_print(octx, " comment \"%s\"",
+					expr->comment);
 
 	if (expr->stmt) {
-		printf(" : ");
+		nft_print(octx, " : ");
 		stmt_print(expr->stmt, octx);
 	}
 }
diff --git a/src/exthdr.c b/src/exthdr.c
index 4add3da..7e59bbf 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -34,20 +34,24 @@ static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 		char buf[9] = {0};
 
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT) {
-			printf("tcp option %s", expr->exthdr.desc->name);
+			nft_print(octx, "tcp option %s",
+				  expr->exthdr.desc->name);
 			return;
 		}
 
 		if (offset)
 			snprintf(buf, sizeof buf, "%d", offset);
-		printf("tcp option %s%s %s", expr->exthdr.desc->name, buf,
-					     expr->exthdr.tmpl->token);
+		nft_print(octx, "tcp option %s%s %s",
+			  expr->exthdr.desc->name, buf,
+			  expr->exthdr.tmpl->token);
 	} else {
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
-			printf("exthdr %s", expr->exthdr.desc->name);
+			nft_print(octx, "exthdr %s",
+				  expr->exthdr.desc->name);
 		else {
-			printf("%s %s", expr->exthdr.desc ? expr->exthdr.desc->name : "unknown-exthdr",
-					expr->exthdr.tmpl->token);
+			nft_print(octx, "%s %s",
+				  expr->exthdr.desc ? expr->exthdr.desc->name : "unknown-exthdr",
+				  expr->exthdr.tmpl->token);
 		}
 	}
 }
diff --git a/src/fib.c b/src/fib.c
index b3488af..21bc69a 100644
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
+	nft_print(octx, "%s", s);
 	*flags &= ~f;
 	if (*flags)
-		printf(" . ");
+		nft_print(octx, " . ");
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
+	nft_print(octx, "fib ");
+	__fib_expr_print_f(&flags, NFTA_FIB_F_SADDR, "saddr", octx);
+	__fib_expr_print_f(&flags, NFTA_FIB_F_DADDR, "daddr", octx);
+	__fib_expr_print_f(&flags, NFTA_FIB_F_MARK, "mark", octx);
+	__fib_expr_print_f(&flags, NFTA_FIB_F_IIF, "iif", octx);
+	__fib_expr_print_f(&flags, NFTA_FIB_F_OIF, "oif", octx);
 
 	if (flags)
-		printf("0x%x", flags);
+		nft_print(octx, "0x%x", flags);
 
-	printf(" %s", fib_result_str(expr->fib.result));
+	nft_print(octx, " %s", fib_result_str(expr->fib.result));
 }
 
 static bool fib_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/hash.c b/src/hash.c
index 1a4bfb3..9cd3c8c 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -19,19 +19,19 @@ static void hash_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	switch (expr->hash.type) {
 	case NFT_HASH_SYM:
-		printf("symhash");
+		nft_print(octx, "symhash");
 	break;
 	case NFT_HASH_JENKINS:
 	default:
-		printf("jhash ");
+		nft_print(octx, "jhash ");
 		expr_print(expr->hash.expr, octx);
 	}
 
-	printf(" mod %u", expr->hash.mod);
+	nft_print(octx, " mod %u", expr->hash.mod);
 	if (expr->hash.seed_set)
-		printf(" seed 0x%x", expr->hash.seed);
+		nft_print(octx, " seed 0x%x", expr->hash.seed);
 	if (expr->hash.offset)
-		printf(" offset %u", expr->hash.offset);
+		nft_print(octx, " offset %u", expr->hash.offset);
 }
 
 static bool hash_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/main.c b/src/main.c
index 702ef30..135ee76 100644
--- a/src/main.c
+++ b/src/main.c
@@ -233,6 +233,11 @@ out:
 	return ret;
 }
 
+static void nft_ctx_reset_output_buffer(struct nft_ctx *ctx)
+{
+	ctx->output.output_buf[0] = 0;
+}
+
 int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
 	    void *scanner, struct parser_state *state,
 	    struct list_head *msgs)
@@ -240,6 +245,9 @@ int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
 	struct cmd *cmd, *next;
 	int ret;
 
+	/* reset the output buffer so we have only one command in output*/
+	nft_ctx_reset_output_buffer(nft);
+
 	ret = nft_parse(nft, scanner, state);
 	if (ret != 0 || state->nerrs > 0) {
 		ret = -1;
@@ -302,6 +310,9 @@ static struct nft_ctx *nft_ctx_new(uint32_t flags)
 	if (flags == NFT_CTX_DEFAULT)
 		nft_ctx_netlink_init(ctx);
 
+	ctx->output.output_buf_len = 4096;
+	ctx->output.output_buf = xzalloc(ctx->output.output_buf_len);
+
 	return ctx;
 }
 
@@ -312,10 +323,16 @@ static void nft_ctx_free(const struct nft_ctx *ctx)
 
 	iface_cache_release();
 	cache_release(&nft->cache);
+	xfree(ctx->output.output_buf);
 	xfree(ctx);
 	nft_exit();
 }
 
+char *nft_ctx_get_output(struct nft_ctx *ctx)
+{
+	return ctx->output.output_buf;
+}
+
 static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
 				   char *buf, size_t buflen)
 {
@@ -330,6 +347,7 @@ static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
 
 	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
+	printf("%s", nft_ctx_get_output(nft));
 
 	erec_print_list(stderr, &msgs, nft->debug_mask);
 	scanner_destroy(scanner);
@@ -356,6 +374,7 @@ static int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 
 	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
+	printf("%s", nft_ctx_get_output(nft));
 err:
 	erec_print_list(stderr, &msgs, nft->debug_mask);
 	scanner_destroy(scanner);
@@ -363,6 +382,32 @@ err:
 	return rc;
 }
 
+__attribute__((format(printf, 2, 0)))
+int nft_print(struct output_ctx *octx, const char *fmt, ...)
+{
+	char buf[4096];
+	va_list arg;
+	int ret;
+	int rlen = octx->output_buf_len - strlen(octx->output_buf);
+	va_start(arg, fmt);
+	ret = vsnprintf(buf, 4096, fmt, arg);
+	va_end(arg);
+	if (ret > rlen) {
+		char  *reallocbuf;
+		size_t tot_len = strlen(octx->output_buf) + ret + 1;
+		size_t reallocsize = 2 * octx->output_buf_len;
+		while (reallocsize < tot_len)
+			reallocsize *= 2;
+		reallocbuf = realloc(octx->output_buf, reallocsize);
+		if (!reallocbuf)
+			return -1;
+		octx->output_buf = reallocbuf;
+		octx->output_buf_len = reallocsize;
+	}
+	strncat(octx->output_buf, buf, octx->output_buf_len - strlen(octx->output_buf) - 1);
+	return 0;
+}
+
 int main(int argc, char * const *argv)
 {
 	char *buf = NULL, *filename = NULL;
diff --git a/src/meta.c b/src/meta.c
index 9c80893..56b9e29 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -54,13 +54,15 @@ static void tchandle_type_print(const struct expr *expr,
 
 	switch(handle) {
 	case TC_H_ROOT:
-		printf("root");
+		nft_print(octx, "root");
 		break;
 	case TC_H_UNSPEC:
-		printf("none");
+		nft_print(octx, "none");
 		break;
 	default:
-		printf("%0x:%0x", TC_H_MAJ(handle) >> 16, TC_H_MIN(handle));
+		nft_print(octx, "%0x:%0x",
+			  TC_H_MAJ(handle) >> 16,
+			  TC_H_MIN(handle));
 		break;
 	}
 }
@@ -134,9 +136,9 @@ static void ifindex_type_print(const struct expr *expr, struct output_ctx *octx)
 
 	ifindex = mpz_get_uint32(expr->value);
 	if (nft_if_indextoname(ifindex, name))
-		printf("\"%s\"", name);
+		nft_print(octx, "\"%s\"", name);
 	else
-		printf("%d", ifindex);
+		nft_print(octx, "%d", ifindex);
 }
 
 static struct error_record *ifindex_type_parse(const struct expr *sym,
@@ -209,9 +211,9 @@ static void uid_type_print(const struct expr *expr, struct output_ctx *octx)
 
 		pw = getpwuid(uid);
 		if (pw != NULL)
-			printf("\"%s\"", pw->pw_name);
+			nft_print(octx, "\"%s\"", pw->pw_name);
 		else
-			printf("%d", uid);
+			nft_print(octx, "%d", uid);
 		return;
 	}
 	expr_basetype(expr)->print(expr, octx);
@@ -261,9 +263,9 @@ static void gid_type_print(const struct expr *expr, struct output_ctx *octx)
 
 		gr = getgrgid(gid);
 		if (gr != NULL)
-			printf("\"%s\"", gr->gr_name);
+			nft_print(octx, "\"%s\"", gr->gr_name);
 		else
-			printf("%u", gid);
+			nft_print(octx, "%u", gid);
 		return;
 	}
 	expr_basetype(expr)->print(expr, octx);
@@ -446,9 +448,11 @@ static bool meta_key_is_qualified(enum nft_meta_keys key)
 static void meta_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	if (meta_key_is_qualified(expr->meta.key))
-		printf("meta %s", meta_templates[expr->meta.key].token);
+		nft_print(octx, "meta %s",
+			  meta_templates[expr->meta.key].token);
 	else
-		printf("%s", meta_templates[expr->meta.key].token);
+		nft_print(octx, "%s",
+			  meta_templates[expr->meta.key].token);
 }
 
 static bool meta_expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -573,9 +577,11 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 static void meta_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	if (meta_key_is_qualified(stmt->meta.key))
-		printf("meta %s set ", meta_templates[stmt->meta.key].token);
+		nft_print(octx, "meta %s set ",
+			  meta_templates[stmt->meta.key].token);
 	else
-		printf("%s set ", meta_templates[stmt->meta.key].token);
+		nft_print(octx, "%s set ",
+			  meta_templates[stmt->meta.key].token);
 
 	expr_print(stmt->meta.expr, octx);
 }
diff --git a/src/numgen.c b/src/numgen.c
index 19a4a9c..3d542fd 100644
--- a/src/numgen.c
+++ b/src/numgen.c
@@ -30,10 +30,12 @@ static const char *numgen_type_str(enum nft_ng_types type)
 
 static void numgen_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	printf("numgen %s mod %u", numgen_type_str(expr->numgen.type),
-	       expr->numgen.mod);
+	nft_print(octx, "numgen %s mod %u",
+		  numgen_type_str(expr->numgen.type),
+		  expr->numgen.mod);
 	if (expr->numgen.offset)
-		printf(" offset %u", expr->numgen.offset);
+		nft_print(octx, " offset %u",
+			  expr->numgen.offset);
 }
 
 static bool numgen_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/payload.c b/src/payload.c
index 7f94ff7..832104d 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -46,11 +46,11 @@ static void payload_expr_print(const struct expr *expr, struct output_ctx *octx)
 	desc = expr->payload.desc;
 	tmpl = expr->payload.tmpl;
 	if (payload_is_known(expr))
-		printf("%s %s", desc->name, tmpl->token);
+		nft_print(octx, "%s %s", desc->name, tmpl->token);
 	else
-		printf("payload @%s,%u,%u",
-		       proto_base_tokens[expr->payload.base],
-		       expr->payload.offset, expr->len);
+		nft_print(octx, "payload @%s,%u,%u",
+			  proto_base_tokens[expr->payload.base],
+			  expr->payload.offset, expr->len);
 }
 
 static bool payload_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/rule.c b/src/rule.c
index 44d36c1..eb84160 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -273,7 +273,8 @@ static const char *set_policy2str(uint32_t policy)
 }
 
 static void set_print_declaration(const struct set *set,
-				  struct print_fmt_options *opts)
+				  struct print_fmt_options *opts,
+				  struct output_ctx *octx)
 {
 	const char *delim = "";
 	const char *type;
@@ -286,34 +287,39 @@ static void set_print_declaration(const struct set *set,
 	else
 		type = "set";
 
-	printf("%s%s", opts->tab, type);
+	nft_print(octx, "%s%s", opts->tab, type);
 
 	if (opts->family != NULL)
-		printf(" %s", opts->family);
+		nft_print(octx, " %s", opts->family);
 
 	if (opts->table != NULL)
-		printf(" %s", opts->table);
+		nft_print(octx, " %s", opts->table);
 
-	printf(" %s {%s", set->handle.set, opts->nl);
+	nft_print(octx, " %s {%s", set->handle.set, opts->nl);
 
-	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
+	nft_print(octx, "%s%stype %s", opts->tab, opts->tab,
+				set->keytype->name);
 	if (set->flags & NFT_SET_MAP)
-		printf(" : %s", set->datatype->name);
+		nft_print(octx, " : %s", set->datatype->name);
 	else if (set->flags & NFT_SET_OBJECT)
-		printf(" : %s", obj_type_name(set->objtype));
+		nft_print(octx, " : %s",
+			  obj_type_name(set->objtype));
 
-	printf("%s", opts->stmt_separator);
+	nft_print(octx, "%s", opts->stmt_separator);
 
 	if (!(set->flags & (NFT_SET_CONSTANT))) {
 		if (set->policy != NFT_SET_POL_PERFORMANCE) {
-			printf("%s%spolicy %s%s", opts->tab, opts->tab,
-			       set_policy2str(set->policy),
-			       opts->stmt_separator);
+			nft_print(octx, "%s%spolicy %s%s",
+				  opts->tab, opts->tab,
+				  set_policy2str(set->policy),
+				  opts->stmt_separator);
 		}
 
 		if (set->desc.size > 0) {
-			printf("%s%ssize %u%s", opts->tab, opts->tab,
-			       set->desc.size, opts->stmt_separator);
+			nft_print(octx, "%s%ssize %u%s",
+				  opts->tab, opts->tab,
+				  set->desc.size,
+				  opts->stmt_separator);
 		}
 	}
 
@@ -323,45 +329,49 @@ static void set_print_declaration(const struct set *set,
 		flags &= ~NFT_SET_TIMEOUT;
 
 	if (flags & (NFT_SET_CONSTANT | NFT_SET_INTERVAL | NFT_SET_TIMEOUT)) {
-		printf("%s%sflags ", opts->tab, opts->tab);
+		nft_print(octx, "%s%sflags ", opts->tab,
+					opts->tab);
 		if (set->flags & NFT_SET_CONSTANT) {
-			printf("%sconstant", delim);
+			nft_print(octx, "%sconstant", delim);
 			delim = ",";
 		}
 		if (set->flags & NFT_SET_INTERVAL) {
-			printf("%sinterval", delim);
+			nft_print(octx, "%sinterval", delim);
 			delim = ",";
 		}
 		if (set->flags & NFT_SET_TIMEOUT) {
-			printf("%stimeout", delim);
+			nft_print(octx, "%stimeout", delim);
 			delim = ",";
 		}
-		printf("%s", opts->stmt_separator);
+		nft_print(octx, "%s", opts->stmt_separator);
 	}
 
 	if (set->timeout) {
-		printf("%s%stimeout ", opts->tab, opts->tab);
-		time_print(set->timeout / 1000);
-		printf("%s", opts->stmt_separator);
+		nft_print(octx, "%s%stimeout ", opts->tab,
+					opts->tab);
+		time_print(set->timeout / 1000, octx);
+		nft_print(octx, "%s", opts->stmt_separator);
 	}
 	if (set->gc_int) {
-		printf("%s%sgc-interval ", opts->tab, opts->tab);
-		time_print(set->gc_int / 1000);
-		printf("%s", opts->stmt_separator);
+		nft_print(octx, "%s%sgc-interval ", opts->tab,
+			  opts->tab);
+		time_print(set->gc_int / 1000, octx);
+		nft_print(octx, "%s", opts->stmt_separator);
 	}
 }
 
 static void do_set_print(const struct set *set, struct print_fmt_options *opts,
 			  struct output_ctx *octx)
 {
-	set_print_declaration(set, opts);
+	set_print_declaration(set, opts, octx);
 
 	if (set->init != NULL && set->init->size > 0) {
-		printf("%s%selements = ", opts->tab, opts->tab);
+		nft_print(octx, "%s%selements = ", opts->tab,
+			  opts->tab);
 		expr_print(set->init, octx);
-		printf("%s", opts->nl);
+		nft_print(octx, "%s", opts->nl);
 	}
-	printf("%s}%s", opts->tab, opts->nl);
+	nft_print(octx, "%s}%s", opts->tab, opts->nl);
 }
 
 void set_print(const struct set *s, struct output_ctx *octx)
@@ -426,14 +436,14 @@ void rule_print(const struct rule *rule, struct output_ctx *octx)
 	list_for_each_entry(stmt, &rule->stmts, list) {
 		stmt->ops->print(stmt, octx);
 		if (!list_is_last(&stmt->list, &rule->stmts))
-			printf(" ");
+			nft_print(octx, " ");
 	}
 
 	if (rule->comment)
-		printf(" comment \"%s\"", rule->comment);
+		nft_print(octx, " comment \"%s\"", rule->comment);
 
 	if (octx->handle > 0)
-		printf(" # handle %" PRIu64, rule->handle.handle.id);
+		nft_print(octx, " # handle %" PRIu64, rule->handle.handle.id);
 }
 
 struct rule *rule_lookup(const struct chain *chain, uint64_t handle)
@@ -663,21 +673,25 @@ static const char *chain_policy2str(uint32_t policy)
 	return "unknown";
 }
 
-static void chain_print_declaration(const struct chain *chain)
+static void chain_print_declaration(const struct chain *chain,
+				    struct output_ctx *octx)
 {
-	printf("\tchain %s {\n", chain->handle.chain);
+	nft_print(octx, "\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		if (chain->dev != NULL) {
-			printf("\t\ttype %s hook %s device %s priority %d; policy %s;\n",
-			       chain->type,
-			       hooknum2str(chain->handle.family, chain->hooknum),
-			       chain->dev, chain->priority,
-			       chain_policy2str(chain->policy));
+			nft_print(octx,
+				  "\t\ttype %s hook %s device %s priority %d; policy %s;\n",
+				  chain->type,
+				  hooknum2str(chain->handle.family, chain->hooknum),
+				  chain->dev, chain->priority,
+				  chain_policy2str(chain->policy));
 		} else {
-			printf("\t\ttype %s hook %s priority %d; policy %s;\n",
-			       chain->type,
-			       hooknum2str(chain->handle.family, chain->hooknum),
-			       chain->priority, chain_policy2str(chain->policy));
+			nft_print(octx,
+				  "\t\ttype %s hook %s priority %d; policy %s;\n",
+				  chain->type,
+				  hooknum2str(chain->handle.family, chain->hooknum),
+				  chain->priority,
+				  chain_policy2str(chain->policy));
 		}
 	}
 }
@@ -686,14 +700,14 @@ static void chain_print(const struct chain *chain, struct output_ctx *octx)
 {
 	struct rule *rule;
 
-	chain_print_declaration(chain);
+	chain_print_declaration(chain, octx);
 
 	list_for_each_entry(rule, &chain->rules, list) {
-		printf("\t\t");
+		nft_print(octx, "\t\t");
 		rule_print(rule, octx);
-		printf("\n");
+		nft_print(octx, "\n");
 	}
-	printf("\t}\n");
+	nft_print(octx, "\t}\n");
 }
 
 void chain_print_plain(const struct chain *chain)
@@ -798,27 +812,27 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 	const char *delim = "";
 	const char *family = family2str(table->handle.family);
 
-	printf("table %s %s {\n", family, table->handle.table);
+	nft_print(octx, "table %s %s {\n", family, table->handle.table);
 	table_print_options(table, &delim);
 
 	list_for_each_entry(obj, &table->objs, list) {
-		printf("%s", delim);
+		nft_print(octx, "%s", delim);
 		obj_print(obj, octx);
 		delim = "\n";
 	}
 	list_for_each_entry(set, &table->sets, list) {
 		if (set->flags & NFT_SET_ANONYMOUS)
 			continue;
-		printf("%s", delim);
+		nft_print(octx, "%s", delim);
 		set_print(set, octx);
 		delim = "\n";
 	}
 	list_for_each_entry(chain, &table->chains, list) {
-		printf("%s", delim);
+		nft_print(octx, "%s", delim);
 		chain_print(chain, octx);
 		delim = "\n";
 	}
-	printf("}\n");
+	nft_print(octx, "}\n");
 }
 
 struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
@@ -1180,9 +1194,9 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		printf("table %s %s {\n",
-		       family2str(table->handle.family),
-		       table->handle.table);
+		nft_print(ctx->octx, "table %s %s {\n",
+			  family2str(table->handle.family),
+			  table->handle.table);
 
 		list_for_each_entry(set, &table->sets, list) {
 			if (cmd->obj == CMD_OBJ_SETS &&
@@ -1195,11 +1209,12 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 			if (cmd->obj == CMD_OBJ_MAPS &&
 			    !(set->flags & NFT_SET_MAP))
 				continue;
-			set_print_declaration(set, &opts);
-			printf("%s}%s", opts.tab, opts.nl);
+			set_print_declaration(set, &opts, ctx->octx);
+			nft_print(ctx->octx, "%s}%s", opts.tab,
+				  opts.nl);
 		}
 
-		printf("}\n");
+		nft_print(ctx->octx, "}\n");
 	}
 	return 0;
 }
@@ -1264,40 +1279,45 @@ static void obj_print_data(const struct obj *obj,
 {
 	switch (obj->type) {
 	case NFT_OBJECT_COUNTER:
-		printf(" %s {%s%s%s", obj->handle.obj,
-				      opts->nl, opts->tab, opts->tab);
+		nft_print(octx, " %s {%s%s%s", obj->handle.obj,
+			  opts->nl, opts->tab, opts->tab);
 		if (octx->stateless) {
-			printf("packets 0 bytes 0");
+			nft_print(octx, "packets 0 bytes 0");
 			break;
 		}
-		printf("packets %"PRIu64" bytes %"PRIu64"",
-		       obj->counter.packets, obj->counter.bytes);
+		nft_print(octx,
+			  "packets %" PRIu64 " bytes %" PRIu64 "",
+			  obj->counter.packets,
+			  obj->counter.bytes);
 		break;
 	case NFT_OBJECT_QUOTA: {
 		const char *data_unit;
 		uint64_t bytes;
 
-		printf(" %s {%s%s%s", obj->handle.obj,
-				      opts->nl, opts->tab, opts->tab);
+		nft_print(octx, " %s {%s%s%s", obj->handle.obj,
+			  opts->nl, opts->tab, opts->tab);
 		data_unit = get_rate(obj->quota.bytes, &bytes);
-		printf("%s%"PRIu64" %s",
-		       obj->quota.flags & NFT_QUOTA_F_INV ? "over " : "",
-		       bytes, data_unit);
+		nft_print(octx, "%s%" PRIu64 " %s",
+			  obj->quota.flags & NFT_QUOTA_F_INV ? "over " : "",
+			  bytes, data_unit);
 		if (!octx->stateless && obj->quota.used) {
 			data_unit = get_rate(obj->quota.used, &bytes);
-			printf(" used %"PRIu64" %s", bytes, data_unit);
+			nft_print(octx, " used %" PRIu64 " %s",
+				  bytes, data_unit);
 		}
 		}
 		break;
 	case NFT_OBJECT_CT_HELPER: {
-		printf("ct helper %s {\n", obj->handle.obj);
-		printf("\t\ttype \"%s\" protocol ", obj->ct_helper.name);
+		nft_print(octx, "ct helper %s {\n", obj->handle.obj);
+		nft_print(octx, "\t\ttype \"%s\" protocol ",
+			  obj->ct_helper.name);
 		print_proto_name_proto(obj->ct_helper.l4proto);
-		printf("\t\tl3proto %s", family2str(obj->ct_helper.l3proto));
+		nft_print(octx, "\t\tl3proto %s",
+			  family2str(obj->ct_helper.l3proto));
 		break;
 		}
 	default:
-		printf("unknown {%s", opts->nl);
+		nft_print(octx, "unknown {%s", opts->nl);
 		break;
 	}
 }
@@ -1332,17 +1352,17 @@ static void obj_print_declaration(const struct obj *obj,
 				  struct print_fmt_options *opts,
 				  struct output_ctx *octx)
 {
-	printf("%s%s", opts->tab, obj_type_name(obj->type));
+	nft_print(octx, "%s%s", opts->tab, obj_type_name(obj->type));
 
 	if (opts->family != NULL)
-		printf(" %s", opts->family);
+		nft_print(octx, " %s", opts->family);
 
 	if (opts->table != NULL)
-		printf(" %s", opts->table);
+		nft_print(octx, " %s", opts->table);
 
 	obj_print_data(obj, opts, octx);
 
-	printf("%s%s}%s", opts->nl, opts->tab, opts->nl);
+	nft_print(octx, "%s%s}%s", opts->nl, opts->tab, opts->nl);
 }
 
 void obj_print(const struct obj *obj, struct output_ctx *octx)
@@ -1383,13 +1403,13 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		printf("table %s %s {\n",
-		       family2str(table->handle.family),
-		       table->handle.table);
+		nft_print(ctx->octx, "table %s %s {\n",
+			  family2str(table->handle.family),
+			  table->handle.table);
 
 		if (cmd->handle.table != NULL &&
 		    strcmp(cmd->handle.table, table->handle.table)) {
-			printf("}\n");
+			nft_print(ctx->octx, "}\n");
 			continue;
 		}
 
@@ -1402,7 +1422,7 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 			obj_print_declaration(obj, &opts, ctx->octx);
 		}
 
-		printf("}\n");
+		nft_print(ctx->octx, "}\n");
 	}
 	return 0;
 }
@@ -1438,19 +1458,20 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		printf("table %s %s\n",
-		       family2str(table->handle.family),
-		       table->handle.table);
+		nft_print(ctx->octx, "table %s %s\n",
+			  family2str(table->handle.family),
+			  table->handle.table);
 	}
 
 	return 0;
 }
 
-static void table_print_declaration(struct table *table)
+static void table_print_declaration(struct table *table,
+				    struct output_ctx *octx)
 {
-	printf("table %s %s {\n",
-		family2str(table->handle.family),
-		table->handle.table);
+	nft_print(octx, "table %s %s {\n",
+		  family2str(table->handle.family),
+		  table->handle.table);
 }
 
 static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
@@ -1458,7 +1479,7 @@ static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
 {
 	struct chain *chain;
 
-	table_print_declaration(table);
+	table_print_declaration(table, ctx->octx);
 
 	list_for_each_entry(chain, &table->chains, list) {
 		if (chain->handle.family != cmd->handle.family ||
@@ -1468,7 +1489,7 @@ static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
 		chain_print(chain, ctx->octx);
 	}
 
-	printf("}\n");
+	nft_print(ctx->octx, "}\n");
 
 	return 0;
 }
@@ -1483,13 +1504,13 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		table_print_declaration(table);
+		table_print_declaration(table, ctx->octx);
 
 		list_for_each_entry(chain, &table->chains, list) {
-			chain_print_declaration(chain);
-			printf("\t}\n");
+			chain_print_declaration(chain, ctx->octx);
+			nft_print(ctx->octx, "\t}\n");
 		}
-		printf("}\n");
+		nft_print(ctx->octx, "}\n");
 	}
 
 	return 0;
@@ -1504,9 +1525,9 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 	if (set == NULL)
 		return -1;
 
-	table_print_declaration(table);
+	table_print_declaration(table, ctx->octx);
 	set_print(set, ctx->octx);
-	printf("}\n");
+	nft_print(ctx->octx, "}\n");
 
 	return 0;
 }
@@ -1693,9 +1714,10 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
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
 
@@ -1741,7 +1763,7 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_MONITOR:
 		return do_command_monitor(ctx, cmd);
 	case CMD_DESCRIBE:
-		return do_command_describe(ctx, cmd);
+		return do_command_describe(ctx, cmd, ctx->octx);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/statement.c b/src/statement.c
index 58f8aaf..ecb1e56 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -109,20 +109,20 @@ struct stmt *verdict_stmt_alloc(const struct location *loc, struct expr *expr)
 
 static void flow_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("flow ");
+	nft_print(octx, "flow ");
 	if (stmt->flow.set) {
 		expr_print(stmt->flow.set, octx);
-		printf(" ");
+		nft_print(octx, " ");
 	}
-	printf("{ ");
+	nft_print(octx, "{ ");
 	expr_print(stmt->flow.key, octx);
-	printf(" ");
+	nft_print(octx, " ");
 
 	octx->stateless++;
 	stmt_print(stmt->flow.stmt, octx);
 	octx->stateless--;
 
-	printf("} ");
+	nft_print(octx, "} ");
 
 }
 
@@ -147,13 +147,13 @@ struct stmt *flow_stmt_alloc(const struct location *loc)
 
 static void counter_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("counter");
+	nft_print(octx, "counter");
 
 	if (octx->stateless)
 		return;
 
-	printf(" packets %" PRIu64 " bytes %" PRIu64,
-	       stmt->counter.packets, stmt->counter.bytes);
+	nft_print(octx, " packets %" PRIu64 " bytes %" PRIu64,
+		  stmt->counter.packets, stmt->counter.bytes);
 }
 
 static const struct stmt_ops counter_stmt_ops = {
@@ -189,10 +189,11 @@ static void objref_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	switch (stmt->objref.type) {
 	case NFT_OBJECT_CT_HELPER:
-		printf("ct helper set ");
+		nft_print(octx, "ct helper set ");
 		break;
 	default:
-		printf("%s name ", objref_type_name(stmt->objref.type));
+		nft_print(octx, "%s name ",
+			  objref_type_name(stmt->objref.type));
 		break;
 	}
 	expr_print(stmt->objref.expr, octx);
@@ -233,39 +234,40 @@ static const char *log_level(uint32_t level)
 
 static void log_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("log");
+	nft_print(octx, "log");
 	if (stmt->log.flags & STMT_LOG_PREFIX)
-		printf(" prefix \"%s\"", stmt->log.prefix);
+		nft_print(octx, " prefix \"%s\"", stmt->log.prefix);
 	if (stmt->log.flags & STMT_LOG_GROUP)
-		printf(" group %u", stmt->log.group);
+		nft_print(octx, " group %u", stmt->log.group);
 	if (stmt->log.flags & STMT_LOG_SNAPLEN)
-		printf(" snaplen %u", stmt->log.snaplen);
+		nft_print(octx, " snaplen %u", stmt->log.snaplen);
 	if (stmt->log.flags & STMT_LOG_QTHRESHOLD)
-		printf(" queue-threshold %u", stmt->log.qthreshold);
+		nft_print(octx, " queue-threshold %u", stmt->log.qthreshold);
 	if ((stmt->log.flags & STMT_LOG_LEVEL) &&
 	    stmt->log.level != LOG_WARNING)
-		printf(" level %s", log_level(stmt->log.level));
+		nft_print(octx, " level %s", log_level(stmt->log.level));
 
 	if ((stmt->log.logflags & NF_LOG_MASK) == NF_LOG_MASK) {
-		printf(" flags all");
+		nft_print(octx, " flags all");
 	} else {
 		if (stmt->log.logflags & (NF_LOG_TCPSEQ | NF_LOG_TCPOPT)) {
 			const char *delim = " ";
 
-			printf(" flags tcp");
+			nft_print(octx, " flags tcp");
 			if (stmt->log.logflags & NF_LOG_TCPSEQ) {
-				printf(" sequence");
+				nft_print(octx, " sequence");
 				delim = ",";
 			}
 			if (stmt->log.logflags & NF_LOG_TCPOPT)
-				printf("%soptions", delim);
+				nft_print(octx, "%soptions",
+							delim);
 		}
 		if (stmt->log.logflags & NF_LOG_IPOPT)
-			printf(" flags ip options");
+			nft_print(octx, " flags ip options");
 		if (stmt->log.logflags & NF_LOG_UID)
-			printf(" flags skuid");
+			nft_print(octx, " flags skuid");
 		if (stmt->log.logflags & NF_LOG_MACDECODE)
-			printf(" flags ether");
+			nft_print(octx, " flags ether");
 	}
 }
 
@@ -328,23 +330,25 @@ static void limit_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 
 	switch (stmt->limit.type) {
 	case NFT_LIMIT_PKTS:
-		printf("limit rate %s%" PRIu64 "/%s",
-		       inv ? "over " : "", stmt->limit.rate,
-		       get_unit(stmt->limit.unit));
+		nft_print(octx, "limit rate %s%" PRIu64 "/%s",
+			  inv ? "over " : "", stmt->limit.rate,
+			  get_unit(stmt->limit.unit));
 		if (stmt->limit.burst > 0)
-			printf(" burst %u packets", stmt->limit.burst);
+			nft_print(octx, " burst %u packets",
+				  stmt->limit.burst);
 		break;
 	case NFT_LIMIT_PKT_BYTES:
 		data_unit = get_rate(stmt->limit.rate, &rate);
 
-		printf("limit rate %s%" PRIu64 " %s/%s",
-		       inv ? "over " : "", rate, data_unit,
-		       get_unit(stmt->limit.unit));
+		nft_print(octx,	"limit rate %s%" PRIu64 " %s/%s",
+			  inv ? "over " : "", rate, data_unit,
+			  get_unit(stmt->limit.unit));
 		if (stmt->limit.burst > 0) {
 			uint64_t burst;
 
 			data_unit = get_rate(stmt->limit.burst, &burst);
-			printf(" burst %"PRIu64" %s", burst, data_unit);
+			nft_print(octx, " burst %" PRIu64 " %s", burst,
+				  data_unit);
 		}
 		break;
 	}
@@ -369,17 +373,17 @@ static void queue_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	const char *delim = " ";
 
-	printf("queue");
+	nft_print(octx, "queue");
 	if (stmt->queue.queue != NULL) {
-		printf(" num ");
+		nft_print(octx, " num ");
 		expr_print(stmt->queue.queue, octx);
 	}
 	if (stmt->queue.flags & NFT_QUEUE_FLAG_BYPASS) {
-		printf("%sbypass", delim);
+		nft_print(octx, "%sbypass", delim);
 		delim = ",";
 	}
 	if (stmt->queue.flags & NFT_QUEUE_FLAG_CPU_FANOUT)
-		printf("%sfanout", delim);
+		nft_print(octx, "%sfanout", delim);
 
 }
 
@@ -401,12 +405,12 @@ static void quota_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	uint64_t bytes, used;
 
 	data_unit = get_rate(stmt->quota.bytes, &bytes);
-	printf("quota %s%"PRIu64" %s",
-	       inv ? "over " : "", bytes, data_unit);
+	nft_print(octx, "quota %s%" PRIu64 " %s",
+		  inv ? "over " : "", bytes, data_unit);
 
 	if (!octx->stateless && stmt->quota.used) {
 		data_unit = get_rate(stmt->quota.used, &used);
-		printf(" used %"PRIu64" %s", used, data_unit);
+		nft_print(octx, " used %" PRIu64 " %s", used, data_unit);
 	}
 }
 
@@ -427,15 +431,15 @@ struct stmt *quota_stmt_alloc(const struct location *loc)
 
 static void reject_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("reject");
+	nft_print(octx, "reject");
 	switch (stmt->reject.type) {
 	case NFT_REJECT_TCP_RST:
-		printf(" with tcp reset");
+		nft_print(octx, " with tcp reset");
 		break;
 	case NFT_REJECT_ICMPX_UNREACH:
 		if (stmt->reject.icmp_code == NFT_REJECT_ICMPX_PORT_UNREACH)
 			break;
-		printf(" with icmpx type ");
+		nft_print(octx, " with icmpx type ");
 		expr_print(stmt->reject.expr, octx);
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
@@ -443,13 +447,13 @@ static void reject_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		case NFPROTO_IPV4:
 			if (stmt->reject.icmp_code == ICMP_PORT_UNREACH)
 				break;
-			printf(" with icmp type ");
+			nft_print(octx, " with icmp type ");
 			expr_print(stmt->reject.expr, octx);
 			break;
 		case NFPROTO_IPV6:
 			if (stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
 				break;
-			printf(" with icmpv6 type ");
+			nft_print(octx, " with icmpv6 type ");
 			expr_print(stmt->reject.expr, octx);
 			break;
 		}
@@ -468,7 +472,7 @@ struct stmt *reject_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &reject_stmt_ops);
 }
 
-static void print_nf_nat_flags(uint32_t flags)
+static void print_nf_nat_flags(uint32_t flags, struct output_ctx *octx)
 {
 	const char *delim = " ";
 
@@ -476,17 +480,17 @@ static void print_nf_nat_flags(uint32_t flags)
 		return;
 
 	if (flags & NF_NAT_RANGE_PROTO_RANDOM) {
-		printf("%srandom", delim);
+		nft_print(octx, "%srandom", delim);
 		delim = ",";
 	}
 
 	if (flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
-		printf("%sfully-random", delim);
+		nft_print(octx, "%sfully-random", delim);
 		delim = ",";
 	}
 
 	if (flags & NF_NAT_RANGE_PERSISTENT)
-		printf("%spersistent", delim);
+		nft_print(octx, "%spersistent", delim);
 }
 
 static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
@@ -496,21 +500,21 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		[NFT_NAT_DNAT]	= "dnat",
 	};
 
-	printf("%s to ", nat_types[stmt->nat.type]);
+	nft_print(octx, "%s to ", nat_types[stmt->nat.type]);
 	if (stmt->nat.addr) {
 		if (stmt->nat.proto) {
 			if (stmt->nat.addr->ops->type == EXPR_VALUE &&
 			    stmt->nat.addr->dtype->type == TYPE_IP6ADDR) {
-				printf("[");
+				nft_print(octx, "[");
 				expr_print(stmt->nat.addr, octx);
-				printf("]");
+				nft_print(octx, "]");
 			} else if (stmt->nat.addr->ops->type == EXPR_RANGE &&
 				   stmt->nat.addr->left->dtype->type == TYPE_IP6ADDR) {
-				printf("[");
+				nft_print(octx, "[");
 				expr_print(stmt->nat.addr->left, octx);
-				printf("]-[");
+				nft_print(octx, "]-[");
 				expr_print(stmt->nat.addr->right, octx);
-				printf("]");
+				nft_print(octx, "]");
 			} else {
 				expr_print(stmt->nat.addr, octx);
 			}
@@ -520,11 +524,11 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	}
 
 	if (stmt->nat.proto) {
-		printf(":");
+		nft_print(octx, ":");
 		expr_print(stmt->nat.proto, octx);
 	}
 
-	print_nf_nat_flags(stmt->nat.flags);
+	print_nf_nat_flags(stmt->nat.flags, octx);
 }
 
 static void nat_stmt_destroy(struct stmt *stmt)
@@ -547,14 +551,14 @@ struct stmt *nat_stmt_alloc(const struct location *loc)
 
 static void masq_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("masquerade");
+	nft_print(octx, "masquerade");
 
 	if (stmt->masq.proto) {
-		printf(" to :");
+		nft_print(octx, " to :");
 		expr_print(stmt->masq.proto, octx);
 	}
 
-	print_nf_nat_flags(stmt->masq.flags);
+	print_nf_nat_flags(stmt->masq.flags, octx);
 }
 
 static void masq_stmt_destroy(struct stmt *stmt)
@@ -576,14 +580,14 @@ struct stmt *masq_stmt_alloc(const struct location *loc)
 
 static void redir_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("redirect");
+	nft_print(octx, "redirect");
 
 	if (stmt->redir.proto) {
-		printf(" to :");
+		nft_print(octx, " to :");
 		expr_print(stmt->redir.proto, octx);
 	}
 
-	print_nf_nat_flags(stmt->redir.flags);
+	print_nf_nat_flags(stmt->redir.flags, octx);
 }
 
 static void redir_stmt_destroy(struct stmt *stmt)
@@ -610,9 +614,10 @@ static const char * const set_stmt_op_names[] = {
 
 static void set_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("set %s ", set_stmt_op_names[stmt->set.op]);
+	nft_print(octx, "set %s ",
+				set_stmt_op_names[stmt->set.op]);
 	expr_print(stmt->set.key, octx);
-	printf(" ");
+	nft_print(octx, " ");
 	expr_print(stmt->set.set, octx);
 }
 
@@ -636,13 +641,13 @@ struct stmt *set_stmt_alloc(const struct location *loc)
 
 static void dup_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("dup");
+	nft_print(octx, "dup");
 	if (stmt->dup.to != NULL) {
-		printf(" to ");
+		nft_print(octx, " to ");
 		expr_print(stmt->dup.to, octx);
 
 		if (stmt->dup.dev != NULL) {
-			printf(" device ");
+			nft_print(octx, " device ");
 			expr_print(stmt->dup.dev, octx);
 		}
 	}
@@ -668,7 +673,7 @@ struct stmt *dup_stmt_alloc(const struct location *loc)
 
 static void fwd_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("fwd to ");
+	nft_print(octx, "fwd to ");
 	expr_print(stmt->fwd.to, octx);
 }
 
-- 
2.14.1

