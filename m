From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH RFC] libnftables: Implement JSON output support
Date: Wed, 17 Jan 2018 12:51:40 +0100
Message-ID: <20180117115140.10751-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49552 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752654AbeAQLvw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jan 2018 06:51:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Although technically there already is support for JSON output via 'nft
export json' command, it is hardly useable since it exports all the gory
details of nftables VM. Also, libnftables has no control over what is
exported since the content comes directly from libnftnl.

Instead, implement JSON format support for regular 'nft list' commands.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Note that this is incomplete and merely meant as foundation for a
discussion about the implementation. A few things I am not happy with:

* The amount of ifdef's introduced is certainly not optimal, though I
  don't see how this could be avoided if JSON support is to be kept
  optional.

* There is quite some code-duplication involved given that this
  introduces an alternative function for almost any function in the
  affected code path.

* JSON output is completely numeric. While this is intentional as it
  helps applications parsing e.g. port numbers, other things like e.g.
  TCP header flags become a bit cryptic.
---
 configure.ac                |  14 ++-
 include/datatype.h          |  14 +++
 include/expression.h        |   9 ++
 include/nftables.h          |   3 +
 include/nftables/nftables.h |   2 +
 include/statement.h         |   7 ++
 src/Makefile.am             |   4 +
 src/datatype.c              |  72 +++++++++++++
 src/expression.c            |  64 ++++++++++++
 src/libnftables.c           |  16 +++
 src/main.c                  |  11 +-
 src/meta.c                  |  16 +++
 src/payload.c               |  23 +++++
 src/rule.c                  | 242 +++++++++++++++++++++++++++++++++++++++++++-
 src/statement.c             |  10 ++
 15 files changed, 504 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6ed3edca1fe5c..ad1c068656d88 100644
--- a/configure.ac
+++ b/configure.ac
@@ -111,6 +111,17 @@ AC_DEFINE([HAVE_LIBXTABLES], [1], [0])
 AC_SUBST(with_libxtables)
 AM_CONDITIONAL([BUILD_XTABLES], [test "x$with_libxtables" == xyes])
 
+AC_ARG_WITH([json], [AS_HELP_STRING([--with-json],
+            [Enable JSON output support)])],
+	    [], [with_json=no])
+AS_IF([test "x$with_json" != xno], [
+AC_CHECK_LIB([jansson], [json_object], ,
+	AC_MSG_ERROR([No suitable version of libjansson found]))
+AC_DEFINE([HAVE_LIBJANSSON], [1], [Define if you have libjansson])
+])
+AC_SUBST(with_json)
+AM_CONDITIONAL([BUILD_JSON], [test "x$with_json" != xno])
+
 # Checks for header files.
 AC_HEADER_STDC
 AC_HEADER_ASSERT
@@ -163,4 +174,5 @@ nft configuration:
   enable debugging symbols:	${with_debug}
   use mini-gmp:			${with_mini_gmp}
   enable pdf documentation:	${enable_pdf_doc}
-  libxtables support:		${with_libxtables}"
+  libxtables support:		${with_libxtables}
+  json output support:          ${with_json}"
diff --git a/include/datatype.h b/include/datatype.h
index e9f60798d1a0c..05a64ffd447c9 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -1,6 +1,10 @@
 #ifndef NFTABLES_DATATYPE_H
 #define NFTABLES_DATATYPE_H
 
