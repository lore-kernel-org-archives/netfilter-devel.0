From: Patrick McHardy <kaber@trash.net>
Subject: Re: BUG: Kernel panic at masquerade
Date: Wed, 14 Jan 2015 19:37:51 +0000
Message-ID: <20150114193745.GL5710@acer.localdomain>
References: <54B048D1.6040009@mail.ru>
 <CAOkSjBieyfUV6HMENQcETwcoADT2YMxhgBfv9Kx9kiM8YYAhKA@mail.gmail.com>
 <20150113194111.GB23967@acer.localdomain>
 <20150114172702.GA20830@salvia>
 <20150114173450.GG5710@acer.localdomain>
 <20150114184052.GA21179@salvia>
 <20150114184910.GK5710@acer.localdomain>
 <20150114191847.GA22670@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Linke <linkerpro@mail.ru>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60208 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbbANTiE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:38:04 -0500
Content-Disposition: inline
In-Reply-To: <20150114191847.GA22670@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.01, Pablo Neira Ayuso wrote:
> On Wed, Jan 14, 2015 at 06:49:10PM +0000, Patrick McHardy wrote:
> > On 14.01, Pablo Neira Ayuso wrote:
> > > I think that if we control the NAT hook registration from a module,
> > > then NAT chains will have to become built-in again, since we need to
> > > tie the NAT chain and its rules from the hook to perform the NAT
> > > handling.
> > 
> > No, I think the NAT runtime should be standalone and the NAT tables
> > should simply be there to set up mappings. Its quite easy, they
> > only receive packets in state NEW and we remove the chain invocation
> > from the NAT core.
> 
> OK, so the NAT standalone module performs the NAT for state
> ESTABLISHED packets. The mapping will be still controlled by the
> chain. This will also work for dynamic NAT set via ctnetlink, so users
> will not need to even have NAT chains to run this.

Exactly.

> I think we'll need two hooks though. And we would still have the
> incompatibility that we have with iptable_nat and nf_tables, only the
> first one in place will be considered. We'll also have to
> inconditionally register the input and output NAT hooks.

Yes, it requires an extra hook. Its not really a difference to the
current situation though, for any working setup where you have both
NAT and the ability to set up NAT mappings, you have to callbacks,
even though once of them is within NAT and not the hooks.

Regarding the input/output hooks, as a small optimization we could
only register those pairs of hooks that are actually needed, meaning
once iptable_nat is loaded we register all of them, same for ctnetlink,
for nftables we only register the pairs we have chains for. Once
registered they have to stay registered though, unless we want to
tracking the active mappings, which we most likely don't.

Regarding having both iptable_nat and nftables, I'd propose to not
only check for state NEW but also configured mappings. That way
both can set up mappings, but only if a mapping is not set up
already. That seems to be the best we can do and doesn't seem to
unreasonable.
