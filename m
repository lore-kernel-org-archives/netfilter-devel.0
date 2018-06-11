From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/15] netfilter: nft_reject_bridge: fix skb allocation size in nft_reject_br_send_v6_unreach
Date: Mon, 11 Jun 2018 11:22:22 +0200
Message-ID: <20180611092233.3219-5-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

In order to allocate icmpv6 skb, sizeof(struct ipv6hdr) should be used.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_reject_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index eaf05de37f75..6de981270566 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -261,7 +261,7 @@ static void nft_reject_br_send_v6_unreach(struct net *net,
 	if (!reject6_br_csum_ok(oldskb, hook))
 		return;
 
-	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct icmp6hdr) +
+	nskb = alloc_skb(sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr) +
 			 LL_MAX_HEADER + len, GFP_ATOMIC);
 	if (!nskb)
 		return;
-- 
2.11.0
