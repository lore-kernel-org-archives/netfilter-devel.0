Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7A2C43217
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jan 2022 22:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiABWPG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Jan 2022 17:15:06 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56138 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiABWPC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Jan 2022 17:15:02 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6144363F5D
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Jan 2022 23:12:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v2 4/7] src: add ruleset optimization infrastructure
Date:   Sun,  2 Jan 2022 23:14:49 +0100
Message-Id: <20220102221452.86469-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220102221452.86469-1-pablo@netfilter.org>
References: <20220102221452.86469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a new -o/--optimize option to enable ruleset
optimization.

You can combine this option with the dry run mode (--check) to review
the proposed ruleset updates without actually loading the ruleset, e.g.

 # nft -c -o -f ruleset.test
 Merging:
 ruleset.nft:16:3-37:           ip daddr 192.168.0.1 counter accept
 ruleset.nft:17:3-37:           ip daddr 192.168.0.2 counter accept
 ruleset.nft:18:3-37:           ip daddr 192.168.0.3 counter accept
 into:
        ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } counter packets 0 bytes 0 accept

This infrastructure collects the common statements that are used in
rules, then it builds a matrix of rules vs. statements. Then, it looks
for common statements in consecutive rules which allows to merge rules.

This ruleset optimization always performs an implicit dry run to
validate that the original ruleset is correct. Then, on a second pass,
it performs the ruleset optimization and add the rules into the kernel
(unless --check has been specified by the user).

From libnftables perspective, there is a new API to enable
this feature:

  uint32_t nft_ctx_get_optimize(struct nft_ctx *ctx);
  void nft_ctx_set_optimize(struct nft_ctx *ctx, uint32_t flags);

This patch adds support for the first optimization: Collapse a linear
list of rules matching on a single selector into a set as exposed in the
example above.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.txt                                   |   5 +
 include/nftables.h                            |   3 +
 include/nftables/libnftables.h                |   7 +
 src/Makefile.am                               |   1 +
 src/libnftables.c                             |  71 ++-
 src/libnftables.map                           |   5 +
 src/main.c                                    |   9 +-
 src/optimize.c                                | 473 ++++++++++++++++++
 .../optimizations/dumps/merge_stmts.nft       |   5 +
 .../shell/testcases/optimizations/merge_stmts |  13 +
 10 files changed, 581 insertions(+), 11 deletions(-)
 create mode 100644 src/optimize.c
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_stmts.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_stmts

diff --git a/doc/nft.txt b/doc/nft.txt
index e4ed98241018..7240deaa8100 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -62,6 +62,11 @@ understanding of their meaning. You can get information about options by running
 *--check*::
 	Check commands validity without actually applying the changes.
 
+*-o*::
+*--optimize*::
+	Optimize your ruleset. You can combine this option with '-c' to inspect
+        the proposed optimizations.
+
 .Ruleset list output formatting that modify the output of the list ruleset command:
 
 *-a*::
diff --git a/include/nftables.h b/include/nftables.h
index d6d9b9cc7206..d49eb579dc04 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -123,6 +123,7 @@ struct nft_ctx {
 	bool			check;
 	struct nft_cache	cache;
 	uint32_t		flags;
+	uint32_t		optimize_flags;
 	struct parser_state	*state;
 	void			*scanner;
 	struct scope		*top_scope;
@@ -224,6 +225,8 @@ int nft_print(struct output_ctx *octx, const char *fmt, ...)
 int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
 	__attribute__((format(printf, 2, 0)));
 
+int nft_optimize(struct nft_ctx *nft, struct list_head *cmds);
+
 #define __NFT_OUTPUT_NOTSUPP	UINT_MAX
 
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 957b5fbee243..85e08c9bc98b 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -41,6 +41,13 @@ void nft_ctx_free(struct nft_ctx *ctx);
 bool nft_ctx_get_dry_run(struct nft_ctx *ctx);
 void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
 
+enum nft_optimize_flags {
+	NFT_OPTIMIZE_ENABLED		= 0x1,
+};
+
+uint32_t nft_ctx_get_optimize(struct nft_ctx *ctx);
+void nft_ctx_set_optimize(struct nft_ctx *ctx, uint32_t flags);
+
 enum {
 	NFT_CTX_OUTPUT_REVERSEDNS	= (1 << 0),
 	NFT_CTX_OUTPUT_SERVICE		= (1 << 1),
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
index e76f32eff7ca..bd71ae9e704f 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -395,6 +395,18 @@ void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry)
 	ctx->check = dry;
 }
 
