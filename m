Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FBCC3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 09:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22A1521907
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 09:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388575AbfISJcD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:32:03 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46322 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388194AbfISJcD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 05:32:03 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iAsnB-0003uO-8Q; Thu, 19 Sep 2019 11:32:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: meter: avoid double-space in list ruleset output
Date:   Thu, 19 Sep 2019 11:23:46 +0200
Message-Id: <20190919092346.3728-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

changes
meter f size 1024 { ip saddr limit rate 10/second}  accept
to
meter f size 1024 { ip saddr limit rate 10/second } accept

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/statement.c                                                 | 2 +-
 tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/statement.c b/src/statement.c
index 5aa5b1e0bda4..af84e06c971e 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -128,7 +128,7 @@ static void meter_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	stmt_print(stmt->meter.stmt, octx);
 	octx->flags = flags;
 
-	nft_print(octx, "} ");
+	nft_print(octx, " }");
 
 }
 
diff --git a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
index e518906cc35b..5a6e3261b4ba 100644
--- a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
+++ b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
@@ -8,6 +8,6 @@ table ip t {
 	}
 
 	chain c {
-		tcp dport 80 meter f size 1024 { ip saddr limit rate 10/second} 
+		tcp dport 80 meter f size 1024 { ip saddr limit rate 10/second }
 	}
 }
-- 
2.21.0

