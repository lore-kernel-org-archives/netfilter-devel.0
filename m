From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 2/2] netfilter: nfmark IPV6 routing in OUTPUT, mangle, NFQUEUE
Date: Mon, 24 Nov 2008 21:46:47 +0100
Message-ID: <1227559607-3077-3-git-send-email-eric@inl.fr>
References: <1227559607-3077-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39501 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753071AbYKXUqu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:46:50 -0500
In-Reply-To: <1227559607-3077-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch let nfmark to be evaluated for routing decision for OUTPUT
packet, in mangle table, when process paquet in NFQUEUE. This patch is
an IPv6 port of Laurent Licour IPv4 one.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv6/netfilter.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index fd5b3a4..af84a43 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -56,6 +56,7 @@ EXPORT_SYMBOL(ip6_route_me_harder);
 struct ip6_rt_info {
 	struct in6_addr daddr;
 	struct in6_addr saddr;
+	__u32 mark;
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
-- 
1.5.6.3