+#ifdef HAVE_LIBJANSSON
+#include <jansson.h>
+#endif
+
 /**
  * enum datatypes
  *
@@ -147,6 +151,9 @@ struct datatype {
 	const char			*basefmt;
 	void				(*print)(const struct expr *expr,
 						 struct output_ctx *octx);
+#ifdef HAVE_LIBJANSSON
+	json_t				*(*json)(const struct expr *expr);
+#endif
 	struct error_record		*(*parse)(const struct expr *sym,
 						  struct expr **res);
 	const struct symbol_table	*sym_tbl;
@@ -158,6 +165,9 @@ extern const struct datatype *datatype_lookup_byname(const char *name);
 extern struct error_record *symbol_parse(const struct expr *sym,
 					 struct expr **res);
 extern void datatype_print(const struct expr *expr, struct output_ctx *octx);
+#ifdef HAVE_LIBJANSSON
+extern json_t *datatype_json(const struct expr *expr);
+#endif
 
 static inline bool datatype_equal(const struct datatype *d1,
 				  const struct datatype *d2)
@@ -207,6 +217,10 @@ extern struct error_record *symbolic_constant_parse(const struct expr *sym,
 extern void symbolic_constant_print(const struct symbol_table *tbl,
 				    const struct expr *expr, bool quotes,
 				    struct output_ctx *octx);
+#ifdef HAVE_LIBJANSSON
+extern json_t *symbolic_constant_json(const struct symbol_table *tbl,
+				      const struct expr *expr);
+#endif
 extern void symbol_table_print(const struct symbol_table *tbl,
 			       const struct datatype *dtype,
 			       enum byteorder byteorder,
diff --git a/include/expression.h b/include/expression.h
index 0a0e178fe4680..4b57c3d1b3697 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -9,6 +9,9 @@
 #include <datatype.h>
 #include <utils.h>
 #include <list.h>
+#ifdef HAVE_LIBJANSSON
+#include <jansson.h>
+#endif
 
 /**
  * enum expr_types
@@ -159,6 +162,9 @@ struct expr_ops {
 					    enum byteorder byteorder);
 	void			(*print)(const struct expr *expr,
 					 struct output_ctx *octx);
+#ifdef HAVE_LIBJANSSON
+	json_t *		(*json)(const struct expr *expr);
+#endif
 	bool			(*cmp)(const struct expr *e1,
 				       const struct expr *e2);
 	void			(*pctx_update)(struct proto_ctx *ctx,
@@ -335,6 +341,9 @@ extern struct expr *expr_clone(const struct expr *expr);
 extern struct expr *expr_get(struct expr *expr);
 extern void expr_free(struct expr *expr);
 extern void expr_print(const struct expr *expr, struct output_ctx *octx);
+#ifdef HAVE_LIBJANSSON
+extern json_t *expr_print_json(const struct expr *expr);
+#endif
 extern bool expr_cmp(const struct expr *e1, const struct expr *e2);
 extern void expr_describe(const struct expr *expr, struct output_ctx *octx);
 
diff --git a/include/nftables.h b/include/nftables.h
index f22df0d1ddc15..f8fb7b38f37ac 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -12,6 +12,9 @@ struct output_ctx {
 	unsigned int ip2name;
 	unsigned int handle;
 	unsigned int echo;
+#ifdef HAVE_LIBJANSSON
+	unsigned int json;
+#endif
 	FILE *output_fp;
 };
 
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 8e59f2b2a59ab..5f53b932802b3 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -55,6 +55,8 @@ bool nft_ctx_output_get_handle(struct nft_ctx *ctx);
 void nft_ctx_output_set_handle(struct nft_ctx *ctx, bool val);
 bool nft_ctx_output_get_echo(struct nft_ctx *ctx);
 void nft_ctx_output_set_echo(struct nft_ctx *ctx, bool val);
+bool nft_ctx_output_get_json(struct nft_ctx *ctx);
+void nft_ctx_output_set_json(struct nft_ctx *ctx, bool val);
 
 FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
 int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
diff --git a/include/statement.h b/include/statement.h
index 23a551b67f2b9..17d7b65151c20 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -256,6 +256,10 @@ enum stmt_types {
 	STMT_EXTHDR,
 };
 
+#ifdef HAVE_LIBJANSSON
+#include <jansson.h>
+#endif
+
 /**
  * struct stmt_ops
  *
@@ -271,6 +275,9 @@ struct stmt_ops {
 	void			(*destroy)(struct stmt *stmt);
 	void			(*print)(const struct stmt *stmt,
 					 struct output_ctx *octx);
+#ifdef HAVE_LIBJANSSON
+	json_t *		(*json)(const struct stmt *stmt);
+#endif
 };
 
 enum stmt_flags {
diff --git a/src/Makefile.am b/src/Makefile.am
index 7fa72a8ea5bc2..42bb49ca04941 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -87,4 +87,8 @@ if BUILD_CLI
 nft_SOURCES += cli.c
 endif
 
+if BUILD_JSON
+libnftables_la_LIBADD += ${JANSSON_LIBS}
+endif
+
 nft_LDADD = libnftables.la
diff --git a/src/datatype.c b/src/datatype.c
index 93726cafc98a1..655bbab8e9d10 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -94,6 +94,23 @@ const struct datatype *datatype_lookup_byname(const char *name)
 	return NULL;
 }
 
+#ifdef HAVE_LIBJANSSON
+json_t *datatype_json(const struct expr *expr)
+{
+	const struct datatype *dtype = expr->dtype;
+
+	do {
+		if (dtype->json != NULL)
+			return dtype->json(expr);
+		if (dtype->sym_tbl != NULL)
+			return symbolic_constant_json(dtype->sym_tbl, expr);
+	} while ((dtype = dtype->basetype));
+
+	BUG("datatype %s has no print method or symbol table\n",
+	    expr->dtype->name);
+}
+#endif
+
 void datatype_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct datatype *dtype = expr->dtype;
@@ -170,6 +187,22 @@ out:
 	return NULL;
 }
 
+#ifdef HAVE_LIBJANSSON
+json_t *symbolic_constant_json(const struct symbol_table *tbl,
+			       const struct expr *expr)
+{
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
+	uint64_t val = 0;
+
+	/* Export the data in the correct byteorder for comparison */
+	assert(expr->len / BITS_PER_BYTE <= sizeof(val));
+	mpz_export_data(constant_data_ptr(val, expr->len), expr->value,
+			expr->byteorder, len);
+
+	return json_pack("{sssi}", "type", "immediate", "val", val);
+}
+#endif
+
 void symbolic_constant_print(const struct symbol_table *tbl,
 			     const struct expr *expr, bool quotes,
 			     struct output_ctx *octx)
