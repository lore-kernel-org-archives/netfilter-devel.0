From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] eval: refactor NAT evaluation functions
Date: Sat, 10 Jan 2015 14:59:13 +0000
Message-ID: <1420901955-21087-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49188 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbbAJO7j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Jan 2015 09:59:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The redir and masq evaluation functions include some useless context
updates and checks.

Refactor the NAT code to have a single instance of address and transport
evaluation functions for simplicity and unified error reporting.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 110 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 54 insertions(+), 56 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 43fb968..4cfe749 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1496,32 +1496,61 @@ static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
 	return stmt_evaluate_reject_family(ctx, stmt, expr);
 }
 
+static int nat_evaluate_family(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	switch (ctx->pctx.family) {
+	case AF_INET:
+	case AF_INET6:
+		return 0;
+	default:
+		return stmt_error(ctx, stmt,
+				  "NAT is only supported for IPv4/IPv6");
+	}
+}
+
+static int nat_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
+			     struct expr **expr)
+{
+	struct proto_ctx *pctx = &ctx->pctx;
+
+	if (pctx->family == AF_INET)
+		expr_set_context(&ctx->ectx, &ipaddr_type, 4 * BITS_PER_BYTE);
+	else
+		expr_set_context(&ctx->ectx, &ip6addr_type, 16 * BITS_PER_BYTE);
+
+	return expr_evaluate(ctx, expr);
+}
+
+static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
+				  struct expr **expr)
+{
+	struct proto_ctx *pctx = &ctx->pctx;
+
+	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL)
+		return stmt_binary_error(ctx, *expr, stmt,
+					 "transport protocol mapping is only "
+					 "valid after transport protocol match");
+
+	expr_set_context(&ctx->ectx, &inet_service_type, 2 * BITS_PER_BYTE);
+	return expr_evaluate(ctx, expr);
+}
+
 static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct proto_ctx *pctx = &ctx->pctx;
 	int err;
 
+	err = nat_evaluate_family(ctx, stmt);
+	if (err < 0)
+		return err;
+
 	if (stmt->nat.addr != NULL) {
-		if (pctx && (pctx->family == AF_INET))
-			expr_set_context(&ctx->ectx, &ipaddr_type,
-					4 * BITS_PER_BYTE);
-		else
-			expr_set_context(&ctx->ectx, &ip6addr_type,
-					 16 * BITS_PER_BYTE);
-		err = expr_evaluate(ctx, &stmt->nat.addr);
+		err = nat_evaluate_addr(ctx, stmt, &stmt->nat.addr);
 		if (err < 0)
 			return err;
 	}
-
 	if (stmt->nat.proto != NULL) {
-		if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL)
-			return stmt_binary_error(ctx, stmt->nat.proto, stmt,
-						 "transport protocol mapping is only "
-						 "valid after transport protocol match");
-
-		expr_set_context(&ctx->ectx, &inet_service_type,
-				 2 * BITS_PER_BYTE);
-		err = expr_evaluate(ctx, &stmt->nat.proto);
+		err = nat_evaluate_transport(ctx, stmt, &stmt->nat.proto);
 		if (err < 0)
 			return err;
 	}
@@ -1533,62 +1562,31 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 static int stmt_evaluate_masq(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct proto_ctx *pctx = &ctx->pctx;
+	int err;
 
-	if (!pctx)
-		goto out;
-
-	switch (pctx->family) {
-	case AF_INET:
-		expr_set_context(&ctx->ectx, &ipaddr_type,
-				4 * BITS_PER_BYTE);
-		break;
-	case AF_INET6:
-		expr_set_context(&ctx->ectx, &ip6addr_type,
-				 16 * BITS_PER_BYTE);
-		break;
-	default:
-		return stmt_error(ctx, stmt, "ip and ip6 support only");
-	}
+	err = nat_evaluate_family(ctx, stmt);
+	if (err < 0)
+		return err;
 
-out:
 	stmt->flags |= STMT_F_TERMINAL;
 	return 0;
 }
 
 static int stmt_evaluate_redir(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	int err;
 	struct proto_ctx *pctx = &ctx->pctx;
+	int err;
 
-	if (!pctx)
-		goto out;
-
-	switch (pctx->family) {
-	case AF_INET:
-		expr_set_context(&ctx->ectx, &ipaddr_type,
-				4 * BITS_PER_BYTE);
-		break;
-	case AF_INET6:
-		expr_set_context(&ctx->ectx, &ip6addr_type,
-				 16 * BITS_PER_BYTE);
-		break;
-	default:
-		return stmt_error(ctx, stmt, "ip and ip6 support only");
-	}
+	err = nat_evaluate_family(ctx, stmt);
+	if (err < 0)
+		return err;
 
 	if (stmt->redir.proto != NULL) {
-		if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL)
-			return stmt_binary_error(ctx, stmt->redir.proto, stmt,
-						 "missing transport protocol match");
-
-		expr_set_context(&ctx->ectx, &inet_service_type,
-				 2 * BITS_PER_BYTE);
-		err = expr_evaluate(ctx, &stmt->redir.proto);
+		err = nat_evaluate_transport(ctx, stmt, &stmt->redir.proto);
 		if (err < 0)
 			return err;
 	}
 
-out:
 	stmt->flags |= STMT_F_TERMINAL;
 	return 0;
 }
-- 
2.1.0

