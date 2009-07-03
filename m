From: Rafael Laufer <rlaufer@cs.ucla.edu>
Subject: Re: [PATCH] SO_ORIGINAL_DST for getsockopt() in SCTP
Date: Thu, 02 Jul 2009 19:26:57 -0700
Message-ID: <4A4D6C71.5080005@cs.ucla.edu>
References: <4A4D504A.6080506@cs.ucla.edu> <20090702.184033.127910800.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:30484 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZGCC1D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:27:03 -0400
In-Reply-To: <20090702.184033.127910800.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> Thunderbird has severely mangled your patch beyond usability.
> 
> Please read Documentation/email-clients.txt in the kernel sources.

Trying again:


diff -rup linux-2.6.28.orig/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c linux-2.6.28/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- linux-2.6.28.orig/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2008-12-24 15:26:37.000000000 -0800
+++ linux-2.6.28/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2009-07-02 17:07:09.000000000 -0700
@@ -258,11 +258,11 @@ getorigdst(struct sock *sk, int optval, 
 	tuple.dst.u3.ip = inet->daddr;
 	tuple.dst.u.tcp.port = inet->dport;
 	tuple.src.l3num = PF_INET;
-	tuple.dst.protonum = IPPROTO_TCP;
+	tuple.dst.protonum = sk->sk_protocol;
 
-	/* We only do TCP at the moment: is there a better way? */
-	if (strcmp(sk->sk_prot->name, "TCP")) {
-		pr_debug("SO_ORIGINAL_DST: Not a TCP socket\n");
+	/* We only do TCP and SCTP at the moment: is there a better way? */
+	if ((sk->sk_protocol != IPPROTO_TCP) && (sk->sk_protocol != IPPROTO_SCTP)) {
+		pr_debug("SO_ORIGINAL_DST: Not a TCP/SCTP socket\n");
 		return -ENOPROTOOPT;
 	}
 

Rafael

