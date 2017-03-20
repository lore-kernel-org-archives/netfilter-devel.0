From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/22] netfilter: nft_exthdr: Allow checking TCP option presence, too
Date: Mon, 20 Mar 2017 11:08:29 +0100
Message-ID: <1490004530-9128-2-git-send-email-pablo@netfilter.org>
References: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Honor NFT_EXTHDR_F_PRESENT flag so we check if the TCP option is
present.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index c308920b194c..d212a85d2f33 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -98,14 +98,21 @@ static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
 			goto err;
 
 		offset = i + priv->offset;
-		dest[priv->len / NFT_REG32_SIZE] = 0;
-		memcpy(dest, opt + offset, priv->len);
+		if (priv->flags & NFT_EXTHDR_F_PRESENT) {
+			*dest = 1;
+		} else {
+			dest[priv->len / NFT_REG32_SIZE] = 0;
+			memcpy(dest, opt + offset, priv->len);
+		}
 
 		return;
 	}
 
 err:
-	regs->verdict.code = NFT_BREAK;
+	if (priv->flags & NFT_EXTHDR_F_PRESENT)
+		*dest = 0;
+	else
+		regs->verdict.code = NFT_BREAK;
 }
 
 static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
-- 
2.1.4
