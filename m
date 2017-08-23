From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nf-next 2/3] netfilter: nft_limit: replace pkt_bytes with bytes
Date: Wed, 23 Aug 2017 22:41:24 +0200
Message-ID: <20170823204125.31427-2-pablombg@gmail.com>
References: <20170823204125.31427-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37145 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754167AbdHWUmQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 16:42:16 -0400
Received: by mail-wm0-f68.google.com with SMTP id v186so693116wmf.4
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 13:42:16 -0700 (PDT)
In-Reply-To: <20170823204125.31427-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just a small refactor patch in order to improve the code readability.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 +-
 net/netfilter/nft_limit.c                | 30 +++++++++++++++---------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index be25cf69295b..dc7661c293b8 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -946,7 +946,7 @@ enum nft_ct_attributes {
 
 enum nft_limit_type {
 	NFT_LIMIT_PKTS,
-	NFT_LIMIT_PKT_BYTES
+	NFT_LIMIT_BYTES
 };
 
 enum nft_limit_flags {
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 18dd57a52651..d66b4de5b07c 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -165,9 +165,9 @@ static const struct nft_expr_ops nft_limit_pkts_ops = {
 	.dump		= nft_limit_pkts_dump,
 };
 
-static void nft_limit_pkt_bytes_eval(const struct nft_expr *expr,
-				     struct nft_regs *regs,
-				     const struct nft_pktinfo *pkt)
+static void nft_limit_bytes_eval(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
 {
 	struct nft_limit *priv = nft_expr_priv(expr);
 	u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);
@@ -176,29 +176,29 @@ static void nft_limit_pkt_bytes_eval(const struct nft_expr *expr,
 		regs->verdict.code = NFT_BREAK;
 }
 
-static int nft_limit_pkt_bytes_init(const struct nft_ctx *ctx,
-				    const struct nft_expr *expr,
-				    const struct nlattr * const tb[])
+static int nft_limit_bytes_init(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				const struct nlattr * const tb[])
 {
 	struct nft_limit *priv = nft_expr_priv(expr);
 
 	return nft_limit_init(priv, tb);
 }
 
-static int nft_limit_pkt_bytes_dump(struct sk_buff *skb,
-				    const struct nft_expr *expr)
+static int nft_limit_bytes_dump(struct sk_buff *skb,
+				const struct nft_expr *expr)
 {
 	const struct nft_limit *priv = nft_expr_priv(expr);
 
-	return nft_limit_dump(skb, priv, NFT_LIMIT_PKT_BYTES);
+	return nft_limit_dump(skb, priv, NFT_LIMIT_BYTES);
 }
 
-static const struct nft_expr_ops nft_limit_pkt_bytes_ops = {
+static const struct nft_expr_ops nft_limit_bytes_ops = {
 	.type		= &nft_limit_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit)),
-	.eval		= nft_limit_pkt_bytes_eval,
-	.init		= nft_limit_pkt_bytes_init,
-	.dump		= nft_limit_pkt_bytes_dump,
+	.eval		= nft_limit_bytes_eval,
+	.init		= nft_limit_bytes_init,
+	.dump		= nft_limit_bytes_dump,
 };
 
 static const struct nft_expr_ops *
@@ -211,8 +211,8 @@ nft_limit_select_ops(const struct nft_ctx *ctx,
 	switch (ntohl(nla_get_be32(tb[NFTA_LIMIT_TYPE]))) {
 	case NFT_LIMIT_PKTS:
 		return &nft_limit_pkts_ops;
-	case NFT_LIMIT_PKT_BYTES:
-		return &nft_limit_pkt_bytes_ops;
+	case NFT_LIMIT_BYTES:
+		return &nft_limit_bytes_ops;
 	}
 	return ERR_PTR(-EOPNOTSUPP);
 }
-- 
2.14.1

