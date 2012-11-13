From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Tue, 13 Nov 2012 16:58:06 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211131639320.21144@blackhole.kfki.hu>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211121740100.18435@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211121805330.23195@lap-x201> <alpine.DEB.2.00.1211121940290.18729@blackhole.kfki.hu> <alpine.DEB.2.00.1211122014550.4432@chris-desktop.fen.aptivate.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Chris Wilson <chris-netfilter-110904@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:33054 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab2KMP6I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:58:08 -0500
In-Reply-To: <alpine.DEB.2.00.1211122014550.4432@chris-desktop.fen.aptivate.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 12 Nov 2012, Chris Wilson wrote:

> On Mon, 12 Nov 2012, Jozsef Kadlecsik wrote:
> 
> > > > > * is sent out of an interface that does not list the packet's new
> > > > > (SNAT-to)
> > > > > source address as one of its IP addresses (i.e. if this were a new
> > > > > connection, MASQUERADE would not choose this source address), and
> > > > 
> > > > First, it'd mean a heavy checking for every matched packet.
> > > 
> > > Is it really so expensive to get the list of IP addresses for an interface
> > > and check down the list for presence of a given address?
> > 
> > That'd mean that for *every* packet first the next routing hop should be
> > calculated in netfilter too
> 
> Why "too"? Doesn't the kernel do that already? Why not use the results of the
> kernel's decision?

I wrote from memory and I was wrong: routing info is reused.
 
> > then an IP address of the interface selected and then the old and the
> > calculated addresses compared. For every packet, unconditionally, that's
> > simply too much overhead.
> 
> This only needs to be done if the packet hits a conntrack with
> --update-source-address. And looking down the list of IP addresses of the
> interface in that case doesn't seem too bad. But I'm willing to concede on it.

In your proposal, the checking of the --update-source-address flag was the 
last one. So I commented it according to that logic.
 
> > > If so, perhaps that's a problem elsewhere in the kernel?
> > 
> > No, it's netfilter specific.
> 
> I mean, it shouldn't be hard (or expensive) to get a list of IP addresses for
> an interface, and it shouldn't be hard to check whether a given IP is in that
> list. If it is, then it seems to me that something must be broken. But I don't
> want to have a fight over it.

What I press is that unnecessary checkings simply waste resources and 
therefore expensive. Even if something is fast, if it can be avoided, then 
we must do so.
 
> > > Another option is to check, after routing, the source address that
> > > MASQUERADE would have assigned to the packet. There must be a mechanism
> > > for that, because we already do it for the first packet in the connection,
> > > and it surely cannot be expensive. If it's different to the current
> > > SNAT-to address in the conntrack, and the flag is set on the conntrack,
> > > then update the conntrack.
> > 
> > The first packets are special: the (NAT) rules are evaluated for the very
> > first packets only. Subsequent ones are looked up in the conntrack table and
> > the nat table is completely skipped. As I wrote, there's no callback/hook by
> > which such a functionality for MASQUERADE could be called.
> 
> That doesn't mean that it's expensive, just that we don't do it at the moment.
> And the mangle table is called for every packet, so netfilter already does
> some work for every packet.

Yes, and the proposal of adding all hooks to the mangle table was also 
heavily argued. Sorry, but I regard it expensive to add a new hook to NAT 
in general, just to check a new MASQUERADE flag for every packet.
 
> > Also, SNAT/MASQUERADE is the very last action in netfilter.
> 
> Sorry, but why does that make a difference?

The "missing" callback/hook from NAT could be "worked around" if there 
were a netfilter hook after SNAT/MASQUERADE.

> > My concern is that there can for example be conntrack extensions attached
> > to the conntrack entry, which may became broken if the IP address was
> > simply changed.
> 
> Good point, I didn't realise that.
> 
> > > I think the problem applies even more to portless protocols such as GRE.
> > > Devices have no choice to "change the source port" when making a new
> > > connection. Any packets that they send, will definitely keep a stale entry
> > > alive.
> > > 
> > > Thank you for considering and engaging with this proposal :)
> > 
> > It's an issue, which should be solved in MASQUERADE itself. The conntrack
> > tool can be used to solve it, in theory. In practice it's not easy at all: a
> > daemon should be run on the machine which catches the routing changes and
> > then calls "conntrack".
> 
> Agreed :)

Please note, I believe only the second example you wrote is relevant. 
Starting VPN just out of the blue *after* connections are built up is just 
not the right thing.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
