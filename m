From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER] xt_pkttype match fixes
Date: Sat, 22 Dec 2007 03:41:29 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220340490.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, stable@kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55157 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXLVCla (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:41:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


We were always interpreting an IPv6 packet as IPv4, but
ipv4_is_multicast() is only valid for AF_INET (obviously). Fix this
by adding an extra condition to check for AF_INET.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/netfilter/xt_pkttype.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6_nosov/net/netfilter/xt_pkttype.c
===================================================================
--- linux-2.6_nosov.orig/net/netfilter/xt_pkttype.c
+++ linux-2.6_nosov/net/netfilter/xt_pkttype.c
@@ -31,7 +31,8 @@ pkttype_mt(const struct sk_buff *skb, co
 	const struct xt_pkttype_info *info = matchinfo;
 
 	if (skb->pkt_type == PACKET_LOOPBACK)
-		type = ipv4_is_multicast(ip_hdr(skb)->daddr)
+		type = match->family == AF_INET &&
+		       ipv4_is_multicast(ip_hdr(skb)->daddr)
 			? PACKET_MULTICAST
 			: PACKET_BROADCAST;
 	else

