From: Dave Johnson <dave-kernel@centerclick.org>
Subject: Re: [PATCH] netfilter: Wrong icmp6 checksum for ICMPV6_TIME_EXCEED
 in reverse SNATv6 path
Date: Mon, 24 Apr 2017 09:11:24 -0400
Message-ID: <22781.63868.363065.484165@gargle.gargle.HOWL>
References: <22774.51265.265373.257836@gargle.gargle.HOWL>
        <22776.44325.616928.335465@gargle.gargle.HOWL>
        <20170424084312.GA3597@salvia>
        <22781.62083.680363.165680@gargle.gargle.HOWL>
        <22781.63534.706649.79254@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lexington.centerclick.org ([45.32.7.34]:59825 "EHLO
        lexington.centerclick.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1170833AbdDXNSz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Apr 2017 09:18:55 -0400
In-Reply-To: <22781.63534.706649.79254@gargle.gargle.HOWL>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


When recalculating the outer ICMPv6 checksum for a reverse path NATv6
such as ICMPV6_TIME_EXCEED nf_nat_icmpv6_reply_translation() was
accessing data beyond the headlen of the skb for non-linear skb.  This
resulted in incorrect ICMPv6 checksum as garbage data was used.

Patch replaces csum_partial() with skb_checksum() which supports
non-linear skbs similar to nf_nat_icmp_reply_translation() from ipv4.

Signed-off-by: Dave Johnson <dave-kernel@centerclick.org>
---
diff -rup linux-4.9.23.orig/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c linux-4.9.23/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
--- linux-4.9.23.orig/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c	2017-04-18 01:12:30.000000000 -0400
+++ linux-4.9.23/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c	2017-04-24 09:00:31.476785772 -0400
@@ -235,7 +235,7 @@ int nf_nat_icmpv6_reply_translation(stru
 		inside->icmp6.icmp6_cksum =
 			csum_ipv6_magic(&ipv6h->saddr, &ipv6h->daddr,
 					skb->len - hdrlen, IPPROTO_ICMPV6,
-					csum_partial(&inside->icmp6,
+					skb_checksum(skb, hdrlen,
 						     skb->len - hdrlen, 0));
 	}
 
