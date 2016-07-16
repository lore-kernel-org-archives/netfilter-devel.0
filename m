From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nft_ct: fix unpaired nf_connlabels_get/put call
Date: Sat, 16 Jul 2016 14:27:21 +0800
Message-ID: <1468650441-17407-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:41330 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbcGPG2C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jul 2016 02:28:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

We only get nf_connlabels if the user add ct label set expr successfully,
but we will also put nf_connlabels if the user delete ct lable get expr.
This is mismathced, and will cause ct label expr cannot work properly.

Also, if we init something fail, we should put nf_connlabels back.
Otherwise, we may waste to alloc the memory that will never be used.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_ct.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 81fbb45..4726a2e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -359,6 +359,7 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_ct *priv = nft_expr_priv(expr);
+	bool label_got = false;
 	unsigned int len;
 	int err;
 
@@ -377,6 +378,7 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		err = nf_connlabels_get(ctx->net, (len * BITS_PER_BYTE) - 1);
 		if (err)
 			return err;
+		label_got = true;
 		break;
 #endif
 	default:
@@ -386,17 +388,28 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 	priv->sreg = nft_parse_register(tb[NFTA_CT_SREG]);
 	err = nft_validate_register_load(priv->sreg, len);
 	if (err < 0)
-		return err;
+		goto err1;
 
 	err = nft_ct_l3proto_try_module_get(ctx->afi->family);
 	if (err < 0)
-		return err;
+		goto err1;
 
 	return 0;
+
+err1:
+	if (label_got)
+		nf_connlabels_put(ctx->net);
+	return err;
+}
+
+static void nft_ct_get_destroy(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr)
+{
+	nft_ct_l3proto_module_put(ctx->afi->family);
 }
 
-static void nft_ct_destroy(const struct nft_ctx *ctx,
-			   const struct nft_expr *expr)
+static void nft_ct_set_destroy(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr)
 {
 	struct nft_ct *priv = nft_expr_priv(expr);
 
@@ -468,7 +481,7 @@ static const struct nft_expr_ops nft_ct_get_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
 	.eval		= nft_ct_get_eval,
 	.init		= nft_ct_get_init,
-	.destroy	= nft_ct_destroy,
+	.destroy	= nft_ct_get_destroy,
 	.dump		= nft_ct_get_dump,
 };
 
@@ -477,7 +490,7 @@ static const struct nft_expr_ops nft_ct_set_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
 	.eval		= nft_ct_set_eval,
 	.init		= nft_ct_set_init,
-	.destroy	= nft_ct_destroy,
+	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
 };
 
-- 
2.5.5


