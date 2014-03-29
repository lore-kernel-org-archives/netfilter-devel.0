From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] netfilter: nft_ct: split nft_ct_init() into two functions for get/set
Date: Sat, 29 Mar 2014 10:43:03 +0000
Message-ID: <1396089783-3984-4-git-send-email-kaber@trash.net>
References: <1396089783-3984-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 219.Red-2-139-50.dynamicIP.rima-tde.net ([2.139.50.219]:19630
	"EHLO macbook.localnet" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751454AbaC2K5E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Mar 2014 06:57:04 -0400
In-Reply-To: <1396089783-3984-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For value spanning multiple registers, we need to validate the length
of data loads. In order to add this to nft_ct, we need the length from
key validation. Split the nft_ct_init() function into two functions
for the get and set operations as preparation for that.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_ct.c | 96 ++++++++++++++++++++++----------------------------
 1 file changed, 43 insertions(+), 53 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a2c45bd..cc56030 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -215,22 +215,14 @@ static void nft_ct_l3proto_module_put(uint8_t family)
 		nf_ct_l3proto_module_put(family);
 }
 
-static int nft_ct_init_validate_get(const struct nft_expr *expr,
-				    const struct nlattr * const tb[])
+static int nft_ct_get_init(const struct nft_ctx *ctx,
+			   const struct nft_expr *expr,
+			   const struct nlattr * const tb[])
 {
 	struct nft_ct *priv = nft_expr_priv(expr);
+	int err;
 
-	if (tb[NFTA_CT_DIRECTION] != NULL) {
-		priv->dir = nla_get_u8(tb[NFTA_CT_DIRECTION]);
-		switch (priv->dir) {
-		case IP_CT_DIR_ORIGINAL:
-		case IP_CT_DIR_REPLY:
-			break;
-		default:
-			return -EINVAL;
-		}
-	}
-
+	priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
 	switch (priv->key) {
 	case NFT_CT_STATE:
 	case NFT_CT_DIRECTION:
@@ -262,12 +254,42 @@ static int nft_ct_init_validate_get(const struct nft_expr *expr,
 		return -EOPNOTSUPP;
 	}
 
+	if (tb[NFTA_CT_DIRECTION] != NULL) {
+		priv->dir = nla_get_u8(tb[NFTA_CT_DIRECTION]);
+		switch (priv->dir) {
+		case IP_CT_DIR_ORIGINAL:
+		case IP_CT_DIR_REPLY:
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	priv->dreg = ntohl(nla_get_be32(tb[NFTA_CT_DREG]));
+	err = nft_validate_output_register(priv->dreg);
+	if (err < 0)
+		return err;
+
+	err = nft_validate_data_load(ctx, priv->dreg, NULL, NFT_DATA_VALUE);
+	if (err < 0)
+		return err;
+
+	err = nft_ct_l3proto_try_module_get(ctx->afi->family);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
 
-static int nft_ct_init_validate_set(uint32_t key)
+static int nft_ct_set_init(const struct nft_ctx *ctx,
+			   const struct nft_expr *expr,
+			   const struct nlattr * const tb[])
 {
-	switch (key) {
+	struct nft_ct *priv = nft_expr_priv(expr);
+	int err;
+
+	priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
+	switch (priv->key) {
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
 		break;
@@ -276,42 +298,10 @@ static int nft_ct_init_validate_set(uint32_t key)
 		return -EOPNOTSUPP;
 	}
 
-	return 0;
-}
-
-static int nft_ct_init(const struct nft_ctx *ctx,
-		       const struct nft_expr *expr,
-		       const struct nlattr * const tb[])
-{
-	struct nft_ct *priv = nft_expr_priv(expr);
-	int err;
-
-	priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
-
-	if (tb[NFTA_CT_DREG]) {
-		err = nft_ct_init_validate_get(expr, tb);
-		if (err < 0)
-			return err;
-
-		priv->dreg = ntohl(nla_get_be32(tb[NFTA_CT_DREG]));
-		err = nft_validate_output_register(priv->dreg);
-		if (err < 0)
-			return err;
-
-		err = nft_validate_data_load(ctx, priv->dreg, NULL,
-					     NFT_DATA_VALUE);
-		if (err < 0)
-			return err;
-	} else {
-		err = nft_ct_init_validate_set(priv->key);
-		if (err < 0)
-			return err;
-
-		priv->sreg = ntohl(nla_get_be32(tb[NFTA_CT_SREG]));
-		err = nft_validate_input_register(priv->sreg);
-		if (err < 0)
-			return err;
-	}
+	priv->sreg = ntohl(nla_get_be32(tb[NFTA_CT_SREG]));
+	err = nft_validate_input_register(priv->sreg);
+	if (err < 0)
+		return err;
 
 	err = nft_ct_l3proto_try_module_get(ctx->afi->family);
 	if (err < 0)
@@ -372,7 +362,7 @@ static const struct nft_expr_ops nft_ct_get_ops = {
 	.type		= &nft_ct_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
 	.eval		= nft_ct_get_eval,
-	.init		= nft_ct_init,
+	.init		= nft_ct_get_init,
 	.destroy	= nft_ct_destroy,
 	.dump		= nft_ct_get_dump,
 };
@@ -381,7 +371,7 @@ static const struct nft_expr_ops nft_ct_set_ops = {
 	.type		= &nft_ct_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
 	.eval		= nft_ct_set_eval,
-	.init		= nft_ct_init,
+	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_destroy,
 	.dump		= nft_ct_set_dump,
 };
-- 
1.9.0

