From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft netdev family bindings
Date: Fri, 5 Jun 2015 18:47:45 +0200
Message-ID: <20150605164742.GA15198@acer.localdomain>
References: <20150605133533.GA4024@acer.localdomain>
 <20150605155827.GA3505@salvia>
 <20150605155922.GC4024@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61327 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbbFEQrs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 12:47:48 -0400
Content-Disposition: inline
In-Reply-To: <20150605155922.GC4024@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.06, Patrick McHardy wrote:
> On 05.06, Pablo Neira Ayuso wrote:
> > > I think this "device" specification is inconsistent with out normal use
> > > of handles. Usually the table_spec contains the fully qualified handle,
> > > which in this case needs to include the device.
> > > 
> > > Consider:
> > > 
> > > table netdev somename {
> > > 	device eth0;
> > > 	...
> > > 
> > > table netdev somename {
> > > 	device eth1;
> > > 	...
> > 
> > I see, you mean the same name:
> > 
> > # nft add table netdev somename { device eth0 \; }
> > # nft add table netdev somename { device eth1 \; }
> > 
> > I can see this is not working fine now, since the second invocation is
> > considered an update. But the kernel should bail out with EBUSY IMO.
> > 
> > > Without including the device in the table handle, the name alone is amiguitios.
> > 
> > The table name should be unique as with other families. Then, probably
> > the device doesn't belong to the handle.
> 
> Yes, I considered every device a single namespace, but thinking about it
> again, it seems more consistent to treat netdev as any other family and
> treat devices similar to base chains. In that case though, it would be
> more consistent to have the device specification not on a table level,
> but on a chain level. So we could have multiple devices as base chains
> in a single table, just as we have multiple hooks in other families.

Ok let's reconsider. For ingress, it definitely seems useful to have
tables which can bind to multiple devices, f.i. for shared sets.

OTOH when using the netdev family for offloading in the future, it
will most likely be impossible to really share data or chains except
when re-expanding it for every device. So the per table binding to
a device makes sense for that.

The point that keeps confusing me is whether we should consider the
device part of the handle, which would implies a seperate namespace
per device, or part of the hook, which would imply a per chain
property, or something completely new, such as a binding. In the
kernel, we have seperate hooks for every device, and for offloading
every device will also have its own namespace, probably even supporting
different features, so I'm tending back to the idea that it should be
part of the handle and every device should be treated as a seperat
namespace, as we currently do for every family.
