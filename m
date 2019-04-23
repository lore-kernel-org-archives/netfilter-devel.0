Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4879DC282DD
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 11:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 220C1204EC
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 11:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfDWLX4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 07:23:56 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56814 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726150AbfDWLX4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 07:23:56 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hItWk-0008TD-39; Tue, 23 Apr 2019 13:23:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: fix double free on xt stmt destruction
Date:   Tue, 23 Apr 2019 13:18:05 +0200
Message-Id: <20190423111805.18838-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

'nft monitor' dies with:
*** Error in `/sbin/nft': double free or corruption (fasttop): 0x000055f8ba57b750 ***

... when the iptables-nft test suite is running in parallel, because
xfree(stmt->xt.name) gets called twice.

Fixes: 4ac11b890fe870 ("src: missing destroy function in statement definitions")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/xt.h    | 2 +-
 src/statement.c | 6 ------
 src/xt.c        | 2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/xt.h b/include/xt.h
index ab59bb3d45a4..9fc515084d59 100644
--- a/include/xt.h
+++ b/include/xt.h
@@ -9,7 +9,7 @@ struct rule;
 struct output_ctx;
 
 void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx);
-void xt_stmt_release(const struct stmt *stmt);
+void xt_stmt_destroy(struct stmt *stmt);
 
 void netlink_parse_target(struct netlink_parse_ctx *ctx,
 			  const struct location *loc,
diff --git a/src/statement.c b/src/statement.c
index b2370f8710a4..7f9c10b38244 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -866,12 +866,6 @@ static void xt_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	xt_stmt_xlate(stmt, octx);
 }
 
-static void xt_stmt_destroy(struct stmt *stmt)
-{
-	xfree(stmt->xt.name);
-	xt_stmt_release(stmt);
-}
-
 static const struct stmt_ops xt_stmt_ops = {
 	.type		= STMT_XT,
 	.name		= "xt",
diff --git a/src/xt.c b/src/xt.c
index 906b2fde10e1..b0f5a30c46b5 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -78,7 +78,7 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 #endif
 }
 
-void xt_stmt_release(const struct stmt *stmt)
+void xt_stmt_destroy(struct stmt *stmt)
 {
 #ifdef HAVE_LIBXTABLES
 	switch (stmt->xt.type) {
-- 
2.21.0

