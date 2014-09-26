From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/4 v2] src: Enhance payload_gen_dependency()
Date: Fri, 26 Sep 2014 18:50:53 +0200
Message-ID: <1411750255-7663-2-git-send-email-alvaroneay@gmail.com>
References: <1411750255-7663-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:39773 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaIZQup (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:50:45 -0400
Received: by mail-we0-f179.google.com with SMTP id u56so1983494wes.38
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2014 09:50:43 -0700 (PDT)
In-Reply-To: <1411750255-7663-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With this patch, this function returns a statement with the new dependency
that we want to add, instead of an expression.

This change is needed in a follow up patch.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[No changes in v2]

 include/payload.h   |    3 ++-
 include/statement.h |    1 +
 src/evaluate.c      |    9 ++-------
 src/payload.c       |   18 +++++++++++++++---
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index d47e564..95364af 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -11,8 +11,9 @@ extern void payload_init_raw(struct expr *expr, enum proto_bases base,
 			     unsigned int offset, unsigned int len);
 
 struct eval_ctx;
+struct stmt;
 extern int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
-				  struct expr **res);
+				  struct stmt **res);
 
 extern bool payload_is_adjacent(const struct expr *e1, const struct expr *e2);
 extern struct expr *payload_expr_join(const struct expr *e1,
diff --git a/include/statement.h b/include/statement.h
index e2f02b8..7a57f7d 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -166,6 +166,7 @@ struct stmt {
 
 extern struct stmt *stmt_alloc(const struct location *loc,
 			       const struct stmt_ops *ops);
+int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt);
 extern void stmt_free(struct stmt *stmt);
 extern void stmt_list_free(struct list_head *list);
 extern void stmt_print(const struct stmt *stmt);
diff --git a/src/evaluate.c b/src/evaluate.c
index 284ee72..52ce548 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -26,7 +26,6 @@
 #include <utils.h>
 
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
-static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt);
 
 static const char *byteorder_names[] = {
 	[BYTEORDER_INVALID]		= "invalid",
@@ -271,13 +270,9 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
 	struct expr *payload = *expr;
 	enum proto_bases base = payload->payload.base;
 	struct stmt *nstmt;
-	struct expr *nexpr;
 
 	if (ctx->pctx.protocol[base].desc == NULL) {
-		if (payload_gen_dependency(ctx, payload, &nexpr) < 0)
-			return -1;
-		nstmt = expr_stmt_alloc(&nexpr->location, nexpr);
-		if (stmt_evaluate(ctx, nstmt) < 0)
+		if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 			return -1;
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
 	} else if (ctx->pctx.protocol[base].desc != payload->payload.desc)
@@ -1205,7 +1200,7 @@ static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
-static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
+int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 {
 #ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
diff --git a/src/payload.c b/src/payload.c
index a3bbe51..b7b74ed 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -21,6 +21,7 @@
 
 #include <rule.h>
 #include <expression.h>
+#include <statement.h>
 #include <payload.h>
 #include <gmputil.h>
 #include <utils.h>
@@ -160,12 +161,13 @@ void payload_init_raw(struct expr *expr, enum proto_bases base,
  *   in the input path though.
  */
 int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
-			   struct expr **res)
+			   struct stmt **res)
 {
 	const struct hook_proto_desc *h = &hook_proto_desc[ctx->pctx.family];
 	const struct proto_desc *desc;
 	const struct proto_hdr_template *tmpl;
 	struct expr *dep, *left, *right;
+	struct stmt *stmt;
 	int protocol;
 	uint16_t type;
 
@@ -186,7 +188,12 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 					    2 * BITS_PER_BYTE, &type);
 
 		dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
-		*res = dep;
+		stmt = expr_stmt_alloc(&dep->location, dep);
+		if (stmt_evaluate(ctx, stmt) < 0) {
+			return expr_error(ctx->msgs, expr,
+					  "dependency statement is invalid");
+		}
+		*res = stmt;
 		return 0;
 	}
 
@@ -220,8 +227,13 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				    constant_data_ptr(protocol, tmpl->len));
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
+	stmt = expr_stmt_alloc(&dep->location, dep);
+	if (stmt_evaluate(ctx, stmt) < 0) {
+		return expr_error(ctx->msgs, expr,
+					  "dependency statement is invalid");
+	}
 	left->ops->pctx_update(&ctx->pctx, dep);
-	*res = dep;
+	*res = stmt;
 	return 0;
 }
 
-- 
1.7.10.4

