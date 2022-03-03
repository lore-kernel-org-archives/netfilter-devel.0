Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466EEC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 11:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiCCLhE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 06:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiCCLg6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 06:36:58 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D241F72
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 03:35:56 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AA391625D9
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 12:34:21 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] optimize: fix vmap with anonymous sets
Date:   Thu,  3 Mar 2022 12:35:52 +0100
Message-Id: <20220303113552.493957-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following example ruleset crashes:

 table inet a {
        chain b {
                tcp dport { 1 } accept
                tcp dport 2-3 drop
        }
 }

because handling for EXPR_SET is missing.

Fixes: 1542082e259b ("optimize: merge same selector with different verdict into verdict map")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                            | 8 ++++++--
 .../testcases/optimizations/dumps/merge_stmts_vmap.nft    | 4 ++++
 tests/shell/testcases/optimizations/merge_stmts_vmap      | 4 ++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 04523edb795b..64c0a4dbe764 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -435,18 +435,22 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct ex
 {
 	struct expr *item, *elem, *mapping;
 
-	if (expr->etype == EXPR_LIST) {
+	switch (expr->etype) {
+	case EXPR_LIST:
+	case EXPR_SET:
 		list_for_each_entry(item, &expr->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item));
 			mapping = mapping_expr_alloc(&internal_location, elem,
 						     expr_get(verdict->expr));
 			compound_expr_add(set, mapping);
 		}
-	} else {
+		break;
+	default:
 		elem = set_elem_expr_alloc(&internal_location, expr_get(expr));
 		mapping = mapping_expr_alloc(&internal_location, elem,
 					     expr_get(verdict->expr));
 		compound_expr_add(set, mapping);
+		break;
 	}
 }
 
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
index 9fa19afcb783..427572954a18 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
@@ -2,4 +2,8 @@ table ip x {
 	chain y {
 		ct state vmap { invalid : drop, established : accept, related : accept }
 	}
+
+	chain z {
+		tcp dport vmap { 1 : accept, 2-3 : drop }
+	}
 }
diff --git a/tests/shell/testcases/optimizations/merge_stmts_vmap b/tests/shell/testcases/optimizations/merge_stmts_vmap
index f838fcfed70b..6511c7b20cb6 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_vmap
+++ b/tests/shell/testcases/optimizations/merge_stmts_vmap
@@ -7,6 +7,10 @@ RULESET="table ip x {
 		ct state invalid drop
 		ct state established,related accept
 	}
+	chain z {
+		tcp dport { 1 } accept
+		tcp dport 2-3 drop
+	}
 }"
 
 $NFT -o -f - <<< $RULESET
-- 
2.30.2

