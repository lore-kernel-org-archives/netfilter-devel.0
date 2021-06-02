Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837B5C47083
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 23:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BE34613E4
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 23:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFBX3e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 19:29:34 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43160 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhFBX3d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 19:29:33 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2DD56641FF
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Jun 2021 01:26:42 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] statement: connlimit: remove extra whitespace in print function
Date:   Thu,  3 Jun 2021 01:27:46 +0200
Message-Id: <20210602232746.15791-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of:

 ct count 2  accept
           ^^

simply print:

 ct count 2 accept

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/statement.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/statement.c b/src/statement.c
index f7f1c0c4d553..7537c07f495c 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -201,7 +201,7 @@ struct stmt *meter_stmt_alloc(const struct location *loc)
 
 static void connlimit_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	nft_print(octx, "ct count %s%u ",
+	nft_print(octx, "ct count %s%u",
 		  stmt->connlimit.flags ? "over " : "", stmt->connlimit.count);
 }
 
-- 
2.20.1

