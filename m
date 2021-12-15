Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3A9C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 19:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhLOT4W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 14:56:22 -0500
Received: from mail.netfilter.org ([217.70.188.207]:55874 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhLOT4W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 14:56:22 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 11EDC625D0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2021 20:53:53 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] src: add ruleset optimization infrastructure
Date:   Wed, 15 Dec 2021 20:56:13 +0100
Message-Id: <20211215195615.139902-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215195615.139902-1-pablo@netfilter.org>
References: <20211215195615.139902-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a new -o/--optimize option to enable ruleset
optimization. From libnftables perspective, there is a new API to enable
this feature:

  bool nft_ctx_get_optimize(struct nft_ctx *ctx);
  void nft_ctx_set_optimize(struct nft_ctx *ctx, bool optimize);

The ruleset optimization first loads the ruleset in "dry run" mode to
validate that the original ruleset is correct. Then, on a second pass it
performs the ruleset optimization before adding the rules into the
kernel.

This infrastructure collects the statements that are used in rules, then
it builds a matrix of rules vs. statements. Then, look for common
statements in consecutive rules. Finally, merge rules.

This patch adds support for the first optimization: Collapse a linear
list of rules matching on a single selector into a set, which transforms:

  ip daddr 192.168.0.1 counter accept
  ip daddr 192.168.0.2 counter accept
  ip daddr 192.168.0.3 counter accept

into:

  ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } counter packets 0 bytes 0 accept

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h             |   4 +
 include/nftables/libnftables.h |   5 +
 src/Makefile.am                |   1 +
 src/libnftables.c              |  41 +++-
 src/libnftables.map            |   5 +
 src/main.c                     |   9 +-
 src/optimize.c                 | 377 +++++++++++++++++++++++++++++++++
 7 files changed, 439 insertions(+), 3 deletions(-)
 create mode 100644 src/optimize.c

diff --git a/include/nftables.h b/include/nftables.h
index 7b6339053b54..271a2d1a5e67 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -121,6 +121,7 @@ struct nft_ctx {
 	unsigned int		debug_mask;
 	struct output_ctx	output;
 	bool			check;
+	bool			optimize;
 	struct nft_cache	cache;
 	uint32_t		flags;
 	struct parser_state	*state;
@@ -222,6 +223,9 @@ int nft_print(struct output_ctx *octx, const char *fmt, ...)
 int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
 	__attribute__((format(printf, 2, 0)));
 
+int nft_optimize(struct nft_ctx *nft, struct list_head *cmds,
+		 struct list_head *msgs);
+
 #define __NFT_OUTPUT_NOTSUPP	UINT_MAX
 
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 957b5fbee243..2e7ed8bf9993 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -41,6 +41,9 @@ void nft_ctx_free(struct nft_ctx *ctx);
 bool nft_ctx_get_dry_run(struct nft_ctx *ctx);
 void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
 
+bool nft_ctx_get_optimize(struct nft_ctx *ctx);
+void nft_ctx_set_optimize(struct nft_ctx *ctx, bool optimize);
+
 enum {
 	NFT_CTX_OUTPUT_REVERSEDNS	= (1 << 0),
 	NFT_CTX_OUTPUT_SERVICE		= (1 << 1),
@@ -85,6 +88,8 @@ void nft_ctx_clear_vars(struct nft_ctx *ctx);
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
 
+int nft_optimize_from_filename(struct nft_ctx *nft, const char *filename);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 01c12c81bce7..c4556de5bd8b 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -70,6 +70,7 @@ libnftables_la_SOURCES =			\
 		mnl.c				\
 		iface.c				\
 		mergesort.c			\
+		optimize.c			\
 		osf.c				\
 		nfnl_osf.c			\
 		tcpopt.c			\
diff --git a/src/libnftables.c b/src/libnftables.c
index 7b9d7efaeaae..39537f4f7eae 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -395,6 +395,18 @@ void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry)
 	ctx->check = dry;
 }
 
