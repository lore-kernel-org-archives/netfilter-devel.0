From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 29/32] netfilter: nf_tables: Fix trailing semicolon
Date: Fri, 19 Jan 2018 20:10:38 +0100
Message-ID: <20180119191041.25804-30-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Luis de Bethencourt <luisbg@kernel.org>

The trailing semicolon is an empty statement that does no operation.
Removing it since it doesn't do anything.

Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dynset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index ec0fd78231d8..fc83e29d6634 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -164,7 +164,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	}
 
 	priv->sreg_key = nft_parse_register(tb[NFTA_DYNSET_SREG_KEY]);
-	err = nft_validate_register_load(priv->sreg_key, set->klen);;
+	err = nft_validate_register_load(priv->sreg_key, set->klen);
 	if (err < 0)
 		return err;
 
-- 
2.11.0
