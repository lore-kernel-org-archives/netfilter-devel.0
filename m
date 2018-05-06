From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 45/51] netfilter: nft_numgen: enable hashing of one element
Date: Mon,  7 May 2018 00:47:03 +0200
Message-ID: <20180506224709.29100-46-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Laura Garcia Liebana <nevola@gmail.com>

The modulus in the hash function was limited to > 1 as initially
there was no sense to create a hashing of just one element.

Nevertheless, there are certain cases specially for load balancing
where this case needs to be addressed.

This patch fixes the following error.

Error: Could not process rule: Numerical result out of range
add rule ip nftlb lb01 dnat to jhash ip saddr mod 1 map { 0: 192.168.0.10 }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The solution comes to force the hash to 0 when the modulus is 1.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/netfilter/nft_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 24f2f7567ddb..e235c17f1b8b 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -97,7 +97,7 @@ static int nft_jhash_init(const struct nft_ctx *ctx,
 	priv->len = len;
 
 	priv->modulus = ntohl(nla_get_be32(tb[NFTA_HASH_MODULUS]));
-	if (priv->modulus <= 1)
+	if (priv->modulus < 1)
 		return -ERANGE;
 
 	if (priv->offset + priv->modulus - 1 < priv->offset)
-- 
2.11.0
