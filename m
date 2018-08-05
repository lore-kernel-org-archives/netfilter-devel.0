From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/21] netfilter: nft_tunnel: fix sparse errors
Date: Sun,  5 Aug 2018 23:21:41 +0200
Message-ID: <20180805212141.3033-22-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[...]
net/netfilter/nft_tunnel.c:117:25:    expected unsigned int [unsigned] [usertype] flags
net/netfilter/nft_tunnel.c:117:25:    got restricted __be16 [usertype] <noident>
[...]
net/netfilter/nft_tunnel.c:246:33:    expected restricted __be16 [addressable] [assigned] [usertype] tp_dst
net/netfilter/nft_tunnel.c:246:33:    got int

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 9332d7933dd5..3a15f219e4e7 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -116,7 +116,7 @@ struct nft_tunnel_opts {
 		struct erspan_metadata	erspan;
 	} u;
 	u32	len;
-	u32	flags;
+	__be16	flags;
 };
 
 struct nft_tunnel_obj {
@@ -337,12 +337,10 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
 	}
 
 	if (tb[NFTA_TUNNEL_KEY_SPORT]) {
-		info.key.tp_src =
-			ntohs(nla_get_be16(tb[NFTA_TUNNEL_KEY_SPORT]));
+		info.key.tp_src = nla_get_be16(tb[NFTA_TUNNEL_KEY_SPORT]);
 	}
 	if (tb[NFTA_TUNNEL_KEY_DPORT]) {
-		info.key.tp_dst =
-			ntohs(nla_get_be16(tb[NFTA_TUNNEL_KEY_DPORT]));
+		info.key.tp_dst = nla_get_be16(tb[NFTA_TUNNEL_KEY_DPORT]);
 	}
 
 	if (tb[NFTA_TUNNEL_KEY_FLAGS]) {
-- 
2.11.0
