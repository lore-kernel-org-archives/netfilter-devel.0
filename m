From: "Fischer, Anna" <anna.fischer@hp.com>
Subject: RE: ip_conntrack fails to track Windows Vista TCP connection
Date: Mon, 14 Jun 2010 17:34:00 +0000
Message-ID: <0199E0D51A61344794750DC57738F58E70B258E346@GVW1118EXC.americas.hpqcorp.net>
References: <0199E0D51A61344794750DC57738F58E70B258E2B3@GVW1118EXC.americas.hpqcorp.net>
 <4C165596.8020700@trash.net>
 <alpine.LSU.2.01.1006141834280.7212@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:32505 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab0FNReu convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:34:50 -0400
In-Reply-To: <alpine.LSU.2.01.1006141834280.7212@obet.zrqbmnf.qr>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Subject: Re: ip_conntrack fails to track Windows Vista TCP connection
> 
> On Monday 2010-06-14 18:15, Patrick McHardy wrote:
> 
> > Fischer, Anna wrote:
> >> I am trying to track (and NAT) a TCP connection to a Windows Vista
> machine
> >> using ip_conntrack. However, Vista uses the Nagle algorithm combined
> with the
> >> TCP Delayed ACK mechanism which does not ACK every single packet, and
> it seems
> >> as if the connection tracking module has problems with this.
> Basically it
> >> fails to recognize Delayed ACK packets, and as these are not picked
> up by the
> >> connection tracking module, my NAT function does not work and so
> packets are
> >> not delivered properly because they are not rewritten by ip_nat. I am
> certain
> >> that the problem is the Vista TCP stack and its mechanisms as when I
> configure
> >> my Windows Vista machine with Nagle = off and TCPNODelay = 1, then
> actually
> >> connection tracking works fine. Also, all connections with Linux
> machines are
> >> tracked properly.
> >>
> >> Is this a known issue?
> >
> > You're mentioning ip_conntrack, which is obsoleted for multiple
> > years now. Which kernel version are you using?
> 
> By definition of ip_conntrack, that must be older than 2.6.20.

Yes, this is a 2.6.18 Xen kernel that I am using. Even if it is obsolete, can you let me know if you are aware of such a problem ever having caused any issues? I just want to get a feeling if I am at least roughly on the right track while figuring out what the problem is.

Thanks,
Anna
