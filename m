From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 35/53] netfilter: nft_lookup: remove superfluous element found check
Date: Mon, 26 Sep 2016 01:06:45 +0200
Message-ID: <1474844823-2026-36-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

We already checked for !found just a bit before:

        if (!found) {
                regs->verdict.code = NFT_BREAK;
                return;
        }

        if (found && set->flags & NFT_SET_MAP)
            ^^^^^

So this redundant check can just go away.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_lookup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index e164325d1bc0..8166b6994cc7 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -43,7 +43,7 @@ static void nft_lookup_eval(const struct nft_expr *expr,
 		return;
 	}
 
-	if (found && set->flags & NFT_SET_MAP)
+	if (set->flags & NFT_SET_MAP)
 		nft_data_copy(&regs->data[priv->dreg],
 			      nft_set_ext_data(ext), set->dlen);
 
-- 
2.1.4
