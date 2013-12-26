From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink: add support to set meta keys
Date: Thu, 26 Dec 2013 20:36:17 +0100
Message-ID: <1388086577-6707-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49619 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab3LZTga (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:36:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arturo Borrero added kernel support to set meta keys in
http://patchwork.ozlabs.org/patch/305281/ and the corresponding
library support in http://patchwork.ozlabs.org/patch/305283/.

This patch enhances nft to use this new kernel feature. The
following example shows how to set the packet mark.

% nft add rule ip filter input meta mark set 22
% nft list table filter
table ip filter {
        chain input {
                 type filter hook input priority 0;
                 meta mark set 0x00000016
        }
}

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c |   37 ++++++++++++++++++++++++++++++++++---
 src/netlink_linearize.c   |    2 ++
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7e4e38c..d1d35f8 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -325,9 +325,9 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 			     expr);
 }
 
-static void netlink_parse_meta(struct netlink_parse_ctx *ctx,
-			       const struct location *loc,
-			       const struct nft_rule_expr *nle)
+static void netlink_parse_meta_dreg(struct netlink_parse_ctx *ctx,
+				    const struct location *loc,
+				    const struct nft_rule_expr *nle)
 {
 	struct expr *expr;
 
@@ -338,6 +338,33 @@ static void netlink_parse_meta(struct netlink_parse_ctx *ctx,
 			     expr);
 }
 
+static void netlink_parse_meta_sreg(struct netlink_parse_ctx *ctx,
+				    const struct location *loc,
+				    const struct nft_rule_expr *nle)
+{
+	struct stmt *stmt;
+	struct expr *expr;
+
+	expr = netlink_get_register(ctx, loc,
+			nft_rule_expr_get_u8(nle, NFT_EXPR_META_SREG));
+	stmt = meta_stmt_alloc(loc,
+			       nft_rule_expr_get_u8(nle, NFT_EXPR_META_KEY),
+			       expr);
+	expr_set_type(expr, stmt->meta.tmpl->dtype, stmt->meta.tmpl->byteorder);
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
+static void netlink_parse_meta(struct netlink_parse_ctx *ctx,
+			       const struct location *loc,
+			       const struct nft_rule_expr *nle)
+{
+	if (nft_rule_expr_is_set(nle, NFT_EXPR_META_DREG))
+		netlink_parse_meta_dreg(ctx, loc, nle);
+	else
+		netlink_parse_meta_sreg(ctx, loc, nle);
+}
+
 static void netlink_parse_ct(struct netlink_parse_ctx *ctx,
 			     const struct location *loc,
 			     const struct nft_rule_expr *nle)
@@ -786,6 +813,10 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_EXPRESSION:
 			expr_postprocess(&rctx, stmt, &stmt->expr);
 			break;
+		case STMT_META:
+			if (stmt->meta.expr != NULL)
+				expr_postprocess(&rctx, stmt, &stmt->meta.expr);
+			break;
 		case STMT_NAT:
 			if (stmt->nat.addr != NULL)
 				expr_postprocess(&rctx, stmt, &stmt->nat.addr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index e64e92a..0ac0218 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -518,6 +518,8 @@ static void netlink_gen_meta_stmt(struct netlink_linearize_ctx *ctx,
 	release_register(ctx);
 
 	nle = alloc_nft_expr("meta");
+	nft_rule_expr_set_u32(nle, NFT_EXPR_META_SREG, sreg);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_META_KEY, stmt->meta.key);
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
-- 
1.7.10.4

