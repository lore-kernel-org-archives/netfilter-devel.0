From: Eric Leblond <eric@regit.org>
Subject: [PATH nft v2 05/18] libnftables: add nft_run_command_from_buffer
Date: Sat, 19 Aug 2017 17:24:07 +0200
Message-ID: <20170819152420.22563-6-eric@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:33612 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751595AbdHSPYk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 11:24:40 -0400
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/nftables/nftables.h |  3 +++
 src/libnftables.c           | 26 +++++++++++++++++++++++++-
 src/main.c                  | 19 ++++++++-----------
 3 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index cfa60fe..63150ba 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -20,4 +20,7 @@ void nft_global_deinit(void);
 struct nft_ctx *nft_context_new(void);
 void nft_context_free(struct nft_ctx *nft);
 
+int nft_run_command_from_buffer(struct nft_ctx *nft, struct nft_cache *cache,
+				char *buf, size_t buflen);
+
 #endif
diff --git a/src/libnftables.c b/src/libnftables.c
index 6756c0f..9701660 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -7,7 +7,6 @@
  *
  */
 
-#include <nftables/nftables.h>
 #include <string.h>
 #include <errno.h>
 #include <nftables.h>
@@ -18,6 +17,8 @@
 #include <libmnl/libmnl.h>
 #include <mnl.h>
 
+#include <nftables/nftables.h>
+
 #include <unistd.h>
 #include <fcntl.h>
 
@@ -71,3 +72,26 @@ void nft_context_free(struct nft_ctx *nft)
 	netlink_close_sock(nft->nf_sock);
 	xfree(nft);
 }
+
+static const struct input_descriptor indesc_cmdline = {
+	.type	= INDESC_BUFFER,
+	.name	= "<cmdline>",
+};
+
+int nft_run_command_from_buffer(struct nft_ctx *nft, struct nft_cache *cache,
+				char *buf, size_t buflen)
+{
+	int rc = NFT_EXIT_SUCCESS;
+	struct parser_state state;
+	LIST_HEAD(msgs);
+	void *scanner;
+
+	parser_init(nft->nf_sock, cache, &state, &msgs);
+	scanner = scanner_init(&state);
+	scanner_push_buffer(scanner, &indesc_cmdline, buf);
+		
+	if (nft_run(nft, nft->nf_sock, cache, scanner, &state, &msgs) != 0)
+		rc = NFT_EXIT_FAILURE;
+
+	return rc;
+}
diff --git a/src/main.c b/src/main.c
index ee5566c..f863dec 100644
--- a/src/main.c
+++ b/src/main.c
@@ -18,8 +18,8 @@
 #include <fcntl.h>
 #include <sys/types.h>
 
-#include <nftables/nftables.h>
 #include <nftables.h>
+#include <nftables/nftables.h>
 #include <utils.h>
 #include <parser.h>
 #include <rule.h>
@@ -182,11 +182,6 @@ static const struct {
 };
 #endif
 
-static const struct input_descriptor indesc_cmdline = {
-	.type	= INDESC_BUFFER,
-	.name	= "<cmdline>",
-};
-
 static int nft_netlink(struct nft_ctx *nft, struct nft_cache *cache,
 		       struct parser_state *state, struct list_head *msgs,
 		       struct mnl_socket *nf_sock)
@@ -385,9 +380,10 @@ int main(int argc, char * const *argv)
 				strcat(buf, " ");
 		}
 		strcat(buf, "\n");
-		parser_init(nft->nf_sock, &cache, &state, &msgs);
-		scanner = scanner_init(&state);
-		scanner_push_buffer(scanner, &indesc_cmdline, buf);
+		rc = nft_run_command_from_buffer(nft, &cache, buf, len + 2);
+		if (rc < 0)
+			return rc;
+		goto libout;
 	} else if (filename != NULL) {
 		rc = cache_update(nft->nf_sock, &cache, CMD_INVALID, &msgs);
 		if (rc < 0)
@@ -397,6 +393,8 @@ int main(int argc, char * const *argv)
 		scanner = scanner_init(&state);
 		if (scanner_read_file(scanner, filename, &internal_location) < 0)
 			goto out;
+		if (nft_run(nft, nft->nf_sock, &cache, scanner, &state, &msgs) != 0)
+			rc = NFT_EXIT_FAILURE;
 	} else if (interactive) {
 		if (cli_init(nft, nft->nf_sock, &cache, &state) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
@@ -409,11 +407,10 @@ int main(int argc, char * const *argv)
 		exit(NFT_EXIT_FAILURE);
 	}
 
-	if (nft_run(nft, nft->nf_sock, &cache, scanner, &state, &msgs) != 0)
-		rc = NFT_EXIT_FAILURE;
 out:
 	scanner_destroy(scanner);
 	erec_print_list(stderr, &msgs);
+libout:
 	xfree(buf);
 	cache_release(&cache);
 	iface_cache_release();
-- 
2.14.1

