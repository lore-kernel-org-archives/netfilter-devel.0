From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 5/5] src: get rid of printf
Date: Thu, 28 Sep 2017 17:17:45 +0200
Message-ID: <20170928151745.28426-6-phil@nwl.cc>
References: <20170928151745.28426-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35282 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752059AbdI1PSJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2017 11:18:09 -0400
In-Reply-To: <20170928151745.28426-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces nft_print()/nft_gmp_print() functions which have
to be used instead of printf to output information that were previously
send to stdout. These functions print to a FILE pointer defined in
struct output_ctx. It is set by calling:

| old_fp = nft_ctx_set_output(ctx, new_fp);

Having an application-defined FILE pointer is actually quite flexible:
Using fmemopen() or even fopencookie(), an application gains full
control over what is printed and where it should go to.

Signed-off-by: Eric Leblond <eric@regit.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Print into a FILE pointer instead of a buffer since that allows to
  include monitor code into the same solution.
- Change monitor code to use nft_print() as well.
- Introduce nft_gmp_print() to replace former calls to gmp_printf().
- Add struct output_ctx pointer to struct eval_ctx, this is required by
  cache_update().
- Make all netlink_dump_*() functions print to output_fp by making use
  of nftnl_*_fprintf() functions.
---
 include/datatype.h      |   5 +-
 include/expression.h    |   2 +-
 include/netlink.h       |   8 +-
 include/nftables.h      |   6 ++
 include/parser.h        |   2 +-
 include/rule.h          |   7 +-
 src/cli.c               |   2 +-
 src/ct.c                |  20 ++--
 src/datatype.c          |  60 +++++------
 src/evaluate.c          |  22 ++--
 src/expression.c        |  74 ++++++-------
 src/exthdr.c            |  15 +--
 src/fib.c               |  23 ++--
 src/hash.c              |  10 +-
 src/main.c              |  51 ++++++++-
 src/meta.c              |  32 +++---
 src/netlink.c           | 126 +++++++++++-----------
 src/netlink_linearize.c |   2 +-
 src/numgen.c            |   7 +-
 src/parser_bison.y      |   3 +-
 src/payload.c           |  10 +-
 src/rt.c                |   2 +-
 src/rule.c              | 272 +++++++++++++++++++++++++-----------------------
 src/statement.c         | 138 ++++++++++++------------
 24 files changed, 495 insertions(+), 404 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 2e345910be83d..e9f60798d1a0c 100644
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
index 32d4423a5e06e..ce6b702a7f378 100644
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
diff --git a/include/netlink.h b/include/netlink.h
index 79dc08f873b98..2ca6f345b6ac9 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -180,14 +180,14 @@ extern int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
 			      struct location *loc, uint32_t type);
 
 extern void netlink_dump_chain(const struct nftnl_chain *nlc,
-			       unsigned int debug_mask);
+			       struct netlink_ctx *ctx);
 extern void netlink_dump_rule(const struct nftnl_rule *nlr,
-			      unsigned int debug_mask);
+			      struct netlink_ctx *ctx);
 extern void netlink_dump_expr(const struct nftnl_expr *nle,
 			      FILE *fp, unsigned int debug_mask);
 extern void netlink_dump_set(const struct nftnl_set *nls,
-			     unsigned int debug_mask);
-extern void netlink_dump_obj(struct nftnl_obj *nlo, unsigned int debug_mask);
+			     struct netlink_ctx *ctx);
+extern void netlink_dump_obj(struct nftnl_obj *nlo, struct netlink_ctx *ctx);
 
 extern int netlink_batch_send(struct netlink_ctx *ctx, struct list_head *err_list);
 
diff --git a/include/nftables.h b/include/nftables.h
index 3429e4c127983..01d72a87212ea 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -30,6 +30,7 @@ struct output_ctx {
 	unsigned int ip2name;
 	unsigned int handle;
 	unsigned int echo;
+	FILE *output_fp;
 };
 
 struct nft_cache {
@@ -148,4 +149,9 @@ void realm_table_meta_exit(void);
 void devgroup_table_exit(void);
 void realm_table_rt_exit(void);
 
+int nft_print(struct output_ctx *octx, const char *fmt, ...)
+	__attribute__((format(printf, 2, 3)));
+int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
+	__attribute__((format(printf, 2, 0)));
+
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/include/parser.h b/include/parser.h
index 431edfb3d4e34..0bdb3fa8225c0 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -33,7 +33,7 @@ struct mnl_socket;
 
 extern void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 			struct parser_state *state, struct list_head *msgs,
-			unsigned int debug_level);
+			unsigned int debug_level, struct output_ctx *octx);
 extern int nft_parse(struct nft_ctx *ctx, void *, struct parser_state *state);
 
 extern void *scanner_init(struct parser_state *state);
