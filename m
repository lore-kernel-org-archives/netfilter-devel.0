From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 3/4] src: fix byteorder conversions in range values
Date: Mon, 28 Jul 2014 13:51:50 +0200
Message-ID: <1406548311-31354-4-git-send-email-alvaroneay@gmail.com>
References: <1406548311-31354-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:63484 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaG1LwB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:52:01 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so7015716wgh.21
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2014 04:52:00 -0700 (PDT)
In-Reply-To: <1406548311-31354-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently if we try to use range values in nft rules doesn't
work correctly. Usually this problems are for doing incorrect byteorder
conversion or for having not too much info for converting the values in
the correct byteorder.

I have designed some solutions for the different kind of datatype:

* If we have a rule that the byteorder are big endian

  nft add rule filter input tcp dport 22-25

  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp gte reg 1 0x00001600 ]
  [ cmp lte reg 1 0x00001900 ]

  In this case, we have sufficient for changing the values in the byteorder,
  that we expect and we change it without problem.

* If we have a rule that we use integer_type, in this case the byteorder
  associate to this value are INVALID:

  nft add rule filter input tcp checksum 22-25

  We usually expect this values from the network in big endian, for that I have
  added a unary expression for changing the register. That solves the problem
  that we have had in delinealize step for having the same rule that we have
  added (usually we have had byteorder problem and we show the rules values in
  wrong byteorder format)

  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 16 => reg 1 ]
  [ byteorder reg 1 = hton(reg 1, 2, 2) ]
  [ cmp gte reg 1 0x00000016 ]
  [ cmp lte reg 1 0x00000019 ]

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/evaluate.c            |   27 +++++++++++++++++++--------
 src/netlink_delinearize.c |   22 +++++++++++++++++++++-
 2 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ecd7dfa..74a7506 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -149,8 +149,15 @@ static enum ops byteorder_conversion_op(struct expr *expr,
 	default:
 		break;
 	}
-	BUG("invalid byte order conversion %u => %u\n",
-	    expr->byteorder, byteorder);
+	/* If we have a value with INVALID format, we must to say what
+	 * kind of unary expression we want to add for comparing the
+	 * value with the register
+	 */
+	if (byteorder != BYTEORDER_HOST_ENDIAN)
+		return OP_NTOH;
+
+	expr->byteorder = BYTEORDER_HOST_ENDIAN;
+	return OP_HTON;
 }
 
 static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
@@ -1031,12 +1038,16 @@ range:
 			break;
 		}
 
-		if (byteorder_conversion(ctx, &rel->left, BYTEORDER_BIG_ENDIAN) < 0)
-			return -1;
-		if (byteorder_conversion(ctx, &right->left, BYTEORDER_BIG_ENDIAN) < 0)
-			return -1;
-		if (byteorder_conversion(ctx, &right->right, BYTEORDER_BIG_ENDIAN) < 0)
-			return -1;
+		switch (rel->left->dtype->byteorder) {
+		case BYTEORDER_INVALID:
+			if (byteorder_conversion(ctx, &rel->left,
+						 BYTEORDER_HOST_ENDIAN) < 0)
+				return -1;
+			break;
+		case BYTEORDER_BIG_ENDIAN:
+		default:
+			break;
+		}
 		break;
 	default:
 		BUG("invalid relational operation %u\n", rel->op);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index c45b3b4..5fdf7e2 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -627,6 +627,18 @@ static void payload_dependency_store(struct rule_pp_ctx *ctx,
 	ctx->pdep  = stmt;
 }
 
+static void expr_payload_elem_postprocess(struct expr *expr)
+{
+	switch (expr->ops->type) {
+	case EXPR_VALUE:
+		if (expr->dtype->byteorder == BYTEORDER_BIG_ENDIAN)
+			mpz_switch_expr_byteorder(expr);
+		break;
+	default:
+		break;
+	}
+}
+
 static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 				      struct stmt *stmt, struct expr *expr)
 {
@@ -648,7 +660,6 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 			if (expr->op == OP_EQ)
 				left->ops->pctx_update(&ctx->pctx, nexpr);
 
-
 	 /* We have to convert the values that we obtained from the kernel to
 	  * host byteorder. Therefore, we assume that the values are in host
 	  * endian after the delinearization.
@@ -677,6 +688,15 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		payload_expr_complete(left, &ctx->pctx);
 		expr_set_type(expr->right, expr->left->dtype,
 			      expr->left->byteorder);
+
+		/* If we have rules that we have used payload with ranges or set
+		 * we must to convert it to host endian for representing it
+		 * correctly
+		 */
+		if (left->dtype->byteorder == BYTEORDER_BIG_ENDIAN)
+			expr_payload_elem_postprocess(expr->right);
+
 		payload_dependency_kill(ctx, expr->left);
 		break;
 	}
-- 
1.7.10.4

