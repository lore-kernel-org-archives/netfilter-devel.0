From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink_delink_delinearize: don't store dependency unless relop checks is eq check
Date: Tue,  9 May 2017 17:37:11 +0200
Message-ID: <20170509153711.26130-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44468 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754404AbdEIPhK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 11:37:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'ip protocol ne 6' is not a dependency for nexthdr protocol, and must
not be stored as such.

Fixes: 0b858391781ba308 ("src: annotate follow up dependency just after killing another")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index a65a97da89fb..f0288cd49914 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1332,7 +1332,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 			payload_dependency_store(&ctx->pdctx, nstmt, base - stacked);
 		} else {
 			payload_dependency_kill(&ctx->pdctx, nexpr->left);
-			if (left->flags & EXPR_F_PROTOCOL)
+			if (expr->op == OP_EQ && left->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(&ctx->pdctx, nstmt, base - stacked);
 		}
 	}
-- 
2.10.2

