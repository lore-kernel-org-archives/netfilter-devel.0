From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/38] netfilter: nft_reject_bridge: remove unnecessary ttl set
Date: Fri, 20 Jul 2018 15:08:29 +0200
Message-ID: <20180720130906.27687-2-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

In the nft_reject_br_send_v4_tcp_reset(), a ttl is set by the
nf_reject_iphdr_put(). so, below code is unnecessary.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_reject_bridge.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 6de981270566..08cbed7d940e 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -89,8 +89,7 @@ static void nft_reject_br_send_v4_tcp_reset(struct net *net,
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
 				   net->ipv4.sysctl_ip_default_ttl);
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
-	niph->ttl	= net->ipv4.sysctl_ip_default_ttl;
-	niph->tot_len	= htons(nskb->len);
+	niph->tot_len = htons(nskb->len);
 	ip_send_check(niph);
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
-- 
2.11.0
