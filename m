From: "Anders K. Pedersen | Surftown" <akp@surftown.com>
Subject: [PATCH V2] netfilter: ipset: support package fragments for IPv4
 protos without ports
Date: Wed, 01 May 2013 20:02:35 +0200
Message-ID: <1367431355.17468.193.camel@homer.cohaesio.com>
References: <20130428100936.60D0815759E@homer.localdomain>
	 <alpine.DEB.2.00.1304301017430.20765@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bender.cohaesio.com ([212.97.128.130]:47337 "EHLO
	mail.cohaesio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab3EASEM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 May 2013 14:04:12 -0400
In-Reply-To: <alpine.DEB.2.00.1304301017430.20765@blackhole.kfki.hu>
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

---

The patch was implemented and tested on linux-3.8.10 and I have verified
that it applies cleanly to current linux.git and nf-next.git.

Now implemented directly in ip_set_get_ip4_port() as suggested. I
originally hadn't done this to avoid duplicating the protocol list from
get_port(), but this is clearly simpler.

Best regards,
Anders K. Pedersen
Surftown A/S

--- linux-3.8.10/net/netfilter/ipset/ip_set_getport.c.orig	2013-02-19 00:58:34.000000000 +0100
+++ linux-3.8.10/net/netfilter/ipset/ip_set_getport.c	2013-04-30 12:41:52.550817989 +0200
@@ -102,9 +102,25 @@ ip_set_get_ip4_port(const struct sk_buff
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


