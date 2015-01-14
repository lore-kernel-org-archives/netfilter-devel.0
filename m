From: Patrick McHardy <kaber@trash.net>
Subject: Re: BUG: Kernel panic at masquerade
Date: Wed, 14 Jan 2015 18:49:10 +0000
Message-ID: <20150114184910.GK5710@acer.localdomain>
References: <54B048D1.6040009@mail.ru>
 <CAOkSjBieyfUV6HMENQcETwcoADT2YMxhgBfv9Kx9kiM8YYAhKA@mail.gmail.com>
 <20150113194111.GB23967@acer.localdomain>
 <20150114172702.GA20830@salvia>
 <20150114173450.GG5710@acer.localdomain>
 <20150114184052.GA21179@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Linke <linkerpro@mail.ru>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59916 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbANStP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:49:15 -0500
Content-Disposition: inline
In-Reply-To: <20150114184052.GA21179@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.01, Pablo Neira Ayuso wrote:
> On Wed, Jan 14, 2015 at 05:34:51PM +0000, Patrick McHardy wrote:
> > On 14.01, Pablo Neira Ayuso wrote:
> > > 
> > > > We should make sure that the user can't mess this up.
> > > 
> > > I'm not so sure, I think we can just make sure users can't crash the
> > > kernel. I mean, there are many ways users can screw it up when
> > > configuring their firewall, they should understand what they are
> > > doing.
> > 
> > Yes, about filtering and NAT, but not about deep implementation
> > details. There fact that they (probably) can't crash the kernel
> > right now is also purely by luck, the NAT system is not designed
> > to have the same packet passed through it multiple times.
> 
> I see, in that case we'll call nf_nat_packet() several times. We
> definitely have to limit number of times that we register the same NAT
> hook to avoid this.

Yep. Easiest solution is to have NAT run standalone.

> > > > Generally I think the current NAT chain implementation is very
> > > > wrong. We need to invoke the core functions once for each direction
> > > > if NAT is used independantly of any chains. So they probably
> > > > shouldn't be tied together.
> > > 
> > > Then, we'll have to register the hooks on some magic priority. The
> > > chains provide the way the user can configure where he wants the NAT
> > > engine to show up.
> > 
> > We do this for conntrack already.
> 
> I see, and that's why we have the 'notrack' target. I think it would
> have been more intuitive to users to indicate what needs to be tracked
> though some rule, instead of the other way around. For example, I
> think that would have helped to improve the integration of the
> synproxy code.

Well, we do this for NAT by requiring mappings to be set up. But
in both cases we still need to invoke the code even if its just
to determine that nothing needs to be done.

> Regarding automagic configurations, we also had to come up with a way
> to configure ct helpers from iptables to avoid the security problems
> that Eric discovered time ago. I think that things that the user gets
> in some automagic fashion tend to result in problems at some point and
> I like that nf_tables aims to be very configurable in general.

I agree. But there's no way to avoid invoking the code for every
packet. The problem we have is a different one, we may invoke it
multiple times per packet and we break connections by deleting
a table. That's something unrelated.

> > Its not about the absolute priority, its simply about relative
> > ordering, so as long as we choose a value that allows to put your
> > own rules either before or after NAT, I don't see the problem.
> >
> > There are also other valid reasons for making the NAT mechanism
> > completely independant of any tables and chains. We support iptables,
> > nftables and ctnetlink to set it up. The mappings are persistent
> > and connections do break if NAT suddenly disappears. That shouldn't
> > happen simply by deleting your table. It should be a more explicit
> > action like unloading a module.
> 
> Not sure, I think it's reasonable to assume that the connection will
> break if you remove your NAT table (in iptables that was only possible
> after removing the module, because it was the only way to destroy a
> table).

I don't think so and its also non-deterministic. It will break if you
delete your table, but only if iptable_nat is not loaded or compiled
in. For ctnetlink its even more strange, We allow to set up mappings
and autoload the NAT families, but we don't invoke the actual NAT
code. From a userspace POV setting up mappings will sometimes work
and sometimes not, depending on something which is pretty much
unrelated, namely whether nftables or iptables NAT is active.

> I think that if we control the NAT hook registration from a module,
> then NAT chains will have to become built-in again, since we need to
> tie the NAT chain and its rules from the hook to perform the NAT
> handling.

No, I think the NAT runtime should be standalone and the NAT tables
should simply be there to set up mappings. Its quite easy, they
only receive packets in state NEW and we remove the chain invocation
from the NAT core.
