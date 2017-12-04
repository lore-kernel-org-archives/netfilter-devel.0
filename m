From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] src: Add option '-D' to define variables from command-line
Date: Mon,  4 Dec 2017 16:22:59 +0530
Message-ID: <20171204105259.28070-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:45915 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751205AbdLDKxX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Dec 2017 05:53:23 -0500
Received: by mail-pg0-f68.google.com with SMTP id m25so7911547pgv.12
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Dec 2017 02:53:23 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds option '-D' with optarg in form test="foo" to define
variable to be referenced from input file.

For eg.
nft -D test="foo" -f /tmp/test1

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
This patch passes identifier and its value as nft_ctx struct members
and binds variable with symbol_bind and when symbol_lookup is called
while parsing, then comparison returns true, but this patch causes 
segmentation fault.

 include/nftables.h          |  6 ++++++
 include/nftables/nftables.h |  2 ++
 include/parser.h            |  3 ++-
 src/libnftables.c           | 11 +++++++++--
 src/main.c                  | 18 +++++++++++++++++-
 src/parser_bison.y          |  7 ++++++-
 6 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 3bfa33e..50b8102 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -21,6 +21,11 @@ struct nft_cache {
 	uint32_t		seqnum;
 };
 
+struct nft_variable {
+	const char 		*identifier;
+	const char 		*expr_value;
+};
+
 struct mnl_socket;
 
 struct nft_ctx {
@@ -32,6 +37,7 @@ struct nft_ctx {
 	struct output_ctx	output;
 	bool			check;
 	struct nft_cache	cache;
+	struct nft_variable	variable;
 	uint32_t		flags;
 };
 
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 8e59f2b..a06a202 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -55,6 +55,8 @@ bool nft_ctx_output_get_handle(struct nft_ctx *ctx);
 void nft_ctx_output_set_handle(struct nft_ctx *ctx, bool val);
 bool nft_ctx_output_get_echo(struct nft_ctx *ctx);
 void nft_ctx_output_set_echo(struct nft_ctx *ctx, bool val);
+void nft_ctx_output_set_variable(struct nft_ctx *ctx, char *identifier,
+				 char *expr_value);
 
 FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
 int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
diff --git a/include/parser.h b/include/parser.h
index 0bdb3fa..46981fe 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -33,7 +33,8 @@ struct mnl_socket;
 
 extern void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 			struct parser_state *state, struct list_head *msgs,
-			unsigned int debug_level, struct output_ctx *octx);
+			unsigned int debug_level, struct output_ctx *octx,
+			struct nft_variable *variable);
 extern int nft_parse(struct nft_ctx *ctx, void *, struct parser_state *state);
 
 extern void *scanner_init(struct parser_state *state);
diff --git a/src/libnftables.c b/src/libnftables.c
index c86d894..b34cea3 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -269,6 +269,13 @@ void nft_ctx_output_set_echo(struct nft_ctx *ctx, bool val)
 	ctx->output.echo = val;
 }
 
+void nft_ctx_output_set_variable(struct nft_ctx *ctx, char *identifier,
+				 char *expr_value)
+{
+	ctx->variable.identifier = identifier;
+	ctx->variable.expr_value = expr_value;
+}
+
 static const struct input_descriptor indesc_cmdline = {
 	.type	= INDESC_BUFFER,
 	.name	= "<cmdline>",
@@ -283,7 +290,7 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen)
 	FILE *fp;
 
 	parser_init(nft->nf_sock, &nft->cache, &state,
-		    &msgs, nft->debug_mask, &nft->output);
+		    &msgs, nft->debug_mask, &nft->output, &nft->variable);
 	scanner = scanner_init(&state);
 	scanner_push_buffer(scanner, &indesc_cmdline, buf);
 
@@ -313,7 +320,7 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 		return -1;
 
 	parser_init(nft->nf_sock, &nft->cache, &state,
-		    &msgs, nft->debug_mask, &nft->output);
+		    &msgs, nft->debug_mask, &nft->output, &nft->variable);
 	scanner = scanner_init(&state);
 	if (scanner_read_file(scanner, filename, &internal_location) < 0) {
 		rc = -1;
diff --git a/src/main.c b/src/main.c
index 353b87b..d9402cf 100644
--- a/src/main.c
+++ b/src/main.c
@@ -37,10 +37,11 @@ enum opt_vals {
 	OPT_DEBUG		= 'd',
 	OPT_HANDLE_OUTPUT	= 'a',
 	OPT_ECHO		= 'e',
+	OPT_VARIABLE		= 'D',
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
+		.name		= "variable",
+		.val		= OPT_VARIABLE,
+		.has_arg	= 1,
+	},
+	{
 		.name		= NULL
 	}
 };
@@ -119,6 +125,7 @@ static void show_help(const char *name)
 "  -N				Translate IP addresses to names.\n"
 "  -a, --handle			Output rule handle.\n"
 "  -e, --echo			Echo what has been added, inserted or replaced.\n"
+"  -D, --define 		Define variable names from command line for using in nft input file.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files. Default is: %s\n"
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
 "\n",
@@ -166,6 +173,7 @@ static const struct {
 int main(int argc, char * const *argv)
 {
 	char *buf = NULL, *filename = NULL;
+	char *identifier = NULL, *expr_value = NULL;
 	enum nft_numeric_level numeric;
 	bool interactive = false;
 	unsigned int debug_mask;
@@ -255,6 +263,14 @@ int main(int argc, char * const *argv)
 		case OPT_ECHO:
 			nft_ctx_output_set_echo(nft, true);
 			break;
+		case OPT_VARIABLE:
+			{
+				const char *search = "=";
+				identifier = strtok(optarg, search);
+				expr_value = strtok(NULL, search);
+				nft_ctx_output_set_variable(nft, identifier, expr_value);
+				break;
+			}
 		case OPT_INVALID:
 			exit(EXIT_FAILURE);
 		}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6e85a62..f382add 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -37,7 +37,8 @@
 
 void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 		 struct parser_state *state, struct list_head *msgs,
-		 unsigned int debug_mask, struct output_ctx *octx)
+		 unsigned int debug_mask, struct output_ctx *octx,
+		 struct nft_variable *variable)
 {
 	memset(state, 0, sizeof(*state));
 	init_list_head(&state->cmds);
@@ -49,6 +50,10 @@ void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 	state->ectx.nf_sock = nf_sock;
 	state->ectx.debug_mask = debug_mask;
 	state->ectx.octx = octx;
+	if (variable->identifier != NULL) {
+		struct expr *expr = (struct expr *) variable->expr_value;
+		symbol_bind(state->scopes[state->scope], variable->identifier, expr);
+	}
 }
 
 static void yyerror(struct location *loc, struct nft_ctx *nft, void *scanner,
-- 
2.11.0