@@ -317,6 +350,19 @@ const struct datatype bitmask_type = {
 	.basetype	= &integer_type,
 };
 
+#ifdef HAVE_LIBJANSSON
+static json_t *integer_type_json(const struct expr *expr)
+{
+	json_t *root = json_object();
+
+	json_object_set_new(root, "type", json_pack("s", "immediate"));
+	json_object_set_new(root, "val",
+			json_pack("i", mpz_get_ui(expr->value)));
+
+	return root;
+}
+#endif
+
 static void integer_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct datatype *dtype = expr->dtype;
@@ -356,9 +402,29 @@ const struct datatype integer_type = {
 	.name		= "integer",
 	.desc		= "integer",
 	.print		= integer_type_print,
+#ifdef HAVE_LIBJANSSON
+	.json		= integer_type_json,
+#endif
 	.parse		= integer_type_parse,
 };
 
+#ifdef HAVE_LIBJANSSON
+static json_t *string_type_json(const struct expr *expr)
+{
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
+	json_t *root = json_object();
+	char data[len+1];
+
+	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	data[len] = '\0';
+
+	json_object_set_new(root, "type", json_pack("s", "immediate"));
+	json_object_set_new(root, "val", json_pack("s", data));
+
+	return root;
+}
+#endif
+
 static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
@@ -385,6 +451,9 @@ const struct datatype string_type = {
 	.desc		= "string",
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.print		= string_type_print,
+#ifdef HAVE_LIBJANSSON
+	.json		= string_type_json,
+#endif
 	.parse		= string_type_parse,
 };
 
@@ -657,6 +726,9 @@ const struct datatype inet_service_type = {
 	.size		= 2 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
 	.print		= inet_service_type_print,
+#ifdef HAVE_LIBJANSSON
+	.json		= integer_type_json,
+#endif
 	.parse		= inet_service_type_parse,
 	.sym_tbl	= &inet_service_tbl,
 };
