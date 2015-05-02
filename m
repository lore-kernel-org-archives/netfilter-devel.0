From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 12/34] netfilter: ipset: make ip_set_get_ip*_port to use skb_network_offset
Date: Sat,  2 May 2015 19:28:01 +0200
Message-ID: <1430587703-3387-13-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:51365 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbbEBR2G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:06 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Alexander Drozdov <al.drozdov@gmail.com>

All the ipset functions respect skb->network_header value,
except for ip_set_get_ip4_port() & ip_set_get_ip6_port(). The
functions should use skb_network_offset() to get the transport
header offset.

Signed-off-by: Alexander Drozdov <al.drozdov@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_getport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_getport.c b/net/netfilter/ipset/ip_set_getport.c
index 29fb01d..1981f02 100644
--- a/net/netfilter/ipset/ip_set_getport.c
+++ b/net/netfilter/ipset/ip_set_getport.c
@@ -98,7 +98,7 @@ ip_set_get_ip4_port(const struct sk_buff *skb, bool src,
 		    __be16 *port, u8 *proto)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	unsigned int protooff = ip_hdrlen(skb);
+	unsigned int protooff = skb_network_offset(skb) + ip_hdrlen(skb);
 	int protocol = iph->protocol;
 
 	/* See comments at tcp_match in ip_tables.c */
@@ -135,7 +135,9 @@ ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
 	__be16 frag_off = 0;
 
 	nexthdr = ipv6_hdr(skb)->nexthdr;
-	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
+	protoff = ipv6_skip_exthdr(skb,
+				   skb_network_offset(skb) +
+					sizeof(struct ipv6hdr), &nexthdr,
 				   &frag_off);
 	if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
 		return false;
-- 
1.8.5.1

