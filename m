From: Eric Leblond <eric@regit.org>
Subject: [PATH nft v2 16/18] libnftables: add error handling
Date: Sat, 19 Aug 2017 17:24:18 +0200
Message-ID: <20170819152420.22563-17-eric@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:33800 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751605AbdHSPdC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 11:33:02 -0400
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It had a nft_get_error to be able to fetch existing errors and get
them into a buffer that can be later used by the application.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/nftables.h          |  1 +
 include/nftables/nftables.h |  1 +
 src/libnftables.c           | 35 +++++++++++++++++++++++++----------
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index ddff5d8..9d119b1 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -30,6 +30,7 @@ struct output_ctx {
 	unsigned int ip2name;
 	unsigned int handle;
 	unsigned int echo;
+	struct list_head msgs;
 	void *ctx;
 	int (*print)(void *ctx, const char *format, ...);
 };
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index f419884..c72ec6b 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -30,6 +30,7 @@ void nft_context_free(struct nft_ctx *nft);
 void nft_context_set_print_func(struct nft_ctx *nft,
 				int (*print)(void *ctx, const char *fmt, ...),
 				void *ctx);
+int nft_get_error(struct nft_ctx *nft, char *err_buf, size_t err_buf_len);
 
 int nft_run_command_from_buffer(struct nft_ctx *nft,
 				char *buf, size_t buflen);
diff --git a/src/libnftables.c b/src/libnftables.c
index 15345ae..b1df916 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -86,6 +86,7 @@ struct nft_ctx *nft_context_new(void)
 	ctx->nf_sock = netlink_open_sock();
 
 	init_list_head(&ctx->cache.list);
+	init_list_head(&ctx->output.msgs);
 
 	ctx->output.ctx = ctx;
 	ctx->output.print = nft_print;
@@ -108,6 +109,7 @@ void nft_context_free(struct nft_ctx *nft)
 		return;
 	netlink_close_sock(nft->nf_sock);
 	cache_release(&nft->cache);
+	erec_free_list(&nft->output.msgs);
 	xfree(nft);
 }
 
@@ -116,23 +118,38 @@ static const struct input_descriptor indesc_cmdline = {
 	.name	= "<cmdline>",
 };
 
+/**
+ * Get current errors and write them in provided buffer
+ *
+ * \return NFT_EXIT_SUCCESS if error, NFT_EXIT_FAILURE if error
+ */
+int nft_get_error(struct nft_ctx *nft, char *err_buf, size_t err_buf_len)
+{
+	FILE *errfile = fmemopen(err_buf, err_buf_len, "w");
+	*err_buf = '\0';
+	erec_print_list(errfile, &nft->output.msgs);
+	fclose(errfile);
+	if (!strlen(err_buf))
+		return NFT_EXIT_FAILURE;
+	return NFT_EXIT_SUCCESS;
+}
+
 int nft_run_command_from_buffer(struct nft_ctx *nft,
 				char *buf, size_t buflen)
 {
 	int rc = NFT_EXIT_SUCCESS;
 	struct parser_state state;
-	LIST_HEAD(msgs);
 	void *scanner;
 
-	parser_init(nft->nf_sock, &nft->cache, &state, &msgs);
+	parser_init(nft->nf_sock, &nft->cache, &state, &nft->output.msgs);
 	scanner = scanner_init(&state);
 	scanner_push_buffer(scanner, &indesc_cmdline, buf);
 		
-	if (nft_run(nft, nft->nf_sock, &nft->cache, scanner, &state, &msgs) != 0)
+	if (nft_run(nft, nft->nf_sock, &nft->cache, scanner,
+		    &state, &nft->output.msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 
 	scanner_destroy(scanner);
-	erec_print_list(stderr, &msgs);
 	return rc;
 }
 
@@ -146,15 +163,15 @@ int nft_run_command_from_filename(struct nft_ctx *nft, const char *filename)
 	rc = cache_update(nft->nf_sock, &nft->cache, CMD_INVALID, &msgs);
 	if (rc < 0)
 		return rc;
-	parser_init(nft->nf_sock, &nft->cache, &state, &msgs);
+	parser_init(nft->nf_sock, &nft->cache, &state, &nft->output.msgs);
 	scanner = scanner_init(&state);
 	if (scanner_read_file(scanner, filename, &internal_location) < 0)
 		return NFT_EXIT_FAILURE;
-	if (nft_run(nft, nft->nf_sock, &nft->cache, scanner, &state, &msgs) != 0)
+	if (nft_run(nft, nft->nf_sock, &nft->cache, scanner,
+		    &state, &nft->output.msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 
 	scanner_destroy(scanner);
-	erec_print_list(stderr, &msgs);
 	return rc;
 }
 
@@ -190,13 +207,12 @@ int nft_batch_add(struct nft_ctx *nft, struct nft_batch *batch,
 	int rc = NFT_EXIT_SUCCESS;
 	int ret = 0;
 	struct parser_state state;
-	LIST_HEAD(msgs);
 	void *scanner;
 	struct cmd *cmd, *next;
 	struct netlink_ctx *ctx = &batch->nl_ctx;
 	uint32_t seqnum;
 
-	parser_init(nft->nf_sock, &nft->cache, &state, &msgs);
+	parser_init(nft->nf_sock, &nft->cache, &state, &nft->output.msgs);
 	scanner = scanner_init(&state);
 	scanner_push_buffer(scanner, &indesc_cmdline, buf);
 		
@@ -220,7 +236,6 @@ int nft_batch_add(struct nft_ctx *nft, struct nft_batch *batch,
 	}
 err1:
 	scanner_destroy(scanner);
-	erec_print_list(stderr, &msgs);
 	return rc;
 }
 
-- 
2.14.1

