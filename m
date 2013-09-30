From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 07/26] netfilter: ipset: Support package fragments for IPv4 protos without ports
Date: Mon, 30 Sep 2013 21:50:18 +0200
Message-ID: <1380570637-31235-8-git-send-email-kadlec@blackhole.kfki.hu>
References: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:36524 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372Ab3I3Tuo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:50:44 -0400
In-Reply-To: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Anders K. Pedersen <akp@surftown.com>

Enable ipset port set types to match IPv4 package fragments for
protocols that doesn't have ports (or the port information isn't
supported by ipset).

For example this allows a hash:ip,port ipset containing the entry
192.168.0.1,gre:0 to match all package fragments for PPTP VPN tunnels
to/from the host. Without this patch only the first package fragment
(with fragment offset 0) was matched, while subsequent fragments wasn't.

This is not possible for IPv6, where the protocol is in the fragmented
part of the package unlike IPv4, where the protocol is in the IP header.

IPPROTO_ICMPV6 is deliberately not included, because it isn't relevant
for IPv4.

Signed-off-by: Anders K. Pedersen <akp@surftown.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_getport.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_getport.c b/net/netfilter/ipset/ip_set_getport.c
index dac156f..29fb01d 100644
--- a/net/netfilter/ipset/ip_set_getport.c
+++ b/net/netfilter/ipset/ip_set_getport.c
@@ -102,9 +102,25 @@ ip_set_get_ip4_port(const struct sk_buff *skb, bool src,
 	int protocol = iph->protocol;
 
 	/* See comments at tcp_match in ip_tables.c */
-	if (protocol <= 0 || (ntohs(iph->frag_off) & IP_OFFSET))
+	if (protocol <= 0)
 		return false;
 
+	if (ntohs(iph->frag_off) & IP_OFFSET)
+		switch (protocol) {
+		case IPPROTO_TCP:
+		case IPPROTO_SCTP:
+		case IPPROTO_UDP:
+		case IPPROTO_UDPLITE:
+		case IPPROTO_ICMP:
+			/* Port info not available for fragment offset > 0 */
+			return false;
+		default:
+			/* Other protocols doesn't have ports,
+			   so we can match fragments */
+			*proto = protocol;
+			return true;
+		}
+
 	return get_port(skb, protocol, protooff, src, port, proto);
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ip4_port);
-- 
1.7.0.4

