From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack and RSTs received during CLOSE_WAIT
Date: Fri, 22 May 2009 09:42:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905220924080.14889@blackhole.kfki.hu>
References: <4A0DE859.7000209@tigertech.com> <alpine.DEB.2.00.0905162348430.4156@blackhole.kfki.hu> <4A0F7FEE.3010405@tigertech.com> <4A139222.2020505@tigertech.com> <alpine.DEB.2.00.0905200904310.10018@blackhole.kfki.hu> <4A1466F6.8070304@tigertech.com>
 <alpine.DEB.2.00.0905202327240.11796@blackhole.kfki.hu> <alpine.DEB.2.00.0905211729090.13699@blackhole.kfki.hu> <4A15A156.6030400@tigertech.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:55646 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZEVHmU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 May 2009 03:42:20 -0400
In-Reply-To: <4A15A156.6030400@tigertech.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 21 May 2009, Robert L Mathews wrote:

> Jozsef Kadlecsik wrote:
> > On Wed, 20 May 2009, Jozsef Kadlecsik wrote:
> > 
> > > Because connlimit/connbytes rely on conntrack, the latter should be
> > > "fixed". However I do not see any way to make it resistant against such
> > > attacks: if we shrink the window (by which alogrithm?) we may block valid
> > > RST segments and thus cause connections to hang instead of termination.
> > 
> > OK, here is a patch. Could you test it with your script and in your
> > environment?
> > 
> > The patch below introduces a new flag for TCP conntrack to mark that RST
> > segment was seen. If retransmitted packets detected from the other direction
> > after the RST segment detected, the timeout of the conntrack entry is
> > linearly increased up to a hardcoded value. Thus we can both catch the
> > retransmitted packets and preserve the effectiveness of connlimit/connbytes.
> 
> Perhaps I'm misunderstanding, but I don't think this will fix it.
> 
> Although the original example I gave involved TCP retransmits that
> "reanimated" the connection, the problem is unfortunately not limited to that
> case, and there don't need to be any TCP retransmits involved. (The subject of
> this thread is now a little misleading and overly-specific, unfortunately.)

Yes, I was concentrating on the original example.
 
> Here's the opening of a telnet connection that I injected a bogus RST packet
> into (the packet has sequence 522209353 instead of the correct 522209354):
> 
> client.52665 > server.23: S 522209223:522209223(0) win 5840 <mss
> 1460,sackOK,nop,wscale 7>
> server.23 > client.52665: S 3233007698:3233007698(0) ack 522209224 win 5792
> <mss 1460,sackOK,nop,wscale 6>
> client.52665 > server.23: . ack 3233007699 win 46 <nop,nop>
> server.23 > client.52665: P 3233007699:3233007711(12) ack 522209224 win 91
> <nop,nop>
> client.52665 > server.23: . ack 3233007711 win 46 <nop,nop>
> client.52665 > server.23: P 522209224:522209236(12) ack 3233007711 win 46
> <nop,nop>
> server.23 > client.52665: . ack 522209236 win 91 <nop,nop>
> server.23 > client.52665: P 3233007711:3233007735(24) ack 522209236 win 91
> <nop,nop>
> client.52665 > server.23: . ack 3233007735 win 46 <nop,nop>
> client.52665 > server.23: P 522209236:522209327(91) ack 3233007735 win 46
> <nop,nop>
> server.23 > client.52665: P 3233007735:3233007750(15) ack 522209327 win 91
> <nop,nop>
> client.52665 > server.23: P 522209327:522209351(24) ack 3233007750 win 46
> <nop,nop>
> server.23 > client.52665: P 3233007750:3233007753(3) ack 522209351 win 91
> <nop,nop>
> client.52665 > server.23: P 522209351:522209354(3) ack 3233007753 win 46
> <nop,nop>
> server.23 > client.52665: P 3233007753:3233007947(194) ack 522209354 win 91
> <nop,nop>
> client.52665 > server.23: R 522209353:522209353(0) win 65535
> client.52665 > server.23: . ack 3233007947 win 54 <nop,nop>
> 
> At this point, the telnet connection with the server is fully established and
> waiting for me to type something (because the server ignored the bogus RST).
> But conntrack incorrectly considers it CLOSEd (because conntrack didn't ignore
> the RST). No retransmits were involved, though.
> 
> Even if nf_conntrack_tcp_loose is true, and conntrack treats subsequent
> packets as a new connection when I type something in telnet, I can make it
> forget about the connection again by sending another bogus RST. If I send a
> bogus RST after every legitimate packet, conntrack will almost always think
> the open connection is actually closed.

But if nf_conntrack_tcp_loose is disabled, then the conntrack entry is 
destroyed and the connection won't be "picked up" at seeing the normal 
packets after the bogus RST.

I do not think that it's a problem that an attacker can destroy conntrack 
entries by forged RST segments: it cannot be prevented. However the 
attacker *can* open up a new connection again and thus overcome the 
limitation of connlimit.
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
