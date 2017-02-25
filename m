From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink_delinearize: remove integer_type_postprocess()
Date: Sat, 25 Feb 2017 12:08:34 +0100
Message-ID: <1488020914-23192-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36398 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751306AbdBYLZ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Feb 2017 06:25:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9306CA4174
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 12:08:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83DA9DA725
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 12:08:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE517DA725
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 12:08:38 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not required anymore since the set definition now comes with the right
byteorder for integer types via NFTA_SET_USERDATA area. So we don't need
to look at the lhs anymore. Note that this was a workaround that does
not work with named sets, where we cannot assume we have a lhs, since
it is valid to have a named set that is not referenced from any rule.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 90553836be79..57b8fa5127e5 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1277,33 +1277,6 @@ struct stmt *netlink_parse_set_expr(const struct set *set,
 
 static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp);
 
-static void integer_type_postprocess(struct expr *expr)
-{
-	struct expr *i;
-
-	switch (expr->ops->type) {
-	case EXPR_VALUE:
-		if (expr->byteorder == BYTEORDER_HOST_ENDIAN) {
-			uint32_t len = div_round_up(expr->len, BITS_PER_BYTE);
-
-			mpz_switch_byteorder(expr->value, len);
-		}
-		break;
-	case EXPR_SET_REF:
-		list_for_each_entry(i, &expr->set->init->expressions, list) {
-			expr_set_type(i, expr->dtype, expr->byteorder);
-			integer_type_postprocess(i);
-		}
-		break;
-	case EXPR_SET_ELEM:
-		expr_set_type(expr->key, expr->dtype, expr->byteorder);
-		integer_type_postprocess(expr->key);
-		break;
-	default:
-		break;
-	}
-}
-
 static void payload_match_expand(struct rule_pp_ctx *ctx,
 				 struct expr *expr,
 				 struct expr *payload)
@@ -1392,8 +1365,6 @@ static void ct_meta_common_postprocess(const struct expr *expr)
 			break;
 	case OP_LOOKUP:
 		expr_set_type(right, left->dtype, left->byteorder);
-		if (right->dtype == &integer_type)
-			integer_type_postprocess(right);
 		break;
 
 	default:
-- 
2.1.4

