From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] expression: fix printing of binary operation
Date: Wed, 15 Jan 2014 12:09:27 +0100
Message-ID: <1389784167-10198-2-git-send-email-pablo@netfilter.org>
References: <1389784167-10198-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40594 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaAOLKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:10:04 -0500
In-Reply-To: <1389784167-10198-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a special print function for the relational case in
which == is assumed, so it's not printed. It also fixes the output of
binary operations from:

& 0x00000003 0x00000001

to:

and 0x00000003 == 0x00000001

An example output of how thing are left after this patch follows:

% nft list table filter
table ip filter {
        chain output {
                 type filter hook output priority 0;
                 meta mark and 0x00000003 == 0x00000001 counter packets 0 bytes 0
                 meta mark 0x00000003 counter packets 0 bytes 0
        }
}

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index 6da5c10..452b0d7 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -411,7 +411,9 @@ static void binop_expr_print(const struct expr *expr)
 		printf(" %s ", expr_op_symbols[expr->op]);
 	else
 		printf(" ");
+
 	expr_print(expr->right);
+	printf(" ==");
 }
 
 static void binop_expr_clone(struct expr *new, const struct expr *expr)
@@ -447,10 +449,17 @@ struct expr *binop_expr_alloc(const struct location *loc, enum ops op,
 	return expr;
 }
 
+static void relational_expr_print(const struct expr *expr)
+{
+	expr_print(expr->left);
+	printf(" ");
+	expr_print(expr->right);
+}
+
 static const struct expr_ops relational_expr_ops = {
 	.type		= EXPR_RELATIONAL,
 	.name		= "relational",
-	.print		= binop_expr_print,
+	.print		= relational_expr_print,
 	.destroy	= binop_expr_destroy,
 };
 
-- 
1.7.10.4

