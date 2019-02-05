From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/6] netfilter: ipv6: Don't preserve original oif for loopback address
Date: Tue,  5 Feb 2019 20:04:14 +0100
Message-ID: <20190205190415.25041-6-pablo@netfilter.org>
References: <20190205190415.25041-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190205190415.25041-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eli Cooper <elicooper@gmx.com>

Commit 508b09046c0f ("netfilter: ipv6: Preserve link scope traffic
original oif") made ip6_route_me_harder() keep the original oif for
link-local and multicast packets. However, it also affected packets
for the loopback address because it used rt6_need_strict().

REDIRECT rules in the OUTPUT chain rewrite the destination to loopback
address; thus its oif should not be preserved. This commit fixes the bug
that redirected local packets are being dropped. Actually the packet was
not exactly dropped; Instead it was sent out to the original oif rather
than lo. When a packet with daddr ::1 is sent to the router, it is
effectively dropped.

Fixes: 508b09046c0f ("netfilter: ipv6: Preserve link scope traffic original oif")
Signed-off-by: Eli Cooper <elicooper@gmx.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 8b075f0bc351..6d0b1f3e927b 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -23,9 +23,11 @@ int ip6_route_me_harder(struct net *net, struct sk_buff *skb)
 	struct sock *sk = sk_to_full_sk(skb->sk);
 	unsigned int hh_len;
 	struct dst_entry *dst;
+	int strict = (ipv6_addr_type(&iph->daddr) &
+		      (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL));
 	struct flowi6 fl6 = {
 		.flowi6_oif = sk && sk->sk_bound_dev_if ? sk->sk_bound_dev_if :
-			rt6_need_strict(&iph->daddr) ? skb_dst(skb)->dev->ifindex : 0,
+			strict ? skb_dst(skb)->dev->ifindex : 0,
 		.flowi6_mark = skb->mark,
 		.flowi6_uid = sock_net_uid(net, sk),
 		.daddr = iph->daddr,
-- 
2.11.0