diff --git a/src/expression.c b/src/expression.c
index 393c1b2b2cfeb..ced9f18f9e0c9 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -75,6 +75,23 @@ void expr_print(const struct expr *expr, struct output_ctx *octx)
 	expr->ops->print(expr, octx);
 }
 
+#ifdef HAVE_LIBJANSSON
+json_t *expr_print_json(const struct expr *expr)
+{
+	struct output_ctx octx;
+	char buf[1024];
+
+	if (expr->ops->json)
+		return expr->ops->json(expr);
+
+	octx.output_fp = fmemopen(buf, 1024, "w");
+	expr->ops->print(expr, &octx);
+	fclose(octx.output_fp);
+
+	return json_pack("s", buf);
+}
+#endif
+
 bool expr_cmp(const struct expr *e1, const struct expr *e2)
 {
 	assert(e1->flags & EXPR_F_SINGLETON);
@@ -254,6 +271,13 @@ struct expr *symbol_expr_alloc(const struct location *loc,
 	return expr;
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *constant_expr_json(const struct expr *expr)
+{
+	return datatype_json(expr);
+}
+#endif
+
 static void constant_expr_print(const struct expr *expr,
 				 struct output_ctx *octx)
 {
@@ -280,6 +304,9 @@ static const struct expr_ops constant_expr_ops = {
 	.type		= EXPR_VALUE,
 	.name		= "value",
 	.print		= constant_expr_print,
+#ifdef HAVE_LIBJANSSON
+	.json		= constant_expr_json,
+#endif
 	.cmp		= constant_expr_cmp,
 	.clone		= constant_expr_clone,
 	.destroy	= constant_expr_destroy,
@@ -543,6 +570,21 @@ static void binop_expr_print(const struct expr *expr, struct output_ctx *octx)
 	binop_arg_print(expr, expr->right, octx);
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *binop_expr_json(const struct expr *expr)
+{
+	json_t *root = json_object(), *tmp = json_object();
+
+	json_object_set_new(tmp, "left", expr_print_json(expr->left));
+	json_object_set_new(tmp, "op", json_pack("s", expr_op_symbols[expr->op]));
+	json_object_set_new(tmp, "right", expr_print_json(expr->right));
+
+	json_object_set_new(root, "match", tmp);
+
+	return root;
+}
+#endif
+
 static void binop_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->left  = expr_clone(expr->left);
@@ -559,6 +601,9 @@ static const struct expr_ops binop_expr_ops = {
 	.type		= EXPR_BINOP,
 	.name		= "binop",
 	.print		= binop_expr_print,
+#ifdef HAVE_LIBJANSSON
+	.json		= binop_expr_json,
+#endif
 	.clone		= binop_expr_clone,
 	.destroy	= binop_expr_destroy,
 };
@@ -580,6 +625,9 @@ static const struct expr_ops relational_expr_ops = {
 	.type		= EXPR_RELATIONAL,
 	.name		= "relational",
 	.print		= binop_expr_print,
+#ifdef HAVE_LIBJANSSON
+	.json		= binop_expr_json,
+#endif
 	.destroy	= binop_expr_destroy,
 };
 
@@ -613,6 +661,19 @@ void relational_expr_pctx_update(struct proto_ctx *ctx,
 		left->ops->pctx_update(ctx, expr);
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *range_expr_json(const struct expr *expr)
+{
+	json_t *root = json_object();
+
+	json_object_set_new(root, "type", json_pack("s", "range"));
+	json_object_set_new(root, "val_low", expr_print_json(expr->left));
+	json_object_set_new(root, "val_high", expr_print_json(expr->right));
+
+	return root;
+}
+#endif
+
 static void range_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	octx->numeric += NFT_NUMERIC_ALL + 1;
@@ -646,6 +707,9 @@ static const struct expr_ops range_expr_ops = {
 	.type		= EXPR_RANGE,
 	.name		= "range",
 	.print		= range_expr_print,
+#ifdef HAVE_LIBJANSSON
+	.json		= range_expr_json,
+#endif
 	.clone		= range_expr_clone,
 	.destroy	= range_expr_destroy,
 	.set_type	= range_expr_set_type,
diff --git a/src/libnftables.c b/src/libnftables.c
index 8a18bb78f0d92..368862e153376 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -270,6 +270,22 @@ void nft_ctx_output_set_echo(struct nft_ctx *ctx, bool val)
 	ctx->output.echo = val;
 }
 
+bool nft_ctx_output_get_json(struct nft_ctx *ctx)
+{
+#ifdef HAVE_LIBJANSSON
+	return ctx->output.json;
+#else
+	return false;
+#endif
+}
+
+void nft_ctx_output_set_json(struct nft_ctx *ctx, bool val)
+{
+#ifdef HAVE_LIBJANSSON
+	ctx->output.json = val;
+#endif
+}
+
 static const struct input_descriptor indesc_cmdline = {
 	.type	= INDESC_BUFFER,
 	.name	= "<cmdline>",
diff --git a/src/main.c b/src/main.c
index 353b87bc66631..348f1c1e4044e 100644
--- a/src/main.c
+++ b/src/main.c
@@ -31,6 +31,7 @@ enum opt_vals {
 	OPT_FILE		= 'f',
 	OPT_INTERACTIVE		= 'i',
 	OPT_INCLUDEPATH		= 'I',
+	OPT_JSON		= 'j',
 	OPT_NUMERIC		= 'n',
 	OPT_STATELESS		= 's',
 	OPT_IP2NAME		= 'N',
@@ -40,7 +41,7 @@ enum opt_vals {
 	OPT_INVALID		= '?',
 };
 
-#define OPTSTRING	"hvcf:iI:vnsNae"
+#define OPTSTRING	"hvcf:iI:jvnsNae"
 
 static const struct option options[] = {
 	{
@@ -94,6 +95,10 @@ static const struct option options[] = {
 		.name		= "echo",
 		.val		= OPT_ECHO,
 	},
+	{
+		.name		= "json",
+		.val		= OPT_JSON,
+	},
 	{
 		.name		= NULL
 	}
@@ -112,6 +117,7 @@ static void show_help(const char *name)
 "  -f, --file <filename>		Read input from <filename>\n"
 "  -i, --interactive		Read input from interactive CLI\n"
 "\n"
+"  -j, --json			Format output in JSON\n"
 "  -n, --numeric			When specified once, show network addresses numerically (default behaviour).\n"
 "  				Specify twice to also show Internet services (port numbers) numerically.\n"
 "				Specify three times to also show protocols, user IDs, and group IDs numerically.\n"
@@ -255,6 +261,9 @@ int main(int argc, char * const *argv)
 		case OPT_ECHO:
 			nft_ctx_output_set_echo(nft, true);
 			break;
+		case OPT_JSON:
+			nft_ctx_output_set_json(nft, true);
+			break;
 		case OPT_INVALID:
 			exit(EXIT_FAILURE);
 		}
diff --git a/src/meta.c b/src/meta.c
index 687de8cda8c35..ab600a05149c7 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -445,6 +445,19 @@ static bool meta_key_is_qualified(enum nft_meta_keys key)
 	}
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *meta_expr_json(const struct expr *expr)
+{
+	json_t *root = json_object();
+
+	json_object_set_new(root, "type", json_pack("s", "meta"));
+	json_object_set_new(root, "name",
+			json_pack("s", meta_templates[expr->meta.key].token));
+
+	return root;
+}
+#endif
+
 static void meta_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	if (meta_key_is_qualified(expr->meta.key))
@@ -535,6 +548,9 @@ static const struct expr_ops meta_expr_ops = {
 	.type		= EXPR_META,
 	.name		= "meta",
 	.print		= meta_expr_print,
+#ifdef HAVE_LIBJANSSON
+	.json		= meta_expr_json,
+#endif
 	.cmp		= meta_expr_cmp,
 	.clone		= meta_expr_clone,
 	.pctx_update	= meta_expr_pctx_update,
diff --git a/src/payload.c b/src/payload.c
index 60090accbcd8b..2dbc7a95c4cc7 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -38,6 +38,26 @@ bool payload_is_known(const struct expr *expr)
 	       tmpl != &proto_unknown_template;
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *payload_expr_json(const struct expr *expr)
+{
+	const struct proto_hdr_template *tmpl;
+	const struct proto_desc *desc;
+
+	desc = expr->payload.desc;
+	tmpl = expr->payload.tmpl;
+	if (payload_is_known(expr))
+		return json_pack("{ssssss}", "type", "payload",
+				"name", desc->name,
+				"field", tmpl->token);
+	else
+		return json_pack("{sssssisi}", "type", "payload",
+				"base", proto_base_tokens[expr->payload.base],
+				"offset", expr->payload.offset,
+				"len", expr->len);
+}
+#endif
+
 static void payload_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct proto_desc *desc;
@@ -107,6 +127,9 @@ static const struct expr_ops payload_expr_ops = {
 	.type		= EXPR_PAYLOAD,
 	.name		= "payload",
 	.print		= payload_expr_print,
+#ifdef HAVE_LIBJANSSON
+	.json		= payload_expr_json,
+#endif
 	.cmp		= payload_expr_cmp,
 	.clone		= payload_expr_clone,
 	.pctx_update	= payload_expr_pctx_update,
diff --git a/src/rule.c b/src/rule.c
index edd0ff6f322c5..d17d763810193 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -28,6 +28,10 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
 
+#ifdef HAVE_LIBJANSSON
+#include <jansson.h>
+#endif
+
 void handle_free(struct handle *h)
 {
 	xfree(h->table);
@@ -357,6 +361,61 @@ static void set_print_declaration(const struct set *set,
 	}
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *set_print_json(const struct set *set)
+{
+	json_t *root = json_object(), *tmp;
+	const char *type, *datatype_ext = NULL;
+
+	if (set->flags & NFT_SET_MAP) {
+		type = "map";
+		datatype_ext = set->datatype->name;
+	} else if (set->flags & NFT_SET_OBJECT) {
+		type = "map";
+		datatype_ext = obj_type_name(set->objtype);
+	} else if (set->flags & NFT_SET_EVAL) {
+		type = "meter";
+	} else {
+		type = "set";
+	}
+
+	json_object_set_new(root, "type", json_pack("s", type));
+	json_object_set_new(root, "name", json_pack("s", set->handle.set));
+	if (datatype_ext)
+		json_object_set_new(root, "datatype", json_pack("s++", set->key->dtype->name, " : ", datatype_ext));
+	else
+		json_object_set_new(root, "datatype", json_pack("s", set->key->dtype->name));
+
+	if (!(set->flags & (NFT_SET_CONSTANT))) {
+		json_object_set_new(root, "policy",
+				json_pack("s", set_policy2str(set->policy)));
+
+		json_object_set_new(root, "size",
+				json_pack("i", set->desc.size));
+	}
+
+	tmp = json_array();
+	if (set->flags & NFT_SET_CONSTANT)
+		json_array_append_new(tmp, json_pack("s", "constant"));
+	if (set->flags & NFT_SET_INTERVAL)
+		json_array_append_new(tmp, json_pack("s", "interval"));
+	if (set->flags & NFT_SET_TIMEOUT)
+		json_array_append_new(tmp, json_pack("s", "timeout"));
+
+	if (json_array_size(tmp))
+		json_object_set_new(root, "flags", tmp);
+	else
+		json_decref(tmp);
+
+	if (set->timeout)
+		json_object_set_new(root, "timeout", json_pack("i", set->timeout));
+	if (set->gc_int)
+		json_object_set_new(root, "gc-interval", json_pack("i", set->gc_int));
+
+	return root;
+}
+#endif
+
 static void do_set_print(const struct set *set, struct print_fmt_options *opts,
 			  struct output_ctx *octx)
 {
@@ -425,6 +484,46 @@ void rule_free(struct rule *rule)
 	xfree(rule);
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *stmt_json_default(const struct stmt *stmt)
+{
+	struct output_ctx octx;
+	char buf[1024];
+
+	octx.output_fp = fmemopen(buf, 1024, "w");
+	stmt->ops->print(stmt, &octx);
+	fclose(octx.output_fp);
+
+	return json_pack("s", buf);
+}
+
+static json_t *rule_print_json(const struct rule *rule)
+{
+	json_t *root = json_object(), *tmp;
+	const struct stmt *stmt;
+
+	json_object_set_new(root, "handle", json_pack("i", rule->handle.handle.id));
+	if (rule->comment)
+		json_object_set_new(root, "comment", json_pack("s", rule->comment));
+
+	tmp = json_array();
+	list_for_each_entry(stmt, &rule->stmts, list) {
+		json_t *stmt_json;
+
+		if (stmt->ops->json)
+			stmt_json = stmt->ops->json(stmt);
+		else
+			stmt_json = stmt_json_default(stmt);
+
+		json_array_append_new(tmp, stmt_json);
+	}
+	if (json_array_size(tmp))
+		json_object_set_new(root, "statements", tmp);
+
+	return root;
+}
+#endif
+
 void rule_print(const struct rule *rule, struct output_ctx *octx)
 {
 	const struct stmt *stmt;
@@ -683,6 +782,34 @@ static void chain_print_declaration(const struct chain *chain,
 	}
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *chain_print_json(const struct chain *chain)
+{
+	json_t *root = json_object(), *tmp;
+	struct rule *rule;
+
+	json_object_set_new(root, "name", json_pack("s", chain->handle.chain));
+
+	if (chain->flags & CHAIN_F_BASECHAIN) {
+		json_object_set_new(root, "type", json_pack("s", chain->type));
+		json_object_set_new(root, "hook", json_pack("s", hooknum2str(chain->handle.family, chain->hooknum)));
+		if (chain->dev)
+			json_object_set_new(root, "device", json_pack("s", chain->dev));
+		json_object_set_new(root, "priority", json_pack("d", chain->priority));
+		json_object_set_new(root, "policy", json_pack("s", chain_policy2str(chain->policy)));
+	}
+
+	tmp = json_array();
+	list_for_each_entry(rule, &chain->rules, list) {
+		json_array_append_new(tmp, rule_print_json(rule));
+	}
+	if (json_array_size(tmp))
+		json_object_set_new(root, "rules", tmp);
+
+	return root;
+}
+#endif
+
 static void chain_print(const struct chain *chain, struct output_ctx *octx)
 {
 	struct rule *rule;
@@ -771,6 +898,26 @@ const char *table_flags_name[TABLE_FLAGS_MAX] = {
 	"dormant",
 };
 
+#ifdef HAVE_LIBJANSSON
+static json_t *table_print_options_json(const struct table *table)
+{
+	uint32_t flags = table->flags;
+	int i;
+
+	if (flags) {
+		json_t *root = json_array();
+
+		for (i = 0; i < TABLE_FLAGS_MAX; i++) {
+			if (flags & 0x1)
+				json_array_append_new(root, json_pack("s", table_flags_name[i]));
+			flags >>= 1;
+		}
+		return root;
+	}
+	return NULL;
+}
+#endif
+
 static void table_print_options(const struct table *table, const char **delim,
 				struct output_ctx *octx)
 {
@@ -792,6 +939,51 @@ static void table_print_options(const struct table *table, const char **delim,
 	}
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *obj_print_data_json(const struct obj *obj);
+
+static json_t *table_print_json(const struct table *table)
+{
+	struct chain *chain;
+	struct obj *obj;
+	struct set *set;
+	const char *family = family2str(table->handle.family);
+	json_t *root = json_object(), *tmp;
+
+	json_object_set_new(root, "family", json_pack("s", family));
+	json_object_set_new(root, "name", json_pack("s", table->handle.table));
+
+	tmp = table_print_options_json(table);
+	if (tmp)
+		json_object_set_new(root, "flags", tmp);
+
+	tmp = json_array();
+	list_for_each_entry(obj, &table->objs, list) {
+		json_array_append_new(tmp, obj_print_data_json(obj));
+	}
+	if (json_array_size(tmp)) {
+		json_object_set_new(root, "objects", tmp);
+		tmp = json_array();
+	}
+	list_for_each_entry(set, &table->sets, list) {
+		if (set->flags & NFT_SET_ANONYMOUS)
+			continue;
+		json_array_append_new(tmp, set_print_json(set));
+	}
+	if (json_array_size(tmp)) {
+		json_object_set_new(root, "sets", tmp);
+		tmp = json_array();
+	}
+	list_for_each_entry(chain, &table->chains, list) {
+		json_array_append_new(tmp, chain_print_json(chain));
+	}
+	if (json_array_size(tmp))
+		json_object_set_new(root, "chains", tmp);
+
+	return root;
+}
+#endif
+
 static void table_print(const struct table *table, struct output_ctx *octx)
 {
 	struct chain *chain;
@@ -1168,6 +1360,14 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *do_list_table_json(struct netlink_ctx *ctx, struct cmd *cmd,
+			 struct table *table)
+{
+	return table_print_json(table);
+}
+#endif
+
 static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 			 struct table *table)
 {
@@ -1268,6 +1468,14 @@ static void print_proto_name_proto(uint8_t l4, struct output_ctx *octx)
 		nft_print(octx, "%d\n", l4);
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *obj_print_data_json(const struct obj *obj)
+{
+	/* XXX */
+	return NULL;
+}
+#endif
+
 static void obj_print_data(const struct obj *obj,
 			   struct print_fmt_options *opts,
 			   struct output_ctx *octx)
@@ -1455,6 +1663,33 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 	return 0;
 }
 
+#ifdef HAVE_LIBJANSSON
+static int do_list_ruleset_json(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	unsigned int family = cmd->handle.family;
+	json_t *root = json_array();
+	struct table *table;
+
+	list_for_each_entry(table, &ctx->cache->list, list) {
+		if (family != NFPROTO_UNSPEC &&
+		    table->handle.family != family)
+			continue;
+
+		cmd->handle.family = table->handle.family;
+		cmd->handle.table = table->handle.table;
+
+		json_array_append_new(root, do_list_table_json(ctx, cmd, table));
+	}
+
+	cmd->handle.table = NULL;
+
+	json_dumpf(root, ctx->octx->output_fp, 0);
+	json_array_clear(root);
+
+	return 0;
+}
+#endif
+
 static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	unsigned int family = cmd->handle.family;
@@ -1581,7 +1816,12 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 		return do_list_set(ctx, cmd, table);
 	case CMD_OBJ_RULESET:
-		return do_list_ruleset(ctx, cmd);
+#ifdef HAVE_LIBJANSSON
+		if (ctx->octx->json)
+			return do_list_ruleset_json(ctx, cmd);
+		else
+#endif
+			return do_list_ruleset(ctx, cmd);
 	case CMD_OBJ_METERS:
 		return do_list_sets(ctx, cmd);
 	case CMD_OBJ_METER:
diff --git a/src/statement.c b/src/statement.c
index 1f93260bd3d5f..fc606ccc45664 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -70,6 +70,13 @@ static void expr_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	expr_print(stmt->expr, octx);
 }
 
+#ifdef HAVE_LIBJANSSON
+static json_t *expr_stmt_json(const struct stmt *stmt)
+{
+	return expr_print_json(stmt->expr);
+}
+#endif
+
 static void expr_stmt_destroy(struct stmt *stmt)
 {
 	expr_free(stmt->expr);
@@ -79,6 +86,9 @@ static const struct stmt_ops expr_stmt_ops = {
 	.type		= STMT_EXPRESSION,
 	.name		= "expression",
 	.print		= expr_stmt_print,
+#ifdef HAVE_LIBJANSSON
+	.json		= expr_stmt_json,
+#endif
 	.destroy	= expr_stmt_destroy,
 };
 
-- 
2.15.1

