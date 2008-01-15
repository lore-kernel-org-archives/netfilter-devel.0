From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/38]: xt_pkttype: IPv6 multicast address recognition
Date: Tue, 15 Jan 2008 07:19:31 +0100 (MET)
Message-ID: <20080115061926.3184.58698.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62196 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYAOGTc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:32 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_pkttype: IPv6 multicast address recognition

Signed-off-by: Jan Engelhart <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 109069cb6db009d150c385451a63461fe9d5c42e
tree f12db52a8a1c5209fd7385bf1b8065c734f8e348
parent 65196922f6f712071d1d559406348c5ba9c9810c
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:37 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:18 +0100

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
