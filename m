From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: exthdr: split netlink dump function
Date: Tue,  8 Aug 2017 15:15:28 +0200
Message-ID: <20170808131530.29194-3-fw@strlen.de>
References: <20170808131530.29194-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34488 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751925AbdHHNPS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2017 09:15:18 -0400
In-Reply-To: <20170808131530.29194-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

so eval and uncoming eval_set versions can reuse a common helper.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_exthdr.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 921c95f2c583..e3a6eebe7e0c 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -180,12 +180,8 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 					   NFT_DATA_VALUE, priv->len);
 }
 
-static int nft_exthdr_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_exthdr_dump_common(struct sk_buff *skb, const struct nft_exthdr *priv)
 {
-	const struct nft_exthdr *priv = nft_expr_priv(expr);
-
-	if (nft_dump_register(skb, NFTA_EXTHDR_DREG, priv->dreg))
-		goto nla_put_failure;
 	if (nla_put_u8(skb, NFTA_EXTHDR_TYPE, priv->type))
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_EXTHDR_OFFSET, htonl(priv->offset)))
@@ -202,6 +198,16 @@ static int nft_exthdr_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static int nft_exthdr_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_exthdr *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_EXTHDR_DREG, priv->dreg))
+		return -1;
+
+	return nft_exthdr_dump_common(skb, priv);
+}
+
 static struct nft_expr_type nft_exthdr_type;
 static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
 	.type		= &nft_exthdr_type,
-- 
2.13.0

