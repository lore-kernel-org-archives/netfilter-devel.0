Return-Path: <SRS0=D3ak=AT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF94C433E2
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 09:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 126E52065C
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 09:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgGHJ1V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 05:27:21 -0400
Received: from correo.us.es ([193.147.175.20]:42774 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgGHJ1V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 05:27:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D53FAEB463
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2020 11:27:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2B83DA3A3
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2020 11:27:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B7B3FDA3AA; Wed,  8 Jul 2020 11:27:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59E52DA3A9
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2020 11:27:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 11:27:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3739D42EF42A
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2020 11:27:15 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] src: allow for variables in the log prefix string
Date:   Wed,  8 Jul 2020 11:27:07 +0200
Message-Id: <20200708092707.21405-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708092707.21405-1-pablo@netfilter.org>
References: <20200708092707.21405-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For example:

 define test = "state"
 define foo = "match"

 table x {
        chain y {
                ct state invalid log prefix "invalid $test $foo:"
        }
 }

This patch scans for variables in the log prefix string. The log prefix
expression is a list of constant and variable expression that are
converted into a constant expression from the evaluation phase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                |  49 ++++++-
 src/parser_bison.y                            | 122 +++++++++++++++++-
 .../optionals/dumps/log_prefix_0.nft          |   5 +
 tests/shell/testcases/optionals/log_prefix_0  |  16 +++
 4 files changed, 187 insertions(+), 5 deletions(-)
 create mode 100644 tests/shell/testcases/optionals/dumps/log_prefix_0.nft
 create mode 100755 tests/shell/testcases/optionals/log_prefix_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 640a7d465bae..d3368bacc6af 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -19,6 +19,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_synproxy.h>
 #include <linux/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_log.h>
 #include <linux/netfilter_ipv4.h>
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
@@ -3203,8 +3204,50 @@ static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	char prefix[NF_LOG_PREFIXLEN] = {}, tmp[NF_LOG_PREFIXLEN] = {};
+	int len = sizeof(prefix), offset = 0, ret;
+	struct expr *expr;
+	size_t size = 0;
+
+	if (stmt->log.prefix->etype != EXPR_LIST)
+		return 0;
+
+	list_for_each_entry(expr, &stmt->log.prefix->expressions, list) {
+		switch (expr->etype) {
+		case EXPR_VALUE:
+			expr_to_string(expr, tmp);
+			ret = snprintf(prefix + offset, len, "%s", tmp);
+			break;
+		case EXPR_VARIABLE:
+			ret = snprintf(prefix + offset, len, "%s",
+				       expr->sym->expr->identifier);
+			break;
+		default:
+			BUG("unknown expresion type %s\n", expr_name(expr));
+			break;
+		}
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (len == NF_LOG_PREFIXLEN)
+		return stmt_error(ctx, stmt, "log prefix is too long");
+
+	expr_free(stmt->log.prefix);
+
+	stmt->log.prefix =
+		constant_expr_alloc(&stmt->log.prefix->location, &string_type,
+				    BYTEORDER_HOST_ENDIAN,
+				    strlen(prefix) * BITS_PER_BYTE,
+				    prefix);
+	return 0;
+}
+
 static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	int ret = 0;
+
 	if (stmt->log.flags & (STMT_LOG_GROUP | STMT_LOG_SNAPLEN |
 			       STMT_LOG_QTHRESHOLD)) {
 		if (stmt->log.flags & STMT_LOG_LEVEL)
@@ -3218,7 +3261,11 @@ static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 	    (stmt->log.flags & ~STMT_LOG_LEVEL || stmt->log.logflags))
 		return stmt_error(ctx, stmt,
 				  "log level audit doesn't support any further options");
