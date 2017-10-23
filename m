From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 1/4] libnftables: Move library stuff out of main.c
Date: Mon, 23 Oct 2017 17:33:16 +0200
Message-ID: <20171023153319.13415-2-phil@nwl.cc>
References: <20171023153319.13415-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60822 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932102AbdJWPdc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2017 11:33:32 -0400
In-Reply-To: <20171023153319.13415-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This creates src/libnftables.c and include/nftables/nftables.h which
will become the central elements of libnftables.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/Makefile.am          |   3 +-
 include/nftables.h           |  27 +----
 include/nftables/Makefile.am |   1 +
 include/nftables/nftables.h  |  58 ++++++++++
 src/Makefile.am              |   3 +-
 src/libnftables.c            | 262 +++++++++++++++++++++++++++++++++++++++++++
 src/main.c                   | 252 +----------------------------------------
 7 files changed, 327 insertions(+), 279 deletions(-)
 create mode 100644 include/nftables/Makefile.am
 create mode 100644 include/nftables/nftables.h
 create mode 100644 src/libnftables.c

diff --git a/include/Makefile.am b/include/Makefile.am
index 5dd73d81f427e..a74ffbfa8de0a 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1,4 +1,5 @@
-SUBDIRS = linux
+SUBDIRS =		linux		\
+			nftables
 
 noinst_HEADERS = 	cli.h		\
 			datatype.h	\
diff --git a/include/nftables.h b/include/nftables.h
index 01d72a87212ea..eb39dbd1487dd 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -4,23 +4,7 @@
 #include <stdbool.h>
 #include <stdarg.h>
 #include <utils.h>
-
-enum numeric_level {
-	NUMERIC_NONE,
-	NUMERIC_ADDR,
-	NUMERIC_PORT,
-	NUMERIC_ALL,
-};
-
-enum debug_level {
-	DEBUG_SCANNER		= 0x1,
-	DEBUG_PARSER		= 0x2,
-	DEBUG_EVALUATION	= 0x4,
-	DEBUG_NETLINK		= 0x8,
-	DEBUG_MNL		= 0x10,
-	DEBUG_PROTO_CTX		= 0x20,
-	DEBUG_SEGTREE		= 0x40,
-};
+#include <nftables/nftables.h>
 
 #define INCLUDE_PATHS_MAX	16
 
@@ -53,15 +37,6 @@ struct nft_ctx {
 	uint32_t		flags;
 };
 
-#define NFT_CTX_DEFAULT		0
-
-enum nftables_exit_codes {
-	NFT_EXIT_SUCCESS	= 0,
-	NFT_EXIT_FAILURE	= 1,
-	NFT_EXIT_NOMEM		= 2,
-	NFT_EXIT_NONL		= 3,
-};
-
 struct input_descriptor;
 struct location {
 	const struct input_descriptor		*indesc;
diff --git a/include/nftables/Makefile.am b/include/nftables/Makefile.am
new file mode 100644
index 0000000000000..9e31d519599c1
--- /dev/null
+++ b/include/nftables/Makefile.am
@@ -0,0 +1 @@
+noinst_HEADERS = nftables.h
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
new file mode 100644
index 0000000000000..44d3e95d399e6
--- /dev/null
+++ b/include/nftables/nftables.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (c) 2017 Eric Leblond <eric@regit.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#ifndef LIB_NFTABLES_H
+#define LIB_NFTABLES_H
+
+#define _GNU_SOURCE
+#include <stdint.h>
+#include <stdio.h>
+#include <stdbool.h>
+
+struct nft_ctx;
+
+enum debug_level {
+	DEBUG_SCANNER		= 0x1,
+	DEBUG_PARSER		= 0x2,
+	DEBUG_EVALUATION	= 0x4,
+	DEBUG_NETLINK		= 0x8,
+	DEBUG_MNL		= 0x10,
+	DEBUG_PROTO_CTX		= 0x20,
+	DEBUG_SEGTREE		= 0x40,
+};
+
+enum numeric_level {
+	NUMERIC_NONE,
+	NUMERIC_ADDR,
+	NUMERIC_PORT,
+	NUMERIC_ALL,
+};
+
+/**
+ * Possible flags to pass to nft_ctx_new()
+ */
+#define NFT_CTX_DEFAULT		0
+
+/**
+ * Exit codes returned by nft_run_cmd_from_*()
+ */
+enum nftables_exit_codes {
+	NFT_EXIT_SUCCESS	= 0,
+	NFT_EXIT_FAILURE	= 1,
+	NFT_EXIT_NOMEM		= 2,
+	NFT_EXIT_NONL		= 3,
+};
+
+struct nft_ctx *nft_ctx_new(uint32_t flags);
+void nft_ctx_free(struct nft_ctx *ctx);
+FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
+
+int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen);
+int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
+
+#endif /* LIB_NFTABLES_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index 99eef7bb849b6..4d613a731dfb9 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -56,7 +56,8 @@ nft_SOURCES =	main.c				\
 		mergesort.c			\
 		scanner.l			\
 		tcpopt.c			\
