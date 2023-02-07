Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E45C636CC
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Feb 2023 10:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjBGKAP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Feb 2023 05:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbjBGJ7m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Feb 2023 04:59:42 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF50E366A2
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Feb 2023 01:58:48 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] optimize: ignore existing nat mapping
Date:   Tue,  7 Feb 2023 10:58:32 +0100
Message-Id: <20230207095832.606021-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

User might be already using a nat mapping in their ruleset, use the
unsupported statement when collecting statements in this case.

 # nft -c -o -f ruleset.nft
 nft: optimize.c:443: rule_build_stmt_matrix_stmts: Assertion `k >= 0' failed.
 Aborted

The -o/--optimize feature only cares about linear rulesets at this
stage, but do not hit assert() in this case.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1656
Fixes: 0a6dbfce6dc3 ("optimize: merge nat rules with same selectors into map")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                          | 7 +++++++
 tests/shell/testcases/optimizations/dumps/merge_nat.nft | 1 +
 tests/shell/testcases/optimizations/merge_nat           | 1 +
 3 files changed, 9 insertions(+)

diff --git a/src/optimize.c b/src/optimize.c
index ff4f26278a6d..d60aa8f22c07 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -370,6 +370,13 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 				clone->log.prefix = expr_get(stmt->log.prefix);
 			break;
 		case STMT_NAT:
+			if ((stmt->nat.addr &&
+			     stmt->nat.addr->etype == EXPR_MAP) ||
+			    (stmt->nat.proto &&
+			     stmt->nat.proto->etype == EXPR_MAP)) {
+				clone->ops = &unsupported_stmt_ops;
+				break;
+			}
 			clone->nat.type = stmt->nat.type;
 			clone->nat.family = stmt->nat.family;
 			if (stmt->nat.addr)
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat.nft b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
index 32423b220ed1..96e38ccd798a 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_nat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
@@ -14,6 +14,7 @@ table ip test3 {
 	chain y {
 		oif "lo" accept
 		snat to ip saddr . tcp sport map { 1.1.1.1 . 1024-65535 : 3.3.3.3, 2.2.2.2 . 1024-65535 : 4.4.4.4 }
+		oifname "enp2s0" snat ip to ip saddr map { 10.1.1.0/24 : 72.2.3.66-72.2.3.78 }
 	}
 }
 table ip test4 {
diff --git a/tests/shell/testcases/optimizations/merge_nat b/tests/shell/testcases/optimizations/merge_nat
index ec9b239c6f48..1484b7d39d48 100755
--- a/tests/shell/testcases/optimizations/merge_nat
+++ b/tests/shell/testcases/optimizations/merge_nat
@@ -27,6 +27,7 @@ RULESET="table ip test3 {
                 oif lo accept
                 ip saddr 1.1.1.1 tcp sport 1024-65535 snat to 3.3.3.3
                 ip saddr 2.2.2.2 tcp sport 1024-65535 snat to 4.4.4.4
+                oifname enp2s0 snat ip to ip saddr map { 10.1.1.0/24 : 72.2.3.66-72.2.3.78 }
         }
 }"
 
-- 
2.30.2

