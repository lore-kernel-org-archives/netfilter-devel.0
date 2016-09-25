From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/53] netfilter: nft_quota: introduce nft_overquota()
Date: Mon, 26 Sep 2016 01:06:19 +0200
Message-ID: <1474844823-2026-10-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is patch renames the existing function to nft_overquota() and make
it return a boolean that tells us if we have exceeded our byte quota.
Just a cleanup.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_quota.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 92b6ff16dbb3..c00104c07095 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -21,10 +21,10 @@ struct nft_quota {
 	atomic64_t	remain;
 };
 
-static inline long nft_quota(struct nft_quota *priv,
-			     const struct nft_pktinfo *pkt)
+static inline bool nft_overquota(struct nft_quota *priv,
+				 const struct nft_pktinfo *pkt)
 {
-	return atomic64_sub_return(pkt->skb->len, &priv->remain);
+	return atomic64_sub_return(pkt->skb->len, &priv->remain) < 0;
 }
 
 static void nft_quota_eval(const struct nft_expr *expr,
@@ -33,7 +33,7 @@ static void nft_quota_eval(const struct nft_expr *expr,
 {
 	struct nft_quota *priv = nft_expr_priv(expr);
 
-	if ((nft_quota(priv, pkt) < 0) ^ priv->invert)
+	if (nft_overquota(priv, pkt) ^ priv->invert)
 		regs->verdict.code = NFT_BREAK;
 }
 
-- 
2.1.4
