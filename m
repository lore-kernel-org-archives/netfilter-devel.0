Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479BDC05027
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Feb 2023 14:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjBFORj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Feb 2023 09:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjBFORh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2023 09:17:37 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0C5183E1
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2023 06:17:31 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] optimize: select merge criteria based on candidates rules
Date:   Mon,  6 Feb 2023 15:17:27 +0100
Message-Id: <20230206141727.594073-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Select the merge criteria based on the statements that are used
in the candidate rules, instead of using the list of statements
in the given chain.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1657
Fixes: 0a6dbfce6dc3 ("optimize: merge nat rules with same selectors into map")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 22 +++++++++----------
 .../optimizations/dumps/merge_nat.nft         |  4 ++++
 tests/shell/testcases/optimizations/merge_nat |  4 ++++
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 5f6e3a64fdd3..ff4f26278a6d 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -985,21 +985,21 @@ static void rule_optimize_print(struct output_ctx *octx,
 	fprintf(octx->error_fp, "%s\n", line);
 }
 
-static enum stmt_types merge_stmt_type(const struct optimize_ctx *ctx)
+static enum stmt_types merge_stmt_type(const struct optimize_ctx *ctx,
+				       uint32_t from, uint32_t to)
 {
-	uint32_t i;
+	uint32_t i, j;
 
-	for (i = 0; i < ctx->num_stmts; i++) {
-		switch (ctx->stmt[i]->ops->type) {
-		case STMT_VERDICT:
-		case STMT_NAT:
-			return ctx->stmt[i]->ops->type;
-		default:
-			continue;
+	for (i = from; i <= to; i++) {
+		for (j = 0; j < ctx->num_stmts; j++) {
+			if (!ctx->stmt_matrix[i][j])
+				continue;
+			if (ctx->stmt_matrix[i][j]->ops->type == STMT_NAT)
+				return STMT_NAT;
 		}
 	}
 
-	/* actually no verdict, this assumes rules have the same verdict. */
+	/* merge by verdict, even if no verdict is specified. */
 	return STMT_VERDICT;
 }
 
@@ -1012,7 +1012,7 @@ static void merge_rules(const struct optimize_ctx *ctx,
 	bool same_verdict;
 	uint32_t i;
 
-	stmt_type = merge_stmt_type(ctx);
+	stmt_type = merge_stmt_type(ctx, from, to);
 
 	switch (stmt_type) {
 	case STMT_VERDICT:
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat.nft b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
index 7a6ecb76a934..32423b220ed1 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_nat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
@@ -1,20 +1,24 @@
 table ip test1 {
 	chain y {
+		oif "lo" accept
 		dnat to ip saddr map { 4.4.4.4 : 1.1.1.1, 5.5.5.5 : 2.2.2.2 }
 	}
 }
 table ip test2 {
 	chain y {
+		oif "lo" accept
 		dnat ip to tcp dport map { 80 : 1.1.1.1 . 8001, 81 : 2.2.2.2 . 9001 }
 	}
 }
 table ip test3 {
 	chain y {
+		oif "lo" accept
 		snat to ip saddr . tcp sport map { 1.1.1.1 . 1024-65535 : 3.3.3.3, 2.2.2.2 . 1024-65535 : 4.4.4.4 }
 	}
 }
 table ip test4 {
 	chain y {
+		oif "lo" accept
 		dnat ip to ip daddr . tcp dport map { 1.1.1.1 . 80 : 4.4.4.4 . 8000, 2.2.2.2 . 81 : 3.3.3.3 . 9000 }
 	}
 }
diff --git a/tests/shell/testcases/optimizations/merge_nat b/tests/shell/testcases/optimizations/merge_nat
index 290cfcfebe2e..ec9b239c6f48 100755
--- a/tests/shell/testcases/optimizations/merge_nat
+++ b/tests/shell/testcases/optimizations/merge_nat
@@ -4,6 +4,7 @@ set -e
 
 RULESET="table ip test1 {
         chain y {
+                oif lo accept
                 ip saddr 4.4.4.4 dnat to 1.1.1.1
                 ip saddr 5.5.5.5 dnat to 2.2.2.2
         }
@@ -13,6 +14,7 @@ $NFT -o -f - <<< $RULESET
 
 RULESET="table ip test2 {
         chain y {
+                oif lo accept
                 tcp dport 80 dnat to 1.1.1.1:8001
                 tcp dport 81 dnat to 2.2.2.2:9001
         }
@@ -22,6 +24,7 @@ $NFT -o -f - <<< $RULESET
 
 RULESET="table ip test3 {
         chain y {
+                oif lo accept
                 ip saddr 1.1.1.1 tcp sport 1024-65535 snat to 3.3.3.3
                 ip saddr 2.2.2.2 tcp sport 1024-65535 snat to 4.4.4.4
         }
@@ -31,6 +34,7 @@ $NFT -o -f - <<< $RULESET
 
 RULESET="table ip test4 {
         chain y {
+                oif lo accept
                 ip daddr 1.1.1.1 tcp dport 80 dnat to 4.4.4.4:8000
                 ip daddr 2.2.2.2 tcp dport 81 dnat to 3.3.3.3:9000
         }
-- 
2.30.2

