From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] evaluate: add missing datatype compat checks for statement arguments
Date: Sat, 10 Jan 2015 14:59:14 +0000
Message-ID: <1420901955-21087-2-git-send-email-kaber@trash.net>
References: <1420901955-21087-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49189 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbbAJO7j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Jan 2015 09:59:39 -0500
In-Reply-To: <1420901955-21087-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a helper function to evaluate expressions used as arguments for
statements and report datatype mismatches.

Fixes acceptance of mismatching expressions like:

$ nft filter output meta mark set ip daddr
<cmdline>:1:29-36: Error: datatype mismatch: expected packet mark. expression has type IPv4 address
filter output meta mark set ip daddr
              ~~~~~~~~~~~~~~^^^^^^^^

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 66 ++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 23 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 4cfe749..0a1422a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1112,6 +1112,22 @@ static int stmt_evaluate_expr(struct eval_ctx *ctx, struct stmt *stmt)
 	return expr_evaluate(ctx, &stmt->expr);
 }
 
+static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
+			     const struct datatype *dtype, unsigned int len,
+			     struct expr **expr)
+{
+	expr_set_context(&ctx->ectx, dtype, len);
+	if (expr_evaluate(ctx, expr) < 0)
+		return -1;
+
+	if (!datatype_equal((*expr)->dtype, dtype))
+		return stmt_binary_error(ctx, *expr, stmt,
+					 "datatype mismatch: expected %s. "
+					 "expression has type %s",
+					 dtype->desc, (*expr)->dtype->desc);
+	return 0;
+}
+
 static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	expr_set_context(&ctx->ectx, &verdict_type, 0);
@@ -1133,11 +1149,18 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	expr_set_context(&ctx->ectx, stmt->meta.tmpl->dtype,
-			 stmt->meta.tmpl->len);
-	if (expr_evaluate(ctx, &stmt->meta.expr) < 0)
-		return -1;
-	return 0;
+	return stmt_evaluate_arg(ctx, stmt,
+				 stmt->meta.tmpl->dtype,
+				 stmt->meta.tmpl->len,
+				 &stmt->meta.expr);
+}
+
+static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	return stmt_evaluate_arg(ctx, stmt,
+				 stmt->ct.tmpl->dtype,
+				 stmt->ct.tmpl->len,
+				 &stmt->ct.expr);
 }
 
 static int reject_payload_gen_dependency_tcp(struct eval_ctx *ctx,
@@ -1512,13 +1535,18 @@ static int nat_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 			     struct expr **expr)
 {
 	struct proto_ctx *pctx = &ctx->pctx;
+	const struct datatype *dtype;
+	unsigned int len;
 
-	if (pctx->family == AF_INET)
-		expr_set_context(&ctx->ectx, &ipaddr_type, 4 * BITS_PER_BYTE);
-	else
-		expr_set_context(&ctx->ectx, &ip6addr_type, 16 * BITS_PER_BYTE);
+	if (pctx->family == AF_INET) {
+		dtype = &ipaddr_type;
+		len   = 4 * BITS_PER_BYTE;
+	} else {
+		dtype = &ip6addr_type;
+		len   = 16 * BITS_PER_BYTE;
+	}
 
-	return expr_evaluate(ctx, expr);
+	return stmt_evaluate_arg(ctx, stmt, dtype, len, expr);
 }
 
 static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
@@ -1531,8 +1559,9 @@ static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 					 "transport protocol mapping is only "
 					 "valid after transport protocol match");
 
-	expr_set_context(&ctx->ectx, &inet_service_type, 2 * BITS_PER_BYTE);
-	return expr_evaluate(ctx, expr);
+	return stmt_evaluate_arg(ctx, stmt,
+				 &inet_service_type, 2 * BITS_PER_BYTE,
+				 expr);
 }
 
 static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
@@ -1591,15 +1620,6 @@ static int stmt_evaluate_redir(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
-static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
-{
-	expr_set_context(&ctx->ectx, stmt->ct.tmpl->dtype,
-			 stmt->ct.tmpl->len);
-	if (expr_evaluate(ctx, &stmt->ct.expr) < 0)
-		return -1;
-	return 0;
-}
-
 static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt->queue.queue != NULL) {
@@ -1645,6 +1665,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_verdict(ctx, stmt);
 	case STMT_META:
 		return stmt_evaluate_meta(ctx, stmt);
+	case STMT_CT:
+		return stmt_evaluate_ct(ctx, stmt);
 	case STMT_LOG:
 		return stmt_evaluate_log(ctx, stmt);
 	case STMT_REJECT:
@@ -1657,8 +1679,6 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_redir(ctx, stmt);
 	case STMT_QUEUE:
 		return stmt_evaluate_queue(ctx, stmt);
-	case STMT_CT:
-		return stmt_evaluate_ct(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
-- 
2.1.0

