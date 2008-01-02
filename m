From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 18/27] xt_pkttype IPv6 multicast address recognition
Date: Wed, 2 Jan 2008 21:30:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022130170.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56941 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbYABUae (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:30:34 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit d952de26e263328ff6cdd04fc0c325bf0651efb4
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 18:24:43 2008 +0100

    [NETFILTER]: xt_pkttype IPv6 multicast address recognition
    
    Signed-off-by: Jan Engelhart <jengelh@computergmbh.de>

 net/netfilter/xt_pkttype.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 080f324..cbcb8ea 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -11,6 +11,7 @@
 #include <linux/if_packet.h>
 #include <linux/in.h>
 #include <linux/ip.h>
+#include <linux/ipv6.h>
 
 #include <linux/netfilter/xt_pkttype.h>
 #include <linux/netfilter/x_tables.h>
@@ -27,16 +28,19 @@ pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
            const void *matchinfo, int offset, unsigned int protoff,
            bool *hotdrop)
 {
-	u_int8_t type;
 	const struct xt_pkttype_info *info = matchinfo;
+	u_int8_t type;
 
-	if (skb->pkt_type == PACKET_LOOPBACK)
-		type = match->family == AF_INET &&
-		       ipv4_is_multicast(ip_hdr(skb)->daddr)
-			? PACKET_MULTICAST
-			: PACKET_BROADCAST;
-	else
+	if (skb->pkt_type != PACKET_LOOPBACK)
 		type = skb->pkt_type;
+	else if (match->family == AF_INET &&
+	    ipv4_is_multicast(ip_hdr(skb)->daddr))
+		type = PACKET_MULTICAST;
+	else if (match->family == AF_INET6 &&
+	    ipv6_hdr(skb)->daddr.s6_addr[0] == 0xFF)
+		type = PACKET_MULTICAST;
+	else
+		type = PACKET_BROADCAST;
 
 	return (type == info->pkttype) ^ info->invert;
 }
