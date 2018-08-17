From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/15] netfilter: ip6t_rpfilter: set F_IFACE for linklocal addresses
Date: Fri, 17 Aug 2018 21:38:39 +0200
Message-ID: <20180817193850.2796-5-pablo@netfilter.org>
References: <20180817193850.2796-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817193850.2796-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Roman reports that DHCPv6 client no longer sees replies from server
due to

ip6tables -t raw -A PREROUTING -m rpfilter --invert -j DROP

rule.  We need to set the F_IFACE flag for linklocal addresses, they
are scoped per-device.

Fixes: 47b7e7f82802 ("netfilter: don't set F_IFACE on ipv6 fib lookups")
Reported-by: Roman Mamedov <rm@romanrm.net>
Tested-by: Roman Mamedov <rm@romanrm.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_rpfilter.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 0fe61ede77c6..c3c6b09acdc4 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -26,6 +26,12 @@ static bool rpfilter_addr_unicast(const struct in6_addr *addr)
 	return addr_type & IPV6_ADDR_UNICAST;
 }
 
+static bool rpfilter_addr_linklocal(const struct in6_addr *addr)
+{
+	int addr_type = ipv6_addr_type(addr);
+	return addr_type & IPV6_ADDR_LINKLOCAL;
+}
+
 static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 				     const struct net_device *dev, u8 flags)
 {
@@ -48,7 +54,11 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	}
 
 	fl6.flowi6_mark = flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
-	if ((flags & XT_RPFILTER_LOOSE) == 0)
+
+	if (rpfilter_addr_linklocal(&iph->saddr)) {
+		lookup_flags |= RT6_LOOKUP_F_IFACE;
+		fl6.flowi6_oif = dev->ifindex;
+	} else if ((flags & XT_RPFILTER_LOOSE) == 0)
 		fl6.flowi6_oif = dev->ifindex;
 
 	rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
-- 
2.11.0
