From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/6] src: add include_paths to struct nft_ctx
Date: Tue, 22 Aug 2017 19:05:06 +0200
Message-ID: <1503421511-17814-2-git-send-email-pablo@netfilter.org>
References: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40942 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751496AbdHVRF2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 13:05:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 75A38D1632
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6374FDA2D2
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:12 +0200 (CEST)
In-Reply-To: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not convenient to keep this as static for the upcoming library, so let's
move it where it belongs.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h |  3 ++-
 include/parser.h   |  5 +++--
 src/main.c         | 17 +++++++++++------
 src/parser_bison.y |  5 +++--
 src/scanner.l      | 10 +++++-----
 5 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 994b5111176c..8399b1ae68f9 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -39,6 +39,8 @@ struct nft_cache {
 };
 
 struct nft_ctx {
+	const char		*include_paths[INCLUDE_PATHS_MAX];
+	unsigned int		num_include_paths;
 	struct output_ctx	output;
 	bool			check;
 	struct nft_cache	cache;
@@ -46,7 +48,6 @@ struct nft_ctx {
 
 extern unsigned int max_errors;
 extern unsigned int debug_level;
-extern const char *include_paths[INCLUDE_PATHS_MAX];
 
 enum nftables_exit_codes {
 	NFT_EXIT_SUCCESS	= 0,
diff --git a/include/parser.h b/include/parser.h
index 5a452f7767aa..df6026824584 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -33,14 +33,15 @@ struct mnl_socket;
 
 extern void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 			struct parser_state *state, struct list_head *msgs);
-extern int nft_parse(void *, struct parser_state *state);
+extern int nft_parse(struct nft_ctx *ctx, void *, struct parser_state *state);
 
 extern void *scanner_init(struct parser_state *state);
 extern void scanner_destroy(struct parser_state *state);
 
 extern int scanner_read_file(void *scanner, const char *filename,
 			     const struct location *loc);
-extern int scanner_include_file(void *scanner, const char *filename,
+extern int scanner_include_file(struct nft_ctx *ctx, void *scanner,
+				const char *filename,
 				const struct location *loc);
 extern void scanner_push_buffer(void *scanner,
 				const struct input_descriptor *indesc,
diff --git a/src/main.c b/src/main.c
index b86ae62f1343..eb0dfb02fd15 100644
--- a/src/main.c
+++ b/src/main.c
@@ -34,9 +34,6 @@ unsigned int max_errors = 10;
 unsigned int debug_level;
 #endif
 
-const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH };
-static unsigned int num_include_paths = 1;
-
 enum opt_vals {
 	OPT_HELP		= 'h',
 	OPT_VERSION		= 'v',
@@ -253,7 +250,7 @@ int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
 	struct cmd *cmd, *next;
 	int ret;
 
-	ret = nft_parse(scanner, state);
+	ret = nft_parse(nft, scanner, state);
 	if (ret != 0 || state->nerrs > 0) {
 		ret = -1;
 		goto err1;
@@ -294,6 +291,12 @@ void nft_exit(void)
 	mark_table_exit();
 }
 
+static void nft_ctx_init(struct nft_ctx *nft)
+{
+	nft->include_paths[0]	= DEFAULT_INCLUDE_PATH;
+	nft->num_include_paths	= 1;
+}
+
 int main(int argc, char * const *argv)
 {
 	struct parser_state state;
@@ -308,6 +311,8 @@ int main(int argc, char * const *argv)
 	init_list_head(&nft.cache.list);
 
 	nft_init();
+	nft_ctx_init(&nft);
+
 	nf_sock = netlink_open_sock();
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
@@ -332,13 +337,13 @@ int main(int argc, char * const *argv)
 			interactive = true;
 			break;
 		case OPT_INCLUDEPATH:
-			if (num_include_paths >= INCLUDE_PATHS_MAX) {
+			if (nft.num_include_paths >= INCLUDE_PATHS_MAX) {
 				fprintf(stderr, "Too many include paths "
 						"specified, max. %u\n",
 					INCLUDE_PATHS_MAX - 1);
 				exit(NFT_EXIT_FAILURE);
 			}
-			include_paths[num_include_paths++] = optarg;
+			nft.include_paths[nft.num_include_paths++] = optarg;
 			break;
 		case OPT_NUMERIC:
 			if (++nft.output.numeric > NUMERIC_ALL) {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 783b72f5a343..18c0f0aa9600 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -48,7 +48,7 @@ void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
 	state->ectx.nf_sock = nf_sock;
 }
 
-static void yyerror(struct location *loc, void *scanner,
+static void yyerror(struct location *loc, struct nft_ctx *nft, void *scanner,
 		    struct parser_state *state, const char *s)
 {
 	erec_queue(error(loc, "%s", s), state->msgs);
@@ -109,6 +109,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %name-prefix "nft_"
 %debug
 %pure-parser
+%parse-param		{ struct nft_ctx *nft }
 %parse-param		{ void *scanner }
 %parse-param		{ struct parser_state *state }
 %lex-param		{ scanner }
@@ -709,7 +710,7 @@ opt_newline		:	NEWLINE
 
 common_block		:	INCLUDE		QUOTED_STRING	stmt_seperator
 			{
-				if (scanner_include_file(scanner, $2, &@$) < 0) {
+				if (scanner_include_file(nft, scanner, $2, &@$) < 0) {
 					xfree($2);
 					YYERROR;
 				}
diff --git a/src/scanner.l b/src/scanner.l
index b6ba32d88f4a..d50e2b671065 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -773,8 +773,8 @@ static bool search_in_include_path(const char *filename)
 		filename[0] != '/');
 }
 
-int scanner_include_file(void *scanner, const char *filename,
-			 const struct location *loc)
+int scanner_include_file(struct nft_ctx *nft, void *scanner,
+			 const char *filename, const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
 	struct error_record *erec;
@@ -784,13 +784,13 @@ int scanner_include_file(void *scanner, const char *filename,
 
 	if (search_in_include_path(filename)) {
 		for (i = 0; i < INCLUDE_PATHS_MAX; i++) {
-			if (include_paths[i] == NULL)
+			if (nft->include_paths[i] == NULL)
 				break;
 			ret = snprintf(buf, sizeof(buf), "%s/%s",
-				       include_paths[i], filename);
+				       nft->include_paths[i], filename);
 			if (ret < 0 || ret >= PATH_MAX) {
 				erec = error(loc, "Too long file path \"%s/%s\"\n",
-					     include_paths[i], filename);
+					     nft->include_paths[i], filename);
 				erec_queue(erec, state->msgs);
 				return -1;
 			}
-- 
2.1.4


