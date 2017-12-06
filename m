From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] src: Add option -D to define variable from command line
Date: Wed,  6 Dec 2017 18:09:08 +0530
Message-ID: <20171206123908.4641-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:40171 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdLFMjg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Dec 2017 07:39:36 -0500
Received: by mail-pf0-f196.google.com with SMTP id v26so2205022pfl.7
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Dec 2017 04:39:36 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch takes argument of '-D' option and pass it to
nft_run_cmd_from_filename and parses the string in scanner_push_file along
with input file.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
I want to parse both input string and input file in scanner_push_file
but unable to do so. Any suggestions are welcome.

 include/nftables/nftables.h |  2 +-
 include/parser.h            |  2 +-
 include/utils.h             |  1 +
 src/libnftables.c           |  4 ++--
 src/main.c                  | 22 ++++++++++++++++++----
 src/parser_bison.y          |  2 +-
 src/rule.c                  |  5 ++++-
 src/scanner.l               | 25 ++++++++++++++++---------
 8 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 8e59f2b..4fa012a 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -61,6 +61,6 @@ int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
 void nft_ctx_clear_include_paths(struct nft_ctx *ctx);
 
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen);
-int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
+int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename, const char *variable);
 
 #endif /* LIB_NFTABLES_H */
diff --git a/include/parser.h b/include/parser.h
index 0bdb3fa..a774b69 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -40,7 +40,7 @@ extern void *scanner_init(struct parser_state *state);
 extern void scanner_destroy(void *scanner);
 
 extern int scanner_read_file(void *scanner, const char *filename,
-			     const struct location *loc);
+			     const char *variable, const struct location *loc);
 extern int scanner_include_file(struct nft_ctx *ctx, void *scanner,
 				const char *filename,
 				const struct location *loc);
diff --git a/include/utils.h b/include/utils.h
index 310389c..6569afe 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -122,6 +122,7 @@ static inline int fls(int x)
 }
 
 extern void __memory_allocation_error(const char *filename, uint32_t line) __noreturn;
+extern void __memory_allocation_error(const char *variable, uint32_t line) __noreturn;
 
 #define memory_allocation_error()		\
 	__memory_allocation_error(__FILE__, __LINE__);
diff --git a/src/libnftables.c b/src/libnftables.c
index c86d894..c0e7d9f 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -299,7 +299,7 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen)
 	return rc;
 }
 
