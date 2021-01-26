Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C9AC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jan 2021 15:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7DA02100A
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jan 2021 15:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392214AbhAZPps (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jan 2021 10:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391958AbhAZPpm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 10:45:42 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6A1C061D73
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2021 07:45:00 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l4QWZ-0008V0-7y; Tue, 26 Jan 2021 16:44:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: evaluate: reset context maxlen value before prio evaluation
Date:   Tue, 26 Jan 2021 16:44:53 +0100
Message-Id: <20210126154453.16149-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

unshare -n tests/shell/run-tests.sh tests/shell/testcases/nft-f/0024priority_0
W: [FAILED]     tests/shell/testcases/nft-f/0024priority_0: got 1
/dev/stdin:8:47-49: Error: Value 100 exceeds valid range 0-15
        type filter hook postrouting priority 100

Reported-by: Andreas Schultz <andreas.schultz@travelping.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                     |  4 ++--
 tests/shell/testcases/nft-f/0024priority_0         | 14 ++++++++++++++
 .../shell/testcases/nft-f/dumps/0024priority_0.nft | 10 ++++++++++
 3 files changed, 26 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/nft-f/0024priority_0
 create mode 100644 tests/shell/testcases/nft-f/dumps/0024priority_0.nft

diff --git a/src/evaluate.c b/src/evaluate.c
index 7d6f55fe0872..3a91e9ea42ed 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3789,8 +3789,8 @@ static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
 	int prio_snd;
 	char op;
 
-	ctx->ectx.dtype = &priority_type;
-	ctx->ectx.len = NFT_NAME_MAXLEN * BITS_PER_BYTE;
+	expr_set_context(&ctx->ectx, &priority_type, NFT_NAME_MAXLEN * BITS_PER_BYTE);
+
 	if (expr_evaluate(ctx, &prio->expr) < 0)
 		return false;
 	if (prio->expr->etype != EXPR_VALUE) {
diff --git a/tests/shell/testcases/nft-f/0024priority_0 b/tests/shell/testcases/nft-f/0024priority_0
new file mode 100755
index 000000000000..586f5c3f2723
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0024priority_0
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+RULESET="
+table inet statelessnat {
+    chain prerouting {
+        type filter hook prerouting priority -100;
+        ip daddr set numgen inc mod 16 map { 0-7 : 10.0.1.1, 8- 15 : 10.0.1.2 }
+    }
+    chain postrouting {
+        type filter hook postrouting priority 100
+    }
+}"
+
+exec $NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/nft-f/dumps/0024priority_0.nft b/tests/shell/testcases/nft-f/dumps/0024priority_0.nft
new file mode 100644
index 000000000000..cd7fc5040c35
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0024priority_0.nft
@@ -0,0 +1,10 @@
+table inet statelessnat {
+	chain prerouting {
+		type filter hook prerouting priority dstnat; policy accept;
+		ip daddr set numgen inc mod 16 map { 0-7 : 10.0.1.1, 8-15 : 10.0.1.2 }
+	}
+
+	chain postrouting {
+		type filter hook postrouting priority srcnat; policy accept;
+	}
+}
-- 
2.26.2

