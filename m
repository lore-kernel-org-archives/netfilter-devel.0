From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 6/7] libnftables: Provide an API for include path handling
Date: Thu, 19 Oct 2017 10:18:46 +0200
Message-ID: <20171019081847.16171-7-phil@nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49424 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752277AbdJSITQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 04:19:16 -0400
In-Reply-To: <20171019081847.16171-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In order to keep the API simple, remove INCLUDE_PATHS_MAX restraint and
dynamically allocate nft_ctx field include_paths instead.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nftables/nftables.h |  6 +++---
 src/libnftables.c           | 34 ++++++++++++++++++++++++++++++++--
 src/main.c                  |  9 ++++-----
 src/scanner.l               |  4 +---
 4 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index f0c9bbf3ba3fe..a752f20d74132 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -17,8 +17,6 @@ struct nft_cache {
 	uint32_t		seqnum;
 };
 
-#define INCLUDE_PATHS_MAX	16
-
 struct output_ctx {
 	unsigned int numeric;
 	unsigned int stateless;
@@ -30,7 +28,7 @@ struct output_ctx {
 
 struct nft_ctx {
 	struct mnl_socket	*nf_sock;
-	const char		*include_paths[INCLUDE_PATHS_MAX];
+	char			**include_paths;
 	unsigned int		num_include_paths;
 	unsigned int		parser_max_errors;
 	unsigned int		debug_mask;
@@ -78,6 +76,8 @@ void nft_ctx_free(struct nft_ctx *ctx);
 
 FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
 void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
+int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
+void nft_ctx_clear_include_paths(struct nft_ctx *ctx);
 
 void nft_ctx_flush_cache(struct nft_ctx *ctx);
 
diff --git a/src/libnftables.c b/src/libnftables.c
index 817f537e32618..2f4275c9a0a94 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -6,10 +6,13 @@
  * published by the Free Software Foundation.
  *
  */
+#define _GNU_SOURCE
 #include <erec.h>
 #include <errno.h>
 #include <mnl.h>
 #include <parser.h>
+#include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 #include <utils.h>
 #include <iface.h>
@@ -122,6 +125,33 @@ static void nft_exit(void)
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
@@ -134,8 +164,7 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	nft_init();
 	ctx = xzalloc(sizeof(struct nft_ctx));
 
-	ctx->include_paths[0]	= DEFAULT_INCLUDE_PATH;
-	ctx->num_include_paths	= 1;
+	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
 	ctx->parser_max_errors	= 10;
 	init_list_head(&ctx->cache.list);
 	ctx->flags = flags;
@@ -158,6 +187,7 @@ void nft_ctx_free(struct nft_ctx *ctx)
 		netlink_close_sock(ctx->nf_sock);
 
 	nft_ctx_flush_cache(ctx);
+	nft_ctx_clear_include_paths(ctx);
 	xfree(ctx);
 	nft_exit();
 }
diff --git a/src/main.c b/src/main.c
index 8359367b78654..de5c115757f44 100644
--- a/src/main.c
+++ b/src/main.c
@@ -196,13 +196,12 @@ int main(int argc, char * const *argv)
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
 			if (++nft->output.numeric > NUMERIC_ALL) {
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

