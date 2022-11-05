Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6507BC4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  5 Nov 2022 15:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiKEP5X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 5 Nov 2022 11:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKEP5W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 5 Nov 2022 11:57:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B80F4E0F0
        for <netfilter-devel@vger.kernel.org>; Sat,  5 Nov 2022 08:57:21 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] optimize: handle prefix and range when merging into set + concatenation
Date:   Sat,  5 Nov 2022 16:57:15 +0100
Message-Id: <20221105155715.22229-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following ruleset fails to be merged using set + concatenation:

  meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.3.0/24 accept
  meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.4.0-2.2.4.10 accept

hitting the following assertion:

  nft: optimize.c:585: __merge_concat_stmts: Assertion `0' failed.
  Abort

This patch also updates tests/shell.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                                  | 2 ++
 .../shell/testcases/optimizations/dumps/merge_stmts_concat.nft  | 2 +-
 tests/shell/testcases/optimizations/merge_stmts_concat          | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/optimize.c b/src/optimize.c
index 180a7d55f18b..09013efc548c 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -578,6 +578,8 @@ static void __merge_concat_stmts(const struct optimize_ctx *ctx, uint32_t i,
 				break;
 			case EXPR_SYMBOL:
 			case EXPR_VALUE:
+			case EXPR_PREFIX:
+			case EXPR_RANGE:
 				clone = expr_clone(stmt_a->expr->right);
 				compound_expr_add(concat, clone);
 				break;
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
index 5d03cf8d9566..f56cea1c4fd7 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
@@ -1,6 +1,6 @@
 table ip x {
 	chain y {
-		iifname . ip saddr . ip daddr { "eth1" . 1.1.1.1 . 2.2.2.3, "eth1" . 1.1.1.2 . 2.2.2.4, "eth2" . 1.1.1.3 . 2.2.2.5 } accept
+		iifname . ip saddr . ip daddr { "eth1" . 1.1.1.1 . 2.2.2.3, "eth1" . 1.1.1.2 . 2.2.2.4, "eth1" . 1.1.1.2 . 2.2.3.0/24, "eth1" . 1.1.1.2 . 2.2.4.0-2.2.4.10, "eth2" . 1.1.1.3 . 2.2.2.5 } accept
 		ip protocol . th dport { tcp . 22, udp . 67 }
 	}
 
diff --git a/tests/shell/testcases/optimizations/merge_stmts_concat b/tests/shell/testcases/optimizations/merge_stmts_concat
index 0bcd95622a98..9679d86223fd 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_concat
+++ b/tests/shell/testcases/optimizations/merge_stmts_concat
@@ -6,6 +6,8 @@ RULESET="table ip x {
 	chain y {
 		meta iifname eth1 ip saddr 1.1.1.1 ip daddr 2.2.2.3 accept
 		meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.4 accept
+		meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.3.0/24 accept
+		meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.4.0-2.2.4.10 accept
 		meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.5 accept
 		ip protocol . th dport { tcp . 22, udp . 67 }
 	}
-- 
2.30.2

