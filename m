From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/5] netfilter: nf_tables: restore notifications for anonymous set destruction
Date: Fri,  7 Mar 2014 19:08:31 +0100
Message-ID: <1394215713-32049-4-git-send-email-kaber@trash.net>
References: <1394215713-32049-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39702 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaCGSIf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:08:35 -0500
In-Reply-To: <1394215713-32049-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since we have the context available again, we can restore notifications
for destruction of anonymous sets.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 3 +--
 net/netfilter/nft_lookup.c    | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 55541ce..2c22fa2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2447,8 +2447,7 @@ err1:
 static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	list_del(&set->list);
-	if (!(set->flags & NFT_SET_ANONYMOUS))
-		nf_tables_set_notify(ctx, set, NFT_MSG_DELSET);
+	nf_tables_set_notify(ctx, set, NFT_MSG_DELSET);
 
 	set->ops->destroy(set);
 	module_put(set->ops->owner);
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 953978e..7fd2bea 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -94,7 +94,7 @@ static void nft_lookup_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(NULL, priv->set, &priv->binding);
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
 }
 
 static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
-- 
1.8.5.3

