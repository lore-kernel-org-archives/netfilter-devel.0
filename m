From: Dave Johnson <dave-kernel@centerclick.org>
Subject: [PATCH] netfilter: Wrong icmp6 checksum for ICMPV6_TIME_EXCEED in reverse SNATv6 path
Date: Thu, 20 Apr 2017 08:44:21 -0400
Message-ID: <22776.44325.616928.335465@gargle.gargle.HOWL>
References: <22774.51265.265373.257836@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lexington.centerclick.org ([72.0.224.86]:37473 "EHLO
        lexington.centerclick.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945367AbdDTMoX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 08:44:23 -0400
In-Reply-To: <22774.51265.265373.257836@gargle.gargle.HOWL>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


When recalculating the outer ICMPv6 checksum for a reverse path NATv6
such as ICMPV6_TIME_EXCEED nf_nat_icmpv6_reply_translation() was
accessing data beyond the headlen of the skb for non-linear skb.  This
resulted in incorrect ICMPv6 checksum as garbage data was used.

Signed-off-by: Dave Johnson <dave-kernel@centerclick.org>
---
diff -rup linux-4.9.23.orig/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c linux-4.9.23/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
--- linux-4.9.23.orig/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c	2017-04-18 01:12:30.000000000 -0400
+++ linux-4.9.23/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c	2017-04-20 08:13:41.070493666 -0400
@@ -229,7 +229,12 @@ int nf_nat_icmpv6_reply_translation(stru
 		return 0;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
-		struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+		struct ipv6hdr *ipv6h;
+
+		if (!skb_make_writable(skb, skb->len))
+			return 0;
+
+		ipv6h = ipv6_hdr(skb);
 		inside = (void *)skb->data + hdrlen;
 		inside->icmp6.icmp6_cksum = 0;
 		inside->icmp6.icmp6_cksum =
