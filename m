From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 27/29: nfmark IPV6 routing in OUTPUT, mangle, NFQUEUE
Date: Thu, 27 Nov 2008 17:15:39 +0100 (MET)
Message-ID: <20081127161539.13891.61126.sendpatchset@x2.localnet>
References: <20081127161503.13891.62766.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20081127161503.13891.62766.sendpatchset@x2.localnet>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit 9f40ac713c49fb6ca655550b620edc85c445d743
Author: Eric Leblond <eric@inl.fr>
Date:   Tue Nov 25 12:18:11 2008 +0100

    netfilter: nfmark IPV6 routing in OUTPUT, mangle, NFQUEUE
    
    This patch let nfmark to be evaluated for routing decision for OUTPUT
    packet, in mangle table, when process paquet in NFQUEUE. This patch is
    an IPv6 port of Laurent Licour IPv4 one.
    
    Signed-off-by: Eric Leblond <eric@inl.fr>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index fd5b3a4..0b88c56 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -56,6 +56,7 @@ EXPORT_SYMBOL(ip6_route_me_harder);
 struct ip6_rt_info {
 	struct in6_addr daddr;
 	struct in6_addr saddr;
+	u_int32_t mark;
 };
 
 static void nf_ip6_saveroute(const struct sk_buff *skb,
@@ -68,6 +69,7 @@ static void nf_ip6_saveroute(const struct sk_buff *skb,
 
 		rt_info->daddr = iph->daddr;
 		rt_info->saddr = iph->saddr;
+		rt_info->mark = skb->mark;
 	}
 }
 
@@ -79,7 +81,8 @@ static int nf_ip6_reroute(struct sk_buff *skb,
 	if (entry->hook == NF_INET_LOCAL_OUT) {
 		struct ipv6hdr *iph = ipv6_hdr(skb);
 		if (!ipv6_addr_equal(&iph->daddr, &rt_info->daddr) ||
-		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr))
+		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr) ||
+		    skb->mark != rt_info->mark)
 			return ip6_route_me_harder(skb);
 	}
 	return 0;
