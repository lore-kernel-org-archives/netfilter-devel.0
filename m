From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft netdev family bindings
Date: Mon, 8 Jun 2015 13:40:58 +0200
Message-ID: <20150608114058.GA4165@salvia>
References: <20150605133533.GA4024@acer.localdomain>
 <20150605155827.GA3505@salvia>
 <20150605155922.GC4024@acer.localdomain>
 <20150605164742.GA15198@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59047 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbbFHLfr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jun 2015 07:35:47 -0400
Content-Disposition: inline
In-Reply-To: <20150605164742.GA15198@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Fri, Jun 05, 2015 at 06:47:45PM +0200, Patrick McHardy wrote:
> On 05.06, Patrick McHardy wrote:
> > On 05.06, Pablo Neira Ayuso wrote:
> > > > I think this "device" specification is inconsistent with out normal use
> > > > of handles. Usually the table_spec contains the fully qualified handle,
> > > > which in this case needs to include the device.
> > > > 
> > > > Consider:
> > > > 
> > > > table netdev somename {
> > > > 	device eth0;
> > > > 	...
> > > > 
> > > > table netdev somename {
> > > > 	device eth1;
> > > > 	...
> > > 
> > > I see, you mean the same name:
> > > 
> > > # nft add table netdev somename { device eth0 \; }
> > > # nft add table netdev somename { device eth1 \; }
> > > 
> > > I can see this is not working fine now, since the second invocation is
> > > considered an update. But the kernel should bail out with EBUSY IMO.
> > > 
> > > > Without including the device in the table handle, the name alone is amiguitios.
> > > 
> > > The table name should be unique as with other families. Then, probably
> > > the device doesn't belong to the handle.
> > 
> > Yes, I considered every device a single namespace, but thinking about it
> > again, it seems more consistent to treat netdev as any other family and
> > treat devices similar to base chains. In that case though, it would be
> > more consistent to have the device specification not on a table level,
> > but on a chain level. So we could have multiple devices as base chains
> > in a single table, just as we have multiple hooks in other families.
> 
> Ok let's reconsider. For ingress, it definitely seems useful to have
> tables which can bind to multiple devices, f.i. for shared sets.

IIRC people are also using ifb as a way for a common policing and
shaping on aggregated links. So this idea of allowing to bind a table
to multiples devices make sense to me.

Then, the idea would to iterate over the list of netdevs that the user
indicates, eg.

table netdev ingress {
        device { eth0, eth1\; }

        ...
}

and register the same chain hooks for each device in the list.

I can go after this and cook a patch for this. The merge window is
still open so we can modify the semantics of the existing netlink
NFTA_TABLE_DEV attribute in David's net-next tree.

> OTOH when using the netdev family for offloading in the future, it
> will most likely be impossible to really share data or chains except
> when re-expanding it for every device. So the per table binding to
> a device makes sense for that.

Yes, the example above will be more complicated to support as there
will be no shared data, and we'll have to repeat the same operation on
several devices. Even a bit more complicated if they are different
device since as soon as one doesn't support one thing, we'll have to
either bail out or fall back to software (AFAIK depending on what ).

Anyway, I don't think we should constrain software because of what we
expect to find in hardware. It should be the other way around,
hardware will have to adapt to the interface that we provide. We'll
have to extend those interfaces incrementally to support more features
if that becomes limited I would say.

> The point that keeps confusing me is whether we should consider the
> device part of the handle, which would implies a seperate namespace
> per device, or part of the hook, which would imply a per chain
> property, or something completely new, such as a binding. In the
> kernel, we have seperate hooks for every device, and for offloading
> every device will also have its own namespace, probably even supporting
> different features, so I'm tending back to the idea that it should be
> part of the handle and every device should be treated as a seperate
> namespace, as we currently do for every family.

So the handle contains the tuple that uniquely identifies the table.
I'm thinking the device doesn't belong there if we support the
scenario above. I see the device statement as a way to bind the table
to a set of devices.

Thanks.