+EXPORT_SYMBOL(nft_ctx_get_optimize);
+bool nft_ctx_get_optimize(struct nft_ctx *ctx)
+{
+	return ctx->optimize;
+}
+
+EXPORT_SYMBOL(nft_ctx_set_optimize);
+void nft_ctx_set_optimize(struct nft_ctx *ctx, bool optimize)
+{
+	ctx->optimize = optimize;
+}
+
 EXPORT_SYMBOL(nft_ctx_output_get_flags);
 unsigned int nft_ctx_output_get_flags(struct nft_ctx *ctx)
 {
@@ -593,8 +605,7 @@ retry:
 	return rc;
 }
 
-EXPORT_SYMBOL(nft_run_cmd_from_filename);
-int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
+static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
 	struct cmd *cmd, *next;
 	int rc, parser_rc;
@@ -616,6 +627,9 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 
 	parser_rc = rc;
 
+	if (nft->optimize)
+		nft_optimize(nft, &cmds, &msgs);
+
 	rc = nft_evaluate(nft, &msgs, &cmds);
 	if (rc < 0)
 		goto err;
@@ -658,3 +672,26 @@ err:
 		nft_cache_release(&nft->cache);
 	return rc;
 }
+
+EXPORT_SYMBOL(nft_run_cmd_from_filename);
+int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
+{
+	bool check;
+	int ret;
+
+	if (nft->optimize) {
+		check = nft->check;
+		nft->check = true;
+		nft->optimize = false;
+
+		/* First make sure the existing ruleset loads fine as is. */
+		ret = __nft_run_cmd_from_filename(nft, filename);
+		if (ret < 0)
+			return ret;
+
+		nft->check = check;
+		nft->optimize = true;
+	}
+
+	return __nft_run_cmd_from_filename(nft, filename);
+}
diff --git a/src/libnftables.map b/src/libnftables.map
index d3a795ce8567..a511dd789154 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -28,3 +28,8 @@ LIBNFTABLES_2 {
   nft_ctx_add_var;
   nft_ctx_clear_vars;
 } LIBNFTABLES_1;
+
+LIBNFTABLES_3 {
+  nft_set_optimize;
+  nft_get_optimize;
+} LIBNFTABLES_2;
diff --git a/src/main.c b/src/main.c
index 5847fc4ad514..fa9315cbdd66 100644
--- a/src/main.c
+++ b/src/main.c
@@ -36,7 +36,8 @@ enum opt_indices {
 	IDX_INTERACTIVE,
         IDX_INCLUDEPATH,
 	IDX_CHECK,
-#define IDX_RULESET_INPUT_END	IDX_CHECK
+	IDX_OPTIMIZE,
+#define IDX_RULESET_INPUT_END	IDX_OPTIMIZE
         /* Ruleset list formatting */
         IDX_HANDLE,
 #define IDX_RULESET_LIST_START	IDX_HANDLE
@@ -80,6 +81,7 @@ enum opt_vals {
 	OPT_NUMERIC_PROTO	= 'p',
 	OPT_NUMERIC_TIME	= 'T',
 	OPT_TERSE		= 't',
+	OPT_OPTIMIZE		= 'o',
 	OPT_INVALID		= '?',
 };
 
@@ -136,6 +138,8 @@ static const struct nft_opt nft_options[] = {
 				     "Format output in JSON"),
 	[IDX_DEBUG]	    = NFT_OPT("debug",			OPT_DEBUG,		"<level [,level...]>",
 				     "Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)"),
+	[IDX_OPTIMIZE]	    = NFT_OPT("optimize",		OPT_OPTIMIZE,		NULL,
+				     "Optimize ruleset"),
 };
 
 #define NR_NFT_OPTIONS (sizeof(nft_options) / sizeof(nft_options[0]))
@@ -484,6 +488,9 @@ int main(int argc, char * const *argv)
 		case OPT_TERSE:
 			output_flags |= NFT_CTX_OUTPUT_TERSE;
 			break;
