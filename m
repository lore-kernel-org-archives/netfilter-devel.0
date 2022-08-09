Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D15BC25B08
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 21:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiHIVSi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 17:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiHIVSS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 17:18:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBE9152E7E
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 14:18:17 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] optimize: check for mergeable rules
Date:   Tue,  9 Aug 2022 23:18:12 +0200
Message-Id: <20220809211812.749217-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220809211812.749217-1-pablo@netfilter.org>
References: <20220809211812.749217-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rules that are equal need to have at least one mergeable statement.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 28 ++++++++++++++++++-
 .../optimizations/dumps/not_mergeable.nft     | 12 ++++++++
 .../testcases/optimizations/not_mergeable     | 16 +++++++++++
 3 files changed, 55 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/not_mergeable.nft
 create mode 100755 tests/shell/testcases/optimizations/not_mergeable

diff --git a/src/optimize.c b/src/optimize.c
index 419a37f2bb20..ea067f80bce0 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -1011,15 +1011,41 @@ static bool stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 	return __stmt_type_eq(stmt_a, stmt_b, true);
 }
 
+static bool stmt_is_mergeable(const struct stmt *stmt)
+{
+	if (!stmt)
+		return false;
+
+	switch (stmt->ops->type) {
+	case STMT_VERDICT:
+		if (stmt->expr->etype == EXPR_MAP)
+			return true;
+		break;
+	case STMT_EXPRESSION:
+	case STMT_NAT:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 static bool rules_eq(const struct optimize_ctx *ctx, int i, int j)
 {
-	uint32_t k;
+	uint32_t k, mergeable = 0;
 
 	for (k = 0; k < ctx->num_stmts; k++) {
+		if (stmt_is_mergeable(ctx->stmt_matrix[i][k]))
+			mergeable++;
+
 		if (!stmt_type_eq(ctx->stmt_matrix[i][k], ctx->stmt_matrix[j][k]))
 			return false;
 	}
 
+	if (mergeable == 0)
+		return false;
+
 	return true;
 }
 
diff --git a/tests/shell/testcases/optimizations/dumps/not_mergeable.nft b/tests/shell/testcases/optimizations/dumps/not_mergeable.nft
new file mode 100644
index 000000000000..08b2b58f66c3
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/not_mergeable.nft
@@ -0,0 +1,12 @@
+table ip x {
+	chain t1 {
+	}
+
+	chain t2 {
+	}
+
+	chain y {
+		counter packets 0 bytes 0 jump t1
+		counter packets 0 bytes 0 jump t2
+	}
+}
diff --git a/tests/shell/testcases/optimizations/not_mergeable b/tests/shell/testcases/optimizations/not_mergeable
new file mode 100755
index 000000000000..25635cdd653d
--- /dev/null
+++ b/tests/shell/testcases/optimizations/not_mergeable
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	chain t1 {
+	}
+	chain t2 {
+	}
+	chain y {
+		counter jump t1
+		counter jump t2
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

