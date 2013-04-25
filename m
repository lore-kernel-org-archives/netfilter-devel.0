From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/10] ipvs: Avoid shadowing net variable in ip_vs_leave()
Date: Thu, 25 Apr 2013 02:22:17 +0200
Message-ID: <1366849341-10466-7-git-send-email-pablo@netfilter.org>
References: <1366849341-10466-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1366849341-10466-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Simon Horman <horms@verge.net.au>

Flagged by sparse.
Compile and sparse tested only.

Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index a0d7bd3..085b588 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -584,9 +584,9 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
 #ifdef CONFIG_IP_VS_IPV6
 	if (svc->af == AF_INET6) {
 		if (!skb->dev) {
-			struct net *net = dev_net(skb_dst(skb)->dev);
+			struct net *net_ = dev_net(skb_dst(skb)->dev);
 
-			skb->dev = net->loopback_dev;
+			skb->dev = net_->loopback_dev;
 		}
 		icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_PORT_UNREACH, 0);
 	} else
-- 
1.7.10.4
