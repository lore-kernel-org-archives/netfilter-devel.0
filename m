From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH:RFC 2/5] bridge-netfilter: update a comment in br_forward.c
 about ip_fragment()
Date: Tue, 30 Mar 2010 16:16:00 +0200
Message-ID: <4BB207A0.7070702@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:53197 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab0C3OQB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:16:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

bridge-netfilter: update a comment in br_forward.c about ip_fragment()

ip_refrag isn't used anymore in the bridge-netfilter code

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>

--- linux-2.6.33/net/bridge/br_forward.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33-uml/net/bridge/br_forward.c	2010-03-30 09:45:27.000000000 +0200
@@ -37,7 +37,7 @@ int br_dev_queue_push_xmit(struct sk_buf
 	if (packet_length(skb) > skb->dev->mtu && !skb_is_gso(skb))
 		kfree_skb(skb);
 	else {
-		/* ip_refrag calls ip_fragment, doesn't copy the MAC header. */
+		/* ip_fragment doesn't copy the MAC header */
 		if (nf_bridge_maybe_copy_header(skb))
 			kfree_skb(skb);
 		else {

-- 
Bart De Schuymer
www.artinalgorithms.be
