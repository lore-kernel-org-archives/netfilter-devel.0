From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 6/7] evaluate: transfer right shifts to set reference side
Date: Sat,  5 Dec 2015 20:04:25 +0100
Message-ID: <1449342266-2756-6-git-send-email-pablo@netfilter.org>
References: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51095 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbbLETEl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 14:04:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id F0EBBDA86D
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DAFB5DA808
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 057C2DA732
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:39 +0100 (CET)
In-Reply-To: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This provides a generic way to transfer shifts from the left hand side
to the right hand range side of a relational expression when performing
transformations from the evaluation step.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c            | 14 ++++++++++++++
 src/netlink_delinearize.c | 19 ++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 0fcdb73..eb191ed 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1099,6 +1099,20 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 			list_add_tail(&i->list, &next->list);
 		}
 		break;
+	case EXPR_SET_REF:
+		list_for_each_entry(i, &(*expr)->right->set->init->expressions, list) {
+			err = binop_can_transfer(ctx, left, i->key);
+			if (err <= 0)
+				return err;
+		}
+		list_for_each_entry_safe(i, next, &(*expr)->right->set->init->expressions,
+					 list) {
+			list_del(&i->list);
+			if (binop_transfer_one(ctx, left, &i->key) < 0)
+				return -1;
+			list_add_tail(&i->list, &next->list);
+		}
+		break;
 	default:
 		return 0;
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8cbabc3..c5e5c69 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1184,8 +1184,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 		expr_free(value);
 		expr_free(binop);
 	} else if (binop->op == OP_AND &&
-		   binop->left->ops->type == EXPR_PAYLOAD &&
-		   binop->right->ops->type == EXPR_VALUE) {
+		   binop->left->ops->type == EXPR_PAYLOAD) {
 		struct expr *payload = binop->left;
 		struct expr *mask = binop->right;
 		unsigned int shift;
@@ -1223,10 +1222,24 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 			 * Finally, convert the expression to 1) by replacing
 			 * the binop with the binop payload expr.
 			 */
-			if (value->ops->type == EXPR_VALUE) {
+			switch (value->ops->type) {
+			case EXPR_VALUE:
 				assert(value->len >= expr->left->right->len);
 				mpz_rshift_ui(value->value, shift);
 				value->len = payload->len;
+				break;
+			case EXPR_SET_REF: {
+				struct expr *i;
+
+				list_for_each_entry(i, &value->set->init->expressions, list) {
+					assert(i->key->len >= expr->left->right->len);
+					mpz_rshift_ui(i->key->value, shift);
+					i->key->len = payload->len;
+				}
+				break;
+				}
+			default:
+				break;
 			}
 
 			payload_match_postprocess(ctx, expr, payload);
-- 
2.1.4

