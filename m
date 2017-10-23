From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 4/4] libnftables: Introduce getters and setters for everything
Date: Mon, 23 Oct 2017 17:33:19 +0200
Message-ID: <20171023153319.13415-5-phil@nwl.cc>
References: <20171023153319.13415-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60852 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932102AbdJWPdq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2017 11:33:46 -0400
In-Reply-To: <20171023153319.13415-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This introduces getter/setter pairs for all parts in struct nft_ctx (and
contained structs) which should be configurable.

Most of them are simple ones, just allowing to get/set a given field:

* nft_ctx_{get,set}_dry_run() -> ctx->check
* nft_ctx_output_{get,set}_numeric()	-> ctx->output.numeric
* nft_ctx_output_{get,set}_stateless()	-> ctx->output.stateless
* nft_ctx_output_{get,set}_ip2name()	-> ctx->output.ip2name
* nft_ctx_output_{get,set}_debug()	-> ctx->debug_mask
* nft_ctx_output_{get,set}_handle()	-> ctx->output.handle
* nft_ctx_output_{get,set}_echo()	-> ctx->output.echo

A more complicated case is include paths handling: In order to keep the
API simple, remove INCLUDE_PATHS_MAX restraint and dynamically allocate
nft_ctx field include_paths instead. So there is:

* nft_ctx_add_include_path()	-> add an include path to the list
* nft_ctx_clear_include_paths()	-> flush the list of include paths

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nftables.h          |   4 +-
 include/nftables/nftables.h |  19 +++++++++
 src/libnftables.c           | 101 +++++++++++++++++++++++++++++++++++++++++++-
 src/main.c                  |  30 +++++++------
 src/scanner.l               |   4 +-
 5 files changed, 137 insertions(+), 21 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 98d619a3ab8d2..97a0436693cfa 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -6,8 +6,6 @@
 #include <utils.h>
 #include <nftables/nftables.h>
 
-#define INCLUDE_PATHS_MAX	16
-
 struct output_ctx {
 	unsigned int numeric;
 	unsigned int stateless;
@@ -27,7 +25,7 @@ struct mnl_socket;
 
 struct nft_ctx {
 	struct mnl_socket	*nf_sock;
-	const char		*include_paths[INCLUDE_PATHS_MAX];
+	char			**include_paths;
 	unsigned int		num_include_paths;
 	unsigned int		parser_max_errors;
 	unsigned int		debug_mask;
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 1207f10cd2457..2dff281183b3c 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -50,7 +50,26 @@ enum nftables_exit_codes {
 
 struct nft_ctx *nft_ctx_new(uint32_t flags);
 void nft_ctx_free(struct nft_ctx *ctx);
+
+bool nft_ctx_get_dry_run(struct nft_ctx *ctx);
+void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
+enum numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx);
+void nft_ctx_output_set_numeric(struct nft_ctx *ctx, enum numeric_level level);
+bool nft_ctx_output_get_stateless(struct nft_ctx *ctx);
+void nft_ctx_output_set_stateless(struct nft_ctx *ctx, bool val);
+bool nft_ctx_output_get_ip2name(struct nft_ctx *ctx);
+void nft_ctx_output_set_ip2name(struct nft_ctx *ctx, bool val);
+unsigned int nft_ctx_output_get_debug(struct nft_ctx *ctx);
+void nft_ctx_output_set_debug(struct nft_ctx *ctx, unsigned int mask);
+bool nft_ctx_output_get_handle(struct nft_ctx *ctx);
+void nft_ctx_output_set_handle(struct nft_ctx *ctx, bool val);
+bool nft_ctx_output_get_echo(struct nft_ctx *ctx);
+void nft_ctx_output_set_echo(struct nft_ctx *ctx, bool val);
+
 FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
+int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
+void nft_ctx_clear_include_paths(struct nft_ctx *ctx);
+
 void nft_ctx_flush_cache(struct nft_ctx *ctx);
 
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen);
diff --git a/src/libnftables.c b/src/libnftables.c
index 51a87dc34bc60..5e70c197846cf 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -14,6 +14,7 @@
 #include <iface.h>
 
 #include <errno.h>
+#include <stdlib.h>
 #include <string.h>
 
 static int nft_netlink(struct nft_ctx *nft,
@@ -123,6 +124,33 @@ static void nft_exit(void)
 	mark_table_exit();
 }
 
+int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
+{
+	char **tmp;
+	int pcount = ctx->num_include_paths;
+
+	tmp = realloc(ctx->include_paths, (pcount + 1) * sizeof(char *));
+	if (!tmp)
+		return -1;
+
+	ctx->include_paths = tmp;
+
+	if (asprintf(&ctx->include_paths[pcount], "%s", path) < 0)
+		return -1;
+
+	ctx->num_include_paths++;
+	return 0;
+}
+
+void nft_ctx_clear_include_paths(struct nft_ctx *ctx)
+{
+	while (ctx->num_include_paths)
+		xfree(ctx->include_paths[--ctx->num_include_paths]);
+
+	xfree(ctx->include_paths);
+	ctx->include_paths = NULL;
+}
+
 static void nft_ctx_netlink_init(struct nft_ctx *ctx)
 {
 	ctx->nf_sock = netlink_open_sock();
@@ -135,8 +163,7 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	nft_init();
 	ctx = xzalloc(sizeof(struct nft_ctx));
 
-	ctx->include_paths[0]	= DEFAULT_INCLUDE_PATH;
-	ctx->num_include_paths	= 1;
+	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
 	ctx->parser_max_errors	= 10;
 	init_list_head(&ctx->cache.list);
 	ctx->flags = flags;
@@ -159,6 +186,7 @@ void nft_ctx_free(struct nft_ctx *ctx)
 		netlink_close_sock(ctx->nf_sock);
 
 	nft_ctx_flush_cache(ctx);
+	nft_ctx_clear_include_paths(ctx);
 	xfree(ctx);
 	nft_exit();
 }
@@ -172,6 +200,75 @@ FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp)
 	return old;
 }
 