+EXPORT_SYMBOL(nft_ctx_get_optimize);
+uint32_t nft_ctx_get_optimize(struct nft_ctx *ctx)
+{
+	return ctx->optimize_flags;
+}
+
+EXPORT_SYMBOL(nft_ctx_set_optimize);
+void nft_ctx_set_optimize(struct nft_ctx *ctx, uint32_t flags)
+{
+	ctx->optimize_flags = flags;
+}
+
 EXPORT_SYMBOL(nft_ctx_output_get_flags);
 unsigned int nft_ctx_output_get_flags(struct nft_ctx *ctx)
 {
@@ -626,8 +638,7 @@ retry:
 	return rc;
 }
 
-EXPORT_SYMBOL(nft_run_cmd_from_filename);
-int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
+static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
 	struct cmd *cmd, *next;
 	int rc, parser_rc;
@@ -638,13 +649,6 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	if (rc < 0)
 		goto err;
 
-	if (!strcmp(filename, "-"))
-		filename = "/dev/stdin";
-
-	if (!strcmp(filename, "/dev/stdin") &&
-	    !nft_output_json(&nft->output))
-		nft->stdin_buf = stdin_to_buffer();
-
 	rc = -EINVAL;
 	if (nft_output_json(&nft->output))
 		rc = nft_parse_json_filename(nft, filename, &msgs, &cmds);
@@ -653,6 +657,9 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 
 	parser_rc = rc;
 
+	if (nft->optimize_flags)
+		nft_optimize(nft, &cmds);
+
 	rc = nft_evaluate(nft, &msgs, &cmds);
 	if (rc < 0)
 		goto err;
@@ -694,7 +701,51 @@ err:
 	if (rc)
 		nft_cache_release(&nft->cache);
 
+	return rc;
+}
+
+static int nft_run_optimized_file(struct nft_ctx *nft, const char *filename)
+{
+	uint32_t optimize_flags;
+	bool check;
+	int ret;
+
+	check = nft->check;
+	nft->check = true;
+	optimize_flags = nft->optimize_flags;
+	nft->optimize_flags = 0;
+
+	/* First check the original ruleset loads fine as is. */
+	ret = __nft_run_cmd_from_filename(nft, filename);
+	if (ret < 0)
+		return ret;
+
+	nft->check = check;
+	nft->optimize_flags = optimize_flags;
+
+	return __nft_run_cmd_from_filename(nft, filename);
+}
+
+EXPORT_SYMBOL(nft_run_cmd_from_filename);
+int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
+{
+	int ret;
+
+	if (!strcmp(filename, "-"))
+		filename = "/dev/stdin";
+
+	if (!strcmp(filename, "/dev/stdin") &&
+	    !nft_output_json(&nft->output))
+		nft->stdin_buf = stdin_to_buffer();
+
+	if (nft->optimize_flags) {
+		ret = nft_run_optimized_file(nft, filename);
+		xfree(nft->stdin_buf);
+		return ret;
+	}
+
+	ret = __nft_run_cmd_from_filename(nft, filename);
 	xfree(nft->stdin_buf);
 
-	return rc;
+	return ret;
 }
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
index 5847fc4ad514..9bd25db82343 100644
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
+			nft_ctx_set_optimize(nft, 0x1);
+			break;
 		case OPT_INVALID:
 			exit(EXIT_FAILURE);
 		}
