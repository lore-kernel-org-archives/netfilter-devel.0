From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/6] payload: add payload_dependency_release() helper function
Date: Wed, 14 Feb 2018 16:22:25 +0100
Message-ID: <20180214152229.11830-3-pablo@netfilter.org>
References: <20180214152229.11830-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031168AbeBNPWj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 10:22:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E0A6311772B
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D30BEDA3A0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0949EDA78A
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:36 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C03B041E4817
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:35 +0100 (CET)
In-Reply-To: <20180214152229.11830-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Wrap code that releases existing dependencies that we have just
annotated in the context structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/payload.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index df3c8136c88c..21c2842807cd 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -428,6 +428,17 @@ void payload_dependency_store(struct payload_dep_ctx *ctx,
 	ctx->pdep  = stmt;
 }
 
+static void payload_dependency_release(struct payload_dep_ctx *ctx)
+{
+	list_del(&ctx->pdep->list);
+	stmt_free(ctx->pdep);
+
+	ctx->pbase = PROTO_BASE_INVALID;
+	if (ctx->pdep == ctx->prev)
+		ctx->prev = NULL;
+	ctx->pdep  = NULL;
+}
+
 /**
  * __payload_dependency_kill - kill a redundant payload depedency
  *
@@ -442,15 +453,8 @@ void __payload_dependency_kill(struct payload_dep_ctx *ctx,
 {
 	if (ctx->pbase != PROTO_BASE_INVALID &&
 	    ctx->pbase == base &&
-	    ctx->pdep != NULL) {
-		list_del(&ctx->pdep->list);
-		stmt_free(ctx->pdep);
-
-		ctx->pbase = PROTO_BASE_INVALID;
-		if (ctx->pdep == ctx->prev)
-			ctx->prev = NULL;
-		ctx->pdep  = NULL;
-	}
+	    ctx->pdep != NULL)
+		payload_dependency_release(ctx);
 }
 
 void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
-- 
2.11.0