+		case OPT_OPTIMIZE:
+			nft_ctx_set_optimize(nft, true);
+			break;
 		case OPT_INVALID:
 			exit(EXIT_FAILURE);
 		}
diff --git a/src/optimize.c b/src/optimize.c
new file mode 100644
index 000000000000..c30000bd2397
--- /dev/null
+++ b/src/optimize.c
@@ -0,0 +1,377 @@
+/*
+ * Copyright (c) 2021 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
+#include <string.h>
+#include <errno.h>
+#include <libmnl/libmnl.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <stdlib.h>
+#include <inttypes.h>
+#include <nftables.h>
+#include <parser.h>
+#include <netlink.h>
+#include <mnl.h>
+#include <expression.h>
+#include <statement.h>
+#include <gmputil.h>
+#include <utils.h>
+#include <erec.h>
+#include <iface.h>
+
+#define MAX_STMTS	12
+
+struct optimize_ctx {
+	struct stmt *stmt[MAX_STMTS];
+	uint32_t num_stmts;
+
+	struct stmt ***stmt_matrix;
+	struct rule **rule;
+	uint32_t num_rules;
+};
+
+static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
+{
+	struct expr *expr_a, *expr_b;
+
+	if (stmt_a->ops->type != stmt_b->ops->type)
+		return false;
+
+	switch (stmt_a->ops->type) {
+	case STMT_EXPRESSION:
+		expr_a = stmt_a->expr;
+		expr_b = stmt_b->expr;
+
+		if (expr_a->left->etype != expr_b->left->etype)
+			return false;
+
+		switch (expr_a->left->etype) {
+		case EXPR_PAYLOAD:
+			if (expr_a->left->payload.desc != expr_b->left->payload.desc)
+				return false;
+			if (expr_a->left->payload.tmpl != expr_b->left->payload.tmpl)
+				return false;
+			break;
+		case EXPR_EXTHDR:
+			if (expr_a->left->exthdr.desc != expr_b->left->exthdr.desc)
+				return false;
+			if (expr_a->left->exthdr.tmpl != expr_b->left->exthdr.tmpl)
+				return false;
+			break;
+		case EXPR_META:
+			if (expr_a->left->meta.key != expr_b->left->meta.key)
+				return false;
+			if (expr_a->left->meta.base != expr_b->left->meta.base)
+				return false;
+			break;
+		case EXPR_CT:
+			if (expr_a->left->ct.key != expr_b->left->ct.key)
+				return false;
+			if (expr_a->left->ct.base != expr_b->left->ct.base)
+				return false;
+			if (expr_a->left->ct.direction != expr_b->left->ct.direction)
+				return false;
+			if (expr_a->left->ct.nfproto != expr_b->left->ct.nfproto)
+				return false;
+			break;
+		case EXPR_RT:
+			if (expr_a->left->rt.key != expr_b->left->rt.key)
+				return false;
+			break;
+		case EXPR_SOCKET:
+			if (expr_a->left->socket.key != expr_b->left->socket.key)
+				return false;
+			if (expr_a->left->socket.level != expr_b->left->socket.level)
+				return false;
+			break;
+		default:
+			return false;
+		}
+		break;
+	case STMT_COUNTER:
+		break;
+	case STMT_VERDICT:
+		expr_a = stmt_a->expr;
+		expr_b = stmt_b->expr;
+		if (expr_a->verdict != expr_b->verdict)
+			return false;
+		if (expr_a->chain && expr_b->chain) {
+			if (expr_a->chain->etype != expr_b->chain->etype)
+				return false;
+			if (expr_a->chain->etype == EXPR_VALUE &&
+			    strcmp(expr_a->chain->identifier, expr_b->chain->identifier))
+				return false;
+		} else if (expr_a->chain || expr_b->chain) {
+			return false;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return true;
+}
+
+static bool stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
+{
+	if (!stmt_a && !stmt_b)
+		return true;
+	else if (!stmt_a)
+		return false;
+	else if (!stmt_b)
+		return false;
+
+	return __stmt_type_eq(stmt_a, stmt_b);
+}
+
+static bool stmt_type_find(struct optimize_ctx *ctx, const struct stmt *stmt)
+{
+	uint32_t i;
+
+	for (i = 0; i < ctx->num_stmts; i++) {
+		if (__stmt_type_eq(stmt, ctx->stmt[i]))
+			return true;
+	}
+
+	return false;
+}
+
+static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
+{
+	struct stmt *stmt;
+
+	list_for_each_entry(stmt, &rule->stmts, list) {
+		if (stmt_type_find(ctx, stmt))
+			continue;
+
+		ctx->stmt[ctx->num_stmts++] = stmt;
+		if (ctx->num_stmts >= MAX_STMTS)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int cmd_stmt_find_in_stmt_matrix(struct optimize_ctx *ctx, struct stmt *stmt)
+{
+	uint32_t i;
+
+	for (i = 0; i < ctx->num_stmts; i++) {
+		if (__stmt_type_eq(stmt, ctx->stmt[i]))
+			return i;
+	}
+	/* should not ever happen. */
+	return 0;
+}
+
+static void rule_build_stmt_matrix_stmts(struct optimize_ctx *ctx,
+					 struct rule *rule, uint32_t *i)
+{
+	struct stmt *stmt;
+	int k;
+
+	list_for_each_entry(stmt, &rule->stmts, list) {
+		k = cmd_stmt_find_in_stmt_matrix(ctx, stmt);
+		ctx->stmt_matrix[*i][k] = stmt;
+	}
+	ctx->rule[(*i)++] = rule;
+}
+
+struct merge {
+	/* interval of rules to be merged */
+	uint32_t	rule_from;
+	uint32_t	num_rules;
+	/* statements to be merged (index relative to statement matrix) */
+	uint32_t	stmt[MAX_STMTS];
+	uint32_t	num_stmts;
+};
+
+static void merge_stmts(const struct optimize_ctx *ctx,
+			uint32_t from, uint32_t to, const struct merge *merge)
+{
+	struct stmt *stmt_a = ctx->stmt_matrix[from][merge->stmt[0]];
+	struct expr *expr_a, *expr_b, *set, *elem;
+	struct stmt *stmt_b;
+	uint32_t x;
+
+	assert (stmt_a->ops->type == STMT_EXPRESSION);
+
+	expr_a = stmt_a->expr->right;
+	set = set_expr_alloc(&internal_location, NULL);
+	elem = set_elem_expr_alloc(&internal_location, expr_get(expr_a));
+	compound_expr_add(set, elem);
+
+	for (x = from + 1; x <= to; x++) {
+		stmt_b = ctx->stmt_matrix[x][merge->stmt[0]];
+		expr_b = stmt_b->expr->right;
+		elem = set_elem_expr_alloc(&internal_location, expr_get(expr_b));
+		compound_expr_add(set, elem);
+	}
+
+	expr_free(stmt_a->expr->right);
+	stmt_a->expr->right = set;
+}
+
+static void merge_rules(const struct optimize_ctx *ctx,
+			uint32_t from, uint32_t to,
+			const struct merge *merge)
+{
+	uint32_t x;
+
+	if (merge->num_stmts > 1) {
+		return;
+	} else {
+		merge_stmts(ctx, from, to, merge);
+	}
+	for (x = from + 1; x <= to; x++) {
+		list_del(&ctx->rule[x]->list);
+		rule_free(ctx->rule[x]);
+	}
+}
+
+static bool rules_eq(const struct optimize_ctx *ctx, int i, int j)
+{
+	uint32_t k;
+
+	for (k = 0; k < ctx->num_stmts; k++) {
+		if (!stmt_type_eq(ctx->stmt_matrix[i][k], ctx->stmt_matrix[j][k]))
+			return false;
+	}
+
+	return true;
+}
+
+static int chain_optimize(struct nft_ctx *nft, struct list_head *rules,
+			  struct list_head *msgs)
+{
+	struct optimize_ctx *ctx;
+	uint32_t num_merges = 0;
+	struct merge *merge;
+	uint32_t i, j, m, k;
+	struct rule *rule;
+	int ret;
+
+	ctx = xzalloc(sizeof(*ctx));
+
+	/* Step 1: collect statements in rules */
+	list_for_each_entry(rule, rules, list) {
+		ret = rule_collect_stmts(ctx, rule);
+		if (ret < 0)
+			goto err;
+
+		ctx->num_rules++;
+	}
+
+	ctx->rule = xzalloc(sizeof(ctx->rule) * ctx->num_rules);
+	ctx->stmt_matrix = xzalloc(sizeof(struct stmt *) * ctx->num_rules);
+	for (i = 0; i < ctx->num_rules; i++)
+		ctx->stmt_matrix[i] = xzalloc(sizeof(struct stmt *) * MAX_STMTS);
+
+	merge = xzalloc(sizeof(*merge) * ctx->num_rules);
+
+	/* Step 2: Build matrix of statements */
+	i = 0;
+	list_for_each_entry(rule, rules, list)
+		rule_build_stmt_matrix_stmts(ctx, rule, &i);
+
+	/* Step 3: Look for common selectors for possible rule mergers */
+	for (i = 0; i < ctx->num_rules; i++) {
+		for (j = i + 1; j < ctx->num_rules; j++) {
+			if (!rules_eq(ctx, i, j)) {
+				if (merge[num_merges].num_rules > 0)
+					num_merges++;
+
+				i = j - 1;
+				break;
+			}
+			if (merge[num_merges].num_rules > 0) {
+				merge[num_merges].num_rules++;
+			} else {
+				merge[num_merges].rule_from = i;
+				merge[num_merges].num_rules = 2;
+			}
+		}
+		if (j == ctx->num_rules && merge[num_merges].num_rules > 0) {
+			num_merges++;
+			break;
+		}
+	}
+
+	/* Step 4: Infer how to merge the candidate rules */
+	for (k = 0; k < num_merges; k++) {
+		i = merge[k].rule_from;
+		j = merge[k].num_rules - 1;
+
+		for (m = 0; m < ctx->num_stmts; m++) {
+			if (!ctx->stmt_matrix[i][m])
+				continue;
+			switch (ctx->stmt_matrix[i][m]->ops->type) {
+			case STMT_EXPRESSION:
+				merge[k].stmt[merge[k].num_stmts++] = m;
+				break;
+			default:
+				break;
+			}
+		}
+
+		merge_rules(ctx, i, i + j, &merge[k]);
+	}
+	ret = 0;
+err:
+	for (i = 0; i < ctx->num_rules; i++)
+		xfree(ctx->stmt_matrix[i]);
+
+	xfree(ctx->stmt_matrix);
+	xfree(ctx->rule);
+	xfree(ctx);
+	xfree(merge);
+
+	return ret;
+}
+
+static int cmd_optimize(struct nft_ctx *nft, struct cmd *cmd,
+			struct list_head *msgs)
+{
+	struct table *table;
+	struct chain *chain;
+	int ret = 0;
+
+	switch (cmd->obj) {
+	case CMD_OBJ_TABLE:
+		table = cmd->table;
+		if (!table)
+			break;
+
+		list_for_each_entry(chain, &table->chains, list)
+			chain_optimize(nft, &chain->rules, msgs);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+int nft_optimize(struct nft_ctx *nft, struct list_head *cmds,
+		 struct list_head *msgs)
+{
+	struct cmd *cmd;
+	int ret;
+
+	list_for_each_entry(cmd, cmds, list) {
+		switch (cmd->op) {
+		case CMD_ADD:
+			ret = cmd_optimize(nft, cmd, msgs);
+			break;
+		default:
+			break;
+		}
+	}
+
+	return ret;
+}
-- 
2.30.2