+bool nft_ctx_get_dry_run(struct nft_ctx *ctx)
+{
+	return ctx->check;
+}
+
+void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry)
+{
+	ctx->check = dry;
+}
+
+enum numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx)
+{
+	return ctx->output.numeric;
+}
+
+void nft_ctx_output_set_numeric(struct nft_ctx *ctx, enum numeric_level level)
+{
+	ctx->output.numeric = level;
+}
+
+bool nft_ctx_output_get_stateless(struct nft_ctx *ctx)
+{
+	return ctx->output.stateless;
+}
+
+void nft_ctx_output_set_stateless(struct nft_ctx *ctx, bool val)
+{
+	ctx->output.stateless = val;
+}
+
+bool nft_ctx_output_get_ip2name(struct nft_ctx *ctx)
+{
+	return ctx->output.ip2name;
+}
+
+void nft_ctx_output_set_ip2name(struct nft_ctx *ctx, bool val)
+{
+	ctx->output.ip2name = val;
+}
+
+unsigned int nft_ctx_output_get_debug(struct nft_ctx *ctx)
+{
+	return ctx->debug_mask;
+}
+void nft_ctx_output_set_debug(struct nft_ctx *ctx, unsigned int mask)
+{
+	ctx->debug_mask = mask;
+}
+
+bool nft_ctx_output_get_handle(struct nft_ctx *ctx)
+{
+	return ctx->output.handle;
+}
+
+void nft_ctx_output_set_handle(struct nft_ctx *ctx, bool val)
+{
+	ctx->output.handle = val;
+}
+
+bool nft_ctx_output_get_echo(struct nft_ctx *ctx)
+{
+	return ctx->output.echo;
+}
+
+void nft_ctx_output_set_echo(struct nft_ctx *ctx, bool val)
+{
+	ctx->output.echo = val;
+}
+
 static const struct input_descriptor indesc_cmdline = {
 	.type	= INDESC_BUFFER,
 	.name	= "<cmdline>",
diff --git a/src/main.c b/src/main.c
index a28564172e9a0..59c39d4570b02 100644
--- a/src/main.c
+++ b/src/main.c
@@ -20,7 +20,6 @@
 
 #include <nftables/nftables.h>
 #include <utils.h>
-#include <nftables.h>
 #include <cli.h>
 
 static struct nft_ctx *nft;
@@ -170,6 +169,8 @@ int main(int argc, char * const *argv)
 	unsigned int len;
 	bool interactive = false;
 	int i, val, rc;
+	enum numeric_level numeric;
+	unsigned int debug_mask;
 
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
 	nft_ctx_set_output(nft, stdout);
@@ -188,7 +189,7 @@ int main(int argc, char * const *argv)
 			       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME);
 			exit(NFT_EXIT_SUCCESS);
 		case OPT_CHECK:
-			nft->check = true;
+			nft_ctx_set_dry_run(nft, true);
 			break;
 		case OPT_FILE:
 			filename = optarg;
@@ -197,29 +198,31 @@ int main(int argc, char * const *argv)
 			interactive = true;
 			break;
 		case OPT_INCLUDEPATH:
-			if (nft->num_include_paths >= INCLUDE_PATHS_MAX) {
-				fprintf(stderr, "Too many include paths "
-						"specified, max. %u\n",
-					INCLUDE_PATHS_MAX - 1);
+			if (nft_ctx_add_include_path(nft, optarg)) {
+				fprintf(stderr,
+					"Failed to add include path '%s'\n",
+					optarg);
 				exit(NFT_EXIT_FAILURE);
 			}
-			nft->include_paths[nft->num_include_paths++] = optarg;
 			break;
 		case OPT_NUMERIC:
-			if (++nft->output.numeric > NUMERIC_ALL) {
+			numeric = nft_ctx_output_get_numeric(nft);
+			if (numeric == NUMERIC_ALL) {
 				fprintf(stderr, "Too many numeric options "
 						"used, max. %u\n",
 					NUMERIC_ALL);
 				exit(NFT_EXIT_FAILURE);
 			}
+			nft_ctx_output_set_numeric(nft, numeric + 1);
 			break;
 		case OPT_STATELESS:
-			nft->output.stateless++;
+			nft_ctx_output_set_stateless(nft, true);
 			break;
 		case OPT_IP2NAME:
-			nft->output.ip2name++;
+			nft_ctx_output_set_ip2name(nft, true);
 			break;
 		case OPT_DEBUG:
+			debug_mask = nft_ctx_output_get_debug(nft);
 			for (;;) {
 				unsigned int i;
 				char *end;
@@ -231,7 +234,7 @@ int main(int argc, char * const *argv)
 				for (i = 0; i < array_size(debug_param); i++) {
 					if (strcmp(debug_param[i].name, optarg))
 						continue;
-					nft->debug_mask |= debug_param[i].level;
+					debug_mask |= debug_param[i].level;
 					break;
 				}
 
@@ -245,12 +248,13 @@ int main(int argc, char * const *argv)
 					break;
 				optarg = end + 1;
 			}
+			nft_ctx_output_set_debug(nft, debug_mask);
 			break;
 		case OPT_HANDLE_OUTPUT:
-			nft->output.handle++;
+			nft_ctx_output_set_handle(nft, true);
 			break;
 		case OPT_ECHO:
-			nft->output.echo++;
+			nft_ctx_output_set_echo(nft, true);
 			break;
 		case OPT_INVALID:
 			exit(NFT_EXIT_FAILURE);
diff --git a/src/scanner.l b/src/scanner.l
index 594073660c6b1..ee09775ebf1d9 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -794,9 +794,7 @@ int scanner_include_file(struct nft_ctx *nft, void *scanner,
 	int ret = -1;
 
 	if (search_in_include_path(filename)) {
-		for (i = 0; i < INCLUDE_PATHS_MAX; i++) {
-			if (nft->include_paths[i] == NULL)
-				break;
+		for (i = 0; i < nft->num_include_paths; i++) {
 			ret = snprintf(buf, sizeof(buf), "%s/%s",
 				       nft->include_paths[i], filename);
 			if (ret < 0 || ret >= PATH_MAX) {
-- 
2.13.1

