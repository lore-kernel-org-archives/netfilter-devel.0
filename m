From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: nf_conntrack: log packets dropped by helpers
Date: Tue, 25 Aug 2009 14:24:55 +0200
Message-ID: <4A93D817.4080706@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040608070703070204040701"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45049 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZHYMY4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Aug 2009 08:24:56 -0400
Received: from [IPv6:2001:6f8:974:0:215:f2ff:fe24:91f8] (unknown [IPv6:2001:6f8:974:0:215:f2ff:fe24:91f8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTPSA id 50BBBB2C55
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2009 14:24:57 +0200 (MEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040608070703070204040701
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

I'm about to commit a couple of patches from some private trees
to my nf-next-2.6.git tree. Any comments welcome.

--------------040608070703070204040701
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit ec4988f91a1750b181cfc87461c3df48b0ab0fc7
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Aug 25 14:21:24 2009 +0200

    netfilter: nf_conntrack: log packets dropped by helpers
    
    Log packets dropped by helpers using the netfilter logging API. This
    is useful in combination with nfnetlink_log to analyze those packets
    in userspace for debugging.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 7d2ead7..44fa394 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -26,6 +26,7 @@
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 #include <net/netfilter/nf_nat_helper.h>
 #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
+#include <net/netfilter/nf_log.h>
 
 int (*nf_nat_seq_adjust_hook)(struct sk_buff *skb,
 			      struct nf_conn *ct,
@@ -113,8 +114,11 @@ static unsigned int ipv4_confirm(unsigned int hooknum,
 
 	ret = helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
 			   ct, ctinfo);
-	if (ret != NF_ACCEPT)
+	if (ret != NF_ACCEPT) {
+		nf_log_packet(AF_INET, hooknum, skb, in, out, NULL,
+			      "nf_ct_%s: dropping packet", helper->name);
 		return ret;
+	}
 
 	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status)) {
 		typeof(nf_nat_seq_adjust_hook) seq_adjust;
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 2a15c2d..6b76778 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -27,6 +27,7 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
+#include <net/netfilter/nf_log.h>
 
 static bool ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			      struct nf_conntrack_tuple *tuple)
@@ -176,8 +177,11 @@ static unsigned int ipv6_confirm(unsigned int hooknum,
 	}
 
 	ret = helper->help(skb, protoff, ct, ctinfo);
-	if (ret != NF_ACCEPT)
+	if (ret != NF_ACCEPT) {
+		nf_log_packet(AF_INET6, hooknum, skb, in, out, NULL,
+			      "nf_ct_%s: dropping packet", helper->name);
 		return ret;
+	}
 out:
 	/* We've seen it coming out the other side: confirm it */
 	return nf_conntrack_confirm(skb);

--------------040608070703070204040701--
