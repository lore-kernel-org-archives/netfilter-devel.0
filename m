Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35870C43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 08:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbiFTIch (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 04:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239340AbiFTIcb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 04:32:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD8F512A97
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 01:32:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 13/18] optimize: add unsupported statement
Date:   Mon, 20 Jun 2022 10:32:10 +0200
Message-Id: <20220620083215.1021238-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620083215.1021238-1-pablo@netfilter.org>
References: <20220620083215.1021238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not try to merge rules with unsupported statements. This patch adds a
dummy unsupported statement which is included in the statement
collection and the rule vs statement matrix.

When looking for possible rule mergers, rules using unsupported
statements are discarded, otherwise bogus rule mergers might occur.

Note that __stmt_type_eq() already returns false for unsupported
statements.

Add a test using meta mark statement, which is not yet supported.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 56 +++++++++++++++++--
 .../optimizations/dumps/skip_unsupported.nft  |  7 +++
 .../testcases/optimizations/skip_unsupported  | 14 +++++
 3 files changed, 73 insertions(+), 4 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/skip_unsupported.nft
 create mode 100755 tests/shell/testcases/optimizations/skip_unsupported

diff --git a/src/optimize.c b/src/optimize.c
index abd0b72f90d3..e3d4bc785226 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -301,16 +301,42 @@ static bool stmt_verdict_eq(const struct stmt *stmt_a, const struct stmt *stmt_b
 
 static bool stmt_type_find(struct optimize_ctx *ctx, const struct stmt *stmt)
 {
+	bool unsupported_exists = false;
 	uint32_t i;
 
 	for (i = 0; i < ctx->num_stmts; i++) {
+		if (ctx->stmt[i]->ops->type == STMT_INVALID)
+			unsupported_exists = true;
+
 		if (__stmt_type_eq(stmt, ctx->stmt[i], false))
 			return true;
 	}
 
+	switch (stmt->ops->type) {
+	case STMT_EXPRESSION:
+	case STMT_VERDICT:
+	case STMT_COUNTER:
+	case STMT_NOTRACK:
+	case STMT_LIMIT:
+	case STMT_LOG:
+	case STMT_NAT:
+	case STMT_REJECT:
+		break;
+	default:
+		/* add unsupported statement only once to statement matrix. */
+		if (unsupported_exists)
+			return true;
+		break;
+	}
+
 	return false;
 }
 
+static struct stmt_ops unsupported_stmt_ops = {
+	.type	= STMT_INVALID,
+	.name	= "unsupported",
+};
+
 static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 {
 	struct stmt *stmt, *clone;
@@ -357,8 +383,8 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 			clone->reject.family = stmt->reject.family;
 			break;
 		default:
-			xfree(clone);
-			continue;
+			clone->ops = &unsupported_stmt_ops;
+			break;
 		}
 
 		ctx->stmt[ctx->num_stmts++] = clone;
@@ -369,6 +395,18 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 	return 0;
 }
 
+static int unsupported_in_stmt_matrix(const struct optimize_ctx *ctx)
+{
+	uint32_t i;
+
+	for (i = 0; i < ctx->num_stmts; i++) {
+		if (ctx->stmt[i]->ops->type == STMT_INVALID)
+			return i;
+	}
+	/* this should not happen. */
+	return -1;
+}
+
 static int cmd_stmt_find_in_stmt_matrix(struct optimize_ctx *ctx, struct stmt *stmt)
 {
 	uint32_t i;
@@ -377,10 +415,14 @@ static int cmd_stmt_find_in_stmt_matrix(struct optimize_ctx *ctx, struct stmt *s
 		if (__stmt_type_eq(stmt, ctx->stmt[i], false))
 			return i;
 	}
-	/* should not ever happen. */
-	return 0;
+
+	return -1;
 }
 
+static struct stmt unsupported_stmt = {
+	.ops	= &unsupported_stmt_ops,
+};
+
 static void rule_build_stmt_matrix_stmts(struct optimize_ctx *ctx,
 					 struct rule *rule, uint32_t *i)
 {
@@ -389,6 +431,12 @@ static void rule_build_stmt_matrix_stmts(struct optimize_ctx *ctx,
 
 	list_for_each_entry(stmt, &rule->stmts, list) {
 		k = cmd_stmt_find_in_stmt_matrix(ctx, stmt);
+		if (k < 0) {
+			k = unsupported_in_stmt_matrix(ctx);
+			assert(k >= 0);
+			ctx->stmt_matrix[*i][k] = &unsupported_stmt;
+			continue;
+		}
 		ctx->stmt_matrix[*i][k] = stmt;
 	}
 	ctx->rule[(*i)++] = rule;
diff --git a/tests/shell/testcases/optimizations/dumps/skip_unsupported.nft b/tests/shell/testcases/optimizations/dumps/skip_unsupported.nft
new file mode 100644
index 000000000000..43b6578dc704
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/skip_unsupported.nft
@@ -0,0 +1,7 @@
+table inet x {
+	chain y {
+		ip saddr 1.2.3.4 tcp dport 80 meta mark set 0x0000000a accept
+		ip saddr 1.2.3.4 tcp dport 81 meta mark set 0x0000000b accept
+		ip saddr . tcp dport { 1.2.3.5 . 81, 1.2.3.5 . 82 } accept
+	}
+}
diff --git a/tests/shell/testcases/optimizations/skip_unsupported b/tests/shell/testcases/optimizations/skip_unsupported
new file mode 100755
index 000000000000..9313c302048c
--- /dev/null
+++ b/tests/shell/testcases/optimizations/skip_unsupported
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table inet x {
+	chain y {
+		ip saddr 1.2.3.4 tcp dport 80 meta mark set 10 accept
+		ip saddr 1.2.3.4 tcp dport 81 meta mark set 11 accept
+		ip saddr 1.2.3.5 tcp dport 81 accept comment \"test\"
+		ip saddr 1.2.3.5 tcp dport 82 accept
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

