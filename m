From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/6] netfilter: nft_byteorder: avoid unneeded le/be conversion steps
Date: Wed, 20 Jan 2016 18:03:59 +0100
Message-ID: <1453309444-2297-2-git-send-email-pablo@netfilter.org>
References: <1453309444-2297-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1453309444-2297-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

David points out that we to three le/be conversions instead
of just one.  Doesn't matter on x86_64 w. gcc, but other
architectures might be less lucky.

Since it also simplifies code just follow his advice.

Fixes: c0f3275f5cb ("nftables: byteorder: provide le/be 64 bit conversion helper")
Suggested-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_byteorder.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 383c171..b78c28b 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -46,16 +46,14 @@ static void nft_byteorder_eval(const struct nft_expr *expr,
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
-				src64 = get_unaligned_be64(&src[i]);
-				src64 = be64_to_cpu((__force __be64)src64);
+				src64 = get_unaligned((u64 *)&src[i]);
 				put_unaligned_be64(src64, &dst[i]);
 			}
 			break;
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = get_unaligned_be64(&src[i]);
-				src64 = (__force u64)cpu_to_be64(src64);
-				put_unaligned_be64(src64, &dst[i]);
+				put_unaligned(src64, (u64 *)&dst[i]);
 			}
 			break;
 		}
-- 
2.1.4
