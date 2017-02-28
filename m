From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/4] evaluate: set byteorder as lhs expression context in stmt_evaluate_arg()
Date: Tue, 28 Feb 2017 01:00:59 +0100
Message-ID: <1488240062-27366-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47524 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdB1ACd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 19:02:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3355FE620
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23D54DA804
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09EA2DA725
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 01:01:07 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

stmt_evaluate_arg() needs to take the lhs map expression byteorder in
order to evaluate the lhs of mappings accordingly.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 87da2fd83597..21f1a475d5e9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1721,9 +1721,9 @@ static int stmt_evaluate_expr(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 			     const struct datatype *dtype, unsigned int len,
-			     struct expr **expr)
+			     enum byteorder byteorder, struct expr **expr)
 {
-	expr_set_context(&ctx->ectx, dtype, len);
+	__expr_set_context(&ctx->ectx, dtype, byteorder, len, 0);
 	if (expr_evaluate(ctx, expr) < 0)
 		return -1;
 
@@ -1737,7 +1737,7 @@ static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 
 static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	if (stmt_evaluate_arg(ctx, stmt, &verdict_type, 0, &stmt->expr) < 0)
+	if (stmt_evaluate_arg(ctx, stmt, &verdict_type, 0, 0, &stmt->expr) < 0)
 		return -1;
 
 	switch (stmt->expr->ops->type) {
@@ -1777,7 +1777,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 
 	payload = stmt->payload.expr;
 	if (stmt_evaluate_arg(ctx, stmt, payload->dtype, payload->len,
-			      &stmt->payload.val) < 0)
+			      payload->byteorder, &stmt->payload.val) < 0)
 		return -1;
 
 	need_csum = stmt_evaluate_payload_need_csum(payload);
@@ -1908,6 +1908,7 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 	return stmt_evaluate_arg(ctx, stmt,
 				 stmt->meta.tmpl->dtype,
 				 stmt->meta.tmpl->len,
+				 stmt->meta.tmpl->byteorder,
 				 &stmt->meta.expr);
 }
 
@@ -1916,6 +1917,7 @@ static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 	return stmt_evaluate_arg(ctx, stmt,
 				 stmt->ct.tmpl->dtype,
 				 stmt->ct.tmpl->len,
+				 stmt->ct.tmpl->byteorder,
 				 &stmt->ct.expr);
 }
 
@@ -2306,7 +2308,8 @@ static int evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 		len   = 16 * BITS_PER_BYTE;
 	}
 
-	return stmt_evaluate_arg(ctx, stmt, dtype, len, expr);
+	return stmt_evaluate_arg(ctx, stmt, dtype, len, BYTEORDER_BIG_ENDIAN,
+				 expr);
 }
 
 static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
@@ -2321,7 +2324,7 @@ static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 
 	return stmt_evaluate_arg(ctx, stmt,
 				 &inet_service_type, 2 * BITS_PER_BYTE,
-				 expr);
+				 BYTEORDER_BIG_ENDIAN, expr);
 }
 
 static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
@@ -2400,6 +2403,7 @@ static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 		if (stmt->dup.dev != NULL) {
 			err = stmt_evaluate_arg(ctx, stmt, &ifindex_type,
 						sizeof(uint32_t) * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN,
 						&stmt->dup.dev);
 			if (err < 0)
 				return err;
@@ -2414,7 +2418,7 @@ static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 
 		err = stmt_evaluate_arg(ctx, stmt, &ifindex_type,
 					sizeof(uint32_t) * BITS_PER_BYTE,
-					&stmt->dup.to);
+					BYTEORDER_HOST_ENDIAN, &stmt->dup.to);
 		if (err < 0)
 			return err;
 		break;
@@ -2436,7 +2440,7 @@ static int stmt_evaluate_fwd(struct eval_ctx *ctx, struct stmt *stmt)
 
 		err = stmt_evaluate_arg(ctx, stmt, &ifindex_type,
 					sizeof(uint32_t) * BITS_PER_BYTE,
-					&stmt->fwd.to);
+					BYTEORDER_HOST_ENDIAN, &stmt->fwd.to);
 		if (err < 0)
 			return err;
 		break;
@@ -2450,6 +2454,7 @@ static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt->queue.queue != NULL) {
 		if (stmt_evaluate_arg(ctx, stmt, &integer_type, 16,
+				      BYTEORDER_HOST_ENDIAN,
 				      &stmt->queue.queue) < 0)
 			return -1;
 		if (!expr_is_constant(stmt->queue.queue))
@@ -2490,6 +2495,7 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 	if (stmt_evaluate_arg(ctx, stmt,
 			      stmt->set.set->set->keytype,
 			      stmt->set.set->set->keylen,
+			      stmt->set.set->set->keytype->byteorder,
 			      &stmt->set.key) < 0)
 		return -1;
 	if (expr_is_constant(stmt->set.key))
@@ -2576,7 +2582,7 @@ static int stmt_evaluate_objref(struct eval_ctx *ctx, struct stmt *stmt)
 
 	if (stmt_evaluate_arg(ctx, stmt,
 			      &string_type, NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE,
-			      &stmt->objref.expr) < 0)
+			      BYTEORDER_HOST_ENDIAN, &stmt->objref.expr) < 0)
 		return -1;
 
 	if (!expr_is_constant(stmt->objref.expr))
-- 
2.1.4

