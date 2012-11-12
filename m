From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Mon, 12 Nov 2012 17:56:26 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211121740100.18435@blackhole.kfki.hu>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Chris Wilson <chris-netfilter-110904@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:42182 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab2KLQ42 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:56:28 -0500
In-Reply-To: <alpine.DEB.2.02.1211121523190.23195@lap-x201>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 12 Nov 2012, Chris Wilson wrote:

> On Mon, 12 Nov 2012, Jozsef Kadlecsik wrote:
> 
> > > > I do not see any simple solution except to delete any NATed entry
> > > > unconditionally when the routing changes. But that can easily be too
> > > > much
> > > > and may kill valid entries.
> > > 
> > > But I'm sorry that you won't consider having a flag that changes
> > > MASQUERADE's behaviour to automatically change the source address in the
> > > conntrack entry.
> > 
> > I don't think changing the source address were a good solution: if
> > MASQUERADE could be changed to handle the cases then the wrong conntrack
> > entries should be deleted.
> > 
> > But what would trigger the action? (Routing changed? I do not see such a
> > kernel event but I might missed it.) And more importantly, what would
> > identify the affected entries?
> > 
> > I do not see any good answer to those questions.
> 
> I propose that:
> 
> * when the packet matches an existing conntrack rule, and
> 
> * is sent out of an interface that does not list the packet's new (SNAT-to)
> source address as one of its IP addresses (i.e. if this were a new
> connection, MASQUERADE would not choose this source address), and

First, it'd mean a heavy checking for every matched packet.

Second, there's no callback, whatsoever in the netfilter conntrack 
framework which could execute this instruction set. And if such an 
internal hook were added, that'd mean an unnecessary "check the hook and 
call if exists" overhead for *every* other case.

An in-kernel "route changed" notification were great, because then we 
could delete all MASQUERAD-ed entries where --update-source-address flag 
is set.
 
> * the --update-source-address flag is set on the MASQUERADE target
> 
> then update the source address on the conntrack rule to the new one.

Why do you insist on updating the source address? Should the 
--update-source-address be limited to UDP only?

> That's the same thing that would happen if we deleted the conntrack entry
> first: MASQUERADE would choose a new source address and save it in the new
> conntrack entry.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
