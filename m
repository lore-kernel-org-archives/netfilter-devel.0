From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH] nftables: exthdr: Allow checking TCP option presence, too
Date: Mon, 20 Feb 2017 17:52:27 +0100
Message-ID: <20170220165227.13505-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:55863 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752118AbdBTQwh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Feb 2017 11:52:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nft_exthdr.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index c308920b194cd..d212a85d2f333 100644
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
2.11.0

