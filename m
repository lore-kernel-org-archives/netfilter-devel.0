From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/15] netfilter: nft_dynset: allow dynamic updates of non-anonymous set
Date: Fri, 17 Aug 2018 21:41:06 +0200
Message-ID: <20180817194106.2878-6-pablo@netfilter.org>
References: <20180817194106.2878-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817194106.2878-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This check is superfluous since it breaks valid configurations, remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dynset.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 81184c244d1a..6e91a37d57f2 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -187,8 +187,6 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DYNSET_EXPR] != NULL) {
 		if (!(set->flags & NFT_SET_EVAL))
 			return -EINVAL;
-		if (!nft_set_is_anonymous(set))
-			return -EOPNOTSUPP;
 
 		priv->expr = nft_expr_init(ctx, tb[NFTA_DYNSET_EXPR]);
 		if (IS_ERR(priv->expr))
-- 
2.11.0
