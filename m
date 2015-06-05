From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft netdev family bindings
Date: Fri, 5 Jun 2015 17:58:27 +0200
Message-ID: <20150605155827.GA3505@salvia>
References: <20150605133533.GA4024@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35253 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbbFEPxR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 11:53:17 -0400
Content-Disposition: inline
In-Reply-To: <20150605133533.GA4024@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 05, 2015 at 03:35:33PM +0200, Patrick McHardy wrote:
> Hi Pablo,
> 
> looking at the netdev syntax:
> 
> table netdev eth0 {
> 	device eth0;
> 	...
> 
> I think this "device" specification is inconsistent with out normal use
> of handles. Usually the table_spec contains the fully qualified handle,
> which in this case needs to include the device.
> 
> Consider:
> 
> table netdev somename {
> 	device eth0;
> 	...
> 
> table netdev somename {
> 	device eth1;
> 	...

I see, you mean the same name:

# nft add table netdev somename { device eth0 \; }
# nft add table netdev somename { device eth1 \; }

I can see this is not working fine now, since the second invocation is
considered an update. But the kernel should bail out with EBUSY IMO.

> Without including the device in the table handle, the name alone is amiguitios.

The table name should be unique as with other families. Then, probably
the device doesn't belong to the handle.

> I'd propose to use
> 
> table netdev <dev> <name>
> 
> Just as we have the family in the handle.

I've considering to allow to bind a table to an input device from
other families as something optional. From the hardware offload
perspective we would need this too if we want to offload the
forwarding table.

Let me know, thanks!
