Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC8CC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Mar 2022 10:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbiCDKhb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 05:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbiCDKha (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 05:37:30 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3971E728E
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 02:36:40 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nQ5Ic-0007AT-TK; Fri, 04 Mar 2022 11:36:38 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: init cmd pointer for new on-stack context
Date:   Fri,  4 Mar 2022 11:36:34 +0100
Message-Id: <20220304103634.13160-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

else, this will segfault when trying to print the
"table 'x' doesn't exist" error message.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                   | 1 +
 tests/shell/testcases/chains/0041chain_binding_0 | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2732f5f49e06..07a4b0ad19b0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3425,6 +3425,7 @@ static int stmt_evaluate_chain(struct eval_ctx *ctx, struct stmt *stmt)
 			struct eval_ctx rule_ctx = {
 				.nft	= ctx->nft,
 				.msgs	= ctx->msgs,
+				.cmd	= ctx->cmd,
 			};
 			struct handle h2 = {};
 
diff --git a/tests/shell/testcases/chains/0041chain_binding_0 b/tests/shell/testcases/chains/0041chain_binding_0
index 59bdbe9f0ba9..806c17535002 100755
--- a/tests/shell/testcases/chains/0041chain_binding_0
+++ b/tests/shell/testcases/chains/0041chain_binding_0
@@ -1,5 +1,11 @@
 #!/bin/bash
 
+# no table z, caused segfault in earlier nft releases
+$NFT insert rule inet x y handle 107 'goto { log prefix "MOO! "; }'
+if [ $? -ne 1 ]; then
+	exit 1
+fi
+
 set -e
 
 EXPECTED="table inet x {
-- 
2.34.1

