From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] expression: fix output of verdict maps
Date: Mon, 13 Jan 2014 13:39:16 +0100
Message-ID: <1389616756-8326-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49461 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaAMMjX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:39:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

% nft list table filter
table ip filter {
	...
	chain output {
		...
		ip saddr map { 1.1.1.1 => accept}
	}
}

It displays 'map' instead of 'vmap'. Fix it by checking the mapping
type in map_expr_print().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index 71154cc..97481d0 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -689,7 +689,11 @@ struct expr *mapping_expr_alloc(const struct location *loc,
 static void map_expr_print(const struct expr *expr)
 {
 	expr_print(expr->map);
-	printf(" map ");
+	if (expr->mappings->ops->type == EXPR_SET_REF &&
+	    expr->mappings->set->datatype->type == TYPE_VERDICT)
+		printf(" vmap ");
+	else
+		printf(" map ");
 	expr_print(expr->mappings);
 }
 
-- 
1.7.10.4