diff --git a/include/rule.h b/include/rule.h
index e2a5c87b70022..1e01127e7d195 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -172,7 +172,8 @@ extern struct chain *chain_lookup(const struct table *table,
 
 extern const char *family2str(unsigned int family);
 extern const char *hooknum2str(unsigned int family, unsigned int hooknum);
-extern void chain_print_plain(const struct chain *chain);
+extern void chain_print_plain(const struct chain *chain,
+			      struct output_ctx *octx);
 
 /**
  * struct rule - nftables rule
@@ -493,6 +494,7 @@ struct eval_ctx {
 	struct set		*set;
 	struct stmt		*stmt;
 	struct nft_cache	*cache;
+	struct output_ctx	*octx;
 	unsigned int		debug_mask;
 	struct expr_ctx		ectx;
 	struct proto_ctx	pctx;
@@ -506,7 +508,8 @@ struct netlink_ctx;
 extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 
 extern int cache_update(struct mnl_socket *nf_sock, struct nft_cache *cache,
-			 enum cmd_ops cmd, struct list_head *msgs, bool debug);
+			enum cmd_ops cmd, struct list_head *msgs, bool debug,
+			struct output_ctx *octx);
 extern void cache_flush(struct list_head *table_list);
 extern void cache_release(struct nft_cache *cache);
 
diff --git a/src/cli.c b/src/cli.c
index d923ff7d36175..692d1731461d1 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -135,7 +135,7 @@ static void cli_complete(char *line)
 	line = s;
 
 	parser_init(cli_nf_sock, &cli_nft->cache, state, &msgs,
-		    cli_nft->debug_mask);
+		    cli_nft->debug_mask, &cli_nft->output);
 	scanner_push_buffer(scanner, &indesc_cli, line);
 	nft_run(cli_nft, cli_nf_sock, scanner, state, &msgs);
 	erec_print_list(stdout, &msgs, cli_nft->debug_mask);
diff --git a/src/ct.c b/src/ct.c
index d64f46724002a..482fbe05cb36b 100644
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
index 5bd0c7b37a2b6..94b1224c66e6e 100644
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
@@ -228,16 +229,17 @@ void symbol_table_print(const struct symbol_table *tbl,
 			switch_byteorder(&value, len);
 
 		if (tbl->base == BASE_DECIMAL)
-			printf("\t%-30s\t%20"PRIu64"\n", s->identifier, value);
+			nft_print(octx, "\t%-30s\t%20" PRIu64 "\n",
+				  s->identifier, value);
 		else
-			printf("\t%-30s\t0x%.*" PRIx64 "\n",
-			       s->identifier, 2 * len, value);
+			nft_print(octx, "\t%-30s\t0x%.*" PRIx64 "\n",
+				  s->identifier, 2 * len, value);
 	}
 }
 
 static void invalid_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	gmp_printf("0x%Zx [invalid type]", expr->value);
+	nft_gmp_print(octx, "0x%Zx [invalid type]", expr->value);
 }
 
 const struct datatype invalid_type = {
@@ -251,30 +253,30 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
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
@@ -327,7 +329,7 @@ static void integer_type_print(const struct expr *expr, struct output_ctx *octx)
 		}
 	} while ((dtype = dtype->basetype));
 
-	gmp_printf(fmt, expr->value);
+	nft_gmp_print(octx, fmt, expr->value);
 }
 
 static struct error_record *integer_type_parse(const struct expr *sym,
@@ -364,7 +366,7 @@ static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 
 	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
 	data[len] = '\0';
-	printf("\"%s\"", data);
+	nft_print(octx, "\"%s\"", data);
 }
 
 static struct error_record *string_type_parse(const struct expr *sym,
@@ -396,7 +398,7 @@ static void lladdr_type_print(const struct expr *expr, struct output_ctx *octx)
 	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 
 	for (i = 0; i < len; i++) {
-		printf("%s%.2x", delim, data[i]);
+		nft_print(octx, "%s%.2x", delim, data[i]);
 		delim = ":";
 	}
 }
@@ -449,7 +451,7 @@ static void ipaddr_type_print(const struct expr *expr, struct output_ctx *octx)
 		getnameinfo((struct sockaddr *)&sin, sizeof(sin), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
 	}
-	printf("%s", buf);
+	nft_print(octx, "%s", buf);
 }
 
 static struct error_record *ipaddr_type_parse(const struct expr *sym,
@@ -507,7 +509,7 @@ static void ip6addr_type_print(const struct expr *expr, struct output_ctx *octx)
 		getnameinfo((struct sockaddr *)&sin6, sizeof(sin6), buf,
 			    sizeof(buf), NULL, 0, NI_NUMERICHOST);
 	}
-	printf("%s", buf);
+	nft_print(octx, "%s", buf);
 }
 
 static struct error_record *ip6addr_type_parse(const struct expr *sym,
@@ -557,7 +559,7 @@ static void inet_protocol_type_print(const struct expr *expr,
 	if (octx->numeric < NUMERIC_ALL) {
 		p = getprotobynumber(mpz_get_uint8(expr->value));
 		if (p != NULL) {
-			printf("%s", p->p_name);
+			nft_print(octx, "%s", p->p_name);
 			return;
 		}
 	}
@@ -821,7 +823,7 @@ const struct datatype icmpx_code_type = {
 	.sym_tbl	= &icmpx_code_tbl,
 };
 
-void time_print(uint64_t seconds)
+void time_print(uint64_t seconds, struct output_ctx *octx)
 {
 	uint64_t days, hours, minutes;
 
@@ -835,13 +837,13 @@ void time_print(uint64_t seconds)
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
@@ -933,7 +935,7 @@ struct error_record *time_parse(const struct location *loc, const char *str,
 
 static void time_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	time_print(mpz_get_uint64(expr->value) / MSEC_PER_SEC);
+	time_print(mpz_get_uint64(expr->value) / MSEC_PER_SEC, octx);
 }
 
 static struct error_record *time_type_parse(const struct expr *sym,
diff --git a/src/evaluate.c b/src/evaluate.c
index 836c95288fdab..c796c3c364014 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -193,7 +193,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		break;
 	case SYMBOL_SET:
 		ret = cache_update(ctx->nf_sock, ctx->cache, ctx->cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -2986,14 +2986,14 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -3004,7 +3004,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -3028,7 +3028,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -3072,7 +3072,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	int ret;
 
 	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
-			   ctx->debug_mask & DEBUG_NETLINK);
+			   ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 	if (ret < 0)
 		return ret;
 
@@ -3159,7 +3159,7 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 	int ret;
 
 	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
-			   ctx->debug_mask & DEBUG_NETLINK);
+			   ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 	if (ret < 0)
 		return ret;
 
@@ -3186,7 +3186,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 	int ret;
 
 	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
-			   ctx->debug_mask & DEBUG_NETLINK);
+			   ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 	if (ret < 0)
 		return ret;
 
@@ -3245,7 +3245,7 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK);
+				   ctx->msgs, ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -3343,7 +3343,7 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 	int ret;
 
 	ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
-			   ctx->debug_mask & DEBUG_NETLINK);
+			   ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 	if (ret < 0)
 		return ret;
 
@@ -3365,7 +3365,7 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	return cache_update(ctx->nf_sock, ctx->cache, cmd->op, ctx->msgs,
-			    ctx->debug_mask & DEBUG_NETLINK);
+			    ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 }
 
 static const char *cmd_op_name[] = {
diff --git a/src/expression.c b/src/expression.c
index ff3550c7cd855..fc1097a1cffda 100644
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
+		  expr->ops->name, dtype->name, dtype->desc);
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
 
@@ -971,18 +973,18 @@ static void set_elem_expr_print(const struct expr *expr,
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
+		nft_print(octx, " comment \"%s\"", expr->comment);
 
 	if (expr->stmt) {
-		printf(" : ");
+		nft_print(octx, " : ");
 		stmt_print(expr->stmt, octx);
 	}
 }
diff --git a/src/exthdr.c b/src/exthdr.c
index 37c7688401f60..ac3e16320d388 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -32,18 +32,19 @@ static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 		 */
 		unsigned int offset = expr->exthdr.offset / 64;
 
-		printf("tcp option %s", expr->exthdr.desc->name);
+		nft_print(octx, "tcp option %s", expr->exthdr.desc->name);
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
 			return;
 		if (offset)
-			printf("%d", offset);
-		printf(" %s", expr->exthdr.tmpl->token);
+			nft_print(octx, "%d", offset);
+		nft_print(octx, " %s", expr->exthdr.tmpl->token);
 	} else {
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
-			printf("exthdr %s", expr->exthdr.desc->name);
+			nft_print(octx, "exthdr %s", expr->exthdr.desc->name);
 		else {
-			printf("%s %s", expr->exthdr.desc ? expr->exthdr.desc->name : "unknown-exthdr",
-					expr->exthdr.tmpl->token);
+			nft_print(octx, "%s %s",
+				  expr->exthdr.desc ? expr->exthdr.desc->name : "unknown-exthdr",
+				  expr->exthdr.tmpl->token);
 		}
 	}
 }
