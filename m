From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/4] evaluate: use stmt_evaluate_arg() in all cases
Date: Mon, 12 Jan 2015 13:30:06 +0000
Message-ID: <1421069406-10276-4-git-send-email-kaber@trash.net>
References: <1421069406-10276-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35358 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbALNaO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:30:14 -0500
In-Reply-To: <1421069406-10276-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When using a symbolic vmap expression, we fail to verify that the map
actually contains verdicts.

Use stmt_evaluate_arg() everywhere to fix this.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 90c87d0..a3484c6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1135,8 +1135,7 @@ static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 
 static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	expr_set_context(&ctx->ectx, &verdict_type, 0);
-	if (expr_evaluate(ctx, &stmt->expr) < 0)
+	if (stmt_evaluate_arg(ctx, stmt, &verdict_type, 0, &stmt->expr) < 0)
 		return -1;
 
 	switch (stmt->expr->ops->type) {
@@ -1625,8 +1624,8 @@ static int stmt_evaluate_redir(struct eval_ctx *ctx, struct stmt *stmt)
 static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt->queue.queue != NULL) {
-		expr_set_context(&ctx->ectx, &integer_type, 16);
-		if (expr_evaluate(ctx, &stmt->queue.queue) < 0)
+		if (stmt_evaluate_arg(ctx, stmt, &integer_type, 16,
+				      &stmt->queue.queue) < 0)
 			return -1;
 		if (!expr_is_constant(stmt->queue.queue))
 			return expr_error(ctx->msgs, stmt->queue.queue,
-- 
2.1.0

