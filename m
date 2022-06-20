Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE40ACCA480
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 08:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbiFTIcc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 04:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239442AbiFTIc2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 04:32:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A14712A81
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 01:32:24 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 04/18] optimize: remove comment after merging
Date:   Mon, 20 Jun 2022 10:32:01 +0200
Message-Id: <20220620083215.1021238-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620083215.1021238-1-pablo@netfilter.org>
References: <20220620083215.1021238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove rule comment after merging rules, let the user decide if they want
to reintroduce the comment in the ruleset file.

Update optimizations/merge_stmt test.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                  | 5 +++++
 tests/shell/testcases/optimizations/merge_stmts | 6 +++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index b19a8b553555..94242ee5f490 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -873,6 +873,11 @@ static void merge_rules(const struct optimize_ctx *ctx,
 		assert(0);
 	}
 
+	if (ctx->rule[from]->comment) {
+		xfree(ctx->rule[from]->comment);
+		ctx->rule[from]->comment = NULL;
+	}
+
         octx->flags |= NFT_CTX_OUTPUT_STATELESS;
 
 	fprintf(octx->error_fp, "Merging:\n");
diff --git a/tests/shell/testcases/optimizations/merge_stmts b/tests/shell/testcases/optimizations/merge_stmts
index 0c35636efaa9..ec7a9dd6b554 100755
--- a/tests/shell/testcases/optimizations/merge_stmts
+++ b/tests/shell/testcases/optimizations/merge_stmts
@@ -4,9 +4,9 @@ set -e
 
 RULESET="table ip x {
 	chain y {
-		ip daddr 192.168.0.1 counter accept
-		ip daddr 192.168.0.2 counter accept
-		ip daddr 192.168.0.3 counter accept
+		ip daddr 192.168.0.1 counter accept comment "test1"
+		ip daddr 192.168.0.2 counter accept comment "test2"
+		ip daddr 192.168.0.3 counter accept comment "test3"
 	}
 }"
 
-- 
2.30.2

