From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink_delinearize: prune implicit binop before payload_match_postprocess()
Date: Mon,  1 Feb 2016 14:32:45 +0100
Message-ID: <1454333565-2108-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49415 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219AbcBANdB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 08:33:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 271FC6C26
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 14:33:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 159C4DA811
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 14:33:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E1F0EDA860
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 14:32:57 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

payload_match_postprocess() expects a relational with payload of his lhs
and value on the rhs.

Moreover, payload_match_expand() releases the previous expression so
valgrind reports an use-after-free when pruning the implicit binop.

Fix this by calling payload_match_postprocess() in first place.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7d94f30..ae6abb0 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1229,13 +1229,12 @@ static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 			value->len = payload->len;
 		}
 
-		payload_match_postprocess(ctx, expr, payload);
-
 		assert(expr->left->ops->type == EXPR_BINOP);
-
 		assert(binop->left == payload);
 		expr->left = expr_get(payload);
 		expr_free(binop);
+
+		payload_match_postprocess(ctx, expr, payload);
 	}
 }
 
-- 
2.1.4

