From: Eric Leblond <eric@regit.org>
Subject: [nft PATH 16/16] libnftables: basic doxygen documentation
Date: Wed, 16 Aug 2017 22:43:10 +0200
Message-ID: <20170816204310.3371-17-eric@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:40678 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752353AbdHPVZ2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 17:25:28 -0400
In-Reply-To: <20170816204310.3371-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/libnftables.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/src/libnftables.c b/src/libnftables.c
index a42e8f1..a9e54c4 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -35,6 +35,12 @@ unsigned int debug_level;
 
 const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH };
 
+/**
+ * Init cache structure.
+ *
+ * This needs to be called once by process to do the initialization
+ * phase of some structures.
+ */
 void nft_global_init(void)
 {
 	mark_table_init();
@@ -48,6 +54,11 @@ void nft_global_init(void)
 #endif
 }
 
+/**
+ * Deinit global structures
+ *
+ * To be call one before exiting the nftables tasks
+ */
 void nft_global_deinit(void)
 {
 	iface_cache_release();
@@ -58,6 +69,12 @@ void nft_global_deinit(void)
 	mark_table_exit();
 }
 
+/**
+ * Set number of consecutive errors to handle
+ *
+ * This can be useful if you send complex command to nftables
+ * and want to debug it but it causes memory leak.
+ */
 int nft_global_set_max_errors(unsigned int errors)
 {
 	max_errors = errors;
@@ -75,6 +92,10 @@ static int nft_print(void *ctx, const char *fmt, ...)
 	return 0;
 } 
 
+/**
+ * Allocate a nftables context
+ *
+ */
 struct nft_ctx *nft_context_new(void)
 {
 	struct nft_ctx *ctx = NULL;
@@ -93,6 +114,12 @@ struct nft_ctx *nft_context_new(void)
 	return ctx;
 }
 
+/** 
+ * Set print function for your application
+ *
+ * Command such as `list ruleset` can trigger an output. This function
+ * allows you to define which function should be used.
+ */
 void nft_context_set_print_func(struct nft_ctx *nft,
 				int (*print)(void *ctx, const char *fmt, ...),
 				void *ctx)
@@ -103,6 +130,9 @@ void nft_context_set_print_func(struct nft_ctx *nft,
 	}
 }
 
+/**
+ * Free a nftables context
+ */
 void nft_context_free(struct nft_ctx *nft)
 {
 	if (nft == NULL)
@@ -118,6 +148,9 @@ static const struct input_descriptor indesc_cmdline = {
 	.name	= "<cmdline>",
 };
 
+/**
+ * Get current errors and write them in provided buffer
+ */
 int nft_get_error(struct nft_ctx *nft, char *err_buf, size_t err_buf_len)
 {
 	FILE *errfile = fmemopen(err_buf, err_buf_len, "w");
@@ -126,6 +159,9 @@ int nft_get_error(struct nft_ctx *nft, char *err_buf, size_t err_buf_len)
 	return 0;	
 }
 
+/**
+ * Run nftables command contained in provided buffer
+ */
 int nft_run_command_from_buffer(struct nft_ctx *nft,
 				char *buf, size_t buflen)
 {
@@ -145,6 +181,9 @@ int nft_run_command_from_buffer(struct nft_ctx *nft,
 	return rc;
 }
 
+/**
+ * Run all nftables commands contained in a file
+ */
 int nft_run_command_from_filename(struct nft_ctx *nft, const char *filename)
 {
 	int rc = NFT_EXIT_SUCCESS;
@@ -167,6 +206,9 @@ int nft_run_command_from_filename(struct nft_ctx *nft, const char *filename)
 	return rc;
 }
 
+/**
+ * Start a batch
+ */
 struct nft_batch *nft_batch_start(struct nft_ctx *nft)
 {
 	struct nft_batch *batch = malloc(sizeof(*batch));
@@ -179,6 +221,9 @@ struct nft_batch *nft_batch_start(struct nft_ctx *nft)
 	return batch;
 }
 
+/**
+ * Add a command to a already created batch
+ */
 int nft_batch_add(struct nft_ctx *nft, struct nft_batch *batch,
 		  const char * buf, size_t buflen)
 {
@@ -226,6 +271,9 @@ err1:
 	return rc;
 }
 
+/**
+ * Commit a batch to the kernel
+ */
 int nft_batch_commit(struct nft_ctx *nft, struct nft_batch *batch)
 {
 	int ret = 0;
@@ -246,6 +294,9 @@ out:
 
 }
 
+/**
+ * Free ressources allocated to a batch
+ */
 void nft_batch_free(struct nft_batch *batch)
 {
 	if (batch == NULL)
-- 
2.14.1

