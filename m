From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] netlink_linearize: fix range cmp instruction generation
Date: Tue,  2 Jun 2015 12:57:39 +0200
Message-ID: <1433242661-32125-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58048 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbbFBK57 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 06:57:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The LHS expression is generated twice and the register not properly released.
Fix by calling netlink_gen_range() before generating the LHS.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_linearize.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 9bef67b..0a0b686 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -203,6 +203,9 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 
 	assert(dreg == NFT_REG_VERDICT);
 
+	if (expr->right->ops->type == EXPR_RANGE)
+		return netlink_gen_range(ctx, expr, dreg);
+
 	sreg = get_register(ctx);
 	netlink_gen_expr(ctx, expr->left, sreg);
 
@@ -229,8 +232,6 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 		right = expr->right->prefix;
 		break;
 		}
-	case EXPR_RANGE:
-		return netlink_gen_range(ctx, expr, dreg);
 	default:
 		right = expr->right;
 	}
-- 
2.1.0

