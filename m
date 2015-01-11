From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 5/6] netlink_delinearize: rename netlink_parse_*_sreg/dreg functions
Date: Sun, 11 Jan 2015 08:09:41 +0000
Message-ID: <1420963782-21189-6-git-send-email-kaber@trash.net>
References: <1420963782-21189-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54800 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbbAKIJu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:09:50 -0500
In-Reply-To: <1420963782-21189-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These are really badly chosen names, use parse_expr and parse_stmt instead.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_delinearize.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 79d5af6..5a89fce 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -342,7 +342,7 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 			     expr);
 }
 
-static void netlink_parse_meta_dreg(struct netlink_parse_ctx *ctx,
+static void netlink_parse_meta_expr(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nft_rule_expr *nle)
 {
@@ -355,7 +355,7 @@ static void netlink_parse_meta_dreg(struct netlink_parse_ctx *ctx,
 			     expr);
 }
 
-static void netlink_parse_meta_sreg(struct netlink_parse_ctx *ctx,
+static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nft_rule_expr *nle)
 {
@@ -377,12 +377,12 @@ static void netlink_parse_meta(struct netlink_parse_ctx *ctx,
 			       const struct nft_rule_expr *nle)
 {
 	if (nft_rule_expr_is_set(nle, NFT_EXPR_META_DREG))
-		netlink_parse_meta_dreg(ctx, loc, nle);
+		netlink_parse_meta_expr(ctx, loc, nle);
 	else
-		netlink_parse_meta_sreg(ctx, loc, nle);
+		netlink_parse_meta_stmt(ctx, loc, nle);
 }
 
-static void netlink_parse_ct_sreg(struct netlink_parse_ctx *ctx,
+static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nft_rule_expr *nle)
 {
@@ -400,7 +400,7 @@ static void netlink_parse_ct_sreg(struct netlink_parse_ctx *ctx,
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
-static void netlink_parse_ct_dreg(struct netlink_parse_ctx *ctx,
+static void netlink_parse_ct_expr(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nft_rule_expr *nle)
 {
@@ -417,9 +417,9 @@ static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
 			     const struct nft_rule_expr *nle)
 {
 	if (nft_rule_expr_is_set(nle, NFT_EXPR_CT_DREG))
-		netlink_parse_ct_dreg(ctx, loc, nle);
+		netlink_parse_ct_expr(ctx, loc, nle);
 	else
-		netlink_parse_ct_sreg(ctx, loc, nle);
+		netlink_parse_ct_stmt(ctx, loc, nle);
 }
 
 static void netlink_parse_counter(struct netlink_parse_ctx *ctx,
-- 
2.1.0

