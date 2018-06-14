From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next,RFC 12/13] netfilter: nft_flow_offload: remove secpath check
Date: Thu, 14 Jun 2018 16:19:46 +0200
Message-ID: <20180614141947.3580-13-pablo@netfilter.org>
References: <20180614141947.3580-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

It is safe to place a flow that is coming from IPSec into the flowtable.
So decapsulated can benefit from the flowtable fastpath.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/netfilter/nft_flow_offload.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index f2e95edfb4de..a7f529b79bdb 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -54,8 +54,6 @@ static bool nft_flow_offload_skip(struct sk_buff *skb)
 
 	if (unlikely(opt->optlen))
 		return true;
-	if (skb_sec_path(skb))
-		return true;
 
 	return false;
 }
-- 
2.11.0
