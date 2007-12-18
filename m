From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 2/2] [NETFILTER]: Fix incorrect assignment of TOS value in
 xt_TOS
Date: Tue, 18 Dec 2007 16:48:13 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712181647340.32270@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712181646220.32270@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57074 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbXLRPsO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:48:14 -0500
In-Reply-To: <Pine.LNX.4.64.0712181646220.32270@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/netfilter/xt_DSCP.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/net/netfilter/xt_DSCP.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_DSCP.c
+++ linux-2.6/net/netfilter/xt_DSCP.c
@@ -134,7 +134,7 @@ tos_tg(struct sk_buff *skb, const struct
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 		iph = ip_hdr(skb);
-		ipv4_change_dsfield(iph, ~0, nv);
+		ipv4_change_dsfield(iph, 0, nv);
 	}
 
 	return XT_CONTINUE;
@@ -156,7 +156,7 @@ tos_tg6(struct sk_buff *skb, const struc
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 		iph = ipv6_hdr(skb);
-		ipv6_change_dsfield(iph, ~0, nv);
+		ipv6_change_dsfield(iph, 0, nv);
 	}
 
 	return XT_CONTINUE;
