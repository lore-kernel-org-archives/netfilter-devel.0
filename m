From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nft_compat: call {target,match}->destroy() to cleanup entry
Date: Wed, 11 Jun 2014 14:27:46 +0200
Message-ID: <1402489666-3620-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48791 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386AbaFKMgA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:36:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise, the reference to external objects (eg. modules) are not
released when the rules are removed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 8a779be..1840989 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -195,6 +195,15 @@ static void
 nft_target_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	struct xt_target *target = expr->ops->data;
+	void *info = nft_expr_priv(expr);
+	struct xt_tgdtor_param par;
+
+	par.net = ctx->net;
+	par.target = target;
+	par.targinfo = info;
+	par.family = ctx->afi->family;
+	if (par.target->destroy != NULL)
+		par.target->destroy(&par);
 
 	module_put(target->me);
 }
@@ -382,6 +391,15 @@ static void
 nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	struct xt_match *match = expr->ops->data;
+	void *info = nft_expr_priv(expr);
+	struct xt_mtdtor_param par;
+
+	par.net = ctx->net;
+	par.match = match;
+	par.matchinfo = info;
+	par.family = ctx->afi->family;
+	if (par.match->destroy != NULL)
+		par.match->destroy(&par);
 
 	module_put(match->me);
 }
-- 
1.7.10.4

