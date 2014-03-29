From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] netfilter: nft_meta: split nft_meta_init() into two functions for get/set
Date: Sat, 29 Mar 2014 10:43:02 +0000
Message-ID: <1396089783-3984-3-git-send-email-kaber@trash.net>
References: <1396089783-3984-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 219.Red-2-139-50.dynamicIP.rima-tde.net ([2.139.50.219]:19630
	"EHLO macbook.localnet" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751417AbaC2K5C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Mar 2014 06:57:02 -0400
In-Reply-To: <1396089783-3984-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For value spanning multiple registers, we need to validate the length
of data loads. In order to add this to nft_meta, we need the length from
key validation. Split the nft_meta_init() function into two functions
for the get and set operations as preparation for that.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_meta.c | 65 ++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 35 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 425cf39..6d0b8cc2 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -170,21 +170,15 @@ static const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
 	[NFTA_META_SREG]	= { .type = NLA_U32 },
 };
 
-static int nft_meta_init_validate_set(uint32_t key)
+static int nft_meta_get_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
 {
-	switch (key) {
-	case NFT_META_MARK:
-	case NFT_META_PRIORITY:
-	case NFT_META_NFTRACE:
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
+	struct nft_meta *priv = nft_expr_priv(expr);
+	int err;
 
-static int nft_meta_init_validate_get(uint32_t key)
-{
-	switch (key) {
+	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
+	switch (priv->key) {
 	case NFT_META_LEN:
 	case NFT_META_PROTOCOL:
 	case NFT_META_NFPROTO:
@@ -205,39 +199,40 @@ static int nft_meta_init_validate_get(uint32_t key)
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
 #endif
-		return 0;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
+	priv->dreg = ntohl(nla_get_be32(tb[NFTA_META_DREG]));
+	err = nft_validate_output_register(priv->dreg);
+	if (err < 0)
+		return err;
+
+	err = nft_validate_data_load(ctx, priv->dreg, NULL, NFT_DATA_VALUE);
+	if (err < 0)
+		return err;
+
+	return 0;
 }
 
-static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			 const struct nlattr * const tb[])
+static int nft_meta_set_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	int err;
 
 	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
-
-	if (tb[NFTA_META_DREG]) {
-		err = nft_meta_init_validate_get(priv->key);
-		if (err < 0)
-			return err;
-
-		priv->dreg = ntohl(nla_get_be32(tb[NFTA_META_DREG]));
-		err = nft_validate_output_register(priv->dreg);
-		if (err < 0)
-			return err;
-
-		return nft_validate_data_load(ctx, priv->dreg, NULL,
-					      NFT_DATA_VALUE);
+	switch (priv->key) {
+	case NFT_META_MARK:
+	case NFT_META_PRIORITY:
+	case NFT_META_NFTRACE:
+		break;
+	default:
+		return -EOPNOTSUPP;
 	}
 
-	err = nft_meta_init_validate_set(priv->key);
-	if (err < 0)
-		return err;
-
 	priv->sreg = ntohl(nla_get_be32(tb[NFTA_META_SREG]));
 	err = nft_validate_input_register(priv->sreg);
 	if (err < 0)
@@ -282,7 +277,7 @@ static const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.eval		= nft_meta_get_eval,
-	.init		= nft_meta_init,
+	.init		= nft_meta_get_init,
 	.dump		= nft_meta_get_dump,
 };
 
@@ -290,7 +285,7 @@ static const struct nft_expr_ops nft_meta_set_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.eval		= nft_meta_set_eval,
-	.init		= nft_meta_init,
+	.init		= nft_meta_set_init,
 	.dump		= nft_meta_set_dump,
 };
 
-- 
1.9.0

