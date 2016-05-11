From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 03/12] evaluate: transfer right shifts to set reference side
Date: Wed, 11 May 2016 23:05:07 +0200
Message-ID: <1463000716-11885-3-git-send-email-pablo@netfilter.org>
References: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40450 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbcEKVF1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 17:05:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 05C3A1BD5B7
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E7B0ACA0FF
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DB74EFF153
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:22 +0200 (CEST)
In-Reply-To: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This provides a generic way to transfer shifts from the left hand side
to the right hand range side of a relational expression when performing
transformations from the evaluation step.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c            | 40 +++++++++++++++++++++++++++++++
 src/netlink_delinearize.c | 60 ++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 94 insertions(+), 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 60bbce1..72a0e43 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1172,6 +1172,46 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr)
 			list_add_tail(&i->list, &next->list);
 		}
 		break;
+	case EXPR_SET_REF:
+		list_for_each_entry(i, &(*expr)->right->set->init->expressions, list) {
+			switch (i->key->ops->type) {
+			case EXPR_VALUE:
+				err = binop_can_transfer(ctx, left, i->key);
+				if (err <= 0)
+					return err;
+				break;
+			case EXPR_RANGE:
+				err = binop_can_transfer(ctx, left, i->key->left);
+				if (err <= 0)
+					return err;
+				err = binop_can_transfer(ctx, left, i->key->right);
+				if (err <= 0)
+					return err;
+				break;
+			default:
+				break;
+			}
+		}
+		list_for_each_entry_safe(i, next, &(*expr)->right->set->init->expressions,
+					 list) {
+			list_del(&i->list);
+			switch (i->key->ops->type) {
+			case EXPR_VALUE:
+				if (binop_transfer_one(ctx, left, &i->key) < 0)
+					return -1;
+				break;
+			case EXPR_RANGE:
+				if (binop_transfer_one(ctx, left, &i->key->left) < 0)
+					return -1;
+				if (binop_transfer_one(ctx, left, &i->key->right) < 0)
+					return -1;
+				break;
+			default:
+				break;
+			}
+			list_add_tail(&i->list, &next->list);
+		}
+		break;
 	default:
 		return 0;
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 84f94fc..eb07ffb 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1185,9 +1185,61 @@ static struct expr *binop_tree_to_list(struct expr *list, struct expr *expr)
 	return list;
 }
 
+static void binop_adjust_one(const struct expr *binop, struct expr *value,
+			     unsigned int shift)
+{
+	struct expr *left = binop->left;
+
+	assert(value->len >= binop->right->len);
+
+	mpz_rshift_ui(value->value, shift);
+	switch (left->ops->type) {
+	case EXPR_PAYLOAD:
+	case EXPR_EXTHDR:
+		value->len = left->len;
+		break;
+	default:
+		BUG("unknown expression type %s\n", left->ops->name);
+		break;
+	}
+}
+
+static void binop_adjust(struct expr *expr, unsigned int shift)
+{
+	const struct expr *binop = expr->left;
+	struct expr *right = expr->right, *i;
+
+	switch (right->ops->type) {
+	case EXPR_VALUE:
+		binop_adjust_one(binop, right, shift);
+		break;
+	case EXPR_SET_REF:
+		list_for_each_entry(i, &right->set->init->expressions, list) {
+			switch (i->key->ops->type) {
+			case EXPR_VALUE:
+				binop_adjust_one(binop, i->key, shift);
+				break;
+			case EXPR_RANGE:
+				binop_adjust_one(binop, i->key->left, shift);
+				binop_adjust_one(binop, i->key->right, shift);
+				break;
+			case EXPR_SET_ELEM:
+				binop_adjust_one(binop, i->key->key, shift);
+				break;
+			default:
+				BUG("unknown expression type %s\n", i->key->ops->name);
+			}
+		}
+		break;
+	default:
+		BUG("unknown expression type %s\n", expr->ops->name);
+		break;
+	}
+}
+
 static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 {
-	struct expr *binop = expr->left, *value = expr->right;
+	struct expr *binop = expr->left;
 	struct expr *left = binop->left;
 	struct expr *mask = binop->right;
 	unsigned int shift;
@@ -1205,11 +1257,7 @@ static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 		 * Finally, convert the expression to 1) by replacing
 		 * the binop with the binop payload/exthdr expression.
 		 */
-		if (value->ops->type == EXPR_VALUE) {
-			assert(value->len >= expr->left->right->len);
-			mpz_rshift_ui(value->value, shift);
-			value->len = left->len;
-		}
+		binop_adjust(expr, shift);
 
 		assert(expr->left->ops->type == EXPR_BINOP);
 		assert(binop->left == left);
-- 
2.1.4