@@ -98,7 +99,7 @@ struct expr *exthdr_expr_alloc(const struct location *loc,
 static void exthdr_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	expr_print(stmt->exthdr.expr, octx);
-	printf(" set ");
+	nft_print(octx, " set ");
 	expr_print(stmt->exthdr.val, octx);
 }
 
diff --git a/src/fib.c b/src/fib.c
index b3488afff3923..21bc69a9f0a38 100644
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
index 1a4bfb30814f1..9cd3c8cfa173d 100644
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
index 8e7b586d347cc..079a05b80e511 100644
--- a/src/main.c
+++ b/src/main.c
@@ -316,6 +316,15 @@ static void nft_ctx_free(const struct nft_ctx *ctx)
 	nft_exit();
 }
 
+static FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp)
+{
+	FILE *old = ctx->output.output_fp;
+
+	ctx->output.output_fp = fp;
+
+	return old;
+}
+
 static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
 				   char *buf, size_t buflen)
 {
@@ -324,7 +333,8 @@ static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
 	LIST_HEAD(msgs);
 	void *scanner;
 
-	parser_init(nft->nf_sock, &nft->cache, &state, &msgs, nft->debug_mask);
+	parser_init(nft->nf_sock, &nft->cache, &state,
+		    &msgs, nft->debug_mask, &nft->output);
 	scanner = scanner_init(&state);
 	scanner_push_buffer(scanner, &indesc_cmdline, buf);
 
@@ -345,11 +355,12 @@ static int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	int rc;
 
 	rc = cache_update(nft->nf_sock, &nft->cache, CMD_INVALID, &msgs,
-			  nft->debug_mask);
+			  nft->debug_mask, &nft->output);
 	if (rc < 0)
 		return NFT_EXIT_FAILURE;
 
-	parser_init(nft->nf_sock, &nft->cache, &state, &msgs, nft->debug_mask);
+	parser_init(nft->nf_sock, &nft->cache, &state,
+		    &msgs, nft->debug_mask, &nft->output);
 	scanner = scanner_init(&state);
 	if (scanner_read_file(scanner, filename, &internal_location) < 0) {
 		rc = NFT_EXIT_FAILURE;
@@ -365,6 +376,37 @@ err:
 	return rc;
 }
 
+int nft_print(struct output_ctx *octx, const char *fmt, ...)
+{
+	int ret;
+	va_list arg;
+
+	if (!octx->output_fp)
+		return -1;
+
+	va_start(arg, fmt);
+	ret = vfprintf(octx->output_fp, fmt, arg);
+	va_end(arg);
+	fflush(octx->output_fp);
+
+	return ret;
+}
+
+int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
+{
+	int ret;
+	va_list arg;
+
+	if (!octx->output_fp)
+		return -1;
+
+	va_start(arg, fmt);
+	ret = gmp_vfprintf(octx->output_fp, fmt, arg);
+	va_end(arg);
+
+	return ret;
+}
+
 int main(int argc, char * const *argv)
 {
 	char *buf = NULL, *filename = NULL;
@@ -372,8 +414,11 @@ int main(int argc, char * const *argv)
 	bool interactive = false;
 	struct parser_state state;
 	int i, val, rc;
+	FILE *outfp = fdopen(dup(STDOUT_FILENO), "w");
 
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
+	nft_ctx_set_output(nft, outfp);
+	close(STDOUT_FILENO);
 
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
diff --git a/src/meta.c b/src/meta.c
index 9c808930532ea..56b9e29699743 100644
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
diff --git a/src/netlink.c b/src/netlink.c
index 3183a8100f752..d5d410a847624 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -39,6 +39,8 @@
 #include <erec.h>
 #include <iface.h>
 
+#define nft_mon_print(monh, ...) nft_print(monh->ctx->octx, __VA_ARGS__)
+
 const struct input_descriptor indesc_netlink = {
 	.name	= "netlink",
 	.type	= INDESC_NETLINK,
@@ -470,7 +472,7 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 	if (ctx->octx->echo) {
 		err = cache_update(ctx->nf_sock, ctx->cache,
 				   CMD_INVALID, ctx->msgs,
-				   ctx->debug_mask & DEBUG_NETLINK);
+				   ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 		if (err < 0)
 			return err;
 
@@ -504,15 +506,15 @@ int netlink_del_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-void netlink_dump_rule(const struct nftnl_rule *nlr, unsigned int debug_mask)
+void netlink_dump_rule(const struct nftnl_rule *nlr, struct netlink_ctx *ctx)
 {
-	char buf[4096];
+	FILE *fp = ctx->octx->output_fp;
 
-	if (!(debug_mask & DEBUG_NETLINK))
+	if (!(ctx->debug_mask & DEBUG_NETLINK) || !fp)
 		return;
 
-	nftnl_rule_snprintf(buf, sizeof(buf), nlr, 0, 0);
-	fprintf(stdout, "%s\n", buf);
+	nftnl_rule_fprintf(fp, nlr, 0, 0);
+	fprintf(fp, "\n");
 }
 
 void netlink_dump_expr(const struct nftnl_expr *nle,
@@ -544,7 +546,7 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *arg)
 	    (h->chain && strcmp(chain, h->chain) != 0))
 		return 0;
 
-	netlink_dump_rule(nlr, ctx->debug_mask);
+	netlink_dump_rule(nlr, ctx);
 	rule = netlink_delinearize_rule(ctx, nlr);
 	list_add_tail(&rule->list, &ctx->list);
 
@@ -576,15 +578,15 @@ static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 	return netlink_del_rule_batch(ctx, h, loc);
 }
 
-void netlink_dump_chain(const struct nftnl_chain *nlc, unsigned int debug_mask)
+void netlink_dump_chain(const struct nftnl_chain *nlc, struct netlink_ctx *ctx)
 {
-	char buf[4096];
+	FILE *fp = ctx->octx->output_fp;
 
-	if (!(debug_mask & DEBUG_NETLINK))
+	if (!(ctx->debug_mask & DEBUG_NETLINK) || !fp)
 		return;
 
-	nftnl_chain_snprintf(buf, sizeof(buf), nlc, 0, 0);
-	fprintf(stdout, "%s\n", buf);
+	nftnl_chain_fprintf(fp, nlc, 0, 0);
+	fprintf(fp, "\n");
 }
 
 static int netlink_add_chain_compat(struct netlink_ctx *ctx,
@@ -610,7 +612,7 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 					    chain->policy);
 	}
 
