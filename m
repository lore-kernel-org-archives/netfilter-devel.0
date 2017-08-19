From: Eric Leblond <eric@regit.org>
Subject: [PATH nft v2 06/18] libnftables: add nft_run_command_from_filename
Date: Sat, 19 Aug 2017 17:24:08 +0200
Message-ID: <20170819152420.22563-7-eric@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:33620 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751612AbdHSPYl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 11:24:41 -0400
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add new function to read nftables command from a file

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/nftables/nftables.h |  2 ++
 src/libnftables.c           | 25 +++++++++++++++++++++++++
 src/main.c                  | 16 +++-------------
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 63150ba..980c6ec 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -22,5 +22,7 @@ void nft_context_free(struct nft_ctx *nft);
 
 int nft_run_command_from_buffer(struct nft_ctx *nft, struct nft_cache *cache,
 				char *buf, size_t buflen);
+int nft_run_command_from_filename(struct nft_ctx *nft, struct nft_cache *cache,
+				  const char *filename);
 
 #endif
diff --git a/src/libnftables.c b/src/libnftables.c
index 9701660..a487a87 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -93,5 +93,30 @@ int nft_run_command_from_buffer(struct nft_ctx *nft, struct nft_cache *cache,
 	if (nft_run(nft, nft->nf_sock, cache, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 
+	scanner_destroy(scanner);
+	erec_print_list(stderr, &msgs);
+	return rc;
+}
+
+int nft_run_command_from_filename(struct nft_ctx *nft, struct nft_cache *cache,
+				  const char *filename)
+{
+	int rc = NFT_EXIT_SUCCESS;
+	struct parser_state state;
+	LIST_HEAD(msgs);
+	void *scanner;
+
+	rc = cache_update(nft->nf_sock, cache, CMD_INVALID, &msgs);
+	if (rc < 0)
+		return rc;
+	parser_init(nft->nf_sock, cache, &state, &msgs);
+	scanner = scanner_init(&state);
+	if (scanner_read_file(scanner, filename, &internal_location) < 0)
+		return NFT_EXIT_FAILURE;
+	if (nft_run(nft, nft->nf_sock, cache, scanner, &state, &msgs) != 0)
+		rc = NFT_EXIT_FAILURE;
+
+	scanner_destroy(scanner);
+	erec_print_list(stderr, &msgs);
 	return rc;
 }
diff --git a/src/main.c b/src/main.c
index f863dec..658988d 100644
--- a/src/main.c
+++ b/src/main.c
@@ -271,7 +271,6 @@ int main(int argc, char * const *argv)
 {
 	struct parser_state state;
 	struct nft_cache cache;
-	void *scanner;
 	LIST_HEAD(msgs);
 	char *buf = NULL, *filename = NULL;
 	unsigned int len;
@@ -383,18 +382,12 @@ int main(int argc, char * const *argv)
 		rc = nft_run_command_from_buffer(nft, &cache, buf, len + 2);
 		if (rc < 0)
 			return rc;
-		goto libout;
+		goto out;
 	} else if (filename != NULL) {
-		rc = cache_update(nft->nf_sock, &cache, CMD_INVALID, &msgs);
+		rc = nft_run_command_from_filename(nft, &cache, filename);
 		if (rc < 0)
 			return rc;
-
-		parser_init(nft->nf_sock, &cache, &state, &msgs);
-		scanner = scanner_init(&state);
-		if (scanner_read_file(scanner, filename, &internal_location) < 0)
-			goto out;
-		if (nft_run(nft, nft->nf_sock, &cache, scanner, &state, &msgs) != 0)
-			rc = NFT_EXIT_FAILURE;
+		goto out;
 	} else if (interactive) {
 		if (cli_init(nft, nft->nf_sock, &cache, &state) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
@@ -408,9 +401,6 @@ int main(int argc, char * const *argv)
 	}
 
 out:
-	scanner_destroy(scanner);
-	erec_print_list(stderr, &msgs);
-libout:
 	xfree(buf);
 	cache_release(&cache);
 	iface_cache_release();
-- 
2.14.1

