From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 25/53] netfilter: nft_numgen: fix race between num generate and store it
Date: Mon, 26 Sep 2016 01:06:35 +0200
Message-ID: <1474844823-2026-26-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <liping.zhang@spreadtrum.com>

After we generate a new number, we still use the priv->counter and
store it to the dreg. This is not correct, another cpu may already
change it to a new number. So we must use the generated number, not
the priv->counter itself.

Fixes: 91dbc6be0a62 ("netfilter: nf_tables: add number generator expression")
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_numgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index f51a3ede3932..f173ebec30a7 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -37,7 +37,7 @@ static void nft_ng_inc_eval(const struct nft_expr *expr,
 		nval = (oval + 1 < priv->modulus) ? oval + 1 : 0;
 	} while (atomic_cmpxchg(&priv->counter, oval, nval) != oval);
 
-	memcpy(&regs->data[priv->dreg], &priv->counter, sizeof(u32));
+	regs->data[priv->dreg] = nval;
 }
 
 static const struct nla_policy nft_ng_policy[NFTA_NG_MAX + 1] = {
-- 
2.1.4