-	netlink_dump_chain(nlc, ctx->debug_mask);
+	netlink_dump_chain(nlc, ctx);
 	err = mnl_nft_chain_add(ctx->nf_sock, nlc, flags, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -646,7 +648,7 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 					    chain->dev);
 	}
 
-	netlink_dump_chain(nlc, ctx->debug_mask);
+	netlink_dump_chain(nlc, ctx);
 	err = mnl_nft_chain_batch_add(nlc, ctx->batch, flags, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -676,7 +678,7 @@ static int netlink_rename_chain_compat(struct netlink_ctx *ctx,
 
 	nlc = alloc_nftnl_chain(h);
 	nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, name);
-	netlink_dump_chain(nlc, ctx->debug_mask);
+	netlink_dump_chain(nlc, ctx);
 	err = mnl_nft_chain_add(ctx->nf_sock, nlc, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -696,7 +698,7 @@ static int netlink_rename_chain_batch(struct netlink_ctx *ctx,
 
 	nlc = alloc_nftnl_chain(h);
 	nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, name);
-	netlink_dump_chain(nlc, ctx->debug_mask);
+	netlink_dump_chain(nlc, ctx);
 	err = mnl_nft_chain_batch_add(nlc, ctx->batch, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -723,7 +725,7 @@ static int netlink_del_chain_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nlc = alloc_nftnl_chain(h);
-	netlink_dump_chain(nlc, ctx->debug_mask);
+	netlink_dump_chain(nlc, ctx);
 	err = mnl_nft_chain_delete(ctx->nf_sock, nlc, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -741,7 +743,7 @@ static int netlink_del_chain_batch(struct netlink_ctx *ctx,
 	int err;
 
 	nlc = alloc_nftnl_chain(h);
-	netlink_dump_chain(nlc, ctx->debug_mask);
+	netlink_dump_chain(nlc, ctx);
 	err = mnl_nft_chain_batch_del(nlc, ctx->batch, 0, ctx->seqnum);
 	nftnl_chain_free(nlc);
 
@@ -1031,15 +1033,15 @@ static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 	}
 }
 
-void netlink_dump_set(const struct nftnl_set *nls, unsigned int debug_mask)
+void netlink_dump_set(const struct nftnl_set *nls, struct netlink_ctx *ctx)
 {
-	char buf[4096];
+	FILE *fp = ctx->octx->output_fp;
 
-	if (!(debug_mask & DEBUG_NETLINK))
+	if (!(ctx->debug_mask & DEBUG_NETLINK) || !fp)
 		return;
 
-	nftnl_set_snprintf(buf, sizeof(buf), nls, 0, 0);
-	fprintf(stdout, "%s\n", buf);
+	nftnl_set_fprintf(fp, nls, 0, 0);
+	fprintf(fp, "\n");
 }
 
 static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
@@ -1171,7 +1173,7 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_LEN,
 				  set->datalen / BITS_PER_BYTE);
 	}
-	netlink_dump_set(nls, ctx->debug_mask);
+	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_set_add(ctx->nf_sock, nls, NLM_F_ECHO | flags,
 			      ctx->seqnum);
@@ -1242,7 +1244,7 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 			   nftnl_udata_buf_len(udbuf));
 	nftnl_udata_buf_free(udbuf);
 
-	netlink_dump_set(nls, ctx->debug_mask);
+	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_set_batch_add(nls, ctx->batch, flags, ctx->seqnum);
 	if (err < 0)
@@ -1357,7 +1359,7 @@ static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
 
 	nls = alloc_nftnl_set(h);
 	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls, ctx->debug_mask);
+	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_batch_add(nls, ctx->batch, flags, ctx->seqnum);
 	nftnl_set_free(nls);
@@ -1377,7 +1379,7 @@ static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 
 	nls = alloc_nftnl_set(h);
 	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls, ctx->debug_mask);
+	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_add(ctx->nf_sock, nls, flags, ctx->seqnum);
 	nftnl_set_free(nls);
@@ -1407,7 +1409,7 @@ static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
 	nls = alloc_nftnl_set(h);
 	if (expr)
 		alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls, ctx->debug_mask);
+	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_batch_del(nls, ctx->batch, 0, ctx->seqnum);
 	nftnl_set_free(nls);
@@ -1427,7 +1429,7 @@ static int netlink_del_setelems_compat(struct netlink_ctx *ctx,
 
 	nls = alloc_nftnl_set(h);
 	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls, ctx->debug_mask);
+	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_delete(ctx->nf_sock, nls, 0, ctx->seqnum);
 	nftnl_set_free(nls);
@@ -1445,7 +1447,7 @@ int netlink_flush_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nls = alloc_nftnl_set(h);
-	netlink_dump_set(nls, ctx->debug_mask);
+	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_batch_flush(nls, ctx->batch, 0, ctx->seqnum);
 	nftnl_set_free(nls);
