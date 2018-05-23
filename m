From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/18] netfilter: ip6t_rpfilter: provide input interface for route lookup
Date: Wed, 23 May 2018 20:42:50 +0200
Message-ID: <20180523184254.22599-15-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Vincent Bernat <vincent@bernat.im>

In commit 47b7e7f82802, this bit was removed at the same time the
RT6_LOOKUP_F_IFACE flag was removed. However, it is needed when
link-local addresses are used, which is a very common case: when
packets are routed, neighbor solicitations are done using link-local
addresses. For example, the following neighbor solicitation is not
matched by "-m rpfilter":

    IP6 fe80::5254:33ff:fe00:1 > ff02::1:ff00:3: ICMP6, neighbor
    solicitation, who has 2001:db8::5254:33ff:fe00:3, length 32

Commit 47b7e7f82802 doesn't quite explain why we shouldn't use
RT6_LOOKUP_F_IFACE in the rpfilter case. I suppose the interface check
later in the function would make it redundant. However, the remaining
of the routing code is using RT6_LOOKUP_F_IFACE when there is no
source address (which matches rpfilter's case with a non-unicast
destination, like with neighbor solicitation).

Signed-off-by: Vincent Bernat <vincent@bernat.im>
Fixes: 47b7e7f82802 ("netfilter: don't set F_IFACE on ipv6 fib lookups")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_rpfilter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index d12f511929f5..0fe61ede77c6 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -48,6 +48,8 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	}
 
 	fl6.flowi6_mark = flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
+	if ((flags & XT_RPFILTER_LOOSE) == 0)
+		fl6.flowi6_oif = dev->ifindex;
 
 	rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
 	if (rt->dst.error)
-- 
2.11.0
