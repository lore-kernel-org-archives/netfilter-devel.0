From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink_delinearize: fix use-after-free
Date: Fri, 27 Nov 2015 12:12:45 +0100
Message-ID: <1448622765-2519-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37513 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbbK0LMw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 06:12:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 78BEBFB453
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2015 12:12:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 68537DA80B
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2015 12:12:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7DCAFDA80B
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2015 12:12:48 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to clone the payload expression before attaching it to the lhs
of the relational expression, this payload expression is located at the
lhs of the binary operation that is released thereafter.

Fixes: 39f15c2 ("nft: support listing expressions that use non-byte header fields")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b119027..1ab8f43 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1217,8 +1217,8 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 	} else if (binop->op == OP_AND &&
 		   binop->left->ops->type == EXPR_PAYLOAD &&
 		   binop->right->ops->type == EXPR_VALUE) {
-		struct expr *payload = expr->left->left;
-		struct expr *mask = expr->left->right;
+		struct expr *payload = binop->left;
+		struct expr *mask = binop->right;
 
 		/*
 		 * This *might* be a payload match testing header fields that
@@ -1266,7 +1266,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 			assert(expr->left->ops->type == EXPR_BINOP);
 
 			assert(binop->left == payload);
-			expr->left = payload;
+			expr->left = expr_clone(payload);
 			expr_free(binop);
 		}
 	}
-- 
2.1.4