@@ -1657,15 +1659,15 @@ out:
 	return err;
 }
 
-void netlink_dump_obj(struct nftnl_obj *nln, unsigned int debug_mask)
+void netlink_dump_obj(struct nftnl_obj *nln, struct netlink_ctx *ctx)
 {
-	char buf[4096];
+	FILE *fp = ctx->octx->output_fp;
 
-	if (!(debug_mask & DEBUG_NETLINK))
+	if (!(ctx->debug_mask & DEBUG_NETLINK) || !fp)
 		return;
 
-	nftnl_obj_snprintf(buf, sizeof(buf), nln, 0, 0);
-	fprintf(stdout, "%s\n", buf);
+	nftnl_obj_fprintf(fp, nln, 0, 0);
+	fprintf(fp, "\n");
 }
 
 int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
@@ -1675,7 +1677,7 @@ int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nlo = alloc_nftnl_obj(h, obj);
-	netlink_dump_obj(nlo, ctx->debug_mask);
+	netlink_dump_obj(nlo, ctx);
 
 	err = mnl_nft_obj_batch_add(nlo, ctx->batch, flags, ctx->seqnum);
 	if (err < 0)
@@ -1693,7 +1695,7 @@ int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nlo = __alloc_nftnl_obj(h, type);
-	netlink_dump_obj(nlo, ctx->debug_mask);
+	netlink_dump_obj(nlo, ctx);
 
 	err = mnl_nft_obj_batch_del(nlo, ctx->batch, 0, ctx->seqnum);
 	if (err < 0)
@@ -1999,16 +2001,16 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 	case NFTNL_OUTPUT_DEFAULT:
 		if (type == NFT_MSG_NEWTABLE) {
 			if (nlh->nlmsg_flags & NLM_F_EXCL)
-				printf("update table ");
+				nft_mon_print(monh, "update table ");
 			else
-				printf("add table ");
+				nft_mon_print(monh, "add table ");
 		} else {
-			printf("delete table ");
+			nft_mon_print(monh, "delete table ");
 		}
 
 		family = nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY);
 
-		printf("%s %s\n", family2str(family),
+		nft_mon_print(monh, "%s %s\n", family2str(family),
 		       nftnl_table_get_str(nlt, NFTNL_TABLE_NAME));
 		break;
 	case NFTNL_OUTPUT_XML:
@@ -2037,17 +2039,17 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 		switch (type) {
 		case NFT_MSG_NEWCHAIN:
 			if (nlh->nlmsg_flags & NLM_F_EXCL)
-				printf("update ");
+				nft_mon_print(monh, "update ");
 			else
-				printf("add ");
+				nft_mon_print(monh, "add ");
 
 			c = netlink_delinearize_chain(monh->ctx, nlc);
-			chain_print_plain(c);
+			chain_print_plain(c, monh->ctx->octx);
 			chain_free(c);
 			break;
 		case NFT_MSG_DELCHAIN:
 			family = nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY);
-			printf("delete chain %s %s %s\n", family2str(family),
+			nft_mon_print(monh, "delete chain %s %s %s\n", family2str(family),
 			       nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE),
 			       nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
 			break;
@@ -2081,7 +2083,7 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 	case NFTNL_OUTPUT_DEFAULT:
 		switch (type) {
 		case NFT_MSG_NEWSET:
-			printf("add ");
+			nft_mon_print(monh, "add ");
 			set = netlink_delinearize_set(monh->ctx, nls);
 			if (set == NULL) {
 				nftnl_set_free(nls);
@@ -2089,11 +2091,11 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 			}
 			set_print_plain(set, monh->ctx->octx);
 			set_free(set);
-			printf("\n");
+			nft_mon_print(monh, "\n");
 			break;
 		case NFT_MSG_DELSET:
 			family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
-			printf("delete set %s %s %s\n",
+			nft_mon_print(monh, "delete set %s %s %s\n",
 			       family2str(family),
 			       nftnl_set_get_str(nls, NFTNL_SET_TABLE),
 			       nftnl_set_get_str(nls, NFTNL_SET_NAME));
@@ -2234,18 +2236,18 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 
 		switch (type) {
 		case NFT_MSG_NEWSETELEM:
-			printf("add ");
+			nft_mon_print(monh, "add ");
 			break;
 		case NFT_MSG_DELSETELEM:
-			printf("delete ");
+			nft_mon_print(monh, "delete ");
 			break;
 		default:
 			set_free(dummyset);
 			goto out;
 		}
-		printf("element %s %s %s ", family2str(family), table, setname);
+		nft_mon_print(monh, "element %s %s %s ", family2str(family), table, setname);
 		expr_print(dummyset->init, monh->ctx->octx);
-		printf("\n");
+		nft_mon_print(monh, "\n");
 
 		set_free(dummyset);
 		break;
@@ -2274,7 +2276,7 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 	case NFTNL_OUTPUT_DEFAULT:
 		switch (type) {
 		case NFT_MSG_NEWOBJ:
-			printf("add ");
+			nft_mon_print(monh, "add ");
 			obj = netlink_delinearize_obj(monh->ctx, nlo);
 			if (obj == NULL) {
 				nftnl_obj_free(nlo);
@@ -2282,11 +2284,11 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 			}
 			obj_print_plain(obj, monh->ctx->octx);
 			obj_free(obj);
-			printf("\n");
+			nft_mon_print(monh, "\n");
 			break;
 		case NFT_MSG_DELOBJ:
 			family = nftnl_obj_get_u32(nlo, NFTNL_OBJ_FAMILY);
-			printf("delete %s %s %s %s\n",
+			nft_mon_print(monh, "delete %s %s %s %s\n",
 			       obj_type_name(nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE)),
 			       family2str(family),
 			       nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE),
@@ -2338,14 +2340,14 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 			nlr_for_each_set(nlr, rule_map_decompose_cb, NULL,
 					 monh->cache);
 
-			printf("add rule %s %s %s ", family, table, chain);
+			nft_mon_print(monh, "add rule %s %s %s ", family, table, chain);
 			rule_print(r, monh->ctx->octx);
-			printf("\n");
+			nft_mon_print(monh, "\n");
 
 			rule_free(r);
 			break;
 		case NFT_MSG_DELRULE:
-			printf("delete rule %s %s %s handle %u\n",
+			nft_mon_print(monh, "delete rule %s %s %s handle %u\n",
 			       family, table, chain, (unsigned int)handle);
 			break;
 		}
@@ -2923,13 +2925,13 @@ static int netlink_events_newgen_cb(const struct nlmsghdr *nlh, int type,
 		}
 	}
 	if (genid >= 0) {
-		printf("# new generation %d", genid);
+		nft_mon_print(monh, "# new generation %d", genid);
 		if (pid >= 0) {
-			printf(" by process %d", pid);
+			nft_mon_print(monh, " by process %d", pid);
 			if (!monh->ctx->octx->numeric)
-				printf(" (%s)", name);
+				nft_mon_print(monh, " (%s)", name);
 		}
-		printf("\n");
+		nft_mon_print(monh, "\n");
 	}
 
 	return MNL_CB_OK;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c070fee2f6525..1712cba2d45a0 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1337,5 +1337,5 @@ void netlink_linearize_rule(struct netlink_ctx *ctx, struct nftnl_rule *nlr,
 		nftnl_udata_buf_free(udata);
 	}
 
-	netlink_dump_rule(nlr, ctx->debug_mask);
+	netlink_dump_rule(nlr, ctx);
 }
diff --git a/src/numgen.c b/src/numgen.c
index 19a4a9ce06450..aa6da490d5d99 100644
--- a/src/numgen.c
+++ b/src/numgen.c
@@ -30,10 +30,11 @@ static const char *numgen_type_str(enum nft_ng_types type)
 
 static void numgen_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	printf("numgen %s mod %u", numgen_type_str(expr->numgen.type),
-	       expr->numgen.mod);
+	nft_print(octx, "numgen %s mod %u",
+		  numgen_type_str(expr->numgen.type),
+		  expr->numgen.mod);
 	if (expr->numgen.offset)
-		printf(" offset %u", expr->numgen.offset);
+		nft_print(octx, " offset %u", expr->numgen.offset);
 }
 
 static bool numgen_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c7ba1495adf33..fad7036022130 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -37,7 +37,7 @@
 
 void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 		 struct parser_state *state, struct list_head *msgs,
-		 unsigned int debug_mask)
+		 unsigned int debug_mask, struct output_ctx *octx)
 {
 	memset(state, 0, sizeof(*state));
 	init_list_head(&state->cmds);
@@ -48,6 +48,7 @@ void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 	state->ectx.msgs = msgs;
 	state->ectx.nf_sock = nf_sock;
 	state->ectx.debug_mask = debug_mask;
+	state->ectx.octx = octx;
 }
 
 static void yyerror(struct location *loc, struct nft_ctx *nft, void *scanner,
diff --git a/src/payload.c b/src/payload.c
index 7f94ff7f2a47c..aa8a95ad59f1c 100644
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
@@ -187,7 +187,7 @@ unsigned int payload_hdr_field(const struct expr *expr)
 static void payload_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	expr_print(stmt->payload.expr, octx);
-	printf(" set ");
+	nft_print(octx, " set ");
 	expr_print(stmt->payload.val, octx);
 }
 
