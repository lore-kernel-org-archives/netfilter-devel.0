From: Julian Anastasov <ja@ssi.bg>
Subject: [PATCH] netfilter: nf_nat: fix crash in nf_nat_csum
Date: Sun, 29 May 2011 23:42:29 +0300 (EEST)
Message-ID: <alpine.LFD.2.00.1105292335220.1429@ja.ssi.bg>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ja.ssi.bg ([178.16.129.10]:54011 "EHLO ja.ssi.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab1E2Uke (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2011 16:40:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


	Fix crash in nf_nat_csum when mangling packets
in OUTPUT hook where skb->dev is not defined, it is set
later before POSTROUTING. Problem happens for CHECKSUM_NONE.
We can check device from rt but using CHECKSUM_PARTIAL
should be safe (skb_checksum_help).

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---

diff -urp v2.6.39/linux/net/ipv4/netfilter/nf_nat_helper.c linux/net/ipv4/netfilter/nf_nat_helper.c
--- v2.6.39/linux/net/ipv4/netfilter/nf_nat_helper.c	2011-01-06 00:01:22.000000000 +0200
+++ linux/net/ipv4/netfilter/nf_nat_helper.c	2011-05-29 23:14:40.166245897 +0300
@@ -160,7 +160,7 @@ static void nf_nat_csum(struct sk_buff *
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
 		if (!(rt->rt_flags & RTCF_LOCAL) &&
-		    skb->dev->features & NETIF_F_V4_CSUM) {
+		    (!skb->dev || skb->dev->features & NETIF_F_V4_CSUM)) {
 			skb->ip_summed = CHECKSUM_PARTIAL;
 			skb->csum_start = skb_headroom(skb) +
 					  skb_network_offset(skb) +
