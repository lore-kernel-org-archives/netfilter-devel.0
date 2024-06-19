Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D4C12FF63
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 10:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718794619; cv=none; b=RoqAoLSXd0vreVFsm/a/v0n05LGO+DjRF2SLBovcK11dFgAQyF4SS/OY6hotkJclLJb234iyYMM9+9TvGhZmejWPt/rwuRc8ucj+KemTl3i9J3M/2P3zo7kky9Ka8FPn0TpXeLYxTNykQi1lIcwqhq0cgH+1j+eefMvgvij4Tbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718794619; c=relaxed/simple;
	bh=S9V9Rv61aqVsWHIo0bkPTG4AuuoaHdgj0BYwf4rrNr4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type; b=YhMlOpWEIWQmkD87SoxSGTJ8Huuk12m/yYDyBGUFob7LIJhoViPnbNgnz/Vd+21os8FmGQYmbWpYaVm4aGUVAD26B6qdtCLaWSGKgjluJbk1sunsQNga86m1KUGkCWgJ8/VXmfek8Pz95Q5WGXmvwaRoYWKF+v61TzcNx5ZHG1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: add string preprocessor and use it for log prefix string
Date: Wed, 19 Jun 2024 12:56:48 +0200
Message-Id: <20240619105648.165635-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

Add a string preprocessor to identify and replace variables in a string.
Rework existing support to variables in log prefix strings to use it.

Fixes: e76bb3794018 ("src: allow for variables in the log prefix string")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Makefile.am               |   1 +
 include/expression.h      |   2 -
 include/parser.h          |   4 +
 include/statement.h       |   2 +-
 src/evaluate.c            |  45 +---------
 src/expression.c          |   9 --
 src/json.c                |   7 +-
 src/netlink_delinearize.c |   6 +-
 src/netlink_linearize.c   |   7 +-
 src/optimize.c            |   6 +-
 src/parser_bison.y        | 126 ++--------------------------
 src/parser_json.c         |   4 +-
 src/preprocess.c          | 168 ++++++++++++++++++++++++++++++++++++++
 src/statement.c           |  10 +--
 14 files changed, 198 insertions(+), 199 deletions(-)
 create mode 100644 src/preprocess.c

diff --git a/Makefile.am b/Makefile.am
index fef1d8d16321..9088170bfc68 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -232,6 +232,7 @@ src_libnftables_la_SOURCES = \
 	src/osf.c \
 	src/owner.c \
 	src/payload.c \
+	src/preprocess.c \
 	src/print.c \
 	src/proto.c \
 	src/rt.c \
diff --git a/include/expression.h b/include/expression.h
index 01b45b7c83b9..8982110cce95 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -415,8 +415,6 @@ extern const struct datatype *expr_basetype(const struct expr *expr);
 extern void expr_set_type(struct expr *expr, const struct datatype *dtype,
 			  enum byteorder byteorder);
 