diff --git a/src/rt.c b/src/rt.c
index 91be5a11c5a28..9ad9e398ebef3 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -82,7 +82,7 @@ static const struct rt_template rt_templates[] = {
 
 static void rt_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	printf("rt %s", rt_templates[expr->rt.key].token);
+	nft_print(octx, "rt %s", rt_templates[expr->rt.key].token);
 }
 
 static bool rt_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/rule.c b/src/rule.c
index 91129734a3d8f..7092d2d6141b7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -123,7 +123,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 
 static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 		      enum cmd_ops cmd, struct list_head *msgs,
-		      unsigned int debug_mask)
+		      unsigned int debug_mask, struct output_ctx *octx)
 {
 	struct handle handle = {
 		.family = NFPROTO_UNSPEC,
@@ -135,6 +135,7 @@ static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 		.msgs		= msgs,
 		.seqnum		= cache->seqnum++,
 		.debug_mask	= debug_mask,
+		.octx		= octx,
 	};
 	int ret;
 
@@ -149,7 +150,8 @@ static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 }
 
 int cache_update(struct mnl_socket *nf_sock, struct nft_cache *cache,
-		 enum cmd_ops cmd, struct list_head *msgs, bool debug)
+		 enum cmd_ops cmd, struct list_head *msgs, bool debug,
+		 struct output_ctx *octx)
 {
 	int ret;
 
@@ -157,7 +159,7 @@ int cache_update(struct mnl_socket *nf_sock, struct nft_cache *cache,
 		return 0;
 replay:
 	netlink_genid_get(nf_sock, cache->seqnum++);
-	ret = cache_init(nf_sock, cache, cmd, msgs, debug);
+	ret = cache_init(nf_sock, cache, cmd, msgs, debug, octx);
 	if (ret < 0) {
 		cache_release(cache);
 		if (errno == EINTR) {
@@ -272,7 +274,8 @@ static const char *set_policy2str(uint32_t policy)
 }
 
 static void set_print_declaration(const struct set *set,
-				  struct print_fmt_options *opts)
+				  struct print_fmt_options *opts,
+				  struct output_ctx *octx)
 {
 	const char *delim = "";
 	const char *type;
@@ -285,34 +288,38 @@ static void set_print_declaration(const struct set *set,
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
 
-	printf("%s%stype %s", opts->tab, opts->tab, set->key->dtype->name);
+	nft_print(octx, "%s%stype %s",
+		  opts->tab, opts->tab, set->key->dtype->name);
 	if (set->flags & NFT_SET_MAP)
-		printf(" : %s", set->datatype->name);
+		nft_print(octx, " : %s", set->datatype->name);
 	else if (set->flags & NFT_SET_OBJECT)
-		printf(" : %s", obj_type_name(set->objtype));
+		nft_print(octx, " : %s", obj_type_name(set->objtype));
 
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
 
@@ -322,45 +329,45 @@ static void set_print_declaration(const struct set *set,
 		flags &= ~NFT_SET_TIMEOUT;
 
 	if (flags & (NFT_SET_CONSTANT | NFT_SET_INTERVAL | NFT_SET_TIMEOUT)) {
-		printf("%s%sflags ", opts->tab, opts->tab);
+		nft_print(octx, "%s%sflags ", opts->tab, opts->tab);
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
+		nft_print(octx, "%s%stimeout ", opts->tab, opts->tab);
+		time_print(set->timeout / 1000, octx);
+		nft_print(octx, "%s", opts->stmt_separator);
 	}
 	if (set->gc_int) {
-		printf("%s%sgc-interval ", opts->tab, opts->tab);
-		time_print(set->gc_int / 1000);
-		printf("%s", opts->stmt_separator);
+		nft_print(octx, "%s%sgc-interval ", opts->tab, opts->tab);
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
+		nft_print(octx, "%s%selements = ", opts->tab, opts->tab);
 		expr_print(set->init, octx);
-		printf("%s", opts->nl);
+		nft_print(octx, "%s", opts->nl);
 	}
-	printf("%s}%s", opts->tab, opts->nl);
+	nft_print(octx, "%s}%s", opts->tab, opts->nl);
 }
 
 void set_print(const struct set *s, struct output_ctx *octx)
@@ -425,14 +432,14 @@ void rule_print(const struct rule *rule, struct output_ctx *octx)
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
@@ -662,16 +669,17 @@ static const char *chain_policy2str(uint32_t policy)
 	return "unknown";
 }
 
-static void chain_print_declaration(const struct chain *chain)
+static void chain_print_declaration(const struct chain *chain,
+				    struct output_ctx *octx)
 {
-	printf("\tchain %s {\n", chain->handle.chain);
+	nft_print(octx, "\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf("\t\ttype %s hook %s", chain->type,
-		       hooknum2str(chain->handle.family, chain->hooknum));
+		nft_print(octx, "\t\ttype %s hook %s", chain->type,
+			  hooknum2str(chain->handle.family, chain->hooknum));
 		if (chain->dev != NULL)
-			printf(" device %s", chain->dev);
-		printf(" priority %d; policy %s;\n",
-		       chain->priority, chain_policy2str(chain->policy));
+			nft_print(octx, " device %s", chain->dev);
+		nft_print(octx, " priority %d; policy %s;\n",
+			  chain->priority, chain_policy2str(chain->policy));
 	}
 }
 
@@ -679,28 +687,28 @@ static void chain_print(const struct chain *chain, struct output_ctx *octx)
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
 
-void chain_print_plain(const struct chain *chain)
+void chain_print_plain(const struct chain *chain, struct output_ctx *octx)
 {
-	printf("chain %s %s %s", family2str(chain->handle.family),
-	       chain->handle.table, chain->handle.chain);
+	nft_print(octx, "chain %s %s %s", family2str(chain->handle.family),
+		  chain->handle.table, chain->handle.chain);
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf(" { type %s hook %s priority %d; policy %s; }",
-		       chain->type, chain->hookstr,
-		       chain->priority, chain_policy2str(chain->policy));
+		nft_print(octx, " { type %s hook %s priority %d; policy %s; }",
+			  chain->type, chain->hookstr,
+			  chain->priority, chain_policy2str(chain->policy));
 	}
 
-	printf("\n");
+	nft_print(octx, "\n");
 }
 
 struct table *table_alloc(void)
@@ -763,22 +771,23 @@ const char *table_flags_name[TABLE_FLAGS_MAX] = {
 	"dormant",
 };
 
-static void table_print_options(const struct table *table, const char **delim)
+static void table_print_options(const struct table *table, const char **delim,
+				struct output_ctx *octx)
 {
 	uint32_t flags = table->flags;
 	int i;
 
 	if (flags) {
-		printf("\tflags ");
+		nft_print(octx, "\tflags ");
 
 		for (i = 0; i < TABLE_FLAGS_MAX; i++) {
 			if (flags & 0x1)
-				printf("%s", table_flags_name[i]);
+				nft_print(octx, "%s", table_flags_name[i]);
 			flags >>= 1;
 			if (flags)
-				printf(",");
+				nft_print(octx, ",");
 		}
-		printf("\n");
+		nft_print(octx, "\n");
 		*delim = "\n";
 	}
 }
@@ -791,27 +800,27 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 	const char *delim = "";
 	const char *family = family2str(table->handle.family);
 
-	printf("table %s %s {\n", family, table->handle.table);
-	table_print_options(table, &delim);
+	nft_print(octx, "table %s %s {\n", family, table->handle.table);
+	table_print_options(table, &delim, octx);
 
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
@@ -1020,7 +1029,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 		int ret;
 
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->obj,
-				   ctx->msgs, ctx->debug_mask);
+				   ctx->msgs, ctx->debug_mask, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -1072,7 +1081,7 @@ static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 		int ret;
 
 		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->obj,
