From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 08/13] netfilter: nft_chain_filter: add support for early ingress
Date: Thu, 14 Jun 2018 16:19:42 +0200
Message-ID: <20180614141947.3580-9-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds the new filter chain at the early ingress hook.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/netfilter/nft_chain_filter.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 84c902477a91..bc7fb2dc0e44 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -277,9 +277,11 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
 	.family		= NFPROTO_NETDEV,
-	.hook_mask	= (1 << NF_NETDEV_INGRESS),
+	.hook_mask	= (1 << NF_NETDEV_INGRESS) |
+			  (1 << NF_NETDEV_EARLY_INGRESS),
 	.hooks		= {
-		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
+		[NF_NETDEV_INGRESS]		= nft_do_chain_netdev,
+		[NF_NETDEV_EARLY_INGRESS]	= nft_do_chain_netdev,
 	},
 };
 
-- 
2.11.0
