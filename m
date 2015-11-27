From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v2] netlink_delinearize: fix use-after-free
Date: Fri, 27 Nov 2015 12:24:22 +0100
Message-ID: <1448623462-2817-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42554 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbbK0LYh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 06:24:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 22566FEFA0
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2015 12:24:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 13DACDA803
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2015 12:24:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 36F70DA801
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2015 12:24:31 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to clone the payload expression before attaching it to the lhs
of the relational expression, this payload expression is located at the
lhs of the binary operation that is released thereafter.

Fixes: 39f15c2 ("nft: support listing expressions that use non-byte header fields")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use expr_get() instead to avoid the extra cost of cloning.

 src/netlink_delinearize.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b119027..6ae7267 100644
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
+			expr->left = expr_get(payload);
 			expr_free(binop);
 		}
 	}
-- 
2.1.4

