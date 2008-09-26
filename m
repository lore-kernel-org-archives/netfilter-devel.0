From: "Horton, Dave" <dhorton@pactolus.com>
Subject: RE: been a while...what happened to NFC_ALTERED?
Date: Thu, 25 Sep 2008 21:28:11 -0400
Message-ID: <E8E029BA163C694484CFEA4914619EA206853DA5@pcsexch-bknet>
References: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com> <alpine.LNX.1.10.0809251923040.18190@fbirervta.pbzchgretzou.qr> <E8E029BA163C694484CFEA4914619EA206853DA2@pcsexch-bknet> <alpine.LNX.1.10.0809252108230.17117@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host70.216.41.17.conversent.net ([216.41.17.70]:3877 "EHLO
	pcsexch.ad.pactolus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752586AbYIZB2M convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:28:12 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> You cannot change the IP address or L4 port without making conntrack
> very unhappy. In the simplest case, you're "just" voiding any state
> matching and flow accounting. In the worst case, iph->daddr (and
> other fields) does not match skb->nfct->....->daddr (respectively)
> anymore and cosmic rays could catalyze up, er, undefined behavior
> could arise.

Hmm.  Well, maybe that's my problem?  Something that I could get away
with in the 2.4 kernel, which I can't any longer?  It is true that in
order for this to work for me on RH3 I had to build a custom kernel that
had a small change to net/ipv4/fib_frontend.c:

--- net/ipv4/fib_frontend.c	Sun Mar 21 07:22:00 1999
+++ net/ipv4/fib_frontend.c	Wed Dec 29 20:29:38 1999
@@ -233,8 +233,13 @@
 
 	if (fib_lookup(&key, &res))
 		goto last_resort;
+#ifdef CONFIG_ALLOW_SPOOFING
+	if (res.type != RTN_UNICAST && res.type != RTN_LOCAL)
+		goto e_inval_res;
+#else
 	if (res.type != RTN_UNICAST)
 		goto e_inval_res;
+#endif
	*spec_dst = FIB_RES_PREFSRC(res);
	fib_combine_itag(itag, &res);
 #ifdef CONFIG_IP_ROUTE_MULTIPATH

I've made the same change on the 2.6 kernel I am trying to get running
with.

This is all in the context of a single-purpose, specialized server that
I build which does a very specific packet forwarding task.  I control
the whole server (no other software needs to run on it) so hopefully I
can somewhat control interactions. Regardless of the fact that it is
non-standard, it does what I need and I need to somehow create that same
functionality under 2.6, if possible.  Do you think I should be looking
at some sort of alternative approach?  The simplest way to describe what
I need to do is that I need to receive UDP packets on a specified set of
ports and send them to a specified remote address:port after changing
the source ip address:port to my local address and a specified port.
