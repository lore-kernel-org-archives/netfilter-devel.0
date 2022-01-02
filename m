Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8168C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jan 2022 22:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiABWPF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Jan 2022 17:15:05 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56142 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiABWPD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Jan 2022 17:15:03 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id D737663F5E
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Jan 2022 23:12:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v2 5/7] optimize: merge rules with same selectors into a concatenation
Date:   Sun,  2 Jan 2022 23:14:50 +0100
Message-Id: <20220102221452.86469-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220102221452.86469-1-pablo@netfilter.org>
References: <20220102221452.86469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch extends the ruleset optimization infrastructure to collapse
several rules with the same selectors into a concatenation.

Transform:

  meta iifname eth1 ip saddr 1.1.1.1 ip daddr 2.2.2.3 accept
  meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.5 accept
  meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.6 accept

into:

  meta iifname . ip saddr . ip daddr { eth1 . 1.1.1.1 . 2.2.2.6, eth1 . 1.1.1.2 . 2.2.2.5 , eth1 . 1.1.1.3 . 2.2.2.6 } accept

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 44 ++++++++++++++++++-
 .../dumps/merge_stmts_concat.nft              |  5 +++
 .../optimizations/merge_stmts_concat          | 13 ++++++
 3 files changed, 61 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_stmts_concat

diff --git a/src/optimize.c b/src/optimize.c
index 5ccdbbdd491f..aaf29c88af75 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -266,6 +266,48 @@ static void merge_stmts(const struct optimize_ctx *ctx,
 	stmt_a->expr->right = set;
 }
 
+static void merge_concat_stmts(const struct optimize_ctx *ctx,
+			       uint32_t from, uint32_t to,
+			       const struct merge *merge)
+{
+	struct expr *concat, *elem, *set;
+	struct stmt *stmt, *stmt_a;
+	uint32_t i, k;
+
+	stmt = ctx->stmt_matrix[from][merge->stmt[0]];
+	/* build concatenation of selectors, eg. ifname . ip daddr . tcp dport */
+	concat = concat_expr_alloc(&internal_location);
+
+	for (k = 0; k < merge->num_stmts; k++) {
+		stmt_a = ctx->stmt_matrix[from][merge->stmt[k]];
+		compound_expr_add(concat, expr_get(stmt_a->expr->left));
+	}
+	expr_free(stmt->expr->left);
+	stmt->expr->left = concat;
+
+	/* build set data contenation, eg. { eth0 . 1.1.1.1 . 22 } */
+	set = set_expr_alloc(&internal_location, NULL);
+	set->set_flags |= NFT_SET_ANONYMOUS;
+
+	for (i = from; i <= to; i++) {
+		concat = concat_expr_alloc(&internal_location);
+		for (k = 0; k < merge->num_stmts; k++) {
+			stmt_a = ctx->stmt_matrix[i][merge->stmt[k]];
+			compound_expr_add(concat, expr_get(stmt_a->expr->right));
+		}
+		elem = set_elem_expr_alloc(&internal_location, concat);
+		compound_expr_add(set, elem);
+	}
+	expr_free(stmt->expr->right);
+	stmt->expr->right = set;
+
+	for (k = 1; k < merge->num_stmts; k++) {
+		stmt_a = ctx->stmt_matrix[from][merge->stmt[k]];
+		list_del(&stmt_a->list);
+		stmt_free(stmt_a);
+	}
+}
+
 static void rule_optimize_print(struct output_ctx *octx,
 				const struct rule *rule)
 {
@@ -307,7 +349,7 @@ static void merge_rules(const struct optimize_ctx *ctx,
 	uint32_t i;
 
 	if (merge->num_stmts > 1) {
-		return;
+		merge_concat_stmts(ctx, from, to, merge);
 	} else {
 		merge_stmts(ctx, from, to, merge);
 	}
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
new file mode 100644
index 000000000000..6dbfff2e15fc
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
@@ -0,0 +1,5 @@
+table ip x {
+	chain y {
+		iifname . ip saddr . ip daddr { "eth1" . 1.1.1.1 . 2.2.2.3, "eth1" . 1.1.1.2 . 2.2.2.4, "eth2" . 1.1.1.3 . 2.2.2.5 } accept
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_stmts_concat b/tests/shell/testcases/optimizations/merge_stmts_concat
new file mode 100755
index 000000000000..941e9a5aa822
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_stmts_concat
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	chain y {
+		meta iifname eth1 ip saddr 1.1.1.1 ip daddr 2.2.2.3 accept
+		meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.4 accept
+		meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.5 accept
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

