From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: ipset: add missing break statemtns in ip_set_get_ip_port()
Date: Wed, 02 Feb 2011 09:35:08 +0100
Message-ID: <4D49173C.6080703@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090908090407050601080901"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62598 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1BBIfX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 03:35:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090908090407050601080901
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Add missing break statements.

I assume the second switch statement which handles only TCP and UDP
is intended to indicate whether a real port number instead of ICMP
port and code were parsed? Otherwise we should add IPPROTO_ICMP and
IPPROTO_ICMPV6 there too.


--------------090908090407050601080901
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="04.diff"

commit 316ed388802533bcfd3dffb38d2ba29ac5428456
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Feb 2 09:31:37 2011 +0100

    netfilter: ipset: add missing break statemtns in ip_set_get_ip_port()
    
    Don't fall through in the switch statement, otherwise IPv4 headers
    are incorrectly parsed again as IPv6 and the return value will always
    be 'false'.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/ipset/ip_set_getport.c b/net/netfilter/ipset/ip_set_getport.c
index 76737bb..4dd2785 100644
--- a/net/netfilter/ipset/ip_set_getport.c
+++ b/net/netfilter/ipset/ip_set_getport.c
@@ -118,8 +118,10 @@ ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src, __be16 *port)
 	switch (pf) {
 	case AF_INET:
 		ret = ip_set_get_ip4_port(skb, src, port, &proto);
+		break;
 	case AF_INET6:
 		ret = ip_set_get_ip6_port(skb, src, port, &proto);
+		break;
 	default:
 		return false;
 	}

--------------090908090407050601080901--
