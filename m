From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/4] netfilter: move generic TEE code from
 xtables to nf_tee_ipv{4,6} modules
Date: Wed, 17 Jun 2015 08:05:09 +0200
Message-ID: <20150617060508.GA29344@acer.localdomain>
References: <1434110378-6284-1-git-send-email-pablo@netfilter.org>
 <1434110378-6284-2-git-send-email-pablo@netfilter.org>
 <20150616163346.GA8671@salvia>
 <20150616163746.GA8748@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62963 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbFQGFM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 02:05:12 -0400
Content-Disposition: inline
In-Reply-To: <20150616163746.GA8748@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.06, Pablo Neira Ayuso wrote:
> On Tue, Jun 16, 2015 at 06:33:46PM +0200, Pablo Neira Ayuso wrote:
> > Hi Patrick,
> > 
> > I'd appreciate your feedback on some small design issue on TEE for
> > nftables.
> > 
> > Basically, the initial patcheset allows this:
> > 
> >         nft add rule ... tee gateway 1.2.3.4
> > 
> > and
> >         nft add rule ... tee oifname eth0 gateway 1.2.3.4
> > 
> > then, internally, this takes a NFTA_TEE_GATEWAY attribute that
> > contains the inet address.
> > 
> > The question is if it's worth passing a register instead to indicate
> > the gateway, ie. NFTA_TEE_GATEWAY_SREG. Thus, we can use maps to set
> > this, eg.
> > 
> >     nft add rule ... tee gateway ip saddr map { 4.3.2.1 : 1.2.3.4 }
> > 
> > Then, we have interfaces, but we actually need to subscribe to netdev
> > events to make sure the pointer to net_device is still valid.
> 
> I mean, the mapping with interface would be a bit more complicated
> given that we need to subscribe to then, because using the name +
> lookup by name per packet seems may result expensive if the number of
> interfaces is high.
> 
> > Do you think it's worth the effort? I've been spinning on this when I
> > remember about nft_queue and I think it would be good to get support
> > done so we can use maps there too.
> > 
> > Let me know, thanks!

I think the current TEE target uses a notifier to keep the ifindex up
to date, but it is optional in any case. I don't see what difference
it makes to support maps for the addresses, we could still have 
either no or just a single interface specified.

The more complicated thing would be combinations of interfaces and
addresses in a map. But you're not thinking about that, right?
