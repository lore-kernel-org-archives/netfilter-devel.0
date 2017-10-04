From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] evaluate: Fix debug output
Date: Wed,  4 Oct 2017 15:59:32 +0200
Message-ID: <20171004135932.20773-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51974 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752040AbdJDN7o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 09:59:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When introducing output_fp, debug output in src/evaluate.c was not
adjusted and therefore broke.

This patch restores eval debug output by applying the following changes:

- Change erec_print() and erec_print_list() to take a struct output_ctx
  pointer as first argument and use output_fp field as destination to
  print to.
- Drop octx_debug_dummy variable and instead use octx pointer from
  struct eval_ctx for debug output.
- Add missing calls to erec_destroy() in eval debug output which should
  eliminate another mem leak.

Fixes: 2535ba7006f22 ("src: get rid of printf")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/erec.h |  5 +++--
 src/cli.c      |  2 +-
 src/erec.c     | 13 +++++++++----
 src/evaluate.c | 20 +++++++++++---------
 src/main.c     | 10 ++++++++--
 5 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/include/erec.h b/include/erec.h
index 223cb12d826ad..79a162902304b 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -46,6 +46,7 @@ extern struct error_record *erec_create(enum error_record_types type,
 					const char *fmt, ...) __gmp_fmtstring(3, 4);
 extern void erec_add_location(struct error_record *erec,
 			      const struct location *loc);