-void expr_to_string(const struct expr *expr, char *string);
-
 struct eval_ctx;
 extern int expr_binary_error(struct list_head *msgs,
 			     const struct expr *e1, const struct expr *e2,
diff --git a/include/parser.h b/include/parser.h
index f79a22f306af..576e5e43e688 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -112,4 +112,8 @@ extern void scanner_push_buffer(void *scanner,
 
 extern void scanner_pop_start_cond(void *scanner, enum startcond_type sc);
 
+const char *str_preprocess(struct parser_state *state, struct location *loc,
+			   struct scope *scope, const char *x,
+			   struct error_record **rec);
+
 #endif /* NFTABLES_PARSER_H */
diff --git a/include/statement.h b/include/statement.h
index 662f99ddef79..9376911bb377 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -90,7 +90,7 @@ enum {
 };
 
 struct log_stmt {
-	struct expr		*prefix;
+	const char		*prefix;
 	unsigned int		snaplen;
 	uint16_t		group;
 	uint16_t		qthreshold;
diff --git a/src/evaluate.c b/src/evaluate.c
index 227f5da86382..aa9293a87856 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4440,49 +4440,12 @@ static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	char tmp[NF_LOG_PREFIXLEN] = {};
-	char prefix[NF_LOG_PREFIXLEN];
-	size_t len = sizeof(prefix);
-	size_t offset = 0;
-	struct expr *expr;
-
-	if (stmt->log.prefix->etype != EXPR_LIST) {
-		if (stmt->log.prefix &&
-		    div_round_up(stmt->log.prefix->len, BITS_PER_BYTE) >= NF_LOG_PREFIXLEN)
-			return expr_error(ctx->msgs, stmt->log.prefix, "log prefix is too long");
-
-		return 0;
-	}
-
-	prefix[0] = '\0';
-
-	list_for_each_entry(expr, &stmt->log.prefix->expressions, list) {
-		int ret;
-
-		switch (expr->etype) {
-		case EXPR_VALUE:
-			expr_to_string(expr, tmp);
-			ret = snprintf(prefix + offset, len, "%s", tmp);
-			break;
-		case EXPR_VARIABLE:
-			ret = snprintf(prefix + offset, len, "%s",
-				       expr->sym->expr->identifier);
-			break;
-		default:
-			BUG("unknown expression type %s\n", expr_name(expr));
-			break;
-		}
-		SNPRINTF_BUFFER_SIZE(ret, &len, &offset);
-	}
+	unsigned int len = strlen(stmt->log.prefix);
 
-	if (len == 0)
+	if (len >= NF_LOG_PREFIXLEN)
 		return stmt_error(ctx, stmt, "log prefix is too long");
-
-	expr = constant_expr_alloc(&stmt->log.prefix->location, &string_type,
-				   BYTEORDER_HOST_ENDIAN,
-				   strlen(prefix) * BITS_PER_BYTE, prefix);
-	expr_free(stmt->log.prefix);
-	stmt->log.prefix = expr;
+	else if (len == 0)
+		return stmt_error(ctx, stmt, "log prefix must have a minimum length of 1 character");
 
 	return 0;
 }
diff --git a/src/expression.c b/src/expression.c
index cb2573fec457..992f51064051 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -183,15 +183,6 @@ void expr_describe(const struct expr *expr, struct output_ctx *octx)
 	}
 }
 
