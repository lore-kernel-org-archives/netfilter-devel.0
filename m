From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 4/4] src: fix byteorder conversions in sets
Date: Mon, 28 Jul 2014 13:51:51 +0200
Message-ID: <1406548311-31354-5-git-send-email-alvaroneay@gmail.com>
References: <1406548311-31354-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:65067 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaG1LwD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:52:03 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so7100312wgh.33
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2014 04:52:01 -0700 (PDT)
In-Reply-To: <1406548311-31354-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, we have wrong byteorder conversions if we want to use
set some nft rules or in some case errors. I have designed a solution for the
different kind of rules with different byteorder:

* For rules with big endian value:

  nft add rule filter input tcp dport {22-25}

  set%d filter 7
  set%d filter 0
  element 00000000 : 1 [end] element 00001600 : 0 [end] element 00001901 : 1 [end]
  ip filter input
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ lookup reg 1 set set%d ]

  In that case, we are going to change it the values inside of the set to big
  endian byteorder.

* For rules with invalid byteorder:

  nft add rule filter input tcp checksum {22-25}

  set%d filter 7
  set%d filter 0
  element 00000000 :1 [end] element 00000016 :0 [end] element 0000001a : 1 [end]
  ip filter input
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 16 => reg 1 ]
  [ byteorder reg 1 = hton(reg 1, 2, 2) ]
  [ lookup reg 1 set set%d ]

  In that case, we are going to add a unary expression for changing the register
  previously to comparing it with the values inside of our set.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/evaluate.c            |   12 ++++++++----
 src/netlink_delinearize.c |   12 ++++++++++++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index d09cb27..4521b92 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -934,11 +934,15 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 						 left->dtype->desc,
 						 right->dtype->desc);
 
-		/* Data for range lookups needs to be in big endian order */
+		/* Data for range with invalid byteorder, we must to add
+		 * a unary expression for changing the register for comparing it
+		 */
 		if (right->set->flags & SET_F_INTERVAL &&
-		    byteorder_conversion(ctx, &rel->left,
-					 BYTEORDER_BIG_ENDIAN) < 0)
-			return -1;
+		    rel->left->byteorder == BYTEORDER_INVALID) {
+			if (byteorder_conversion(ctx, &rel->left,
+						 BYTEORDER_HOST_ENDIAN) < 0)
+				return -1;
+		}
 		left = rel->left;
 		break;
 	case OP_EQ:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 015c211..1b2ffa6 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -629,11 +629,21 @@ static void payload_dependency_store(struct rule_pp_ctx *ctx,
 
 static void expr_payload_elem_postprocess(struct expr *expr)
 {
+	struct expr *i;
+
 	switch (expr->ops->type) {
 	case EXPR_VALUE:
 		if (expr->dtype->byteorder == BYTEORDER_BIG_ENDIAN)
 			mpz_switch_expr_byteorder(expr);
 		break;
+	case EXPR_SET_REF:
+		list_for_each_entry(i, &expr->set->init->expressions, list)
+			expr_payload_elem_postprocess(i);
+		break;
+	case EXPR_RANGE:
+		expr_payload_elem_postprocess(expr->right);
+		expr_payload_elem_postprocess(expr->left);
+		break;
 	default:
 		break;
 	}
@@ -891,6 +901,8 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 		expr_postprocess(ctx, stmt, &expr->right);
 		break;
 	case EXPR_SET_REF:
+		expr_postprocess(ctx, stmt, &expr->set->init);
+		break;
 	case EXPR_EXTHDR:
 	case EXPR_META:
 	case EXPR_CT:
-- 
1.7.10.4

