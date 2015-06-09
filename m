From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft netdev family bindings
Date: Tue, 9 Jun 2015 12:57:12 +0200
Message-ID: <20150609105712.GA29356@acer.localdomain>
References: <20150605133533.GA4024@acer.localdomain>
 <20150605155827.GA3505@salvia>
 <20150605155922.GC4024@acer.localdomain>
 <20150605164742.GA15198@acer.localdomain>
 <20150608114058.GA4165@salvia>
 <20150609092318.GA25651@acer.localdomain>
 <20150609105245.GA2811@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38777 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbbFIK5Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2015 06:57:16 -0400
Content-Disposition: inline
In-Reply-To: <20150609105245.GA2811@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.06, Pablo Neira Ayuso wrote:
> On Tue, Jun 09, 2015 at 11:23:19AM +0200, Patrick McHardy wrote:
> > My idea was to have the base chains bind to a device, then we can
> > create shared chains and jump to them from the base chain:
> > 
> > table netdev ingress {
> > 	chain eth0 {
> > 		hook eth0 ingress;
> > 		jump shared_chain;
> > 	}
> > 	chain eth1 {
> > 		hook eth1 ingress;
> > 		jump shared_chain;
> > 	}
> > 	chain shared_chain {
> > 		...
> > 	}
> > }
> > 
> > I think if we treat the table namespace global, than the hook and base
> > chain is the natural place to specify the device since this is where
> > the packets actually enter.
> 
> We can also achieve this sharing with the approach I describe above, I
> don't see any limitation on that.

Its not a limitation, merely something that seems slightly inconsistent.
The base chain definitions basically define the entry points and in this
case we define them in two steps, unlike in the other cases.

It also matches better what we have in the kernel. Its actually the
hooks that are per device and nothing else.

> If the user doesn't want to share any set and chain, he creates a
> separate table so there's a clear separation between namespaces.
> Thus, we don't allow user to make convoluted configurations in
> scenarios where he doesn't need to share anything.

Yes, but that wouldn't be different if we have the device binding in
the hook definition.
