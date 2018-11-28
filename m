From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/16] netfilter: ipv6: Preserve link scope traffic original oif
Date: Wed, 28 Nov 2018 11:17:37 +0100
Message-ID: <20181128101741.20924-13-pablo@netfilter.org>
References: <20181128101741.20924-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128101741.20924-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Alin Nastac <alin.nastac@gmail.com>

When ip6_route_me_harder is invoked, it resets outgoing interface of:
  - link-local scoped packets sent by neighbor discovery
  - multicast packets sent by MLD host
  - multicast packets send by MLD proxy daemon that sets outgoing
    interface through IPV6_PKTINFO ipi6_ifindex

Link-local and multicast packets must keep their original oif after
ip6_route_me_harder is called.

Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 5ae8e1c51079..8b075f0bc351 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -24,7 +24,8 @@ int ip6_route_me_harder(struct net *net, struct sk_buff *skb)
 	unsigned int hh_len;
 	struct dst_entry *dst;
 	struct flowi6 fl6 = {
-		.flowi6_oif = sk ? sk->sk_bound_dev_if : 0,
+		.flowi6_oif = sk && sk->sk_bound_dev_if ? sk->sk_bound_dev_if :
+			rt6_need_strict(&iph->daddr) ? skb_dst(skb)->dev->ifindex : 0,
 		.flowi6_mark = skb->mark,
 		.flowi6_uid = sock_net_uid(net, sk),
 		.daddr = iph->daddr,
-- 
2.11.0
