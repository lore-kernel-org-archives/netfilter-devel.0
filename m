Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B23C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 14:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiCCOjv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 09:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiCCOju (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 09:39:50 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA8D914891E
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 06:39:04 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 19CD06019D
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 15:37:30 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 1/2] optimize: more robust statement merge with vmap
Date:   Thu,  3 Mar 2022 15:38:59 +0100
Message-Id: <20220303143900.702741-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check expressions that are expected on the rhs rather than using a
catch-all default case.

Actually, lists and sets need to be their own routine, because this
needs the set element key expression to be merged.

This is a follow up to 99eb46969f3d ("optimize: fix vmap with anonymous
sets").

Fixes: 1542082e259b ("optimize: merge same selector with different verdict into verdict map")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - split EXPR_LIST and EXPR_SET handling.
    - check for EXPR_SYMBOL (EXPR_VALUE is not yet available before evaluation).

 src/optimize.c                                   | 16 ++++++++++++++--
 .../optimizations/dumps/merge_stmts_vmap.nft     |  2 +-
 .../testcases/optimizations/merge_stmts_vmap     |  1 +
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 64c0a4dbe764..cd799e0d3407 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -437,7 +437,6 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct ex
 
 	switch (expr->etype) {
 	case EXPR_LIST:
-	case EXPR_SET:
 		list_for_each_entry(item, &expr->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item));
 			mapping = mapping_expr_alloc(&internal_location, elem,
@@ -445,12 +444,25 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct ex
 			compound_expr_add(set, mapping);
 		}
 		break;
-	default:
+	case EXPR_SET:
+		list_for_each_entry(item, &expr->expressions, list) {
+			elem = set_elem_expr_alloc(&internal_location, expr_get(item->key));
+			mapping = mapping_expr_alloc(&internal_location, elem,
+						     expr_get(verdict->expr));
+			compound_expr_add(set, mapping);
+		}
+		break;
+	case EXPR_PREFIX:
+	case EXPR_RANGE:
+	case EXPR_SYMBOL:
 		elem = set_elem_expr_alloc(&internal_location, expr_get(expr));
 		mapping = mapping_expr_alloc(&internal_location, elem,
 					     expr_get(verdict->expr));
 		compound_expr_add(set, mapping);
 		break;
+	default:
+		assert(0);
+		break;
 	}
 }
 
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
index 427572954a18..5a9b3006743b 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
@@ -4,6 +4,6 @@ table ip x {
 	}
 
 	chain z {
-		tcp dport vmap { 1 : accept, 2-3 : drop }
+		tcp dport vmap { 1 : accept, 2-3 : drop, 4 : accept }
 	}
 }
diff --git a/tests/shell/testcases/optimizations/merge_stmts_vmap b/tests/shell/testcases/optimizations/merge_stmts_vmap
index 6511c7b20cb6..79350076d6c6 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_vmap
+++ b/tests/shell/testcases/optimizations/merge_stmts_vmap
@@ -10,6 +10,7 @@ RULESET="table ip x {
 	chain z {
 		tcp dport { 1 } accept
 		tcp dport 2-3 drop
+		tcp dport 4 accept
 	}
 }"
 
-- 
2.30.2

