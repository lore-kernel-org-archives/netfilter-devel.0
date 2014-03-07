From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/5] netfilter: nft_ct: remove family from struct nft_ct
Date: Fri,  7 Mar 2014 19:08:32 +0100
Message-ID: <1394215713-32049-5-git-send-email-kaber@trash.net>
References: <1394215713-32049-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39704 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaCGSIf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:08:35 -0500
In-Reply-To: <1394215713-32049-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since we have the context available during destruction again, we can
remove the family from the private structure.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_ct.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 65a2c7b..bd0d41e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -24,11 +24,10 @@
 struct nft_ct {
 	enum nft_ct_keys	key:8;
 	enum ip_conntrack_dir	dir:8;
-	union{
+	union {
 		enum nft_registers	dreg:8;
 		enum nft_registers	sreg:8;
 	};
-	uint8_t			family;
 };
 
 static void nft_ct_get_eval(const struct nft_expr *expr,
@@ -316,17 +315,13 @@ static int nft_ct_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	priv->family = ctx->afi->family;
-
 	return 0;
 }
 
 static void nft_ct_destroy(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr)
 {
-	struct nft_ct *priv = nft_expr_priv(expr);
-
-	nft_ct_l3proto_module_put(priv->family);
+	nft_ct_l3proto_module_put(ctx->afi->family);
 }
 
 static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
-- 
1.8.5.3

