From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 2/27] Change semantic of mask value in xt_TOS
Date: Wed, 2 Jan 2008 21:25:53 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022125360.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60569 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbYABUZy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:25:54 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 4fd5dd02c10be25f59155d127d3ea6de17703946
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 17:35:23 2008 +0100

    [NETFILTER]: Change semantic of mask value in xt_TOS
    
    This patch changes the behavior of xt_TOS v1 so that the mask value
    the user supplies means "zero out these bits" rather than "keep these
    bits". This is more easy on the user, as (I would assume) people keep
    more bits than zeroing, so, an example:
    
    	Action:     Set bit 0x01.
    	before (&): iptables -j TOS --set-tos 0x01/0xFE
    	after (&~): iptables -j TOS --set-tos 0x01/0x01
    
    This is not too "tragic" with xt_TOS, but where larger fields are used
    (e.g. proposed xt_MARK v2), `--set-xmar 0x01/0x01` vs. `--set-xmark
    0x01/0xFFFFFFFE` really makes a difference. Other target(!) modules,
    such as xt_TPROXY also use &~ rather than &, so let's get to a common
    ground.
    
    (Since xt_TOS has not yet left the development tree en direction to
    mainline, the semantic can be changed as proposed without breaking
    iptables.)
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 net/netfilter/xt_DSCP.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index fd7500e..9951e7f 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -128,7 +128,7 @@ tos_tg(struct sk_buff *skb, const struct net_device *in,
 	u_int8_t orig, nv;
 
 	orig = ipv4_get_dsfield(iph);
-	nv   = (orig & info->tos_mask) ^ info->tos_value;
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
