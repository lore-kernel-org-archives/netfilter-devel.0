From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER]: xt_conntrack: fix missing boolean clamping
Date: Thu, 21 Feb 2008 14:57:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802211457200.26109@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45911 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYBUN5l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:57:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 14c8c528a0ee9f0468be251cf3d16029924ee422
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Feb 21 14:57:01 2008 +0100

    [NETFILTER]: xt_conntrack: fix missing boolean clamping
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 8533085..dd192ac 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -231,7 +231,7 @@ conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
 			if (test_bit(IPS_DST_NAT_BIT, &ct->status))
 				statebit |= XT_CONNTRACK_STATE_DNAT;
 		}
-		if ((info->state_mask & statebit) ^
+		if (!!(info->state_mask & statebit) ^
 		    !(info->invert_flags & XT_CONNTRACK_STATE))
 			return false;
 	}