-void expr_to_string(const struct expr *expr, char *string)
-{
-	int len = expr->len / BITS_PER_BYTE;
-
-	assert(expr->dtype == &string_type);
-
-	mpz_export_data(string, expr->value, BYTEORDER_HOST_ENDIAN, len);
-}
-
 void expr_set_type(struct expr *expr, const struct datatype *dtype,
 		   enum byteorder byteorder)
 {
diff --git a/src/json.c b/src/json.c
index b4fad0abd4b3..b1531ff3f4c9 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1343,12 +1343,9 @@ json_t *log_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	json_t *root = json_object(), *flags;
 
-	if (stmt->log.flags & STMT_LOG_PREFIX) {
-		char prefix[NF_LOG_PREFIXLEN] = {};
+	if (stmt->log.flags & STMT_LOG_PREFIX)
+		json_object_set_new(root, "prefix", json_string(stmt->log.prefix));
 
-		expr_to_string(stmt->log.prefix, prefix);
-		json_object_set_new(root, "prefix", json_string(prefix));
-	}
 	if (stmt->log.flags & STMT_LOG_GROUP)
 		json_object_set_new(root, "group",
 				    json_integer(stmt->log.group));
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index da9f7a91e4b3..82e68999a432 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1090,11 +1090,7 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 	stmt = log_stmt_alloc(loc);
 	prefix = nftnl_expr_get_str(nle, NFTNL_EXPR_LOG_PREFIX);
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOG_PREFIX)) {
-		stmt->log.prefix = constant_expr_alloc(&internal_location,
-						       &string_type,
-						       BYTEORDER_HOST_ENDIAN,
-						       (strlen(prefix) + 1) * BITS_PER_BYTE,
-						       prefix);
+		stmt->log.prefix = xstrdup(prefix);
 		stmt->log.flags |= STMT_LOG_PREFIX;
 	}
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOG_GROUP)) {
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 6204d8fd2668..a8a717336e78 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1146,12 +1146,9 @@ static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 
 	nle = alloc_nft_expr("log");
-	if (stmt->log.prefix != NULL) {
-		char prefix[NF_LOG_PREFIXLEN] = {};
+	if (stmt->log.prefix != NULL)
+		nftnl_expr_set_str(nle, NFTNL_EXPR_LOG_PREFIX, stmt->log.prefix);
 
-		expr_to_string(stmt->log.prefix, prefix);
-		nftnl_expr_set_str(nle, NFTNL_EXPR_LOG_PREFIX, prefix);
-	}
 	if (stmt->log.flags & STMT_LOG_GROUP) {
 		nftnl_expr_set_u16(nle, NFTNL_EXPR_LOG_GROUP, stmt->log.group);
 		if (stmt->log.flags & STMT_LOG_SNAPLEN)
diff --git a/src/optimize.c b/src/optimize.c
index b90dd995b13e..1dd08586f326 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -215,9 +215,7 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b,
 		if (!stmt_a->log.prefix)
 			return true;
 
-		if (stmt_a->log.prefix->etype != EXPR_VALUE ||
-		    stmt_b->log.prefix->etype != EXPR_VALUE ||
-		    mpz_cmp(stmt_a->log.prefix->value, stmt_b->log.prefix->value))
+		if (strcmp(stmt_a->log.prefix, stmt_b->log.prefix))
 			return false;
 		break;
 	case STMT_REJECT:
@@ -406,7 +404,7 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 		case STMT_LOG:
 			memcpy(&clone->log, &stmt->log, sizeof(clone->log));
 			if (stmt->log.prefix)
-				clone->log.prefix = expr_get(stmt->log.prefix);
+				clone->log.prefix = xstrdup(stmt->log.prefix);
 			break;
 		case STMT_NAT:
 			if ((stmt->nat.addr &&
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 53f45315ef46..f3f71801643d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3372,127 +3372,19 @@ log_args		:	log_arg
 log_arg			:	PREFIX			string
 			{
 				struct scope *scope = current_scope(state);
-				bool done = false, another_var = false;
-				char *start, *end, scratch = '\0';
-				struct expr *expr, *item;
-				struct symbol *sym;
-				enum {
-					PARSE_TEXT,
-					PARSE_VAR,
-				} prefix_state;
-
-				/* No variables in log prefix, skip. */
-				if (!strchr($2, '$')) {
-					expr = constant_expr_alloc(&@$, &string_type,
-								   BYTEORDER_HOST_ENDIAN,
-								   (strlen($2) + 1) * BITS_PER_BYTE, $2);
-					free_const($2);
-					$<stmt>0->log.prefix = expr;
-					$<stmt>0->log.flags |= STMT_LOG_PREFIX;
-					break;
-				}
-
-				/* Parse variables in log prefix string using a
-				 * state machine parser with two states. This
-				 * parser creates list of expressions composed
-				 * of constant and variable expressions.
-				 */
-				expr = compound_expr_alloc(&@$, EXPR_LIST);
-
-				start = (char *)$2;
+				struct error_record *erec;
+				const char *prefix;
 
-				if (*start != '$') {
-					prefix_state = PARSE_TEXT;
-				} else {
-					prefix_state = PARSE_VAR;
-					start++;
-				}
-				end = start;
-
-				/* Not nice, but works. */
-				while (!done) {
-					switch (prefix_state) {
-					case PARSE_TEXT:
-						while (*end != '\0' && *end != '$')
-							end++;
-
-						if (*end == '\0')
-							done = true;
-
-						*end = '\0';
-						item = constant_expr_alloc(&@$, &string_type,
-									   BYTEORDER_HOST_ENDIAN,
-									   (strlen(start) + 1) * BITS_PER_BYTE,
-									   start);
-						compound_expr_add(expr, item);
-
-						if (done)
-							break;
-
-						start = end + 1;
-						end = start;
-
-						/* fall through */
-					case PARSE_VAR:
-						while (isalnum(*end) || *end == '_')
-							end++;
-
-						if (*end == '\0')
-							done = true;
-						else if (*end == '$')
-							another_var = true;
-						else
-							scratch = *end;
-
-						*end = '\0';
-
-						sym = symbol_get(scope, start);
-						if (!sym) {
-							sym = symbol_lookup_fuzzy(scope, start);
-							if (sym) {
-								erec_queue(error(&@2, "unknown identifier '%s'; "
-										 "did you mean identifier ‘%s’?",
-										 start, sym->identifier),
-									   state->msgs);
-							} else {
-								erec_queue(error(&@2, "unknown identifier '%s'",
-										 start),
-									   state->msgs);
-							}
-							expr_free(expr);
-							free_const($2);
-							YYERROR;
-						}
-						item = variable_expr_alloc(&@$, scope, sym);
-						compound_expr_add(expr, item);
-
-						if (done)
-							break;
-
-						/* Restore original byte after
-						 * symbol lookup.
-						 */
-						if (scratch) {
-							*end = scratch;
-							scratch = '\0';
-						}
-
-						start = end;
-						if (another_var) {
-							another_var = false;
-							start++;
-							prefix_state = PARSE_VAR;
-						} else {
-							prefix_state = PARSE_TEXT;
-						}
-						end = start;
-						break;
-					}
+				prefix = str_preprocess(state, &@2, scope, $2, &erec);
+				if (!prefix) {
+					erec_queue(erec, state->msgs);
+					free_const($2);
+					YYERROR;
 				}
 
 				free_const($2);
-				$<stmt>0->log.prefix	 = expr;
-				$<stmt>0->log.flags 	|= STMT_LOG_PREFIX;
+				$<stmt>0->log.prefix = prefix;
+				$<stmt>0->log.flags |= STMT_LOG_PREFIX;
 			}
 			|	GROUP			NUM
 			{
diff --git a/src/parser_json.c b/src/parser_json.c
index 8b7efaf22662..ee4657ee8044 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2565,9 +2565,7 @@ static struct stmt *json_parse_log_stmt(struct json_ctx *ctx,
 	stmt = log_stmt_alloc(int_loc);
 
 	if (!json_unpack(value, "{s:s}", "prefix", &tmpstr)) {
-		stmt->log.prefix = constant_expr_alloc(int_loc, &string_type,
-						       BYTEORDER_HOST_ENDIAN,
-						       (strlen(tmpstr) + 1) * BITS_PER_BYTE, tmpstr);
+		stmt->log.prefix = xstrdup(tmpstr);
 		stmt->log.flags |= STMT_LOG_PREFIX;
 	}
 	if (!json_unpack(value, "{s:i}", "group", &tmp)) {
diff --git a/src/preprocess.c b/src/preprocess.c
new file mode 100644
index 000000000000..619f67a15049
--- /dev/null
+++ b/src/preprocess.c
@@ -0,0 +1,168 @@
+/*
+ * Copyright (c) 2013-2024 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
+#include <ctype.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <string.h>
+#include <utils.h>
+
+#include "list.h"
+#include "parser.h"
+#include "erec.h"
+
+struct str_buf {
+	uint8_t		*str;
+	uint32_t	len;
+	uint32_t	size;
+};
+
+#define STR_BUF_LEN	128
+
+static struct str_buf *str_buf_alloc(void)
+{
+	struct str_buf *buf;
+
+	buf = xzalloc(sizeof(*buf));
+	buf->str = xzalloc_array(1, STR_BUF_LEN);
+	buf->size = STR_BUF_LEN;
+
+	return buf;
+}
+
+static int str_buf_add(struct str_buf *buf, const char *str, uint32_t len)
+{
+	uint8_t *tmp;
+
+	if (len + buf->len > buf->size) {
+		buf->size = (len + buf->len) * 2;
+		tmp = xrealloc(buf->str, buf->size);
+		buf->str = tmp;
+	}
+
+	memcpy(&buf->str[buf->len], str, len);
+	buf->len += len;
+
+	return 0;
+}
+
+struct str_chunk {
+	struct list_head	list;
+	char			*str;
+	uint32_t		len;
+	bool			is_sym;
+};
+
+static void add_str_chunk(const char *x, int from, int to, struct list_head *list, bool is_sym)
+{
+	struct str_chunk *chunk;
+	int len = to - from;
+
+	chunk = xzalloc_array(1, sizeof(*chunk));
+	chunk->str = xzalloc_array(1, len + 1);
+	chunk->is_sym = is_sym;
+	chunk->len = len;
+	memcpy(chunk->str, &x[from], len);
+
+	list_add_tail(&chunk->list, list);
+}
+
+static void free_str_chunk(struct str_chunk *chunk)
+{
+	free(chunk->str);
+	free(chunk);
+}
+
+const char *str_preprocess(struct parser_state *state, struct location *loc,
+			   struct scope *scope, const char *x,
+			   struct error_record **erec)
+{
+	struct str_chunk *chunk, *next;
+	struct str_buf *buf;
+	const char *str;
+	int i, j, start;
+	LIST_HEAD(list);
+
+	start = 0;
+	i = 0;
+	while (1) {
+		if (x[i] == '\0') {
+			i++;
+			break;
+		}
+
+		if (x[i] != '$') {
+			i++;
+			continue;
+		}
+
+		if (isdigit(x[++i]))
+			continue;
+
+		j = i;
+		while (1) {
+			if (isalpha(x[i]) ||
+			    isdigit(x[i]) ||
+			    x[i] == '_') {
+				i++;
+				continue;
+			}
+			break;
+		}
+		add_str_chunk(x, start, j-1, &list, false);
+		add_str_chunk(x, j, i, &list, true);
+		start = i;
+	}
+	if (start != i)
+		add_str_chunk(x, start, i, &list, false);
+
+	buf = str_buf_alloc();
+
+	list_for_each_entry_safe(chunk, next, &list, list) {
+		if (chunk->is_sym) {
+			struct symbol *sym;
+
+			sym = symbol_lookup(scope, chunk->str);
+			if (!sym) {
+				sym = symbol_lookup_fuzzy(scope, chunk->str);
+				if (sym) {
+					*erec = error(loc, "unknown identifier '%s'; "
+							   "did you mean identifier '%s'?",
+					              chunk->str, sym->identifier);
+				} else {
+					*erec = error(loc, "unknown identifier '%s'",
+						      chunk->str);
+				}
+				goto err;
+			}
+			str_buf_add(buf, sym->expr->identifier,
+				    strlen(sym->expr->identifier));
+		} else {
+			str_buf_add(buf, chunk->str, chunk->len);
+		}
+		list_del(&chunk->list);
+		free_str_chunk(chunk);
+	}
+
+	str = (char *)buf->str;
+
+	free(buf);
+
+	return (char *)str;
+err:
+	list_for_each_entry_safe(chunk, next, &list, list) {
+		list_del(&chunk->list);
+		free_str_chunk(chunk);
+	}
+	free(buf->str);
+	free(buf);
+
+	return NULL;
+}
diff --git a/src/statement.c b/src/statement.c
index ab144d639318..551cd13fa04e 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -377,12 +377,8 @@ int log_level_parse(const char *level)
 static void log_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	nft_print(octx, "log");
-	if (stmt->log.flags & STMT_LOG_PREFIX) {
-		char prefix[NF_LOG_PREFIXLEN] = {};
-
-		expr_to_string(stmt->log.prefix, prefix);
-		nft_print(octx, " prefix \"%s\"", prefix);
-	}
+	if (stmt->log.flags & STMT_LOG_PREFIX)
+		nft_print(octx, " prefix \"%s\"", stmt->log.prefix);
 	if (stmt->log.flags & STMT_LOG_GROUP)
 		nft_print(octx, " group %u", stmt->log.group);
 	if (stmt->log.flags & STMT_LOG_SNAPLEN)
@@ -419,7 +415,7 @@ static void log_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 
 static void log_stmt_destroy(struct stmt *stmt)
 {
-	expr_free(stmt->log.prefix);
+	free_const(stmt->log.prefix);
 }
 
 static const struct stmt_ops log_stmt_ops = {
-- 
2.30.2

