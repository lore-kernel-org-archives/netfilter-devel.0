Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3E3C3F6B0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 21:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiHIVSh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 17:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiHIVSR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 17:18:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 122C352FD4
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 14:18:17 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] optimize: merging concatenation is unsupported
Date:   Tue,  9 Aug 2022 23:18:11 +0200
Message-Id: <20220809211812.749217-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220809211812.749217-1-pablo@netfilter.org>
References: <20220809211812.749217-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Existing concatenation cannot be merge at this stage, skip them
otherwise this assertion is hit:

 nft: optimize.c:434: rule_build_stmt_matrix_stmts: Assertion `k >= 0' failed

Extend existing test to cover this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                                | 4 ++++
 .../testcases/optimizations/dumps/merge_stmts_concat.nft      | 1 +
 tests/shell/testcases/optimizations/merge_stmts_concat        | 1 +
 3 files changed, 6 insertions(+)

diff --git a/src/optimize.c b/src/optimize.c
index 2340ef466fc0..419a37f2bb20 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -352,6 +352,10 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 				clone->ops = &unsupported_stmt_ops;
 				break;
 			}
+			if (stmt->expr->left->etype == EXPR_CONCAT) {
+				clone->ops = &unsupported_stmt_ops;
+				break;
+			}
 		case STMT_VERDICT:
 			clone->expr = expr_get(stmt->expr);
 			break;
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
index 6dbfff2e15fc..15cfa7e85c33 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
@@ -1,5 +1,6 @@
 table ip x {
 	chain y {
 		iifname . ip saddr . ip daddr { "eth1" . 1.1.1.1 . 2.2.2.3, "eth1" . 1.1.1.2 . 2.2.2.4, "eth2" . 1.1.1.3 . 2.2.2.5 } accept
+		ip protocol . th dport { tcp . 22, udp . 67 }
 	}
 }
diff --git a/tests/shell/testcases/optimizations/merge_stmts_concat b/tests/shell/testcases/optimizations/merge_stmts_concat
index 941e9a5aa822..623fdff9a649 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_concat
+++ b/tests/shell/testcases/optimizations/merge_stmts_concat
@@ -7,6 +7,7 @@ RULESET="table ip x {
 		meta iifname eth1 ip saddr 1.1.1.1 ip daddr 2.2.2.3 accept
 		meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.4 accept
 		meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.5 accept
+		ip protocol . th dport { tcp . 22, udp . 67 }
 	}
 }"
 
-- 
2.30.2

