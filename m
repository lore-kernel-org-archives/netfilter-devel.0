From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 075/123] netfilter: ipv6: Preserve link scope traffic original oif
Date: Wed,  5 Dec 2018 04:35:07 -0500
Message-ID: <20181205093555.5386-75-sashal@kernel.org>
References: <20181205093555.5386-1-sashal@kernel.org>
Cc: Alin Nastac <alin.nastac@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181205093555.5386-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Alin Nastac <alin.nastac@gmail.com>

[ Upstream commit 508b09046c0f21678652fb66fd1e9959d55591d2 ]

When ip6_route_me_harder is invoked, it resets outgoing interface of:
  - link-local scoped packets sent by neighbor discovery
  - multicast packets sent by MLD host
  - multicast packets send by MLD proxy daemon that sets outgoing
    interface through IPV6_PKTINFO ipi6_ifindex

Link-local and multicast packets must keep their original oif after
ip6_route_me_harder is called.

Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.17.1