-int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
+int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename, const char *variable)
 {
 	struct parser_state state;
 	LIST_HEAD(msgs);
@@ -315,7 +315,7 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	parser_init(nft->nf_sock, &nft->cache, &state,
 		    &msgs, nft->debug_mask, &nft->output);
 	scanner = scanner_init(&state);
-	if (scanner_read_file(scanner, filename, &internal_location) < 0) {
+	if (scanner_read_file(scanner, filename, variable, &internal_location) < 0) {
 		rc = -1;
 		goto err;
 	}
diff --git a/src/main.c b/src/main.c
index 353b87b..ff7495a 100644
--- a/src/main.c
+++ b/src/main.c
@@ -37,10 +37,11 @@ enum opt_vals {
 	OPT_DEBUG		= 'd',
 	OPT_HANDLE_OUTPUT	= 'a',
 	OPT_ECHO		= 'e',
+	OPT_VARIABLE 		= 'D',
 	OPT_INVALID		= '?',
 };
 
-#define OPTSTRING	"hvcf:iI:vnsNae"
+#define OPTSTRING	"hvcf:iI:vnsNaeD:"
 
 static const struct option options[] = {
 	{
@@ -95,6 +96,11 @@ static const struct option options[] = {
 		.val		= OPT_ECHO,
 	},
 	{
+		.name 		= "variable",
+		.val 		= OPT_VARIABLE,
+		.has_arg 	= 1,
+	},
+	{
 		.name		= NULL
 	}
 };
@@ -119,6 +125,7 @@ static void show_help(const char *name)
 "  -N				Translate IP addresses to names.\n"
 "  -a, --handle			Output rule handle.\n"
 "  -e, --echo			Echo what has been added, inserted or replaced.\n"
+"  -D<variable=value> 		Define variable names from command line for using in nft input file.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files. Default is: %s\n"
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
 "\n",
@@ -165,7 +172,7 @@ static const struct {
 
 int main(int argc, char * const *argv)
 {
-	char *buf = NULL, *filename = NULL;
+	char *buf = NULL, *filename = NULL, *variable = NULL;
 	enum nft_numeric_level numeric;
 	bool interactive = false;
 	unsigned int debug_mask;
@@ -225,6 +232,7 @@ int main(int argc, char * const *argv)
 			for (;;) {
 				unsigned int i;
 				char *end;
+				fprintf(stderr, "This is debug optarg %s\n", optarg);
 
 				end = strchr(optarg, ',');
 				if (end)
@@ -255,6 +263,13 @@ int main(int argc, char * const *argv)
 		case OPT_ECHO:
 			nft_ctx_output_set_echo(nft, true);
 			break;
+		case OPT_VARIABLE:
+			{
+				char variable[120];
+				strcpy(variable, "define ");
+				strcat(variable, optarg);
+				break;
+			}
 		case OPT_INVALID:
 			exit(EXIT_FAILURE);
 		}
@@ -273,7 +288,7 @@ int main(int argc, char * const *argv)
 		strcat(buf, "\n");
 		rc = !!nft_run_cmd_from_buffer(nft, buf, len + 2);
 	} else if (filename != NULL) {
-		rc = !!nft_run_cmd_from_filename(nft, filename);
+		rc = !!nft_run_cmd_from_filename(nft, filename, variable);
 	} else if (interactive) {
 		if (cli_init(nft) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
@@ -285,7 +300,6 @@ int main(int argc, char * const *argv)
 		fprintf(stderr, "%s: no command specified\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
-
 	xfree(buf);
 	nft_ctx_free(nft);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6e85a62..74f051b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -745,7 +745,7 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 				}
 				xfree($2);
 			}
-			|	DEFINE		identifier	'='	initializer_expr	stmt_separator
+			|	DEFINE		identifier	'='	initializer_expr
 			{
 				struct scope *scope = current_scope(state);
 
diff --git a/src/rule.c b/src/rule.c
index cbc40e2..7722467 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -480,6 +480,8 @@ void symbol_bind(struct scope *scope, const char *identifier, struct expr *expr)
 	sym->expr = expr;
 
 	list_add_tail(&sym->list, &scope->symbols);
+	list_for_each_entry(sym, &scope->symbols, list) {
+	}
 }
 
 struct symbol *symbol_lookup(const struct scope *scope, const char *identifier)
@@ -488,8 +490,9 @@ struct symbol *symbol_lookup(const struct scope *scope, const char *identifier)
 
 	while (scope != NULL) {
 		list_for_each_entry(sym, &scope->symbols, list) {
-			if (!strcmp(sym->identifier, identifier))
+			if (!strcmp(sym->identifier, identifier)) {
 				return sym;
+			}
 		}
 		scope = scope->parent;
 	}
diff --git a/src/scanner.l b/src/scanner.l
index 6f19eec..97145ed 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -628,10 +628,10 @@ static void scanner_pop_buffer(yyscan_t scanner)
 }
 
 static struct error_record *scanner_push_file(void *scanner, const char *filename,
-					      FILE *f, const struct location *loc)
+					      FILE *f, const char *variable, const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
-	YY_BUFFER_STATE b;
+	YY_BUFFER_STATE b, temp;
 
 	if (state->indesc_idx == MAX_INCLUDE_DEPTH) {
 		fclose(f);
@@ -639,8 +639,15 @@ static struct error_record *scanner_push_file(void *scanner, const char *filenam
 			     MAX_INCLUDE_DEPTH);
 	}
 
-	b = yy_create_buffer(f, YY_BUF_SIZE, scanner);
-	yypush_buffer_state(b, scanner);
+	if (variable != NULL) {
+		b = yy_scan_string(variable, scanner);
+		temp = yy_create_buffer(f, YY_BUF_SIZE, scanner);
+		yypush_buffer_state(temp, scanner);
+	}
+	else {
+		b = yy_create_buffer(f, YY_BUF_SIZE, scanner);
+		yypush_buffer_state(b, scanner);
+	}
 
 	state->indesc = &state->indescs[state->indesc_idx++];
 	if (loc != NULL)
@@ -653,7 +660,7 @@ static struct error_record *scanner_push_file(void *scanner, const char *filenam
 }
 
 static int include_file(void *scanner, const char *filename,
-			const struct location *loc)
+			const char *variable, const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
 	struct error_record *erec;
@@ -666,7 +673,7 @@ static int include_file(void *scanner, const char *filename,
 		goto err;
 	}
 
-	erec = scanner_push_file(scanner, filename, f, loc);
+	erec = scanner_push_file(scanner, filename, f, variable, loc);
 	if (erec != NULL)
 		goto err;
 	return 0;
@@ -739,7 +746,7 @@ static int include_glob(void *scanner, const char *pattern,
 			if (len == 0 || path[len - 1] == '/')
 				continue;
 
-			ret = include_file(scanner, path, loc);
+			ret = include_file(scanner, path, NULL, loc);
 			if (ret != 0)
 				goto err;
 		}
@@ -774,9 +781,9 @@ err:
 }
 
 int scanner_read_file(void *scanner, const char *filename,
-		      const struct location *loc)
+		      const char *variable, const struct location *loc)
 {
-	return include_file(scanner, filename, loc);
+	return include_file(scanner, filename, variable, loc);
 }
 
 static bool search_in_include_path(const char *filename)
-- 
2.11.0

