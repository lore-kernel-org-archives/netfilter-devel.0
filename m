From: Rafael Laufer <rlaufer@cs.ucla.edu>
Subject: [PATCH] SO_ORIGINAL_DST for getsockopt() in SCTP
Date: Thu, 02 Jul 2009 17:26:50 -0700
Message-ID: <4A4D504A.6080506@cs.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:50752 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbZGCA0z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:26:55 -0400
Received: from sj-core-1.cisco.com (sj-core-1.cisco.com [171.71.177.237])
	by sj-dkim-4.cisco.com (8.12.11/8.12.11) with ESMTP id n630QxZW009310
	for <netfilter-devel@vger.kernel.org>; Thu, 2 Jul 2009 17:26:59 -0700
Received: from xbh-sjc-211.amer.cisco.com (xbh-sjc-211.cisco.com [171.70.151.144])
	by sj-core-1.cisco.com (8.13.8/8.14.3) with ESMTP id n630QxiI024256
	for <netfilter-devel@vger.kernel.org>; Fri, 3 Jul 2009 00:26:59 GMT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

a tiny kernel patch to allow getsockopt() with SO_ORIGINAL_DST to work 
for SCTP:

diff -rup 
linux-2.6.28.orig/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c 
linux-2.6.28/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- linux-2.6.28.orig/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c    
2008-12-24 15:26:37.000000000 -0800
+++ linux-2.6.28/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c 
2009-07-02 17:07:09.000000000 -0700
@@ -258,11 +258,11 @@ getorigdst(struct sock *sk, int optval,
    tuple.dst.u3.ip = inet->daddr;
    tuple.dst.u.tcp.port = inet->dport;
    tuple.src.l3num = PF_INET;
-   tuple.dst.protonum = IPPROTO_TCP;
+   tuple.dst.protonum = sk->sk_protocol;

-   /* We only do TCP at the moment: is there a better way? */
-   if (strcmp(sk->sk_prot->name, "TCP")) {
-       pr_debug("SO_ORIGINAL_DST: Not a TCP socket\n");
+   /* We only do TCP and SCTP at the moment: is there a better way? */
+   if ((sk->sk_protocol != IPPROTO_TCP) && (sk->sk_protocol != 
IPPROTO_SCTP)) {
+       pr_debug("SO_ORIGINAL_DST: Not a TCP/SCTP socket\n");
        return -ENOPROTOOPT;
    }


Rafael

