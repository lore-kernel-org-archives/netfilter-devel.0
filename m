From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: bridge: fix missing link layer headers on outgoing routed
 packets
Date: Thu, 13 Dec 2007 18:28:38 +0100
Message-ID: <47616BC6.9010208@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060104070702080403020902"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49216 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762682AbXLMR27 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:28:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060104070702080403020902
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------060104070702080403020902
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 8579176d1476637ed7e87c770e2c64da4453a6e6
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Dec 13 17:54:52 2007 +0100

    [NETFILTER]: bridge: fix missing link layer headers on outgoing routed packets
    
    As reported by Damien Thebault, the double POSTROUTING hook invocation
    fix caused outgoing packets routed between two bridges to appear without
    a link-layer header. The reason for this is that we're skipping the
    br_nf_post_routing hook for routed packets now and don't save the
    original link layer header, but nevertheless tries to restore it on
    output, causing corruption.
    
    The root cause for this is that skb->nf_bridge has no clearly defined
    lifetime and is used to indicate all kind of things, but that is
    quite complicated to fix. For now simply don't touch these packets
    and handle them like packets from any other device.
    
    Tested-by: Damien Thebault <damien.thebault@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 533ee35..499aa93 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -50,7 +50,8 @@ enum nf_br_hook_priorities {
 extern int nf_bridge_copy_header(struct sk_buff *skb);
 static inline int nf_bridge_maybe_copy_header(struct sk_buff *skb)
 {
-	if (skb->nf_bridge)
+	if (skb->nf_bridge &&
+	    skb->nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT))
 		return nf_bridge_copy_header(skb);
   	return 0;
 }

--------------060104070702080403020902--
