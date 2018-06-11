From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/15] ipvs: fix check on xmit to non-local addresses
Date: Mon, 11 Jun 2018 11:22:23 +0200
Message-ID: <20180611092233.3219-6-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

There is mistake in the rt_mode_allow_non_local assignment.
It should be used to check if sending to non-local addresses is
allowed, now it checks if local addresses are allowed.

As local addresses are allowed for most of the cases, the only
places that are affected are for traffic to transparent cache
servers:

- bypass connections when cache server is not available
- related ICMP in FORWARD hook when sent to cache server

Fixes: 4a4739d56b00 ("ipvs: Pull out crosses_local_route_boundary logic")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 4527921b1c3a..8f7fff774283 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -168,7 +168,7 @@ static inline bool crosses_local_route_boundary(int skb_af, struct sk_buff *skb,
 						bool new_rt_is_local)
 {
 	bool rt_mode_allow_local = !!(rt_mode & IP_VS_RT_MODE_LOCAL);
-	bool rt_mode_allow_non_local = !!(rt_mode & IP_VS_RT_MODE_LOCAL);
+	bool rt_mode_allow_non_local = !!(rt_mode & IP_VS_RT_MODE_NON_LOCAL);
 	bool rt_mode_allow_redirect = !!(rt_mode & IP_VS_RT_MODE_RDR);
 	bool source_is_loopback;
 	bool old_rt_is_local;
-- 
2.11.0