-				   ctx->msgs, ctx->debug_mask);
+				   ctx->msgs, ctx->debug_mask, ctx->octx);
 		if (ret < 0)
 			return ret;
 
@@ -1178,9 +1187,9 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -1193,11 +1202,11 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 			if (cmd->obj == CMD_OBJ_MAPS &&
 			    !(set->flags & NFT_SET_MAP))
 				continue;
-			set_print_declaration(set, &opts);
-			printf("%s}%s", opts.tab, opts.nl);
+			set_print_declaration(set, &opts, ctx->octx);
+			nft_print(ctx->octx, "%s}%s", opts.tab, opts.nl);
 		}
 
-		printf("}\n");
+		nft_print(ctx->octx, "}\n");
 	}
 	return 0;
 }
@@ -1246,14 +1255,14 @@ struct obj *obj_lookup(const struct table *table, const char *name,
 	return NULL;
 }
 
-static void print_proto_name_proto(uint8_t l4)
+static void print_proto_name_proto(uint8_t l4, struct output_ctx *octx)
 {
 	const struct protoent *p = getprotobynumber(l4);
 
 	if (p)
-		printf("%s\n", p->p_name);
+		nft_print(octx, "%s\n", p->p_name);
 	else
-		printf("%d\n", l4);
+		nft_print(octx, "%d\n", l4);
 }
 
 static void obj_print_data(const struct obj *obj,
@@ -1262,36 +1271,39 @@ static void obj_print_data(const struct obj *obj,
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
+		nft_print(octx, "packets %" PRIu64 " bytes %" PRIu64 "",
+			  obj->counter.packets, obj->counter.bytes);
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
-		print_proto_name_proto(obj->ct_helper.l4proto);
-		printf("\t\tl3proto %s", family2str(obj->ct_helper.l3proto));
+		nft_print(octx, "ct helper %s {\n", obj->handle.obj);
+		nft_print(octx, "\t\ttype \"%s\" protocol ",
+			  obj->ct_helper.name);
+		print_proto_name_proto(obj->ct_helper.l4proto, octx);
+		nft_print(octx, "\t\tl3proto %s",
+			  family2str(obj->ct_helper.l3proto));
 		break;
 		}
 	case NFT_OBJECT_LIMIT: {
@@ -1299,34 +1311,36 @@ static void obj_print_data(const struct obj *obj,
 		const char *data_unit;
 		uint64_t rate;
 
-		printf(" %s {%s%s%s", obj->handle.obj,
-				      opts->nl, opts->tab, opts->tab);
+		nft_print(octx, " %s {%s%s%s", obj->handle.obj,
+			  opts->nl, opts->tab, opts->tab);
 		switch (obj->limit.type) {
 		case NFT_LIMIT_PKTS:
-			printf("limit rate %s%" PRIu64 "/%s",
-			       inv ? "over " : "", obj->limit.rate,
-			       get_unit(obj->limit.unit));
+			nft_print(octx, "limit rate %s%" PRIu64 "/%s",
+				  inv ? "over " : "", obj->limit.rate,
+				  get_unit(obj->limit.unit));
 			if (obj->limit.burst > 0)
-				printf(" burst %u packets", obj->limit.burst);
+				nft_print(octx, " burst %u packets",
+					  obj->limit.burst);
 			break;
 		case NFT_LIMIT_PKT_BYTES:
 			data_unit = get_rate(obj->limit.rate, &rate);
 
-			printf("limit rate %s%" PRIu64 " %s/%s",
-			       inv ? "over " : "", rate, data_unit,
-			       get_unit(obj->limit.unit));
+			nft_print(octx, "limit rate %s%" PRIu64 " %s/%s",
+				  inv ? "over " : "", rate, data_unit,
+				  get_unit(obj->limit.unit));
 			if (obj->limit.burst > 0) {
 				uint64_t burst;
 
 				data_unit = get_rate(obj->limit.burst, &burst);
-				printf(" burst %"PRIu64" %s", burst, data_unit);
+				nft_print(octx, " burst %"PRIu64" %s",
+					  burst, data_unit);
 			}
 			break;
 		}
 		}
 		break;
 	default:
-		printf("unknown {%s", opts->nl);
+		nft_print(octx, "unknown {%s", opts->nl);
 		break;
 	}
 }
