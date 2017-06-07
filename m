From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink_delinearize: prefer ct event set foo,bar over 'set foo|bar'
Date: Wed,  7 Jun 2017 17:16:47 +0200
Message-ID: <20170607151647.22788-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46402 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750920AbdFGPQa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 11:16:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Translate binop representation to a list-based one, so nft prints
"ct event destroy,new" instead of 'ct event destroy|new'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b355eff47222..3ee07c0a1306 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2205,8 +2205,13 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 				expr_postprocess(&rctx, &stmt->meta.expr);
 			break;
 		case STMT_CT:
-			if (stmt->ct.expr != NULL)
+			if (stmt->ct.expr != NULL) {
 				expr_postprocess(&rctx, &stmt->ct.expr);
+
+				if (stmt->ct.expr->ops->type == EXPR_BINOP)
+					stmt->ct.expr = binop_tree_to_list(NULL,
+									   stmt->ct.expr);
+			}
 			break;
 		case STMT_NAT:
 			if (stmt->nat.addr != NULL)
-- 
2.13.0

