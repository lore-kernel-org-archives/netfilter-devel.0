From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Mon, 12 Nov 2012 16:05:45 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Chris Wilson <chris-netfilter-110904@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:37490 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab2KLPFs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 10:05:48 -0500
In-Reply-To: <alpine.DEB.2.02.1211121019280.23195@lap-x201>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 12 Nov 2012, Chris Wilson wrote:

> On Sat, 10 Nov 2012, Jozsef Kadlecsik wrote:
> 
> > But the thread is drifted from the original cases:
> > 
> > > This only seems to happen when you're using a UDP device behind a Linux
> > > NAT router, and your routing to the destination host changes, because:
> > > 
> > > * You bring up a VPN tunnel and the SIP destination is at the other end
> > > of that tunnel; or
> > 
> > This case is not handled by MASQUERADE.
> > 
> > > * Your default route changes because you failover to another provider.
> > 
> > And this case is also not handled if the original default route device is
> > still healthy, that is for example when you use some dynamic routing
> > protocol which detects failure in the routing path.
> 
> Not necessarily dynamic routing. Even using pppd (pppoa/pppoe) for one
> connection and ethernet for the other can cause this problem. Any case that
> changes routing without bringing down the old device can be affected.
> 
> I'm glad you agree that these are actual problems or limitations with
> MASQUERADE.
>
> > I do not see any simple solution except to delete any NATed entry
> > unconditionally when the routing changes. But that can easily be too much
> > and may kill valid entries.
> 
> But I'm sorry that you won't consider having a flag that changes 
> MASQUERADE's behaviour to automatically change the source address in the 
> conntrack entry.

I don't think changing the source address were a good solution: if 
MASQUERADE could be changed to handle the cases then the wrong conntrack 
entries should be deleted.

But what would trigger the action? (Routing changed? I do not see such a 
kernel event but I might missed it.) And more importantly, what would 
identify the affected entries?

I do not see any good answer to those questions.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
