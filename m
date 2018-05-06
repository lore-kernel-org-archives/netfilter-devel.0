From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 51/51] netfilter: nft_dynset: fix timeout updates on 32bit
Date: Mon,  7 May 2018 00:47:09 +0200
Message-ID: <20180506224709.29100-52-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This must now use a 64bit jiffies value, else we set
a bogus timeout on 32bit.

Fixes: 8e1102d5a1596 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dynset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 5cc3509659c6..b07a3fd9eeea 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -81,7 +81,7 @@ static void nft_dynset_eval(const struct nft_expr *expr,
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 			timeout = priv->timeout ? : set->timeout;
-			*nft_set_ext_expiration(ext) = jiffies + timeout;
+			*nft_set_ext_expiration(ext) = get_jiffies_64() + timeout;
 		}
 
 		if (sexpr != NULL)
-- 
2.11.0
