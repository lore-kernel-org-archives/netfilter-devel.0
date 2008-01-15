From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/38]: xt_pkttype: Add explicit check for IPv4
Date: Tue, 15 Jan 2008 07:19:29 +0100 (MET)
Message-ID: <20080115061924.3184.12307.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62193 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYAOGTa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:30 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_pkttype: Add explicit check for IPv4

In the PACKET_LOOPBACK case, the skb data was always interpreted as
IPv4, but that is not valid for IPv6, obviously. Fix this by adding an
extra condition to check for AF_INET.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 65196922f6f712071d1d559406348c5ba9c9810c
tree eead1feb27c9cdeeb316638e9ddb48d4f775e6b6
parent 72c54af2cbc724b17aa0b4e58718311dd70617df
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:35 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:17 +0100

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
