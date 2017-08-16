From: Eric Leblond <eric@regit.org>
Subject: [nft PATH 02/16] libnftables: add context new and free
Date: Wed, 16 Aug 2017 22:42:56 +0200
Message-ID: <20170816204310.3371-3-eric@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:40684 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752262AbdHPVZ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 17:25:29 -0400
In-Reply-To: <20170816204310.3371-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/nftables.h          |  1 +
 include/nftables/nftables.h |  3 +++
 src/libnftables.c           | 20 ++++++++++++++++++++
 src/main.c                  | 27 +++++++++++++--------------
 4 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index a457aba..717af37 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -35,6 +35,7 @@ struct output_ctx {
 struct nft_ctx {
 	struct output_ctx	output;
 	bool			check;
+	struct mnl_socket	*nf_sock;
 };
 
 struct nft_cache {
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 4ba16f0..cfa60fe 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -17,4 +17,7 @@
 void nft_global_init(void);
 void nft_global_deinit(void);
 
+struct nft_ctx *nft_context_new(void);
+void nft_context_free(struct nft_ctx *nft);
+
 #endif
diff --git a/src/libnftables.c b/src/libnftables.c
index 215179a..da1b231 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -51,3 +51,23 @@ void nft_global_deinit(void)
 	realm_table_meta_exit();
 	mark_table_exit();
 }
+
+struct nft_ctx *nft_context_new(void)
+{
+	struct nft_ctx *ctx = NULL;
+	ctx = malloc(sizeof(struct nft_ctx));
+	if (ctx == NULL)
+		return NULL;
+	ctx->nf_sock = netlink_open_sock();
+
+	return ctx;
+}
+
+
+void nft_context_free(struct nft_ctx *nft)
+{
+	if (nft == NULL)
+		return;
+	netlink_close_sock(nft->nf_sock);
+	xfree(nft);
+}
diff --git a/src/main.c b/src/main.c
index dde3104..23af38e 100644
--- a/src/main.c
+++ b/src/main.c
@@ -29,7 +29,6 @@
 #include <iface.h>
 #include <cli.h>
 
-static struct nft_ctx nft;
 unsigned int max_errors = 10;
 #ifdef DEBUG
 unsigned int debug_level;
@@ -283,13 +282,13 @@ int main(int argc, char * const *argv)
 	unsigned int len;
 	bool interactive = false;
 	int i, val, rc = NFT_EXIT_SUCCESS;
-	struct mnl_socket *nf_sock;
+	struct nft_ctx *nft;
 
 	memset(&cache, 0, sizeof(cache));
 	init_list_head(&cache.list);
 
 	nft_global_init();
-	nf_sock = netlink_open_sock();
+	nft = nft_context_new();
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
 		if (val == -1)
@@ -304,7 +303,7 @@ int main(int argc, char * const *argv)
 			       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME);
 			exit(NFT_EXIT_SUCCESS);
 		case OPT_CHECK:
-			nft.check = true;
+			nft->check = true;
 			break;
 		case OPT_FILE:
 			filename = optarg;
@@ -322,7 +321,7 @@ int main(int argc, char * const *argv)
 			include_paths[num_include_paths++] = optarg;
 			break;
 		case OPT_NUMERIC:
-			if (++nft.output.numeric > NUMERIC_ALL) {
+			if (++nft->output.numeric > NUMERIC_ALL) {
 				fprintf(stderr, "Too many numeric options "
 						"used, max. %u\n",
 					NUMERIC_ALL);
@@ -330,10 +329,10 @@ int main(int argc, char * const *argv)
 			}
 			break;
 		case OPT_STATELESS:
-			nft.output.stateless++;
+			nft->output.stateless++;
 			break;
 		case OPT_IP2NAME:
-			nft.output.ip2name++;
+			nft->output.ip2name++;
 			break;
 #ifdef DEBUG
 		case OPT_DEBUG:
@@ -365,7 +364,7 @@ int main(int argc, char * const *argv)
 			break;
 #endif
 		case OPT_HANDLE_OUTPUT:
-			nft.output.handle++;
+			nft->output.handle++;
 			break;
 		case OPT_ECHO:
 			nft.output.echo++;
@@ -386,20 +385,20 @@ int main(int argc, char * const *argv)
 				strcat(buf, " ");
 		}
 		strcat(buf, "\n");
-		parser_init(nf_sock, &cache, &state, &msgs);
+		parser_init(nft->nf_sock, &cache, &state, &msgs);
 		scanner = scanner_init(&state);
 		scanner_push_buffer(scanner, &indesc_cmdline, buf);
 	} else if (filename != NULL) {
-		rc = cache_update(nf_sock, &cache, CMD_INVALID, &msgs);
+		rc = cache_update(nft->nf_sock, &cache, CMD_INVALID, &msgs);
 		if (rc < 0)
 			return rc;
 
-		parser_init(nf_sock, &cache, &state, &msgs);
+		parser_init(nft->nf_sock, &cache, &state, &msgs);
 		scanner = scanner_init(&state);
 		if (scanner_read_file(scanner, filename, &internal_location) < 0)
 			goto out;
 	} else if (interactive) {
-		if (cli_init(&nft, nf_sock, &cache, &state) < 0) {
+		if (cli_init(nft, nft->nf_sock, &cache, &state) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
 				argv[0]);
 			exit(NFT_EXIT_FAILURE);
@@ -410,7 +409,7 @@ int main(int argc, char * const *argv)
 		exit(NFT_EXIT_FAILURE);
 	}
 
-	if (nft_run(&nft, nf_sock, &cache, scanner, &state, &msgs) != 0)
+	if (nft_run(nft, nft->nf_sock, &cache, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 out:
 	scanner_destroy(scanner);
@@ -418,7 +417,7 @@ out:
 	xfree(buf);
 	cache_release(&cache);
 	iface_cache_release();
-	netlink_close_sock(nf_sock);
+	nft_context_free(nft);
 	nft_global_deinit();
 
 	return rc;
-- 
2.14.1

