Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C5CC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Oct 2022 23:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiJDXqJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Oct 2022 19:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiJDXph (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Oct 2022 19:45:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DC4AB5D
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2022 16:45:01 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] evaluate: bogus datatype assertion in binary operation evaluation
Date:   Wed,  5 Oct 2022 01:44:41 +0200
Message-Id: <20221004234442.779257-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use datatype_equal(), otherwise dynamically allocated datatype fails
to fulfill the datatype pointer check, triggering the assertion:

 nft: evaluate.c:1249: expr_evaluate_binop: Assertion `expr_basetype(left) == expr_basetype(right)' failed.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1636
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                             | 2 +-
 .../shell/testcases/optimizations/dumps/not_mergeable.nft  | 7 +++++++
 tests/shell/testcases/optimizations/not_mergeable          | 6 ++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index a52867b33be0..2e2b8df0f004 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1265,7 +1265,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 					 sym, expr_name(right));
 
 	/* The grammar guarantees this */
-	assert(expr_basetype(left) == expr_basetype(right));
+	assert(datatype_equal(expr_basetype(left), expr_basetype(right)));
 
 	switch (op->op) {
 	case OP_LSHIFT:
diff --git a/tests/shell/testcases/optimizations/dumps/not_mergeable.nft b/tests/shell/testcases/optimizations/dumps/not_mergeable.nft
index 08b2b58f66c3..02b89207b0cb 100644
--- a/tests/shell/testcases/optimizations/dumps/not_mergeable.nft
+++ b/tests/shell/testcases/optimizations/dumps/not_mergeable.nft
@@ -5,8 +5,15 @@ table ip x {
 	chain t2 {
 	}
 
+	chain t3 {
+	}
+
+	chain t4 {
+	}
+
 	chain y {
 		counter packets 0 bytes 0 jump t1
 		counter packets 0 bytes 0 jump t2
+		ip version vmap { 4 : jump t3, 6 : jump t4 }
 	}
 }
diff --git a/tests/shell/testcases/optimizations/not_mergeable b/tests/shell/testcases/optimizations/not_mergeable
index 25635cdd653d..ddb2f0fd86fc 100755
--- a/tests/shell/testcases/optimizations/not_mergeable
+++ b/tests/shell/testcases/optimizations/not_mergeable
@@ -7,9 +7,15 @@ RULESET="table ip x {
 	}
 	chain t2 {
 	}
+	chain t3 {
+	}
+	chain t4 {
+	}
 	chain y {
 		counter jump t1
 		counter jump t2
+		ip version 4 jump t3
+		ip version 6 jump t4
 	}
 }"
 
-- 
2.30.2

