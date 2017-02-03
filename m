From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/9] netfilter: nft_ct: prepare for key-dependent error unwind
Date: Fri,  3 Feb 2017 13:35:49 +0100
Message-ID: <20170203123556.17357-3-fw@strlen.de>
References: <20170203123556.17357-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41960 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752700AbdBCMfp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 07:35:45 -0500
In-Reply-To: <20170203123556.17357-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Next patch will add ZONE_ID set support which will need similar
error unwind (put operation) as conntrack labels.

Prepare for this: remove the 'label_got' boolean in favor
of a switch statement that can be extended in next patch.

As we already have that in the set_destroy function place that in
a separate function and call it from the set init function.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_ct.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 5bd4cdfdcda5..2d82df2737da 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -386,12 +386,24 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
+{
+	switch (priv->key) {
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	case NFT_CT_LABELS:
+		nf_connlabels_put(ctx->net);
+		break;
+#endif
+	default:
+		break;
+	}
+}
+
 static int nft_ct_set_init(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr,
 			   const struct nlattr * const tb[])
 {
 	struct nft_ct *priv = nft_expr_priv(expr);
-	bool label_got = false;
 	unsigned int len;
 	int err;
 
@@ -412,7 +424,6 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		err = nf_connlabels_get(ctx->net, (len * BITS_PER_BYTE) - 1);
 		if (err)
 			return err;
-		label_got = true;
 		break;
 #endif
 	default:
@@ -431,8 +442,7 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 	return 0;
 
 err1:
-	if (label_got)
-		nf_connlabels_put(ctx->net);
+	__nft_ct_set_destroy(ctx, priv);
 	return err;
 }
 
@@ -447,16 +457,7 @@ static void nft_ct_set_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_ct *priv = nft_expr_priv(expr);
 
-	switch (priv->key) {
-#ifdef CONFIG_NF_CONNTRACK_LABELS
-	case NFT_CT_LABELS:
-		nf_connlabels_put(ctx->net);
-		break;
-#endif
-	default:
-		break;
-	}
-
+	__nft_ct_set_destroy(ctx, priv);
 	nft_ct_netns_put(ctx->net, ctx->afi->family);
 }
 
-- 
2.10.2

