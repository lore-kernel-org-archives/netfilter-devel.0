Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12C7C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 May 2022 16:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbiECQOE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 May 2022 12:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbiECQNz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 May 2022 12:13:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAA0B167D8
        for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2022 09:10:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] optimize: incorrect logic in verdict comparison
Date:   Tue,  3 May 2022 18:10:15 +0200
Message-Id: <20220503161017.54258-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Keep inspecting rule verdicts before assuming they are equal. Update
existing test to catch this bug.

Fixes: 1542082e259b ("optimize: merge same selector with different verdict into verdict map")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                         | 10 +++++-----
 .../testcases/optimizations/merge_stmts_concat_vmap    |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 4ad25fab6be4..a6c26d21eb6b 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -621,13 +621,13 @@ static bool stmt_verdict_cmp(const struct optimize_ctx *ctx,
 	for (i = from; i + 1 <= to; i++) {
 		stmt_a = ctx->stmt_matrix[i][k];
 		stmt_b = ctx->stmt_matrix[i + 1][k];
-		if (!stmt_a && !stmt_b)
-			return true;
-		if (stmt_verdict_eq(stmt_a, stmt_b))
-			return true;
+		if (!stmt_a || !stmt_b)
+			return false;
+		if (!stmt_verdict_eq(stmt_a, stmt_b))
+			return false;
 	}
 
-	return false;
+	return true;
 }
 
 static void rule_optimize_print(struct output_ctx *octx,
diff --git a/tests/shell/testcases/optimizations/merge_stmts_concat_vmap b/tests/shell/testcases/optimizations/merge_stmts_concat_vmap
index f1ab0288ab0d..5c0ae60caafa 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_concat_vmap
+++ b/tests/shell/testcases/optimizations/merge_stmts_concat_vmap
@@ -5,8 +5,8 @@ set -e
 RULESET="table ip x {
 	chain y {
 		ip saddr 1.1.1.1 ip daddr 2.2.2.2 accept
-		ip saddr 2.2.2.2 ip daddr 3.3.3.3 drop
 		ip saddr 4.4.4.4 ip daddr 5.5.5.5 accept
+		ip saddr 2.2.2.2 ip daddr 3.3.3.3 drop
 	}
 }"
 
-- 
2.30.2

