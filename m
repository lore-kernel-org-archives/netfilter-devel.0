From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] expression: don't trim off unary expression on delinearization
Date: Fri, 26 May 2017 14:36:45 +0200
Message-ID: <1495802206-28856-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48170 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933321AbdEZMhA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 May 2017 08:37:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 313871DF5A1
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 14:36:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2211A100A6A
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 14:36:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23315FC3DB
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 14:36:47 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This transformation introduces an unnecessary asymmetry between the
linearization and delinearization steps that prevent rule deletion from
definition to work fine.

Moreover, do not print htonl and ntonl from unary expression, this
syntax is not allowed by the parser.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c          | 3 ---
 src/netlink_delinearize.c | 5 +----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 5defa63f4a5f..55dd391178c3 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -460,10 +460,7 @@ const char *expr_op_symbols[] = {
 
 static void unary_expr_print(const struct expr *expr)
 {
-	if (expr_op_symbols[expr->op] != NULL)
-		printf("%s(", expr_op_symbols[expr->op]);
 	expr_print(expr->arg);
-	printf(")");
 }
 
 static void unary_expr_clone(struct expr *new, const struct expr *expr)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 49dc6a6016ba..b355eff47222 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1759,10 +1759,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	}
 	case EXPR_UNARY:
 		expr_postprocess(ctx, &expr->arg);
-		expr_set_type(expr->arg, expr->arg->dtype, !expr->arg->byteorder);
-
-		*exprp = expr_get(expr->arg);
-		expr_free(expr);
+		expr_set_type(expr, expr->arg->dtype, !expr->arg->byteorder);
 		break;
 	case EXPR_BINOP:
 		expr_postprocess(ctx, &expr->left);
-- 
2.1.4