-	return 0;
+
+	if (stmt->log.prefix)
+		ret = stmt_evaluate_log_prefix(ctx, stmt);
+
+	return ret;
 }
 
 static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2fecc3472fba..face99507b82 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2636,11 +2636,125 @@ log_args		:	log_arg
 
 log_arg			:	PREFIX			string
 			{
-				struct expr *expr;
+				struct scope *scope = current_scope(state);
+				bool done = false, another_var = false;
+				char *start, *end, scratch = '\0';
+				struct expr *expr, *item;
+				struct symbol *sym;
+				enum {
+					PARSE_TEXT,
+					PARSE_VAR,
+				} prefix_state;
+
+				/* No variables in log prefix, skip. */
+				if (!strchr($2, '$')) {
+					expr = constant_expr_alloc(&@$, &string_type,
+								   BYTEORDER_HOST_ENDIAN,
+								   (strlen($2) + 1) * BITS_PER_BYTE, $2);
+					$<stmt>0->log.prefix = expr;
+					$<stmt>0->log.flags |= STMT_LOG_PREFIX;
+					break;
+				}
 
-				expr = constant_expr_alloc(&@$, &string_type,
-							   BYTEORDER_HOST_ENDIAN,
-							   strlen($2) * BITS_PER_BYTE, $2);
+				/* Parse variables in log prefix string using a
+				 * state machine parser with two states. This
+				 * parser creates list of expressions composed
+				 * of constant and variable expressions.
+				 */
+				expr = compound_expr_alloc(&@$, EXPR_LIST);
+
+				start = (char *)$2;
+
+				if (*start != '$') {
+					prefix_state = PARSE_TEXT;
+				} else {
+					prefix_state = PARSE_VAR;
+					start++;
+				}
+				end = start;
+
+				/* Not nice, but works. */
+				while (!done) {
+					switch (prefix_state) {
+					case PARSE_TEXT:
+						while (*end != '\0' && *end != '$')
+							end++;
+
+						if (*end == '\0')
+							done = true;
+
+						*end = '\0';
+						item = constant_expr_alloc(&@$, &string_type,
+									   BYTEORDER_HOST_ENDIAN,
+									   (strlen(start) + 1) * BITS_PER_BYTE,
+									   start);
+						compound_expr_add(expr, item);
+
+						if (done)
+							break;
+
+						start = end + 1;
+						end = start;
+
+						/* fall through */
+					case PARSE_VAR:
+						while (isalnum(*end) || *end == '_')
+							end++;
+
+						if (*end == '\0')
+							done = true;
+						else if (*end == '$')
+							another_var = true;
+						else
+							scratch = *end;
+
+						*end = '\0';
+
+						sym = symbol_get(scope, start);
+						if (!sym) {
+							sym = symbol_lookup_fuzzy(scope, start);
+							if (sym) {
+								erec_queue(error(&@2, "unknown identifier '%s'; "
+										 "did you mean identifier ‘%s’?",
+										 start, sym->identifier),
+									   state->msgs);
+							} else {
+								erec_queue(error(&@2, "unknown identifier '%s'",
+										 start),
+									   state->msgs);
+							}
+							expr_free(expr);
+							xfree($2);
+							YYERROR;
+						}
+						item = variable_expr_alloc(&@$, scope, sym);
+						compound_expr_add(expr, item);
+
+						if (done)
+							break;
+
+						/* Restore original byte after
+						 * symbol lookup.
+						 */
+						if (scratch) {
+							*end = scratch;
+							scratch = '\0';
+						}
+
+						start = end;
+						if (another_var) {
+							another_var = false;
+							start++;
+							prefix_state = PARSE_VAR;
+						} else {
+							prefix_state = PARSE_TEXT;
+						}
+						end = start;
+						break;
+					}
+				}
+
+				xfree($2);
 				$<stmt>0->log.prefix	 = expr;
 				$<stmt>0->log.flags 	|= STMT_LOG_PREFIX;
 			}
diff --git a/tests/shell/testcases/optionals/dumps/log_prefix_0.nft b/tests/shell/testcases/optionals/dumps/log_prefix_0.nft
new file mode 100644
index 000000000000..8c11d697f9f2
--- /dev/null
+++ b/tests/shell/testcases/optionals/dumps/log_prefix_0.nft
@@ -0,0 +1,5 @@
+table ip x {
+	chain y {
+		ct state invalid log prefix "invalid state match, logging:"
+	}
+}
diff --git a/tests/shell/testcases/optionals/log_prefix_0 b/tests/shell/testcases/optionals/log_prefix_0
new file mode 100755
index 000000000000..513a9e74b92e
--- /dev/null
+++ b/tests/shell/testcases/optionals/log_prefix_0
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+set -e
+
+TMP=$(mktemp)
+
+RULESET='define test = "state"
+define foo = "match, logging"
+
+table x {
+        chain y {
+                ct state invalid log prefix "invalid $test $foo:"
+        }
+}'
+
+$NFT -f - <<< "$RULESET"
-- 
2.20.1