@@ -1363,17 +1377,17 @@ static void obj_print_declaration(const struct obj *obj,
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
@@ -1414,13 +1428,13 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
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
 
@@ -1433,7 +1447,7 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 			obj_print_declaration(obj, &opts, ctx->octx);
 		}
 
-		printf("}\n");
+		nft_print(ctx->octx, "}\n");
 	}
 	return 0;
 }
@@ -1469,19 +1483,20 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -1489,7 +1504,7 @@ static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
 {
 	struct chain *chain;
 
-	table_print_declaration(table);
+	table_print_declaration(table, ctx->octx);
 
 	list_for_each_entry(chain, &table->chains, list) {
 		if (chain->handle.family != cmd->handle.family ||
@@ -1499,7 +1514,7 @@ static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
 		chain_print(chain, ctx->octx);
 	}
 
-	printf("}\n");
+	nft_print(ctx->octx, "}\n");
 
 	return 0;
 }
@@ -1514,13 +1529,13 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -1535,9 +1550,9 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 	if (set == NULL)
 		return -1;
 
-	table_print_declaration(table);
+	table_print_declaration(table, ctx->octx);
 	set_print(set, ctx->octx);
-	printf("}\n");
+	nft_print(ctx->octx, "}\n");
 
 	return 0;
 }
@@ -1728,9 +1743,10 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
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
 
@@ -1776,7 +1792,7 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_MONITOR:
 		return do_command_monitor(ctx, cmd);
 	case CMD_DESCRIBE:
-		return do_command_describe(ctx, cmd);
+		return do_command_describe(ctx, cmd, ctx->octx);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/statement.c b/src/statement.c
index 0b2c28bc374af..6166863bacedc 100644
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
@@ -190,10 +190,11 @@ static void objref_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
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
@@ -234,39 +235,40 @@ static const char *log_level(uint32_t level)
 
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
 
@@ -329,23 +331,25 @@ static void limit_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 
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
@@ -370,17 +374,17 @@ static void queue_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
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
 
@@ -402,12 +406,12 @@ static void quota_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
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
 
@@ -428,15 +432,15 @@ struct stmt *quota_stmt_alloc(const struct location *loc)
 
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
@@ -444,13 +448,13 @@ static void reject_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
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
@@ -469,7 +473,7 @@ struct stmt *reject_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &reject_stmt_ops);
 }
 
-static void print_nf_nat_flags(uint32_t flags)
+static void print_nf_nat_flags(uint32_t flags, struct output_ctx *octx)
 {
 	const char *delim = " ";
 
@@ -477,17 +481,17 @@ static void print_nf_nat_flags(uint32_t flags)
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
@@ -497,21 +501,21 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
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
@@ -521,11 +525,11 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
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
@@ -548,14 +552,14 @@ struct stmt *nat_stmt_alloc(const struct location *loc)
 
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
@@ -577,14 +581,14 @@ struct stmt *masq_stmt_alloc(const struct location *loc)
 
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
@@ -611,9 +615,9 @@ static const char * const set_stmt_op_names[] = {
 
 static void set_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("set %s ", set_stmt_op_names[stmt->set.op]);
+	nft_print(octx, "set %s ", set_stmt_op_names[stmt->set.op]);
 	expr_print(stmt->set.key, octx);
-	printf(" ");
+	nft_print(octx, " ");
 	expr_print(stmt->set.set, octx);
 }
 
@@ -637,13 +641,13 @@ struct stmt *set_stmt_alloc(const struct location *loc)
 
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
@@ -669,7 +673,7 @@ struct stmt *dup_stmt_alloc(const struct location *loc)
 
 static void fwd_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	printf("fwd to ");
+	nft_print(octx, "fwd to ");
 	expr_print(stmt->fwd.to, octx);
 }
 
-- 
2.13.1

