From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: BUG: Kernel panic at masquerade
Date: Wed, 14 Jan 2015 19:40:52 +0100
Message-ID: <20150114184052.GA21179@salvia>
References: <54B048D1.6040009@mail.ru>
 <CAOkSjBieyfUV6HMENQcETwcoADT2YMxhgBfv9Kx9kiM8YYAhKA@mail.gmail.com>
 <20150113194111.GB23967@acer.localdomain>
 <20150114172702.GA20830@salvia>
 <20150114173450.GG5710@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Linke <linkerpro@mail.ru>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58525 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbbANSiC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:38:02 -0500
Content-Disposition: inline
In-Reply-To: <20150114173450.GG5710@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 14, 2015 at 05:34:51PM +0000, Patrick McHardy wrote:
> On 14.01, Pablo Neira Ayuso wrote:
> > On Tue, Jan 13, 2015 at 07:41:12PM +0000, Patrick McHardy wrote:
> > > Related to this, what also kind of sucks is that you have to manually
> > > take care of creating the opposite NAT chain (pre/postrouting, in/output)
> > > to have NAT work properly.
> > 
> > We can add some dependency chains that are automagically installed,
> > eg. if you install a NAT prerouting chain, then install the
> > postrouting chain that mirrors. But then, we will be assumming things
> > on the user configuration, and I think that may results in problems
> > when some user comes up later with some strange combination that he
> > cannot achieve because of some automagic configuration we brought up.
> > 
> > > We should make sure that the user can't mess this up.
> > 
> > I'm not so sure, I think we can just make sure users can't crash the
> > kernel. I mean, there are many ways users can screw it up when
> > configuring their firewall, they should understand what they are
> > doing.
> 
> Yes, about filtering and NAT, but not about deep implementation
> details. There fact that they (probably) can't crash the kernel
> right now is also purely by luck, the NAT system is not designed
> to have the same packet passed through it multiple times.

I see, in that case we'll call nf_nat_packet() several times. We
definitely have to limit number of times that we register the same NAT
hook to avoid this.

> > > Generally I think the current NAT chain implementation is very
> > > wrong. We need to invoke the core functions once for each direction
> > > if NAT is used independantly of any chains. So they probably
> > > shouldn't be tied together.
> > 
> > Then, we'll have to register the hooks on some magic priority. The
> > chains provide the way the user can configure where he wants the NAT
> > engine to show up.
> 
> We do this for conntrack already.

I see, and that's why we have the 'notrack' target. I think it would
have been more intuitive to users to indicate what needs to be tracked
though some rule, instead of the other way around. For example, I
think that would have helped to improve the integration of the
synproxy code.

Regarding automagic configurations, we also had to come up with a way
to configure ct helpers from iptables to avoid the security problems
that Eric discovered time ago. I think that things that the user gets
in some automagic fashion tend to result in problems at some point and
I like that nf_tables aims to be very configurable in general.

> Its not about the absolute priority, its simply about relative
> ordering, so as long as we choose a value that allows to put your
> own rules either before or after NAT, I don't see the problem.
>
> There are also other valid reasons for making the NAT mechanism
> completely independant of any tables and chains. We support iptables,
> nftables and ctnetlink to set it up. The mappings are persistent
> and connections do break if NAT suddenly disappears. That shouldn't
> happen simply by deleting your table. It should be a more explicit
> action like unloading a module.

Not sure, I think it's reasonable to assume that the connection will
break if you remove your NAT table (in iptables that was only possible
after removing the module, because it was the only way to destroy a
table).

I think that if we control the NAT hook registration from a module,
then NAT chains will have to become built-in again, since we need to
tie the NAT chain and its rules from the hook to perform the NAT
handling.
