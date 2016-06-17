From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/7] netfilter: nf_tables: fix wrong check of NFT_SET_MAP in nf_tables_bind_set
Date: Fri, 17 Jun 2016 20:25:14 +0200
Message-ID: <1466187919-12800-3-git-send-email-pablo@netfilter.org>
References: <1466187919-12800-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1466187919-12800-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <liping.zhang@spreadtrum.com>

We should check "i" is used as a dictionary or not, "binding" is already
checked before.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7b7aa87..492f6f8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2946,7 +2946,7 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		 * jumps are already validated for that chain.
 		 */
 		list_for_each_entry(i, &set->bindings, list) {
-			if (binding->flags & NFT_SET_MAP &&
+			if (i->flags & NFT_SET_MAP &&
 			    i->chain == binding->chain)
 				goto bind;
 		}
-- 
2.1.4
