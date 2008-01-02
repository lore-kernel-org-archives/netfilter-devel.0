From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 3/27] Properly set the TOS field in xt_TOS
Date: Wed, 2 Jan 2008 21:26:10 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022125540.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60571 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbYABU0L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:26:11 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 8f0c85f00df581bf4379db5c382232c8c441ca3e
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 17:35:49 2008 +0100

    [NETFILTER]: Properly set the TOS field in xt_TOS
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 net/netfilter/xt_DSCP.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 9951e7f..3d216d6 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -134,7 +134,7 @@ tos_tg(struct sk_buff *skb, const struct net_device *in,
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 		iph = ip_hdr(skb);
-		ipv4_change_dsfield(iph, ~0, nv);
+		ipv4_change_dsfield(iph, 0, nv);
 	}
 
 	return XT_CONTINUE;
@@ -156,7 +156,7 @@ tos_tg6(struct sk_buff *skb, const struct net_device *in,
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
 			return NF_DROP;
 		iph = ipv6_hdr(skb);
-		ipv6_change_dsfield(iph, ~0, nv);
+		ipv6_change_dsfield(iph, 0, nv);
 	}
 
 	return XT_CONTINUE;