-		parser_bison.y
+		parser_bison.y			\
+		libnftables.c
 
 if BUILD_CLI
 nft_SOURCES +=	cli.c
diff --git a/src/libnftables.c b/src/libnftables.c
new file mode 100644
index 0000000000000..9bc51dd894d09
--- /dev/null
+++ b/src/libnftables.c
@@ -0,0 +1,262 @@
+/*
+ * Copyright (c) 2017 Eric Leblond <eric@regit.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <nftables/nftables.h>
+#include <erec.h>
+#include <mnl.h>
+#include <parser.h>
+#include <utils.h>
+#include <iface.h>
+
+#include <errno.h>
+#include <string.h>
+
+static int nft_netlink(struct nft_ctx *nft,
+		       struct parser_state *state, struct list_head *msgs,
+		       struct mnl_socket *nf_sock)
+{
+	uint32_t batch_seqnum, seqnum = 0;
+	struct nftnl_batch *batch;
+	struct netlink_ctx ctx;
+	struct cmd *cmd;
+	struct mnl_err *err, *tmp;
+	LIST_HEAD(err_list);
+	bool batch_supported = netlink_batch_supported(nf_sock, &seqnum);
+	int ret = 0;
+
+	batch = mnl_batch_init();
+
+	batch_seqnum = mnl_batch_begin(batch, mnl_seqnum_alloc(&seqnum));
+	list_for_each_entry(cmd, &state->cmds, list) {
+		memset(&ctx, 0, sizeof(ctx));
+		ctx.msgs = msgs;
+		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
+		ctx.batch = batch;
+		ctx.batch_supported = batch_supported;
+		ctx.octx = &nft->output;
+		ctx.nf_sock = nf_sock;
+		ctx.cache = &nft->cache;
+		ctx.debug_mask = nft->debug_mask;
+		init_list_head(&ctx.list);
+		ret = do_command(&ctx, cmd);
+		if (ret < 0)
+			goto out;
+	}
+	if (!nft->check)
+		mnl_batch_end(batch, mnl_seqnum_alloc(&seqnum));
+
+	if (!mnl_batch_ready(batch))
+		goto out;
+
+	ret = netlink_batch_send(&ctx, &err_list);
+
+	list_for_each_entry_safe(err, tmp, &err_list, head) {
+		list_for_each_entry(cmd, &state->cmds, list) {
+			if (err->seqnum == cmd->seqnum ||
+			    err->seqnum == batch_seqnum) {
+				netlink_io_error(&ctx, &cmd->location,
+						 "Could not process rule: %s",
+						 strerror(err->err));
+				errno = err->err;
+				if (err->seqnum == cmd->seqnum) {
+					mnl_err_list_free(err);
+					break;
+				}
+			}
+		}
+	}
+out:
+	mnl_batch_reset(batch);
+	return ret;
+}
+
+int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
+	    void *scanner, struct parser_state *state,
+	    struct list_head *msgs)
+{
+	struct cmd *cmd, *next;
+	int ret;
+
+	ret = nft_parse(nft, scanner, state);
+	if (ret != 0 || state->nerrs > 0) {
+		ret = -1;
+		goto err1;
+	}
+
+	list_for_each_entry(cmd, &state->cmds, list)
+		nft_cmd_expand(cmd);
+
+	ret = nft_netlink(nft, state, msgs, nf_sock);
+err1:
+	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
+		list_del(&cmd->list);
+		cmd_free(cmd);
+	}
+
+	return ret;
+}
+
+static void nft_init(void)
+{
+	mark_table_init();
+	realm_table_rt_init();
+	devgroup_table_init();
+	realm_table_meta_init();
+	ct_label_table_init();
+	gmp_init();
+#ifdef HAVE_LIBXTABLES
+	xt_init();
+#endif
+}
+
+static void nft_exit(void)
+{
+	ct_label_table_exit();
+	realm_table_rt_exit();
+	devgroup_table_exit();
+	realm_table_meta_exit();
+	mark_table_exit();
+}
+
+static void nft_ctx_netlink_init(struct nft_ctx *ctx)
+{
+	ctx->nf_sock = netlink_open_sock();
+}
+
+struct nft_ctx *nft_ctx_new(uint32_t flags)
+{
+	struct nft_ctx *ctx;
+
+	nft_init();
+	ctx = xzalloc(sizeof(struct nft_ctx));
+
+	ctx->include_paths[0]	= DEFAULT_INCLUDE_PATH;
+	ctx->num_include_paths	= 1;
+	ctx->parser_max_errors	= 10;
+	init_list_head(&ctx->cache.list);
+	ctx->flags = flags;
+
+	if (flags == NFT_CTX_DEFAULT)
+		nft_ctx_netlink_init(ctx);
+
+	return ctx;
+}
+
+void nft_ctx_free(struct nft_ctx *ctx)
+{
+	if (ctx->nf_sock)
+		netlink_close_sock(ctx->nf_sock);
+
+	iface_cache_release();
+	cache_release(&ctx->cache);
+	xfree(ctx);
+	nft_exit();
+}
+
+FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp)
+{
+	FILE *old = ctx->output.output_fp;
+
+	ctx->output.output_fp = fp;
+
+	return old;
+}
+
+static const struct input_descriptor indesc_cmdline = {
+	.type	= INDESC_BUFFER,
+	.name	= "<cmdline>",
+};
+
+int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen)
+{
+	int rc = NFT_EXIT_SUCCESS;
+	struct parser_state state;
+	LIST_HEAD(msgs);
+	void *scanner;
+	FILE *fp;
+
+	parser_init(nft->nf_sock, &nft->cache, &state,
+		    &msgs, nft->debug_mask, &nft->output);
+	scanner = scanner_init(&state);
+	scanner_push_buffer(scanner, &indesc_cmdline, buf);
+
+	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
+		rc = NFT_EXIT_FAILURE;
+
+	fp = nft_ctx_set_output(nft, stderr);
+	erec_print_list(&nft->output, &msgs, nft->debug_mask);
+	nft_ctx_set_output(nft, fp);
+	scanner_destroy(scanner);
+
+	return rc;
+}
+
+int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
+{
+	struct parser_state state;
+	LIST_HEAD(msgs);
+	void *scanner;
+	int rc;
+	FILE *fp;
+
+	rc = cache_update(nft->nf_sock, &nft->cache, CMD_INVALID, &msgs,
+			  nft->debug_mask, &nft->output);
+	if (rc < 0)
+		return NFT_EXIT_FAILURE;
+
+	parser_init(nft->nf_sock, &nft->cache, &state,
+		    &msgs, nft->debug_mask, &nft->output);
+	scanner = scanner_init(&state);
+	if (scanner_read_file(scanner, filename, &internal_location) < 0) {
+		rc = NFT_EXIT_FAILURE;
+		goto err;
+	}
+
+	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
+		rc = NFT_EXIT_FAILURE;
+err:
+	fp = nft_ctx_set_output(nft, stderr);
+	erec_print_list(&nft->output, &msgs, nft->debug_mask);
+	nft_ctx_set_output(nft, fp);
+	scanner_destroy(scanner);
+
+	return rc;
+}
+
+int nft_print(struct output_ctx *octx, const char *fmt, ...)
+{
+	int ret;
+	va_list arg;
+
+	if (!octx->output_fp)
+		return -1;
+
+	va_start(arg, fmt);
+	ret = vfprintf(octx->output_fp, fmt, arg);
+	va_end(arg);
+	fflush(octx->output_fp);
+
+	return ret;
+}
+
+int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
+{
+	int ret;
+	va_list arg;
+
+	if (!octx->output_fp)
+		return -1;
+
+	va_start(arg, fmt);
+	ret = gmp_vfprintf(octx->output_fp, fmt, arg);
+	va_end(arg);
+	fflush(octx->output_fp);
+
+	return ret;
+}
+
diff --git a/src/main.c b/src/main.c
index 1b26838058a4a..b9938c9cd86e6 100644
--- a/src/main.c
+++ b/src/main.c
@@ -18,14 +18,9 @@
 #include <fcntl.h>
 #include <sys/types.h>
 
-#include <nftables.h>
+#include <nftables/nftables.h>
 #include <utils.h>
 #include <parser.h>
-#include <rule.h>
-#include <netlink.h>
-#include <erec.h>
-#include <mnl.h>
-#include <iface.h>
 #include <cli.h>
 
 static struct nft_ctx *nft;
@@ -169,251 +164,6 @@ static const struct {
 	},
 };
 
-static const struct input_descriptor indesc_cmdline = {
-	.type	= INDESC_BUFFER,
-	.name	= "<cmdline>",
-};
-
-static int nft_netlink(struct nft_ctx *nft,
-		       struct parser_state *state, struct list_head *msgs,
-		       struct mnl_socket *nf_sock)
-{
-	uint32_t batch_seqnum, seqnum = 0;
-	struct nftnl_batch *batch;
-	struct netlink_ctx ctx;
-	struct cmd *cmd;
-	struct mnl_err *err, *tmp;
-	LIST_HEAD(err_list);
-	bool batch_supported = netlink_batch_supported(nf_sock, &seqnum);
-	int ret = 0;
-
-	batch = mnl_batch_init();
-
-	batch_seqnum = mnl_batch_begin(batch, mnl_seqnum_alloc(&seqnum));
-	list_for_each_entry(cmd, &state->cmds, list) {
-		memset(&ctx, 0, sizeof(ctx));
-		ctx.msgs = msgs;
-		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
-		ctx.batch = batch;
-		ctx.batch_supported = batch_supported;
-		ctx.octx = &nft->output;
-		ctx.nf_sock = nf_sock;
-		ctx.cache = &nft->cache;
-		ctx.debug_mask = nft->debug_mask;
-		init_list_head(&ctx.list);
-		ret = do_command(&ctx, cmd);
-		if (ret < 0)
-			goto out;
-	}
-	if (!nft->check)
-		mnl_batch_end(batch, mnl_seqnum_alloc(&seqnum));
-
-	if (!mnl_batch_ready(batch))
-		goto out;
-
-	ret = netlink_batch_send(&ctx, &err_list);
-
-	list_for_each_entry_safe(err, tmp, &err_list, head) {
-		list_for_each_entry(cmd, &state->cmds, list) {
-			if (err->seqnum == cmd->seqnum ||
-			    err->seqnum == batch_seqnum) {
-				netlink_io_error(&ctx, &cmd->location,
-						 "Could not process rule: %s",
-						 strerror(err->err));
-				errno = err->err;
-				if (err->seqnum == cmd->seqnum) {
-					mnl_err_list_free(err);
-					break;
-				}
-			}
-		}
-	}
-out:
-	mnl_batch_reset(batch);
-	return ret;
-}
-
-int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-	    void *scanner, struct parser_state *state,
-	    struct list_head *msgs)
-{
-	struct cmd *cmd, *next;
-	int ret;
-
-	ret = nft_parse(nft, scanner, state);
-	if (ret != 0 || state->nerrs > 0) {
-		ret = -1;
-		goto err1;
-	}
-
-	list_for_each_entry(cmd, &state->cmds, list)
-		nft_cmd_expand(cmd);
-
-	ret = nft_netlink(nft, state, msgs, nf_sock);
-err1:
-	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
-		list_del(&cmd->list);
-		cmd_free(cmd);
-	}
-
-	return ret;
-}
-
-static void nft_init(void)
-{
-	mark_table_init();
-	realm_table_rt_init();
-	devgroup_table_init();
-	realm_table_meta_init();
-	ct_label_table_init();
-	gmp_init();
-#ifdef HAVE_LIBXTABLES
-	xt_init();
-#endif
-}
-
-static void nft_exit(void)
-{
-	ct_label_table_exit();
-	realm_table_rt_exit();
-	devgroup_table_exit();
-	realm_table_meta_exit();
-	mark_table_exit();
-}
-
-static void nft_ctx_netlink_init(struct nft_ctx *ctx)
-{
-	ctx->nf_sock = netlink_open_sock();
-}
-
-static struct nft_ctx *nft_ctx_new(uint32_t flags)
-{
-	struct nft_ctx *ctx;
-
-	nft_init();
-	ctx = xzalloc(sizeof(struct nft_ctx));
-
-	ctx->include_paths[0]	= DEFAULT_INCLUDE_PATH;
-	ctx->num_include_paths	= 1;
-	ctx->parser_max_errors	= 10;
-	init_list_head(&ctx->cache.list);
-	ctx->flags = flags;
-
-	if (flags == NFT_CTX_DEFAULT)
-		nft_ctx_netlink_init(ctx);
-
-	return ctx;
-}
-
-static void nft_ctx_free(struct nft_ctx *ctx)
-{
-	if (ctx->nf_sock)
-		netlink_close_sock(ctx->nf_sock);
-
-	iface_cache_release();
-	cache_release(&ctx->cache);
-	xfree(ctx);
-	nft_exit();
-}
-
-static FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp)
-{
-	FILE *old = ctx->output.output_fp;
-
-	ctx->output.output_fp = fp;
-
-	return old;
-}
-
-static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
-				   char *buf, size_t buflen)
-{
-	int rc = NFT_EXIT_SUCCESS;
-	struct parser_state state;
-	LIST_HEAD(msgs);
-	void *scanner;
-	FILE *fp;
-
-	parser_init(nft->nf_sock, &nft->cache, &state,
-		    &msgs, nft->debug_mask, &nft->output);
-	scanner = scanner_init(&state);
-	scanner_push_buffer(scanner, &indesc_cmdline, buf);
-
-	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
-		rc = NFT_EXIT_FAILURE;
-
-	fp = nft_ctx_set_output(nft, stderr);
-	erec_print_list(&nft->output, &msgs, nft->debug_mask);
-	nft_ctx_set_output(nft, fp);
-	scanner_destroy(scanner);
-
-	return rc;
-}
-
-static int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
-{
-	struct parser_state state;
-	LIST_HEAD(msgs);
-	void *scanner;
-	int rc;
-	FILE *fp;
-
-	rc = cache_update(nft->nf_sock, &nft->cache, CMD_INVALID, &msgs,
-			  nft->debug_mask, &nft->output);
-	if (rc < 0)
-		return NFT_EXIT_FAILURE;
-
-	parser_init(nft->nf_sock, &nft->cache, &state,
-		    &msgs, nft->debug_mask, &nft->output);
-	scanner = scanner_init(&state);
-	if (scanner_read_file(scanner, filename, &internal_location) < 0) {
-		rc = NFT_EXIT_FAILURE;
-		goto err;
-	}
-
-	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
-		rc = NFT_EXIT_FAILURE;
-err:
-	fp = nft_ctx_set_output(nft, stderr);
-	erec_print_list(&nft->output, &msgs, nft->debug_mask);
-	nft_ctx_set_output(nft, fp);
-	scanner_destroy(scanner);
-
-	return rc;
-}
-
-int nft_print(struct output_ctx *octx, const char *fmt, ...)
-{
-	int ret;
-	va_list arg;
-
-	if (!octx->output_fp)
-		return -1;
-
-	va_start(arg, fmt);
-	ret = vfprintf(octx->output_fp, fmt, arg);
-	va_end(arg);
-	fflush(octx->output_fp);
-
-	return ret;
-}
-
-int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
-{
-	int ret;
-	va_list arg;
-
-	if (!octx->output_fp)
-		return -1;
-
-	va_start(arg, fmt);
-	ret = gmp_vfprintf(octx->output_fp, fmt, arg);
-	va_end(arg);
-	fflush(octx->output_fp);
-
-	return ret;
-}
-
 int main(int argc, char * const *argv)
 {
 	char *buf = NULL, *filename = NULL;
-- 
2.13.1