+extern void erec_destroy(struct error_record *erec);
 
 #define error(loc, fmt, args...) \
 	erec_create(EREC_ERROR, (loc), (fmt), ## args)
@@ -58,9 +59,9 @@ static inline void erec_queue(struct error_record *erec,
 	list_add_tail(&erec->list, queue);
 }
 
-extern void erec_print(FILE *f, const struct error_record *erec,
+extern void erec_print(struct output_ctx *octx, const struct error_record *erec,
 		       unsigned int debug_mask);
-extern void erec_print_list(FILE *f, struct list_head *list,
+extern void erec_print_list(struct output_ctx *octx, struct list_head *list,
 			    unsigned int debug_mask);
 
 struct eval_ctx;
diff --git a/src/cli.c b/src/cli.c
index 692d1731461d1..cadc3af6e8034 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -138,7 +138,7 @@ static void cli_complete(char *line)
 		    cli_nft->debug_mask, &cli_nft->output);
 	scanner_push_buffer(scanner, &indesc_cli, line);
 	nft_run(cli_nft, cli_nf_sock, scanner, state, &msgs);
-	erec_print_list(stdout, &msgs, cli_nft->debug_mask);
+	erec_print_list(&cli_nft->output, &msgs, cli_nft->debug_mask);
 	xfree(line);
 	cache_release(&cli_nft->cache);
 	iface_cache_release();
diff --git a/src/erec.c b/src/erec.c
index 174d1aeb0ca8f..76fdeb8635a13 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -69,7 +69,7 @@ void erec_add_location(struct error_record *erec, const struct location *loc)
 	erec->num_locations++;
 }
 
-static void erec_destroy(struct error_record *erec)
+void erec_destroy(struct error_record *erec)
 {
 	unsigned int i;
 
@@ -112,7 +112,7 @@ struct error_record *erec_create(enum error_record_types type,
 	return erec;
 }
 
-void erec_print(FILE *f, const struct error_record *erec,
+void erec_print(struct output_ctx *octx, const struct error_record *erec,
 		unsigned int debug_mask)
 {
 	const struct location *loc = erec->locations, *iloc;
@@ -123,6 +123,10 @@ void erec_print(FILE *f, const struct error_record *erec,
 	unsigned int i, end;
 	int l, ret;
 	off_t orig_offset = 0;
+	FILE *f = octx->output_fp;
+
+	if (!f)
+		return;
 
 	switch (indesc->type) {
 	case INDESC_BUFFER:
@@ -202,13 +206,14 @@ void erec_print(FILE *f, const struct error_record *erec,
 	fprintf(f, "\n");
 }
 
-void erec_print_list(FILE *f, struct list_head *list, unsigned int debug_mask)
+void erec_print_list(struct output_ctx *octx, struct list_head *list,
+		     unsigned int debug_mask)
 {
 	struct error_record *erec, *next;
 
 	list_for_each_entry_safe(erec, next, list, list) {
 		list_del(&erec->list);
-		erec_print(f, erec, debug_mask);
+		erec_print(octx, erec, debug_mask);
 		erec_destroy(erec);
 	}
 }
diff --git a/src/evaluate.c b/src/evaluate.c
index ca9180b7d102c..193ea1c7b5d19 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -30,7 +30,6 @@
 #include <utils.h>
 #include <xt.h>
 
-static struct output_ctx octx_debug_dummy;
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
 
 static const char *byteorder_names[] = {
@@ -1777,9 +1776,10 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &(*expr)->location,
 				   "Evaluate %s", (*expr)->ops->name);
-		erec_print(stdout, erec, ctx->debug_mask);
-		expr_print(*expr, &octx_debug_dummy);
-		printf("\n\n");
+		erec_print(ctx->octx, erec, ctx->debug_mask);
+		expr_print(*expr, ctx->octx);
+		nft_print(ctx->octx, "\n\n");
+		erec_destroy(erec);
 	}
 
 	switch ((*expr)->ops->type) {
@@ -2762,9 +2762,10 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &stmt->location,
 				   "Evaluate %s", stmt->ops->name);
-		erec_print(stdout, erec, ctx->debug_mask);
-		stmt_print(stmt, &octx_debug_dummy);
-		printf("\n\n");
+		erec_print(ctx->octx, erec, ctx->debug_mask);
+		stmt_print(stmt, ctx->octx);
+		nft_print(ctx->octx, "\n\n");
+		erec_destroy(erec);
 	}
 
 	switch (stmt->ops->type) {
@@ -3452,8 +3453,9 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 
 		erec = erec_create(EREC_INFORMATIONAL, &cmd->location,
 				   "Evaluate %s", cmd_op_to_name(cmd->op));
-		erec_print(stdout, erec, ctx->debug_mask);
-		printf("\n\n");
+		erec_print(ctx->octx, erec, ctx->debug_mask);
+		nft_print(ctx->octx, "\n\n");
+		erec_destroy(erec);
 	}
 
 	ctx->cmd = cmd;
diff --git a/src/main.c b/src/main.c
index fc79cfaa30e0c..b59c932ad4299 100644
--- a/src/main.c
+++ b/src/main.c
@@ -332,6 +332,7 @@ static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
 	struct parser_state state;
 	LIST_HEAD(msgs);
 	void *scanner;
+	FILE *fp;
 
 	parser_init(nft->nf_sock, &nft->cache, &state,
 		    &msgs, nft->debug_mask, &nft->output);
@@ -341,7 +342,9 @@ static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
 	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 
-	erec_print_list(stderr, &msgs, nft->debug_mask);
+	fp = nft_ctx_set_output(nft, stderr);
+	erec_print_list(&nft->output, &msgs, nft->debug_mask);
+	nft_ctx_set_output(nft, fp);
 	scanner_destroy(scanner);
 
 	return rc;
@@ -353,6 +356,7 @@ static int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	LIST_HEAD(msgs);
 	void *scanner;
 	int rc;
+	FILE *fp;
 
 	rc = cache_update(nft->nf_sock, &nft->cache, CMD_INVALID, &msgs,
 			  nft->debug_mask, &nft->output);
@@ -370,7 +374,9 @@ static int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 err:
-	erec_print_list(stderr, &msgs, nft->debug_mask);
+	fp = nft_ctx_set_output(nft, stderr);
+	erec_print_list(&nft->output, &msgs, nft->debug_mask);
+	nft_ctx_set_output(nft, fp);
 	scanner_destroy(scanner);
 
 	return rc;
-- 
2.13.1

