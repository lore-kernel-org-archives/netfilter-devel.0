From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH] evaluate: clean up unused variables (pctx)
Date: Mon, 12 Jan 2015 10:53:57 +0100
Message-ID: <1421056437-9641-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56132 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbALJxl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:53:41 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so18224896wgh.2
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2015 01:53:39 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/evaluate.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 53f3cf0..d24d4cc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1563,7 +1563,6 @@ static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 
 static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct proto_ctx *pctx = &ctx->pctx;
 	int err;
 
 	err = nat_evaluate_family(ctx, stmt);
@@ -1587,7 +1586,6 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_masq(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct proto_ctx *pctx = &ctx->pctx;
 	int err;
 
 	err = nat_evaluate_family(ctx, stmt);
@@ -1600,7 +1598,6 @@ static int stmt_evaluate_masq(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_redir(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct proto_ctx *pctx = &ctx->pctx;
 	int err;
 
 	err = nat_evaluate_family(ctx, stmt);
-- 
1.7.10.4

