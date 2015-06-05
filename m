From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 5/9] netlink_linearize: generate concat expressions
Date: Fri,  5 Jun 2015 15:42:47 +0200
Message-ID: <1433511771-4620-6-git-send-email-kaber@trash.net>
References: <1433511771-4620-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59942 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbbFENm4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 09:42:56 -0400
In-Reply-To: <1433511771-4620-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the real length for reserving/releasing registers when generating
concat expressions.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_linearize.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 6930b39..bf1e56b 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -68,13 +68,19 @@ static void __release_register(struct netlink_linearize_ctx *ctx,
 static enum nft_registers get_register(struct netlink_linearize_ctx *ctx,
 				       const struct expr *expr)
 {
-	return __get_register(ctx, NFT_REG_SIZE * BITS_PER_BYTE);
+	if (expr && expr->ops->type == EXPR_CONCAT)
+		return __get_register(ctx, expr->len);
+	else
+		return __get_register(ctx, NFT_REG_SIZE * BITS_PER_BYTE);
 }
 
 static void release_register(struct netlink_linearize_ctx *ctx,
 			     const struct expr *expr)
 {
-	__release_register(ctx, NFT_REG_SIZE * BITS_PER_BYTE);
+	if (expr && expr->ops->type == EXPR_CONCAT)
+		__release_register(ctx, expr->len);
+	else
+		__release_register(ctx, NFT_REG_SIZE * BITS_PER_BYTE);
 }
 
 static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
@@ -87,8 +93,10 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 {
 	const struct expr *i;
 
-	list_for_each_entry(i, &expr->expressions, list)
+	list_for_each_entry(i, &expr->expressions, list) {
 		netlink_gen_expr(ctx, i, dreg);
+		dreg += netlink_register_space(i->len);
+	}
 }
 
 static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
-- 
2.1.0

