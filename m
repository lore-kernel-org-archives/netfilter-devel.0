From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2] libnftables: Unexport enum nftables_exit_codes
Date: Fri, 10 Nov 2017 12:27:15 +0100
Message-ID: <20171110112715.23289-1-phil@nwl.cc>
References: <20171109192712.GX32305@orbyte.nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39812 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbdKJL11 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Nov 2017 06:27:27 -0500
In-Reply-To: <20171109192712.GX32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Apart from SUCCESS/FAILURE, these codes were not used by library
functions simply because NOMEM and NONL conditions lead to calling
exit() instead of propagating the error condition back up the call
stack.

Instead, make nft_run_cmd_from_*() return either 0 or -1 on error.
Usually errno will then contain more details about what happened and/or
there are messages in erec.

Calls to exit() in main() are adjusted to stay compatible.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Fixed return code of main() if nft_run_cmd_from_*() fails, this broke
  tests/shell.
---
 include/nftables.h          |  7 +++++++
 include/nftables/nftables.h | 10 ----------
 src/libnftables.c           | 10 +++++-----
 src/main.c                  | 20 ++++++++++----------
 4 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index d69079fe03e3a..3bfa33e5cb336 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -35,6 +35,13 @@ struct nft_ctx {
 	uint32_t		flags;
 };
 
+enum nftables_exit_codes {
+	NFT_EXIT_SUCCESS	= 0,
+	NFT_EXIT_FAILURE	= 1,
+	NFT_EXIT_NOMEM		= 2,
+	NFT_EXIT_NONL		= 3,
+};
+
 struct input_descriptor;
 struct location {
 	const struct input_descriptor		*indesc;
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 4211be76e6e40..8e59f2b2a59ab 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -38,16 +38,6 @@ enum nft_numeric_level {
  */
 #define NFT_CTX_DEFAULT		0
 
-/**
- * Exit codes returned by nft_run_cmd_from_*()
- */
-enum nftables_exit_codes {
-	NFT_EXIT_SUCCESS	= 0,
-	NFT_EXIT_FAILURE	= 1,
-	NFT_EXIT_NOMEM		= 2,
-	NFT_EXIT_NONL		= 3,
-};
-
 struct nft_ctx *nft_ctx_new(uint32_t flags);
 void nft_ctx_free(struct nft_ctx *ctx);
 
diff --git a/src/libnftables.c b/src/libnftables.c
index dc6a5fdf32640..e8fa6742f7d17 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -272,7 +272,7 @@ static const struct input_descriptor indesc_cmdline = {
 
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen)
 {
-	int rc = NFT_EXIT_SUCCESS;
+	int rc = 0;
 	struct parser_state state;
 	LIST_HEAD(msgs);
 	void *scanner;
@@ -284,7 +284,7 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen)
 	scanner_push_buffer(scanner, &indesc_cmdline, buf);
 
 	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
-		rc = NFT_EXIT_FAILURE;
+		rc = -1;
 
 	fp = nft_ctx_set_output(nft, stderr);
 	erec_print_list(&nft->output, &msgs, nft->debug_mask);
@@ -306,18 +306,18 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	rc = cache_update(nft->nf_sock, &nft->cache, CMD_INVALID, &msgs,
 			  nft->debug_mask, &nft->output);
 	if (rc < 0)
-		return NFT_EXIT_FAILURE;
+		return -1;
 
 	parser_init(nft->nf_sock, &nft->cache, &state,
 		    &msgs, nft->debug_mask, &nft->output);
 	scanner = scanner_init(&state);
 	if (scanner_read_file(scanner, filename, &internal_location) < 0) {
-		rc = NFT_EXIT_FAILURE;
+		rc = -1;
 		goto err;
 	}
 
 	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
-		rc = NFT_EXIT_FAILURE;
+		rc = -1;
 err:
 	fp = nft_ctx_set_output(nft, stderr);
 	erec_print_list(&nft->output, &msgs, nft->debug_mask);
diff --git a/src/main.c b/src/main.c
index 529bedffc2e3b..8d03f8989b1fc 100644
--- a/src/main.c
+++ b/src/main.c
@@ -183,11 +183,11 @@ int main(int argc, char * const *argv)
 		switch (val) {
 		case OPT_HELP:
 			show_help(argv[0]);
-			exit(NFT_EXIT_SUCCESS);
+			exit(0);
 		case OPT_VERSION:
 			printf("%s v%s (%s)\n",
 			       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME);
-			exit(NFT_EXIT_SUCCESS);
+			exit(0);
 		case OPT_CHECK:
 			nft_ctx_set_dry_run(nft, true);
 			break;
@@ -202,7 +202,7 @@ int main(int argc, char * const *argv)
 				fprintf(stderr,
 					"Failed to add include path '%s'\n",
 					optarg);
-				exit(NFT_EXIT_FAILURE);
+				exit(1);
 			}
 			break;
 		case OPT_NUMERIC:
@@ -211,7 +211,7 @@ int main(int argc, char * const *argv)
 				fprintf(stderr, "Too many numeric options "
 						"used, max. %u\n",
 					NFT_NUMERIC_ALL);
-				exit(NFT_EXIT_FAILURE);
+				exit(1);
 			}
 			nft_ctx_output_set_numeric(nft, numeric + 1);
 			break;
@@ -241,7 +241,7 @@ int main(int argc, char * const *argv)
 				if (i == array_size(debug_param)) {
 					fprintf(stderr, "invalid debug parameter `%s'\n",
 						optarg);
-					exit(NFT_EXIT_FAILURE);
+					exit(1);
 				}
 
 				if (end == NULL)
@@ -257,7 +257,7 @@ int main(int argc, char * const *argv)
 			nft_ctx_output_set_echo(nft, true);
 			break;
 		case OPT_INVALID:
-			exit(NFT_EXIT_FAILURE);
+			exit(1);
 		}
 	}
 
@@ -272,19 +272,19 @@ int main(int argc, char * const *argv)
 				strcat(buf, " ");
 		}
 		strcat(buf, "\n");
-		rc = nft_run_cmd_from_buffer(nft, buf, len + 2);
+		rc = !!nft_run_cmd_from_buffer(nft, buf, len + 2);
 	} else if (filename != NULL) {
-		rc = nft_run_cmd_from_filename(nft, filename);
+		rc = !!nft_run_cmd_from_filename(nft, filename);
 	} else if (interactive) {
 		if (cli_init(nft) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
 				argv[0]);
-			exit(NFT_EXIT_FAILURE);
+			exit(1);
 		}
 		return 0;
 	} else {
 		fprintf(stderr, "%s: no command specified\n", argv[0]);
-		exit(NFT_EXIT_FAILURE);
+		exit(1);
 	}
 
 	xfree(buf);
-- 
2.13.1

