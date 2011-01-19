From: kaber@trash.net
Subject: [PATCH 21/79] ipvs: remove shadow rt variable
Date: Wed, 19 Jan 2011 20:14:21 +0100
Message-ID: <1295464519-21763-22-git-send-email-kaber@trash.net>
References: <1295464519-21763-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1295464519-21763-1-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

Remove a sparse warning about rt variable.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_xmit.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 10bd39c..50b131c 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -188,7 +188,6 @@ __ip_vs_reroute_locally(struct sk_buff *skb)
 			},
 			.mark = skb->mark,
 		};
-		struct rtable *rt;
 
 		if (ip_route_output_key(net, &rt, &fl))
 			return 0;
-- 
1.7.2.3

