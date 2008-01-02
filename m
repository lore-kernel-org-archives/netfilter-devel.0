From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 17/27] xt_pkttype: Add explicit check for IPv4
Date: Wed, 2 Jan 2008 21:30:16 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022130070.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56939 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbYABUaR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:30:17 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 7843dd922e769bfadded963e59645a2e21e6fd34
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 18:24:19 2008 +0100

    [NETFILTER]: xt_pkttype: Add explicit check for IPv4
    
    In the PACKET_LOOPBACK case, the skb data was always interpreted as
    IPv4, but that is not valid for IPv6, obviously. Fix this by adding an
    extra condition to check for AF_INET.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 net/netfilter/xt_pkttype.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 2762449..080f324 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -31,7 +31,8 @@ pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
 	const struct xt_pkttype_info *info = matchinfo;
 
 	if (skb->pkt_type == PACKET_LOOPBACK)
-		type = ipv4_is_multicast(ip_hdr(skb)->daddr)
+		type = match->family == AF_INET &&
+		       ipv4_is_multicast(ip_hdr(skb)->daddr)
 			? PACKET_MULTICAST
 			: PACKET_BROADCAST;
 	else