diff --git a/src/optimize.c b/src/optimize.c
new file mode 100644
index 000000000000..5ccdbbdd491f
--- /dev/null
+++ b/src/optimize.c
@@ -0,0 +1,473 @@
+/*
+ * Copyright (c) 2021 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
+#define _GNU_SOURCE
+#include <string.h>
+#include <errno.h>
+#include <inttypes.h>
+#include <nftables.h>
+#include <parser.h>
+#include <expression.h>
+#include <statement.h>
+#include <utils.h>
+#include <erec.h>
+
+#define MAX_STMTS	32
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
+	case STMT_NOTRACK:
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
+	case STMT_LIMIT:
+		if (stmt_a->limit.rate != stmt_b->limit.rate ||
+		    stmt_a->limit.unit != stmt_b->limit.unit ||
+		    stmt_a->limit.burst != stmt_b->limit.burst ||
+		    stmt_a->limit.type != stmt_b->limit.type ||
+		    stmt_a->limit.flags != stmt_b->limit.flags)
+			return false;
+		break;
+	case STMT_LOG:
+		if (stmt_a->log.snaplen != stmt_b->log.snaplen ||
+		    stmt_a->log.group != stmt_b->log.group ||
+		    stmt_a->log.qthreshold != stmt_b->log.qthreshold ||
+		    stmt_a->log.level != stmt_b->log.level ||
+		    stmt_a->log.logflags != stmt_b->log.logflags ||
+		    stmt_a->log.flags != stmt_b->log.flags ||
+		    stmt_a->log.prefix->etype != EXPR_VALUE ||
+		    stmt_b->log.prefix->etype != EXPR_VALUE ||
+		    mpz_cmp(stmt_a->log.prefix->value, stmt_b->log.prefix->value))
+			return false;
+		break;
+	case STMT_REJECT:
+		if (stmt_a->reject.expr || stmt_b->reject.expr)
+			return false;
+
+		if (stmt_a->reject.family != stmt_b->reject.family ||
+		    stmt_a->reject.type != stmt_b->reject.type ||
+		    stmt_a->reject.icmp_code != stmt_b->reject.icmp_code)
+			return false;
+		break;
+	default:
+		/* ... Merging anything else is yet unsupported. */
+		return false;
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
+	struct stmt *stmt, *clone;
+
+	list_for_each_entry(stmt, &rule->stmts, list) {
+		if (stmt_type_find(ctx, stmt))
+			continue;
+
+		/* No refcounter available in statement objects, clone it to
+		 * to store in the array of selectors.
+		 */
+		clone = stmt_alloc(&internal_location, stmt->ops);
+		switch (stmt->ops->type) {
+		case STMT_EXPRESSION:
+		case STMT_VERDICT:
+			clone->expr = expr_get(stmt->expr);
+			break;
+		case STMT_COUNTER:
+		case STMT_NOTRACK:
+			break;
+		case STMT_LIMIT:
+			memcpy(&clone->limit, &stmt->limit, sizeof(clone->limit));
+			break;
+		case STMT_LOG:
+			memcpy(&clone->log, &stmt->log, sizeof(clone->log));
+			clone->log.prefix = expr_get(stmt->log.prefix);
+			break;
+		default:
+			break;
+		}
+
+		ctx->stmt[ctx->num_stmts++] = clone;
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
+	uint32_t i;
+
+	assert (stmt_a->ops->type == STMT_EXPRESSION);
+
+	set = set_expr_alloc(&internal_location, NULL);
+	set->set_flags |= NFT_SET_ANONYMOUS;
+
+	expr_a = stmt_a->expr->right;
+	elem = set_elem_expr_alloc(&internal_location, expr_get(expr_a));
+	compound_expr_add(set, elem);
+
+	for (i = from + 1; i <= to; i++) {
+		stmt_b = ctx->stmt_matrix[i][merge->stmt[0]];
+		expr_b = stmt_b->expr->right;
+		elem = set_elem_expr_alloc(&internal_location, expr_get(expr_b));
+		compound_expr_add(set, elem);
+	}
+
+	expr_free(stmt_a->expr->right);
+	stmt_a->expr->right = set;
+}
+
+static void rule_optimize_print(struct output_ctx *octx,
+				const struct rule *rule)
+{
+	const struct location *loc = &rule->location;
+	const struct input_descriptor *indesc = loc->indesc;
+	const char *line;
+	char buf[1024];
+
+	switch (indesc->type) {
+	case INDESC_BUFFER:
+	case INDESC_CLI:
+		line = indesc->data;
+		*strchrnul(line, '\n') = '\0';
+		break;
+	case INDESC_STDIN:
+		line = indesc->data;
+		line += loc->line_offset;
+		*strchrnul(line, '\n') = '\0';
+		break;
+	case INDESC_FILE:
+		line = line_location(indesc, loc, buf, sizeof(buf));
+		break;
+	case INDESC_INTERNAL:
+	case INDESC_NETLINK:
+		break;
+	default:
+		BUG("invalid input descriptor type %u\n", indesc->type);
+	}
+
+	print_location(octx->error_fp, indesc, loc);
+	fprintf(octx->error_fp, "%s\n", line);
+}
+
+static void merge_rules(const struct optimize_ctx *ctx,
+			uint32_t from, uint32_t to,
+			const struct merge *merge,
+			struct output_ctx *octx)
+{
+	uint32_t i;
+
+	if (merge->num_stmts > 1) {
+		return;
+	} else {
+		merge_stmts(ctx, from, to, merge);
+	}
+
+	fprintf(octx->error_fp, "Merging:\n");
+	rule_optimize_print(octx, ctx->rule[from]);
+
+	for (i = from + 1; i <= to; i++) {
+		rule_optimize_print(octx, ctx->rule[i]);
+		list_del(&ctx->rule[i]->list);
+		rule_free(ctx->rule[i]);
+	}
+
+	fprintf(octx->error_fp, "into:\n\t");
+	rule_print(ctx->rule[from], octx);
+	fprintf(octx->error_fp, "\n");
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
+static int chain_optimize(struct nft_ctx *nft, struct list_head *rules)
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
+		j = merge[k].num_rules - 1;
+		merge_rules(ctx, i, i + j, &merge[k], &nft->output);
+	}
+	ret = 0;
+	for (i = 0; i < ctx->num_rules; i++)
+		xfree(ctx->stmt_matrix[i]);
+
+	xfree(ctx->stmt_matrix);
+	xfree(merge);
+err:
+	for (i = 0; i < ctx->num_stmts; i++)
+		stmt_free(ctx->stmt[i]);
+
+	xfree(ctx->rule);
+	xfree(ctx);
+
+	return ret;
+}
+
+static int cmd_optimize(struct nft_ctx *nft, struct cmd *cmd)
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
+		list_for_each_entry(chain, &table->chains, list) {
+			if (chain->flags & CHAIN_F_HW_OFFLOAD)
+				continue;
+
+			chain_optimize(nft, &chain->rules);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+int nft_optimize(struct nft_ctx *nft, struct list_head *cmds)
+{
+	struct cmd *cmd;
+	int ret;
+
+	list_for_each_entry(cmd, cmds, list) {
+		switch (cmd->op) {
+		case CMD_ADD:
+			ret = cmd_optimize(nft, cmd);
+			break;
+		default:
+			break;
+		}
+	}
+
+	return ret;
+}
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts.nft
new file mode 100644
index 000000000000..b56ea3ed4115
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts.nft
@@ -0,0 +1,5 @@
+table ip x {
+	chain y {
+		ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } counter packets 0 bytes 0 accept
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_stmts b/tests/shell/testcases/optimizations/merge_stmts
new file mode 100755
index 000000000000..0c35636efaa9
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_stmts
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	chain y {
+		ip daddr 192.168.0.1 counter accept
+		ip daddr 192.168.0.2 counter accept
+		ip daddr 192.168.0.3 counter accept
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

